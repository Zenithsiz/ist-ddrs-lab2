library(ggplot2)

# Sets the next `queue_idx` packet as the current served
serve_packet <- function(state, queue_idx) {
  # Set the packet as being served
  state$served_packet_size <- state$queues_packet_size[[queue_idx]][1]
  state$served_queue <- queue_idx
  state$event_list[3] <- state$time + state$served_packet_size / state$link_capacity

  # Set credit to 0, if empty, else subtract the used bits
  if (state$num_in_queue[queue_idx] == 1) {
    state$queues_credit[queue_idx] <- 0
  } else {
    state$queues_credit[queue_idx] <- state$queues_credit[queue_idx] - state$served_packet_size
  }

  # Then remove the queued packet
  state$queues_packet_size[[queue_idx]] <- state$queues_packet_size[[queue_idx]][-1]
  state$num_in_queue[queue_idx] <- state$num_in_queue[queue_idx] - 1
}

# Finds a queue to serve.
find_queue_to_serve <- function(state) {
  # Check all remaining queues if they have enough credit
  for (queue_idx in state$served_queue:length(state$queues_credit)) {
    if (state$queues_credit[queue_idx] >= state$queues_packet_size[[queue_idx]][1]) {
      serve_packet(state, queue_idx)
      return()
    }
  }

  # Otherwise, find a queue to get from
  state$served_queue <- NULL
  while (is.null(state$served_queue)) {
    # Add quantum to each queue
    state$queues_credit <- state$queues_credit + state$queues_quantum

    # Then get the first queue that has enough credits
    for (queue_idx in seq_along(state$queues_credit)) {
      if (state$queues_credit[queue_idx] >= state$queues_packet_size[[queue_idx]][1]) {
        serve_packet(state, queue_idx)
        return()
      }
    }
  }
}

calc_throughput <- function(arrival_rates, link_capacity, avg_packet_sizes, queues_quantum) {
  # Initialization
  state <- new.env(parent = emptyenv())
  state$arrival_rates <- arrival_rates
  state$link_capacity <- link_capacity
  state$avg_packet_sizes <- avg_packet_sizes
  state$queues_quantum <- queues_quantum
  state$time <- 0
  state$num_sys_completed <- 0
  state$link_status <- 0
  state$num_in_queue <- c(0, 0)
  state$queues_packet_size <- list(c(), c())
  state$accum_bits <- c(0, 0)
  state$event_list <- c(rexp(1, state$arrival_rates[1]), rexp(1, state$arrival_rates[2]), Inf)
  state$queues_credit <- c(0, 0)

  # Current served packet, and the queue it came from
  state$served_packet_size <- NULL
  state$served_queue <- NULL

  # Simulation loop
  state$max_completed <- 2000
  while (state$num_sys_completed < state$max_completed) {
    # Get next event type
    next_event_type <- which.min(state$event_list)
    state$time <- state$event_list[next_event_type]

    # If it's an arrival event
    if (next_event_type == 1 || next_event_type == 2) {
      # Add the arrival to the queue
      state$event_list[next_event_type] <- state$time + rexp(1, state$arrival_rates[next_event_type])

      # Generate a uniformly sampled packet size
      packet_size <- sample(seq(
        state$avg_packet_sizes[next_event_type] - 500,
        state$avg_packet_sizes[next_event_type] + 500,
        100
      ), 1)

      # If there's someone in the queue, queue the arriving packet
      if (state$link_status == 1) {
        state$queues_packet_size[[next_event_type]] <- c(state$queues_packet_size[[next_event_type]], packet_size)
        state$num_in_queue[next_event_type] <- state$num_in_queue[next_event_type] + 1
      }

      # Else if there's no one in the queue, put them on the link
      # and schedule their departure
      else {
        state$link_status <- 1
        state$served_packet_size <- packet_size
        state$served_queue <- next_event_type
        state$event_list[3] <- state$time + state$served_packet_size / state$link_capacity
      }
    }

    # Else it's a departure event
    else {
      state$num_sys_completed <- state$num_sys_completed + 1
      state$accum_bits[state$served_queue] <- state$accum_bits[state$served_queue] + state$served_packet_size

      # If all queues are empty
      if (all(state$num_in_queue == 0)) {
        state$served_queue <- NULL
        state$served_packet_size <- NULL
        state$event_list[3] <- Inf
        state$link_status <- 0

        # Reset all queue's credits
        for (queue_idx in seq_along(state$queues_credit)) {
          state$queues_credit[queue_idx] <- 0
        }
      }

      # Else if any are queue
      else if (any(state$num_in_queue == 0)) {
        # Find the first non-empty queue
        queue_idx <- which(state$num_in_queue != 0)
        serve_packet(state, queue_idx)
      }

      # Else all are full
      else {
        find_queue_to_serve(state)
      }
    }
  }

  lapply(state$accum_bits, \(bits) bits / state$time)
}

