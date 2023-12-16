#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[In order to simulate the Deficit Round Robin (DDR) algorithm, we based ourselves on the `rand_sched.R` script and modified the following:]

- Added a `queues_quantum` vector to hold the quantum of each queue
- Added a `queues_credit` vector to hold the current credits of each queue.
- Whenever a queue becomes empty, we reset it's credits to 0.
- When receiving a departure event, if all servers are full, we check if any of the left queues still has enough credits for the next packet, and if so, we serve it. Otherwise, we give all queues credits based on their quantum and find the first queue that can serve the next packet. If none are able to, we give them credits again and keep repeating until there is a suitable queue.

#indent_par[The following code 9 is our implementation:]

#code_figure(
  columns(1, text(size: 0.7em, raw(read("/code/11.R"), lang: "R", block: true))),
  caption: "Implementation of deficit round robin",
)

#pagebreak()

#indent_par[We've chosen to simulate several scenarios in which:]

- Arrival rates: $0.75$, $1.50$ and $2.25$.
- Link capacity: $1000 "bits" dot s^(-1)$
- Average packet sizes: $500 $ to $ 3500 "bits"$, such that $"AvgPacketSize"_1 + "AvgPacketSize"_2 = 4000$
- Queues quantum: $250$ to $1750 "bits"$, such that $"QueueQuantum"_1 + "QueueQuantum"_2 = 2000$

#indent_par[And obtained the following graphs in figures 15 through 20:]

#grid(
  columns: (1fr, 1fr),
  pad(1em, figure(
    image("/output/11_1_1.svg", width: 100%),
    caption: [Throughput for queue 1 #linebreak() (Arrival rate 0.75)]
  )),
  pad(1em, figure(
    image("/output/11_2_1.svg", width: 100%),
    caption: [Throughput for queue 2 #linebreak() (Arrival rate 2.25)]
  )),
  pad(1em, figure(
    image("/output/11_1_2.svg", width: 100%),
    caption: [Throughput for queue 1 #linebreak() (Arrival rate 1.50)]
  )),
  pad(1em, figure(
    image("/output/11_2_2.svg", width: 100%),
    caption: [Throughput for queue 2 #linebreak() (Arrival rate 1.50)]
  )),
  pad(1em, figure(
    image("/output/11_1_3.svg", width: 100%),
    caption: [Throughput for queue 1 #linebreak() (Arrival rate 2.25)]
  )),
  pad(1em, figure(
    image("/output/11_2_3.svg", width: 100%),
    caption: [Throughput for queue 2 #linebreak() (Arrival rate 0.75)]
  )),
)

#indent_par[In all images we see a (mostly) vertical gradient, implying that the throughput values don't change much across the x axis (average packet sizes). From this, we conclude that the relative quantum values seem to mostly determine the throughput of each queue, regardless of the queue's relative average packet size.]

#indent_par[When the arrival rates are different, the vertical gradient starts to break at the extremes. However, outside of these parts, the pattern still fits extremely well.]

#pagebreak()
