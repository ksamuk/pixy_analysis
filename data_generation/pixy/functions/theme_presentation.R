theme_presentation <- function(base_size = 24, title_size = 28, legend_size = 18, 
                              bg_col = "grey25", panel_col = "white", text_col = "white",
                              grid_col = "grey50",
                              base_family = "") {
  # Starts with theme_grey and then modify some parts
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(
      strip.background = element_blank(),
      strip.text.x = element_text(size = base_size,colour=text_col),
      strip.text.y = element_text(size = base_size,colour=text_col),
      axis.text.x = element_text(size= base_size,colour=text_col),
      axis.text.y = element_text(size= base_size,colour=text_col),
      axis.ticks =  element_line(colour = text_col), 
      axis.title.x= element_text(size=title_size,colour=text_col),
      axis.title.y= element_text(size=title_size,angle=90,colour=text_col),
      #legend.position = "none", 
      panel.background = element_rect(fill=panel_col, color = NULL), 
      panel.border =element_blank(), 
      panel.grid = element_line(color = grid_col, size = 0.5),
      panel.grid.major.x = element_blank(), 
      panel.grid.minor.x = element_blank(), 
      panel.grid.minor.y = element_blank(), 
      panel.margin = unit(1.0, "lines"), 
      plot.background = element_rect(fill=bg_col, color = NULL), 
      plot.title = element_text(size=base_size,colour=text_col), 
      plot.margin = unit(c(1.5, 1.5, 1.5, 1.5), "lines"),
      axis.line = element_line(colour = text_col),
      legend.background=element_rect(fill=bg_col),
      legend.title = element_text(size=legend_size,colour=text_col),
      legend.text = element_text(size=legend_size,colour=text_col),
      legend.key = element_rect( fill = bg_col),
      legend.key.size = unit(c(0.5, 0.5), "lines")
    )
}
