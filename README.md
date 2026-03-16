# Conformational ML: AdK Dynamics and Generative Modeling

This project implements a pipeline for analyzing and generating conformational states of Adenylate Kinase (AdK) using Time-lagged Autoencoders (TAE), Graph Neural Networks (GNN), and Denoising Diffusion Probabilistic Models (DDPM).

## Project Structure

- `src/preprocessing/`: Data loading, alignment, and featurization (Cα distances).
- `src/models/`: Implementation of TAE, GNN, and Diffusion models.
- `src/analysis/`: MSM analysis, VAMP-2 scoring, CK tests, and pocket detection.
- `scripts/`: Training and validation scripts for all models.
- `outputs/`: Model checkpoints, latent trajectories, and analysis plots.

## Installation

```bash
pip install -r requirements.txt
```

## Usage

1. **Preprocessing**: `python scripts/extract_coordinates.py`
2. **Train Baselines**: `python scripts/train_baselines.py`
3. **Train Models**: `python scripts/train_tae.py`, `python scripts/train_gnn.py`, `python scripts/train_diffusion.py`
4. **Analysis**: `python scripts/run_baselines.py`, `python scripts/run_pocket_analysis.py`
