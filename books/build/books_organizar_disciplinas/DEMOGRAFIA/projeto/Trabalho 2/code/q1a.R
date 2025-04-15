"Aberto: terça-feira, 4 abr. 2023, 22:10"
"Vencimento: segunda-feira, 10 jul. 2023, 23:59"

# Parte 1 - Estrutura Populacional e avaliação da informação sobre idade

library(tidyverse)
library(ggplot2)
library(scales)

rm(ordemetaria)
# NECESSÁRIO ----
options(scipen = 99999)

ordemetaria <-
  c(
    "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
    "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
    "70-74", "75-79", "80+"
  )
# data.Need.Q1 ----

# a) Construa as pirâmides etárias por grupos de idade para a população da UF
#    escolhida em 1991, 2000, 2010, 2015, 2020 e 2030 (obtenha os dados no portal
#    do DATASUS para os anos censitários e projeções para os demais anos).
#    Comente os resultados à luz da discussão sobre transição demográfica.

# anosCensitários DATASUS ----
"anos cesitários :  1991, 2000, 2010 ||| projetar: 2020 e 2030"
# graficos PirEtar - 1991 ----

pop1991 <-
  pop1991 |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "0-1" ~ "0-4",
      fxetaria %in% "1-4" ~ "0-4",
      TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria),
  ) |>
  dplyr::filter(!fxetaria %in% "9") |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::mutate(
    porcentagem = ((populacao / sum(populacao)) * 100)
  ) |>
  dplyr::arrange(sexo)

pop1991

"GRAFICO 1991"

Plotpop1991 <-
  ggplot(
    data = pop1991,
    aes(x = fxetaria, group = sexo, color = sexo)
  ) +
  geom_line(
    data = dplyr::filter(pop1991, sexo %in% c(1,"1")),
    aes(y = -porcentagem),
    position = position_dodge(width = 0.8),
    linewidth = 1.5,
  ) +
  geom_line(
    data = dplyr::filter(pop1991, sexo %in% c(2,"2")),
    aes(y = porcentagem),
    position = position_dodge(width = 0.8),
    linewidth = 1.5,
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = function(x) paste(abs(x), "%"),
    limits = c(-12, 12),
    breaks = seq(-12, 12, 2)
  ) +
  theme_minimal() +
  # ROTULOS (1 == HOMEM &&& 2 == MULHER)
  scale_color_manual(
    values = c("#f95d06","#343496"),
    aesthetics = "color",
    labels = c("Homens", "Mulheres")
  ) +
  geom_hline(yintercept = 0, color = "#6f5d5d", linewidth = .5, linetype = "solid") +
  theme(
    # panel.background = element_rect(color = "#f5f5f7", fill = "#f5f5f7"),
    plot.title = element_text(size = 20, face = "bold"),
    panel.grid.major.x = element_line(linewidth = 0.7, color = "#e5dfdf"),
    panel.grid.major.y = element_line(linewidth = 0.5),
    axis.text.x = element_text(size = 14, face = "plain"),
    axis.text.y = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 16, face = "bold"),
    axis.title.y = element_text(size = 16, face = "bold"),
    legend.title = element_blank(),
    legend.text = element_text(size = 16),
    legend.position = "bottom",
    plot.caption = element_text(size = 12, hjust = 0),
    plot.margin = margin(t = 10, r = 20, b = 20, l = 10),
    # aspect.ratio = (max(as.numeric(idadeSimples)) / 100 * max(Poecendeclarada))
  ) +
  labs(
    x = "Grupos Etários",
    y = "Proporção da população",
    # color = "Sexo",
    title = "Pirâmide Etária de 1991, Goiás",
    caption = "Fonte: DATASUS, 1991"
  )

Plotpop1991
# .Export Plot
ggsave(
  filename = "Plotpop1991.png",
  plot = Plotpop1991,
  path = "Trabalho 2/result/figuras/",
  scale = 1,
  dpi = 300,
  limitsize = TRUE,
  bg = "#f5f5f7"
)



# graficos PirEtar - 2000 ----

"GRAFICO 2000"

pop2000 <-
  pop2000 |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "0-1" ~ "0-4",
      fxetaria %in% "1-4" ~ "0-4",
      TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::filter(!fxetaria %in% "9") |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::mutate(
    porcentagem = (populacao / sum(populacao)) * 100
  ) |>
  dplyr::arrange(sexo)

