library(tidyverse)

setwd("C:/Users/czarg/OneDrive/Documents/github/César Gabriel/Lei do bem/Apoio Tecnico/julho/SEG/")

path <- 'data/Aguardando Análise (1ª Análise e Contestação).xlsx' 

# data<-
  readxl::read_xlsx(
    path = path,
    sheet = 2
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
      "Setor",`2021`,`2022`
      ) |> 
    mutate(
      `2021` = dplyr::if_else(`2021` %in% NA,0, `2021`),
      `2022` = dplyr::if_else(`2022` %in% NA,0, `2022`),
    ) |> 
    dplyr::arrange(`Setor`) |> 
    openxlsx::write.xlsx(
      file = "result/aguard-analise-contest-2021-2022.xlsx")


