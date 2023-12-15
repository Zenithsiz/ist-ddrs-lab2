params_all <- list(
  list(s1 = 1, p1 = 0.9, s2 = 11, p2 = 0.1),
  list(s1 = 1, p1 = 0.99, s2 = 101, p2 = 0.01)
)

calc_stats <- function(params) {
  ρ <- 0.5
  μ <- 1 / (params$s1 * params$p1 + params$s2 * params$p2)
  λ <- ρ * μ
  λ1 <- params$p1 * λ
  λ2 <- params$p2 * λ

  wq1 <- (λ1 * params$s1^2 + λ2 * params$s2^2) / (2 * (1 - λ1 * params$s1))
  wq2 <- (λ1 * params$s1^2 + λ2 * params$s2^2) / (2 * (1 - λ1 * params$s1) * (1 - λ1 * params$s1 - λ2 * params$s2))

  wq <- (λ1 * wq1 + λ2 * wq2) / (λ1 + λ2)

  data.frame(
    s1 = signif(params$s1, 4),
    p1 = signif(params$p1, 4),
    s2 = signif(params$s2, 4),
    p2 = signif(params$p2, 4),
    μ = signif(μ, 4),
    λ = signif(λ, 4),
    λ1 = signif(λ1, 4),
    λ2 = signif(λ2, 4),
    wq1 = signif(wq1, 4),
    wq2 = signif(wq2, 4),
    wq = signif(wq, 4)
  )
}

data <- lapply(params_all, calc_stats)
data <- do.call(rbind, data)
str(data)
write.table(data, "output/8c.csv", sep = "\t", row.names = FALSE)
