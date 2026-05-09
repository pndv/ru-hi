# Project Skills & Knowledge Log: Hindi-Russian Migration

This document tracks the specialized skills and domain knowledge acquired or applied during the migration of the "Hindi-Russian Study Guide" from LaTeX to Typst.

## 🛠 Technical Skills

### Typst Migration & Integration
- **Syntax Conversion:** Mapping LaTeX packages (like `babel`, `biblatex`, `graphicx`) to Typst equivalents (`#import`, `#figure`, `#bibliography`).
- **Compilation Workflows:** Managing Typst builds with external font paths (`--font-path`) and output directory management.
- **Project Parity:** Auditing `.tex` vs `.typ` files to ensure consistent chapter structure during migration.

### SVG Asset Optimization
- **Bloat Removal:** Stripping Inkscape-specific metadata (`sodipodi`, `inkscape` namespaces) to reduce file size and improve parser compatibility.
- **SVG 2.0 to 1.1 Downgrading:** Identifying and removing unsupported CSS properties like `shape-inside` to ensure rendering across all PDF engines.
- **Direct XML Manipulation:** Surgical editing of SVG paths and text elements using shell tools and regex to fix syntax errors.

### Typography Management
- **Font Alignment:** Synchronizing typography between document source and graphical assets. Specifically, integrating the **Shobhika** font into SVG `font-family` styles to match the main Typst body text.
- **Font Inspection:** Using tools like `otfinfo` and `fc-list` to verify PostScript names and family names for correct engine mapping.

## 📚 Domain Knowledge

### Russian Linguistics
- **Orthography:** Correct usage of the Russian soft sign (**ь - мягкий знак**) and hard sign (**ъ - твёрдый знак**).
- **Adjective Declension:** Proper spelling of Russian descriptive adjectives (e.g., *мягкий* vs *мякий*).
- **Phonetics:** Transcription of Russian sounds into Hindi Devanagari script (e.g., [म्याग्कि ज़्नाक]).

### Hindi Anatomical Terminology
- **Linguistic Anatomy:** Distinguishing between standard anatomical terms (**तालु** - Palate) and colloquial/incorrect terms (**तलवा** - Sole) in the context of phonetics.
- **Technical Refinement:** Implementing specific distinctions like **कठोर तालु** (Hard Palate) and **कोमल तालु** (Soft Palate) for educational clarity.

## 🔍 Troubleshooting & Quality Assurance

### Compiler-Driven Diagnosis
- **Error Trace Analysis:** Utilized Typst's granular error reporting to pinpoint asset failures. For example, a "failed to parse SVG" error provided a specific line and column reference (`unknown token at 385:1`).
- **Binary/Text Validation:** Cross-referenced compiler output with `read_file` inspections to identify non-standard artifacts. In one instance, this led to the discovery of a stray `>` character appended outside the root `</svg>` tag, likely introduced during automated batch processing.
- **Surgical Correction:** Employed precise shell commands (e.g., `sed` with line-matching patterns like `/^>$/d`) to perform non-destructive cleanup across multiple assets simultaneously.

### Automated Auditing
- **Regex-based Validation:** Used `grep` and `sed` to perform project-wide audits for spelling inconsistencies (like `мякий` vs `мягкий`) and terminology errors, ensuring that fixes were applied globally rather than in isolation.
- **Regression Testing:** Re-ran the Typst compilation engine after every significant asset or source change to verify that structural integrity was maintained while achieving aesthetic goals.
