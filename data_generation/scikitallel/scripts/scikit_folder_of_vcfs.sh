#!/bin/bash

#SBATCH -J ska_folder-%j
#SBATCH -o tmp/ska_folder-%j.out


while read vcf
do

echo $vcf

python scripts/compute_dxy_scikit-allel.py --vcf $vcf
python scripts/compute_pi_scikit-allel.py --vcf $vcf

done < $1

