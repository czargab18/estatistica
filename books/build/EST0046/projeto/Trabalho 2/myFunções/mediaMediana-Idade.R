pop1991 <-
  pop1991 |>
  group_by(fxetaria) %>%
  summarise(populacao = sum(populacao))

pop2000 <-
  pop2000 |>
  group_by(fxetaria) %>%
  summarise(populacao = sum(populacao))

pop2010 <-
  pop2010 |>
  group_by(fxetaria) %>%
  summarise(populacao = sum(populacao))

popIBGE2015 <-
  popIBGE2015 |>
  group_by(fxetaria) %>%
  summarise(populacao = sum(populacao))

popIBGE2020 <-
  popIBGE2020 |>
  group_by(fxetaria) %>%
  summarise(populacao = sum(populacao))

popIBGE2030 <-
  popIBGE2030 |>
  group_by(fxetaria) %>%
  summarise(populacao = sum(populacao))


calculate_mean_median_intervals <- function(data_frame) {
  # Remove any rows with missing values
  data_frame <- data_frame[complete.cases(data_frame), ]

  # Calculate the midpoint of each interval
  interval_midpoint <- sapply(data_frame$fxetaria, function(x) {
    interval <- as.character(x)
    interval <- gsub("[^0-9-]+", "", interval)
    interval <- as.numeric(unlist(strsplit(interval, "-")))
    mean(interval)
  })

  # Calculate the weighted sum of frequencies
  weighted_sum <- sum(interval_midpoint * data_frame$populacao, na.rm = TRUE)

  # Calculate the total frequency
  total_frequency <- sum(data_frame$populacao, na.rm = TRUE)

  # Calculate the mean
  mean_value <- weighted_sum / total_frequency

  # Calculate the median
  cumulative_frequency <- cumsum(data_frame$populacao)
  median_index <- which(cumulative_frequency >= total_frequency / 2)[1]
  median_value <- interval_midpoint[median_index]

  # Return the mean and median as a named list
  result <- list(mean = mean_value, median = median_value)
  return(result)
}

calculate_mean_median_intervals(pop1991)

calculate_mean_median_intervals(pop2000)

calculate_mean_median_intervals(pop2010)

calculate_mean_median_intervals(popIBGE2015)

calculate_mean_median_intervals(popIBGE2020)

calculate_mean_median_intervals(popIBGE2030)
