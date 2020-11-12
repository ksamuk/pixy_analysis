#!/usr/bin/bash
#SBATCH --mem=60GB
##############################################################################################
cd /datacommons/noor/klk37/dxy_project

#BFS
#Step 1: find a global estimate of the SFS
/datacommons/noor/klk37/angsd/angsd -bam bam_BFS.filelist -doSaf 1 -r X -anc Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa -GL 1 -P 24 -out BFS-thetasStep1-out
#get the maximum likelihood estimate of the SFS
/datacommons/noor/klk37/angsd/misc/realSFS BFS-thetasStep1-out.saf.idx -P 24 > BFS-thetasStep1-out.sfs

#Step2: Calculate thetas per site
/datacommons/noor/klk37/angsd/angsd -bam bam_BFS.filelist -out BFS-thetasStep1-out -doThetas 1 -doSaf 1 -pest BFS-thetasStep1-out.sfs -r X -anc Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa -GL 1

/datacommons/noor/klk37/angsd/misc/thetaStat print BFS-thetasStep1-out.thetas.idx 2>/dev/null |head

/datacommons/noor/klk37/angsd/misc/thetaStat do_stat BFS-thetasStep1-out.thetas.idx

#Step3: Estimate over windows -- making two passes in order to get ANGSD to include the first window:
/datacommons/noor/klk37/angsd/misc/thetaStat do_stat BFS-thetasStep1-out.thetas.idx -win 9999 -step 1 -outnames thetaBFS.thetasWin-1kb.gz
/datacommons/noor/klk37/angsd/misc/thetaStat do_stat BFS-thetasStep1-out.thetas.idx -win 9998 -step 1 -outnames thetaBFS.thetasWin-9998bp

#Now grab the relevant columns, window information and pairwise theta:
awk '{print $1, $2, $3, $5, $14}' thetaBFS.thetasWin-10kb.gz.pestPG > thetaBFS.thetasWin-10kb.pairwiseTheta.txt
awk '{print $1, $2, $3, $5, $14}' thetaBFS.thetasWin-9998bp.pestPG > thetaBFS.thetasWin-9998bp.pairwiseTheta.txt

##############################################################################################
# KES:

#Step 1: find a global estimate of the SFS
/datacommons/noor/klk37/angsd/angsd -bam bam_KES.filelist -doSaf 1 -r X -anc Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa -GL 1 -P 24 -out KES-thetasStep1-out
#get the maximum likelihood estimate of the SFS
/datacommons/noor/klk37/angsd/misc/realSFS KES-thetasStep1-out.saf.idx -P 24 > KES-thetasStep1-out.sfs

#Step2: Calculate thetas per site
/datacommons/noor/klk37/angsd/angsd -bam bam_KES.filelist -out KES-thetasStep1-out -doThetas 1 -doSaf 1 -pest KES-thetasStep1-out.sfs -r X -anc Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa -GL 1

/datacommons/noor/klk37/angsd/misc/thetaStat print KES-thetasStep1-out.thetas.idx 2>/dev/null |head

/datacommons/noor/klk37/angsd/misc/thetaStat do_stat KES-thetasStep1-out.thetas.idx

#Step3: Estimate over windows
/datacommons/noor/klk37/angsd/misc/thetaStat do_stat KES-thetasStep1-out.thetas.idx -win 9999 -step 1 -outnames thetaKES.thetasWin-1kb.gz
/datacommons/noor/klk37/angsd/misc/thetaStat do_stat KES-thetasStep1-out.thetas.idx -win 9998 -step 1 -outnames thetaKES.thetasWin-9998bp

#Now grab the relevant columns, window information and pairwise theta:
awk '{print $1, $2, $3, $5, $14}' thetaKES.thetasWin-10kb.gz.pestPG > thetaKES.thetasWin-10kb.pairwiseTheta.txt
awk '{print $1, $2, $3, $5, $14}' thetaKES.thetasWin-9998bp.pestPG > thetaKES.thetasWin-9998bp.pairwiseTheta.txt
