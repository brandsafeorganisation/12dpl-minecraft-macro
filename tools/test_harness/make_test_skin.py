#!/usr/bin/env python3
"""Write a test player skin for scenario 28 (run.sh calls it).

  python3 make_test_skin.py FILE     writes a 64 x 64 skin to FILE

The skin is a simple person drawn part by part in the block game's
layout: a face with eyes, hair, a teal shirt, blue trousers and grey
shoes, with a second layer (a fringe and an open green jacket) over it,
and wide (4 pixel) arms. Only the Python standard library is used."""
import random, sys
from make_test_pack import write_png

CLEAR  = (0, 0, 0, 0)
SKIN   = (224, 172, 132, 255)
HAIR   = (92, 60, 32, 255)
EYE    = (40, 60, 160, 255)
WHITE  = (240, 240, 240, 255)
MOUTH  = (160, 90, 80, 255)
SHIRT  = (40, 160, 160, 255)
JACKET = (40, 110, 50, 255)
JEANS  = (50, 70, 150, 255)
SHOE   = (100, 100, 100, 255)

def skin():
    px = [[CLEAR] * 64 for _ in range(64)]

    def fill(x, y, w, h, c):
        for j in range(y, y + h):
            for i in range(x, x + w):
                px[j][i] = c

    def box(u, v, w, h, d, c):
        """a part's six faces at (u, v): w wide, h tall, d deep"""
        fill(u + d, v, w * 2, d, c)          # top and bottom
        fill(u, v + d, 2 * (d + w), h, c)    # right, front, left, back

    # head: skin, hair on top, back and sides, a face on the front
    box(0, 0, 8, 8, 8, SKIN)
    fill(8, 0, 8, 8, HAIR)
    fill(24, 8, 8, 8, HAIR)
    fill(0, 8, 8, 3, HAIR); fill(16, 8, 8, 3, HAIR); fill(8, 8, 8, 2, HAIR)
    fill(9, 12, 2, 1, WHITE); fill(10, 12, 1, 1, EYE)
    fill(13, 12, 2, 1, WHITE); fill(13, 12, 1, 1, EYE)
    fill(11, 14, 2, 1, MOUTH)
    # hat layer: a fringe over the forehead
    fill(40, 8, 8, 1, HAIR); fill(41, 9, 2, 1, HAIR); fill(45, 9, 2, 1, HAIR)
    # body and arms (shirt, bare hands), legs (trousers, shoes)
    box(16, 16, 8, 12, 4, SHIRT)
    for u, v in ((40, 16), (32, 48)):
        box(u, v, 4, 12, 4, SHIRT)
        fill(u, v + 13, 16, 3, SKIN)
        fill(u + 8, v, 4, 4, SKIN)           # the hand's palm (bottom)
    for u, v in ((0, 16), (16, 48)):
        box(u, v, 4, 12, 4, JEANS)
        fill(u, v + 13, 16, 3, SHOE)
        fill(u + 8, v, 4, 4, SHOE)           # the sole (bottom)
    # jacket layer: open at the front, sleeves to the elbow
    box(16, 32, 8, 12, 4, JACKET)
    fill(22, 36, 4, 12, CLEAR)               # the open front
    for u, v in ((40, 32), (48, 48)):
        fill(u, v + 4, 16, 6, JACKET)
    return px

if __name__ == '__main__':
    if len(sys.argv) != 2: sys.exit(__doc__)
    open(sys.argv[1], 'wb').write(write_png(skin(), 64, 64, 3, 8, random.Random(28), 9))
