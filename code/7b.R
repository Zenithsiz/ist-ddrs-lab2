source("code/7.R")
source("code/ppl/ppl.R")

arrival_rates1 <- c(60, 80)

set.seed(0)
data <- lapply(arrival_rates1, function(arrival_rate1) {
  cat(sprintf("Arrival rate (1) = %d\n", arrival_rate1))

  packet_size <- 800
  sim_res <- calc_data(2, c(arrival_rate1, 40), packet_size, c(1, 1))

  # Then calculate theoretical results
  λ <- Flows[[1]]$arrivalrate + Flows[[2]]$arrivalrate
  μ <- LinkCapacity / packet_size
  avg_wait_delay <- λ / (2 * μ * (μ - λ)) + 1 / μ

  throughput1 <- Flows[[1]]$arrivalrate * packet_size
  throughput2 <- Flows[[2]]$arrivalrate * packet_size

  data.frame(
    λ = λ,
    μ = μ,
    calc_avg_wait_delay = signif(avg_wait_delay, 4),
    calc_throughput1 = signif(throughput1, 4),
    calc_throughput2 = signif(throughput2, 4),
    sim_avg_wait_delay1_min = signif(sim_res$avg_wait_delay1$min, 4),
    sim_avg_wait_delay1_max = signif(sim_res$avg_wait_delay1$max, 4),
    sim_avg_wait_delay2_min = signif(sim_res$avg_wait_delay2$min, 4),
    sim_avg_wait_delay2_max = signif(sim_res$avg_wait_delay2$max, 4),
    sim_throughput1_min = signif(sim_res$throughput1$min, 4),
    sim_throughput1_max = signif(sim_res$throughput1$max, 4),
    sim_throughput2_min = signif(sim_res$throughput2$min, 4),
    sim_throughput2_max = signif(sim_res$throughput2$max, 4)
  )
})
data <- do.call(rbind, data)

write.table(data, "output/7b.csv", sep = "\t", row.names = FALSE)
