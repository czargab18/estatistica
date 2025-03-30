
# Q3D ----

# d) Construa Tábuas de Vida para cada sexo para a UF escolhida para 2021, a
# partir das taxas específicas de mortalidade obtidas no item a:

# - Utilize a TMI obtida no item b ou do estudo Global Burden of Disease - GBD.
#   Lembre que deve-se obter a TMI para cada sexo em separado.

# T.Mortali.Infantil-Femin-Mascili ----------------------------------------


# TMI, utilizando o número médio de óbitos ocorridos entre 2019
#    e 2021 e o número de nascimentos de 2020


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
    ano %in% 2020
  )

#  CÁLCULO TMI 5qx FEMININA ----

# Numero Médio Óbitos FEMININA     "TMI = obitos<5/nascimentos"

1<idade<4
num.medio<-
  simdf[simdf$idade %in% 400:404,] |> 
  filter(
    ano %in% 2019:2021
  )|> 
  filter(
    sexo %in% c(2,"F")
  ) |> 
  select(ano) |> 
  table() |> 
  mean()


# resposta
# tmi.5q0.Femin <- (num.medio/sinasc.data$nascidos)*1000 'PARA CALCULAR TABUA'
'TMI.5qx.Femini= 0.912671'

tmi.5q0.Femin <- (num.medio/sinasc.data$nascidos)
tmi.5q0.Femin

#  CÁLCULO TMI 1qx FEMININA----
"DADOS DO SIM JÁ SÃO SOBRE MORTES"

# NumMédio Óbitos Feminia "TMI = obitos<1/nascimentos"
num.medio<-
  simdf[simdf$idade %in% 400:401,] |> 
  filter(
    ano %in% 2019:2021
  )|> 
  filter(
    sexo %in% c(2,"F")
  ) |> 
  select(ano) |> 
  table() |> 
  mean()


# resposta
# tmi.1q0 <- (num.medio/sinasc.data$nascidos)*1000 'PARA CALCULAR TABUA'
'TMI.1q0.feminia == 0.3952512'

tmi.1q0 <- (num.medio/sinasc.data$nascidos)
tmi.1q0 









#  CÁLCULO TMI 5qx MASCULINA ----

# Numero Médio Óbitos MASCULINA     "TMI = obitos<5/nascimentos"

num.medio<-
  simdf[simdf$idade %in% 400:404,] |> 
  filter(
    ano %in% 2019:2021
  )|> 
  filter(
    sexo %in% c(1,"M")
  ) |> 
  select(ano) |> 
  table() |> 
  mean()


# resposta
tmi.5q0.Masculina <- (num.medio/sinasc.data$nascidos)*1000
tmi.5q0.Masculina
'TMI.5qx.Masculina = 1.049212'

#  CÁLCULO TMI 1qx MASCULINA ----
"DADOS DO SIM JÁ SÃO SOBRE MORTES"

# NumMédio Óbitos Feminia "TMI = obitos<1/nascimentos"
num.medio<-
  simdf[simdf$idade %in% 400:401,] |> 
  filter(
    ano %in% 2019:2021
  )|> 
  filter(
    sexo %in% c(1,"M")
  ) |> 
  select(ano) |> 
  table() |> 
  mean()


# resposta
tmi.1q0 <- (num.medio/sinasc.data$nascidos)*1000

tmi.1q0 
'TMI.1q0.Masculina == 0.4814879'






# - Estime os fatores de separação, para cada sexo, para as idades 0-1 e 1-4 com
#   base nos microdados do SIM.

# - Compare os valores da função esperança de vida para as idades exatas 0 e 60
#   com aqueles obtidos pelo estudo GBD, pelas Nações Unidas (UN Population).
#   Comente sobre os resultados obtidos e sobre o significado desses indicadores.

# - Com base na TV calculada, grafique as funções lx e nqx para cada sexo e
#    comente os resultados. Se lo=1, qual o significado da função lx? Interprete, neste caso, l20 e l60.

