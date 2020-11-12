#!/bin/bash

# simulate test data for evaluating the effect of missing data

# generate 100 datasets
python scripts/msprime_simulate_data.py --prefix data/simulated_var_only/pi_sim_ --datasets 100

# for each dataset, inject invariant sites 
# (automatically loops through all files in a folder)
sh scripts/inject_invariant_sites.sh data/simulated_var_only data/simulated_invar

# generate missing datasets from invariant data

# get list of simulated data
ls data/simulated_invar/* > invar_list.txt

# apply missingness script to each file for each level of missingness
while read invar_vcf

do

	for i in $(seq 0 100 10000)
	do
		echo $i
	
		#((i = $i * 100))

		sh scripts/create_missing_sites.sh $invar_vcf $i data/simulated_missing_sites/$i
	
	done
	
done < invar_list.txt
