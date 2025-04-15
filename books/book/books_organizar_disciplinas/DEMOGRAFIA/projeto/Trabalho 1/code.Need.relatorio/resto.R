
# Load-data-Manipulação ---------------------------------------------------

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



# TABUA DE VIDA 2010 -----
# 
# 
# tabuaVida<-readxl::read_xlsx(
#   path = "TabuasVida/tabuaVida (1).xlsx") |> 
#   janitor::clean_names()





# QUESTÃO 01 - Diagrama de Lexis --------------------------------------------------------------

# Q1-A ----
#  a) Construir o Diagrama de Lexis para os dados de nascidos vivos de 2000 a
#     2021 da UF escolhida (SINASC) e de óbitos menores de 5 anos (idades simples)
#     para o mesmo período segundo ano de nascimento.

# CODE ----
# SIM DATA - ANÁLISE DA IDADE SIMPLES 
'Pego o ano, dtobtido e dtnasc, POR 400<Idade<405(completa)
  para obter as datas para o diagrama (linha de vida).'

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

'Observação: Há um individuo que MORREU 1 DIAA ANTES
 de completar 5 anos de vida. Logo, entre em menor <5 anos'

"como 'sim.data$idade %in% 405' cuja 'id.simples' >= 5,
a seleção FOI feita de 400:404"
# sim.data[sim.data$idade %in% 405,c("idade","id.simples")]

# DIAGRAMA LEXIS ----
"PARA CONSTRUIR O DIAGRAMA DE LEXIS"

# SINASC 
sinasc.data<-
  sinascdf$dtnasc |>
  stringr::str_replace(" ","") |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,nascidos=Freq)

# SIM
sim.data<-
  sim.data$data.obito |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,obtos=Freq)

# [DIAG.-LEXIS] DATA FRAME COM NASCIMENTOS E OBTOS 

df.diagLexis <-
  merge(
    x = sinasc.data,
    y = sim.data,
    by = "ano")

# EXPORTANDO DADO - DIAGRAMA LEXIS
write.csv(df.diagLexis, file = "dadoTratado/quest.1a.csv", row.names = FALSE)

# CONSTRUÇÃO DO DIAGRAMA - LEXIS 

"SEM LINHA DE VIDA"
library(LexisPlotR)

# FILTRO ANOS '2002:2021'
df.diagLe<-
  df.diagLexis[df.diagLexis$ano %in% 2002:2021,]

# CAMADA DO DIAGRAMA 
diagLexis <-
  LexisPlotR::lexis_grid(
    year_start = 2002,
    year_end = 2021,
    age_start = 0,
    age_end = 5,
    delta = 1
  ) +
  
  # DIAGRAMA - LEXIS  FINAL 
  
  
  annotate("text",
           x = seq(as.Date("2002-8-1"), as.Date("2021-8-1"), "years"),
           y = 0.13,
           label = df.diagLe$nascidos,
           color='#1b429e',size = 3.5) +
  annotate("text",
           x = seq(as.Date("2002-8-1"), as.Date("2021-8-1"), "years"),
           y = 2.5,
           label = df.diagLe$obtos,
           color='red',size = 5) +
  
  # ROTULOS DO DIAGRAMA 
  
  labs(
    title = "Diagrama de Lexis sobre nascimentos e óbitos menores que 5 anos de Goiás.",
    subtitle = "Dados relacionados aos anos de 2000 à 2021.", 
    x = "Coortes",
    y = "Anos Completos"
  ) +
  theme(
    plot.margin = margin(1, .5, .1, .1, unit = "cm"),
    plot.title = element_text(size = 16),
    plot.subtitle = element_text(size = 12),
    axis.title.x = element_text(size = 10),
    axis.title.y = element_text(size = 10),
    axis.text.x = element_text(size = 10)
  )

# EXPORTANDO DIAGRAMA DE LEXIS FINAL 

ggsave(path = "imagens/",
       filename = "DiagLexis.png", plot = diagLexis,
       dpi = 300,
       # width = 12,
       # height = 8,
       units = "cm",
       scale = 2
)


# Q1-B ----
# b) Supondo população fechada (inexistência de migração), calcule a probabilidade
#    de um recém-nascido na UF, ou território de escolha, sobreviver à idade exata
#    5 para as coortes de 2000 a 2016.

# CODE ----

# coluna 'IDADE', dados da 'DECLARAÇÃO DE OBITO'
"4: Anos, o segundo subcampo varia de 00 a 99.
    Exemplo: 410 == 10 anos"

