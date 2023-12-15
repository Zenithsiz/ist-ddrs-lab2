source("code/8.R")
source("code/util.R")

stopping_condition <- 10000

mm1_stats <- lapply(1:25, \(...) calc_stats_mm1(0.5, 1, 0.99, 101, 0.01, stopping_condition))
mm1_avg_delay <- calc_ci(0.95, sapply(mm1_stats, \(stat) stat$avg_delay))

mg1_stats1 <- lapply(1:25, \(...) calc_stats_mg1(0.5, 1, 0.9, 11, 0.1, stopping_condition))
mg1_avg_delay1 <- calc_ci(0.95, sapply(mg1_stats1, \(stat) stat$avg_delay))

mg1_stats2 <- lapply(1:25, \(...) calc_stats_mg1(0.5, 1, 0.99, 101, 0.01, stopping_condition))
mg1_avg_delay2 <- calc_ci(0.95, sapply(mg1_stats2, \(stat) stat$avg_delay))

output <- list(
  mm1_sim_avg_delay_ci_min = signif(mm1_avg_delay$ci_min, 4),
  mm1_sim_avg_delay_ci_max = signif(mm1_avg_delay$ci_max, 4),
  mm1_calc_avg_delay = signif(mm1_stats[[1]]$wq, 4),
  mm1_calc_c2 = signif(mm1_stats[[1]]$c2, 4),
  mg1_1_sim_avg_delay_ci_min = signif(mg1_avg_delay1$ci_min, 4),
  mg1_1_sim_avg_delay_ci_max = signif(mg1_avg_delay1$ci_max, 4),
  mg1_1_calc_avg_delay = signif(mg1_stats1[[1]]$wq_pk, 4),
  mg1_1_calc_c2 = signif(mg1_stats1[[1]]$c2_pk, 4),
  mg1_2_sim_avg_delay_ci_min = signif(mg1_avg_delay2$ci_min, 4),
  mg1_2_sim_avg_delay_ci_max = signif(mg1_avg_delay2$ci_max, 4),
  mg1_2_calc_avg_delay = signif(mg1_stats2[[1]]$wq_pk, 4),
  mg1_2_calc_c2 = signif(mg1_stats2[[1]]$c2_pk, 4)
)
str(output)
write.table(output, "output/8a.csv", sep = "\t", row.names = FALSE)
