
# plot<-
  data |>
    dplyr::filter(
      Sexo %in% c('Masculino','Feminino')
    ) |> 
  ggplot(
    aes(x= Sexo, fill = `Sexo`)
  ) +
  geom_bar() +
    scale_fill_manual(
      values =  c(
        'Masculino' = '#19567C',
        'Feminino' = '#E32E91'
      )
    )+
    labs(
      title = 'Proporção de Pesquisadores por Sexo',
      x = 'Sexo',
      y = 'Pesquisadores'
    ) +
    theme(
      panel.background = element_blank(),
      axis.ticks = element_blank(),
      panel.grid.major.y = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
      legend.position = "none"
    )
  
  
  
  ggsave(plot = plot, filename = 'kelyane/plot-sexo.png', dpi = 300)
  