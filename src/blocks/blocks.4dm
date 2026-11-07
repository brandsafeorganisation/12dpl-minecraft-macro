#ifndef BLOCKS_4DM_INCLUDED
#define BLOCKS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/blocks/blocks.h"
#include "../../include/blocks/textures.h"

// ---------------------------------------------------------------- blocks

Integer block_is_solid(Integer p_block)
// ----------------------------------------------------------------
// TRUE for blocks that stop movement and hide the faces behind them
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_AIR   ) return FALSE;
  if (p_block == BLOCK_WATER ) return FALSE;
  if (block_is_plant(p_block)) return FALSE;
  return TRUE;
}

Integer block_is_plant(Integer p_block)
// ----------------------------------------------------------------
// TRUE for grass tufts, flowers, dead bushes and torches: two
// pictures crossed in an X, that nothing collides with and that break
// with one hit
// ----------------------------------------------------------------
{
  if (p_block >= BLOCK_TALL_GRASS && p_block <= BLOCK_DEAD_BUSH) return TRUE;
  if (p_block == BLOCK_TORCH) return TRUE;
  return FALSE;
}

Integer block_box(Integer p_block, Real &p_min_x, Real &p_min_y, Real &p_min_z, Real &p_max_x, Real &p_max_y, Real &p_max_z)
// ----------------------------------------------------------------
// The part of its cell a block can be aimed at and is outlined by,
// 0..1 along each axis. Returns TRUE if that is less than the whole
// cell (torches, flowers and other plants).
// ----------------------------------------------------------------
{
  Real l_half   = 0.5;
  Real l_height = 1.0;

  if (p_block == BLOCK_TORCH) {
    l_half   = 0.0625;
    l_height = 0.625;
  } else if (p_block == BLOCK_POPPY || p_block == BLOCK_DANDELION) {
    l_half   = 0.1875;
    l_height = 0.625;
  } else if (block_is_plant(p_block)) {
    l_half   = 0.375;
    l_height = 0.8125;
  }
  p_min_x = 0.5 - l_half;
  p_min_z = 0.5 - l_half;
  p_max_x = 0.5 + l_half;
  p_max_z = 0.5 + l_half;
  p_min_y = 0.0;
  p_max_y = l_height;
  return l_half < 0.5 || l_height < 1.0;
}

Integer block_light_emission(Integer p_block)
// ----------------------------------------------------------------
// Light a block gives off (0..LIGHT_MAX_LEVEL)
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_TORCH) return TORCH_LIGHT;
  if (block_furnace_is_lit(p_block)) return FURNACE_LIGHT;
  return 0;
}

Integer block_is_see_through(Integer p_block)
// ----------------------------------------------------------------
// TRUE for solid blocks you can see through (glass): they don't
// hide their neighbours' faces, and two of them side by side don't
// draw the face between them
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_GLASS) return TRUE;
  return FALSE;
}

Integer block_hides_faces(Integer p_block)
// ----------------------------------------------------------------
// TRUE if a block hides the faces of the blocks next to it (water
// is handled separately: faces against water are drawn only when
// the camera is under water)
// ----------------------------------------------------------------
{
  if (block_is_see_through(p_block)) return FALSE;
  return block_is_solid(p_block);
}

Integer block_plant_texture(Integer p_block)
// ----------------------------------------------------------------
// Sprite drawn for a plant block, 0 if it isn't a plant
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_TALL_GRASS) return TEX_PLANT_GRASS;
  if (p_block == BLOCK_POPPY     ) return TEX_PLANT_POPPY;
  if (p_block == BLOCK_DANDELION ) return TEX_PLANT_DANDELION;
  if (p_block == BLOCK_DEAD_BUSH ) return TEX_PLANT_DEAD_BUSH;
  if (p_block == BLOCK_TORCH     ) return TEX_TORCH;
  return 0;
}

Integer block_is_furnace(Integer p_block)
// ----------------------------------------------------------------
// TRUE for any of the four furnace orientations, burning or not
// ----------------------------------------------------------------
{
  if (p_block >= BLOCK_FURNACE_PX && p_block <= BLOCK_FURNACE_NZ) return TRUE;
  if (p_block >= BLOCK_LIT_FURNACE_PX && p_block <= BLOCK_LIT_FURNACE_NZ) return TRUE;
  return FALSE;
}

