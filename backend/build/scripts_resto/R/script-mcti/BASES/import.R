# bibliotecas ----
library(tidyverse)
library(genderBR)
library(readxl)
library(parallel)

# Computação Paralela ----

# iniciar 

compParalela <-
  parallel::makeCluster(
    parallel::detectCores()-4
    )

compParalela


# stopCluster(compParalela)



# import data ----

setwd("C:/Users/czarg/OneDrive/Documents/github/César Gabriel/lei do bem/pesquisadores/")

data<-
  readxl::read_xlsx(
    path = 'data/2018-2022.xlsx',
    sheet = 'GERAL',
  ) |>
  dplyr::mutate(
    'Sexo' = genderBR::get_gender(Nome),
  ) |> 
  # REMOVER ÚLTIMAS 3 LINHAS DO DATA FRAME (por causa da mensagem de erro)
  dplyr::mutate(
    'Sexo' = genderBR::get_gender(Nome),
    Sexo = dplyr::case_when(
      Sexo %in% "Male" ~ 'Masculino',
      Sexo %in% "Female" ~ 'Feminino',
      TRUE ~ 'ND'
    ),
    `Horas de trabalho – anuais` = dplyr::case_when(
      `Horas de trabalho – anuais` >= 2640 ~ 2640,
      `Horas de trabalho – anuais` < 0 ~ 0,
      TRUE ~  `Horas de trabalho – anuais`
    )
  )

data


# Relações para estudo ----

# [1] "Ano Base"           "CPF"                            "Nome"                          
# [4] "Sexo"               "Titulação"                      "Horas de trabalho – anuais"    
# [7] "Dedicação"          "Valor"                          "CNPJ"                          
# [10] X"Razão Social"X     "Tipo Instituição"               "Atividade Econômica"           
# [13] "UF"                 "Região"                         "Número do projeto"             
# [16] "Área do projeto"    "Tipo de projeto - PB, PA ou DE" "Resultado da análise"    





# baixar os dados tratados ----

# Escrever o dataframe para um arquivo do Excel
openxlsx::write.xlsx(data, file = "result/dados-tratado.xlsx")




# Valores únicos -----

data_cnpj<-
  data |> 
  dplyr::group_by(`Ano Base`, `CNPJ`,`Nome`)  |> 
  dplyr::summarise(
    CPF = toString(unique(CPF)),
    Nome = toString(unique((Nome))),
    Sexo = toString(unique(Sexo)),
    Titulacao = toString(unique(Titulação)),
    `Horas de trabalho` = sum(`Horas de trabalho – anuais`),
    Dedicação = toString(unique(Dedicação)),
    Valor = sum(Valor),
    `Razão Social` = toString(unique(`Razão Social`)),
    Tipo_Instituicao = toString(unique(`Tipo Instituição`)),
    `Atividade Econômica` = toString(unique(`Atividade Econômica`)),
    UF = toString(unique(UF)),
    Região = toString(unique(Região)),
    `Número do projeto` = toString(unique(`Número do projeto`)),
    `Área do projeto` = toString(unique(`Área do projeto`)),
    `Tipo de projeto` = toString(unique(`Tipo de projeto - PB, PA ou DE`)),
    `Resultado da análise` = toString(unique(`Resultado da análise`)),
    # .groups = "drop"
  ) |> 
  dplyr::mutate(
    `NumProj quant` = map_int(strsplit(`Número do projeto`, ", "), ~length(unique(.x)))
  )

data_cnpj


openxlsx::write.xlsx(data_cnpj, file = "result/dados-tratado-cnpj.xlsx")




# putras analises -----

# quantidade
length(unique(data$`Nome`)) -
length(unique(data$`CPF`))
length(unique(data$`CNPJ`))


# nomes
data |> 
  group_by(Nome) |> 
  summarise(
    # `Nome` = length(unique(`Nome`)),
    `CPF` = toString(unique(`CPF`))
  )

data |> 
  group_by(CPF) |> 
  summarise(
    `Nome` = toString(unique(`Nome`)),
    # `CPF` = toString(unique(`CPF`))
  )


# repetição de CPF

data |> 
  select(CPF,Sexo) |>
  pivot_wider(
    names_from = `Sexo`,
    values_from = `CPF`,
    values_fn = list
  ) |> 
  mutate(
    `Masculino` = map_int(`Masculino`, ~length(unique(.x))),
    `Percent_Masculino` = Masculino/(length(unique(data$`CPF`))-1),
    `Feminino` = map_int(`Feminino`, ~length(unique(.x))),
    `Percent_Feminino` = Feminino/(length(unique(data$`CPF`))-1),
    `ND` = map_int(`ND`, ~length(unique(.x))),
    `Percent_ND` = ND/(length(unique(data$`CPF`))-1),
  )

