#import "/typst/util.typ" as util: indent_par, code_figure

==== a.

#indent_par[The following figures 7 and 8 show the throughput of slotted ALOHA for various values of $N$, $p$ and $σ$, on the same scale.]

#grid(
  columns: (1fr, 1fr),
  pad(1em, figure(
    image("/output/3a-aloha10.svg", width: 100%),
    caption: [Theoretical performance of slotted ALOHA (N = 10)]
  )),
  pad(1em, figure(
    image("/output/3a-aloha25.svg", width: 100%),
    caption: [Theoretical performance of slotted ALOHA (N = 25)]
  )),
)

#indent_par[For small values of $σ$, most users are stuck in the thinking state, without sending packets, while for larger values of $σ$, most users are simultaneously attempting to send packets, thus increasing the probability of a collision. In both cases, the throughput is low, regardless of the values of $p$.]

#indent_par[For values of $σ$ between 0.01 and 0.1, we see a sharp increase in throughput, given that this is a "sweet spot", where users will try to transmit more often, but not as often as to collide. However, in this range, the throughput depends sharply on the values of $N$ and $p$.]

#indent_par[Higher values of $p$ lead to a lower overall throughput, for the same values of $σ$ and $N$ because more collisions occur before successfully transmitting when in the backlogged state.]

#indent_par[Higher values of $N$ lead to a lower overall throughput for the same values of $σ$ and $p$ due to a higher chance of collisions, given there are more users to collide with.]

#pagebreak()

==== b.

#indent_par[We developed the following script in code 2 to simulate slotted ALOHA:]

#code_figure(
  text(size: 0.8em, raw(read("/code/3b.R"), lang: "R", block: true)),
  caption: "Developed code",
)

#pagebreak()

#indent_par[After running the developed script, we obtained the following results, presented in figures 9 and 10:]

#grid(
  columns: (1fr, 1fr),
  pad(1em, figure(
    image("/output/3b-aloha10.svg", width: 100%),
    caption: [Simulated performance of slotted ALOHA (N = 10)]
  )),
  pad(1em, figure(
    image("/output/3b-aloha25.svg", width: 100%),
    caption: [Simulated Performance of slotted ALOHA (N = 25)]
  )),
)

#indent_par[As we use the same scale for both the theoretical graphs (Figures 7 and 8) and simulated graphs (Figures 9 and 10, respectively), we can compare them side by side to get an idea of whether or not they are similar. By performing this comparison, we conclude that all graphs are very similar, except for the graph with $N = 25$ and $p = 0.3$, which has the drop-off occur a fair bit later, and is quite noisy compared to the others.]

==== c.

#indent_par[The slotted ALOHA system has each user have a certain state, _THINKING_ or _BACKLOGGED_, and depending on the state, they have a certain probability of sending their message. When successfully sending it, they set themselves as _THINKING_, otherwise if two or more users sent a packet in the same time slot, they both return to _BACKLOGGED_.]

#indent_par[On the other hand, the CSMA system works by having each user sense if the line is idle or busy. If it's busy, they wait until sensing it idle, then they send their packet fully.]

#indent_par[Adding onto CSMA, CSMA/CD has each user check for collisions during transmission, backing off for a random period if a collision occurs.]

#indent_par[Examples of technologies that use these systems are:]

- ALOHA: RFID tags.
- CSMA/CD: Ethernet protocol.

#indent_par[Given that CSMA is easily outperformed by CSMA/CD, without adding much complexity, we could not find any relevant technologies that used it.]

#pagebreak()