Integer block_furnace_is_lit(Integer p_block)
// ----------------------------------------------------------------
// TRUE for a burning furnace block
// ----------------------------------------------------------------
{
  if (p_block >= BLOCK_LIT_FURNACE_PX && p_block <= BLOCK_LIT_FURNACE_NZ) return TRUE;
  return FALSE;
}

Integer block_furnace_lit_as(Integer p_block, Integer p_lit)
// ----------------------------------------------------------------
// The furnace block facing the same way as p_block, burning (lit
// TRUE) or not
// ----------------------------------------------------------------
{
  Integer l_unlit = p_block;

  if (block_furnace_is_lit(p_block)) l_unlit = p_block - BLOCK_LIT_FURNACE_PX + BLOCK_FURNACE_PX;
  if (p_lit) return l_unlit - BLOCK_FURNACE_PX + BLOCK_LIT_FURNACE_PX;
  return l_unlit;
}

Integer block_furnace_front(Integer p_block)
// ----------------------------------------------------------------
// Direction the door of a furnace block faces, 0 if not a furnace
// ----------------------------------------------------------------
{
  Integer l_unlit = block_furnace_lit_as(p_block, FALSE);

  if (l_unlit == BLOCK_FURNACE_PX) return DIR_PX;
  if (l_unlit == BLOCK_FURNACE_NX) return DIR_NX;
  if (l_unlit == BLOCK_FURNACE_PZ) return DIR_PZ;
  if (l_unlit == BLOCK_FURNACE_NZ) return DIR_NZ;
  return 0;
}

Integer block_falls(Integer p_block)
// ----------------------------------------------------------------
// TRUE for blocks that fall when there is nothing under them
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_SAND  ) return TRUE;
  if (p_block == BLOCK_GRAVEL) return TRUE;
  return FALSE;
}

Integer block_hand_hits(Integer p_block)
// ----------------------------------------------------------------
// Number of hits to break a block with an empty hand (or the wrong
// tool), 0 means unbreakable
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_BEDROCK       ) return 0;
  if (p_block == BLOCK_WATER         ) return 0;
  if (p_block == BLOCK_AIR           ) return 0;
  if (block_is_plant(p_block)       ) return 1;
  if (p_block == BLOCK_LEAVES        ) return 1;
  if (p_block == BLOCK_CACTUS        ) return 1;
  if (p_block == BLOCK_DIRT          ) return 2;
  if (p_block == BLOCK_GRASS         ) return 2;
  if (p_block == BLOCK_SAND          ) return 2;
  if (p_block == BLOCK_GRAVEL        ) return 3;
  if (p_block == BLOCK_OAK_LOG       ) return 4;
  if (p_block == BLOCK_PLANKS        ) return 4;
  if (p_block == BLOCK_CRAFTING_TABLE) return 4;
  if (p_block == BLOCK_GLASS         ) return 2;
  if (p_block == BLOCK_BED           ) return 2;
  if (p_block == BLOCK_CHEST         ) return 4;
  if (p_block == BLOCK_SANDSTONE     ) return 6;
  if (p_block == BLOCK_COAL_ORE      ) return 10;
  if (p_block == BLOCK_IRON_ORE      ) return 12;
  return 8;
}

Integer block_tool_kind(Integer p_block)
// ----------------------------------------------------------------
// The tool that breaks a block faster (TOOL_*)
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_DIRT          ) return TOOL_SHOVEL;
  if (p_block == BLOCK_GRASS         ) return TOOL_SHOVEL;
  if (p_block == BLOCK_SAND          ) return TOOL_SHOVEL;
  if (p_block == BLOCK_GRAVEL        ) return TOOL_SHOVEL;
  if (p_block == BLOCK_OAK_LOG       ) return TOOL_AXE;
  if (p_block == BLOCK_PLANKS        ) return TOOL_AXE;
  if (p_block == BLOCK_CRAFTING_TABLE) return TOOL_AXE;
  if (p_block == BLOCK_BED           ) return TOOL_AXE;
  if (p_block == BLOCK_CHEST         ) return TOOL_AXE;
  if (p_block == BLOCK_STONE         ) return TOOL_PICKAXE;
  if (p_block == BLOCK_COBBLESTONE   ) return TOOL_PICKAXE;
  if (p_block == BLOCK_SANDSTONE     ) return TOOL_PICKAXE;
  if (p_block == BLOCK_COAL_ORE      ) return TOOL_PICKAXE;
  if (p_block == BLOCK_IRON_ORE      ) return TOOL_PICKAXE;
  if (block_is_furnace(p_block)      ) return TOOL_PICKAXE;
  return TOOL_NONE;
}

