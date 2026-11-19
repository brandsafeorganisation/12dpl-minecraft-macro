# Cubeland test harness

A way to run and check Cubeland on Linux without 12d Model.

12dPL is close enough to C++ that the macro can be turned into a C++ program
with a few mechanical changes. The harness does that, replaces each 12d
library call with a small stand-in, and drives the game from a script of
clicks and keys instead of a person. It is only a testing tool: the macro
never uses it, and nothing here goes into 12d.

## What it can tell you

- **The game logic works.** Scenarios break blocks, craft, kill a cow, cook
  beef, fall, die, respawn, and save and load worlds. `call dump` prints the
  player, inventory, cows, drops and furnaces so you can see the result.
- **What the screen looks like.** Every polygon the macro draws is filled
  into an image. `snap` saves the current frame to `run/out`.
- **Array mistakes.** It is compiled with AddressSanitizer and
  UndefinedBehaviorSanitizer, so reading past the end of an array, or before
  index 1, stops the run with a report pointing at the line.
- **Record mistakes.** The `Attributes` stand-in copies by value (so code
  that only works if 12d shares Attributes as handles breaks here) and
  checks field types: a field written as an Integer and read as a Real is
  reported as a type error. Each run ends with the number of attribute
  calls and type errors; the type error count should be 0.
- **Some 12dPL pitfalls.** The translator warns about `+=`, `?:`, variables
  declared in `for` headers, joining two string literals, declaring
  the same variable twice in a function, and parameters or locals without
  their `p_` / `l_` prefix.

What it can't tell you: how fast the macro runs in 12d, how 12d's own panels
and widgets behave, or whether 12d accepts something that C++ accepts. The
stand-ins only copy the behaviour the macro relies on.

## How it works

1. `translate.py` runs the C preprocessor over `cubeland.4dm`, removes the
   `{ }` braces around global variables, adds 1 to every array size (12dPL
   arrays start at 1), renames `main` and writes `build/game.cpp`.
2. `runtime.h` defines the 12dPL types (`Integer`, `Real`, `Text`,
   `Attributes`, ...) and stand-ins for the library calls: maths, text,
   attributes, files, panels and widgets, the cursor and the clock.
3. `harness.cpp` holds the drawing calls, which fill polygons into a pixel
   buffer, and `Wait_on_events`, which plays back the scenario script. Each
   script step becomes the event 12d would send, and the clock moves on
   1/30 s per event.
4. `hooks.cpp` is appended to the translated game (after the macro's
   `#define`s, dumped with `cpp -dM`), so it can use the macro's records,
   functions and constants. That's where `call` commands such as `dump`,
   `give_beef` or `aim_cow` live.

## Using it

You need `g++`, `python3` and `cpp`. Pillow (`pip install pillow`) is only
needed to turn the snapshots into `.png` files.

```bash
./build.sh
```

```bash
./run.sh --all
```

```bash
./run.sh scenarios/02_crafting_and_tools.txt
```

Each run starts with no saved worlds. Pass `--keep` to keep them, which
scenario 06 needs because it loads the world that 05 saves. Worlds go in
`run/cubeland_worlds` and snapshots in `run/out`. `build.sh` builds two programs:
`build/game` from `cubeland.4dm` and `build/test` from the test build
`test/cubeland_test.4dm`; a scenario with the line `# build: test` runs the second.
The test build's clock counts real time, so its reports show real call times.
The build first checks the test registry is up to date
(`python3 tools/make_test_registry.py --check`). Rebuild after changing the
macro.

## Scenario scripts

One command per line; `#` starts a comment.

| Command                | What it does                                                   |
|------------------------|----------------------------------------------------------------|
| `ui <label>`           | click the menu widget (button, field, row) whose label is or starts with `<label>`; `#<id>` picks one by id, `row:<world>` a world's row; the game menu's buttons by name too |
| `field <label>\|<text>` | click a text field, rub out what's in it and type `<text>`   |
| `slide <label>\|<f>`   | click a slider `<f>` (0..1) of the way along                   |
| `input <title>\|<text>` | test build only: type text into its panel's input box         |
| `button <reply>`       | test build only: press one of its panel's buttons              |
| `select_name <name>`   | test build only: select that item in its function list         |
| `click <x> <y>`        | left click the view at (x, y), from the bottom left            |
| `rclick`, `lbdown`, `move` | right click, mouse down, or mouse move at (x, y)           |
| `capclick`, `caprclick` | left or right click at the cursor while it's captured         |
| `look <dx> <dy>`       | move the mouse by (dx, dy) pixels                              |
| `wait <n>`             | let n frames pass                                              |
| `key <c> [n]`          | press a key (n times); `space` for the space bar; `bs` and `ctrlbs` are Backspace and Ctrl+Backspace as 12d sends them (characters 8 and 127), `ctrlq` is Ctrl+Q (Ctrl + a letter is characters 1 to 26), `shift` is Shift alone as the Windows build sends it |
| `type <text>`          | press each character of the rest of the line, spaces included   |
| `enter`                | press Enter in the keys box (sends a chat line)                |
| `holdkey <c> <n>`      | hold a key for n frames (auto-repeat)                          |
| `time <s>`             | move the clock on by s seconds without a frame                 |
| `snap <name>`          | save the next frame as `run/out/<name>.ppm`/`.png`; prints its polygons, draw calls, texts and record calls (`FRAME_LOG=1` prints them for every frame) |
| `call <hook>`          | run a hook from `hooks.cpp`                                    |
| `quit`                 | close the panel                                                |

