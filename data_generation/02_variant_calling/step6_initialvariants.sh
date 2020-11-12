#!/bin/bash
#SBATCH -p noor

#Step6: Create initial variant calls for each chromosome

cd /work/klk37/bams
PATH=/datacommons/noor/klk37/java/jdk1.8.0_144/bin:$PATH
export PATH

CHRS=(2R 2L 3R 3L X)
FILES=*.bam
for BAM in $FILES
do
	for CHR in "${CHRS[@]}"
	do
		ID="$(echo ${BAM} | awk -F'[.]' '{print $1}')"
		echo "calling variants for $ID"
		OUT="$ID"-chr"$CHR"-g.vcf.gz
		echo "$OUT"
		runscript="$ID"_"$CHR"_runstep6.sh
		echo "#!/bin/bash" >> $runscript
		echo "#SBATCH --mem=40GB" >> $runscript
		echo -e "/datacommons/noor/klk37/gatk-4.0.7.0/gatk --java-options "-Xmx100G" HaplotypeCaller \\" >> $runscript
		echo -e "\t-R /datacommons/noor/klk37/dxy_project/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa -I $BAM -O $OUT -ERC GVCF \\" >> $runscript
		echo -e "\t-L $CHR" >> $runscript
		sbatch $runscript
	done
done
