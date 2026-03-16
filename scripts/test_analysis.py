import os
import sys
import numpy as np
import pandas as pd

# Add src to Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'src')))

from analysis.metrics import (
    compute_rmsd, pairwise_rmsd, radius_of_gyration, bond_geometry_check, ramachandran_check
)
from analysis.msm import (
    run_vamp2, run_ck_test, plot_implied_timescales, plot_free_energy_landscape
)
from analysis.pockets import (
    aggregate_pocket_results, find_cryptic_pockets
)
from analysis.visualize import (
    plot_conformational_landscape, plot_rmsd_distribution, plot_ramachandran, plot_guidance_scale_tradeoff
)

def test_metrics():
    print("Testing metrics...")
    coords_a = np.random.rand(100, 3) * 10
    coords_b = coords_a + np.random.normal(0, 0.1, (100, 3))
    
    rmsd = compute_rmsd(coords_a, coords_b)
    print(f"  compute_rmsd: {rmsd:.4f} (expected ~float)")
    assert isinstance(rmsd, float)
    
    ensemble = np.random.rand(10, 100, 3) * 10
    pr_rmsd = pairwise_rmsd(ensemble)
    print(f"  pairwise_rmsd shape: {pr_rmsd.shape} (expected (10, 10))")
    assert pr_rmsd.shape == (10, 10)
    
    rg = radius_of_gyration(coords_a)
    print(f"  radius_of_gyration: {rg:.4f} (expected ~float)")
    assert isinstance(rg, float)
    
    # Create somewhat realistic bond lengths (distance ~3.8 between consecutive)
    chain = np.zeros((100, 3))
    for i in range(1, 100):
        direction = np.random.randn(3)
        direction /= np.linalg.norm(direction)
        chain[i] = chain[i-1] + direction * 3.8
    bg = bond_geometry_check(chain)
    print(f"  bond_geometry_check: {bg} (expected mean~3.8, pct ~100%)")
    assert isinstance(bg, dict)
    
    # Ramachandran check (dummy path)
    if os.path.exists("dummy.pdb"):
        rc = ramachandran_check("dummy.pdb")
    else:
        rc = ramachandran_check("non_existent.pdb")
    print(f"  ramachandran_check keys: {list(rc.keys())}")
    assert 'allowed_pct' in rc

def test_msm():
    print("Testing MSM utilities...")
    latents = [np.random.rand(100, 2) for _ in range(5)]
    lags = [1, 2, 5]
    
    v2 = run_vamp2(latents, lags)
    print(f"  run_vamp2 returned for lags: {list(v2.keys())}")
    assert isinstance(v2, dict)
    
    ckt = run_ck_test(latents, 2)
    print(f"  run_ck_test completed. Expected None if no PyEMMA, got {type(ckt)}")
    
    plot_implied_timescales(lags, np.array([10.0, 8.0, 5.0]), "test_its.png")
    assert os.path.exists("test_its.png")
    
    plot_free_energy_landscape(np.random.randn(1000, 2), "test_fel.png")
    assert os.path.exists("test_fel.png")
    print("  MSM plots generated.")

def test_pockets():
    print("Testing pocket utilities...")
    dummy_results = [
        {'structure_id': 's1', 'pocket_id': 1, 'volume': 150.0, 'druggability_score': 0.8, 'center_x': 5.0, 'center_y': 5.0, 'center_z': 5.0, 'Score': 1.0},
        {'structure_id': 's1', 'pocket_id': 2, 'volume': 80.0, 'druggability_score': 0.2, 'center_x': -5.0, 'center_y': -5.0, 'center_z': -5.0, 'Score': 0.4},
    ]
    df = aggregate_pocket_results(dummy_results)
    print(f"  aggregate_pocket_results DataFrame shape: {df.shape}")
    assert df.shape == (2, 8)
    
    state_res = {
        'state_A': pd.DataFrame([
            {'structure_id': 's1', 'center_x': 10.1, 'center_y': 10.0, 'center_z': 10.0},
            {'structure_id': 's2', 'center_x': 10.0, 'center_y': 9.9, 'center_z': 10.1}, 
            {'structure_id': 's3', 'center_x': 10.0, 'center_y': 10.0, 'center_z': 10.0},
        ]),
        'state_B': pd.DataFrame([
            {'structure_id': 's4', 'center_x': -10.0, 'center_y': -10.0, 'center_z': -10.0},
        ])
    }
    cryptic = find_cryptic_pockets(state_res)
    print(f"  find_cryptic_pockets clusters found: {len(cryptic)}")
    assert len(cryptic) > 0

def test_visualize():
    print("Testing visualize utilities...")
    z = np.random.randn(200, 2)
    labels = np.random.randint(0, 3, 200)
    
    plot_conformational_landscape(z, labels, "PCA", "test_landscape.png")
    assert os.path.exists("test_landscape.png")
    
    rmsd = np.random.rand(100)
    plot_rmsd_distribution(rmsd, "State_A", "test_rmsd.png")
    assert os.path.exists("test_rmsd.png")
    
    phi = np.random.uniform(-180, 180, 500)
    psi = np.random.uniform(-180, 180, 500)
    plot_ramachandran(phi, psi, "test_rama.png")
    assert os.path.exists("test_rama.png")
    
    res = {
        1.0: {'state_specificity': 0.5, 'ensemble_diversity': 5.0},
        2.0: {'state_specificity': 0.7, 'ensemble_diversity': 4.0},
        5.0: {'state_specificity': 0.9, 'ensemble_diversity': 2.0},
    }
    plot_guidance_scale_tradeoff(res, "test_tradeoff.png")
    assert os.path.exists("test_tradeoff.png")
    print("  Visualize plots generated.")

if __name__ == "__main__":
    os.makedirs(os.path.join(os.path.dirname(__file__), '../src/analysis'), exist_ok=True)
    test_metrics()
    test_msm()
    test_pockets()
    test_visualize()
    print("ALL TESTS PASSED!")
