#  PACOTES ----
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


# DadosImport-----


'IMPORTANDO SINASC'
pf.sinasc<-fs::dir_ls("data.Need.Project/sinasc-dados/", glob = "*.DBC|*.dbc") |>
  stringr::str_remove_all(pattern = ".DBC|.dbc") |>
  stringr::str_c(pattern=".dbc")

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

rm(pf.sinasc)

'IMPORTANDO SIM'

pf.sim<-fs::dir_ls("data.Need.Project/sim-dados/", glob = "*DOGO*.DBC|*DOGO*.dbc") |>
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

rm(pf.sim)

# "PROJEÇÕES POPULAÇÃO"

url <- "https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/projecoes_2018_populacao_2010_2060_20200406.xls"

download.file(url,
              destfile = "data.Need.Project/estimativa_projecao/projecoesPopulacao_2010_2060.xls",
              mode = "wb")  # Baixar o arquivo Excel

rm(url)

pop_estimada <-
  read_xls(
     path = "data.Need.Project/estimativa_projecao/projecoesPopulacao_2010_2060.xls",
     sheet = "GO",
     skip = 4) |> 
  janitor::clean_names()

pop_estimada


# microDatasus------

# if(!require(microdatasus)){
#   devtools::install_github("rfsaldanha/microdatasus")
# }
# 
# library(microdatasus)
# dados <-
#   fetch_datasus(
#     year_start = 2002,
#     year_end = 2021, uf = "GO",
#     information_system = "SIM-DO") |>
#   process_sim()





# code.Need.Q1 ------
"como 'sim.data$idade %in% 405' cuja 'id.simples' >= 5,
a seleção FOI feita de 400:404"

sim.data<-
  simdf[simdf$idade %in% 400:404,c("idade","ano","dtobito", "dtnasc")] |>
  as.data.frame() |>
  rename(data.obito=dtobito,data.nasc=dtnasc) |>
  mutate(
    # IDADE SIMPLES
    id.simples=map2(
      .x = dmy(data.obito),
      .y = dmy(data.nasc),
      .f = ~round(
        (as.numeric(.x-.y)/365),
        digits = 1)
    )
  ) |>
  unnest(id.simples)

"Pego o ano, dtobtido e dtnasc, POR 400<Idade<405(completa)
  para obter as datas para o diagrama (linha de vida).
Observação: Há um individuo que MORREU 1 DIAA ANTES
 de completar 5 anos de vida. Logo, entre em menor <5 anos"

# Numero de NASCIMENTOS DO SINASC
sinasc.data<-
  sinascdf$dtnasc |>
  stringr::str_replace(" ","") |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,nascidos=Freq)

# Numero de óbtos PELO DO SIM
sim.data<-
  sim.data$data.obito |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,obtos=Freq)

# JUNTANDO BASES
dadoDiagLex <-
  merge(
    x = sinasc.data,
    y = sim.data,
    by = "ano") |> 
  filter( ano %in%  c(2000:2021)
  )




# code.Respost.Need.Q1A ------

# CAMADA DO DIAGRAMA 
library(LexisPlotR)
library(ggplot2)

# diagLexis <-
LexisPlotR::lexis_grid(
  year_start = 2000,
  year_end = 2021,
  age_start = 0,
  age_end = 5,
  delta = 1
) +
  
  # DIAGRAMA - LEXIS  FINAL 
  annotate("text",
           x = seq(as.Date("2000-8-1"), as.Date("2021-8-1"), "years"),
           y = 0.13,
           label = dadoDiagLex$nascidos,
           color='#1b429e',size = 3) +
  annotate("text",
           x = seq(as.Date("2000-8-1"), as.Date("2021-8-1"), "years"),
           y = 2.5,
           label = dadoDiagLex$obtos,
           color='red',size = 5) +
  
  # ROTULOS DO DIAGRAMA 
  labs(
    title = "Diagrama de Lexis sobre nascimentos e óbitos menores que 5 anos de Goiás.",
    subtitle = "Dados relacionados aos anos de 2000 à 2021.", 
    x = "Coortes",
    y = "Anos Completos"
  ) +
  theme(
    plot.margin = margin(.5, .5, .5, .5, unit = "cm"),
    plot.title = element_text(size = 14),
    plot.subtitle = element_text(size = 12),
    axis.title.x = element_text(size = 10),
    axis.title.y = element_text(size = 10),
    axis.text.x = element_text(size = 10)
  ) 


