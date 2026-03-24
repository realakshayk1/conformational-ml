import numpy as np
import os
import sys

# Add src to path
sys.path.append('src')
from analysis.pockets import export_to_pdb, run_p2rank, parse_p2rank_output

def test_single_pdb():
    ensemble_path = 'outputs/ensembles/open_gs3.0.npy'
    if not os.path.exists(ensemble_path):
        print(f"Error: {ensemble_path} not found.")
        return

    coords = np.load(ensemble_path)[0] # (214, 3)
    pdb_dir = 'outputs/pdb/test'
    pdb_path = os.path.join(pdb_dir, 'structure_000.pdb')
    
    print(f"Exporting structure to {pdb_path}...")
    export_to_pdb(coords, pdb_path)
    
    # Add CRYST1 and END records manually to be safe, though export_to_pdb adds END
    with open(pdb_path, 'r') as f:
        lines = f.readlines()
    
    # CRYST1    1.000    1.000    1.000  90.00  90.00  90.00 P 1           1
    cryst1 = "CRYST1    1.000    1.000    1.000  90.00  90.00  90.00 P 1           1\n"
    with open(pdb_path, 'w') as f:
        f.write(cryst1)
        for line in lines:
            f.write(line)
            if not line.endswith('\n'):
                f.write('\n')

    print("Running P2Rank...")
    analysis_root = "outputs/analysis/test"
    out_dir = os.path.join(analysis_root, "p2rank_raw")
    
    success = run_p2rank(pdb_path, out_dir)
    if not success:
        print("P2Rank execution failed.")
        return

    print("Parsing results...")
    p_res = parse_p2rank_output(out_dir, "structure_000.pdb")
    
    print(f"Number of pockets found: {p_res['n_pockets']}")
    if p_res['n_pockets'] > 0:
        print(f"Top pocket probability: {p_res['pockets'][0]['probability']}")
        print(f"Top pocket score: {p_res['pockets'][0]['score']}")
    else:
        print("No pockets found. This is a valid result for Cα-only structures if no pockets exceed the threshold.")

if __name__ == "__main__":
    test_single_pdb()
