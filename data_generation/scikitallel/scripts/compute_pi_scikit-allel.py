#!/usr/bin/env python
# coding: utf-8

# In[8]:


import allel
import zarr
import argparse
import re
import sys
import os


# In[9]:


# parse the vcf location from the command line
parser = argparse.ArgumentParser(description='Wrapper to compute pi with scikit-allel for simulated data')
parser.add_argument('--vcf', type=str, nargs='?', help='Path to the input VCF', required=True)
args = parser.parse_args()

# test value
#args = parser.parse_args('--vcf ../../simulating-test-data/data/simulated_invar/pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_0_invar.vcf.gz'.split())

# parse the arguments
# chromosome is always '1' in our simulated data
chromosome = '1'
vcf_path = args.vcf
zarr_path = 'data/zarr/' + re.sub('.*/|.vcf.*', '', vcf_path) + '.zarr'


# In[10]:


# generate the zarr array 
allel.vcf_to_zarr(vcf_path, zarr_path, group=chromosome, fields='*', log=sys.stdout, overwrite=True)
callset = zarr.open_group(zarr_path, mode='r')


# In[11]:


# get a list of samples from the callset
samples = callset[chromosome + '/samples'][:]
samples_list = list(samples)
#print('VCF samples:', samples_list)


# In[12]:



# window size
# this is fixed (1-10000) in our simulated data
window_start = 1
window_end = 10000
window_range = list(range(window_start, window_end))

# the genotype calls
# recode the gt matrix as a Dask array (saves memory)
gt_dask = allel.GenotypeDaskArray(callset[chromosome + '/calldata/GT'])
gt_array = allel.GenotypeArray(gt_dask).to_packed()
gt_array = allel.GenotypeArray.from_packed(gt_array)

pos_array = allel.SortedIndex(callset[chromosome + '/variants/POS'])
loc_region = pos_array.locate_range(window_start, window_end)
gt_region = gt_array[loc_region]

# 50 = number of samples
# gt_pop = gt_region.take(range(0,50), axis=1)


# In[13]:


# create pi name via the prefix
sci_pi_file = "data/pi_out/allel_" + re.sub('.*/|_invar.*', '', vcf_path) +"_pi.txt"
outfile = open(sci_pi_file, 'w')
outfile.write("filename" + "\t" + "chromosome" + "\t" + "window_pos_1" + "\t" + "window_pos_2" + "\t" + "sk_allel_avg_pi" + "\t" + "sk_allel_no_sites" + "\n")

# compute pi (for the whole region)
hap = gt_region.to_haplotypes() 
ac = hap.count_alleles()
pi_est = allel.sequence_diversity(window_range, ac) 

# write to file
outfile.write(re.sub('.*/|.vcf.*', '', vcf_path) + "\t" + str(chromosome) + "\t" + str(window_start) + "\t" + str(window_end) + "\t" + str(pi_est) + "\t" + str(len(gt_region)) + "\n")
outfile.close()

# nuke zarr folder
os.system("rm -r " + zarr_path)