pop2000

Plotpop2000 <-
  ggplot(
    data = pop2000,
    aes(x = fxetaria, group = sexo, color = sexo)
  ) +
  geom_line(
    data = dplyr::filter(pop2000, sexo == "1"),
    aes(y = -porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  geom_line(
    data = dplyr::filter(pop2000, sexo == "2"),
    aes(y = porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = function(x) paste(abs(x), "%"),
    limits = c(-12, 12),
    breaks = seq(-12, 12, 2)
  ) +
  theme_minimal() +
  # ROTULOS (1 == HOMEM &&& 2 == MULHER)
  scale_color_manual(
    values = c("#f95d06", "#343496"),
    aesthetics = "color",
    labels = c("Homens", "Mulheres")
  ) +
  geom_hline(yintercept = 0, color = "#6f5d5d", size = .5, linetype = "solid") +
  # girar gráfico
  ggplot2::coord_flip() +
  theme_minimal() +
  theme(
    # panel.background = element_rect(color = "#f5f5f7", fill = "#f5f5f7"),
    plot.title = element_text(size = 20, face = "bold"),
    panel.grid.major.x = element_line(linewidth = 0.7, color = "#e5dfdf"),
    panel.grid.major.y = element_line(linewidth = 0.5),
    axis.text.x = element_text(size = 14, face = "plain"),
    axis.text.y = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 16, face = "bold"),
    axis.title.y = element_text(size = 16, face = "bold"),
    legend.title = element_blank(),
    legend.text = element_text(size = 16),
    legend.position = "bottom",
    plot.caption = element_text(size = 12, hjust = 0),
    plot.margin = margin(t = 10, r = 20, b = 20, l = 10)
  ) +
  labs(
    x = "Grupos Etários",   
    y = "Proporção da população",
    # fill = "Sexo",
    title = "Pirâmide Etária de 2000, Goiás",
    caption = "Fonte: DATASUS, 2000"
  )

Plotpop2000

# .Export Plot
ggsave(
  filename = "Plotpop2000.png",
  plot = Plotpop2000,
  path = "Trabalho 2/result/figuras/",
  scale = 1,
  dpi = 300,
  limitsize = TRUE,
  bg = "#f5f5f7"
)

# graficos PirEtar - 2010 ----


"GRAFICO 2010"

pop2010 <-
  pop2010 |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "0-1" ~ "0-4",
      fxetaria %in% "1-4" ~ "0-4",
      TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria),
    populacao = as.double(populacao)
  ) |>
  dplyr::filter(!fxetaria %in% "9") |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::mutate(
    porcentagem = ((populacao / sum(populacao)) * 100)
  ) |>
  dplyr::arrange(sexo)

pop2010

"GRAFICO 2010"

