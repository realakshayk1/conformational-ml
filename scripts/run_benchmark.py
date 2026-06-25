"""Phase A3 — score generated conformers against the T4L L99A excited state (2LC9).

Takes a directory of generated PDBs (from BioEmu / AlphaFlow), computes the frozen
excited-state CV for every conformer, gates on Cα bond geometry, and reports the
headline metric: fraction of conformers reaching the excited basin vs the
experimental ~3% population.

Usage:
    python scripts/run_benchmark.py --generated-dir outputs/benchmark/generated/t4l/bioemu \
        --label bioemu --out outputs/benchmark/t4l_benchmark.json

Each *.pdb in the directory is scored; multi-model PDBs are expanded model-by-model.
Sub-directories are treated as seeds (e.g. .../bioemu/seed0, seed1, ...).
"""
import argparse
import glob
import json
import os
import sys

import numpy as np

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.analysis.order_param import T4LExcitedCV, ca_by_resid, n_models, _stack
from src.analysis.metrics import bond_geometry_check, radius_of_gyration

EXPERIMENTAL_EXCITED_POP = 0.03


def _conformer_ca_ordered(query):
    """CA coords ordered by residue id (for geometry / Rg)."""
    resids = sorted(query)
    return _stack(query, resids)


def score_pdb(cv: T4LExcitedCV, pdb_path: str):
    out = []
    for m in range(n_models(pdb_path)):
        q = ca_by_resid(pdb_path, m)
        if len(q) < 20:
            continue
        cvr = cv.score_coords(q)
        ca = _conformer_ca_ordered(q)
        geom = bond_geometry_check(ca)
        out.append({
            "source": f"{os.path.basename(pdb_path)}#model{m}",
            "rmsd_to_2lc9": cvr.rmsd_to_2lc9,
            "rmsd_to_1l83": cvr.rmsd_to_1l83,
            "delta": cvr.rmsd_to_1l83 - cvr.rmsd_to_2lc9,
            "excited_state_like": cvr.excited_state_like,
            "mean_ca_distance": geom["mean_ca_distance"],
            "pct_bonds_within_tol": geom["pct_within_tolerance"],
            "geometry_valid": bool(geom["pct_within_tolerance"] >= 90.0),
            "rg": radius_of_gyration(ca),
        })
    return out


def aggregate(records, label):
    n = len(records)
    if n == 0:
        return {"label": label, "n_conformers": 0, "error": "no conformers scored"}
    geo_valid = [r for r in records if r["geometry_valid"]]
    excited = [r for r in records if r["excited_state_like"]]
    excited_valid = [r for r in geo_valid if r["excited_state_like"]]
    ground = [r for r in records if r["excited_state_like"] is False]
    return {
        "label": label,
        "n_conformers": n,
        "experimental_excited_population": EXPERIMENTAL_EXCITED_POP,
        # headline: fraction reaching the excited basin (raw and geometry-gated)
        "frac_excited_state_like": len(excited) / n,
        "frac_excited_state_like_geom_valid": (len(excited_valid) / len(geo_valid)) if geo_valid else None,
        "min_rmsd_to_2lc9": float(min(r["rmsd_to_2lc9"] for r in records)),
        "ground_basin_recall": len(ground) / n,            # sanity: should reproduce 1L83
        "geometry_validity_rate": len(geo_valid) / n,      # gates the claim
        "mean_rg": float(np.mean([r["rg"] for r in records])),
    }


def collect_pdbs(generated_dir):
    pdbs = sorted(glob.glob(os.path.join(generated_dir, "*.pdb")))
    seeds = {}
    if pdbs:
        seeds["_all"] = pdbs
    for sub in sorted(glob.glob(os.path.join(generated_dir, "*/"))):
        sp = sorted(glob.glob(os.path.join(sub, "*.pdb")))
        if sp:
            seeds[os.path.basename(sub.rstrip("/"))] = sp
    return seeds


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--generated-dir", required=True)
    ap.add_argument("--config", default="configs/evaluation/t4l_excited_state.yaml")
    ap.add_argument("--label", default="generator")
    ap.add_argument("--out", default="outputs/benchmark/t4l_benchmark.json")
    args = ap.parse_args()

    cv = T4LExcitedCV.from_config(args.config)
    if cv.margin is None:
        raise SystemExit("CV margin is not frozen in the config — run Phase A1 calibration first.")

    seeds = collect_pdbs(args.generated_dir)
    if not seeds:
        raise SystemExit(f"No .pdb files found under {args.generated_dir}")

    per_seed, all_records = {}, []
    for seed, pdbs in seeds.items():
        if seed == "_all" and len(seeds) > 1:
            continue  # avoid double-counting when seed subdirs exist
        recs = []
        for p in pdbs:
            recs.extend(score_pdb(cv, p))
        per_seed[seed] = aggregate(recs, f"{args.label}:{seed}")
        all_records.extend(recs)

    # seed mean +/- sd of the headline metric
    fracs = [s["frac_excited_state_like"] for s in per_seed.values() if s.get("n_conformers")]
    summary = {
        "label": args.label,
        "overall": aggregate(all_records, args.label),
        "per_seed": per_seed,
        "headline_frac_excited_mean": float(np.mean(fracs)) if fracs else None,
        "headline_frac_excited_sd": float(np.std(fracs)) if len(fracs) > 1 else None,
    }

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w") as fh:
        json.dump(summary, fh, indent=2)

    o = summary["overall"]
    print(f"\n=== {args.label} | {o['n_conformers']} conformers ===")
    print(f"  excited-state-like:        {o['frac_excited_state_like']*100:.2f}%  "
          f"(experimental ~{EXPERIMENTAL_EXCITED_POP*100:.0f}%)")
    print(f"  excited (geometry-valid):  "
          f"{(o['frac_excited_state_like_geom_valid'] or 0)*100:.2f}%")
    print(f"  min RMSD to 2LC9 (F/G):    {o['min_rmsd_to_2lc9']:.2f} A")
    print(f"  ground-basin recall:       {o['ground_basin_recall']*100:.2f}%")
    print(f"  geometry validity rate:    {o['geometry_validity_rate']*100:.2f}%")
    print(f"  wrote {args.out}")


if __name__ == "__main__":
    main()
