import os
import json
import numpy as np

import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from load_trajectory import load_and_align_datasets
from featurize import extract_ca_distances

def split_and_save_data():
    """
    Loads AdK datasets, extracts features, splits them temporally (70/15/15) within each trajectory,
    concatenates the respective splits, and saves them to disk along with metadata.
    """
    universes = load_and_align_datasets()
    
    # Extract features for all three
    print("\n--- Featurizing Equilibrium Dataset ---")
    feat_eq = extract_ca_distances(universes["equilibrium"])
    
    print("\n--- Featurizing DIMS Dataset ---")
    feat_dims = extract_ca_distances(universes["dims"])
    
    print("\n--- Featurizing FRODA Dataset ---")
    feat_froda = extract_ca_distances(universes["froda"])
    
    datasets = {
        "equilibrium": feat_eq,
        "dims":          feat_dims,
        "froda":         feat_froda
    }
    
    splits = {"train": [], "val": [], "test": []}
    metadata = {"train": [], "val": [], "test": []}
    
    for name, features in datasets.items():
        n_frames = features.shape[0]
        n_train = int(0.70 * n_frames)
        n_val = int(0.15 * n_frames)
        # test takes the rest
        
        # Temporal split (no shuffling)
        train_feat = features[:n_train]
        val_feat = features[n_train:n_train + n_val]
        test_feat = features[n_train + n_val:]
        
        splits["train"].append(train_feat)
        splits["val"].append(val_feat)
        splits["test"].append(test_feat)
        
        # Track metadata: dataset name and number of frames contributed to this split block
        metadata["train"].append({"dataset": name, "frames": train_feat.shape[0]})
        metadata["val"].append({"dataset": name, "frames": val_feat.shape[0]})
        metadata["test"].append({"dataset": name, "frames": test_feat.shape[0]})
        
    print("\n--- Concatenating Splits ---")
    final_train = np.concatenate(splits["train"], axis=0)
    final_val = np.concatenate(splits["val"], axis=0)
    final_test = np.concatenate(splits["test"], axis=0)
    
    print(f"Final train shape: {final_train.shape}")
    print(f"Final val shape:   {final_val.shape}")
    print(f"Final test shape:  {final_test.shape}")
    
    # Save to data/processed/
    processed_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "data", "processed")
    os.makedirs(processed_dir, exist_ok=True)
    
    print(f"\nSaving arrays to {processed_dir} ...")
    np.save(os.path.join(processed_dir, "train.npy"), final_train)
    np.save(os.path.join(processed_dir, "val.npy"), final_val)
    np.save(os.path.join(processed_dir, "test.npy"), final_test)
    
    # Save metadata
    meta_path = os.path.join(processed_dir, "metadata.json")
    with open(meta_path, "w") as f:
        json.dump(metadata, f, indent=4)
        
    print(f"Metadata saved to {meta_path}")

if __name__ == "__main__":
    split_and_save_data()
