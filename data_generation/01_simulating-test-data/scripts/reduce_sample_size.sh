#!/bin/bash

# randomly drops a set number of lines from a vcf
# ks may 2019


# (zipped) vcf name, no. individuals to retain, output dir
vcforig=$1
retain=$2
outdir=$3

# prepare vcf for processing
mkdir -p data/missing_tmp
#gunzip -c data/simulated_invar/pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_0_invar.vcf.gz > data/missing_tmp/vcf_unzip.vcf
gunzip -c $vcforig > data/missing_tmp/vcf_unzip.vcf
vcf="data/missing_tmp/vcf_unzip.vcf"

# preserve header
grep "##" $vcf > data/missing_tmp/vcf_header.vcf
grep -v "##" $vcf > data/missing_tmp/vcf_tmp.vcf

# get the max column based of the number of retained samples
cutcolumn=`expr 9 + $retain`

# drop the specified number of lines
cat data/missing_tmp/vcf_tmp.vcf | cut -f1-$cutcolumn > data/missing_tmp/vcf_tmp2.vcf

# add the reduced file back below the header
cat data/missing_tmp/vcf_tmp2.vcf >> data/missing_tmp/vcf_header.vcf

# write to output folder
mkdir -p $outdir
outname=$(echo $vcforig | sed "s/\.vcf.gz/\.lowsample_n=${retain}.vcf/g" | sed 's/.*\///g' )
mv data/missing_tmp/vcf_header.vcf $outdir/$outname

# cleanup temp files
rm -r data/missing_tmp