ggsave(path = "figuras/graficos/",
       filename = "DiagLexis.png",
       dpi = 300,
       width = 12,
       height = 4,
       units = "cm",
       scale = 2
)




# code.Remove.NOT.Q1A------
rm(sim.data)
rm(sinasc.data)
rm(sim.data)
rm(dadoDiagLex)



# code.Need.Q1B ------
library(tidyverse)
# coluna 'IDADE', dados da 'DECLARAÇÃO DE OBITO'
"4: Anos, o segundo subcampo varia de 00 a 99.
    Exemplo: 410 == 10 anos"

# OBTOS 
n.obtos<-
  simdf[simdf$idade %in% 400:405,] |>
  dplyr::select(dtobito) |>
  dplyr::mutate(
    dtobito=format(
      dmy(dtobito),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  dplyr::rename(ano=dtobito,obtos=Freq) |>
  dplyr::filter(
    ano %in%  c(2000:2016)
  ) |> 
  dplyr::select(ano,obtos)

# n.obtos<-n.obtos[
#   n.obtos$ano %in% 2000:2016,c("ano","obtos")]


# NASCIMENTOS
n.nascimentos<-
  sinascdf |>
  select(dtnasc) |>
  dplyr::mutate(
    dtnasc=format(
      lubridate::dmy(dtnasc),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  dplyr::rename(ano=dtnasc,nasc=Freq) |> 
  filter(
    ano %in%  2000:2016
  ) |> 
  dplyr::select(ano,nasc)


# n.nascimentos<-n.nascimentos[
#   n.nascimentos$ano %in% 2000:2016,c("ano","nasc")]


# DATAFRAME  COMPLETO 
dadoSobrev<-
  merge(n.nascimentos,n.obtos, by = "ano") |> 
  
  # "sobreV=1-[soma(mortos)/nascidos-vivos]*1mil"
  # PROBABILIDADE DE SOBREVIVER EM CADA ANO
  mutate(
    pb.sobrev=map2(
      .x = obtos,
      .y = nasc,
      .f = ~round(1-((.x/.y)),digits=4),
      .progress = TRUE
    )
  ) |>
  unnest(pb.sobrev) 

write.csv(
  file = "dadoTratado/q1/Sobrev5.csv",  row.names = FALSE
)



# code.Respost.Need.Q1B ------


# install.packages("gtsummary")
# install.packages("gt")


# co.Remove.NOT.Q1B ------

rm(n.obtos)
rm(n.nascimentos)
rm(dadoSobrev)




# library(kableExtra)
# TABELA
# knitr::kable(
#   x = dadoSobrev,
#   align = "c",
#   caption = "Tabela 1: Probabilidade de um recém-nascido de Goias, das coortes de 2000 a 2016, sobreviver ao primeiro aniversário.",
#   col.names = 
#     c("Ano","Número de Nascimentos", "Numero de Obtos", "Probabilidade de Sobreviver (em cada ano)")) |> 
#   kableExtra::add_footnote(label = "Fonte: Sistemas de Informação sobre Nascidos Vivos (SINASC) e Mortalidade (SIM) do Ministério da Saúde da Unidade Federativa de Goiás, entre os anos de 2000 a 2016.")





# code.Need.Q1C ------

#  COLUNA IDADE: 400:401 (menor de 1 ano).
n.obtos<-
  simdf[simdf$idade %in% 400:401,] |>
  select(dtobito) |>
  dplyr::mutate(
    dtobito=format(
      dmy(dtobito),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtobito,obtos=Freq) |> 
  filter( 
    ano %in%  c(2000:2020)
  ) |> 
  select(ano,obtos)



# NASCIMENTOS 
n.nascimentos<-
  sinascdf |>
  select(dtnasc) |>
  dplyr::mutate(
    dtnasc=format(dmy(dtnasc),"%Y")) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtnasc,nasc=Freq) |> 
  filter( 
    ano %in%  c(2000:2020)
  ) |> 
  select(ano,nasc)


# DATAFRAME  COMPLETO 
dadoSobrev<-
  merge(
    x = n.nascimentos,
    y = n.obtos,
    by = "ano") |> 
  
  # PROBABILIDADE DE SOBREVIVER AO PRIMEIRO ANO
  # " sobre=1-[soma-mortos/nascidos-vivos]*1mil"
  
  mutate(
    pb.sobrev=map2(
      .x = obtos,
      .y = nasc,
      
      .f = ~round((1-(.x/.y)),digits=7),
      .progress = TRUE
    )
  ) |>
  unnest(pb.sobrev) 
  
  
  write.csv(
    file = "dadoTratado/q1/Sobrev1.csv",  row.names = FALSE
  )



# co.Remove.NOT.Q1C ------

rm(n.obtos)
rm(n.nascimentos)
rm(dadoSobrev)




# code.Need.Q2 ------

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

# NUMERO DE NASCIMENTOS 
nascimentos<-
  sinascdf |>
  select(ano) |> 
  filter(
    ano %in% c(2010,2019,2021)
  ) |> 
  table() |> data.frame()

nascimentos







# code.Need.Q2A.TBN ------

# - Taxa Bruta de Natalidade (TBN)
"$$
  TBN = \frac{N}{\bar{P}} \times 1000
$$
"
# 'TBN = (nascidos/população)'
'Juntando dados necessarios "popTotal" e "nascimentos".
Calculando TBN-TOTAL'

# dadoTBNatali<-
  merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tbnTotal=map2(
      .x = Freq,
      .y = populacao,
      
      .f = ~round(((.x/.y)*1000), digits = 2),
      .progress = TRUE
    )
  ) |> 
  unnest(tbnTotal)|>
  rename(populacaoTotal=populacao) |> 
  filter(
    grupo_etario == "Total" 
  )

  merge(x = popHom,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tbnTotal=map2(
      .x = Freq,
      .y = populacao,
      
      .f = ~round(((.x/.y)*1000), digits = 2),
      .progress = TRUE
    )
  ) |> 
  unnest(tbnTotal)|>
  rename(populacaoTotal=populacao) |> 
  filter(
    grupo_etario == "Total" 
  )
# dadoTBNatali<-dadoTBNatali[,-1]






# code.Remove.NOT.TBN------

rm(dadoTBNatali)
rm(nascimentos)





# code.Need.Q2A.TFG------
# - Taxa Fecundidade Geral (TFG) e Taxas específicas de fecundidade - TEF (Grafique esses valores)  
"
$$
  TFG = \frac{\text{número de nascidos vivos}}{\text{número de mulheres em idade reprodutiva}}
$$
"
# NUMERO DE NASCIMENTOS 
# NUMERO DE NASCIMENTOS 
nascimentos<-
  sinascdf |>
  select(ano) |> 
  filter(
    ano %in% c(2010,2019,2021)
  ) |> 
  table() |> data.frame()

nascimentos


tfg.mulher <-
  merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  filter(
    row_number() %in% c(1,5:11,21,25:31,41, 45:51)
  ) |> 
  mutate(
    TFG=map2(
      .x = Freq,
      .y = populacao,
      
      .f = ~((.x/.y)*1000),
      .progress = TRUE
    )
  ) |>
  unnest(TFG) |> 
  filter( grupo_etario == "Total")


tfg.mulher



# nascidos -- 2010 = 87476 
# nascidos -- 2019 =  96112 
# nascidos -- 2021 =  90961 



# code.Need.Q2B.TEF ------

#  TEF estão dentro do DATAFRAME "tbm.mulher.dado"

# TOTAL POR ANO = linhas 1,21 e 41 obs: # (N/Pbar)*1000 'Basta multiplicar as linhas por 1mil'
# GRUPO ETARIO= linhas 2:20, 22:40 e 42:60

"nascidos por idade da mãe em 2010 19 e 2021"
nascimentos<-
  sinascdf |> 
  mutate(idademae = as.numeric(as.character(idademae)),
         grupo_etario = cut(
           idademae, c(15, 20, 25, 30, 35, 40, 45,50),
           labels = c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49"),
           include.lowest = TRUE)) |> 
  select(ano,grupo_etario) |> 
  group_by() |> 
  table() |> as.data.frame() |> arrange(ano) |> 
  relocate(grupo_etario, .before = "ano") |> 
  rename(nasc.IDADE=Freq) 

# JUNTANDO BASES E CALCULANDO A TEF
tef.mulher <-
  popMul |> 
  filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49")
  ) |> 
  merge(y = nascimentos,  by = c("grupo_etario","ano"), all.x = TRUE ) |>
  mutate(
    TEF=map2(
      .x = nasc.IDADE,
      .y = populacao,
      
      .f = ~round(((.x/.y)), digits = 4),
      .progress = TRUE
    )
  ) |> 
  unnest(TEF) |> 
  arrange(ano) 
  
tef.mulher 
  
  # write.csv( file = "dadoTratado/q2/tef.mulher.csv", row.names = FALSE)






# GRAFICO TFG ------
# GRAFICO TEF 

library(ggplot2)
library(dplyr)

# plot.tfg.mulher<-
#   tef.mulher

plot.tef.ano<-
  tef.mulher |> 
  ggplot( aes(x = grupo_etario, y = TEF, color = factor(ano))) +
  geom_line(data = filter(tef.mulher,ano == 2010),
            group = 1,size = 1.5,) +
  geom_line(data = filter(tef.mulher,ano == 2019),
            group = 1,size = 1.5,) +
  geom_line(data = filter(tef.mulher,ano == 2021),
            group = 1,size = 1.5) +
  geom_point(size = 3.5) +
  scale_color_manual(values = c("blue", "green", "red")) +
  scale_y_log10() +
  
  theme_minimal() + 
  theme(
    panel.grid.major.x = element_line(size = .7, color = "grey"),
    panel.grid.major.y = element_line(size = 0.5),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
    
  ) +
  labs(
    title = "Taxa de Especifica de Fecundidade de mulheres em idade Reprodutiva",
    subtitle = "Dados referentes aos anos de 2010, 2019 e 2021",
    x = "Anoa",
    y = "Taxa de Especifica Fecundidade",
    caption = "Ano")


plot.tef.ano


ggsave(path = "figuras/graficos/",
       filename = "plot.tef.ano.png", plot = plot.tef.ano,
       dpi = 300,
       width = 12,
       height = 8,
       units = "cm",
       scale = 2
)





# code.Need.Q2A.TBR ----
# Taxa Bruta de Reprodução

# tef.mulher<- tef.mulher |> 
#   arrange(ano)

TEF.2010<-
  tef.mulher |> 
  filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
      ano %in% 2010  ) |> 
  select(TEF)|> 
  sum()


TEF.2019<-
  tef.mulher |> 
  filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
      ano %in% 2019  ) |> 
  select(TEF)|> 
  sum()


