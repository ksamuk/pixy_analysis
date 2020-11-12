# aggregate all raw pi/dxy calculations from various software packages
# KMS 2020-04-02

library("tidyverse")
library("ggdark")

######################################## 
# pixy data
######################################## 

pixy_dat <- read_rds("data_generation/pixy/data/pixy_simulated_data.rds")

######################################## 
# popgenome
######################################## 

# vcf_source, method, avg_pi, avg_dxy

popgenome_dat <- read.csv("data_generation/popgenome/data/popgenome_pi_dxy_est.csv")

popgenome_dat <- popgenome_dat %>% 
  mutate(vcf_source = gsub("_invar.missing.*|_invar.vcf.gz", "", vcf_file) %>% gsub(".*/", "", .)) %>%
  mutate(missing_type = ifelse(grepl("genos", vcf_file), "genotypes", "sites")) %>%
  mutate(missing_type = ifelse(grepl("accuracy", vcf_file), "accuracy", missing_type)) %>%
  mutate(missing_data = ifelse(grepl("genos", vcf_file), 
                               as.numeric(gsub(".*missing_genos=|.vcf.*", "", vcf_file)),
                               as.numeric(gsub(".*missing_|.vcf.*", "", vcf_file)))) %>%
  mutate(missing_data = ifelse(missing_type == "sites", (10000-missing_data)/10000, missing_data)) %>%
  mutate(missing_data = ifelse(missing_type == "accuracy", 0, missing_data)) %>%
  rename(avg_pi = popgenome_pi, avg_dxy = popgenome_dxy) %>%
  mutate(method = "popgenome") %>%
  select(vcf_source, missing_type, missing_data, method, avg_pi, avg_dxy)

######################################## 
# scikit-allel
######################################## 

# vcf_source, method, avg_pi, avg_dxy

scikit_dat <- read.csv("data_generation/scikitallel/data/scikit_pi_dxy_est.csv")

scikit_dat <- scikit_dat %>% 
  mutate(vcf_source = gsub("_invar.missing.*", "", filename) %>% gsub(".*/", "", .)) %>%
  mutate(vcf_source = gsub("_invar.missing.*|_invar$", "", filename) %>% gsub(".*/", "", .)) %>%
  mutate(missing_type = ifelse(grepl("genos", filename), "genotypes", "sites")) %>%
  mutate(missing_type = ifelse(grepl("msprime", filename), "accuracy", missing_type)) %>%
  mutate(missing_data = ifelse(grepl("genos", filename), 
                               as.numeric(gsub(".*missing_genos=|.vcf.*", "", filename)),
                               as.numeric(gsub(".*missing_|.vcf.*", "", filename)))) %>%
  mutate(missing_data = ifelse(missing_type == "sites", 
                               (10000-missing_data)/10000, missing_data)) %>%
  mutate(missing_data = ifelse(missing_type == "accuracy", 0, missing_data)) %>%
  rename(avg_pi = sk_allel_avg_pi, avg_dxy = sk_allel_avg_dxy) %>%
  mutate(method = "scikitallel") %>%
  select(vcf_source, missing_type, missing_data, method, avg_pi, avg_dxy) %>%
  distinct



######################################## 
# vcftools
######################################## 

# vcf_source, method, avg_pi, avg_dxy

vcftools_dat <- read.table("data_generation/vcftools/data/vcftools_summary.txt", h = T)

vcftools_dat <- vcftools_dat %>% 
  mutate(avg_dxy = NA) %>%
  mutate(method = "vcftools") %>%
  select(vcf_source, missing_type, missing_data, method, avg_pi, avg_dxy)

######################################## 
# join everything
######################################## 

sim_dat <- bind_rows(pixy_dat, popgenome_dat, scikit_dat, vcftools_dat ) %>%
  arrange(method, missing_type, missing_data)


# write to file
write_rds(sim_dat, "data/sim_dat_all.rds")
