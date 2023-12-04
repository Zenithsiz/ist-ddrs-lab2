cur_state <- 1
trans_matrix <- matrix(
  c(
    c(0, 2, 0),
    c(1, 0, 1),
    c(1, 1, 0)
  ),
  nrow = 3,
  ncol = 3,
  byrow = TRUE
)


max_time <- 100000
cur_time <- 0
states <- list()
while (cur_time < max_time) {
  states[[length(states) + 1]] <- cur_state

  trans_rate <- sum(trans_matrix[cur_state, ])
  wait_time <- rexp(1, rate = trans_rate)
  cur_time <- cur_time + wait_time

  probs <- cumsum(trans_matrix[cur_state, ]) / sum(trans_matrix[cur_state, ])
  prob <- runif(1, 0.0, 1.0)
  next_state <- which(probs >= prob)
  if (is.vector(next_state)) {
    next_state <- next_state[1]
  }
  cur_state <- next_state
}

probs <- sapply(1:3, function(state) length(states[states == state]) / length(states))
probs <- sapply(probs, function(x) round(x, 4))
print(probs)
write.table(probs, "output/5-sim1.csv", sep = "\t", col.names = FALSE, row.names = FALSE)
