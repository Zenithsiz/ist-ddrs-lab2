#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[In order to simulate the Deficit Round Robin (DDR) algorithm, we based ourselves on the `rand_sched.R` script and modified the following:]

- Added a `queues_quantum` vector to hold the quantum of each queue
- Added a `queues_credit` vector to hold the current credits of each queue.
- Whenever a queue becomes empty, we reset it's credits to 0.
- When receiving a departure event, if all servers are full, we check if any of the left queues still has enough credits for the next packet, and if so, we serve it. Otherwise, we give all queues credits based on their quantum and find the first queue that can serve the next packet. If none are able to, we give them credits again and keep repeating until there is a suitable queue.

#indent_par[The following code 9 is our implementation:]

#code_figure(
  columns(1, text(size: 0.75em, raw(read("/code/11.R"), lang: "R", block: true))),
  caption: "Implementation of deficit round robin",
)

#pagebreak()

#indent_par[We've chosen to simulate several scenarios in which:]

- Link capacity: $1000 "bits" dot s^(-1)$
- Average packet sizes: $500 $ to $ 3500 "bits"$, such that $"AvgPacketSize"_1 + "AvgPacketSize"_2 = 4000$
- Queues quantum: $250 $ to $ 1750 "bits"$, such that $"QueueQuantum"_1 + "QueueQuantum"_2 = 2000$

#indent_par[And obtained the following graphs in figures 15 and 16:]

#grid(
  columns: (1fr, 1fr),
  figure(
    image("/output/11_1.svg", width: 80%),
    caption: [Throughput for queue 1]
  ),
  figure(
    image("/output/11_2.svg", width: 80%),
    caption: [Throughput for queue 2]
  ),
)

#indent_par[We can conclude that for most quantum values, the average packet sizes don't impact the throughput of each queue. Instead the quantum values mostly determine the throughput]

#indent_par[However, for extreme sizes of the quantum, the average packet sizes can influence the throughput on extreme values.]

#indent_par[Overall, we conclude that the ratio between the queue quantums mostly determines the throughput of each queue.]
