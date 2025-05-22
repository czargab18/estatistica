
plot<-
  data |> 
  ggplot(
    aes(x= Dedicação)
  ) +
  geom_bar(
    fill= '#1B4AEF'
  ) +
  labs(
    title = 'Proporção do Tipo de  Dedicação dos Pesquisadores',
    x = 'Tipo de Dedicação'
  ) +
  theme(
    # plot.background = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major.y = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
    axis.title.y = element_blank()
  )



ggsave(plot = plot, filename = 'plots/plot-dedicacao-distribuicao-pesquisadores.png', dpi = 300)
