#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx
#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[The following figure 23, from the guide, is the network we'll be using for this exercise:]

#figure(
  image("/images/16-diagram.png", width: 75%),
	caption: "Network diagram"
)

==== a.

#indent_par[Our first approach consisted of a simple approach using the smallest number of links per flow, and then increasing the link capacities one by one until we achieved the desired blocking probability. We have detailed it in the following tables 25 and 26, and the results in table 27:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,

		[ Flow ],
		[ Path ],

		[1], [$1 -> 2$],
		[2], [$2 -> 3$],
		[3], [$1 -> 2 -> 3$],
	)),
	kind: table,
	caption: [Flow paths (Approach 1)]
)

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,

		[ Link ],
		[ Capacity ($"circuits"$) ],

		[$1 <-> 2$], [5],
		[$1 <-> 4$], [0],
		[$2 <-> 3$], [5],
		[$2 <-> 4$], [0],
		[$3 <-> 4$], [0],
	)),
	kind: table,
	caption: [Link capacities (Approach 1)]
)

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto),
		align: center + horizon,

		[ Flow ],
		[ Blocking probability ($%$) ],
		[ Total cost ($€$) ],

		[1], [0.3049],
		rowspanx(3)[ 5000 ],
		[2], [0.3049],
		[3], [0.6088],
	)),
	kind: table,
	caption: [Results (Approach 1)]
)

#pagebreak()

#indent_par[In our second approach, we determined that having the 3rd flow not share the circuits of the 1st and 2nd flows was desireable, especially since the links $1 -> 4$ and $4 -> 3$ are the cheapest, at only $100€$ per circuit. Again, we started from 0 circuits in each link, and increased them until we had the desired blocking percentages. We've detailed the approach in tables 28 and 29, and the results in table 30.]

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,

		[ Flow ],
		[ Path ],

		[1], [$1 -> 2$],
		[2], [$2 -> 3$],
		[3], [$1 -> 4 -> 3$],
	)),
	kind: table,
	caption: [Flow paths (Approach 2)]
)

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,

		[ Link ],
		[ Capacity ($"circuits"$) ],

		[$1 <-> 2$], [4],
		[$1 <-> 4$], [4],
		[$2 <-> 3$], [4],
		[$2 <-> 4$], [0],
		[$3 <-> 4$], [4],
	)),
	kind: table,
	caption: [Link capacities (Approach 2)]
)

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto),
		align: center + horizon,

		[ Flow ],
		[ Blocking probability ($%$) ],
		[ Total cost ($€$) ],

		[1], [0.1580],
		rowspanx(3)[ 4800 ],
		[2], [0.1580],
		[3], [0.3140],
	)),
	kind: table,
	caption: [Results (Approach 2)]
)

#pagebreak()

#indent_par[In our third and final approach, we determined that the link $1 -> 2$ was very expensive, and considered whether it'd be worth to instead use the links $1 -> 4$, $4 -> 3$ and $3 -> 2$ instead. We briefly considered $1 -> 4$ and $4 -> 2$, but this link is very expensive and not used by any other flow, so it was likely not worth it. Again, we started from 0 circuits in each link, and increased them until we had the desired blocking percentages. We've detailed the approach in tables 31 and 32, and the results in table 33.]

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,

		[ Flow ],
		[ Path ],

		[1], [$1 -> 4 -> 3 -> 2$],
		[2], [$2 -> 3$],
		[3], [$1 -> 4 -> 3$],
	)),
	kind: table,
	caption: [Flow paths (Approach 3)]
)

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,

		[ Link ],
		[ Capacity ($"circuits"$) ],

		[$1 <-> 2$], [0],
		[$1 <-> 4$], [5],
		[$2 <-> 3$], [5],
		[$2 <-> 4$], [0],
		[$3 <-> 4$], [5],
	)),
	kind: table,
	caption: [Link capacities (Approach 3)]
)

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto),
		align: center + horizon,

		[ Flow ],
		[ Blocking probability ($%$) ],
		[ Total cost ($€$) ],

		[1], [0.9028],
		rowspanx(3)[ 3500 ],
		[2], [0.3031],
		[3], [0.6016],
	)),
	kind: table,
	caption: [Results (Approach 3)]
)

#indent_par[Despite fiddling around more, we couldn't find any better approaches, and thus our best result was $3500 €$.]

#pagebreak()

==== b.

#indent_par[We used the following parameters for the simulation:]

- ```R
LinkCapacities <<- c(0, 5, 5, 0, 5)
```

- ```R
Flows <<- list(
  list(duration = 1, rate = 0.5, bwd = 1, route = c(2, 5, 3)),
  list(duration = 1, rate = 0.5, bwd = 1, route = c(3)),
  list(duration = 1, rate = 0.5, bwd = 1, route = c(2, 5))
)
```

- ```R
endTime <<- 10000 * (1 / 0.5)
```

#indent_par[Finally, we obtained the following results in table 34, after running the `cnet` simulator 10 times and calculating 95% confidence intervals:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,


		[ Flow ],
		[ Blocking probability ($%$) ],

		[1], [ 0.514 .. 0.626 ],
		[2], [ 0.236 .. 0.327 ],
		[3], [ 0.276 .. 0.380 ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[The simulation results are more trustful, since our previous approach in exercise 16.a is just an approximation.]

==== c.

#indent_par[After running the `prodbound` script, we obtained the following results in table 35:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto),
		align: center + horizon,


		[ Flow ],
		[ Blocking probability ($%$) ],

		[1], [ 0.9174 ],
		[2], [ 0.3067 ],
		[3], [ 0.6126 ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[From the results, we see that the results are higher than the `cnet` simulated results. This is to be expected, since the product bound is an estimate of the upper bound of the expected results. Since both the number of links our flows cross and our blocking probabilities are small, the product bound still produces a similar result to the simulation.]
