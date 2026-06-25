# Phase B2 — Generate KRAS G12D ensembles on Colab (BioEmu primary, AlphaFlow cross-check)

Mirror of the T4L runbook. Output layout expected by `scripts/run_benchmark.py`:
`outputs/benchmark/generated/kras/<model>/<seed>/samples.pdb` (multi-model PDB per seed).

KRAS G12D catalytic-domain sequence (Asp at position 12; residues 1–168 from PDB 7RPZ):

```
TEYKLVVVGADGVGKSALTIQLIQNHFVDEYDPTIEDSYRKQVVIDGETSLLDILDTAGQEEYSAMRDQYMRTGEGFLLVFAINNTKSFEDIHHYREQIKRVKDSEDVPMVLVGNKSDLPSRTVDTKQAQDLARSYGIPFIETSAKTRQGVDDAFYTLVREIRKHKEK
```

> The CV scores switch-II (residues 60–76); this construct covers it fully.

---

## Cell 1 — install BioEmu
```bash
pip install bioemu
```

## Cell 2 — generate (3 seeds × ~1000 samples)
```python
import os, subprocess
SEQ = ("TEYKLVVVGADGVGKSALTIQLIQNHFVDEYDPTIEDSYRKQVVIDGETSLLDILDTAGQEEYSAMRDQ"
       "YMRTGEGFLLVFAINNTKSFEDIHHYREQIKRVKDSEDVPMVLVGNKSDLPSRTVDTKQAQDLARSYGI"
       "PFIETSAKTRQGVDDAFYTLVREIRKHKEK")
for seed in range(3):
    out = f"outputs/benchmark/generated/kras/bioemu/seed{seed}"
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
for seed_dir in sorted(glob.glob("outputs/benchmark/generated/kras/bioemu/seed*")):
    u = mda.Universe(os.path.join(seed_dir, "topology.pdb"),
                     os.path.join(seed_dir, "samples.xtc"))
    ca = u.select_atoms("protein")
    with mda.Writer(os.path.join(seed_dir, "samples.pdb"), multiframe=True,
                    n_atoms=ca.n_atoms) as w:
        for _ in u.trajectory:
            w.write(ca)
    print(seed_dir, "->", u.trajectory.n_frames, "models")
```

## Cell 4 — (optional) AlphaFlow cross-check
Run AlphaFlow inference on the same sequence into
`outputs/benchmark/generated/kras/alphaflow/seed*/samples.pdb`.

---

## Then — score
```bash
python scripts/run_benchmark.py \
  --generated-dir outputs/benchmark/generated/kras/bioemu \
  --config configs/evaluation/kras_sii_state.yaml \
  --label bioemu_kras --out outputs/benchmark/kras_benchmark_bioemu.json
```
Headline = `frac_target_state_like` = recall of the switch-II-OPEN (SII-P) state. There is
no canonical equilibrium population for the SII-open state, so the claim is recall +
min-RMSD-to-bound-pocket, with geometry-valid fraction and seed mean±sd.
```
