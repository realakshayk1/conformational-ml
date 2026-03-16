"""
Stage 6 & 7: Ensemble Generation and Validation for AdK DDPM.
1. Defines conformational states (open, intermediate, closed) via KMeans.
2. Generates ensembles using sample() and sample_cfg().
3. Performs physical validity checks (Bond length, Rg, Diversity).
4. Measures conditioning specificity (RMSD to real frames).
5. Visualizes CFG trade-offs.
"""
import os
import sys
import json
import torch
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from scipy.spatial.distance import cdist

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from src.models.diffusion import ConformationalDiffusionModel


def compute_rmsd(coords1, coords2):
    """Simple RMSD between two (N, 3) coordinate arrays."""
    return np.sqrt(np.mean(np.sum((coords1 - coords2)**2, axis=1)))


def calculate_rg(coords):
    """Radius of gyration for (N, 3) array."""
    centroid = np.mean(coords, axis=0)
    return np.sqrt(np.mean(np.sum((coords - centroid)**2, axis=1)))


def main():
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print(f"Using device: {device}")

    # Paths
    outputs_dir = os.path.join(os.path.dirname(__file__), "..", "outputs")
    checkpoint_path = os.path.join(outputs_dir, "checkpoints", "diffusion_model.pt")
    stats_path = os.path.join(outputs_dir, "checkpoints", "diffusion_norm_stats.npz")
    latent_path = os.path.join(outputs_dir, "latent", "gnn_encoder.npy")
    coords_path = os.path.join(outputs_dir, "coords", "train_coords.npy")
    
    ensembles_dir = os.path.join(outputs_dir, "ensembles")
    figures_dir = os.path.join(outputs_dir, "figures")
    analysis_dir = os.path.join(outputs_dir, "analysis")
    os.makedirs(ensembles_dir, exist_ok=True)
    os.makedirs(figures_dir, exist_ok=True)
    os.makedirs(analysis_dir, exist_ok=True)

    # 1. Define States using KMeans
    print("Defining conformational states via KMeans...")
    z_all = np.load(latent_path)
    kmeans = KMeans(n_clusters=3, random_state=42, n_init=10).fit(z_all)
    centroids = kmeans.cluster_centers_
    labels = kmeans.labels_

    # Order: lowest PC1 (dim 0) is closed, highest is open
    order = np.argsort(centroids[:, 0])
    state_names = ['closed', 'intermediate', 'open']
    ordered_centroids = centroids[order]
    
    # State mapping: closed=order[0], intermediate=order[1], open=order[2]
    # maps current kmeans labels to [0, 1, 2] corresponding to [closed, intermediate, open]
    label_map = {old: new for new, old in enumerate(order)}
    unified_labels = np.array([label_map[l] for l in labels])

    for i, name in enumerate(state_names):
        count = np.sum(unified_labels == i)
        print(f"  State {name}: centroid={ordered_centroids[i]}, frames={count}")

    # 2. Load Model and Stats
    print("Loading model and normalization stats...")
    model = ConformationalDiffusionModel(coord_dim=642, cond_dim=2, T=200, hidden=1024).to(device)
    model.load_state_dict(torch.load(checkpoint_path, map_location=device))
    model.eval()

    stats = np.load(stats_path)
    coord_mean = torch.tensor(stats['mean'], dtype=torch.float32).to(device)
    global_std = torch.tensor(stats['std'], dtype=torch.float32).to(device)

    # 3. Ensemble Generation
    guidance_scales = [1.0, 3.0, 5.0, 7.0]
    n_gen = 100
    
    results_summary = {}

    for s_idx, state in enumerate(state_names):
        z_cond = torch.tensor(ordered_centroids[s_idx], dtype=torch.float32).to(device)
        results_summary[state] = {}
        
        # Unconditional baseline (sample without CFG)
        print(f"Generating ensemble for {state} (Baseline, No CFG)...")
        nocfg_path = os.path.join(ensembles_dir, f"{state}_nocfg.npy")
        samples_norm = model.sample(z_cond, n_samples=n_gen, device=device)
        samples = samples_norm.view(n_gen, -1) * global_std + coord_mean
        samples = samples.view(n_gen, 214, 3).cpu().numpy()
        np.save(nocfg_path, samples)

        # CFG runs
        for gs in guidance_scales:
            print(f"Generating ensemble for {state} (CFG gs={gs})...")
            cfg_path = os.path.join(ensembles_dir, f"{state}_gs{gs}.npy")
            samples_norm = model.sample_cfg(z_cond, n_samples=n_gen, guidance_scale=gs, device=device)
            samples = samples_norm.view(n_gen, -1) * global_std + coord_mean
            samples = samples.view(n_gen, 214, 3).cpu().numpy()
            np.save(cfg_path, samples)
            
            results_summary[state][str(gs)] = {}

    # 4. Physical Validity & Specificity Checks
    print("\nRunning Validation Suite...")
    train_coords = np.load(coords_path)

    for state_idx, state in enumerate(state_names):
        real_state_coords = train_coords[unified_labels == state_idx]
        real_other_coords = train_coords[unified_labels != state_idx]
        
        real_mean_rg = np.mean([calculate_rg(x) for x in real_state_coords])
        real_std_rg = np.std([calculate_rg(x) for x in real_state_coords])

        # We'll check each GS and NoCFG
        test_cases = [("nocfg", 1.0)] + [(f"gs{gs}", gs) for gs in guidance_scales]
        
        for name_suffix, gs_val in test_cases:
            ens_path = os.path.join(ensembles_dir, f"{state}_{name_suffix}.npy")
            ens = np.load(ens_path)
            
            # Check 1: Bond Lengths
            bond_lengths = []
            flagged_count = 0
            for struct in ens:
                bls = np.linalg.norm(np.diff(struct, axis=0), axis=1)
                bond_lengths.append(bls.mean())
                if np.any((bls > 5.0) | (bls < 2.5)):
                    flagged_count += 1
            
            # Check 2: Radius of Gyration
            gen_rgs = [calculate_rg(x) for x in ens]
            
            # Check 3: Diversity (Pairwise RMSD)
            pairwise_rmsds = []
            rng = np.random.default_rng(42)
            for _ in range(20):
                i, j = rng.choice(n_gen, size=2, replace=False)
                pairwise_rmsds.append(compute_rmsd(ens[i], ens[j]))
            
            # Specificity: RMSD to Real
            # Use 50 random real frames for efficiency
            real_s_subset = real_state_coords[rng.choice(len(real_state_coords), 50)]
            real_not_s_subset = real_other_coords[rng.choice(len(real_other_coords), 50)]
            
            rmsds_to_s = []
            rmsds_to_not_s = []
            for g in ens:
                rmsds_to_s.append(np.min([compute_rmsd(g, r) for r in real_s_subset]))
                rmsds_to_not_s.append(np.min([compute_rmsd(g, r) for r in real_not_s_subset]))
            
            # Store
            gs_key = str(gs_val)
            if gs_key not in results_summary[state]:
                 results_summary[state][gs_key] = {}
            
            res = results_summary[state][gs_key]
            res["mean_bond_length"] = float(np.mean(bond_lengths))
            res["pct_flagged_bonds"] = float(flagged_count / n_gen * 100)
            res["mean_rg"] = float(np.mean(gen_rgs))
            res["std_rg"] = float(np.std(gen_rgs))
            res["real_mean_rg"] = float(real_mean_rg)
            res["real_std_rg"] = float(real_std_rg)
            res["mean_pairwise_rmsd"] = float(np.mean(pairwise_rmsds))
            res["mean_rmsd_to_target_state"] = float(np.mean(rmsds_to_s))
            res["mean_rmsd_to_other_states"] = float(np.mean(rmsds_to_not_s))
            res["conditioning_check"] = "PASS" if res["mean_rmsd_to_target_state"] < res["mean_rmsd_to_other_states"] else "FAIL"

    # 5. Guidance Scale Comparison Plot (Open State)
    print("Generating Trade-off Plot...")
    gs_list = guidance_scales
    open_res = results_summary["open"]
    diversity = [open_res[str(gs)]["mean_pairwise_rmsd"] for gs in gs_list]
    fidelity = [open_res[str(gs)]["mean_rmsd_to_target_state"] for gs in gs_list]

    fig, ax1 = plt.subplots(figsize=(8, 5))
    color = 'tab:blue'
    ax1.set_xlabel('Guidance Scale')
    ax1.set_ylabel('Pairwise RMSD (Diversity) [Å]', color=color)
    ax1.plot(gs_list, diversity, 'o-', color=color, label='Diversity')
    ax1.tick_params(axis='y', labelcolor=color)

    ax2 = ax1.twinx()
    color = 'tab:red'
    ax2.set_ylabel('RMSD to Real Open Frames (Fidelity) [Å]', color=color)
    ax2.plot(gs_list, fidelity, 's-', color=color, label='Fidelity')
    ax2.tick_params(axis='y', labelcolor=color)

    plt.title('CFG Trade-off: Open State Ensemble')
    fig.tight_layout()
    plt.savefig(os.path.join(figures_dir, "cfg_tradeoff_open.png"), dpi=300)
    plt.close()

    # 6. Save Summary
    with open(os.path.join(analysis_dir, "ensemble_validation.json"), "w") as f:
        json.dump(results_summary, f, indent=2)

    # 7. Final Table
    print("\n" + "="*80)
    print(f"{'State':<15} | {'GS':<5} | {'Bond':<6} | {'Rg (Gen/Real)':<15} | {'Diversity':<10} | {'Conditioning'}")
    print("-" * 80)
    for state in state_names:
        for gs in [1.0, 3.0, 7.0]:
            r = results_summary[state][str(gs)]
            rg_str = f"{r['mean_rg']:.1f}/{r['real_mean_rg']:.1f}"
            print(f"{state:<15} | {gs:<5} | {r['mean_bond_length']:.2f} | {rg_str:<15} | {r['mean_pairwise_rmsd']:.2f} | {r['conditioning_check']}")
    print("="*80)


if __name__ == "__main__":
    main()
