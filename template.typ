#let project(title: "", author: "", body) = {
  set document(title: title, author: author)
  set page(
    paper: "a4",
    margin: (inside: 2.5cm, outside: 2cm, y: 2cm),
    numbering: "i",
    number-align: center,
  )
  set text(font: ("Shobhika"), lang: "hi", region: "IN")
  set heading(numbering: "1.1")

  show regex("[\p{Cyrillic}\u0301\u0300]+"): set text(lang: "ru")

  // Title page
  align(center + horizon)[
    #block(text(weight: 700, 2.5em, title))
    #v(2em)
    #block(text(weight: 400, 1.5em, author))
  ]
  pagebreak()

  // Table of contents
  outline(depth: 3, indent: auto)
  pagebreak()
  
  // List of figures and tables
  outline(target: figure.where(kind: image), title: "List of Figures")
  pagebreak()
  outline(target: figure.where(kind: table), title: "List of Tables")
  pagebreak()

  set page(numbering: "1")
  counter(page).update(1)

  body
}

#let ruCursive(content) = {
  // Use a cursive font if available, otherwise it falls back correctly.
  set text(font: ("PT Serif", "Times New Roman", "Arial"), lang: "ru", style: "italic")
  content
}

// Conditional bibliography loader: avoids "multiple bibliographies" error
// when compiling individual chapter files standalone.
// Use load-bib(main: true) in main.typ, and load-bib() in chapter files.
// Source: https://forum.typst.app/t/how-to-share-bibliography-in-a-multi-file-setup/1605
#let load-bib(main: false) = {
  counter("bibs").step()
  context if main {
    [#bibliography("bibliography.yml", title: [संदर्भसूची], style: "ieee") <main-bib>]
  } else if query(<main-bib>) == () and counter("bibs").get().first() == 1 {
    bibliography("bibliography.yml", title: [संदर्भसूची], style: "ieee")
  }
}

#let genCaseTable(caption, fig_label, ..entries) = {
  let rows = entries.pos()
  // If entries were passed as a single string with semicolons (like in LaTeX)
  if rows.len() == 1 and rows.at(0).contains(";") {
    rows = rows.at(0).split(";").map(it => it.trim())
  }
  
  [
    #figure(
      table(
        columns: (1fr, 1fr, 1fr, 1fr),
        inset: 10pt,
        align: (left, left, left, left),
        table.header(
          [*कारक*], [*पादेय्ज़ (падеж)*], [*एकवचन*], [*बहुवचन*]
        ),
        [कर्ता], [इमेनितेल्नीय (именительный)], rows.at(0), rows.at(1),
        [कर्म], [विनीतेल्नीय (винительный)], rows.at(2), rows.at(3),
        [संबंध], [रोदीतेल्नीय (Родительный)], rows.at(4), rows.at(5),
        [अधिकरण], [प्रेद्लोज़्नीय (Предложный)], rows.at(6), rows.at(7),
        [संप्रदान], [दातेल्नीय (Дательный)], rows.at(8), rows.at(9),
        [करण], [त्वोरीतेल्नीय (Творительный)], rows.at(10), rows.at(11),
      ),
      caption: caption,
    ) #label(fig_label)
  ]
}
