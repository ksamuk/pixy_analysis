library("tidyverse")
library("patchwork")

#library("officer")
#library("aod")
#library("rvg")
#library("ggrastr")


######################################## 
# Figure 4, ag1000g data
######################################## 

pi_dat <- read_rds("data/ag1000g_pi_all.rds")

# add in additional missing data counts
pi_dat <- pi_dat %>%
  mutate(missing_sites = ((window_pos_2 - window_pos_1 + 1)- no_sites)) %>%
  mutate(count_missing_full = count_missing + choose(18,2) * missing_sites)

# number of total possible comparisons 
# (for converting count missing to a proportion)
# this is the max number of comparions at a site (18 choose 2)
# multiplied by the max number of sites in a window (10000)
# this value is the same for pi and dxy because 
# the two populations both have 18 individuals

comps_max <- choose(18,2) * 10000

# pi data to wide format
pi_wide <- pi_dat %>%
  filter(pop == "BFS") %>%
  group_by(method) %>% 
  #mutate(row_id = row_number()) %>%
  spread(key = method, value = avg_pi) %>%
  ungroup %>%
  mutate(prop_missing = count_missing_full/comps_max)


# shared theming elements for figure 3
fill_title <- "Prop.\nMissing"
axis_lim <- c(0, 0.0325)
point_size <- 2.5
alpha_val <- 1.0
color_limits <- c(0.0,0.257)
trans_breaks <- c(0.15, 0.20, 0.25, 0.3)
stroke_size <- 0.15
axis_breaks <- seq(0,0.03, by = 0.005)

# pixy vs popgenome
pixy_pg <- pi_wide %>%
  ggplot(aes(y = pixy, x = PopGenome, fill = prop_missing))+
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_abline(slope = 1, intercept = 0, color = "red", size = 1)+
  #geom_smooth(color = "blue", se = FALSE)+
  xlab("PopGenome Pi Estimate")+
  ylab("pixy Pi Estimate") +
  theme_bw()+
  coord_fixed(xlim = axis_lim, ylim = axis_lim)+
  scale_x_continuous(breaks = axis_breaks) +
  scale_y_continuous(breaks = axis_breaks) +
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))


# pixy vs vcftools
pixy_vcf <- pi_wide %>%
  ggplot(aes(y = pixy, x = VCFtools, fill = prop_missing))+
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_abline(slope = 1, intercept = 0, color = "red", size = 1)+
  #geom_smooth(color = "blue", se = FALSE)+
  xlab("VCFtools Pi Estimate")+
  ylab("pixy Pi Estimate") +
  theme_bw()+
  coord_fixed(xlim = axis_lim, ylim = axis_lim)+
  scale_x_continuous(breaks = axis_breaks) +
  scale_y_continuous(breaks = axis_breaks) +
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))



# pixy vs ANGSD
pixy_ang <- pi_wide %>%
  ggplot(aes(y = pixy, x = ANGSD, fill = prop_missing))+
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_abline(slope = 1, intercept = 0, color = "red", size = 1)+
  #geom_smooth(color = "blue", se = FALSE)+
  xlab("ANGSD Pi Estimate")+
  ylab("pixy Pi Estimate") +
  theme_bw()+
  coord_fixed(xlim = axis_lim, ylim = axis_lim)+
  scale_x_continuous(breaks = axis_breaks) +
  scale_y_continuous(breaks = axis_breaks) +
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))


# pixy vs scikit-allel
pixy_ska <- pi_wide %>%
  ggplot(aes(y = pixy, x = `scikit-allel`, fill = prop_missing))+
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_abline(slope = 1, intercept = 0, color = "red", size = 1)+
  #geom_smooth(color = "blue", se = FALSE)+
  xlab("scikit-allel Pi Estimate")+
  ylab("pixy Pi Estimate") +
  theme_bw()+
  coord_fixed(xlim = axis_lim, ylim = axis_lim)+
  scale_x_continuous(breaks = axis_breaks) +
  scale_y_continuous(breaks = axis_breaks) +
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))


# compose Figure 4
(fig4 <- ((pixy_vcf | pixy_ang) / (pixy_pg | pixy_ska)) +
  plot_layout(guides = 'collect') +
  plot_annotation(tag_levels = "A") &
  theme(axis.text.x = element_text(angle = 45, hjust = 1)))
  

ggsave(fig4, filename = "figures/Figure4_raw.pdf", useDingbats = FALSE)
ggsave(fig4, filename = "figures/Figure4_raw.png")


