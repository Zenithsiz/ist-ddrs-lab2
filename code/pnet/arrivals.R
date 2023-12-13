# This function processes the arrivals of packets at flows

pnet.arrivals <- function(state, LinkCapacities, Flows, thisFlow) {
  # Unpack the flow we're working on
  thisArrivalRate <- Flows[[thisFlow]]$rate
  thisMeanPacketLength <- Flows[[thisFlow]]$packetsize
  thisRoute <- Flows[[thisFlow]]$route

  # Schedule next event here
  state$EventList <- rbind(state$EventList, c(state$Time + rexp(1, thisArrivalRate), 1, thisFlow))

  thisLength <- rexp(1, 1 / thisMeanPacketLength)
  firstLink <- thisRoute[1]
  if (length(state$Queues[[firstLink]]) == 0) {
    firstLinkCapacity <- LinkCapacities[firstLink]
    state$EventList <- rbind(state$EventList, c(state$Time + thisLength / firstLinkCapacity, 2, firstLink))
  }

  thisPacket <- c(thisFlow, state$Time, thisLength)
  state$Queues[[firstLink]][[length(state$Queues[[firstLink]]) + 1]] <- thisPacket
}
