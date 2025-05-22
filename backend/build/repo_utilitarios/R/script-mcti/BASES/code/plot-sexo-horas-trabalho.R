

plot<-
  table(
    data$`Sexo`,
    data$`Horas de trabalho – anuais`
  ) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Sexo' = Var1,
    'Horas de trabalho – anuais' = Var2,
    'Pesquisadores' = Freq
  ) |> 
    dplyr::filter(
      Sexo %in% c('Masculino','Feminino')
    ) |> 
    mutate(
      `Horas de trabalho – anuais` = as.double(`Horas de trabalho – anuais`),
      'Horas de trabalho' = dplyr::case_when(
        `Horas de trabalho – anuais` %in% min(`Horas de trabalho – anuais`):54 ~ 'menos que 54h',
        `Horas de trabalho – anuais` %in% 55:159 ~ 'de 55h a 159h',
        `Horas de trabalho – anuais` %in% 160:517 ~ 'de 160 a 517h',
        `Horas de trabalho – anuais` %in% 517:max(`Horas de trabalho – anuais`) ~ 'acima de 517h',
      )
    )  |>
  ggplot(
    aes(
      x = `Sexo`,
      y = `Pesquisadores`,
      fill = `Horas de trabalho`,
    )
  ) +
    geom_bar(
      stat = 'identity',
      position = 'dodge',
    ) +
    scale_fill_manual(
      values = c(
        'menos que 54h' = "#BB6B00",
        'de 55h a 159h' = "#210F04",
        'de 160 a 517h' = "#690500",
        'acima de 517h' = "#452103"
      ),
    ) +
  labs(
    title = 'Quantidade de Sexo e horas trabalhadas anuais.'
  ) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.title = element_blank(),
    legend.position = 'top'
  )

  plot

ggsave(plot = plot, filename = 'kelyane/plot-sexo-horas-trabalhadas.png', dpi = 300)





