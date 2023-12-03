require(ggplot2)
require(pracma)

aloha_theoretical <- function(n, prob_backlogged, prob_thinking) {
  mat <- matrix(ncol = n + 1, nrow = n + 1)

  for (i in 0:n) {
    for (j in 0:n) {
      if (j < i - 1) mat[i + 1, j + 1] <- 0
      if (j == i - 1) {
        mat[i + 1, j + 1] <- i * prob_backlogged * (1 - prob_backlogged)^(i - 1) * (1 - prob_thinking)^(n - i)
      }
      if (j == i) {
        mat[i + 1, j + 1] <- (1 - prob_thinking)^(n - i) *
          (1 - i * prob_backlogged * (1 - prob_backlogged)^(i - 1)) +
          (n - i) * prob_thinking * (1 - prob_thinking)^(n - i - 1) * (1 - prob_backlogged)^i
      }
      if (j == i + 1) {
        mat[i + 1, j + 1] <- (n - i) * prob_thinking * (1 - prob_thinking)^(n - i - 1) * (1 - (1 - prob_backlogged)^i)
      }
      if (j > i + 1) mat[i + 1, j + 1] <- choose(n - i, j - i) * prob_thinking^(j - i) * (1 - prob_thinking)^(n - j)
    }
  }

  e <- matrix(rep(1, len = (n + 1)^2), nrow = n + 1)
  i <- diag(n + 1)
  e <- c(rep(1, n + 1))

  pi_vec <- e %*% solve(mat + e - i)

  cth <- vector(length = n + 1)
  for (i in 0:n) {
    cth[i + 1] <- (1 - prob_backlogged)^i * (n - i) * prob_thinking * (1 - prob_thinking)^(n - i - 1) +
      i * prob_backlogged * (1 - prob_backlogged)^(i - 1) * (1 - prob_thinking)^(n - i)
  }

  throughput_theoretical <- sum(pi_vec * cth)

  return(throughput_theoretical)
}

create_graph <- function(slots_len, probs_thinking, probs_backlogged, output_file) {
  throughput <- lapply(probs_backlogged, function(prob_backlogged) {
    sapply(probs_thinking, function(prob_thinking) aloha_theoretical(slots_len, prob_backlogged, prob_thinking))
  })
  prob_names <- lapply(probs_backlogged, function(prob) rep(as.character(prob), length(probs_thinking)))

  throughput_data <- data.frame(
    x = probs_thinking,
    y = unlist(throughput),
    p = unlist(prob_names)
  )
  plot <- ggplot(throughput_data) +
    geom_line(aes(.data$x, .data$y, color = .data$p)) +
    scale_x_log10() +
    xlab("σ") +
    ylab("Throughput")

  ggsave(plot, file = output_file, device = "svg")
}

set.seed(0)
pdf(NULL)
create_graph(10, logseq(1, 1.3, 1000) - 1, c(0.3, 0.4, 0.5, 0.6), "output/3a-aloha10.svg")
create_graph(25, logseq(1, 1.05, 1000) - 1, c(0.2, 0.3), "output/3a-aloha25.svg")
