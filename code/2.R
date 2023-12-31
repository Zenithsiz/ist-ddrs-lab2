data <- read.csv("data/2dtmc_data.csv", sep = "\t")
data <- data$x

occur_matrix <- matrix(
  c(c(0, 0), c(0, 0)),
  nrow = 2,
  ncol = 2,
  byrow = TRUE
)

for (data_idx in 2:length(data)) {
  prev <- data[data_idx - 1]
  cur <- data[data_idx]

  occur_matrix[1 + cur, 1 + prev] <- occur_matrix[1 + cur, 1 + prev] + 1
}

cat("Occurrences matrix:\n")
print(occur_matrix)
write.table(occur_matrix, "output/2-occur.csv", sep = "\t", col.names = FALSE, row.names = FALSE)

prob_matrix <- apply(
  occur_matrix,
  1, function(row) row / sum(row)
)
prob_matrix <- apply(prob_matrix, 1, function(cell) round(cell, 4))

cat("Probability matrix:\n")
print(prob_matrix)
write.table(prob_matrix, "output/2-prob.csv", sep = "\t", col.names = FALSE, row.names = FALSE)
