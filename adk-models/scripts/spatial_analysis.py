import os
import pandas as pd
import numpy as np
import json

def spatial_analysis():
    analysis_root = 'outputs/analysis/p2rank_raw'
    states = ['closed', 'intermediate', 'open']
    results_json_path = 'outputs/analysis/pocket_analysis.json'
    
    if not os.path.exists(results_json_path):
        print(f"Error: {results_json_path} not found.")
        return

    with open(results_json_path, 'r') as f:
        analysis_data = json.load(f)

    geometry_results = {}
    all_centers = {}

    print("Extracting pocket centers and scores...")
    for state in states:
        state_dir = os.path.join(analysis_root, state)
        if not os.path.exists(state_dir):
            print(f"Warning: {state_dir} not found.")
            continue
            
        centers = []
        scores = []
        
        # Generated structures: 100 per state
        for i in range(100):
            csv_path = os.path.join(state_dir, f"structure_{i:03d}.rebuilt.pdb_predictions.csv")
            if os.path.exists(csv_path):
                try:
                    df = pd.read_csv(csv_path)
                    # Strip whitespace from columns
                    df.columns = [c.strip() for c in df.columns]
                    
                    if 'probability' in df.columns:
                        # Filter for prob > 0.5
                        df_filtered = df[df['probability'] > 0.5]
                        
                        if not df_filtered.empty:
                            # Get top pocket (first row)
                            top = df_filtered.iloc[0]
                            cx = float(top['center_x'])
                            cy = float(top['center_y'])
                            cz = float(top['center_z'])
                            score = float(top['score'])
                            
                            centers.append([cx, cy, cz])
                            scores.append(score)
                except Exception as e:
                    print(f"Error parsing {csv_path}: {e}")

        if centers:
            centers_np = np.array(centers)
            mean_center = np.mean(centers_np, axis=0).tolist()
            # Std deviation of the centers (spatial spread)
            std_center = float(np.mean(np.std(centers_np, axis=0)))
            mean_score = float(np.mean(scores))
            
            geometry_results[state] = {
                "mean_center": mean_center,
                "std_center": std_center,
                "mean_score": mean_score
            }
            all_centers[state] = mean_center
        else:
            print(f"No valid pockets (prob > 0.5) found for state: {state}")

    # Compute displacements
    displacements = {}
    pairs = [('closed', 'open'), ('closed', 'intermediate'), ('intermediate', 'open')]
    for s1, s2 in pairs:
        if s1 in all_centers and s2 in all_centers:
            d = np.linalg.norm(np.array(all_centers[s1]) - np.array(all_centers[s2]))
            displacements[f"{s1}_vs_{s2}"] = float(d)

    # Update JSON
    analysis_data['pocket_geometry'] = geometry_results
    analysis_data['pocket_geometry']['inter_state_displacement_angstroms'] = displacements

    with open(results_json_path, 'w') as f:
        json.dump(analysis_data, f, indent=2)

    # Print Report
    print("\n--- Spatial Pocket Analysis ---")
    print(f"{'State':<15} | {'Mean Center (x, y, z)':<30} | {'Spread (Std)':<12} | {'Mean Score':<10}")
    print("-" * 80)
    for state in states:
        if state in geometry_results:
            g = geometry_results[state]
            c = g['mean_center']
            print(f"{state:<15} | ({c[0]:.1f}, {c[1]:.1f}, {c[2]:.1f}) | {g['std_center']:.2f} \u00c5 | {g['mean_score']:.2f}")

    print("\n--- Inter-State Pocket Displacement ---")
    for k, v in displacements.items():
        print(f"{k:<30}: {v:.2f} \u00c5")

    # Interpretation
    if displacements:
        max_d = max(displacements.values())
        if max_d > 5:
            print(f"\nInterpretation: Significant pocket shift detected (max displacement {max_d:.1f}\u00c5 > 5\u00c5).")
            print("The dominant pocket location changes across conformations, indicating state-specific pocket geometry.")
        else:
            print(f"\nInterpretation: No major pocket shift detected (max displacement {max_d:.1f}\u00c5 < 5\u00c5).")
            print("The pocket remains spatially conserved across conformations.")
    else:
        print("\nInterpretation: Could not compute displacements due to missing pocket detections.")

if __name__ == "__main__":
    spatial_analysis()
