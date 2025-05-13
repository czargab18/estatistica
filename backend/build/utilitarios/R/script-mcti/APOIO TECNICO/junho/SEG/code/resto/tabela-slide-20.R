library(tidyverse)


path <- 'Z:/SETEC/DEPAI/CGIT/03_COIAI/Lei do Bem/Apoio Técnico (ATs)/2024/17-21 Junho/Projetos para análise/Aguardando análise - 1º análise - Lei do Bem.xlsx' 

data<-
  readxl::read_xlsx(
    path = path,
    sheet = 1
  ) |> 
  dplyr::select(
    c(`Ano Base`,Setor,`Sugestão para analisar`,Projeto)
  ) |> 
   pivot_longer(
     cols = `Sugestão para analisar`,
     names_to = "Mérito_Categoria",
     values_to = "Sugestão"
   ) |> 
  dplyr::select(-`Mérito_Categoria`) |> 
  dplyr::arrange(`Setor`) |> 
  dplyr::group_by(Setor)


view(data)

data$Projeto <- 1

view(data)

# verificar valores NA no dataset 
# data_pivotado <-
  data |> 
  pivot_wider(
    names_from = Sugestão,
    values_from = c(Projeto),
    values_fn = sum
  ) |> 
  filter(
    `Ano Base` == 2022
  ) |> view()
  
  # Escrever o dataframe para um arquivo do Excel
  openxlsx::write.xlsx(data_pivotado, file = "dados-tratado-slide.xlsx")
  
    
