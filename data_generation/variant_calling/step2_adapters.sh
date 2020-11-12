#!/bin/bash
#Step 2: Mark adapter sequences
cd /work/klk37/

BAMs=*.bam
for BAM in $BAMs
do
	#name="$(echo ${R1} | awk -F'[_' '{print $1}')"
	name="$(echo ${BAM} | grep -oP '.*(?=_unaligned_read_pairs.bam)')"
	echo "working on $name"
	MET="$name"_mark_adapters_metrics.txt
	OUT="$name"_ubam_markadapters.bam
	runscript="$name"_runstep2.sh
	echo "#!/bin/bash" >> $runscript
	echo "#SBATCH --mem=30GB" >> $runscript
	echo "/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -Xmx8G -jar /datacommons/noor/klk37/picard.jar MarkIlluminaAdapters \\" >> $runscript
	echo -e "\tINPUT=$BAM \\" >> $runscript
	echo -e "\tOUTPUT=$OUT \\" >> $runscript
	echo -e "\tMETRICS=$MET \\" >> $runscript
	echo -e "\tTMP_DIR=`pwd`/tmp" >> $runscript
	sbatch $runscript
done