# An idea for an plot (S2?)
# deviation from the 1:1 line as a function of missing data

y_scale <- c(-0.03,0.01)

vcf_resid <- pi_wide %>%
  mutate(vcf_resid = resid(lm(VCFtools-pixy ~ 0, data = pi_wide, na.action = "na.exclude"))) %>%
  ggplot(aes(y = vcf_resid, x = prop_missing, fill = prop_missing)) +
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_smooth(color = "red", se = FALSE)+
  theme_bw()+
  xlab("Proportion of Data Missing")+
  ylab("VCFtools \u03C0 - pixy \u03C0")+
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))+
  ylim(y_scale)
  

pg_resid <- pi_wide %>%
  mutate(vcf_resid = resid(lm(PopGenome-pixy ~ 0, data = pi_wide, na.action = "na.exclude"))) %>%
  ggplot(aes(y = vcf_resid, x = prop_missing, fill = prop_missing)) +
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_smooth(color = "red", se = FALSE)+
  theme_bw()+
  xlab("Proportion of Data Missing")+
  ylab("PopGenome \u03C0 - pixy \u03C0")+
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))+
  ylim(y_scale)

ang_resid <- pi_wide %>%
  mutate(vcf_resid = resid(lm(ANGSD-pixy ~ 0, data = pi_wide, na.action = "na.exclude"))) %>%
  ggplot(aes(y = vcf_resid, x = prop_missing, fill = prop_missing)) +
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_smooth(color = "red", se = FALSE)+
  theme_bw()+
  xlab("Proportion of Data Missing")+
  ylab("ANGSD \u03C0 - pixy \u03C0")+
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))+
  ylim(y_scale)

ska_resid <- pi_wide %>%
  mutate(vcf_resid = resid(lm(`scikit-allel`-pixy ~ 0, data = pi_wide, na.action = "na.exclude"))) %>%
  ggplot(aes(y = vcf_resid, x = prop_missing, fill = prop_missing)) +
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_smooth(color = "red", se = FALSE)+
  theme_bw()+
  xlab("Proportion of Data Missing")+
  ylab("scikit-allel \u03C0 - pixy \u03C0")+
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))+
  ylim(y_scale)

# compose Figure S1
(figS2 <- ((vcf_resid | ang_resid) / (pg_resid | ska_resid)) +
    plot_layout(guides = 'collect') +
    plot_annotation(tag_levels = "A"))


ggsave(figS2, filename = "figures/FigureS2_raw.pdf", useDingbats = FALSE)
ggsave(figS2, filename = "figures/FigureS2_raw.png")



vcf_prop <- pi_wide %>%
  mutate(vcf_resid = resid(lm(VCFtools-pixy ~ 0, data = pi_wide, na.action = "na.exclude"))) %>%
  mutate(vcf_prop = VCFtools/pixy) %>%
  select(pixy, VCFtools, missing_sites, vcf_resid, vcf_prop) %>%
  filter(!is.infinite(vcf_prop)) %>%
  pull(vcf_prop)

ska_prop <- pi_wide %>%
  mutate(vcf_resid = resid(lm(`scikit-allel`-pixy ~ 0, data = pi_wide, na.action = "na.exclude"))) %>%
  mutate(vcf_prop = `scikit-allel`/pixy) %>%
  select(pixy, `scikit-allel`, missing_sites, vcf_resid, vcf_prop) %>%
  filter(!is.infinite(vcf_prop)) %>%
  pull(vcf_prop)

ang_prop <- pi_wide %>%
  mutate(vcf_resid = resid(lm(ANGSD-pixy ~ 0, data = pi_wide, na.action = "na.exclude"))) %>%
  mutate(vcf_prop = ANGSD/pixy) %>%
  select(pixy, ANGSD, missing_sites, vcf_resid, vcf_prop) %>%
  filter(!is.infinite(vcf_prop)) %>%
  pull(vcf_prop)

pg_resid <- pi_wide %>%
  mutate(vcf_resid = resid(lm(PopGenome-pixy ~ 0, data = pi_wide, na.action = "na.exclude"))) %>%
  mutate(vcf_prop = PopGenome/pixy) %>%
  select(pixy, PopGenome, missing_sites, vcf_resid, vcf_prop) %>%
  filter(!is.infinite(vcf_prop)) %>%
  pull(vcf_prop)

summary(vcf_prop)
summary(ska_prop)
summary(pg_resid)
summary(ang_prop)
  

