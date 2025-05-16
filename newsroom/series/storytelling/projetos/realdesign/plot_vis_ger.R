library(ggtext)
library(extrafont)
library(ggplot2)
# Painel - visão geral ----

panel_vis_ger <-
   readr::read_csv(
      file = "data/realdesign/Visão geral personalizada.csv",
      skip = 2,
   ) |>
   dplyr::select(
      -"Código da moeda"
   )

# tibble::view(panel_vis_ger)

# gráfico ----

d <-
   ggplot2::ggplot(
      data = panel_vis_ger,
      ggplot2::aes(x = Dia)
   ) +
   ggplot2::geom_line(
      ggplot2::aes(y = `Impr.`, color = "Impressões"),
      linewidth = 1.2,
   ) +
   ggplot2::geom_line(
      ggplot2::aes(y = `Interações`, color = "Interações"),
      linewidth = 1.2,
   ) +
   ggplot2::scale_y_continuous(
      breaks = seq(0, max(panel_vis_ger$`Impr.`), 50),
      expand = c(0, 0),
   ) +
   ggplot2::annotate(
      "text",
      x = min(panel_vis_ger$Dia),
      # y = seq(0, max(panel_vis_ger$`Impr.`), 50),
      y = seq(0, 250, 50),
      label = c("0", "50", "100", "150", "200", "250"),
      vjust = -.5,
      hjust = 0
   ) +
   ggplot2::scale_color_manual(
      values = c("Impressões" = "#ff8e01", "Interações" = "#1c88e3")
   ) +
   ggplot2::scale_x_date(expand = c(0, 0)) +
   ggplot2::labs(
      title = "Análise de desempenho dos <br> anúncios do Google Ads de 2024",
      caption = "Comparação de
    <span style='color: black;'>
    <b>Impressões</b></span>e
    <span style='color: black;'>
    <b>Interações</b></span><br>de 14 de abril a 13 de maio."
   ) +
   ggplot2::theme(
      rect = element_rect(fill = "#ffffff"),
      text = element_text(family = "SF Compact"),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_line(color = "black", linewidth = 1, lineend = "round"),
      axis.title.y = element_blank(),
      axis.title.x = element_blank(),
      axis.text.y = element_blank(),
      axis.text.x = element_text(color = "#000029", size = 8, face = "bold"),
      axis.line.x.bottom = element_line(color = "black", linewidth = 1, lineend = "round"),
      legend.position = "top",
      legend.title = element_blank(),
      legend.text = element_markdown(),
      legend.key = element_blank(),
      legend.justification.top = "left",
      legend.margin = margin(t = 0, r = 2, b = -40, l = 2),
      panel.background = element_rect("#ffffff"),
      panel.grid = element_blank(),
      panel.grid.major.y = element_line(colour = "#000009", linetype = 2),
      plot.title = element_markdown(size = 10), # pacote ggtext - usar html em ggplot2
      plot.subtitle = element_markdown(size = 7), # pacote ggtext - usar html em ggplot2
      plot.caption = element_markdown(),
      # plot.margin = margin(t = 0, r = 0.5, b = 0, l = 0.5, unit = "cm"),
      plot.margin = margin(t = 0.6, r = 0.5, b = 0.6, l = 0.5, unit = "cm"),
   )


# save ----
d |>
   ggplot2::ggsave(
      filename = "plot_vis_ger_impr_click.png",
      device = "png",
      path = "graficos/construindo/realdesign",
      width = 1080,
      height = 1350,
      units = "px"
   )
