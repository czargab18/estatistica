
plot<-
  table(data$UF,data$Sexo) |> 
  as.data.frame() |> 
  dplyr::rename(
    'uf' = Var1,
    'Sexo' = Var2,
    'Pesquisadores' = Freq
  ) |> 
    dplyr::filter(
      Sexo %in% c('Masculino','Feminino')
    ) |> 
  ggplot(
    aes(
      x = fct_reorder(uf,desc(x = `Pesquisadores`)),
      y = `Pesquisadores`,
      fill = `Sexo`
    )
  ) + 
  geom_bar(
    stat = 'identity',
    position = "dodge",
  ) +
    scale_fill_manual(
      values = c(
        'Feminino' = '#E32E91',
        'Masculino' = '#19567C'
      )
    ) + 
  labs(
    title = 'Distribuição dos Pesquisadores por Sexo e Unidade Federativa',
    x = 'Unidade Federativas',
    y = 'Pesquisadores'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.x = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
    axis.title.y = element_blank(),
    legend.position = 'top',
    legend.title = element_blank()
  )

plot

ggsave(plot = plot, filename = 'kelyane/plot-uf-sexo.png', dpi = 300)
  