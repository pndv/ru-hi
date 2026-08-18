#import "/template.typ": *

== सारांश तालिका <sec:case-summary-table>

// The `\par`-stacked questions of the LaTeX cells become paragraph breaks inside
// a content block, so every question keeps its own line.
#booktabs-table(
  caption: [कारक],
  label-name: "tab:case-summary-table",
  columns: (auto, 1fr, auto, 1fr),
  halign: (col, _) => if col == 0 or col == 2 { center + horizon } else { left + horizon },
  header: ([*कारक*], [*प्रश्न*], [*#ru[падеж]*], [*#ru[вопрос]*]),
  [कर्ता],
  [किसने],
  ru[именительный],
  [#ru[кто?]

    #ru[что?]],
  [कर्म],
  [किसको],
  ru[винительный],
  [#ru[кого?]

    #ru[что?]],
  [संबंध],
  [किसका

    किसके

    किसकी],
  ru[Предложный],
  [#ru[о ком?]

    #ru[о чём?]],
  [संप्रदान],
  [किसके लिए],
  ru[Дательный],
  [#ru[кому?]

    #ru[чему?]],
  [अधिकरण],
  [में, पर],
  ru[Родительный],
  [#ru[кого?]

    #ru[чего?]],
  [करण],
  [किससे (किसके द्वारा)],
  ru[Творительный],
  [#ru[кем?]

    #ru[чем?]

    #ru[за кем?]

    #ru[за чем?]],
  [अपादान],
  [किससे (अलगाव)],
  ru[Творительный],
  [#ru[с кем?]

    #ru[с чем?]

    #ru[от кем?]

    #ru[от чем?]],
)
