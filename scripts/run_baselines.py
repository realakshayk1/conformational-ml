import os
import sys
import json
import numpy as np

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'src')))

from analysis.msm import run_vamp2, run_ck_test, plot_free_energy_landscape


def compute_vac_baseline(baseline_dir, lag_times, dim=2):
    """VAMP-2 score linear VAC baselines at dim=2 to match TAE latent dimensionality.

    Scores both PCA50→top-2 (linear VAC proper) and PCA2 (direct 2D projection).
    """
    from deeptime.decomposition import VAMP

    results = {}

    for label, fname in [("linear_vac_pca50_dim2", "pca50_train.npy"),
                          ("linear_vac_pca2",       "pca2_train.npy")]:
        path = os.path.join(baseline_dir, fname)
        if not os.path.exists(path):
            print(f"  Skipping {label}: {path} not found.")
            continue
        traj = np.load(path)
        scores = {}
        for lag in lag_times:
            model = VAMP(lagtime=lag, dim=dim).fit([traj]).fetch_model()
            scores[lag] = float(model.score(r=2))
        results[label] = scores
        best = max(scores.values())
        print(f"  {label}: best VAMP-2 = {best:.4f}")

    return results

def check_ck_test_pass(cktest, lag_time):
    """Check CK test pass/fail using diagonal self-transition probabilities with 95% CI.

    The CK test compares, for each macrostate k, the directly-estimated self-transition
    probability against the value propagated from the base model. Those are the DIAGONAL
    entries [k, k] of each transition matrix — indexing a whole row [k] (as the previous
    version did) compares an array against scalar bounds and is incorrect.
    """
    if cktest is None:
        return "FAIL (No MSM constructed)"

    try:
        outside_bounds = 0
        total = 0

        for lag_idx, lag in enumerate(cktest.lagtimes):
            if lag == 0:
                continue
            for k in range(cktest.n_components):
                pred = float(np.real(cktest.predictions[lag_idx][k, k]))
                samples = [float(s[k, k]) for s in cktest.estimates_samples[lag_idx]]
                lower = np.percentile(samples, 2.5)
                upper = np.percentile(samples, 97.5)
                total += 1
                if not (lower <= pred <= upper):
                    outside_bounds += 1

        if outside_bounds == 0:
            return f"PASS (all {total} diagonal entries within 95% CI)"
        else:
            return f"FAIL ({outside_bounds}/{total} diagonal entries outside 95% CI)"

    except Exception as e:
        return f"FAIL (Error: {e})"

def main():
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    latent_dir = os.path.join(base_dir, 'outputs', 'latent')
    baseline_dir = os.path.join(base_dir, 'outputs', 'baselines')
    analysis_dir = os.path.join(base_dir, 'outputs', 'analysis')
    figures_dir = os.path.join(base_dir, 'outputs', 'figures')
    
    os.makedirs(analysis_dir, exist_ok=True)
    os.makedirs(figures_dir, exist_ok=True)
    
    taus = [1, 5, 10, 20]
    lag_times = [1, 5, 10, 20, 50]
    
    all_scores = {}
    best_score_candidate = -np.inf
    best_tau = None
    best_lag = None
    
    # 0. Linear VAC baselines (dim=2, matching TAE latent dimensionality)
    print("Computing linear VAC baseline VAMP-2 scores (dim=2)...")
    vac_scores = compute_vac_baseline(baseline_dir, lag_times)
    all_scores.update(vac_scores)

    # 1. VAMP-2 Scoring
    print("Running VAMP-2 scoring...")
    for tau in taus:
        file_path = os.path.join(latent_dir, f'tae_tau{tau}.npy')
        if not os.path.exists(file_path):
            raise FileNotFoundError(
                f"Latent file not found: {file_path}. Run train_baselines.py first to "
                f"produce real latents. (Never substitute random data — a VAMP-2 of ~1.0 "
                f"on noise is meaningless and has previously been mistaken for a baseline.)"
            )
        traj = np.load(file_path)
        # run_vamp2 expects a list of trajectories
        scores = run_vamp2([traj], lag_times)
        all_scores[f"tau_{tau}"] = scores
        
        # Determine best among tau=1 and tau=5 only
        if tau in [1, 5]:
            for lag, score in scores.items():
                if score > best_score_candidate:
                    best_score_candidate = score
                    best_tau = tau
                    best_lag = lag
                    
    # Score GNN encoder latent if available
    gnn_path = os.path.join(latent_dir, 'gnn_encoder.npy')
    if os.path.exists(gnn_path):
        gnn_traj = np.load(gnn_path)
        gnn_scores = run_vamp2([gnn_traj], lag_times)
        all_scores["gnn_encoder"] = gnn_scores
        print(f"  GNN encoder best VAMP-2: {max(gnn_scores.values()):.4f}")

    with open(os.path.join(analysis_dir, 'vamp2_scores.json'), 'w') as f:
        json.dump(all_scores, f, indent=4)

    print(f"\nBest VAMP-2 Score (candidates tau=1,5): {best_score_candidate:.4f} (tau={best_tau}, lag={best_lag})")
        
    # 2. CK Test
    print("\nRunning Chapman-Kolmogorov test...")
    best_traj_path = os.path.join(latent_dir, f'tae_tau{best_tau}.npy')
    best_traj = np.load(best_traj_path)
    cktest = run_ck_test([best_traj], best_lag)
    
    ck_result_str = check_ck_test_pass(cktest, best_lag)
    print(f"CK Test Result: {ck_result_str}")
    
    # Plotting CK test
    if cktest is not None:
        try:
            import matplotlib.pyplot as plt
            from deeptime.plots import plot_ck_test
            fig = plot_ck_test(cktest)
            fig.savefig(os.path.join(figures_dir, 'ck_test.png'))
            plt.close(fig)
        except Exception:
            pass
            
            
    # 3. Free Energy Landscapes
    print("\nGenerating Free Energy Landscapes...")
    # Best TAE
    plot_free_energy_landscape(best_traj, os.path.join(figures_dir, 'landscape_tae.png'))
    
    # PCA Baseline
    pca_path = os.path.join(baseline_dir, 'pca2_train.npy')
    if not os.path.exists(pca_path):
        raise FileNotFoundError(
            f"PCA baseline not found: {pca_path}. Run train_baselines.py to compute the "
            f"real PCA projection. (Do not substitute random data for the baseline.)"
        )
    pca_traj = np.load(pca_path)
    plot_free_energy_landscape(pca_traj, os.path.join(figures_dir, 'landscape_pca.png'))
    
    # 4. Summary Table
    print("\n" + "="*60)
    print(f"{'Method':<15} | {'VAMP-2 Score':<15} | {'CK Test Pass':<30} | {'Best Lag Time'}")
    print("-" * 60)
    
    ck_pass = ck_result_str.startswith("PASS")
    ck_display = ck_result_str.split(" (")[0] if ck_result_str else "N/A"
    
    print(f"{f'TAE (tau={best_tau})':<15} | {best_score_candidate:<15.4f} | {ck_result_str:<30} | {best_lag}")
    print("="*60)

if __name__ == "__main__":
    main()
