"Aberto: terça-feira, 4 abr. 2023, 22:10"
"Vencimento: segunda-feira, 10 jul. 2023, 23:59"

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

# Parte 1 - Estrutura Populacional e avaliação da informação sobre idade

# data.Need.Q1 ----

# a) Construa as pirâmides etárias por grupos de idade para a população da UF
#    escolhida em 1991, 2000, 2010, 2015, 2020 e 2030 (obtenha os dados no portal
#    do Datasus para os anos censitários e projeções para os demais anos).
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

# Plotpop1991 <-
  ggplot2::ggplot(data = pop1991, mapping = aes(x = fxetaria)) +
  ggplot2::geom_bar(
    data = filter(pop1991, sexo == "2"),
    aes(y = populacao, fill = sexo), stat = "identity",  position=position_dodge (1)
  ) +
  ggplot2::geom_bar(
    data = filter(pop1991, sexo == "1"),
    aes(y = -populacao, fill = sexo), stat = "identity", position=position_dodge (1)
  ) +
  #  PORCENTAGEM | DISTRIBUIÇÃO
  geom_text(
    data = filter(pop1991, sexo == "2"),
    aes(y = populacao, label = paste(round(porcentagem, 2), "%")),
    position = position_nudge(y = 30000), size = 5, vjust = 0
  ) +
  geom_text(
    data = filter(pop1991, sexo == "1"),
    aes(y = -populacao, label = paste(round(porcentagem, 2), "%")),
    position = position_nudge(y = -30000), size = 5, vjust = 1
  ) +
  # ROTULOS (1 == HOMEM &&& 2 == MULHER)
  scale_color_manual(
    values = c("#f95d06", "#343496"), aesthetics = "fill",
    labels = c("Homens", "Mulheres")
  ) +
  ggplot2::scale_y_continuous(
    limits = c(-300000, 300000),
    breaks = seq(-300000, 300000, 100000),
    labels = function(x) {
      abs(x) / 1000
    }
  ) +

  # girar gráfico
  coord_flip() +
  theme_minimal() +
  theme(
    panel.grid.major.x = element_line(linewidth = 0.7, color = "gray"),
    panel.grid.major.y = element_line(linewidth = 0.5),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 12),
    legend.position = "bottom"
  ) +
  labs(
    x = "Grupos Etários",
    y = "População (em milhares de pessoas)",
    fill = "Sexo",
    color = "Sexo",
    title = "Pirâmide Etária de 1991, Goiás",
    caption = "Fonte: Datasus, 1991"
  )

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


# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------
# # c ------------------------------------------------------











pop1991 <- pop1991 |> dplyr::mutate(ano = 1991)
pop2000 <- pop2000 |> dplyr::mutate(ano = 2000)
pop2010 <- pop2010 |> dplyr::mutate(ano = 2010)

popIBGE2015 <- popIBGE2015 |> dplyr::mutate(ano = 2015, sexo = dplyr::case_when(sexo %in% "F"~"2",sexo %in%"M"~"1", TRUE~sexo))
popIBGE2020 <- popIBGE2020 |> dplyr::mutate(ano = 2020, sexo = dplyr::case_when(sexo %in% "F"~"2",sexo %in%"M"~"1", TRUE~sexo))
popIBGE2030 <- popIBGE2030 |> dplyr::mutate(ano = 2030, sexo = dplyr::case_when(sexo %in% "F"~"2",sexo %in%"M"~"1", TRUE~sexo))


datasetCompleto <- 
merge(x = pop1991, y = pop2000, by = c("fxetaria", "sexo"))  |> 
# dplyr::select(c("fxetaria","sexo","ano.x","ano.y", "porcentagem.x", "porcentagem.y")) |>
dplyr::select(-c("populacao.x","populacao.y")) |>
tidyr::pivot_longer(
  cols = c("ano.x","ano.y"),
               names_to = "anoRemove",
               values_to = "ano"
  )  |>
  tidyr::pivot_longer(
  cols = c("porcentagem.x","porcentagem.y"),
               names_to = "porcentagemRemove",
               values_to = "porcentagem"
  ) |>
  dplyr::select(-c("anoRemove", "porcentagemRemove"))  |>
  
  # JUNTANDO OUTRO DATASET
  # JUNTANDO OUTRO DATASET
  # JUNTANDO OUTRO DATASET

  merge(y = pop2010, by = c("fxetaria", "sexo")) |>
