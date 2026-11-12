#!/usr/bin/env python3
"""Make a resource pack that exercises the macro's zip, deflate and PNG
code, and check what the macro decoded from it.

  python3 make_test_pack.py make            writes packs/test_pack.zip,
                                            packs/test_pack/ (the same
                                            images unzipped) and
                                            packs/test_pack_expected.json
  python3 make_test_pack.py check FILE      compares FILE (written by the
                                            dump_textures hook) with what
                                            each texture should be

Every image has at most 8 colours, so the macro's colour reduction keeps
them exactly. The images cycle through every PNG colour type and bit
depth the macro supports (grey 1/2/4/8/16 bit, RGB 8/16, palette 1/2/4/8
with transparency, grey + alpha, RGBA 8/16), all five row filters,
stored and compressed deflate data, images bigger than 16 x 16 and a tall
animation strip. Mob skins (64 x 32 cow and pig skins and a 128 x 128 zombie, so the
scaling to a 64 pixel wide layout is tested) check that each mob part is
sampled from the right rectangle, turned the right way. The zip mixes stored and deflated entries and ends with
a comment, so the end record has to be searched for.
Only the Python standard library is used."""
import json, os, random, re, struct, sys, zipfile, zlib

HERE = os.path.dirname(os.path.abspath(__file__))
MACRO = os.path.normpath(os.path.join(HERE, '..', '..'))
PACKS = os.path.join(HERE, 'packs')
COLORMAP_AT = (51, 173)

def map_entries():
    """(tex macro name, kind, name, tint, overlay) from pack_map_entry()"""
    src = open(os.path.join(MACRO, 'src', 'blocks', 'resource_pack.4dm')).read()
    return [(t.strip(), k, n, tint, o) for t, k, n, tint, o in re.findall(
        r'pack_entry\(p_tex, p_kind, p_name, p_tint, p_overlay, (\w+(?:\s*\+\s*\d+)?)\s*, "(\w+)"\s*, "([\w/]+)"\s*, (\w+)\s*, "(\w*)"\)', src)]

def part_entries():
    """(tex macro name, skin name, x, y, w, h, turn macro) from pack_map_part()"""
    src = open(os.path.join(MACRO, 'src', 'blocks', 'resource_pack.4dm')).read()
    return [(t, n, int(x), int(y), int(w), int(h), turn) for t, n, x, y, w, h, turn in re.findall(
        r'pack_part\(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, (\w+)\s*, "([\w/]+)"\s*, (\d+)\s*, (\d+)\s*, (\d+)\s*, (\d+)\s*, (\w+)\s*\)', src)]

