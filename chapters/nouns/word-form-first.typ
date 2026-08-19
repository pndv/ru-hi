// The LaTeX blobs annotated their twelve `;`-separated values with
// `%Именительный`, `%винительный`, `%Предложный`, `%Дательный`, `%Родительный`,
// `%Творительный` comments to keep track of which pair belonged to which case.
// That mapping is now carried by the argument names of `gencasetable`, in the
// same order the values appeared in, so the comments are no longer needed.
//
// The stress marks are normalised to a combining acute (U+0301): the source
// mixed precomposed Latin letters into Cyrillic words (`теáтр`, `здáние`) and
// LaTeX accent macros (`стак\'ан`, `óблако`).
#import "/template.typ": *

== शब्दों के रूप (प्रथम प्रकार) <sec:noun-endings-first-declension>

रूसी में सजीव और निर्जीव वस्तुओं के लिए अलग रूप होते हैं। हाँलाकि दोनों रूपों में अधिकतर समानतायें हैं, परंतु कुछ कारकों के लिए दोनों, जैसे कर्म कारक, में यह
रूप भिन्न हो जाते हैं @readyruss2021।

=== कठोर-अंत पुलिंग शब्दों का रूप (निर्जीव वस्तु) <subsec:noun-endings-first-declension-hard-inanimate-male>

#gencasetable(
  caption: [#sru[р]-कारांत संज्ञा \ #sru[теа́тр] = रंगमंच, थिएटर (theatre)],
  label-name: "tab:noun-endings-first-declension-hard-inanimate-male",
  nominative: ("теа́тр", "теа́тры"),
  accusative: ("теа́тр", "теа́тры"),
  prepositional: ("теа́тра", "теа́тров"),
  dative: ("теа́тре", "теа́трых"),
  genitive: ("теа́тру", "теа́трам"),
  instrumental: ("теа́тром", "теа́трами"),
)

इसी प्रकार: #ru[стака́н] (गिलास)

=== कठोर-अंत पुलिंग शब्दों का रूप (सजीव वस्तु) <subsec:noun-endings-first-declension-hard-animate-male>

#ru[ма́льчик] = बालक

#gencasetable(
  caption: [#sru[к]-कारांत संज्ञा],
  label-name: "tab:noun-endings-first-declension-hard-animate-male",
  nominative: ("ма́льчик", "ма́льчикы"),
  accusative: ("ма́льчика", "ма́льчиков"),
  prepositional: ("ма́льчика", "ма́льчиков"),
  dative: ("ма́льчике", "ма́льчиках"),
  genitive: ("ма́льчику", "ма́льчикам"),
  instrumental: ("ма́льчиком", "ма́льчиками"),
)

इसी प्रकार: #ru[сло́н] (हाथी/हस्ति)

=== कोमल-अंत #sru[й] पुलिंग शब्दों का रूप (निर्जीव वस्तु) <subsec:noun-endings-first-declension-y-inanimate-male>

#ru[музе́й] = म्‍यूजि़यम

#gencasetable(
  caption: [#sru[й]-कारांत संज्ञा],
  label-name: "tab:noun-endings-first-declension-y-inanimate-male",
  nominative: ("музе́й", "музеи"),
  accusative: ("музей", "музеи"),
  prepositional: ("музее", "музеях"),
  dative: ("музею", "музеям"),
  genitive: ("музея", "музеев"),
  instrumental: ("музеем", "музеями"),
)

=== कोमल-अंत #sru[ь (мякий знак)] पुलिंग शब्दों का रूप (निर्जीव वस्तु) <subsec:noun-endings-first-declension-b-inanimate-male>

#ru[портфе́ль] = ब्रीफ़केस / अटैची

#gencasetable(
  caption: [#sru[ь]-कारांत संज्ञा],
  label-name: "tab:noun-endings-first-declension-b-inanimate-male",
  nominative: ("портфе́ль", "портфе́ли"),
  accusative: ("портфе́ль", "портфе́ли"),
  prepositional: ("портфе́ле", "портфе́лях"),
  dative: ("портфе́лю", "портфе́лям"),
  genitive: ("портфе́ля", "портфе́лей"),
  instrumental: ("портфе́лем", "портфе́лями"),
)

इसी प्रकार: #ru[учуте́ль] (अध्यापक)

=== #sru[o]--कारांत नपुंसकलिंग शब्दों का रूप <subsec:noun-endings-first-declension-o-neuter>

#ru[кре́сло] = कुर्सी

#gencasetable(
  caption: [#sru[o]-कारांत संज्ञा],
  label-name: "tab:noun-endings-first-declension-o-neuter",
  nominative: ("кре́сло", "кре́сла"),
  accusative: ("кре́сло", "кре́сла"),
  prepositional: ("кре́сле", "кре́слах"),
  dative: ("кре́слу", "кре́слам"),
  genitive: ("кре́сла", "кре́сел"),
  instrumental: ("кре́слом", "кре́слами"),
)

इसी प्रकार: #ru[коле́но] (घुटना), #ru[о́блако] (मेघ, बादल), #ru[я́блоко] (सेब), #ru[боло́то] (दलदल), #ru[ви́но] (मदिरा)

=== #sru[е]--कारांत नपुंसकलिंग शब्दों का रूप <subsec:noun-endings-first-declension-e-neuter>

#ru[зда́ние] = बिल्डिंग

#gencasetable(
  caption: [#sru[е]-कारांत संज्ञा],
  label-name: "tab:noun-endings-first-declension-e-neuter",
  nominative: ("зда́ние", "зда́ния"),
  accusative: ("зда́ние", "зда́ния"),
  prepositional: ("зда́нии", "зда́ниях"),
  dative: ("зда́нию", "зда́ниям"),
  genitive: ("зда́ния", "зда́ний"),
  instrumental: ("зда́нием", "зда́ниями"),
)

इसी प्रकार: #ru[море́] (पर्वत), #ru[Полоте́нце] (तौलिया)

=== #sru[ё]--कारांत नपुंसकलिंग शब्दों का रूप <subsec:noun-endings-first-declension-yo-neuter>

#ru[бельё] = अंडरवियर (underwear)

#gencasetable(
  caption: [#sru[ё]-कारांत संज्ञा],
  label-name: "tab:noun-endings-first-declension-yo-neuter",
  nominative: ("бельё", "Белья"),
  accusative: ("бельё", "Белья"),
  prepositional: ("белье", "Бельях"),
  dative: ("белью", "Бельям"),
  genitive: ("белья", "Белей"),
  instrumental: ("бельём", "Бельями"),
)

इसी प्रकार: #ru[Жильё], #ru[шитьё], #ru[нытьё], #ru[питьё], #ru[остриё], #ru[ружьё], #ru[копьё], #ru[жульё], #ru[гнильё],
#ru[враньё], #ru[старьё], #ru[сырьё], #ru[чутьё], #ru[бритьё]
