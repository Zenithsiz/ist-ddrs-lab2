# Determines the flow blocking probabilities of a circuit switched network using
# the reduced load approximation. It uses the method of repeated substitutions
# (Keith Ross book, page 184)

source("code/circnets/erlB.R")

##############################################################################
# Insert here the input parameters

# Links must be identified by contiguous integers starting at 1. These numbers
# must be used as indexes of the LinkCapacities vector and of the vectors
# defining the routes of each flow. Do not use the node numbers for this
# purpose!

# Define here the capacity of each link. The capacity must be expressed in number
# of circuits. This assumes that each call occupies one circuit.

# Links
# (1): 1 <-> 2
# (2): 1 <-> 4
# (3): 2 <-> 3
# (4): 2 <-> 4
# (5): 3 <-> 4

# Solutions:
# c(5, 0, 5, 0, 0) + (c(1)      , c(3)      , c(1, 3)) => 5000 Euros
# c(4, 4, 4, 0, 4) + (c(1)      , c(3)      , c(2, 5)) => 4800 Euros
# c(0, 5, 5, 0, 5) + (c(2, 5, 3), c(3)      , c(2, 5)) => 3500 Euros
# c(4, 6, 4, 0, 6) + (c(2, 5, 3), c(1, 2, 5), c(2, 5)) => 5200 Euros
LinkCapacities <- c(0, 5, 5, 0, 5)

# Define here the link costs
LinkCosts <- c(500, 100, 500, 1000, 100)

# Define here the flows. Flows is a list of lists that stores in each list (1)
# the offered load and (2) the route of each flow; the routes must be defined
# using the link identifiers (and not the node identifiers)
Flows <- list(
  # Flow 1
  # list(load = 0.5, route = c(1)),
  list(load = 0.5, route = c(2, 5, 3)),

  # Flow 2
  list(load = 0.5, route = c(3)),
  # list(load = 0.5, route = c(1, 2, 5)),

  # Flow 3
  # list(load = 0.5, route = c(1, 3))
  list(load = 0.5, route = c(2, 5))
)


# Do not write bellow this line!
##############################################################################

numLinks <- length(LinkCapacities)
numFlows <- length(Flows)

niter <- 0
errorTarget <- 0.00001
error <- Inf

LinkBlocking <- rep(0, numLinks)
LinkBlockingPrevious <- rep(Inf, numLinks)
while (error > errorTarget) { # Repeated substitutions
  LinkLoads <- rep(0, numLinks)
  for (j in 1:numLinks) { # Iterates over links
    for (k in 1:numFlows) { # Iterates over flows
      Route <- Flows[[k]]$route
      if (any(Route == j)) { # Checks to see if this flow crosses link j
        Load <- Flows[[k]]$load
        AcceptRoute <- Route[-which(Route == j)] # Removes link j from this flow
        LengthAcceptRoute <- length(AcceptRoute)
        if (LengthAcceptRoute == 0) { # Computes acceptance probability of this flow
          AcceptProb <- 1
        } else {
          AcceptProb <- 1
          for (l in 1:LengthAcceptRoute) {
            Link <- AcceptRoute[l]
            AcceptProb <- AcceptProb * (1 - LinkBlocking[Link])
          }
        }
        ReducedLoad <- Load * AcceptProb # Computes reduced load of this flow
        LinkLoads[j] <- LinkLoads[j] + ReducedLoad # Accumulates load in link
      }
    } # Ends iteration over flows
  } # Ends iteration over links
  for (m in 1:numLinks) { # Calculates link blocking probabilities
    LinkBlocking[m] <- erlB(LinkLoads[m], LinkCapacities[m])
  }
  error <- max(abs(LinkBlocking - LinkBlockingPrevious))
  LinkBlockingPrevious <- LinkBlocking
  niter <- niter + 1
}

# Computes blocking probability of each flow
FlowBlocking <- c(length = numFlows)
for (i in 1:numFlows) {
  Route <- Flows[[i]]$route
  AcceptProb <- 1
  for (j in 1:length(Route)) {
    Link <- Route[j]
    AcceptProb <- AcceptProb * (1 - LinkBlocking[Link])
  }
  FlowBlocking[i] <- 1 - AcceptProb
}

# print results
cat(sprintf("Number of iterations = %d", niter), "\n")
for (i in 1:numLinks) {
  cat(sprintf("Blocking probability of link %d = %f (%d)", i, LinkBlocking[i], LinkBlocking[i] < 0.01), "\n")
}
for (i in 1:numFlows) {
  cat(sprintf("Blocking probability of flow %d = %f (%d)", i, FlowBlocking[i], FlowBlocking[i] < 0.01), "\n")
}
cat(sprintf("Total cost of solution is %d Euros", sum(LinkCapacities * LinkCosts)), "\n")
