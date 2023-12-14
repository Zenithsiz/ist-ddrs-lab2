source("code/kleinrock.R")
source("code/pnet/pnet.R")

k <- 1000

link_capacity <- 256 * k
packet_size <- 1 * k

LinkCapacities <- replicate(7, link_capacity)

# 12 -> 1
# 13 -> 2
# 24 -> 3
# 25 -> 4
# 35 -> 5
# 46 -> 6
# 56 -> 7

Flows <- list(
  list(rate = 215, packetsize = packet_size, route = c(1, 3, 6)),
  list(rate = 64, packetsize = packet_size, route = c(2, 5)),
  list(rate = 128, packetsize = packet_size, route = c(2, 5, 7)),
  list(rate = 128, packetsize = packet_size, route = c(4))
)

kleinrock <- approx_kleinrock(LinkCapacities, Flows, packet_size)
str(kleinrock)
cat(sprintf("Kleinrock average: %.20f\n", kleinrock$total_wait))

min_rate <- min(sapply(Flows, function(flow) flow$rate))
endTime <- 10000 * (1 / min_rate)
cat(sprintf("End time = %.2f\n", endTime))

set.seed(0)
pnet_results <- lapply(1:2, function(...) pnet(LinkCapacities, Flows, endTime))
pnet_avgs <- sapply(pnet_results, function(res) res$avg_flow_delays)

pnet_mean <- mean(pnet_avgs)
pnet_var <- var(pnet_avgs)

confidence <- 0.95
p <- 1 - (1 - confidence) / 2
t <- qt(p, length(pnet_results) - 1)
pnet_ci_min <- pnet_mean - t * sqrt(pnet_var / length(pnet_results))
pnet_ci_max <- pnet_mean + t * sqrt(pnet_var / length(pnet_results))
cat(sprintf("PNet average results: %.5f .. %.5f\n", pnet_ci_min, pnet_ci_max))
