# aggregate all raw pi/dxy calculations from various software packages
# KMS 2020-04-02

library("tidyverse")
library("ggridges")
library("patchwork")
library("GGally")

######################################## 
# read in and format data for plots
######################################## 

sim_dat <- read_rds("data/sim_dat_all.rds")

# expected pi
Ne <- 1e6
Mu <- 1e-8
exp_pi <- 4*Ne*Mu

# sample size
n <- 50

# li and nei 1975
# expected sampling variance over all loci
v_pi <- (2*exp_pi*(exp_pi+4)+8*(n-1)*exp_pi)/(2*n*(2*n-1)*(exp_pi+1)*(exp_pi+2)*(exp_pi+3))


# filter for accuracy data
acu_dat <- sim_dat  %>%
  filter(missing_type == "accuracy")

# convert to wide format (for Figure2B)
pi_wide <- acu_dat %>%
  filter(avg_pi > 0.001) %>%
  mutate(vcf_source = gsub("_invar.vcf.gz", "", vcf_source)) %>%
  mutate(vcf_source = gsub("_vcf_id.*", "", vcf_source)) %>%
  select(vcf_source, method, avg_pi) %>%
  arrange(vcf_source, method) %>%
  group_by(method) %>%
  mutate(grouped_id = row_number()) %>%
  ungroup %>%
  spread(method, avg_pi) %>% 
  select(-grouped_id) %>%
  distinct

# hack to get spread to work correctly
pixy_dat <- pi_wide %>% select(vcf_source, pixy) %>% filter(complete.cases(.))
pi_wide <- pi_wide %>% select(-pixy) %>% 
  filter(complete.cases(.)) %>% 
  left_join(pixy_dat) %>% 
  distinct %>%
  mutate(msprime = gsub(".*=", "", vcf_source) %>% as.numeric()) 

dxy_wide <- acu_dat %>%
  filter(avg_pi > 0.001) %>%
  mutate(vcf_source = gsub("_invar.vcf.gz", "", vcf_source)) %>%
  mutate(vcf_source = gsub("_vcf_id.*", "", vcf_source)) %>%
  arrange(vcf_source, method) %>%
  select(vcf_source, method, avg_dxy) %>%
  group_by(method) %>%
  mutate(grouped_id = row_number()) %>%
  spread(method, avg_dxy) %>%
  select(-grouped_id)%>%
  select(-vcftools) %>%
  distinct

pixy_dat <- dxy_wide %>% select(vcf_source, pixy) %>% filter(complete.cases(.))
dxy_wide <- dxy_wide %>% select(-pixy) %>% 
  filter(complete.cases(.)) %>% 
  left_join(pixy_dat) %>% 
  distinct 

pi_wide_2 <- pi_wide %>%
  gather(key = method, value = avg_pi, -vcf_source, -pixy) %>%
  distinct()

dxy_wide_2 <- dxy_wide %>%
  gather(key = method, value = avg_dxy, -vcf_source, -pixy)

# summary stats for plotting
se <- function(x) sd(x, na.rm = TRUE)/sqrt(length(x))

sum_dat <- acu_dat %>%
  filter(avg_pi > 0.001) %>%
  filter(!is.na(avg_pi)) %>%
  select(method, avg_pi, avg_dxy) %>%
  gather(key = "stat", value = "value", -method) %>%
  mutate(stat = factor(stat, levels = c("avg_pi", "avg_dxy"))) %>%
  group_by(method, stat) %>%
  summarise(mean_val = mean(value, na.rm = TRUE), se_val = se(value)) %>%
  ungroup %>%
  mutate(mean_upper = mean_val + se_val, mean_lower = mean_val - se_val) %>%
  mutate(exp_pi = exp_pi) 


# pixy is perfectly correlated with the other methods for pi
# pi r^2 - 1.000, f=1.47x10^6, (1,19998), p<2.2e16
lm(pixy ~ avg_pi, data = pi_wide_2) %>% summary

# pixy is nearly perfectly correlated with the other methods for pi
# popgenome for some reason has more variance
# pi r^2 - 0.9866, f=1.47x10^6, (1,19998), p<2.2e16
lm(pixy ~ avg_dxy, data = dxy_wide_2) %>% summary


######################################################
# Figure 2, accuracy comparison with no missing data
######################################################

