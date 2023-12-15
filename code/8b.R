source("code/8.R")

set.seed(0)

stopping_condition <- 10000
mm1_var <- var(sapply(1:100, function(...) calc_stats_mm1(0.5, 1, 0.99, 101, 0.01, stopping_condition)$avg_delay))
mg1_var1 <- var(sapply(1:100, function(...) calc_stats_mg1(0.5, 1, 0.9, 11, 0.1, stopping_condition)$avg_delay))
mg1_var2 <- var(sapply(1:100, function(...) calc_stats_mg1(0.5, 1, 0.99, 101, 0.01, stopping_condition)$avg_delay))

output <- list(
  mm1_var = signif(mm1_var, 4),
  mg1_1_var = signif(mg1_var1, 4),
  mg1_2_var = signif(mg1_var2, 4)
)
str(output)
write.table(output, "output/8b.csv", sep = "\t", row.names = FALSE)
