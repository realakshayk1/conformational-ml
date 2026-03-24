import numpy as np
from deeptime.markov.msm import MaximumLikelihoodMSM
from deeptime.clustering import KMeans

data = np.random.randn(1000, 2)
# Discretize
km = KMeans(n_clusters=3)
dtrajs = km.fit_fetch(data).transform(data)

# Fit MSM
msm_estimator = MaximumLikelihoodMSM(lagtime=2)
msm = msm_estimator.fit_fetch([dtrajs])

print("MSM methods:")
for m in dir(msm):
    if 'ck' in m.lower():
        print(m)

ck = msm.ck_test(msm_estimator, mlags=5)
print("CK test type:", type(ck))
print("CK test dir:", dir(ck))
