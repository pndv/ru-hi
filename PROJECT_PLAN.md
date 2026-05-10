# Comprehensive Project Plan: Hindi-Russian Study Guide

## Phase 1: Foundation (Migration & Phonetics)
- **Typst Porting:** Finalize the conversion of all remaining `.tex` files to `.typ`.
- **Phonetic Consistency:** Audit Russian-to-Devanagari transcriptions for consistency (e.g., standardizing the use of `व्य` for `в` and `ओ` for `о`).
- **Special Signs Expansion:** Deepen the section on **ь** (soft sign) and **ъ** (hard sign) with comparative Hindi examples (e.g., relating `ь` to a soft *halant*).

## Phase 2: Core Grammar (The Case System)
- **Karaka Mapping:** Perform a contrastive analysis mapping the 6 Russian cases to the 8 Hindi **Karaka (कारक)**.
  - Accusative $\rightarrow$ कर्म कारक (Karm Karaka).
  - Genitive $\rightarrow$ संबंध कारक (Sambandh Karaka), etc.
- **Standardized Declensions:** Use the `#genCaseTable` function to generate consistent, high-quality tables for all noun genders.

## Phase 3: The Verb System (Conjugation & Aspect)
- **Conjugation Models:** Categorize and document Type 1 and Type 2 conjugation patterns.
- **Aspect Nuances:** Explain Perfective vs. Imperfective using Hindi tense structures (e.g., continuous vs. completed actions).
- **Verbs of Motion:** Develop visual diagrams in SVG/Typst to illustrate directional movement (towards vs. from).

## Phase 4: Practical Usage & Syntax
- **Word Order Contrast:** Compare Russian's flexible syntax with Hindi's SOV (Subject-Object-Verb) structure.
- **Localized Scenarios:** Add conversational sections (e.g., "At the Airport," "In the Bazaar") tailored for Indian learners.

## Phase 5: Final Polish & Indexing
- **Russian-Hindi Glossary:** Utilize Typst’s `#index` features to build a comprehensive bilingual glossary.
- **Bibliographic Cleanup:** Standardize the `bibliography.bib` using high-signal academic and comparative references.

---

## Essential References

### Existing Textbooks (Benchmarking)
- **"Russian for Indians"** by Hem Chandra Pande (Academic Standard).
- **"Hindi-Russian Teacher"** by Rajesh Jha (Self-Learning).
- **"Russian Language Grammar" (रूसी भाषा का व्याकरण)** by Hem Chandra Pande.

### Comparative Linguistics (Level-Up)
- **"India & Russia: Linguistic & Cultural Affinity"** by W.R. Rishi (Excellent cognate lists).
- **"Cognate Words in Sanskrit and Russian"** by Indu Lekha (Deep root analysis).
- **"A Comprehensive Russian Grammar"** by Terence Wade (Grammatical accuracy).
- **"Language and Style of the Vedic R̥ṣis"** by Tatyana Elizarenkova (Indo-European context).
