source("code/ppl/ppl.R")

# Inputs to `ppl.R`
LinkCapacity <- NULL
Flows <- NULL
endTime <- NULL

calc_data <- function(sourcetype, arrival_rates, packet_size, priorities) {
  # Perform simulation
  LinkCapacity <<- 100e3
  Flows <<- list(
    list(sourcetype = sourcetype, arrivalrate = arrival_rates[1], packetsize = packet_size, priority = priorities[1]),
    list(sourcetype = sourcetype, arrivalrate = arrival_rates[2], packetsize = packet_size, priority = priorities[2])
  )
  min_arrival_rate <- min(sapply(Flows, function(flow) flow$arrivalrate))
  endTime <<- 10000 * (1 / min_arrival_rate)
  sim_res <- lapply(1:10, function(run_idx) {
    cat(sprintf("Run #%d\n", run_idx))

    res <- ppl()
    data.frame(
      avg_wait_delay1 = res$flow_avg_delays[1],
      avg_wait_delay2 = res$flow_avg_delays[2],
      throughput1 = res$flow_throughput[1],
      throughput2 = res$flow_throughput[2]
    )
  })
  sim_res <- do.call(rbind, sim_res)
  sim_res <- lapply(sim_res, function(col) {
    col_mean <- mean(col)
    col_var <- var(col)

    confidence <- 0.95
    p <- 1 - (1 - confidence) / 2
    t <- qt(p, length(col) - 1)
    ci_min <- col_mean - t * sqrt(col_var / length(col))
    ci_max <- col_mean + t * sqrt(col_var / length(col))

    list(min = ci_min, max = ci_max)
  })

  sim_res
}
