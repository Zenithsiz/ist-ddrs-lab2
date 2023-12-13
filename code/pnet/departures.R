# This function processes the departures of packets from links

pnet.departures <- function(state, LinkCapacities, Flows, thisLink) {
  thisPacket <- state$Queues[[thisLink]][[1]] # Reads this packet
  thisFlow <- thisPacket[1] # Reads flow of this packet
  thisRoute <- Flows[[thisFlow]]$route # Reads route of this flow

  # Processes departure of this packet from this link
  lastLink <- thisRoute[length(thisRoute)] # Determines the last link in the route of this flow
  if (thisLink == lastLink) { # If  departure is from last link
    thisArrivalTime <- thisPacket[2] # Reads arrival time of this packet
    PacketDelay <- state$Time - thisArrivalTime # Calculates packet delay
    state$FlowStats[thisFlow, 1] <- state$FlowStats[thisFlow, 1] + 1 # Increments number of packets that departed from this flow
    state$FlowStats[thisFlow, 2] <- state$FlowStats[thisFlow, 2] + PacketDelay # Adds delay of this packet to delay of this flow
  } else { # If departure is not from last link
    nextLink <- thisRoute[which(thisRoute == thisLink) + 1] # Determines next link in the route of this flow
    if (length(state$Queues[[nextLink]]) == 0) { # If queue of next link is empty
      thisLength <- thisPacket[3] # Reads length of this packet
      nextLinkCapacity <- LinkCapacities[nextLink] # Reads capacity of next link
      state$EventList <- rbind(state$EventList, c(state$Time + thisLength / nextLinkCapacity, 2, nextLink)) # Schedules departure of this packet at next link
    }
    state$Queues[[nextLink]][[length(state$Queues[[nextLink]]) + 1]] <- thisPacket # Stores this packet in queue of next link
  }

  # Removes this packet from head of queue of this link
  state$Queues[[thisLink]][[1]] <- NULL

  # Processes next packet of this link
  if (length(state$Queues[[thisLink]]) == 0) { # If queue of this link become empty
    # Do nothing
  } else { # If queue of this link is not empty
    nextPacket <- state$Queues[[thisLink]][[1]] # Reads next packet of this link
    nextLength <- nextPacket[3] # Reads length of next packet
    thisLinkCapacity <- LinkCapacities[thisLink] # Reads capacity of this link
    state$EventList <- rbind(state$EventList, c(state$Time + nextLength / thisLinkCapacity, 2, thisLink)) # Schedules departure of next packet at this link
  }
}
