#!/usr/bin/bash
#SBATCH --mem=20GB
##############################################################################################
# Runs vcftools --window-pi on the BFS population

mkdir -p tmp
mkdir -p data

#find ../simulating-test-data/data/simulated_invar -type f | grep "10000_16_invar" > tmp/vcf_invar.txt
#find ../simulating-test-data/data/simulated_missing_sites -type f | grep "10000_16_invar" > tmp/vcf_missing_sites.txt
find ../simulating-test-data/data/reruns -type f > tmp/vcf_missing_genos.txt


# mkdir -p data/invar

# while read vcf
# do

# vcfslug=$(echo $vcf | sed 's/.*\///g')

# vcftools --gzvcf $vcf --window-pi 10000 --chr 1 --out data/invar/$vcfslug

# done < tmp/vcf_invar.txt


# mkdir -p data/missing_sites

# while read vcf
# do

# vcfslug=$(echo $vcf | sed 's/.*\///g')
# vcftools --gzvcf $vcf --window-pi 10000 --chr 1 --out data/missing_sites/$vcfslug

# done < tmp/vcf_missing_sites.txt



mkdir -p data/missing_genos

while read vcf
do

vcfslug=$(echo $vcf | sed 's/.*\///g')
vcftools --gzvcf $vcf --window-pi 10000 --chr 1 --out data/missing_genos/$vcfslug

done < tmp/vcf_missing_genos.txt

