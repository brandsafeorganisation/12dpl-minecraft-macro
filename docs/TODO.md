# To do

Issues and additions the owner has asked for, newest first. Move an
item to "Done" (with the commit) when it is finished and tested.

## Open

### Rendering and models

- **Looking straight up darkens the player's head.** Looking directly
  up makes the player's head go dark.
- **Animate the portal.** The Nether portal is a still purple face; it
  should swirl like the block game's.
- **Worn armour should use the resource pack.** Armour on the player
  model is drawn in built-in colours; use the pack's armour layer
  textures (`textures/models/armor/iron_layer_1.png` and `_2`).
- **The player can't look over their left shoulder.** The head turns
  further to one side than the other.
- **Flying in creative should still walk.** Flying should still show
  the walking animation, as in the block game.
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

### The Nether and portals

- **Rework how a chest's dimension is kept.** At present each chest
  (and furnace, mob and drop) carries a `dim` field and the slot indexes
  filter on it. A chest shouldn't have to know its dimension. Instead,
  keep each dimension's things in a store of their own, and save each
  dimension to a folder of its own, as the block game does (`DIM-1`
  for the Nether).
- **Portal timing and effect:**
  - creative: travel instantly;
  - survival: travel after 5 seconds, with the
    whole screen covered by a warping purple portal overlay that
    builds up while you stand in it.
- **Flint and steel lights fires anywhere.** It should start a fire on
  any solid block's face (not in water or lava), not only light a
  portal. Fire burns, spreads to flammable blocks and hurts.

### Items and blocks

- **Diamonds and the jukebox:**
  - diamond ore, deep underground (iron pickaxe or better);
  - the diamond item;
  - diamond tools: pickaxe, axe, shovel, sword and hoe if hoes exist;
  - diamond armour;
  - a jukebox, crafted like a chest (planks all round) with a diamond
    in the centre.

## Done

- Key Binds screen in the block game's style, with every key
  changeable; the old help panel removed; Q drops the held item (Ctrl+Q
  the stack); C no longer crouches; Ctrl+W sprints.
