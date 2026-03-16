import os
import json
import numpy as np

def verify_datasets():
    """
    Loads saved processed tensors, prints their shapes and stats,
    and checks for NaNs and Infs.
    """
    processed_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data", "processed")
    
    files = ["train.npy", "val.npy", "test.npy"]
    
    print("--- Verifying Processed Tensors ---")
    
    for filename in files:
        filepath = os.path.join(processed_dir, filename)
        if not os.path.exists(filepath):
            print(f"Error: {filepath} does not exist.")
            continue
            
        data = np.load(filepath)
        
        has_nan = np.isnan(data).any()
        has_inf = np.isinf(data).any()
        
        print(f"\n{filename}:")
        print(f"  Shape: {data.shape}")
        if data.size > 0:
            print(f"  Min value: {np.nanmin(data):.4f}")
            print(f"  Max value: {np.nanmax(data):.4f}")
        print(f"  Contains NaN: {has_nan}")
        print(f"  Contains Inf: {has_inf}")
        
        assert not has_nan, f"{filename} contains NaNs!"
        assert not has_inf, f"{filename} contains Infs!"
        
    print("\n--- Verifying Metadata ---")
    meta_path = os.path.join(processed_dir, "metadata.json")
    if os.path.exists(meta_path):
        with open(meta_path, "r") as f:
            metadata = json.load(f)
        print("Metadata splits:", list(metadata.keys()))
        for split_name, entries in metadata.items():
            total_frames = sum(entry["frames"] for entry in entries)
            print(f"  {split_name} total frames in metadata: {total_frames}")
            for entry in entries:
                print(f"    - {entry['dataset']}: {entry['frames']}")
    else:
        print(f"Error: {meta_path} does not exist.")

if __name__ == "__main__":
    verify_datasets()
