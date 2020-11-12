# aggregate all raw pi/dxy calculations from various software packages
# KMS 2020-04-02
# KLK edited 2020-05-15

library("tidyverse")
library("officer")
library("aod")
library("rvg")
library("ggrastr")
library("patchwork")
library("reshape2")
library("gridExtra")

######################################## 
# read in and format data for plots
######################################## 

sim_dat <- read_rds("data/sim_dat_all.rds") %>%
  mutate(vcf_source = gsub("_invar.*", "", vcf_source))

# expected pi
Ne <- 1e6
Mu <- 1e-8
#exp_pi <- 4*Ne*Mu
exp_pi <- (12*Ne*Mu)/(3+(16*Ne*Mu))

# this is the maxmium value of pi for a VCF
# i.e. the "true" per site estimate of pi for that sample
# with zero missing data
# used for scaling
max_stats <- sim_dat  %>%
  filter(missing_type == "sites") %>%
  filter(missing_data == 0) %>% 
  mutate(max_pi = avg_pi) %>% 
  mutate(max_dxy = avg_dxy) %>%
  select(vcf_source, method, max_pi, max_dxy)

sim_dat <- sim_dat %>%
  left_join(max_stats) %>%
  filter(missing_type != "accuracy") %>%
  mutate(pi_scaled = avg_pi/max_pi) %>%
  mutate(dxy_scaled = avg_dxy/max_dxy)

######################################## 
# statistical tests 
######################################## 

stats_tests_pi <- sim_dat %>%
  filter(missing_data < 1) %>%
  group_by(method,missing_type) %>%
  do(model = lm(.$pi_scaled ~ .$missing_data)) %>%
  broom::tidy(model) %>%
  filter(term != "(Intercept)") %>%
  arrange(missing_type) %>%
  select(-term) %>%
  mutate(stat = "pi")

stats_tests_dxy <- sim_dat %>%
  filter(missing_data < 1) %>%
  filter(!is.na(dxy_scaled)) %>%
  group_by(method,missing_type) %>%
  filter(method != "VCFtools") %>%
  do(model = lm(.$dxy_scaled ~ .$missing_data)) %>%
  broom::tidy(model) %>%
  filter(term != "(Intercept)") %>%
  arrange(missing_type) %>%
  select(-term) %>%
  mutate(stat = "dxy")

bind_rows(stats_tests_pi, stats_tests_dxy) %>%
  write.csv(file = "figures/TableS2.csv", row.names = FALSE, quote = FALSE)

######################################## 
# Figure 2, simulated data
######################################## 

# unscaled pi for all methods
# maybe S1?
sim_dat %>%
  #sample_frac(0.05) %>%
  filter(missing_data < 1) %>%
  ggplot(aes(x = missing_data, y = avg_pi))+
  geom_point_rast(size = 0.5, alpha = 1, shape = 16, color = "black")+
  #geom_point(size = 0.5, alpha = 1, shape = 16, color = "black")+
  geom_smooth(color = "blue", se = FALSE)+
  geom_hline(yintercept = exp_pi, color = "red", size = 0.75, linetype = 2) +
  facet_grid(method~missing_type)+
  xlab("Proportion of Data Missing")+
  ylab("Pi Estimate") +
  theme_bw()+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) 

# scaled pi for all methods
# figure 2B
pi <- sim_dat %>%
  filter(missing_data < 1) %>%
  ggplot(aes(x = missing_data, y = pi_scaled))+
  geom_point_rast(size = 0.25, alpha = 0.4, shape = 16, color = "grey50", raster.height = 1, raster.width = 1)+
  #geom_point(size = 0.5, alpha = 0.4, shape = 16, color = "grey50")+
  geom_smooth(color = "red", se = FALSE)+
  geom_hline(yintercept = 1, color = "black", size = 0.5, linetype = 2) +
  facet_grid(missing_type~method)+
  xlab("Proportion of Data Missing")+
  ylab("Scaled Pi Estimate") +
  theme_bw()+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        strip.background = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.text.x = element_text(angle = 45, hjust = 1))+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) 

# same for dxy
dxy <- sim_dat %>%
  filter(missing_data < 1) %>%
  ggplot(aes(x = missing_data, y = dxy_scaled))+
  geom_point_rast(size = 0.25, alpha = 0.4, shape = 16, color = "grey50", raster.height = 1, raster.width = 1)+
  #geom_point(size = 0.5, alpha = 0.4, shape = 16, color = "grey50")+
  geom_smooth(color = "red", se = FALSE)+
  geom_hline(yintercept = 1, color = "black", size = 0.5, linetype = 2) +
  facet_grid(missing_type~method)+
  xlab("Proportion of Data Missing")+
  ylab("Scaled Dxy Estimate") +
  theme_bw()+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        strip.background = element_blank(), 
        axis.line = element_line(colour = "black"),
        axis.text.x = element_text(angle = 45, hjust = 1))+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 6)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) 


compound <- fig3 <-pi / dxy + 
  plot_annotation(tag_levels = "A")

ggsave("figures/Figure3_raw.pdf", plot = compound, device = "pdf", scale = 1 ,width = 6, height = 6)
