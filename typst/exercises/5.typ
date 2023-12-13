#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[Figure 12 represents the 3-DTMC we'll be using for this exercise.]

#figure(
  image("/images/5-diagram.png", width: 50%),
	caption: "3-DTMC"
)

==== (i) Solving the balance equations

#indent_par[The following equations 6, 7, 8 and 9 are our balance equations:]

$ pi_0 λ_00 + pi_1 λ_10 + pi_2 λ_20 = pi_0 λ_00 + pi_0 λ_01 + pi_0 λ_02 $
$ pi_0 λ_01 + pi_1 λ_11 + pi_2 λ_21 = pi_1 λ_10 + pi_1 λ_11 + pi_1 λ_12 $
$ pi_0 λ_02 + pi_1 λ_12 + pi_2 λ_22 = pi_2 λ_20 + pi_2 λ_21 + pi_2 λ_22 $
$ pi_0 + pi_1 + pi_2 = 1 $

#indent_par[Calling $P$ the matrix $mat(λ_00, λ_01, λ_02; λ_10, λ_11, λ_12; λ_20, λ_21, λ_22)$, the 3 first balance equations can be expressed as the following equation 10:]

$
	P^T dot
	mat(
		sum_(j) λ_(0j), 0, 0;
		0, sum_(j) λ_(1j), 0;
		0, 0, sum_(j) λ_(2j);
	)
	= 0
$


#pagebreak()

#indent_par[We can then model this in R using the following code 2:]

#code_figure(
  text(size: 0.8em, raw(read("/code/5-solve.R"), lang: "R", block: true)),
  caption: "Code for solving the balance equations",
)

#indent_par[Like in exercise 4, we need to substitute one of the equations by the 4th balance equation. Doing so, we reach the limiting state probabilities in table 6:]

#let solution = csv("/output/5-solve.csv", delimiter: "\t")
#figure(
	pad(1em, text(size: 1.5em, math.mat(
		gap: 1em,
		..solution
	))),
	kind: table,
	caption: "Limiting state probabilities"
)

#pagebreak()

==== (ii). Simulation using view 1

#indent_par[The following code 4 contains our approach to obtain the limiting state probabilities via simulation implementing the 1st view.]

#code_figure(
  text(size: 0.8em, raw(read("/code/5-sim1.R"), lang: "R", block: true)),
  caption: "Code using simulation view 1",
)

#indent_par[View 1 is similar to how a DTMC works, but before each jump, a state will wait an exponentially distributed amount of time, with rate given by it the transition rate out of it.]

#indent_par[After running the code, we ended up with the results in table 7:]

#let solution = csv("/output/5-sim1.csv", delimiter: "\t")
#figure(
	pad(1em, text(size: 1.5em, math.mat(
		gap: 1em,
		..solution
	))),
	kind: table,
	caption: "Limiting state probabilities"
)

#pagebreak()

==== (iii). Simulation using view 2

#indent_par[The following code 5 contains our approach to obtain the limiting state probabilities via simulation implementing the 2nd view.]

#code_figure(
  text(size: 0.8em, raw(read("/code/5-sim2.R"), lang: "R", block: true)),
  caption: "Code using simulation view 2",
)

#indent_par[View 2 instead elects to have multiple wait times, depending on the transition rate to each other state, then selecting the state with the minimum time out of all generated outputs.]

#indent_par[After running the code, we ended up with the results in table 8:]

#let solution = csv("/output/5-sim2.csv", delimiter: "\t")
#figure(
	pad(1em, text(size: 1.5em, math.mat(
		gap: 1em,
		..solution
	))),
	kind: table,
	caption: "Limiting state probabilities"
)

==== (iv). Results

#indent_par[Both of the results obtained in tables 7 and 8 are very close to the theoretical values presented in table 6.]

#indent_par[This is, in part, because we used a high limit for the maximum time of 100000. This limit impacts the accuracy of the results greatly, with low maximum times have limiting state probabilities that are very far from the theoretical values.]

#pagebreak()
