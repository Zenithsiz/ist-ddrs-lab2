#import "/typst/util.typ" as util: indent_par

#indent_par[The 2-DTMC process, illustrated in figure 1, is capable of performing both what the Bernoulli process can, as well as another interesting behavior.]

#figure(
  image("/output/1.svg", width: 50%),
  caption: [2-DTMC process]
)

#indent_par[α, β are the state transition probabilities. For example, state 0 has probability $α$ of staying in state 0, and probability $1 - α$ of moving to state 1. Meanwhile, state 1 has probability $1 - β$ of staying in state 1 and probability $β$ of moving to state 0.]

#indent_par[Based on the professor's code in `dtmc_bernoulli_plot.R`, we've created graphs to illustrate the different behaviors exhibited by the 2-DTMC.]

==== a. Interesting behavior

#indent_par[When the α and β parameters are on opposite sides of the spectrum (such as α close to 0.0 and β close to 1.0, or vice-versa), the 2-DTMC process exhibits an interesting behavior, shown in figure 2:]

#figure(
  image("/output/1b (α=0.9, β=0.1).svg", width: 80%),
  caption: [2-DTMC and Bernoulli processes (α=0.9, β=0.1)]
)

#indent_par[Unlike the Bernoulli process, for which each event is independent of the previous, the 2-DTMC "remembers" its previous state, ensuring that both states are very stable, not wanting to transition to the other one, leading to this interesting behavior.]

#pagebreak()

==== b. Bernoulli-like behavior

#indent_par[When the α and β parameters are about equal, the 2-DTMC process performs almost exactly as the Bernoulli process, as shown in figures 3, 4 and 5.]

#grid(
  columns: (1fr, 1fr, 1fr),
  pad(1em, figure(
    image("/output/1a (α=0.1, β=0.1).svg", width: 100%),
    caption: [2-DTMC and Bernoulli processes (α=0.1, β=0.1)]
  )),
  pad(1em, figure(
    image("/output/1a (α=0.5, β=0.5).svg", width: 100%),
    caption: [2-DTMC and Bernoulli processes (α=0.5, β=0.5)]
  )),
  pad(1em, figure(
    image("/output/1a (α=0.9, β=0.9).svg", width: 100%),
    caption: [2-DTMC and Bernoulli processes (α=0.9, β=0.9)]
  ))
)

#indent_par[When α and β are close to 0.0 or 1.0, one of the states will become very stable while the other state will become very unstable, quickly wanting to transition to the other state.]

#indent_par[When α and β are close to 0.5, both states are very unstable.]

#indent_par[The existence of one or more unstable states implies that the system can no longer as easily "remember" its previous state and thus the probability of finding the system in a given state can now be approximated by a Bernoulli process.]
