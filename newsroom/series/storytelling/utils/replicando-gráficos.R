# Replicando gráficos Histograma ----
# https://www.nexojornal.com.br/grafico/2023/07/21/Maioria-dos-jogos-da-Copa-acontece-na-madrugada-brasileira


# Instale o pacote ggplot2 se ainda não o tiver instalado
# install.packages("ggplot2")

# Carregue o pacote ggplot2
library(ggplot2)

# Crie um conjunto de dados de exemplo com horas aleatórias
set.seed(123)
horas <- sample(21:32, 100, replace = TRUE) # Gere horas entre 21 e 32 (9h da manhã do dia seguinte)
dados <- data.frame(horas = horas) |>
  dplyr::mutate(
    horas = dplyr::if_else(horas >= 24, horas - 24, horas)
  )
View(dados)


# Rótulos a serem destacados
rotulos_destacados <- c(3, 9, 15, 21)

# Crie um histograma usando ggplot2
ggplot(dados, aes(x = horas)) +
  geom_rect(
    xmin = 25, xmax = 28,
    ymin = 0, ymax = 12, fill = "red", alpha = 0.3
  ) +
  geom_histogram(
    binwidth = 1, fill = "#2B825B", color = "black", alpha = 0.7
  )+
  scale_y_continuous(
    breaks = c(seq(0, 10, 2), 12),
    labels = c(seq(0, 10, 2), "12 jogos")
  ) +
  theme(
    panel.grid.major.y = element_line(
      linewidth = .5,
      linetype = "dashed",
      colour = "#898989"
      ),
    panel.background = element_rect(
      fill = "#ffffff",
      linewidth = 2
      ),
    panel.grid.minor = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid = element_blank(),
    # axis.text.x = element_text(
    #   color = ifelse(dados$horas %in% rotulos_destacados, "red", "black"),
    #   face = ifelse(dados$horas %in% rotulos_destacados, "bold", "normal")
    # ),
  )











