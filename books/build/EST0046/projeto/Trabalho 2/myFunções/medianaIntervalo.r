library(rlang)

mdInterv <- function(data, col_class, col_frequency) {
    # código 
  return(median)
}

# ----------------------------------------------------------------------------------------------------------------------------

"MASCULINA"
pop1991  |> dplyr::filter(sexo== "1")  |> dplyr::mutate(freqAcum = cumsum(populacao))

> 2015505/2
[1] 1007753

 4 1     15-19       219107      10.9     922035
" 5 1     20-24       200429       9.94   1122464"
 6 1     25-29       180533       8.96   1302997

20 + ((1007753 - 922035)/200429)*4

"FEMININA"
pop1991  |> dplyr::filter(sexo== "2")  |> dplyr::mutate(freqAcum = cumsum(populacao))

> 2003398/2
[1] 1001699

4 2     15-19       222656      11.1     902861
"5 2     20-24       204716      10.2    1107577"
6 2     25-29       187942       9.38   1295519

20 + ((1001699 - 902861)/204716)*4

"TOTAL"
pop1991 |> dplyr::group_by(fxetaria) |> dplyr::summarise(populacao = sum(populacao)) |> dplyr::mutate(freqAcum = cumsum(populacao))

> 4018903/2
[1] 2009452

 4 15-19       441763  1824896
" 5 20-24       405145  2230041"
 6 25-29       368475  2598516

20 + ((2009452 - 1824896)/405145)*4

# ----------------------------------------------------------------------------------------------------------------------------

"MASCULINA"
pop2000  |> dplyr::filter(sexo== "1")  |> dplyr::mutate(freqAcum = cumsum(populacao))

> 2492438/2
[1] 1246219

 4 1     15-19       260633      10.5    1007663
" 5 1     20-24       249699      10.0    1257362"
 6 1     25-29       220783       8.86   1478145

20 + ((1246219 - 1007663)/249699)*4
[1] 23.8215

"FEMININA"
pop2000  |> dplyr::filter(sexo== "2")  |> dplyr::mutate(freqAcum = cumsum(populacao))

> 2510790/2
[1] 1255395

 5 2     20-24       254376      10.1    1234296
" 6 2     25-29       229265       9.13   1463561"
 7 2     30-34       214677       8.55   1678238

25 + ((1255395 - 1234296)/229265)*4
[1] 25.36812


"TOTAL"
pop2010 |> dplyr::group_by(fxetaria) |> dplyr::summarise(populacao = sum(populacao)) |> dplyr::mutate(freqAcum = cumsum(populacao))

> 6003788/2
[1] 3001894

 5 20-24       554139  2529278
 "6 25-29       556602  3085880"
 7 30-34       532272  3618152

25 + ((3001894 - 2529278)/556602)*4
[1] 28.39644

# ----------------------------------------------------------------------------------------------------------------------------
"MASCULINA"
popIBGE2015  |> dplyr::filter(sexo== "M")  |> dplyr::mutate(freqAcum = cumsum(populacao))

> 3288834/2
[1] 1644417

 6 M     25-29       297653        9.05  1620819
" 7 M     30-34       290892        8.84  1911711"
 8 M     35-39       270622        8.23  2182333

30 + ((1644417 - 1620819)/290892)*4
[1] 30.32449

"FEMININA"
popIBGE2015  |> dplyr::filter(sexo== "F")  |> dplyr::mutate(freqAcum = cumsum(populacao))

> 3336694/2
[1] 1668347

 6 F     25-29       293022        8.78  1575252
" 7 F     30-34       292599        8.77  1867851"
 8 F     35-39       278005        8.33  2145856

30 + ((1668347 - 1575252)/292599)*4
[1] 31.27266


"TOTAL"
popIBGE2015 |> dplyr::group_by(fxetaria) |> dplyr::summarise(populacao = sum(populacao)) |> dplyr::mutate(freqAcum = cumsum(populacao))

>  6625528/2
[1] 3312764

 6 25-29       590675  3196071
" 7 30-34       583491  3779562"
 8 35-39       548627  4328189

30 + ((3312764 - 3196071)/583491)*4
[1] 30.79996


# ----------------------------------------------------------------------------------------------------------------------------

"MASCULINA"
popIBGE2020  |> dplyr::filter(sexo== "M")  |> dplyr::mutate(freqAcum = cumsum(populacao))

>  3527872/2
[1] 1763936

 6 M     25-29       297480        8.43  1633510
" 7 M     30-34       306630        8.69  1940140"
 8 M     35-39       294739        8.35  2234879