TEF.2021<-
  tef.mulher |> 
  filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
      ano %in% 2021  ) |> 
  select(TEF)|> 
  sum()

# RESPOSTA
TEF.2010.5<-
  (5*TEF.2010)

TEF.2019.5<-
  5*TEF.2019

TEF.2021.5<-
  5*TEF.2021

"
TEF.2010 == 2.001883
TEF.2019 == 2.072548
TEF.2021 == 1.953119
"




# code.Need.Q2A.TLR------



# Q2B.ComparacTaxas------
"http://tabnet.datasus.gov.br/cgi/idb2012/matriz.htm"


# Q2C.ComparacTaxas.GRAFICOS------

# code.Need.Q2A.TLR ------

# code.Need.Q3A ------

dtobto<-
  simdf[simdf$ano %in% c("2010","2019","2021"),c("ano","dtobito")] |>
  select("ano") |>
  table() |>
  data.frame() |>
  rename(numero=Freq)



# code.Need.Q3A.TBM ------

# TBM HOMENS
tbmHomem<-
  merge( x = popHom, y = dtobto, by = "ano",all.x = TRUE) |> 
  mutate(
    TBM=map2(
      .x = numero,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  )  |> unnest(TBM) 

# TBM MULHERES 
tbmMulher<-
  merge(x = popMul, y = dtobto, by = "ano",all.x = TRUE) |> 
  mutate(
    TBM=map2(
      .x = numero,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> unnest(TBM) 
 
# 

tbmHomem |> 
  filter(
    grupo_etario %in% "Total"
  ) |> 
  mutate(
    TBM = (TBM)*1000
  )

tbmMulher |> 
  filter(
    grupo_etario %in% "Total"
  ) |> 
  mutate(
    TBM = (TBM)*1000
  )


# code.Need.Q3A.TEM ------
#  RESPOSTA 




# |> 
#   write.csv( file = "dadoTratado/tbmHomem.TEspefic.mort.csv", row.names = FALSE)
tbmHomem<-
  tbmHomem |> 
  filter(
    ! grupo_etario %in% "Total"
  )

tbmMulher<-
  tbmMulher |> 
  filter(
    !grupo_etario %in% "Total")

TBM.H.M<-
  merge(x = tbmMulher, y = tbmHomem, by = c("ano","grupo_etario")) |> 
  select(ano,grupo_etario,TBM.x,TBM.y)
# |> 
#   filter(!grupo_etario %in% "Total")


# Carregar a biblioteca necessária
library(ggplot2)

#  DESEJADO ----


plot.tbm.mulher<-
  TBM.H.M %>%
  filter(grupo_etario != "Total" & grupo_etario != "Ignorado") %>%
  select(ano, grupo_etario, TBM.x) |> 
  ggplot(aes(x = grupo_etario, y = TBM.x, group = ano, color = factor(ano))) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "TBM") +
  ggtitle("Taxas Específicas de Mortalidade Feminina por idade ") +
  scale_color_manual(values = c("purple", "gold", "lightblue"),
                     labels = c("2010", "2019", "2021"),
                     name = "Ano") +
  theme_minimal()

plot.tbm.homem<-
  TBM.H.M %>%
  filter(grupo_etario != "Total" & grupo_etario != "Ignorado") %>%
  select(ano, grupo_etario, TBM.y) |> 
  ggplot(aes(x = grupo_etario, y = TBM.y, group = ano, color = factor(ano))) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "TBM") +
  ggtitle("Taxas Específicas de Mortalidade Masculina por idade") +
  scale_color_manual(values = c("darkgreen", "darkgrey", "green"),
                     labels = c("2010", "2019", "2021"),
                     name = "Ano") +
  theme_minimal()



# library(patchwork)
ploy.tbm.mulher.homem<-
  plot.tbm.mulher /plot.tbm.homem +
  theme(plot.title = element_text(hjust = 0.5))


# AS TBMs MUlher-Homem nos 3 anos  

# plot.tbm<-
  TBM.H.M |> 
  ggplot(aes(x = grupo_etario, group = ano)) +
  geom_line(aes(y = TBM.x, color = "Mulher"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "Mulher"), size = 3, fill = "darkorange") +
  geom_line(aes(y = TBM.y, color = "Homem"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "Homem"), size = 3, fill = "steelblue") +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_color_manual(values = c("Mulher" = "darkorange", "Homem" = "steelblue"),
                     labels = c("Mulher", "Homem"),
                     name = "Sexo") +
  facet_wrap(~ano, ncol = 1) +
  theme_minimal()



# install.packages("patchwork")







# -----------------


"Em 'df.M.Q3A', Há as informações de total de homens e os grupos etários.
Assim, nessas linhas 'Totais' já contem a informação da TBM e TEM por idade,
nas outras linhas - 'grupos etarios'. Para os anos de interesse"


"O mesmo para 'df.H.Q3A'."


# code.Need.Q3B ------
# SINASC 
sinasc.data<-
  sinascdf$dtnasc |>
  stringr::str_replace(" ","") |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,nascidos=Freq) |> 
  filter(
    ano == 2020
  )

