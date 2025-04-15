# Padronização Indireta ----


# PADRONIZAÇÃO INDIRETA   ----

dadoPadIndireta<-
  dadosPivot |> 
  # filter( ! grupo %in% 'Total') |> 
  mutate(
    Bnumer = map2( .x = nMxB, .y = nPxB, .f = ~round((.x*(.y/211782.9)), digits = 4)  ), # P_bar_Brasil
    Bdenom = map2( .x = nMxW, .y = nPxB, .f = ~round((.x*(.y/211782.9)), digits = 4)  ), # P_bar_Brasil

    Tnumer = map2( .x = nMxT, .y = nPxT, .f = ~round((.x*(.y/59872.58)), digits = 4)  ), # P_bar_Tanzania
    Tdenom = map2( .x = nMxW, .y = nPxT, .f = ~round((.x*(.y/59872.58)), digits = 4)  ), # P_bar_Tanzania
  ) |> 
  unnest(c(Bnumer,Bdenom, Tnumer,Tdenom))



IpB = sum(  dadoPadIndireta[,"Bnumer"]   ) / sum(  dadoPadIndireta[,"Bdenom"]   ) # [1] 0.915493

IpT = sum(  dadoPadIndireta[,"Tnumer"]   ) / sum(  dadoPadIndireta[,"Tdenom"]   ) # [1] 1.487805


# .final

dadosPivot |> 
  select(
    grupo, nMxB,nMxT,nPxW
  ) |> 
  write.csv(file = "Atividades/PadronTaxas/dadosTratados/PadIndir.csv",row.names = FALSE)


# |grupo|nMxB|nMxT|nPxW|

