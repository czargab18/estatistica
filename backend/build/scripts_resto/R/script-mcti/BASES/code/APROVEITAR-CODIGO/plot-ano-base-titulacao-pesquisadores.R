
# plot<-
  data |> 
  select(`Ano Base`,Titulação) |> 
  table() |> 
  as.data.frame() |> 
  dplyr::rename(
    'Pesquisadores' = Freq
  ) |> 
  # dplyr::summarise(
  #   'max' = max(`Pesquisadores`)
  # )
  #   
    
  ggplot(
    aes(
      x = `Ano.Base`,
      y = Pesquisadores,
      color = Titulação,
      group = `Titulação`
    )
  ) + 
  geom_line(
    linewidth = 1,
  ) +
  scale_y_continuous(
    limits = c(0,15000),
    breaks = seq(0,15000,2500)
  ) +
  scale_color_manual(
    values = c(
      "Apoio Técnico" = "#1f77b4",
      "Doutor" = "#ffa500",       
      "Graduado" = "#f50400",
      "Mestre" = "#05079d",
      "Pós Graduado" = "#223026",
      "Técnico de Nível Médio" = "#b38471",
      "Tecnólogo" = "#7f7f7f"
    )
  ) +
  labs(
    title = 'Quantidade de Pesquisadores por Ano Base e Titulação',
    x = 'Ano Base',
    y = 'Quantidade de Pesquisadores'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.position = "top",
    legend.title = element_blank(),
    # legend.text = element_text(size = 10, hjust = 0)
  )



ggsave(plot = plot, filename = 'plots/plot-ano-base-sexo-pesquisadores.png', dpi = 300)
