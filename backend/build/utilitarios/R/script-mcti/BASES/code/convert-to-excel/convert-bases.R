# bibliotecas ----
library(tidyverse)
library(genderBR)
library(readxl)
library(parallel)

# Localização do arquivo ----
setwd("C:/Users/czarg/OneDrive/Documents/github/César Gabriel/lei do bem/pesquisadores/")

options(scipen = 999)

# Import data 2018 ----


data_2018<-
  read_xlsx(
    path = 'data/dado-final/2018.xlsx',
  ) |> 
  dplyr::mutate(
    NODispendio = genderBR::get_gender(NODispendio),
    Sexo = dplyr::case_when(
      NODispendio %in% 'Male' ~ 'Masculino',
      NODispendio %in% 'Female' ~ 'Feminino',
      TRUE ~ 'ND'
    )
  )

data_2018

openxlsx::write.xlsx(data_2018, 'result/data-por-ano/2018.xlsx')

# Import data 2019 ----


data_2019<-
  read_xlsx(
    path = 'data/dado-final/2019.xlsx',
  ) |> 
  dplyr::mutate(
    NODispendio = genderBR::get_gender(NODispendio),
    Sexo = dplyr::case_when(
      NODispendio %in% 'Male' ~ 'Masculino',
      NODispendio %in% 'Female' ~ 'Feminino',
      TRUE ~ 'ND'
    )
  )

data_2019

openxlsx::write.xlsx(data_2019, 'result/data-por-ano/2019.xlsx')

# Import data 2020 ----


data_2020<-
  read_xlsx(
    path = 'data/dado-final/2020.xlsx',
  ) |> 
  dplyr::mutate(
    NODispendio = genderBR::get_gender(NODispendio),
    Sexo = dplyr::case_when(
      NODispendio %in% 'Male' ~ 'Masculino',
      NODispendio %in% 'Female' ~ 'Feminino',
      TRUE ~ 'ND'
    )
  )

data_2020

openxlsx::write.xlsx(data_2020, 'result/data-por-ano/2020.xlsx')

# Import data 2021 ----


data_2021<-
  read_xlsx(
    path = 'data/dado-final/2021.xlsx',
  ) |> 
  dplyr::mutate(
    NODispendio = genderBR::get_gender(NODispendio),
    Sexo = dplyr::case_when(
      NODispendio %in% 'Male' ~ 'Masculino',
      NODispendio %in% 'Female' ~ 'Feminino',
      TRUE ~ 'ND'
    )
  )

data_2021

openxlsx::write.xlsx(data_2021, 'result/data-por-ano/2021.xlsx')


# Import data 2021 ----


data_2022<-
  read_xlsx(
    path = 'data/dado-final/2022.xlsx',
  ) |> 
  dplyr::mutate(
    NODispendio = genderBR::get_gender(NODispendio),
    Sexo = dplyr::case_when(
      NODispendio %in% 'Male' ~ 'Masculino',
      NODispendio %in% 'Female' ~ 'Feminino',
      TRUE ~ 'ND'
    )
  )

data_2022

openxlsx::write.xlsx(data_2022, 'result/data-por-ano/2022.xlsx')


# Base completa -----
list_file<-function(diretorio) {
  arquivos <- list.files(diretorio)
  arquivos_data <- arquivos[str_detect(arquivos, "^20")]
  return(arquivos_data)
}


files<-
  list_file(
    diretorio = "C:/Users/czarg/OneDrive/Documents/github/César Gabriel/lei do bem/pesquisadores/data/dado-final/"
  )

map_df(
  .x = files,
  ~readxl::read_xlsx(
    path = paste('data/dado-final/',.x,sep = ''),
    col_types = c(
      "text", "numeric", "text",
      "text", "text", "text",
      "text", "text", "text",
      "text", "text", "text",
      "text", "text", "text",
      "text", "text", "text"
    )
  )
) |>
  mutate(
    # 'Sexo' = genderBR::get_gender(Nome),
  )
