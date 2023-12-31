# Simulator of a packet switched point-to-point link, with 2 scheduling
# mechanisms (fifo and strict priority), and 2 source types (both with Poisson
# arrivals but one with exponentially distributed packet sizes and the other
# with fixed packet sizes). It estimates the average packet delay, and the
# throughput of each flow.

source("code/ppl/init.R")
source("code/ppl/timing.R")
source("code/ppl/arrivals.R")
source("code/ppl/departures.R")
source("code/ppl/pq.R")
source("code/ppl/report.R")

ppl <- function() {
  init() # Initialization of data structures

  # Main program
  while (Time < endTime) {
    nextEvent <- timing() # Next event
    nextFlow <- nextEvent[2] # Flow of next event
    nextEventType <- nextEvent[3] # Type of next event
    if (nextEventType == 1) { # If next event is an arrival
      arrivals(nextFlow) # Call arrivals routine
    } else { # If next event is a departure
      departures() # Call departures routine
    }
  }

  list(
    flow_avg_delays = sapply(seq_len(nrow(FlowStats)), function(i) FlowStats[i, 2] / FlowStats[i, 1]),
    flow_throughput = sapply(seq_len(nrow(FlowStats)), function(i) FlowStats[i, 3] / Time)
  )
}
