# ANSWER ------

# compare as suas TBM. Descreva os cálculos e as 
# hipóteses utilizadas nesta comparação. (Utilize os dois métodos de 
# comparação de TBM - padronização direta e indireta)



# cálculo da TBM e TEM e PADRONIZAÇÃO----

dadoPadDireta <-
  dadosPivot |> 
  # filter( ! grupo %in% 'Total') |>
  mutate(
    Bpadron = map2( .x = nMxB, .y = nPxW, .f = ~round(((.x*.y)/211782.9), digits = 2)  ),# P_bar_Brasil
    Tpadron = map2( .x = nMxT, .y = nPxW, .f = ~round(((.x*.y)/59872.58), digits = 2)  )# P_bar_Tanzania
  ) |> 
  unnest(c(Bpadron, Tpadron)) |> 
  select(grupo,nMxB,nMxT,nPxW,Bpadron,Tpadron)

  
  # write.csv(file = "Atividades/PadronTaxas/dadosTratados/PadDireta.csv",row.names = FALSE)


# PADRONIZAÇÃO DIRETA 



sum(  dadoPadDireta[,"Bpadron"]   ) # 0.2541
sum(  dadoPadDireta[,"Tpadron"]   ) # 1.4007


# .final


# GRAFICO ---
plot.dado<-
dadosPivot |> 
  filter( ! grupo %in% 'Total') |>
  select(grupo, nMxB, nMxT, nMxW, nPxW ) |> 
  mutate(
    Bpadron = map2( .x = nMxB, .y = nPxW, .f = ~round(((.x*.y)/211782.9), digits = 9)  ),# P_bar_Brasil
    Tpadron = map2( .x = nMxT, .y = nPxW, .f = ~round(((.x*.y)/59872.58), digits = 9)  )# P_bar_Tanzania
  ) |> 
  unnest( c(Tpadron,Bpadron) ) |> 
  pivot_longer(

  cols = -c(grupo,nPxW),
  names_to = "Pais", values_to = "nMxPad" ) |> 

# GRAFICO PADRONIZAÇÃO DIRETA 

  mutate(grupo = if_else(grupo == "80-100", "80+", grupo)) |> 
  mutate(
    grupo =
      factor(grupo,
             levels = c("0-1","1-4","5-9","10-14","15-19","20-24",
                        "25-29","30-34", "35-39","40-44","45-49",
                        "50-54","55-59","60-64","65-69","70-74",
                        "75-79","80+"))) |>
  arrange(grupo) |> 
  filter(
  !  Pais %in% c("nMxB", "nMxT")
  ) |> 
  select(grupo, nMxPad,Pais) |> 
  mutate(
    Pais = if_else( Pais == 'nMxW','População Mundial',Pais),
    Pais = if_else( Pais == 'Tpadron','República Unida da Tanzânia',Pais),
    Pais = if_else( Pais == 'Bpadron','Brasil',Pais) 
    )


plot.dado |> 
ggplot( aes(x = grupo, y = nMxPad, colour = Pais,   group = Pais)  ) +
  
  geom_line(size = 2.5) +
  scale_y_log10() +
  
  scale_color_manual(values = c("lightgreen", "orange","skyblue"))+
  labs(
    # title = "Taxa Especifica de Mortalidade de Homens e Mulheres em 2010 2019 e 2021",
    x = "Grupos Etários",
    y = "Taxa de Mortalidade Padronizada \n (escala logarítmica)"
  ) + 
  theme_minimal()+
  bbplot::bbc_style() +
  
  
  theme(
    axis.title.y = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 12, face = "plain"),
    axis.ticks = element_line(color = "gray"),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 8),
    
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.border = element_blank())


# .final

"como visto no grafico, as taxas estão padronizadas em relação a população Mundial."




# COMPARAÇÃO DIRETA ----

dadosPivot |> 
  select( !c("nDxW", "nPxW", "nMxW" )) |>
  write.csv(file = "Atividades/PadronTaxas/dadosTratados/dadosPopMort.csv",row.names = FALSE)


dadosPivot |> 
  select( c("grupo","nDxW", "nPxW", "nMxW" )) |>
  write.csv(file = "Atividades/PadronTaxas/dadosTratados/dadosMortal.csv",row.names = FALSE)




