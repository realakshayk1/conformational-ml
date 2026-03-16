"""
Train the conditional DDPM with improved capacity and stabilization fixes.
- hidden=1024, 3 layers, LayerNorm
- AdamW, lr=1e-4, weight_decay=1e-2
- T=200
- x_t clamping in sample() [-4, 4]
- FIXED NORMALIZATION: Global Unit Variance AFTER per-dim centering.
- Bond length check after Epoch 1.
"""
import os
import sys
import numpy as np
import torch
import torch.optim as optim
import matplotlib.pyplot as plt

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from src.models.diffusion import ConformationalDiffusionModel


def main():
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print(f"Using device: {device}")

    # --- Config ---
    COORD_DIM = 214 * 3
    COND_DIM = 2
    T = 200
    HIDDEN = 1024
    BATCH_SIZE = 64
    EPOCHS = 100
    LR = 1e-4
    WEIGHT_DECAY = 1e-2
    PATIENCE = 15

    # --- Directories ---
    coords_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "coords")
    latent_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "latent")
    checkpoint_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "checkpoints")
    figures_dir = os.path.join(os.path.dirname(__file__), "..", "outputs", "figures")
    os.makedirs(checkpoint_dir, exist_ok=True)
    os.makedirs(figures_dir, exist_ok=True)

    # --- 1. Load data ---
    print("Loading data...")
    train_coords = np.load(os.path.join(coords_dir, "train_coords.npy"))
    val_coords = np.load(os.path.join(coords_dir, "val_coords.npy"))
    gnn_latents = np.load(os.path.join(latent_dir, "gnn_encoder.npy"))

    train_flat = train_coords.reshape(train_coords.shape[0], -1).astype(np.float32)
    val_flat = val_coords.reshape(val_coords.shape[0], -1).astype(np.float32)

    # --- FIXED NORMALIZATION ---
    # 1. Center per dimension
    coord_mean = train_flat.mean(axis=0)  # (642,)
    train_centered = train_flat - coord_mean
    
    # 2. Compute Global Standard Deviation OF THE CENTERED DATA
    global_std = train_centered.std()
    print(f"Global Std (centered): {global_std:.4f}")

    # 3. Scale
    train_norm = train_centered / global_std
    val_norm = (val_flat - coord_mean) / global_std

    print(f"Train stats after normalization:")
    print(f"  Range: [{train_norm.min():.2f}, {train_norm.max():.2f}]")
    print(f"  Global Std: {train_norm.std():.4f} (Should be 1.0000)")
    
    # Load val latents
    val_latent_path = os.path.join(latent_dir, "gnn_val_latents.npy")
    if os.path.exists(val_latent_path):
        val_latents = np.load(val_latent_path)
    else:
        print("Val latents missing. Recalculating...")
        from src.models.gnn import GNNEncoder
        from src.models.graph_utils import build_graph
        gnn_encoder = GNNEncoder(in_channels=3, hidden_dim=64, latent_dim=2).to(device)
        gnn_encoder.load_state_dict(torch.load(os.path.join(checkpoint_dir, "gnn_encoder.pt"), map_location=device))
        gnn_encoder.eval()
        val_latents_list = []
        with torch.no_grad():
            for i in range(len(val_coords)):
                g = build_graph(val_coords[i], cutoff=8.0).to(device)
                z = gnn_encoder(g.x, g.edge_index, torch.zeros(g.num_nodes, dtype=torch.long, device=device))
                val_latents_list.append(z.cpu().numpy())
        val_latents = np.concatenate(val_latents_list, axis=0)
        np.save(val_latent_path, val_latents)

    train_x = torch.tensor(train_norm, dtype=torch.float32)
    val_x = torch.tensor(val_norm, dtype=torch.float32)
    train_z = torch.tensor(gnn_latents, dtype=torch.float32)
    val_z = torch.tensor(val_latents, dtype=torch.float32)

    # --- 2. Model ---
    model = ConformationalDiffusionModel(coord_dim=COORD_DIM, cond_dim=2, T=T, hidden=HIDDEN).to(device)
    optimizer = optim.AdamW(model.parameters(), lr=LR, weight_decay=WEIGHT_DECAY)

    # --- 3. Training ---
    train_losses, val_losses = [], []
    best_val_loss = float('inf'); best_epoch = 0; patience_counter = 0

    print("\nStarting Training...")
    for epoch in range(1, EPOCHS + 1):
        model.train()
        batch_loss = []
        # Shuffle batch indices for better learning
        indices = torch.randperm(len(train_x))
        for i in range(0, len(train_x), BATCH_SIZE):
            idx = indices[i:i+BATCH_SIZE]
            x0, z = train_x[idx].to(device), train_z[idx].to(device)
            t = torch.randint(0, T, (x0.shape[0],), device=device)
            noise_pred, noise_true = model(x0, t, z)
            loss = torch.nn.functional.mse_loss(noise_pred, noise_true)
            optimizer.zero_grad(); loss.backward(); optimizer.step()
            batch_loss.append(loss.item())

        avg_train = np.mean(batch_loss); train_losses.append(avg_train)

        model.eval()
        v_loss = []
        with torch.no_grad():
            for i in range(0, len(val_x), BATCH_SIZE):
                end = min(i+BATCH_SIZE, len(val_x))
                x0, z = val_x[i:end].to(device), val_z[i:end].to(device)
                t = torch.randint(0, T, (x0.shape[0],), device=device)
                noise_pred, noise_true = model(x0, t, z)
                v_loss.append(torch.nn.functional.mse_loss(noise_pred, noise_true).item())
        avg_val = np.mean(v_loss); val_losses.append(avg_val)

        is_best = avg_val < best_val_loss
        if is_best:
            best_val_loss = avg_val; best_epoch = epoch; patience_counter = 0
            torch.save(model.state_dict(), os.path.join(checkpoint_dir, "diffusion_model.pt"))
            np.savez(os.path.join(checkpoint_dir, "diffusion_norm_stats.npz"), 
                     mean=coord_mean, std=np.array([global_std]))
        else:
            patience_counter += 1

        print(f"Epoch {epoch:3d}/100 | Train: {avg_train:.6f} | Val: {avg_val:.6f}" + (" | BEST" if is_best else ""))

        # Epoch 1 Sanity Check
        if epoch == 1:
            print("  Performing Epoch 1 Sanity Check...")
            z_mean = torch.tensor(gnn_latents.mean(axis=0), dtype=torch.float32)
            s_norm = model.sample(z_mean, n_samples=5, device=device)
            s = s_norm.view(5, -1).cpu().numpy() * global_std + coord_mean
            s = s.reshape(5, 214, 3)
            bonds = [np.linalg.norm(np.diff(sx, axis=0), axis=1).mean() for sx in s]
            print(f"  Epoch 1 sample check: mean_bond={bonds}")
            if np.mean(bonds) > 20.0:
                print("  FATAL: Sampling is still exploding (mean bond > 20Å). Stopping.")
                sys.exit(1)
            print("  Check PASS: Sampling is stable.")

        if patience_counter >= PATIENCE:
            print("Early stopping."); break

    plt.figure(); plt.plot(train_losses, label='Train'); plt.plot(val_losses, label='Val')
    plt.title("DDPM Loss (Final Fixes)"); plt.savefig(os.path.join(figures_dir, "diffusion_loss.png")); plt.close()

if __name__ == "__main__":
    main()
