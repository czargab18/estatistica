
plot<-
  data |> 
  select(`Ano Base`,`Horas de trabalho – anuais`) |> 
  table() |> 
  as.data.frame() |> 
  dplyr::rename(
    'Pesquisadores' = Freq
  ) |>
  ggplot(
    aes(
      x = `Ano.Base`,
      y = Pesquisadores,
      # color = Horas.de.trabalho...anuais,
      group = `Horas.de.trabalho...anuais`
    )
  ) + 
  geom_bar(
    stat = 'identity',
    fill = '#1B4AEF'
  ) +
  scale_y_continuous(
    limits = c(0,40000),
    breaks = seq(0,40000,5000)
  ) +
  labs(
    title = 'Quantidade de Pesquisadores por Ano e Horas de trabalho anuais',
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



ggsave(plot = plot, filename = 'plots/plot-ano-base-sexo-pesquisadores.png', dpi = 300)
