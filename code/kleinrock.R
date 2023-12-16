# Calculates the throughput of a network using the kleinrock approximation
approx_kleinrock <- function(link_capacities, flows, packet_size) {
  # Calculate the arrival rates per link and for the whole network
  # (bits / s)
  λ_network <- 0
  λ_per_link <- replicate(length(link_capacities), 0)
  for (flow in flows) {
    λ_network <- λ_network + flow$rate
    for (link_idx in flow$route) {
      λ_per_link[link_idx] <- λ_per_link[link_idx] + flow$rate
    }
  }

  # Then calculate the service rates
  # (packets / s)
  μ_per_link <- link_capacities / packet_size

  # Then the average packets per link and in the network
  # (packets)
  avg_packets_per_link <- λ_per_link / (μ_per_link - λ_per_link)
  avg_packets_network <- sum(avg_packets_per_link)

  # And finally the average packet delay per link, then flow and in the network
  # (seconds)
  avg_packet_delay_network <- sum(avg_packets_per_link) / λ_network
  avg_packet_delay_per_link <- 1 / (μ_per_link - λ_per_link)
  avg_packet_delay_per_flow <- lapply(flows, function(flow) {
    sum(sapply(flow$route, function(link_idx) avg_packet_delay_per_link[link_idx]))
  })

  list(
    avg_packet_delay_per_flow = avg_packet_delay_per_flow,
    avg_packet_delay_network = avg_packet_delay_network,
    avg_packets_network = avg_packets_network
  )
}
