#!/usr/bin/bash
#SBATCH --mem=20GB
##############################################################################################
# Runs vcftools --window-pi on the BFS population

#cd /datacommons/noor/klk37/dxy_project

vcftools --gzvcf ../../data/ag1000/chrX_36Ag_allsites_filtered.vcf.gz --keep bfs_samples.txt --window-pi 10000 --chr X --out chrX-windowed-pi-vcftools_BFS.txt

