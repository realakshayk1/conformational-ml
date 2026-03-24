import numpy as np
from deeptime.markov.msm import BayesianMSM
from deeptime.clustering import KMeans

data = np.random.randn(1000, 2)
km = KMeans(n_clusters=3)
dtrajs = km.fit_fetch(data).transform(data)

models = []
for i in range(1, 6):
    models.append(BayesianMSM(lagtime=2 * i).fit_fetch(dtrajs))

ck = models[0].ck_test(models, 3, err_est=True)

print("Vars:", vars(ck).keys())
print("Estimates shape:", len(ck.estimates), len(ck.estimates[0]))

if hasattr(ck, 'confidence_interval_estimates'):
    print("Has confidence_interval_estimates")
if hasattr(ck, 'confidence_interval_predictions'):
    print("Has confidence_interval_predictions")

import inspect
print([m[0] for m in inspect.getmembers(ck)])