# - Comente os resultados à luz de artigos recém publicados.






# T.Especif.Mortali-Masculi-Femini ----------------------------------------

# - Taxa ESPEFICICA (e Bruta) de Mortalidade ----

' - Taxas específicas de mortalidade por sexo e idade - nMx (grafique)'

"Em 'tbmMulher', Há as informações de total de homens e os grupos etários.
Assim, nessas linhas 'Totais' já contem a informação da TBM e TEM por idade,
nas outras linhas - 'grupos etarios'. Para os anos de interesse"

"O mesmo para 'tbmMulher'."

# DATA FRAME
dtobto<-
  simdf[simdf$ano %in% 2021,] |>
  select("ano") |>
  table() |>
  data.frame() |>
  rename(numero=Freq)

# nMx - TBM HOMENS ----

popHomem<-
  popHom |> 
  filter(
    ano %in% 2021
  )

TEM.H<-
  merge( x = popHomem, y = dtobto, by = "ano",all.x = TRUE) |> 
  mutate(
    TEF=map2(
      .x = numero,
      .y = populacao,
      
      # .f = ~((.x/.y)*1000),
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  )

# nMx -  TBM MULHERES  ----

popMulher<-
  popMul |> 
  filter(
    ano %in% 2021
  )

TEM.M<-
  merge(x = popMulher, y = dtobto, by = "ano",all.x = TRUE) |> 
  mutate(
    TEF=map2(
      .x = numero,
      .y = populacao,
      
      # .f = ~((.x/.y)*1000),
      .f = ~((.x/.y)),
      .progress = TRUE
    )
  ) |> 
  unnest(TEF)

# TVida Feminina ----

'(1) l0 = 100000'
'(2) nqx = 4*(nMx)/(1+(4-2)*nMx) , onde nKx=n/2 == 4/2 == 2,
assumindo que os óbtos:Uniforme.
assumindo os dados são de boa qualidade, podemos estimar nqx por nMx.'

# dados-femininnos 2021 ----

TEM.M

# Cálcular nqx ----------------------------------------------------------

'nqx = 4*(TEF.f)/(1+(4-2)*TEF.f)'

TEM.M <-
  TEM.M |> 
    mutate(
      TEF = as.numeric(TEF),
      nqx = map(
        .x = TEF,
        .f = ~(4*(.x)/(1+(4-2)*.x))
        )
      ) |> 
    unnest(nqx)
    
"REAJUSTANDO OS VALORES DO GRUPO ETÁRIO '0' E '1-4'."
  
# Consetando grupo etario '0'

'removendo LINHA == TOTAL'
TEM.M<-TEM.M[-1,]

"Criando e Substituindo Priemira linha. Que receberá o valor da T.Mort INfantil
Feminina 1q0"

TEM.M<-rbind(c("2021","0",NA,NA,0.4814879,0.0004814879), TEM.M)

'Grupo etário - "0-4".'
TEM.M<-TEM.M[-2,]

TEM.M<- rbind(c("2021","1-4",NA,NA, 0.0003952512,0.0003952512), TEM.M)

TEM.M<-TEM.M[c(2, 1, 3:nrow(TEM.M)), ]

'Grupo etário - "80+".'
TEM.M[18,"grupo_etario"]<-"80+"

"REMOVENDO GRUPOS ETÁRIOS > 80"
TEM.M<-TEM.M[-c(19,20),]

TEM.M<-TEM.M |>
  rename(
    nMx=TEF
  )

TEM.M<-TEM.M |> select(grupo_etario,nqx)

# Função ChatGPT tabuaVidaFeminia----

# lx e ndx cálculados corretamente

TEM.M<-calculateValues(TEM.M)




# write.csv(TEM.M, file = "dadoTratado/TabuaVidaFemini.xls", row.names = FALSE)


