library(tidyverse)
library(genderBR)
library(readxl)



plot<-
  table(data$`Ano Base`) |> 
  as.data.frame() |> 
  dplyr::rename(
    "Ano Base" = Var1,
    "Pesquisadores" = Freq
  ) |> 
ggplot(
  aes(x= `Ano Base`, y=Pesquisadores)
  ) +
  geom_line(
    aes(group = 1),
    linewidth = 1.5,
    color= '#1B4AEF'
    )+
  
  scale_y_continuous(
    breaks = seq(0,1200,200),
    limits = c(0,1200)
  ) +
  labs(
    title = 'Quantidade de Pesquisadores por Ano Base'
  ) +
  theme(
    # plot.background = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
    axis.title.y = element_blank()
  )  


ggsave(plot = plot, filename = 'plots/plot-ano-base.png', dpi = 300)
  
