source("code/kleinrock.R")

k <- 1000
M <- 1000 * k
link_capacities <<- c(
  100 * M,
  100 * M,
  200 * M
)

packet_size <- 8 * k
flows <<- list(
  list(rate = 7.5 * k, route = c(1, 3)),
  list(rate = 10 * k, route = c(2, 3)),
  list(rate = 5 * k, route = c(3))
)

approx <- approx_kleinrock(link_capacities, flows, packet_size)
str(approx)
