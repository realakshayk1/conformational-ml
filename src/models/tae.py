import torch
import torch.nn as nn
import torch.nn.functional as F

class TimelaggedAutoencoder(nn.Module):
    def __init__(self, input_dim, latent_dim):
        super().__init__()
        self.encoder = nn.Sequential(
            nn.Linear(input_dim, 256),
            nn.ReLU(),
            nn.Linear(256, 64),
            nn.ReLU(),
            nn.Linear(64, latent_dim)
        )
        self.decoder = nn.Sequential(
            nn.Linear(latent_dim, 64),
            nn.ReLU(),
            nn.Linear(64, 256),
            nn.ReLU(),
            nn.Linear(256, input_dim)
        )

    def forward(self, x_t, x_tau=None):
        """
        Forward pass for the Time-lagged Autoencoder.
        Args:
            x_t: Coordinates at time t (batch, input_dim)
            x_tau: Optional target coordinates at time t + tau, not strictly needed for standard forward.
        Returns:
            z_t: Latent projection at time t (batch, latent_dim)
            x_tau_pred: Predicted coordinates at time t + tau (batch, input_dim)
        """
        z_t = self.encoder(x_t)
        x_tau_pred = self.decoder(z_t)
        return z_t, x_tau_pred

    def training_step(self, batch, tau=None):
        """
        Compute MSE loss for the Time-lagged Autoencoder.
        Args:
            batch: Tuple of (x_t, x_tau) where both are (batch, input_dim)
            tau: Time lag parameter (for tracking/conceptual purposes)
        Returns:
            loss: Mean Squared Error between the prediction and true x_tau
        """
        x_t, x_tau = batch
        _, x_tau_pred = self(x_t)
        loss = F.mse_loss(x_tau_pred, x_tau)
        return loss
