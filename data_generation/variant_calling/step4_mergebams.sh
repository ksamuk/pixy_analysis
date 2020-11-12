#!/bin/bash
#SBATCH --mem=50GB

#Step4: merge bams for each sample

cd /work/klk37/bams

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224300.bam \
	ERR323822_piped.bam ERR328551_piped.bam ERR328539_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224168.bam \
	ERR323746_piped.bam ERR326996_piped.bam ERR327008_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224314.bam \
	ERR323823_piped.bam ERR328540_piped.bam ERR328552_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224235.bam \
	ERR323777_piped.bam ERR327051_piped.bam ERR327063_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224245.bam \
	ERR323753_piped.bam ERR327003_piped.bam ERR327015_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224206.bam \
	ERR323773_piped.bam ERR327047_piped.bam ERR327059_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224153.bam \
	ERR317276_piped.bam ERR320203_piped.bam ERR320215_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224091.bam \
	ERR317271_piped.bam ERR320198_piped.bam ERR320210_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224105.bam \
	ERR317272_piped.bam ERR320199_piped.bam ERR320211_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224112.bam \
	ERR317274_piped.bam ERR320201_piped.bam ERR320213_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224167.bam \
	ERR323745_piped.bam ERR326995_piped.bam ERR327007_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224209.bam \
	ERR323747_piped.bam ERR326997_piped.bam ERR327009_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224224.bam \
	ERR323750_piped.bam ERR327000_piped.bam ERR327012_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224109.bam \
	ERR323700_piped.bam ERR327142_piped.bam ERR327154_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224137.bam \
	ERR323703_piped.bam ERR327145_piped.bam ERR327157_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224217.bam \
	ERR323748_piped.bam ERR326998_piped.bam ERR327010_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224218.bam \
	ERR323764_piped.bam ERR327026_piped.bam ERR327038_piped.bam ERR491356_piped.bam ERR495504_piped.bam ERR495516_piped.bam

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224115.bam \
	ERR317285_piped.bam ERR320224_piped.bam ERR320236_piped.bam ERR495826_piped.bam ERR502075_piped.bam ERR502171_piped.bam

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224205.bam \
	ERR323762_piped.bam ERR327024_piped.bam ERR327036_piped.bam ERR491354_piped.bam ERR495502_piped.bam ERR495514_piped.bam

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_KES_ERS224170.bam \
	ERR323757_piped.bam ERR327019_piped.bam ERR327031_piped.bam ERR491349_piped.bam ERR495497_piped.bam ERR495509_piped.bam

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224670.bam \
	ERR326992_piped.bam ERR328759_piped.bam ERR328771_piped.bam ERR491202_piped.bam ERR495686_piped.bam ERR501923_piped.bam

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224248.bam \
	ERR323754_piped.bam ERR327004_piped.bam ERR327016_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224089.bam \
	ERR327101_piped.bam ERR338379_piped.bam ERR338391_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224283.bam \
	ERR323817_piped.bam ERR328534_piped.bam ERR328546_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224294.bam \
	ERR323819_piped.bam ERR328536_piped.bam ERR328548_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224165.bam \
	ERR327112_piped.bam ERR338390_piped.bam ERR338402_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224095.bam \
	ERR327103_piped.bam ERR338381_piped.bam ERR338393_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224295.bam \
	ERR323820_piped.bam ERR328537_piped.bam ERR328549_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224227.bam \
	ERR323751_piped.bam ERR327001_piped.bam ERR327013_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223790.bam \
	ERR319996_piped.bam ERR327360_piped.bam ERR327372_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223797.bam \
	ERR319997_piped.bam ERR327361_piped.bam ERR327373_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223771.bam \
	ERR320019_piped.bam ERR328396_piped.bam ERR328408_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223827.bam \
	ERR320024_piped.bam ERR328401_piped.bam ERR328413_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223759.bam \
	ERR320043_piped.bam ERR328418_piped.bam ERR328430_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223750.bam \
	ERR320016_piped.bam ERR328393_piped.bam ERR328405_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224771.bam \
	ERR343475_piped.bam ERR343655_piped.bam ERR343667_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223967.bam \
	ERR328794_piped.bam ERR331929_piped.bam ERR331941_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223970.bam \
	ERR328827_piped.bam ERR331998_piped.bam ERR332010_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS223924.bam \
	ERR328777_piped.bam ERR331900_piped.bam ERR331912_piped.bam   

/opt/apps/rhel7/samtools-1.9/bin/samtools merge Agam_BFS_ERS224776.bam \
	ERR343476_piped.bam ERR343656_piped.bam ERR343668_piped.bam   
