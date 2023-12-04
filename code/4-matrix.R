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

prev_matrix <- matrix(data = 0.0, nrow = 3, ncol = 3)
step_matrix <- prob_matrix

steps <- 0
epsilon <- 1e-9
while (steps < 100) {
  prev_matrix <- step_matrix
  step_matrix <- step_matrix %*% prob_matrix
  steps <- steps + 1


  step_diff <- step_matrix - prev_matrix
  step_converged <- sapply(step_diff, function(cell) abs(cell) < epsilon)
  if (all(step_converged)) {
    break
  }
}


cat(sprintf("Took %d steps\n", steps))
cat(sprintf("Final matrix:\n"))
step_matrix <- apply(step_matrix, 1, function(cell) round(cell, 4))
print(step_matrix)
write.table(step_matrix, "output/4-matrix.csv", sep = "\t", col.names = FALSE, row.names = FALSE)
