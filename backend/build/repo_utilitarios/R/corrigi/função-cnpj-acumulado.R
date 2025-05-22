library(tidyverse)

# Função ----
calcular_proporcao_novos_cnpjs <- function(df, coluna_ano, coluna_cnpj) {
  # Cria uma cópia do data frame para não modificar o original
  df <- df %>% 
    select({{coluna_ano}}, {{coluna_cnpj}}) %>%
    distinct() %>% # Remove duplicatas dentro de cada ano
    rename(Ano_Base = {{coluna_ano}}, cnpj = {{coluna_cnpj}})
  
  # Inicializa a coluna de novos CNPJs e o vetor de acumulados
  df$CNPJ_novo <- FALSE
  acumulados <- c()
  
  # Loop para marcar novos CNPJs em cada ano
  for (ano in unique(df$Ano_Base)) {
    cnpj_atual <- df$cnpj[df$Ano_Base == ano]
    
    # Se for o primeiro ano (2006 ou o primeiro ano disponível), todos os CNPJs são novos
    if (ano == min(df$Ano_Base)) {
      df$CNPJ_novo[df$Ano_Base == ano] <- TRUE
    } else {
      # Identifica os CNPJs novos (não presentes nos acumulados)
      novos_cnpj <- setdiff(cnpj_atual, acumulados)
      df$CNPJ_novo[df$Ano_Base == ano & df$cnpj %in% novos_cnpj] <- TRUE
    }
    
    # Atualiza o vetor acumulado com os novos CNPJs
    acumulados <- unique(c(acumulados, cnpj_atual))
  }
  
  # Resumo final com contagem de novos CNPJs e proporção acumulada
  resultado <- df %>%
    group_by(Ano_Base) %>%
    summarize(
      CNPJs_novos = sum(CNPJ_novo, na.rm = TRUE),
      CNPJ_acumulados = n_distinct(cnpj),
      Proporcao_novos = CNPJs_novos / lag(CNPJ_acumulados, default = CNPJs_novos[1]),
      .groups = 'drop'
    )
  
  return(resultado)
}
# Teste Base qualquer -----

# Data frame de exemplo (ou substitua com seu próprio data frame)
df_exemplo <- data.frame(
  Indice_AnoBase = 1:12,
  Razão_Social = rep("Empresa", 12),
  cnpj = c("12345678000195", "12345678000195", "23456789000112", "34567890000123",
           "12345678000195", "23456789000112", "45678901000134", "56789012000145",
           "67890123000156", "78901234040167","78901234040167","78901234400167"),
  UF = rep("SP", 12),
  Ano_Base = c(2006, 2006, 2007, 2007, 2008, 2008, 2009, 2010, 2011, 2011,2010, 2011)
) |> 
  arrange(Ano_Base)

print(df_exemplo)

resultado <- calcular_proporcao_novos_cnpjs(df_exemplo, coluna_ano = Ano_Base, coluna_cnpj = cnpj)

print(resultado)  


# Teste amostra base de dados CNPJ -----
library(readxl)
getwd()

df_menor<-
  readxl::read_xlsx(path = 'base/CNPJ - pag.Lei-doBem & pasta.P-rede.xlsx', sheet = 1) |> 
  select(Ano_Base = Ano_Base, cnpj = cnpj) |> 
  filter(Ano_Base %in% c(2006:2007)) |>
  arrange(Ano_Base)

print(df_menor,n = 430)

# função
calcular_proporcao_novos_cnpjs(df_menor, coluna_ano = Ano_Base, coluna_cnpj = cnpj)



# Base completa----
base_completa <- 
  readxl::read_xlsx(path = 'base/base completa.xlsx', sheet = 2) |>
  select(Ano_Base, cnpj) |> 
  arrange(Ano_Base) |> 
  mutate(
    Ano_Base = as.integer(Ano_Base),
  )

calcular_proporcao_novos_cnpjs(df = base_completa,coluna_ano = Ano_Base, coluna_cnpj = cnpj)