# OBTOS 
n.obtos<-
  simdf[simdf$idade %in% 400:405,] |>
  select(dtobito) |>
  dplyr::mutate(
    dtobito=format(
      dmy(dtobito),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtobito,obtos=Freq)

n.obtos<-n.obtos[
  n.obtos$ano %in% 2000:2016,c("ano","obtos")]


# NASCIMENTOS
n.nascimentos<-
  sinascdf |>
  select(dtnasc) |>
  dplyr::mutate(
    dtnasc=format(
      dmy(dtnasc),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtnasc,nasc=Freq)

n.nascimentos<-n.nascimentos[
  n.nascimentos$ano %in% 2000:2016,c("ano","nasc")]


# DATAFRAME  COMPLETO 
df.nasc.obto<-
  merge(n.nascimentos,n.obtos, by = "ano")

# PROBABILIDADE DE SOBREVIVER EM CADA ANO
"sobreV=1-[soma(mortos)/nascidos-vivos]*1mil"

pb.sobreviver<-
  df.nasc.obto |>
  mutate(
    pb.sobrev=map2(
      .x = df.nasc.obto$obtos,
      .y = df.nasc.obto$nasc,
      .f = ~round(1-((.x/.y)),digits=4),
      .progress = TRUE
    )
  ) |>
  unnest(pb.sobrev)

# RESPOSTA 1B ----

# PROBABILIDADE DE SOBREVIVER ENTRE 2000 E 2016
prod(pb.sobreviver$pb.sobrev)

'RESPOSTA = 0.9534497'

# EXPORTANDO OS DADOS
write.csv(pb.sobreviver, file = "dadoTratado/quest.1b.csv", row.names = FALSE)



# Q1-C ----
# c) Considerando o mesmo pressuposto, calcule a probabilidade de sobreviver ao
#    primeiro aniversário dos recém-nascidos no período de 2000 a 2020.

# CODE ----
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
  rename(ano=dtobito,obtos=Freq)

n.obtos<-n.obtos[
  n.obtos$ano %in% 2000:2020,c("ano","obtos")]


n.nascimentos<-
  sinascdf |>
  select(dtnasc) |>
  dplyr::mutate(
    dtnasc=format(dmy(dtnasc),"%Y")) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtnasc,nasc=Freq)

n.nascimentos<-n.nascimentos[
  n.nascimentos$ano %in% 2000:2020,c("ano","nasc")]

# DATAFRAME  COMPLETO 
df.nasc.obto<-
  merge(
    x = n.nascimentos,
    y = n.obtos,
    by = "ano")

# PROBABILIDADE DE SOBREVIVER AO PRIMEIRO ANO
" sobre=1-[soma-mortos/nascidos-vivos]*1mil"

pb.sobreviver<-
  df.nasc.obto |>
  mutate(
    pb.sobrev=map2(
      .x = df.nasc.obto$obtos,
      .y = df.nasc.obto$nasc,
      
      .f = ~round((1-(.x/.y)),digits=7),
      .progress = TRUE
    )
  ) |>
  unnest(pb.sobrev)

# RESPOSTA 1C ----

prod(pb.sobreviver$pb.sobrev)

'RESPOSTA = 0.9788178'

# EXPORTANDO OS DADOS
write.csv(
  pb.sobreviver,
  file = "dadoTratado/quest.1c.csv",
  row.names = FALSE)




# Q1-D ----
# d) Comente sobre os valores encontrados. Não esquecer a qualidade da informação
#     trabalhada.# d) Comente sobre os valores encontrados. Não esquecer a
#     qualidade da informação trabalhada.






# QUESTÃO 02 - Natalidade/Fecundidade --------------------------------------------------------------

# Q2A----

# a) Com base nos dados do SINASC para os de 2010, 2019 e  2021 e na
#    população por sexo e idade estimada (projetada), construa os seguintes
#    indicadores para a Unidade da Federação:

"dados das Projeções da população por idade e sexo."
# https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fftp.ibge.gov.br%2FProjecao_da_Populacao%2FProjecao_da_Populacao_2018%2Fprojecoes_2018_populacao_2010_2060_20200406.xls&wdOrigin=BROWSELINK

pop_estimada

# CODE ----

popTotal<-
  pop_estimada[46:66,c("grupo_etario","x2010","x2019","x2021")] |>
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  arrange(ano) |>
  mutate(
    ano = str_remove_all(ano,pattern = "x")
  )


popMul<-
  pop_estimada[24:43,c("grupo_etario","x2010","x2019","x2021")] |>
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  arrange(ano) |>
  mutate(
    ano = str_remove_all(ano,pattern = "x")
  )

popHom <-
  pop_estimada[1:20,c("grupo_etario","x2010","x2019","x2021")]|> 
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  arrange(ano) |>
  mutate(
    ano = str_remove_all(ano,pattern = "x")
  )

# NASCIMENTOS 
sinasc.data<-
  sinascdf$dtnasc |>
  stringr::str_replace(" ","") |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,nascidos=Freq)

nascimentos <-
  sinasc.data[sinasc.data$ano %in% c(2010,2019,2021),]


# TBN ----

# TBN/popTOTAL Taxa Bruta de Natalidade  'TBN = (nascidos/população)'

