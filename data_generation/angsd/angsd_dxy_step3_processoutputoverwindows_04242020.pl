#!/usr/bin/perl -w
##################################################################
# Process output from calcDxy.R to get windowed Dxy
# AUTHOR: Katharine Korunes
# USAGE: perl angsd_step3_processoutput.pl Dxy_persite.txt WindowSize(Int)
#
# ##############################################################
use strict;

my $totalLen = 24393108; #For Anopheles X. Adjust if running on other chromosomes
my $win = "$ARGV[1]"; 

my $chr = "$ARGV[0]";
my $output = "chrX_angsd_DxySummary\.txt";
open (OUT, ">$output") or die "file not found $!";

my %snps;
open (CHR, $chr) or die "file not found $!\n";
while (<CHR>){
	my $line = $_;
	if ($line =~ m/^chromo/){ #header, so skip
		next;
	} else {
		my @fields = split (/\s+/, $line);
		my $position = $fields[1];
		my $dxy = $fields[2];
		$snps{$position} = $dxy;
	}
}
close (CHR);

#now get avg from each window
print OUT "Chrom\tWindowStart\tWindowEnd\tAvgOverAllSites\tAvgOverSitesWithDxyEstimate\n";
for (my $i = 1; $i <= ($totalLen - $win); $i += $win){
	my $start = $i;
	my $end = ($i + ($win - 1));
	my $sum = 0;
	my $withData = 0;
	for (my $x = $start; $x <= $end; $x++){
		if (exists $snps{$x}){
			my $val = $snps{$x};
			$withData++;
			$sum = ($sum + $val);
		}
	} 
	my $avg = ($sum/$win);
	my $avgSitesWithData = 0;
	if ($withData > 0){
		$avgSitesWithData = ($sum/$withData);
	}
	print OUT "chrX\t$start\t$end\t$avg\t$avgSitesWithData\n";
}
close OUT;

exit;
