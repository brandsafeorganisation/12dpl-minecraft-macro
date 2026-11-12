#!/usr/bin/env python3
"""Write small font files for scenario 19 into packs/ (ignored by git).

They only hold what the macro reads: the table directory and a "name"
table. Each tests one way a family name can be stored:

  test_font.ttf        Windows (UTF-16) names in two languages; the
                       English one must win: "Cubeland Test Sans"
  test_mac.otf         only a Mac Roman name: "Mac Only Font"
  test_collection.ttc  a collection whose first font is "First Of Two"
  not_a_font.ttf       text, which must be refused
"""
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "packs")


def name_table(records):
    """records: (platform, encoding, language, name_id, bytes)"""
    strings = b""
    rows = b""
    for platform, encoding, language, name_id, data in records:
        rows += struct.pack(">HHHHHH", platform, encoding, language, name_id, len(data), len(strings))
        strings += data
    header = struct.pack(">HHH", 0, len(records), 6 + 12 * len(records))
    return header + rows + strings


def font(records, base=0):
    """A font whose table directory starts at base and has a dummy
    table before the name table"""
    tables = [(b"head", b"\0" * 54), (b"name", name_table(records))]
    directory = struct.pack(">IHHHH", 0x00010000, len(tables), 0, 0, 0)
    offset = base + 12 + 16 * len(tables)
    body = b""
    for tag, data in tables:
        directory += tag + struct.pack(">III", 0, offset + len(body), len(data))
        body += data + b"\0" * (-len(data) % 4)
    return directory + body


def windows(text, language=1033, name_id=1):
    return (3, 1, language, name_id, text.encode("utf-16-be"))


def main():
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "test_font.ttf"), "wb") as f:
        f.write(font([windows("Cubeland Test Sans Regular", name_id=4),
                      windows("Cubeland Prueba", language=3082),
                      windows("Cubeland Test Sans")]))
    with open(os.path.join(OUT, "test_mac.otf"), "wb") as f:
        f.write(font([(1, 0, 0, 1, b"Mac Only Font")]))
    first = font([windows("First Of Two")], base=20)
    with open(os.path.join(OUT, "test_collection.ttc"), "wb") as f:
        f.write(b"ttcf" + struct.pack(">HHI", 1, 0, 2) + struct.pack(">II", 20, 20 + len(first)) + first
                + font([windows("Second Of Two")], base=20 + len(first)))
    with open(os.path.join(OUT, "not_a_font.ttf"), "w") as f:
        f.write("This is not a font, just some text.\n")
    print("wrote 4 font files to", OUT)


if __name__ == "__main__":
    main()
