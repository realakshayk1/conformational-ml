import torch
import torch.nn as nn
import numpy as np
from src.models.embeddings import SinusoidalPositionEmbeddings


class ConformationalDiffusionModel(nn.Module):
    """
    Conditional DDPM for generating Cα coordinate conformations.
    Conditions on a frozen GNN encoder's latent vector z.

    FIX: Increased capacity (1024 hidden, 3 layers), LayerNorm, 
         reduced T=200, and clamping in sample loop.
    """

    def __init__(self, coord_dim=642, cond_dim=2, T=200, hidden=1024):
        super().__init__()
        self.coord_dim = coord_dim
        self.cond_dim = cond_dim
        self.T = T
        self.hidden = hidden

        # --- Noise schedule (linear beta schedule) ---
        betas = torch.linspace(1e-4, 0.02, T)
        alphas = 1.0 - betas
        alpha_bar = torch.cumprod(alphas, dim=0)

        # Register as buffers
        self.register_buffer('betas', betas)
        self.register_buffer('alphas', alphas)
        self.register_buffer('alpha_bar', alpha_bar)
        self.register_buffer('sqrt_alpha_bar', torch.sqrt(alpha_bar))
        self.register_buffer('sqrt_one_minus_alpha_bar', torch.sqrt(1.0 - alpha_bar))

        # --- Denoising network ---
        self.time_embed = SinusoidalPositionEmbeddings(128)
        self.cond_proj = nn.Linear(cond_dim, 128)

        # 3-layer MLP denoiser with LayerNorm (FIX 1, 2)
        # Input dim: coord_dim (642) + t_emb (128) + z_emb (128) = 898
        self.denoise_net = nn.Sequential(
            nn.Linear(coord_dim + 128 + 128, hidden),
            nn.LayerNorm(hidden),
            nn.SiLU(),
            nn.Linear(hidden, hidden),
            nn.LayerNorm(hidden),
            nn.SiLU(),
            nn.Linear(hidden, hidden),
            nn.LayerNorm(hidden),
            nn.SiLU(),
            nn.Linear(hidden, coord_dim)
        )

    def get_noisy_sample(self, x0, t):
        """Forward diffusion: add noise to clean coordinates."""
        noise = torch.randn_like(x0)
        sqrt_ab = self.sqrt_alpha_bar[t].unsqueeze(-1)
        sqrt_one_minus_ab = self.sqrt_one_minus_alpha_bar[t].unsqueeze(-1)
        x_t = sqrt_ab * x0 + sqrt_one_minus_ab * noise
        return x_t, noise

    def forward(self, x0, t, z):
        """Training forward pass: add noise, then predict it."""
        x_t, noise_true = self.get_noisy_sample(x0, t)

        t_emb = self.time_embed(t.float())
        z_emb = self.cond_proj(z)

        inp = torch.cat([x_t, t_emb, z_emb], dim=-1)
        noise_pred = self.denoise_net(inp)
        return noise_pred, noise_true

    @torch.no_grad()
    def sample(self, z, n_samples=1, device='cpu'):
        """Reverse diffusion: generate conformations conditioned on z."""
        if z.dim() == 1:
            z = z.unsqueeze(0).expand(n_samples, -1)
        z = z.to(device)

        # Start from pure noise
        x_t = torch.randn(n_samples, self.coord_dim, device=device)

        # Reverse diffusion loop: t = T-1, T-2, ..., 0
        for t_val in reversed(range(self.T)):
            # FIX 6: Clamp x_t before noise prediction to stabilize sampling
            x_t = x_t.clamp(-4.0, 4.0)

            t = torch.full((n_samples,), t_val, device=device, dtype=torch.long)

            # Predict noise
            t_emb = self.time_embed(t.float())
            z_emb = self.cond_proj(z)
            inp = torch.cat([x_t, t_emb, z_emb], dim=-1)
            eps_pred = self.denoise_net(inp)

            # Reverse step coefficients
            alpha_t = self.alphas[t_val]
            beta_t = self.betas[t_val]

            # Mean of p(x_{t-1} | x_t)
            coeff1 = 1.0 / torch.sqrt(alpha_t)
            coeff2 = beta_t / self.sqrt_one_minus_alpha_bar[t_val]
            mean = coeff1 * (x_t - coeff2 * eps_pred)

            if t_val > 0:
                noise = torch.randn_like(x_t)
                sigma = torch.sqrt(beta_t)
                x_t = mean + sigma * noise
            else:
                x_t = mean

        return x_t.view(n_samples, 214, 3)

    @torch.no_grad()
    def sample_cfg(self, z, n_samples=1, guidance_scale=3.0, device='cpu'):
        """
        Reverse diffusion with Classifier-Free Guidance (CFG).
        ε_guided = ε_uncond + guidance_scale * (ε_cond - ε_uncond)

        Args:
            z: Conditioning vector (cond_dim,) or (n_samples, cond_dim)
            n_samples: Number of samples to generate
            guidance_scale: Scale for blending conditional and unconditional noise
            device: Device to run on

        Returns:
            x0_pred: Generated coordinates (n_samples, 214, 3) in normalized space
        """
        if z.dim() == 1:
            z = z.unsqueeze(0).expand(n_samples, -1)
        z = z.to(device)

        # Unconditional conditioning (batch of zeros)
        z_uncond = torch.zeros_like(z)

        # Start from pure noise
        x_t = torch.randn(n_samples, self.coord_dim, device=device)

        # Reverse diffusion loop: t = T-1, T-2, ..., 0
        for t_val in reversed(range(self.T)):
            # Stabilization clamping (from Stage 5)
            x_t = x_t.clamp(-4.0, 4.0)

            t = torch.full((n_samples,), t_val, device=device, dtype=torch.long)
            t_emb = self.time_embed(t.float())

            # 1. Conditional noise prediction
            z_emb_cond = self.cond_proj(z)
            inp_cond = torch.cat([x_t, t_emb, z_emb_cond], dim=-1)
            eps_cond = self.denoise_net(inp_cond)

            # 2. Unconditional noise prediction
            z_emb_uncond = self.cond_proj(z_uncond)
            inp_uncond = torch.cat([x_t, t_emb, z_emb_uncond], dim=-1)
            eps_uncond = self.denoise_net(inp_uncond)

            # 3. Guided noise prediction
            eps_guided = eps_uncond + guidance_scale * (eps_cond - eps_uncond)

            # Reverse step coefficients
            alpha_t = self.alphas[t_val]
            beta_t = self.betas[t_val]

            # Mean of p(x_{t-1} | x_t)
            coeff1 = 1.0 / torch.sqrt(alpha_t)
            coeff2 = beta_t / self.sqrt_one_minus_alpha_bar[t_val]
            mean = coeff1 * (x_t - coeff2 * eps_guided)

            if t_val > 0:
                noise = torch.randn_like(x_t)
                sigma = torch.sqrt(beta_t)
                x_t = mean + sigma * noise
            else:
                x_t = mean

        # Return in normalized space (caller denormalizes)
        return x_t.view(n_samples, 214, 3)
