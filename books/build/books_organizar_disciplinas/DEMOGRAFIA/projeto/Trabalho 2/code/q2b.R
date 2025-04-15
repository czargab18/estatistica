# b) Assumindo população fechada (ausência de migração), projete a população da
#   UF escolhida de 2010 a 2020, segundo o cenário de mortalidade e fecundidade
#   constante. Obtenha indicadores de fecundidade e mortalidade para o período
#   2014-2016 (nascimentos e óbitos médios do triênio e população projetada pelo
#   IBGE para 2015). Construa uma tábua de vida e obtenha as taxas específicas
#   de fecundidade.
"
link: https://www.ibge.gov.br/estatisticas/sociais/populacao/9662-censo-demografico-2010.html?=&t=downloads
"
# ============== TAXAS FECUNDIDADE CONSTANTE ==============

'Numero de Nascimentos por IDADEMAE, contados pela coluna "contador"
SEM/NÃO CONSIDERAR O SEXO dos nascidos-vivos'

sinasc.Fecund <-
  microdatasus::fetch_datasus(
    uf = "GO",
    year_start = 2014,
    year_end = 2016,
    information_system = "SINASC",
    vars = c("DTNASC", "IDADEMAE", "SEXO") # IDADEMÃE para Construir GRUPOS-ETÁRIOS
  ) |>
  dplyr::mutate(
    IDADEMAE = as.numeric(as.character(IDADEMAE)),
    DTNASC = format(lubridate::dmy(DTNASC), "%Y"),
    GRUPO = cut(
      IDADEMAE,
      c(15, 20, 25, 30, 35, 40, 45, 50),
      labels = c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49"),
      include.lowest = TRUE
    ),
    contador = 1,
    SEXO = dplyr::case_when(
      SEXO %in% "1" ~ "M",
      SEXO %in% "2" ~ "F",
      SEXO %in% c(0, "0", 9, "9") ~ "I",
      TRUE ~ SEXO
    ),
    GRUPO = factor(
      GRUPO,
      levels = c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49")
    ),
  ) |>
  dplyr::filter(
    !(GRUPO %in% c(NA, "NA") | SEXO %in% c(0, "0", "I", NA, "NA"))
  ) |>
  # "IDADEMA usado para criar os GRUPOS-ETÁRIOS"
  dplyr::select(-"IDADEMAE") |>
  tidyr::pivot_wider(
    names_from = DTNASC, # os Nomes das NOVAS COLUNAS vem de 'ano'
    values_from = contador, # os valores paras as NOVAS COLUNAS vem de 'contador'
    # como ignora-se valores únicos como: "IDADE", "DTOBITO")
    values_fn = list(contador = sum)
    # Podemos somar os valores repetidos atraves de 'contador'
  ) |>
  dplyr::arrange(SEXO, GRUPO) |>
dplyr::mutate(
  # nascimentos médios do triênio - população projetada pelo IBGE para 2015
  nNx_media = purrr::pmap_dbl(
    .l = list(`2014`, `2015`, `2016`),
    # .f = function(x, y, z) {
    .f = \(x, y, z){
      round(
        ((x + y + z) / 3),
        digits = 2
      )
    }
  )
) |>
  dplyr::select(c("GRUPO", "SEXO","nNx_media"))

View(sinasc.Fecund)


"POPULAÇÃO FEMININA 2010"

popFem2015 <-
  popIBGE2015 |>
  dplyr::rename(
    "SEXO" = "sexo",
    "GRUPO" = "fxetaria",
    "pop2015" = "populacao",
  ) |>
  dplyr::filter(
    (
      GRUPO %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") &
        SEXO %in% c(2, "2", "F", 1, "1", "M")
    )
  ) |>
  dplyr::select(c("GRUPO", "SEXO", "pop2015"))

View(popFem2015)


"JUNTANDO NASCIMENTOS COM NÚMERO DA POPULAÇÃO 'FEMININA' 2010"

