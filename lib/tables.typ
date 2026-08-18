// Table helpers.
//
// Reproduces the `ltablex` + `booktabs` look of the LaTeX source: a 1pt rule at
// the top and the bottom, a 0.5pt rule under the header, generous vertical insets
// standing in for `\renewcommand{\arraystretch}{1.5}`, a header row that repeats
// when the table breaks across pages (`\endhead`), and the closing
// `इति तालिका N.N` line of `\endlastfoot`.
//
// The per-page `अगले पृष्ट पर जारी` notice of `\endfoot` is dropped: Typst's
// `table.footer` repeats on *every* page including the last one, so it cannot
// express "continued on the next page".

#import "lang.typ": ru

#let booktabs-table(
  caption: none,
  label-name: none,
  columns: auto,
  halign: auto,
  header: none,
  ..body,
) = {
  let ncols = if type(columns) == int {
    columns
  } else if type(columns) == array {
    columns.len()
  } else {
    1
  }

  let closing = if label-name == none {
    ()
  } else {
    (
      table.cell(
        colspan: ncols,
        align: right,
        inset: (x: 6pt, y: 5pt),
        text(size: 0.85em)[इति तालिका #ref(label(label-name))],
      ),
    )
  }

  let fig = figure(
    kind: table,
    caption: caption,
    table(
      columns: columns,
      align: halign,
      stroke: none,
      inset: (x: 6pt, y: 7pt),
      table.hline(stroke: 1pt),
      ..if header == none { () } else { (table.header(..header, table.hline(stroke: 0.5pt)),) },
      ..body.pos(),
      table.hline(stroke: 1pt),
      ..closing,
    ),
  )

  if label-name == none { fig } else [#fig#label(label-name)]
}

// `\gencasetable{caption;label;12 forms}` with named arguments instead of one
// `;`-separated blob: each case takes a `(singular, plural)` pair, so a swapped
// value cannot slip through unnoticed.
//
// The row order and the कारक <-> падеж pairing are copied verbatim from
// `main.tex`, including the `संबंध` / `Предложный` row.
#let gencasetable(
  caption: none,
  label-name: none,
  nominative: (),
  accusative: (),
  prepositional: (),
  dative: (),
  genitive: (),
  instrumental: (),
) = {
  let row(hi, rus, forms) = {
    assert(
      type(forms) == array and forms.len() == 2,
      message: "gencasetable: each case needs a (singular, plural) pair, got " + repr(forms),
    )
    (hi, ru(rus), ru(forms.at(0)), ru(forms.at(1)))
  }

  booktabs-table(
    caption: caption,
    label-name: label-name,
    columns: (1fr, 1fr, 1fr, 1fr),
    header: ([*कारक*], [*#ru[падеж]*], [*एकवचन*], [*बहुवचन*]),
    ..row([कर्ता], "именительный", nominative),
    ..row([कर्म], "винительный", accusative),
    ..row([संबंध], "Предложный", prepositional),
    ..row([संप्रदान], "Дательный", dative),
    ..row([अधिकरण], "Родительный", genitive),
    ..row([करण], "Творительный", instrumental),
  )
}
