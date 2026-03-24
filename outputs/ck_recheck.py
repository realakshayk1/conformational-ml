import numpy as np
import matplotlib.pyplot as plt
from deeptime.clustering import KMeans
from deeptime.markov.msm import BayesianMSM
from deeptime.plots import plot_ck_test
import os

print("Starting CK recheck for tau=1 at lag=5...")

# Load latent trajectory
data = np.load('outputs/latent/tae_tau1.npy').astype(np.float64)
print(f"Loaded data shape: {data.shape}")

# Discretize into k=3 states
kmeans = KMeans(n_clusters=3).fit(data)
dtraj = kmeans.transform(data)
print("Discretization complete.")

# Rerun CK test at lag=5
print("Fitting BayesianMSM at lag=5...")
model_base = BayesianMSM(lagtime=5).fit_fetch([dtraj])

print("Building models list for CK test (mlags=5)...")
models = []
for i in range(1, 6):
    models.append(BayesianMSM(lagtime=5 * i).fit_fetch([dtraj]))

# Now call ck_test on the base model
ck = model_base.ck_test(models, 3, err_est=True)


print("CK test complete.")

# Plot and save
os.makedirs('outputs/figures', exist_ok=True)
fig = plot_ck_test(ck)
plt.suptitle('CK Test — TAE tau=1, lag=5 (Markov lag)')
plt.tight_layout()
plt.savefig('outputs/figures/ck_test_tau1_lag5.png', dpi=150)
plt.close()

print("Saved ck_test_tau1_lag5.png")
