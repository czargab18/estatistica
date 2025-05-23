
# plot<-
  table(
    data$`Área do projeto`,
    data$Sexo
  ) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Área do projeto' = Var1,
    'Sexo' = Var2,
    'Pesquisadores' = Freq
  ) |> 
    dplyr::filter(
      Sexo %in% c('Masculino','Feminino')
    ) |> 
    dplyr::mutate(
      totPesqr = 4420,
      'PorcetPesqui' = round(Pesquisadores/totPesqr,digits = 2)*100
    )  |> 
  # summarise(
  #   'max' = sum(Pesquisadores)
  # )
  ggplot(
    aes(
      x = fct_reorder(`Área do projeto`,Pesquisadores),
      y = `Pesquisadores`,
      fill = `Sexo`,
      
    )
  ) +
  geom_bar(
    stat = 'identity',
    position = 'dodge'
  ) +
    # geom_text(aes(label = paste(PorcetPesqui,"%")),
    #           position = position_dodge(0.9),
    #           # vjust = -0.5,
    #           color = "black") +
  scale_y_continuous(
    limits = c(0,1000),
    breaks = seq(0,1000,200)
  ) +
    scale_fill_manual(
      values =  c(
        'Masculino' = '#19567C',
        'Feminino' = '#E32E91'
      )
    )+
    labs(
    title = 'Quantidade de Pesquisadores por Região e Ano Base'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.title = element_blank(),
    # legend.position = 'top'
  ) +
    coord_flip()

plot

ggsave(plot = plot, filename = 'kelyane/plot-sexo-area-projeto.png', dpi = 300)






