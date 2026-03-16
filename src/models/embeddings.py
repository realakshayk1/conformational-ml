import math
import torch
import torch.nn as nn

class SinusoidalPositionEmbeddings(nn.Module):
    def __init__(self, dim):
        super().__init__()
        self.dim = dim

    def forward(self, time):
        """
        Args:
            time: (batch_size,) tensor of time steps
        Returns:
            embeddings: (batch_size, dim) tensor of embeddings
        """
        device = time.device
        half_dim = self.dim // 2
        embeddings = math.log(10000) / (half_dim - 1)
        embeddings = torch.exp(torch.arange(half_dim, device=device) * -embeddings)
        embeddings = time[:, None] * embeddings[None, :]
        embeddings = torch.cat((embeddings.sin(), embeddings.cos()), dim=-1)
        
        # If dim is odd, pad the embeddings with zeros
        if self.dim % 2 != 0:
            embeddings = torch.nn.functional.pad(embeddings, (0, 1))
            
        return embeddings
