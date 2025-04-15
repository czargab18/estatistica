meanpop1991<-
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

meanpop1991<- sum(meanpop1991$meanPonder)/sum(meanpop1991$populacao)

print(round(meanpop1991, digits = 2))
