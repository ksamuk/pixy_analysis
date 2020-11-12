#!/bin/bash
#SBATCH --mem=40GB
#SBATCH -p noor

#Step9: exclude two samples per populations, to get consistent sample size for both populations and avoid using any males

cd /work/klk37/vcfs
PATH=/datacommons/noor/klk37/java/jdk1.8.0_144/bin:$PATH
export PATH

/datacommons/noor/klk37/gatk-4.1.1.0/gatk --java-options "-Xmx80g" SelectVariants \
	-R /datacommons/noor/klk37/dxy_project/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa \
	-V chrX_allsites.vcf.gz \
	-xl-sn /datacommons/noor/klk37/dxy_project/excludesamples.args \
	-O chrX_36Ag_allsites.vcf.gz
