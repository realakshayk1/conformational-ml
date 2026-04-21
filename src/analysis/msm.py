import numpy as np
import matplotlib.pyplot as plt

def run_vamp2(latent_trajectories: list, lag_times: list) -> dict:
    """Scans lag times to compute VAMP-2 scores."""
    from deeptime.decomposition import VAMP
    scores = {}
    for lag in lag_times:
        model = VAMP(lagtime=lag).fit(latent_trajectories).fetch_model()
        scores[lag] = float(model.score(r=2))
    return scores

def run_ck_test(latent_trajectories: list, lag_time: int):
    """Returns a Chapman-Kolmogorov test result object from deeptime."""
    from deeptime.clustering import KMeans
    from deeptime.markov.msm import MaximumLikelihoodMSM
    
    # Check if trajectories is list of arrays or one array
    if isinstance(latent_trajectories, list) and len(latent_trajectories) == 1:
        data = latent_trajectories[0]
    else:
        # Simplification assuming it's a single trajectory for best model
        data = latent_trajectories if not isinstance(latent_trajectories, list) else latent_trajectories[0]

    # 1. Discretize into k=3 states
    km = KMeans(n_clusters=3, max_iter=100, init_strategy='kmeans++')
    dtrajs = km.fit_fetch(data).transform(data)
    
    # 2. Fit Models for varying lags
    models = []
    mlags = 5
    for i in range(1, mlags + 1):
        estimator = MaximumLikelihoodMSM(lagtime=lag_time * i, reversible=True)
        models.append(estimator.fit_fetch(dtrajs))
        
    msm = models[0] # The base model at lag_time
    
    # 3. CK test
    cktest = msm.ck_test(models, 3)
    return cktest

def plot_implied_timescales(lag_times: list, timescales: np.ndarray, save_path: str):
    plt.figure()
    plt.plot(lag_times, timescales, marker='o')
    plt.xlabel('Lag time')
    plt.ylabel('Implied timescales')
    plt.yscale('log')
    plt.title('Implied Timescales')
    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()

def plot_free_energy_landscape(z: np.ndarray, save_path: str):
    """2D free energy surface from latent coordinates using KDE."""
    plt.figure(figsize=(8, 6))
    counts, xedges, yedges = np.histogram2d(z[:, 0], z[:, 1], bins=50, density=True)
    counts = np.maximum(counts, 1e-10)
    free_energy = -np.log(counts)
    free_energy -= free_energy.min()

    X, Y = np.meshgrid(xedges[:-1], yedges[:-1])
    plt.contourf(X, Y, free_energy.T, levels=20, cmap='viridis')
    plt.colorbar(label='Free Energy (kT)')
    plt.xlabel('Latent Dim 1')
    plt.ylabel('Latent Dim 2')
    plt.title('Free Energy Landscape')
    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()
