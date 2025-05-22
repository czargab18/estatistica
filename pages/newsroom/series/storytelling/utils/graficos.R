library(ggplot2)

# View(mtcars)

str(mtcars)

# link : https://www.nexojornal.com.br/grafico/2023/11/13/Absten%C3%A7%C3%A3o-do-Enem-2023-fica-pr%C3%B3xima-ao-percentual-de-2022
ggplot(
  data = mtcars,
) +
  geom_line(aes(x = mpg, y = disp), linewith = 1, color = "#0287FF") +
  geom_point(aes(x = mpg, y = disp), shape = 20, size = 4.5, color = "#FFFFFF") +
  geom_point(aes(x = mpg, y = disp), shape = 19, size = 1.5, color = "#0287FF") +
  theme_minimal()




# EXEMPLO Gráfico com HTML ----
library(ggplot2)
library(ggtext)

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  scale_color_manual(
    name = NULL,
    values = c(setosa = "#0072B2", virginica = "#009E73", versicolor = "#D55E00"),
    labels = c(
      setosa = "<i style='color:#0072B2'>I. setosa</i>",
      virginica = "<i style='color:#009E73'>I. virginica</i>",
      versicolor = "<i style='color:#D55E00'>I. versicolor</i>"
    )
  ) +
  labs(
    title = "**Fisher's *Iris* dataset**
    <span style='font-size:11pt'>Sepal width vs. sepal length for three *Iris*
    species</span>",
    x = "Sepal length (cm)", y = "Sepal width (cm)",
    caption = "<b>Source</b>: *Fisher's Iris dataset*"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_markdown(lineheight = 1.1),
    legend.text = element_markdown(size = 11),
    plot.caption = element_markdown(size = 11)
  )




# gráfico BARRAS ----
dados <- data.frame(
  Categoria = c("A", "B", "C", "D"),
  Valor = c(30, 50, 20, 40)
)


ggplot(dados, aes(x = Categoria, y = Valor, fill = Categoria)) +
  geom_bar(stat = "identity") +
  guides(fill = FALSE) + # Remove a legenda
  scale_fill_manual(
    values = c(
      "A" = "#87CEFA",
      "B" = "#87CEFA",
      "C" = "#87CEFA",
      "D" = "#000080"
    )
  ) +
  theme_minimal()



# COLUNAS - cores Diferentes ----
dados <- data.frame(
  Variavel = rep(c("A", "B", "C", "D"), each = 2),
  Estado = rep(c("Antes", "Depois"), times = 4),
  Valor = c(30, 40, 50, 60, 20, 25, 40, 50)
)