Integer block_needs_tool(Integer p_block)
// ----------------------------------------------------------------
// TRUE for blocks that drop nothing unless broken with their tool
// (stone and everything made of it needs a pickaxe)
// ----------------------------------------------------------------
{
  if (block_tool_kind(p_block) == TOOL_PICKAXE) return TRUE;
  return FALSE;
}

Integer block_tier_needed(Integer p_block)
// ----------------------------------------------------------------
// The lowest tool tier that collects a block: iron ore needs a stone
// pickaxe or better, everything else any tier of its tool
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_IRON_ORE) return TIER_STONE;
  return TIER_WOOD;
}

Integer block_hits_with(Integer p_block, Integer p_tool_item)
// ----------------------------------------------------------------
// Number of hits to break a block holding tool_item
// The right tool divides the hand hits by 3 (wood), 4 (stone) or 6
// (iron)
// ----------------------------------------------------------------
{
  Integer l_hits  = block_hand_hits(p_block);
  Integer l_speed = 1;

  if (l_hits <= 0) return 0;

  if (item_tool_kind(p_tool_item) == block_tool_kind(p_block)) {
    if (item_tool_tier(p_tool_item) == TIER_WOOD ) l_speed = 3;
    if (item_tool_tier(p_tool_item) == TIER_STONE) l_speed = 4;
    if (item_tool_tier(p_tool_item) == TIER_IRON ) l_speed = 6;
  }

  l_hits = Floor((l_hits + l_speed - 1.0) / l_speed);
  if (l_hits < 1) l_hits = 1;

  return l_hits;
}

Integer block_drop_item(Integer p_block, Integer p_tool_item)
// ----------------------------------------------------------------
// Item left behind when a block is broken while holding tool_item,
// ITEM_NONE for nothing
// ----------------------------------------------------------------
{
  if (block_needs_tool(p_block)) {
    if (item_tool_kind(p_tool_item) != block_tool_kind(p_block)) return ITEM_NONE;
    if (item_tool_tier(p_tool_item) < block_tier_needed(p_block)) return ITEM_NONE;
  }

  if (p_block == BLOCK_GRASS   ) return ITEM_DIRT;
  if (p_block == BLOCK_STONE   ) return ITEM_COBBLESTONE;
  if (p_block == BLOCK_COAL_ORE) return ITEM_COAL;
  if (p_block == BLOCK_LEAVES  ) return ITEM_NONE;
  if (p_block == BLOCK_TALL_GRASS) return ITEM_NONE;
  if (p_block == BLOCK_DEAD_BUSH ) return ITEM_STICK;
  if (p_block == BLOCK_WATER   ) return ITEM_NONE;
  if (p_block == BLOCK_AIR     ) return ITEM_NONE;
  if (p_block == BLOCK_BEDROCK ) return ITEM_NONE;
  if (block_is_furnace(p_block)) return ITEM_FURNACE;
  return p_block;
}

Integer block_pick_item(Integer p_block)
// ----------------------------------------------------------------
// The item that places a block (for pick block), ITEM_NONE for
// blocks no item places
// ----------------------------------------------------------------
{
  if (block_is_furnace(p_block)) return ITEM_FURNACE;
  if (item_places_block(p_block) == BLOCK_AIR) return ITEM_NONE;
  return p_block;
}

