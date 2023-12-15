#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[We have run the simulator for a range of $ρ ∈ [0.1, 1.5]$, with an interval of $0.1$ and obtained the following graph in figure 14:]

#figure(
	image("/output/9.svg", width: 100%),
	caption: [Results]
)

#indent_par[For stables values of the system ($ρ < 1.0$), both policies are very comparable. However, when the system becomes unstable ($ρ >= 1.0$), the *JSQ* policy outperforms the random policy.]

#pagebreak()
