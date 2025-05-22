
# plot<-
data |> 
  select(`Ano Base`,Sexo) |> 
  table() |> 
  as.data.frame() |> 
  dplyr::rename(
    'Pesquisadores' = Freq
  ) |> 
  dplyr::filter(
    Sexo %in% c('Masculino','Feminino')
  ) |> 
  dplyr::mutate(
    totPesqr = 4420,
    'PorcetPesqui' = round(Pesquisadores/totPesqr,digits = 2)*100
  ) |> 
  ggplot(
    aes(
      x = `Ano.Base`,
      y = Pesquisadores,
      color = Sexo,
      group = `Sexo`
    )
  ) + 
  geom_line(
    linewidth = 1.5,
  ) +
  geom_text(aes(label = paste(PorcetPesqui,"%")), 
            position = position_dodge(0.9), 
            # vjust = -0.5, 
            color = "black") +
  scale_y_continuous(
    limits = c(0,600),
    breaks = seq(0,600,200)
  ) +
  scale_color_manual(
    values = c("Masculino" = "#19567C", "Feminino" = "#E32E91")
  ) +
  labs(
    title = 'Quantidade de Pesquisadores por Ano e Sexo',
    x = 'Ano Base',
    y = 'Quantidade de Pesquisadores'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.position = "top",
    legend.title = element_blank(),
  )

plot

ggsave(plot = plot, filename = 'kelyane/plot-ano-base-sexo.png', dpi = 300)
