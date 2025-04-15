# c) Avalie a qualidade da declaração de idade no Censo 2010 segundo forma de
#    declaração (data de nascimento e idade presumida). Calcule os índices de
#    Whipple, Myers e Bachi. Construa a pirâmide por idade simples. Comente os
#    resultados. (utilize a planilha SINGAGE do PAS - disponível na plataforma)

# Obtenha os dados na Tabela 3.2.1.2 do Censo 2010 - Resultados do Universo
# (https://www.ibge.gov.br/estatisticas/sociais/populacao/9662-censo-demografico-2010.html?edicao=10503&t=downloads)



# o que fazer ?  Avsliar :

# - data de nascimento (índices de Whipple, Myers e Bachi)

# - idade presumida (índices de Whipple, Myers e Bachi)



# ===========================  ===========================

# - Construa a pirâmide por idade simples


# =========================== ler .ods ===========================

if (!require(readODS)) {
    install.packages("readODS", repos = "https://ropensci.r-universe.dev")
} else {
    library(readODS)
}

popcenso2010 <-
    readODS::read_ods(
        path = "Trabalho 2/Planilhas/Tabela 3.26.1.2.ods",
        range = "B9:O111",
    ) |>
    dplyr::select(col = c(1, 3, 4, 13, 14)) |>
    dplyr::rename(
        "idadeSimples" = "col1",
        "homemDataNascim" = "col2",
        "mulherDataNascim" = "col3",
        "homemDeclarada" = "col4",
        "mulherDeclarada" = "col5",
    ) |>
    dplyr::mutate(
        idadeSimples = dplyr::case_when(
            idadeSimples %in% "Menos de 1 ano" ~ "0 ano",
            idadeSimples %in% "100 anos ou mais" ~ "100",
            TRUE ~ idadeSimples
        ),
        idadeSimples = stringr::str_remove_all(idadeSimples, pattern = " ano|[s]"),
        homemDeclarada = as.numeric(homemDeclarada),
        mulherDeclarada = as.numeric(mulherDeclarada),
        homemDataNascim = as.numeric(homemDataNascim),
        mulherDataNascim = as.numeric(mulherDataNascim),
    )


# --------------------------------------------------------- popDeclar ---------------------------------------------------------

popDeclar <-
    popcenso2010 |>
    dplyr::select(-c(homemDataNascim, mulherDataNascim)) |>
    tidyr::pivot_longer(
        cols = c(homemDeclarada, mulherDeclarada),
        names_to = "sexoDeclar",
        values_to = "popDeclar"
    ) |>
    dplyr::mutate(
        sexoDeclar = dplyr::case_when(
            sexoDeclar %in% "homemDeclarada" ~ "homem",
            sexoDeclar %in% "mulherDeclarada" ~ "mulher",
            TRUE ~ sexoDeclar
        ),
        Porcendeclarada = popDeclar / sum(popDeclar),
        idadeSimples = factor(forcats::as_factor(idadeSimples), levels = as.factor(seq(0, 100))),
    ) |>
    dplyr::filter(!idadeSimples %in% c("Total", NA, "NA"))

popDeclar

# --------------------------------------------------------- popDtNascim ---------------------------------------------------------

popDtNascim <-
    popcenso2010 |>
    dplyr::select(c(idadeSimples, homemDataNascim, mulherDataNascim)) |>
    tidyr::pivot_longer(
        cols = c(homemDataNascim, mulherDataNascim),
        names_to = "sexoDTNasc",
        values_to = "popDTNasc"
    ) |>
    dplyr::mutate(
        sexoDTNasc = dplyr::case_when(
            sexoDTNasc %in% "homemDataNascim" ~ "homem",
            sexoDTNasc %in% "mulherDataNascim" ~ "mulher",
            TRUE ~ sexoDTNasc
        ),
        PorcenderDtNasc = popDTNasc / sum(popDTNasc),
        idadeSimples = factor(forcats::as_factor(idadeSimples), levels = as.factor(seq(0, 100))),
    ) |>
    dplyr::filter(!idadeSimples %in% c("Total", NA, "NA"))


# =========================================================== GRÁFICO ===========================================================
popDeclar
popDtNascim

library(ggplot2)

