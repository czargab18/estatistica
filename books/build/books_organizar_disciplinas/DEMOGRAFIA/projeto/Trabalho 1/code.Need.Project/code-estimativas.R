library(purrr)

# Descompactar arquivos ZIP usando a função map()
map(
  .x = list.files(
    "estimativas/",
    pattern = ".zip$",
    full.names = TRUE),
  .f = ~utils::unzip(
    .x,
    exdir = "estimativas/",
    overwrite = TRUE) |> file.remove(.x)
  )
