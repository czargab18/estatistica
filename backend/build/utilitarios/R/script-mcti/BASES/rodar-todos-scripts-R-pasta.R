# Diretório onde os scripts estão localizados
diretorio <- "C:/Users/cesar.oliveira.INTRA/Documents/César Gabriel/Lei do bem/pesquisadores/code"

# Lista todos os arquivos na pasta
  arquivos <- list.files(diretorio, full.names = TRUE)

# Filtra apenas os arquivos .r
scripts_r <- arquivos[grep("\\.R$", arquivos)]

# Encontra o arquivo IMPORT.r se existir
import_r <- file.path(diretorio, "import.R")
if (import_r %in% scripts_r) {
  # Remove IMPORT.r para rodar por último 
  scripts_r <- scripts_r[scripts_r != import_r]
  # Adiciona IMPORT.r no final
  scripts_r <- c(scripts_r, import_r)
}

# Loop para executar cada script
for (script in scripts_r) {
  cat("Executando:", script, "\n")
  source(script)
}

