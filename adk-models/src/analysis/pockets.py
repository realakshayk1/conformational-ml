import os
import subprocess
import numpy as np
import pandas as pd
import json
import glob

def wsl_path(win_path):
    r"""
    Converts Windows paths to WSL-compatible paths.
    C:\Users\aksha\... → /mnt/c/Users/aksha/...
    """
    path = win_path.replace('\\', '/')
    if ':' in path:
        drive, rest = path.split(':', 1)
        return f"/mnt/{drive.lower()}{rest}"
    return path

def export_to_pdb(coords, output_path, residue_names=None):
    """
    Exports Cα coordinate array (N, 3) to a minimal PDB file.
    """
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    n_atoms = coords.shape[0]
    if residue_names is None:
        residue_names = ['ALA'] * n_atoms
    
    lines = []
    # CRYST1    1.000    1.000    1.000  90.00  90.00  90.00 P 1           1
    lines.append("CRYST1    1.000    1.000    1.000  90.00  90.00  90.00 P 1           1")
    # PDB format for CA only
    # ATOM      1  CA  ALA A   1      X.XXX   Y.YYY   Z.ZZZ  1.00  0.00           C
    for i in range(n_atoms):
        res_name = residue_names[i]
        x, y, z = coords[i]
        line = f"ATOM  {i+1:>5}  CA  {res_name:>3} A{i+1:>4}    {x:>8.3f}{y:>8.3f}{z:>8.3f}  1.00  0.00           C"
        lines.append(line)
    lines.append("END")
    
    with open(output_path, 'w') as f:
        f.write('\n'.join(lines) + '\n')

