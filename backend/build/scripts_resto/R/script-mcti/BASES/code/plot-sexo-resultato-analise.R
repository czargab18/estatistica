plot<-
  table(
    data$`Resultado da análise`,
    data$Sexo
  ) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Resultado da análise' = Var1,
    'Sexo' = Var2,
    'Pesquisadores' = Freq
  ) |> 
  dplyr::filter(
    Sexo %in% c('Masculino','Feminino')
  ) |> 
  dplyr::mutate(
    totPesqr = 4420,
    'PorcetPesqui' = round(Pesquisadores/totPesqr,digits = 2)*100
  ) |> 
  # summarise(
  #   'max' = max(Pesquisadores)
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
  geom_text(aes(label = paste(PorcetPesqui,"%")), 
            position = position_dodge(0.9), 
            # vjust = -0.5, 
            color = "black") +
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
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.title = element_blank(),
    # legend.position = 'top'
  )

plot

ggsave(plot = plot, filename = 'kelyane/plot-sexo-result-analis.png', dpi = 300)






