# code.Need.Q2 ------

#  Projeções
'popTotal'
popMul
popHom

# NUMERO DE NASCIMENTOS 
nascimentos<-
  sinascdf |>
  select(ano) |> 
  filter(
    ano %in% c(2010,2019,2021)
  ) |> 
  table() |> data.frame()

nascimentos




# code.Need.Q2A.TBN -----------------------------------------------------------------------

# - Taxa Bruta de Natalidade (TBN)


'Juntando dados necessarios "popTotal" e "nascimentos". Calculando TBN-TOTAL'

dadoTBNatali<-
  merge(x = popMul,y = nascimentos,  by = "ano", all.x = TRUE ) |>
  relocate(grupo_etario, .before = "ano") |>
  mutate(
    tbnTotal=map2( .x = Freq, .y = populacao,
      
      .f = ~round(((.x/.y)*1000), digits = 2),
      .progress = TRUE
    )
  ) |> 
  unnest(tbnTotal)|>
  rename(populacaoTotal=populacao) |> 
  filter(
    grupo_etario %in% "Total" 
  )


write.csv(x = dadoTBNatali,
          file = "Trabalho 1/dadoTratado/q2/TBNatali.csv",  row.names = FALSE )


# code.Remove.NOT.TBN------

rm(dadoTBNatali)
rm(nascimentos)



# code.Need.Q2A.TFG -----------------------------------------------------------------------------


# - Taxa Fecundidade Geral (TFG) e Taxas específicas de fecundidade - TEF (Grafique esses valores)  


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
    TFG=map2( .x = Freq, .y = populacao,
      
      .f = ~((.x/.y)*1000)    )
  ) |>
  unnest(TFG) |> 
  filter( grupo_etario == "Total")


tfg.mulher

write.csv(x = tfg.mulher, file = "Trabalho 1/dadoTratado/q2/TFG.csv", row.names = FALSE)

# grafico TFG
plot.tfg.ano<-
  ggplot(tfg.mulher, aes(x = factor(ano), y = TFG, group = 1 )) +
  geom_line(size = 1.5,  color = "#d8b365") +
  geom_point(size = 3.5,  color = "#d8b365") +
  theme_minimal() +
  theme(
    panel.grid.major.x = element_line(size = .7, color = "lightgrey"),
    panel.grid.major.y = element_line(size = 0.5),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) + 
  labs(
    title = "Taxa de Fecundidade Geral mulheres em idade Reprodutiva",
    x = "Anos Observados",
    y = "Taxa de Fecundidade Gerae")




ggsave( plot = plot.tfg.ano, path = "Trabalho 1/figuras/graficos/", filename = "TFG.grafico.png",
        dpi = 800,
        width = 12,
        height = 8,
        units = "cm",
        scale = 2 )









rm(nascimentos)

# code.Need.Q2B.TEF ------

"nascidos por idade da mãe em 2010 2019 e 2021"
nascimentos<-
  sinascdf |> 
  filter(
    ano %in% c(2010,2019,2021)
  ) |> 
  mutate(
    idademae = as.numeric(as.character(idademae)),
         grupo_etario = cut(
           idademae, c(15, 20, 25, 30, 35, 40, 45,50),
           labels = c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49"),
           include.lowest = TRUE)
    ) |>
  
  select(ano,grupo_etario) |> group_by() |> 
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
      
      # .f = ~((.x/.y)), # Grafico
      .f = ~round(((.x/.y)), digits = 4),
      .progress = TRUE
    )
  ) |> 
  unnest(TEF) |> 
  arrange(ano) 

tef.mulher 

write.csv(x = tef.mulher, file = "Trabalho 1/dadoTratado/q2/TEF.csv", row.names = FALSE)

# GRAFICO TEF 

library(ggplot2)
library(dplyr)

library(ggplot2)

plot.tef.ano<-
  ggplot(tef.mulher, aes(x = grupo_etario, y = TEF, color = as.factor(ano),group = ano)) +
  geom_line(size = 1.5) +
  geom_point(size = 3.5) +
  scale_color_manual(values = c("#d8b365", "#ef8a62", "#5ab4ac")) +
    # scale_y_log10()+
  theme_minimal() +
  theme(
    panel.grid.major.x = element_line(size = .7, color = "grey"),
    panel.grid.major.y = element_line(size = 0.5),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) + 
  labs(
    title = "Taxa de Especifica de Fecundidade de mulheres em idade Reprodutiva",
    x = "Grupos etários",
    y = "Taxa de Especifica Fecundidade",
    color = "ano")
  


ggsave( plot = plot.tef.ano, path = "Trabalho 1/figuras/graficos/", filename = "TEF.grafico.png",
       dpi = 800,
       width = 12,
       height = 8,
       units = "cm",
       scale = 2 )


rm(plot.tef.ano)

