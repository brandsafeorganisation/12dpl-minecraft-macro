# Cubeland

A first-person block-building sandbox for 12d Model, drawn entirely in a
`Draw_Box` with polygons.

## Running it

1. Compile `cubeland.4dm` with the 12d macro compiler. It pulls in everything
   else through `src/build.4dm`.
2. Run the compiled `cubeland.4do`.
3. The **Cubeland - worlds** panel opens. Type a world name and, optionally, a
   seed, then press **Create new world**. You can also pick a saved world and
   press **Play selected**.
4. Click the game view to start playing. Press **H** at any time for the
   controls. You start inside a small house with a crafting table, a
   furnace, a chest, a bed and two torches.
5. **Settings** (on the world menu, in game, or the **O** key) opens a panel
   of buttons for render distance (50 blocks to start with), texture
   detail, field of view, mouse speed, grass and flowers, shadows,
   auto-jump, the HUD and statistics, the resource pack and the font.

Worlds are saved in a `cubeland_worlds` folder inside the 12d working folder.
A world is saved when you quit to the menu, when you press **Save**, and every
two minutes while you play. Settings are kept in
`cubeland_worlds/cubeland_settings.txt`. Worlds saved by the first version
can't be opened by this one (items were renumbered).

### Without 12d (Windows)

`tools/desktop` builds the same macro into a stand-alone `cubeland.exe` that
runs on any 64-bit Windows 10 or 11 PC without 12d Model. A ready-built copy
is in `release/cubeland.exe`. Double-click it, and
worlds are saved next to it. See [tools/desktop/README.md](tools/desktop/README.md)
for how to rebuild it after you change the macro.

## Controls

| Input         | Action                                                       |
|---------------|--------------------------------------------------------------|
| Click view    | start playing (the mouse then turns the camera); after a pause, W A S D or Space also carries on |
| Mouse         | look around                                                  |
| Left click    | break blocks (harder blocks take more hits), hit animals     |
| Right click   | place blocks, eat food, open crafting tables, furnaces and chests, sleep in beds, open and shut doors |
| W A S D       | walk                                                         |
| Space         | jump, swim up, fly up                                        |
| 1 - 9         | choose a hotbar slot                                         |
| E             | inventory and 2 x 2 crafting (E or Q closes any screen)      |
| Q             | pause and free the mouse                                     |
| F / J         | auto-walk on/off, auto-jump on/off                           |
| G             | fly on/off (no gravity, no fall damage)                      |
| C             | crouch on/off (sink while flying)                            |
| Shift + W A S D | crouch while held: slower, and you don't walk off edges (sink while flying) |
| T             | chat; Enter sends the line, Escape drops it                  |
| /             | chat with a / already typed, for a command (see below)       |
| P             | pick block: hold the item of the block you're looking at     |
| U             | hide or show the HUD                                         |
| - / =         | shorter / longer render distance (8 to 64 blocks)            |
| I / H / O     | position, render and frame-time statistics, help, settings   |

The keys go to the **Keys** box under the view. If they stop working, click
that box. 12d doesn't report Shift on its own, only the capital letter it
makes, so Shift crouches together with a movement key (the Windows build
also sees Shift held by itself); Caps Lock does the same.

### Commands

Type these in the chat line (**/** or **T** then **/**). Times are in the
block game's ticks: 24000 to a day, 0 at sunrise, 6000 at noon.

| Command | What it does |
|---------|--------------|
| `/time set day\|noon\|night\|midnight\|<ticks>` | set the time of day |
| `/time add <ticks>` | move the clock on |
| `/time query daytime\|gametime\|day` | say the time |
| `/gamerule doDaylightCycle true\|false` | start or stop the clock (saved with the world) |
| `/give <player> <item> [count]` | give yourself items, e.g. `/give @p oak_door 3` or `/give @p minecraft:torch 64` (any player name means you) |
| `/help` | list the commands |

12d only sends auto-repeat for the last key held and never reports a key being
released. Because of that, only one movement key works at a time. Each press
moves you for a moment and holding the key keeps you moving. Space keeps your
current movement going so you can run and jump, and auto-jump (on by default)
hops up one-block steps for you.

