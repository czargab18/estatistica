# q1b ---

# b) Para todos os anos acima mencionados, calcule os indicadores de estrutura
#    por Idade (proporção de idosos (60 anos e mais), proporção de crianças
#    (0 a 4 anos), proporção de jovens (0 a 14 anos), razão de dependência e
#    índice de envelhecimento). Calcule a idade média e a idade mediana.
#    Calcule e grafique a razão de sexo por grupos de idade para 2000, 2010 e
#    2030. Comente os resultados.


# q1b pop1991 ----
# - proporção de idosos (60 anos e mais)

(
  pop1991 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop1991 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de crianças (0 a 4 anos)
(
  pop1991 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop1991 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de jovens (0 a 14 anos)
(
  pop1991 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|5-9|10-14")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop1991 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )

# - razão de dependência
(
  pop1991 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop1991 |>
      dplyr::filter(
        # DIFERENTE DE
        !stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - índice de envelhecimento)

(
  pop1991 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop1991 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|5\\b-9|\\b10-14\\b")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# q1b pop2000 ----

# - proporção de idosos (60 anos e mais)

(
  pop2000 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2000 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de crianças (0 a 4 anos)
(
  pop2000 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b0-1\\b|\\b1-4\\b")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2000 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de jovens (0 a 14 anos)
(
  pop2000 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b0-1\\b|\\b1-4\\b|\\b5-9\\b|\\b10-14\\b")
    ) |>
    dplyr::filter(!fxetaria %in% "10-14") |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2000 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )

# - razão de dependência
(
  pop2000 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b0-1\\b|\\b1-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2000 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b0-1\\b|\\b1-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - índice de envelhecimento)

(
  pop2000 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2000 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b0-1\\b|\\b1-4\\b|\\b5-9\\b|\\b10-14\\b")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )



# q1b pop2010 ----

# - proporção de idosos (60 anos e mais)

(
  pop2010 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2010 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de crianças (0 a 4 anos)
(
  pop2010 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b")
    ) |>
    dplyr::filter(!fxetaria %in% "10-14") |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2010 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de jovens (0 a 14 anos)
(
  pop2010 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b5-9\\b|\\b10-14\\b")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2010 |> dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )

# - razão de dependência
(
  pop2010 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b0-1\\b|\\b1-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2010 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b0-1\\b|\\b1-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - índice de envelhecimento)

(
  pop2010 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    pop2010 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b0-1\\b|\\b1-4\\b|\\b5-9\\b|\\b10-14\\b")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )




# q1b popIBGE2015 ----
'popIBGE2015 |> dplyr::filter(stringr::str_detect(fxetaria, pattern = "Total"))'

# - proporção de idosos (60 anos e mais)

(
  popIBGE2015 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    sum(popIBGE2015$populacao, na.rm = TRUE)
    # popIBGE2015 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de crianças (0 a 4 anos)
(
  popIBGE2015 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|5-9")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    sum(popIBGE2015$populacao, na.rm = TRUE)
    # popIBGE2015 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de jovens (0 a 14 anos)
(
  popIBGE2015 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|5-9|10-14")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    sum(popIBGE2015$populacao, na.rm = TRUE)
    # popIBGE2015 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )

# - razão de dependência
(
  popIBGE2015 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    popIBGE2015 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|5-9|10-14|60-64|65-69|70-74|75-79|80+")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - índice de envelhecimento)

(
  popIBGE2015 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    popIBGE2015 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )





# q1b popIBGE2020 ----
'popIBGE2020 |> dplyr::filter(stringr::str_detect(fxetaria, pattern = "Total"))'

# - proporção de idosos (60 anos e mais)

(
  popIBGE2020 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b60-64\\b|\\b65-69\\b|\\b70-74\\b|\\b75-79\\b|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    sum(popIBGE2020$populacao, na.rm = TRUE)
    # popIBGE2020 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de crianças (0 a 4 anos)
(
  popIBGE2020 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    sum(popIBGE2020$populacao, na.rm = TRUE)
    # popIBGE2020 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de jovens (0 a 14 anos)
(
  popIBGE2020 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    sum(popIBGE2020$populacao, na.rm = TRUE)
    # popIBGE2020 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )

# - razão de dependência
(
  popIBGE2020 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b|\\b60-64\\b|\\b65-69\\b|\\b70-74\\b|\\b75-79\\b|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    popIBGE2020 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b|\\b60-64\\b|\\b65-69\\b|\\b70-74\\b|\\b75-79\\b|80+")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - índice de envelhecimento)

(
  popIBGE2020 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    popIBGE2020 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )







# q1b popIBGE2030 ----
'popIBGE2030 |> dplyr::filter(stringr::str_detect(fxetaria, pattern = "Total"))'

# - proporção de idosos (60 anos e mais)

(
  popIBGE2030 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80-84|85-89|90+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    sum(popIBGE2030$populacao, na.rm = TRUE)
    # popIBGE2030 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de crianças (0 a 4 anos)
(
  popIBGE2030 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    sum(popIBGE2030$populacao, na.rm = TRUE)
    # popIBGE2030 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - proporção de jovens (0 a 14 anos)
(
  popIBGE2030 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (sum(popIBGE2030$populacao, na.rm = TRUE)
    # popIBGE2030 |>    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )

# - razão de dependência
(
  popIBGE2030 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    popIBGE2030 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b|60-64|65-69|70-74|75-79|80+")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )


# - índice de envelhecimento)

(
  popIBGE2030 |>
    dplyr::filter(
      stringr::str_detect(fxetaria, pattern = "60-64|65-69|70-74|75-79|80+")
    ) |>
    dplyr::ungroup() |> dplyr::select(populacao) |> sum()
) /
  (
    popIBGE2030 |>
      dplyr::filter(
        !stringr::str_detect(fxetaria, pattern = "\\b0-1\\b|\\b1-4\\b|\\b0-4\\b|\\b5-9\\b|\\b10-14\\b")
      ) |>
      dplyr::ungroup() |> dplyr::select(populacao) |> sum()
  )




# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------
# IDADE MEDIA E MEDIANA ---------------------------------------------------

# MEDIANA ----
"MASCULINA"
pop1991 |>
  dplyr::filter(sexo == "1") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 2015505/2
# [1] 1007753

 15-19       219107      10.9     922035
"20-24       200429       9.94   1122464"
 25-29       180533       8.96   1302997
'
20 + ((1007753 - 922035) / 200429) * 4
# # [1] 21.71069

"FEMININA"
pop1991 |>
  dplyr::filter(sexo == "2") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 2003398/2
# [1] 1001699

 15-19       222656      11.1     902861
"20-24       204716      10.2    1107577"
 25-29       187942      9.38   1295519
'
20 + ((1001699 - 902861) / 204716) * 4
# [1] 21.93122

"TOTAL"
pop1991 |>
  dplyr::group_by(fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 4018903/2
# [1] 2009452

 15-19       441763  1824896
"20-24       405145  2230041"
 25-29       368475  2598516
'
20 + ((2009452 - 1824896) / 405145) * 4
# [1] 21.82212

# ----------------------------------------------------------------------------------------------------------------------------

"MASCULINA"
pop2000 |>
  dplyr::filter(sexo == "1") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 2492438/2
# [1] 1246219

 15-19       260633      10.5    1007663
"20-24       249699      10.0    1257362"
 25-29       220783      8.86   1478145
'
20 + ((1246219 - 1007663) / 249699) * 4
# [1] 23.8215

"FEMININA"
pop2000 |>
  dplyr::filter(sexo == "2") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 2510790/2
# [1] 1255395

 5 2     20-24       254376      10.1    1234296
" 6 2     25-29       229265       9.13   1463561"
 7 2     30-34       214677       8.55   1678238
'

25 + ((1255395 - 1234296) / 229265) * 4
# [1] 25.36812


"TOTAL"
pop2010 |>
  dplyr::group_by(fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 6003788/2
# [1] 3001894

 5 20-24       554139  2529278
 "6 25-29       556602  3085880"
 7 30-34       532272  3618152
'
25 + ((3001894 - 2529278) / 556602) * 4
# [1] 28.39644

# ----------------------------------------------------------------------------------------------------------------------------
"MASCULINA"
popIBGE2015 |>
  dplyr::filter(sexo == "M") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 3288834/2
# [1] 1644417

 6 M     25-29       297653        9.05  1620819
" 7 M     30-34       290892        8.84  1911711"
 8 M     35-39       270622        8.23  2182333
'
30 + ((1644417 - 1620819) / 290892) * 4
# [1] 30.32449

"FEMININA"
popIBGE2015 |>
  dplyr::filter(sexo == "F") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 3336694/2
# [1] 1668347

 6 F     25-29       293022        8.78  1575252
" 7 F     30-34       292599        8.77  1867851"
 8 F     35-39       278005        8.33  2145856
'
30 + ((1668347 - 1575252) / 292599) * 4
# [1] 31.27266


"TOTAL"
popIBGE2015 |>
  dplyr::group_by(fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'>  6625528/2
# [1] 3312764

 6 25-29       590675  3196071
" 7 30-34       583491  3779562"
 8 35-39       548627  4328189
'
30 + ((3312764 - 3196071) / 583491) * 4
# [1] 30.79996


# ----------------------------------------------------------------------------------------------------------------------------

"MASCULINA"
popIBGE2020 |>
  dplyr::filter(sexo == "M") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'>  3527872/2
# [1] 1763936

 6 M     25-29       297480        8.43  1633510
" 7 M     30-34       306630        8.69  1940140"
 8 M     35-39       294739        8.35  2234879
'
30 + ((1763936 - 1633510) / 306630) * 4
# [1] 31.70141

"FEMININA"
popIBGE2020 |>
  dplyr::filter(sexo == "F") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 3588271/2
# [1] 1794136

 6 F     25-29       295305        8.23  1584766
" 7 F     30-34       301927        8.41  1886693"
 8 F     35-39       296964        8.28  2183657
'
30 + ((1794136 - 1584766) / 301927) * 4
# [1] 32.77378


"TOTAL"
popIBGE2020 |>
  dplyr::group_by(fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 7116143/2
# [1] 3558072

 6 25-29       592785  3218276
" 7 30-34       608557  3826833"
 8 35-39       591703  4418536
'
30 + ((3558072 - 3218276) / 608557) * 4
# [1] 32.23345

# ----------------------------------------------------------------------------------------------------------------------------

"MASCULINA"
popIBGE2030 |>
  dplyr::filter(sexo == "M") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'>  3923556/2
# [1] 1961778

 7 M     30-34       310099        7.90  1939981
" 8 M     35-39       308370        7.86  2248351"
 9 M     40-44       309033        7.88  2557384
'
35 + ((1961778 - 1939981) / 308370) * 4
# [1] 35.28274

"FEMININA"
popIBGE2030 |>
  dplyr::filter(sexo == "F") |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 4015040/2
# [1] 2007520

 7 F     30-34       304607        7.59  1877770
" 8 F     35-39       307000        7.65  2184770"
 9 F     40-44       307206        7.65  2491976
'
35 + ((2007520 - 1877770) / 307000) * 4
# [1] 36.69055


"TOTAL"
popIBGE2030 |>
  dplyr::group_by(fxetaria) |>
  dplyr::summarise(populacao = sum(populacao)) |>
  dplyr::mutate(freqAcum = cumsum(populacao))

'> 7938596/2
# [1] 3969298

 7 30-34       614706  3817751
" 8 35-39       615370  4433121"
 9 40-44       616239  5049360
'
35 + ((3969298 - 3817751) / 615370) * 4
# [1] 35.98508


# Média ======================================================

# media pop1991

meanpop1991 <-
  pop1991 |>
  dplyr::mutate(
    fxetaria = dplyr::if_else(fxetaria %in% "80+", "80-00", fxetaria),
    #  ptsmean = stringr::str_split(fxetaria, pattern = "-", n = 2)
  ) |>
  #  tidyr::unnest(cols = ptsmean)
  tidyr::separate(
    col = fxetaria,
    into = c("limInfer", "limSuper"),
    sep = "-"
  ) |>
  dplyr::mutate(
    ptsMean = purrr::map2(
      .x = as.numeric(limInfer), .y = as.numeric(limSuper),
      .f = ~ (abs((.y + .x)) / 2)
    ),
    meanPonder = purrr::map2(
      .x = populacao, .y = ptsMean,
      .f = ~ ((.x * .y)),
    ),
  ) |>
  tidyr::unnest(cols = c(ptsMean, meanPonder))


# solução FINAL

meanpop1991 <- sum(meanpop1991$meanPonder) / sum(meanpop1991$populacao)

print(round(meanpop1991, digits = 2))

# média pop2000

meanpop2000 <-
  pop2000 |>
  dplyr::mutate(
    fxetaria = dplyr::if_else(fxetaria %in% "80+", "80-00", fxetaria),
    #  ptsmean = stringr::str_split(fxetaria, pattern = "-", n = 2)
  ) |>
  #  tidyr::unnest(cols = ptsmean)
  tidyr::separate(
    col = fxetaria,
    into = c("limInfer", "limSuper"),
    sep = "-"
  ) |>
  dplyr::mutate(
    ptsMean = purrr::map2(
      .x = as.numeric(limInfer), .y = as.numeric(limSuper),
      .f = ~ (abs((.y + .x)) / 2)
    ),
    meanPonder = purrr::map2(
      .x = populacao, .y = ptsMean,
      .f = ~ ((.x * .y)),
    ),
  ) |>
  tidyr::unnest(cols = c(ptsMean, meanPonder))

# solução FINAL
meanpop2000 <- sum(meanpop2000$meanPonder) / sum(meanpop2000$populacao)

print(round(meanpop2000, digits = 2))


# média pop2010

meanpop2010 <-
  pop2010 |>
  dplyr::mutate(
    fxetaria = dplyr::if_else(fxetaria %in% "80+", "80-00", fxetaria),
    #  ptsmean = stringr::str_split(fxetaria, pattern = "-", n = 2)
  ) |>
  #  tidyr::unnest(cols = ptsmean)
  tidyr::separate(
    col = fxetaria,
    into = c("limInfer", "limSuper"),
    sep = "-"
  ) |>
  dplyr::mutate(
    ptsMean = purrr::map2(
      .x = as.numeric(limInfer), .y = as.numeric(limSuper),
      .f = ~ (abs((.y + .x)) / 2)
    ),
    meanPonder = purrr::map2(
      .x = populacao, .y = ptsMean,
      .f = ~ ((.x * .y)),
    ),
  ) |>
  tidyr::unnest(cols = c(ptsMean, meanPonder))

# solução FINAL
meanpop2010 <- sum(meanpop2010$meanPonder) / sum(meanpop2010$populacao)

print(round(meanpop2010, digits = 2))


# média popIBGE2015

meanpopIBGE2015 <-
  popIBGE2015 |>
  dplyr::mutate(
    fxetaria = dplyr::if_else(fxetaria %in% "80+", "80-00", fxetaria),
    #  ptsmean = stringr::str_split(fxetaria, pattern = "-", n = 2)
  ) |>
  #  tidyr::unnest(cols = ptsmean)
  tidyr::separate(
    col = fxetaria,
    into = c("limInfer", "limSuper"),
    sep = "-"
  ) |>
  dplyr::mutate(
    ptsMean = purrr::map2(
      .x = as.numeric(limInfer), .y = as.numeric(limSuper),
      .f = ~ (abs((.y + .x)) / 2)
    ),
    meanPonder = purrr::map2(
      .x = populacao, .y = ptsMean,
      .f = ~ ((.x * .y)),
    ),
  ) |>
  tidyr::unnest(cols = c(ptsMean, meanPonder))

# solução FINAL
meanpopIBGE2015 <- sum(meanpopIBGE2015$meanPonder) / sum(meanpopIBGE2015$populacao)

print(round(meanpopIBGE2015, digits = 2))


# média popIBGE2020

meanpopIBGE2020 <-
  popIBGE2020 |>
  dplyr::mutate(
    fxetaria = dplyr::if_else(fxetaria %in% "80+", "80-00", fxetaria),
    #  ptsmean = stringr::str_split(fxetaria, pattern = "-", n = 2)
  ) |>
  #  tidyr::unnest(cols = ptsmean)
  tidyr::separate(
    col = fxetaria,
    into = c("limInfer", "limSuper"),
    sep = "-"
  ) |>
  dplyr::mutate(
    ptsMean = purrr::map2(
      .x = as.numeric(limInfer), .y = as.numeric(limSuper),
      .f = ~ (abs((.y + .x)) / 2)
    ),
    meanPonder = purrr::map2(
      .x = populacao, .y = ptsMean,
      .f = ~ ((.x * .y)),
    ),
  ) |>
  tidyr::unnest(cols = c(ptsMean, meanPonder))

# solução FINAL
meanpopIBGE2020 <- sum(meanpopIBGE2020$meanPonder) / sum(meanpopIBGE2020$populacao)

print(round(meanpopIBGE2020, digits = 2))

# média popIBGE2030

meanpopIBGE2030 <-
  popIBGE2030 |>
  dplyr::mutate(
    fxetaria = dplyr::if_else(fxetaria %in% "80+", "80-00", fxetaria),
    #  ptsmean = stringr::str_split(fxetaria, pattern = "-", n = 2)
  ) |>
  #  tidyr::unnest(cols = ptsmean)
  tidyr::separate(
    col = fxetaria,
    into = c("limInfer", "limSuper"),
    sep = "-"
  ) |>
  dplyr::mutate(
    ptsMean = purrr::map2(
      .x = as.numeric(limInfer), .y = as.numeric(limSuper),
      .f = ~ (abs((.y + .x)) / 2)
    ),
    meanPonder = purrr::map2(
      .x = populacao, .y = ptsMean,
      .f = ~ ((.x * .y)),
    ),
  ) |>
  tidyr::unnest(cols = c(ptsMean, meanPonder))

# solução FINAL
meanpopIBGE2030 <- sum(meanpopIBGE2030$meanPonder) / sum(meanpopIBGE2030$populacao)

print(round(meanpopIBGE2030, digits = 2))













# RSexo 2000, 2010, 2030 ----
ordemetaria <-
  c(
    "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
    "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
    "70-74", "75-79", "80+"
  )


# RS.2000

RS.2000 <-
  pop2000 |>
  dplyr::arrange(sexo) |>
  dplyr::ungroup() |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "0-1" ~ "0-4",
      fxetaria %in% "1-4" ~ "0-4", TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(as.numeric(populacao))) |>
  tidyr::pivot_wider( # PIVOTEAMENTO
    names_from = sexo,
    values_from = populacao
  ) |>
  dplyr::rename(homem = "1", mulher = "2") |>
  dplyr::mutate(
    RS = purrr::map2(
      .x = homem, .y = mulher,
      .f = \(.x, .y){
        .x / .y
      }
    ),
    ano = 2000
  ) |>
  tidyr::unnest(RS)

RS.2000


# RS.2010
RS.2010 <-
  pop2010 |>
  dplyr::arrange(sexo) |>
  dplyr::ungroup() |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "0-1" ~ "0-4",
      fxetaria %in% "1-4" ~ "0-4", TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(as.numeric(populacao))) |>
  tidyr::pivot_wider( # PIVOTEAMENTO
    names_from = sexo,
    values_from = populacao
  ) |>
  dplyr::rename(homem = "1", mulher = "2") |>
  dplyr::mutate(
    RS = purrr::map2(
      .x = homem, .y = mulher,
      .f = \(.x, .y){
        .x / .y
      }
    ),
    ano = 2010
  ) |>
  tidyr::unnest(RS)

# RS.2030

ordemetaria <-
  c(
    "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
    "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
    "70-74", "75-79", "80+"
  )

RS.2030 <-
  popIBGE2030 |>
  dplyr::arrange(sexo) |>
  dplyr::ungroup() |>
  dplyr::mutate(
    fxetaria = dplyr::case_when(
      fxetaria %in% "0-1" ~ "0-4",
      fxetaria %in% "1-4" ~ "0-4", TRUE ~ fxetaria
    ),
    fxetaria = factor(forcats::as_factor(fxetaria), levels = ordemetaria)
  ) |>
  dplyr::group_by(sexo, fxetaria) |>
  dplyr::summarise(populacao = sum(as.numeric(populacao))) |>
  tidyr::pivot_wider( # PIVOTEAMENTO
    names_from = sexo,
    values_from = populacao
  ) |>
  dplyr::mutate(
    RS = purrr::map2(
      .x = M, .y = F,
      .f = \(.x, .y){
        .x / .y
      }
    ),
    Ano = 2000
  ) |>
    tidyr::unnest(RS)
  dplyr::rename(fxetaria = fxetaria)

RS.2030


# Completo.RS
library(tidyverse)

Completo.RS <-
  merge(x = RS.2000, y = RS.2010, by = c("fxetaria")) |>
  dplyr::select(fxetaria, RS.x, RS.y) |>
  merge(y = RS.2030, by = "fxetaria") |>
  dplyr::select(fxetaria, RS.x, RS.y, RS) |>
  tidyr::pivot_longer(
    cols = -c(fxetaria),
    names_to = "Ano", values_to = "RS"
  ) |>
  dplyr::mutate(
    Ano = dplyr::if_else(stringr::str_detect(Ano, pattern = "RS.x"), "2000", Ano),
    Ano = dplyr::if_else(stringr::str_detect(Ano, pattern = "RS.y"), "2010", Ano),
    Ano = dplyr::if_else(stringr::str_detect(Ano, pattern = "RS"), "2030", Ano)
  ) |>
  dplyr::arrange(fxetaria)

Completo.RS


# Gráfico RS ----

PlotRS0porgrupo <-
  ggplot(data = Completo.RS, aes(x = fxetaria)) +
  geom_line(
    aes(y = RS, color = Ano, group = Ano),
    size = 1.2,
  ) +
  geom_hline(yintercept = 1, color = "#6f5d5d", size = .5, linetype = "solid") +
  scale_y_continuous(
    limits = c(0, 1.25),
    breaks = seq(0, 1.25, 0.5)
  ) +
  scale_color_manual(
    aesthetics = "color",
    # values = c("#f95d06", "#343496", "yellow")
    values = c("#1B9E77", "#D95F02", "#7570B3")
  ) +
  theme_minimal() +
  theme_minimal() +
  theme(
    # panel.background = element_rect(color = "#f5f5f7", fill = "#f5f5f7"),
    plot.title = element_text(size = 20, face = "bold"),
    panel.grid.major.x = element_line(linewidth = 0.4, color = "#e5dfdf"),
    panel.grid.major.y = element_line(linewidth = 0.25),
    axis.text.x = element_text(size = 12, face = "plain"),
    axis.text.y = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold"),
    legend.title = element_blank(),
    legend.text = element_text(size = 16),
    legend.position = "bottom",
    plot.caption = element_text(size = 12, hjust = 0),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 10)
  ) +
  labs(
    x = "Grupos Etários",
    y = "Raza De Sexo (escala Logarítmica)",
    title = "Razão de sexo em Goiás por grupo etário",
    caption = "Fonte: DATASUS - 2000 e 2010 e projeção IBGE - 2030"
  )

PlotRS0porgrupo

ggsave(
  filename = "PlotRS0porgrupo.png",
  plot = PlotRS0porgrupo,
  path = "Trabalho 2/result/figuras/",
  scale = 1.3,
  dpi = 300,
  limitsize = TRUE,
  bg = "#f5f5f7"
)


# desnecessário
rm(RS.2030)
rm(RS.2010)
rm(RS.2030)
rm(RS.2000)

rm(Plotpop1991)
rm(Plotpop2010)
rm(Plotpop2000)

rm(Plotpop2010IBGE)
rm(Plotpop2015IBGE)
rm(Plotpop2020IBGE)
rm(Plotpop2030IBGE)

rm(PlotRS0porgrupo)
rm(PlotpopIBGE2010)
rm(Completo.RS)

rm(projecoesIBGE)
rm(pop1991)
rm(pop2000)
rm(pop2010)

rm(ordemetaria)

rm(popIBGE2010)
rm(popIBGE2015)
rm(popIBGE2020)
rm(popIBGE2030)


