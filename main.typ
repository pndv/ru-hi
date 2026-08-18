#import "template.typ": *

#show: book.with(
  title: [हिन्दी भाषियों के लिए रूसी अध्यन],
  author: "Vinay Pandey",
)

#frontmatter()
#outline(title: [अनुक्रमणिका], depth: 3)
#outline(title: [चित्र सूची], target: figure.where(kind: image))
#outline(title: [तालिका सूची], target: figure.where(kind: table))

// Reading order, and every chapter is built: the LaTeX `\includeonly` mechanism
// (which left `adjective` and `numerals` out of the PDF entirely) is gone.
#mainmatter()
#include "chapters/intro/intro.typ"
#include "chapters/nouns/nouns.typ"
#include "chapters/pronoun.typ"
#include "chapters/tenses.typ"
#include "chapters/cases/cases.typ"
#include "chapters/adjective.typ"
#include "chapters/numerals.typ"

#backmatter()
#bibliography("bibliography.yml", title: [संदर्भसूची], style: "csl/hindi-numeric.csl")
#make-index(title: [वर्णक्रमानुसार सूची])