Integer block_face_texture(Integer p_block, Integer p_direction)
// ----------------------------------------------------------------
// Texture drawn on one face of a block
// Lit furnace doors are swapped in by the renderer
// ----------------------------------------------------------------
{
  if (p_block == BLOCK_BEDROCK    ) return TEX_BEDROCK;
  if (p_block == BLOCK_STONE      ) return TEX_STONE;
  if (p_block == BLOCK_COBBLESTONE) return TEX_COBBLESTONE;
  if (p_block == BLOCK_DIRT       ) return TEX_DIRT;
  if (p_block == BLOCK_LEAVES     ) return TEX_LEAVES;
  if (p_block == BLOCK_WATER      ) return TEX_WATER;
  if (p_block == BLOCK_PLANKS     ) return TEX_PLANKS;
  if (p_block == BLOCK_SAND       ) return TEX_SAND;
  if (p_block == BLOCK_COAL_ORE   ) return TEX_COAL_ORE;
  if (p_block == BLOCK_IRON_ORE   ) return TEX_IRON_ORE;
  if (p_block == BLOCK_GRAVEL     ) return TEX_GRAVEL;
  if (p_block == BLOCK_GLASS      ) return TEX_GLASS;

  if (p_block == BLOCK_CHEST) {
    if (p_direction == DIR_PY || p_direction == DIR_NY) return TEX_CHEST_TOP;
    return TEX_CHEST_SIDE;
  }
  if (p_block == BLOCK_BED) {
    if (p_direction == DIR_PY) return TEX_BED_TOP;
    if (p_direction == DIR_NY) return TEX_PLANKS;
    return TEX_BED_SIDE;
  }

  if (p_block == BLOCK_GRASS) {
    if (p_direction == DIR_PY) return TEX_GRASS_TOP;
    if (p_direction == DIR_NY) return TEX_DIRT;
    return TEX_GRASS_SIDE;
  }
  if (p_block == BLOCK_OAK_LOG) {
    if (p_direction == DIR_PY || p_direction == DIR_NY) return TEX_LOG_TOP;
    return TEX_LOG_SIDE;
  }
  if (p_block == BLOCK_SANDSTONE) {
    if (p_direction == DIR_PY || p_direction == DIR_NY) return TEX_SANDSTONE_TOP;
    return TEX_SANDSTONE_SIDE;
  }
  if (p_block == BLOCK_CACTUS) {
    if (p_direction == DIR_PY || p_direction == DIR_NY) return TEX_CACTUS_TOP;
    return TEX_CACTUS_SIDE;
  }
  if (p_block == BLOCK_CRAFTING_TABLE) {
    if (p_direction == DIR_PY) return TEX_TABLE_TOP;
    if (p_direction == DIR_NY) return TEX_PLANKS;
    return TEX_TABLE_SIDE;
  }
  if (block_is_furnace(p_block)) {
    if (p_direction == DIR_PY || p_direction == DIR_NY) return TEX_FURNACE_TOP;
    if (p_direction == block_furnace_front(p_block)) {
      if (block_furnace_is_lit(p_block)) return TEX_FURNACE_FRONT_LIT;
      return TEX_FURNACE_FRONT;
    }
    return TEX_FURNACE_SIDE;
  }

  return TEX_STONE;
}

Real block_face_shade(Integer p_direction)
// ----------------------------------------------------------------
// Fixed light level of a face direction (sun from above, slightly
// to one side) so the sides of a cube read clearly
// ----------------------------------------------------------------
{
  if (p_direction == DIR_PY) return 1.0;
  if (p_direction == DIR_NY) return 0.55;
  if (p_direction == DIR_PZ || p_direction == DIR_NZ) return 0.84;
  return 0.70;
}

// ---------------------------------------------------------------- items

