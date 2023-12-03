#import "/util.typ" as util: indent_par

#indent_par[To estimate the transition probabilities, we traverse the data a pair at a time. This allows us to check the transition of each data point and store it in an occurrences matrix.]

#indent_par[Afterwards, we can divide each row by the number of occurrences in that row to obtain the transition probability matrix]

#indent_par[The following were our results:]

#let occur_matrix = csv("/output/2-occur.csv", delimiter: "\t")
#let prob_matrix = csv("/output/2-prob.csv", delimiter: "\t")
#grid(
  columns: (1fr, 1fr),
  figure(
    pad(1em, math.mat(
      delim: "[",
      gap: 1em,
      ..occur_matrix
    )),
    kind: table,
    caption: "Occurrences matrix"
  ),
  figure(
    pad(1em, math.mat(
      delim: "[",
      gap: 1em,
      ..prob_matrix
    )),
    kind: table,
    caption: "Transition probability matrix"
  )
)
