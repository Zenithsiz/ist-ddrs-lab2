ρ <- 0.5
s1 <- 1
p1 <- 0.99
s2 <- 101
p2 <- 0.01

μ <- 1 / (s1 * p1 + s2 * p2)
λ <- ρ * μ
λ1 <- p1 * λ
λ2 <- p2 * λ

wq1 <- (λ1 * s1^2 + λ2 * s2^2) / (2 * (1 - λ1 * s1))
wq2 <- (λ1 * s1^2 + λ2 * s2^2) / (2 * (1 - λ1 * s1) * (1 - λ1 * s1 - λ2 * s2))

wq <- (λ1 * wq1 + λ2 * wq2) / (λ1 + λ2)

cat(sprintf("μ = %.2f\n", μ))
cat(sprintf("λ = %.2f\n", λ))
cat(sprintf("λ1 = %.4f\n", λ1))
cat(sprintf("λ2 = %.4f\n", λ2))
cat(sprintf("wq1 = %.2f\n", wq1))
cat(sprintf("wq2 = %.2f\n", wq2))
cat(sprintf("wq = %.2f\n", wq))
