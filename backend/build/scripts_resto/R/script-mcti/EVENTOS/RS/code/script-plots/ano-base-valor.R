
    table(
      data_rs$`Ano Base`,
      data_rs$`Valor`
    ) |> 
      as.data.frame() |> 
      dplyr::rename(
        'Ano Base' = Var1,
        'Valor' = Var2,
        'Projetos' = Freq,
      ) |> 
      dplyr::mutate(
        `labels` = dplyr::case_when(
          `Valor` %in% 0:55473 ~ 'até 55473',
          `Valor` %in% 55474:199587 ~ '55474 a 199587',
          `Valor` %in% 199588:750458 ~ '199588 a 750458',
          `Valor` %in% 750459:604728 ~ '750459 a 604728',
          `Valor` %in% 750459:604728 ~ 'acima de 604729',
          TRUE ~ `Valor`
        )
      ) |> 
      ggplot2::ggplot(
        ggplot2::aes(
          x = `Ano Base`,
          y = `Projetos`,
          color = `Ano Base`,
        )
      ) +
      ggplot2::geom_line(
        linewidth = 1.5,
      )

    
    
    
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





