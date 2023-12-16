source("code/kleinrock.R")

k <- 1000

link_capacity <- 256 * k
packet_size <- 1 * k

link_capacities <- replicate(7, link_capacity)
flows <- list(
  list(rate = 171.5, packetsize = packet_size, route = c(1, 3, 6)),
  list(rate = 43.5, packetsize = packet_size, route = c(1, 4, 7)),
  list(rate = 64, packetsize = packet_size, route = c(2, 5)),
  list(rate = 128, packetsize = packet_size, route = c(2, 5, 7)),
  list(rate = 128, packetsize = packet_size, route = c(4))
)

kleinrock <- approx_kleinrock(link_capacities, flows, packet_size)
str(kleinrock)
cat(sprintf("Kleinrock average: %.20f\n", kleinrock$avg_packet_delay_network))