# code.Need.Q3B.TMI.5qx ------
"TMI = obitos<5/nascimentos"

# Numero Médio Óbitos

num.medio<-
  simdf[simdf$idade %in% 400:405,c("ano","dtobito")] |> 
  select(dtobito) |>
  mutate(
    dtobito=format(
      dmy(dtobito),"%Y"),
  ) |> 
  filter(
    dtobito %in% 2019:2021
  ) |> 
  table() |> 
  mean()



# RESPOSTA

tmi.5q0 <-
  (num.medio/sinasc.data$nascidos)*1000

tmi.5q0
'TMI.5qx = 1.961883'


# code.Need.Q3B.TMI.1qx ------
#  CÁLCULO TMI 1qx
"TMI = obitos<1/nascimentos"

num.medio<-
 simdf[simdf$ano %in%  2019:2021,] |> 
  select(idade) |> nrow()

# RESPOSTA
tmi.1q0 <- 
  (num.medio/sinasc.data$nascidos)*1000

tmi.1q0 
'TMI.1q0 == tmi == 0.8767391'




# code.Need.Q3B.TMINeo ------
 
"TMI = obitos<1/nascimentos"

# SINASC 
sinasc.data<-
  sinascdf$dtnasc |>
  stringr::str_replace(" ","") |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,nascidos=Freq) |> 
  filter(
    ano %in% c(2019,2020,2021)
  )

