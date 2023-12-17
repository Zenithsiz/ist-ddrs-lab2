#import "/typst/util.typ" as util: indent_par, code_figure

#indent_par[In the following 4 headings, we describe the four quality of life (QoS) components:]

==== a. Classification

#indent_par[Classification is the first step in the QoS chain, where packets are identified by criteria and mapped to queues, with an enqueuing priority. Some examples of matching criteria are:]

- Parts of the MAC address.
- Source / Destination IPv4 / IPv6 address / prefix
- Protocol type

==== b. Buffering

#indent_par[Buffering, also called enqueuing, is the second step in the Qos chain. Given the mapping from the previous step, the packets will be assigned to a queue.]

==== c. Scheduling

#indent_par[Scheduling, also called dequeuing, is the third step in the Qos chain. After entering its assigned queue, a packet will be scheduled for processing. This procedure will employ a policy that will determine when each packet will be served.]

#indent_par[In detail, the 7x50 _Nokia_ routers use a policy of strict priority, with two different levels of priorities. However, there can be multiple queues with the same priority. In this case, once a packet is assigned a priority, it will be distributed according to a round-robin policy to the respective queues.]

==== d. Remarking

#indent_par[After a packet is processed, it can be re-evaluated, similarly to the first step of classification, so that further equipment down the line can have a better idea of the nature of this packet.]

#pagebreak()
