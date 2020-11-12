#!/bin/bash
#SBATCH --mem=40GB

#Step5: Mark duplicates

cd /work/klk37/bams

BAMs=*_RG.bam
for BAM in $BAMs
do
	#name="$(echo ${R1} | awk -F'[_' '{print $1}')"
	name="$(echo ${BAM} | grep -oP '.*(?=_RG.bam)')"
	echo "working on $name"
	OUT="$name"_dedup_reads.bam
	MET="$name"_dedup_metrics.txt
	runscript="$name"_runstep5.sh
	echo "#!/bin/bash" >> $runscript
	echo "#SBATCH --mem=30GB" >> $runscript
	echo -e "/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar MarkDuplicates \\" >> $runscript
	echo -e "\tINPUT=$BAM \\" >> $runscript
	echo -e "\tOUTPUT=$OUT \\" >> $runscript
	echo -e "\tMETRICS_FILE=$MET" >> $runscript
	echo -e "\t/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar BuildBamIndex \\" >> $runscript
	echo -e "\tINPUT=$OUT" >> $runscript
	sbatch $runscript
done
