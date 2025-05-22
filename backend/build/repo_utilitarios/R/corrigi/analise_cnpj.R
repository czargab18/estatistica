# Script ----

library(tidyverse)

df<-readxl::read_xlsx(path = 'base/CNPJ - pag.Lei-doBem & pasta.P-rede.xlsx',sheet = 3)
names(df)

library(dplyr)

# Supondo que df é o seu data frame já carregado
# As colunas que estamos utilizando são: "Ano_Base" e "cnpj"

resultado <- df %>%
  arrange(Ano_Base) %>%
  group_by(Ano_Base) %>%
  summarise(
    CNPJ_acumulados = n_distinct(cnpj),
    .groups = 'drop'
  ) %>%
  mutate(
    CNPJs_novos = CNPJ_acumulados - lag(CNPJ_acumulados, default = 0),
    CNPJs_novos = ifelse(is.na(CNPJs_novos), CNPJ_acumulados, CNPJs_novos),
    Proporcao_novos = CNPJs_novos / lag(CNPJ_acumulados, default = NA)
  )

# Adicionando uma coluna para verificar CNPJs novos
acumulados <- c()  # vetor para armazenar os CNPJs acumulados

# Loop para verificar CNPJs novos
df$CNPJ_novo <- FALSE  # Inicializa a coluna como FALSE

for (ano in unique(df$Ano_Base)) {
  cnpj_atual = df$cnpj[df$Ano_Base == ano]
  novos_cnpj = setdiff(cnpj_atual, acumulados)  # CNPJs novos
  df$CNPJ_novo[df$Ano_Base == ano & df$cnpj %in% novos_cnpj] <- TRUE  # Marca como novo
  acumulados <- unique(c(acumulados, cnpj_atual))  # Atualiza o vetor de acumulados
}

# Resumo de CNPJs novos por ano
resultado_novos <- df %>%
  group_by(Ano_Base) %>%
  summarise(
    CNPJs_novos = sum(CNPJ_novo),
    CNPJ_acumulados = n_distinct(cnpj),
    Proporcao_novos = CNPJs_novos / CNPJ_acumulados
  )

# Verifique o resultado
print(resultado_novos)

# teste ----

# Exemplo simples de dados
df_exemplo <- data.frame(
  Indice_AnoBase = 1:10,
  Razão_Social = rep("Empresa", 10),
  cnpj = c("12345678000195", "12345678000195", "23456789000112", "34567890000123",
           "12345678000195", "23456789000112", "45678901000134", "56789012000145",
           "67890123000156", "78901234000167"),
  UF = rep("SP", 10),
  Ano_Base = c(2006, 2006, 2007, 2007, 2008, 2008, 2009, 2010, 2011, 2011)
)

print(df_exemplo)