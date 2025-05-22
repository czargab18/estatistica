
plot<-
  table(data$`Tipo de projeto - PB, PA ou DE`,data$Sexo) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Tipo de projeto' = Var1,
    'Sexo' = Var2,
    'Pesquisadores' = Freq
  ) |> 
    dplyr::mutate(
      totPesqr = 4420,
      'PorcetPesqui' = round(Pesquisadores/totPesqr,digits = 2)*100
    ) |> 
    dplyr::select(
      -totPesqr
    ) |> 
    dplyr::filter(
      Sexo %in% c('Masculino','Feminino')
    ) |> 
  ggplot(
    aes(
      x= fct_reorder(`Tipo de projeto`, -desc(Pesquisadores)),
      y = Pesquisadores,
      fill = Sexo
    )
  ) + 
  geom_bar(
    stat = 'identity',
    position = 'dodge'
  ) +
    scale_fill_manual(
      values =  c(
        'Masculino' = '#19567C',
        'Feminino' = '#E32E91'
      )
    )+
    geom_text(aes(label = paste(PorcetPesqui,"%")), 
              position = position_dodge(0.9), 
              # vjust = -0.5, 
              color = "black") +
  labs(
    title = 'Distribuição por Tipo de Projetos e Sexo',
    x = 'Pesquisadores'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    # panel.grid.major.y = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
    axis.title.y = element_blank(),
    legend.position = 'top',
    legend.title = element_blank()
  ) +
    coord_flip()


plot
ggsave(plot = plot, filename = 'kelyane/plot-sexo-tipo-projeto.png', dpi = 300)



