
# FUNÇÃO CHAT nlx-ndx - v*.*.*----

calculateValues <- function(df) {
  df$lx <- integer(nrow(df))
  df$ndx <- integer(nrow(df))
  
  # Definir lx e ndx para o grupo etário "0"
  df$lx[1] <- 100000
  df$ndx[1] <- round(df$lx[1] * as.numeric(df$nqx[1]), 0)
  
  # Calcular lx e ndx para os outros grupos etários
  for (i in 2:nrow(df)) {
    df$lx[i] <- df$lx[i-1] - df$ndx[i-1]
    df$ndx[i] <- round(df$lx[i] * as.numeric(df$nqx[i]), 0)
  }
  
  return(df)
}


TEM.M<-calculateValues(TEM.M)

# TREINAMENTO -----


# FUNÇÃO CHAT nLx - v*.*.*----
calculate_nLx <- function(df) {
  nLx <- numeric(nrow(df))  # Cria um vetor vazio para armazenar os valores de nLx
  
  for (i in 1:nrow(df)) {
    grupo_etario <- df$grupo_etario[i]
    lx <- df$lx[i]
    
    if (!is.na(grupo_etario)) {
      if (grupo_etario %in% c("0", "1-4")) {
        if (grupo_etario == "0") {
          fx <- 0.4
        } else {
          fx <- 0.1
        }
        
        if (i < nrow(df)) {
          lx_n <- df$lx[i+1]
          nLx[i] <- fx * lx + (1 - fx) * lx_n
        } else {
          nLx[i] <- fx * lx
        }
      } else if (grupo_etario %in% c("5-9", "10-14", "15-19", "20-24", "50-54")) {
        if (i < nrow(df)) {
          lx_n <- df$lx[i+1]
          nLx[i] <- (4/2) * (lx + lx_n)
        } else {
          nLx[i] <- (4/2) * lx
        }
      } else if (grupo_etario >= "25") {
        nLx[i] <- (4.769 + 0.0000536 * lx) * lx
      } else {
        nLx[i] <- NA  # Define nLx como NA para linhas com grupo_etario inválido
      }
    }
  }
  
  df$nLx <- nLx  # Adiciona a coluna nLx ao data frame
  return(df)
}

calculate_nLx(TEM.M)
# --------
calculate_nLx <- function(df) {
  nLx <- numeric(nrow(df))  # Cria um vetor vazio para armazenar os valores de nLx
  
  for (i in 1:nrow(df)) {
    grupo_etario <- df$grupo_etario[i]
    lx <- df$lx[i]
    
    if (!is.na(grupo_etario)) {
      if (grupo_etario %in% c("0", "1-4")) {
        if (grupo_etario == "0") {
          fx <- 0.4
        } else {
          fx <- 0.1
        }
        
        if (i < nrow(df)) {
          lx_n <- df$lx[i+1]
          nLx[i] <- fx * lx + (1 - fx) * lx_n
        } else {
          nLx[i] <- fx * lx
        }
      } else if (grupo_etario %in% c("5-9", "10-14", "15-19", "20-24")) {
        if (i < nrow(df)) {
          lx_n <- df$lx[i+1]
          nLx[i] <- (4/2) * (lx + lx_n)
        } else {
          nLx[i] <- (4/2) * lx
        }
      }else if (grupo_etario >= "25") {
        nLx[i] <- (4.769 + 0.0000536 * lx) * lx
      } else {
        nLx[i] <- NA  # Define nLx como NA para linhas com grupo_etario inválido
      }
    }
  }
  
  df$nLx <- nLx  # Adiciona a coluna nLx ao data frame
  return(df)
}


calculate_nLx(TEM.M)


#  ----------
calculate_nLx <- function(df) {
  nLx <- numeric(nrow(df))  # Cria um vetor vazio para armazenar os valores de nLx
  
  for (i in 1:nrow(df)) {
    grupo_etario <- df$grupo_etario[i]
    lx <- df$lx[i]
    
    if (grupo_etario %in% c("0", "1-4")) {
      if (grupo_etario == "0") {
        fx <- 0.4
      } else {
        fx <- 0.1
      }
      
      if (i < nrow(df)) {
        lx_n <- df$lx[i+1]
        nLx[i] <- fx * lx + (1 - fx) * lx_n
      } else {
        nLx[i] <- fx * lx
      }
    } else if (grupo_etario %in% c("5-9", "10-14", "15-19", "20-24")) {
      if (i < nrow(df)) {
        lx_n <- df$lx[i+1]
        nLx[i] <- (4/2) * (lx + lx_n)
      } else {
        nLx[i] <- (4/2) * lx
      }
    } else if (as.numeric(grupo_etario) >= 8) {
      nLx[i] <- (4.769 + 0.0000536 * lx) * lx
    }
  }
  
  df$nLx <- nLx  # Adiciona a coluna nLx ao data frame
  return(df)
}

calculate_nLx(TEM.M)


# grupo etário corrigido

calculate_nLx <- function(df) {
  nLx <- numeric(nrow(df))  # Cria um vetor vazio para armazenar os valores de nLx
  
  for (i in 1:nrow(df)) {
    grupo_etario <- df$grupo_etario[i]
    lx <- df$lx[i]
    
    if (grupo_etario %in% c("0", "1-4")) {
      if (grupo_etario == "0") {
        fx <- 0.4
      } else {
        fx <- 0.1
      }
      
      if (i < nrow(df)) {
        lx_n <- df$lx[i+1]
        nLx[i] <- fx * lx + (1 - fx) * lx_n
      } else {
        nLx[i] <- fx * lx
      }
    } else if (grupo_etario %in% c("5-9", "10-14", "15-19", "20-24")) {
      if (i < nrow(df)) {
        lx_n <- df$lx[i+1]
        nLx[i] <- (4/2) * (lx + lx_n)
      } else {
        nLx[i] <- (4/2) * lx
      }
    } else if (grupo_etario >= "8") {
      nLx[i] <- (4.769 + 0.0000536 * lx) * lx
    }
  }
  
  df$nLx <- nLx  # Adiciona a coluna nLx ao data frame
  return(df)
}



calculate_nLx(TEM.M)













# -------



calculate_nLx <- function(df) {
  nLx <- numeric(nrow(df))  # Cria um vetor vazio para armazenar os valores de nLx
  
  for (i in 1:nrow(df)) {
    grupo_etario <- df$grupo_etario[i]
    lx <- df$lx[i]
    
    if (grupo_etario < 5) {
      if (grupo_etario == 0) {
        fx <- 0.4
      } else {
        fx <- ifelse(grupo_etario == 4, 0.35, 0.1)
      }
      
      if (i < nrow(df)) {
        lx_n <- df$lx[i+1]
        nLx[i] <- fx*lx + (1-fx)*lx_n
      } else {
        nLx[i] <- fx*lx
      }
    } else {
      if (grupo_etario >= 8) {
        nLx[i] <- (4.769 + 0.0000536*lx) * lx
      } else {
        if (i < nrow(df)) {
          lx_n <- df$lx[i+1]
          nLx[i] <- (4/2) * (lx + lx_n)
        } else {
          nLx[i] <- (4/2) * lx
        }
      }
    }
  }
  
  df$nLx <- nLx  # Adiciona a coluna nLx ao data frame
  return(df)
}
