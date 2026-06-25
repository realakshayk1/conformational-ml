"""Fetch experimental ground-truth structures for the rare-state benchmark.

These PDBs live under data/ (gitignored), so this script makes them reproducible.
Run from the repo root:  python scripts/fetch_ground_truth_structures.py
"""
import os
import urllib.request

# target -> {pdb_id: role}
STRUCTURES = {
    "t4l": {
        "2LC9": "excited state (NMR ensemble; ~3% population; F/G-helix straightened)",
        "1L83": "ground/closed L99A state (reference)",
        "3DMV": "excited-state-mimic mutant (cross-check)",
        "3DMX": "excited-state-mimic mutant (cross-check)",
        "4W52": "benzene-bound (cavity-open sanity anchor)",
    },
    "kras": {
        # Phase B — KRAS G12D switch-II pocket ground truth.
        "7RPZ": "MRTX1133-bound (switch-II pocket OPEN)",
        "8DNI": "MRTX1133-bound (switch-II pocket OPEN)",
        "4DSN": "apo GDP-bound (switch-II pocket CLOSED reference)",
    },
}

BASE_URL = "https://files.rcsb.org/download/{pdb_id}.pdb"


def main():
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    for target, entries in STRUCTURES.items():
        out_dir = os.path.join(repo_root, "data", target, "structures")
        os.makedirs(out_dir, exist_ok=True)
        for pdb_id, role in entries.items():
            out_path = os.path.join(out_dir, f"{pdb_id}.pdb")
            if os.path.exists(out_path):
                print(f"[skip] {pdb_id} already present")
                continue
            url = BASE_URL.format(pdb_id=pdb_id)
            print(f"[get ] {pdb_id} -> {out_path}  ({role})")
            urllib.request.urlretrieve(url, out_path)
    print("Done.")


if __name__ == "__main__":
    main()
