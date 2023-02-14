## ggplot slides theme

library("tidyverse")
library(ggExtra)

theme_set(theme_light())

theme_update(
  # Axes
  axis.title = element_text(size = rel(0.85), face = "bold"),
  axis.title.x = element_text(margin = margin(t = 10)),
  axis.title.y = element_text(margin = margin(r = 10)),
  axis.text = element_text(size = rel(0.70), face = "bold"),
  axis.line = element_line(color = "black", arrow = arrow(length = unit(0.3, "lines"), type = "closed")),
  # Title
  plot.title = element_text(size = rel(1), face = "bold", margin = margin(0,0,5,0), hjust = 0),
  # Grids and borders
  panel.grid.minor = element_blank(),
  panel.border = element_blank(),
  # Legend
  legend.title = element_text(size = rel(0.8)),
  legend.text = element_text(size = rel(0.7), face = "plain"),
  legend.key = element_rect(fill = "transparent", colour = NA),
  legend.key.size = unit(0.6, "lines"),
  legend.background = element_rect(fill = "transparent", colour = NA),
  legend.margin = margin(0,0,0,0),
  legend.box.margin = margin(0,0,0,0),
  # Facetting labels
  strip.background = element_rect(fill = "#17252D", color = "#17252D"),
  strip.text = element_text(size = rel(0.85), face = "bold", color = "white", margin = margin(5,0,5,0))
)


plot <- function(...) ggplot(...)  + 
  guides(colour = guide_legend(override.aes = list(size = 4))) 



#theme_set(t)