30 + ((1763936 - 1633510)/306630)*4
[1] 31.70141

"FEMININA"
popIBGE2020  |> dplyr::filter(sexo== "F")  |> dplyr::mutate(freqAcum = cumsum(populacao))

> 3588271/2
[1] 1794136

 6 F     25-29       295305        8.23  1584766
" 7 F     30-34       301927        8.41  1886693"
 8 F     35-39       296964        8.28  2183657

30 + ((1794136 - 1584766)/301927)*4
[1] 32.77378


"TOTAL"
popIBGE2020 |> dplyr::group_by(fxetaria) |> dplyr::summarise(populacao = sum(populacao)) |> dplyr::mutate(freqAcum = cumsum(populacao))

> 7116143/2
[1] 3558072

 6 25-29       592785  3218276
" 7 30-34       608557  3826833"
 8 35-39       591703  4418536

30 + ((3558072 - 3218276)/608557)*4
[1] 32.23345

# ----------------------------------------------------------------------------------------------------------------------------

"MASCULINA"
popIBGE2030  |> dplyr::filter(sexo== "M")  |> dplyr::mutate(freqAcum = cumsum(populacao))

>  3923556/2
[1] 1961778

 7 M     30-34       310099        7.90  1939981
" 8 M     35-39       308370        7.86  2248351"
 9 M     40-44       309033        7.88  2557384

35 + ((1961778 - 1939981)/308370)*4
[1] 35.28274

"FEMININA"
popIBGE2030  |> dplyr::filter(sexo== "F")  |> dplyr::mutate(freqAcum = cumsum(populacao))

> 4015040/2
[1] 2007520

 7 F     30-34       304607        7.59  1877770
" 8 F     35-39       307000        7.65  2184770"
 9 F     40-44       307206        7.65  2491976

35 + ((2007520 - 1877770)/307000)*4
[1] 36.69055


"TOTAL"
popIBGE2030 |> dplyr::group_by(fxetaria) |> dplyr::summarise(populacao = sum(populacao)) |> dplyr::mutate(freqAcum = cumsum(populacao))

> 7938596/2
[1] 3969298

 7 30-34       614706  3817751
" 8 35-39       615370  4433121"
 9 40-44       616239  5049360

35 + ((3969298 - 3817751)/615370)*4
[1] 35.98508

# ----------------------------------------------------------------------------------------------------------------------------

" FUNCIONA PARA POPULAÇÃO TOTAL"

calcular_mediana_intervalo <- function(dataframe) {
  # Ordenar o dataframe pelos limites inferiores das classes
  dataframe <- dataframe[order(dataframe$Classe), ]
  # Calcular o tamanho total da amostra (n)
  n <- sum(dataframe$Frequencia)
  # Encontrar a posição n/2
  posicao_mediana <- n / 2
  # Encontrar o índice da frequência acumulada que ultrapassa ou é igual à posição n/2
  indice_mediana <- match(TRUE, cumsum(dataframe$Frequencia) >= posicao_mediana)
  # Obter os valores necessários para o cálculo da mediana
  limite_inferior_mediana <- as.numeric(sub("\\s*-.*", "", dataframe$Classe[indice_mediana]))
  frequencia_acumulada_anterior <- sum(dataframe$Frequencia[1:(indice_mediana - 1)])
  frequencia_mediana <- dataframe$Frequencia[indice_mediana]
  amplitude <- as.numeric(sub(".*-\\s*", "", dataframe$Classe[indice_mediana])) - limite_inferior_mediana
  # Calcular a mediana usando a fórmula para intervalos de classe
  mediana <- limite_inferior_mediana + ((posicao_mediana - frequencia_acumulada_anterior) / frequencia_mediana) * amplitude
  return(mediana)
  print(median)
}


dado  <-
popIBGE2030 |> dplyr::group_by(fxetaria) |>
dplyr::summarise(populacao = sum(populacao)) |>
dplyr::mutate(freqAcum = cumsum(populacao)) |>
dplyr::rename("Classe" = "fxetaria", "Frequencia" = "populacao" ) |>
dplyr::select(-freqAcum)

# Chamando a função para calcular a mediana
mediana_calculada <- calcular_mediana_intervalo(dado)
# print(mediana_calculada)


# # ----------------------------------------------------------------------------------------------------------------------------
# # ----------------------------------------------------------------------------------------------------------------------------



# # ----------------------------------------------------------------------------------------------------------------------------
# # ----------------------------------------------------------------------------------------------------------------------------