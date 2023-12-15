#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx
#import "/typst/util.typ" as util: indent_par, code_figure

==== a.

#let results = csv("/output/8a.csv", delimiter: "\t")

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
		[ #results.at(1).at(0) .. #results.at(1).at(1) ],
		[ #results.at(1).at(2) ],
		[ #results.at(1).at(3) ],

		rowspanx(2)[ `M/G/1` ],
		[ 1 ], [ 0.9 ], [ 11 ], [ 0.1 ],
		[ #results.at(1).at(4) .. #results.at(1).at(5) ],
		[ #results.at(1).at(6) ],
		[ #results.at(1).at(7) ],

		[ 1 ], [ 0.99 ], [ 101 ], [ 0.01 ],
		[ #results.at(1).at(8) .. #results.at(1).at(9) ],
		[ #results.at(1).at(10) ],
		[ #results.at(1).at(11) ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[The simulated average delay results line up quite well with the calculated theoretical ones, with all values inside of the confidence interval.]

#indent_par[We can also conclude that the higher the workload variability ($C^2$), the higher the average delay experienced by the system.]
