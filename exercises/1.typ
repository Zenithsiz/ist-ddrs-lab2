#import "/util.typ" as util: indent_par

#indent_par[The 2-DTMC process is capable of performing both what the Bernoulli process can, as well as another interesting behavior]

#figure(
  image("/diagrams/1.svg", width: 50%),
  caption: [2-DTMC process]
)

==== a. Interesting behavior

#indent_par[When the α and β parameters are on opposite sides of the spectrum, the 2-DTMC process exhibits an interesting behavior:]

#figure(
  image("/images/1b (α=0.9, β=0.1).svg", width: 50%),
  caption: [2-DTMC and Bernoulli processes (α=0.9, β=0.1)]
)

#indent_par[Unlike the Bernoulli process, the 2-DTMC "remembers" it's previous state, ensuring that both states are very stable, not wanting to transition to the other side.]

#pagebreak()

==== b. Bernoulli-like behavior

#indent_par[When the α and β parameters are equal, the 2-DTMC process performs almost exactly as the Bernoulli process:]

#grid(
  columns: (1fr, 1fr, 1fr),
  figure(
    image("/images/1a (α=0.1, β=0.1).svg", width: 80%),
    caption: [2-DTMC and Bernoulli processes (α=0.1, β=0.1)]
  ),
  figure(
    image("/images/1a (α=0.5, β=0.5).svg", width: 80%),
    caption: [2-DTMC and Bernoulli processes (α=0.5, β=0.5)]
  ),
  figure(
    image("/images/1a (α=0.9, β=0.9).svg", width: 80%),
    caption: [2-DTMC and Bernoulli processes (α=0.9, β=0.9)]
  )
)

#indent_par[When α and β are close to 0.0 or 1.0, one of the states will become very stable while the other state will become very unstable, quickly wanting to transition to the other state.]

#indent_par[When α and β are close to 0.5, both states are very unstable.]

#indent_par[The existence of one or more unstable states imply that the system can no longer as easily "remember" it's previous state and thus the probability of finding the system in a given state can now be approximated by a bernoulli process]
