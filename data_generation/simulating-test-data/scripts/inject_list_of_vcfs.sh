#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH -J vcf_inject-%j
#SBATCH -o tmp/vcf_inject-%j.out

vcflist=$1
let n_samples=50
let seq_length=10000

while read vcf
do

# createa  temp dir
tdir=$(mktemp -d data/accuracy_invar/vcf.XXXXXXXXX)

#outfile=$(echo $vcf | sed 's/.vcf$/_invar.vcf.gz/g')
outfile=$(echo $vcf | sed 's/.vcf$/_invar.vcf.gz/g' | sed "s/accuracy_var_only/accuracy_invar/")

echo "injecting invariant sites into $vcf..."
echo "will write to $outfile..."
echo "$n_samples samples"
echo "$seq_length sites"

# sites with variants

var_sites=$(grep -v "#" $vcf | awk '{print $2}')
echo "$var_sites" | sort -V > $tdir/var_sites.tmp

# find sites that need invar
diff --new-line-format="" --unchanged-line-format="" inject_tmp/all_sites.tmp $tdir/var_sites.tmp | sort -V > $tdir/invar_sites.tmp

invar_sites=$(cat $tdir/invar_sites.tmp)

# create a VCF with all invariant sites

# the start of a blank row
row=".\t0\t1\t.\tPASS\t.\tGT"

while read site
do

	gt=$(printf '0|0\t%.0s' $(eval echo "{1..$n_samples}"))

	newline="1\t$site\t$row\t$gt"
	echo -e $newline >> $tdir/vcf_blank_spaces.vcf

done < $tdir/invar_sites.tmp

sed 's/\s/\t/g' $tdir/vcf_blank_spaces.vcf | sed 's/^[ \t]*//;s/[ \t]*$//' > $tdir/vcf_blank.vcf

grep "#" $vcf > $tdir/vcf_header.vcf

grep -v "#" $vcf > $tdir/vcf_variants.vcf

cat $tdir/vcf_blank.vcf $tdir/vcf_variants.vcf > $tdir/test_tmp.vcf

cat $tdir/test_tmp.vcf | sort -k1V,1 -k2n,2 > $tdir/test.vcf

cat $tdir/vcf_header.vcf $tdir/test.vcf | grep . | gzip -c > $outfile 

rm -r $tdir

echo "wrote to $outfile"

done < $vcflist


