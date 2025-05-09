# q1 -----
# library(languageserver)
# library(tidyverse)
library(foreign) # ler .dbf

# Diretórios dos arquivos
fs::dir_ls("data/T2/", glob = "*.DBF|*.dbf")

# Necessários ----
padrao <- "^(0[1-9]0[0-9]|1[0-9]1[0-9]|0000|2024|2529|3034|3539|4044|4549|5054|5559|6064|6569|7074|7579|8099)$"


ordemetaria <-
  c(
    "0-1", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
    "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
    "70-74", "75-79", "80+"
  )


# POPBR91   1991 - DATASUS ----
pop1991 <-
  foreign::read.dbf(file = "data/T2/POPBR91.DBF") |>
  janitor::clean_names() |>
  dplyr::filter(grepl("^52", munic_res)) |>
  dplyr::select(-munic_res) |>
  dplyr::filter(
    stringr::str_detect(fxetaria, pattern = padrao)
  ) |>
  dplyr::mutate(
    fxetaria = purrr::map_chr(as.character(fxetaria), ~ if (nchar(.) == 4) {
      paste0(substr(., 1, 2), "-", substr(., 3, 4))
    } else {
      .
    })
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% c("00-00", "01-01") ~ "0-1",
      fxetaria %in% c("01-01", "02-02", "03-03", "04-04") ~ "1-4",
      fxetaria %in% c("05-05", "06-06", "07-07", "08-08", "09-09") ~ "5-9",
      fxetaria %in% c("10-10", "11-11", "12-12", "13-13", "14-14") ~ "10-14",
      fxetaria %in% c("15-15", "16-16", "17-17", "18-18", "19-19") ~ "15-19",
      fxetaria %in% c("80-99") ~ "80+",
      TRUE ~ fxetaria
    ),
    #  reordenando os grupos etários
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::arrange(fxetaria)


pop1991


# POPBR00 2000 - DATASUS ----

pop2000 <-
  foreign::read.dbf(file = "data/T2/POPBR00.DBF") |>
  janitor::clean_names() |>
  dplyr::filter(grepl("^52", munic_res)) |>
  dplyr::select(-munic_res) |>
  dplyr::filter(
    stringr::str_detect(fxetaria, pattern = padrao)
  ) |>
  dplyr::mutate(
    fxetaria = purrr::map_chr(as.character(fxetaria), ~ if (nchar(.) == 4) {
      paste0(substr(., 1, 2), "-", substr(., 3, 4))
    } else {
      .
    })
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% c("00-00", "01-01") ~ "0-1",
      fxetaria %in% c("01-01", "02-02", "03-03", "04-04") ~ "1-4",
      fxetaria %in% c("05-05", "06-06", "07-07", "08-08", "09-09") ~ "5-9",
      fxetaria %in% c("10-10", "11-11", "12-12", "13-13", "14-14") ~ "10-14",
      fxetaria %in% c("15-15", "16-16", "17-17", "18-18", "19-19") ~ "15-19",
      fxetaria %in% c("80-99") ~ "80+",
      TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::arrange(fxetaria)


pop2000

# POPTBR10.csv  2010 ----

pop2010 <-
  foreign::read.dbf(file = "data/T2/POPBR10.DBF") |>
  janitor::clean_names() |>
  dplyr::filter(grepl("^52", munic_res)) |>
  dplyr::select(-munic_res) |>
  dplyr::filter(
    stringr::str_detect(fxetaria, pattern = padrao)
  ) |>
  dplyr::mutate(
    fxetaria = purrr::map_chr(as.character(fxetaria), ~ if (nchar(.) == 4) {
      paste0(substr(., 1, 2), "-", substr(., 3, 4))
    } else {
      .
    })
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% c("00-00", "01-01") ~ "0-1",
      fxetaria %in% c("01-01", "02-02", "03-03", "04-04") ~ "1-4",
      fxetaria %in% c("05-05", "06-06", "07-07", "08-08", "09-09") ~ "5-9",
      fxetaria %in% c("10-10", "11-11", "12-12", "13-13", "14-14") ~ "10-14",
      fxetaria %in% c("15-15", "16-16", "17-17", "18-18", "19-19") ~ "15-19",
      fxetaria %in% c("80-99") ~ "80+",
      TRUE ~ fxetaria
    ),
    #  reordenando os grupos etários
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::arrange(fxetaria)


View(pop2010)
# projeçoesIBGE -----------------------------------------------------------
rm(ordemetaria) # ordem etária é diferente nos 2 primeiros grupos

ordemetaria <-
c(
  "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
  "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
  "70-74", "75-79", "80+"
)

projecoesIBGE <-
  readxl::read_xlsx("data/T2/GO-projecoesIBGE.xlsx") |>
  # dplyr::filter( !dplyr::row_number() %in% c(21,22)) |>
  janitor::clean_names() |>
  # AS COLUNAS SÃO IMPORTADAS COMO ( CARACTERES & PONTO )
  #  AO CONVERTER PARA NUMERO, FICAM EM DECIMAL POR CAUSA DO PONTO

  dplyr::mutate(
    x2015 = stringr::str_replace_all(x2015, pattern = ",", replace = ""),
    x2020 = stringr::str_replace_all(x2020, pattern = ",", replace = ""),
    x2030 = stringr::str_replace_all(x2030, pattern = ",", replace = "")
  )

view(projecoesIBGE)

# 2015.projecao ----

popIBGE2015 <-
  projecoesIBGE |>
  dplyr::select(sexo, grupo_etario, x2015) |>
  # dplyr::select( !c('x2010','x2020','x2030') ) |>
  dplyr::filter(!grupo_etario %in% c(NA, "Total", "GRUPO ETÁRIO")) |>
  dplyr::rename(populacao = "x2015", fxetaria = "grupo_etario") |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "80-84" ~ "80+",
      fxetaria %in% "85-89" ~ "80+",
      fxetaria %in% "90+" ~ "80+",
      TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria),
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(as.numeric(populacao))) |>
  dplyr::arrange(sexo)


