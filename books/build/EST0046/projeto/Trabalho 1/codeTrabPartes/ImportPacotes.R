#  PACOTES ---------------------------------------------------------------------------
library(fs)
library(purrr)
library(stringr)
library(tidyverse)
library(readxl)
# library(kableExtra)

# instalar o pacote read.dbc GITHUB
if(!require(read.dbc)){
  devtools::install_github("danicat/read.dbc")
} else {
  library(read.dbc)
}

# microDatasus------

if(!require(microdatasus)){
  devtools::install_github("rfsaldanha/microdatasus")
  library(microdatasus)
} else {
  library(microdatasus)
}



sistemas<-c("SIM-DO", "SIM-DOFET", "SIM-DOEXT", "SIM-DOINF", "SIM-DOMAT", "SINASC")

dados<-
  purrr::map(
    .x = sistemas,
    ~fetch_datasus(
      year_start = 2000, year_end = 2021,
      uf = "GO",
      information_system = .x)
  )


for (i in seq_along(dados)) {
  write.csv(dados[[i]], file = paste0("Trabalho 1/dataProject/", sistemas[i], ".csv"), row.names = FALSE)
}

#  ou 
dados |> 
  imap(~ write.csv(.x, file = paste0("caminho/para/pasta/", sistemas[.y], ".csv"), row.names = FALSE))


# correção dos dados

simdf$dtnasc[
  simdf$dtnasc %in% c("00001916", "10001950", "0001914", "00001922", "'11120001",
                      "0151 927", "23061004")
] <- c("03111916", "15061950", "22071914","16121922", "11041943","31031927",
       "13061905")


# BASE DE DADOS 

sinascdf<-
  readr::read_csv(file = "Trabalho 1/dataProject/SINASC.csv") |> 
  janitor::clean_names() |> 
  mutate(  dtnasc = lubridate::dmy(dtnasc),
           ano = format(lubridate::dmy(dtnasc), "%Y")  )

simdf<-
  readr::read_csv(file = "Trabalho 1/dataProject/SIM-DO.csv") |> 
  janitor::clean_names() |> 
  mutate(
    dtobito = lubridate::dmy(dtobito),
    dtnasc = lubridate::dmy(
      iconv(dtnasc, from = "UTF-8", to = "UTF-8" )   ),
    ano = format(lubridate::dmy(dtobito), "%Y") 
  )


# População Projetada -------------------------------------------------------------------



# "PROJEÇÕES POPULAÇÃO"

library(readxl)

url <- "https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/projecoes_2018_populacao_2010_2060_20200406.xls"

download.file(url,
              destfile = "Trabalho 1/dataProject/estimacoes/projecoesPopulacao_2010_2060.xls",
              mode = "wb")  # Baixar o arquivo Excel

rm(url)

pop_estimada <-
  read_xls(
    path = "Trabalho 1/dataProject/estimacoes/projecoesPopulacao_2010_2060.xls",
    sheet = "GO",
    skip = 4) |> 
  janitor::clean_names()

pop_estimada



# library(tidyverse)

popTotal<-
  pop_estimada[46:66,c("grupo_etario","x2010","x2019","x2021")] |>
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  mutate(
    ano = as.numeric(str_remove_all(ano,pattern = "x"))
  ) |> 
  arrange(ano)

#  PROJEÇÕES DA POPULAÇÃO POR SEXO "MULHER"

popMul<- pop_estimada[24:43,c("grupo_etario","x2010","x2019","x2021")] |>
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  mutate(
    ano = as.numeric(str_remove_all(ano,pattern = "x"))
  ) |> 
  arrange(ano)
#  PROJEÇÕES DA POPULAÇÃO POR SEXO "HOMEM"

popHom <-
  pop_estimada[1:20,c("grupo_etario","x2010","x2019","x2021")]|> 
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  mutate(
    ano = as.numeric(str_remove_all(ano,pattern = "x"))
  ) |> 
  arrange(ano)







# Tabua Vida ---------------------------------------------------------------


url <- "https://unbbr-my.sharepoint.com/:x:/r/personal/211029058_aluno_unb_br/_layouts/15/Doc.aspx?sourcedoc=%7B3E1B5995-A3DE-45C5-842C-1B3AD4D2914B%7D&file=Tabuas_Mortalidade%202010-2060.xls&action=default&mobileredirect=true&DefaultItemOpen=1&login_hint=211029058%40aluno.unb.br&ct=1687812093347&wdOrigin=OFFICECOM-WEB.START.EDGEWORTH&cid=775c3831-e274-4fc2-9566-e0dc730c594d&wdPreviousSessionSrc=HarmonyWeb&wdPreviousSession=97bd440d-908a-4850-9121-4b8a5680f6aa"

download.file(url,
              destfile = "Trabalho 1/dataProject/tabuaVida/Tabuas_Mortalidade 2010-2060.xls",
              mode = "wb")  # Baixar o arquivo Excel

rm(url)


TabVidaFeminina<-
  readxl::read_xlsx(
    path = "Trabalho 1/dataProject/tabuaVida/Tabuas_Mortalidade 2010-2060.xlsx",
    sheet = "GO",
    range = "K1:S305",
    ) |> 
  filter(  row_number() %in% c(1:30, 231:255, 281:305) & 
             !row_number() %in%   c(1,3:5,7,9, 232,234, 282, 284)  ) |> 
  filter(
    ! row_number() %in% c(24,47)
  ) |> 
  rename(
    grupo_etario = '...1',
    nLx = '...7'
  ) |>
   mutate(grupo_etario = case_when(
    grupo_etario == "15"  ~ "15-19",
    grupo_etario == "20"  ~ "20-24",
    grupo_etario == "25"  ~ "25-29",
    grupo_etario == "30"  ~ "30-34",
    grupo_etario == "35"  ~ "35-39",
    grupo_etario == "40"  ~ "40-44",
    grupo_etario == "45"  ~ "45-49",
    TRUE~grupo_etario
  )) |> 
  filter(
    !grupo_etario %in% c("Tábuas mulheres", "Ano:", "Idade")
  )







TabVidaMasculina<-
  readxl::read_xlsx(
    path = "Trabalho 1/dataProject/tabuaVida/Tabuas_Mortalidade 2010-2060.xlsx",
    sheet = "GO",
    range = "A1:I305",
    # skip = 8
  ) |> 
  filter(  row_number() %in% c(1:30, 231:255, 281:305) &
             !row_number() %in%   c(1,3:5,7,9, 232,234, 282, 284)  ) |>
  filter(
    ! row_number() %in% c(24,47)
  ) |> 
  rename(
    grupo_etario = 'Unidade da Federação:',
    nLx = '...7'
  ) |>
  mutate(grupo_etario = case_when(
    grupo_etario == "15"  ~ "15-19",
    grupo_etario == "20"  ~ "20-24",
    grupo_etario == "25"  ~ "25-29",
    grupo_etario == "30"  ~ "30-34",
    grupo_etario == "35"  ~ "35-39",
    grupo_etario == "40"  ~ "40-44",
    grupo_etario == "45"  ~ "45-49",
    TRUE~grupo_etario
  )) |> 
  filter(
    !grupo_etario %in% c("Tábuas mulheres", "Ano:", "Idade")
  )


# .final



