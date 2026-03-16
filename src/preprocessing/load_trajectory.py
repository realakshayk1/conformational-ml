import os
import MDAnalysis as mda
from MDAnalysisData import datasets
from MDAnalysis.analysis import align
import warnings

def load_and_align_datasets():
    """
    Downloads the AdK equilibrium, DIMS, and FRODA datasets.
    Loads them into MDAnalysis Universe objects.
    Aligns all trajectories to the first frame of the equilibrium dataset.
    Returns a dictionary of aligned universes.
    """
    # Create data directory if it doesn't exist
    data_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "data")
    os.makedirs(data_dir, exist_ok=True)
    
    print("Downloading/fetching AdK equilibrium dataset...")
    adk_eq = datasets.fetch_adk_equilibrium(data_home=data_dir)
    print("Downloading/fetching AdK DIMS dataset...")
    adk_dims = datasets.fetch_adk_transitions_DIMS(data_home=data_dir)
    print("Downloading/fetching AdK FRODA dataset...")
    adk_froda = datasets.fetch_adk_transitions_FRODA(data_home=data_dir)

    print("\nLoading datasets into MDAnalysis Universes...")
    # Suppress warnings about missing topology information (like masses/bonds)
    # which are common and not needed for alpha-carbon distance calculations
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        u_eq = mda.Universe(adk_eq.topology, adk_eq.trajectory)
        u_dims = mda.Universe(adk_dims.topology, adk_dims.trajectories)
        u_froda = mda.Universe(adk_froda.topology, adk_froda.trajectories)

    print(f"Equilibrium frames: {len(u_eq.trajectory)}")
    print(f"DIMS frames: {len(u_dims.trajectory)}")
    print(f"FRODA frames: {len(u_froda.trajectory)}")

    # Verify C-alpha counts match
    ca_eq = u_eq.select_atoms("name CA")
    ca_dims = u_dims.select_atoms("name CA")
    ca_froda = u_froda.select_atoms("name CA")

    n_ca = len(ca_eq)
    print(f"\nNumber of CA atoms in Equilibrium: {n_ca}")
    
    if len(ca_dims) != n_ca or len(ca_froda) != n_ca:
        raise ValueError(f"CA atom counts do not match! "
                         f"Eq: {n_ca}, DIMS: {len(ca_dims)}, FRODA: {len(ca_froda)}")

    # Alignment Reference: First frame of the equilibrium trajectory explicitly
    # Set the equilibrium trajectory to its first frame
    u_eq.trajectory[0] 
    ref = u_eq.select_atoms("name CA")
    
    # We will align all datasets (including equilibrium itself) to this reference frame
    print("\nAligning trajectories to the first frame of the equilibrium dataset...")
    
    align.AlignTraj(u_eq, u_eq, select="name CA", in_memory=True).run()
    align.AlignTraj(u_dims, u_eq, select="name CA", in_memory=True).run()
    align.AlignTraj(u_froda, u_eq, select="name CA", in_memory=True).run()
    
    print("Alignment complete.")

    return {
        "equilibrium": u_eq,
        "dims": u_dims,
        "froda": u_froda
    }

if __name__ == "__main__":
    universes = load_and_align_datasets()
    print("Successfully loaded and aligned all datasets.")
