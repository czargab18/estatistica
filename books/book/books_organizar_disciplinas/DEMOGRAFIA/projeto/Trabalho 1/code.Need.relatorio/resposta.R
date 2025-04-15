# PACOTES ----
# devtools::install_github("ottlngr/LexisPlotR")
# library(LexisPlotR)

# Questão 1: Diagrama de Lexis ----

# Q1-A ----
#  a) Construir o Diagrama de Lexis para os dados de nascidos vivos de 2000 a
#     2021 da UF escolhida (SINASC) e de óbitos menores de 5 anos (idades simples)
#     para o mesmo período segundo ano de nascimento.

# CODE ----


# SIM DATA
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

# ANÁLISE DA IDADE SIMPLES

"como 'sim.data$idade %in% 405' cuja 'id.simples' >= 5,
a seleção FOI feita de 400:404"
# sim.data[sim.data$idade %in% 405,c("idade","id.simples")]

# DIAGRAMA LEXIS ----
"PARA CONSTRUIR O DIAGRAMA DE LEXIS"

sinasc.data<-
  sinascdf$dtnasc |>
  stringr::str_replace(" ","") |>
  lubridate::dmy() |> 
  format("%Y") |>
  table() |>
  data.frame() |>
  rename(ano=Var1,nascidos=Freq)


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
df.diagLexis<-
  df.diagLexis[df.diagLexis$ano %in% 2002:2021,]

# CAMADA DO DIAGRAMA 
diagLexis<-  LexisPlotR::lexis_grid(
  year_start = 2002,
  year_end = 2021,
  age_start = 0,
  age_end = 5,
  delta = 1
)

# DIAGRAMA - LEXIS  FINAL 
diagLexis<-
  diagLexis +
  annotate("text",
           x = seq(as.Date("2002-8-1"), as.Date("2021-8-1"), "years"),
           y = 0.13,
           label = df.diagLexis$nascidos,
           color='#1b429e',size = 1.5) +
  annotate("text",
           x = seq(as.Date("2002-8-1"), as.Date("2021-8-1"), "years"),
           y = 2,
           label = df.diagLexis$obtos,
           color='#1b429e',size = 2)

# ROTULOS DO DIAGRAMA 
diagLexis<-
  diagLexis +
  labs(
    title = "Diagrama de Lexis sobre nascimentos e óbitos menores que 5 anos.",
    subtitle = "Ddados relacionados aos anos de 2000 à 2016.", 
    x = "Coortes",
    y = "Anos Completos"
  ) +
  theme(
    plot.margin = margin(1, .5, .1, .1, unit = "cm"),
    plot.title = element_text(size = 10),
    plot.subtitle = element_text(size = 8),
    axis.title.x = element_text(size = 10),
    axis.title.y = element_text(size = 10),
    axis.text.x = element_text(size = 4)
  )

# EXPORTANDO DIAGRAMA DE LEXIS FINAL 

ggsave(path = "imagens/",
       filename = "DiagLexis.png", plot = diagLexis,
       dpi = 300,
       width = 12,
       height = 8,
       units = "cm")

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



# Questão 2:  Natalidade/Fecundidade ----

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


# TBM ----

# Taxa Bruta de Natalidade 
# TBM = (nascidos/população)