def run_p2rank(pdb_path, output_dir):
    """
    Runs P2Rank via WSL on a given PDB file.
    """
    os.makedirs(output_dir, exist_ok=True)
    wsl_pdb = wsl_path(os.path.abspath(pdb_path))
    wsl_out = wsl_path(os.path.abspath(output_dir))
    
    # cmd: ~/p2rank/prank predict -f <pdb> -o <out>
    cmd = [
        'wsl', 'bash', '-c',
        f"~/p2rank/prank predict -f {wsl_pdb} -o {wsl_out}"
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error running P2Rank on {pdb_path}:")
        print(result.stderr)
        return False
    return True

def parse_p2rank_output(output_dir, pdb_filename):
    """
    Parses P2Rank CSV output for a specific PDB.
    P2Rank creates: <pdb_filename>_predictions.csv
    """
    #pdb_base = os.path.basename(pdb_filename)
    csv_path = os.path.join(output_dir, f"{pdb_filename}_predictions.csv")
    
    if not os.path.exists(csv_path):
        return {"n_pockets": 0, "pockets": []}
    
    df = pd.read_csv(csv_path)
    df.columns = [c.strip() for c in df.columns]
    
    pockets = []
    for _, row in df.iterrows():
        pockets.append({
            "score": float(row['score']),
            "probability": float(row['probability']),
            "center": [float(row['center_x']), float(row['center_y']), float(row['center_z'])]
        })
    
    return {
        "n_pockets": len(pockets),
        "pockets": pockets
    }

def batch_analyze_state(state_name, ensemble_path, pdb_root, analysis_root, n_structures=100):
    """
    Exports and analyzes an entire ensemble state.
    """
    coords = np.load(ensemble_path) # (100, 214, 3)
    results = []
    
    pdb_dir = os.path.join(pdb_root, state_name)
    out_dir = os.path.join(analysis_root, "p2rank_raw", state_name)
    
    print(f"Processing state: {state_name}")
    for i in range(n_structures):
        pdb_path = os.path.join(pdb_dir, f"structure_{i:03d}.rebuilt.pdb")
        # export_to_pdb(coords[i], pdb_path) # Don't export, use rebuilt ones
        
        # P2Rank output structure: out_dir/structure_000.rebuilt.pdb_predictions.csv
        # We need to pass the state-specific out_dir
        run_p2rank(pdb_path, out_dir)
        
        # Parse
        p_res = parse_p2rank_output(out_dir, f"structure_{i:03d}.rebuilt.pdb")
        results.append({
            "id": i,
            "n_pockets": p_res['n_pockets'],
            "top_pocket_prob": p_res['pockets'][0]['probability'] if p_res['n_pockets'] > 0 else 0.0,
            "top_pocket_score": p_res['pockets'][0]['score'] if p_res['n_pockets'] > 0 else 0.0
        })
        
        if (i+1) % 20 == 0:
            print(f"  Completed {i+1}/{n_structures}")
            
    return results

def aggregate_frequencies(all_results):
    """
    Computes pocket frequencies and identifies cryptic pockets.
    Criterion:
    - Present if top_pocket_prob > 0.5
    - High confidence if top_pocket_prob > 0.7
    - Cryptic if freq_S > 0.20 and freq_others < 0.05
    """
    summary = {"generated": {}, "real": {}}
    states = ["closed", "intermediate", "open"]
    
    # Process Generated
    gen_freqs = {}
    for state in states:
        results = all_results["generated"][state]
        n = len(results)
        pocket_freq = sum(1 for r in results if r['top_pocket_prob'] > 0.5) / n
        high_conf_freq = sum(1 for r in results if r['top_pocket_prob'] > 0.7) / n
        
        gen_freqs[state] = pocket_freq
        summary["generated"][state] = {
            "pocket_freq": pocket_freq,
            "high_conf_freq": high_conf_freq,
            "cryptic": False # To be updated
        }

    # Identify cryptic
    state_specific_findings = []
    for state in states:
        freq_s = gen_freqs[state]
        others = [gen_freqs[s] for s in states if s != state]
        freq_others = sum(others) / len(others) if others else 0
        
        if freq_s > 0.20 and freq_others < 0.05:
            summary["generated"][state]["cryptic"] = True
            summary["generated"][state]["status"] = "STATE-SPECIFIC CRYPTIC"
            state_specific_findings.append(state)
        elif freq_s > 0.20:
            summary["generated"][state]["status"] = "STATE-ENRICHED"
    
    # Process Real (assuming 20 structures per state)
    for state in states:
        results = all_results["real"].get(state, [])
        if not results:
            summary["real"][state] = {"pocket_freq": 0.0}
            continue
        n = len(results)
        pocket_freq = sum(1 for r in results if r['top_pocket_prob'] > 0.5) / n
        summary["real"][state] = {"pocket_freq": pocket_freq}
        
    summary["cryptic_pockets_found"] = len(state_specific_findings) > 0
    summary["state_specific_findings"] = state_specific_findings
    
    return summary

def main():
    import numpy as np
    
    # Configuration
    states = ["closed", "intermediate", "open"]
    n_gen = 100
    n_real = 20
    
    pdb_root = "outputs/pdb"
    analysis_root = "outputs/analysis"
    ensemble_dir = "outputs/ensembles"
    
    os.makedirs(os.path.join(analysis_root, "p2rank_raw"), exist_ok=True)
    
    all_results = {"generated": {}, "real": {}}
    
    # 1. Analyze Generated Ensembles
    print("--- Analyzing Generated Ensembles ---")
    for state in states:
        ensemble_path = os.path.join(ensemble_dir, f"{state}_gs3.0.npy")
        if os.path.exists(ensemble_path):
            all_results["generated"][state] = batch_analyze_state(
                state, ensemble_path, pdb_root, analysis_root, n_structures=n_gen
            )
        else:
            print(f"Warning: {ensemble_path} not found.")

    # 2. Analyze Real Trajectory Frames
    print("\n--- Analyzing Real Trajectory Frames ---")
    # Load train_coords and labels
    train_coords_path = "outputs/coords/train_coords.npy"
    labels_path = "outputs/analysis/ensemble_validation.json" # Re-using previously saved labels
    
    if os.path.exists(train_coords_path) and os.path.exists(labels_path):
        train_coords = np.load(train_coords_path) # (N, 214, 3)
        with open(labels_path, 'r') as f:
            val_data = json.load(f)
            # Assuming labels were saved in a way we can recover
            # For now, if we don't have explicit labels per frame, we'll try to find them
            # In Stage 7, k-means was run. We expect labels to be available.
            # If not, we might need to re-run clustering or use the indices.
            # Let's check training_data_stats in val_data
            labels = np.array(val_data.get('training_labels', []))
            
        if len(labels) == 0:
            print("Warning: No training labels found in ensemble_validation.json. Skipping real frames comparison.")
        else:
            for state_idx, state in enumerate(states):
                # state_idx: 0=closed, 1=intermediate, 2=open (based on kmeans order)
                indices = np.where(labels == state_idx)[0]
                if len(indices) < n_real:
                    n_real_state = len(indices)
                else:
                    n_real_state = n_real
                    # Randomly sample
                    np.random.seed(42)
                    indices = np.random.choice(indices, n_real_state, replace=False)
                
                print(f"Sampling {n_real_state} real frames for {state}")
                real_state_results = []
                pdb_dir = os.path.join(pdb_root, f"real_{state}")
                out_dir = os.path.join(analysis_root, "p2rank_raw", f"real_{state}")
                
                for i, idx in enumerate(indices):
                    pdb_path = os.path.join(pdb_dir, f"structure_{i:03d}.rebuilt.pdb")
                    # export_to_pdb(train_coords[idx], pdb_path)
                    run_p2rank(pdb_path, out_dir)
                    p_res = parse_p2rank_output(out_dir, f"structure_{i:03d}.rebuilt.pdb")
                    real_state_results.append({
                        "id": i,
                        "n_pockets": p_res['n_pockets'],
                        "top_pocket_prob": p_res['pockets'][0]['probability'] if p_res['n_pockets'] > 0 else 0.0
                    })
                all_results["real"][state] = real_state_results
    else:
        print("Warning: train_coords.npy or labels not found. Skipping real frames.")

    # 3. Save Raw Results
    raw_results_path = os.path.join(analysis_root, "p2rank_raw_results.json")
    with open(raw_results_path, 'w') as f:
        json.dump(all_results, f, indent=2)
    
    # 4. Aggregate and Save Summary
    summary = aggregate_frequencies(all_results)
    summary_path = os.path.join(analysis_root, "pocket_analysis.json")
    with open(summary_path, 'w') as f:
        json.dump(summary, f, indent=2)
    
    print("\n--- Final Summary ---")
    print(json.dumps(summary, indent=2))
    print(f"\nResults saved to {summary_path}")

if __name__ == "__main__":
    main()
