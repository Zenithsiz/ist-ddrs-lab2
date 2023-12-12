library(ggplot2)

calc_avg_delay <- function(ArrivalRate, ServiceRate, StoppingCondition) {
  Time <- 0
  NumQueueCompleted <- 0
  ServerStatus <- 0
  NumInQueue <- 0
  AcumDelay <- 0
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
        AcumDelay <- AcumDelay + Time - QueueArrivalTime[1]
        QueueArrivalTime <- QueueArrivalTime[-1]
        NumInQueue <- NumInQueue - 1
        NumQueueCompleted <- NumQueueCompleted + 1
        EventList[2] <- Time + rexp(1, ServiceRate)
      }
    }
  }

  AcumDelay / NumQueueCompleted
}

generate_graph <- function(rho, output_file) {
  print(rho)

  StoppingConditions <- seq(1000, 2000, by = 500)
  AvgAvgDelays <- sapply(StoppingConditions, function(StoppingCondition) {
    sum(sapply(1:50, function(...) {
      calc_avg_delay(rho, 1, StoppingCondition)
    }))
  })

  data <- data.frame(x = StoppingConditions, y = AvgAvgDelays)

  plot <- ggplot(data) +
    geom_line(aes(.data$x, .data$y)) +
    xlab("Stopping condition") +
    ylab("Avg delay")

  ggsave(plot, file = output_file, device = "svg")
}

set.seed(0)
pdf(NULL)
generate_graph(1, "output/6a.svg")
generate_graph(2, "output/6b.svg")