tefFemini2015 <-
  merge(
    x = sinasc.Fecund, y = popFem2015,
    by = c("GRUPO","SEXO")
  ) |>
  dplyr::mutate(
    tef2010 = purrr::map2(
      .x = nNx_media,
      .y = pop2015,
      .f = ~ round((.x / .y), digits = 4)
    )
  ) |>
  dplyr::select(GRUPO, SEXO, tef2010) |>
  dplyr::arrange(SEXO, GRUPO)

View(tefFemini2015)

"JUNTANDO BASES PARA CALCULAR TEF CONSTANTE - 2010"
Projpop2010 <- 
pop2010 |>
  dplyr::rename(
    "SEXO" = "sexo",
    "GRUPO" = "fxetaria",
    "Npop2010" = "populacao",
  ) |>
  dplyr::filter(
    (
      GRUPO %in% c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49") &
        SEXO %in% c(2, "2", "F", 1, "1", "M")
    )
  ) |>
  dplyr::mutate(
    SEXO = dplyr::case_when(
      SEXO %in% "1" ~ "M",
      SEXO %in% "2" ~ "F",
      SEXO %in% c(0,"9") ~ "I",
      TRUE ~ SEXO
    ),
  )

Projpop2010
tefFemini2015

# ============ 'NASCIMENTOS MÉDIOS ==> bar{B}' ============

TEFB_bar_pop2010 <- 
merge(x = Projpop2010, y = tefFemini2015, by = c('GRUPO','SEXO')) |>
dplyr::mutate(
  B_bar = purrr::map2(
  .x = Npop2010, .y =  tef2015, 
  .f = ~round( ( (.x*.y) ), digits = 0 )
  )
) |>
dplyr::arrange(SEXO,GRUPO)

TEFB_bar_pop2010

# TEFB_bar_pop2010 |> 
# dplyr::filter( SEXO %in% 'F')  |>
# dplyr::select(B_bar)
# 
# 
# TEFB_bar_pop2010 |> 
# dplyr::filter( SEXO %in% 'M') |>
# dplyr::select(B_bar)

readODS::write_ods(
  x = TEFB_bar_pop2010,
  path = "Trabalho 2/result/tabelas/TEFB_bar_pop2010-TabVida.ods",
  row_names = FALSE
)

View(TEFB_bar_pop2010)


"EXPORTANDO PARA EXCEL"

TEFB_bar_pop2010
# ============== FINAL :TAXAS FECUNDIDADE CONSTANTE ==============







# ===============================================================

"Numero de Óbitos por IDADE"

ordemetaria <-
  c(
    "NA", NA,
    "0-1", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34",
    "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
    "70-74", "75-79", "80+"
  )



