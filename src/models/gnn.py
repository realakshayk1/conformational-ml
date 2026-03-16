import torch
import torch.nn as nn
from torch_geometric.nn import GCNConv, global_mean_pool


class GNNEncoder(nn.Module):
    """
    GNN encoder for Cα coordinate graphs.
    3-layer GCNConv with global mean pooling → latent vector.
    """
    def __init__(self, in_channels=3, hidden_dim=64, latent_dim=2):
        super().__init__()
        self.conv1 = GCNConv(in_channels, hidden_dim)
        self.conv2 = GCNConv(hidden_dim, hidden_dim)
        self.conv3 = GCNConv(hidden_dim, hidden_dim)
        self.proj = nn.Linear(hidden_dim, latent_dim)
        self.act = nn.ReLU()

    def forward(self, x, edge_index, batch):
        """
        Args:
            x: Node features (num_nodes, in_channels)
            edge_index: Graph connectivity (2, num_edges)
            batch: Batch assignment vector (num_nodes,)
        Returns:
            z: Graph latent vectors (batch_size, latent_dim)
        """
        x = self.act(self.conv1(x, edge_index))
        x = self.act(self.conv2(x, edge_index))
        x = self.act(self.conv3(x, edge_index))
        x = global_mean_pool(x, batch)
        return self.proj(x)


class GNNDecoder(nn.Module):
    """
    MLP decoder: latent vector → reconstructed Cα coordinates.
    Maps (batch_size, latent_dim) → (batch_size, n_atoms * 3).
    """
    def __init__(self, latent_dim=2, hidden_dim=256, n_atoms=214):
        super().__init__()
        self.n_atoms = n_atoms
        self.decoder = nn.Sequential(
            nn.Linear(latent_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, n_atoms * 3)
        )

    def forward(self, z):
        """
        Args:
            z: Latent vectors (batch_size, latent_dim)
        Returns:
            coords: Reconstructed coordinates (batch_size, n_atoms, 3)
        """
        out = self.decoder(z)
        return out.view(-1, self.n_atoms, 3)


class GNNAutoencoder(nn.Module):
    """
    Full GNN autoencoder for training.
    Encoder: GNN on per-frame graphs → latent vector
    Decoder: MLP latent vector → reconstructed Cα coordinates
    """
    def __init__(self, in_channels=3, hidden_dim=64, latent_dim=2, n_atoms=214):
        super().__init__()
        self.encoder = GNNEncoder(in_channels, hidden_dim, latent_dim)
        self.decoder = GNNDecoder(latent_dim, hidden_dim=256, n_atoms=n_atoms)

    def forward(self, x, edge_index, batch):
        z = self.encoder(x, edge_index, batch)
        coords_pred = self.decoder(z)
        return z, coords_pred
