#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[To estimate the transition probabilities, we traverse the data, two points at a time, as shown on figure 6. This allows us to check the transition of each data point and store it in an occurrences matrix, as we traverse.]

#figure(
  ```
  Data:        0 0 1 1 0 0 0 1 0
  Iteration 1: 0 0                   Transition: 0 -> 0
  Iteration 2:   0 1                 Transition: 0 -> 1
  Iteration 3:     1 1               Transition: 1 -> 1
  Iteration 4:       1 0             Transition: 1 -> 0
  Iteration 5:         0 0           Transition: 0 -> 0
  Iteration 6:           0 0         Transition: 0 -> 0
  Iteration 7:             0 1       Transition: 0 -> 1
  Iteration 8:               1 0     Transition: 1 -> 0
  ...
  ```,
  kind: image,
  caption: "Data traversal"
)

#pagebreak()

#indent_par[Afterwards, we can divide each row by the number of occurrences in that row to obtain the transition probability matrix. The following code 1 is the code we developed to accomplish this:]

#code_figure(
  text(size: 1.0em, raw(read("/code/2.R"), lang: "R", block: true)),
  caption: "Developed code",
)

#indent_par[The following tables 1 and 2 contain our results:]

#let occur_matrix = csv("/output/2-occur.csv", delimiter: "\t")
#let prob_matrix = csv("/output/2-prob.csv", delimiter: "\t")
#grid(
  columns: (1fr, 1fr),
  figure(
    pad(1em, text(size: 1.8em, math.mat(
      gap: 1em,
      ..occur_matrix
    ))),
    kind: table,
    caption: "Occurrences matrix"
  ),
  figure(
    pad(1em, text(size: 1.8em, math.mat(
      gap: 1em,
      ..prob_matrix
    ))),
    kind: table,
    caption: "Transition probability matrix"
  )
)

#pagebreak()