simdf <-
  microdatasus::fetch_datasus(
    uf = "GO",
    year_start = 2014,
    year_end = 2016,
    information_system = "SIM-DO",
    vars = c("DTOBITO", "IDADE", "SEXO")
  ) |>
  dplyr::mutate(
    ano = format(lubridate::dmy(DTOBITO), "%Y"),
    contador = 1,
    grupo_etario = dplyr::case_when(
      stringr::str_detect(IDADE,
        pattern = stringr::str_c(sprintf("%03d", seq(000, 400)), collapse = "|")
      ) ~ "0",
      stringr::str_detect(
        IDADE,
        pattern = stringr::str_c(sprintf("%03d", seq(401, 404)), collapse = "|")
      ) ~ "1",
      stringr::str_detect(
        IDADE,
        pattern = stringr::str_c(sprintf("%03d", seq(405, 409)), collapse = "|")
      ) ~ "5",
      stringr::str_detect(
        IDADE,
        pattern = stringr::str_c(sprintf("%03d", seq(480, 599)), collapse = "|")
      ) ~ "80",
      TRUE ~ stringr::str_sub(IDADE, start = 2)
    ),
    SEXO = dplyr::case_when(
      SEXO %in% "1" ~ "M",
      SEXO %in% "2" ~ "F",
      SEXO %in% "0" ~ "I",
      TRUE ~ SEXO
    ),
    grupo_etario = as.numeric(grupo_etario),
    grupo_etario = dplyr::case_when(
      grupo_etario %in% 0 ~ "0-1",
      grupo_etario %in% 1 ~ "1-4",
      grupo_etario %in% 5 ~ "5-9",
      grupo_etario %in% 10:14 ~ "10-14",
      grupo_etario %in% 15:19 ~ "15-19",
      grupo_etario %in% 20:24 ~ "20-24",
      grupo_etario %in% 25:29 ~ "25-29",
      grupo_etario %in% 30:34 ~ "30-34",
      grupo_etario %in% 35:39 ~ "35-39",
      grupo_etario %in% 40:44 ~ "40-44",
      grupo_etario %in% 45:49 ~ "45-49",
      grupo_etario %in% 50:54 ~ "50-54",
      grupo_etario %in% 55:59 ~ "55-59",
      grupo_etario %in% 60:64 ~ "60-64",
      grupo_etario %in% 65:69 ~ "65-69",
      grupo_etario %in% 70:74 ~ "70-74",
      grupo_etario %in% 75:79 ~ "75-79",
      grupo_etario %in% 80 ~ "80+",
      TRUE ~ as.character(grupo_etario)
    ),
    grupo_etario = factor(grupo_etario, levels = ordemetaria),
    #     [1] "NA"  NA   "0-1"   "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29"
    #     [10] "30-34" "35-39" "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70-74"
    #     [19] "75-79" "80+"
  ) |>
  dplyr::arrange(grupo_etario) |>
  dplyr::filter(
    !(
      grupo_etario %in% c(99, "NA", NA) |
        IDADE %in% c(999, "999", NA, 0, "0") |
        SEXO %in% c("0", 0, "I", "i")
    )
  ) |>
  dplyr::select(-c("IDADE", "DTOBITO")) |>
  # PIVOTEANDO APENAS A COLUNA: |=========> ANO <=========|
  tidyr::pivot_wider(
    names_from = ano, # os Nomes das NOVAS COLUNAS vem de 'ano'
    values_from = contador, # os valores paras as NOVAS COLUNAS vem de 'contador'
    # como ignora-se valores únicos como: "IDADE", "DTOBITO")
    values_fn = list(contador = sum)
    # Podemos somar os valores repetidos atraves de 'contador'
  ) |>
  # JUNTANDO NÚMERO DE ÓBITOS COM NASCIDOS VIVOS - Manualmente
  dplyr::mutate(
    # óbitos médios do triênio e população projetada pelo
    #   IBGE para 2015
    nDx_media = purrr::pmap_dbl(
      .l = list(`2014`, `2015`, `2016`),
      .f = \(x, y, z){
        round(
          ((x + y + z) / 3),
          digits = 2
        )
      }
    ),
    grupo_etario = as.character(grupo_etario)
  ) |>
  dplyr::select(c("SEXO", "grupo_etario", "nDx_media")) |>
  dplyr::arrange("grupo_etario", "SEXO")



# POPTBR10.csv  2010 ----
"data foi pego de ~/code/ImportData.R"
pop2010 <-
  pop2010 |>
  dplyr::rename("SEXO" = "sexo", "grupo_etario" = "fxetaria") |>
  dplyr::mutate(
    SEXO = dplyr::if_else(SEXO %in% "1", "M", "F")
  )


simdfPop2010 <-
  merge(x = simdf, y = pop2010, by = c("SEXO", "grupo_etario")) |>
  dplyr::mutate(
    grupo_etario = factor(grupo_etario, levels = ordemetaria),
  ) |>
  dplyr::arrange(SEXO, grupo_etario)

View(simdfPop2010)

# ================= TÁBUA MASCULINA - FEMININA =================

readODS::write_ods(
  x = simdf,
  path = "Trabalho 2/result/tabelas/simdf-TabVida.ods",
  row_names = FALSE
)
readODS::write_ods(
  x = simdfPop2010,
  path = "Trabalho 2/result/tabelas/simdfPop2010-TabVida.ods",
  row_names = FALSE
)


# TÁBUA DE MORTALIDADE
# ( MORTAL + FECUND ) CONSTANTES - TABUA DE 2010

# TAXAS ESPECIFICAS DE FECUNDIDADE
# PROJEÇÃO 2010 - 2015 - 2010





# ============== FEMIMNINA ==============
