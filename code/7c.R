
for (arrival_rate1 in c(60, 80)) {
	LinkCapacity <<- 100e3
	packet_size = 800
	Flows <<- list(
		list(sourcetype = 2, arrivalrate = arrival_rate1, packetsize = packet_size, priority=1),
		list(sourcetype = 2, arrivalrate = 40, packetsize = packet_size, priority=2)
	)
	endTime <<- 10000*(1/10)

	λ1 = Flows[[1]]$arrivalrate
	λ2 = Flows[[2]]$arrivalrate
	μ = LinkCapacity / packet_size
	p1 = λ1 / μ
	p2 = λ2 / μ
	p = p1 + p2
	avg_wait_delay1 = (p / (2 * μ)) / (1 - p1) + 1 / μ
	avg_wait_delay2 = (p / (2 * μ)) / ((1 - p1) * (1 - p1 - p2)) + 1 / μ

	throughput1 = Flows[[1]]$arrivalrate * packet_size
	throughput2 = Flows[[2]]$arrivalrate * packet_size

	cat(sprintf("λ1 = %.2f\n", λ1))
	cat(sprintf("λ2 = %.2f\n", λ2))
	cat(sprintf("μ = %.2f\n", μ))
	cat(sprintf("p1 = %.2f\n", p1))
	cat(sprintf("p2 = %.2f\n", p2))
	cat(sprintf("W1 = %.2f\n", avg_wait_delay1))
	cat(sprintf("W2 = %.2f\n", avg_wait_delay2))
	cat(sprintf("Throughput (1) = %.2f\n", throughput1))
	cat(sprintf("Throughput (2) = %.2f\n", throughput2))

	set.seed(1)
	source("code/ppl/ppl.R")
}
