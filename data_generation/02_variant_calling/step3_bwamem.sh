#!/bin/bash
# Step3: SamToFastq, BWA-MEM, and MergeBamAlignment to generate a cleaned, sorted BAM file

cd /work/klk37/

BAMS=*_ubam_markadapters.bam
for BAM in $BAMS
do
	name="$(echo ${BAM} | grep -oP '.*(?=_ubam_markadapters.bam)')"
	echo "working on $name"
	runscript="$name"_runstep3.sh
	echo "#!/bin/bash" >> $runscript
    echo "#SBATCH --mem=30GB" >> $runscript
	echo "/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -Xmx8G -jar /datacommons/noor/klk37/picard.jar SamToFastq \\" >> $runscript
	echo -e "\tI=$BAM \\" >> $runscript
	echo -e "\tFASTQ=/dev/stdout \\" >> $runscript
	echo -e "\tCLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true \\" >> $runscript
	echo -e "\tTMP_DIR=`pwd`/tmp | \\" >> $runscript
	echo -e "\t/opt/apps/rhel7/bwa-0.7.17/bwa mem -M -t 4 -p /datacommons/noor/klk37/dxy_project/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa.gz /dev/stdin | \\" >> $runscript
	echo -e "\t/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -Xmx16G -jar /datacommons/noor/klk37/picard.jar MergeBamAlignment \\" >> $runscript
	echo -e "\tALIGNED_BAM=/dev/stdin \\" >> $runscript
	echo -e "\tUNMAPPED_BAM="$name"_unaligned_read_pairs.bam \\" >> $runscript
	echo -e "\tOUTPUT="$name"_piped.bam \\" >> $runscript
	echo -e "\tR=/datacommons/noor/klk37/dxy_project/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa.gz CREATE_INDEX=true ADD_MATE_CIGAR=true \\" >> $runscript
	echo -e "\tCLIP_ADAPTERS=false CLIP_OVERLAPPING_READS=true \\" >> $runscript
	echo -e "\tINCLUDE_SECONDARY_ALIGNMENTS=true MAX_INSERTIONS_OR_DELETIONS=-1 \\" >> $runscript
	echo -e "\tPRIMARY_ALIGNMENT_STRATEGY=MostDistant ATTRIBUTES_TO_RETAIN=XS \\" >> $runscript
	echo -e "\tTMP_DIR=`pwd`/tmp" >> $runscript
	sbatch $runscript
done
