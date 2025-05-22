data$Valor

plot<-
data |> 
  select(
    `Sexo`,`Resultado da análise`,
  ) |> 
  dplyr::filter(
    Sexo %in% c('Masculino','Feminino')
  ) |> 
  table() |> 
  as.data.frame() |> 
  dplyr::rename(
    'Resultado da análise' = `Resultado.da.análise`,
    'Pesquisadores' = Freq
  ) |> 
  # summarise(
  #   'max' = max(Freq)
  # )
  ggplot(
    aes(
      x = forcats::fct_reorder(`Resultado da análise`,desc(Pesquisadores)),
      y = `Pesquisadores`,
      fill = `Sexo`,
    )
  ) +
  geom_bar(
    stat = 'identity',
    position = 'dodge'
  ) +
  scale_y_continuous(
    limits = c(0,1800),
    breaks = seq(0,1800,400)
  ) +
  scale_fill_manual(
    values =  c(
      'Masculino' = '#19567C',
      'Feminino' = '#E32E91'
    )
  )+
  labs(
    title = 'Quantidade de Pesquisadores por Sexo e Resultado da Análise',
    x = 'Resultado da Análise'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.title = element_blank(),
    legend.position = 'top'
  )

plot

ggsave(plot = plot, filename = 'kelyane/plot-sexo-result-analis.png', dpi = 300)

