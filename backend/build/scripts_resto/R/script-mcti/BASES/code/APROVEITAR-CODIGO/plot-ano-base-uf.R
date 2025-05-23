
plot<-
  table(
  data$`Ano Base`,
  data$UF
) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Ano Base' = Var1,
    'UF' = Var2,
    'Pesquisadores' = Freq
  ) |> 
  # summarise(
  #   'max' = max(Pesquisadores)
  # )
  ggplot(
    aes(
      x = `Ano Base`,
      y = `Pesquisadores`,
      color = `UF`,
      group = `UF`
      
    )
  ) +
  geom_line(
    linewidth = 1
  ) +
  scale_y_continuous(
    limits = c(0,14000),
    breaks = seq(0,14000,2000)
  ) +
  scale_color_manual(
    values = c(
      'DF'="#FF0000", 
      'SP'="#00FF00", 
      'PR'="#0000FF", 
      'RS'="#75DBCD", 
      'SC'="#FF00FF", 
      'MG'="#00FFFF",
      'RJ'="#566246", 
      'BA'="#6F1A07", 
      'MT'="#4A4A48", 
      'GO'="#C0C0C0", 
      'ES'="#A9A9A9", 
      'AM'="#808080",
      'CE'="#C6D9F0", 
      'CE'="#99B8E6", 
      'TO'="#73A2B8", 
      'RN'="#4D648B", 
      'MS'="#293852", 
      'PE'="#000A1F",
      'PA'="#00FF00"
    ),
    ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .1,linetype = 'dashed',color = '#777777'),
    legend.title = element_blank(),
  )

plot

ggsave(plot = plot, filename = 'plots/plot-ano-base-uf-pesquisadores.png', dpi = 300)





