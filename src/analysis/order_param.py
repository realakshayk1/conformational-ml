"""State-contrast collective variables for the rare-state benchmark (Phases A & B).

A conformer is scored by how close a flexible REGION sits to a TARGET-state reference
vs a GROUND-state reference, after superposing on the stable core. It is
"target-state-like" iff
    rmsd_to_target < rmsd_to_ground - margin
where `margin` is calibrated ONCE on the reference structures and then frozen. Nothing
here is tuned against generator output.

Targets:
  * T4L L99A : target = 2LC9 excited state (F/G helix), ground = 1L83.
  * KRAS G12D: target = MRTX1133-bound switch-II-OPEN (7RPZ/8DNI), ground = 6WS4 GDP apo.

Usage:
    from src.analysis.order_param import StateContrastCV
    cv = StateContrastCV.from_config("configs/evaluation/t4l_excited_state.yaml")
    res = cv.score("conformer.pdb")          # or cv.score_coords(ca_by_resid_dict)
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
    """Superpose `mobile` onto `ref` using the alignment (core) subsets, then return
    the RMSD over the measurement (region) atoms."""
    mu_m, mu_r = align_mobile.mean(0), align_ref.mean(0)
    R = _kabsch_rotation(align_mobile - mu_m, align_ref - mu_r)
    moved = (mobile - mu_m) @ R + mu_r
    diff = moved - ref
    return float(np.sqrt((diff * diff).sum(axis=1).mean()))


# ---------------------------------------------------------------------------
# Structure loading (CA by residue, altloc-deduped)
# ---------------------------------------------------------------------------
def ca_by_resid(pdb_path: str, model: int = 0) -> Dict[int, np.ndarray]:
    """Return {resid: CA xyz} for one model of a PDB, deduping altlocs/chains."""
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


def _all_models(pdb_path: str) -> List[Dict[int, np.ndarray]]:
    return [ca_by_resid(pdb_path, m) for m in range(n_models(pdb_path))]


@dataclass
class CVResult:
    rmsd_to_target: float        # min over all target-state reference models
    rmsd_to_ground: float        # min over all ground-state reference models
    target_like: Optional[bool]  # None until margin is frozen

    @property
    def delta(self) -> float:
        return self.rmsd_to_ground - self.rmsd_to_target


class StateContrastCV:
    def __init__(self, target_pdbs: List[str], ground_pdbs: List[str],
                 region: List[int], core_exclude: List[int],
                 margin: Optional[float] = None):
        self.region = list(region)
        self.core_exclude = set(core_exclude)
        self.margin = margin
        self.target_models = [m for p in target_pdbs for m in _all_models(p)]
        self.ground_models = [m for p in ground_pdbs for m in _all_models(p)]

    @classmethod
    def from_config(cls, config_path: str, repo_root: Optional[str] = None) -> "StateContrastCV":
        import yaml
        if repo_root is None:
            repo_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        with open(config_path) as fh:
            cfg = yaml.safe_load(fh)
        c = cfg["contrast"]
        def rp(p):
            return p if os.path.isabs(p) else os.path.join(repo_root, p)
        return cls(
            target_pdbs=[rp(p) for p in c["target_state_pdbs"]],
            ground_pdbs=[rp(p) for p in c["ground_state_pdbs"]],
            region=c["region_residues"],
            core_exclude=c["alignment_core_exclude"],
            margin=c.get("margin_angstrom"),
        )

    def _rmsd_to_ref(self, query: Dict[int, np.ndarray], ref: Dict[int, np.ndarray]) -> float:
        shared = sorted(set(query) & set(ref))
        region = [r for r in self.region if r in shared]
        core = [r for r in shared if r not in self.core_exclude]
        if len(region) < 3 or len(core) < 10:
            return float("nan")
        return _superpose_rmsd(_stack(query, region), _stack(ref, region),
                               _stack(query, core), _stack(ref, core))

    def score_coords(self, query: Dict[int, np.ndarray]) -> CVResult:
        r_target = min(self._rmsd_to_ref(query, m) for m in self.target_models)
        r_ground = min(self._rmsd_to_ref(query, m) for m in self.ground_models)
        like = None
        if self.margin is not None:
            like = bool(r_target < r_ground - self.margin)
        return CVResult(rmsd_to_target=r_target, rmsd_to_ground=r_ground, target_like=like)

    def score(self, pdb_path: str, model: int = 0) -> CVResult:
        return self.score_coords(ca_by_resid(pdb_path, model))


def calibrate_threshold(cv: "StateContrastCV", reference_pdbs: Dict[str, str]) -> dict:
    """Report CV values for reference structures so the margin can be frozen.

    Target references must come out target-like; ground references must not. The
    separation between the two sets sets the margin.
    """
    rows = {}
    for name, path in reference_pdbs.items():
        vals = [cv.score(path, m) for m in range(n_models(path))]
        rows[name] = {
            "n_models": n_models(path),
            "mean_rmsd_to_target": float(np.nanmean([v.rmsd_to_target for v in vals])),
            "mean_rmsd_to_ground": float(np.nanmean([v.rmsd_to_ground for v in vals])),
            "mean_delta": float(np.nanmean([v.delta for v in vals])),
        }
    return rows
