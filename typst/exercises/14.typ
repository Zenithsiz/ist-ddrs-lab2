#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx
#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[We used our previously developed Kleinrock script and the `pnet` simulator, running it 10 times and calculating 95% confidence intervals, acquiring the following results in table 18:]

#figure(
	pad(1em, tablex(
		columns: (auto, auto, auto, auto, auto),
		align: center + horizon,


		rowspanx(2)[ ρ ],
		rowspanx(2)[ λ ],
		rowspanx(2)[ μ ],
		colspanx(2)[ Average packet delay ],
		[ Kleinrock ],
		[ `pnet` ],

		[ 0.05 ],
		[ 3.2 ],
		rowspanx(4)[ 64 ],
		[ 0.03289 ],
		[ 0.03315 .. 0.03359 ],

		[ 0.5 ],
		[ 32.0 ],
		[ 0.0625 ],
		[ 0.0636 .. 0.06655 ],

		[ 0.95 ],
		[ 60.8 ],
		[ 0.625 ],
		[ 0.28067 .. 0.43387 ],

		[ 0.975 ],
		[ 62.4 ],
		[ 1.25 ],
		[ 0.45371 .. 0.88948 ],
	)),
	kind: table,
	caption: [Results]
)

#indent_par[Although the Kleinrock approximation never enters the confidence intervals obtained from the `pnet` simulator, for lower values of $ρ$, it is close to the confidence intervals. However for larger values of $ρ$, it starts to drift apart very noticeably.]

#pagebreak()