Text item_name(Integer p_item)
// ----------------------------------------------------------------
// Display name of an item
// ----------------------------------------------------------------
{
  if (p_item == ITEM_BEDROCK        ) return "Bedrock";
  if (p_item == ITEM_STONE          ) return "Stone";
  if (p_item == ITEM_COBBLESTONE    ) return "Cobblestone";
  if (p_item == ITEM_DIRT           ) return "Dirt";
  if (p_item == ITEM_GRASS          ) return "Grass Block";
  if (p_item == ITEM_OAK_LOG        ) return "Oak Log";
  if (p_item == ITEM_LEAVES         ) return "Oak Leaves";
  if (p_item == ITEM_PLANKS         ) return "Oak Planks";
  if (p_item == ITEM_CRAFTING_TABLE ) return "Crafting Table";
  if (p_item == ITEM_FURNACE        ) return "Furnace";
  if (p_item == ITEM_SAND           ) return "Sand";
  if (p_item == ITEM_SANDSTONE      ) return "Sandstone";
  if (p_item == ITEM_CACTUS         ) return "Cactus";
  if (p_item == ITEM_COAL_ORE       ) return "Coal Ore";
  if (p_item == ITEM_IRON_ORE       ) return "Iron Ore";
  if (p_item == ITEM_IRON_INGOT     ) return "Iron Ingot";
  if (p_item == ITEM_IRON_PICKAXE   ) return "Iron Pickaxe";
  if (p_item == ITEM_IRON_AXE       ) return "Iron Axe";
  if (p_item == ITEM_IRON_SHOVEL    ) return "Iron Shovel";
  if (p_item == ITEM_IRON_SWORD     ) return "Iron Sword";
  if (p_item == ITEM_TORCH          ) return "Torch";
  if (p_item == ITEM_GLASS          ) return "Glass";
  if (p_item == ITEM_BED            ) return "Bed";
  if (p_item == ITEM_CHEST          ) return "Chest";
  if (p_item == ITEM_ROTTEN_FLESH   ) return "Rotten Flesh";
  if (p_item == ITEM_GRAVEL         ) return "Gravel";
  if (p_item == ITEM_POPPY          ) return "Poppy";
  if (p_item == ITEM_DANDELION      ) return "Dandelion";
  if (p_item == ITEM_STICK          ) return "Stick";
  if (p_item == ITEM_RAW_BEEF       ) return "Raw Beef";
  if (p_item == ITEM_COOKED_BEEF    ) return "Cooked Beef";
  if (p_item == ITEM_RAW_PORKCHOP   ) return "Raw Porkchop";
  if (p_item == ITEM_COOKED_PORKCHOP) return "Cooked Porkchop";
  if (p_item == ITEM_COAL           ) return "Coal";
  if (p_item == ITEM_WOODEN_PICKAXE ) return "Wooden Pickaxe";
  if (p_item == ITEM_STONE_PICKAXE  ) return "Stone Pickaxe";
  if (p_item == ITEM_WOODEN_AXE     ) return "Wooden Axe";
  if (p_item == ITEM_STONE_AXE      ) return "Stone Axe";
  if (p_item == ITEM_WOODEN_SHOVEL  ) return "Wooden Shovel";
  if (p_item == ITEM_STONE_SHOVEL   ) return "Stone Shovel";
  if (p_item == ITEM_WOODEN_SWORD   ) return "Wooden Sword";
  if (p_item == ITEM_STONE_SWORD    ) return "Stone Sword";
  return "";
}

Integer item_places_block(Integer p_item)
// ----------------------------------------------------------------
// Block an item places, BLOCK_AIR if it cannot be placed
// Furnaces are turned to face the player when placed
// ----------------------------------------------------------------
{
  if (p_item < ITEM_BEDROCK   ) return BLOCK_AIR;
  if (p_item > MAX_BLOCK_ID   ) return BLOCK_AIR;
  if (p_item == BLOCK_WATER   ) return BLOCK_AIR;
  if (p_item >  ITEM_FURNACE && p_item <= BLOCK_FURNACE_NZ) return BLOCK_AIR;
  if (p_item == BLOCK_TALL_GRASS) return BLOCK_AIR;
  if (p_item == BLOCK_DEAD_BUSH ) return BLOCK_AIR;
  return p_item;
}

Integer item_is_block(Integer p_item)
// ----------------------------------------------------------------
// TRUE if the item is drawn as a little cube
// ----------------------------------------------------------------
{
  if (block_is_plant(p_item)) return FALSE;
  if (item_places_block(p_item) != BLOCK_AIR) return TRUE;
  return FALSE;
}

Integer item_max_stack(Integer p_item)
// ----------------------------------------------------------------
// How many of an item fit in one slot (tools don't stack)
// ----------------------------------------------------------------
{
  if (item_tool_kind(p_item) != TOOL_NONE) return 1;
  return MAX_STACK;
}

