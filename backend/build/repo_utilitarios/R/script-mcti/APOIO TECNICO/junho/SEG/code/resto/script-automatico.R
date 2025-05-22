library(tidyverse)


path <- 'Z:/SETEC/DEPAI/CGIT/03_COIAI/Lei do Bem/Apoio Técnico (ATs)/2024/17-21 Junho/Projetos para análise/Aguardando análise - Contestação - Lei do Bem v1.xlsx' 

data<-
  readxl::read_xlsx(
    path = path,
  ) |> 
  dplyr::select("Ano Base","Setor","CNPJ","Projeto",'Sugestão para analisar') |> 
  dplyr::group_by(`Ano Base`,`Setor`)

data$Projeto <- 1

# data_tratado<-
  data |> 
  pivot_wider(
    id_cols = Setor,
    names_from = `Ano Base`,
    values_from = c(Projeto,CNPJ),
    values_fn = list
  ) |> 
    mutate(
      # Numero de Projetos Por Ano Base
      `Projeto_2019` = purrr::map_int(.x = `Projeto_2019`, ~sum(., na.rm = TRUE)),
      `Projeto_2020` = purrr::map_int(.x = `Projeto_2020`, ~sum(., na.rm = TRUE)),
      `Projeto_2021` = purrr::map_int(.x = `Projeto_2021`, ~sum(., na.rm = TRUE)),
      # Número de empresas por setor
      `CNPJ_2019` = purrr::map_int(.x = `CNPJ_2019`, ~length(unique(.))),
      `CNPJ_2020` = purrr::map_int(.x = `CNPJ_2020`, ~length(unique(.))),
      `CNPJ_2021` = purrr::map_int(.x = `CNPJ_2021`, ~length(unique(.))),
    ) |> 
  dplyr::rename(
  '2019'  = `Projeto_2019`,
  '2020'  = `Projeto_2020`,
  '2021'  = `Projeto_2021`,
  'Número de empresas 2019'  = `CNPJ_2019`,
  'Número de empresas 2020'  = `CNPJ_2020`,
  'Número de empresas 2021'  = `CNPJ_2021`
  
  )
  