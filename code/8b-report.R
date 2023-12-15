mm1_var <- var(sapply(1:100, \(...) calc_stats_mm1(...)$avg_delay))
mg1_var1 <- var(sapply(1:100, \(...) calc_stats_mg1(...)$avg_delay))
mg1_var2 <- var(sapply(1:100, \(...) calc_stats_mg1(...)$avg_delay))
