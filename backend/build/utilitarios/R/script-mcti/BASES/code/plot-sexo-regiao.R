
plot<-
  table(
    data$Região,
    data$Sexo
  ) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Região' = Var1,
    'Sexo' = Var2,
    'Pesquisadores' = Freq
  ) |> 
    dplyr::filter(
      Sexo %in% c('Masculino','Feminino')
    ) |> 
  # summarise(
  #   'max' = sum(Pesquisadores)
  # ) |> 
    dplyr::mutate(
      totPesqr = 4420,
      'PorcetPesqui' = round(Pesquisadores/totPesqr,digits = 2)*100
    ) |> 
  ggplot(
    aes(
      x = `Sexo`,
      y = `Pesquisadores`,
      fill = `Região`,
      group = `Região`
      
    )
  ) +
  geom_bar(
    stat = 'identity',
    position = 'dodge'
  ) +
    geom_text(aes(label = paste(PorcetPesqui,"%")), 
              position = position_dodge(0.9), 
              # vjust = -0.5, 
              color = "black") +
  scale_y_continuous(
    limits = c(0,1200),
    breaks = seq(0,1200,200)
  ) +
  scale_fill_manual(
    values = c(
      "Região Centro-Oeste" = "#028090",
      "Região Nordeste" = "#507DBC",
      "Região Norte" = "#2A43D6",
      "Região Sudeste" = "#7776BC",
      "Região Sul" = "#FF674D"
    ),
  ) +
    labs(
      title = 'Quantidade de Pesquisadores por Região e Ano Base'
    ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.title = element_blank(),
  )

plot

ggsave(plot = plot, filename = 'kelyane/plot-ano-base-regiao.png', dpi = 300)





