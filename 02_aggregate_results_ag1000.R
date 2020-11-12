# aggregate all raw pi/dxy calculations from various software packages
# KMS 2020-04-02

library("tidyverse")

######################################## 
# pixy data
######################################## 

pixy_dxy <- read.table("data_generation/pixy/data/ag1000/ag1000__dxy.txt", h = T)
pixy_pi <- read.table("data_generation/pixy/data/ag1000/ag1000__pi.txt", h = T)

# grab the number of missing sites (assuming this is approximately constant for all methods)
pi_missing <- pixy_pi %>%
  mutate(pop = as.character(pop)) %>%
  select(pop, window_pos_1, window_pos_2, no_sites, count_missing)

dxy_missing <- pixy_dxy %>%
  select(window_pos_1, window_pos_2, no_sites, count_missing)

pixy_pi <- pixy_pi %>%
  mutate(method = "pixy") %>%
  select(method, pop, window_pos_1, window_pos_2,  avg_pi)

pixy_dxy <- pixy_dxy %>%
  mutate(method = "pixy") %>%
  select(method, window_pos_1, window_pos_2, avg_dxy)


######################################## 
# popgenome
######################################## 

popgenome_dat <- read_rds("data_generation/popgenome/data/popgenome_pi_dxy_ag1000g.rds")

popgenome_pi <- popgenome_dat %>%
  select(-pop_genome_dxy) %>%
  gather(-window_pos_1, -window_pos_2, value = avg_pi, key = pop) %>%
  mutate(pop = gsub(".*_", "", pop)) %>%
  mutate(method = "PopGenome") %>%
  select(method, pop, window_pos_1, window_pos_2, avg_pi) %>%
  distinct()

popgenome_dxy <- popgenome_dat %>%
  mutate(method = "PopGenome") %>%
  rename(avg_dxy = pop_genome_dxy) %>%
  select(method, window_pos_1, window_pos_2, avg_dxy)%>%
  distinct()


######################################## 
# scikit-allel
######################################## 

scikit_pi_bfs <- read.table("data_generation/scikitallel/data/allel_BFS_pi.txt", h = T)
scikit_pi_kes <- read.table("data_generation/scikitallel/data/allel_KES_pi.txt", h = T)
scikit_dxy <- read.table("data_generation/scikitallel/data/allel_KES_BFS_dxy.txt", h = T)

scikit_pi_bfs <- scikit_pi_bfs %>%
  mutate(method = "scikit-allel") %>%
  mutate(pop = "BFS") %>%
  rename(avg_pi = sk_allel_avg_pi) %>%
  select(method, pop, window_pos_1, window_pos_2, avg_pi)

scikit_pi_kes <- scikit_pi_kes %>%
  mutate(method = "scikit-allel") %>%
  mutate(pop = "KES") %>%
  rename(avg_pi = sk_allel_avg_pi) %>%
  select(method, pop, window_pos_1, window_pos_2, avg_pi)

scikit_pi <- bind_rows(scikit_pi_bfs, scikit_pi_kes)

scikit_dxy <- scikit_dxy %>%
  mutate(method = "scikit-allel") %>%
  rename(avg_dxy = sk_allel_avg_dxy) %>%
  select(method, window_pos_1, window_pos_2, avg_dxy)


######################################## 
# vcftools
######################################## 

vcftools_pi_bfs <- read.table("data_generation/vcftools/data/chrX-windowed-pi-vcftools_BFS.txt.windowed.pi", h = T)
vcftools_pi_kes <- read.table("data_generation/vcftools/data/chrX-windowed-pi-vcftools_KES.txt.windowed.pi", h = T)

names(vcftools_pi_bfs) <- c("CHROM", "window_pos_1", "window_pos_2", "N_VAR", "avg_pi")
names(vcftools_pi_kes) <- c("CHROM", "window_pos_1", "window_pos_2", "N_VAR", "avg_pi")

vcftools_pi_bfs <- vcftools_pi_bfs %>%
  mutate(method = "VCFtools") %>%
  mutate(pop = "BFS") %>%
  select(method, pop, window_pos_1, window_pos_2, avg_pi)

vcftools_pi_kes <- vcftools_pi_kes %>%
  mutate(method = "VCFtools") %>%
  mutate(pop = "KES") %>%
  select(method, pop, window_pos_1, window_pos_2, avg_pi)

vcftools_pi <- bind_rows(vcftools_pi_bfs, vcftools_pi_kes)

######################################## 
# ANGSD
######################################## 

angsd_pi_bfs <- read.table("data_generation/angsd/ANGSD_output/chrX_angsd_piSummary_thetaBFS.thetasWin-10kb.pairwiseTheta.txt", h = T) 
names(angsd_pi_bfs) <- c("chrom", "window_pos_1", "window_pos_2", "theta_pi", "n_sites")

angsd_pi_bfs <- angsd_pi_bfs %>%
  mutate(method = "ANGSD") %>%
  mutate(pop = "BFS") %>%
  mutate(avg_pi = theta_pi / n_sites) %>%
  mutate(window_pos_1 = as.numeric(as.character(window_pos_1))) %>%
  mutate(window_pos_2 = as.numeric(as.character(window_pos_2))) %>%
  select(method, pop, window_pos_1, window_pos_2, avg_pi)

angsd_pi_kes <- read.table("data_generation/angsd/ANGSD_output/chrX_angsd_piSummary_thetaKES.thetasWin-10kb.pairwiseTheta.txt", h = T) 
names(angsd_pi_kes) <- c("chrom", "window_pos_1", "window_pos_2", "theta_pi", "n_sites")

angsd_pi_kes <- angsd_pi_kes %>%
  mutate(method = "ANGSD") %>%
  mutate(pop = "KES") %>%
  mutate(avg_pi = theta_pi / n_sites) %>%
  mutate(window_pos_1 = as.numeric(as.character(window_pos_1))) %>%
  mutate(window_pos_2 = as.numeric(as.character(window_pos_2))) %>%
  select(method, pop, window_pos_1, window_pos_2, avg_pi)

angsd_pi <- bind_rows (angsd_pi_kes, angsd_pi_bfs)
  

angsd_dxy <- read.table("data_generation/angsd/ANGSD_output/chrX_angsd_DxySummary.txt", h= T )
names(angsd_dxy) <- c("chrom", "window_pos_1", "window_pos_2", "avg_dxy", "avg_dxy_2")

angsd_dxy <- angsd_dxy %>%
  mutate(method = "ANGSD") %>%
  select(method, window_pos_1, window_pos_2, avg_dxy)

######################################## 
# combine all ag1000g data
######################################## 

# pi
pi_all <- bind_rows(pixy_pi, popgenome_pi, vcftools_pi, scikit_pi, angsd_pi) %>%
  arrange(window_pos_1, method) %>% 
  left_join(pi_missing) %>%
  filter(!is.na(no_sites))

# dxy
dxy_all <- bind_rows(pixy_dxy, popgenome_dxy, scikit_dxy, angsd_dxy)%>%
  arrange(window_pos_1, method) %>%
  left_join(dxy_missing)

# write to file
write_rds(pi_all, "data/ag1000g_pi_all.rds")
write_rds(dxy_all, "data/ag1000g_dxy_all.rds")


