#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx
#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[Using the following network in figure 22, adapted from the guide, we define the link numbers and routes in the following colors:]

- Flow 1: Red
- Flow 2: Green
- Flow 3: Blue
- Flow 4: Cyan

#figure(
  image("/images/15-diagram.png", width: 75%),
	caption: "Network diagram"
)

==== a. Kleinrock

#indent_par[Using the previously developed Kleinrock script, we obtained the following results in table 20:]

#figure(
	pad(1em, tablex(
		columns: (auto, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ Flow ],
		colspanx(2)[ Average packet delay ($"ms"$) ],

		[ Per flow ],
		[ Network ],

		[1],
		[73.2],
		rowspanx(4)[44.36],

		[2],
		[31.2],

		[3],
		[39.1],

		[4],
		[7.81],

	)),
	kind: table,
	caption: [Results]
)

#pagebreak()

==== b.

#indent_par[We ran the `pnet` simulator 10 times, calculating 95% confidence intervals, and obtained the results in table 21:]

#indent_par[The network average packet delay was calculated from each flow's average delay via the following formula:]

$ W = (sum_i λ_i W_i) / (sum_j λ_j) $

#indent_par[We used the following parameters for the simulation:]

- ```R
LinkCapacities <- replicate(7, 256 * 1000)
```
- ```R
Flows <- list(
  list(rate = 215, packetsize = packet_size, route = c(1, 3, 6)),
  list(rate = 64, packetsize = packet_size, route = c(2, 5)),
  list(rate = 128, packetsize = packet_size, route = c(2, 5, 7)),
  list(rate = 128, packetsize = packet_size, route = c(4))
)
```
- ```R
endTime <- 10000 * (1 / 64) # 156.25
```

#figure(
	pad(1em, tablex(
		columns: (auto, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ Flow ],
		colspanx(2)[ Average packet delay ($"ms"$) ],

		[ Per flow ],
		[ Network ],

		[1],
		[53.64 .. 57.33],
		rowspanx(4)[ 35.30 .. 37.15 ],

		[2],
		[27.96 .. 28.80],

		[3],
		[35.80 .. 36.72],

		[4],
		[7.66 .. 7.84],
	)),
	kind: table,
	caption: [Results]
)

#pagebreak()

==== c.

#indent_par[In order to determine the optimal bifurcation path, we first determine that the flow through the link $2 -> 4$ and $2 -> 5$ must be equal. Given that the flow 4 already uses the link $2 -> 5$, we must account for it in the calculations.]

#indent_par[With this in mind, we reach the following equation system 17, where $l_24$ is the flow through link $2 -> 4$ and $l_25$ is the flow through link $2 -> 5$]

$ cases( l_24 + l_25 = 215, l_24 = l_25 + 128 ) $

#indent_par[Solving these, we reach $l_24 = 171.5$ and $l_25 = 43.5$]

#indent_par[In order to compare against our results in exercise 15.a, we used the Kleinrock script and got the following results in table 22.]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, 1fr, 1fr),
		align: center + horizon,


		rowspanx(2)[ Flow ],
		rowspanx(2)[ Bifurcation ],
		colspanx(2)[ Average packet delay ($"ms"$) ],

		[ Per flow ],
		[ Network ],

		rowspanx(2)[1],
		[1],
		rowspanx(2)[48.1],
		rowspanx(5)[36.19],

		[2],

		[2],
		rowspanx(3)[ N/A ],
		[31.2],

		[3],
		[43.1],

		[4],
		[11.8],

	)),
	kind: table,
	caption: [Results]
)

#indent_par[We can be sure that we have obtained the optimal bifurcation, because the average packet delay for each bifurcated flow has the same value. We also see that flow 2 was not affected at all, since flow 1 does not cross it on any of it's path or bifurcations. However, flow 3 and flow 4 have both been slightly affected due to the 2nd bifurcation of flow 1 passing through them. This is to be expected, as we are pushing more packets through the same links. Overall, the network average packet delay is lower, despite the increases to flow 3 and 4, due to flow 1 now having much lower delays.]

#pagebreak()

==== d.

#indent_par[We used the following parameters for the simulation of `bg.R`:]

- #text(size: 0.7em, ```R
LinkCapacities <<- matrix(
	c(
		0, 256e3, 256e3, 0    , 0    , 0,
		0, 0    , 0    , 256e3, 256e3, 0,
		0, 0    , 0    , 0    , 256e3, 0,
		0, 0    , 0    , 0    , 0    , 256e3,
		0, 0    , 0    , 0    , 0    , 256e3,
		0, 0    , 0    , 0    , 0    , 0
	),
	nrow = 6,
	ncol = 6,
	byrow = TRUE
)
```)
- #text(size: 0.7em, ```R
Flows <<- matrix(
	c(
		1, 6, 215e3 + 128e3,
		1, 5, 64e3,
		2, 5, 128e3
	),
	nrow = 3,
	ncol = 3,
	byrow = TRUE
)
```)

#indent_par[Then obtained the results from the `bg.R` script in the following table 23:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto),
		align: center + horizon,


		[ Flow ],
		[ Rate ($"bits" s^(-1)$) ],
		[ Rate ($"packets" s^(-1)$) ],

		[ $1 -> 2 -> 4 -> 6$ ], [ 170168 ], [ 170.168 ],
		[ $1 -> 3 -> 5 -> 6$ ], [ 172832 ], [ 172.832 ],
		[ $1 -> 2 -> 5 -> 6$ ], [ 0 ], [ 0 ],
		[ $1 -> 2 -> 5$ ], [ 39218 ], [ 39.218 ],
		[ $1 -> 3 -> 5$ ], [ 24782 ], [ 24.782 ],
		[ $2 -> 5$ ], [ 128000 ], [ 128.000 ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[Finally, using our previously developed Kleinrock script to get the following results in table 24:]

#figure(
	pad(1em, tablex(
		columns: (auto, 1fr, 1fr, 1fr),
		align: center + horizon,


		colspanx(2, rowspanx(2)[ Flow ]),
		colspanx(2)[ Average packet delay ($"ms"$) ],

		[ Per flow ],
		[ Network ],

		[1], [ $1 -> 2 -> 4 -> 6$ ], [ 44.8 ],
		rowspanx(5)[ 35.87 ],

		[2], [ $1 -> 3 -> 5 -> 6$ ], [ 46.3 ],
		[3], [ $1 -> 2 -> 5$ ], [ 32.7 ],
		[4], [ $1 -> 3 -> 5$ ], [ 34.3 ],
		[5], [ $2 -> 5$ ], [ 11.3 ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[Comparing with our previous attempt at bifurcation in exercise 15.c, we see an small overall improvement to the network average packet delay. The gradient projection algorithm discovered 2 new flows we hadn't used, namely $1 -> 3 -> 5 -> 6$ and $1 -> 2 -> 5$. Despite outputting the flow $1 -> 2 -> 5 -> 6$, it has no rate, so we did not include it in the kleinrock script.]
