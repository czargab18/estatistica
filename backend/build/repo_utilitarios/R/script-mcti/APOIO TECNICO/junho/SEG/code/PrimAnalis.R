library(tidyverse)


setwd("C:/Users/cesar.oliveira.INTRA/Documents/César Gabriel/Lei do bem/Apoio Tecnico")


path <-  "junho/SEG/data/Aguardando análise - 1º análise - Lei do Bem.xlsx"

# data<-
  readxl::read_xlsx(
    path = path,
  ) |> 
  dplyr::select("Ano Base","Setor","CNPJ","Projeto",'Sugestão para analisar') |> 
  dplyr::group_by(`Ano Base`,`Setor`) |> 
  dplyr::mutate(
    Projeto = 1
  ) |> 
pivot_wider(
  id_cols = Setor,
  names_from = `Ano Base`,
  values_from = c(Projeto,CNPJ),
  values_fn = list
) |> 
    mutate(
      `Projeto_2022` = purrr::map_int(.x = `Projeto_2022`, ~sum(., na.rm = TRUE)),
      
      `CNPJ_2022` = purrr::map_int(.x = `CNPJ_2022`, ~length(unique(.))),
    ) |> 
    dplyr::rename(
      '2022'  = `Projeto_2022`,
      
      'Número de empresas 2022'  = `CNPJ_2022`,
      
    ) |> 
    openxlsx::write.xlsx( file = "junho/SEG/result/result-2022.xlsx")
  