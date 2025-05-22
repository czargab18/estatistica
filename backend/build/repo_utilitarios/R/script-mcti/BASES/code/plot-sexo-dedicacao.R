
plot<-
  table(
    data$`Sexo`,
    data$Dedicação
  ) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Sexo' = Var1,
    'Dedicação' = Var2,
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
  #   'max' = max(Pesquisadores),
  #   'sum' = sum(Pesquisadores)
  # )
  ggplot(
    aes(
      x = forcats::fct_reorder(`Dedicação`,desc(Pesquisadores)),
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
    limits = c(0,2000),
    breaks = seq(0,2000,400)
  ) +
    scale_fill_manual(
      values =  c(
        'Masculino' = '#19567C',
        'Feminino' = '#E32E91'
      )
    )+
  labs(
    title = 'Quantidade de Pesquisadores por Sexo e tipo de Dedicação',
    x = 'Dedicação'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.title = element_blank(),
    legend.position = 'top'
  )

plot

ggsave(plot = plot, filename = 'kelyane/plot-sexo-dedicacao.png', dpi = 300)

