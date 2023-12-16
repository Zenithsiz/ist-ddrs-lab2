#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[*NGINX* is a web server that is capable, among many other things, of being a load balancer. To achieve this, it employs several balancing algorithms, which will be detailed next.]

#indent_par[Each of these algorithms perform some tradeoff to achieve better average response times under different scenarios. To be able to compare them, we'll enumerate the situation each algorithm is best suited for.]

==== 1. Round robin

#indent_par[When using round robin, requests will be sequentially served on each available server. For example, if we have 3 servers, called $S_1$, $S_2$, $S_3$, requests will go to servers in the following order:]

- $S_1$, $S_2$, $S_3$, $S_1$, $S_2$, $S_3$, $S_1$, ...

#indent_par[This means that each request is treated equally, and thus the algorithm is best suited for when requests have a low variability in terms of workload.]

==== 2. Least connections

#indent_par[When using least connections, a request will be sent towards the server with the lowest number of active connections. However, *NGINX* also takes into account the relative computing capacity of each server to determine which server to route the request to. This means the algorithm is better described as weighted least connections.]

#indent_par[This algorithm is best suited for applications where requests are distributed with a relatively high variance, since the balancer will attempt to distribute new packets to servers which aren't already highly loaded.]

==== 3. Least time

#indent_par[This algorithm is an extension to the least connections algorithm that also takes into account the previous response times of the server.]

#indent_par[It serves the same purpose as the least connections algorithm, but when the workload of a packet can't be easily computed up-front, this algorithm should be able to estimate this, using the previous response times.]

==== 4. Hash

#indent_par[This algorithm routes packets deterministically based on some it's properties, such as the ip address of the client who sent it.]

#indent_par[It is closely related to a random algorithm, but it ensures that if a packet has the same property, it can be routed to the same server. This means that if using the client ip address as the hash, for example, a client who is sending many heavy packets will consistently get the same server, and so other clients which aren't associated to the same server won't have any response time impact.]

==== 5. Random with two choices

#indent_par[This algorithm is very closely related to the least connections / least time algorithms. However, instead of selecting the server with the lowest overall connections (or time), it will instead choose two random servers and check the lowest among them.]

#indent_par[This can be good when the operation of checking a server's least connections (or time) is more expensive than just giving them another packet, or when there are many servers, and the time it takes to ask them all for their least connections (or time) is comparable to the time it takes to process the packet.]

#pagebreak()