# IDADE SIMPLES 
tmi.dado<-
  simdf[simdf$ano %in% c(2019, 2021),c("ano","idade","dtnasc", "dtobito")] |> 
  mutate(
    id.simpl = map2(
      .x = dmy(dtobito),
      .y = dmy(dtnasc),
      .f = ~round(
        (as.numeric(.x-.y)),digits = 3),
      .progress = TRUE
    )
  ) |>
  unnest(id.simpl) |>
  filter(id.simpl < 365)

"Assumindo que de 200:229 representam os dias com base na nomenclatura da documentação
SIM Anterior"
tmi.dado[tmi.dado$idade %in% 200:229,c("ano","idade","dtnasc", "dtobito","id.simpl")] |> 
  select(dtobito,id.simpl) |>
  mutate(
    dtobito=format(
      dmy(dtobito),"%Y"),
  ) |> 
  filter(
    dtobito %in% 2019:2021 & id.simpl <27
  ) |> 
  count()



# Soma de 2019:2021. Não há dados sobre 2020 
num.medio<- (1068)/3

# RESPOSTA
tmineo <- (num.medio/sinasc.data$nascidos)*1000


"TMINeo  2019 == 3.704012 2020 == 3.837530 2021 == 3.913765"


# 0: Idade ignorada, o segundo subcampo e 
# 1: Horas, o segundo subcampo varia de 01 a 23 
# 2: Dias, o segundo subcampo varia de 01 a 29 
# 3: Meses, o segundo subcampo varia de 01 a 11 
# 000: Idade ignorada 
# 020: 20 minutos 
# 103: 3 horas 
# 204: 4 dias 
# 305: 5 meses 


