# Pacotes ----

# packages<- c("tidyverse")

if(!require("tidyverse")){
  install.packages("tidyverse")
}  else{
  library("tidyverse")
}


# Import dados----
dados<-readxl::read_xls(
  file.choose()
)

# dataframe ----

data.frame(dados)


# glimpse(dados) 

#-----------------------------------------------------

# questão 01----

## 1. Descrever as características das escolas e o
## desempenho de seus estudantes na Prova de Brasil em 2011.


# VARIAVEIS QUALITIATIVAS
prop.table(table(dados$REG))*100
prop.table(table(dados$LOCAL))*100

prop.table(table(dados$TAM_MUN))*100
prop.table(table(dados$ADM))*100

prop.table(table(dados$TAM_ESCOLA))*100

# VARIAVEIS QUANTITATIVAS
summary(dados[,-c(1:7)])


# questão 02----

## 2. Estimar a proporção de escolas que menos de 75%
## de seus estudantes participaram da Prova Brasil em 2011.

summary(dados$PARTICIPACAO)
# como q(0.75) 3rd Qu. == 97.06, logo, quantile(dados$PARTICIPACAO)

xi<-(dados$PARTICIPACAO)<97.06
# proporção == somando valores menores que 97.06 e dividindo por 200
p0<- (sum(xi)/length(dados$PARTICIPACAO))

prop.test(p0,length(n),
          correct = FALSE,
          p=0.95,
          alternative = "two.side"
          )



# questão 03----
## 3. Estimar a proficiência média em Língua Portuguesa e em Matemática
## das  escolas na Prova Brasil em 2011.

# estim profic. media lp

t.test(dados$NOTA_LP,
       conf.level = 0.95,
       alternative="two.side"
       )
#  intervalo 181.4977 187.4473, desvio em relação a media
# 184.4725 é 2.974

# estim profic. media mat

t.test(dados$NOTA_MT,
       conf.level = 0.95,
       alternative="two.side"
)



# questão 04----

## 4. Verificar se houve melhora do resultado da Prova Brasil de 2009 para 2011.
## Na Prova Brasil realizada em 2009 aproficiência em
## Língua Portuguesa foi 184,3 e em Matemática foi 204,3.

# Língua Portuguesa
x_09<-184.3
# calculando estatistica do teste
u<-mean(dados$NOTA_LP)

t <- (u-x_09)/
  (sd(dados$NOTA_LP)
   /sqrt(n))

# intervalo e nivel de significancia

n.sig <- .05 
# erro
t.half.alpha = qt(1-(n.sig/2)
                  , df=length(dados$NOTA_LP)-1) 

c(-t.half.alpha,+t.half.alpha)

# ou pval<-2*pt(t,df=200-1)


# Matematica
x_09<-184.3
# calculando estatistica do teste
u<-mean(dados$NOTA_MT)

t <- (u-x_09)/
  (sd(dados$NOTA_MT)
   /sqrt(n))

# intervalo e nivel de significancia

n.sig <- .05 
# erro
t.half.alpha = qt(1-(n.sig/2)
                  , df=length(dados$NOTA_LP)-1) 

c(-t.half.alpha,+t.half.alpha)

# ou pval<-2*pt(t,df=200-1)



# questão 05----

## 5. Verificar se é possível afirmar que as
## notas em Língua Portuguesa e em Matemática
## são normalmente  distribuídas.

#  Língua Portuguesa 
shapiro.test(dados$NOTA_LP)
hist(dados$NOTA_LP)

ggplot(dados, aes(x=NOTA_LP)) +
  geom_histogram(aes(y=after_stat(density)))+
  stat_function(
    fun = dnorm,
    args = list(
      mean=mean(dados$NOTA_LP),
      sd=sd(dados$NOTA_LP)),
    color="red",
    size=1.5
  )+
  theme_classic()


# Matemática
shapiro.test(dados$NOTA_MT)
hist(dados$NOTA_MT)

ggplot(dados, aes(x=dados$NOTA_MT)) +
  geom_histogram(aes(y=after_stat(density)))+
  stat_function(
    fun = dnorm,
    args = list(
      mean=mean(dados$NOTA_MT),
      sd=sd(dados$NOTA_MT)),
    color="red",
    size=1.5
  )


# questão 06----

## 6. Comparar a proficiência média em Matemática segundo o local da escola.
##  Você diria que a proficiência em Matemática é maior em escolas urbanas?

# associação entre quantita e qualit, qui-quadrado
tbl<-table(dados$NOTA_MT,dados$LOCAL)

chisq.test(tbl,
           correct = FALSE
           )

# questão 07----

##   7. Verificar se existe diferença significativa
## entre as notas de Língua Portuguesa e Matemática.

# associaç entre 2 var quanti

t.test(dados$NOTA_LP, dados$NOTA_MT, conf.level = .95)

cor.test(dados$NOTA_LP, dados$NOTA_MT,
         conf.level = .95,
         alternative = "two.side",
         method = "pearson")

# questão 08----

## 8. Comparar a proporção de escolas que menos de 75% de seus estudantes
## participaram da Prova Brasil em 2011 segundo: 

###   a. Local da escola;
summary(dados$PARTICIPACAO) # q3(0.75)=97.06

xi<-(dados$PARTICIPACAO)<97.06
# proporção == somando valores menores que 97.06 e dividindo por 200


# var quantitativa e qualitativa
tbl<-table(xi,dados$LOCAL)

chisq.test(tbl,
           correct = FALSE
           )


###   b. Região de localização da escola.

tbl<-table(xi,dados$REG)

chisq.test(tbl,
           correct = FALSE
           )


# questão 09----

## 9. Verificar se:
###   a. Região e categoria administrativa estão associadas;

# 2 var qualitativas
tbl <-table(dados$REG,dados$ADM) |>
  addmargins()

chisq.test(tbl,
           correct = FALSE)

###   b. Tamanho da escola e tamanho do município estão associados.

# 2 var qualitativas
tbl <-table(dados$TAM_ESCOLA,dados$TAM_MUN) |>
  addmargins()

chisq.test(tbl,
           correct = FALSE)



# questão 10----

## 10. Verificar se a nota em Língua Portuguesa é um bom indicador
## para predizer a nota existe em Matemática, ouseja se estão associadas.

# 2 var quantitati

cor.test(dados$NOTA_LP,
         dados$NOTA_MT,
         alternative = "two.side",
         method = "pearson",
         conf.level = 0.95
         )

