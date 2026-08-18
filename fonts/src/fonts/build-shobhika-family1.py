import argparse
import os
import sys
import io
from fontTools.merge import Merger
from fontTools.ttLib import TTFont, newTable
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.pens.cu2quPen import Cu2QuPen

def convert_cff_to_truetype(font: TTFont) -> TTFont:
    """Converts an OpenType-CFF (.otf) font in-memory to TrueType (.ttf)."""
    if "CFF " not in font and "CFF2" not in font:
        return font

    print("    [Info] Converting PostScript (CFF) outlines to TrueType (glyf)...")
    glyph_set = font.getGlyphSet()
    glyf_table = newTable("glyf")
    glyph_order = font.getGlyphOrder()

    glyf_table.setGlyphOrder(glyph_order)
    glyf_table.glyphs = {}

    for name in glyph_order:
        tt_pen = TTGlyphPen(glyph_set)
        cu_pen = Cu2QuPen(tt_pen, max_err=1.0, reverse_direction=True)
        glyph = glyph_set[name]
        glyph.draw(cu_pen)
        glyf_table.glyphs[name] = tt_pen.glyph()

    font["glyf"] = glyf_table
    font["loca"] = newTable("loca")
    font["head"].glyphDataFormat = 0

    for table in ["CFF ", "CFF2", "VORG"]:
        if table in font:
            del font[table]

    font.sfntVersion = "\x00\x01\x00\x00"

    maxp = newTable("maxp")
    maxp.tableVersion = 0x00010000
    maxp.numGlyphs = len(glyph_order)
    maxp.maxPoints = 0
    maxp.maxContours = 0
    maxp.maxCompositePoints = 0
    maxp.maxCompositeContours = 0
    maxp.maxZones = 1
    maxp.maxTwilightPoints = 0
    maxp.maxStorage = 0
    maxp.maxFunctionDefs = 0
    maxp.maxInstructionDefs = 0
    maxp.maxStackElements = 0
    maxp.maxSizeOfInstructions = 0
    maxp.maxComponentElements = 0
    maxp.maxComponentDepth = 0
    font["maxp"] = maxp

    buf = io.BytesIO()
    font.save(buf)
    buf.seek(0)
    return TTFont(buf)


def patch_metadata(font_path: str, style_name: str, is_bold: bool, is_italic: bool):
    """Updates the internal font names, styles, and flags."""
    font = TTFont(font_path)
    family_name = "Shobhika"
    ps_style = style_name.replace(" ", "")
    full_name = f"{family_name} {style_name}"
    ps_name = f"{family_name}-{ps_style}"

    name_records = {
        1: family_name,
        2: style_name,
        3: f"Merged : {full_name}", # Unique Font Identifier
        4: full_name,
        6: ps_name,
        16: family_name,  # Critical for Typst fontdb grouping
        17: style_name,   # Critical for Typst fontdb grouping
    }

    # 1. Completely rewrite the Name Table to prevent "PT Serif" ghosts
    name_table = font["name"]
    name_table.names = []

    for nameID, value in name_records.items():
        # Windows English
        name_table.setName(value, nameID, platformID=3, platEncID=1, langID=0x409)
        # Mac English
        name_table.setName(value, nameID, platformID=1, platEncID=0, langID=0)

    # 2. Update 'head' table flags
    head = font["head"]
    if is_bold:
        head.macStyle |= 1 << 0
    else:
        head.macStyle &= ~(1 << 0)

    if is_italic:
        head.macStyle |= 1 << 1
    else:
        head.macStyle &= ~(1 << 1)

    # 3. Update 'OS/2' table flags & weight (Typst relies on this)
    if "OS/2" in font:
        os2 = font["OS/2"]
        os2.usWeightClass = 700 if is_bold else 400

        if is_italic:
            os2.fsSelection |= 1 << 0
            os2.fsSelection &= ~(1 << 6) # Clear Regular bit
        else:
            os2.fsSelection &= ~(1 << 0)
            os2.fsSelection |= 1 << 6

        if is_bold:
            os2.fsSelection |= 1 << 5
        else:
            os2.fsSelection &= ~(1 << 5)

    # 4. Update 'post' table (Typst checks this angle for Oblique/Italic logic)
    if "post" in font:
        if is_italic:
            font["post"].italicAngle = -11.0
        else:
            font["post"].italicAngle = 0.0

    font.save(font_path)
    font.close()


