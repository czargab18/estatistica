library(tidyverse)


path <- 'junho/SEG/data/Aguardando análise - Contestação - Lei do Bem v1.xlsx' 

# data<-
  readxl::read_xlsx(
    path = path,
  ) |> 
  dplyr::select("Ano Base","Setor","Projeto") |> 
  dplyr::group_by(`Ano Base`,`Setor`) |> 
    dplyr::mutate(
      Projeto = 1
    ) |>  
  tidyr::pivot_wider(
    id_cols = Setor,
    names_from = `Ano Base`,
    values_from = Projeto,
    values_fn = sum
  ) |> 
    dplyr::select(
      "Setor", `2019`,`2020`,`2021`
      ) |> 
    mutate(
      `2019` = dplyr::if_else(`2019` %in% NA,0, `2019`),
      `2020` = dplyr::if_else(`2020` %in% NA,0, `2020`),
      `2021` = dplyr::if_else(`2021` %in% NA,0, `2021`),
    ) |> 
    openxlsx::write.xlsx(
      file = "junho/SEG/result/result-aguard-analise-contest-2019-2020-2021.xlsx")


