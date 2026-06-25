# Implementation Plan — Experiment-Anchored Rare-State Benchmark for Protein Ensemble Generators

**Thesis:** The field has established that equilibrium ensemble generators (AlphaFlow / BioEmu)
under-sample rare/cryptic states — the Bowman lab benchmarked it (Jan 2026), MarS-FM addresses it
at foundation-model scale (2026), and an NMR+ML excited-state paper exists (Nov 2025). This
project does not claim a new method. It executes a **sharp, quantitative, experiment-anchored
extension** of that benchmark, validated against gold-standard NMR ground truth (Kay, *Nature*
2011, PDB 2LC9). The value is a rigorous, reproducible result on a target the leading labs care
about.

**Compute:** Colab Pro (~250 units). Inference + structural analysis only. **No MD, no
from-scratch generator training** in the core path.
**North-star artifact:** one figure — *fraction of generated conformers reaching the T4L L99A
excited state (PDB 2LC9) vs the experimental 3% population* — plus one quantitative statement.

---

## Accuracy & improvement guardrails (apply to every phase)

- **Cite the prior art as the foundation you build on**, so the contribution is positioned as a
  precise extension, not a duplicate or a novelty claim:
  - Bowman et al. 2026, *AI-Based Methods for Cryptic Pocket Detection Are Fast and Qualitative…* — the benchmark you extend.
  - MarS-FM 2026 (Kapuśniak et al., Oxford/Valence/Recursion) — the MSM-generative method you do NOT duplicate.
  - Bouvignies & Kay, *Nature* 2011 (PDB **2LC9**) — your quantitative ground truth.
  - NMR+ML excited-state paper (Nov 2025) — your angle is *quantitative population reproduction*, not NMR-guided selection.
- **Claim = competent execution + a precise number.** Report "I reproduced and quantified X
  against ground truth Y; here is the gap" — measured, not asserted.
- **Pre-register the collective variable from literature** before looking at any generator output.
- **Geometry validity gates every structural claim** — never report a pocket/RMSD result on
  conformers that fail `bond_geometry_check`.
- **Always quantify against experimental ground truth** (the 3% population; bound-structure RMSD),
  with ≥3 seeds and mean±sd.
- **Report negative/failure results explicitly** — a clean "the generator misses it" is the result.

---

## Phase 0 — Prerequisites (~2-3 days)

1. **Verify the baseline + CK-test code paths compute correctly** and fold in the pending
   corrections on `claude/goofy-cerf-9aeac5` so all reported numbers are trustworthy before new
   work builds on them.
2. **Collect experimental ground-truth structures** (free, no MD) into `data/t4l/structures/`:
   - **2LC9** — minor *excited* state (NMR, 3% population; F/G helices straighten near cavity). **The target.**
   - **1L83** — L99A ground/closed state. **The reference.**
   - **3DMV / 3DMX** — excited-state-mimic mutants (independent cross-check of the 2LC9 conformation).
   - **4W52** — benzene-bound (cavity-open with ligand; sanity anchor).
3. **Pin the collective variable (CV) from literature** → `configs/evaluation/t4l_excited_state.yaml`:
   - Primary CV: **Cα-RMSD of the F/G-helix region (res ~108-116) to 2LC9 vs to 1L83.** A
     conformer is "excited-state-like" if it is meaningfully closer to 2LC9 (helix straightened)
     than to 1L83, beyond a pre-registered threshold.
   - Secondary CV (all-atom only): **Phe114 χ1 rotamer** (ring rotated into cavity) and **fpocket cavity volume**.

**Reusable repo infra (all phases):** `load_trajectory.py` (alignment),
`featurize.extract_ca_coordinates`, `metrics.py` (`compute_rmsd`, `radius_of_gyration`,
`bond_geometry_check`), `pockets.py` (P2Rank/fpocket pipeline: `export_to_pdb`, `run_p2rank`,
`parse_p2rank_output`, `batch_analyze_state`, `aggregate_frequencies`).

---

## Phase A — Core Benchmark: does the generator reach T4L's 2LC9 excited state? (1-2 wks)

*Primary deliverable. Pure inference + structural analysis. No MD.*

**Goal:** quantify whether BioEmu / AlphaFlow sample the experimentally-known 3% excited state.
**Deliverable:** `outputs/benchmark/t4l_excited_state.png` + `t4l_benchmark.json`.

### A1. CV implementation — `src/analysis/order_param.py` (new, small)
- Function `t4l_excited_cv(coords_or_pdb)` → returns (rmsd_to_2lc9_helix, rmsd_to_1l83_helix,
  optional Phe114 rotamer, optional cavity volume). Align on the stable core (everything except
  the F/G region) before measuring the helix region, reusing alignment from `load_trajectory`.
- Calibrate the threshold using 2LC9, 1L83, 3DMV/3DMX themselves (they must land in the right
  basins) — this validates the CV before any generator output is seen.

### A2. Generate ensembles (Colab) — `notebooks/run_generator_t4l.ipynb`
- **BioEmu first** (open weights, ~1.9 GPU-s/sample, backbone frames → built-in sidechain
  reconstruction; best Colab fit). Generate **1000+ samples** of the 164-residue T4L L99A
  sequence. Save to `outputs/benchmark/generated/t4l/bioemu/`.
