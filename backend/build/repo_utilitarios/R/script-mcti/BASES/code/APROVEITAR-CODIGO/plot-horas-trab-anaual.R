
# Média de horas trabalhadas de todos os pesquisadores
sumarizacao<-
  data |> 
  summarize(
    'média' = mean(`Horas de trabalho – anuais`),
    'mediana' = median(`Horas de trabalho – anuais`),
    'mínimo' = min(`Horas de trabalho – anuais`),
    'máximo' = max(`Horas de trabalho – anuais`),
    'quantil 1' = quantile(`Horas de trabalho – anuais`, 0.25),
    'quantil 3' = quantile(`Horas de trabalho – anuais`, 0.75),
  )



plot<-
  data |> 
  ggplot(aes(x = `Horas de trabalho – anuais`)) +
  geom_freqpoly(bins=30) +
  labs(
    title = 'Frequência das Horas Anuais Trabalhadas pelos Pesquisadores',
    x = 'Horas Trabalhadas',
    y = 'Quantidade de Pesquisadores'
  ) +
  theme(
    # plot.background = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major.y = element_line(
      linewidth = .5,
      linetype = 'dashed',
      color = '#777777'
      ),
  )


ggsave(plot = plot, filename = 'plots/plot-horas-trab-pesquisadores.png', dpi = 300)







plot<-
  data |> 
  mutate(
    rotulos = cut(
    `Horas de trabalho – anuais`,
    breaks = c(0, 120, 1200, 12000, Inf),
    labels = c("menor que 120h", "120 a 1200h", "1200 a 12000h", "maior que 12000h"))
  ) |> 
  select(
    c(`Horas de trabalho – anuais`,rotulos)
  ) |> 
  as.data.frame() |> 
  na.omit() |> 
 
  ggplot(
    aes(
      x = rotulos,
      y=`Horas de trabalho – anuais`
      )
  )+
  geom_bar(
    stat = 'identity',
    fill = "#1B4AEF"
    )+
  scale_y_continuous(
    labels = function(x) format(x, scientific = FALSE)
    ) +
  labs(
    title = 'Frequência das Horas Anuais Trabalhadas pelos Pesquisadores',
    x = 'Horas Trabalhadas',
    y = 'Quantidade de Pesquisadores'
  ) +
  theme(
    # plot.background = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major.y = element_line(linewidth = .5,linetype = 'dashed',color = '#777777'),
  )


ggsave(plot = plot, filename = 'plots/plot-horas-por-frequencia-pesquisadores.png', dpi = 300)  








