# Simulation of Web server farm with random and JSQ task assignment policies;
# estimates average delay in system

require(ggplot2)
require(extraDistr)

rescheduleDepartures <- function(ServiceRate, Departures, TimePrevious, Time, thisServer, numJobsBefore, numJobsAfter) {
  for (i in seq_len(nrow(Departures))) {
    ElapsedTime <- Time - TimePrevious[thisServer]
    if (Departures[i, 4] == thisServer) {
      PreviousServicedUnits <- Departures[i, 3]
      LastServicedUnits <- ElapsedTime * ServiceRate / numJobsBefore
      RemainingServiceUnits <- PreviousServicedUnits - LastServicedUnits
      Departures[i, 3] <- RemainingServiceUnits
      Departures[i, 1] <- Time + RemainingServiceUnits * numJobsAfter / ServiceRate
    }
  }
  TimePrevious[thisServer] <- Time
}

calc_avg_delay_random <- function(numServers, ArrivalRate, ServiceRate, StoppingCondition) {
  # Random task assignment policy
  Time <- 0
  nextArrivalTime <- rexp(1, rate = ArrivalRate)
  # Departures is a matrix of departure events where each row is an event and each
  # event includes (i) departure time, (ii) arrival time, (iii) service time, and
  # (iv) server number
  Departures <- matrix(rep(Inf, 4), nrow = 1, ncol = 4, byrow = TRUE)
  numJobsServer <- rep(0, numServers)
  TimePrevious <- rep(0, numServers)
  AccumDelay <- 0
  NumSysCompleted <- 0
  # Simulation loop
  while (NumSysCompleted < StoppingCondition) {
    Departures <- Departures[order(Departures[, 1]), , drop = FALSE]
    nextDepartureTime <- Departures[1, 1]
    Time <- min(c(nextArrivalTime, nextDepartureTime))
    nextEventType <- which.min(c(nextArrivalTime, nextDepartureTime))
    if (nextEventType == 1) {
      nextArrivalTime <- Time + rexp(1, ArrivalRate)
      thisServer <- rdunif(1, 1, numServers)
      numJobsServer[thisServer] <- numJobsServer[thisServer] + 1
      numJobs <- numJobsServer[thisServer]
      if (!all(is.na(Departures))) {
        rescheduleDepartures(ServiceRate, Departures, TimePrevious, Time, thisServer, numJobs - 1, numJobs)
      }
      ServiceUnits <- rexp(1, rate = ServiceRate)
      DepartureTime <- Time + ServiceUnits * numJobs / ServiceRate
      Departures <- rbind(Departures, c(DepartureTime, Time, ServiceUnits, thisServer))
    } else {
      thisDeparture <- Departures[1, ]
      thisDelay <- Time - thisDeparture[2]
      AccumDelay <- AccumDelay + thisDelay
      thisServer <- thisDeparture[4]
      numJobsServer[thisServer] <- numJobsServer[thisServer] - 1
      numJobs <- numJobsServer[thisServer]
      NumSysCompleted <- NumSysCompleted + 1
      Departures <- Departures[-1, , drop = FALSE]
      if (!all(is.na(Departures))) {
        rescheduleDepartures(ServiceRate, Departures, TimePrevious, Time, thisServer, numJobs + 1, numJobs)
      }
    }
  }

  AvgDelay <- AccumDelay / NumSysCompleted

  ro <- ArrivalRate / (numServers * ServiceRate)
  TrueAvgDelay <- (numServers / ArrivalRate) * (ro / (1 - ro))

  list(avg_delay = AvgDelay, wq = TrueAvgDelay)
}

