#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx
#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[The following code 10 is our implementation of the kleinrock approximation. It takes the link capacities, flows and packet size similarly to the `pnet` simulator.]

#code_figure(
  text(size: 0.8em, raw(read("/code/kleinrock.R"), lang: "R", block: true)),
  caption: "Code for Kleinrock approximation",
)

#indent_par[To test the simulator, we've used the following network from the course slides (`pktnet`, page 14).]

#figure(
  image("/images/13-diagram.png", width: 75%),
	caption: "3-DTMC"
)

#pagebreak()

#indent_par[We developed the following code 11 to test our implementation and obtained the results in table 18:]

#code_figure(
  text(size: 0.8em, raw(read("/code/13.R"), lang: "R", block: true)),
  caption: "Code for testing the Kleinrock approximation",
)

#figure(
	pad(1em, tablex(
		columns: (auto, 1fr, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ Flow ],
		colspanx(2)[ Average packet delay ($"μs"$) ],
		rowspanx(2)[ Average packets (network) ],

		[ Per flow ],
		[ Network ],

		[1],
		[600],
		rowspanx(3)[644.4],
		rowspanx(3)[14.5],

		[2],
		[800],

		[3],
		[400],

	)),
	kind: table,
	caption: [Results]
)

#indent_par[Our values are the same as calculated manually, and thus we conclude our script is valid.]