# code.Need.Q3B.TMIpos ------
tmi.dado[tmi.dado$idade %in% 200:312,c("ano","idade","dtnasc", "dtobito","id.simpl")] |> 
  select(dtobito,id.simpl) |>
  mutate(
    dtobito=format(
      dmy(dtobito),"%Y"),
  ) |> 
  filter(
    dtobito %in% 2019:2021 & id.simpl >=28 & id.simpl<=365
  ) |> 
  count()

num.medio<-(636)/3

# RESPOSTA
tmi <- (num.medio/sinasc.data$nascidos)*1000

"TMIPos  2019 == 2.205760  2020 == 2.285271 2021 == 2.330669"




# code.Need.Q3B.TMIprec ------
tmi.dado[tmi.dado$idade %in% 200:229,c("ano","idade","dtnasc", "dtobito","id.simpl")] |> 
  select(dtobito,id.simpl) |>
  mutate(
    dtobito=format(
      dmy(dtobito),"%Y"),
  ) |> 
  filter(
    dtobito %in% 2019:2021 & id.simpl<=6
  ) |> 
  count()

num.medio<-(677)/3
tmi <- (num.medio/sinasc.data$nascidos)*1000

# Resposta
"TMIPrec  2019 == 2.347955 2020 == 2.432592 2021 == 2.480917"



# code.Need.Q3B.TMIperineo ----

# code.Need.Q3C ----



# code.Need.Q3D ----

# DADOS NECESSÁRIOS 

