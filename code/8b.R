source("code/8.R")

set.seed(3)

stopping_condition <- 10000
mm1_var <- var(sapply(1:100, function(...) calc_stats_mm1(0.5, 1, 0.99, 101, 0.01, stopping_condition)$avg_delay))
print(mm1_var)

mg1_var1 <- var(sapply(1:100, function(...) calc_stats_mg1(0.5, 1, 0.9, 11, 0.1, stopping_condition)$avg_delay))
print(mg1_var1)

mg1_var2 <- var(sapply(1:100, function(...) calc_stats_mg1(0.5, 1, 0.99, 101, 0.01, stopping_condition)$avg_delay))
print(mg1_var2)