values <- seq(1 / 8, 7 / 8, by = 1 / 64)
params_all <- sapply(values, \(avg_packet_size_ratio) {
  sapply(values, \(quantum_ratio) {
    lapply(c(1 / 4, 2 / 4, 3 / 4), \(arrival_rate_ratio) {
      list(
        arrival_rate_ratio = arrival_rate_ratio,
        avg_packet_size_ratio = avg_packet_size_ratio,
        quantum_ratio = quantum_ratio
      )
    })
  })
})

set.seed(0)
data <- lapply(params_all, \(params) {
  str(params)

  arrival_rates <- c(
    params$arrival_rate_ratio * 3,
    (1 - params$arrival_rate_ratio) * 3
  )
  link_capacity <- 1000
  avg_packet_sizes <- c(
    params$avg_packet_size_ratio * 4000,
    (1 - params$avg_packet_size_ratio) * 4000
  )
  queues_quantum <- c(
    params$quantum_ratio * 2000,
    (1 - params$quantum_ratio) * 2000
  )

  throughputs <- calc_throughput(arrival_rates, link_capacity, avg_packet_sizes, queues_quantum)
  data.frame(
    arrival_rate_ratio = params$arrival_rate_ratio,
    avg_packet_sizes1 = avg_packet_sizes[[1]],
    queues_quantum1 = queues_quantum[[1]],
    throughput1 = signif(throughputs[[1]], 4),
    throughput2 = signif(throughputs[[2]], 4)
  )
})
data <- do.call(rbind, data)

create_plot <- function(arrival_rate_ratio, throughput, throughput_title) {
  data <- data[data$arrival_rate_ratio == arrival_rate_ratio, ]

  ggplot(data, aes(.data$avg_packet_sizes1, .data$queues_quantum1)) +
    geom_raster(aes(fill = .data[[throughput]])) +
    scale_x_continuous(
      name = "Average packet size (1)",
      sec.axis = sec_axis(~ 4000 - ., name = "Average packet size (2)")
    ) +
    scale_y_continuous(
      name = "Quantum (1)",
      sec.axis = sec_axis(~ 2000 - ., name = "Quantum (1)")
    ) +
    scale_fill_gradient(
      name = throughput_title,
      low = "#ff2020",
      high = "#20ff20",
      limits = c(0, 1000)
    ) +
    xlab("Packet size %") +
    ylab("Quantum size %")
}

plot <- create_plot(1 / 4, "throughput1", "Throughput (1)")
ggsave(plot, file = "output/11_1_1.svg", device = "svg")
plot <- create_plot(2 / 4, "throughput1", "Throughput (1)")
ggsave(plot, file = "output/11_1_2.svg", device = "svg")
plot <- create_plot(3 / 4, "throughput1", "Throughput (1)")
ggsave(plot, file = "output/11_1_3.svg", device = "svg")
plot <- create_plot(1 / 4, "throughput2", "Throughput (2)")
ggsave(plot, file = "output/11_2_1.svg", device = "svg")
plot <- create_plot(2 / 4, "throughput2", "Throughput (2)")
ggsave(plot, file = "output/11_2_2.svg", device = "svg")
plot <- create_plot(3 / 4, "throughput2", "Throughput (2)")
ggsave(plot, file = "output/11_2_3.svg", device = "svg")
