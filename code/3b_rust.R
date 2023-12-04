require(ggplot2)
require(pracma)

data <- read.csv("output/3b.csv")
data <- data[with(data, order(data$p, data$s)), ]

create_graph <- function(slots_len, probs_thinking, probs_backlogged, output_file) {
  throughput <- subset(data, data$N == slots_len)$t
  prob_names <- lapply(probs_backlogged, function(prob) rep(as.character(prob), length(probs_thinking)))

  throughput_data <- data.frame(
    x = probs_thinking,
    y = unlist(throughput),
    p = unlist(prob_names)
  )
  plot <- ggplot(throughput_data) +
    geom_line(aes(.data$x, .data$y, color = .data$p)) +
    scale_x_log10(limit = c(0.0005, 0.3)) +
    ylim(0.0, 0.4) +
    xlab("σ") +
    ylab("Throughput")

  ggsave(plot, file = output_file, device = "svg")
}

set.seed(0)
pdf(NULL)
create_graph(10, logseq(1 + 1e-7, 1.3, 1000) - 1, c(0.3, 0.4, 0.5, 0.6), "output/3b-aloha10.svg")
create_graph(25, logseq(1 + 1e-7, 1.3, 1000) - 1, c(0.2, 0.3), "output/3b-aloha25.svg")
