import numpy as np
import json
import os
from sklearn.cluster import KMeans

def recover_labels():
    latent_path = 'outputs/latent/gnn_encoder.npy'
    val_json_path = 'outputs/analysis/ensemble_validation.json'
    
    if not os.path.exists(latent_path):
        print(f"Error: {latent_path} not found.")
        return
    
    print("Running KMeans to recover labels...")
    z_all = np.load(latent_path)
    kmeans = KMeans(n_clusters=3, random_state=42, n_init=10).fit(z_all)
    centroids = kmeans.cluster_centers_
    labels = kmeans.labels_

    # Order: lowest PC1 is closed, highest is open (same as generate_and_validate_ensembles.py)
    order = np.argsort(centroids[:, 0])
    label_map = {old: new for new, old in enumerate(order)}
    unified_labels = [int(label_map[l]) for l in labels]
    
    if os.path.exists(val_json_path):
        with open(val_json_path, 'r') as f:
            data = json.load(f)
        
        data['training_labels'] = unified_labels
        
        with open(val_json_path, 'w') as f:
            json.dump(data, f, indent=2)
        print(f"Updated {val_json_path} with training_labels.")
    else:
        print(f"Error: {val_json_path} not found.")

if __name__ == "__main__":
    recover_labels()
