source("code/kleinrock.R")

k <- 1000

link_capacity <- 256 * k
packet_size <- 1 * k

link_capacities <- replicate(7, link_capacity)
flows <- list(
  list(rate = 170.168, packetsize = packet_size, route = c(1, 3, 6)),
  list(rate = 172.832, packetsize = packet_size, route = c(2, 5, 7)),
  list(rate = 39.218, packetsize = packet_size, route = c(1, 4)),
  list(rate = 24.782, packetsize = packet_size, route = c(2, 5)),
  list(rate = 128.0, packetsize = packet_size, route = c(4))
)

kleinrock <- approx_kleinrock(link_capacities, flows, packet_size)
str(kleinrock)
cat(sprintf("Kleinrock average: %.20f\n", kleinrock$avg_packet_delay_network))