PlotpopDeclar <-
    ggplot(
        data = popDeclar,
        aes(x = idadeSimples, group = sexoDeclar, color = sexoDeclar)
    ) +
    geom_line(
    data =  dplyr::filter(popDeclar, sexoDeclar %in% "homem"),
     aes(y = Porcendeclarada),
    position = position_dodge(width = 0.8),
    linewidth = 1.2,
  ) +
    geom_line(
    data =  dplyr::filter(popDeclar, sexoDeclar %in% "mulher"),
     aes(y = -Porcendeclarada),
    position = position_dodge(width = 0.8),
    linewidth = 1.2,
  ) +
    ggplot2::coord_flip() +
    scale_color_manual(
        values = c("#f95d06", "#343496"),
        aesthetics = "color",
        labels = c("Homens", "Mulheres")
    )    +
    scale_x_discrete(
        breaks = seq(0, 100, 5)
    ) +
    scale_y_continuous(
        labels = function(x) paste(abs(x), "%")
    ) +
    theme_minimal() +
    # ROTULOS (1 == HOMEM &&& 2 == MULHER)
    theme(
        plot.title = element_text(size = 16, face = "bold"),
        panel.grid.major.x = element_line(linewidth = 0.7, color = "#e5dfdf"),
        panel.grid.major.y = element_line(linewidth = 0),
        axis.text.x = element_text(size = 14, face = "plain"),
        axis.text.y = element_text(size = 14, face = "plain"),
        axis.title.x = element_text(size = 14, face = "bold"),
        axis.title.y = element_text(size = 14, face = "bold"),
        legend.title = element_blank(),
        legend.text = element_text(size = 16),
        legend.position = "bottom",
        plot.caption = element_text(size = 12, hjust = 0),
        # plot.margin = margin(t = 10, r = 20, b = 10, l = 10),
        # plot.background = element_rect(fill = "green")
    ) +
    labs(
        x = "Idade Simples",
        y = "Proporção da população",
        # color = "Sexo",
        title = "IDADE DECLARADA",
        caption = "Fonte: DATASUS, 2010"
    )


PlotpopDeclar

# .Export Plot
ggsave(
    filename = "PlotpopDeclar.png",
    plot = PlotpopDeclar,
    path = "Trabalho 2/result/figuras/",
    scale = 1.5,
    dpi = 300,
    limitsize = TRUE,
    bg = "#f5f5f7",
    #   units = "cm",
)


# =========================================================== Gráfico ===========================================================

# - Comente os resultados.

PlotpopDtNascim <-
    # gráfico
    ggplot(
        data = popDtNascim,
        aes(x = idadeSimples, group = sexoDTNasc, color = sexoDTNasc)
    ) +
    geom_line(
    data =  dplyr::filter(popDtNascim, sexoDTNasc %in% "homem"),
     aes(y = PorcenderDtNasc),
    position = position_dodge(width = 0.8),
    linewidth = 1.2,
  ) +
    geom_line(
    data =  dplyr::filter(popDtNascim, sexoDTNasc %in% "mulher"),
     aes(y = -PorcenderDtNasc),
    position = position_dodge(width = 0.8),
    linewidth = 1.2,
  ) +
    ggplot2::coord_flip() +
    scale_x_discrete(
        breaks = seq(0, 100, 5)
    ) +
    scale_y_continuous(
        labels = function(x) paste(abs(x) * 100, "%")
    ) +
    theme_minimal() +
    # ROTULOS (1 == HOMEM &&& 2 == MULHER)
    scale_color_manual(
        values = c("#f95d06", "#343496"),
        aesthetics = "color",
        labels = c("Homens", "Mulheres")
    ) +
    theme(
        plot.title = element_text(size = 16, face = "bold"),
        panel.grid.major.x = element_line(linewidth = 0.7, color = "#e5dfdf"),
        panel.grid.major.y = element_line(linewidth = 0),
        axis.text.x = element_text(size = 14, face = "plain"),
        axis.text.y = element_text(size = 14, face = "plain"),
        axis.title.x = element_text(size = 14, face = "bold"),
        axis.title.y = element_text(size = 14, face = "bold"),
        legend.title = element_blank(),
        legend.text = element_text(size = 16),
        legend.position = "bottom",
        plot.caption = element_text(size = 12, hjust = 0),
        # plot.margin = margin(t = 10, r = 20, b = 10, l = 10),
        # plot.background = element_rect(fill = "green")
    ) +
    labs(
        x = "Idade Simples",
        y = "Proporção da Populaçã",
        # color = "Sexo",
        title = "DATA NASCIMENTO",
        caption = "Fonte: DATASUS, 2010"
    )

PlotpopDtNascim
# .Export Plot
ggsave(
    filename = "PlotpopDtNascim.png",
    plot = PlotpopDtNascim,
    path = "Trabalho 2/result/figuras/",
    scale = 1.5,
    dpi = 300,
    limitsize = TRUE,
    bg = "#f5f5f7",
    #   units = "cm",
)