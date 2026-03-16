import numpy as np
from scipy.spatial.distance import pdist

def extract_ca_distances(universe):
    """
    Extracts C-alpha coordinates from the given MDAnalysis Universe for each frame.
    Computes the upper-triangle of the pairwise distance matrix.
    Returns a 2D numpy array of shape (n_frames, n_features).
    """
    ca_atoms = universe.select_atoms("name CA")
    n_frames = len(universe.trajectory)
    n_atoms = len(ca_atoms)
    
    # pdist returns a condensed distance matrix, which is exactly the upper triangle.
    # The length should be n_atoms * (n_atoms - 1) / 2
    n_features = n_atoms * (n_atoms - 1) // 2
    
    # Pre-allocate array
    features = np.zeros((n_frames, n_features), dtype=np.float32)
    
    print(f"Extracting features across {n_frames} frames...")
    
    for i, ts in enumerate(universe.trajectory):
        coords = ca_atoms.positions
        # pdist computes the pairwise distances between observations in n-dimensional space.
        # It automatically returns the condensed distance matrix (upper triangle).
        condensed_dist = pdist(coords, metric='euclidean')
        features[i] = condensed_dist
        
    print(f"Output features shape: {features.shape}")
    
    return features

if __name__ == "__main__":
    # Optional test block if run directly, would require a universe
    pass