Integer item_tool_kind(Integer p_item)
// ----------------------------------------------------------------
// TOOL_* kind of a tool item, TOOL_NONE for everything else
// ----------------------------------------------------------------
{
  if (p_item == ITEM_WOODEN_PICKAXE || p_item == ITEM_STONE_PICKAXE || p_item == ITEM_IRON_PICKAXE) return TOOL_PICKAXE;
  if (p_item == ITEM_WOODEN_AXE     || p_item == ITEM_STONE_AXE     || p_item == ITEM_IRON_AXE    ) return TOOL_AXE;
  if (p_item == ITEM_WOODEN_SHOVEL  || p_item == ITEM_STONE_SHOVEL  || p_item == ITEM_IRON_SHOVEL ) return TOOL_SHOVEL;
  if (p_item == ITEM_WOODEN_SWORD   || p_item == ITEM_STONE_SWORD   || p_item == ITEM_IRON_SWORD  ) return TOOL_SWORD;
  return TOOL_NONE;
}

Integer item_tool_tier(Integer p_item)
// ----------------------------------------------------------------
// TIER_WOOD, TIER_STONE or TIER_IRON for tools, TIER_NONE otherwise
// ----------------------------------------------------------------
{
  if (p_item == ITEM_WOODEN_PICKAXE || p_item == ITEM_WOODEN_AXE ) return TIER_WOOD;
  if (p_item == ITEM_WOODEN_SHOVEL  || p_item == ITEM_WOODEN_SWORD) return TIER_WOOD;
  if (p_item == ITEM_STONE_PICKAXE  || p_item == ITEM_STONE_AXE  ) return TIER_STONE;
  if (p_item == ITEM_STONE_SHOVEL   || p_item == ITEM_STONE_SWORD ) return TIER_STONE;
  if (p_item == ITEM_IRON_PICKAXE   || p_item == ITEM_IRON_AXE   ) return TIER_IRON;
  if (p_item == ITEM_IRON_SHOVEL    || p_item == ITEM_IRON_SWORD  ) return TIER_IRON;
  return TIER_NONE;
}

Integer item_max_uses(Integer p_item)
// ----------------------------------------------------------------
// Number of uses before a tool breaks, 0 for items that don't wear
// ----------------------------------------------------------------
{
  if (item_tool_tier(p_item) == TIER_WOOD ) return 60;
  if (item_tool_tier(p_item) == TIER_STONE) return 132;
  if (item_tool_tier(p_item) == TIER_IRON ) return 251;
  return 0;
}

Integer item_attack_damage(Integer p_item)
// ----------------------------------------------------------------
// Damage done to a cow when hitting it while holding item
// ----------------------------------------------------------------
{
  Integer l_kind = item_tool_kind(p_item);
  Integer l_tier = item_tool_tier(p_item);

  if (l_kind == TOOL_SWORD) return 2 + l_tier;
  if (l_kind == TOOL_AXE  ) return 1 + l_tier;
  if (l_kind != TOOL_NONE ) return 2;
  return 1;
}

Integer item_food_value(Integer p_item)
// ----------------------------------------------------------------
// Health restored by eating an item, 0 if it is not food
// ----------------------------------------------------------------
{
  if (p_item == ITEM_RAW_BEEF       ) return 2;
  if (p_item == ITEM_COOKED_BEEF    ) return 7;
  if (p_item == ITEM_RAW_PORKCHOP   ) return 2;
  if (p_item == ITEM_COOKED_PORKCHOP) return 7;
  if (p_item == ITEM_ROTTEN_FLESH   ) return 1;
  return 0;
}

Integer item_fuel_seconds(Integer p_item)
// ----------------------------------------------------------------
// Seconds an item burns for in a furnace, 0 if it is not fuel
// One item takes COOK_SECONDS to cook
// ----------------------------------------------------------------
{
  if (p_item == ITEM_COAL          ) return 40;
  if (p_item == ITEM_OAK_LOG       ) return 20;
  if (p_item == ITEM_PLANKS        ) return 10;
  if (p_item == ITEM_CRAFTING_TABLE) return 15;
  if (p_item == ITEM_STICK         ) return 5;
  if (item_tool_tier(p_item) == TIER_WOOD) return 10;
  return 0;
}

