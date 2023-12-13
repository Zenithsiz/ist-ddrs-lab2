#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx
#import "/typst/util.typ" as util: indent_par, code_figure

==== a.

#let solution = csv("/output/7a.csv", delimiter: "\t")

#indent_par[We first calculated all theoretical values and arrived at the following, in table 10:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, 1.5fr, 2fr, 2fr),
		align: center + horizon,


		rowspanx(2)[ $λ$ ],
		rowspanx(2)[ $μ$ ],
		rowspanx(2)[ Average delay ($s$) ],
		colspanx(2)[ Throughput ($"bits" dot s^(-1)$) ],
		[ Flow 1 ], [ Flow 2 ],

		[ #solution.at(1).at(0) ],
		rowspanx(2)[ #solution.at(1).at(1) ],
		[ #solution.at(1).at(2) ],
		[ #solution.at(1).at(3) ],
		[ #solution.at(1).at(4) ],

		[ #solution.at(2).at(0) ],
		[ #solution.at(2).at(2) ],
		[ #solution.at(2).at(3) ],
		[ #solution.at(2).at(4) ],

	)),
	kind: table,
	caption: [Theoretical calculations]
)

#indent_par[Finally, for each value, we ran the simulator 20 times, and obtained the following confidence intervals, in table 11:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, 1fr, 1fr, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ $λ$ ],
		rowspanx(2)[ $μ$ ],
		colspanx(2)[ Average delay ($s$) ],
		colspanx(2)[ Throughput ($"bits" dot s^(-1)$) ],
		[ Flow 1 ], [ Flow 2 ],
		[ Flow 1 ], [ Flow 2 ],

		[ #solution.at(1).at(0 ) ],
		rowspanx(2)[ #solution.at(1).at(1) ],
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
	kind: table,
	caption: [Simulation results]
)

#indent_par[We can see that for $λ = #solution.at(1).at(0)$, the values mostly line up with the calculated theoretical ones on both the average delay and throughput.]

#indent_par[However, for $λ = #solution.at(2).at(0)$, although the results still line up with the throughput, the average delay has a much bigger confidence interval, despite the mean still being spot-on.]

#pagebreak()

==== b.

#let solution = csv("/output/7b.csv", delimiter: "\t")

#indent_par[The values chosen for $𝜆$ and $𝜇$ are the same as in the previous exercise, to enable us to compare the results:]

#indent_par[The following table 12 are the updated theoretical results:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, 1.5fr, 2fr, 2fr),
		align: center + horizon,


		rowspanx(2)[ $λ$ ],
		rowspanx(2)[ $μ$ ],
		rowspanx(2)[ Average delay ($s$) ],
		colspanx(2)[ Throughput ($"bits" dot s^(-1)$) ],
		[ Flow 1 ], [ Flow 2 ],

		[ #solution.at(1).at(0) ],
		rowspanx(2)[ #solution.at(1).at(1) ],
		[ #solution.at(1).at(2) ],
		[ #solution.at(1).at(3) ],
		[ #solution.at(1).at(4) ],

		[ #solution.at(2).at(0) ],
		[ #solution.at(2).at(2) ],
		[ #solution.at(2).at(3) ],
		[ #solution.at(2).at(4) ],

	)),
	kind: table,
	caption: [Theoretical calculations]
)

#indent_par[Finally, just like in the previous exercise, for each value, we ran the simulator 20 times, and obtained the following confidence intervals, in table 13:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, 1fr, 1fr, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ $λ$ ],
		rowspanx(2)[ $μ$ ],
		colspanx(2)[ Average delay ($s$) ],
		colspanx(2)[ Throughput ($"bits" dot s^(-1)$) ],
		[ Flow 1 ], [ Flow 2 ],
		[ Flow 1 ], [ Flow 2 ],

		[ #solution.at(1).at(0 ) ],
		rowspanx(2)[ #solution.at(1).at(1) ],
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
	kind: table,
	caption: [Simulation results]
)

#indent_par[Similarly to the previous exercise, for $λ = #solution.at(1).at(0)$, the values line up quite well, but for $λ = #solution.at(2).at(0)$, we see some deviation on the average delay. In this case the deviation is so strong the confidence intervals don't even include the theoretical value.]

#indent_par[When comparing this approach, using fixed packet sizes, against the previous, with exponentially distributed packet size, we see that the average delays are much smaller. This implies that, despite the mean being the same, the net negative effect of the larger packets outweighs the positive effect of the smaller packets that the exponential distribution yields.]

#pagebreak()

==== c.

#let solution = csv("/output/7c.csv", delimiter: "\t")

#indent_par[]

#indent_par[The following table 14 are the updated theoretical results:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto, 1fr, 1fr, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ $λ_1$ ],
		rowspanx(2)[ $λ_2$ ],
		rowspanx(2)[ $μ$ ],
		colspanx(2)[ Average delay ($s$) ],
		colspanx(2)[ Throughput ($"bits" dot s^(-1)$) ],
		[ Flow 1 ], [ Flow 2 ],
		[ Flow 1 ], [ Flow 2 ],

		[ #solution.at(1).at(0) ],
		[ #solution.at(1).at(1) ],
		[ #solution.at(1).at(2) ],

		[ #solution.at(1).at(3) ],
		[ #solution.at(1).at(4) ],
		[ #solution.at(1).at(5) ],
		[ #solution.at(1).at(6) ],

	)),
	kind: table,
	caption: [Theoretical calculations]
)

#indent_par[Finally, just like in the previous 2 exercises, for each value, we ran the simulator 20 times, and obtained the following confidence intervals, in table 15:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto, 1fr, 1fr, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ $λ_1$ ],
		rowspanx(2)[ $λ_2$ ],
		rowspanx(2)[ $μ$ ],
		colspanx(2)[ Average delay ($s$) ],
		colspanx(2)[ Throughput ($"bits" dot s^(-1)$) ],
		[ Flow 1 ], [ Flow 2 ],
		[ Flow 1 ], [ Flow 2 ],

		[ #solution.at(1).at(0) ],
		[ #solution.at(1).at(1) ],
		[ #solution.at(1).at(2) ],

		[ #solution.at(1).at(7 ) .. #solution.at(1).at(8 ) ],
		[ #solution.at(1).at(9 ) .. #solution.at(1).at(10) ],
		[ #solution.at(1).at(11) .. #solution.at(1).at(12) ],
		[ #solution.at(1).at(13) .. #solution.at(1).at(14) ],
	)),
	kind: table,
	caption: [Simulation results]
)

// TODO: Compare with a. and b.
