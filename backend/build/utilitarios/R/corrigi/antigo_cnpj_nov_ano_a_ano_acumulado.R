setwd("C:/Users/cesar.oliveira/Documents/github/cnpj-novo/")

# Carregar os pacotes necessários
library(readxl)
library(dplyr)

# Ler o arquivo Excel (substitua 'caminho_do_arquivo.xlsx' pelo caminho real do arquivo)
df <- read_excel("cnpj-participantes-lei-do-bem-2006-a-2023.xlsx")

# Remover os caracteres ".", "/", "-" da coluna CNPJ
df$CNPJ <- gsub("[./-]", "", df$CNPJ)

# Inicializar vetores para armazenar os resultados
anos <- sort(unique(df$Ano_Base))
cnpj_novos_por_ano <- c()
total_cnpjs_por_ano <- c()

# Inicializar um conjunto vazio para armazenar todos os CNPJs já vistos
cnpjs_vistos <- character(0)

# Iterar sobre os anos e calcular quantos CNPJs são novos e o total de CNPJs em cada ano
for (ano in anos) {
  # Selecionar os CNPJs do ano atual
  cnpjs_ano_atual <- df %>% filter(Ano_Base == !!ano) %>% pull(CNPJ) %>% unique()
  
  # Calcular os CNPJs novos: aqueles que ainda não foram vistos
  cnpjs_novos <- setdiff(cnpjs_ano_atual, cnpjs_vistos)
  
  # Armazenar o número de novos CNPJs
  cnpj_novos_por_ano[as.character(ano)] <- length(cnpjs_novos)
  
  # Armazenar o número total de CNPJs do ano atual
  total_cnpjs_por_ano[as.character(ano)] <- length(cnpjs_ano_atual)
  
  # Atualizar o conjunto de CNPJs já vistos com os do ano atual
  cnpjs_vistos <- union(cnpjs_vistos, cnpjs_ano_atual)
}

# Criar um dataframe com os resultados
df_resultado <- data.frame(
  Ano = anos,
  Novos_CNPJs = cnpj_novos_por_ano,
  Total_CNPJs = total_cnpjs_por_ano
)

# Exibir o dataframe com os resultados
print(df_resultado)

# Opcional: visualizar o dataframe em formato de tabela
View(df_resultado)




openxlsx::write.xlsx(x = df_resultado,file = 'cnpj-novos.xlsx')