def merge_and_patch(primary_path: str, secondary_path: str, output_path: str, style_name: str, is_bold: bool, is_italic: bool):
    for path in (primary_path, secondary_path):
        if not os.path.isfile(path):
            sys.exit(f"Error: Input font not found at '{path}'")

    print(f"Processing:\n  Primary   : {primary_path}\n  Secondary : {secondary_path}")

    f_primary = TTFont(primary_path)
    f_secondary = TTFont(secondary_path)

    has_cff_pri = "CFF " in f_primary or "CFF2" in f_primary
    has_cff_sec = "CFF " in f_secondary or "CFF2" in f_secondary

    if has_cff_pri != has_cff_sec:
        f_primary = convert_cff_to_truetype(f_primary)
        f_secondary = convert_cff_to_truetype(f_secondary)

    # fontTools.merge requires file paths or memory streams, not raw TTFont objects
    buf_primary = io.BytesIO()
    f_primary.save(buf_primary)
    buf_primary.seek(0)

    buf_secondary = io.BytesIO()
    f_secondary.save(buf_secondary)
    buf_secondary.seek(0)

    # Perform the exact merge using the correct method
    merger = Merger()
    merged_font = merger.merge([buf_primary, buf_secondary])
    merged_font.save(output_path)

    merged_font.close()
    f_primary.close()
    f_secondary.close()

    patch_metadata(output_path, style_name, is_bold=is_bold, is_italic=is_italic)
    print(f"  -> Generated: {output_path}\n")


def main():
    parser = argparse.ArgumentParser(description="Merge PT Serif italics into Shobhika (handles OTF/TTF mismatch).")
    parser.add_argument("-i", "--input-dir", default=".", help="Directory with input fonts")
    parser.add_argument("-o", "--output-dir", default=".", help="Directory for generated fonts")
    parser.add_argument("--shobhika-reg", help="Path to Shobhika-Regular (.otf or .ttf)")
    parser.add_argument("--shobhika-bold", help="Path to Shobhika-Bold (.otf or .ttf)")
    parser.add_argument("--pt-italic", help="Path to PTSerif-Italic (.otf or .ttf)")
    parser.add_argument("--pt-bolditalic", help="Path to PTSerif-BoldItalic (.otf or .ttf)")

    args = parser.parse_args()

    def resolve(filename, explicit_path):
        if explicit_path:
            return explicit_path
        for ext in (".otf", ".ttf"):
            candidate = os.path.join(args.input_dir, filename + ext)
            if os.path.isfile(candidate):
                return candidate
        return os.path.join(args.input_dir, filename + ".ttf")

    shobhika_reg = resolve("Shobhika-Regular", args.shobhika_reg)
    shobhika_bold = resolve("Shobhika-Bold", args.shobhika_bold)
    pt_italic = resolve("PTSerif-Italic", args.pt_italic)
    pt_bolditalic = resolve("PTSerif-BoldItalic", args.pt_bolditalic)

    os.makedirs(args.output_dir, exist_ok=True)

    merge_and_patch(
        primary_path=pt_italic,
        secondary_path=shobhika_reg,
        output_path=os.path.join(args.output_dir, "Shobhika-Italic.ttf"),
        style_name="Italic",
        is_bold=False,
        is_italic=True,
    )

    merge_and_patch(
        primary_path=pt_bolditalic,
        secondary_path=shobhika_bold,
        output_path=os.path.join(args.output_dir, "Shobhika-BoldItalic.ttf"),
        style_name="Bold Italic",
        is_bold=True,
        is_italic=True,
    )

if __name__ == "__main__":
    main()
