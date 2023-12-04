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
coef_matrix <- t(prob_matrix) - diag(rowSums(prob_matrix))
consts <- c(0, 0, 0)

# Substitute one of the rows by the final `pi0 + pi1 + pi2 = 1` equation.
subst_idx <- 3
coef_matrix[subst_idx, ] <- c(1, 1, 1)
consts[subst_idx] <- 1

solution <- solve(coef_matrix, consts)
solution <- sapply(solution, function(x) round(x, 4))
print(solution)
write.table(solution, "output/4-solve.csv", sep = "\t", col.names = FALSE, row.names = FALSE)
