#!/usr/bin/bash
#SBATCH --mem=20GB

mkdir -p tmp
mkdir -p data
mkdir -p data/ag1000

python pixy.py --stats pi dxy \
--vcf ../../data/ag1000/chrX_36Ag_allsites_filtered.vcf.gz \
--zarr_path tmp/X \
--window_size 10000 \
--populations Ag1000_sampleIDs_popfile.txt \
--outfile_prefix data/ag1000/ag1000_ \
--variant_filter_expression "DP>=10,GQ>30" \
--invariant_filter_expression "DP>=10,RGQ>30" 














