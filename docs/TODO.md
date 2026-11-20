# To do

Issues and additions the owner has asked for, newest first. Move an
item to "Done" (with the commit) when it is finished and tested.

## Open

### Multiplayer: real LAN

- Open to LAN and Play Multiplayer should work between PCs on the same
  network without a shared folder. 12dPL has no sockets and cmd.exe
  can't listen, so a small PowerShell helper (started hidden with
  `Create_process`) carries the log lines over UDP broadcast (finding
  worlds) and TCP (playing), writing the same files the shared-folder
  mode reads. The investigation and plan: `docs/lan_plan.md`.

## Done

- Open to LAN from the game menu (where Mode was): the LAN World screen
  sets the game mode guests join in and Allow Cheats, then Start LAN
  World hosts the world being played; the name is the 12d user name.
  Play Multiplayer lists open LAN worlds (host, world, the mode you'd
  join in) with Join Server, Refresh and Back; a world closed by its
  host leaves the list. Cheats (`/time`, `/gamerule`, `/give`,
  `/gamemode`) only work in a LAN world that allows them; `/whisper`
  (`/w`, `/msg`, `/tell`). Still through the shared folder (any folder
  named `cubeland_mp`). The bed's foot end is the right way up, and the
  bed item is a little bed drawn from the pack's bed pictures.

- The first-person arm is the skin's right arm (sleeve and all; slim
  skins are found and get 3 pixel arms on the model too); tools are
  held tipped forward by the handle; the bed is one mattress on legs
  across both halves; chests are 14/16 with a lid and latch, face the
  player when placed and join into 54-slot double chests; chests, beds
  and worn armour use the pack's entity pictures (the layout of the
  chest and bed pictures is from the block game's format and hasn't
  been checked against a real pack); container screens are titled.

- Each dimension keeps its own mobs, drops, furnaces and chests (no
  `dim` fields; the other dimension's are put away and swapped back at
  a portal), and a world is saved as a folder with the Nether in
  `DIM-1`; older single-file worlds still load.

- The head stays lit looking straight up; it turns as far left as
  right; flying shows the walking legs; the portal swirls (8 frames,
  the pack's animation strip if it has one); a survival portal takes
  5 seconds with a swirling purple overlay closing in and the view
  swimming, a creative one is instant; flint and steel lights fires on
  any block, which spread, burn wood away and hurt; diamond ore,
  diamonds, diamond tools and armour, the jukebox; worn armour uses
  the pack's armour layers (old or new layout).
- Key Binds screen in the block game's style, with every key
  changeable; the old help panel removed; Q drops the held item (Ctrl+Q
  the stack); C no longer crouches; Ctrl+W sprints.
