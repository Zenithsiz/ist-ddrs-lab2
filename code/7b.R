
for (arrival_rate1 in c(60, 80)) {
	LinkCapacity <<- 100e3
	packet_size = 800
	Flows <<- list(
		list(sourcetype = 2, arrivalrate = arrival_rate1, packetsize = packet_size, priority=1),
		list(sourcetype = 2, arrivalrate = 40, packetsize = packet_size, priority=1)
	)
	endTime <<- 10000*(1/10)

	λ = Flows[[1]]$arrivalrate + Flows[[2]]$arrivalrate
	μ = LinkCapacity / packet_size
	avg_wait_delay = λ / ( 2 * μ * (μ - λ) ) + 1 / μ

	throughput1 = Flows[[1]]$arrivalrate * packet_size
	throughput2 = Flows[[2]]$arrivalrate * packet_size

	cat(sprintf("λ = %.2f\n", λ))
	cat(sprintf("μ = %.2f\n", μ))
	cat(sprintf("W = %.2f\n", avg_wait_delay))
	cat(sprintf("Throughput (1) = %.2f\n", throughput1))
	cat(sprintf("Throughput (2) = %.2f\n", throughput2))

	set.seed(1)
	source("code/ppl/ppl.R")
}