## Resource packs

The textures can come from a block game resource pack instead of the
built-in ones. In **Settings**, type or browse to the pack's `.zip` file
(or the folder you unzipped it into) in the **Resource pack** box and press
**Use this resource pack**; **Built-in textures** switches back. The choice
is saved and loaded again next time.

The macro reads the zip and its PNG images itself (12dPL has no image
library), so loading a pack takes a moment. It uses the images under
`assets/minecraft/textures/block/` and `item/` for every block and item
Cubeland has, samples each to 16 x 16 and keeps 8 colours per texture.
Grey images that the game colours by biome (grass, leaves, water) are
tinted with the pack's `colormap/grass.png` and `foliage.png`. Anything the
pack doesn't have keeps its built-in texture. The crack stages
(`block/destroy_stage_0` .. `9`), the health bar hearts
(`gui/sprites/hud/heart/full`, `half` and `container`) and the door
(`block/oak_door_top`, `oak_door_bottom`, `item/oak_door`) come from the
pack too. A pack's crack images are meant to darken the block under them,
which can't be done here, so only their darker pixels are drawn. Cows, pigs and zombies use
the pack's mob skins (`entity/cow/cow.png`, `entity/pig/pig.png`,
`entity/zombie/zombie.png`): every
face of the model is cut from its own rectangle of the skin. Packs made for
16 x 16 work best: bigger images are sampled down, and only 8 colours of
a detailed image survive. Interlaced PNGs aren't supported.

## Fonts

The game's text (hotbar counts, messages, the help and inventory screens)
can use any font installed in Windows. In **Settings**:

- **Next font** steps through fonts that come with Windows (Arial, Segoe
  UI, Consolas, Courier New, Verdana, Tahoma, Trebuchet MS, Georgia,
  Comic Sans MS); **12d's default** goes back to the normal font.
- **Font name** takes the name of any installed font; press **Use this
  font name**.
- **Font file** takes a `.ttf`, `.otf` or `.ttc` file; **Use this font
  file** reads the font's name from the file and uses it.