When a script runs out, the panel is closed, so every scenario ends.

`snap` names the next frame that is drawn, which is the frame after the next
event, so put a `wait 1` (or another event) after it. Menus only redraw when
the mouse moves onto another widget or every 0.1 s, so after a snap of a
menu wait 4 frames.

`ui` looks the widget up in the menu as it was last drawn, so a `ui` line
works on whatever screen the previous line left on show. Each run gets
`run/resourcepacks` (the test pack's zip and folder, and a file that isn't
a pack), `run/skins` (the supplied skin and a file that isn't one) and
`run/fonts` (the test fonts) for the pickers. `call` hooks that click
(`slot<n>`, `output`, `grid_*`) put their clicks at the front of the queue, so
they happen before the next script line.

Two environment variables help when something goes wrong:

```bash
TRACE=1 ./run.sh scenarios/02_crafting_and_tools.txt
```

```bash
TRACE_ATTR=1 ./run.sh scenarios/07_scenery.txt
```

`TRACE` prints every scripted event; `TRACE_ATTR` prints the record fields
that were looked up most often (to find hot spots).

## Scenarios

| Script                        | Checks                                                          |
|-------------------------------|-----------------------------------------------------------------|
| `01_tour`                     | create a world, spawn in the house, look, walk, inventory       |
| `02_crafting_and_tools`       | planks and a crafting table in the 2 x 2 grid, place the table, sticks and a pickaxe in its 3 x 3 grid; stone drops nothing by hand and cobblestone with the pickaxe, which wears |
| `03_cow_and_furnace`          | kill a cow with a sword, place a furnace facing the player      |
| `04_texture_stats`            | how many rectangles each texture and sprite is drawn with       |
| `05_cooking_and_save`         | cook beef through the furnace screen, eat, save                 |
| `06_load_fall_respawn`        | load the world from 05, fall damage, death and respawn          |
| `07_scenery`                  | biome and terrain statistics; the house, water, forest, desert, meadow, cave and hills; water seen from above |
| `08_crack_and_underwater`     | crack overlay on stone, the underwater view                     |
| `09_click_to_play`            | a new world waits for a click ("Click to play")                 |
| `10_settings`                 | the settings panel from the menu and in game, the - / = keys    |
| `11_save_and_load`            | items, tool wear, a furnace and block edits survive save and load |
| `12_delete_world`             | the world list; deleting a world (asked twice) empties and hides its file; the name can be reused |
| `13_resource_pack`            | the pack picker; a file that isn't a pack is reported; the test pack loads from its folder and from its zip (see below) |
| `14_iron_fly_pick`            | iron ore needs a stone pickaxe, iron recipes, pick block, hiding the HUD, frame statistics, a double Space that does nothing in survival, then /gamemode creative and flying |
| `15_night_torches_zombies`    | a torch lights a cave and the light goes when it's broken; sunset and night skies; a zombie walks up and hits, a sword kills it; zombies spawn at night and burn at noon; glass; the house at night; a bed skips to morning and sets the spawn point |
| `16_chest`                    | items put in a chest survive save and load and spill out when it's broken |
| `17_mob_models`               | the cow from the front, side and back, and a zombie, with their per-face textures |
| `18_plants`                   | grass, a poppy, a dandelion, a dead bush and a torch drawn as crossed pictures, from the front, an angle and above; aiming through the empty part of a poppy's cell hits what's behind it; a torch's small outline |
| `19_fonts`                    | the font picker, a typed font name, family names read from the font files in the fonts folder (Windows and Mac names, a collection, a file that isn't a font), and the game drawing its text with the chosen font; run `make_test_fonts.py` first |
| `20_lit_furnace`              | a furnace with fuel becomes a lit furnace block that gives off light, and goes dark again when it stops burning |
| `21_pigs`                     | a new world has pigs; the pig model from the side and the front; a pig killed with a sword drops raw porkchops |
| `22_doors_beds_crouch`        | a door placed, opened, shut and walked into; the door's edge; a two block bed placed and broken (one bed drops); Shift stops you at a hole's edge; Shift sinks while flying; the house's door and bed |
| `23_chat_commands`            | T and / open the chat line; /time set and add, /gamerule doDaylightCycle (the clock stops), /give (with and without minecraft:), an unknown item and command, Escape, /gamemode creative (no hearts) and survival |
| `24_multiplayer`              | hosting a world; a made-up second player's log (joining, chat, walking, a block, a half written line, a clock the host ignores, leaving); the host's broken block in its log; joining the session gets the snapshot plus every log |
| `25_game_modes`               | spectator flies down through the ground, can't break anything or open the inventory and has no hotbar; creative from there keeps flying; the creative screen lists every item, searches ("iron" finds 10), gives a full stack or one more, throws away a stack put down on it, and its tabs switch to the inventory and back; survival lands you and a double Space doesn't fly; an unknown mode |
| `26_test_build`               | the test build (`build/test`): every unit test and every function with each data set (typical, random, edges), then floor_divide 500 times a data set with its code in the report, a library call with edge values only, a panel function that can't be run, a report in another folder, Open last report; lists the reports written and what was opened |
| `27_pause_menu`               | Escape shows the game menu over the darkened world, the button under the mouse lights up, Controls opens the Key Binds and Done goes back, Mode cycles the game mode, Back to Game plays on; creative flight lands on the ground; the creative screen over the darkened world; Save and Quit to Title |
| `29_body_pose`                | the player model from outside: legs together standing still, the head turning before the body, the crouch leaning forward |
| `30_title_screens`            | the title screen; typing a new world's name in creative; its picture taken after a couple of seconds; the world list's pictures, game modes, files, dates and versions; searching it; the multiplayer screen |
| `31_armour_offhand_eggs`      | only the right piece goes in each armour slot; the picture in the inventory, the armour bar and the 3D model wear it; a zombie's hit is 1 not 3 in full iron and wears every piece; a torch in the offhand shows by the hotbar, is placed with an empty main hand and X swaps it; a cow egg makes a cow (used up in survival); the armour comes back with the world; the eggs in the creative list and a zombie egg not used up |
| `32_nether`                   | an overworld has lava pools with obsidian rims; flint and steel lights an obsidian frame; standing in the portal takes you to the Nether, where a portal is built for you; its netherrack, lava, soul sand, glowstone and quartz; lava burns in survival; a world saved in the Nether opens there; back through, the overworld's frame is still there; breaking the frame puts the portal out |
| `33_key_binds`               | the Key Binds screen from the options: changing a key, a shared key in red, Reset and Reset Keys, scrolling; in the game Q drops one, Ctrl+Q the stack, C does nothing, Shift with W sneaks, Ctrl+W sprints, Escape pauses |
| `34_diamonds_fire`           | diamond ore in a new world, diamond armour from in front, the head lit looking straight up and turning both ways, flint and steel lighting a fire that flickers, spreads along a planks wall and burns it and a jukebox away, fire hurting in survival, a survival portal taking 5 seconds under the purple overlay, a creative one at once |
| `28_skin_camera`              | the skin picker: a file that isn't a skin is reported, the supplied skin (`release/skins/purple.png`) dresses the player model; V: the camera behind, in front (walking backwards), and the eyes again |

### Font files

`make_test_fonts.py` writes the small font files scenario 19 reads into
`packs/`: just a table directory and a name table, each storing the family
name a different way.

```bash
python3 make_test_fonts.py
```

### Resource pack test

`make_test_pack.py` writes a pack to `packs/` (ignored by git) that uses
every PNG colour type and bit depth the macro reads, all five row
filters, stored and compressed data, images bigger than 16 x 16, a tall
animation strip, colormaps, and a zip with stored and deflated entries and
a comment. Scenario 13 loads it and the `dump_textures` hook writes every
texture pixel to `run/out`; the script then compares them with the images:

```bash
python3 make_test_pack.py make
```

```bash
./run.sh scenarios/13_resource_pack.txt
```

```bash
python3 make_test_pack.py check run/out/textures.txt
```

`run/out/textures_folder.txt` holds the same check for the unzipped folder.
A real pack can be tried by copying it into `packs/` and changing the path
in the scenario.

Hooks use the macro's own constants (`ITEM_STONE_SWORD`, `BLOCK_STONE`, ...),
so they follow changes to `src/blocks/blocks.4dm`.