'Juntando dados necessarios "popTotal" e "nascimentos".
Calculando TBN-TOTAL'
tbn.popTotal.dado<-
  merge(x = popTotal,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tbnTotal=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(tbnTotal)|>
  rename(populacaoTotal=populacao)

tbn.popTotal.dado

# TBN/popMULHERES Taxa Bruta de Natalidade  'TBN = (nascidos/população)'

'Juntando dados necessarios "popMul" e "nascimentos".
Calculando TBN-TOTAL'
tbn.mulher.dado<-
  merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tbnMulher=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(tbnMulher)|>
  rename(populacaoMulher=populacao)

tbn.mulher.dado

# TBM/popHOMENS Taxa Bruta de Natalidade  'TBN = (nascidos/população)'

'Juntando dados necessarios "popHom" e "nascimentos".
Calculando TBN-HOMENS'

tbn.homem.dado<-merge(x = popHom,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tbmHomem=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(tbmHomem)|>
  rename(populacaoHomem=populacao)

tbn.homem.dado

# JUNTANDO E EXPORTANDO DADOS COMPLETO

dataframe<-
  merge(
    x = tbn.popTotal.dado,
    y = tbn.mulher.dado,
    by = c("grupo_etario","ano","nascidos")
  ) |>
  merge(
    tbn.homem.dado, by = c("grupo_etario","ano","nascidos")
  ) 
# |> 
write.csv(
  file = "dadoTratado/quest.2A.TBM.csv",
  row.names = FALSE)

dataframe

#  TFG e nfx ----

# Taxa Fecundidade Geral (TFG) e Taxas específicas de fecundidade - nfx
# (Grafique esses valores)

"Como 'tbm.mulher.dado', tanto os 'grupos etários como 'população total',
ambos pelo ano, ao aplicar a função abaixo, obtemos as duas taxas 'TFG e TEF'
, basta olhar as linhas da coluna 'grupo_etario'."

# A TFG e a TEF estão dentro do DATAFRAME "tbm.mulher.dado"
# TOTAL POR ANO = linhas 1,21 e 41 obs: # (N/Pbar)*1000 'Basta multiplicar as linhas por 1mil'
# GRUPO ETARIO= linhas 2:20, 22:40 e 42:60


tfg.mulher <-
  merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tfg=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)*1000),
      .progress = TRUE
    )
  ) |> 
  unnest(tfg) |> 
  filter(
    row_number() %in% c(1,5:11,21,25:31,41, 45:51)
  )

# nascidos -- 2010 = 87476 
# nascidos -- 2019 =  96112 
# nascidos -- 2021 =  90961 

tfg.mulher<-tfg.mulher[,-4]

# PIVOTEAMENTO - ENCURTAR DATAFRAME
tfg.mulher<-
  pivot_wider(
    data = tfg.mulher  ,
    names_from = "ano",
    values_from = c(populacao, tfg)
  ) 

# 'ordenando'
tfg.tef.mulher<-
  tfg.tef.mulher |> 
  select(
    c("grupo_etario",
      "populacao_2010","tfg_2010",
      "populacao_2019","tfg_2019",
      "populacao_2021","tfg_2021")
  )

View(tfg.mulher)





#  EXPORTAR OS 3 DATA FRAMES 
write.csv(
  tfg.tef.mulher,
  file = "dadoTratado/quest.2A.TFG.TEF.csv",
  row.names = FALSE)






# resposta

tfg.mulher  


# GRÁFICO ----
plot.tfg.mulher<-
  tfg.mulher |> 
  filter(
    !row_number() %in% c(1,9,17)
  ) |> 
  ggplot( aes(x = grupo_etario, y = tfg, color = factor(ano))) +
  geom_line(data = filter(plot.tfg.mulher,ano == 2010),
            group = 1,size = 1.5,) +
  geom_line(data = filter(plot.tfg.mulher,ano == 2019),
            group = 1,size = 1.5,) +
  geom_line(data = filter(plot.tfg.mulher,ano == 2021),
            group = 1,size = 1.5) +
  geom_point(size = 3.5) +
  scale_color_manual(values = c("blue", "green", "red")) +
  scale_y_log10() +
  theme_minimal() + 
  theme(
    panel.grid.major.x = element_line(size = .7, color = "grey"),
    panel.grid.major.y = element_line(size = 0.5)
  ) +
  labs(
    title = "Taxa Especifica de Fecundidade de mulheres em idade Reprodutiva",
    subtitle = "Dados referentes aos anos de 2010, 2019 e 2021",
    x = "Classe Etária",
    y = "Taxa Especifica de Fecundidade",
    color = "Ano")

plot.tfg.mulher

# TFT ----
# TEF.f (feminina) ----

# Taxas específicas de fecundidade feminina (apenas os nascimentos femininos)

f.nascimentos<-
  sinascdf[sinascdf$ano %in% c(2010,2019,2021),c("ano","sexo")] |>
  filter(sexo %in% c(2,"M")) |>
  count(ano) |>
  rename(nascidos=n)

f.nascimentos


