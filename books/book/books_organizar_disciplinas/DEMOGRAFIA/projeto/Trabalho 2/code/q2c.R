# c) No link https://www.ibge.gov.br/estatisticas/sociais/populacao/9109-projecao-da-populacao.html?=&t=downloads
#    estão disponíveis as projeções da população por sexo e idade para o Brasil 
#    (2010-2060) e para as Unidades da Federação - revisão 2018, realizadas pelo IBGE.

#   Com base nessas informações, construa e compare as pirâmides resultantes para 
#   os anos de 2010, 2020 e 2060 para o Brasil.

#   Compare os resultados da projeção para a UF escolhida realizada no item (b)
#   e a publicada pelo IBGE


# * Para a análise dos resultados utilize indicadores de estrutura para
#   respectivos anos (como os calculados na Parte 2 deste trabalho). Também
#   comente  sobre os indicadores da dinâmica - taxa bruta de mortalidade, de
#   natalidade e taxa de crescimento.
ordemetaria<-
  c("0-4","5-9","10-14","15-19", "20-24", "25-29", "30-34",
    "35-39","40-44","45-49","50-54","55-59","60-64","65-69",
    "70-74","75-79","80-84","85-89","90+")

dadoq2c<-
  readxl::read_xlsx('data/T2/q2c.xlsx')


dadoq2c<-
  dadoq2c |> 
  mutate(
    `2010` = as.numeric(str_remove_all(`2010`, pattern = ',')),
    `2020` = as.numeric(str_remove_all(`2020`, pattern = ',')),
    `2060` = as.numeric(str_remove_all(`2060`, pattern = ','))
  ) |> 
  pivot_longer(cols = -`GRUPO ETÁRIO`,
               names_to = "Ano",
               values_to = "Populacao") |> 
  mutate(
    sexo = if_else(Ano == '2010', 'Mulher',
                   if_else(Ano == '2010 H', 'Homen',
                           if_else(Ano == '2020', 'Mulher',
                                   if_else(Ano == '2020 H', 'Homen',
                                           if_else(Ano == '2060', 'Mulher',
                                                   if_else(Ano == '2060 H', 'Homen',Ano)))))),
    Ano = str_remove_all(Ano, pattern = ' H'),
    Populacao = abs(Populacao),
    `GRUPO ETÁRIO` = factor(forcats::as_factor(`GRUPO ETÁRIO`),  levels = ordemetaria),
  )
  
  

dadoq2c

library(tidyverse)

Plotq2c<-
  ggplot2::ggplot(
    data = dadoq2c,
    mapping = aes(x = `GRUPO ETÁRIO`,group = sexo, color = sexo)
    ) +
  ggplot2::geom_line(
    data = filter(dadoq2c, sexo == 'Mulher'),
    aes(y = Populacao, color = sexo), 
    position = position_dodge(width = 0.8),
    size = 1.5,
    ) +
  ggplot2::geom_line(
    data = filter(dadoq2c, sexo == 'Homen'),
    aes(y = -Populacao, color = sexo),
     position = position_dodge(width = 0.8),
    size = 1.5,
    ) +
  
  scale_color_manual(
    values =  c('#f95d06','#343496'),
    aesthetics = 'color',
    labels = c("Mulheres","Homens")) +
  
  
  ggplot2::scale_y_continuous(
    limits = c(-8900000, 8900000),
    breaks = seq(-8900000, 8900000, 4000000),
    labels = function(x) {abs(x) / 1000}
  ) +
  
  # girar gráfico 
  ggplot2::coord_flip() +
    facet_wrap(~Ano) +    
  theme_minimal() +
  
  theme(
    panel.grid.major.x = element_line(linewidth = 0.7, color = "gray"),
    panel.grid.major.y = element_line(linewidth = 0.5),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 12),
        legend.position = "bottom",
            legend.title = element_blank(),
    aspect.ratio = 2
  ) +
  labs(
    x = "Grupos Etários",
    y = "População (em milhares em milhares)",
    fill = "Sexo",
    title = "Pirâmide Etária de 2010, 2020 e 2060, Brasil ",
    caption = "Fonte: Projeção IBGE, revisão 2018"
  )


Plotq2c

# .Export Plot 
ggsave(
  filename = 'Plotq2c.png',
  plot = Plotq2c,
  path = 'Trabalho 2/result/figuras',
  scale = 1,
  dpi = 300,
  limitsize = TRUE,
  bg = '#f5f5f7'
)