cores <- c(
  "Antes_A" = "#2A6D98", "Depois_A" = "#45B5FD",
  "Antes_B" = "#2A6D98", "Depois_B" = "#45B5FD",
  "Antes_C" = "#2A6D98", "Depois_C" = "#45B5FD",
  "Antes_D" = "#1C4966", "Depois_D" = "#0000A0"
)
library(ggplot2)
ggplot(dados, aes(x = Variavel, y = Valor, fill = paste0(Estado, "_", Variavel))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Gráfico Antes e Depois para Cada Variável", x = "Variável", y = "Valor") +
  scale_fill_manual(values = cores, guide = "none") +
  tema_nexo()




# THEME NEXOS ----
#' Tema inspirado nos graficos do Nexo Jornal
#'
#'
#' @inheritParams ggplot2::theme_grey
#' @family themes nexo
#' @export
#' @importFrom grid unit
#' @note
#'  Fontes originais
#'
#'  Titulo e subtitulo: Sentinel
#'
#'  Grafico: Gotham Rounded
tema_nexo <- function(base_size = 12, base_family = "sans") {
  (tema_base(base_size = base_size, base_family = base_family)
  + theme( # plot.margin = margin(t = 18, r = 20, b = 6, l = 20),
      plot.background = element_rect(fill = "#eeeeee", color = NA),
      panel.background = element_rect(fill = NA, color = NA),
      plot.title = element_text(size = rel(2)),
      plot.subtitle = element_text(
        color = "#7d7d7d",
        margin = margin(0, 0, 20, 0)
      ),
      plot.title.position = "plot",
      plot.caption = element_text(hjust = 0),
      plot.caption.position = "plot",
      axis.line.x = element_line(size = 1.2),
      axis.line.y = element_blank(),
      axis.text.x = element_text(
        color = "#263238",
        face = "bold",
        size = rel(1.2)
      ),
      axis.text.y = element_text(
        color = "#656565",
        size = rel(1.2)
      ),
      axis.title = element_blank(),
      axis.ticks.x = element_line(color = "#1b1b19", size = 0.8),
      axis.ticks.length.x = unit(5, "pt"),
      axis.ticks.y = element_blank(),
      panel.grid = element_line(
        color = "#b8b8b8", size = 0.1,
        linetype = "dashed"
      ),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank()
    ))
}

#' Tema base
#'
#' This theme is designed to be a foundation from which to build new
#' themes, and not meant to be used directly. \code{theme_foundation()}
#' is a complete theme with only minimal number of elements defined.
#' It is easier to create new themes by extending this one rather
#' than \code{\link[ggplot2]{theme_gray}()} or \code{\link[ggplot2]{theme_bw}()},
#' because those themes define elements deep in the hierarchy.
#'
#' This theme takes \code{\link[ggplot2]{theme_gray}()} and sets all
#' \code{colour} and \code{fill} values to \code{NULL}, except for the top-level
#' elements (\code{line}, \code{rect}, and \code{title}), which have
#' \code{colour = "black"}, and \code{fill = "white"}. This leaves the spacing
#' and-non colour defaults of the default \pkg{ggplot2} themes in place.
#'
#' @inheritParams ggplot2::theme_grey
#'
#' @family themes
#' @export
#' @importFrom ggplot2 theme_grey
tema_base <- function(base_size = 12, base_family = "") {
  thm <- theme_grey(base_size = base_size, base_family = base_family)
  for (i in names(thm)) {
    if ("colour" %in% names(thm[[i]])) {
      thm[[i]]["color"] <- list(NULL)
    }
    if ("fill" %in% names(thm[[i]])) {
      thm[[i]]["fill"] <- list(NULL)
    }
  }
  thm + theme(
    panel.border = element_rect(fill = NA),
    legend.background = element_rect(color = NA),
    line = element_line(color = "black"),
    rect = element_rect(fill = "white", color = NA),
    text = element_text(color = "black")
  )
}


# Gráfico tracejado ----
set.seed(35)
df <- data.frame(
  Class = factor(rep(c(1, 2), times = 80), labels = c("Math", "Science")),
  StudyTime = factor(sort(sample(1:4, 16, prob = c(0.25, 0.3, 0.3, 0.15), replace = TRUE)), labels = c("<5", "5-10", "10-20", ">20")),
  Nerd = factor(sapply(rep(c(0.1, 0.3, 0.5, 0.8), c(30, 50, 50, 30)), function(x) sample(c("Nerd", "NotNerd"), size = 1, prob = c(x, 1 - x))), levels = c("NotNerd", "Nerd"))
)

library(ggplot2)
# remotes::install_github("coolbutuseless/ggpattern")
library(ggpattern)
ggplot(data = df, aes(x = Class, fill = StudyTime)) +
  geom_bar_pattern(
    position = position_dodge(preserve = "single"),
    color = "#fffffff4",
    pattern_fill = "#ffffff",
    pattern_angle = 0,
    # pattern_density = 0.1,
    pattern_spacing = 0.075,
    pattern_key_scale_factor = 0.6
  ) +
  scale_fill_brewer(palette = "Set1", guide = guide_legend(title = "Study Time")) +
  scale_color_brewer(palette = "Set1", guide = guide_legend(title = "Study Time"))



# Listas nas barras ----

set.seed(35)
df <- data.frame(
  Class = factor(rep(c(1, 2), times = 80), labels = c("Math", "Science")),
  StudyTime = factor(sort(sample(1:4, 16, prob = c(0.25, 0.3, 0.3, 0.15), replace = TRUE)), labels = c("<5", "5-10", "10-20", ">20")),
  Nerd = factor(sapply(rep(c(0.1, 0.3, 0.5, 0.8), c(30, 50, 50, 30)), function(x) sample(c("Nerd", "NotNerd"), size = 1, prob = c(x, 1 - x))), levels = c("NotNerd", "Nerd"))
)

library(ggplot2)
# remotes::install_github("coolbutuseless/ggpattern")
library(ggpattern)
ggplot(data = df, aes(x = Class, fill = StudyTime)) +
  geom_bar_pattern(
    position = position_dodge(preserve = "single"),
    color = "#fffffff4",
    pattern_fill = "#ffffff",
    pattern_angle = 0,
    # pattern_density = 0.1,
    pattern_spacing = 0.075,
    pattern_key_scale_factor = 0.6
  )


  scale_fill_brewer(palette = "Set1", guide = guide_legend(title = "Study Time")) +
  scale_color_brewer(palette = "Set1", guide = guide_legend(title = "Study Time"))
