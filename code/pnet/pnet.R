# This program simulates a packet-switched network with fixed routing to estimate
# the average packet delay of each flow

source("code/pnet/init.R")
source("code/pnet/timing.R")
source("code/pnet/arrivals.R")
source("code/pnet/departures.R")

pnet <- function(LinkCapacities, Flows, endTime) {
  state <- pnet.init(LinkCapacities, Flows)

  while (state$Time < endTime) {
    nextEvent <- pnet.timing(state)
    nextEventType <- nextEvent[2]
    nextResourceNumber <- nextEvent[3]

    if (nextEventType == 1) {
      pnet.arrivals(state, LinkCapacities, Flows, nextResourceNumber)
    } else {
      pnet.departures(state, LinkCapacities, Flows, nextResourceNumber)
    }
  }

  list(
    avg_flow_delays = sapply(1:state$numFlows, function(i) state$FlowStats[i, 2] / state$FlowStats[i, 1])
  )
}
