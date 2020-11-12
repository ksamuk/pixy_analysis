#!/bin/bash
#SBATCH --mem=40GB

#Step4.5: after merging the bams to get 1 bam per sample, ensure consistent read group naming within each sample

cd /work/klk37/bams
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224670.bam O=Agam_BFS_ERS224670_RG.bam ID=ERS224670 LB=ERS224670 PL=Illumina PU=ERS224670 SM=ERS224670 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224248.bam O=Agam_BFS_ERS224248_RG.bam ID=ERS224248 LB=ERS224248 PL=Illumina PU=ERS224248 SM=ERS224248 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224089.bam O=Agam_BFS_ERS224089_RG.bam ID=ERS224089 LB=ERS224089 PL=Illumina PU=ERS224089 SM=ERS224089 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224283.bam O=Agam_BFS_ERS224283_RG.bam ID=ERS224283 LB=ERS224283 PL=Illumina PU=ERS224283 SM=ERS224283 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224294.bam O=Agam_BFS_ERS224294_RG.bam ID=ERS224294 LB=ERS224294 PL=Illumina PU=ERS224294 SM=ERS224294 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224165.bam O=Agam_BFS_ERS224165_RG.bam ID=ERS224165 LB=ERS224165 PL=Illumina PU=ERS224165 SM=ERS224165 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224095.bam O=Agam_BFS_ERS224095_RG.bam ID=ERS224095 LB=ERS224095 PL=Illumina PU=ERS224095 SM=ERS224095 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224295.bam O=Agam_BFS_ERS224295_RG.bam ID=ERS224295 LB=ERS224295 PL=Illumina PU=ERS224295 SM=ERS224295 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224227.bam O=Agam_BFS_ERS224227_RG.bam ID=ERS224227 LB=ERS224227 PL=Illumina PU=ERS224227 SM=ERS224227 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223790.bam O=Agam_BFS_ERS223790_RG.bam ID=ERS223790 LB=ERS223790 PL=Illumina PU=ERS223790 SM=ERS223790 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223797.bam O=Agam_BFS_ERS223797_RG.bam ID=ERS223797 LB=ERS223797 PL=Illumina PU=ERS223797 SM=ERS223797 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223771.bam O=Agam_BFS_ERS223771_RG.bam ID=ERS223771 LB=ERS223771 PL=Illumina PU=ERS223771 SM=ERS223771 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223827.bam O=Agam_BFS_ERS223827_RG.bam ID=ERS223827 LB=ERS223827 PL=Illumina PU=ERS223827 SM=ERS223827 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223759.bam O=Agam_BFS_ERS223759_RG.bam ID=ERS223759 LB=ERS223759 PL=Illumina PU=ERS223759 SM=ERS223759 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223750.bam O=Agam_BFS_ERS223750_RG.bam ID=ERS223750 LB=ERS223750 PL=Illumina PU=ERS223750 SM=ERS223750 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224771.bam O=Agam_BFS_ERS224771_RG.bam ID=ERS224771 LB=ERS224771 PL=Illumina PU=ERS224771 SM=ERS224771 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223967.bam O=Agam_BFS_ERS223967_RG.bam ID=ERS223967 LB=ERS223967 PL=Illumina PU=ERS223967 SM=ERS223967 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223970.bam O=Agam_BFS_ERS223970_RG.bam ID=ERS223970 LB=ERS223970 PL=Illumina PU=ERS223970 SM=ERS223970 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS223924.bam O=Agam_BFS_ERS223924_RG.bam ID=ERS223924 LB=ERS223924 PL=Illumina PU=ERS223924 SM=ERS223924 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_BFS_ERS224776.bam O=Agam_BFS_ERS224776_RG.bam ID=ERS224776 LB=ERS224776 PL=Illumina PU=ERS224776 SM=ERS224776 \

/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224300.bam O=Agam_KES_ERS224300_RG.bam ID=ERS224300 LB=ERS224300 PL=Illumina PU=ERS224300 SM=ERS224300 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224168.bam O=Agam_KES_ERS224168_RG.bam ID=ERS224168 LB=ERS224168 PL=Illumina PU=ERS224168 SM=ERS224168 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224314.bam O=Agam_KES_ERS224314_RG.bam ID=ERS224314 LB=ERS224314 PL=Illumina PU=ERS224314 SM=ERS224314 \	
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224235.bam O=Agam_KES_ERS224235_RG.bam ID=ERS224235 LB=ERS224235 PL=Illumina PU=ERS224235 SM=ERS224235 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224245.bam O=Agam_KES_ERS224245_RG.bam ID=ERS224245 LB=ERS224245 PL=Illumina PU=ERS224245 SM=ERS224245 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224206.bam O=Agam_KES_ERS224206_RG.bam ID=ERS224206 LB=ERS224206 PL=Illumina PU=ERS224206 SM=ERS224206 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224153.bam O=Agam_KES_ERS224153_RG.bam ID=ERS224153 LB=ERS224153 PL=Illumina PU=ERS224153 SM=ERS224153 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224091.bam O=Agam_KES_ERS224091_RG.bam ID=ERS224091 LB=ERS224091 PL=Illumina PU=ERS224091 SM=ERS224091 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224105.bam O=Agam_KES_ERS224105_RG.bam ID=ERS224105 LB=ERS224105 PL=Illumina PU=ERS224105 SM=ERS224105 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224112.bam O=Agam_KES_ERS224112_RG.bam ID=ERS224112 LB=ERS224112 PL=Illumina PU=ERS224112 SM=ERS224112 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224167.bam O=Agam_KES_ERS224167_RG.bam ID=ERS224167 LB=ERS224167 PL=Illumina PU=ERS224167 SM=ERS224167 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224209.bam O=Agam_KES_ERS224209_RG.bam ID=ERS224209 LB=ERS224209 PL=Illumina PU=ERS224209 SM=ERS224209 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224224.bam O=Agam_KES_ERS224224_RG.bam ID=ERS224224 LB=ERS224224 PL=Illumina PU=ERS224224 SM=ERS224224 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224109.bam O=Agam_KES_ERS224109_RG.bam ID=ERS224109 LB=ERS224109 PL=Illumina PU=ERS224109 SM=ERS224109 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224137.bam O=Agam_KES_ERS224137_RG.bam ID=ERS224137 LB=ERS224137 PL=Illumina PU=ERS224137 SM=ERS224137 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224217.bam O=Agam_KES_ERS224217_RG.bam ID=ERS224217 LB=ERS224217 PL=Illumina PU=ERS224217 SM=ERS224217 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224218.bam O=Agam_KES_ERS224218_RG.bam ID=ERS224218 LB=ERS224218 PL=Illumina PU=ERS224218 SM=ERS224218 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224115.bam O=Agam_KES_ERS224115_RG.bam ID=ERS224115 LB=ERS224115 PL=Illumina PU=ERS224115 SM=ERS224115 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224205.bam O=Agam_KES_ERS224205_RG.bam ID=ERS224205 LB=ERS224205 PL=Illumina PU=ERS224205 SM=ERS224205 \
	
/datacommons/noor/klk37/java/jdk1.8.0_144/bin/java -jar /datacommons/noor/klk37/picard.jar AddOrReplaceReadGroups \
	I=Agam_KES_ERS224170.bam O=Agam_KES_ERS224170_RG.bam ID=ERS224170 LB=ERS224170 PL=Illumina PU=ERS224170 SM=ERS224170 \
	
