
plot<-
  table(
    data$`Sexo`,
    data$`Titulação`
  ) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Sexo' = Var1,
    'Titulação' = Var2,
    'Pesquisadores' = Freq
  ) |> 
  dplyr::mutate(
    Sexo = factor(Sexo, levels = c('Masculino', 'Feminino')),
    )
  dplyr::mutate(
    totPesqr = length(toString(unique(Pesquisadores))),
    'PorcetPesqui' = round(
      Pesquisadores/totPesqr,
      digits = 2)*100
  )
  # summarise(
  #   'max' = max(Pesquisadores)
  # )
    dplyr::filter(
      Sexo %in% c('Masculino','Feminino')
    ) |> 
  ggplot(
    aes(
      x= forcats::fct_reorder(`Titulação`,-desc(Pesquisadores)),
      y = `Pesquisadores`,
      fill = `Sexo`,
      group = `Sexo`
    )
  ) +
  geom_bar(
    stat = 'identity',
    position = "dodge",
  ) +
  geom_text(aes(label = paste(PorcetPesqui,"%")), 
            position = position_dodge(0.9), 
            # vjust = -0.5, 
            color = "black") +
  coord_flip() +
  # scale_y_continuous(
  #   limits = c(0,1200),
  #   breaks = seq(0,1200,200)
  # ) +
    scale_fill_manual(
      breaks = c('Masculino', 'Feminino'),
      labels = c('Masculino', 'Feminino'),
      values = c(
        "Masculino" = "#19567C",
        "Feminino" = "#E32E91"
      ),
    ) +
  labs(
    title = 'Quantidade de Pesquisadores por Sexo e Titulação',
    x = '',
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.title = element_blank(),
    legend.position = "top",
  )
  

plot

ggsave(plot=plot,filename = 'kelyane/plot-sexo-titulacao.png', dpi = 300)





