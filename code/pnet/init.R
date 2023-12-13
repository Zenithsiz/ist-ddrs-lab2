pnet.init <- function(LinkCapacities, Flows) {
  # Setup event list
  EventList <- matrix(, nrow = 0, ncol = 3, byrow = TRUE)
  for (i in seq_along(Flows)) {
    thisArrivalRate <- Flows[[i]]$rate
    EventList <- rbind(EventList, c(rexp(1, thisArrivalRate), 1, i))
  }

  state <- new.env(parent = emptyenv())
  state$Time <- 0
  state$EventList <- EventList
  state$numFlows <- length(Flows)
  state$numLinks <- length(LinkCapacities)
  state$Queues <- rep(list(list()), state$numLinks)
  state$FlowStats <- matrix(0, nrow = length(Flows), ncol = 2, byrow = TRUE)

  state
}
