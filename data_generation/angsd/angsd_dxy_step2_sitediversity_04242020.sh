#!/usr/bin/bash
#SBATCH --mem=60GB
##############################################################################################
cd /datacommons/noor/klk37/dxy_project
#doMajorMinor 4 uses the ref allele as major
#skipTriallelic
#doMaf 1 calculated allele freq with fixed major/minor
#gl 2 uses genotype likelihoods based on GATK model
#doCounts 1
#minQ 30 discard bases with Q score below this threshold
#setMinDepthInd (requires doCounts)

#BFS:
/datacommons/noor/klk37/angsd/angsd -out angsdout_step2_BFS -bam bam_BFS.filelist -nInd 18 -r X -ref Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa -fai Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa.fai -doMajorMinor 4 -skipTriallelic -doMaf 1 -gl 2 -doCounts 1 -minQ 20 -only_proper_pairs 1 -setMinDepthInd 10 -sites sitesfile_angsd_step1.txt

##############################################################################################
#KES:
/datacommons/noor/klk37/angsd/angsd -out angsdout_step2_KES -bam bam_KES.filelist -nInd 18 -r X -ref Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa -fai Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa.fai -doMajorMinor 4 -skipTriallelic -doMaf 1 -gl 2 -doCounts 1 -minQ 20 -only_proper_pairs 1 -setMinDepthInd 10 -sites sitesfile_angsd_step1.txt
