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

#indent_par[The following code 8 contains out approach to calculate the variance. The functions `calc_stats_mm1` and `calc_stats_mg1` simulate the corresponding systems and return a list where `$avg_delay` contains the simulated average delay.]

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

#indent_par[This makes sense, as despite our _elephants_ occurring less often, their larger size ensures that the users that come after them have a much higher average queue delay, which in turn increases the variance of the system.]

#pagebreak()