# Figure 2A: histograms of avgerage pi
figure2A <- acu_dat %>%
  filter(avg_pi > 0.001) %>%
  select(method, avg_pi, avg_dxy) %>%
  gather(key = "stat", value = "value", -method) %>%
  mutate(stat = factor(stat, levels = c("avg_pi", "avg_dxy"))) %>%
  filter(stat == "avg_pi") %>%
  mutate(value = ifelse(value > 0.1, 0.1, value)) %>%
  ggplot(aes(x = value, y = method))+
  geom_vline(xintercept = exp_pi, linetype = 1, size = 1, color = "red", alpha = 0.8)+
  #geom_density_ridges(scale = 0.95, draw_baseline = FALSE)+
  #geom_density_ridges(stat="density", scale = 0.95, draw_baseline = FALSE)+
  geom_density_ridges(stat = "binline", bins = 100, scale = 0.95, draw_baseline = FALSE, fill = NA)+
  #geom_point(data = sum_dat, aes(y = 0, x = exp_pi), pch = 23, fill = "black")+
  #geom_vline(xintercept = exp_pi, linetype = 2, size = 0.5, color = "black")+
  geom_point(data = sum_dat, aes(y = as.numeric(as.factor(method))+0.05, x = mean_val), shape = 25, size = 3, color = "black", fill = NA)+
  scale_y_discrete(expand = c(0.01, 0))+
  theme_minimal()+
  ylab("Method")+
  xlab("pi Estimate")+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "black"),
        axis.ticks = element_line())

# Figure 2C: histograms of avgerage dxy
sum_dat2 <- sum_dat %>%
  filter(method != "vcftools") %>%
  mutate(method =  factor(method)) 

figure2B <- acu_dat %>%
  filter(avg_pi > 0.001) %>%
  select(method, avg_pi, avg_dxy) %>%
  gather(key = "stat", value = "value", -method) %>%
  mutate(stat = factor(stat, levels = c("avg_pi", "avg_dxy"))) %>%
  filter(stat == "avg_dxy") %>%
  filter(method != "vcftools") %>%
  mutate(value = ifelse(value > 0.1, 0.1, value)) %>%
  ggplot(aes(x = value, y = method))+
  geom_density_ridges(stat = "binline", bins = 100, scale = 0.95, draw_baseline = FALSE, fill = NA)+
  geom_vline(xintercept = exp_pi, linetype = 1, size = 1, color = "red", alpha = 0.8)+
  #geom_point(data = sum_dat, aes(y = as.numeric(as.factor(method)), x = mean_val), shape = 16, size = 2)+
  #geom_segment(data = sum_dat2, 
  #             aes(y = as.numeric(as.factor(method)), yend = as.numeric(as.factor(method))+0.65, 
  #                 x = mean_val, xend = mean_val), 
  #             inherit.aes = F, size =0.5, lty = 2, color = "black", alphg =0.8)+
  geom_point(data = sum_dat2, aes(y = as.numeric(as.factor(method))+0.05, x = mean_val), shape = 25, size = 3, color = "black", fill = NA)+
  scale_y_discrete(expand = c(0.01, 0))+
  theme_minimal()+
  ylab("Method")+
  xlab("dxy Estimate")+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "black"),
        axis.ticks = element_line())

# Figure 2B: pixy pi vs other methods
figure2C <- pi_wide_2 %>%
  filter(method != "msprime") %>%
  ggplot(aes(x = avg_pi, y = pixy)) +
  geom_point(alpha = 0.4, shape = 16, color = "grey50")+
  geom_smooth(method = "lm", se = F, color = "black")+
  facet_wrap(~method)+
  theme_classic()+
  ylab("pixy pi Estimate")+
  xlab("pi Estimate")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        strip.background = element_blank())

# Figure 2D: pixy dxy vs other methods
figure2D <- dxy_wide_2 %>%
  ggplot(aes(x = avg_dxy, y = pixy)) +
  geom_point(alpha = 0.4, shape = 16, color = "grey50")+
  geom_smooth(method = "lm", se = F, color = "black")+
  facet_wrap(~method)+
  theme_classic()+
  ylab("pixy pi Estimate")+
  xlab("pi Estimate")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        strip.background = element_blank())

#figure2 <- (figure2A|figure2B)/(figure2C|figure2D)+
#  plot_annotation(tag_levels = "A")

(figure2 <- figure2A + figure2B + figure2C + figure2D +
  plot_annotation(tag_levels = "A") +
  plot_layout(heights = c(2, 1)))

ggsave("figures/Figure2_raw.pdf", figure2, width = 8, height = 6, device = "pdf")

  
  