# Porting ScuffedMinecraft features to Cubeland: plan

Source: https://github.com/WSAL-Evan/ScuffedMinecraft (MIT, (c) 2024 WSAL Evan). The MIT
notice is in the Credits section of `cubeland/README.md`.

This plan was written before any porting started. The status table below records what has
been done since; update it when an item is done or dropped. The rest of the document is the
original plan, kept for reference. It says `scratchpad/scuffed` where the source was cloned
for the analysis; that clone is not part of the repo, so clone the repository again to look
at the code it cites.

## Status

| Item | Status | Notes |
|---|---|---|
| A1 Caves | done (differently) | random-walk "worm" tunnels (`world_carve_caves`) rather than a 3D noise lattice, which was too slow to generate in 12dPL |
| A2 Plants | done | tall grass, poppy, dandelion, dead bush (and torches): first camera-facing sprites, now two pictures crossed in an X fixed in the world, split into four half pictures so they paint in the right order (`render_add_plant`) |
| A3 Block light and torches | done | flood-fill block light packed into `g_world` (`block + 64 * light`, option 2 of the plan), relit in a 31^3 box per change and after loading; torches (light 14); faces store sky and torch light separately |
| A3 Flood-fill sky light | not done | sky light is still the cheaper depth-below-sky-top estimate; glass lets it through |
| A3 Per-face AO | done | edges weigh 2, corners 1, out of 12 (`LIGHT_AO_STRENGTH`) |
| A4 Ponds and stamps | done (ponds) | ponds without a general stamp system; the starter house is built directly |
| A5 Dirt/gravel pockets, ores | done | coal veins, gravel pockets, **iron ore** (stone pickaxe needed), iron ingot from the furnace, iron tools |
| A6 Pick block | done | key P (12d's Draw_Box middle button is unverified) |
| A6 Hide HUD | done | key U and a settings button |
| A6 FPS min/avg/max | done | in the I statistics line, over each second |
| A6 Settings file | done | `cubeland_worlds/cubeland_settings.txt` |
| B1 Animated water | done (simplified) | drifting light/dark bands on water surfaces; the surface itself stays flat |
| B2 Edge-strip AO | not done | |
| B3 Isometric icons | done (differently) | block icons were already drawn as small cubes; non-block items got 16 x 16 pixel-art icons |
| B4 Fly mode | done | key G; Space up, C down; no gravity or fall damage while flying |
| B5 Day/night | done | 20 minute day saved with the world; sky, fog, sun, moon and stars follow it; sky light dims at night; beds skip the night |
| B6 Vertical render range | done | sections more than 40 blocks above or below the eye are skipped |
| Resource packs (not from SM) | done | `.zip` or folder in Settings; zip, deflate and PNG decoded in 12dPL (`resource_pack.4dm`) |
| Beyond SM | done | zombies at night, glass, beds, chests, iron |
| O1 Optimising | done (first pass) | slot index for mobs, drops, furnaces; layer-sorted faces; hidden face removal (30-58% fewer polygons); table-driven section building (-79% calls to create a world); background section loading; see section O |
| Chunk loading | done (as section loading) | the world stays one 128 x 128 x 96 grid generated at once (generation is cheap next to meshing); sections are built on demand and in the background, nearest first |
| Lit furnace light | done | a burning furnace becomes a lit furnace block (light 13) |
| More animals | done (pigs) | pigs with porkchops, built-in and pack skins |
| Fonts (not from SM) | done | Windows font list, typed font name, or family name read from a .ttf/.otf/.ttc |
| Desktop build (not from SM) | done | `tools/desktop`: the same macro as a Windows `.exe`, without 12d |

Suggested next steps: flood-fill sky light (so caves under overhangs darken properly), B2 edge-strip AO, doors, sheep and
chickens, and the remaining O candidates (per-frame record reads, smaller light boxes, merging far faces).

## 0. Which ScuffedMinecraft?

The repo has three distinct codebases in its history. Each has different features:

| Era | Commit / tag | Stack | Notable content |
|---|---|---|---|
| v1 "classic" | `429e862` (pre-alpha v1.x, Episodes 1-5) | OpenGL 3.3, ImGui, OpenSimplex | **The richest one**: terrain + caves + "ore" + 8 surface features (pond, tree, grass, tall grass, 4 flowers), billboards, water shader, underwater fog, hotbar with isometric icons, ImGui settings, middle-click pick-block |
| v2 "WillowVox" | `c7c1549` (Episode 6) | own engine (WillowVox), FastNoiseLite | Same features re-expressed with FBm noise settings + per-feature `chance`, `dirtLayers=5`, `sandLayers=2` |
| v3 current `main` | `8dad167` (Episodes 1-2 of the Vulkan rewrite) | Vulkan, Slang, FastNoise2, job pool | Only dirt/grass/stone/glowstone, but adds **voxel flood-fill lighting (sky + block light, 0-15) and smooth lighting with ambient occlusion** |

Everything below cites the file and commit it came from.

---

## 1. Inventory of ScuffedMinecraft

### 1.1 World generation

**v1 `ScuffedMinecraft/src/WorldGen.cpp` (429e862)**. All noise is OpenSimplex (`OSN::Noise<2>/<3>`, output about [-1, 1]).

- Surface height: `noiseY = 20 + Σ layers` where
  - layer 1: frequency 0.01, amplitude 20
  - layer 2: frequency 0.05, amplitude 3
  - (`NoiseSettings{frequency, amplitude, offset}`)
- Water level 20. Cells above the surface and `<= waterLevel` are water, the rest air.
- Caves: 3D noise, frequency 0.05, amplitude 1, threshold `> 0.5`, maxHeight 100. Caves carve
  everywhere below the surface, including right at it, so they open to the sky.
- "Ore": 3D noise, frequency 0.075, offset 8.54, threshold 0.75, block 1 (= **dirt**), maxHeight 0.
  These are just dirt pockets in stone. There are no real ores.
- Layers: the top cell is grass if `noiseY > waterLevel+1`, otherwise sand. Below the top it is dirt (sand if
  the column is low) down to y > 10, then stone. This is crude. v2 uses `dirtLayers = 5`, `sandLayers = 2`.
- **Surface features** (generic "stamp" system, `SurfaceFeature.h`): each feature has a 2D
  noise `{frequency, amp, offset, chance}`, a block array `sizeX*sizeY*sizeZ` (index
  `fY*sizeX*sizeZ + fX*sizeZ + fZ`), a `replaceBlock` bool array, a size and an offset. It is placed
  on column (x, z) when `noise2D(x*f+off, z*f+off) > chance`, the column is not within
  `waterLevel+2`, and the surface cell is not a cave. A cell is written if `replace[i] || current == air`.
  The features are applied in this order:

  | Feature | noise freq | offset | chance | size (x,y,z) | offset | content |
  |---|---|---|---|---|---|---|
  | Pond | 0.43 | 2.35 | 0.85 | 7,3,7 | -3,-2,-3 | layer y-2: a 5-cell water plus-shape; layer y-1: 7x7 disc of water with a grass rim; layer y: air (all replace) |
  | Tree | 4.23 | 8.54 | 0.80 | 5,7,5 | -2,0,-2 | y0 grass (replace), y1-2 log, y3-4 log in 5x5 leaves minus corners, y5-6 plus-shape leaves (MC-style oak) |
  | Tall grass | 1.23 | 4.34 | 0.60 | 1,3,1 | 0 | grass block, tall-grass-bottom, tall-grass-top |
  | Grass | 2.65 | 8.54 | 0.50 | 1,2,1 | 0 | grass block, short grass |
  | Poppy | 5.32 | 3.67 | 0.80 | 1,2,1 | 0 | grass block, poppy |
  | White tulip | 5.57 | 7.654 | 0.80 | | | |
  | Pink tulip | 4.94 | 2.23 | 0.80 | | | |
  | Orange tulip | 6.32 | 8.2 | 0.85 | | | |

  A frequency above about 1 makes simplex noise effectively white noise per column, so the "chance" is really
  a per-column probability. For OpenSimplex2D, roughly P(>0.5) ≈ 10-15%, P(>0.6) ≈ 6-8%,
  P(>0.8) ≈ 1-2%, P(>0.85) ≈ 0.5-1%.

**v2 `include/StandardWorld.h`, `SMTerrainGen.h` (c7c1549)**. FastNoiseLite FBm settings:
surface `{amp 20, freq 0.5, oct 1, heightOffset -5}` + `{amp 3, freq 2.4}`; cave
`{freq 2.5, oct 1, threshold 0.5}`; ore `{freq 4.5, threshold 0.7, replace=dirt, offsets 14/34/23}`;
tree feature chance 0.95, grasses 0.8-0.9, flowers 0.95. Ground: top = grass (sand if
`surface < water+2`), 5 dirt layers, then stone.

**v3 `game/src/world/WorldGen.cpp` + `ChunkManager.cpp` (main)**. FastNoise2 FBm simplex:
surface output [0, 10], scale 100, 2 octaves, gain 0.3, lacunarity 4.0. Cave FBm output [0, 1],
scale 30, 2 octaves, gain 0.25, lacunarity 3.0, **solid only where cave < 0.8** (about 10-15% carved).
Top is grass, the next 5 are dirt, the rest stone.

There are no biomes in any version, and no structures beyond the stamps.

### 1.2 Blocks (v1 `Blocks.h`)

Air, Dirt, Grass Block, Stone, Log, Leaves, Grass, Tall Grass Bottom, Tall Grass Top, Poppy, White
Tulip, Pink Tulip, Orange Tulip, Water, Sand. v3 adds **Glowstone** (emits light 15). There are 5
render types (`Block.h`): SOLID, TRANSPARENT (air), LEAVES (neighbours' faces are drawn
behind them), BILLBOARD, LIQUID.

### 1.3 Chunk system

16³ chunks. v1 `Planet.cpp` uses a render distance (cube radius) with renderHeight, a load queue and an unload
radius. v3 uses padded snapshots, a multi-threaded priority job pool and a job inbox. **Not portable** (no threads,
fixed arrays). Cubeland's fixed 128x128x96 world with cached 16³ section face lists already
does the job.

### 1.4 Lighting (v3 `game/src/world/VoxelLighting.cpp`, `BuildChunkMesh.cpp`, `shaders/shader.slang`)

- Two 4-bit channels per cell: block light and sky light.
- BFS flood fill with a FIFO queue. Light only enters AIR cells. Each step loses 1. **Sky light 15
  going straight down stays 15** (`Incoming()`: `d == NEG_Y && from == 15 ? 15 : from-1`).
- Removal uses a second "darkness" BFS (`PropagateDarkness`), the standard two-queue algorithm.
  Neighbours whose light was lower than the removed value are zeroed and re-queued. Brighter ones are re-seeded
  into the add queue. Sky columns are re-seeded where `nSkyLight == 15 && skyLight != 15`.
- `dirFlags` stop a node from propagating back the way it came.
- Smooth lighting: for each vertex, sum the light of the 4 cells (2 edges + corner + the face cell)
  around that vertex in the face plane. The corner is skipped if both edges are solid. Divide by the air count.
- AO for each vertex is `aoEdges` (0-2), or 1 if only the corner is solid. Multiplier `1 - ao*0.3`.
- Light curve: `v = max(level/15, ...)` then `v/(2 - v)`. The floor is 0.02 (cave darkness is nearly black).
- Toggle: "Smooth Lighting" checkbox.

v1 lighting is fixed directional: ambient 0.5 + diffuse dot(N, normalize(-(0.8, 1, 0.7))).

### 1.5 Rendering features

- **Billboards** (v1 `Chunk.cpp` lines 80-110): two crossed vertical quads through the cell diagonals
  (corners at 0.14645/0.85355, i.e. 0.5 ± 0.3536, so each quad is 1 block wide), height 1, with alpha-discard
  texture. They are not camera-facing.
- **Leaves** as a separate type: faces of solid blocks behind leaves are still drawn.
- **Water** (`water_vert.glsl`): top surface lowered 0.1. Waves:
  `y += (sin(x*π/2 + t) + sin(z*π/2 + 1.5t)) * 0.05`. Texture animation of 32 frames over 5 s.
  Water side faces are drawn only against non-liquid transparent neighbours. The `aTop` flag marks surface quads.
- **Underwater post-process** (`framebuffer_frag.glsl`): fog colour (0, 0, 0.25), depth fog
  between 0.9 and 1.0 of the depth buffer.
- Sky: a plain clear colour (0.6, 0.8, 1.0), or (0.4, 0.6, 0.9) in v3. There are no clouds, sun or fog in air.
- Block outline: wireframe cube 1.002 in size around the targeted block.
- Crosshair: textured, with invert logic-op.
- Hotbar (ImGui): 9 boxes, the selected one filled. Solid blocks show an **isometric 3-face icon** (top +
  left + right side, right side under a 100-alpha black "shadow" quad). Billboards show a flat sprite.
- FPS counter (current/avg/min/max), FPS cap, vsync, fullscreen toggle, F1 hides UI.

### 1.6 Physics / movement

v1/v2 have a free-fly camera only (WASD + E/Q up/down, Space+W = horizontal forward,
"absolute vertical movement" option), with no gravity or collision. Raycast is a fixed 0.01 step march
to 5 blocks (`Physics.cpp`). Placement face is picked from the hit point offset. Cubeland's DDA,
collision, gravity and swimming are all better than this.

### 1.7 UI / gameplay

Left click breaks instantly, right click places (also into water), middle click picks the block into the
slot, number keys and scroll wheel pick hotbar slots, Esc toggles the menu (mouse release). ImGui panel has render distance
slider 0-30, render height 0-10, smooth lighting, FPS cap. `ConfigLoader.h` reads a `Config.ini`
key=value file (only example keys). There is no inventory, crafting, health, mobs or saving.

---

## 2. Comparison with Cubeland

| Area | ScuffedMinecraft | Cubeland now | Gap |
|---|---|---|---|
| Terrain | 2-layer simplex, flat-ish | 4-pattern value noise, continents, mountains, oceans, beaches (`world_terrain_height`) | Cubeland ahead (user is already smoothing hills) |
| Caves | 3D noise, threshold | **none** | **port** |
| Ores / pockets | dirt pockets only | none | port pockets, extend to coal/iron |
| Ponds | 7x3x7 stamp | none (only sea) | **port** |
| Trees | fixed 5x7x5 stamp | own oak with random height and corner trimming | equal. Adopt the stamp *system* only |
| Grass / flowers | 6 billboard plants | none | **port (new render type)** |
| Biomes | none | forest density pattern; user adding desert | n/a |
| Lighting | flood-fill sky + block, smooth light, AO | fixed per-direction shade (`block_face_shade`) + distance fog | **port (simplified)** |
| Light-emitting block | glowstone | none | port as torch / glowstone |
| Water | waves, animation, underwater fog | WATER_TOP 0.875, wet-face flag, underwater murky fog + sky | port waves/shimmer (cheap) |
| Leaves see-through | yes | opaque | skip (polygon cost) |
| Sky | flat colour | gradient + sun | Cubeland ahead |
| Outline / crosshair | yes | yes | equal |
| Hotbar icons | isometric cubes | 2x2 quadrant colours (`g_tex_quad_*`) | user is already doing icons. Isometric recipe below |
| Pick block | middle click | none | port (cheap) |
| Settings | ImGui sliders, FPS stats, F1 hide UI, smooth-light toggle | keys - / = and stats on I | user is building a button menu. Add toggles |
| Config file | Config.ini | per-world save | small port |
| Physics, inventory, crafting, mobs, saving | none | full | Cubeland far ahead |
| Chunks / threads / GPU | yes | n/a | skip |

---

## 3. Recommendations

Budget rules used below: **≤ 2,000 polygons/frame**, **about 250k statements/frame**. World generation
can take a few extra seconds (it runs once per new world), but every new per-cell pass over the
1.57M cells costs about 1.57M × (statements per cell). At an estimated 6-10M simple statements/s in
12d (from the 250k/frame at 25-30 fps figure), a 10-statement pass is about 2-3 s.

Remember **no short-circuit evaluation** in 12dPL. Guards like `if (in_bounds && g_world[i] ...)`
must be nested `if`s, or the array read will go out of range.

### (A) Port now: high value, feasible

#### A1. Caves (3D noise carving)
- **Where:** `src/world.4dm`. Add `world_cave_noise(x, y, z)` and a carve pass in `world_generate`
  after the column fill and before trees. Add `CAVE_*` defines in `include/world.h`.
- **Algorithm:** full 3D value noise per cell is too slow (8 hashes, each a `Sin`, for each of about 1M stone cells).
  Use a **coarse lattice + trilinear interpolation** instead:
  1. Fill `g_cave_lattice[LATTICE_CELLS]` at spacing 4: (128/4+1)·(96/4+1)·(128/4+1) =
     33·25·33 = **27,225** values, using `hash_real(i + g_seed_shift_a, j*1.0, k + g_seed_shift_b)`.
     Do two octaves: spacing 8 (17·13·17 = 3,757) at weight 0.65 and spacing 4 at weight 0.35. This matches
     v3's 2-octave FBm (gain about 0.3).
  2. For each cell with `5 <= y <= height - 1`, interpolate. Precompute fractional weights per axis
     (4 possible values), and the inner y loop can step linearly. Carve to air when
     `value > CAVE_THRESHOLD` = **0.72** for this value-noise blend. Value noise is lower contrast than simplex, so
     tune it so that about 8-12% of stone is carved. This plays the role of v3's `>= 0.8` on [0, 1] FBm and v1's `> 0.5` on simplex.
  3. "Spaghetti" variant (looks more like tunnels): carve where `|value - 0.5| < 0.035` on one
     lattice octave, OR the same test on a second lattice. Use it if blobs look too cheesy.
- **Rules:** never carve y ≤ 4 (keep the bedrock floor). Never carve a cell that has water above it or
  beside it (sea floor and the pond rim). In practice, skip columns with `height < SEA_LEVEL + 2` for the top 4 cells,
  so no flooding is needed. Let caves breach the surface on land (as v1 does) to get cave mouths.
  Fill carved cells below y = 10 with nothing. Lava does not exist, so leave them as air.
- **Interactions:** trees and plants must check that the ground cell is still grass/solid after carving (v1 checks
  "is cave" at the surface). The spawn search already needs `GRASS` at top. Lighting (A3) is what makes caves look
  like caves, and without it they render as bright as the surface. Cows: `cows.4dm` already
  avoids cliffs. Check that cows spawn only on the column top (heightmap), not in caves.
- **Cost:** generation is about 1M stone cells × about 15 statements ≈ 2-3 s extra, and 0 at runtime. Caves *add*
  visible faces only when you are in or near them. Section culling handles the rest, but `mesh_section_buried`
  becomes false for more sections, so meshing at load grows. `SECTION_FACE_CAP` 1024 may overflow in
  cave-heavy sections. Watch `g_mesh_overflow` and raise the cap to 1536 if needed (pool becomes 589,824).

#### A2. Plants: grass, tall grass, flowers (billboards)
- **Blocks:** add `BLOCK_SHORT_GRASS`, `BLOCK_TALL_GRASS_LOW`, `BLOCK_TALL_GRASS_HIGH`, `BLOCK_POPPY`,
  `BLOCK_TULIP_WHITE`, `BLOCK_TULIP_PINK`, `BLOCK_TULIP_ORANGE` (and `BLOCK_DEAD_BUSH` for the user's desert).
  **Id coordination:** blocks currently use 1-15, items 20+. With the user's tools and new blocks,
  move items to 100+ (or switch to Attributes ids) before adding these. Flowers as items: drop themselves
  (decoration, and later dyes). Grass drops nothing (or a seed later).
- **New block class "plant":** add `block_is_plant()`, and `block_is_opaque()` (TRUE for solids, FALSE for air, water and plants).
  - `block_is_solid` → FALSE for plants (walk through, no collision).
  - `mesh_build_section`: treat a plant neighbour like air when deciding faces (`flag = 0`). For the plant
    cell itself, emit **one** entry with a new direction `DIR_PLANT = 7` (must stay < `DIR_WET_FLAG` 8).
    Grow groups to 7 per section: `SECTION_DIR_GROUPS = NUM_SECTIONS * 7` = 2688, update
    `mesh_group_faces` and `g_sort_next[7]`. The group is never back-face-culled.
  - `physics_raycast_blocks`: stop on plants too (you can target and break them), but `block_is_solid` is
    still FALSE for movement. Hardness 0 means instant break (hardness 0 currently means "unbreakable", so
    use a separate `block_breaks_instantly`).
  - Placing into a plant cell replaces it, as v1 does for water. Breaking/placing the block *below* a plant removes the plant
    in a handler for `EVT_BLOCK_BROKEN` (world module emits a second break), and the same for tall-grass halves.
  - Water never flows into plants (they are only generated above sea level+2).
- **Rendering:** do **not** copy the crossed quads. Two intersecting quads cannot be ordered by a
  painter's algorithm and would cost 2× polygons. Draw **one camera-facing quad** (a true billboard,
  yawed to face the eye): corners at cell centre ± 0.5·(right_x, 0, right_z) using `g_right_x/g_right_z`,
  y from 0 to 1 (tall grass: two cells, so two quads stacked). In `render_collect_blocks`, for
  `DIR_PLANT` call a new `render_add_plant(x, y, z, block, dist_sq)` that calls `render_add_face` with
  `e1 = camera right` (in camera space this is simply (1, 0, 0) scaled, which is very cheap) and `e2 = up`.
  Painter order by cell centre works because the quad passes through the centre.
- **Textures** (`src/textures.4dm`): plant textures need **transparency**. Reserve palette index 0 = transparent:
  - `texture_finish`: if the texture is flagged transparent, do not pick a base colour. Emit rects for every
    non-transparent colour, and `g_tex_base = 0`.
  - `render_draw_face`: skip the base polygon when `g_tex_base[tex] == 0`.
  - LOD for plants: DETAIL_FULL ≤ 6 blocks (all rects, keep plant textures to ≤ 12 rects by drawing them as
    a few vertical blades, which merge well). DETAIL_MAJOR draws 2-3 big rects. DETAIL_FLAT draws one rect of the average colour
    over u 0.25-0.75, v 0-0.6. **Cull plants beyond `PLANT_DISTANCE` = 14 blocks** (or 60% of render distance).
  - Texture designs: short grass = 5-7 blades of 2 greens. Tall grass = the same, taller, cut at the top/bottom
    seam. Poppy = green stem + 3x3 red head with a dark centre. Tulips = stem + 2 leaves + 3x4 cup (white
    (235,235,225), pink (235,150,190), orange (240,130,40)).
- **Generation** (`world.4dm`, after trees): per grass column, `r = hash_real(x, z, 61 + seed)` and
  `meadow = world_value_noise(x/18, z/18, 7)` (density zones, so there are clearings and meadows), then:
  - `r < 0.10*meadow` → short grass. `< 0.13*meadow` → tall grass. Each flower ≈ `0.004 + 0.012*meadow`, with
    flower colour picked by a second low-frequency noise so flowers cluster by kind (MC-like patches).
  - Skip forest-dense columns (forest noise > 0.6) and anything within 2 of sea level (as v1/v2:
    `noiseY < waterLevel + 2`). Desert columns get rare dead bushes (user's desert work).
- **Cost:** with the above, about 12-18% plant coverage within 14 blocks: π·14² ≈ 615 columns × 0.15 ≈ 90
  plants × (1 base-less quad + about 3-10 rects near, 1 far) ≈ 250-400 polygons in a meadow. That is a lot. Put
  `PLANT_DISTANCE` on the detail levels (low 8, normal 12, high 16) and add a settings toggle "Plants: on/off".
  Plants never occlude terrain faces, so total terrain polygons stay the same.

#### A3. Lighting: sky light + block light with flood fill (simplified v3)
- **Storage:** v3 packs two 4-bit channels. Options:
  1. Separate `Integer g_light[WORLD_CELLS]` (`sky*16 + block`). This is a second 1.57M array, and the
     README already doubts that 12d will allow one.
  2. **Recommended: pack into `g_world`**: `cell = block + 64*sky + 1024*blocklight` (block < 64).
     There are only 15 direct `g_world[` reads (mesh 7, render_world 2, save 1, world 5). Route them through
     `world_get_block()` (`value % 64`), or apply the `% 64` at those sites, and keep a
     `world_get_light()`. Saves already record edits by block id, so light is never saved. Recompute it on load.
- **Generation** (`world_generate`): sky light for each column top-down. It is 15 until the first opaque cell.
  Leaves and water reduce it by 1 and 2 per cell and break the "straight down stays 15" rule. Below, set 0. Then seed a
  FIFO (array ring buffer `g_light_queue[65536]` of cell indices) with every sky-15 air cell that has a
  horizontal neighbour with sky < 14 (overhangs, cave mouths, under trees). BFS as in v3
  `PropagateLight<SkyChannel>`: each step -1, enter non-opaque cells only.
- **Edits:** `light_on_event()` handles `EVT_BLOCK_BROKEN` / `EVT_BLOCK_PLACED`:
  - Placing an opaque block uses the removal BFS (v3 `PropagateDarkness`): queue (cell, old level), zero
    the cell, and for each neighbour, if `0 < n < level` zero it and queue it, else if `n >= level` add it to the
    re-light queue. Then run the add BFS. Do both channels.
  - Breaking: recompute the column sky above (straight down from the first open cell) and seed the cell from its 6
    neighbours (max - 1), then add BFS.
  - Each changed cell must `mesh_mark_dirty` its section, because light is baked into the face list (below).
    Track the changed bounding box during the BFS and mark the sections it touches.
  - Cap the work per event (`LIGHT_MAX_STEPS` ≈ 20k). Light radius is 15, so worst case about 14k cells.
- **Light sources:** add `BLOCK_TORCH` (crafted 1 stick + 1 coal → 4, light 14) rendered as a plant-
  style billboard with a small flame rect, and/or `BLOCK_GLOWSTONE` (light 15, v3) as a solid
  block (crafting from ... or found in deep caves). Furnace when lit: light 13 (nice, cheap: emit on
  furnace state change).
- **Baking into faces** (`mesh_build_section`): add `Integer g_face_light[FACE_POOL_SIZE]` (393k,
  same size as existing pool arrays) storing the light of the **air cell the face touches** (v3
  flat mode: `snapshot.light[neighbour]`). Combine as `max(sky*day_factor, block)`.
- **Rendering** (`render_add_block_face` / `render_draw_face`): `shade = block_face_shade(dir) *
  light_curve(level)` where `light_curve` is a 16-entry table `g_light_curve[16]` built at init from v3's
  formula `v = l/15; v/(2-v)`, with floor **0.10** (not 0.02: Cubeland has no gamma, and
  totally black faces vanish into the painter's background). Block light gets a warm tint:
  add (+20, +10, 0) via `g_q_add_*` when block > sky.
- **Smooth lighting / AO (per face, simplified):** per-vertex gradients are impossible with flat
  fills. Bake a **per-face AO factor** at mesh time instead: in the face plane around the air
  cell, count the solids among the 4 edge neighbours (weight 2) and 4 corner neighbours (weight 1, only if neither adjacent
  edge is solid, as in v3), so `ao = sum/12`. `shade *= 1 - 0.35*ao`. Pack it as `light + 16*ao_level(0..3)`
  in `g_face_light`. That is 8 extra lookups per face at mesh time and **0 extra polygons**. A settings toggle "Smooth
  lighting" switches AO on or off (as in v3).
- **Cost:** 0 polygons. Per face per frame, 1 array read + 1 multiply (about 2k faces → about 4k statements).
  Mesh rebuild about 10 extra statements per face. Generation: one column pass (cheap) + BFS over the boundary
  air (≈ 50-150k cells ≈ 1-2 s).
- **Interaction with fog:** keep distance fog multiplying `lit` as now. Dark caves still fade to sky colour at
  distance, which looks wrong underground. Use a darker fog colour when `light at the eye cell < 8`
  (`render_setup_camera`, lerp the fog toward (20, 20, 28)).

#### A4. Ponds and surface-feature stamps
- **Where:** `world.4dm`. Add a tiny data-driven stamp system (`world_stamp(feature, x, y, z)`) with global
  arrays `g_feat_block[]`, `g_feat_replace[]`, `g_feat_size_x/y/z[]`, `g_feat_off_x/y/z[]`,
  `g_feat_first[]` loaded in `world_init_features()`. Copy v1's index order
  `fY*sizeX*sizeZ + fX*sizeZ + fZ` and the "write if replace or air" rule.
- **Pond** (v1 data verbatim, 7x3x7, offset -3,-2,-3): deepest layer is a 5-cell plus of water, middle a 7x7 disc
  of water with grass rim, top layer air. Place on grass columns with `height >= SEA_LEVEL + 3`, at
  per-column probability ≈ **0.0015** (v1's 0.85 threshold at freq 0.43 gives a few per 128² world). Require
  all 9 centre columns within ±1 of the centre height (flat ground) so no water hangs on a slope. Run
  before trees, and put sand (desert) or dirt instead of grass under the water. Mark water so lighting/mesh treat it
  normally. `world_break_block` already refills cells next to water only below `SEA_LEVEL`. Ponds
  are above it, so a broken pond rim simply leaves a hole (as in v1). That is acceptable. A later
  "water source" flag would be needed for spreading.
- **Tree:** keep Cubeland's own oak (it already varies the trunk 4-6 and trims corners). Optionally add v1's
  stamp as a "bush" (only layers 3-6 of the tree, on a 1-log stump) to vary forests.
- **Cost:** generation only. Pond water faces only (water tops: about 20 faces each).

#### A5. Dirt / gravel pockets and real ores
- v1/v2 "ore" = dirt pockets (3D noise > 0.75 at freq 0.075, about 1 in 12 blocks of size about 3-4). Do it with the same
  coarse lattice as A1 (spacing 4, a different salt), threshold 0.78, inside stone only → dirt pockets.
  Add **gravel** with another salt for variety if desired (falls? no, keep static).
- Since the user is adding a pickaxe and tools, go one step beyond SM: **coal ore** (stone, y < 80, cluster
  noise > 0.80, about 1%) and **iron ore** (y < 48, > 0.84). Cheaper: random-walk veins of 4-8 cells:
  `ORE_VEINS_COAL = 90`, `ORE_VEINS_IRON = 45` per world, each a 6-step walk using `hash_real`. That costs
  only a few thousand statements, much cheaper than per-cell noise. Iron ore smelts in the existing furnace
  (`item_smelt_result`) → iron ingot → iron pickaxe (user's tools). Coal = furnace fuel (80 s) + torches.
- Textures: stone base + 6-8 clustered dark (coal) or tan/orange (iron) speckles via the existing
  `texture_blotch`/`texture_speckle` helpers. 1-2 more rects than stone.
- **Cost:** generation only. Polygons +2 per visible ore face.

#### A6. Small UI / control ports
- **Pick block** (v1 middle click): if the 12d `Draw_Box` reports a middle button, select the hotbar
  slot that holds the targeted block's item (survival-style). Otherwise bind it to key `P`. `player.4dm`.
- **Hide HUD (F1 in SM):** toggle key, e.g. `U`, and a settings button. `render_hud` early-out. Saves
  about 100-200 polygons, so it doubles as a performance option.
- **FPS min/avg/max** like SM's ImGui line: add to the `I` stats overlay (`render_hud.4dm`). Keep a
  1-second window of frame times in `game_panel.4dm`.
- **Settings persistence** (SM `ConfigLoader.h`, key=value): write `cubeland_worlds/settings.txt`
  with render distance, plants on/off, smooth lighting, HUD and so on, using the existing file helpers in `save.4dm`.
  This fits the user's button settings menu.

### (B) Port in simplified form

#### B1. Animated water surface
v1 waves `y = top - 0.1 + (sin(x·π/2 + t) + sin(z·π/2 + 1.5t))·0.05`. With flat polygons, apply this
**per corner** of each water *top* face (4 `Sin` calls per face, cache per (x+z) column per frame if
needed), so the surface ripples. Corners are shared, so there are no cracks. Only within 10 blocks (beyond: flat). Also
cycle the water palette brightness ±6% over 5 s (SM 32-frame animation stand-in, changes
`g_q_add_*` only). The cost is about 30 statements per near water face. The painter order is unchanged.
Lower `WATER_TOP` from 0.875 to 0.9 (SM uses 1 - 0.1). It is already close, so this is optional.

#### B2. Edge-strip ambient occlusion (near faces only)
On top of A3's per-face AO, for DETAIL_FULL faces draw a dark translucent-looking strip (shade ×0.6,
width 3/16) along each occluded edge (4-bit edge mask baked next to the AO level). The cost is 1 polygon per occluded
edge, only within about 6 blocks, so ≤ 100-200 polygons. It gives most of the smooth-lighting look. Put it behind the
"Smooth lighting: high" setting.

#### B3. Isometric hotbar/inventory icons (SM `draw_hotbar_box`)
The user is already doing distinct item icons. If blocks get icons, SM's geometry is a good recipe:
cube size 0.4·slot, top rhombus (back-left, back-right, front-right, front-left at x offsets 0,
0.75c, 1.5c and y offsets 0, c/4, c/2), left and right parallelograms of height c, right side
darkened by an alpha-100 black quad (in Cubeland: multiply by 0.6, left by 0.8). Fill each face with
the texture's 2x2 quadrant colours (`g_tex_quad_*`) as 4 sub-parallelograms, which is 12 polygons per icon.
Plants: flat sprite from rects. 9 hotbar icons ≈ 108 polygons. If that is too many, use base colour only (27).

#### B4. Fly / creative mode
SM's camera is free-fly (E/Q up/down, Space+W horizontal). A `G` toggle (creative flight) in `player.4dm`
skips gravity: Space = up, a new key (e.g. `C`) = down. One held key only, so vertical moves use the same
tap-ramp logic as walking. This is handy for testing caves and lighting. Keep collision on.

#### B5. Day/night (stretch, enabled by A3)
SM has no day cycle, but its sky light channel makes one almost free: multiply the sky channel by
`day_factor` (0.25-1.0) at render time (not baked, so no remesh). Lerp the sky gradient and fog colour, and the sun
moves along an arc. Torches then matter. About 20 statements per frame, 0 polygons. A 20-minute cycle, toggle in settings.

#### B6. Render-height / vertical render distance
SM has a separate render-height slider. In Cubeland `render_collect_blocks` uses the same
range for y. Clamp the vertical section range to ±2 sections (32 blocks) when the camera is above
ground, to save section tests. Low value, trivial. Fold it into the user's render-distance setting.

### (O) Optimising

Every feature so far added work per frame. Before adding more, spend a pass on speed. Measure first,
change one thing at a time, and keep the test scenarios passing (their dumps show behaviour hasn't changed).

**How to measure**
- In game: the I statistics line shows frame time min/avg/max over each second, polygons and faces.
- Harness: `TRACE_ATTR=1 ./run.sh scenarios/15_night_torches_zombies.txt` lists the most-read
  record fields, and `[frames]` gives attribute calls per run. Attributes calls are the slowest
  thing 12dPL does in a loop, so that count is the main number to bring down.
- First measurement (scenario 15, 471 frames, 367k record reads, about 780 per frame): the top
  entries are `used_1` ... `used_11` about 2,850 times each. That is the cow/zombie loop asking every
  slot whether it is alive, every frame.

**Done**
- Slot index (`slots.4dm`): mobs, drops and furnaces keep a list of their used slot numbers. Spawning
  and dying go through `mob_set_used` / `drop_set_used` / `furnace_set_used`, which write the record
  and the list together; after loading, the lists are rebuilt from the records. Loops visit only
  the used slots. Record reads over all 16 scenarios: 1.90M -> 1.41M (-26%); scenario 15 (night,
  zombies): 367k -> 197k (-46%). Every scenario's dump is unchanged.

**Render measurements** (render distance 50; counted per frame in a scratch build)

| View | faces looked at | faces drawn | polygons | flat / major / full faces (polygons) | underground faces (polygons) |
|---|---|---|---|---|---|
| 01 tour, open land | 2,750-3,160 | 730-790 | 2,600-2,770 | 523 (559) / 163 (990) / 41 (1,026) | 23 (23) |
| 03 cow, near a house | 3,200-3,950 | 670-770 | 2,640-3,190 | 533 (583) / 190 (1,558) / 45 (1,047) | 39-100 (240-300) |
| 07 scenery, forest | 9,100-9,600 | 310-1,860 | 2,840-4,860 | 20-1,600 (20-1,600) / 260-300 (2,070-2,550) / 30-40 (500-870) | 0-146 (0-589) |

What this says:
- Most of the per-face work is spent rejecting. 75-96% of the cached faces the loop looks at are
  thrown away (facing away, too far, or outside the view): in the forest, 9,500 looked at for 350
  drawn. Sections are culled with a 13.9-block bounding sphere, so a section that is only partly
  in view sends all its faces through the per-face tests.
- Polygons come mostly from the nearer faces. A flat face is 1 polygon, a "major" face about 7
  (base colour plus its larger colour patches), a "full" face about 22. In the forest, 300 major
  faces make 80% of the polygons. Resource pack textures have more patches than the built-in ones
  (8,550 rectangles against 7,139), so they cost more.
- Far faces are many but cheap: 500-1,600 flat faces, one polygon each. Neighbouring faces with the
  same texture, direction and light could be merged into one polygon (greedy meshing).
- Faces hidden underground (cave floors seen through the ground) are only 1-10% of polygons.
- The painter's algorithm draws everything in view, back to front, even what nearer faces cover.
  (Measured afterwards: 40-60% of the polygons in hills, houses and caves were completely covered.
  Hidden face removal, below, now skips them.)

**Done since** (measured in the harness at render distance 50; game state and every test picture unchanged)
- Faces are sorted by direction *and layer* (the cell's position across the section along the
  face's axis), so only the layers facing the eye are walked; each face keeps its block, and the
  per-face screen test is written out in the loop. 10-20% fewer faces looked at.
- Hidden face removal: queued faces are checked nearest first against covered spans of vertical
  screen lines every 4 pixels; a face inside covered spans on every line it touches is skipped.
  Polygons: house 4,855 -> 2,563, meadow 3,748 -> 2,398, hill 2,636 -> 1,845, cave 761 -> 322,
  looking down 1,169 -> 517. Total function calls stay within 1% (the check costs about what the
  skipped drawing saved) while `Draw_polygon` calls drop 46%.
- Section building reads `g_world` directly through lookup tables by cell value (kind, block,
  light, solid) instead of chains of `block_*` calls, face light reads its neighbours the same way,
  and column scans skip air: creating a world and drawing its first frame went from 21.0M to
  4.4M function calls.
- Background loading: a couple of out-of-view sections in range are built per frame, nearest first.
- Only the buckets used are walked and emptied; stars are worked out once; the renderer no longer
  looks furnaces up per face (lit furnaces are their own blocks).
- Light changes rebuild every section within the light radius (before, light spreading into the
  next section showed late).

**Remaining candidates**
1. Rendering, per-face rejects: most remaining rejects are faces off screen or out of range in
   sections only partly in view; 8-block sub-sections would cut them.
2. Rendering, polygons: at far range, merge neighbouring flat faces into strips.
3. Per-frame values read from records more than once (`state`, `selected`, `dead`: thousands of reads):
   read once at the start of the frame into locals, pass them down.
4. Light updates: `world_light_update` relights a 31^3 box per block change. Shrink the box to the
   torch radius actually affected, and skip it entirely when no light source is near.
5. Mesh rebuilds: count section rebuilds (`builds` in the dump) when breaking one block; rebuild only
   the touched section and neighbours on its faces.
6. Rendering, small things: cache sun/sky colours, which only change every few seconds of game time.
7. Saving: write chunks of the world per line instead of per block if save time is noticeable.

Each change should state the before/after number (frame ms in game, or record reads in the harness)
in its commit message.

### (C) Skip, and why

| Feature | Reason |
|---|---|
| Infinite chunk streaming, ChunkManager, priority job pool, job inbox | No threads, fixed-size literal arrays. A 128² world already fits. Streaming would need a moving origin and re-gen per chunk, a big rewrite with little gain |
| Vulkan/OpenGL pipeline, Slang/GLSL shaders, framebuffer post-processing, depth-buffer fog, mipmaps, texture atlas (`block_map.psd/.ase`) | No GPU. The equivalent effects already exist (palette rect textures, LOD, distance fog, underwater fog) |
| See-through leaves (LEAVES render type drawing faces behind) | Would multiply visible faces in forests (each leaf cube shows up to 6 faces plus everything behind). That breaks the 2,000-polygon budget. Keep leaves opaque. A "fancy leaves" toggle is not worth it |
| Per-vertex smooth lighting gradients | Draw_Box fills flat colours. A3 per-face AO and B2 edge strips approximate it |
| Crossed-quad billboards | ~~Intersecting quads can't be painter-sorted~~: done after all, by splitting each picture at the crossing into two halves that only meet along the middle (A2) |
| SM terrain height function itself | Cubeland's is already richer, and the user is reworking hills. The SM numbers (base 20 + 20·n(0.01) + 3·n(0.05)) can serve as a reference "smooth" profile: low-frequency amplitude about 7× the detail amplitude |
| SM's 0.01-step raycast, free-fly-only physics | Cubeland's DDA and collision are better |
| ImGui widgets (sliders, checkboxes, InputInt FPS cap), vsync, fullscreen | Not available in 12d. The user's button settings menu covers this. There is no frame cap: the macro runs as fast as it can |
| Scroll-wheel hotbar | Only if 12d reports wheel events to Draw_Box (unverified). Number keys already work |
| Glowstone-only lighting test scene, logging, CMake/CI | Not features |

---

## 4. Interaction with the user's parallel work

- **Smoother hills + clearings:** A1 caves and A4 ponds run after the height map, so they compose. Ponds
  need flat ground, and smoother hills give more pond sites. "Clearings" should reuse the same low-frequency
  noise as the forest gate, and A2 meadows should be dense *in* the clearings, which gives the right look for free.
  Keep `g_height_map` correct after caves (caves don't change the top unless they breach it, so recompute
  the top cell for breached columns).
- **Desert biome:** the plant generator needs the biome id per column. Deserts get dead bushes (+ cactus if
  the user adds it), no grass or flowers, and no ponds (or rare oases using the pond stamp with a sand rim). Caves under desert
  should not breach a sand surface without support (sand doesn't fall in Cubeland, so it is fine either way).
- **Starter house:** stamp it *after* caves, ponds, ores and plants, and clear plants and carve-fill caves under its
  footprint (fill air below the floor with dirt/stone down to the first solid). It can be the first user of the A4 stamp
  system (a stamp with `replace = true`). Light: run the light pass after the house so the interior is dark-
  ish, which makes a placed torch obvious. Put 2-4 torches in the house if A3 lands.
- **3x3 / 2x2 crafting grids:** new recipes to add: torch (coal over stick → 4), flowers → nothing (or dyes
  later), iron pickaxe (3 iron + 2 sticks), glowstone? (skip), "grass → seeds"? (skip).
- **Basic tools (pickaxe for stone):** ores need hardness and tool tiers. Coal needs a wooden pickaxe or better. Iron ore needs
  a stone pickaxe or better (MC rule). Iron ingot comes from the furnace (`item_smelt_result`). Plants break instantly by hand.
- **16x16 textures + distinct icons:** A2 needs the transparent palette index (0) in the texture
  pipeline and an "is sprite" flag so icon drawing uses the flat sprite. A5 adds 2-3 ore textures, A2
  7 plant textures, and the torch 1. Raise `NUM_TEXTURES`, `TEXTURE_PIXELS`, `TEXTURE_PALETTES`,
  `TEXTURE_QUADRANTS` and `MAX_TEXTURE_RECTS` (plants are rect-heavy: budget about 12 each).
- **Render distance in settings:** add rows for *Plants (off/near/far)*, *Smooth lighting
  (off/face/edges)*, *Water waves on/off*, *Hide HUD*, *Day/night on/off*. Each detail level should also set
  `PLANT_DISTANCE`.
- **Attributes refactor / honest functions:** keep the **hot per-cell data in plain arrays**
  (`g_world`, light packing, face pool, `g_face_light`, cave lattice). Attribute lookups per cell or per face
  would blow the statement budget. Put *definitions* in Attributes: block properties (plant/opaque/light
  emission/hardness/tool tier), feature stamps, ore and plant generation parameters, and settings. Write
  the new functions in the honest style from the start, e.g. `light_propagate(world, queue, ...)`. Note
  that 12dPL passes arrays by reference, so the big arrays can be parameters at no copy cost (check this in the
  type docs before relying on it). Do A3's `g_world` packing **before or together with** the refactor,
  since both touch every `g_world[` access.
- **Block id space:** blocks 1-15 and items 20-22 are packed tightly. This plan adds about 7 plants, 2-3 ores, torch,
  (gravel, glowstone), and the user adds tools, sandstone/cactus and so on. Pick a new layout now (blocks 1-63, so
  they fit A3's `% 64` packing, items 100+) and add a save-format version bump in `save.4dm`.

---

## 5. Suggested order and rough effort

1. A3 storage decision + `g_world` access cleanup (with the Attributes refactor). Small.
2. A1 caves + A5 pockets/ores (shared lattice code). Medium.
3. A3 lighting: generation pass, baking into faces, render curve, then edit BFS, then torch. Large.
4. A2 plants: transparent textures, plant render path, generation, break rules. Medium-large.
5. A4 stamps + ponds (+ house uses stamps). Small-medium.
6. A6 small UI ports. Small.
7. B1 waves, B2 edge AO, B5 day/night, B3 icons, B4 fly. Each small.

Test each step in `tools/test_harness` (frames to PNG + `I` stats). Track `g_stat_polygons`
in a cave, a meadow, a forest and an ocean scene against the 2,000 budget, and track generation time for seeds
0, 1 and 12345.

## 6. Key parameters (quick reference)

- v1 surface: `20 + 20·S(0.01x, 0.01z) + 3·S(0.05x, 0.05z)`, water 20
- v1 cave: `S3(0.05·p) > 0.5`, maxHeight 100. v3 cave: FBm scale 30, 2 oct, gain 0.25, lac 3, carve where ≥ 0.8 on [0, 1]
- v1 pockets: `S3(0.075·p + 8.54) > 0.75` → dirt
- Feature thresholds: pond 0.85@0.43, tree 0.80@4.23, tall grass 0.60@1.23, grass 0.50@2.65, poppy 0.80@5.32,
  tulips 0.80/0.80/0.85 @ 5.57/4.94/6.32. Not within water+2, not in caves
- Billboard quads: diagonal, 0.5 ± 0.35355
- Water: top -0.1, waves amplitude 0.05 (two sines, x and z, time ×1 and ×1.5, wavelength 4), 32 frames / 5 s
- Underwater fog: (0, 0, 64) RGB
- Light: 0-15, -1 per step, sky 15 straight down is lossless, curve `v/(2-v)`, AO `1 - 0.3·ao`, ao ∈ {0, 1, 2}
- Glowstone light 15. Render distance slider 1-25 (v3) / 0-30 (v1), height 1-10
