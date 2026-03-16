import os
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
import umap

def main():
    # Define directories
    data_dir = os.path.join(os.path.dirname(__file__), "..", "..", "adk-data", "data", "processed")
    baseline_out_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "baselines")
    figures_out_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "figures")
    
    os.makedirs(baseline_out_dir, exist_ok=True)
    os.makedirs(figures_out_dir, exist_ok=True)
    
    # Load data
    print("Loading data...")
    train_path = os.path.join(data_dir, "train.npy")
    val_path = os.path.join(data_dir, "val.npy")
    
    train_data = np.load(train_path)
    val_data = np.load(val_path)
    
    print(f"Loaded train data with shape: {train_data.shape}")
    print(f"Loaded val data with shape: {val_data.shape}")
    
    # 1. First PCA reduction to 50 components
    print("Fitting PCA(n=50) dimensional reduction...")
    pca50 = PCA(n_components=50)
    pca50_train = pca50.fit_transform(train_data)
    pca50_val = pca50.transform(val_data)
    
    # Save pca50 projections
    np.save(os.path.join(baseline_out_dir, "pca50_train.npy"), pca50_train)
    np.save(os.path.join(baseline_out_dir, "pca50_val.npy"), pca50_val)
    print("Saved PCA50 representations.")
    
    # 2. PCA to 2 components from pca50
    print("Fitting PCA(n=2) from PCA50...")
    pca2 = PCA(n_components=2)
    pca2_train = pca2.fit_transform(pca50_train)
    pca2_val = pca2.transform(pca50_val)
    
    np.save(os.path.join(baseline_out_dir, "pca2_train.npy"), pca2_train)
    np.save(os.path.join(baseline_out_dir, "pca2_val.npy"), pca2_val)
    
    # 3. UMAP to 2 components from pca50
    print("Fitting UMAP(n=2) from PCA50...")
    reducer = umap.UMAP(n_components=2, random_state=42)
    umap2_train = reducer.fit_transform(pca50_train)
    umap2_val = reducer.transform(pca50_val)
    
    np.save(os.path.join(baseline_out_dir, "umap2_train.npy"), umap2_train)
    np.save(os.path.join(baseline_out_dir, "umap2_val.npy"), umap2_val)
    
    # 4. Generate Visualization
    print("Generating PCA vs UMAP scatter plot...")
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))
    
    # PCA Plot
    ax1.scatter(pca2_train[:, 0], pca2_train[:, 1], alpha=0.5, s=2, c='blue', label='Train')
    ax1.scatter(pca2_val[:, 0], pca2_val[:, 1], alpha=0.5, s=2, c='red', label='Val')
    ax1.set_title("PCA (2D) Landscape")
    ax1.set_xlabel("PC 1")
    ax1.set_ylabel("PC 2")
    ax1.legend()
    
    # UMAP Plot
    ax2.scatter(umap2_train[:, 0], umap2_train[:, 1], alpha=0.5, s=2, c='blue', label='Train')
    ax2.scatter(umap2_val[:, 0], umap2_val[:, 1], alpha=0.5, s=2, c='red', label='Val')
    ax2.set_title("UMAP (2D) Landscape")
    ax2.set_xlabel("UMAP 1")
    ax2.set_ylabel("UMAP 2")
    ax2.legend()
    
    plt.tight_layout()
    plot_path = os.path.join(figures_out_dir, "baselines.png")
    plt.savefig(plot_path, dpi=300)
    plt.close()
    print(f"Saved baseline figures to {plot_path}")

if __name__ == "__main__":
    main()
