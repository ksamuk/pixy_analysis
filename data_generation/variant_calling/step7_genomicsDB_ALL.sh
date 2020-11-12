#!/bin/bash
#SBATCH --mem=10GB
cd /work/klk37/bams/
PATH=/datacommons/noor/klk37/java/jdk1.8.0_144/bin:\$PATH
export PATH
#Step7: Create initial GenomicsDB for each chromosome

CHRS=(2R 2L 3R 3L X)
for CHR in "${CHRS[@]}"
do
	OUT="$CHR"_allsamples_genomicsdb
	runscript="$CHR"_runstep7.sh
	file1=Agam_BFS_ERS224670_dedup_reads-chr"$CHR"-g.vcf.gz
	file2=Agam_BFS_ERS224248_dedup_reads-chr"$CHR"-g.vcf.gz
	file3=Agam_BFS_ERS224089_dedup_reads-chr"$CHR"-g.vcf.gz
	file4=Agam_BFS_ERS224283_dedup_reads-chr"$CHR"-g.vcf.gz
	file5=Agam_BFS_ERS224294_dedup_reads-chr"$CHR"-g.vcf.gz
	file6=Agam_BFS_ERS224165_dedup_reads-chr"$CHR"-g.vcf.gz
	file7=Agam_BFS_ERS224095_dedup_reads-chr"$CHR"-g.vcf.gz
	file8=Agam_BFS_ERS224295_dedup_reads-chr"$CHR"-g.vcf.gz
	file9=Agam_BFS_ERS224227_dedup_reads-chr"$CHR"-g.vcf.gz
	file10=Agam_BFS_ERS223790_dedup_reads-chr"$CHR"-g.vcf.gz
	file11=Agam_BFS_ERS223797_dedup_reads-chr"$CHR"-g.vcf.gz
	file12=Agam_BFS_ERS223771_dedup_reads-chr"$CHR"-g.vcf.gz
	file13=Agam_BFS_ERS223827_dedup_reads-chr"$CHR"-g.vcf.gz
	file14=Agam_BFS_ERS223759_dedup_reads-chr"$CHR"-g.vcf.gz
	file15=Agam_BFS_ERS223750_dedup_reads-chr"$CHR"-g.vcf.gz
	file16=Agam_BFS_ERS224771_dedup_reads-chr"$CHR"-g.vcf.gz
	file17=Agam_BFS_ERS223967_dedup_reads-chr"$CHR"-g.vcf.gz
	file18=Agam_BFS_ERS223970_dedup_reads-chr"$CHR"-g.vcf.gz
	file19=Agam_BFS_ERS223924_dedup_reads-chr"$CHR"-g.vcf.gz
	file20=Agam_BFS_ERS224776_dedup_reads-chr"$CHR"-g.vcf.gz
	file21=Agam_KES_ERS224300_dedup_reads-chr"$CHR"-g.vcf.gz
	file22=Agam_KES_ERS224168_dedup_reads-chr"$CHR"-g.vcf.gz
	file23=Agam_KES_ERS224314_dedup_reads-chr"$CHR"-g.vcf.gz
	file24=Agam_KES_ERS224235_dedup_reads-chr"$CHR"-g.vcf.gz
	file25=Agam_KES_ERS224245_dedup_reads-chr"$CHR"-g.vcf.gz
	file26=Agam_KES_ERS224206_dedup_reads-chr"$CHR"-g.vcf.gz
	file27=Agam_KES_ERS224153_dedup_reads-chr"$CHR"-g.vcf.gz
	file28=Agam_KES_ERS224091_dedup_reads-chr"$CHR"-g.vcf.gz
	file29=Agam_KES_ERS224105_dedup_reads-chr"$CHR"-g.vcf.gz
	file30=Agam_KES_ERS224112_dedup_reads-chr"$CHR"-g.vcf.gz
	file31=Agam_KES_ERS224167_dedup_reads-chr"$CHR"-g.vcf.gz
	file32=Agam_KES_ERS224209_dedup_reads-chr"$CHR"-g.vcf.gz
	file33=Agam_KES_ERS224224_dedup_reads-chr"$CHR"-g.vcf.gz
	file34=Agam_KES_ERS224109_dedup_reads-chr"$CHR"-g.vcf.gz
	file35=Agam_KES_ERS224137_dedup_reads-chr"$CHR"-g.vcf.gz
	file36=Agam_KES_ERS224217_dedup_reads-chr"$CHR"-g.vcf.gz
	file37=Agam_KES_ERS224218_dedup_reads-chr"$CHR"-g.vcf.gz
	file38=Agam_KES_ERS224115_dedup_reads-chr"$CHR"-g.vcf.gz
	file39=Agam_KES_ERS224205_dedup_reads-chr"$CHR"-g.vcf.gz
	file40=Agam_KES_ERS224170_dedup_reads-chr"$CHR"-g.vcf.gz

	echo "#!/bin/bash" >> $runscript
	echo "#SBATCH --mem=40GB" >> $runscript
	echo "cd /work/klk37/bams" >> $runscript
	echo "PATH=/datacommons/noor/klk37/java/jdk1.8.0_144/bin:\$PATH" >> $runscript
	echo "export PATH" >> $runscript
	echo -e "/datacommons/noor/klk37/gatk-4.1.1.0/gatk --java-options \"-Xmx80g -Xms40g\" GenomicsDBImport \\" >> $runscript
	echo -e "\t-V $file1 \\" >> $runscript
	echo -e "\t-V $file2 \\" >> $runscript
	echo -e "\t-V $file3 \\" >> $runscript
	echo -e "\t-V $file4 \\" >> $runscript
	echo -e "\t-V $file5 \\" >> $runscript
	echo -e "\t-V $file6 \\" >> $runscript
	echo -e "\t-V $file7 \\" >> $runscript
	echo -e "\t-V $file8 \\" >> $runscript
	echo -e "\t-V $file9 \\" >> $runscript
	echo -e "\t-V $file10 \\" >> $runscript
	echo -e "\t-V $file11 \\" >> $runscript
	echo -e "\t-V $file12 \\" >> $runscript
	echo -e "\t-V $file13 \\" >> $runscript
	echo -e "\t-V $file14 \\" >> $runscript
	echo -e "\t-V $file15 \\" >> $runscript
	echo -e "\t-V $file16 \\" >> $runscript
	echo -e "\t-V $file17 \\" >> $runscript
	echo -e "\t-V $file18 \\" >> $runscript
	echo -e "\t-V $file19 \\" >> $runscript
	echo -e "\t-V $file20 \\" >> $runscript
	echo -e "\t-V $file21 \\" >> $runscript
	echo -e "\t-V $file22 \\" >> $runscript
	echo -e "\t-V $file23 \\" >> $runscript
	echo -e "\t-V $file24 \\" >> $runscript
	echo -e "\t-V $file25 \\" >> $runscript
	echo -e "\t-V $file26 \\" >> $runscript
	echo -e "\t-V $file27 \\" >> $runscript
	echo -e "\t-V $file28 \\" >> $runscript
	echo -e "\t-V $file29 \\" >> $runscript
	echo -e "\t-V $file30 \\" >> $runscript
	echo -e "\t-V $file31 \\" >> $runscript
	echo -e "\t-V $file32 \\" >> $runscript
	echo -e "\t-V $file33 \\" >> $runscript
	echo -e "\t-V $file34 \\" >> $runscript
	echo -e "\t-V $file35 \\" >> $runscript
	echo -e "\t-V $file36 \\" >> $runscript
	echo -e "\t-V $file37 \\" >> $runscript
	echo -e "\t-V $file38 \\" >> $runscript
	echo -e "\t-V $file39 \\" >> $runscript
	echo -e "\t-V $file40 \\" >> $runscript
	echo -e "\t--genomicsdb-workspace-path $OUT \\" >> $runscript
	echo -e "\t-L $CHR" >> $runscript
	sbatch $runscript
done
