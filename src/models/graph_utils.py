"""
Graph construction utilities for the GNN encoder.
Builds torch_geometric Data objects from Cα coordinate arrays.
"""
import numpy as np
import torch
from torch_geometric.data import Data
from scipy.spatial.distance import cdist


def build_graph(coords, cutoff=8.0):
    """
    Build a graph from a single frame's Cα coordinates.

    Args:
        coords: numpy array of shape (n_atoms, 3)
        cutoff: distance cutoff in Angstroms for edge construction

    Returns:
        torch_geometric Data with:
            x: node features (n_atoms, 3) — xyz coordinates
            edge_index: (2, n_edges) — bidirectional edges within cutoff
    """
    dists = cdist(coords, coords)
    src, dst = np.where((dists < cutoff) & (dists > 0))
    edge_index = torch.tensor(np.array([src, dst]), dtype=torch.long)
    x = torch.tensor(coords, dtype=torch.float32)
    return Data(x=x, edge_index=edge_index)


def build_dataset(all_coords, cutoff=8.0):
    """
    Pre-build graph Data objects for all frames.

    Args:
        all_coords: numpy array of shape (n_frames, n_atoms, 3)
        cutoff: distance cutoff in Angstroms

    Returns:
        list of torch_geometric Data objects
    """
    dataset = []
    n_frames = all_coords.shape[0]
    for i in range(n_frames):
        data = build_graph(all_coords[i], cutoff=cutoff)
        # Store original coords as target for reconstruction loss
        data.y = data.x.clone()
        dataset.append(data)
        if (i + 1) % 5000 == 0:
            print(f"  Built {i + 1}/{n_frames} graphs...")
    print(f"  Built all {n_frames} graphs.")
    return dataset
