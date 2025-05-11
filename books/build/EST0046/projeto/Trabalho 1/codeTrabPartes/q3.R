# code.Need.Q3 ------

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
      
      .f = ~round( ((.x/.y)*1000), digits = 2) )     ) |> 
  filter(  grupo_etario %in% "Total" ) # Taxa Bruta de Mortalidade
# filter( ! grupo_etario %in% "Total" )  "Taxa Especifica de Mortalidade"

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
  filter(  grupo_etario %in% "Total" ) # Taxa Bruta de Mortalidade
  # filter( ! grupo_etario %in% "Total" )  "Taxa Especifica de Mortalidade"


tbm.mulher

rm(tbm.homem)
rm(tbm.mulher)


  merge(tbm.homem, tbm.mulher, by = c("grupo_etario","ano")) |> 
    select(grupo_etario, ano, TBM.x, TBM.y) |> 
    
  pivot_longer(cols = -c(grupo_etario, ano), names_to = "Sexo", values_to = "nMx") |> 
    
  mutate(Sexo = if_else(Sexo == "TBM.x", "Masculino", "Feminino")) |> 
  mutate(grupo_etario = if_else(grupo_etario == "80-84", "80+", grupo_etario)) |> 
  filter( ! grupo_etario %in% c("85-89","90+")  ) |> 
    mutate(
         grupo_etario = 
           factor(grupo_etario,
                  levels = c("0-4","5-9","10-14","15-19","20-24",
                             "25-29","30-34", "35-39","40-44","45-49",
                             "50-54","55-59","60-64","65-69","70-74",
                             "75-79","80+"))) |> 
    arrange(grupo_etario) |> 
                          
 
    # filter(ano==2010) |> 

# Gráfico TBM Masculino Feminina
  
ggplot(aes(x = grupo_etario, y = nMx, group = paste(ano, Sexo), colour = Sexo))+
  geom_line(size = 1) +
  scale_color_manual(values = c("skyblue", "orange"))+
  scale_y_log10() +
  facet_wrap(~ano, ncol = 1) +
    labs(
      # title = "Taxa Especifica de Mortalidade de Homens e Mulheres em 2010 2019 e 2021",
      x = "Coortes",
      y = "Taxa Especifica de Mortalidade"
    ) +
    
  theme_minimal()+
  theme(
    axis.title.y = element_text(size = 12, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.ticks = element_line(color = "gray"),
       
     panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.border = element_blank(),
        axis.line = element_line(color = "gray"))










#  EXPORTAR PIVOTE AMAENTO DE MULHERES E HOMENS
tbm.mulher |> 
pivot_wider( names_from = ano, values_from = populacao:TBM) |> 
  rename(
    `grupo etário` = "grupo_etario",
    `População 2010` = "populacao_2010",
    `População 2019` = "populacao_2019",
    `População 2021` = "populacao_2021",
    `Numero de óbtos 2010` = "numObtos_2010",
    `Numero de óbtos 2019` = "numObtos_2019",
    `Numero de óbtos 2021` = "numObtos_2021",
    `TBM 2010` = "TBM_2010",
    `TBM 2019` = "TBM_2019",
    `TBM 2021` = "TBM_2021",
    
  ) 

  # write.csv(file = "dadoTratado/q3/tbm.mulher.csv",row.names = FALSE)


tbm.homem  |> 
pivot_wider( names_from = ano, values_from = populacao:TBM) |> 
  rename(
    `grupo etário` = "grupo_etario",
    `População 2010` = "populacao_2010",
    `População 2019` = "populacao_2019",
    `População 2021` = "populacao_2021",
    `Numero de óbtos 2010` = "numObtos_2010",
    `Numero de óbtos 2019` = "numObtos_2019",
    `Numero de óbtos 2021` = "numObtos_2021",
    `TBM 2010` = "TBM_2010",
    `TBM 2019` = "TBM_2019",
    `TBM 2021` = "TBM_2021",
    
  ) 

  # write.csv(file = "dadoTratado/q3/tbm.homen.csv",row.names = FALSE)


rm(tbm.homem)
rm(tbm.mulher)



# b) Calcule a TMI, utilizando o número médio de óbitos ocorridos entre 2019 e 2021
#    e o número de nascimentos de 2020. 

"nascimentos"
nasc_2020<- sinascdf[sinascdf$ano %in% 2020, ] |> select(ano) |> nrow()

# TMI 1 ANO  = (u/nasc_2020)*1000, u=(0btos_2010_219_2021  < 1 )/3

"numero delinhas /3 anos"
u<- 
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade")] |> 
      filter(idade %in% 000:400) |> nrow()  )/3


TMI.1.ano <-  (u/nasc_2020)*1000


# TMI 5 ANO  = (u/nasc_2020)*1000, u=(0btos_2010_219_2021  < 1 )/3

u<-
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade")] |> 
      filter(idade %in% 000:404) |> nrow()  )/3

TMI.5.ano <-  (u/nasc_2020)*1000





#  Calcule os indicadores: ----------------------------------------------


# taxa de mortalidade neonatal,
u<-
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade")] |> 
      filter(idade %in% 000:227) |> nrow()  )/3

TMI.neo <-  (u/nasc_2020)*1000




# neonatal precoce,
u<-
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade","sexo")] |> 
      filter(idade %in% 000:207 ) |> nrow()  )/3

TMI.prec <-  (u/nasc_2020)*1000


# neonatal tardia,

u<-
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade")] |> 
      filter(idade %in% 207:227) |> nrow()  )/3

TMI.neo <-  (u/nasc_2020)*1000



# posneonatal.
u<-
  ( simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade")] |> 
      filter(idade %in% 207:227) |> nrow()  )/3

TMI.pos <-  (u/nasc_2020)*1000

# neonatal perinatal

{
(   
  (
    (    simdf[simdf$ano %in% c(2010,2019,2020),c("ano","idade")] |> 
       filter(idade %in% 000:207) |> nrow() 
       )
                                +
       ( 
         simdf[simdf$ano %in% c(2010,2019,2020),c("ano","semagestac")] |> 
       filter(  ! semagestac %in% 00:21) |> nrow()
       )
    
  )/3
)/nasc_2020
} 


# code.Need.Q3B.TMIperineo ---





# data frame TAXAS Mortalidade Infantil ----



tabela3b <- data.frame('Dados' = "Goiás 2018-2020",
                       'Infantil' = TMI*1000,
                       'Neonatal' = tx_mort_neotal*1000,
                       'Neonatal Precoce' = tx_mort_neotal_precoce*1000,
                       'Neonatal Tardia' = tx_mort_neotal_tardia*1000,
                       'Pós Neonatal' = tx_mort_posneotal*1000,
                       'Neonatal Perinatal' = tx_mort_neotal_perinatal*1000,
                       'Obitos Fetais' = tx_mort_obitos_fetais*1000)

colnames(tabela3b) <- c('Dados', 'Infantil','Neonatal', 'Neonatal Precoce', 'Neonatal Tardia', 'Pós Neonatal', 'Neonatal Perinatal', 'Obitos Fetais')




