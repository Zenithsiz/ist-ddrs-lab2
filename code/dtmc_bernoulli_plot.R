library(ggplot2)
library(gridExtra)

# Input parameters
alpha <- 0.9
beta <- 0.1

# 2-DTMC transition matrix
p <- matrix(c(alpha, 1 - alpha, beta, 1 - beta),
  nrow = 2,
  ncol = 2,
  byrow = TRUE
)
# DTMC mean
p_avg <- p[1, 2] / (1 + p[2, 1] - p[1, 1])

points1 <- c()
points2 <- c()
points_len <- 200

# 2-DTMC simulation
current_state <- 0
for (i in 1:points_len) {
  # Extracts probability of transition to same state
  prob <- p[current_state + 1, current_state + 1]

  # Changes state if no success
  if (rbinom(1, 1, prob) == 0) {
    current_state <<- (current_state + 1) %% 2
  }
  points1 <<- c(points1, current_state)
}

# Bernoulli process simulation
points2 <- lapply(1:points_len, function(...) rbinom(1, 1, p_avg))
points2 <- unlist(points2)

data1 <- data.frame(x = seq_along(points1), y = points1)
data2 <- data.frame(x = seq_along(points2), y = points2)

p1 <- ggplot(data1, aes(x, y)) +
  geom_point() +
  scale_y_continuous("2-DTMC")
p2 <- ggplot(data2, aes(x, y)) +
  geom_point() +
  scale_y_continuous("Bernoulli")
p3 <- grid.arrange(p1, p2, ncol = 1)
p3

ggsave(p3, file = "p3.jpeg", device = "jpeg")
