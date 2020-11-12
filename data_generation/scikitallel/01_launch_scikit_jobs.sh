#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH -J sk_allel
#SBATCH -o tmp/pi_dxy_allel-%j.out

rm data/pi_out/*
rm data/dxy_out/*


#ls -d ../simulating-test-data/data/simulated_missing_genos/* > tmp/missing_genos_dir_list.txt
#ls -d ../simulating-test-data/data/simulated_missing_sites/* > tmp/missing_sites_dir_list.txt
#
#while read vcffolder 
#do
# 
#sbatch 02_scikit_dxy_pi_vcfolder.sh $vcffolder
# 
#done < tmp/missing_genos_dir_list.txt
#
#
#while read vcffolder 
#do
#
#sbatch 02_scikit_dxy_pi_vcfolder.sh $vcffolder
#
#done < tmp/missing_sites_dir_list.txt
#
#
#sbatch 02_scikit_dxy_pi_vcfolder.sh ../simulating-test-data/data/simulated_invar


sbatch 02_scikit_dxy_pi_vcfolder.sh ../simulating-test-data/data/accuracy_invar
