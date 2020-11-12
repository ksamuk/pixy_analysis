#!/bin/bash

#SBATCH --cpus-per-task=2
#SBATCH -p noor

Rscript 03_bind_scikit_files.R

# remove old zarr files
cd data
mkdir empty_dir/
rsync -a --delete empty_dir/ zarr/
rm -r empty_dir

