library("tidyverse")
library("ggdark")
#install.packages("ggdark")

# expected pi
Ne <- 1e6
Mu <- 1e-8
exp_pi <- 4*Ne*Mu

# bind files into a dataframe

pg_pi <- read.csv("data/popgenome_pi_dxy_est.csv")

# fix missing genos scale

#pg_pi <- pg_pi %>%
#  mutate(n_missing = ifelse(missing_type == "genos", gsub(".*=|.vcf.gz", "", vcf_file), n_missing)) %>%
#  mutate(n_missing = as.numeric(n_missing))

max_pi <- pg_pi %>%
  mutate(vcf_source = gsub("_invar.missing.*", "", vcf_file) %>% gsub(".*/", "", .)) %>%
  #mutate(vcf_source = as.factor(vcf_source) %>% as.numeric) %>%
  group_by(vcf_source, missing_type) %>%
  summarize(max_pi = max(popgenome_pi)) 

max_dxy <- pg_pi %>%
  mutate(vcf_source = gsub("_invar.missing.*", "", vcf_file) %>% gsub(".*/", "", .)) %>%
  #mutate(vcf_source = as.factor(vcf_source) %>% as.numeric) %>%
  group_by(vcf_source, missing_type) %>%
  summarize(max_dxy = max(popgenome_dxy)) 

# sites
pg_pi %>%
  mutate(vcf_source = gsub("_invar.missing.*", "", vcf_file) %>% gsub(".*/", "", .)) %>%
  #mutate(vcf_source = as.factor(vcf_source) %>% as.numeric) %>%
  left_join(max_pi) %>%
  mutate(vcf_source = fct_reorder(vcf_source, max_pi)) %>%
  ggplot(aes(x = n_missing, y= popgenome_dxy/max_pi))+
  geom_point(size = 1, alpha= 0.2)+
  #geom_line()+
  geom_smooth(method = "loess", span = 0.1)+
  facet_wrap(~missing_type, scales = "free_x")+
  scale_color_viridis_c()+
  dark_theme_gray()

pg_pi %>%
  mutate(vcf_source = gsub("_invar.missing.*", "", vcf_file) %>% gsub(".*/", "", .)) %>%
  #mutate(vcf_source = as.factor(vcf_source) %>% as.numeric) %>%
  group_by(vcf_source, missing_type) %>%
  mutate(popgenome_pi_scaled = popgenome_pi/max(popgenome_pi)) %>%
  ungroup %>%
  left_join(max_pi) %>%
  left_join(max_dxy) %>%
  mutate(vcf_source = fct_reorder(vcf_source, max_pi)) %>%
  ggplot(aes(x = n_missing, y= popgenome_pi/max_pi))+
  geom_point(size = 1, alpha= 0.2)+
  #geom_line()+
  geom_smooth(method = "loess", span = 0.1)+
  facet_wrap(~missing_type, scales = "free_x")+
  scale_color_viridis_c()+
  dark_theme_gray()

  