#!/bin/bash

#SBATCH --mem=12000
#SBATCH --cpus-per-task=18
#SBATCH -J pgeno
#SBATCH -o tmp/popgeno-%j.out

Rscript 02_compute_pi_vcf_folder.R $1 $2