#  TAXA ESPECIFICA DE FECUNDIDADE FEMININA ------

filhas<- 
  sinascdf |> 
  filter(ano %in% c(2010, 2019, 2021)  & sexo %in% c(2, "F")) |> 
  mutate(
    idademae = as.numeric(as.character(idademae)),
    grupo_etario = cut(
      idademae, c(15, 20, 25, 30, 35, 40, 45,50),
      labels = c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49"),
      include.lowest = TRUE)
  ) |>
  select(ano,grupo_etario) |> group_by() |> 
  table() |> as.data.frame() |> arrange(ano) |> 
  
  relocate(grupo_etario, .before = "ano") |> 
  rename(numero.filhas=Freq) 



dado.tbr<-
  merge(x = popMul,y = filhas,  by = c("grupo_etario","ano")) |>
  mutate(
    TEF=map2( .x = numero.filhas, .y = populacao,
              
              .f = ~((.x/.y))
    )
  ) |>
  unnest(TEF)



plot.tef.feminina.ano<-
  ggplot(dado.tbr, aes(x = grupo_etario, y = TEF, color = as.factor(ano),group = ano)) +
  geom_line(size = 1.5) +
  geom_point(size = 3.5) +
  scale_color_manual(values = c("#d8b365", "#ef8a62", "#5ab4ac")) +
  # scale_y_log10()+
  theme_minimal() +
  theme(
    panel.grid.major.x = element_line(size = .7, color = "grey"),
    panel.grid.major.y = element_line(size = 0.5),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) + 
  labs(
    title = "Taxa de Especifica de Fecundidade Feminina de mulheres em idade Reprodutiva",
    x = "Grupos etários",
    y = "Taxa de Especifica Fecundidade Feminina",
    color = "ano")



ggsave( plot = plot.tef.feminina.ano, path = "Trabalho 1/figuras/graficos/", filename = "TEF.feminina.grafico.png",
        dpi = 800,
        width = 12,
        height = 8,
        units = "cm",
        scale = 2 )







# code.Need.Q2A.TFT ----

# Taxa Fecundidade Total

TFT.2010<-
 5*(
   tef.mulher |> 
   filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
      ano %in% 2010  ) |> 
  select(TEF)|> 
  sum()
  )


TFT.2019<-
  5*(
  tef.mulher |> 
  filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
      ano %in% 2019  ) |> 
  select(TEF)|> 
  sum()
  )

TFT.2021<-
  5*(
  tef.mulher |> 
  filter(
    grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
      ano %in% 2021  ) |> 
  select(TEF)|> 
  sum()
  )

TFT.2010
TFT.2019
TFT.2021

#  Data frame TEF | ano
TFT<-
  data.frame(
    ano = c(2010, 2019, 2021),
    TFT = c(TFT.2010, TFT.2019, TFT.2021)
    )
  
write.csv(x = TFT, file = "Trabalho 1/dadoTratado/q2/TFT.csv", row.names = FALSE)


rm(TFT.2010)
rm(TFT.2019)
rm(TFT.2021)
rm(TFT)
rm(plot.tef.ano)
rm(plot.tfg.ano)
rm(filhas)
rm(nascimentos)

# code.Need.Q2A.TBR------

# - Taxa Buta de Reprodução

# TFT FEMININA

filhas<- 
  sinascdf |> 
  filter(ano %in% c(2010, 2019, 2021)  & sexo %in% c(2, "F")) |> 
  mutate(
    idademae = as.numeric(as.character(idademae)),
    grupo_etario = cut(
      idademae, c(15, 20, 25, 30, 35, 40, 45,50),
      labels = c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49"),
      include.lowest = TRUE)
  ) |>
  select(ano,grupo_etario) |> group_by() |> 
  table() |> as.data.frame() |> arrange(ano) |> 
  
  relocate(grupo_etario, .before = "ano") |> 
  rename(numero.filhas=Freq) 



dado.tbr<-
  merge(x = popMul,y = filhas,  by = c("grupo_etario","ano")) |>
  mutate(
    TEF=map2( .x = numero.filhas, .y = populacao,
      
      .f = ~((.x/.y))
    )
  ) |>
  unnest(TEF)

dado.tbr

TBR.2010<-
  5*(
    dado.tbr |> 
      filter(
        grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
          ano %in% 2010  ) |> 
      select(TEF)|> 
      sum()
  )


TBR.2019<-
  5*(
    dado.tbr |> 
      filter(
        grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
          ano %in% 2019  ) |> 
      select(TEF)|> 
      sum()
  )

TBR.2021<-
  5*(
    dado.tbr |> 
      filter(
        grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
          ano %in% 2021  ) |> 
      select(TEF)|> 
      sum()
  )

TBR.2010
TBR.2019
TBR.2021

