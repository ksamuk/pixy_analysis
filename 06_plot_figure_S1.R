library("tidyverse")
library("patchwork")

#library("officer")
#library("aod")
#library("rvg")
#library("ggrastr")


######################################## 
# Figure S2, ag1000g data for dxy
######################################## 

dxy_dat <- read_rds("data/ag1000g_dxy_all.rds")

# add in additional missing data counts
dxy_dat <- dxy_dat %>%
  mutate(missing_sites = ((window_pos_2 - window_pos_1 + 1)- no_sites)) %>%
  mutate(count_missing_full = count_missing + (18^2) * missing_sites)

# number of total possible comparisons 
# (for converting count missing to a proportion)
# this is the max number of comparions at a site (18 choose 2)
# multiplied by the max number of sites in a window (10000)
# this value is the same for pi and dxy because 
# the two populations both have 18 individuals

comps_max <- 18^2 * 10000

# pi data to wide format

dxy_wide <- dxy_dat %>%
  group_by(method) %>% 
  #mutate(row_id = row_number()) %>%
  spread(key = method, value = avg_dxy) %>%
  ungroup %>%
  mutate(prop_missing = count_missing_full/comps_max)

dxy_wide$prop_missing %>% summary

# share theming elements for figure 3
fill_title <- "Prop.\nMissing"
color_limits <- c(0.0,0.257)
axis_lim <- c(0, 0.0325)
point_size <- 2.5
stroke_size <- 0.15
axis_breaks <- seq(0,0.03, by = 0.005)

# pixy vs popgenome
pixy_pg <- dxy_wide %>%
  ggplot(aes(y = pixy, x = PopGenome, fill = prop_missing))+
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size)+
  geom_abline(slope = 1, intercept = 0, color = "red", size = 1)+
  #geom_smooth(color = "blue", se = FALSE)+
  xlab("PopGenome dxy Estimate")+
  ylab("pixy dxy Estimate") +
  theme_bw()+
  coord_fixed(xlim = axis_lim, ylim = axis_lim)+
  scale_x_continuous(breaks = axis_breaks) +
  scale_y_continuous(breaks = axis_breaks) +
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))


# pixy vs ANGSD
pixy_ang <- dxy_wide %>%
  ggplot(aes(y = pixy, x = ANGSD, fill = prop_missing))+
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size)+
  geom_abline(slope = 1, intercept = 0, color = "red", size = 1)+
  #geom_smooth(color = "blue", se = FALSE)+
  xlab("ANGSD dxy Estimate")+
  ylab("pixy dxy Estimate") +
  theme_bw()+
  coord_fixed(xlim = axis_lim, ylim = axis_lim)+
  scale_x_continuous(breaks = axis_breaks) +
  scale_y_continuous(breaks = axis_breaks) +
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))


# pixy vs scikit-allel
pixy_ska <- dxy_wide %>%
  ggplot(aes(y = pixy, x = `scikit-allel`, fill = prop_missing))+
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size)+
  geom_abline(slope = 1, intercept = 0, color = "red", size = 1)+
  #geom_smooth(color = "blue", se = FALSE)+
  xlab("scikit-allel dxy Estimate")+
  ylab("pixy dxy Estimate") +
  theme_bw()+
  coord_fixed(xlim = axis_lim, ylim = axis_lim)+
  scale_x_continuous(breaks = axis_breaks) +
  scale_y_continuous(breaks = axis_breaks) +
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))


# compose Figure S1
(figS1 <- ((pixy_ang | pixy_pg) / (pixy_ska | pixy_ska)) +
  plot_layout(guides = 'collect') +
  plot_annotation(tag_levels = "A") &
  theme(axis.text.x = element_text(angle = 45, hjust = 1)))
  

ggsave(figS1, filename = "figures/FigureS1_raw.pdf", useDingbats = FALSE)
ggsave(figS1, filename = "figures/FigureS1_raw.png")

# An idea for an plot (S3?)
# deviation from the 1:1 line as a function of missing data

yscale <- c(-0.04, 0.03)

pg_resid <- dxy_wide %>%
  mutate(vcf_resid = resid(lm(PopGenome-pixy ~ 0, data = dxy_wide, na.action = "na.exclude"))) %>%
  ggplot(aes(y = vcf_resid, x = prop_missing, fill = prop_missing)) +
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_smooth(color = "red", se = FALSE)+
  theme_bw()+
  xlab("Proportion of Data Missing")+
  ylab("PopGenome dxy - pixy dxy ")+
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))+
  ylim(y_scale)

ang_resid <- dxy_wide %>%
  mutate(vcf_resid = resid(lm(ANGSD-pixy ~ 0, data = dxy_wide, na.action = "na.exclude"))) %>%
  ggplot(aes(y = vcf_resid, x = prop_missing, fill = prop_missing)) +
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_smooth(color = "red", se = FALSE)+
  theme_bw()+
  xlab("Proportion of Data Missing")+
  ylab("ANGSD dxy - pixy dxy")+
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))+
  ylim(y_scale)

ska_resid <- dxy_wide %>%
  mutate(vcf_resid = resid(lm(`scikit-allel`-pixy ~ 0, data = dxy_wide, na.action = "na.exclude"))) %>%
  ggplot(aes(y = vcf_resid, x = prop_missing, fill = prop_missing)) +
  geom_point(size = point_size, shape = 21, color = "black", stroke = stroke_size, alpha = alpha_val)+
  geom_smooth(color = "red", se = FALSE)+
  theme_bw()+
  xlab("Proportion of Data Missing")+
  ylab("scikit-allel dxy - pixy dxy")+
  scale_fill_viridis_c(limits = color_limits)+ 
  guides(fill = guide_legend(title = fill_title))+
  ylim(y_scale)

# compose Figure S3
(figS3 <- ((ang_resid | pg_resid) / (ska_resid | ska_resid)) +
    plot_layout(guides = 'collect') +
    plot_annotation(tag_levels = "A") &
    theme(axis.text.x = element_text(angle = 45, hjust = 1)))


ggsave(figS3, filename = "figures/FigureS3_raw.pdf", useDingbats = FALSE)
ggsave(figS3, filename = "figures/FigureS3_raw.png")  