view(popIBGE2015)

# 2020.projecao ----

popIBGE2020 <-
  projecoesIBGE |>
  dplyr::select(sexo, grupo_etario, x2020) |>
  dplyr::filter(!grupo_etario %in% c(NA, "Total", "GRUPO ETÁRIO")) |>
  dplyr::rename(populacao = "x2020", fxetaria = "grupo_etario") |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "80-84" ~ "80+",
      fxetaria %in% "85-89" ~ "80+",
      fxetaria %in% "90+" ~ "80+",
      TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(as.numeric(populacao))) |>
  dplyr::arrange(sexo)

view(popIBGE2020)
# 2030.projecao ----

popIBGE2030 <-
  projecoesIBGE |>
  dplyr::select(sexo, grupo_etario, x2030) |>
  dplyr::filter(!grupo_etario %in% c(NA, "Total", "GRUPO ETÁRIO")) |>
  dplyr::rename(populacao = "x2030", fxetaria = "grupo_etario") |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "80-84" ~ "80+",
      fxetaria %in% "85-89" ~ "80+",
      fxetaria %in% "90+" ~ "80+",
      TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(as.numeric(populacao))) |>
  dplyr::arrange(sexo)

popIBGE2030


# Populacao ----
praTabuaVida <-
  readxl::read_xlsx("Trabalho 2/dataProject/projecoesIBGE/GO-projecoesIBGE.xlsx",
    sheet = "2015"
  ) |>
  janitor::clean_names() |>
  # AS COLUNAS SÃO IMPORTADAS COMO ( CARACTERES & PONTO )
  #  AO CONVERTER PARA NUMERO, FICAM EM DECIMAL POR CAUSA DO PONTO

  dplyr::mutate(
    x2014 = stringr::str_replace_all(x2014, pattern = "\\.", replace = ""),
    x2015 = stringr::str_replace_all(x2015, pattern = "\\.", replace = ""),
    x2016 = stringr::str_replace_all(x2016, pattern = "\\.", replace = ""),

    # CONVERTENDO PARA NUMERICO
    x2014 = as.numeric(x2014),
    x2015 = as.numeric(x2015),
    x2016 = as.numeric(x2016)
  ) |>
  dplyr::rename("2014" = x2014, "2015" = x2015, "2016" = x2016) |>
  dplyr::filter(!dplyr::row_number() %in% 21:22)


# desnecessário. ----
rm(padrao)
rm(ordemetaria)



dadoq2c <-
  readxl::read_xlsx("Trabalho 2/dataProject/q2c.xlsx")
