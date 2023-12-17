require(ggplot2)
require(pracma)

status_thinking <- "Thinking"
status_backlogged <- "Backlogged"

calc_throughput <- function(slots_len, prob_backlogged, prob_thinking) {
  slots <- as.list(rep(status_thinking, slots_len))

  total_steps <- 10000000
  successes <- 0
  for (cur_step in 1:total_steps) {
    # Get all the slots that will be transmitting
    transmitting <- sapply(seq_along(slots), function(slot_idx) {
      prob <- ifelse(slots[slot_idx] == status_thinking, prob_thinking, prob_backlogged)
      ifelse(rbinom(1, 1, prob) == 1, slot_idx, -1)
    })
    transmitting <- transmitting[transmitting != -1]

    # Then check if we succeeded and set the next status of all the transmitting
    success <- length(transmitting) == 1
    next_status <- ifelse(success, status_thinking, status_backlogged)
    for (slot_idx in transmitting) {
      slots[slot_idx] <- next_status
    }

    # Finally if we succeeded, add it to the number of successes
    successes <- successes + success
  }

  success_ratio <- successes / total_steps
  success_ratio
}

create_graph <- function(slots_len, probs_thinking, probs_backlogged, output_file) {
  throughput <- lapply(probs_backlogged, function(prob_backlogged) {
    sapply(probs_thinking, function(prob_thinking) calc_throughput(slots_len, prob_backlogged, prob_thinking))
  })
  prob_names <- lapply(probs_backlogged, function(prob) rep(as.character(prob), length(probs_thinking)))

  throughput_data <- data.frame(
    x = probs_thinking,
    y = unlist(throughput),
    p = unlist(prob_names)
  )
  plot <- ggplot(throughput_data) +
    geom_line(aes(.data$x, .data$y, color = .data$p)) +
    scale_x_log10(limit = c(0.0005, 0.3)) +
    ylim(0.0, 0.4) +
    xlab("σ") +
    ylab("Throughput")

  ggsave(plot, file = output_file, device = "svg")
}

pdf(NULL)
create_graph(10, logseq(1 + 1e-7, 1.3, 1000) - 1, c(0.3, 0.4, 0.5, 0.6), "output/3b-aloha10.svg")
create_graph(25, logseq(1 + 1e-7, 1.3, 1000) - 1, c(0.2, 0.3), "output/3b-aloha25.svg")
