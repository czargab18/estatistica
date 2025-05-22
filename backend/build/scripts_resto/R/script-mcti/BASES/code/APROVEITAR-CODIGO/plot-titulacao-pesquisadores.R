


plot<-
  table(data$Titulação) |> 
    as.data.frame() |> 
    dplyr::rename(
      'Titulação' = Var1,
      'valor' = Freq
    ) |> 
  ggplot(
    aes(
      x = fct_reorder(Titulação,desc(valor)),
      y = valor
      )
  ) +
  geom_bar(
    stat = "identity",
    fill= '#1B4AEF'
  ) +
  labs(
    title = 'Proporção de Pesquisadores por Titulação',
    x = 'Titulação'
  ) +
  theme(
    # plot.background = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major.y = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
    axis.title.y = element_blank()
  )



ggsave(plot = plot, filename = 'plots/plot-titulacao-pesquisadores.png', dpi = 300)