TEF.f.mulher<-
  merge(
    x = popMul,
    y = f.nascimentos,
    by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |> 
  mutate(
    TEFf=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49")
  )  


TEF.f.mulher


# Taxa de Fecundidade Total (TFT) ou Índice Sintético de Fecundidade

# DATA FRAME 
"A taxa de FECUNDIDADE TOTAL é 5 vezes a soma da TEF por grupo etário"
tef.mulher<-
  merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tef=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(tef)

tef.mulher

"EXCLUINDO DE MULHERES QUE NÃO ESTEJAM EM IDADE DE REPRODUÇÃO.
A TEF vai de 15 até 49 ou 59?"

TEF.2010<-
  tef.mulher$tef[5:11] |> 
  as.numeric() |> 
  sum()

TEF.2019<-tef.mulher$tef[25:31] |> 
  as.numeric() |> 
  sum()

TEF.2021<-tef.mulher$tef[45:51] |> 
  as.numeric() |> 
  sum()

# RESPOSTA 
TEF.2010<-5*TEF.2010
TEF.2019<-5*TEF.2019
TEF.2021<-5*TEF.2021

"
TEF.2010 == 0.4003765
TEF.2019 == 0.4145096
TEF.2021 == 0.3906237
"

# TBR ----
# Taxa Bruta de Reprodução

TEF.2010<-TEF.f.mulher$TEFf[5:11] |> 
  as.numeric() |> 
  sum()

TEF.2019<-TEF.f.mulher$TEFf[25:31] |> 
  as.numeric() |> 
  sum()

TEF.2021<-TEF.f.mulher$TEFf[45:51] |> 
  as.numeric() |> 
  sum()

# RESPOSTA
TEF.2010<-5*TEF.2010
TEF.2019<-5*TEF.2019
TEF.2021<-5*TEF.2021

"
TEF.2010 == 2.001883
TEF.2019 == 2.072548
TEF.2021 == 1.953119
"


# RELAÇÃO ENTRE TFT e TBR ----
"SE DER TEMPO PARA CALCULAR"
# TLR ----
# Taxa Líquida de Reprodução (é necessária a informação da função L
# da Tábua de Vida)

tabuaVida2010<-tabuaVida[1:35,c("idades_exatas_x","l_x_n")]
tabuaVida2010$ano<-2010


tabuaVida2019<-tabuaVida[41:75,c("idades_exatas_x","l_x_n")]
tabuaVida2019$ano<-2019

tabuaVida2021<-tabuaVida[81:115,c("idades_exatas_x","l_x_n")]
tabuaVida2021$ano<-2021





# 'TLR = 5*TBR*(Lx/l0)'

"ASSUMINNDO QUE OS DADOS DO SIM E SINASC COLETADOS SÃO DE BOA QUALIDADE,
SEM CRITERIO DE QUALIDADE OU CAPACIDADE TECNICA PARA JULGAR."

"PORTANDO, PARA CÁLCULAR A TLR, PRECISAMOS CÁLCULAR UMA TÁBUA DE VIDA
para uma corte de mulheres hipoteticas."





# QUESTÃO 03 - Diagrama de Lexis --------------------------------------------------------------

# Q2B----

# b) Compare os seus resultados com os valores obtidos  pelo IBGE (projeções),
#    e para o Brasil, pelo estudo GBD, pelas Nações Unidas (UN Population) e
#     aqueles publicados no site do Datasus para 2010 (RIPSA - Indicadores e
#     dados básicos - http://tabnet.datasus.gov.br/cgi/idb2012/matriz.htm ).
#     Como  os indicadores de reprodução não aparecem nessas listas, a partir
#     das TFT, calcule esses indicadores para comparação.

# Q2C----

# c) Comente esses resultados (inclusive os gráficos das nfx), fazendo referência
#    a artigos já publicados sobre o assunto.

# Q2D----

# d) Para os dados do SINASC para 2021, analise a associação entre (apresente
#   ao menos uma medida de associação):

# CODE ----
# - idade e escolaridade da mãe

Q2D<-
  sinascdf[sinascdf$ano %in% 2021,c("idademae", "escmae","parto")]

chisq.test(Q2D$idademae, Q2D$escmae)

write.csv(Q2D, file = "dadoTratado/quest.2d.csv", row.names = FALSE)



# - tipo de parto e escolaridade da mãe

chisq.test(Q2D$parto, Q2D$escmae)

# Apresente graficamente os dados e obtenha medidas para essa associação.
# GRÁFICO ----







# Q3 ----


# Questão 3: Mortalidade 

# a) Com base nos dados sobre óbitos do SIM para 2010, 2019 e  2021 e a população
#    por sexo e idade estimada (projetada) para a UF, obtenha os seguintes
#    indicadores:

# - DADOS TBM ----


dtobto<-simdf[simdf$ano %in% c("2010","2019","2021"),c("ano","dtobito")] |>
  select("ano") |>
  table() |>
  data.frame() |>
  rename(numero=Freq)

# TBM HOMENS
tbmHomem<-
  merge( x = popHom, y = dtobto, by = "ano",all.x = TRUE) |> 
  mutate(
    TBM=map2(
      .x = numero,
      .y = populacao,
      
      .f = ~((.x/.y)*1000),
      .progress = TRUE
    )
  )

# TBM MULHERES 
tbmMulher<-merge(x = popMul, y = dtobto, by = "ano",all.x = TRUE) |> 
  mutate(
    TBM=map2(
      .x = numero,
      .y = populacao,
      
      .f = ~((.x/.y)*1000),
      .progress = TRUE
    )
  )


# - Taxas específicas de mortalidade por sexo e idade - nMx (grafique) ----

"Em 'df.M.Q3A', Há as informações de total de homens e os grupos etários.
Assim, nessas linhas 'Totais' já contem a informação da TBM e TEM por idade,
nas outras linhas - 'grupos etarios'. Para os anos de interesse"


"O mesmo para 'df.H.Q3A'."

# Q3B ----
# b) Calcule a TMI, utilizando o número médio de óbitos ocorridos entre 2019
#    e 2021 e o número de nascimentos de 2020. Calcule os indicadores: taxa de
#    mortalidade neonatal, neonatal precoce, neonatal tardia, posneonatal.
#    Agregando a informação sobre óbitos fetais para os mesmos anos, calcule a
#    taxa de mortalidade perinatal.

# TMI ----

# TMI, com média-óbitos entre 2019-2021 e nascimentos de 2020

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

#  CÁLCULO TMI 5qx ----

# Numero Médio Óbitos

simdf[simdf$idade %in% 400:404,c("ano","dtobito")] |> 
  select(dtobito) |>
  mutate(
    dtobito=format(
      dmy(dtobito),"%Y"),
  ) |> 
  filter(
    dtobito %in% 2019:2021
  ) |> 
  table()

num.medio<- (201+148+197)/3


"TMI = obitos<5/nascimentos"
tmi.5q0 <- (num.medio/sinasc.data$nascidos)*1000

# resposta
tmi.5q0
'TMI.5qx = 1.961883'

#  CÁLCULO TMI 1qx ----

simdf[simdf$idade %in% 400:401,c("ano","dtobito")] |> 
  select(dtobito) |>
  mutate(
    dtobito=format(
      dmy(dtobito),"%Y"),
  ) |> 
  filter(
    dtobito %in% 2019:2021
  ) |> 
  table()

num.medio<- (89   +62   +93 )/3

"TMI = obitos<1/nascimentos"
tmi.1q0 <- (num.medio/sinasc.data$nascidos)*1000

# resposta
tmi.1q0 
'TMI.1q0 == tmi == 0.8767391'



# TMINeo ----

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
    id.simpl = map2( .x = dmy(dtobito), .y = dmy(dtnasc), .f = ~round(
      (as.numeric(.x-.y)),digits = 3),.progress = TRUE)) |>
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

