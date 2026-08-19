import argparse
import os
import sys
from fontTools.ttLib import TTFont, newTable
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.transformPen import TransformPen

# --- THE FIX: A custom pen to flatten composite glyphs on the fly ---
class FlatteningTTGlyphPen(TTGlyphPen):
    def __init__(self, glyphSet):
        # Passing 'None' forces the pen to treat everything as pure contours
        super().__init__(None)
        self.flatten_glyphSet = glyphSet

    def addComponent(self, glyphName, transformation):
        # When told to draw a component, intercept it, apply the math (scale/shift),
        # and draw it as raw paths instead!
        tPen = TransformPen(self, transformation)
        self.flatten_glyphSet[glyphName].draw(tPen)


def convert_cff_to_truetype(font: TTFont) -> TTFont:
    """Converts OpenType-CFF outlines to TrueType."""
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
        glyph_set[name].draw(cu_pen)
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
    maxp.maxPoints = maxp.maxContours = maxp.maxCompositePoints = maxp.maxCompositeContours = 0
    maxp.maxZones = 1
    maxp.maxTwilightPoints = maxp.maxStorage = maxp.maxFunctionDefs = maxp.maxInstructionDefs = maxp.maxStackElements = maxp.maxSizeOfInstructions = maxp.maxComponentElements = maxp.maxComponentDepth = 0
    font["maxp"] = maxp

    return font


def patch_metadata(font: TTFont, style_name: str, is_bold: bool, is_italic: bool):
    """Updates the internal font names, styles, and angles."""
    family_name = "Shobhika"
    ps_style = style_name.replace(" ", "")
    full_name = f"{family_name} {style_name}"
    ps_name = f"{family_name}-{ps_style}"

    name_records = {
        1: family_name,
        2: style_name,
        3: f"Transplant : {full_name}",
        4: full_name,
        6: ps_name,
        16: family_name,
        17: style_name,
    }

    name_table = font["name"]
    name_table.names = []

    for nameID, value in name_records.items():
        name_table.setName(value, nameID, platformID=3, platEncID=1, langID=0x409)
        name_table.setName(value, nameID, platformID=1, platEncID=0, langID=0)

    head = font["head"]
    if is_bold: head.macStyle |= 1 << 0
    else:       head.macStyle &= ~(1 << 0)
    if is_italic: head.macStyle |= 1 << 1
    else:         head.macStyle &= ~(1 << 1)

    if "OS/2" in font:
        os2 = font["OS/2"]
        os2.usWeightClass = 700 if is_bold else 400
        if is_italic:
            os2.fsSelection |= 1 << 0
            os2.fsSelection &= ~(1 << 6)
        else:
            os2.fsSelection &= ~(1 << 0)
            os2.fsSelection |= 1 << 6
        if is_bold: os2.fsSelection |= 1 << 5
        else:       os2.fsSelection &= ~(1 << 5)

    if "post" in font:
        if is_italic: font["post"].italicAngle = -11.0
        else:         font["post"].italicAngle = 0.0


def merge_and_patch(primary_path: str, secondary_path: str, output_path: str, style_name: str, is_bold: bool, is_italic: bool):
    for path in (primary_path, secondary_path):
        if not os.path.isfile(path):
            sys.exit(f"Error: Input font not found at '{path}'")

    print(f"Processing:\n  Italic Source : {primary_path}\n  Base Target   : {secondary_path}")

    f_primary = TTFont(primary_path)
    f_secondary = TTFont(secondary_path)

    # Standardize formats
    if "CFF " in f_secondary or "CFF2" in f_secondary:
        f_secondary = convert_cff_to_truetype(f_secondary)
    if "CFF " in f_primary or "CFF2" in f_primary:
        f_primary = convert_cff_to_truetype(f_primary)

    pri_glyf = f_primary["glyf"]
    sec_glyf = f_secondary["glyf"]
    pri_hmtx = f_primary["hmtx"]
    sec_hmtx = f_secondary["hmtx"]

    pri_glyph_set = f_primary.getGlyphSet()
    processed_glyphs = set()
    count = 0

    # 1. Transplant outlines by exact Glyph Name
    for name in f_primary.getGlyphOrder():
        if name in sec_glyf.glyphs and name not in processed_glyphs:
            pen = FlatteningTTGlyphPen(pri_glyph_set)
            pri_glyph_set[name].draw(pen)
            sec_glyf.glyphs[name] = pen.glyph()
            sec_hmtx.metrics[name] = pri_hmtx.metrics[name]
            processed_glyphs.add(name)
            count += 1

    # 2. Transplant outlines by Unicode (Catches renamed Cyrillic variants)
    pri_cmap = f_primary.getBestCmap()
    sec_cmap = f_secondary.getBestCmap()

    if pri_cmap and sec_cmap:
        for uni, pri_name in pri_cmap.items():
            if uni in sec_cmap:
                sec_name = sec_cmap[uni]
                if sec_name not in processed_glyphs:
                    pen = FlatteningTTGlyphPen(pri_glyph_set)
                    pri_glyph_set[pri_name].draw(pen)
                    sec_glyf.glyphs[sec_name] = pen.glyph()
                    sec_hmtx.metrics[sec_name] = pri_hmtx.metrics[pri_name]
                    processed_glyphs.add(sec_name)
                    count += 1

    print(f"    [Success] Surgically flattened and transplanted {count} italic glyphs.")

    patch_metadata(f_secondary, style_name, is_bold=is_bold, is_italic=is_italic)

    f_secondary.save(output_path)
    print(f"  -> Generated: {output_path}\n")

    f_primary.close()
    f_secondary.close()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input-dir", default=".")
    parser.add_argument("-o", "--output-dir", default=".")
    parser.add_argument("--shobhika-reg")
    parser.add_argument("--shobhika-bold")
    parser.add_argument("--pt-italic")
    parser.add_argument("--pt-bolditalic")

    args = parser.parse_args()

    def resolve(filename, explicit_path):
        if explicit_path: return explicit_path
        for ext in (".otf", ".ttf"):
            candidate = os.path.join(args.input_dir, filename + ext)
            if os.path.isfile(candidate): return candidate
        return os.path.join(args.input_dir, filename + ".ttf")

    shobhika_reg = resolve("Shobhika-Regular", args.shobhika_reg)
    shobhika_bold = resolve("Shobhika-Bold", args.shobhika_bold)
    pt_italic = resolve("PTSerif-Italic", args.pt_italic)
    pt_bolditalic = resolve("PTSerif-BoldItalic", args.pt_bolditalic)

    os.makedirs(args.output_dir, exist_ok=True)

    merge_and_patch(pt_italic, shobhika_reg, os.path.join(args.output_dir, "Shobhika-Italic.ttf"), "Italic", False, True)
    merge_and_patch(pt_bolditalic, shobhika_bold, os.path.join(args.output_dir, "Shobhika-BoldItalic.ttf"), "Bold Italic", True, True)

if __name__ == "__main__":
    main()
