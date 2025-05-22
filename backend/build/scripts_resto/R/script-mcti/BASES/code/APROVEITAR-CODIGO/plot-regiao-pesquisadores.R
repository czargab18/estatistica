  
  plot<-
    table(data$Região) |> 
    as.data.frame() |> 
    dplyr::rename(
      'regiao' = Var1,
      'Pesquisadores' = Freq
    ) |> 
    ggplot(
      aes(
        y = fct_reorder(regiao,-desc(x = `Pesquisadores`)),
        x = `Pesquisadores`
      )
    ) + 
    geom_bar(
      stat = 'identity',
      fill= '#1B4AEF'
    ) +
    labs(
      title = 'Distribuição dos Pesquisadores por Regiões',
      x = 'Pesquisadores'
    ) +
    theme(
      panel.background = element_blank(),
      axis.ticks = element_blank(),
      panel.grid.major.x = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
      axis.title.y = element_blank()
    )
  
  
  
  ggsave(plot = plot, filename = 'plots/plot-regioes-pesquisadores.png', dpi = 300)
