Applying ANGSD to Anopheles test data.

#### Dxy using Joshua Penalba's script for calculating Dxy from ANGSD mafs: https://github.com/mfumagalli/ngsPopGen/blob/master/scripts/calcDxy.R

Applying the script according to the recommendations on the above GitHub:
- Step 1. angsd_dxy_step1_prepmafs_04242020.sh - Run ANGSD with all populations with -SNP_pval and -skipTriallelic flags. Use the ref allele as the major allele ("-doMajorMinor 4"). Discard genotypes with Q score below 30 or depth below 10.

- Step 2. angsd_dxy_step2_sitediversity_04242020.sh - Rerun ANGSD per population, using the -sites flag with a file corresponding to the recovered SNPs. This guarantees that sites with an allele fixed in one population are still included. 
Note: To make the sites file, grab the 1st and 2nd columns of the output from the previous step (*mafs.gz); remove the header; run “angsd sites index sitesfile.txt

- Step 3. Gunzip the resulting mafs files and run script: "/opt/apps/rhel7/R-3.6.0/bin/Rscript calcDxy.R -p angsdout_step2_BFS.mafs -q angsdout_step2_KES.mafs". This step makes “Dxy_persite.txt" and outputs a global Dxy (In this case, "Global dxy is: 291027.696983545")
Note: The global Dxy is the sum of Dxy for all sites in the input. The user provides maf files for each population and optionally provides a “total length” parameter (t), which (if provided) serves as the denominator for the global per site Dxy estimate. This makes this method’s accuracy and reproducibility dependent on the user correctly tallying and reporting the number of supported invariant sites.

- Step 4. angsd_dxy_step3_processoutputoverwindows_04242020.pl - Custom perl script to average the persite output over windows. For 10kb windows I ran: perl angsd_dxy_step3_processoutputoverwindows_04242020.pl Dxy_persite.txt 10000

The output is chrX_angsd_DxySummary.txt, which includes an avg Dxy per window using the total # of sites as the denominator, and an estimate using the # of sites with data as the denominator.

###### Within population diversity using the strategy documented by ANGSD here: http://www.popgen.dk/angsd/index.php/Thetas,Tajima,Neutrality_tests 

Commands are in run_angsdThetas_BFS_KES.sh -- use the final output of this script to run each population through angsd_processoutput_pairwiseThetas.pl (custom perl script for parsing).

The final result is two files (chrX_angsd_piSummary_thetaBFS.thetasWin-10kb.pairwiseTheta and chrX_angsd_piSummary_thetaKES.thetasWin-10kb.pairwiseTheta ) where pi is tP/nSites.