# dplyr::select(c("fxetaria","sexo","ano.x","ano.y", "porcentagem.x", "porcentagem.y")) |>
dplyr::select(-"populacao")  |>
tidyr::pivot_longer(
  cols = c("ano.x","ano.y"),
               names_to = "anoRemove",
               values_to = "ano"
  )  |>
  tidyr::pivot_longer(
  cols = c("porcentagem.x","porcentagem.y"),
               names_to = "porcentagemRemove",
               values_to = "porcentagem"
  ) |>
  dplyr::select(-c("anoRemove", "porcentagemRemove")) |>

  # JUNTANDO OUTRO DATASET
  # JUNTANDO OUTRO DATASET
  # JUNTANDO OUTRO DATASET

  merge(y = popIBGE2015, by = c("fxetaria", "sexo")) |>
# dplyr::select(c("fxetaria","sexo","ano.x","ano.y", "porcentagem.x", "porcentagem.y")) |>
dplyr::select(-"populacao") |>
tidyr::pivot_longer(
  cols = c("ano.x","ano.y"),
               names_to = "anoRemove",
               values_to = "ano"
  )  |>
  tidyr::pivot_longer(
  cols = c("porcentagem.x","porcentagem.y"),
               names_to = "porcentagemRemove",
               values_to = "porcentagem"
  ) |>
  dplyr::select(-c("anoRemove", "porcentagemRemove")) |>

  # JUNTANDO OUTRO DATASET
  # JUNTANDO OUTRO DATASET
  # JUNTANDO OUTRO DATASET

  merge(y = popIBGE2020, by = c("fxetaria", "sexo")) |>
# dplyr::select(c("fxetaria","sexo","ano.x","ano.y", "porcentagem.x", "porcentagem.y")) |>
dplyr::select(-"populacao") |>
tidyr::pivot_longer(
  cols = c("ano.x","ano.y"),
               names_to = "anoRemove",
               values_to = "ano"
  )  |>
  tidyr::pivot_longer(
  cols = c("porcentagem.x","porcentagem.y"),
               names_to = "porcentagemRemove",
               values_to = "porcentagem"
  ) |>
  dplyr::select(-c("anoRemove", "porcentagemRemove")) |>

  # JUNTANDO OUTRO DATASET
  # JUNTANDO OUTRO DATASET
  # JUNTANDO OUTRO DATASET

  merge(y = popIBGE2030, by = c("fxetaria", "sexo")) |>
# dplyr::select(c("fxetaria","sexo","ano.x","ano.y", "porcentagem.x", "porcentagem.y")) |>
dplyr::select(-"populacao") |>
tidyr::pivot_longer(
  cols = c("ano.x","ano.y"),
               names_to = "anoRemove",
               values_to = "ano"
  )  |>
  tidyr::pivot_longer(
  cols = c("porcentagem.x","porcentagem.y"),
               names_to = "porcentagemRemove",
               values_to = "porcentagem"
  ) |>
  dplyr::select(-c("anoRemove", "porcentagemRemove")) |>
  dplyr::distinct()



datasetCompleto

  ggplot(
    data = datasetCompleto,
    aes(x = fxetaria, color = sexo)
  ) +
  geom_line(
    data = dplyr::filter(datasetCompleto, sexo == "1"),
    aes(y = porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  geom_line(
    data = dplyr::filter(datasetCompleto, sexo == "2"),
    aes(y = -porcentagem),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  coord_flip() +
  facet_wrap(~ano)




  scale_y_continuous(
    labels = function(x) paste(abs(x), "%"),
    limits = c(-12, 12),
    breaks = seq(-10, 10, 2)
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
    y = "Distribuição da população (em milhares de pessoas)",
    fill = "Sexo",
    title = "Pirâmide Etária de 2030, Goiás",
    caption = "Fonte: Projeção IBGE, 2030"
  )




















































  geom_line(
    data = dplyr::filter(popcenso2010, declarada == "homem"),
    aes(y = popDeclarada),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +
  geom_line(
    data = dplyr::filter(popcenso2010, declarada == "mulher"),
    aes(y = -popDeclarada),
    position = position_dodge(width = 0.8),
    size = 1.5,
  ) +