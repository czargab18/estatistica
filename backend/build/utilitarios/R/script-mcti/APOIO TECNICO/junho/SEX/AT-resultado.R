library(tidyverse)

setwd("C:/Users/cesar.oliveira.INTRA/Documents/César Gabriel/Lei do bem/Apoio Tecnico/")

path <- 'C:/Users/cesar.oliveira.INTRA/Documents/César Gabriel/Lei do bem/Apoio Tecnico/junho/SEX/data/Contestação - resultado.xlsx' 

data<-
  readxl::read_xlsx(
    path = path,
    sheet = 1
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
      'Total 2020' = purrr::map2_int(
        .x = `2020_Recomendado`,
        .y = `2020_Não Recomendado`,
        ~(.x + .y)
      ),
      'Total 2021' = purrr::map2_int(
        .x = `2021_Recomendado`,
        .y = `2021_Não Recomendado`,
        ~(.x + .y)
      ),
      
      # PORCETAGEM RECOMENDADO
      
      "% 2019 Recomendado" = purrr::map2_dbl(
        .x = `2019_Recomendado`,
        .y = `Total 2019`,
        ~ round(
          (.x/.y)*100
          )
        ),
      "% 2020 Recomendado" = purrr::map2_dbl(
        .x = `2020_Recomendado`,
        .y = `Total 2020`,
        ~ round(
          (.x/.y)*100
          )
        ),
      "% 2021 Recomendado" = purrr::map2_dbl(
        .x = `2021_Recomendado`,
        .y = `Total 2021`,
        ~ round(
          (.x/.y)*100
          )
        ),
      # PORCETAGEM NÃO RECOMENDADO
      
      "% 2019 Não Recomendado" = purrr::map2_dbl(
        .x = `2019_Não Recomendado`,
        .y = `Total 2019`,
        ~ round(
          (.x/.y)*100
          )
        ),
      "% 2020 Não Recomendado" = purrr::map2_dbl(
        .x = `2020_Não Recomendado`,
        .y = `Total 2020`,
        ~ round(
          (.x/.y)*100
          )
        ),
      "% 2021 Não Recomendado" = purrr::map2_dbl(
        .x = `2021_Não Recomendado`,
        .y = `Total 2021`,
        ~ round(
          (.x/.y)*100
          )
        ),
      
      # SUBSTITUINDO NA POR 0
      
      `2019_Recomendado` = dplyr::if_else(`2019_Recomendado` %in% NA,0,`2019_Recomendado`),
      `2020_Recomendado` = dplyr::if_else(`2020_Recomendado` %in% NA,0,`2020_Recomendado`),
      `2021_Recomendado` = dplyr::if_else(`2021_Recomendado` %in% NA,0,`2021_Recomendado`),
      
      `2019_Não Recomendado` = dplyr::if_else(`2019_Não Recomendado` %in% NA,0,`2019_Não Recomendado`),
      `2020_Não Recomendado` = dplyr::if_else(`2020_Não Recomendado` %in% NA,0,`2020_Não Recomendado`),
      `2021_Não Recomendado` = dplyr::if_else(`2021_Não Recomendado` %in% NA,0,`2021_Não Recomendado`),
      
      `Total 2019` = dplyr::if_else(`Total 2019` %in% NA,0,`Total 2019`),
      `Total 2020` = dplyr::if_else(`Total 2020` %in% NA,0,`Total 2020`),
      `Total 2021` = dplyr::if_else(`Total 2021` %in% NA,0,`Total 2021`),
      
      
      `% 2019 Recomendado` = dplyr::if_else(`% 2019 Recomendado` %in% NA,0,`% 2019 Recomendado`),
      `% 2020 Recomendado` = dplyr::if_else(`% 2020 Recomendado` %in% NA,0,`% 2020 Recomendado`),
      `% 2021 Recomendado` = dplyr::if_else(`% 2021 Recomendado` %in% NA,0,`% 2021 Recomendado`),

      `% 2019 Não Recomendado` = dplyr::if_else(`% 2019 Não Recomendado` %in% NA,0,`% 2019 Não Recomendado`),
      `% 2020 Não Recomendado` = dplyr::if_else(`% 2020 Não Recomendado` %in% NA,0,`% 2020 Não Recomendado`),
      `% 2021 Não Recomendado` = dplyr::if_else(`% 2021 Não Recomendado` %in% NA,0,`% 2021 Não Recomendado`),
    ) |> 
  dplyr::rename(
    "2019 Recomendado" = `2019_Recomendado`,
    "2020 Recomendado" = `2020_Recomendado`,
    "2021 Recomendado" = `2021_Recomendado`,
    "2019 Não Recomendado" = `2019_Não Recomendado`,
    "2020 Não Recomendado" = `2020_Não Recomendado`,
    "2021 Não Recomendado" = `2021_Não Recomendado`,
    
  )
  

openxlsx::write.xlsx(data, file = "junho/SEX/result/resultado-completo.xlsx")

#  DADO FINAL 2019 
data |> 
  dplyr::select(
    Setor,
    `2019 Não Recomendado`,
    `% 2019 Não Recomendado`,
    `2019 Recomendado`,
    `% 2019 Recomendado`,
    `Total 2019`
    ) |> 
  openxlsx::write.xlsx( file = "junho/SEX/result/resultado-2019.xlsx")

# DADO FINAL 2020
data |> 
  dplyr::select(
    Setor,
    `2020 Não Recomendado`,
    `% 2020 Não Recomendado`,
    `2020 Recomendado`,
    `% 2020 Recomendado`,
    `Total 2020`
    ) |> 
  openxlsx::write.xlsx( file = "junho/SEX/result/resultado-2020.xlsx")

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
  