12d can only draw with fonts that Windows has installed, so a font file
you pick has to be installed too (double click it, then **Install**). If
a font isn't installed, Windows draws a similar one instead. The choice is
saved with the other settings (a font file's path too). After switching back
to 12d's default, the default font comes back the next time the game opens.
The Windows build (`tools/desktop`) can use a font file without installing
it: it loads the chosen file for itself, then and every time it starts.

## What's in it

- **Blocks:** dirt, grass, stone, cobblestone, sand, sandstone, gravel, coal
  ore, iron ore, cactus, oak log, leaves, oak planks, water, bedrock,
  glass, crafting table, furnace, chest, bed, door and torch. Each has its own 16 x 16 pixel texture,
  generated by the macro when it starts (or taken from a resource pack).
  Near faces show all 16 x 16 pixels; at the **High** texture detail
  setting they do from further away too.
- **Plants:** grass tufts, poppies and dandelions in meadows, dead bushes
  in deserts. Each is two pictures crossed in an X, like the block game's
  plants, so they look the same from every side; you walk through
  them, break them with one hit, and placing a block replaces them. Torches,
  flowers and grass are only aimed at (and outlined) where they really
  are, so you can reach past them.
- **Water:** seen from above you see through it: the bed and banks under
  it are drawn tinted blue, with a few light glints drifting across the
  surface (12d can't draw see-through colours, so this stands in for it).
- **Terrain:** generated from the seed. Rolling hills with the odd steep
  area, forests with open clearings between them, sandy deserts with
  cacti, beaches and oceans (water fills every open cell below y 62).
  Underground there are winding caves, coal ore, iron ore (below y 44) and
  gravel. Some worlds
  get small ponds. A starter house is built near the middle of the world:
  cobblestone floor, log corners, plank walls with an open door and
  windows, a crafting table, a furnace, a bed and a chest.
- **Day and night:** a day lasts 20 minutes. The sun and moon cross the
  sky, the sky turns orange at sunrise and sunset and dark blue at
  night, stars come out, and the land goes dark. The time is on the
  status line and is saved with the world.
- **Light:** faces get darker the further they are below open sky (caves,
  overhangs, the shade of trees) and in corners and creases (this can be
  turned off in the settings). **Torches** give off light that spreads
  through the air around corners and fades over 14 blocks, so caves and
  houses can be lit at night. A **burning furnace** glows and lights its
  surroundings too (a little less than a torch) until its fuel runs out.
  Glass lets light through.
- **Zombies:** at night they come out in the dark, 14 to 30 blocks away
  (never right next to torches). They walk straight at you, hit for 3
  with a knock-back, take a few hits to kill, drop rotten flesh, and burn
  up when the sun rises unless they're in the shade.
- **Beds:** two blocks long: the foot goes where you click and the head one
  block further the way you are looking. Right-click either half at night
  to sleep until morning; using a bed also makes it your respawn point.
  Breaking either half removes the whole bed and drops one bed.
- **Doors:** two blocks tall, made from 6 planks. A shut door is a thin
  panel on the side of its block you were facing; right-click to swing it
  open or shut. You can't walk through a shut door. The top half has
  windows you can see through. Breaking either half drops one door.
- **Chests:** hold 27 stacks. Right-click to open; the contents are
  saved with the world and spill out if the chest is broken.
- **Player:** 1.8 blocks tall, with 5 blocks of reach, gravity and collision,
  swimming, fall damage, a 10-heart health bar and slow healing. **C** (or
  Shift with a movement key) crouches: lower, slower, and you stop at
  edges instead of walking off. **G** turns on flying: no gravity, Space
  rises, C or Shift sinks, and you still collide with blocks.
- **Breaking and placing:** a block being broken cracks in 10 pixel-art
  stages (the resource pack's `destroy_stage` images if it has them).
  Broken blocks drop as items that are picked up when you walk near them.
  Furnaces turn to face you when placed.
- **Tools:** wooden, stone and iron pickaxes, axes, shovels and swords. The
  right tool breaks a block in fewer hits. **Stone, cobblestone, sandstone,
  coal ore and furnaces drop nothing unless mined with a pickaxe, and iron
  ore needs a stone or iron pickaxe.** Swords and axes hit cows harder.
  Tools wear out (a bar under the icon shows how much) and break after 60
  (wood), 132 (stone) or 251 (iron) uses.
- **Inventory:** a 9-slot hotbar and a 27-slot (9 x 3) inventory. Click to pick
  up, drop or swap a stack. Right-click to split a stack or place one item.
  Every item that isn't a block has its own 16 x 16 pixel-art icon.
- **Crafting:** lay items out in the grid: 2 x 2 in the inventory (E), 3 x 3
  at a crafting table. The result appears in the output slot; click it to
  craft. Shapes can go anywhere in the grid and can be mirrored.

  | Result            | Grid                                             |
  |-------------------|--------------------------------------------------|
  | 4 oak planks      | 1 oak log                                        |
  | 4 sticks          | 2 planks, one above the other                    |
  | crafting table    | 2 x 2 planks                                     |
  | sandstone         | 2 x 2 sand                                       |
  | 4 torches         | coal over a stick                                |
  | chest             | 8 planks round the edge of the 3 x 3 grid        |
  | bed               | 3 leaves over 3 planks                           |
  | 3 oak doors       | 2 x 3 planks                                     |
  | furnace           | 8 cobblestone round the edge of the 3 x 3 grid   |
  | pickaxe           | 3 planks, cobblestone or iron ingots across the top, 2 sticks down the middle |
  | axe               | 3 planks, cobblestone or iron ingots in an L, 2 sticks |
  | shovel            | 1 plank, cobblestone or iron ingot over 2 sticks |
  | sword             | 2 planks, cobblestone or iron ingots over 1 stick |

- **Furnace:** has input, fuel and output slots. It cooks beef, bakes
  cobblestone into stone and sand into glass, smelts iron ore into iron
  ingots, and turns logs into coal.
  Coal, logs, planks, sticks, crafting tables and wooden tools burn. It keeps
  cooking while you are in a menu or paused.
- **Cows and pigs:** they wander the grassland and avoid cliffs and
  water. They run when hit; cows drop 1–3 raw beef and pigs 1–3 raw
  porkchops, which cook in a furnace. The models have the block game's
  proportions (cow: body, head with horns, four legs; pig: body, head
  with a snout, four short legs) and a texture per face. Their legs swing
  from the hip as they walk and their heads look round, and at you when
  you're close. A new world
  starts with 10 cows and 6 pigs, and more turn up now and then away
  from you. Raw beef and porkchops heal 2, cooked ones 7 and rotten
  flesh 1.

## Code layout

```
cubeland.4dm          main(): world menu, then the game, until Quit
CLAUDE.md             project rules and testing notes on top of the style guide
resources/            12dPL style guide, differences from C, API references
docs/                 the ScuffedMinecraft port plan and its progress
src/build.4dm         includes include/core/safety.h first, then every source file
src/<part>/*.4dm      the code, one folder per part of the game (below)
include/<part>/*.h    each module's constants, record field names and prototypes,
                      in the same folders as its source
  core/               util, records (Attributes records, the random sequence),
                      slots (which mob, drop and furnace numbers are in use),
                      events (the game event queue); common.h, config.h
                      (sizes and limits), debug.h, safety.h (blocks dangerous
                      12d calls)
  blocks/             blocks (block and item rules), textures (the built-in
                      textures), resource_pack (zip, deflate and PNG reading)
  world/              world (block grid, terrain, light), mesh (cached
                      visible faces), physics (collision, ray casting)
  items/              inventory, crafting, furnace, chest, drops
  mobs/               cows (cows, pigs and zombies)
  player/             player: movement and actions
  render/             render_world (the 3D view), render_hud (crosshair,
                      hotbar, health, hand, help, item icons), render_ui
                      (inventory, crafting table, furnace and chest screens)
  program/            settings (the settings record and its file), save
                      (world files), commands (the chat commands), game
                      (starting worlds, the per-frame update, event dispatch)
  ui/                 menu_panel, settings_panel, game_panel (the 12d panels:
                      the controllers), font (font names and files)
tools/test_harness/   runs the macro as C++ for testing (not used by 12d)
tools/desktop/        the same macro as a Windows program (not used by 12d)
```

The code follows model–view–controller and the rules in
[resources/12dPL Style Guide.md](resources/12dPL%20Style%20Guide.md)
and [CLAUDE.md](CLAUDE.md):

- **Records.** Game state lives in 12d `Attributes` used like structs: the
  player, inventory, crafting grid, furnaces, cows, drops, settings, HUD,
  UI, recipe book, world info, the random sequence and the event queue.
  Each module has getters and setters for its records, e.g.
  `player_position(player, x, y, z)`.
- **Honest functions.** Records, the time and the random sequence are
  passed in as parameters, so a function's signature shows everything it
  reads and writes. Only the controllers name the global records. The big
  tables (block grid, face cache, textures) stay as arrays owned by one
  module; they are the documented exceptions.
- **Events.** The model modules (world, player, cows and so on) never call
  each other to report what happened. They emit an event into the queue
  record, and `game_dispatch_events()` passes each event to every module's
  `*_on_event()` handler. For example, breaking a block emits
`EVT_BLOCK_BROKEN`. The mesh module then rebuilds the nearby faces, the drops
module spawns the item, the save module records the change, and the furnace
module drops a broken furnace's contents.

### Rendering

- The world is one fixed 128 × 96 × 128 array, generated in full when it is
  created. For drawing it is cut into 16×16×16 sections (chunks). Each section caches the block faces
  that touch air, grouped by direction (plus a group for plants), with a light
  level per face, so a frame only walks those lists. Whole groups facing away
  from the camera are skipped.
- Faces are projected through a pinhole camera and painted far to near. For
  unit cubes on a grid, ordering by each cube's centre distance is a valid
  back-to-front order, so a bucket sort is enough.
- Torch light is stored in the block grid itself: a cell holds
  `block + 64 * light`, so no second 1.5-million-cell array is needed and
  unlit cells (nearly all of them) read as plain block numbers. Placing or
  breaking a block next to any light relights a 31 × 31 × 31 box around it
  with a flood fill. Each cached face keeps its sky light and torch light
  apart, so the night only dims the sky part.
- Sections more than 40 blocks above or below the eye are skipped. Water
  surfaces ripple with drifting light and dark bands.
- Each texture is stored as a base colour plus merged rectangles of its other
  colours. Close faces get every rectangle, mid-range faces only the larger
  ones, and distant faces a single average colour. Colours are shaded by face
  direction and fade into the sky with distance.

### Tuning

`include/core/config.h` holds the world size, physics and entity limits.
`render_set_detail()` in `src/render/render_world.4dm` holds the three texture detail
levels; the render distance is a setting (8 to 64 blocks). Array sizes must be plain numbers, so
when you change the world size, also update the products written next to it
(`WORLD_CELLS`, `WORLD_COLUMNS`, the strides, the section counts and
`FACE_POOL_SIZE`).

### Safety

`include/core/safety.h` is the first file `src/build.4dm` includes. It
`#define`s every 12d call that could do harm (start a program, delete or
copy files, delete or change models, tins, views or project settings, use
the clipboard, databases or the network) as `illegal_call`, which doesn't
exist, so a macro that uses one of them doesn't compile. Even `File_open`
is blocked: files are opened with `safe_file_open()`, which reads any
file but only writes inside `cubeland_worlds`. You can check what the
macro is able to do by reading that one file. Deleting a world therefore
empties its file (the menu then hides it) instead of deleting it.

## Testing note

This was written without access to 12d Model. To check it, the macro was
translated into C++ and run against stand-ins for the 12d calls it uses
(panels, `Draw_Box` drawing, files, events, Attributes). That harness is in
`tools/test_harness`, and its README explains how to use it. It covered world generation,
movement, breaking and placing, 2 x 2 and 3 x 3 crafting, tools, cooking,
cows, fall damage, death and respawn, the settings panel, saving and
loading, resource packs (every decoded pixel is compared with the
source images), iron, flying and pick block, day and night, torch light
(including after loading), zombies, glass, beds and chests, with the
frames rendered to images. The
code sticks to the language features and library calls the 12dOOM macro
uses.

Some things could not be checked:

- **Frame rate in 12d.** At a 20 block view a frame runs about 250,000
  statements, which the 12dOOM timings put at roughly 25–30 frames per
  second. The default view is now 50 blocks, which draws more faces, so
  if it's slow press `-` (or use Settings) for a shorter view. The **I**
  statistics show the fastest, average and slowest frame of each second.
- **Resource pack loading time.** Decoding a pack runs in 12dPL, one bit
  at a time. It takes a fraction of a second in the test harness; in 12d
  it could take several seconds.
- **The large arrays.** The world is a 1.5-million-cell array and the face
  cache 786,432 entries per field. If 12d refuses arrays that large, reduce
  `WORLD_SIZE_X`/`WORLD_SIZE_Z` (and the products next to them) in
  `include/core/config.h`.
- **Attributes.** The records rely on `Get_attribute`, `Set_attribute`,
  `Attribute_delete_all` and reading attributes by number for saving. A frame
  makes roughly 1,000–2,000 attribute calls; if those turn out to be slow in
  12d, see the optimising step (O1) in `docs/scuffedminecraft_plan.md`.
  Loops over mobs, drops and furnaces already go through a list of the
  used slots (`slots.4dm`) instead of asking every slot's record.

## Credits

Some world features (caves, plants that face the camera, ponds, corner
shading) follow the ideas in
[ScuffedMinecraft](https://github.com/WSAL-Evan/ScuffedMinecraft) by WSAL Evan,
used under its MIT licence:

> MIT License
>
> Copyright (c) 2024 WSAL Evan
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
