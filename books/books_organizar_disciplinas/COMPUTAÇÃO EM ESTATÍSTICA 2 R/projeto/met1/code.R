# Pacotes ----

# packages<- c("tidyverse")

if (!require("tidyverse")) {
  install.packages("tidyverse")
} else {
  library("tidyverse")
}

# Import dados----
dados <- readxl::read_xls(
  file.choose()
)

# dataframe ----

data.frame(dados)

# glimpse(dados)

# questão 01----

## 1. Descrever as características das escolas e o
## desempenho de seus estudantes na Prova de Brasil em 2011.


prop.table(table(dados$REG)) * 100
prop.table(table(dados$LOCAL)) * 100



prop.table(table(dados$TAM_MUN)) * 100
prop.table(table(dados$ADM)) * 100

prop.table(table(dados$TAM_ESCOLA)) * 100

summary(dados[, -c(1:7)])
# Resposta 01


# questão 02----

## 2. Estimar a proporção de escolas que menos de 75%
## de seus estudantes participaram da Prova Brasil em 2011.

summary(dados$PARTICIPACAO)
# como q(0.75) 3rd Qu. == 97.06, logo, quantile(dados$PARTICIPACAO)

xi <- (dados$PARTICIPACAO) < 97.06
sum_xi <- sum(xi)
n <- length(dados$PARTICIPACAO)

p_chapeu <- (sum_xi / n)

desv_padrao <-
  sqrt((p_chapeu * (1 - p_chapeu))
  / n)

z <- qnorm(.975)
erro <- desv_padrao * z

interv_p <- erro + c(-z, +z)


# Resposta 2


# questão 03----

## 3. Estimar a proficiência média em Língua Portuguesa e em Matemática
## das  escolas na Prova Brasil em 2011.

# estim profic. media lp

n <- length(dados$NOTA_LP)
s <- sd(dados$NOTA_LP)
se <- s / sqrt(n)
e <- qt(.95, df = n - 1) * se
xbar <- mean(dados$NOTA_LP)
ic_xbar <- xbar - c(-e, +e)

# estim profic. media mat
n <- length(dados$NOTA_MT)
s <- sd(dados$NOTA_MT)
se <- s / sqrt(n)
e <- qt(.95, df = n - 1) * se
xbar <- mean(dados$NOTA_MT)

ic_xbar <- xbar - c(-e, +e)

# Resposta 3




# questão 04----

## 4. Verificar se houve melhora do resultado da Prova Brasil de 2009 para 2011.
## Na Prova Brasil realizada em 2009 aproficiência em
## Língua Portuguesa foi 184,3 e em Matemática foi 204,3.

# melhoria ntre LP 2009 e 2011
xbar09 <- (184.37)

xbar11 <- mean(dados$NOTA_LP)
s <- sd(dados$NOTA_LP)
n <- length(dados$NOTA_LP)

t <- (xbar11 - xbar09) / (s / sqrt(n))

erro <- qnorm(.975) * t

interv <- c(-erro, +erro)

resp <- (-erro < t & t < +erro)

# alpha<-0.5
# t.alpha <- qt(1-alpha/2,df=n-1)

# melhoria ntre Mt 2009 e 2011
xbar09 <- (204.3)

xbar11 <- mean(dados$NOTA_MT)
s <- sd(dados$NOTA_MT)
n <- length(dados$NOTA_MT)

t <- (xbar11 - xbar09) / (s / sqrt(n))

alpha <- 0.5
t.alpha <- qt(1 - alpha / 2, df = n - 1)

interv <- c(-t.alpha, +t.alpha)

resp <- (-t.alpha < t & t < +t.alpha)


# questão 05----

## 5. Verificar se é possível afirmar que as
## notas em Língua Portuguesa e em Matemática
## são normalmente  distribuídas.

#  Língua Portuguesa
hist(dados$NOTA_LP)

ggplot(dados, aes(x = NOTA_LP)) +
  geom_histogram(aes(y = ..density..)) +
  stat_function(
    fun = dnorm,
    args = list(
      mean = mean(dados$NOTA_LP),
      sd = sd(dados$NOTA_LP)
    ),
    color = "red",
    size = 2
  ) +
  theme_classic()

shapiro.test(dados$NOTA_LP)

# Matemática
hist(dados$NOTA_MT)

ggplot(dados, aes(x = dados$NOTA_MT)) +
  geom_histogram(aes(y = ..density..)) +
  stat_function(
    fun = dnorm,
    args = list(
      mean = mean(dados$NOTA_MT),
      sd = sd(dados$NOTA_MT)
    ),
    color = "red",
    size = 5
  )

# questão 06----

## 6. Comparar a proficiência média em Matemática segundo o local da escola.
##  Você diria que a proficiência em Matemática é maior em escolas urbanas?

tbl <- table(dados$NOTA_MT, dados$LOCAL)

chisq.test(tbl)


# questão 07----

##   7. Verificar se existe diferença significativa
## entre as notas de Língua Portuguesa e Matemática.


t.test(dados$NOTA_LP, dados$NOTA_MT, conf.level = .95)



# questão 08----

## 8. Comparar a proporção de escolas que menos de 75% de seus estudantes
## participaram da Prova Brasil em 2011 segundo:

###   a. Local da escola;
###   b. Região de localização da escola.

summary(dados$PARTICIPACAO)
# como q(0.75) 3rd Qu. == 97.06, logo

xi <- (dados$PARTICIPACAO) < 97.06
sum_xi <- sum(xi)
n <- length(dados$PARTICIPACAO)
p_chapeu <- (sum_xi / n)

dados$PARTICIPACAO <- (dados$PARTICIPACAO < 96.0)

tbl <- dados |>
  select(LOCAL, PARTICIPACAO, REG) |>
  mutate(
    PARTICIPACAO = PARTICIPACAO < 96.06
  ) |>
  filter(PARTICIPACAO == TRUE) |>
  select(REG, LOCAL) |>
  na.omit()

prop.test(
  table(tbl),
  conf.level = 0.95,
  correct = FALSE
)

# questão 09----

## 9. Verificar se:
###   a. Região e categoria administrativa estão associadas;

tbl <- table(dados$ADM, dados$REG) |>
  addmargins()

chisq.test(tbl)

###   b. Tamanho da escola e tamanho do município estão associados.

# tbl<-table(dados$TAM_ESCOLA,
#            dados$TAM_MUN)

chisq.test(dados$TAM_ESCOLA,
  dados$TAM_MUN,
  correct = FALSE
)



# questão 10----

## 10. Verificar se a nota em Língua Portuguesa é um bom indicador
## para predizer a nota existe em Matemática, ouseja se estão associadas.


cor.test(dados$NOTA_LP,
  dados$NOTA_MT,
  alternative = "two.side",
  method = "pearson",
  conf.level = 0.95
)
