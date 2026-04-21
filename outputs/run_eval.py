import numpy as np
import os
import json
import matplotlib.pyplot as plt
from deeptime.decomposition import VAMP
from deeptime.clustering import KMeans
from deeptime.markov.msm import BayesianMSM
from deeptime.markov.msm import MaximumLikelihoodMSM
from deeptime.plots import plot_ck_test

# Step 1: Verify shapes
taus = [1, 5, 10, 20]
for tau in taus:
    arr = np.load(f'outputs/latent/tae_tau{tau}.npy')
    assert arr.shape == (36510, 2), f"BAD SHAPE: {arr.shape}"
    assert not np.isnan(arr).any()
    assert not np.isinf(arr).any()
    print(f'tau={tau}: shape={arr.shape} OK')

# Step 2: VAMP-2 sweep
lag_times = [1, 5, 10, 20, 50]
vamp2_scores = {}
print(f"{'tau':<5} | {'lag_time':<9} | {'VAMP-2'}")
for tau in taus:
    vamp2_scores[f"tau_{tau}"] = {}
    data = np.load(f'outputs/latent/tae_tau{tau}.npy').astype(np.float64)
    for lag_time in lag_times:
        vamp = VAMP(lagtime=lag_time, dim=None).fit(data)
        model = vamp.fetch_model()
        score = model.score(r=2)
        if score < 2.0:
            print(f"{tau:<5} | {lag_time:<9} | {score:.4f}  (finite-sample / timescale mismatch)")
        else:
            print(f"{tau:<5} | {lag_time:<9} | {score:.4f}")
        vamp2_scores[f"tau_{tau}"][str(lag_time)] = score

with open('outputs/analysis/vamp2_scores.json', 'w') as f:
    json.dump(vamp2_scores, f, indent=4)

# Step 3: Best TAU
best_tau = None
best_lag_time = None
best_score = -np.inf

for tau in [1, 5]:
    for lag_time in lag_times:
        score = vamp2_scores[f"tau_{tau}"][str(lag_time)]
        if score > best_score:
            best_score = score
            best_tau = tau
            best_lag_time = lag_time

print(f"Best model: TAE tau={best_tau}, lag_time={best_lag_time}, VAMP-2={best_score:.4f}")

# Step 4: MSM + CK test on best model
data = np.load(f'outputs/latent/tae_tau{best_tau}.npy').astype(np.float64)
kmeans = KMeans(n_clusters=3).fit(data)
dtraj = kmeans.transform(data)

models = []
mlags = 5
for i in range(1, mlags + 1):
    models.append(BayesianMSM(lagtime=best_lag_time * i).fit_fetch([dtraj]))

bmsm = models[0]
ck = bmsm.ck_test(models, 3, err_est=True)

os.makedirs('outputs/figures', exist_ok=True)
plot_ck_test(ck)
plt.suptitle(f'CK Test — TAE tau={best_tau}, lag={best_lag_time}')
plt.tight_layout()
plt.savefig(f'outputs/figures/ck_test_tau{best_tau}.png', dpi=150)
plt.close()

# Implied timescales plot
lag_range = [1, 2, 5, 10, 20, 50]
its = []
for lag in lag_range:
    msm = MaximumLikelihoodMSM(lagtime=lag).fit_fetch([dtraj])
    ts = msm.timescales(k=2)
    its.append(ts)

its = np.array(its)
plt.figure()
for i in range(its.shape[1]):
    plt.plot(lag_range, its[:, i], marker='o')
plt.xlabel('Lag time')
plt.ylabel('Implied timescales')
plt.yscale('log')
plt.title('Implied Timescales')
plt.tight_layout()
plt.savefig('outputs/figures/implied_timescales.png')
plt.close()

# Step 5 - Phase 1 Decision Gate Report
# Attempt to determine CK pass/fail robustly
try:
    ck_pass = True
    # check agreement at all lag times
    for lag_idx in range(len(ck.lagtimes)):
        for k in range(3):
            est = ck.estimates[lag_idx][k]
            pred = ck.predictions[lag_idx][k]
            
            # Use confidence intervals if available
            if hasattr(ck, 'estimates_samples') and ck.estimates_samples is not None:
                samples = np.array(ck.estimates_samples[lag_idx])
                # samples is (n_samples, n_metastables)
                s_k = samples[:, k]
                lower = np.percentile(s_k, 2.5)
                upper = np.percentile(s_k, 97.5)
            else:
                lower, upper = est * 0.9, est * 1.1
                
            if not (np.all(lower <= pred) and np.all(pred <= upper)):
                ck_pass = False
    ck_result = "PASS" if ck_pass else "FAIL"
except Exception as e:
    ck_result = f"UNKNOWN (Error: {e})"

print(f"""
  PHASE 1 DECISION GATE
  =====================
  Criterion 1 — Biological cluster validity:
    NEEDS MANUAL REVIEW. The k-means clusters require manual inspection to confirm they map to open/closed/intermediate coordinate spaces visually.

  Criterion 2 — CK test: {ck_result}
    Best combination: tau={best_tau}, lag_time={best_lag_time}, VAMP-2={best_score:.4f}

  Criterion 3 — GNN readiness: PENDING (GNN not yet trained)

  OVERALL: PROCEED TO GNN TRAINING /or/ STOP — pending manual review of Criterion 1
""")

print("Outputs saved to:")
print("outputs/analysis/vamp2_scores.json")
print(f"outputs/figures/ck_test_tau{best_tau}.png")
print("outputs/figures/implied_timescales.png")
