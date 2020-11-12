library("tidyverse")
library("ggdark")
library("officer")
library("aod")
library("rvg")
library("ggrastr")

pi_files <- list.files("data/invar", full.names = TRUE, pattern = ".pi")

# expected pi
Ne <- 1e6
Mu <- 1e-8
exp_pi <- 4*Ne*Mu

read_pi <- function(x){
  
  df <- read.table(x, h = T)
  if(nrow(df) > 0){
    
    data.frame(filename = x, df)
    
  }
  
  
}

pi_invar_df <- lapply(pi_files, read_pi)
pi_invar_df <- bind_rows(pi_invar_df) %>%
  filter(BIN_START ==1)

pi_invar_df %>%
  ggplot(aes(x = PI))+
  geom_histogram()+
  geom_density()+
  geom_vline(xintercept = exp_pi)


pi_files <- list.files("data/var_only", full.names = TRUE, pattern = ".pi")
pi_var_df <- lapply(pi_files, read_pi)
pi_var_df <- bind_rows(pi_var_df)

# GENOTYPES
pi_files <- list.files("data/missing_genos", full.names = TRUE, pattern = ".pi")
pi_mgenos_df <- lapply(pi_files, read_pi)
pi_mgenos_df <- bind_rows(pi_mgenos_df)

pi_mgenos_df <- pi_mgenos_df %>%
  mutate(missing_data = as.numeric(gsub(".*missing_genos=|.vcf.*", "", filename)))

pi_mgenos_df %>%
  filter(PI > 0.001) %>%
  ggplot(aes(x = missing_data, y = PI))+
  geom_point()+
  xlab("Proportion of Missing Genotypes Per Site")+
  ylab("VCFtools Pi Estimate")

# SITES
pi_files <- list.files("data/missing_sites", full.names = TRUE, pattern = ".pi")
pi_msites_df <- lapply(pi_files, read_pi)
pi_msites_df <- bind_rows(pi_msites_df)

pi_msites_df <- pi_msites_df %>%
  mutate(missing_data = as.numeric(gsub(".*missing_|.vcf.*", "", filename))) %>%
  mutate(missing_data = (10000-missing_data)/10000)

# ACCURACY
ac_files <- list.files("data/accuracy_invar", full.names = TRUE, pattern = ".pi")
pi_ac_df <- lapply(ac_files, read_pi)
pi_ac_df <- bind_rows(pi_ac_df)

pi_ac_df <- pi_ac_df %>%
  mutate(missing_data = 0)

head(pi_msites_df)
head(pi_mgenos_df)
head(pi_ac_df)

sites_tmp <- pi_msites_df %>%
  select(filename, PI, missing_data) %>%
  mutate(missing_type = "sites") %>%
  rename(avg_pi = PI)

genos_tmp <- pi_mgenos_df %>%
  select(filename, PI, missing_data) %>%
  mutate(missing_type = "genotypes") %>%
  rename(avg_pi = PI)

ac_tmp <- pi_ac_df %>%
  select(filename, PI, missing_data) %>%
  mutate(missing_type = "accuracy") %>%
  rename(avg_pi = PI)

max_pi_vcftools <- pi_invar_df %>%
  mutate(vcf_source = gsub("_invar.*", "", filename) %>% gsub(".*/", "", .)) %>%
  mutate(max_pi_vcftools = PI) %>% 
  select(vcf_source, max_pi_vcftools) %>%
  arrange(vcf_source)

bind_rows(sites_tmp, genos_tmp, ac_tmp) %>% 
  mutate(vcf_source = gsub("_invar.missing.*", "", filename) %>% gsub(".*/", "", .)) %>%
  mutate(vcf_source = gsub(".windowed.pi*", "", filename) %>% gsub(".*/", "", .)) %>%
  left_join(max_pi_vcftools) %>% 
  write.table("data/vcftools_summary.txt", row.names = FALSE)

pi_msites_df %>%
  #filter(PI > 0.001) %>%
  ggplot(aes(x = missing_data, y = PI))+
  geom_point()+
  xlab("Proportion of Missing Sites")+
  ylab("VCFtools Pi Estimate")

pi_msites_df %>%
  #filter(PI > 0.001) %>%
  ggplot(aes(x = missing_data, y = PI))+
  geom_point()+
  xlab("Proportion of Missing Sites")+
  ylab("VCFtools Pi Estimate")