calc_avg_delay_jsq <- function(numServers, ArrivalRate, ServiceRate, StoppingCondition) {
  # JSQ task assignment policy
  Time <- 0
  nextArrivalTime <- rexp(1, rate = ArrivalRate)
  # Departures is a matrix of departure events where each row is an event and each
  # event includes (i) departure time, (ii) arrival time, (iii) service time, and
  # (iv) server number
  Departures <- matrix(rep(Inf, 4), nrow = 1, ncol = 4, byrow = TRUE)
  numJobsServer <- rep(0, numServers)
  TimePrevious <- rep(0, numServers)
  AccumDelay <- 0
  NumSysCompleted <- 0
  # Simulation loop
  while (NumSysCompleted < StoppingCondition) {
    Departures <- Departures[order(Departures[, 1]), , drop = FALSE]
    nextDepartureTime <- Departures[1, 1]
    Time <- min(c(nextArrivalTime, nextDepartureTime))
    nextEventType <- which.min(c(nextArrivalTime, nextDepartureTime))
    if (nextEventType == 1) {
      nextArrivalTime <- Time + rexp(1, ArrivalRate)
      minServers <- which(numJobsServer == min(numJobsServer))
      thisServerIndex <- rdunif(1, 1, length(minServers))
      thisServer <- minServers[thisServerIndex]
      numJobsServer[thisServer] <- numJobsServer[thisServer] + 1
      numJobs <- numJobsServer[thisServer]
      if (!all(is.na(Departures))) {
        rescheduleDepartures(ServiceRate, Departures, TimePrevious, Time, thisServer, numJobs - 1, numJobs)
      }
      ServiceUnits <- rexp(1, rate = ServiceRate)
      DepartureTime <- Time + ServiceUnits * numJobs / ServiceRate
      Departures <- rbind(Departures, c(DepartureTime, Time, ServiceUnits, thisServer))
    } else {
      thisDeparture <- Departures[1, ]
      thisDelay <- Time - thisDeparture[2]
      AccumDelay <- AccumDelay + thisDelay
      thisServer <- thisDeparture[4]
      numJobsServer[thisServer] <- numJobsServer[thisServer] - 1
      numJobs <- numJobsServer[thisServer]
      NumSysCompleted <- NumSysCompleted + 1
      Departures <- Departures[-1, , drop = FALSE]
      if (!all(is.na(Departures))) {
        rescheduleDepartures(ServiceRate, Departures, TimePrevious, Time, thisServer, numJobs + 1, numJobs)
      }
    }
  }
  AvgDelay <- AccumDelay / NumSysCompleted

  list(avg_delay = AvgDelay)
}

set.seed(0)

service_rates <- seq(1, 5, 0.1)

avg_delays_random <- list()
avg_delays_random_theoretical <- list()
avg_delays_jsq <- list()
for (service_rate in service_rates) {
  cat(sprintf("Service Rate: %.2f\n", service_rate))

  numServers <- 2
  ArrivalRate <- 1.5
  StoppingCondition <- 1000

  stats_random <- calc_avg_delay_random(numServers, ArrivalRate, service_rate, StoppingCondition)
  stats_jsq <- calc_avg_delay_jsq(numServers, ArrivalRate, service_rate, StoppingCondition)

  avg_delays_random[[length(avg_delays_random) + 1]] <- stats_random$avg_delay
  avg_delays_random_theoretical[[length(avg_delays_random_theoretical) + 1]] <- stats_random$wq
  avg_delays_jsq[[length(avg_delays_jsq) + 1]] <- stats_jsq$avg_delay
}

data <- data.frame(
  x = service_rates,
  avg_delays_random = unlist(avg_delays_random),
  avg_delays_random_theoretical = unlist(avg_delays_random_theoretical),
  avg_delays_jsq = unlist(avg_delays_jsq)
)

plot <- ggplot(data) +
  geom_line(aes(.data$x, .data$avg_delays_random, color = "Avg. Delay (Random)")) +
  geom_line(aes(.data$x, .data$avg_delays_random_theoretical, color = "Avg. Delay (Theoretical random)")) +
  geom_line(aes(.data$x, .data$avg_delays_jsq, color = "Avg. Delay (JSQ)")) +
  xlab("Service rate") +
  ylab("Avg delay")

ggsave(plot, file = "output/9.svg", device = "png")
