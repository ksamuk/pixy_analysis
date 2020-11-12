library("tidyverse")
library("ggdark")
library("officer")
library("aod")
library("rvg")
library("ggrastr")
#devtools::install_github('VPetukhov/ggrastr')

# pi

pi_files <- list.files("data_generation/pixy/data/missing_genos", full.names = TRUE, pattern = ".*pi.txt")
pi_files <- c(pi_files, list.files("data_generation/pixy/data/missing_sites", full.names = TRUE, pattern = ".*pi.txt"))


# expected pi
Ne <- 1e6
Mu <- 1e-8
#exp_pi <- 4*Ne*Mu
exp_pi <- (12*Ne*Mu)/(3+(16*Ne*Mu))

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
  mutate(missing_data = ifelse(grepl("genos", filename), 
                               as.numeric(gsub(".*missing_genos=|.vcf.*", "", filename)),
                               as.numeric(gsub(".*missing_|.vcf.*", "", filename)))) %>%
  mutate(missing_data = ifelse(missing_type == "sites", (10000-missing_data)/10000, missing_data))
  

max_pixy <- pixy_pi  %>%
  filter(missing_type == "sites") %>%
  mutate(vcf_source = gsub("_invar.missing.*", "", filename) %>% gsub(".*/", "", .)) %>%
  filter(missing_data == 0) %>%
  mutate(max_pi_pixy = avg_pi) %>% 
  select(vcf_source, pop, max_pi_pixy) %>%
  arrange(vcf_source)
 
# nice pixy plot
pixy_pi %>%
  #filter(avg_pi > 0.001) %>%
  mutate(vcf_source = gsub("_invar.missing.*", "", filename) %>% gsub(".*/", "", .)) %>%
  left_join(max_pixy) %>%
  mutate(pi_scaled = avg_pi/max_pi_pixy) %>%
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

# bring in VCFtools data

vcftools_dat <- read.table("../vcftools/data/vcftools_summary.txt", h = T)

# LONG
vcftools_dat <- vcftools_dat %>%
  mutate(method = "vcftools") %>%
  rename(max_pi = max_pi_vcftools) %>%
  mutate(vcf_source = as.character(vcf_source)) %>%
  select(vcf_source, method, missing_type, missing_data, avg_pi, max_pi)

pixy_sub <- pixy_pi %>%
  mutate(vcf_source = gsub("_invar.missing.*", "", filename) %>% gsub(".*/", "", .)) %>%
  left_join(max_pixy) %>%
  mutate(method = "pixy") %>%
  rename(max_pi = max_pi_pixy) %>%
  select(vcf_source, method, missing_type, missing_data, avg_pi, max_pi)
  
pi_df <- bind_rows(vcftools_dat, pixy_sub)


# WIDE
vcftools_dat <- read.table("../vcftools/data/vcftools_summary.txt", h = T)

vcftools_dat <- vcftools_dat %>%
  mutate(vcf_source = as.character(vcf_source)) %>%
  mutate(vcftools_pi = avg_pi) %>%
  select(vcf_source, missing_type, missing_data, vcftools_pi, max_pi_vcftools)

pixy_sub <- pixy_pi %>%
  mutate(vcf_source = gsub("_invar.missing.*", "", filename) %>% gsub(".*/", "", .)) %>%
  left_join(max_pixy) %>%
  mutate(pixy_pi = avg_pi) %>%
  select(vcf_source, missing_type, missing_data, pixy_pi, max_pi_pixy)

pi_wide <- left_join(pixy_sub, vcftools_dat)

# First Figure
fig1 <- pi_df %>%
  filter(vcf_source != "pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_55") %>%
  filter(vcf_source != "pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_85") %>%
  mutate(pi_scaled = avg_pi/max_pi) %>%
  filter((pi_scaled > 0.005 | missing_data > 0.9 & method == "vcftools") | 
           (pi_scaled > 0.005 & method == "pixy")) %>%
  select(vcf_source, method, max_pi) %>%
  distinct %>%
  ggplot(aes(fill = method, x = max_pi*(50/49)))+
  #geom_point(size = 1, alpha = 0.5, pch = 16)+
  geom_histogram(alpha = 1.0, position="identity", bins = 22)+
  #geom_density(alpha = 1.0, position="identity")+
  geom_vline(xintercept = exp_pi, size = 1.5, color = "grey95")+
  facet_wrap(~method)+
  xlab("Proportion of Data Missing")+
  ylab("Frequency") +
  #scale_color_viridis_c()+
  dark_theme_gray(base_size = 20)+
  theme(axis.line = element_line(colour = "grey50"),
        panel.grid = element_line(colour = "grey15", size = 0.5),
        legend.position = "none")+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6), expand = c(0,0)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6), expand = c(0,0))+
  scale_fill_manual(values = c("#ff410d", "#6ee2ff"))