num.medio<- (1068)/3
# Soma de 2019:2021. Não há dados sobre 2020 

"TMI = obitos<1/nascimentos"
tmi <- (num.medio/sinasc.data$nascidos)*1000


# Resposta
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


# TMIpos ----

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
tmi <- (num.medio/sinasc.data$nascidos)*1000

# Resposta
"TMIPos  2019 == 2.205760  2020 == 2.285271 2021 == 2.330669"



# TMIprec ----
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

# TMItardia ----

tmi.dado[tmi.dado$idade %in% 200:229,c("ano","idade","dtnasc", "dtobito","id.simpl")] |> 
  select(dtobito,id.simpl) |>
  mutate(
    dtobito=format(
      dmy(dtobito),"%Y"),
  ) |> 
  filter(
    dtobito %in% 2019:2021 & id.simpl >=7 & id.simpl <=27
  ) |> 
  count()

num.medio<-(400)/3
tmi <- (num.medio/sinasc.data$nascidos)*1000

# Resposta
"TMITard 2019 == 2.347955 2020 == 2.432592 2021 == 2.480917"



# Q3C ----

# c) Compare os seus resultados com os valores obtidos pelo estudo GBD, pela Nações
#    Unidas (UN Population) e aqueles publicados no site do Datasus (RIPSA -
#    Indicadores e dados básicos - http://tabnet.datasus.gov.br/cgi/idb2012/matriz.htm ).
#    Para a TMI, compare com os valores obtidos na questão 1. Comente sobre os
#    aspectos metodológicos dessas duas formas de cálculo.

# Q3D ----

# d) Compare a estrutura de mortalidade por causas entre 2010 e 2021. Utilize
#    20 primeiras grupos de causas segundo Grupos CID-10 (ver Tabnet - Datasus),
#    segundo sexo para os anos selecionado. Comente os resultados. Destacar a
#    mortalidade por Covid-19 (CID B34.2). 

# Q3D ----

# d) Construa Tábuas de Vida para cada sexo para a UF escolhida para 2021, a
# partir das taxas específicas de mortalidade obtidas no item a:


# DADOS TEspec.Mortalidade - nMx ----

popMul<-
  pop_estimada[24:43,c("grupo_etario","x2010","x2019","x2021")] |>
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  arrange(ano) |>
  mutate(
    ano = str_remove_all(ano,pattern = "x")
  )

popHom <-
  pop_estimada[1:20,c("grupo_etario","x2010","x2019","x2021")]|> 
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  arrange(ano) |>
  mutate(
    ano = str_remove_all(ano,pattern = "x")
  )


# -----

# - Utilize a TMI obtida no item b ou do estudo Global Burden of Disease - GBD.
#   Lembre que deve-se obter a TMI para cada sexo em separado.

# - Estime os fatores de separação, para cada sexo, para as idades 0-1 e 1-4 com
#   base nos microdados do SIM.

# - Compare os valores da função esperança de vida para as idades exatas 0 e 60
#   com aqueles obtidos pelo estudo GBD, pelas Nações Unidas (UN Population).
#   Comente sobre os resultados obtidos e sobre o significado desses indicadores.

# - Com base na TV calculada, grafique as funções lx e nqx para cada sexo e
#    comente os resultados. Se lo=1, qual o significado da função lx? Interprete, neste caso, l20 e l60.

# - Comente os resultados à luz de artigos recém publicados.














# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------
# finaldoRMD------DSEDFSDV ------------------------------------------------












#  PACOTES  ----
library(fs)
library(purrr)
library(stringr)
library(tidyverse)
library(kableExtra)

# instalar o pacote read.dbc GITHUB
if(!require(read.dbc)){
  devtools::install_github("danicat/read.dbc")
} else {
  library(read.dbc)
}
if(!require(microdatasus)){
  devtools::install_github("rfsaldanha/microdatasus")
}
library(microdatasus)

# Exemplode como baixar os dodos do SIM
# dados <-
#   fetch_datasus(
#     year_start = 2002,
#     year_end = 2021, uf = "GO",
#     information_system = "SIM-DO") |>
#   process_sim()
# 
# dados # dados
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

