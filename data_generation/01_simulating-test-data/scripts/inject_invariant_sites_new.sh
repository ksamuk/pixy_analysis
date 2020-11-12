#!/bin/bash

# injects missing invariant sites into a msprime vcf
# ks may 2019

vcfdir="data/accuracy_var_only"
outdir="data/accuracy_invar"

mkdir -p inject_tmp
mkdir -p $outdir

# list the vcf files
# generate lists of 100
ls data/accuracy_var_only/* > inject_tmp/vcf_files.tmp

cd inject_tmp

split -l 100 vcf_files.tmp vcf_files_

cd ..

ls inject_tmp/vcf_files_* > inject_tmp/vcf_lists.tmp


# exemplar vcf file for building a fake invariants sites vcf
vcfex=$(cat inject_tmp/vcf_files.tmp | head -n 1) 

# parse the length of the sequence from the header
seq_length=$(grep length $vcfex | sed 's/.*length=//g' | sed 's/>//g')

# count the number of samples in the file
n_samples=$(grep "#CHROM" $vcfex  | awk '{print NF; exit}')

# there are 9 non-genotype columns
let n_samples=n_samples-9

# all the possible sites
sites=$(seq 1 $seq_length)
echo "$sites" | sort -V > inject_tmp/all_sites.tmp

# launch subjobs (each 100 vcfs)
while read vcflist
do

sbatch inject_list_of_vcfs.sh $vcflist

done < inject_tmp/vcf_lists.tmp





