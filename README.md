# AdK Conformational Diffusion: Latent Space & Generative Modeling

Successfull implementation of a state-conditioned Denoising Diffusion Probabilistic Model (DDPM) for generating transition ensembles of Adenylate Kinase (AdK). The project combines representation learning with conditional generative modeling to explore the protein's conformational landscape.

## Description

This project addresses two core scientific questions:
1. Learning a latent representation of protein conformational space that captures biologically meaningful states (better than PCA or UMAP).
2. Training a diffusion model conditioned on those states to generate structural ensembles that reveal transient cryptic binding sites.

The pipeline uses **Adenylate Kinase (AdK)** as a model system, utilizing MD trajectories from the MDAnalysisData package (~60,000 frames total).

## Installation

### Requirements
- Python 3.10
- Conda (recommended for managing dependencies)

### Setup
1. Create and activate the conda environment:
   ```bash
   conda create -n adk python=3.10
   conda activate adk
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
   Dependencies include: `PyTorch`, `PyTorch Geometric`, `MDAnalysis`, `MDAnalysisData`, `numpy`, `scipy`, `matplotlib`, `seaborn`, `deeptime`/`PyEMMA`, `fpocket`/`MDpocket`.

## Project Structure

- `src/`:
    - `preprocessing/`: MD trajectory loading, C\u03b1 alignment, and featurization (pairwise distances).
    - `models/`: Implementation of Time-lagged Autoencoders (TAE), GNN encoders, and DDPM.
    - `analysis/`: Markov State Models (MSM), VAMP-2 scoring, CK tests, and pocket detection.
- `scripts/`: Training, validation, and evaluation scripts.
- `outputs/`:
    - `checkpoints/`: Optimized model weights.
    - `figures/`: Visualizations of training progress, latent landscapes, and evaluation results.
    - `ensembles/`: Generated structural ensembles for closed, intermediate, and open states.
    - `RESULTS_SUMMARY.md`: Detailed technical summary of findings.

## Usage

1. **Data Preprocessing**: Align trajectories and extract C\u03b1 coordinates.
   ```bash
   python scripts/extract_coordinates.py
   ```
2. **Representation Learning**: Train TAE and GNN to define the conformational state space.
   ```bash
   python scripts/train_tae.py
   python scripts/train_gnn.py
   ```
3. **Generative Modeling**: Train the conditional diffusion model.
   ```bash
   python scripts/train_diffusion.py
   ```
4. **Validation & Ensemble Generation**: Generate ensembles and validate physical properties (Rg, bond lengths).
   ```bash
   python scripts/generate_and_validate_ensembles.py
   ```
5. **Downstream Analysis**: Detect binding pockets and analyze state-specific features.
   ```bash
   python scripts/run_pocket_analysis.py
   ```

## Results Summary (v1.0-phase2)

- **Dynamical Capture**: VAMP-2 score of **2.97** (out of 3.0), passing the CK test for Markovian behavior.
- **State Definition**: GNN latent projection correlates with PCA PC1 at **r = 0.99**, successfully mapping the transition pathway.
- **Generative Fidelity**: Generated ensembles match real MD distributions for Radius of Gyration (Rg) within **~5%**.
- **Structural Integrity**: C\u03b1 virtual bond lengths are maintained at ~4.07\u00c5, ensuring physical validity.

## Authors and Acknowledgment

This project was developed by the research team using the Antigravity AI coding assistant.

## License

This project is a private research repository. No open-source license is granted at this time.
