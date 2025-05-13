library(tidyverse)


path <- 'Z:/SETEC/DEPAI/CGIT/03_COIAI/Lei do Bem/Apoio Técnico (ATs)/2024/17-21 Junho/Projetos para análise/Aguardando análise - 1º análise - Lei do Bem.xlsx' 

data<-
  readxl::read_xlsx(
    path = path,
  )



data |> 
  filter(
    Setor == "Transversal" & `Ano Base` == 2019
  ) |> 
  print(max_extra_cols = )



data |> 
  dplyr::filter(
    Setor == "Agroindústria e Alimentos" & 
      `Ano Base` == 2019
  )
