# Simulator of packet scheduler with two queues, using a random scheduling
# algorithm. The queues have independent Poisson arrivals and uniformly
# distributed packet sizes

set.seed(0)

# Input parameters
ArrivalRate <- c(1, 1)
avg_packet_size <- c(1000, 3000)
link_capacity <- 1000
queues_quantum <- c(2000, 1000)

# Initialization
time <- 0
num_sys_completed <- 0
link_status <- 0
num_in_queue <- c(0, 0)
queues_packet_size <- list(c(), c())
accum_bits <- c(0, 0)
event_list <- c(rexp(1, ArrivalRate[1]), rexp(1, ArrivalRate[2]), Inf)
queues_credit <- c(0, 0)

# Link
served_packet_size <- NULL
served_queue <- NULL

# Simulation loop
while (num_sys_completed < 10000) {
  # Get next event type
  next_event_type <- which.min(event_list)
  time <- event_list[next_event_type]

  # If it's an arrival event
  if (next_event_type == 1 || next_event_type == 2) {
    # Add the arrival to the queue
    event_list[next_event_type] <- time + rexp(1, ArrivalRate[next_event_type])

    # Generate a uniformly sampled packet size
    packet_size <- sample(seq(avg_packet_size[next_event_type] - 500, avg_packet_size[next_event_type] + 500, 100), 1)

    # If there's someone in the queue, queue the arriving packet
    if (link_status == 1) {
      queues_packet_size[[next_event_type]] <- c(queues_packet_size[[next_event_type]], packet_size)
      num_in_queue[next_event_type] <- num_in_queue[next_event_type] + 1
    }

    # Else if there's no one in the queue, put them on the link
    # and schedule their departure
    else {
      link_status <- 1
      served_packet_size <- packet_size
      served_queue <- next_event_type
      event_list[3] <- time + served_packet_size / link_capacity
    }
  }

  # Else it's a departure event
  else {
    num_sys_completed <- num_sys_completed + 1
    accum_bits[served_queue] <- accum_bits[served_queue] + served_packet_size

    # If all queues are empty
    if (all(num_in_queue == 0)) {
      served_queue <- NULL
      served_packet_size <- NULL
      event_list[3] <- Inf
      link_status <- 0
    }

    # Else if any are queue
    else if (any(num_in_queue == 0)) {
      # Find the first non-empty queue
      current_queue <- which(num_in_queue != 0)

      # Set it as being served and add a departure event
      packet_size <- queues_packet_size[[current_queue]][1]
      served_packet_size <- packet_size
      event_list[3] <- time + served_packet_size / link_capacity
      served_queue <- current_queue

      # Remove the queued packet and set credit to 0, if empty
      queues_packet_size[[current_queue]] <- queues_packet_size[[current_queue]][-1]
      num_in_queue[current_queue] <- num_in_queue[current_queue] - 1
      if (num_in_queue[current_queue] == 0) {
        queues_credit[current_queue] <- 0
      }
    }

    # Else all are full
    else {
      found_queue <- FALSE

      # If the last queue still has enough quantum, serve it
      last_queue_next_packet_size <- queues_packet_size[[served_queue]][1]
      if (queues_credit[served_queue] >= last_queue_next_packet_size) {
        # Set the packet as being served
        served_packet_size <- last_queue_next_packet_size
        event_list[3] <- time + served_packet_size / link_capacity

        # Set credit to 0, if empty, else subtract the used bits
        if (num_in_queue[served_queue] == 1) {
          queues_credit[served_queue] <- 0
        } else {
          queues_credit[served_queue] <- queues_credit[served_queue] - last_queue_next_packet_size
        }

        # Remove the queued packet
        queues_packet_size[[served_queue]] <- queues_packet_size[[served_queue]][-1]
        num_in_queue[served_queue] <- num_in_queue[served_queue] - 1

        found_queue <- TRUE
      }

      # If we aren't at the last queue yet, check them
      if (!found_queue && served_queue < length(queues_credit)) {
        for (queue_idx in (served_queue + 1):length(queues_credit)) {
          # And check if it's enough
          queue_next_packet_size <- queues_packet_size[[queue_idx]][1]
          if (queues_credit[queue_idx] >= queue_next_packet_size) {
            # Set the packet as being served
            served_packet_size <- queue_next_packet_size
            served_queue <- queue_idx
            event_list[3] <- time + served_packet_size / link_capacity

            # Set credit to 0, if empty, else subtract the used bits
            if (num_in_queue[queue_idx] == 1) {
              queues_credit[queue_idx] <- 0
            } else {
              queues_credit[queue_idx] <- queues_credit[queue_idx] - queue_next_packet_size
            }

            # Then remove the queued packet
            queues_packet_size[[queue_idx]] <- queues_packet_size[[queue_idx]][-1]
            num_in_queue[queue_idx] <- num_in_queue[queue_idx] - 1

            found_queue <- TRUE
            break
          }
        }
      }

      # Otherwise, find a queue to get from
      if (!found_queue) {
        served_queue <- NULL
        while (is.null(served_queue)) {
          # Add quantum to each queue
          for (queue_idx in seq_along(queues_credit)) {
            queues_credit[queue_idx] <- queues_credit[queue_idx] + queues_quantum[queue_idx]
          }

          # Then get the first queue that has enough credits
          for (queue_idx in seq_along(queues_credit)) {
            # And check if it's enough
            queue_next_packet_size <- queues_packet_size[[queue_idx]][1]
            if (queues_credit[queue_idx] >= queue_next_packet_size) {
              # Set the packet as being served
              served_packet_size <- queue_next_packet_size
              served_queue <- queue_idx
              event_list[3] <- time + served_packet_size / link_capacity

              # Set credit to 0, if empty, else subtract the used bits
              if (num_in_queue[queue_idx] == 1) {
                queues_credit[queue_idx] <- 0
              } else {
                queues_credit[queue_idx] <- queues_credit[queue_idx] - queue_next_packet_size
              }

              # Then remove the queued packet
              queues_packet_size[[queue_idx]] <- queues_packet_size[[queue_idx]][-1]
              num_in_queue[queue_idx] <- num_in_queue[queue_idx] - 1

              found_queue <- TRUE
              break
            }
          }
        }
      }
    }
  }
}

print(queues_credit)

# Print results
cat(sprintf("The throughput of queue 1 is %f\n", accum_bits[1] / time))
cat(sprintf("The throughput of queue 2 is %f\n", accum_bits[2] / time))
