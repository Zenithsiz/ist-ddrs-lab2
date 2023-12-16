#import "/typst/util.typ" as util

#set document(
  author: util.authors,
  title: util.title,
  date: none
)
#set page(
  header: locate(loc => if loc.page() > 1 {
    image("/images/tecnico-logo.png", height: 30pt)
  }),
  footer: locate(loc => if loc.page() > 1 {
    align(center, counter(page).display())
  }),
)
#set text(
  font: "Linux Libertine",
  lang: "en",
)
#set par(
  justify: true,
)
#set math.equation(
  numbering: "(1)",
)
#set math.mat(
  delim: "[",

)
#show figure: set block(breakable: true)
#show link: underline

#include "cover.typ"
#pagebreak()

#hide[= Table of contents]

#outline(title: "Table of contents", indent: 1em)
#pagebreak()

#hide[= Figures]

#outline(title: "Figures", target: figure)
#pagebreak()

= Exercises

== A. Discrete-time Markov chains

=== 1. Exercise 1
#include "exercises/1.typ"

=== 2. Exercise 2
#include "exercises/2.typ"

=== 3. Exercise 3
#include "exercises/3.typ"

== B. Discrete-time Markov chains and Continuous-time Markov chains

=== 4. Exercise 4
#include "exercises/4.typ"

=== 5. Exercise 5
#include "exercises/5.typ"

== C. Queueing systems

=== 6. Exercise 6
#include "exercises/6.typ"

=== 7. Exercise 7
#include "exercises/7.typ"

== D. Workloads

=== 8. Exercise 8
#include "exercises/8.typ"

== E. Server farms

=== 9. Exercise 9
#include "exercises/9.typ"

=== 10. Exercise 10
#include "exercises/10.typ"

== F. Packet scheduling

=== 11. Exercise 11
#include "exercises/11.typ"

=== 12. Exercise 12
#include "exercises/12.typ"
