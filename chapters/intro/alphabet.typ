#import "/template.typ": *

== वर्णमाला <sec:intro-alpha-list>

// Every row of the alphabet table is built from the two forms of one letter:
// the Italics column shows the lowercase letter in Shobhika's italic face
// (`\ruit`) and the two Cursive columns show both forms in Marck Script
// (`\ruscursive`), so a row can never fall out of step with itself.
#let letter(big, small, hindi) = (
  ru(big),
  ru(small),
  ruit(small),
  ruscursive(big),
  ruscursive(small),
  hindi,
)

#booktabs-table(
  caption: [वर्णमाला],
  label-name: "tab:alphabet",
  columns: (auto, auto, auto, auto, auto, 1fr),
  halign: (col, _) => if col == 5 { left + horizon } else { center + horizon },
  header: (
    [*बड़ी लिपि*],
    [*छोटी लिपि*],
    [*Italics*],
    [*Big Cursive*],
    [*Small Cursive*],
    [*हिन्दी उच्चारण*],
  ),
  ..letter("А", "а", [अ]),
  ..letter("Б", "б", [ब]),
  ..letter("В", "в", [व]),
  ..letter("Г", "г", [ग]),
  ..letter("Д", "д", [ड]),
  ..letter("Е", "е", [येह्]),
  ..letter("Ё", "ё", [यो]),
  ..letter("Ж", "ж", [क्ज़, अंग्रेजी भाषा के _tre#underline[asu]re_\/_ट्रेज़र_ के ज़ कि भांति]),
  ..letter("З", "з", [ज़]),
  ..letter("И", "и", [इ]),
  ..letter("Й", "й", [य]),
  ..letter("К", "к", [क]),
  ..letter("Л", "л", [ल]),
  ..letter("М", "м", [म]),
  ..letter("Н", "н", [ह]),
  ..letter("О", "о", [ओ]),
  ..letter("П", "п", [प]),
  ..letter("Р", "р", [र]),
  ..letter("С", "с", [स]),
  ..letter("Т", "т", [ट]),
  ..letter("У", "у", [उ]),
  ..letter("Ф", "ф", [फ]),
  ..letter("Х", "х", [ख]),
  ..letter("Ц", "ц", [त्स]),
  ..letter("Ч", "ч", [च]),
  ..letter("Ш", "ш", [श]),
  ..letter("Щ", "щ", [ष]),
  ..letter("Ъ", "ъ", [@subsubsec:alpha-pronounce-special-char-hard भाग देखिए]),
  ..letter("Ы", "ы", [@subsubsec:alpha-pronounce-special-char-oui भाग देखिए]),
  ..letter(
    "Ь",
    "ь",
    [@subsubsec:alpha-pronounce-special-char-soft भाग देखिए#index-see("ь", "мякий знак")],
  ),
  ..letter("Э", "э", [ए]),
  ..letter("Ю", "ю", [यू]),
  ..letter("Я", "я", [या]),
)
