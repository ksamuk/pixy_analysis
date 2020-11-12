Analysis scripts used in the academic manuscript accompanying the [pixy software](https://github.com/ksamuk/pixy). 

See the manuscript here:
https://www.biorxiv.org/content/10.1101/2020.06.27.175091v1

## Project Structure

* The top level directory contains the R scripts (and Rstudio project file) used to generate the figures and analyses presented in the paper.
* The 'data_generation' folder contains subfolders for each method used to: 
  * Simulate sequence data using [msprime](https://msprime.readthedocs.io/en/stable/) 
  * Call variants (i.e. create an all-sites VCF) from a subset of the the [Ag1000g](https://www.malariagen.net/projects/ag1000g) data. 
  * Estimate pi and dxy from the simulated & Ag1000g datasets using a variety of methods, including pixy.
