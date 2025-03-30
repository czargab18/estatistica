# d) Construa Tábuas de Vida para cada sexo para a UF escolhida para 2021, 
# a partir das taxas específicas de mortalidade obtidas no item a:
  

Utilize a TMI obtida no item b ou do estudo Global Burden of Disease - GBD. Lembre que deve-se obter a TMI para cada sexo em separado.

Estime os fatores de separação, para cada sexo, para as idades 0-1 e 1-4 com base nos microdados do SIM.
Compare os valores da função esperança de vida para as idades exatas 0 e 60 com aqueles obtidos pelo estudo GBD, pelas Nações Unidas (UN Population). Comente sobre os resultados obtidos e sobre o significado desses indicadores.
Com base na TV calculada, grafique as funções lx e nqx para cada sexo e comente os resultados. Se lo=1, qual o significado da função lx? Interprete, neste caso, l20 e l60.
Comente os resultados à luz de artigos recém publicados.



# code.Need.Q3D ----

# DADOS NECESSÁRIOS 

"nascimentos"
nasc_2020<- sinascdf[sinascdf$ano %in% 2020, ] |> select(ano) |> nrow()

# TMI 1 ANO  = (u/nasc_2020)*1000, u=(0btos_2010_219_2021  < 1 )/3

"numerodelinhas /3 anos"
u<- 
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade","sexo")] |> 
      filter(idade %in% 000:400 & sexo %in% c(1,"M")) |> nrow()  )/3


TMI.1.Homem <-  (u/nasc_2020)*1000


# TMI 5 ANO  = (u/nasc_2020)*1000, u=(0btos_2010_219_2021  < 1 )/3

u<-
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade","sexo")] |> 
      filter(idade %in% 000:404 & sexo %in% c(1,"M")) |> nrow()  )/3

TMI.5.Homem <-  (u/nasc_2020)*1000

#  Mulher
"numerodelinhas /3 anos"
u<- 
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade","sexo")] |> 
      filter(idade %in% 000:400 & sexo %in% c(2,"F")) |> nrow()  )/3


TMI.1.Mulher <-  (u/nasc_2020)*1000


# TMI 5 ANO  = (u/nasc_2020)*1000, u=(0btos_2010_219_2021  < 1 )/3

u<-
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade","sexo")] |> 
      filter(idade %in% 000:404 & sexo %in% c(2,"F")) |> nrow()  )/3

TMI.5.Mulher <-  (u/nasc_2020)*1000


# TMI POR SEXO 

TMI.1.Homem
TMI.1.Mulher

TMI.5.Mulher
TMI.5.Mulher


popMul
popHom


# Taxa Bruta de Mortalidade


tbm.homem<-
  merge(
    x = popHom, y = dtobto,
    by = "ano",all.x = TRUE) |> 
  mutate(
    TBM=map2(
      .x = numObtos,
      .y = populacao,
      
      .f = ~round( ((.x/.y)), digits = 2) )     ) |> 
  # filter(  grupo_etario %in% "Total" )  # Taxa Bruta de Mortalidade
  filter( ! grupo_etario %in% "Total" )   #"Taxa Especifica de Mortalidade"

tbm.homem

tbm.mulher<-
  merge(
    x = popMul, y = dtobto,
    by = "ano",all.x = TRUE) |> 
  mutate(
    TBM=map2(
      .x = numObtos,
      .y = populacao,
      
      .f = ~round(   ((.x/.y)*1000),   digits = 2) )   ) |>  
  # filter(  grupo_etario %in% "Total" )   # Taxa Bruta de Mortalidade
  filter( ! grupo_etario %in% "Total" )    # "Taxa Especifica de Mortalidade"


tbm.homem
tbm.mulher
#  ----


# DADOS

# DATA FRAME 
"No caso de 1q0,'Idades < 1', se os dados são de boa qualidade, pode-se
utilizar os valores obtidos a partir do cálculo direto da 'Taxa de
Mortalidade Infantil'
"
# OBTOS PARA A nMx

obtos<-
  simdf[simdf$ano %in% 2021,"ano"] |>   table() |>
  as.data.frame() |>  rename(ano=Var1,n.obtos=Freq)

obtos

#  BASE DE DADOS MULHER 
base.TabVida.Mulher<-
  popMul[popMul$ano %in% 2021,] |> 
  merge(y = obtos, by="ano", all.x = TRUE) |> 
  mutate(
    nMx = map2( .x = n.obtos, .y = populacao, .f = ~round(((.x/.y)),digits = 3) )
  ) |> 
  unnest(nMx) |> 
  # select(grupo_etario,ano,populacao,TMI.1q0, TMI.5q0, nMx) |> 
  mutate(
    nqx = map( .x = nMx, .f = ~round((4*(.x)/(1+(4-2)*.x)), digits = 3) )   ) |> 
  unnest(nqx) |> 
  select(grupo_etario, ano, nMx,nqx)
  

# write.csv(base.TabVida.Mulher, file = "dadoTratado/q3/base.TabVida.Mulhe.xls", row.names = FALSE)


#  BASE DE DADOS Homem 
base.TabVida.Homem<-
  popHom[popHom$ano %in% 2021,] |> 
  merge(y = obtos, by="ano", all.x = TRUE) |> 
  mutate(
    nMx = map2( .x = n.obtos, .y = populacao, .f = ~round(((.x/.y)),digits = 3) )
  ) |> 
  unnest(nMx) |> 
  mutate( nqx = map( .x = nMx, .f = ~round((4*(.x)/(1+(4-2)*.x)), digits = 3))   ) |> 
  unnest(nqx) |> 
  select(grupo_etario, ano, nMx,nqx)

  # write.csv(base.TabVida.Homem,file = "dadoTratado/q3/base.TabVida.Homem.xls", row.names = FALSE)


  


base.TabVida.Homem
base.TabVida.Mulher



