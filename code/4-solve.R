# The transition probability matrix
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

# Build the coefficient matrix and constants
coef_matrix <- matrix(
  c(
    c(-prob_matrix[1, 2] - prob_matrix[1, 3], prob_matrix[2, 1], prob_matrix[3, 1]),
    c(prob_matrix[1, 2], -prob_matrix[2, 1] - prob_matrix[2, 3], prob_matrix[3, 2]),
    c(prob_matrix[1, 3], prob_matrix[2, 3], -prob_matrix[3, 1] - prob_matrix[3, 2])
  ),
  nrow = 3,
  ncol = 3,
  byrow = TRUE
)
consts <- c(0, 0, 0)

# Substitute one of the rows by the final `pi0 + pi1 + pi2 = 1` equation.
subst_idx <- 3
coef_matrix[subst_idx, ] <- c(1, 1, 1)
consts[subst_idx] <- 1

solution <- solve(coef_matrix, consts)
print(solution)
