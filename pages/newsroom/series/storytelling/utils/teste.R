# Pesuisando detalhes ----
# Carregue o pacote ggplot2
library(ggplot2)
library(extrafont)
library(ggtext)

# Crie um conjunto de dados de exemplo
dados <- data.frame(
  x = seq(1, 100, length.out = 10),  
  y = seq(0, 1, length.out = 10)^(5.5) 
)

# g<-
ggplot(
  dados, aes(x = x, y = y),
) +
  
  # ADICIONANDO CAMADA EM DESTAQUE
  annotate(
    "rect",
    xmin = 0, xmax = 50,
    ymin = 0, ymax = Inf,
    fill = "#ececec", alpha = 0.3
  ) +
  annotate(
    "rect",
    xmin = 90, xmax = 100,
    ymin = 0, ymax = Inf,
    fill = "#ececec", alpha = 0.3
  ) +
  
  # Add linha
  geom_line(
    colour = "#008cff",
    linewidth = 1.5
  ) +
  scale_x_continuous(
    breaks = seq(0, 100, by = 10),
    minor_breaks = TRUE,
    labels = c("1", seq(10, 100, by = 10))
  ) +
  scale_y_continuous(
    breaks = c(0.0,0.2,0.4,0.6,0.8),
    expand = c(0,0)
  ) + 
  annotate(
    "text",
    x = 0,
    y = 0.0,
    label = "0 ",
    color = "black",
    # hjust = 3,
    vjust = -0.5
  )+
  annotate(
    "text",
    x = 0,
    y = c(0.2,0.4,0.6),
    label = c("2%", "4%", "6%"),
    color = "black",
    # hjust = 1.3,
    vjust = -0.5
  )+
  annotate(
    "text",
    x = 0,
    y = 0.8,
    label = "8% de deduções",
    color = "black",
    hjust = 0.1,
    vjust = -0.5
  )+
  
  labs(
    title = "% do total de deduções que vai \npara cada grupo de declarantes ",
    subtitle = "Por centil, no Imposto de Renda de 2022"
  ) +
  
  theme(
    axis.title = element_blank(),
    axis.text.y = element_blank(), # REMOVER escala Y
    axis.ticks.x = element_line(linewidth = .5),
    axis.ticks.y = element_blank(),
    axis.line.x.bottom = element_line(linewidth = 1),
    
    
    plot.background = element_rect(fill = "#d9d9d9"),
    plot.title = element_text(color = "#333333", size = 12),
    plot.subtitle = element_text(color = "#999999"),
    plot.margin = margin(t = 12, r = 24, b = 12, l = 24, unit = "pt"),
    
    
    panel.background = element_rect(
      fill = "#d9d9d9",
      colour = "#d9d9d9"
    ),
    panel.grid.major.y = element_line(colour = "black", linetype = "dashed"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    aspect.ratio = 4/5
  )

# g |>
ggplot2::ggsave(
   path= "graficos/recrianndo/01/",
   filename = 'nexografico-final.png',
   width = 1080,
   height = 1350,
   units = "px",
   # dpi = 300
   )