pop_estimada<-
  readxl::read_xlsx(
    path = "estimativa_projecao/projecoes_2018_populacao_2010_2060_20200406.xlsx",
    skip = 4) |> 
  janitor::clean_names()



# TABUA DE VIDA 2010 -----
# 
# 
tabuaVida<-readxl::read_xlsx(
  path = "TabuasVida/tabuaVida (1).xlsx") |>
  janitor::clean_names()



# Q1-A ----
# CODE ----
# SIM DATA - ANÁLISE DA IDADE SIMPLES 
'Pego o ano, dtobtido e dtnasc, POR 400<Idade<405(completa)
  para obter as datas para o diagrama (linha de vida).'

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

'Observação: Há um individuo que MORREU 1 DIAA ANTES
 de completar 5 anos de vida. Logo, entre em menor <5 anos'

"como 'sim.data$idade %in% 405' cuja 'id.simples' >= 5,
a seleção FOI feita de 400:404"
# sim.data[sim.data$idade %in% 405,c("idade","id.simples")]

# DIAGRAMA LEXIS ----
"PARA CONSTRUIR O DIAGRAMA DE LEXIS"

# SINASC 
sinasc.data<-
  sinascdf$dtnasc |>
  stringr::str_replace(" ","") |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,nascidos=Freq)

# SIM
sim.data<-
  sim.data$data.obito |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,obtos=Freq)

# [DIAG.-LEXIS] DATA FRAME COM NASCIMENTOS E OBTOS 

dadoDiagLex <-
  merge(
    x = sinasc.data,
    y = sim.data,
    by = "ano")

# EXPORTANDO DADO - DIAGRAMA LEXIS
write.csv(df.diagLexis, file = "dadoTratado/quest.1a.csv", row.names = FALSE)

# CONSTRUÇÃO DO DIAGRAMA - LEXIS 

"SEM LINHA DE VIDA"
library(LexisPlotR)

# FILTRO ANOS '2002:2021'
df.diagLe<-
  df.diagLexis[df.diagLexis$ano %in% 2002:2021,]

# CAMADA DO DIAGRAMA 
diagLexis <-
  LexisPlotR::lexis_grid(
    year_start = 2002,
    year_end = 2021,
    age_start = 0,
    age_end = 5,
    delta = 1
  ) +
  
  # DIAGRAMA - LEXIS  FINAL 
  
  
  annotate("text",
           x = seq(as.Date("2002-8-1"), as.Date("2021-8-1"), "years"),
           y = 0.13,
           label = df.diagLe$nascidos,
           color='#1b429e',size = 3.5) +
  annotate("text",
           x = seq(as.Date("2002-8-1"), as.Date("2021-8-1"), "years"),
           y = 2.5,
           label = df.diagLe$obtos,
           color='red',size = 5) +
  
  # ROTULOS DO DIAGRAMA 
  
  labs(
    title = "Diagrama de Lexis sobre nascimentos e óbitos menores que 5 anos de Goiás.",
    subtitle = "Dados relacionados aos anos de 2000 à 2021.", 
    x = "Coortes",
    y = "Anos Completos"
  ) +
  theme(
    plot.margin = margin(1, .5, .1, .1, unit = "cm"),
    plot.title = element_text(size = 16),
    plot.subtitle = element_text(size = 12),
    axis.title.x = element_text(size = 10),
    axis.title.y = element_text(size = 10),
    axis.text.x = element_text(size = 10)
  )

# EXPORTANDO DIAGRAMA DE LEXIS FINAL 

ggsave(path = "imagens/",
       filename = "DiagLexis.png", plot = diagLexis,
       dpi = 300,
       # width = 12,
       # height = 8,
       units = "cm",
       scale = 2
)





# q1b CODE ----

# coluna 'IDADE', dados da 'DECLARAÇÃO DE OBITO'
"4: Anos, o segundo subcampo varia de 00 a 99.
    Exemplo: 410 == 10 anos"

# OBTOS 
n.obtos<-
  simdf[simdf$idade %in% 400:405,] |>
  select(dtobito) |>
  dplyr::mutate(
    dtobito=format(
      dmy(dtobito),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtobito,obtos=Freq)

n.obtos<-n.obtos[
  n.obtos$ano %in% 2000:2016,c("ano","obtos")]


# NASCIMENTOS
n.nascimentos<-
  sinascdf |>
  select(dtnasc) |>
  dplyr::mutate(
    dtnasc=format(
      dmy(dtnasc),"%Y")
  ) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtnasc,nasc=Freq)

n.nascimentos<-n.nascimentos[
  n.nascimentos$ano %in% 2000:2016,c("ano","nasc")]


# RESPOSTA 1B ----
# DATAFRAME  COMPLETO 
df.nasc.obto<-
  merge(n.nascimentos,n.obtos, by = "ano")

# PROBABILIDADE DE SOBREVIVER EM CADA ANO
"sobreV=1-[soma(mortos)/nascidos-vivos]*1mil"

pb.sobreviver.5<-
  df.nasc.obto |>
  mutate(
    pb.sobrev=map2(
      .x = df.nasc.obto$obtos,
      .y = df.nasc.obto$nasc,
      .f = ~round(1-((.x/.y)),digits=4),
      .progress = TRUE
    )
  ) |>
  unnest(pb.sobrev)


