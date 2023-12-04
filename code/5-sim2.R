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

  trans_rates <- sapply(1:3, function(state_idx) trans_matrix[cur_state, state_idx])

  # Note: We're suppressing warnings here due to the NAs produced with `trans_rate == 0`
  wait_times <- suppressWarnings(sapply(trans_rates, function(trans_rate) rexp(1, rate = trans_rate)))
  next_state <- which.min(wait_times)

  cur_time <- cur_time + wait_times[next_state]

  cur_state <- next_state
}

probs <- sapply(1:3, function(state) length(states[states == state]) / length(states))
probs <- sapply(probs, function(x) round(x, 4))
print(probs)
write.table(probs, "output/5-sim2.csv", sep = "\t", col.names = FALSE, row.names = FALSE)
