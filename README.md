# AdK Conformational Diffusion: Latent Space & Generative Modeling

Successfull implementation of a state-conditioned Denoising Diffusion Probabilistic Model (DDPM) for generating transition ensembles of Adenylate Kinase (AdK). The project combines representation learning with conditional generative modeling to explore the protein's conformational landscape.

## Scientific Questions

This project is built around two core scientific inquiries:
1. **Representation Learning**: Can we learn a low-dimensional latent representation of protein conformational space that captures biologically meaningful states more effectively than standard methods like PCA or UMAP?
2. **Generative Modeling**: Can a diffusion model, conditioned on these learned states, generate physically valid structural ensembles that reveal transient cryptic binding sites often invisible to static analysis?

## Description

The pipeline uses **Adenylate Kinase (AdK)** as a model system, well-known for its large-scale open/closed conformational transitions. We utilize ~60,000 frames of MD trajectories (Equilibrium, DIMS, and FRODA) from the `MDAnalysisData` package.

## Installation

### Requirements
- Python 3.10
- Conda (recommended)

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

### Representation & Dynamics
- **VAMP-2 Score**: **2.97** (Theoretical max 3.0), indicating excellent capture of the slowest dynamical modes.
- **Markovian Validation**: Passed the Chapman-Kolmogorov (CK) test at a lag time of 5.
- **State Axis**: GNN latent projection correlates with PCA PC1 at **r = 0.99**, providing a high-fidelity mapping of the closed-to-open transition.

### Generative Performance
- **Generative Fidelity**: Generated ensembles match real MD distributions for Radius of Gyration (Rg) within **~5%**.
- **Structural Integrity**: C\u03b1 virtual bond lengths are maintained at ~4.07\u00c5, ensuring physical validity.
- **Validation Loss**: Best MSE of **0.249** achieved at epoch 84.

### Pocket Analysis (PULCHRA + P2Rank)
We evaluated the ability to detect binding pockets across states in both generated and real ensembles:
| State        | Generated Freq | Real Freq | Druggability Score |
|--------------|----------------|-----------|--------------------|
| Closed       | 0.91           | 0.80      | 15.65              |
| Intermediate | 0.74           | 0.60      | 13.93              |
| Open         | 0.90           | 0.95      | 15.42              |

## Conclusions

Based on the Phase 2 results, we can answer our core scientific questions:

1. **Latent Representation**: Yes. The GNN-based latent space captures the transition pathway with significantly higher purity and correlation (r=0.99) than linear baselines, enabling a precise 1D mapping of the conformational axis.
2. **Generative Ensembles**: Yes. The conditional diffusion model generates state-specific ensembles that are physically valid and match MD statistics within 5%. 
3. **Cryptic Sites**: The analysis revealed that the dominant binding pocket is spatially conserved across states (displacement < 2.3\u00c5). However, the **intermediate state** exhibited notable pocket occlusion (lowest frequency & druggability score), confirming that transition states may naturally obscure binding sites during domain motion. No entirely new "cryptic" pockets were found, but the dynamic narrowing of the existing pocket was explicitly captured.

## Authors and Acknowledgment

This project was developed by the research team using the Antigravity AI coding assistant.

## License

This project is a private research repository. No open-source license is granted at this time.
