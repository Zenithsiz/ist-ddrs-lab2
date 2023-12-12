# Compares M/M/1 and M/G/1 with bimodal service distribution, in terms of average
# queuing delay, for the same arrival rate and mean service rate

calc_stats_mm1 <- function(ρ, s1, p1, s2, p2, stopping_condition) {
  service_rate <- 1 / (s1 * p1 + s2 * p2)
  arrival_rate <- service_rate * ρ

  time <- 0
  num_queue_completed <- 0
  server_status <- 0
  num_in_queue <- 0
  accum_delay <- 0
  queue_arrival_time <- c()
  event_list <- c(rexp(1, arrival_rate), Inf)
  # simulation cycle
  while (num_queue_completed < stopping_condition) {
    next_event_type <- which.min(event_list)
    time <- event_list[next_event_type]
    if (next_event_type == 1) {
      event_list[1] <- time + rexp(1, arrival_rate)
      if (server_status == 1) {
        queue_arrival_time <- c(queue_arrival_time, time)
        num_in_queue <- num_in_queue + 1
      } else {
        num_queue_completed <- num_queue_completed + 1
        server_status <- 1
        event_list[2] <- time + rexp(1, service_rate)
      }
    } else {
      if (num_in_queue == 0) {
        server_status <- 0
        event_list[2] <- Inf
      } else {
        accum_delay <- accum_delay + time - queue_arrival_time[1]
        queue_arrival_time <- queue_arrival_time[-1]
        num_in_queue <- num_in_queue - 1
        num_queue_completed <- num_queue_completed + 1
        event_list[2] <- time + rexp(1, service_rate)
      }
    }
  }

  avg_delay <- accum_delay / num_queue_completed

  # Theoretical
  wq <- (arrival_rate / service_rate) / (service_rate - arrival_rate)

  list(wq = wq, c2 = 1, avg_delay = avg_delay)
}

# M/G/1 Bimodal
calc_stats_mg1 <- function(ρ, s1, p1, s2, p2, stopping_condition) {
  service_rate <- 1 / (s1 * p1 + s2 * p2)
  arrival_rate <- service_rate * ρ

  time <- 0
  num_queue_completed <- 0
  server_status <- 0
  num_in_queue <- 0
  accum_delay <- 0
  queue_arrival_time <- c()
  queue_job_size <- c()
  event_list <- c(rexp(1, arrival_rate), Inf)

  # simulation cycle
  while (num_queue_completed < stopping_condition) {
    next_event_type <- which.min(event_list)
    time <- event_list[next_event_type]
    if (next_event_type == 1) {
      event_list[1] <- time + rexp(1, arrival_rate)
      job_size <- ifelse(runif(1) < p1, s1, s2)
      if (server_status == 1) {
        queue_arrival_time <- c(queue_arrival_time, time)
        queue_job_size <- c(queue_job_size, job_size)
        num_in_queue <- num_in_queue + 1
      } else {
        num_queue_completed <- num_queue_completed + 1
        server_status <- 1
        event_list[2] <- time + job_size
      }
    } else {
      if (num_in_queue == 0) {
        server_status <- 0
        event_list[2] <- Inf
      } else {
        accum_delay <- accum_delay + time - queue_arrival_time[1]
        job_size <- queue_job_size[1]
        queue_arrival_time <- queue_arrival_time[-1]
        queue_job_size <- queue_job_size[-1]
        num_in_queue <- num_in_queue - 1
        num_queue_completed <- num_queue_completed + 1
        event_list[2] <- time + job_size
      }
    }
  }

  avg_delay <- accum_delay / num_queue_completed

  # Theoretical
  # M/G/1 Pollaczek-Khinchine
  es <- s1 * p1 + s2 * p2
  es2 <- s1^2 * p1 + s2^2 * p2
  wq_pk <- arrival_rate * es2 / (2 * (1 - arrival_rate * es))
  c2_pk <- es2 / es^2 - 1

  list(wq_pk = wq_pk, c2_pk = c2_pk, avg_delay = avg_delay)
}