- **AlphaFlow second** (all-atom via ESMFold, ~32 GPU-s/sample; a few hundred samples) as an
  independent cross-check and to enable the Phe114 side-chain CV.

### A3. Score + compare — `scripts/run_benchmark.py`
- Compute the CV for every generated conformer.
- **Headline metric:** fraction of samples in the excited-state basin vs the experimental **3%**.
  Expected result: generator gives ≈0% (misses it entirely) or a badly wrong population.
- Secondary: minimum Cα-RMSD of any generated conformer to 2LC9 over the helix region (does the
  generator even *get near* the rare state?).
- **Geometry gate (`metrics.bond_geometry_check`)** on all conformers — report validity rate.
- Sanity: confirm the generator *does* reproduce the 1L83 ground basin, so the miss is specific
  to the rare state, not a broken run.

### A4. Robustness
- ≥3 generation seeds; report excited-state fraction as mean±sd.
- Report both BioEmu and AlphaFlow (cross-method agreement strengthens the claim).

**Done when:** one figure + JSON show, with seeds and geometry validation, the generator's
excited-state recall against the 3% ground truth, while it covers the ground basin.
**Risks:** (i) BioEmu/AlphaFlow Colab setup friction — budget a day; (ii) CV disputes — mitigate
by reporting backbone helix-RMSD *and* cavity volume, and validating the CV on 2LC9/3DMV first.

---

## Phase B — Generalization to a clinical target: KRAS G12D switch-II (1-2 wks)

*Same harness, new target, free experimental ground truth.*

**Goal:** show the same rare-state blind spot on a druggable oncology target.
**Deliverable:** `outputs/benchmark/kras_sii_state.png` + `kras_benchmark.json`.

### B1. Setup — `configs/datasets/kras_g12d.yaml` + `configs/evaluation/kras_sii_state.yaml`
- Ground truth (free PDBs): **SII-pocket-open** = MRTX1133-bound complexes (e.g. 7RPZ / 8DNI);
  **closed** = apo GDP-bound KRAS G12D. Annotate P-loop / Switch I (res ~25-40) / Switch II
  (res ~60-76) / α3, per the PRD KRAS notes.
- CV: **Switch-II displacement / SII-pocket opening** between Switch II and α3 (backbone-based,
  robust across both generators); secondary = fpocket SII-P volume.

### B2. Benchmark (required)
- Reuse the entire Phase A pipeline (`order_param.py` gets a `kras_sii_cv`, `run_benchmark.py`
  takes `--target kras`). Generate with BioEmu/AlphaFlow on the G12D sequence; score against the
  open/closed references. Report recall of the SII-open state + RMSD to the MRTX1133-bound pocket.

### B3. Optional modest rare-state recovery (only if Phase A/B benchmarks land cleanly)
- **No new SOTA model.** A lightweight recovery via **importance reweighting / CV biasing** of
  the existing sample pool, or the repo's small `ConformationalDiffusionModel` retrained on the
  available structures conditioned on a state label (Cα only, with the PRD's bond/angle/clash
  losses) — framed as a *proof-of-concept reweighting*, not a method contribution. Validate any
  recovered conformer's pocket with PULCHRA → P2Rank/fpocket and `bond_geometry_check` first.

**Done when:** KRAS figure shows the SII-open state recall vs the bound-structure ground truth.
Even benchmark-only (no recovery step) demonstrates the blind spot generalizes to a clinical target.

---

## Phase C — Optional MSM/kinetics deepening (do later)

*Not required for A/B. Adds a kinetic dimension if real MD becomes available.*

- Building an MSM needs real T4L MD, which is **not publicly downloadable** (choderalab repo is
  setup-only; Folding@home data needs a direct request; mdCATH/ATLAS T4L is too short for a 3%
  state). The natural path is to request the FAH trajectories from the Chodera/Bowman groups.
- With trajectories in hand, reuse `msm.py`, `pcca.py`, `its.py`, `ck.py`: discretize the latent,
  fit a reversible MSM at an ITS-justified lag, PCCA+ to the excited/ground macrostates, and run
  CK validation — then relate the generator's sampled population to the MSM equilibrium population.

---

## Sequencing, compute, and data

| Phase | Time | Compute (Colab units, rough) | Ships |
|-------|------|------------------------------|-------|
| 0 | 2-3 d | ~0 | verified code + ground-truth structures + pinned CV |
| A | 1-2 wk | ~40-80 (generator inference ×seeds) | **the T4L benchmark figure** |
| B | 1-2 wk | ~40-80 | KRAS clinical generalization (+ optional recovery) |
| C | later | ~0-40 | optional MSM/kinetics deepening (needs MD via data request) |

**Do Phase A first** — it's almost pure inference + analysis, hard to botch, experiment-anchored,
and self-contained. B widens it to a clinical target. C is a later add-on once MD data is sourced.

### Data inventory (all free unless noted)
- **T4L:** PDB 2LC9 (excited), 1L83 (ground), 3DMV/3DMX (mimics), 4W52 (benzene). No MD needed for A.
- **KRAS G12D:** MRTX1133-bound complexes (SII-open) + apo GDP-bound (closed). No MD needed for B.
- **Models:** BioEmu (open weights, Colab-friendly), AlphaFlow (open, heavier, all-atom cross-check).
- **T4L MD trajectories:** NOT publicly downloadable — request from Chodera/Bowman if Phase C is pursued.
