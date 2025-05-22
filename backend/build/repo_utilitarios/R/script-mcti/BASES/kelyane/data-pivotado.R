# Numero de empresas ----
table(data$CNPJ) |> 
  as.data.frame() |> 
  summarise(
    'sum' = sum(Freq),
    'mean' = mean(Freq)
  )
count(Var1) |> 
  summarise(
    'sum' = sum(n)
  )
# Numero de Professores ----
table(data$Nome) |> 
  as.data.frame() |> 
  summarise(
    'sum' = sum(Freq),
    'mean' = mean(Freq)
  )
count(Var1) |> 
  summarise(
    'sum' = sum(n)
  )

# Numero de Professores Sexo ND ----
  table(data$Nome,data$Sexo) |> 
    as.data.frame() |> 
    filter(Var2 %in% 'ND') |>
    arrange(Var1) |> 
  mutate(
    n = 1
  ) |> 
  summarise(
    'sum' = sum(n)
  )

# pivotamento ----

data |> 
  dplyr::select(
    -c("CPF","Razão Social","Tipo Instituição",)
  ) |> 
  dplyr::arrange(Nome) |> 
  pivot_wider(
    names_from = c(`Nome`),
    values_from = c(`CNPJ`),
    values_fn = list
  ) |> 
  # pivot_longer(
  #   cols = c(`ABEL CASSIANO MARIA`:`ZILDA MARIA GONÇALVES`),
  #   names_to = 'Nome',
  #   values_to = 'CNPJ'
  # ) |> 
  view()

names(data)


