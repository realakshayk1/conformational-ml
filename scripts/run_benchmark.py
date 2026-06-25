"""Phase A3 / B2 — score generated conformers against a rare target state.

Takes a directory of generated PDBs (from BioEmu / AlphaFlow), computes the frozen
state-contrast CV for every conformer, gates on Cα bond geometry, and reports the
headline metric: fraction of conformers reaching the TARGET basin. For T4L the config
carries an experimental target population (~3%) to compare against; for KRAS it reports
recall of the switch-II-open state.

Usage:
    python scripts/run_benchmark.py \
        --generated-dir outputs/benchmark/generated/t4l/bioemu \
        --config configs/evaluation/t4l_excited_state.yaml \
        --label bioemu_t4l --out outputs/benchmark/t4l_benchmark_bioemu.json

Each *.pdb is scored; multi-model PDBs are expanded model-by-model. Sub-directories are
treated as seeds (e.g. .../bioemu/seed0, seed1, ...).
"""
import argparse
import glob
import json
import os
import sys

import numpy as np
import yaml

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.analysis.order_param import StateContrastCV, ca_by_resid, n_models, _stack
from src.analysis.metrics import bond_geometry_check, radius_of_gyration


def _conformer_ca_ordered(query):
    return _stack(query, sorted(query))


def score_pdb(cv: StateContrastCV, pdb_path: str):
    out = []
    for m in range(n_models(pdb_path)):
        q = ca_by_resid(pdb_path, m)
        if len(q) < 20:
            continue
        r = cv.score_coords(q)
        ca = _conformer_ca_ordered(q)
        geom = bond_geometry_check(ca)
        out.append({
            "source": f"{os.path.basename(pdb_path)}#model{m}",
            "rmsd_to_target": r.rmsd_to_target,
            "rmsd_to_ground": r.rmsd_to_ground,
            "delta": r.delta,
            "target_like": r.target_like,
            "mean_ca_distance": geom["mean_ca_distance"],
            "pct_bonds_within_tol": geom["pct_within_tolerance"],
            "geometry_valid": bool(geom["pct_within_tolerance"] >= 90.0),
            "rg": radius_of_gyration(ca),
        })
    return out


def aggregate(records, label, exp_pop):
    n = len(records)
    if n == 0:
        return {"label": label, "n_conformers": 0, "error": "no conformers scored"}
    geo_valid = [r for r in records if r["geometry_valid"]]
    target = [r for r in records if r["target_like"]]
    target_valid = [r for r in geo_valid if r["target_like"]]
    ground = [r for r in records if r["target_like"] is False]
    return {
        "label": label,
        "n_conformers": n,
        "experimental_target_population": exp_pop,
        "frac_target_state_like": len(target) / n,
        "frac_target_state_like_geom_valid": (len(target_valid) / len(geo_valid)) if geo_valid else None,
        "min_rmsd_to_target": float(min(r["rmsd_to_target"] for r in records)),
        "ground_basin_recall": len(ground) / n,
        "geometry_validity_rate": len(geo_valid) / n,
        "mean_rg": float(np.mean([r["rg"] for r in records])),
    }


def collect_pdbs(generated_dir):
    seeds = {}
    pdbs = sorted(glob.glob(os.path.join(generated_dir, "*.pdb")))
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
    ap.add_argument("--config", required=True)
    ap.add_argument("--label", default="generator")
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    cv = StateContrastCV.from_config(args.config)
    if cv.margin is None:
        raise SystemExit("CV margin is not frozen in the config — run calibration first.")
    with open(args.config) as fh:
        exp_pop = yaml.safe_load(fh).get("experimental_target_population")

    seeds = collect_pdbs(args.generated_dir)
    if not seeds:
        raise SystemExit(f"No .pdb files found under {args.generated_dir}")

    per_seed, all_records = {}, []
    for seed, pdbs in seeds.items():
        if seed == "_all" and len(seeds) > 1:
            continue
        recs = []
        for p in pdbs:
            recs.extend(score_pdb(cv, p))
        per_seed[seed] = aggregate(recs, f"{args.label}:{seed}", exp_pop)
        all_records.extend(recs)

    fracs = [s["frac_target_state_like"] for s in per_seed.values() if s.get("n_conformers")]
    summary = {
        "label": args.label,
        "config": args.config,
        "overall": aggregate(all_records, args.label, exp_pop),
        "per_seed": per_seed,
        "headline_frac_target_mean": float(np.mean(fracs)) if fracs else None,
        "headline_frac_target_sd": float(np.std(fracs)) if len(fracs) > 1 else None,
    }

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w") as fh:
        json.dump(summary, fh, indent=2)

    o = summary["overall"]
    exp_str = f"  (experimental ~{exp_pop*100:.0f}%)" if exp_pop else "  (no published population; recall)"
    print(f"\n=== {args.label} | {o['n_conformers']} conformers ===")
    print(f"  target-state-like:         {o['frac_target_state_like']*100:.2f}%{exp_str}")
    print(f"  target (geometry-valid):   {(o['frac_target_state_like_geom_valid'] or 0)*100:.2f}%")
    print(f"  min RMSD to target:        {o['min_rmsd_to_target']:.2f} A")
    print(f"  ground-basin recall:       {o['ground_basin_recall']*100:.2f}%")
    print(f"  geometry validity rate:    {o['geometry_validity_rate']*100:.2f}%")
    print(f"  wrote {args.out}")


if __name__ == "__main__":
    main()
