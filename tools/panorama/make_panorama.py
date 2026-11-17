#!/usr/bin/env python3
"""Make the title screen's panorama, src/render/panorama_data.4dm.

The harness takes eight 90 degree views all round one spot of a
generated world (panorama_shots.txt, 45 degrees apart). This script
reprojects them onto a cylinder, PANO_COLUMNS cells all the way round
and PANO_ROWS cells high, softens it a little, cuts it down to
PANO_COLOURS colours and writes the 12dPL that fills the macro's
panorama table: one panorama_set_colour call a colour and one
panorama_set_row call a row (a character a cell; see
panorama_set_row in src/render/render_menu.4dm).

    cd tools/test_harness && ./run.sh ../panorama/panorama_shots.txt
    python3 tools/panorama/make_panorama.py

It reads tools/test_harness/run/out/pano0..7.png, keeps a copy of the
result as tools/panorama/panorama.png and needs Pillow.
"""
import math
import os
import sys

from PIL import Image, ImageFilter

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SHOTS = os.path.join(ROOT, "tools", "test_harness", "run", "out")
OUT = os.path.join(ROOT, "src", "render", "panorama_data.4dm")
PICTURE = os.path.join(ROOT, "tools", "panorama", "panorama.png")
COLUMNS, ROWS, COLOURS = 640, 96, 64
VIEWS = 8
STRIP = 22            # the status strip under the 3D view, in pixels
SAMPLES = 3           # samples a cell in each direction


def sample(img, x, y):
    w, h = img.size
    x = min(max(x, 0.0), w - 1.001)
    y = min(max(y, 0.0), h - 1.001)
    x0, y0 = int(x), int(y)
    fx, fy = x - x0, y - y0
    p = img.load()
    out = [0.0, 0.0, 0.0]
    for (dx, dy, wgt) in ((0, 0, (1 - fx) * (1 - fy)), (1, 0, fx * (1 - fy)), (0, 1, (1 - fx) * fy), (1, 1, fx * fy)):
        c = p[x0 + dx, y0 + dy]
        for k in range(3):
            out[k] += c[k] * wgt
    return out


def main():
    shots = []
    for k in range(VIEWS):
        path = os.path.join(SHOTS, "pano%d.png" % k)
        if not os.path.exists(path):
            sys.exit("make_panorama: no %s (run the harness scenario first)" % path)
        img = Image.open(path).convert("RGB")
        w, h = img.size
        shots.append(img.crop((0, 0, w, h - STRIP)))
    w, h = shots[0].size
    focal = (w / 2.0) / math.tan(math.radians(45))          # the views are 90 degrees wide
    cx, cy = w / 2.0, h / 2.0
    cell_angle = 2 * math.pi / COLUMNS                      # square cells: as tall as they are wide
    pano = Image.new("RGB", (COLUMNS, ROWS))
    px = pano.load()
    for col in range(COLUMNS):
        for row in range(ROWS):
            acc = [0.0, 0.0, 0.0]
            for sx in range(SAMPLES):
                for sy in range(SAMPLES):
                    # yaw grows to the right (the game turns right for a larger yaw)
                    yaw = (col + (sx + 0.5) / SAMPLES) * cell_angle
                    up = ((ROWS / 2.0) - (row + (sy + 0.5) / SAMPLES)) * cell_angle
                    view = int(round(yaw / (2 * math.pi / VIEWS))) % VIEWS
                    off = yaw - view * (2 * math.pi / VIEWS)
                    off = (off + math.pi) % (2 * math.pi) - math.pi
                    x = cx + focal * math.tan(off)
                    y = cy - focal * math.tan(up) / math.cos(off)
                    c = sample(shots[view], x, y)
                    for k in range(3):
                        acc[k] += c[k]
            n = SAMPLES * SAMPLES
            px[col, row] = tuple(int(a / n + 0.5) for a in acc)
    pano = pano.filter(ImageFilter.GaussianBlur(0.6))
    small = pano.quantize(colors=COLOURS, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    palette = small.getpalette()[:3 * COLOURS]
    while len(palette) < 3 * COLOURS:
        palette += [0, 0, 0]
    small.convert("RGB").save(PICTURE)
    cells = small.load()

    def char(index):          # colour index 0..63 -> one character
        code = 48 + index
        if code == 92:
            return "~"
        if code == 63:
            return "!"
        return chr(code)

    lines = ["// ----------------------------------------------------------------",
             "// The title screen's panorama. Written by tools/panorama/",
             "// make_panorama.py from views of a generated world: run that",
             "// script, don't edit this file.",
             "// ----------------------------------------------------------------",
             "",
             "void panorama_load()",
             "// ----------------------------------------------------------------",
             "// Fill the panorama table the first time it is needed",
             "// ----------------------------------------------------------------",
             "{",
             "  if (g_pano_ready) return;",
             "  g_pano_ready = 1;"]
    for i in range(COLOURS):
        lines.append("  panorama_set_colour(%d, %d, %d, %d);" % (i + 1, palette[3 * i], palette[3 * i + 1], palette[3 * i + 2]))
    for row in range(ROWS):
        text = "".join(char(cells[col, row]) for col in range(COLUMNS))
        lines.append('  panorama_set_row(%d, "%s");' % (row + 1, text))
    lines.append("}")
    with open(OUT, "w", newline="\n") as f:
        f.write("\n".join(lines) + "\n")
    runs = sum(1 + sum(1 for c in range(1, COLUMNS) if cells[c, r] != cells[c - 1, r]) for r in range(ROWS))
    print("wrote", os.path.relpath(OUT, ROOT), "-", runs, "runs all round,", runs * 860 // (COLUMNS * 520 // ROWS * 1) // 1, "or so on screen")


if __name__ == "__main__":
    main()
