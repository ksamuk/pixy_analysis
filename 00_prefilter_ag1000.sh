#!/bin/bash

# prefilter the ag1000g VCF using bcftools

bcftools view --exclude-types indels --max-alleles 2 data/ag1000/chrX_36Ag_allsites_filtered.vcf.gz | bcftools +setGT - -- -n . -t q -e 'FORMAT/DP>=10&(GQ>=30|RGQ>=30)' | bgzip -c > data/ag1000/chrX_36Ag_allsites_filtered.vcf.gz

cd data/ag1000

tabix chrX_36Ag_allsites_filtered.vcf.gz