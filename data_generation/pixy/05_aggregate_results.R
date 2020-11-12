library("tidyverse")
library("ggdark")

######################################## 
# pixy data
######################################## 

# pi

pi_files <- list.files("data/missing_genos", full.names = TRUE, pattern = ".*pi.txt")
pi_files <- c(pi_files, list.files("data/missing_sites", full.names = TRUE, pattern = ".*pi.txt"))
pi_files <- c(pi_files, list.files("data/accuracy_invar", full.names = TRUE, pattern = ".*pi.txt"))


# expected pi
Ne <- 1e6
Mu <- 1e-8
exp_pi <- 4*Ne*Mu

# sample size
n <- 50

# li and nei 1975
# expected variance over all loci
v_pi <- (2*exp_pi*(exp_pi+4)+8*(n-1)*exp_pi)/(2*n*(2*n-1)*(exp_pi+1)*(exp_pi+2)*(exp_pi+3))


read_pi <- function(x){
  
  #cat(paste0(x, "\n"))
  
  df <- try({df <- read.table(x, h = T)}, silent = TRUE)
  if(class(df) == "data.frame"){
    
    if(nrow(df) > 0){
      
      data.frame(filename = x, df)
      
    }
    
  }
  
}

pixy_pi <- lapply(pi_files, read_pi)
pixy_pi <- bind_rows(pixy_pi)

pixy_pi <- pixy_pi %>%
  mutate(missing_type = ifelse(grepl("genos", filename), "genotypes", "sites")) %>%
  mutate(missing_type = ifelse(grepl("accuracy", filename), "accuracy", missing_type)) %>%
  mutate(missing_data = ifelse(grepl("genos", filename), 
                               as.numeric(gsub(".*missing_genos=|.vcf.*", "", filename)),
                               as.numeric(gsub(".*missing_|.vcf.*", "", filename)))) %>%
  mutate(missing_data = ifelse(missing_type == "sites", (10000-missing_data)/10000, missing_data))%>%
  mutate(missing_data = ifelse(missing_type == "accuracy", 0, missing_data))

# this is the maxmium value of pi for a VCF
# i.e. the "true" per site estimate of pi for that sample
# with zero missing data
# used for scaling
max_pixy <- pixy_pi  %>%
  filter(missing_type == "sites"|missing_type == "accuracy") %>%
  mutate(vcf_source = gsub("_invar.missing.*|_invar.vcf.*", "", filename) %>% gsub(".*/", "", .)) %>%
  filter(missing_data == 0) %>%
  mutate(max_pi_pixy = avg_pi) %>% 
  select(vcf_source,  pop, max_pi_pixy) %>%
  arrange(vcf_source)

pixy_pi <- pixy_pi %>%
  mutate(vcf_source = gsub("_invar.missing.*|_invar.vcf.*", "", filename) %>% gsub(".*/", "", .)) %>%
  left_join(max_pixy) %>% 
  mutate(pi_scaled = avg_pi/max_pi_pixy) 

# inspect the data
pixy_pi %>%
  ggplot(aes(x = missing_data, y = pi_scaled))+
  geom_point(size = 1, alpha = 0.5)+
  geom_hline(yintercept = 1, color = "red", size = 0.75, linetype = 1) +
  facet_wrap(~missing_type)+
  xlab("Proportion of Data Missing")+
  ylab("Scaled Pi Estimate") +
  #scale_color_viridis_c()+
  dark_theme_gray(base_size = 20)+
  theme(axis.line = element_line(colour = "grey50"),
        panel.grid = element_line(colour = "grey15"))+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6))

# check the accuracy data
avg_pi_obs <- pixy_pi %>%
  filter(missing_type == "accuracy") %>%
  filter(!is.na(avg_pi)) %>%
  pull(avg_pi) %>%
  mean

avg_pi_obs
exp_pi

# check the accuracy data
var_pi_obs <- pixy_pi %>%
  filter(missing_type == "accuracy") %>%
  filter(!is.na(avg_pi)) %>%
  pull(avg_pi) %>%
  var

var_pi_obs
v_pi


# dxy
dxy_files <- list.files("data/missing_genos", full.names = TRUE, pattern = ".*dxy.txt")
dxy_files <- c(dxy_files, list.files("data/missing_sites", full.names = TRUE, pattern = ".*dxy.txt"))
dxy_files <- c(dxy_files, list.files("data/accuracy_invar", full.names = TRUE, pattern = ".*dxy.txt"))

# expected pi
Ne <- 1e6
Mu <- 1e-8
#exp_pi <- 4*Ne*Mu
exp_pi <- (12*Ne*Mu)/(3+(16*Ne*Mu))

pixy_dxy <- lapply(dxy_files, read_pi)
pixy_dxy <- bind_rows(pixy_dxy)

pixy_dxy <- pixy_dxy %>%
  mutate(missing_type = ifelse(grepl("genos", filename), "genotypes", "sites")) %>%
  mutate(missing_type = ifelse(grepl("accuracy", filename), "accuracy", missing_type)) %>%
  mutate(missing_data = ifelse(grepl("genos", filename), 
                               as.numeric(gsub(".*missing_genos=|.vcf.*", "", filename)),
                               as.numeric(gsub(".*missing_|.vcf.*", "", filename)))) %>%
  mutate(missing_data = ifelse(missing_type == "sites", (10000-missing_data)/10000, missing_data)) %>%
  mutate(missing_data = ifelse(missing_type == "accuracy", 0, missing_data))

# this is the maxmium value of pi for a VCF
# i.e. the "true" per site estimate of pi for that sample
# with zero missing data
# used for scaling
max_dxy <- pixy_dxy %>%
  filter(missing_type == "sites"|missing_type == "accuracy") %>%
  mutate(vcf_source = gsub("_invar.missing.*|_invar.vcf.*", "", filename) %>% gsub(".*/", "", .)) %>%
  filter(missing_data == 0) %>% 
  mutate(max_dxy_pixy = avg_dxy) %>% 
  select(vcf_source, max_dxy_pixy) %>%
  arrange(vcf_source)

pixy_dxy <- pixy_dxy %>%
  mutate(vcf_source = gsub("_invar.missing.*|_invar.vcf.*", "", filename) %>% gsub(".*/", "", .)) %>%
  left_join(max_dxy) %>%
  mutate(dxy_scaled = avg_dxy/max_dxy_pixy)

# inspect the data
pixy_dxy %>%
  ggplot(aes(x = missing_data, y = dxy_scaled))+
  geom_point(size = 1, alpha = 0.5)+
  geom_hline(yintercept = 1, color = "red", size = 0.75, linetype = 1) +
  facet_wrap(~missing_type)+
  xlab("Proportion of Data Missing")+
  ylab("Scaled Pi Estimate") +
  #scale_color_viridis_c()+
  dark_theme_gray(base_size = 20)+
  theme(axis.line = element_line(colour = "grey50"),
        panel.grid = element_line(colour = "grey15"))+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6))

pixy_dat <- pixy_dxy %>%
  select(vcf_source, missing_type, missing_data, avg_dxy) %>%
  left_join(pixy_pi, .) %>%
  mutate(method = "pixy") %>%
  select(vcf_source, missing_type, missing_data, method, avg_pi, avg_dxy)

write_rds(pixy_dat, "data/pixy_simulated_data.rds")