tbm.popTotal.dado<-
  merge(x = popTotal,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tbmTotal=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(tbmTotal)|>
  rename(populacaoTotal=populacao)

tbm.popTotal.dado


tbm.mulher.dado<-merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tbmMulher=map2(
      .x = nascidos,
      .y = populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(tbmMulher)|>
  rename(populacaoMulher=populacao)

tbm.mulher.dado

tbm.homem.dado<-merge(x = popHom,y = nascimentos,  by = "ano", all.x = TRUE ) |>
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

tbm.homem.dado

# JUNTANDO OS DATA FRAMES

dataframe<-
   merge(
  x = tbm.popTotal.dado,
  y = tbm.mulher.dado,
  by = c("grupo_etario","ano","nascidos")
  ) |>
   merge(
     tbm.homem.dado, by = c("grupo_etario","ano","nascidos")
   )

#  EXPORTAR OS 3 DATA FRAMES 
write.csv(
  dataframe,
  file = "dadoTratado/quest.2A.TBM.csv",
  row.names = FALSE)


#  TFG e nfx ----

# Taxa Fecundidade Geral (TFG) e Taxas específicas de fecundidade - nfx
# (Grafique esses valores)

"Como 'tbm.mulher.dado' com tanto os 'grupos etários como 'população total',
amobos pelo ano, ao aplicar a função abaixo, obtemos as duas taxas, basta olhar
a coluna 'grupo_etario'."

tfg.tef.mulher.dado<-
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
  unnest(tfg)

tfg.tef.mulher.dado

# PIVOTEAMENTO - ENCURTAR DATAFRAME
tfg.tef.mulher.dado<-
  pivot_wider(
  data = tfg.tef.mulher.dado,
  names_from = ano,
  values_from = c(populacao, nascidos, tfg)
  ) 

tfg.tef.mulher.dado<-
  tfg.tef.mulher.dado |> 
  select(
    c("grupo_etario",
      "populacao_2010", "nascidos_2010","tfg_2010",
      "populacao_2019", "nascidos_2019","tfg_2019",
      "populacao_2021", "nascidos_2021","tfg_2021")
  )

View(tfg.tef.mulher.dado)

#  EXPORTAR OS 3 DATA FRAMES 
write.csv(
  tfg.tef.mulher.dado,
  file = "dadoTratado/quest.2A.TFG.TEF.csv",
  row.names = FALSE)


# A TFG e a TEF estão dentro do DATAFRAME "tbm.mulher.dado"
# TOTAL POR ANO = linhas 1,21 e 41 obs: # (N/Pbar)*1000 'Basta multiplicar as linhas por 1mil'
# GRUPO ETARIO= linhas 2:20, 22:40 e 42:60


# TFT ----
# Taxa de Fecundidade Total (TFT) ou Índice Sintético de Fecundidade

# DATA FRAME 
"A taxa de FECUNDIDADE TOTAL é 5 vezes a soma da TEF por grupo etário"
tef.mulher.dado<-
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

# TAXA FECUNDIDADE TOTAL
"EXCLUINDO DE MULHERES QUE NÃO ESTEJAM EM IDADE DE REPRODUÇÃO.
A TEF vai de 15 até 49 ou 59?"

TEF.2010<-tef.mulher.dado$tef[5:11] |> 
  as.numeric() |> 
  sum()

TEF.2019<-tef.mulher.dado$tef[25:31] |> 
  as.numeric() |> 
  sum()

TEF.2021<-tef.mulher.dado$tef[45:51] |> 
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


# TET.f (feminina) ----

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
      .x = TEF.f.mulher$nascidos,
      .y = TEF.f.mulher$populacao,
      
      .f = ~((.x/.y)),
      .progress = TRUE
    )
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
TEF.2010<-5*TEF.2010
TEF.2019<-5*TEF.2019
TEF.2021<-5*TEF.2021

"
TEF.2010 == 2.001883
TEF.2019 == 2.072548
TEF.2021 == 1.953119
"



# TLR ----
# Taxa Líquida de Reprodução (é necessária a informação da função L
# da Tábua de Vida)

# TLR = 5*sum(TEF.f)*(nLx/l0)

# nLx = Nlx+n + nKx*ndx
# nLx= n lx+n + n (lx  - lx+n) / 2 . Então, 

# nLx = n(lx + l+n) / 2
# n/2 = (29-25)/2, para todos os grupos etários, nkx=n/2=2

# linhas 1:2,12:20
# linhas 21:22,32:40,
# linhas 41:42,52:60,

# popMul |>
#   mutate(
#     ndx = as.numeric(
#       case_when(
#         row_number() %in% c(1:2,12:20,21:22,32:40,41:42,52:60) ~ NA,
#          # !row_number() %in% c(1:2,12:20,21:22,32:40,41:42,52:60) ~ NA,
#         TRUE ~ "2"
#       )
#     )
#   )


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

# - tipo de parto e escolaridade da mãe

chisq.test(Q2D$parto, Q2D$escmae)


# Apresente graficamente os dados e obtenha medidas para essa associação.



# Q3 ----
# Questão 3: Mortalidade 

# a) Com base nos dados sobre óbitos do SIM para 2010, 2019 e  2021 e a população
#    por sexo e idade estimada (projetada) para a UF, obtenha os seguintes
#    indicadores:

# - Taxa Bruta de Mortalidade ----

# DATA FRAME
dtobto<-simdf[simdf$ano %in% c("2010","2019","2021"),c("ano","dtobito")] |>
  select("ano") |>
  table() |>
  data.frame() |>
  rename(numero=Freq)

# TBM HOMENS
df.H.Q3A<-
  merge(
  x = popHom, y = dtobto,
  by = "ano",all.x = TRUE)

df.H.Q3A<-
  df.H.Q3A |>
  mutate(
    TBM=map2(
      .x = df.H.Q3A$numero,
      .y = df.H.Q3A$populacao,
      
      .f = ~((.x/.y)*1000),
      .progress = TRUE
    )
  )
  
  # TBM MULHERES 
df.M.Q3A<-merge(x = popMul, y = dtobto, by = "ano",all.x = TRUE)
  
df.M.Q3A<-df.M.Q3A |>
  mutate(
    TBM=map2(
      .x = df.M.Q3A$numero,
      .y = df.M.Q3A$populacao,
      
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


# TMI.5q0<- simdf[simdf$idade %in% 000:405,c("ano","idade")]
# TMI.1q0<- simdf[simdf$idade %in% 000:401 ,c("ano","idade")]

# simdf[simdf$idade %in% c(200:229,400),c("ano","idade")]

# DATA FRAME 
df.Q3B<-simdf[simdf$ano %in% c(2019, 2021),c("ano","idade","dtnasc", "dtobito")]

df.Q3B<-df.Q3B |> 
    mutate(
    id.simpl = map2(
      .x = dmy(df.Q3B$dtobito),
      .y = dmy(df.Q3B$dtnasc),
      .f = ~round(
        (as.numeric(.x-.y)),
        digits = 3),
      .progress = TRUE
    )
  ) |>
  unnest(id.simpl) |>
  filter(id.simpl < 365)
  
  
df.Q3B

TMI
TMIneo
TMIpos
TMIprec
TMItardia



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

