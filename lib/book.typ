// Book layout: page geometry, running header, matter switching, heading and
// figure numbering, outlines and the alphabetical index.
//
// Mirrors the LaTeX `book` class this document used to be built with:
//   * lowercase roman page numbers in the frontmatter, arabic from the first
//     chapter on (`\frontmatter` / `\mainmatter` / `\backmatter`),
//   * headings numbered down to three levels (`secnumdepth=2`), so
//     `====` (\subsubsection) stays unnumbered and out of the outline,
//   * per-chapter figure and table numbers (`1.1`, `1.2`, …),
//   * `supplement: none` everywhere, because the source text spells the Hindi
//     word itself (`इति तालिका @tab:x`, `@sec:x भाग देखिए`) exactly like
//     LaTeX's bare `\ref`.
//
// No `show emph` / `show strong` rules are declared: Shobhika ships real Bold,
// Italic and Bold Italic faces, so Typst's built-in emphasis resolves inside the
// family for Devanagari, Cyrillic and Latin alike (see lib/lang.typ).

#import "lang.typ": body-font
#import "@preview/in-dexter:0.7.2" as indexer

// ---------------------------------------------------------------- index ----

// `\index{कारक}` -> `#index("कारक")`, `\index{कारक!अपादान}` -> `#index("कारक", "अपादान")`.
// The keys have to be plain strings: `#index(ru[род])` compiles but registers an
// entry with an empty term, since the package sorts and prints the key itself.
// `entry-casing` is neutralised: makeindex printed the entries verbatim, and the
// package default would upper-case Cyrillic keys such as `ь` into `Ь`.
#let index = indexer.index

// `\index{\ru{ь}|see {\ru{мякий знак}}}`: an ordinary entry whose displayed text
// carries the cross-reference and whose page link renders empty.
#let index-see(term, target) = indexer.index(
  display: [#term, देखिए #target],
  fmt: _ => none,
  term,
)

// Two-column index (`\makeindex[columns=2, …, intoc]`). The title is emitted
// outside `columns(..)` on purpose: it is a level 1 heading and therefore starts a
// new page, which is illegal inside a column context.
//
// `use-page-counter: true` prints the page *number* of an entry rather than its
// physical page index, so entries point at `1`, `2`, … as makeindex did.
// The per-letter section headings of the package are replaced by vertical space,
// mirroring makeindex's `\indexspace`; Devanagari would otherwise be grouped by
// grapheme cluster (`का`, `कर्`, …) instead of by letter.
#let make-index(title: none, outlined: true, cols: 2) = {
  if title != none {
    heading(level: 1, numbering: none, outlined: outlined, title)
  }
  columns(
    cols,
    indexer.make-index(
      entry-casing: k => k,
      use-page-counter: true,
      section-title: (letter, counter) => if counter > 0 { v(0.8em) },
    ),
  )
}

// --------------------------------------------------------------- matter ----

#let matter = state("book-matter", "front")

// The page counter already starts at 1 on the title page emitted by `book`,
// so the frontmatter only has to select the roman numbering.
#let frontmatter() = matter.update("front")

#let mainmatter() = {
  pagebreak(weak: true)
  matter.update("main")
  counter(page).update(1)
}

// The backmatter keeps the arabic numbering of the mainmatter, exactly like
// `\backmatter` in the LaTeX `book` class.
#let backmatter() = matter.update("back")

// ----------------------------------------------------------------- book ----

#let book(
  title: [],
  author: "",
  date: datetime.today(),
  body,
) = {
  set document(title: title, author: author)

  set text(lang: "hi", font: body-font, size: 11pt)
  set par(justify: true, first-line-indent: (amount: 1.5em, all: false))

  set page(
    paper: "us-letter",
    margin: (x: 2.8cm, top: 2.6cm, bottom: 2.6cm),
    header: context {
      // Running chapter title, suppressed in the frontmatter and on the page a
      // chapter opens on (LaTeX switches to the `plain` style there).
      if matter.get() != "front" {
        let this-page = here().page()
        let chapters = query(heading.where(level: 1))
        let opens-here = chapters.any(h => h.location().page() == this-page)
        let before = chapters.filter(h => h.location().page() < this-page)
        if not opens-here and before.len() > 0 {
          set text(size: 9pt)
          align(center, before.last().body)
        }
      }
    },
    footer: context {
      let n = counter(page).get().first()
      let m = matter.get()
      // The title page carries no printed number (`\thispagestyle{empty}`).
      if not (m == "front" and n == 1) {
        set text(size: 9pt)
        align(center, numbering(if m == "front" { "i" } else { "1" }, n))
      }
    },
  )

  // `secnumdepth=2`: chapter / section / subsection are numbered, deeper levels
  // are not. `supplement: none` keeps `@sec:x` a bare number, as `\ref` was.
  //
  // A level 4 heading (`\subsubsection`) is still given the *subsection's* number,
  // because `@subsubsec:x` would otherwise render empty: LaTeX's `\ref` to an
  // unnumbered heading printed the last stepped counter in exactly the same way.
  // The number is dropped from the heading itself by the show rule below.
  set heading(
    numbering: (..n) => {
      let parts = n.pos()
      numbering("1.1", ..if parts.len() <= 3 { parts } else { parts.slice(0, 3) })
    },
    supplement: none,
  )

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: image)).update(0)
    block(above: 0pt, below: 1.4em, text(size: 1.7em, weight: "bold", it))
  }
  show heading.where(level: 2): it => block(above: 1.8em, below: 0.9em, text(size: 1.3em, weight: "bold", it))
  show heading.where(level: 3): it => block(above: 1.4em, below: 0.8em, text(size: 1.1em, weight: "bold", it))
  // Unnumbered on the page (`secnumdepth=2`) and, with `depth: 3` on the outline,
  // out of the table of contents as well.
  show heading.where(level: 4): it => block(above: 1.2em, below: 0.6em, text(size: 1em, weight: "bold", it.body))

  // Per-chapter figure and table numbers; the counters are reset by the level 1
  // heading rule above.
  set figure(numbering: n => numbering("1.1", counter(heading).get().first(), n), supplement: none)
  show figure.where(kind: table): set figure(placement: none)
  show figure.where(kind: table): set figure.caption(position: top)
  // `ltablex` tables ran across pages; a Typst figure is an unbreakable block
  // unless told otherwise, which would push a long table off the page bottom.
  show figure.where(kind: table): set block(breakable: true)

  // `supplement: none` also strips the number from the caption, so the caption
  // rule spells out the Hindi word and the number itself, like babel-hindi's
  // `तालिका 1.1: …` / `चित्र 1.1: …`.
  show figure.caption: it => context {
    let word = if it.kind == table { [तालिका] } else if it.kind == image { [चित्र] } else { none }
    if word == none {
      it
    } else {
      [#word #it.counter.display(it.numbering)#it.separator#it.body]
    }
  }

  set outline(indent: auto)
  show outline: set par(first-line-indent: 0pt)

  // Title page (`\maketitle`).
  {
    set align(center)
    v(3fr)
    text(size: 2.4em, weight: "bold", title)
    v(2em)
    text(size: 1.2em, author)
    v(1em)
    text(size: 1em, date.display("[day].[month].[year]"))
    v(4fr)
  }
  pagebreak(weak: true)

  body
}
