
# TOP 10 ATIVIDADES ECONOMICAS 


table(data$`Atividade Econômica`) |> 
  as.data.frame() |> 
  dplyr::rename(
    'Atividade Econômica' = Var1,
    'frequencia' = Freq
  ) |>
  arrange(valor = desc(frequencia)) |> 
  head(10) |> 
  ggplot(
    aes(
      y= fct_reorder(`Atividade Econômica`,-desc(frequencia)),
      x = frequencia
    )
  ) + 
  geom_bar(
    stat = 'identity',
    fill= '#1B4AEF'
  )
