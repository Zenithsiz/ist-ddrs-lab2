#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[Figure 11 represents the 3-DTMC we'll be using for this exercise.]

#figure(
  image("/images/4-diagram.png", width: 70%),
	caption: "3-DTMC"
)

==== (i) Solving the balance equations

#indent_par[The following equations 1, 2, 3 and 4 are our balance equations:]

$ pi_0 p_00 + pi_1 p_10 + pi_2 p_20 = pi_0 p_00 + pi_0 p_01 + pi_0 p_02 $
$ pi_0 p_01 + pi_1 p_11 + pi_2 p_21 = pi_1 p_10 + pi_1 p_11 + pi_1 p_12 $
$ pi_0 p_02 + pi_1 p_12 + pi_2 p_22 = pi_2 p_20 + pi_2 p_21 + pi_2 p_22 $
$ pi_0 + pi_1 + pi_2 = 1 $

#indent_par[Calling $P$ the matrix $mat(p_00, p_01, p_02; p_10, p_11, p_12; p_20, p_21, p_22)$, the 3 first balance equations can be expressed as the following equation 5:]

$
	P^T dot
	mat(
			sum_(j) p_(0j), 0, 0;
			0, sum_(j) p_(1j), 0;
			0, 0, sum_(j) p_(2j);
	)
	= 0
$

#pagebreak()

#indent_par[We can then model this in R using the following code 3:]

#code_figure(
  text(size: 1.0em, raw(read("/code/4-solve.R"), lang: "R", block: true)),
  caption: "Code for solving the balance equations",
)

#indent_par[To solve the system, the 3 first balance equations aren't enough, we must substitute one of them for the 4th balance equations to ensure the system is solvable. In our case, we substituted the 3rd equation with the 4th. The following table 3 contains our results:]

#let solution = csv("/output/4-solve.csv", delimiter: "\t")
#figure(
	pad(1em, text(size: 1.5em, math.mat(
		gap: 1em,
		..solution
	))),
	kind: table,
	caption: "Limiting state probabilities"
)

#pagebreak()

==== (ii). Matrix multiplication

#indent_par[The following code 4 contains our approach to obtain the limiting state probabilities via matrix multiplication.]

#code_figure(
  text(size: 0.8em, raw(read("/code/4-matrix.R"), lang: "R", block: true)),
  caption: "Code using matrix multiplication",
)

#indent_par[We can simply raise the probability transition matrix by itself numerous times to get a matrix that has our limiting state probabilities in each row.]

#indent_par[To decide how many times we need to raise the matrix, we keep raising it until the difference in each cell from the previous step is less than a certain $ε$. In our case, we used $ε = 10^(-9)$. This process took, in total 22 steps to achieve our desired $ε$, obtaining the limiting state probabilities in table 4:]

#let solution = csv("/output/4-matrix.csv", delimiter: "\t")
#figure(
	pad(1em, text(size: 1.5em, math.mat(
		gap: 1em,
		..solution
	))),
	kind: table,
	caption: "Limiting state probabilities"
)

#indent_par[The results we obtained are equal to the theoretical results calculated in the previous exercise.]

#pagebreak()

==== (iii). Simulation

#indent_par[The following code 5 contains our approach to obtain the limiting state probabilities via simulation.]

#code_figure(
  text(size: 0.8em, raw(read("/code/4-sim.R"), lang: "R", block: true)),
  caption: "Code using simulation",
)

#indent_par[We initialize our current state to 1, then for 100000 rounds, save the current state, calculate the next state and save it to the current.]

#indent_par[To calculate the next state, we generate a uniformly random number in the $[0.0, 1.0]$ interval, and then choose the first index of the cumulative sum of the probabilities that is higher than the number we generated.]

#indent_par[This works because by calculating the cumulative sum of the probabilities, we're calculating its cumulative density function. Then by definition, finding the input for which this function has value $<= x$, for $x ∈ [0.0, 1.0]$ is equal to sampling the original distribution.]

#indent_par[Finally, we get the limiting state probabilities by checking how many states there are out of all the ones we've visited for each state. The output of this process can be seen in table 5:]

#let solution = csv("/output/4-sim.csv", delimiter: "\t")
#figure(
	pad(1em, text(size: 1.5em, math.mat(
		gap: 1em,
		..solution
	))),
	kind: table,
	caption: "Limiting state probabilities"
)

#indent_par[The results aren't exactly equal to the theoretical results, but this is expected, given it's a simulation. However, they are very close to them.]

#pagebreak()
