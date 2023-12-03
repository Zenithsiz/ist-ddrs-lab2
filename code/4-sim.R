cur_state <- 1
prob_matrix <- matrix(
    c(
        c(0.6, 0.0, 0.4),
        c(0.7, 0.2, 0.1),
        c(0.0, 0.2, 0.8)
    ),
    nrow = 3,
    ncol = 3,
    byrow = TRUE
)


rounds <- 100000
states <- list()
for (round_idx in 1:rounds) {
    states[[length(states) + 1]] <- cur_state
    probs <- cumsum(prob_matrix[cur_state, ])

    prob <- runif(1, 0.0, 1.0)
    next_state <- which(probs >= prob)
    if (is.vector(next_state)) {
        next_state <- next_state[1]
    }
    cur_state <- next_state
}

for (state in 1:3) {
    state_count <- length(states[states == state])
    state_prob <- state_count / rounds
    cat(sprintf("State %d prob: %f\n", state, state_prob))
}
