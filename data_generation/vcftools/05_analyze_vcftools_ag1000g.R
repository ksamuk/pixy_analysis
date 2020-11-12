library("tidyverse")
library("ggdark")
library("officer")
library("aod")
library("rvg")
library("ggrastr")

vcftBFS <- read.table("data/chrX-windowed-pi-vcftools_BFS.txt.windowed.pi", header = TRUE) %>%
  rename(window_pos_1 = BIN_START, window_pos_2 = BIN_END, vcftools_pi = PI) %>%
  select(window_pos_1, window_pos_2, vcftools_pi)

pixyBFS <- read.table("data/pixy_out_BFS_pi_10132019.txt", header = TRUE) %>%
  rename(pixy_pi = avg_pi)

sciBFS <- read.table("data/scikitallel_BFS_pi.txt", header = TRUE) %>%
  select(window_pos_1, window_pos_2, sci_avg_pi, sci_no_sites)


pi_df <- left_join(pixyBFS, vcftBFS) %>%
  left_join(sciBFS)

vcft <- pi_df %>%
  mutate(p_missing = count_missing/(choose(13,2)*sci_no_sites)) %>%
  #(p_missing < 0.1) %>%
  ggplot(aes(x = vcftools_pi, y = pixy_pi, color = p_missing)) + 
  ggrastr::geom_point_rast(size = 2.5, alpha = 0.8, pch = 16, raster.width = 6, raster.height = 6) +
  #geom_smooth(method="lm")+
  geom_abline(intercept = 0)+
  dark_theme_grey(base_size = 20)+
  theme(axis.line = element_line(colour = "grey50"),
        panel.grid = element_line(colour = "grey15", size = 0.5))+
  #coord_fixed()+
  scale_x_continuous(limits = c(0, 0.1), expand = c(0,0))+
  scale_y_continuous(limits = c(0, 0.1), expand = c(0,0))+
  labs(x = "vcftools", y = "pixy")+
  scale_color_viridis_c()

vcft2 <- pi_df %>%
    mutate(p_missing = count_missing/(choose(13,2)*sci_no_sites)) %>%
    mutate(p_missing = as.factor(p_missing < 0.1)) %>%
    ggplot(aes(x = vcftools_pi, y = pixy_pi, color = p_missing)) + 
    #ggrastr::geom_point_rast(size = 2, alpha = 1.0, raster.width = 6, raster.height = 6) +
    ggrastr::geom_point_rast(size = 2.5, pch = 16, alpha = 0.8, raster.width = 6, raster.height = 6) +
    #geom_smooth(method="lm")+
    geom_abline(intercept = 0)+
    dark_theme_grey(base_size = 20)+
    theme(axis.line = element_line(colour = "grey50"),
          panel.grid = element_line(colour = "grey15", size = 0.5))+
    #coord_fixed()+
    scale_x_continuous(limits = c(0, 0.1), expand = c(0,0))+
    scale_y_continuous(limits = c(0, 0.1), expand = c(0,0))+
    labs(x = "vcftools", y = "pixy")+
    #scale_color_viridis_c()+
    scale_color_manual(values  = c("grey40", "red"))

scikit <- pi_df %>%
  mutate(p_missing = count_missing/(choose(13,2)*sci_no_sites)) %>%
  #filter(p_missing < 100) %>%
  ggplot(aes(x = sci_avg_pi, y = pixy_pi, color = p_missing)) + 
  #geom_point()+
  ggrastr::geom_point_rast(size = 2.5, pch = 16, alpha = 0.8, raster.width = 6, raster.height = 6) +
  #geom_smooth(method="lm")+
  geom_abline(intercept = 0)+
  dark_theme_grey(base_size = 20)+
  theme(axis.line = element_line(colour = "grey50"),
        panel.grid = element_line(colour = "grey15", size = 0.5))+
  #coord_fixed()+
  scale_x_continuous(limits = c(0, 0.1), expand = c(0,0))+
  scale_y_continuous(limits = c(0, 0.1), expand = c(0,0))+
  labs(x="scikit-allel", y="pixy")+
  scale_color_viridis_c()

read_pptx() %>% 
  add_slide(layout = "Title and Content", master = "Office Theme") %>% 
  ph_with_vg_at(code = print(vcft), left = 0, top = 0, width = 10, height = 7.5) %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>% 
  ph_with_vg_at(code = print(vcft2), left = 0, top = 0, width = 10, height = 7.5) %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with_vg_at(code = print(scikit), left = 0, top = 0, width = 10, height = 7.5) %>%
  print(target = "slides/pi_ag1000_vcftools_scikit.pptx")
