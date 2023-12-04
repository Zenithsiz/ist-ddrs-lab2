#import "/typst/util.typ" as util: indent_par

==== a.

#indent_par[The following figures 7 and 8 show the throughput of slotted ALOHA for various values of $N$, $p$ and $σ$ on the same scale.]

#grid(
  columns: (1fr, 1fr),
  figure(
    image("/output/3a-aloha10.svg", width: 80%),
    caption: [Theoretical performance of slotted ALOHA (N = 10)]
  ),
  figure(
    image("/output/3a-aloha25.svg", width: 80%),
    caption: [Theoretical performance of slotted ALOHA (N = 25)]
  ),
)

#indent_par[For small values of $σ$, most users are stuck in the thinking state, without sending packets, while for larger values of $σ$, most users are simultaneously attempting to send packets, thus increasing the probability of a collision. In both cases, the throughput is low, regardless of the values of $p$]

#indent_par[For values of $σ$ between 0.01 and 0.1, we see a sharp increase in throughput, given that this is a "sweet spot", where users will try to transmit more often, but not as often as to collide. However, in this range, the throughput depends sharply on the values of $N$ and $p$.]

#indent_par[Higher values of $p$ lead to a lower overall throughput, for the same values of $σ$ and $N$ because more collisions occur before successfully transmitting when in the backlogged state.]

#indent_par[Higher values of $N$ lead to a lower overall throughput for the same values of $σ$ and $p$ due to a higher chance of collisions, given there are more users to collide with.]

#pagebreak()

==== b.

#grid(
  columns: (1fr, 1fr),
  figure(
    image("/output/3b-aloha10.svg", width: 80%),
    caption: [Simulated performance of slotted ALOHA (N = 10)]
  ),
  figure(
    image("/output/3b-aloha25.svg", width: 80%),
    caption: [Simulated Performance of slotted ALOHA (N = 25)]
  ),
)

==== c.