fig1_xy <- pi_wide %>%
  select(vcf_source, max_pi_pixy, max_pi_vcftools) %>%
  distinct %>%
  ggplot(aes(y = max_pi_pixy, x = max_pi_vcftools))+
  geom_point(size = 5, alpha = 0.5, pch = 16)+
  geom_abline(slope = 1, color = "white") +
  #geom_density(alpha = 1.0, position="identity")+
  labs(x = "vcftools pi", y = "pixy pi")+
  #scale_color_viridis_c()+
  dark_theme_gray(base_size = 20)+
  theme(axis.line = element_line(colour = "grey50"),
        panel.grid = element_line(colour = "grey15", size = 0.5),
        legend.position = "none")

# Second Figure
fig2 <- pi_df %>%
  filter(vcf_source != "pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_55") %>%
  filter(vcf_source != "pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_85") %>%
  mutate(pi_scaled = avg_pi/max_pi) %>%
  filter((pi_scaled > 0.005 | missing_data > 0.9 & method == "vcftools") | 
         (pi_scaled > 0.005 & method == "pixy")) %>%
  ggplot(aes(x = missing_data, y = pi_scaled, color = method))+
  #geom_point(size = 1, alpha = 0.5, pch = 16)+
  ggrastr::geom_point_rast(size = 4, alpha = 0.2, pch = 16, raster.width = 6, raster.height = 7) +
  geom_smooth()+
  facet_wrap(~missing_type)+
  xlab("Proportion of Data Missing")+
  ylab("Scaled Pi Estimate") +
  #scale_color_viridis_c()+
  dark_theme_gray(base_size = 20)+
  theme(axis.line = element_line(colour = "grey50"),
        panel.grid = element_line(colour = "grey15", size = 0.5))+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6), expand = c(0,0)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6), expand = c(0,0))+
  scale_color_manual(values = c("#ff410d", "#6ee2ff"))

fig2_blank <- pi_df %>%
  filter(vcf_source != "pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_55") %>%
  filter(vcf_source != "pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_85") %>%
  mutate(pi_scaled = avg_pi/max_pi) %>%
  filter((pi_scaled > 0.005 | missing_data > 0.9 & method == "vcftools") | 
           (pi_scaled > 0.005 & method == "pixy")) %>%
  ggplot(aes(x = missing_data, y = pi_scaled, color = method))+
  #geom_point(size = 1, alpha = 0.5, pch = 16)+
  ggrastr::geom_point_rast(size = 4, alpha = 0.2, pch = 16, raster.width = 6, raster.height = 7) +
  geom_smooth()+
  facet_wrap(~missing_type)+
  xlab("Proportion of Data Missing")+
  ylab("Scaled Pi Estimate") +
  #scale_color_viridis_c()+
  dark_theme_gray(base_size = 20)+
  theme(axis.line = element_line(colour = "grey50"),
        panel.grid = element_line(colour = "grey15", size = 0.5))+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6), expand = c(0,0)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6), expand = c(0,0))+
  scale_color_manual(values = c("#ff410d", NA))

read_pptx() %>% 
  add_slide(layout = "Title and Content", master = "Office Theme") %>% 
  ph_with_vg_at(code = print(fig1), left = 0, top = 0, width = 10, height = 7.5) %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>% 
  ph_with_vg_at(code = print(fig1_xy), left = 0, top = 0, width = 10, height = 7.5) %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with_vg_at(code = print(fig2_blank), left = 0, top = 0, width = 10, height = 7.5) %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with_vg_at(code = print(fig2), left = 0, top = 0, width = 10, height = 7.5) %>%
  print(target = "slides/pi_fig1_Fig2.pptx")
  




pi_df %>%
  filter(avg_pi > 0.001) %>%
  mutate(pi_scaled = avg_pi/max_pi_pixy) %>%
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


