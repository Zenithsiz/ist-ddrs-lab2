#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx
#import "/typst/util.typ" as util: indent_par, code_figure

==== a.

#let results_a = csv("/output/8a.csv", delimiter: "\t")

#indent_par[The following table 15 contains the results of the script. The simulated results have been run 10 times, and are displayed as a confidence interval of 95%.]

#figure(
	pad(1em, tablex(
		columns: (0.6fr, auto, auto, auto, auto, auto, 1.5fr, 1fr, 1fr),
		align: center + horizon,

		rowspanx(2)[ System ],
		rowspanx(2)[ $ρ$ ],
		rowspanx(2)[ $S_1$ ],
		rowspanx(2)[ $p_1$ ],
		rowspanx(2)[ $S_2$ ],
		rowspanx(2)[ $p_2$ ],
		[ Simulated ],
		colspanx(2)[ Theoretical ],

		[ Average delay ],
		[ Average delay ],
		[ $C^2$ ],


		[ `M/M/1` ],
		rowspanx(3)[ 0.5 ],
		colspanx(4)[ N/A ],
		[ #results_a.at(1).at(0) .. #results_a.at(1).at(1) ],
		[ #results_a.at(1).at(2) ],
		[ #results_a.at(1).at(3) ],

		rowspanx(2)[ `M/G/1` ],
		[ 1 ], [ 0.9 ], [ 11 ], [ 0.1 ],
		[ #results_a.at(1).at(4) .. #results_a.at(1).at(5) ],
		[ #results_a.at(1).at(6) ],
		[ #results_a.at(1).at(7) ],

		[ 1 ], [ 0.99 ], [ 101 ], [ 0.01 ],
		[ #results_a.at(1).at(8) .. #results_a.at(1).at(9) ],
		[ #results_a.at(1).at(10) ],
		[ #results_a.at(1).at(11) ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[The simulated average delay results line up quite well with the calculated theoretical ones, with all values inside of the confidence interval.]

#indent_par[We can also conclude that the higher the workload variability ($C^2$), the higher the average delay experienced by the system.]

==== b.

#let results_b = csv("/output/8b.csv", delimiter: "\t")

#indent_par[The following code 9 contains our approach to calculate the variance. The functions `calc_stats_mm1` and `calc_stats_mg1` simulate the corresponding systems and return a list where `$avg_delay` contains the simulated average delay.]

#code_figure(
  text(size: 0.8em, raw(read("/code/8b-report.R"), lang: "R", block: true)),
  caption: "Code for calculating the variance of the systems",
)

#indent_par[The following table 16 contains the results to our approach:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto, auto, auto, auto, auto, auto),
		align: center + horizon,

		[ System ],
		[ $ρ$ ],
		[ $S_1$ ],
		[ $p_1$ ],
		[ $S_2$ ],
		[ $p_2$ ],
		[ Variance ],
		[ $C^2$ ],

		[ `M/M/1` ],
		rowspanx(3)[ 0.5 ],
		colspanx(4)[ N/A ],
		[ #results_b.at(1).at(0) ],
		[ #results_a.at(1).at(3) ],

		rowspanx(2)[ `M/G/1` ],
		[ 1 ], [ 0.9 ], [ 11 ], [ 0.1 ],
		[ #results_b.at(1).at(1) ],
		[ #results_a.at(1).at(7) ],

		[ 1 ], [ 0.99 ], [ 101 ], [ 0.01 ],
		[ #results_b.at(1).at(2) ],
		[ #results_a.at(1).at(11) ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[We've included the workload variability from the previous exercise as the column $C^2$ to compare against. We can thus conclude that the variance and variability are correlated.]

#indent_par[This makes sense, as, despite our _elephants_ occurring less often, their larger size ensures that the users that come after them have a much higher average queue delay, which in turn increases the variance of the system.]

==== c.

#let results_c = csv("/output/8c.csv", delimiter: "\t")

#indent_par[In our current implementation, we treat both the _elephants_ and _mice_ the same. _Elephants_ will always have a large size and thus need more time in queue, but this shouldn't affect the _mice_ that can be dispatched quickly.]

#indent_par[To remedy this, we can treat both categories of users differently, by performing *packet scheduling*. In specific, we can use a *strict priority* with _mice_ having a higher priority than the _elephants_. This leads to a higher average delay for the _elephants_, but with the tradeoff of the _mice_ having a much lower average delay.]

#indent_par[To be able to calculate exactly whether this tradeoff is valuable, we can use the following formulas 11 through 15 to calculate the average queuing delay for each type of user:]

$ λ_1 = p_1 dot λ $
$ λ_2 = p_2 dot λ $

$ W_"q1" = (λ_1 s_1^2 + λ_2 s_2^2) / (2 (1 - λ_1 s_1)) $
$ W_"q2" = (λ_1 s_1^2 + λ_2 s_2^2) / (2 (1 - λ_1 s_1) (1 - λ_1 s_1 - λ_2 s_2)) $

$ W_q = (λ_1 W_"q1" + λ_2 W_"q2") / (λ_1 + λ_2) $

#indent_par[Where $W_"q1"$ is the average queueing delay of _mice_, $W_"q2"$ is the average queueing delay of _elephants_ and $W_q$ is the total average queueing delay.]

#indent_par[With these formulas in hand, we have computed the values in the following table 17:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto, auto, auto, auto, 1fr, 1fr, 1fr, 1fr),
		align: center + horizon,

		rowspanx(3)[ System ],
		rowspanx(3)[ $ρ$ ],
		rowspanx(3)[ $S_1$ ],
		rowspanx(3)[ $p_1$ ],
		rowspanx(3)[ $S_2$ ],
		rowspanx(3)[ $p_2$ ],
		colspanx(4)[ Average delay ],
		rowspanx(2)[ Standard ],
		colspanx(3)[ Strict priority packet scheduling ],
		[ _mice_ ],
		[ _elephants_ ],
		[ Total ],

		rowspanx(2)[ `M/G/1` ],
		rowspanx(2)[ 0.5 ],
		[ 1 ], [ 0.9 ], [ 11 ], [ 0.1 ],
		[ #results_a.at(1).at(6) ],
		[ #results_c.at(1).at(8) ],
		[ #results_c.at(1).at(9) ],
		[ #results_c.at(1).at(10) ],

		[ 1 ], [ 0.99 ], [ 101 ], [ 0.01 ],
		[ #results_a.at(1).at(10) ],
		[ #results_c.at(2).at(8) ],
		[ #results_c.at(2).at(9) ],
		[ #results_c.at(2).at(10) ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[The average delay of the _mice_ is now considerably lower than before. The _elephants_' average delay rose about as much as the _mice_'s lowered, but given that we have many more _mice_ than _elephants_, this is a valuable tradeoff, which can be further reinforced by looking at the average total, which is lower in general, by a considerable amount.]

#pagebreak()
