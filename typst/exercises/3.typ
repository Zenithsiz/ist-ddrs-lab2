#import "/typst/util.typ" as util: indent_par

==== a.

#indent_par[]

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