# PROBABILIDADE DE SOBREVIVER ENTRE 2000 E 2016
prod(pb.sobreviver.5$pb.sobrev)

'RESPOSTA = 0.9534497'

# EXPORTANDO OS DADOS
write.csv(pb.sobreviver.5, file = "dadoTratado/quest.1b.csv", row.names = FALSE)



# CODE ----
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
  rename(ano=dtobito,obtos=Freq)

n.obtos<-n.obtos[
  n.obtos$ano %in% 2000:2020,c("ano","obtos")]


n.nascimentos<-
  sinascdf |>
  select(dtnasc) |>
  dplyr::mutate(
    dtnasc=format(dmy(dtnasc),"%Y")) |>
  table() |>
  as.data.frame() |>
  rename(ano=dtnasc,nasc=Freq)

n.nascimentos<-n.nascimentos[
  n.nascimentos$ano %in% 2000:2020,c("ano","nasc")]

# DATAFRAME  COMPLETO 
df.nasc.obto<-
  merge(
    x = n.nascimentos,
    y = n.obtos,
    by = "ano")

# PROBABILIDADE DE SOBREVIVER AO PRIMEIRO ANO
" sobre=1-[soma-mortos/nascidos-vivos]*1mil"

pb.sobreviver.1<-
  df.nasc.obto |>
  mutate(
    pb.sobrev=map2(
      .x = df.nasc.obto$obtos,
      .y = df.nasc.obto$nasc,
      
      .f = ~round((1-(.x/.y)),digits=7),
      .progress = TRUE
    )
  ) |>
  unnest(pb.sobrev)

# RESPOSTA 1C ----

prod(pb.sobreviver.1$pb.sobrev)

'RESPOSTA = 0.9788178'

# EXPORTANDO OS DADOS
write.csv(
  pb.sobreviver.1,
  file = "dadoTratado/quest.1c.csv",
  row.names = FALSE)







# POPULAÇÃO PROJETADA -----

"dados das Projeções da população por idade e sexo."
 # https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fftp.ibge.gov.br%2FProjecao_da_Populacao%2FProjecao_da_Populacao_2018%2Fprojecoes_2018_populacao_2010_2060_20200406.xls&wdOrigin=BROWSELINK

# POPULAÇÃO ESTIMADA -----

pop_estimada<-
  readxl::read_xlsx(
    path = "estimativa_projecao/projecoes_2018_populacao_2010_2060_20200406.xlsx",
    skip = 4) |> 
  janitor::clean_names()

# CODE ----
library(tidyverse)

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


popMul<- pop_estimada[24:43,c("grupo_etario","x2010","x2019","x2021")] |>
  pivot_longer(
    cols = starts_with("x20"),
    names_to = "ano",
    values_to = "populacao") |>
  mutate(
    ano = as.numeric(str_remove_all(ano,pattern = "x"))
  ) |> 
  arrange(ano)

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

# NASCIMENTOS 
sinasc.data<-
  sinascdf$dtnasc |>
  stringr::str_replace(" ","") |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,nascidos=Freq)

nascimentos <-
  sinasc.data[sinasc.data$ano %in% c(2010,2019,2021),]




# TFG TEF ----
# Taxa Fecundidade Geral (TFG) e Taxas específicas de fecundidade - nfx
# (Grafique esses valores)

"Como 'tbm.mulher.dado', tanto os 'grupos etários como 'população total',
ambos pelo ano, ao aplicar a função abaixo, obtemos as duas taxas 'TFG e TEF'
, basta olhar as linhas da coluna 'grupo_etario'."

# A TFG e a TEF estão dentro do DATAFRAME "tbm.mulher.dado"
# TOTAL POR ANO = linhas 1,21 e 41 obs: # (N/Pbar)*1000 'Basta multiplicar as linhas por 1mil'
# GRUPO ETARIO= linhas 2:20, 22:40 e 42:60


tfg.mulher <-
  merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tfg=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)*1000),
      .progress = TRUE
    )
  ) |> 
  unnest(tfg) |> 
  filter(
    row_number() %in% c(1,5:11,21,25:31,41, 45:51)
  )

# nascidos -- 2010 = 87476 
# nascidos -- 2019 =  96112 
# nascidos -- 2021 =  90961 

tfg.mulh<-tfg.mulher[,-c(4,5)]

tfg.mulh

# GRÁFICO TEF ----


library(ggplot2)
library(dplyr)

tef.dado.mulher<-
  tfg.mulher |> 
  filter(
    !row_number() %in% c(1,9,17)
  )

plot.tef.mulher<-
  tef.dado.mulher[,-4] |> 
  ggplot( aes(x = grupo_etario, y = tfg, color = factor(ano))) +
  geom_line(data = filter(tef.dado.mulher,as.numeric(ano) == 2010),
            group = 1,size = 1.5,) +
  geom_line(data = filter(tef.dado.mulher,as.numeric(ano) == 2019),
            group = 1,size = 1.5,) +
  geom_line(data = filter(tef.dado.mulher,as.numeric(ano) == 2021),
            group = 1,size = 1.5) +
  geom_point(size = 3.5) +
  scale_y_log10() +
  scale_color_manual(values = c("blue", "green", "red")) +
  theme_minimal() + 
  theme(
    panel.grid.major.x = element_line(size = .7, color = "grey"),
    panel.grid.major.y = element_line(size = 0.5),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) +
  labs(
    title = "Taxa Especifica de Fecundidade de mulheres em idade Reprodutiva",
    subtitle = "Dados referentes aos anos de 2010, 2019 e 2021",
    x = "Classe Etária",
    y = "Taxa Especifica de Fecundidade",
    color = "Ano")


