"""Collective variables for the T4L L99A excited-state benchmark (Phase A).

The excited state (PDB 2LC9, Bouvignies & Kay, Nature 2011) differs from the ground
state (1L83) by straightening of helices F and G near the engineered L99A cavity.
The primary CV measures, for a query conformer, the CA-RMSD of the F/G region after
superposing on the stable core, against the excited (2LC9) and ground (1L83) references.

A conformer is "excited-state-like" iff
    rmsd_to_2lc9 < rmsd_to_1l83 - margin
where `margin` is calibrated ONCE on the reference structures (see calibrate_threshold)
and then frozen. Nothing here is tuned against generator output.

Usage:
    from src.analysis.order_param import T4LExcitedCV
    cv = T4LExcitedCV.from_config("configs/evaluation/t4l_excited_state.yaml")
    result = cv.score("path/to/conformer.pdb")   # or score_coords(ca_by_resid)
"""
from __future__ import annotations

import os
import warnings
from dataclasses import dataclass
from typing import Dict, List, Optional

import numpy as np

warnings.filterwarnings("ignore")


# ---------------------------------------------------------------------------
# Geometry helpers
# ---------------------------------------------------------------------------
def _kabsch_rotation(P: np.ndarray, Q: np.ndarray) -> np.ndarray:
    """Optimal rotation aligning P onto Q (both Nx3, already centered)."""
    H = P.T @ Q
    U, _, Vt = np.linalg.svd(H)
    d = np.sign(np.linalg.det(Vt.T @ U.T))
    D = np.diag([1.0, 1.0, d])
    return U @ D @ Vt


def _superpose_rmsd(mobile: np.ndarray, ref: np.ndarray,
                    align_mobile: np.ndarray, align_ref: np.ndarray) -> float:
    """Superpose `mobile` onto `ref` using the alignment subsets, then return the
    RMSD over the (mobile, ref) measurement atoms.

    align_* define the core used to compute the transform; mobile/ref are the
    measurement atoms (the F/G region) the RMSD is reported over.
    """
    mu_m, mu_r = align_mobile.mean(0), align_ref.mean(0)
    R = _kabsch_rotation(align_mobile - mu_m, align_ref - mu_r)
    moved = (mobile - mu_m) @ R + mu_r
    diff = moved - ref
    return float(np.sqrt((diff * diff).sum(axis=1).mean()))


# ---------------------------------------------------------------------------
# Structure loading (CA by residue, altloc-deduped)
# ---------------------------------------------------------------------------
def ca_by_resid(pdb_path: str, model: int = 0) -> Dict[int, np.ndarray]:
    """Return {resid: CA xyz} for one model of a PDB, deduping altlocs/chains.

    Keeps the first CA seen per residue id (highest-occupancy altloc tends to be
    listed first), which is robust to the >1 CA/residue seen in some crystal files.
    """
    import MDAnalysis as mda

    u = mda.Universe(pdb_path)
    if len(u.trajectory) > 1:
        u.trajectory[model]
    ca = u.select_atoms("protein and name CA")
    out: Dict[int, np.ndarray] = {}
    for atom in ca:
        rid = int(atom.resid)
        if rid not in out:
            out[rid] = atom.position.astype(float)
    return out


def n_models(pdb_path: str) -> int:
    import MDAnalysis as mda
    return len(mda.Universe(pdb_path).trajectory)


def _stack(d: Dict[int, np.ndarray], resids: List[int]) -> np.ndarray:
    return np.array([d[r] for r in resids])


@dataclass
class CVResult:
    rmsd_to_2lc9: float          # min over excited-ensemble models
    rmsd_to_1l83: float
    excited_state_like: Optional[bool]   # None until margin is set


class T4LExcitedCV:
    def __init__(self, excited_pdb: str, ground_pdb: str,
                 fg_region: List[int], core_exclude: List[int],
                 margin: Optional[float] = None):
        self.fg_region = list(fg_region)
        self.core_exclude = set(core_exclude)
        self.margin = margin
        self.ground = ca_by_resid(ground_pdb)
        # excited reference is an NMR ensemble -> keep every model
        self.excited_models = [ca_by_resid(excited_pdb, m)
                               for m in range(n_models(excited_pdb))]

    @classmethod
    def from_config(cls, config_path: str, repo_root: Optional[str] = None) -> "T4LExcitedCV":
        import yaml
        if repo_root is None:
            repo_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        with open(config_path) as fh:
            cfg = yaml.safe_load(fh)
        def rp(p):
            return p if os.path.isabs(p) else os.path.join(repo_root, p)
        gt = cfg["ground_truth"]
        pcv = cfg["primary_cv"]
        return cls(
            excited_pdb=rp(gt["excited_state"]),
            ground_pdb=rp(gt["ground_state"]),
            fg_region=pcv["fg_region_residues"],
            core_exclude=pcv["alignment_core_exclude"],
            margin=pcv.get("margin_angstrom"),
        )

    def _rmsd_to_ref(self, query: Dict[int, np.ndarray], ref: Dict[int, np.ndarray]) -> float:
        # shared residues between query and ref
        shared = sorted(set(query) & set(ref))
        fg = [r for r in self.fg_region if r in shared]
        core = [r for r in shared if r not in self.core_exclude]
        if len(fg) < 3 or len(core) < 10:
            return float("nan")
        return _superpose_rmsd(_stack(query, fg), _stack(ref, fg),
                               _stack(query, core), _stack(ref, core))

    def score_coords(self, query: Dict[int, np.ndarray]) -> CVResult:
        r_ground = self._rmsd_to_ref(query, self.ground)
        r_excited = min(self._rmsd_to_ref(query, m) for m in self.excited_models)
        like = None
        if self.margin is not None:
            like = bool(r_excited < r_ground - self.margin)
        return CVResult(rmsd_to_2lc9=r_excited, rmsd_to_1l83=r_ground, excited_state_like=like)

    def score(self, pdb_path: str, model: int = 0) -> CVResult:
        return self.score_coords(ca_by_resid(pdb_path, model))


def calibrate_threshold(cv: "T4LExcitedCV", reference_pdbs: Dict[str, str]) -> dict:
    """Report CV values for the reference structures so the margin can be frozen.

    Excited references (2LC9 models, 3DMV/3DMX mimics) must come out excited-like;
    the ground reference (1L83) must not. Returns a summary dict.
    """
    rows = {}
    for name, path in reference_pdbs.items():
        nm = n_models(path)
        vals = [cv.score(path, m) for m in range(nm)]
        rows[name] = {
            "n_models": nm,
            "mean_rmsd_to_2lc9": float(np.nanmean([v.rmsd_to_2lc9 for v in vals])),
            "mean_rmsd_to_1l83": float(np.nanmean([v.rmsd_to_1l83 for v in vals])),
            "mean_delta": float(np.nanmean([v.rmsd_to_1l83 - v.rmsd_to_2lc9 for v in vals])),
        }
    return rows
