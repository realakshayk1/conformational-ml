import numpy as np
import matplotlib.pyplot as plt
import os

def plot_conformational_landscape(z: np.ndarray, labels: np.ndarray, method_name: str, save_path: str):
    """2D scatter of latent space colored by conformational state."""
    plt.figure(figsize=(8, 6))
    
    scatter = plt.scatter(z[:, 0], z[:, 1], c=labels, cmap='viridis', alpha=0.7)
    plt.colorbar(scatter, label='State / Label')
    plt.xlabel('Latent Dim 1')
    plt.ylabel('Latent Dim 2')
    plt.title(f'Conformational Landscape ({method_name})')
    
    os.makedirs(os.path.dirname(save_path) or '.', exist_ok=True)
    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()

def plot_rmsd_distribution(rmsd_values: np.ndarray, state_name: str, save_path: str):
    """Plots the distribution of RMSD values."""
    plt.figure(figsize=(8, 6))
    
    plt.hist(rmsd_values.flatten(), bins=50, alpha=0.7, color='blue', edgecolor='black')
    plt.xlabel('RMSD (Å)')
    plt.ylabel('Frequency')
    plt.title(f'RMSD Distribution - {state_name}')
    
    os.makedirs(os.path.dirname(save_path) or '.', exist_ok=True)
    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()

def plot_ramachandran(phi: np.ndarray, psi: np.ndarray, save_path: str):
    """Generates a Ramachandran plot."""
    plt.figure(figsize=(8, 8))
    
    plt.hist2d(phi, psi, bins=[np.linspace(-180, 180, 100), np.linspace(-180, 180, 100)], cmap='Blues', cmin=1)
    
    plt.xlim(-180, 180)
    plt.ylim(-180, 180)
    plt.xlabel('Phi (degrees)')
    plt.ylabel('Psi (degrees)')
    plt.title('Ramachandran Plot')
    
    plt.axhline(0, color='gray', linestyle='--')
    plt.axvline(0, color='gray', linestyle='--')
    
    os.makedirs(os.path.dirname(save_path) or '.', exist_ok=True)
    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()

def plot_guidance_scale_tradeoff(results_dict: dict, save_path: str):
    """Plots the tradeoff: x = guidance_scale, y1 = specificity, y2 = diversity."""
    scales = sorted(results_dict.keys())
    specificity = [results_dict[s].get('state_specificity', np.nan) for s in scales]
    diversity = [results_dict[s].get('ensemble_diversity', np.nan) for s in scales]
    
    fig, ax1 = plt.subplots(figsize=(8, 6))

    color1 = 'tab:red'
    ax1.set_xlabel('Guidance Scale')
    ax1.set_ylabel('State Specificity', color=color1)
    ax1.plot(scales, specificity, color=color1, marker='o', label='Specificity')
    ax1.tick_params(axis='y', labelcolor=color1)

    ax2 = ax1.twinx()  
    color2 = 'tab:blue'
    ax2.set_ylabel('Ensemble Diversity', color=color2)  
    ax2.plot(scales, diversity, color=color2, marker='s', label='Diversity')
    ax2.tick_params(axis='y', labelcolor=color2)
    
    plt.title('Guidance Scale Tradeoff')
    
    fig.tight_layout()  
    os.makedirs(os.path.dirname(save_path) or '.', exist_ok=True)
    plt.savefig(save_path)
    plt.close()
