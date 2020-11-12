#!/bin/bash
#Step 1: Generate unmapped BAM (uBAM) files from the raw sequences found in paired fastq files

cd /work/klk37/

R1S=*_1.fastq.gz
for R1 in $R1S
do
	name="$(echo ${R1} | grep -oP '.*(?=_1.fastq.gz)')"
	echo "working on $name"
	R2="$name"_2.fastq.gz
	runscript="$name"_runstep1.sh
	echo "#!/bin/bash" >> $runscript
	echo "#SBATCH --mem=30GB" >> $runscript
	echo "/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -Xmx8G -jar /datacommons/noor/klk37/picard.jar FastqToSam \\" >> $runscript
	echo -e "\tF1=$R1 \\" >> $runscript
	echo -e "\tF2=$R2 \\" >> $runscript
	echo -e "\tO="$name"_unaligned_read_pairs.bam \\" >> $runscript
	echo -e "\tRG=$name \\" >> $runscript
	echo -e "\tSM=$name \\" >> $runscript
	echo -e "\tTMP_DIR=`pwd`/tmp" >> $runscript
	sbatch $runscript
done
