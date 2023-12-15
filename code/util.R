# Calculates confidence intervals for `samples` using student's T distribution
calc_ci <- function(confidence, samples) {
  samples_mean <- mean(samples)
  samples_var <- var(samples)

  p <- 1 - (1 - confidence) / 2
  t <- qt(p, length(samples) - 1)
  ci_min <- samples_mean - t * sqrt(samples_var / length(samples))
  ci_max <- samples_mean + t * sqrt(samples_var / length(samples))

  list(ci_min = ci_min, ci_max = ci_max)
}
