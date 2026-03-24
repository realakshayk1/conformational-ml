import numpy as np
import inspect
from deeptime.markov.msm import MaximumLikelihoodMSM
from deeptime.clustering import KMeans

data = np.random.randn(1000, 2)
km = KMeans(n_clusters=3)
dtrajs = km.fit_fetch(data).transform(data)
e = MaximumLikelihoodMSM(lagtime=2)
m = e.fit_fetch([dtrajs])

print(inspect.signature(m.ck_test))
