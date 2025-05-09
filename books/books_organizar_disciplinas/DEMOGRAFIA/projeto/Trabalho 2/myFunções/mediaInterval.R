# run code in q1a
# run code in q1a
# run code in q1a
# run code in q1a

(
    sum(pop1991$populacao*2)/sum(pop1991$populacao)
)



view(
    pop1991 |>
    dplyr::mutate(
        fxetaria = dplyr::if_else(fxetaria %in% "80+", "80-00", fxetaria),
        meanPonder = map(.x = populacao, .f = ~(.x*2) )
    )
)


pop2000
pop2010

pop2015IBGE
pop2020IBGE
pop2030IBGE
