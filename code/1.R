library(ggplot2)
library(gridExtra)

simulate <- function(alpha, beta, output_file) {
  # 2-DTMC transition matrix
  p <- matrix(
    c(
      c(alpha, 1 - alpha),
      c(beta, 1 - beta)
    ),
    nrow = 2,
    ncol = 2,
    byrow = TRUE
  )

  # DTMC mean
  p_avg <- p[1, 2] / (1 + p[2, 1] - p[1, 1])

  points_len <- 200

  # 2-DTMC simulation
  points1 <- c()
  current_state <- 0
  for (i in 1:points_len) {
    # Extracts probability of transition to same state
    prob <- p[current_state + 1, current_state + 1]

    # Changes state if no success
    if (rbinom(1, 1, prob) == 0) {
      current_state <- (current_state + 1) %% 2
    }

    points1[length(points1) + 1] <- current_state
  }

  # Bernoulli process simulation
  points2 <- lapply(1:points_len, function(...) rbinom(1, 1, p_avg))
  points2 <- unlist(points2)

  # Organize into data frames
  data1 <- data.frame(x = seq_along(points1), y = points1)
  data2 <- data.frame(x = seq_along(points2), y = points2)

  p1 <- ggplot(data1) +
    geom_point(aes(.data$x, .data$y)) +
    scale_y_continuous("2-DTMC")
  p2 <- ggplot(data2) +
    geom_point(aes(.data$x, .data$y)) +
    scale_y_continuous("Bernoulli")
  p3 <- grid.arrange(p1, p2, ncol = 1)
  ggsave(p3, file = output_file, device = "svg")
}

set.seed(0)
pdf(NULL)
simulate(0.1, 0.1, "output/1a (α=0.1, β=0.1).svg")
simulate(0.5, 0.5, "output/1a (α=0.5, β=0.5).svg")
simulate(0.9, 0.9, "output/1a (α=0.9, β=0.9).svg")
simulate(0.9, 0.1, "output/1b (α=0.9, β=0.1).svg")
