# Cubeland: notes for Claude

Read these first; this file only adds what they don't cover:

- `resources/12dPL Differences from C Language.md`
- `resources/12dPL Style Guide.md`
- `resources/12dpl_functions_documentation.json` and
  `resources/12dpl_data_types_documentation.json` for library calls and types

Don't edit anything in `resources/` other than this project's own notes:
those files are the owner's. `README.md` has the player-facing description
and the code layout (`src/<part>/`, `include/<part>/`).

## Working here

- Only 12dPL matters. The C++ under `tools/` exists to test and demo the
  macro; never change the macro to suit the tools.
- Ask before reshaping anything outside Cubeland (a past rewrite of a
  scaffold was rejected and had to be reverted).
- `release/cubeland_worlds/` holds the owner's saved worlds. Leave it alone.
- Commit and push to the branch you are given; no pull requests unless asked.

## Project specifics on top of the style guide

### Honest functions

- Only the controllers (`src/ui/*_panel.4dm`) and `game.4dm`'s top-level
  update and dispatch name the global records (`g_player`, `g_cows`, ...).
  Everything below takes the record as a parameter, with `&` if it writes it.
- Hidden inputs are parameters too: randomness comes from a random record
  (`random_next(p_random)`), time as `p_now` / `p_dt`, keys and mouse from the
  controller. Only the controller calls `Get_time` or `Get_random_number*`.
- Results come back through `&` parameters or result records, never through
  "result" globals.
- Allowed exceptions are big arrays owned by one module, which only that
  module writes and others read through its functions (the world, mesh,
  physics and save headers list theirs under `// Table functions`):

  | Table                                     | Owner               |
  |-------------------------------------------|---------------------|
  | `g_world`, height and biome maps, `g_light_q*` | `world.4dm`    |
  | `g_face_*`, `g_section_*`, `g_cell_*`     | `mesh.4dm`          |
  | texture pixels, palettes, rectangles      | `textures.4dm`      |
  | render scratch, `g_view_*`                | `render_world.4dm`  |
  | `g_edit_*`                                | `save.4dm`          |
  | `g_pack_*`, `g_inflate_*`                 | `resource_pack.4dm` |
  | `g_icon_*`                                | `render_hud.4dm`    |

### Records (Attributes)

- Field names are object-like macros in the module's header
  (`#define ATTR_PLAYER_SELECTED ("selected")`); shared ones such as `ATTR_X`
  are in `include/core/records.h`. Never spell a field name inline.
- `record_clear(record, DATATYPE_...)` empties a record and stamps its type.
- A collection is one record with numbered fields: `"x_3"` is field `x` of
  entity 3 (`record_real_at(p_cows, ATTR_X, l_cow)`). No arrays of Attributes.
- A field keeps the type of its first write; read it with the matching getter.
- Pass records with `&` and never copy them with `=`: 12d doesn't document
  whether Attributes copy or share, so code must work either way.

### Events

- Modules emit events (`emit_cell_event(p_events, EVT_BLOCK_BROKEN, ...)`)
  rather than calling each other to report something. Event ids are in
  `include/core/events.h`.
- `game_dispatch_events()` hands each event to every module's
  `*_on_event()`. To react to something, add a case there, not a call at
  the place it happens. Calling another module's honest query functions
  (`block_is_solid`, `item_name`) is fine.

### More 12dPL pitfalls met in this code

- Array sizes must be literal numbers (use a macro from `config.h`).
- Declare loop variables at the top of the function; never declare a name
  twice in one function.
- Turn a Real into an Integer by assignment (`Integer l_i = Floor(x);`) or
  `floor_integer()`; don't pass a Real to an Integer parameter.
- A variable and a function can't share a name; the prefixes prevent it.

### Safety

- `include/core/safety.h` is the first include of `src/build.4dm`. It
  defines every dangerous 12d call as `illegal_call`. Never include anything
  before it or `#undef` its names; add any new dangerous call you meet.
- Open files only with `safe_file_open()`. It writes only inside
  `SAFE_WRITE_FOLDER` (`cubeland_worlds`).
- Never delete files; overwrite them with a marker (`save_delete_world()`).

## Testing: `tools/test_harness`

It translates the macro to C++, runs scripted scenarios under
AddressSanitizer and UndefinedBehaviorSanitizer, and renders snapshots.
`tools/test_harness/README.md` explains scenarios, hooks and tracing.

```bash
cd tools/test_harness && ./build.sh && ./run.sh --all
```

After a change:

- The build prints `lint problems: 0`.
- Every scenario ends with `type errors 0` and no sanitizer report.
- Look at the PNGs in `run/out/` for anything visual.

Things learned the hard way:

- A `snap` straight after a hit catches the hit flash; put `wait 1` first.
- Long `time` steps can let the game idle into a pause
  (`IDLE_RELEASE_SECONDS`), so the next snap shows the pause screen.
- Mouse capture can't be tested here (no real cursor or focus); say so
  when changing `game_panel.4dm`'s capture code.

## Windows build: `tools/desktop`

The same macro as a Windows program, for trying it without 12d. Build with
`./build_with_zig.sh` (see `tools/desktop/README.md`; set `ZIG` if Zig isn't
`python3 -m ziglang`), then copy `tools/desktop/build/cubeland.exe` to
`release/cubeland.exe` and commit it with the change.
