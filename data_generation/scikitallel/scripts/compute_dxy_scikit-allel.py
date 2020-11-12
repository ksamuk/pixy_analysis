#!/usr/bin/env python
# coding: utf-8

# In[2]:


import allel
import zarr
import argparse
import re
import sys
import os


# In[18]:


# parse the vcf location from the command line
parser = argparse.ArgumentParser(description='Wrapper to compute dxy with scikit-allel for simulated data')
parser.add_argument('--vcf', type=str, nargs='?', help='Path to the input VCF', required=True)
#args = parser.parse_args()

# test value
#args = parser.parse_args('--vcf ../../simulating-test-data/data/simulated_missing_sites/100/pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_0_invar.missing_100.vcf'.split())
args = parser.parse_args()

# parse the arguments
# chromosome is always '1' in our simulated data
chromosome = '1'
vcf_path = args.vcf
zarr_path = 'data/zarr/' + re.sub('.*/|.vcf.*', '', vcf_path) + '.zarr'


# In[19]:


# generate the zarr array 
allel.vcf_to_zarr(vcf_path, zarr_path, group=chromosome, fields='*', log=sys.stdout, overwrite=True)
callset = zarr.open_group(zarr_path, mode='r')


# In[20]:


# get a list of samples from the callset
samples = callset[chromosome + '/samples'][:]
samples_list = list(samples)
#print('VCF samples:', samples_list)


# In[21]:



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


# In[22]:


# create pi name via the prefix
sci_pi_file = "data/dxy_out/allel_" + re.sub('.*/|_invar.*', '', vcf_path) +"_dxy.txt"
outfile = open(sci_pi_file, 'w')
outfile.write("filename" + "\t" + "chromosome" + "\t" + "window_pos_1" + "\t" + "window_pos_2" + "\t" + "sk_allel_avg_dxy" + "\t" + "sk_allel_no_sites" + "\n")


# In[23]:


# compute dxy (for the whole region)
# the idea here is to arbitrary divide the population into two "populations"
# the expected value of dxy = pi (of the total sample) in this case 

hap_p1 = gt_region.subset(sel0=range(window_start,len(gt_region)), sel1=range(0,24)).to_haplotypes() 
hap_p2 = gt_region.subset(sel0=range(window_start,len(gt_region)), sel1=range(25,49)).to_haplotypes() 


# In[27]:


ac1 = hap_p1.count_alleles()
ac2 = hap_p2.count_alleles()
dxy_est = allel.sequence_divergence(window_range, ac1, ac2) 


# In[25]:


# write to file
outfile.write(re.sub('.*/|.vcf.*', '', vcf_path) + "\t" + str(chromosome) + "\t" + str(window_start) + "\t" + str(window_end) + "\t" + str(dxy_est) + "\t" + str(len(gt_region)) + "\n")
outfile.close()

# nuke zarr folder
os.system("rm -r " + zarr_path)

