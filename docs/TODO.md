# To do

Issues and additions the owner has asked for, newest first. Move an
item to "Done" (with the commit) when it is finished and tested.

## Open

### Rendering and models

- **The first-person arm should match the player model.** It should
  use the skin's arm (slim or wide) and sleeve, not a stand-in.
- **Hold tools like tools.** A pickaxe or sword should be held at an
  angle, the way it is held in the block game, not shown as a flat
  item picture in the hand.
- **Fix the bed.** The two halves look disjointed and don't use the
  resource pack's bed texture.
- **Chest:**
  - use the resource pack's chest texture;
  - make it smaller than a full block (14/16 wide and tall);
  - add double chests: two chests side by side make one 54-slot chest.

## Done

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
