

# TOP 10 ATIVIDADES ECONOMICAS 

plot<-
  table(
    data$`Sexo`,
    data$`UF`
  ) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Sexo' = Var1,
    'UF'= Var2,
    'Pesquisadores' = Freq
  ) |>
  arrange(valor = desc(Pesquisadores)) |> 
  dplyr::filter(
    Sexo %in% c('Masculino','Feminino')
  ) |> 
  dplyr::mutate(
    totPesqr = 4420,
    'PorcetPesqui' = round(Pesquisadores/totPesqr,digits = 2)*100
  ) |> 
  ggplot(
    aes(
      x= forcats::fct_reorder(`UF`,desc(Pesquisadores)),
      y = Pesquisadores,
      fill = `Sexo`
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
  scale_fill_manual(
    values = c(
      "Masculino" = "#19567C",
      "Feminino" = "#E32E91"
    ),
  ) +
  labs(
    title = 'Quantidade de Pesquisadores por Sexo e Unidade Federativa',
    x = 'Unidade Federativa'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.title = element_blank(),
    legend.position = "top",
  )

plot

ggsave(plot = plot, filename = 'kelyane/plot-sexo-uf.png', dpi = 300)


