#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[Figure 13 shows the average delay as a function of the stopping condition for system loads $ρ$ equal to 0.5, 1 and 2.]

#indent_par[We've chosen to include $ρ = 0.5$ to serve as a comparison against the other values.]

#figure(
  image("/output/6.svg", width: 80%),
	caption: "Average delay as a function of the stopping condition"
)

#indent_par[The y-axis is on a log-scale, because the function grows very rapidly, for certain values we'll discuss shortly. There also exists a ribbon around each value, representing 95% confidence intervals for the average delay.]

#indent_par[To calculate the confidence intervals, we perform 50 rounds of the simulator.]

#indent_par[For $ρ = 0.5$, the average delay is constant as the stopping condition grows, indicating this is a stable system.]

#indent_par[For $ρ = 1$ and $ρ = 2$, the average delay increases without bound as the stopping condition grows. This indicates these systems are unstable, with $ρ = 2$ being more unstable than $ρ = 1$.]

#indent_par[As a fun note, another difference between $ρ = 1$ and $ρ = 2$ is that the former has a huge confidence interval, while the latter's is very tight around the mean. This implies that as the system becomes more unstable, the run-to-run variance decreases.]

#pagebreak()
