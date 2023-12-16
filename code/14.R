source("code/kleinrock.R")
source("code/pnet/pnet.R")

k <- 1000

link_capacity <- 64 * k
packet_size <- 1000
μ <- link_capacity / packet_size
cat(sprintf("μ = %.2f\n", μ))

set.seed(0)
𝜌_all <- c(0.05, 0.5, 0.95, 0.975)
for (𝜌 in 𝜌_all) {
  λ <- μ * 𝜌
  cat(sprintf("𝜌 = %.3f\n", 𝜌))
  cat(sprintf("λ = %.3f\n", λ))

  LinkCapacities <- c(link_capacity, link_capacity)
  Flows <- list(
    list(rate = λ, packetsize = packet_size, route = c(1, 2))
  )

  kleinrock <- approx_kleinrock(LinkCapacities, Flows, packet_size)
  cat(sprintf("Kleinrock average: %.5f\n", kleinrock$avg_packet_delay_network))

  min_rate <- min(sapply(Flows, function(flow) flow$rate))
  endTime <- 10000 * (1 / min_rate)
  cat(sprintf("End time = %.2f\n", endTime))

  pnet_results <- lapply(1:10, function(...) pnet(LinkCapacities, Flows, endTime))
  pnet_avgs <- sapply(pnet_results, function(res) res$avg_flow_delays)

  pnet_mean <- mean(pnet_avgs)
  pnet_var <- var(pnet_avgs)

  confidence <- 0.95
  p <- 1 - (1 - confidence) / 2
  t <- qt(p, length(pnet_results) - 1)
  pnet_ci_min <- pnet_mean - t * sqrt(pnet_var / length(pnet_results))
  pnet_ci_max <- pnet_mean + t * sqrt(pnet_var / length(pnet_results))
  cat(sprintf("PNet average results: %.5f .. %.5f\n", pnet_ci_min, pnet_ci_max))
}
