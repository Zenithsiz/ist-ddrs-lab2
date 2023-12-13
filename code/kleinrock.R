# Calculates the throughput of a network using the kleinrock approximation
approx_kleinrock <- function(link_capacities, flows, packet_size) {
  # (Bits / s)
  λ_total <- 0
  λ <- replicate(length(link_capacities), 0)
  for (flow in flows) {
    λ_total <- λ_total + flow$rate
    for (node_idx in flow$route) {
      λ[node_idx] <- λ[node_idx] + flow$rate
    }
  }

  # (Packets / s)
  μ <- link_capacities / packet_size

  # (Packets)
  l <- λ / (μ - λ)
  l_sum <- sum(l)

  total_wait <- l_sum / sum(λ_total)
  waits_flows <- 1 / (μ - λ)
  waits <- sapply(flows, function(flow) {
    sum(sapply(flow$route, function(node_idx) waits_flows[node_idx]))
  })

  list(
    waits = waits,
    total_wait = total_wait,
    l_sum = l_sum
  )
}
