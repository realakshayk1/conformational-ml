"""
Train the GNN autoencoder on aligned Cα coordinate graphs.
Encodes per-frame graphs → latent vector → decodes to reconstructed coordinates.
Saves encoder-only checkpoint for Phase 2 diffusion training.
"""
import os
import sys
import numpy as np
import torch
import torch.nn.functional as F
import torch.optim as optim
import matplotlib.pyplot as plt
from torch_geometric.loader import DataLoader

# Add project root to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from src.models.gnn import GNNAutoencoder
from src.models.graph_utils import build_dataset


def main():
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print(f"Using device: {device}")

    # --- Config ---
    CUTOFF = 8.0
    LATENT_DIM = 2
    HIDDEN_DIM = 64
    BATCH_SIZE = 32
    EPOCHS = 50
    LR = 1e-3
    N_ATOMS = 214

    # --- Directories ---
    coords_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "coords")
    checkpoint_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "checkpoints")
    latent_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "latent")
    figures_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "figures")
    os.makedirs(checkpoint_dir, exist_ok=True)
    os.makedirs(latent_dir, exist_ok=True)
    os.makedirs(figures_dir, exist_ok=True)

    # --- 1. Load coordinates ---
    print("Loading coordinate arrays...")
    train_coords = np.load(os.path.join(coords_dir, "train_coords.npy"))
    val_coords = np.load(os.path.join(coords_dir, "val_coords.npy"))
    print(f"Train coords: {train_coords.shape}")
    print(f"Val coords:   {val_coords.shape}")

    # --- 2. Build graphs ---
    print(f"\nBuilding training graphs (cutoff={CUTOFF}Å)...")
    train_dataset = build_dataset(train_coords, cutoff=CUTOFF)

    # Quick diagnostic on first graph
    g0 = train_dataset[0]
    print(f"  Sample graph: nodes={g0.num_nodes}, edges={g0.num_edges}, x={g0.x.shape}")
    if g0.num_edges < 2000 or g0.num_edges > 6000:
        print(f"  WARNING: Edge count {g0.num_edges} outside expected range [2000, 6000]")

    print(f"\nBuilding validation graphs...")
    val_dataset = build_dataset(val_coords, cutoff=CUTOFF)

    # --- 3. Create DataLoaders (no shuffling for temporal order) ---
    train_loader = DataLoader(train_dataset, batch_size=BATCH_SIZE, shuffle=False)
    val_loader = DataLoader(val_dataset, batch_size=BATCH_SIZE, shuffle=False)

    # --- 4. Model ---
    model = GNNAutoencoder(
        in_channels=3,
        hidden_dim=HIDDEN_DIM,
        latent_dim=LATENT_DIM,
        n_atoms=N_ATOMS
    ).to(device)
    optimizer = optim.Adam(model.parameters(), lr=LR)

    print(f"\nModel parameters: {sum(p.numel() for p in model.parameters()):,}")

    # --- 5. Training loop ---
    train_losses = []
    val_losses = []
    best_val_loss = float('inf')
    best_epoch = 0

    print(f"\n{'='*60}")
    print(f"Training GNN Autoencoder for {EPOCHS} epochs")
    print(f"{'='*60}")

    for epoch in range(1, EPOCHS + 1):
        # Training
        model.train()
        epoch_train_loss = 0.0
        n_train_batches = 0

        for batch in train_loader:
            batch = batch.to(device)
            optimizer.zero_grad()

            z, coords_pred = model(batch.x, batch.edge_index, batch.batch)

            # Reconstruct target: batch.y contains original coords per node
            # We need per-graph targets: reshape batch.y to (batch_size, n_atoms, 3)
            target = batch.y.view(-1, N_ATOMS, 3)

            loss = F.mse_loss(coords_pred, target)
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
            for batch in val_loader:
                batch = batch.to(device)
                z, coords_pred = model(batch.x, batch.edge_index, batch.batch)
                target = batch.y.view(-1, N_ATOMS, 3)
                loss = F.mse_loss(coords_pred, target)
                epoch_val_loss += loss.item()
                n_val_batches += 1

        avg_val_loss = epoch_val_loss / n_val_batches
        val_losses.append(avg_val_loss)

        # Save best checkpoint
        if avg_val_loss < best_val_loss:
            best_val_loss = avg_val_loss
            best_epoch = epoch
            # Save encoder-only checkpoint (for Phase 2 diffusion)
            torch.save(
                model.encoder.state_dict(),
                os.path.join(checkpoint_dir, "gnn_encoder.pt")
            )
            # Save full autoencoder for reference
            torch.save(
                model.state_dict(),
                os.path.join(checkpoint_dir, "gnn_autoencoder_full.pt")
            )

        print(f"Epoch {epoch:3d}/{EPOCHS} | Train: {avg_train_loss:.6f} | Val: {avg_val_loss:.6f}"
              + (f" | NEW BEST" if epoch == best_epoch and epoch > 0 else ""))

        # Early stopping check: if val loss diverges after epoch 10
        if epoch > 10 and len(val_losses) > 5:
            recent_val = val_losses[-5:]
            if all(recent_val[i] > recent_val[i-1] for i in range(1, len(recent_val))):
                print(f"\nWARNING: Val loss has been increasing for 5 consecutive epochs.")
                print("Stopping early to avoid wasting compute on a diverging model.")
                break

    # --- 6. Loss curves ---
    print("\nSaving loss curves...")
    fig, ax = plt.subplots(figsize=(8, 5))
    epochs_range = range(1, len(train_losses) + 1)
    ax.plot(epochs_range, train_losses, label='Train Loss', color='blue')
    ax.plot(epochs_range, val_losses, label='Val Loss', color='red')
    ax.axvline(x=best_epoch, color='green', linestyle='--', alpha=0.7, label=f'Best (epoch {best_epoch})')
    ax.set_title("GNN Autoencoder Loss Curves")
    ax.set_xlabel("Epoch")
    ax.set_ylabel("MSE Loss")
    ax.legend()
    ax.grid(True, linestyle='--', alpha=0.7)
    plt.tight_layout()
    loss_path = os.path.join(figures_dir, "gnn_loss.png")
    plt.savefig(loss_path, dpi=300)
    plt.close()
    print(f"Saved loss curves to {loss_path}")

    # --- 7. Generate latent trajectory ---
    print("\nGenerating latent trajectory from best encoder...")
    # Reload best encoder weights
    best_model = GNNAutoencoder(
        in_channels=3, hidden_dim=HIDDEN_DIM, latent_dim=LATENT_DIM, n_atoms=N_ATOMS
    ).to(device)
    best_model.load_state_dict(
        torch.load(os.path.join(checkpoint_dir, "gnn_autoencoder_full.pt"), map_location=device)
    )
    best_model.eval()

    latents = []
    with torch.no_grad():
        for batch in DataLoader(train_dataset, batch_size=BATCH_SIZE, shuffle=False):
            batch = batch.to(device)
            z = best_model.encoder(batch.x, batch.edge_index, batch.batch)
            latents.append(z.cpu().numpy())

    latent_trajectory = np.concatenate(latents, axis=0)
    print(f"Latent trajectory shape: {latent_trajectory.shape}")

    # Assertions
    assert latent_trajectory.shape == (train_coords.shape[0], LATENT_DIM), \
        f"Wrong shape: {latent_trajectory.shape}"
    assert not np.isnan(latent_trajectory).any(), "NaNs in latent trajectory"
    assert not np.isinf(latent_trajectory).any(), "Infs in latent trajectory"

    latent_path = os.path.join(latent_dir, "gnn_encoder.npy")
    np.save(latent_path, latent_trajectory)
    print(f"Saved latent trajectory to {latent_path}")

    # --- 8. Landscape plot ---
    print("\nGenerating landscape scatter plot...")
    fig, ax = plt.subplots(figsize=(7, 6))
    ax.scatter(latent_trajectory[:, 0], latent_trajectory[:, 1], s=1, alpha=0.5, c='blue')
    ax.set_title("GNN Encoder Latent Space")
    ax.set_xlabel("Latent Dim 1")
    ax.set_ylabel("Latent Dim 2")
    plt.tight_layout()
    landscape_path = os.path.join(figures_dir, "landscape_gnn.png")
    plt.savefig(landscape_path, dpi=300)
    plt.close()
    print(f"Saved landscape plot to {landscape_path}")

    # --- 9. Final report ---
    print(f"\n{'='*60}")
    print(f"FINAL REPORT")
    print(f"{'='*60}")
    print(f"Final train loss: {train_losses[-1]:.4f}")
    print(f"Final val loss:   {val_losses[-1]:.4f}")
    print(f"Best val loss:    {best_val_loss:.4f} (epoch {best_epoch})")
    print(f"GNN latent range: dim1=[{latent_trajectory[:,0].min():.4f}, {latent_trajectory[:,0].max():.4f}], "
          f"dim2=[{latent_trajectory[:,1].min():.4f}, {latent_trajectory[:,1].max():.4f}]")
    print(f"Checkpoint saved: outputs/checkpoints/gnn_encoder.pt (encoder only)")
    print(f"Full AE saved:    outputs/checkpoints/gnn_autoencoder_full.pt")
    print(f"Latent saved:     outputs/latent/gnn_encoder.npy")
    print(f"Loss curves:      outputs/figures/gnn_loss.png")
    print(f"Landscape:        outputs/figures/landscape_gnn.png")


if __name__ == "__main__":
    main()