TBR<-
  data.frame(
  ano = c(2010, 2019, 2021),
  TBR = c(TBR.2010, TBR.2019, TBR.2021)
)

write.csv(x = TBR, file = "Trabalho 1/dadoTratado/q2/TBR.csv", row.names = FALSE)

# Relação TBR e TFT feminina - RS0 - razão -sexo ano ----

rs0<-
  sinascdf |> 
  filter(ano %in% c(2010, 2019, 2021)) |>
  select(ano, sexo, idademae) |> 
  mutate(
    sexo = ifelse(sexo %in% c(2, "F"), "F", "M" ), 
    idademae = as.numeric(as.character(idademae)),
  ) |>
  mutate(
    grupo_etario = cut(
      idademae, c(15, 20, 25, 30, 35, 40, 45,50),
      labels = c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49"),
      include.lowest = TRUE)
  ) |> arrange(grupo_etario, ano)


rs0<-
  (
    ( # FILTRANDO HOMENS 
      rs0 |> select(sexo,ano) |> filter(ano %in% c(2010, 2019, 2021) & sexo %in% "M") |> nrow()
    )/ 
      ( # FILTER MULHERES
        rs0 |> select(sexo, ano) |> filter(ano %in% c(2010, 2019, 2021) & sexo %in% "F") |> nrow()
      )
  )

# relação TBR e TFT Femina 
relacTBR.TFT<-
  TFT |> 
  mutate( relacao = round((TFT/(1+ rs0)), digits = 2)) |> 
  select(ano, relacao)

write.csv(x = relacTBR.TFT, file = "Trabalho 1/dadoTratado/q2/relacTBReTFT.csv", row.names = FALSE)



# code.Need.Q2A.TLR------

# - Taxa Liquida de Reprodução


filhas<-
  sinascdf |> 
  filter(ano %in% c(2010, 2019, 2021)  & sexo %in% c(2, "F")) |> 
  mutate(
    idademae = as.numeric(as.character(idademae)),
    grupo_etario = cut(
      idademae, c(15, 20, 25, 30, 35, 40, 45,50),
      labels = c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49"),
      include.lowest = TRUE)
  ) |>
  select(ano,grupo_etario) |> group_by() |> 
  table() |> as.data.frame() |> arrange(ano) |> 
  
  relocate(grupo_etario, .before = "ano") |> 
  rename(numero.filhas=Freq) 


TabVidaFeminina<-
  TabVidaFeminina |> 
  filter( grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49")) |> 
  mutate(
    ano = ifelse(row_number() %in% 1:7, 2010, 
           ifelse(row_number() %in% 8:14, 2019, 
                  ifelse(row_number() %in% 15:21, 2021, NA)))
  ) |> 
  arrange(ano)


dado.tef.finlhas<-
  merge(x = popMul,y = filhas,  by = c("grupo_etario","ano")) |> 
  merge(y = TabVidaFeminina, by = c("grupo_etario","ano")) |> 
    mutate(
      TEF.f = map2(.x = numero.filhas, .y= populacao, ~(.x/.y)),
      
      TLR = map2(.x = TEF.f, .y= as.numeric(nLx),  ~((.x)*(.y/100000))     )) |> 
  
  unnest(c(TEF.f,TLR)) |> 
    select(grupo_etario, ano, populacao, numero.filhas, nLx, TEF.f, TLR )

  
  
  

  
# calculo final 

TLR.2010<-
  5*(
    dado.tef.finlhas |> 
      filter(
        # grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
          ano %in% 2010  ) |> 
      select(TLR)|> 
      sum()
  )

TLR.2019<-
  5*(
    dado.tef.finlhas |> 
      filter(
        # grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
          ano %in% 2019  ) |> 
      select(TLR)|> 
      sum()
  )


TLR.2021<-
  5*(
    dado.tef.finlhas |> 
      filter(
        # grupo_etario %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") & 
          ano %in% 2021  ) |> 
      select(TLR)|> 
      sum()
  )

TLR.2010
TLR.2019
TLR.2021


TLR<- 
  data.frame(
  ano = c(2010, 2019, 2021),
  TLR = c(TLR.2010, TLR.2019, TLR.2021)
)

write.csv(x = TLR, file = "Trabalho 1/dadoTratado/q2/TLR.csv", row.names = FALSE)






# code.Remove  -----


rm(dado.tbr)
rm(dado.tef.finlhas)
rm(dadoDiagLex)
rm(filhas)
rm(funcaoTbL)
rm(nascimentos)
rm(nLx.Tabua.F)
rm(plot.tef.ano)
rm(TBR.2010)
rm(TBR.2019)
rm(TBR.2021)
rm(tef.mulher)
rm(tfg.mulher)
rm(TFT.2010)
rm(TFT.2019)
rm(TFT.2021)
rm(TLR.2010)
rm(TLR.2019)
rm(TLR.2021)

