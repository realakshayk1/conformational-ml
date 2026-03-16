import os
import sys
import numpy as np
import torch
import torch.optim as optim
import matplotlib.pyplot as plt

# Add src to python path to load the TAE module
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from src.models.tae import TimelaggedAutoencoder

def create_time_lagged_dataset(data, tau):
    """
    Creates time-lagged pairs (x_t, x_{t+tau}) from a sequential trajectory.
    """
    if data.shape[0] <= tau:
        raise ValueError(f"Trajectory length ({data.shape[0]}) is too short for tau={tau}")
    x_t = data[:-tau]
    x_tau = data[tau:]
    return x_t, x_tau

def generate_batches(x_t, x_tau, batch_size, shuffle=True):
    """
    Simple batch generator.
    """
    n_samples = x_t.shape[0]
    indices = np.arange(n_samples)
    if shuffle:
        np.random.shuffle(indices)
        
    for start_idx in range(0, n_samples, batch_size):
        end_idx = min(start_idx + batch_size, n_samples)
        batch_idx = indices[start_idx:end_idx]
        yield torch.tensor(x_t[batch_idx], dtype=torch.float32), torch.tensor(x_tau[batch_idx], dtype=torch.float32)

def train_for_tau(tau, train_data, val_data, epochs, batch_size, checkpoint_dir, latent_dir):
    print(f"\n--- Training TAE for tau = {tau} ---")
    
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print(f"Using device: {device}")
    
    # 1. Create Datasets
    x_train_t, x_train_tau = create_time_lagged_dataset(train_data, tau)
    x_val_t, x_val_tau = create_time_lagged_dataset(val_data, tau)
    
    print(f"Train pairs: {x_train_t.shape[0]}")
    print(f"Val pairs: {x_val_t.shape[0]}")
    
    # 2. Instantiate Model
    # Operating on the PCA 50-dim projected space
    model = TimelaggedAutoencoder(input_dim=50, latent_dim=2).to(device)
    optimizer = optim.Adam(model.parameters(), lr=1e-3)
    
    train_losses = []
    val_losses = []
    
    for epoch in range(1, epochs + 1):
        model.train()
        epoch_train_loss = 0.0
        n_train_batches = 0
        
        # Training
        for batch_x_t, batch_x_tau in generate_batches(x_train_t, x_train_tau, batch_size):
            batch_x_t = batch_x_t.to(device)
            batch_x_tau = batch_x_tau.to(device)
            
            optimizer.zero_grad()
            loss = model.training_step((batch_x_t, batch_x_tau))
            loss.backward()
            optimizer.step()
            
            epoch_train_loss += loss.item()
            n_train_batches += 1
            
        avg_train_loss = epoch_train_loss / n_train_batches
        train_losses.append(avg_train_loss)
        
        # Validation
        model.eval()
        epoch_val_loss = 0.0
        n_val_batches = 0
        
        with torch.no_grad():
            for batch_x_t, batch_x_tau in generate_batches(x_val_t, x_val_tau, batch_size, shuffle=False):
                batch_x_t = batch_x_t.to(device)
                batch_x_tau = batch_x_tau.to(device)
                loss = model.training_step((batch_x_t, batch_x_tau))
                epoch_val_loss += loss.item()
                n_val_batches += 1
                
        avg_val_loss = epoch_val_loss / n_val_batches
        val_losses.append(avg_val_loss)
        
        if epoch % 10 == 0 or epoch == 1:
            print(f"Epoch {epoch}/{epochs} | Train Loss: {avg_train_loss:.6f} | Val Loss: {avg_val_loss:.6f}")
    
    # 3. Save Checkpoint
    checkpoint_path = os.path.join(checkpoint_dir, f"tae_tau{tau}.pt")
    torch.save(model.state_dict(), checkpoint_path)
    print(f"Saved checkpoint to {checkpoint_path}")
    
    # 4. Project Full Data to Latent Trajectory
    model.eval()
    print(f"Projecting full training sequence into latent space for tau={tau}...")
    full_train_tensor = torch.tensor(train_data, dtype=torch.float32).to(device)
    
    # Batch projection to avoid VRAM/RAM exhaustion
    latents = []
    with torch.no_grad():
        for i in range(0, len(full_train_tensor), batch_size):
            batch_t = full_train_tensor[i:i+batch_size]
            z_t, _ = model(batch_t)
            latents.append(z_t.cpu().numpy())
            
    latent_trajectory = np.concatenate(latents, axis=0)
    
    latent_path = os.path.join(latent_dir, f"tae_tau{tau}.npy")
    np.save(latent_path, latent_trajectory)
    print(f"Saved latent trajectory of shape {latent_trajectory.shape} to {latent_path}")
    
    return train_losses, val_losses

def main():
    # Define directories
    baseline_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "baselines")
    checkpoint_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "checkpoints")
    latent_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "latent")
    figures_out_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "figures")
    
    os.makedirs(checkpoint_dir, exist_ok=True)
    os.makedirs(latent_dir, exist_ok=True)
    os.makedirs(figures_out_dir, exist_ok=True)
    
    # Load PCA(n=50) dimensional data
    print("Loading PCA50 pre-processed data...")
    train_path = os.path.join(baseline_dir, "pca50_train.npy")
    val_path = os.path.join(baseline_dir, "pca50_val.npy")
    
    if not os.path.exists(train_path) or not os.path.exists(val_path):
        print("Error: PCA50 baseline data not found. Please run train_baselines.py first.")
        sys.exit(1)
        
    train_data = np.load(train_path)
    val_data = np.load(val_path)
    print(f"Train data shape: {train_data.shape}")
    print(f"Val data shape: {val_data.shape}")
    
    # Config
    taus = [1, 5, 10, 20]
    EPOCHS = 50
    BATCH_SIZE = 256
    
    # Store learning curves for all taus
    history = {}
    
    for tau in taus:
        train_loss, val_loss = train_for_tau(
            tau=tau, 
            train_data=train_data, 
            val_data=val_data, 
            epochs=EPOCHS, 
            batch_size=BATCH_SIZE,
            checkpoint_dir=checkpoint_dir, 
            latent_dir=latent_dir
        )
        history[tau] = {'train': train_loss, 'val': val_loss}
        
    # Plot all loss curves
    print("\nGenerating Loss Curves figure...")
    fig, axes = plt.subplots(2, 2, figsize=(12, 10))
    axes = axes.flatten()
    
    for idx, tau in enumerate(taus):
        ax = axes[idx]
        epochs_range = range(1, EPOCHS + 1)
        ax.plot(epochs_range, history[tau]['train'], label='Train Loss', color='blue')
        ax.plot(epochs_range, history[tau]['val'], label='Val Loss', color='red')
        ax.set_title(f"TAE Loss ($\\tau$={tau})")
        ax.set_xlabel("Epoch")
        ax.set_ylabel("MSE Loss")
        ax.legend()
        ax.grid(True, linestyle='--', alpha=0.7)
        
    plt.tight_layout()
    plot_path = os.path.join(figures_out_dir, "tae_loss_curves.png")
    plt.savefig(plot_path, dpi=300)
    plt.close()
    print(f"Saved all TAE loss curves to {plot_path}")

if __name__ == "__main__":
    main()
