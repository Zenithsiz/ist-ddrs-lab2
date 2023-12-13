library(scales)
library(ggplot2)

calc_avg_delay <- function(ArrivalRate, ServiceRate, StoppingCondition) {
  Time <- 0
  NumQueueCompleted <- 0
  ServerStatus <- 0
  NumInQueue <- 0
  AccumDelay <- 0
  QueueArrivalTime <- c()
  EventList <- c(rexp(1, ArrivalRate), Inf)

  while (NumQueueCompleted < StoppingCondition) {
    NextEventType <- which.min(EventList)
    Time <- EventList[NextEventType]
    if (NextEventType == 1) {
      EventList[1] <- Time + rexp(1, ArrivalRate)
      if (ServerStatus == 1) {
        QueueArrivalTime <- c(QueueArrivalTime, Time)
        NumInQueue <- NumInQueue + 1
      } else {
        NumQueueCompleted <- NumQueueCompleted + 1
        ServerStatus <- 1
        EventList[2] <- Time + rexp(1, ServiceRate)
      }
    } else {
      if (NumInQueue == 0) {
        ServerStatus <- 0
        EventList[2] <- Inf
      } else {
        AccumDelay <- AccumDelay + Time - QueueArrivalTime[1]
        QueueArrivalTime <- QueueArrivalTime[-1]
        NumInQueue <- NumInQueue - 1
        NumQueueCompleted <- NumQueueCompleted + 1
        EventList[2] <- Time + rexp(1, ServiceRate)
      }
    }
  }

  AccumDelay / NumQueueCompleted
}

generate_graph <- function(ρ_all, output_file) {
  data <- lapply(ρ_all, function(ρ) {
    cat(sprintf("ρ = %.2f\n", ρ))

    stopping_conditions <- c(1000, 2000, 5000, 10000, 20000)
    avg_delay_results <- lapply(stopping_conditions, function(stopping_condition) {
      cat(sprintf("stopping condition = %.2f\n", stopping_condition))
      avg_delays <- sapply(1:50, function(...) {
        calc_avg_delay(ρ, 1, stopping_condition)
      })

      avg_delays_mean <- mean(avg_delays)
      avg_delays_var <- var(avg_delays)

      confidence <- 0.95
      p <- 1 - (1 - confidence) / 2
      t <- qt(p, length(avg_delays) - 1)
      avg_delays_ci_min <- avg_delays_mean - t * sqrt(avg_delays_var / length(avg_delays))
      avg_delays_ci_max <- avg_delays_mean + t * sqrt(avg_delays_var / length(avg_delays))

      list(
        mean = avg_delays_mean,
        ci_min = avg_delays_ci_min,
        ci_max = avg_delays_ci_max
      )
    })
    avg_delay_means <- sapply(avg_delay_results, function(res) res$mean)
    avg_delay_ci_mins <- sapply(avg_delay_results, function(res) res$ci_min)
    avg_delay_ci_maxs <- sapply(avg_delay_results, function(res) res$ci_max)

    data.frame(
      ρ = sprintf("%.2f", ρ),
      x = stopping_conditions,
      mean = avg_delay_means,
      ci_min = avg_delay_ci_mins,
      ci_max = avg_delay_ci_maxs
    )
  })
  data <- do.call("rbind", data)

  plot <- ggplot(data, aes(.data$x, group = .data$ρ, color = .data$ρ)) +
    geom_ribbon(aes(ymin = .data$ci_min, ymax = .data$ci_max), alpha = 0.2, fill = "grey50", linetype = 0) +
    geom_line(aes(y = .data$mean)) +
    xlab("Stopping condition") +
    ylab("Avg delay") +
    scale_x_continuous() +
    scale_y_log10(labels = scales::comma)

  ggsave(plot, file = output_file, device = "svg")
}

set.seed(0)
pdf(NULL)
generate_graph(c(0.5, 1, 2), "output/6.svg")
