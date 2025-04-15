TBM.H.M %>%
  ggplot(aes(x = grupo_etario, group = ano)) +
  geom_line(aes(y = TBM.x, color = factor(ano)),size = 1.5) +
  geom_point(aes(y = TBM.x), color = "darkorange", size = 3) +
  geom_line(aes(y = TBM.y, linetype = factor(ano)),size = 1.5) +
  geom_point(aes(y = TBM.y), color = "steelblue", size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_linetype_manual(values = c(1, 2, 3)) +
  scale_color_manual(values = c("darkorange", "darkorange", "steelblue", "steelblue"),
                     labels = c("Mulher", "Mulher", "Homem", "Homem"),
                     name = "Sexo") +
  theme_minimal()








TBM.H.M %>%
  ggplot(aes(x = grupo_etario, group = ano)) +
  geom_line(aes(y = TBM.x), size = 1.5) +
  geom_point(aes(y = TBM.x, color = "TBM.x"), size = 3) +
  geom_line(aes(y = TBM.y), size = 1.5) +
  geom_point(aes(y = TBM.y, color = "TBM.y"), size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_color_manual(values = c("TBM.x" = "darkorange", "TBM.y" = "steelblue"),
                     labels = c("TBM.x", "TBM.y"),
                     name = "Taxas") +
  theme_minimal()




TBM.H.M %>%
  ggplot(aes(x = grupo_etario, group = ano)) +
  geom_line(aes(y = TBM.x, color = factor(ano)), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "TBM.x"), size = 3) +
  geom_line(aes(y = TBM.y, color = factor(ano)), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "TBM.y"), size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_color_manual(values = c("TBM.x" = "darkorange", "TBM.y" = "steelblue", "2010" = "red", "2019" = "green", "2021" = "blue"),
                     labels = c("Mulher", "Homem", "2010", "2019", "2021"),
                     name = "Ano") +
  theme_minimal()








TBM.H.M %>%
  ggplot(aes(x = grupo_etario, group = ano)) +
  geom_line(aes(y = TBM.x, color = "Mulher"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "Mulher"), size = 3) +
  geom_line(aes(y = TBM.y, color = "Homem"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "Homem"), size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_color_manual(values = c("Mulher" = "darkorange", "Homem" = "steelblue", "2010" = "darkorange", "2019" = "steelblue", "2021" = "red"),
                     labels = c("Mulher", "Homem", "2010", "2019", "2021"),
                     name = "Ano") +
  theme_minimal()







TBM.H.M %>%
  ggplot(aes(x = grupo_etario, group = ano)) +
  geom_line(aes(y = TBM.x, color = "Mulher"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "Mulher"), size = 3) +
  geom_line(aes(y = TBM.y, color = "Homem"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "Homem"), size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_color_manual(values = c("Mulher" = "darkorange", "Homem" = "steelblue"),
                     labels = c("Mulher", "Homem"),
                     name = "Sexo") +
  theme_minimal()








TBM.H.M %>%
  ggplot(aes(x = grupo_etario, group = ano)) +
  geom_line(aes(y = TBM.x, color = "Mulher"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "Mulher"), size = 3) +
  geom_line(aes(y = TBM.y, color = "Homem"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "Homem"), size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_color_manual(values = c("Mulher" = "darkorange", "Homem" = "steelblue"),
                     labels = c("Mulher", "Homem"),
                     name = "Sexo") +
  facet_wrap(~ano, ncol = 1) +
  theme_minimal()


TBM.H.M %>%
  ggplot(aes(x = grupo_etario, group = ano)) +
  # Gráfico para o ano de 2010
  geom_line(aes(y = TBM.x, color = "2010"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "2010"), size = 3, fill = "darkorange") +
  # Gráfico para o ano de 2019
  geom_line(data = filter(TBM.H.M, ano == 2019),
            aes(y = TBM.x, color = "2019"), size = 1.5, linetype = "dashed") +
  geom_point(data = filter(TBM.H.M, ano == 2019),
             aes(y = TBM.x, color = "2019"), size = 3, fill = "blue") +
  # Gráfico para o ano de 2021
  geom_line(data = filter(TBM.H.M, ano == 2021),
            aes(y = TBM.x, color = "2021"), size = 1.5, linetype = "dotted") +
  geom_point(data = filter(TBM.H.M, ano == 2021),
             aes(y = TBM.x, color = "2021"), size = 3, fill = "green") +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_color_manual(values = c("2010" = "black", "2019" = "blue", "2021" = "green"),
                     labels = c("2010", "2019", "2021"),
                     name = "Ano") +
  theme_minimal()




library(ggplot2)

# Gráfico com os três anos e facetamento
TBM.H.M %>%
  ggplot(aes(x = grupo_etario, group = ano)) +
  geom_line(aes(y = TBM.x, color = "Mulher"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "Mulher"), size = 3, fill = "darkorange") +
  geom_line(aes(y = TBM.y, color = "Homem"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "Homem"), size = 3, fill = "steelblue") +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo") +
  scale_color_manual(values = c("Mulher" = "darkorange", "Homem" = "steelblue"),
                     labels = c("Mulher", "Homem"),
                     name = "Sexo") +
  facet_wrap(~ano, ncol = 1) +
  theme_minimal()

# Exibir o gráfico completo
print(grafico_completo)




# --------------

library(ggplot2)

# Gráfico para o ano de 2010
grafico_2010 <- TBM.H.M %>%
  filter(ano == 2010) %>%
  ggplot(aes(x = grupo_etario)) +
  geom_line(aes(y = TBM.x, color = "Mulher"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "Mulher"), size = 3) +
  geom_line(aes(y = TBM.y, color = "Homem"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "Homem"), size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo - Ano 2010") +
  scale_color_manual(values = c("Mulher" = "darkorange", "Homem" = "steelblue"),
                     labels = c("Mulher", "Homem"),
                     name = "Sexo") +
  theme_minimal()

# Gráfico para o ano de 2019
grafico_2019 <- TBM.H.M %>%
  filter(ano == 2019) %>%
  ggplot(aes(x = grupo_etario)) +
  geom_line(aes(y = TBM.x, color = "Mulher"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "Mulher"), size = 3) +
  geom_line(aes(y = TBM.y, color = "Homem"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "Homem"), size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo - Ano 2019") +
  scale_color_manual(values = c("Mulher" = "darkorange", "Homem" = "steelblue"),
                     labels = c("Mulher", "Homem"),
                     name = "Sexo") +
  theme_minimal()

# Gráfico para o ano de 2021
grafico_2021 <- TBM.H.M %>%
  filter(ano == 2021) %>%
  ggplot(aes(x = grupo_etario)) +
  geom_line(aes(y = TBM.x, color = "Mulher"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.x, color = "Mulher"), size = 3) +
  geom_line(aes(y = TBM.y, color = "Homem"), size = 1.5, linetype = "solid") +
  geom_point(aes(y = TBM.y, color = "Homem"), size = 3) +
  scale_y_log10() +
  labs(x = "Grupo Etário", y = "") +
  ggtitle("Taxas Específicas de Mortalidade por idade e sexo - Ano 2021") +
  scale_color_manual(values = c("Mulher" = "darkorange", "Homem" = "steelblue"),
                     labels = c("Mulher", "Homem"),
                     name = "Sexo") +
  theme_minimal()

# Exibir os gráficos
print(grafico_2010)
print(grafico_2019)
print(grafico_2021)





