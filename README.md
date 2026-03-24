# Conformational ML: AdK Dynamics and Generative Modeling

Successfull implementation of a state-conditioned Denoising Diffusion Probabilistic Model (DDPM) for generating transition ensembles of Adenylate Kinase (AdK). The model is conditioned on a latent representation learned via a Graph Neural Network (GNN) and validated against molecular dynamics (MD) trajectories.

## Project Structure

- `src/preprocessing/`: Data loading, alignment, and featurization (C\u03b1 distances).
- `src/models/`: Implementation of TAE, GNN, and Diffusion models.
- `src/analysis/`: MSM analysis, VAMP-2 scoring, CK tests, and pocket detection.
- `scripts/`: Training and validation scripts for all models.
- `outputs/`:
    - `checkpoints/`: Saved model weights for TAE, GNN, and DDPM.
    - `figures/`: Training curves, latent landscapes, and validation plots.
    - `ensembles/`: Generated structural ensembles for closed, intermediate, and open states.
    - `analysis/`: Results from Markov State Models and pocket detection.
    - `RESULTS_SUMMARY.md`: Detailed technical report of Phase 2 results.

## Installation

```bash
pip install -r requirements.txt
```

## Usage

1. **Preprocessing**: `python scripts/extract_coordinates.py`
2. **Verify Data**: `python scripts/verify_data.py`
3. **Train Baselines**: `python scripts/train_baselines.py`
4. **Train Representation**: `python scripts/train_tae.py`, `python scripts/train_gnn.py`
5. **Train Diffusion**: `python scripts/train_diffusion.py`
6. **Generate Ensembles**: `python scripts/generate_and_validate_ensembles.py`
7. **Analysis**: `python scripts/run_pocket_analysis.py`

## Results Summary (v1.0-phase2)

- **VAMP-2 Score**: 2.97 (capturing slow dynamical modes).
- **CK Test**: PASS (Markovian behavior at lag=5).
- **Latent Correlation**: r = 0.99 with PCA PC1 (Closed \u2194 Open axis).
- **Physical Validity**: Generated ensembles match real MD Radius of Gyration (Rg) within ~5%.
- **Pocket Analysis**: Successfully identified spatially conserved binding pockets across states.