Integer item_smelt_result(Integer p_item)
// ----------------------------------------------------------------
// What a furnace turns an item into, ITEM_NONE if it cannot
// ----------------------------------------------------------------
{
  if (p_item == ITEM_RAW_BEEF    ) return ITEM_COOKED_BEEF;
  if (p_item == ITEM_RAW_PORKCHOP) return ITEM_COOKED_PORKCHOP;
  if (p_item == ITEM_COBBLESTONE ) return ITEM_STONE;
  if (p_item == ITEM_SAND        ) return ITEM_GLASS;
  if (p_item == ITEM_IRON_ORE    ) return ITEM_IRON_INGOT;
  if (p_item == ITEM_OAK_LOG     ) return ITEM_COAL;
  return ITEM_NONE;
}

Integer item_top_texture(Integer p_item)
// ----------------------------------------------------------------
// Texture for the top of a block item's cube
// ----------------------------------------------------------------
{
  if (p_item == ITEM_FURNACE) return TEX_FURNACE_TOP;
  return block_face_texture(item_places_block(p_item), DIR_PY);
}

Integer item_side_texture(Integer p_item)
// ----------------------------------------------------------------
// Texture for the sides of a block item's cube
// ----------------------------------------------------------------
{
  if (p_item == ITEM_FURNACE) return TEX_FURNACE_FRONT;
  return block_face_texture(item_places_block(p_item), DIR_PZ);
}

Integer item_sprite_texture(Integer p_item)
// ----------------------------------------------------------------
// Flat 16 x 16 picture of an item that is not a block (drawn as a
// sprite in slots, in the hand and when dropped), 0 for blocks
// ----------------------------------------------------------------
{
  if (p_item == ITEM_STICK          ) return TEX_ITEM_STICK;
  if (p_item == ITEM_RAW_BEEF       ) return TEX_ITEM_RAW_BEEF;
  if (p_item == ITEM_COOKED_BEEF    ) return TEX_ITEM_COOKED_BEEF;
  if (p_item == ITEM_RAW_PORKCHOP   ) return TEX_ITEM_RAW_PORKCHOP;
  if (p_item == ITEM_COOKED_PORKCHOP) return TEX_ITEM_COOKED_PORKCHOP;
  if (p_item == ITEM_COAL           ) return TEX_ITEM_COAL;
  if (p_item == ITEM_IRON_INGOT     ) return TEX_ITEM_IRON_INGOT;
  if (p_item == ITEM_IRON_PICKAXE   ) return TEX_ITEM_IRON_PICKAXE;
  if (p_item == ITEM_IRON_AXE       ) return TEX_ITEM_IRON_AXE;
  if (p_item == ITEM_IRON_SHOVEL    ) return TEX_ITEM_IRON_SHOVEL;
  if (p_item == ITEM_IRON_SWORD     ) return TEX_ITEM_IRON_SWORD;
  if (p_item == ITEM_WOODEN_PICKAXE ) return TEX_ITEM_WOODEN_PICKAXE;
  if (p_item == ITEM_STONE_PICKAXE  ) return TEX_ITEM_STONE_PICKAXE;
  if (p_item == ITEM_WOODEN_AXE     ) return TEX_ITEM_WOODEN_AXE;
  if (p_item == ITEM_STONE_AXE      ) return TEX_ITEM_STONE_AXE;
  if (p_item == ITEM_WOODEN_SHOVEL  ) return TEX_ITEM_WOODEN_SHOVEL;
  if (p_item == ITEM_STONE_SHOVEL   ) return TEX_ITEM_STONE_SHOVEL;
  if (p_item == ITEM_WOODEN_SWORD   ) return TEX_ITEM_WOODEN_SWORD;
  if (p_item == ITEM_STONE_SWORD    ) return TEX_ITEM_STONE_SWORD;
  if (p_item == ITEM_ROTTEN_FLESH   ) return TEX_ITEM_ROTTEN_FLESH;
  return block_plant_texture(p_item);
}

#endif