plot.tef.mulher

ggsave(path = "imagens/",
       filename = "plot.tef.mulher.png", plot = plot.tef.mulher,
       dpi = 300,
       # width = 12,
       # height = 8,
       units = "cm",
       scale = 2
)


# GRAFICO TFG ----

library(ggplot2)
library(dplyr)

plot.tfg.mulher<-
  tfg.mulher |> 
  filter(
    row_number() %in% c(1,9,17)
  )  

plot.tfg.ano<-
  plot.tfg.mulher |> 
  ggplot( aes(x = ano, y = tfg)) +
  geom_line(group=1,size=1.7, color="grey") +
  geom_point(size = 3.5,aes(color= as.factor(ano))) +
  theme_minimal() + 
  theme(
    panel.grid.major.x = element_line(size = .7, color = "grey"),
    panel.grid.major.y = element_line(size = 0.5),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
    
  ) +
  labs(
    title = "Taxa de Fecundidade Geral de mulheres em idade Reprodutiva",
    subtitle = "Dados referentes aos anos de 2010, 2019 e 2021",
    x = "Anoa",
    y = "Taxa de Fecundidade Geral",
    caption = "Ano")



plot.tfg.ano

ggsave(path = "imagens/",
       filename = "plot.tfg.ano.png", plot = plot.tfg.ano,
       dpi = 300,
       width = 12,
       height = 8,
       units = "cm",
       scale = 2
)


# TFT ----

# Taxa de Fecundidade Total (TFT) ou Índice Sintético de Fecundidade

# DATA FRAME 
"A taxa de FECUNDIDADE TOTAL é 5 vezes a soma da TEF por grupo etário"
tef.mulher<-
  merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tef=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(tef)

# tef.mulher

"EXCLUINDO DE MULHERES QUE NÃO ESTEJAM EM IDADE DE REPRODUÇÃO.
A TEF vai de 15 até 49 ou 59?"

TEF.2010<-
  tef.mulher$tef[5:11] |> 
  as.numeric() |> 
  sum()

TEF.2019<-tef.mulher$tef[25:31] |> 
  as.numeric() |> 
  sum()

TEF.2021<-tef.mulher$tef[45:51] |> 
  as.numeric() |> 
  sum()

# RESPOSTA 
TEF.2010<-5*TEF.2010
TEF.2019<-5*TEF.2019
TEF.2021<-5*TEF.2021

"
TEF.2010 == 0.4003765
TEF.2019 == 0.4145096
TEF.2021 == 0.3906237
"


# TEF - Feminina ----
# TEF.f (feminina) ----

# Taxas específicas de fecundidade feminina (apenas os nascimentos femininos)

f.nascimentos<-
  sinascdf[sinascdf$ano %in% c(2010,2019,2021),c("ano","sexo")] |>
  filter(sexo %in% c(2,"M")) |>
  count(ano) |>
  rename(nascidos=n)

f.nascimentos


TEF.f.mulher<-
  merge(
    x = popMul,
    y = f.nascimentos,
    by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |> 
  mutate(
    TEFf=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(TEFf) |> 
  filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49")
  )  


TEF.f.mulher



# TBR ----
# Taxa Bruta de Reprodução

TEF.2010<-TEF.f.mulher$TEFf[5:11] |> 
  as.numeric() |> 
  sum()

TEF.2019<-TEF.f.mulher$TEFf[25:31] |> 
  as.numeric() |> 
  sum()

TEF.2021<-TEF.f.mulher$TEFf[45:51] |> 
  as.numeric() |> 
  sum()

# RESPOSTA
TEF.2010.5<-5*TEF.2010
TEF.2019.5<-5*TEF.2019
TEF.2021.5<-5*TEF.2021

"
TEF.2010 == 2.001883
TEF.2019 == 2.072548
TEF.2021 == 1.953119
"

# RELAÇÃO (TFT E TBR) ----
# 1,M = MASCULINO
# 2,F = FEMININO

library(dplyr)

Numero.H.M<-
  sinascdf |> 
  filter(ano %in% c(2010, 2019, 2021))  |> 
  group_by(ano) |> 
  summarize(
    mulheres = sum(sexo %in% c(2, "F")),
    homens = sum(sexo %in% c(1, "M"))
  )

# TAXA BRUTA DE REPRODUÇÃO
# TBR = TEF/(1+RS)

Relac.H.M.2010<-
  TEF.2010.5 |> 
  map(
    .f = ~ ((.x)/(1+(Numero.H.M$homens[1]/Numero.H.M$mulheres[1])))
  )

Relac.H.M.2019<-
  TEF.2019.5 |> 
  map(
    .f = ~ ((.x)/(1+(Numero.H.M$homens[2]/Numero.H.M$mulheres[2])))
  )

Relac.H.M.2021<-
  TEF.2021.5 |> 
  map(
    .f = ~ ((.x)/(1+(Numero.H.M$homens[3]/Numero.H.M$mulheres[3])))
  )

# relação 

Relac.H.M.2010
Relac.H.M.2019
Relac.H.M.2021





