source("code/8.R")

stopping_condition <- 10000
mm1_stats <- calc_stats_mm1(0.5, 1, 0.99, 101, 0.01, stopping_condition)
mg1_stats1 <- calc_stats_mg1(0.5, 1, 0.9, 11, 0.1, stopping_condition)
mg1_stats2 <- calc_stats_mg1(0.5, 1, 0.99, 101, 0.01, stopping_condition)

print(mm1_stats)
print(mg1_stats1)
print(mg1_stats2)