'2010,2019,2021'
# OBTOS < 1 ANO
n1.obtos<-
  simdf[simdf$idade %in% 400:401,] |>
  select(dtobito) |>
  dplyr::mutate(
    dtobito=format(
      dmy(dtobito),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtobito,obtos=Freq)

n1.obtos<-n1.obtos[
  n1.obtos$ano %in% c(2010,2019,2021),c("ano","obtos")] |>
  rename(obtos.1ano=obtos)

# OBTO < 5 ANOS
n5.obtos<-
  simdf[simdf$idade %in% 000:404,c("idade","ano","dtobito", "dtnasc")] |> 
  select(dtobito) |>
  dplyr::mutate(
    dtobito=format(
      dmy(dtobito),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtobito,obtos=Freq)

n5.obtos<-n5.obtos[
  n5.obtos$ano %in% c(2010,2019,2021),c("ano","obtos")] |>
  rename(obtos.5ano=obtos)


# DADOS

# óbtos menores que 1 anos exato
n1.obtos[n1.obtos$ano %in% c(2010,2019,2021),c("ano","obtos.1ano")]

# óbtos menores que 5 anos exato
# n5.obtos[n5.obtos$ano %in% c(2010,2019,2021),]
n5.obtos[n5.obtos$ano %in% c(2010,2019,2021),c("ano","obtos.5ano")]

# nascimentos
sinasc.data

# DATA FRAME 
"No caso de 1q0,'Idades < 1', se os dados são de boa qualidade, pode-se
utilizar os valores obtidos a partir do cálculo direto da 'Taxa de
Mortalidade Infantil'
"

TMInfantil <-
  merge(
    x = n5.obtos,
    y = sinasc.data$nascidos ,all.x = TRUE) |> 
  rename(
    nascidos = y
  ) |> 
  
  
  merge(
    y = n1.obtos[n1.obtos$ano %in% c(2010, 2019, 2021), c("ano", "obtos.1ano")],
    by = "ano") |>
  mutate(
    TMI.1q0 = map2(
      .x = obtos.1ano,
      .y = nascidos,
      .f = ~round(((.x/.y)),digits = 5)),
    TMI.5q0 = map2(
      .x = obtos.5ano,
      .y = nascidos,
      .f = ~round(((.x/.y)),digits = 5)),
  ) |> 
  unnest(c(TMI.5q0,TMI.1q0))

TMInfantil

# OBTOS PARA A nMx

obtos<-
  simdf[simdf$ano %in% c(2010,2019,2021),] |>
  select(dtobito) |>
  dplyr::mutate(
    dtobito=format(
      dmy(dtobito),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtobito,n.obtos=Freq)

obtos


#  BASE DE DADOS MULHER 
base.TabVida.Mulher<-
popMul[popMul$ano %in% 2021,] |> 
  filter(
    ! grupo_etario %in% c("Total","GRUPO ET\u00c1RIO")
    # row_number() %in% c(4:21,25:42,46:63)
    # !row_number() %in% c(22:23, 43:44)
  ) |>
  merge( y = obtos, by = "ano", all.x = TRUE
  ) |> 
  merge( y = TMInfantil, by = "ano", all.x = TRUE
  ) |>
  relocate(
    grupo_etario,.before = "ano"
  ) |> 
  mutate(
    nMx = map2( 
      .x = n.obtos, .y = populacao, 
      .f = ~round(((.x/.y)),digits = 5), .progress = TRUE
    )
  ) |> unnest(nMx) |> 
  select(grupo_etario,ano,populacao,TMI.1q0, TMI.5q0, nMx) |> 
  mutate(
    nqx = map(
      .x = nMx,
      .f = ~(4*(.x)/(1+(4-2)*.x))
    )
  ) |> 
  unnest(nqx) |> 
  select(grupo_etario, ano, nMx,nqx) |> 
  distinct() |> 
  
  write.csv( file = "dadoTratado/base.TabVida.Mulhe.xls", row.names = FALSE)




#  BASE DE DADOS Homem 
base.TabVida.Homem<-
popHom[popHom$ano %in% 2021,] |> 
  filter(
    ! grupo_etario %in% c("Total","GRUPO ET\u00c1RIO")
    # row_number() %in% c(4:21,25:42,46:63)
    # !row_number() %in% c(22:23, 43:44)
  ) |>
  merge( y = obtos[obtos$ano %in% 2021, c("ano", "n.obtos")], by = "ano", all.x = TRUE
  ) |> 
  merge( y = TMInfantil, by = "ano", all.x = TRUE
  ) |>
  relocate(
    grupo_etario,.before = "ano"
  ) |> 
  mutate(
    nMx = map2( 
      .x = n.obtos, .y = populacao, 
      .f = ~round(((.x/.y)),digits = 5), .progress = TRUE
    )
  ) |> unnest(nMx) |> 
  select(grupo_etario,ano,populacao,TMI.1q0, TMI.5q0, nMx) |> 
  mutate(
    nqx = map(
      .x = nMx,
      .f = ~(4*(.x)/(1+(4-2)*.x))
    )
  ) |> 
  unnest(nqx) |> 
  select(grupo_etario, ano, nMx,nqx) |> 
  distinct() |> 


  write.csv(file = "dadoTratado/base.TabVida.Homem.xls", row.names = FALSE)





