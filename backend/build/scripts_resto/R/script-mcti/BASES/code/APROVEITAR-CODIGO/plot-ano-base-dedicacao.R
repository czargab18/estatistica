
plot<-
  data |> 
  select(`Ano Base`,Dedicação) |> 
  table() |> 
  as.data.frame() |> 
  dplyr::rename(
    'Pesquisadores' = Freq
  ) |> 
  ggplot(
    aes(
      x = `Ano.Base`,
      y = Pesquisadores,
      color = Dedicação,
      group = `Dedicação`
    )
  ) + 
  geom_line(
    linewidth = 1
  ) +
  scale_y_continuous(
    limits = c(0,30000),
    breaks = seq(0,30000,5000)
  ) +
  scale_color_manual(
    values = c("Exclusiva" = "#1f77b4", "Parcial" = "#ff7f0e")
  ) +
  labs(
    title = 'Quantidade de Pesquisadores por Ano Base e Dedicação',
    x = 'Ano Base',
    y = 'Quantidade de Pesquisadores'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.position = "top",
    legend.title = element_blank(),
  )


ggsave(plot = plot, filename = 'plots/plot-ano-base-dedicacao-pesquisadores.png', dpi = 300)