# repetição anobase e sexo

data |> 
  select(`Ano Base`,CPF,Sexo) |> 
  pivot_wider(
    names_from = c(`Ano Base`,Sexo),
    values_from = `CPF`,
    values_fn = ~length(unique(.x))) |> 
  pivot_longer(
    cols = `2018_Masculino`:`NA_ND`,
    names_to = c("Ano Base","Sexo"),
    values_to = "CPF",
    names_sep = "_"
  )

#        Masculino Feminino ND   TOTAL 
# 2018    0,73     0,03     0,23 10.714
#        Masculino Feminino ND   TOTAL
# 2019   0.72     0.03     0.25 10.467
#        Masculino Feminino ND   TOTAL
# 2020   0.71       0.24    0.03 14.871
#        Masculino Feminino ND   TOTAL
# 2021   0.70      0.25     0.30 18699
#        Masculino Feminino ND   TOTAL
# 2022  0.71       0.24     0.03 18906

# Porcet de mulheres por projeto

data |> 
  select(`Número do projeto`,CNPJ,Nome) |> 
  pivot_wider(
    names_from = c(`Número do projeto`,),
    values_from = Nome,
    values_fn = ~length(unique(.x))
  ) |> 
  openxlsx::write.xlsx(file = "result/porcetagem-mulheres-projeto.xlsx")

# Classif Sexo Novas Bases ----

list_file<-function(diretorio) {
  arquivos <- list.files(diretorio)
  arquivos_data <- arquivos[str_detect(arquivos, "^data_")]
  return(arquivos_data)
}


files<-
  list_file(
    diretorio = "C:/Users/czarg/OneDrive/Documents/github/César Gabriel/lei do bem/pesquisadores/data/"
  )


data_2018_2022<-
  map_df(
    .x = files,
    ~readxl::read_xlsx(
      path = paste('data/',.x,sep = ''),
      sheet = 'Dados Gerais',
    )
  ) |> 
  filter(!if_all(everything(), is.na)) |>
  mutate(
    'Sexo' = genderBR::get_gender(Nome),
  ) |> 
  pivot_longer(
    cols = `1ª Analise`:`3ª Analise`,
    names_to = "Analise",
    values_to = "Resultado"
  ) |> 
  dplyr::select(-`Resultado`) |> 
  mutate(
    Sexo = dplyr::case_when(
      Sexo %in% 'Male' ~ 'Masculino',
      Sexo %in% 'Female' ~ 'Feminino',
      TRUE ~ 'ND'
      )
  )

openxlsx::write.xlsx(data_2018_2022, file = "result/dados-tratado-2018-2022.xlsx")


# IMPORT RH BASE ----

list_file<-function(diretorio) {
  arquivos <- list.files(diretorio)
  arquivos_data <- arquivos[str_detect(arquivos, "^RH")]
  return(arquivos_data)
}
files<-
  list_file(
    diretorio = "C:/Users/czarg/OneDrive/Documents/github/César Gabriel/lei do bem/pesquisadores/data/"
  )

files

data_RH_2018_2019<-
  map_df(
    .x = files,
    ~readr::read_delim(
      file = paste('data/',.x,sep = ''),
      # delim = "\t",
      locale = locale(encoding = "ISO-8859-1"),
      show_col_types = FALSE 
      )
    ) |> 
  mutate(
    Sexo = genderBR::get_gender(NODispendio),
    Sexo = dplyr::case_when(
      Sexo %in% 'Male' ~ 'Masculino',
      Sexo %in% 'Female' ~ 'Feminino',
      TRUE ~ 'ND'
    )
  )

openxlsx::write.xlsx(data_RH_2018_2019, file = "result/dados-tratado-RH-2018-2019.xlsx")

# quantidade de CPFs e CNPJs únicos
length(unique(data_RH_2018_2019$`CNPJ`))
length(unique(data_RH_2018_2019$NRCNPJCPF))

# quantidade de CNPJs por ano
data_RH_2018_2019 |> 
  select(`NRAnoBase`, `CNPJ`) |>
  pivot_wider(
    names_from = `NRAnoBase`,
    values_from = `CNPJ`,
    # values_fn = ~length(unique(.x))
    values_fn = list
  )



# finalizar computação paralela
stopCluster(compParalela)