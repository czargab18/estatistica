# packages ----

# install.packages("foreign")
# install.packages("tidyverse")
# install.packages("fs")
# install.packages("devtools")

# instalar o pacote read.dbc GITHUB
if(!require(read.dbc)){
  devtools::install_github("danicat/read.dbc")
} else {
  library(read.dbc)
}

library(fs)
library(purrr)
library(stringr)
library(tidyverse)

# SINASC dataframe ----
# CORREÇÃO EXTENÇÃO ARQUIVO: .dbc e .DBC 

pf.sinasc<-fs::dir_ls("dados/sinasc-dados/", glob = "*.DBC|*.dbc") |>
  stringr::str_remove_all(pattern = ".DBC|.dbc") |>
  stringr::str_c(pattern=".dbc")

# dataframe- sinasc
sinascdf<-
  purrr::map2(
  .x = pf.sinasc,
  .y = 2000:2021,
  .f = ~ read.dbc::read.dbc(.x) |>
    # cria coluna ANO dentro de cada lista
    dplyr::mutate(ano = .y),
  .progress = TRUE
) |>
  dplyr::bind_rows() |>
  janitor::clean_names()


# SIM DATAFRAME ----

# consetando extensão dos arquivos .DBC para .dbc
pf.sim<-fs::dir_ls("dados/sim-dados/", glob = "*DOGO*.DBC|*DOGO*.dbc") |>
  stringr::str_remove_all(pattern = ".DBC|.dbc") |>
  stringr::str_c(pattern=".dbc")


simdf<-
  purrr::map2(
  .x = pf.sim,
  .y = 2000:2021,
  .f = ~ read.dbc::read.dbc(.x) |> dplyr::mutate(ano = .y),
  .progress = TRUE
) |>
  dplyr::bind_rows() |>
  janitor::clean_names()

# CORREÇÃO 14 - DADOS SIM  ----

simdf$dtnasc[
  simdf$dtnasc %in% c("00001916", "10001950", "0001914", "00001922", "'11120001",
                      "0151 927", "23061004")
] <- c("03111916", "15061950", "22071914","16121922", "11041943","31031927",
       "13061905")


# DATA DE NASCIMENTODOS - DADOS SIM

# Ao Ler os dados de cada ano, obtemos 3519 NA´s na COLUNA DTNASC
# MAS, ao converter em datas muda para 3533 NA´s 
# Significa que 14 datas estão erradas e 3519 não foram informadas

simdf[simdf$dtnasc %in% NA,] |>
  select(dtnasc) |>
  count()

#  outra forma de encontrar os NA´s da COLUNA DTNASC
is.na(simdf$dtnasc) |>
  table()

# DATA SIM ----
simdf[,c(3,5)]<-
  simdf[,c(3,5)] |> 
  dplyr::mutate(
    dtobito=format(
      dmy(dtobito),"%d-%m-%Y"),
    dtnasc=iconv(
      dtnasc, from = "ISO-8859-1", to = "UTF-8"),
    dtnasc=format(
      dmy(dtnasc),"%d-%m-%Y")
  )

# POPULAÇÃO ESTIMADA -----
   
pop_estimada<-readxl::read_xlsx(
  path = "estimativa_projecao/projecoes_2018_populacao_2010_2060_20200406.xlsx",
  skip = 4) |> 
  janitor::clean_names()





