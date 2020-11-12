#!/usr/bin/bash
#SBATCH --mem=20GB


mkdir -p tmp
mkdir -p data

find ../simulating-test-data/data/simulated_var_only -type f > tmp/vcf_var_only.txt
find ../simulating-test-data/data/simulated_invar -type f > tmp/vcf_invar.txt
find ../simulating-test-data/data/simulated_missing_sites -type f > tmp/vcf_missing_sites.txt
find ../simulating-test-data/data/simulated_missing_genos -type f > tmp/vcf_missing_genos.txt
find ../simulating-test-data/data/accuracy_invar -type f > tmp/vcf_accuracy.txt

##rm -r data/var_only
##mkdir -p data/var_only
#
#while read vcf
#do
#
#mkdir -p tmp/1
#rm -r tmp/1
#vcfslug=$(echo $vcf | sed 's/.*\///g')
#echo $vcf
#
#python pixy.py --stats pi --vcf $vcf --zarr_path tmp/1 --window_size 10000 --populations populations_pi.txt --bypass_filtration yes --outfile_prefix data/var_only/$vcfslug
#
#rm -r tmp/1
#
#done < tmp/vcf_var_only.txt 
#
##rm -r data/invar
##mkdir -p data/invar
#
#while read vcf
#do
#
#mkdir -p tmp/1
#rm -r tmp/1
#vcfslug=$(echo $vcf | sed 's/.*\///g')
#echo $vcf
#
#python pixy.py --stats pi --vcf $vcf --zarr_path tmp/1 --window_size 10000 --populations populations_pi.txt --bypass_filtration yes --outfile_prefix data/invar/$vcfslug
#
#rm -r tmp/1  
#
#done < tmp/vcf_invar.txt
#
##rm -r data/missing_sites
##mkdir -p data/missing_sites
#
#while read vcf
#do
#
#mkdir -p tmp/1
#rm -r tmp/1
#vcfslug=$(echo $vcf | sed 's/.*\///g')
#echo $vcf
#
#python pixy.py --stats pi --vcf $vcf --zarr_path tmp/1 --window_size 10000 --populations populations_pi.txt --bypass_filtration yes --outfile_prefix data/missing_sites/$vcfslug
#
#rm -r tmp/1  
#
#done < tmp/vcf_missing_sites.txt
#
#
##rm -r data/missing_genos
##mkdir -p data/missing_genos
#
#while read vcf
#do
#
#mkdir -p tmp/1
#rm -r tmp/1
#vcfslug=$(echo $vcf | sed 's/.*\///g')
#echo $vcf
#
#python pixy.py --stats pi --vcf $vcf --zarr_path tmp/1 --window_size 10000 --populations populations_pi.txt --bypass_filtration yes --outfile_prefix data/missing_genos/$vcfslug
#
#rm -r tmp/1   
#
#done < tmp/vcf_missing_genos.txt



mkdir -p data/accuracy_invar
while read vcf
do

mkdir -p tmp/1
rm -r tmp/1
vcfslug=$(echo $vcf | sed 's/.*\///g')
echo $vcf

python pixy.py --stats pi --vcf $vcf --zarr_path tmp/1 --window_size 10000 --populations populations_pi.txt --bypass_filtration yes --outfile_prefix data/accuracy_invar/$vcfslug

rm -r tmp/1   

done < tmp/vcf_accuracy.txt

