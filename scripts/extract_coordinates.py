"""
Extract aligned Cα coordinates from AdK trajectory datasets.
Applies the same temporal split (70/15/15) and alignment (to first equilibrium frame)
as the original featurization pipeline in adk-data.
Saves coordinate arrays as (N_frames, 214, 3) .npy files.
"""
import os
import sys
import json
import warnings
import numpy as np

# Add adk-data preprocessing to path for loading
adk_data_src = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "adk-data", "src", "preprocessing"))
sys.path.insert(0, adk_data_src)

from load_trajectory import load_and_align_datasets


def extract_ca_coordinates(universe):
    """
    Extract Cα coordinates from each frame of an MDAnalysis Universe.
    Returns array of shape (n_frames, n_ca_atoms, 3).
    """
    ca_atoms = universe.select_atoms("name CA")
    n_frames = len(universe.trajectory)
    n_atoms = len(ca_atoms)

    coords = np.zeros((n_frames, n_atoms, 3), dtype=np.float32)

    for i, ts in enumerate(universe.trajectory):
        coords[i] = ca_atoms.positions.copy()

    return coords


def verify_alignment(coords, label=""):
    """Quick sanity check that coordinates are aligned."""
    # Check that frame 0 and frame 1 have similar mean positions
    mean_0 = coords[0].mean(axis=0)
    mean_1 = coords[1].mean(axis=0)
    diff = np.linalg.norm(mean_0 - mean_1)
    print(f"  [{label}] Frame 0 mean: {mean_0}")
    print(f"  [{label}] Frame 1 mean: {mean_1}")
    print(f"  [{label}] Mean position diff (frame 0 vs 1): {diff:.4f} Å")
    if diff > 1.0:
        print(f"  WARNING: Mean position difference > 1Å — alignment may have failed!")
    else:
        print(f"  OK: Frames are well-aligned.")


def main():
    # Output directory
    out_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "coords")
    os.makedirs(out_dir, exist_ok=True)

    # 1. Load and align datasets (same as original pipeline)
    print("Loading and aligning trajectories...")
    universes = load_and_align_datasets()

    # 2. Extract coordinates from each dataset
    print("\n--- Extracting Cα coordinates ---")
    coords_eq = extract_ca_coordinates(universes["equilibrium"])
    print(f"Equilibrium: {coords_eq.shape}")

    coords_dims = extract_ca_coordinates(universes["dims"])
    print(f"DIMS: {coords_dims.shape}")

    coords_froda = extract_ca_coordinates(universes["froda"])
    print(f"FRODA: {coords_froda.shape}")

    # 3. Apply same 70/15/15 temporal split as adk-data/src/preprocessing/split.py
    print("\n--- Applying temporal split (70/15/15) ---")
    all_datasets = {
        "equilibrium": coords_eq,
        "dims": coords_dims,
        "froda": coords_froda
    }

    train_splits = []
    val_splits = []

    for name, coords in all_datasets.items():
        n_frames = coords.shape[0]
        n_train = int(0.70 * n_frames)
        n_val = int(0.15 * n_frames)

        train_feat = coords[:n_train]
        val_feat = coords[n_train:n_train + n_val]

        print(f"  {name}: total={n_frames}, train={train_feat.shape[0]}, val={val_feat.shape[0]}")
        train_splits.append(train_feat)
        val_splits.append(val_feat)

    # 4. Concatenate splits
    train_coords = np.concatenate(train_splits, axis=0)
    val_coords = np.concatenate(val_splits, axis=0)

    print(f"\nFinal train_coords: {train_coords.shape}")
    print(f"Final val_coords:   {val_coords.shape}")

    # 5. Verify alignment
    print("\n--- Alignment verification ---")
    verify_alignment(train_coords, "train")
    verify_alignment(val_coords, "val")

    # 6. Save
    train_path = os.path.join(out_dir, "train_coords.npy")
    val_path = os.path.join(out_dir, "val_coords.npy")
    np.save(train_path, train_coords)
    np.save(val_path, val_coords)
    print(f"\nSaved {train_path} ({train_coords.shape})")
    print(f"Saved {val_path} ({val_coords.shape})")

    # 7. Final assertions
    assert train_coords.shape == (36510, 214, 3), f"Unexpected train shape: {train_coords.shape}"
    assert val_coords.shape[1:] == (214, 3), f"Unexpected val shape: {val_coords.shape}"
    assert not np.isnan(train_coords).any(), "NaNs in train coordinates"
    assert not np.isnan(val_coords).any(), "NaNs in val coordinates"
    print("\nAll assertions passed. Coordinate extraction complete.")


if __name__ == "__main__":
    main()
