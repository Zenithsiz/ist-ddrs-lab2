# Events are stored in a matrix called EventList, where each row represents an
# event. Events are defined by time of occurrence, type of event (1-arrival at
# flow or 2-departure from link) and number of flow or link. The function sorts the
# event list, determines the next event, advances the simulation clock to the
# time of the next event, returns this event and removes it from the event list.

pnet.timing <- function(state) {
  # Sort event list by time
  state$EventList <- state$EventList[order(state$EventList[, 1]), , drop = FALSE]

  # Then pop the next event, advance the clock
  # Note: `drop = FALSE` ensures `EventList` stays a matrix
  nextEvent <- state$EventList[1, ]
  state$EventList <- state$EventList[-1, , drop = FALSE]
  state$Time <- nextEvent[1]

  nextEvent
}
