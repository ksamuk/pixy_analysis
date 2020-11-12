#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH -J pgeno
#SBATCH -o tmp/popgeno-%j.out

#sbatch 01_run_popgenome.sh ../simulating-test-data/data/simulated_missing_genos 12
#sbatch 01_run_popgenome.sh ../simulating-test-data/data/simulated_missing_sites 12
#sbatch 01_run_popgenome.sh ../simulating-test-data/data/simulated_invar 12
sbatch 01_run_popgenome.sh ../simulating-test-data/data/accuracy_invar 12