def expected_part(pixels, width, x, y, w, h, turn):
    """the 16 x 16 picture the macro samples from a skin rectangle"""
    skin = macro_value('PACK_SKIN_WIDTH')
    rx, ry = x * width // skin, y * width // skin
    rw, rh = max(1, w * width // skin), max(1, h * width // skin)
    out = []
    for v in range(1, 17):
        for u in range(1, 17):
            a, b = u, v
            if turn == 'PACK_TURN_RIGHT': a, b = v, 17 - u
            elif turn == 'PACK_TURN_HALF': a, b = 17 - u, 17 - v
            elif turn == 'PACK_TURN_LEFT': a, b = 17 - v, u
            px = rx + ((2 * a - 1) * rw) // 32
            py = ry + ((2 * b - 1) * rh) // 32
            out.append(list(pixels[py][px]))
    return out

def macro_value(name):
    if '+' in name:
        base, offset = name.split('+')
        return macro_value(base.strip()) + int(offset)
    for header in ('textures.h', 'resource_pack.h'):
        m = re.search(r'#define\s+' + name + r'\s+(\w+)', open(os.path.join(MACRO, 'include', 'blocks', header)).read())
        if m: return int(m.group(1)) if m.group(1).isdigit() else macro_value(m.group(1))
    raise KeyError(name)

# ---------------------------------------------------------------- PNG writer
def chunk(kind, data):
    return struct.pack('>I', len(data)) + kind + data + struct.pack('>I', zlib.crc32(kind + data) & 0xffffffff)

def pack_bits(values, depth):
    out = bytearray(); acc = 0; n = 0
    for v in values:
        acc = (acc << depth) | v; n += depth
        if n == 8: out.append(acc); acc = 0; n = 0
    if n: out.append(acc << (8 - n))
    return bytes(out)

def filter_rows(rows, bpp, rng):
    out = bytearray(); prev = bytes(len(rows[0]))
    for row in rows:
        f = rng.randrange(5); line = bytearray([f])
        for i, x in enumerate(row):
            a = row[i - bpp] if i >= bpp else 0
            b = prev[i]
            c = prev[i - bpp] if i >= bpp else 0
            if f == 0: p = 0
            elif f == 1: p = a
            elif f == 2: p = b
            elif f == 3: p = (a + b) // 2
            else:
                e = a + b - c; pa, pb, pc = abs(e - a), abs(e - b), abs(e - c)
                p = a if pa <= pb and pa <= pc else (b if pb <= pc else c)
            line.append((x - p) & 255)
        out += line; prev = row
    return bytes(out)

def write_png(pixels, w, h, ctype, depth, rng, level):
    """pixels: list of rows of (r,g,b,a); returns PNG bytes"""
    channels = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}[ctype]
    extra = b''
    palette = []
    if ctype == 3:
        for row in pixels:
            for p in row:
                if p not in palette: palette.append(p)
        rng.shuffle(palette)
        extra = chunk(b'PLTE', b''.join(bytes(p[:3]) for p in palette))
        if any(p[3] < 255 for p in palette):
            extra += chunk(b'tRNS', bytes(p[3] for p in palette))
    rows = []
    for row in pixels:
        vals = []
        for p in row:
            if ctype == 3: vals.append(palette.index(p))
            elif ctype == 0: vals.append(p[0])
            elif ctype == 4: vals += [p[0], p[3]]
            elif ctype == 2: vals += list(p[:3])
            else: vals += list(p)
        if depth == 16:
            raw = b''.join(bytes([v, rng.randrange(256)]) for v in vals)
        elif depth == 8:
            raw = bytes(vals)
        else:
            raw = pack_bits(vals, depth)
        rows.append(raw)
    bpp = max(1, channels * depth // 8)
    data = zlib.compress(filter_rows(rows, bpp, rng), level)
    ihdr = struct.pack('>IIBBBBB', w, h, depth, ctype, 0, 0, 0)
    return b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', ihdr) + extra + chunk(b'IDAT', data) + chunk(b'IEND', b'')

# ---------------------------------------------------------------- images
ENCODINGS = [(0, 1), (0, 2), (0, 4), (0, 8), (0, 16), (2, 8), (2, 16), (3, 1), (3, 2), (3, 4), (3, 8),
             (4, 8), (6, 8), (6, 16)]

def grey_levels(depth):
    top = (1 << depth) - 1
    return [v for v in range(top + 1)], top

def make_image(rng, encoding, sprite, size, tall, colours=8):
    ctype, depth = encoding
    # colours: up to 7 solid plus see-through for sprites
    if ctype in (0, 4):
        levels = list(range(256)) if depth >= 8 else grey_levels(depth)[0]
        solid = [(v, v, v, 255) for v in rng.sample(levels, min(len(levels), colours - 1 if sprite else colours))]
    else:
        count = colours - 1 if sprite else colours
        if ctype == 3: count = min(count, (1 << depth) - (1 if sprite else 0))
        solid = [(rng.randrange(256), rng.randrange(256), rng.randrange(256), 255) for _ in range(count)]
    transparent = (0, 0, 0, 0)
    can_hide = sprite and ctype in (3, 4, 6)
    w, h = size, size * (4 if tall else 1)
    pixels = []
    for y in range(h):
        row = []
        for x in range(w):
            if can_hide and rng.random() < 0.4: row.append(transparent)
            else: row.append(rng.choice(solid))
        pixels.append(row)
    return pixels, w, h

def grey_value(v, depth):
    # what the macro scales a grey sample of this depth to
    if depth >= 8: return v
    return v * 255 // ((1 << depth) - 1)

def expected_16(pixels, w, h, encoding):
    """the 16 x 16 picture the macro should sample (top square)"""
    ctype, depth = encoding
    side = min(w, h); out = []
    for v in range(1, 17):
        for u in range(1, 17):
            x = ((2 * u - 1) * side) // 32; y = ((2 * v - 1) * side) // 32
            r, g, b, a = pixels[y][x]
            if ctype in (0, 4):
                r = g = b = grey_value(r, depth)
            out.append([r, g, b, a])
    return out

def make():
    rng = random.Random(1234)
    os.makedirs(PACKS, exist_ok=True)
    files = {}
    expected = {}
    entries = map_entries()
    tints = {}

    # colormaps: one 256 x 256 RGB image each, with the meadow colour at COLORMAP_AT
    for name in ('grass', 'foliage'):
        colour = (rng.randrange(256), rng.randrange(256), rng.randrange(256))
        tints[name] = colour
        pixels = [[(40, 40, 40, 255)] * 256 for _ in range(256)]
        pixels[COLORMAP_AT[1]][COLORMAP_AT[0]] = colour + (255,)
        files['colormap/' + name] = write_png(pixels, 256, 256, 2, 8, rng, 6)

    water = (macro_value('PACK_WATER_R'), macro_value('PACK_WATER_G'), macro_value('PACK_WATER_B'))
    first_sprite = macro_value('TEX_FIRST_SPRITE')

    overlay_pixels = None
    for n, (tex, kind, name, tint, overlay) in enumerate(entries):
        tex_id = macro_value(tex)
        sprite = tex_id >= first_sprite
        encoding = ENCODINGS[n % len(ENCODINGS)]
        size = 32 if n % 9 == 4 else 16
        tall = (n % 11 == 6)
        if tint != 'PACK_TINT_NONE' and encoding[0] not in (0, 4):
            encoding = (0, 8)               # tinted images are grey in real packs
        # with an overlay the two images share the 8 colours
        pixels, w, h = make_image(rng, encoding, sprite, size, tall, 4 if overlay else 8)
        level = [0, 1, 9][n % 3]
        files[kind + '/' + name] = write_png(pixels, w, h, encoding[0], encoding[1], rng, level)
        picture = expected_16(pixels, w, h, encoding)

        if overlay:
            # the overlay is grey, tinted with the grass colour and drawn over the solid pixels
            opix, ow, oh = make_image(rng, (6, 8), True, 16, False, 4)
            opix = [[(p[0], p[0], p[0], p[3]) for p in row] for row in opix]
            files[kind + '/' + overlay] = write_png(opix, ow, oh, 6, 8, rng, 9)
            over = expected_16(opix, ow, oh, (6, 8))
            t = tints['grass']
            for i, p in enumerate(over):
                if p[3] >= 128:
                    picture[i] = [p[0] * t[0] // 255, p[1] * t[1] // 255, p[2] * t[2] // 255, 255]

        if tint != 'PACK_TINT_NONE':
            t = {'PACK_TINT_GRASS': tints['grass'], 'PACK_TINT_FOLIAGE': tints['foliage'],
                 'PACK_TINT_WATER': water}[tint]
            picture = [[p[0] * t[0] // 255, p[1] * t[1] // 255, p[2] * t[2] // 255, p[3]] for p in picture]

        expected[str(tex_id)] = {'name': kind + '/' + name, 'encoding': list(encoding), 'size': [w, h],
                                 'sprite': sprite, 'pixels': picture}

    # mob skins: 8 colours each, solid (mob textures have no holes)
    skins = {}
    for name, (w, h, ctype) in {'cow/cow': (64, 32, 2), 'pig/pig': (64, 32, 6), 'zombie/zombie': (128, 128, 6)}.items():
        colours = [(rng.randrange(256), rng.randrange(256), rng.randrange(256), 255) for _ in range(8)]
        pixels = [[rng.choice(colours) for _ in range(w)] for _ in range(h)]
        skins[name] = (pixels, w)
        files['entity/' + name] = write_png(pixels, w, h, ctype, 8, rng, 6)
    for tex, name, x, y, w, h, turn in part_entries():
        pixels, width = skins[name]
        expected[str(macro_value(tex))] = {'name': 'entity/' + name + ' part', 'encoding': [2, 8], 'size': [w, h],
                                           'sprite': False, 'pixels': expected_part(pixels, width, x, y, w, h, turn)}

    # zip: mixed stored and deflated entries, and a comment at the end
    path = os.path.join(PACKS, 'test_pack.zip')
    with zipfile.ZipFile(path, 'w') as z:
        z.writestr('pack.mcmeta', '{"pack": {"pack_format": 46, "description": "Cubeland test pack"}}')
        for i, (key, data) in enumerate(sorted(files.items())):
            method = zipfile.ZIP_STORED if i % 4 == 0 else zipfile.ZIP_DEFLATED
            z.writestr(zipfile.ZipInfo('assets/minecraft/textures/' + key + '.png'), data, compress_type=method)
        z.comment = b'made by make_test_pack.py'
    folder = os.path.join(PACKS, 'test_pack')
    for key, data in files.items():
        out = os.path.join(folder, 'assets', 'minecraft', 'textures', key + '.png')
        os.makedirs(os.path.dirname(out), exist_ok=True)
        open(out, 'wb').write(data)
    json.dump(expected, open(os.path.join(PACKS, 'test_pack_expected.json'), 'w'))
    print('wrote', path, 'and', folder, 'with', len(files), 'images')

def check(dump_file):
    expected = json.load(open(os.path.join(PACKS, 'test_pack_expected.json')))
    got = {}
    for line in open(dump_file):
        parts = line.split()
        if len(parts) == 257: got[parts[0]] = parts[1:]
    bad = 0
    for tex, e in sorted(expected.items(), key=lambda kv: int(kv[0])):
        if tex not in got: print('missing texture', tex, e['name']); bad += 1; continue
        wrong = 0
        for i, p in enumerate(e['pixels']):
            if p[3] < 128:
                want = '-' if e['sprite'] else None   # holes in block textures take the commonest colour
            else:
                want = '%d,%d,%d' % tuple(p[:3])
            if want is not None and got[tex][i] != want: wrong += 1
        if wrong:
            bad += 1
            print('texture %s (%s, colour type %d, %d bit, %dx%d): %d pixels differ' %
                  (tex, e['name'], e['encoding'][0], e['encoding'][1], e['size'][0], e['size'][1], wrong))
    print('checked %d textures, %d wrong' % (len(expected), bad))
    return bad

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == 'make': make()
    elif len(sys.argv) >= 3 and sys.argv[1] == 'check': sys.exit(1 if check(sys.argv[2]) else 0)
    else: print(__doc__)
