#!/bin/bash

# nuke old versions
rm scripts/compute_dxy_scikit-allel.py
rm scripts/compute_pi_scikit-allel.py

# convert to .py
jupyter nbconvert --to=python scripts/compute_dxy_scikit-allel.ipynb
jupyter nbconvert --to=python scripts/compute_pi_scikit-allel.ipynb