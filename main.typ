#import "util.typ" as util

#set document(
  author: util.authors,
  title: util.title,
  date: none
)
#set page(
  header: locate(loc => if loc.page() > 1 {
    image("images/tecnico-logo.png", height: 30pt)
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
