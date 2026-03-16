# RESULTS SUMMARY

## Stage 8: Cryptic Pocket Analysis

**Method:** PULCHRA full-atom reconstruction from Cα ensembles,
P2Rank pocket detection on 300 generated + 60 real structures.

**Pocket frequencies (guidance_scale=3.0):**
| State        | Generated | Real  |
|--------------|-----------|-------|
| Closed       | 0.91      | 0.80  |
| Intermediate | 0.74      | 0.60  |
| Open         | 0.90      | 0.95  |

Generated frequencies track real MD frame frequencies well,
confirming the diffusion model reproduces pocket accessibility.

**Spatial analysis:**
| State        | Mean pocket center    | Mean P2Rank score |
|--------------|-----------------------|-------------------|
| Closed       | (-1.4, 1.5, 2.4)Å    | 16.63             |
| Intermediate | (-1.9, 3.2, 2.7)Å    | 13.93             |
| Open         | (0.1, 3.1, 3.0)Å     | 14.69             |

Inter-state displacement: 2.29Å (closed↔open). Pocket location
shifts modestly with global domain motion — binding site is
constitutive but geometry varies across states.

Intermediate state shows lowest druggability score (13.93),
consistent with partial pocket occlusion during domain transition.

**No cryptic pockets identified** by strict criterion
(>20% one state, <5% others) — all three states show broadly
accessible nucleotide binding sites, consistent with AdK literature.

**Limitation:** PULCHRA reconstructs backbone + Cβ only.
Full side-chain reconstruction (SCWRL4) would improve pocket
scoring accuracy for future work.
