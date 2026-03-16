import torch
import sys
import os

# Add root folder so we can import src
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.models.embeddings import SinusoidalPositionEmbeddings
from src.models.tae import TimelaggedAutoencoder
from src.models.gnn import AdKGNNEncoder
from src.models.diffusion import ConformationalDiffusionModel

def test_models():
    print("--- Testing Embeddings ---")
    emb_model = SinusoidalPositionEmbeddings(dim=128)
    t = torch.tensor([1, 10, 100])
    emb = emb_model(t)
    print(f"Input time: {t.shape} -> Emb: {emb.shape}")
    assert emb.shape == (3, 128)
    print("Embedding test passed!\n")

    print("--- Testing Time-lagged Autoencoder ---")
    tae = TimelaggedAutoencoder(input_dim=60, latent_dim=10)
    x_t = torch.randn(16, 60)
    x_tau = torch.randn(16, 60)
    z_t, x_tau_pred = tae(x_t)
    print(f"x_t: {x_t.shape} -> z_t: {z_t.shape}, x_tau_pred: {x_tau_pred.shape}")
    assert z_t.shape == (16, 10)
    assert x_tau_pred.shape == (16, 60)
    
    loss = tae.training_step((x_t, x_tau))
    print(f"MSE Loss computed successfully: {loss.item():.4f}")
    assert isinstance(loss, torch.Tensor)
    print("TAE test passed!\n")

    print("--- Testing AdKGNNEncoder ---")
    gnn = AdKGNNEncoder(node_feat_dim=6, edge_feat_dim=1, latent_dim=16)
    
    # Simulate a batch of 2 graphs, each with 20 residues
    x = torch.randn(40, 6)
    
    # 200 edges in the batch
    edge_index = torch.randint(0, 40, (2, 200))
    edge_attr = torch.randn(200, 1)
    
    # Construct batch assignment tensor
    batch = torch.cat([torch.zeros(20, dtype=torch.long), torch.ones(20, dtype=torch.long)])
    
    z = gnn(x, edge_index, edge_attr, batch)
    print(f"Input x: {x.shape}, edge_index: {edge_index.shape} -> Output z: {z.shape}")
    assert z.shape == (2, 16)
    print("GNN test passed!\n")

    print("--- Testing ConformationalDiffusionModel ---")
    diff = ConformationalDiffusionModel(coord_dim=60, state_dim=16, hidden_dim=128, T=1000)
    
    x_noisy = torch.randn(32, 60)
    t_batch = torch.randint(0, 1000, (32,))
    z_state = torch.randn(32, 16)
    
    eps = diff(x_noisy, t_batch, z_state)
    print(f"x_noisy: {x_noisy.shape}, t_batch: {t_batch.shape}, z_state: {z_state.shape} -> eps: {eps.shape}")
    assert eps.shape == (32, 60)
    
    # Test guidance
    eps_guided = diff.guided_sample(x_noisy, t_batch, z_state, guidance_scale=3.0)
    print(f"eps_guided shape: {eps_guided.shape}")
    assert eps_guided.shape == (32, 60)
    
    print("Diffusion test passed!\n")
    print("✅ All Model Skeletons Passed Shape Checks")

if __name__ == "__main__":
    test_models()
