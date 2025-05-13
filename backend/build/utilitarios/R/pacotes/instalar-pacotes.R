# verificar pacotes instalados ----

save_installed_packages <- function(file_path = "installed_packages.txt") {
  # Obtém a lista de pacotes instalados
  installed_packages <- installed.packages()[, "Package"]
  
  # Adiciona aspas duplas a cada nome de pacote
  quoted_packages <- paste0('"', installed_packages, '"')
  
  # Cria a string no formato desejado
  package_list <- paste(quoted_packages, collapse = ", ")
  package_string <- paste0("pacote <- c(", package_list, ")")
  
  # Salva a string em um arquivo .txt
  write(package_string, file = file_path)
  
  cat("Lista de pacotes instalada salva em", file_path, "\n")
}

# Uso da função
save_installed_packages("installed_packages.txt")


# instalar pacotes -----

check_and_install_packages <- function(file_path = "installed_packages.txt") {
  # Lê o arquivo .txt
  package_string <- readLines(file_path)
  
  # Extrai os nomes dos pacotes da string
  package_names <- gsub('pacote <- c\\(|\\)|"', '', package_string)
  package_names <- unlist(strsplit(package_names, ", "))
  
  # Função para verificar se o pacote está instalado
  is_installed <- function(pkg) {
    pkg %in% rownames(installed.packages())
  }
  
  # Função para verificar se o pacote está atualizado
  is_up_to_date <- function(pkg) {
    available <- available.packages()
    if (pkg %in% rownames(available)) {
      installed_version <- as.character(packageVersion(pkg))
      latest_version <- available[pkg, "Version"]
      compareVersion(installed_version, latest_version) >= 0
    } else {
      FALSE
    }
  }
  
  # Verifica e instala/atualiza pacotes
  for (pkg in package_names) {
    if (!is_installed(pkg)) {
      cat("Instalando pacote:", pkg, "\n")
      install.packages(pkg)
    } else if (!is_up_to_date(pkg)) {
      cat("Atualizando pacote:", pkg, "\n")
      install.packages(pkg)
    } else {
      cat("Pacote já está instalado e atualizado:", pkg, "\n")
    }
  }
  
  cat("Verificação e instalação de pacotes concluída.\n")
}

# Uso da função
check_and_install_packages("installed_packages.txt")


