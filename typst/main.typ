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

#pagebreak()

=== 3. Exercise 3
#include "exercises/3.typ"