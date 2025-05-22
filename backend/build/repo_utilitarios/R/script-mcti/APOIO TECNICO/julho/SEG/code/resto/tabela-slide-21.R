library(tidyverse)


path <- 'Z:/SETEC/DEPAI/CGIT/03_COIAI/Lei do Bem/Apoio Técnico (ATs)/2024/17-21 Junho/Projetos para análise/Aguardando análise - Contestação - Lei do Bem.xlsx' 

data<-
  readxl::read_xlsx(
    path = path,
  ) |> 
  dplyr::select("Ano Base","Setor","Projeto") |> 
  dplyr::group_by(`Ano Base`,`Setor`)
  
data$Projeto <- 1

data_tratado<-
  data |> 
  pivot_wider(
    id_cols = Setor,
    names_from = `Ano Base`,
    values_from = Projeto,
    values_fn = sum
  ) |> 
  select(
    "Setor", `2019`,`2020`,`2021`
  )


# Escrever o dataframe para um arquivo do Excel
openxlsx::write.xlsx(data_tratado, file = "apresentação/dado-tratado-slide21.xlsx")


