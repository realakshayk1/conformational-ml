import numpy as np
import MDAnalysis as mda

def compute_rmsd(coords_a: np.ndarray, coords_b: np.ndarray) -> float:
    """Calculates the Cα RMSD between two sets of coordinates."""
    if coords_a.shape != coords_b.shape:
        raise ValueError("Coordinate arrays must have the same shape")
    diff = coords_a - coords_b
    return float(np.sqrt(np.mean(np.sum(diff**2, axis=-1))))

def pairwise_rmsd(ensemble: np.ndarray) -> np.ndarray:
    """All-vs-all RMSD within a generated ensemble."""
    n_frames = ensemble.shape[0]
    rmsd_matrix = np.zeros((n_frames, n_frames))
    for i in range(n_frames):
        for j in range(i + 1, n_frames):
            r = compute_rmsd(ensemble[i], ensemble[j])
            rmsd_matrix[i, j] = r
            rmsd_matrix[j, i] = r
    return rmsd_matrix

def ramachandran_check(pdb_path: str) -> dict:
    """Uses MDAnalysis to extract phi/psi dihedrals."""
    try:
        import warnings
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            u = mda.Universe(pdb_path)
            
        ram = mda.analysis.dihedrals.Ramachandran(u.select_atoms('protein')).run()
        
        # Depending on MDAnalysis version, it's either ram.angles or ram.results.angles
        if hasattr(ram, 'results') and hasattr(ram.results, 'angles'):
            angles = ram.results.angles
        else:
            angles = ram.angles
            
        if angles.ndim == 3 and angles.shape[0] == 1:
            angles = angles[0]
            
        phi_angles = angles[:, 0]
        psi_angles = angles[:, 1]
        
        # Simple proxy for 'allowed' - generally valid main chain areas
        allowed_mask = (phi_angles < 0) & ((psi_angles > 90) | (psi_angles < -30))
        allowed_count = np.sum(allowed_mask)
        total = len(phi_angles)
        
        return {
            'allowed_pct': float(allowed_count / total * 100) if total > 0 else 0.0,
            'outlier_pct': float((total - allowed_count) / total * 100) if total > 0 else 0.0,
            'phi_angles': phi_angles.tolist(),
            'psi_angles': psi_angles.tolist()
        }
    except Exception as e:
        return {'allowed_pct': 0.0, 'outlier_pct': 0.0, 'phi_angles': [], 'psi_angles': []}

def radius_of_gyration(coords: np.ndarray) -> float:
    """Calculates the radius of gyration from a set of coordinates."""
    center_of_mass = np.mean(coords, axis=0)
    sq_distances = np.sum((coords - center_of_mass)**2, axis=-1)
    return float(np.sqrt(np.mean(sq_distances)))

def bond_geometry_check(coords: np.ndarray) -> dict:
    """Checks if virtual Cα-Cα bond lengths are ~3.8Å ± 0.1Å."""
    if len(coords) < 2:
        return {'mean_ca_distance': 0.0, 'pct_within_tolerance': 0.0}
        
    distances = np.linalg.norm(coords[1:] - coords[:-1], axis=1)
    mean_dist = float(np.mean(distances))
    
    within_tol = np.sum((distances >= 3.7) & (distances <= 3.9))
    pct_within = float(within_tol / len(distances) * 100)
    
    return {
        'mean_ca_distance': mean_dist,
        'pct_within_tolerance': pct_within
    }
