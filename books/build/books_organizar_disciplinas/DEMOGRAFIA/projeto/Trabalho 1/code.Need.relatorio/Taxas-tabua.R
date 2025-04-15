# DADOS NECESSÁRIOS ----

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
  simdf[simdf$idade %in% 400:404,c("idade","ano","dtobito", "dtnasc")] |> 
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


# DADOS ----

# óbtos menores que 1 anos exato
n1.obtos[n1.obtos$ano %in% c(2010,2019,2021),c("ano","obtos.1ano")]

# óbtos menores que 5 anos exato
# n5.obtos[n5.obtos$ano %in% c(2010,2019,2021),]
n5.obtos[n5.obtos$ano %in% c(2010,2019,2021),c("ano","obtos.5ano")]

# nascimentos
sinasc.dat<-sinasc.data

# DATA FRAME 
"No caso de 1q0,'Idades < 1', se os dados são de boa qualidade, pode-se
utilizar os valores obtidos a partir do cálculo direto da 'Taxa de
Mortalidade Infantil'
"

TMInfantil <-
  merge(
    x = sinasc.dat,
    y = n5.obtos) 
  
  
  # |>
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


#  BASE DE DADOS ----
base.completa<-
  popTotal[popTotal$ano %in% c(2010,2019,2021),] |> 
  filter(
    # row_number() %in% c(4:21,25:42,46:63)
    !row_number() %in% c(1,22:23,43:44) # linhas diferentes
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
  ) |> unnest(nMx)




# ARRUMANDO 'base.completa' ----

base.completa[c(2,21,42),"nMx"]<-
  base.completa[c(2,21,42),] |>
  select("TMI.5q0") |> 
  rename(
    nMx = "TMI.5q0"
  ) |>
  select(nMx)

base.completa

# BASE FINAL ----
base.completa<-
  base.completa[,c(1,2,10)]

view(base.completa)

#  nqx ----

"nMx = TAXA ESPECIFICA MORTALIDADE"
"nMx = obtos/pop"


# AGRUPANDO IDADE > 80 - 2010 ----

"56        80-84 2021 0.02485
57        85-89 2021 0.04606
58          90+ 2021 0.07091
"
# > 0.07091+.04606+0.024857
# [1] 0.141827


base.completa[18,"nMx"] <- 0.141827
base.completa$grupo_etario[18] <- "80+" 


base.completa.2010<-
  base.completa |> 
  filter(
    !row_number() %in% c(1,19:63)
  )

base.completa.2010

#  nqx 2010 ----

"nKx = n/2, n=4, nKx=2"
"nqx = n*(nMx)/(1+(n-nKx)*nMx)"

# nqx = 4*(nMx)/(1+(4-2)*nMx)

base.completa.2010<-
  base.completa.2010 |> 
  mutate(
    nqx = map(
      .x = base.completa.2010$nMx,
      .f = ~(4*(.x)/(1+(4-2)*.x))
    )
  ) |>
  unnest(nqx)

base.completa.2010


# TÁBUA e CORREÇÃO DE LINHA ----

tabuaVida<-
  data.frame(
    grupo_etario=c(
      "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
      "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
      "70-74", "75-79", "80+"
    )
  ) |>
  merge(
    y = base.completa.2010,
    by = "grupo_etario"
  )

# CORREÇÃO DE LINHA 
add<-
  tabuaVida |> 
  slice(10)

tabuaVida<-
  add_row(.data = tabuaVida,.before = 2, add)


tabuaVida<-tabuaVida[-11,]



# FUNÇÃO ChatGPT----

tabuaVida<-
  calculateLifeTable(tabuaVida)





#  -------





base.completa.2010

# TÁBUA ----

tabuaVida<-
  data.frame(
    grupo_etario=c(
      "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
      "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
      "70-74", "75-79", "80+"
    )
  ) |>
  merge(
    y = base.completa.2010,
    by = "grupo_etario"
  )

# CORREÇÃO DE LINHA 
add<-
  tabuaVida |> 
  slice(10)

tabuaVida<-
  add_row(.data = tabuaVida,.before = 2, add)


tabuaVida<-tabuaVida[-11,]


# ----

tabuaVida




# nkx=n/2, 4/2 == 2


# nLx = Nlx+n + nKx*ndx
# nLx= n lx+n + n (lx  - lx+n) / 2 . Então, 

# nLx = n(lx + l+n) / 2
# nkx=n/2 = (29-25)/2, para todos os grupos etários, nkx=n/2=2

