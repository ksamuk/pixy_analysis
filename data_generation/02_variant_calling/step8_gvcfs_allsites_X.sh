#!/bin/bash
#SBATCH --mem=80GB
#SBATCH -p noor

#Step8: GenotypeGVCFs to create a genotyped allsites VCF for the X chromosome

cd /work/klk37/bams
PATH=/datacommons/noor/klk37/java/jdk1.8.0_144/bin:$PATH
export PATH

/datacommons/noor/klk37/gatk-4.1.1.0/gatk --java-options "-Xmx80g" GenotypeGVCFs \
	-R /datacommons/noor/klk37/dxy_project/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa \
	-V gendb://X_allsamples_genomicsdb \
	-all-sites \
	-L X \
	-O chrX_allsites.vcf.gz
