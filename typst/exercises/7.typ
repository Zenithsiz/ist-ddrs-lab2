#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx
#import "/typst/util.typ" as util: indent_par, code_figure

==== a.

#let solution = csv("/output/7a.csv", delimiter: "\t")

#indent_par[The following table 9 depicts the values of $𝜆$ and $𝜇$ chosen]:

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,

		[ λ ], [ μ ],
		[ #solution.at(1).at(0) ], rowspanx(2)[ #solution.at(1).at(1) ],
		[ #solution.at(2).at(0) ],

	)),
	caption: [Chosen values for $𝜆$ and $𝜇$]
)

#indent_par[We first calculated all theoretical values and arrived at the following]:

#figure(
	pad(1em, tablex(
		columns: (auto, 1.5fr, 2fr, 2fr),
		align: center + horizon,


		rowspanx(2)[ λ ],
		rowspanx(2)[ Average delay ($s$) ],
		colspanx(2)[ Throughput ($"bits" dot s^(-1)$) ],
		[ Flow 1 ], [ Flow 2 ],

		[ #solution.at(1).at(0) ],
		[ #solution.at(1).at(2) ],
		[ #solution.at(1).at(3) ],
		[ #solution.at(1).at(4) ],

		[ #solution.at(2).at(0) ],
		[ #solution.at(2).at(2) ],
		[ #solution.at(2).at(3) ],
		[ #solution.at(2).at(4) ],

	)),
	caption: [Theoretical calculations]
)

#indent_par[Finally, for each value, we ran the simulator 20 times, and obtained the following confidence intervals]:

#figure(
	pad(1em, tablex(
		columns: (auto, 1fr, 1fr, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ λ ],
		colspanx(2)[ Average delay ($s$) ],
		colspanx(2)[ Throughput ($"bits" dot s^(-1)$) ],
		[ Flow 1 ], [ Flow 2 ],
		[ Flow 1 ], [ Flow 2 ],

		[ #solution.at(1).at(0 ) ],
		[ #solution.at(1).at(5 ) .. #solution.at(1).at(6 ) ],
		[ #solution.at(1).at(7 ) .. #solution.at(1).at(8 ) ],
		[ #solution.at(1).at(9 ) .. #solution.at(1).at(10) ],
		[ #solution.at(1).at(11) .. #solution.at(1).at(12) ],

		[ #solution.at(2).at(0) ],
		[ #solution.at(2).at(5 ) .. #solution.at(2).at(6 ) ],
		[ #solution.at(2).at(7 ) .. #solution.at(2).at(8 ) ],
		[ #solution.at(2).at(9 ) .. #solution.at(2).at(10) ],
		[ #solution.at(2).at(11) .. #solution.at(2).at(12) ],

	)),
	caption: [Theoretical calculations]
)

#indent_par[We can see that for $λ = #solution.at(1).at(0)$, the values mostly line up with the calculated theoretical ones on both the average delay and throughput.]

#indent_par[However, for $λ = #solution.at(2).at(0)$, although the results still line up with the throughput, the average delay has a much bigger confidence interval, despite the mean still being spot-on.]

#pagebreak()
