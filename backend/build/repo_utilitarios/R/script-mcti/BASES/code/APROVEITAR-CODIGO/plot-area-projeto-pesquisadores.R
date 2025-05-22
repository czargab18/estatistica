
plot<-
table(data$`Área do projeto`) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Area do Projeto' = Var1,
    'Pesquisadores' = Freq
  ) |> 
  ggplot(
    aes(
      y= fct_reorder(`Area do Projeto`,-desc(Pesquisadores)),
      x = Pesquisadores
    )
  ) + 
  geom_bar(
    stat = 'identity',
    fill= '#1B4AEF'
  ) +
  labs(
    title = 'Proporção do Área de Projetos dos Pesquisadores',
    x = 'Quantidade de Pesquisadores'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major.x = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
    axis.title.y = element_blank()
  )



ggsave(plot = plot, filename = 'plots/plot-area-projeto-distribuicao-pesquisadores.png', dpi = 300)