Plotpop2010 <-
  ggplot(
    data = pop2010,
    aes(x = fxetaria, group = sexo, color = sexo)
  ) +
  geom_line(
    data = dplyr::filter(pop2010, sexo == "1"),
    aes(y = -porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  geom_line(
    data = dplyr::filter(pop2010, sexo == "2"),
    aes(y = porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = function(x) paste(abs(x), "%"),
    limits = c(-12, 12),
    breaks = seq(-12, 12, 2)
  ) +
  theme_minimal() +
  # ROTULOS (1 == HOMEM &&& 2 == MULHER)
  scale_color_manual(
    values = c("#f95d06", "#343496"),
    aesthetics = "color",
    labels = c("Homens", "Mulheres")
  ) +
  geom_hline(yintercept = 0, color = "#6f5d5d", size = .5, linetype = "solid") +
  # girar gráfico
  ggplot2::coord_flip() +
  theme_minimal() +
  theme(
    # panel.background = element_rect(color = "#f5f5f7", fill = "#f5f5f7"),
    plot.title = element_text(size = 20, face = "bold"),
    panel.grid.major.x = element_line(linewidth = 0.7, color = "#e5dfdf"),
    panel.grid.major.y = element_line(linewidth = 0.5),
    axis.text.x = element_text(size = 14, face = "plain"),
    axis.text.y = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 16, face = "bold"),
    axis.title.y = element_text(size = 16, face = "bold"),
    legend.title = element_blank(),
    legend.text = element_text(size = 16),
    legend.position = "bottom",
    plot.caption = element_text(size = 12, hjust = 0),
    plot.margin = margin(t = 10, r = 20, b = 20, l = 10)
  ) +
  labs(
    x = "Grupos Etários",
    y = "Proporção da população",
    # fill = "Sexo",
    title = "Pirâmide Etária de 2010, Goiás",
    caption = "Fonte: DATASUS, 2010"
  )

Plotpop2010

# .Export Plot
ggsave(
  filename = "Plotpop2010.png",
  plot = Plotpop2010,
  path = "Trabalho 2/result/figuras/",
  scale = 1,
  dpi = 300,
  limitsize = TRUE,
  bg = "#f5f5f7"
)



# .projeções IBGE ----

# 2015.projecao ----
popIBGE2015 <-
  popIBGE2015 |>
  dplyr::mutate(
    porcentagem = (populacao / sum(populacao)) * 100
  )

popIBGE2015
#  GRÁFICO

Plotpop2015IBGE <-
  ggplot(
    data = popIBGE2015,
    aes(x = fxetaria, group = sexo, color = sexo)
  ) +
  geom_line(
    data = dplyr::filter(popIBGE2015, sexo == "M"),
    aes(y = porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  geom_line(
    data = dplyr::filter(popIBGE2015, sexo == "F"),
    aes(y = -porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  scale_y_continuous(
#    labels = function(x) paste(abs(x), "%"),
#    limits = c(-10, 10),
#    breaks = seq(-10, 10, 2)
    labels = function(x) paste(abs(x), "%"),
    limits = c(-12, 12),
    breaks = seq(-12, 12, 2)
    
  ) +
  theme_minimal() +

  # ROTULOS (1 == HOMEM &&& 2 == MULHER)
  scale_color_manual(
    values = c("#f95d06", "#343496"),
    aesthetics = "color",
    labels = c("Homens", "Mulheres")
  ) +
  coord_flip() +
  geom_hline(yintercept = 0, color = "#6f5d5d", size = .5, linetype = "solid") +
  # girar gráfico
  theme(
    # panel.background = element_rect(color = "#f5f5f7", fill = "#f5f5f7"),
    plot.title = element_text(size = 20, face = "bold"),
    panel.grid.major.x = element_line(linewidth = 0.7, color = "#e5dfdf"),
    panel.grid.major.y = element_line(linewidth = 0.5),
    axis.text.x = element_text(size = 14, face = "plain"),
    axis.text.y = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 16, face = "bold"),
    axis.title.y = element_text(size = 16, face = "bold"),
    legend.title = element_blank(),
    legend.text = element_text(size = 16),
    legend.position = "bottom",
    plot.caption = element_text(size = 12, hjust = 0),
    plot.margin = margin(t = 10, r = 20, b = 20, l = 10)
  ) +
  labs(
    x = "Grupos Etários",
    y = "Proporção da população",
    fill = "Sexo",
    title = "Pirâmide Etária de 2015, Goiás",
    caption = "Fonte: Projeção IBGE, 2015"
  )

Plotpop2015IBGE

# .Export Plot
ggsave(
  filename = "PlotpopIBGE2015.png",
  plot = Plotpop2015IBGE,
  path = "Trabalho 2/result/figuras/",
  scale = 1,
  dpi = 300,
  limitsize = TRUE,
  bg = "#f5f5f7"
)

# 2020.projecao ----
popIBGE2020 <-
  popIBGE2020 |>
  dplyr::mutate(
    porcentagem = (populacao / sum(populacao)) * 100
  )

popIBGE2020
#  GRÁFICO

Plotpop2020IBGE <-
  ggplot(
    data = popIBGE2020,
    aes(x = fxetaria, group = sexo, color = sexo)
  ) +
  geom_line(
    data = dplyr::filter(popIBGE2020, sexo == "M"),
    aes(y = porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  geom_line(
    data = dplyr::filter(popIBGE2020, sexo == "F"),
    aes(y = -porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  coord_flip() +
  scale_y_continuous(
#    labels = function(x) paste(abs(x), "%"),
#    limits = c(-10, 10),
#    breaks = seq(-10, 10, 2)
    labels = function(x) paste(abs(x), "%"),
    limits = c(-12, 12),
    breaks = seq(-12, 12, 2)
  ) +
  theme_minimal() +
  # ROTULOS (1 == HOMEM &&& 2 == MULHER)
  scale_color_manual(
    values = c("#f95d06", "#343496"),
    aesthetics = "color",
    labels = c("Homens", "Mulheres")
  ) +
  geom_hline(yintercept = 0, color = "#6f5d5d", size = .5, linetype = "solid") +
  # girar gráfico
  ggplot2::coord_flip() +
  theme_minimal() +
  theme(
    # panel.background = element_rect(color = "#f5f5f7", fill = "#f5f5f7"),
    plot.title = element_text(size = 20, face = "bold"),
    panel.grid.major.x = element_line(linewidth = 0.7, color = "#e5dfdf"),
    panel.grid.major.y = element_line(linewidth = 0.5),
    axis.text.x = element_text(size = 14, face = "plain"),
    axis.text.y = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 16, face = "bold"),
    axis.title.y = element_text(size = 16, face = "bold"),
    legend.title = element_blank(),
    legend.text = element_text(size = 16),
    legend.position = "bottom",
    plot.caption = element_text(size = 12, hjust = 0),
    plot.margin = margin(t = 10, r = 20, b = 20, l = 10)
  ) +
  labs(
    x = "Grupos Etários",
    y = "Proporção da população",
    fill = "Sexo",
    title = "Pirâmide Etária de 2020, Goiás",
    caption = "Fonte: Projeção IBGE, 2020"
  )


Plotpop2020IBGE
# .Export Plot
ggsave(
  filename = "PlotpopIBGE2020.png",
  plot = Plotpop2020IBGE,
  path = "Trabalho 2/result/figuras/",
  scale = 1,
  dpi = 300,
  limitsize = TRUE,
  bg = "#f5f5f7"
)

# 2030.projecao ----
popIBGE2030 <-
  popIBGE2030 |>
  dplyr::mutate(
    porcentagem = (populacao / sum(populacao)) * 100
  )
#  GRÁFICO

Plotpop2030IBGE <-
  ggplot(
    data = popIBGE2030,
    aes(x = fxetaria, group = sexo, color = sexo)
  ) +
  geom_line(
    data = dplyr::filter(popIBGE2030, sexo == "M"),
    aes(y = porcentagem),
    position = position_dodge(width = 0.8),
    linewidth = 1.5,
  ) +
  geom_line(
    data = dplyr::filter(popIBGE2030, sexo == "F"),
    aes(y = -porcentagem),
    position = position_dodge(width = 0.8),
    linewidth = 1.5,
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = function(x) paste(abs(x), "%"),
    limits = c(-12, 12),
    breaks = seq(-12, 12, 2)
  ) +
  theme_minimal() +
  # ROTULOS (1 == HOMEM &&& 2 == MULHER)
  scale_color_manual(
    values = c("#f95d06", "#343496"),
    aesthetics = "color",
    labels = c("Homens", "Mulheres")
  ) +
  geom_hline(yintercept = 0, color = "#6f5d5d", size = .5, linetype = "solid") +

  theme(
    # panel.background = element_rect(color = "#f5f5f7", fill = "#f5f5f7"),
    plot.title = element_text(size = 20, face = "bold"),
    panel.grid.major.x = element_line(linewidth = 0.7, color = "#e5dfdf"),
    panel.grid.major.y = element_line(linewidth = 0.5),
    axis.text.x = element_text(size = 14, face = "plain"),
    axis.text.y = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 16, face = "bold"),
    axis.title.y = element_text(size = 16, face = "bold"),
    legend.title = element_blank(),
    legend.text = element_text(size = 16),
    legend.position = "bottom",
    plot.caption = element_text(size = 12, hjust = 0),
    plot.margin = margin(t = 10, r = 20, b = 20, l = 10)
  ) +
  labs(
    x = "Grupos Etários",
    y = "Proporção da população",
    # fill = "Sexo",
    title = "Pirâmide Etária de 2030, Goiás",
    caption = "Fonte: Projeção IBGE, 2030"
  )

Plotpop2030IBGE
# .Export Plot
ggsave(
  filename = "PlotpopIBGE2030.png",
  plot = Plotpop2030IBGE,
  path = "Trabalho 2/result/figuras/",
  scale = 1,
  dpi = 300,
  limitsize = TRUE,
  bg = "#f5f5f7"
)


# Comente os resultados à luz da discussão
# sobre transição demográfica.


Plotpop1991
Plotpop2000
Plotpop2010

Plotpop2015IBGE
Plotpop2020IBGE
Plotpop2030IBGE