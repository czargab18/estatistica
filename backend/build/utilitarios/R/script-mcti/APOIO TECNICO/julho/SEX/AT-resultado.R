library(tidyverse)

# setwd("C:/Users/cesar.oliveira.INTRA/Documents/César Gabriel/Lei do bem/Apoio Tecnico/")

# path <- 'C:/Users/cesar.oliveira.INTRA/Documents/César Gabriel/Lei do bem/Apoio Tecnico/junho/SEX/data/Contestação - resultado.xlsx' 

path <- '../SEG/data/Aguardando Análise (1ª Análise e Contestação).xlsx'

# data<-
  readxl::read_xlsx(
    path = path,
    sheet = 2
  ) |> 
  dplyr::select("Ano Base","Setor","Qtde Projetos","Resultado Análise") |> 
  dplyr::group_by(`Ano Base`,`Setor`) |> 
  tidyr::pivot_wider(
    id_cols = Setor,
    names_from = c(`Ano Base`,`Resultado Análise`),
    values_from = c(`Qtde Projetos`),
    values_fn = sum
  ) |>
    dplyr::mutate(

            # TOTAL
      
      'Total 2019' = purrr::map2_int(
        .x = `2019_Recomendado`,
        .y = `2019_Não Recomendado`,
        ~(.x + .y)
      ),
      'Total 2021' = purrr::map2_int(
        .x = `2021_Recomendado`,
        .y = `2021_Não Recomendado`,
        ~(.x + .y)
      ),
      'Total 2022' = purrr::map2_int(
        .x = `2022_Recomendado`,
        .y = `2022_Não Recomendado`,
        ~(.x + .y)
      ),
      
      # PORCETAGEM RECOMENDADO

      "% 2021 Recomendado" = purrr::map2_dbl(
        .x = `2021_Recomendado`,
        .y = `Total 2021`,
        ~ round(
          (.x/.y)*100
          )
        ),
      "% 2022 Recomendado" = purrr::map2_dbl(
        .x = `2022_Recomendado`,
        .y = `Total 2022`,
        ~ round(
          (.x/.y)*100
          )
        ),
      # PORCETAGEM NÃO RECOMENDADO
      

      "% 2021 Não Recomendado" = purrr::map2_dbl(
        .x = `2021_Não Recomendado`,
        .y = `Total 2021`,
        ~ round(
          (.x/.y)*100
          )
        ),
      "% 2022 Não Recomendado" = purrr::map2_dbl(
        .x = `2022_Não Recomendado`,
        .y = `Total 2022`,
        ~ round(
          (.x/.y)*100
          )
        ),
      
      # SUBSTITUINDO NA POR 0
      
      `2021_Recomendado` = dplyr::if_else(`2021_Recomendado` %in% NA,0,`2021_Recomendado`),
      `2022_Recomendado` = dplyr::if_else(`2022_Recomendado` %in% NA,0,`2022_Recomendado`),
      
      `2021_Não Recomendado` = dplyr::if_else(`2021_Não Recomendado` %in% NA,0,`2021_Não Recomendado`),
      `2022_Não Recomendado` = dplyr::if_else(`2022_Não Recomendado` %in% NA,0,`2022_Não Recomendado`),
      
      `Total 2021` = dplyr::if_else(`Total 2021` %in% NA,0,`Total 2021`),
      `Total 2022` = dplyr::if_else(`Total 2022` %in% NA,0,`Total 2022`),
      
      
      `% 2021 Recomendado` = dplyr::if_else(`% 2021 Recomendado` %in% NA,0,`% 2021 Recomendado`),
      `% 2022 Recomendado` = dplyr::if_else(`% 2022 Recomendado` %in% NA,0,`% 2022 Recomendado`),

      `% 2021 Não Recomendado` = dplyr::if_else(`% 2021 Não Recomendado` %in% NA,0,`% 2021 Não Recomendado`),
      `% 2022 Não Recomendado` = dplyr::if_else(`% 2022 Não Recomendado` %in% NA,0,`% 2022 Não Recomendado`),
    ) |> 
  dplyr::rename(
    "2021 Recomendado" = `2021_Recomendado`,
    "2022 Recomendado" = `2022_Recomendado`,
    "2021 Não Recomendado" = `2021_Não Recomendado`,
    "2022 Não Recomendado" = `2022_Não Recomendado`,
    
  )
  

openxlsx::write.xlsx(data, file = "junho/SEX/result/resultado-completo.xlsx")


# DADO FINAL 2021
data |> 
  dplyr::select(
    Setor,
    `2021 Não Recomendado`,
    `% 2021 Não Recomendado`,
    `2021 Recomendado`,
    `% 2021 Recomendado`,
    `Total 2021`
    ) |> 
  openxlsx::write.xlsx( file = "junho/SEX/result/resultado-2021.xlsx")

# DADO FINAL 2022

data |> 
  dplyr::select(
    Setor,
    `2022 Não Recomendado`,
    `% 2022 Não Recomendado`,
    `2022 Recomendado`,
    `% 2022 Recomendado`,
    `Total 2022`
    ) |> 
  openxlsx::write.xlsx( file = "junho/SEX/result/resultado-2022.xlsx")
  

