#import "template.typ": *

#show: project.with(
  title: "हिन्दी भाषियों के लिए रूसी अध्यन",
  author: "Vinay Pandey1",
)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

#include "chapters/intro/intro.typ"
#include "chapters/nouns/nouns.typ"
#include "chapters/pronoun.typ"
#include "chapters/tenses.typ"
#include "chapters/cases/cases.typ"

#load-bib(main: true)
