# Phase A2 — Generate T4L L99A ensembles on Colab (BioEmu primary, AlphaFlow cross-check)

Run on **Colab Pro (A100)**. Output layout is what `scripts/run_benchmark.py` expects:
`outputs/benchmark/generated/t4l/<model>/<seed>/samples.pdb` (multi-model PDB per seed).

The L99A construct sequence (Ala at position 99; 162 resolved residues from PDB 1L83):

```
MNIFEMLRIDEGLRLKIYKDTEGYYTIGIGHLLTKSPSLNAAKSELDKAIGRNTNGVITKDEAEKLFNQDVDAAVRGILRNAKLKPVYDSLDAVRRAAAINMVFQMGETGVAGFTNSLRMLQQKRWDEAAVNLAKSRWYNQTPNRAKRVITTFRTGTWDAYK
```

> The CV scores only shared residues up to ~118, so the missing C-terminal 163–164 do
> not affect the benchmark (the scorer intersects residue ids).

---

## Cell 1 — install BioEmu
```bash
pip install bioemu
```
> BioEmu's exact CLI can change between versions — check https://github.com/microsoft/bioemu .
> As of writing: `python -m bioemu.sample --sequence <SEQ> --num_samples N --output_dir DIR`,
> which writes `samples.xtc` + `topology.pdb` into `DIR`.

## Cell 2 — generate (3 seeds × ~1000 samples)
```python
import os, subprocess
SEQ = ("MNIFEMLRIDEGLRLKIYKDTEGYYTIGIGHLLTKSPSLNAAKSELDKAIGRNTNGVITKDEAEKLFNQ"
       "DVDAAVRGILRNAKLKPVYDSLDAVRRAAAINMVFQMGETGVAGFTNSLRMLQQKRWDEAAVNLAKSRW"
       "YNQTPNRAKRVITTFRTGTWDAYK")
for seed in range(3):
    out = f"outputs/benchmark/generated/t4l/bioemu/seed{seed}"
    os.makedirs(out, exist_ok=True)
    subprocess.run([
        "python", "-m", "bioemu.sample",
        "--sequence", SEQ, "--num_samples", "1000",
        "--seed", str(seed), "--output_dir", out,
    ], check=True)
```

## Cell 3 — convert each seed's samples to one multi-model PDB
```python
import MDAnalysis as mda, glob, os
for seed_dir in sorted(glob.glob("outputs/benchmark/generated/t4l/bioemu/seed*")):
    xtc = os.path.join(seed_dir, "samples.xtc")
    top = os.path.join(seed_dir, "topology.pdb")
    u = mda.Universe(top, xtc)
    ca = u.select_atoms("protein")               # write all atoms; scorer uses CA
    with mda.Writer(os.path.join(seed_dir, "samples.pdb"), multiframe=True,
                    n_atoms=ca.n_atoms) as w:
        for _ in u.trajectory:
            w.write(ca)
    print(seed_dir, "->", u.trajectory.n_frames, "models")
```

## Cell 4 — (optional) AlphaFlow cross-check
Clone https://github.com/bjing2016/alphaflow , run inference on the same sequence,
write per-seed multi-model PDBs into `outputs/benchmark/generated/t4l/alphaflow/seed*/samples.pdb`.
AlphaFlow is all-atom, enabling the secondary Phe114 χ1 CV.

---

## Then, locally (or on Colab) — score
```bash
python scripts/run_benchmark.py \
  --generated-dir outputs/benchmark/generated/t4l/bioemu \
  --label bioemu --out outputs/benchmark/t4l_benchmark_bioemu.json
```
Headline = `frac_excited_state_like` vs the experimental ~3%. The scorer reports the
geometry-valid fraction, min RMSD to 2LC9, ground-basin recall (sanity: should be high),
and seed mean±sd.
```
