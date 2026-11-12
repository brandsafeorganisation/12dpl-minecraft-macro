#ifndef RESOURCE_PACK_4DM_INCLUDED
#define RESOURCE_PACK_4DM_INCLUDED

#include "../../include/core/safety.h"
#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/blocks/blocks.h"
#include "../../include/blocks/textures.h"
#include "../../include/blocks/resource_pack.h"

// ---------------------------------------------------------------- constant tables

void pack_init_tables()
// ----------------------------------------------------------------
// Fill the constant tables: powers of two, the bits of every byte
// and the deflate length and distance tables (RFC 1951 3.2.5)
// ----------------------------------------------------------------
{
  Integer l_n     = 0;
  Integer l_byte  = 0;
  Integer l_bit   = 0;
  Integer l_value = 0;

  if (g_pack_tables_ready) return;

  g_pow2[1] = 1;
  for (l_n = 2; l_n <= 31; ++l_n) g_pow2[l_n] = g_pow2[l_n - 1] * 2;

  for (l_byte = 0; l_byte <= 255; ++l_byte) {
    l_value = l_byte;
    for (l_bit = 0; l_bit <= 7; ++l_bit) {
      g_byte_bit[l_byte * 8 + l_bit + 1] = l_value - floor_divide(l_value, 2) * 2;
      l_value = floor_divide(l_value, 2);
    }
  }

  // Lengths 3..258 for symbols 257..285
  for (l_n = 1; l_n <= 8; ++l_n) {
    g_length_base [l_n] = l_n + 2;
    g_length_extra[l_n] = 0;
  }
  for (l_n = 9; l_n <= 28; ++l_n) {
    g_length_extra[l_n] = floor_divide(l_n - 5, 4);
    g_length_base [l_n] = g_length_base[l_n - 1] + g_pow2[g_length_extra[l_n - 1] + 1];
  }
  g_length_base [29] = 258;
  g_length_extra[29] = 0;

  // Distances 1..32768 for symbols 0..29
  for (l_n = 1; l_n <= 4; ++l_n) {
    g_distance_base [l_n] = l_n;
    g_distance_extra[l_n] = 0;
  }
  for (l_n = 5; l_n <= 30; ++l_n) {
    g_distance_extra[l_n] = floor_divide(l_n - 3, 2);
    g_distance_base [l_n] = g_distance_base[l_n - 1] + g_pow2[g_distance_extra[l_n - 1] + 1];
  }

  // Order in which code length code lengths are sent
  g_code_order[1]  = 16; g_code_order[2]  = 17; g_code_order[3]  = 18; g_code_order[4]  = 0;
  g_code_order[5]  = 8;  g_code_order[6]  = 7;  g_code_order[7]  = 9;  g_code_order[8]  = 6;
  g_code_order[9]  = 10; g_code_order[10] = 5;  g_code_order[11] = 11; g_code_order[12] = 4;
  g_code_order[13] = 12; g_code_order[14] = 3;  g_code_order[15] = 13; g_code_order[16] = 2;
  g_code_order[17] = 14; g_code_order[18] = 1;  g_code_order[19] = 15;

  g_pack_tables_ready = TRUE;
}

// ---------------------------------------------------------------- honest helpers

Integer pack_word_byte(Integer p_word, Integer p_byte)
// ----------------------------------------------------------------
// Byte number p_byte (1 = lowest) of a 4 byte little-endian word
// read with File_read, which comes back as a signed Integer
// ----------------------------------------------------------------
{
  Integer l_value = p_word;
  Integer l_high  = 0;
  Integer l_n     = 0;

  if (l_value < 0) {
    l_value = l_value + 2147483647 + 1;   // drop the sign bit ...
    l_high  = 128;                        // ... which is bit 7 of byte 4
  }
  for (l_n = 1; l_n < p_byte; ++l_n) l_value = floor_divide(l_value, 256);
  if (p_byte == 4) return l_value + l_high;
  return l_value - floor_divide(l_value, 256) * 256;
}

Integer pack_paeth(Integer p_left, Integer p_up, Integer p_up_left)
// ----------------------------------------------------------------
// The PNG Paeth predictor
// ----------------------------------------------------------------
{
  Integer l_estimate = p_left + p_up - p_up_left;
  Integer l_left     = Absolute(l_estimate - p_left);
  Integer l_up       = Absolute(l_estimate - p_up);
  Integer l_up_left  = Absolute(l_estimate - p_up_left);

  if (l_left <= l_up && l_left <= l_up_left) return p_left;
  if (l_up <= l_up_left)                     return p_up;
  return p_up_left;
}

Integer pack_is_zip(Text p_path)
// ----------------------------------------------------------------
// TRUE if the path names a .zip file rather than a folder
// ----------------------------------------------------------------
{
  Text    l_extension = PACK_ZIP_EXTENSION;
  Integer l_length    = Text_length(p_path);

  if (l_length <= 4) return FALSE;
  if (Text_lower(Get_subtext(p_path, l_length - 3, l_length)) == l_extension) return TRUE;
  return FALSE;
}

Text pack_key(Text p_kind, Text p_name)
// ----------------------------------------------------------------
// Name used for an image in the pack's records: "block_stone",
// "entity_cow_cow" (no "/", which Attributes might read as a path)
// ----------------------------------------------------------------
{
  return pack_replace(p_kind + "_" + p_name, "/", "_");
}

Text pack_replace(Text p_text, Text p_find, Text p_with)
// ----------------------------------------------------------------
// p_text with every p_find (one character) replaced by p_with
// ----------------------------------------------------------------
{
  Text    l_out  = "";
  Text    l_char = "";
  Integer l_at   = 0;

  for (l_at = 1; l_at <= Text_length(p_text); ++l_at) {
    l_char = Get_subtext(p_text, l_at, l_at);
    if (l_char == p_find) l_char = p_with;
    l_out = l_out + l_char;
  }
  return l_out;
}

Integer pack_part(Integer &p_tex, Text &p_name, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h, Integer &p_turn,
                  Integer p_set_tex, Text p_set_name, Integer p_set_x, Integer p_set_y, Integer p_set_w, Integer p_set_h, Integer p_set_turn)
// ----------------------------------------------------------------
// Fill in one entry of the mob part map (helper for pack_map_part)
// ----------------------------------------------------------------
{
  p_tex  = p_set_tex;
  p_name = p_set_name;
  p_x    = p_set_x;
  p_y    = p_set_y;
  p_w    = p_set_w;
  p_h    = p_set_h;
  p_turn = p_set_turn;
  return TRUE;
}

Integer pack_map_part(Integer p_entry, Integer &p_tex, Text &p_name, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h,
                      Integer &p_turn)
// ----------------------------------------------------------------
// Entry number p_entry of the map from our mob part textures to
// rectangles of the pack's mob skins (images under entity/). The
// rectangles follow the classic skin layout: a box of the model
// with its corner of the skin at (u, v) and size w x h x d keeps
// its top at (u + d, v), its sides at (u, v + d) and
// (u + d + w, v + d) and its front at (u + d, v + d). The cow's
// body lies on its side in the model, so its pictures are turned.
// Returns FALSE after the last entry.
// ----------------------------------------------------------------
{
  //                                                                                    x   y   w   h   turn
  if (p_entry == 1 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_COW_FACE         , "cow/cow"      , 6 , 6 , 8 , 8 , PACK_TURN_NONE );
  if (p_entry == 2 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_COW_HEAD_SIDE    , "cow/cow"      , 0 , 6 , 6 , 8 , PACK_TURN_NONE );
  if (p_entry == 3 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_COW_HEAD_TOP     , "cow/cow"      , 6 , 0 , 8 , 6 , PACK_TURN_NONE );
  if (p_entry == 4 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_COW_HIDE         , "cow/cow"      , 18, 14, 10, 18, PACK_TURN_RIGHT);
  if (p_entry == 5 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_COW_BODY_TOP     , "cow/cow"      , 50, 14, 12, 18, PACK_TURN_RIGHT);
  if (p_entry == 6 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_COW_BODY_END     , "cow/cow"      , 28, 4 , 12, 10, PACK_TURN_NONE );
  if (p_entry == 7 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_COW_LEG          , "cow/cow"      , 4 , 20, 4 , 12, PACK_TURN_NONE );
  if (p_entry == 8 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_COW_HORN         , "cow/cow"      , 22, 1 , 1 , 3 , PACK_TURN_NONE );
  if (p_entry == 9 ) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_ZOMBIE_FACE      , "zombie/zombie", 8 , 8 , 8 , 8 , PACK_TURN_NONE );
  if (p_entry == 10) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_ZOMBIE_HEAD_SIDE , "zombie/zombie", 0 , 8 , 8 , 8 , PACK_TURN_NONE );
  if (p_entry == 11) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_ZOMBIE_HEAD_TOP  , "zombie/zombie", 8 , 0 , 8 , 8 , PACK_TURN_NONE );
  if (p_entry == 12) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_ZOMBIE_SHIRT     , "zombie/zombie", 20, 20, 8 , 12, PACK_TURN_NONE );
  if (p_entry == 13) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_ZOMBIE_SHIRT_SIDE, "zombie/zombie", 16, 20, 4 , 12, PACK_TURN_NONE );
  if (p_entry == 14) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_ZOMBIE_PANTS     , "zombie/zombie", 4 , 20, 4 , 12, PACK_TURN_NONE );
  if (p_entry == 15) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_ZOMBIE_ARM       , "zombie/zombie", 40, 20, 4 , 12, PACK_TURN_LEFT );
  if (p_entry == 16) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_ZOMBIE_SKIN      , "zombie/zombie", 48, 16, 4 , 4 , PACK_TURN_NONE );
  if (p_entry == 17) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_PIG_FACE         , "pig/pig"      , 8 , 8 , 8 , 8 , PACK_TURN_NONE );
  if (p_entry == 18) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_PIG_HEAD_SIDE    , "pig/pig"      , 0 , 8 , 8 , 8 , PACK_TURN_NONE );
  if (p_entry == 19) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_PIG_BODY_SIDE    , "pig/pig"      , 28, 16, 8 , 16, PACK_TURN_RIGHT);
  if (p_entry == 20) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_PIG_BODY_TOP     , "pig/pig"      , 54, 16, 10, 16, PACK_TURN_RIGHT);
  if (p_entry == 21) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_PIG_BODY_END     , "pig/pig"      , 46, 8 , 10, 8 , PACK_TURN_NONE );
  if (p_entry == 22) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_PIG_LEG          , "pig/pig"      , 4 , 20, 4 , 6 , PACK_TURN_NONE );
  if (p_entry == 23) return pack_part(p_tex, p_name, p_x, p_y, p_w, p_h, p_turn, TEX_PIG_SNOUT        , "pig/pig"      , 17, 17, 4 , 3 , PACK_TURN_NONE );
  return FALSE;
}

Integer pack_entry(Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_tint, Text &p_overlay,
                   Integer p_set_tex, Text p_set_kind, Text p_set_name, Integer p_set_tint, Text p_set_overlay)
// ----------------------------------------------------------------
// Fill in one entry of the texture map (helper for pack_map_entry)
// ----------------------------------------------------------------
{
  p_tex     = p_set_tex;
  p_kind    = p_set_kind;
  p_name    = p_set_name;
  p_tint    = p_set_tint;
  p_overlay = p_set_overlay;
  return TRUE;
}

Integer pack_map_entry(Integer p_entry, Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_tint, Text &p_overlay)
// ----------------------------------------------------------------
// Entry number p_entry of the map from our textures to pack images:
// the texture, the image's folder (block or item) and name, the
// tint for grey images, and an image drawn over it (grass sides).
// Returns FALSE after the last entry. Mob textures come from parts
// of the mob skins instead (pack_map_part).
// ----------------------------------------------------------------
{
  if (p_entry == 1 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_BEDROCK          , "block", "bedrock"             , PACK_TINT_NONE   , "");
  if (p_entry == 2 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_STONE            , "block", "stone"               , PACK_TINT_NONE   , "");
  if (p_entry == 3 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_COBBLESTONE      , "block", "cobblestone"         , PACK_TINT_NONE   , "");
  if (p_entry == 4 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DIRT             , "block", "dirt"                , PACK_TINT_NONE   , "");
  if (p_entry == 5 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_GRASS_TOP        , "block", "grass_block_top"     , PACK_TINT_GRASS  , "");
  if (p_entry == 6 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_GRASS_SIDE       , "block", "grass_block_side"    , PACK_TINT_NONE   , "grass_block_side_overlay");
  if (p_entry == 7 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_LOG_SIDE         , "block", "oak_log"             , PACK_TINT_NONE   , "");
  if (p_entry == 8 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_LOG_TOP          , "block", "oak_log_top"         , PACK_TINT_NONE   , "");
  if (p_entry == 9 ) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_LEAVES           , "block", "oak_leaves"          , PACK_TINT_FOLIAGE, "");
  if (p_entry == 10) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_WATER            , "block", "water_still"         , PACK_TINT_WATER  , "");
  if (p_entry == 11) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_PLANKS           , "block", "oak_planks"          , PACK_TINT_NONE   , "");
  if (p_entry == 12) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_TABLE_TOP        , "block", "crafting_table_top"  , PACK_TINT_NONE   , "");
  if (p_entry == 13) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_TABLE_SIDE       , "block", "crafting_table_front", PACK_TINT_NONE   , "");
  if (p_entry == 14) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_FURNACE_FRONT    , "block", "furnace_front"       , PACK_TINT_NONE   , "");
  if (p_entry == 15) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_FURNACE_FRONT_LIT, "block", "furnace_front_on"    , PACK_TINT_NONE   , "");
  if (p_entry == 16) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_FURNACE_SIDE     , "block", "furnace_side"        , PACK_TINT_NONE   , "");
  if (p_entry == 17) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_FURNACE_TOP      , "block", "furnace_top"         , PACK_TINT_NONE   , "");
  if (p_entry == 18) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_SAND             , "block", "sand"                , PACK_TINT_NONE   , "");
  if (p_entry == 19) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_SANDSTONE_TOP    , "block", "sandstone_top"       , PACK_TINT_NONE   , "");
  if (p_entry == 20) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_SANDSTONE_SIDE   , "block", "sandstone"           , PACK_TINT_NONE   , "");
  if (p_entry == 21) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_CACTUS_TOP       , "block", "cactus_top"          , PACK_TINT_NONE   , "");
  if (p_entry == 22) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_CACTUS_SIDE      , "block", "cactus_side"         , PACK_TINT_NONE   , "");
  if (p_entry == 23) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_COAL_ORE         , "block", "coal_ore"            , PACK_TINT_NONE   , "");
  if (p_entry == 24) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_IRON_ORE         , "block", "iron_ore"            , PACK_TINT_NONE   , "");
  if (p_entry == 25) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_GRAVEL           , "block", "gravel"              , PACK_TINT_NONE   , "");
  if (p_entry == 26) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_PLANT_GRASS      , "block", "short_grass"         , PACK_TINT_GRASS  , "");
  if (p_entry == 27) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_PLANT_POPPY      , "block", "poppy"               , PACK_TINT_NONE   , "");
  if (p_entry == 28) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_PLANT_DANDELION  , "block", "dandelion"           , PACK_TINT_NONE   , "");
  if (p_entry == 29) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_PLANT_DEAD_BUSH  , "block", "dead_bush"           , PACK_TINT_NONE   , "");
  if (p_entry == 30) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_STICK       , "item" , "stick"               , PACK_TINT_NONE   , "");
  if (p_entry == 31) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_RAW_BEEF    , "item" , "beef"                , PACK_TINT_NONE   , "");
  if (p_entry == 32) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_COOKED_BEEF , "item" , "cooked_beef"         , PACK_TINT_NONE   , "");
  if (p_entry == 33) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_COAL        , "item" , "coal"                , PACK_TINT_NONE   , "");
  if (p_entry == 34) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_IRON_INGOT  , "item" , "iron_ingot"          , PACK_TINT_NONE   , "");
  if (p_entry == 35) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_WOODEN_PICKAXE, "item", "wooden_pickaxe"     , PACK_TINT_NONE   , "");
  if (p_entry == 36) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_STONE_PICKAXE , "item", "stone_pickaxe"      , PACK_TINT_NONE   , "");
  if (p_entry == 37) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_IRON_PICKAXE  , "item", "iron_pickaxe"       , PACK_TINT_NONE   , "");
  if (p_entry == 38) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_WOODEN_AXE    , "item", "wooden_axe"         , PACK_TINT_NONE   , "");
  if (p_entry == 39) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_STONE_AXE     , "item", "stone_axe"          , PACK_TINT_NONE   , "");
  if (p_entry == 40) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_IRON_AXE      , "item", "iron_axe"           , PACK_TINT_NONE   , "");
  if (p_entry == 41) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_WOODEN_SHOVEL , "item", "wooden_shovel"      , PACK_TINT_NONE   , "");
  if (p_entry == 42) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_STONE_SHOVEL  , "item", "stone_shovel"       , PACK_TINT_NONE   , "");
  if (p_entry == 43) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_IRON_SHOVEL   , "item", "iron_shovel"        , PACK_TINT_NONE   , "");
  if (p_entry == 44) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_WOODEN_SWORD  , "item", "wooden_sword"       , PACK_TINT_NONE   , "");
  if (p_entry == 45) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_STONE_SWORD   , "item", "stone_sword"        , PACK_TINT_NONE   , "");
  if (p_entry == 46) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_IRON_SWORD    , "item", "iron_sword"         , PACK_TINT_NONE   , "");
  if (p_entry == 47) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_TORCH              , "block", "torch"              , PACK_TINT_NONE   , "");
  if (p_entry == 48) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_GLASS              , "block", "glass"              , PACK_TINT_NONE   , "");
  if (p_entry == 49) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_ROTTEN_FLESH  , "item", "rotten_flesh"       , PACK_TINT_NONE   , "");
  if (p_entry == 50) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_RAW_PORKCHOP  , "item", "porkchop"           , PACK_TINT_NONE   , "");
  if (p_entry == 51) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_COOKED_PORKCHOP, "item", "cooked_porkchop"   , PACK_TINT_NONE   , "");
  if (p_entry == 52) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 0  , "block", "destroy_stage_0"   , PACK_TINT_NONE   , "");
  if (p_entry == 53) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 1  , "block", "destroy_stage_1"   , PACK_TINT_NONE   , "");
  if (p_entry == 54) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 2  , "block", "destroy_stage_2"   , PACK_TINT_NONE   , "");
  if (p_entry == 55) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 3  , "block", "destroy_stage_3"   , PACK_TINT_NONE   , "");
  if (p_entry == 56) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 4  , "block", "destroy_stage_4"   , PACK_TINT_NONE   , "");
  if (p_entry == 57) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 5  , "block", "destroy_stage_5"   , PACK_TINT_NONE   , "");
  if (p_entry == 58) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 6  , "block", "destroy_stage_6"   , PACK_TINT_NONE   , "");
  if (p_entry == 59) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 7  , "block", "destroy_stage_7"   , PACK_TINT_NONE   , "");
  if (p_entry == 60) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 8  , "block", "destroy_stage_8"   , PACK_TINT_NONE   , "");
  if (p_entry == 61) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DESTROY_FIRST + 9  , "block", "destroy_stage_9"   , PACK_TINT_NONE   , "");
  if (p_entry == 62) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_HEART_FULL         , "gui"  , "sprites/hud/heart/full"     , PACK_TINT_NONE, "");
  if (p_entry == 63) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_HEART_HALF         , "gui"  , "sprites/hud/heart/half"     , PACK_TINT_NONE, "");
  if (p_entry == 64) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_HEART_CONTAINER    , "gui"  , "sprites/hud/heart/container", PACK_TINT_NONE, "");
  if (p_entry == 65) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DOOR_TOP           , "block", "oak_door_top"       , PACK_TINT_NONE   , "");
  if (p_entry == 66) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_DOOR_BOTTOM        , "block", "oak_door_bottom"    , PACK_TINT_NONE   , "");
  if (p_entry == 67) return pack_entry(p_tex, p_kind, p_name, p_tint, p_overlay, TEX_ITEM_DOOR          , "item" , "oak_door"           , PACK_TINT_NONE   , "");
  return FALSE;
}

// ---------------------------------------------------------------- reading bytes

void pack_store_byte(Integer p_buffer, Integer p_position, Integer p_value)
// ----------------------------------------------------------------
// Put one byte into a buffer, ignoring positions past its end
// ----------------------------------------------------------------
{
  if (p_position < 1) return;
  if (p_buffer == PACK_BUFFER_IN) {
    if (p_position <= PACK_IN_SIZE) g_pack_in[p_position] = p_value;
  } else {
    if (p_position <= PACK_FILE_SIZE) g_pack_file[p_position] = p_value;
  }
}

Integer pack_read_bytes(File &p_file, Integer p_count, Integer p_buffer)
// ----------------------------------------------------------------
// Read p_count bytes (or up to the end of the file if p_count is 0)
// from the file's current position into a buffer, starting at 1.
// Reads 4 bytes at a time; the last 1-3 bytes of a file whose size
// isn't a multiple of 4 are read as a 2 byte word and padding.
// Returns the number of bytes stored.
// ----------------------------------------------------------------
{
  Integer l_word   = 0;
  Integer l_stored = 0;
  Integer l_byte   = 0;
  Integer l_limit  = p_count;
  Integer l_room   = PACK_IN_SIZE;

  if (p_buffer == PACK_BUFFER_FILE) l_room = PACK_FILE_SIZE;
  if (l_limit < 1 || l_limit > l_room) l_limit = l_room;

  while (l_stored < l_limit) {
    if (File_read(p_file, l_word) != 0) {
      // fewer than 4 bytes left: try a 2 byte word
      if (File_read_short(p_file, l_word) == 0) {
        if (l_word < 0) l_word = l_word + 65536;
        pack_store_byte(p_buffer, l_stored + 1, pack_word_byte(l_word, 1));
        pack_store_byte(p_buffer, l_stored + 2, pack_word_byte(l_word, 2));
        l_stored = l_stored + 2;
      }
      break;
    }
    for (l_byte = 1; l_byte <= 4; ++l_byte) {
      if (l_stored < l_limit) {
        ++l_stored;
        pack_store_byte(p_buffer, l_stored, pack_word_byte(l_word, l_byte));
      }
    }
  }
  if (p_buffer == PACK_BUFFER_IN) {
    g_pack_in_count = l_stored;
  } else {
    g_pack_file_count = l_stored;
  }
  return l_stored;
}

Integer pack_read_short_at(File &p_file)
// ----------------------------------------------------------------
// Unsigned 2 byte little-endian number at the file position
// ----------------------------------------------------------------
{
  Integer l_value = 0;

  if (File_read_short(p_file, l_value) != 0) return 0;
  if (l_value < 0) l_value = l_value + 65536;
  return l_value;
}

Integer pack_read_word_at(File &p_file)
// ----------------------------------------------------------------
// 4 byte little-endian number at the file position (offsets and
// sizes in a zip are well below 2^31, so the sign doesn't matter)
// ----------------------------------------------------------------
{
  Integer l_value = 0;

  if (File_read(p_file, l_value) != 0) return 0;
  return l_value;
}

Integer pack_file_size(File &p_file)
// ----------------------------------------------------------------
// Size of an open file in bytes, found by a binary search for the
// last position a 2 byte read still works from (12dPL has no call
// that returns a file's size)
// ----------------------------------------------------------------
{
  Integer l_low   = 0;           // a read works from here
  Integer l_high  = 1073741824;  // and fails from here
  Integer l_mid   = 0;
  Integer l_value = 0;

  File_seek(p_file, 0);
  if (File_read_short(p_file, l_value) != 0) return 0;

  while (l_high - l_low > 1) {
    l_mid = l_low + floor_divide(l_high - l_low, 2);
    File_seek(p_file, l_mid);
    if (File_read_short(p_file, l_value) == 0) {
      l_low = l_mid;
    } else {
      l_high = l_mid;
    }
  }
  return l_low + 2;
}

// ---------------------------------------------------------------- inflate (RFC 1951)

Integer inflate_bit()
// ----------------------------------------------------------------
// Next bit of the compressed input (bits are used lowest first)
// ----------------------------------------------------------------
{
  Integer l_bit = 0;

  if (g_inflate_pos > g_inflate_end) {
    g_inflate_failed = TRUE;
    return 0;
  }
  l_bit = g_byte_bit[g_pack_in[g_inflate_pos] * 8 + g_inflate_bit + 1];
  ++g_inflate_bit;
  if (g_inflate_bit == 8) {
    g_inflate_bit = 0;
    ++g_inflate_pos;
  }
  return l_bit;
}

Integer inflate_bits(Integer p_count)
// ----------------------------------------------------------------
// The next p_count bits as a number (first bit lowest)
// ----------------------------------------------------------------
{
  Integer l_value = 0;
  Integer l_n     = 0;

  for (l_n = 1; l_n <= p_count; ++l_n) {
    if (inflate_bit()) l_value = l_value + g_pow2[l_n];
  }
  return l_value;
}

void inflate_put(Integer p_byte)
// ----------------------------------------------------------------
// Append one byte to the output
// ----------------------------------------------------------------
{
  if (g_inflate_out >= g_inflate_limit) return;
  ++g_inflate_out;
  g_pack_out[g_inflate_out] = p_byte;
}

Integer inflate_build(Integer p_table, Integer p_first, Integer p_count)
// ----------------------------------------------------------------
// Build Huffman table 1 or 2 from the code lengths in
// g_inflate_lengths[p_first .. p_first + p_count - 1]. Returns 0 for
// a complete code, > 0 for an incomplete one, < 0 if it is invalid.
// (A canonical code, built as in zlib's "puff".)
// ----------------------------------------------------------------
{
  Integer l_count_at  = (p_table - 1) * 16;
  Integer l_symbol_at = (p_table - 1) * PACK_HUFFMAN_SYMBOLS;
  Integer l_length    = 0;
  Integer l_symbol    = 0;
  Integer l_left      = 1;
  Integer l_bits      = 0;

  for (l_bits = 0; l_bits <= 15; ++l_bits) g_huffman_count[l_count_at + l_bits + 1] = 0;
  for (l_symbol = 0; l_symbol < p_count; ++l_symbol) {
    l_length = g_inflate_lengths[p_first + l_symbol];
    g_huffman_count[l_count_at + l_length + 1] = g_huffman_count[l_count_at + l_length + 1] + 1;
  }
  if (g_huffman_count[l_count_at + 1] == p_count) return 0;

  for (l_bits = 1; l_bits <= 15; ++l_bits) {
    l_left = l_left * 2 - g_huffman_count[l_count_at + l_bits + 1];
    if (l_left < 0) return l_left;
  }

  g_inflate_offsets[2] = 0;
  for (l_bits = 1; l_bits <= 14; ++l_bits) {
    g_inflate_offsets[l_bits + 2] = g_inflate_offsets[l_bits + 1] + g_huffman_count[l_count_at + l_bits + 1];
  }
  for (l_symbol = 0; l_symbol < p_count; ++l_symbol) {
    l_length = g_inflate_lengths[p_first + l_symbol];
    if (l_length != 0) {
      g_huffman_symbol[l_symbol_at + g_inflate_offsets[l_length + 1] + 1] = l_symbol;
      g_inflate_offsets[l_length + 1] = g_inflate_offsets[l_length + 1] + 1;
    }
  }
  return l_left;
}

Integer inflate_decode(Integer p_table)
// ----------------------------------------------------------------
// Read one symbol with Huffman table 1 or 2; -1 if the code is bad
// ----------------------------------------------------------------
{
  Integer l_count_at  = (p_table - 1) * 16;
  Integer l_symbol_at = (p_table - 1) * PACK_HUFFMAN_SYMBOLS;
  Integer l_code      = 0;
  Integer l_first     = 0;
  Integer l_index     = 0;
  Integer l_count     = 0;
  Integer l_length    = 0;

  for (l_length = 1; l_length <= 15; ++l_length) {
    l_code  = l_code + inflate_bit();
    l_count = g_huffman_count[l_count_at + l_length + 1];
    if (l_code - l_count < l_first) {
      return g_huffman_symbol[l_symbol_at + l_index + (l_code - l_first) + 1];
    }
    l_index = l_index + l_count;
    l_first = (l_first + l_count) * 2;
    l_code  = l_code * 2;
    if (g_inflate_failed) return -1;
  }
  return -1;
}

Integer inflate_codes()
// ----------------------------------------------------------------
// Decode one block's literals and length/distance pairs with the
// current tables (1 = literal/length, 2 = distance)
// ----------------------------------------------------------------
{
  Integer l_symbol   = 0;
  Integer l_length   = 0;
  Integer l_distance = 0;
  Integer l_from     = 0;

  while (TRUE) {
    l_symbol = inflate_decode(1);
    if (l_symbol < 0) return FAILURE;
    if (l_symbol == 256) return SUCCESS;
    if (g_inflate_out >= g_inflate_limit) return SUCCESS;   // have all we need

    if (l_symbol < 256) {
      inflate_put(l_symbol);
    } else {
      l_symbol = l_symbol - 257;
      if (l_symbol >= 29) return FAILURE;
      l_length = g_length_base[l_symbol + 1] + inflate_bits(g_length_extra[l_symbol + 1]);

      l_symbol = inflate_decode(2);
      if (l_symbol < 0 || l_symbol >= 30) return FAILURE;
      l_distance = g_distance_base[l_symbol + 1] + inflate_bits(g_distance_extra[l_symbol + 1]);
      if (l_distance > g_inflate_out) return FAILURE;

      l_from = g_inflate_out - l_distance;
      while (l_length > 0) {
        ++l_from;
        inflate_put(g_pack_out[l_from]);
        --l_length;
      }
    }
    if (g_inflate_failed) return FAILURE;
  }
  return SUCCESS;
}

Integer inflate_stored()
// ----------------------------------------------------------------
// Copy an uncompressed block
// ----------------------------------------------------------------
{
  Integer l_length = 0;

  if (g_inflate_bit != 0) {
    g_inflate_bit = 0;
    ++g_inflate_pos;
  }
  if (g_inflate_pos + 3 > g_inflate_end) return FAILURE;
  l_length = g_pack_in[g_inflate_pos] + 256 * g_pack_in[g_inflate_pos + 1];
  g_inflate_pos = g_inflate_pos + 4;   // length and its complement
  if (g_inflate_pos + l_length - 1 > g_inflate_end) return FAILURE;

  while (l_length > 0) {
    inflate_put(g_pack_in[g_inflate_pos]);
    ++g_inflate_pos;
    --l_length;
  }
  return SUCCESS;
}

Integer inflate_fixed()
// ----------------------------------------------------------------
// A block compressed with the fixed Huffman codes
// ----------------------------------------------------------------
{
  Integer l_symbol = 0;

  for (l_symbol = 1; l_symbol <= 288; ++l_symbol) {
    g_inflate_lengths[l_symbol] = 8;
    if (l_symbol > 144) g_inflate_lengths[l_symbol] = 9;
    if (l_symbol > 256) g_inflate_lengths[l_symbol] = 7;
    if (l_symbol > 280) g_inflate_lengths[l_symbol] = 8;
  }
  inflate_build(1, 1, 288);
  for (l_symbol = 1; l_symbol <= 30; ++l_symbol) g_inflate_lengths[l_symbol] = 5;
  inflate_build(2, 1, 30);
  return inflate_codes();
}

Integer inflate_dynamic()
// ----------------------------------------------------------------
// A block that sends its own Huffman codes first
// ----------------------------------------------------------------
{
  Integer l_lengths   = inflate_bits(5) + 257;
  Integer l_distances = inflate_bits(5) + 1;
  Integer l_codes     = inflate_bits(4) + 4;
  Integer l_index     = 0;
  Integer l_symbol    = 0;
  Integer l_repeat    = 0;
  Integer l_value     = 0;
  Integer l_result    = 0;

  if (l_lengths > 286 || l_distances > 30) return FAILURE;

  for (l_index = 1; l_index <= 19; ++l_index) g_inflate_lengths[l_index] = 0;
  for (l_index = 1; l_index <= l_codes; ++l_index) {
    g_inflate_lengths[g_code_order[l_index] + 1] = inflate_bits(3);
  }
  if (inflate_build(1, 1, 19) != 0) return FAILURE;

  l_index = 0;
  while (l_index < l_lengths + l_distances) {
    l_symbol = inflate_decode(1);
    if (l_symbol < 0) return FAILURE;
    if (l_symbol < 16) {
      ++l_index;
      g_inflate_lengths[l_index] = l_symbol;
    } else {
      l_value = 0;
      if (l_symbol == 16) {
        if (l_index == 0) return FAILURE;
        l_value  = g_inflate_lengths[l_index];
        l_repeat = 3 + inflate_bits(2);
      } else if (l_symbol == 17) {
        l_repeat = 3 + inflate_bits(3);
      } else {
        l_repeat = 11 + inflate_bits(7);
      }
      if (l_index + l_repeat > l_lengths + l_distances) return FAILURE;
      while (l_repeat > 0) {
        ++l_index;
        g_inflate_lengths[l_index] = l_value;
        --l_repeat;
      }
    }
    if (g_inflate_failed) return FAILURE;
  }
  if (g_inflate_lengths[257] == 0) return FAILURE;   // no end-of-block code

  l_result = inflate_build(1, 1, l_lengths);
  if (l_result < 0) return FAILURE;
  if (l_result > 0 && l_lengths != g_huffman_count[1] + g_huffman_count[2]) return FAILURE;

  l_result = inflate_build(2, l_lengths + 1, l_distances);
  if (l_result < 0) return FAILURE;
  if (l_result > 0 && l_distances != g_huffman_count[17] + g_huffman_count[18]) return FAILURE;

  return inflate_codes();
}

Integer pack_inflate(Integer p_first, Integer p_last, Integer p_limit)
// ----------------------------------------------------------------
// Decompress the deflate data in g_pack_in[p_first .. p_last] into
// g_pack_out, stopping after p_limit bytes (0 = as many as fit).
// Returns the number of bytes written, or FAILURE.
// ----------------------------------------------------------------
{
  Integer l_last   = FALSE;
  Integer l_type   = 0;
  Integer l_result = SUCCESS;

  pack_init_tables();
  g_inflate_pos    = p_first;
  g_inflate_bit    = 0;
  g_inflate_end    = p_last;
  g_inflate_out    = 0;
  g_inflate_failed = FALSE;
  g_inflate_limit  = PACK_OUT_SIZE;
  if (p_limit > 0 && p_limit < PACK_OUT_SIZE) g_inflate_limit = p_limit;

  while (!l_last) {
    l_last = inflate_bit();
    l_type = inflate_bits(2);
    if (l_type == 0) {
      l_result = inflate_stored();
    } else if (l_type == 1) {
      l_result = inflate_fixed();
    } else if (l_type == 2) {
      l_result = inflate_dynamic();
    } else {
      l_result = FAILURE;
    }
    if (l_result != SUCCESS || g_inflate_failed)  return FAILURE;
    if (g_inflate_out >= g_inflate_limit)          l_last = TRUE;
  }
  return g_inflate_out;
}

// ---------------------------------------------------------------- finding images

Integer pack_zip_index(Text p_path, Attributes &p_wanted, Attributes &p_index, Text &p_problem)
// ----------------------------------------------------------------
// Read a zip file's central directory and note where each wanted
// image is stored (offset of its local header, compressed size and
// method) in p_index under its key. Returns how many were found.
// ----------------------------------------------------------------
{
  File    l_file;
  Text    l_prefix      = PACK_TEXTURE_PREFIX;
  Text    l_name        = "";
  Text    l_rest        = "";
  Text    l_key         = "";
  Integer l_prefix_size = Text_length(l_prefix);
  Integer l_size        = 0;
  Integer l_position    = 0;
  Integer l_entries     = 0;
  Integer l_entry       = 0;
  Integer l_method      = 0;
  Integer l_packed      = 0;
  Integer l_name_size   = 0;
  Integer l_extra_size  = 0;
  Integer l_note_size   = 0;
  Integer l_offset      = 0;
  Integer l_slash       = 0;
  Integer l_found       = 0;
  Integer l_skip        = 0;

  record_clear(p_index, DATATYPE_PACK_INDEX);
  if (safe_file_open(p_path, "rb", l_file) != 0) {
    p_problem = "Couldn't open " + p_path;
    return 0;
  }

  // The end record is the last 22 bytes, unless the zip has a comment
  l_size     = pack_file_size(l_file);
  l_position = l_size - 22;
  while (l_position >= 0 && l_position >= l_size - 65557) {
    File_seek(l_file, l_position);
    if (pack_read_word_at(l_file) == ZIP_END_SIGNATURE) break;
    --l_position;
  }
  if (l_position < 0 || l_position < l_size - 65557) {
    File_close(l_file);
    p_problem = "That isn't a zip file.";
    return 0;
  }
  File_seek(l_file, l_position + 10);
  l_entries  = pack_read_short_at(l_file);
  l_skip     = pack_read_word_at(l_file);        // directory size
  l_position = pack_read_word_at(l_file);        // directory offset

  for (l_entry = 1; l_entry <= l_entries; ++l_entry) {
    File_seek(l_file, l_position);
    if (pack_read_word_at(l_file) != ZIP_ENTRY_SIGNATURE) break;
    File_seek(l_file, l_position + 10);
    l_method      = pack_read_short_at(l_file);
    File_seek(l_file, l_position + 20);
    l_packed      = pack_read_word_at(l_file);
    File_seek(l_file, l_position + 28);
    l_name_size   = pack_read_short_at(l_file);
    l_extra_size  = pack_read_short_at(l_file);
    l_note_size   = pack_read_short_at(l_file);
    File_seek(l_file, l_position + 42);
    l_offset      = pack_read_word_at(l_file);
    l_name        = "";
    File_read(l_file, l_name_size, l_name);

    // "assets/minecraft/textures/<kind>/<name>.png" -> "<kind>_<name>"
    if (l_name_size > l_prefix_size + 4) {
      if (Get_subtext(l_name, 1, l_prefix_size) == l_prefix) {
        l_rest  = Get_subtext(l_name, l_prefix_size + 1, l_name_size - 4);
        l_slash = Find_text(l_rest, "/");
        if (l_slash > 1) {
          l_key = pack_key(Get_subtext(l_rest, 1, l_slash - 1), Get_subtext(l_rest, l_slash + 1, Text_length(l_rest)));
          if (record_integer(p_wanted, l_key) == TRUE) {
            record_set_integer(p_index, l_key + ATTR_PACK_OFFSET, l_offset);
            record_set_integer(p_index, l_key + ATTR_PACK_SIZE,   l_packed);
            record_set_integer(p_index, l_key + ATTR_PACK_METHOD, l_method);
            ++l_found;
          }
        }
      }
    }
    l_position = l_position + 46 + l_name_size + l_extra_size + l_note_size;
  }
  File_close(l_file);
  if (l_found == 0) p_problem = "No block or item textures in that zip.";
  return l_found;
}

Integer pack_load_png_from_zip(Text p_path, Attributes &p_index, Text p_key)
// ----------------------------------------------------------------
// Put the PNG file stored under p_key in the zip into g_pack_file.
// Returns SUCCESS or FAILURE (missing, or a method we can't read).
// ----------------------------------------------------------------
{
  File    l_file;
  Integer l_offset  = record_integer(p_index, p_key + ATTR_PACK_OFFSET);
  Integer l_packed  = record_integer(p_index, p_key + ATTR_PACK_SIZE);
  Integer l_method  = record_integer(p_index, p_key + ATTR_PACK_METHOD);
  Integer l_name    = 0;
  Integer l_extra   = 0;
  Integer l_written = 0;
  Integer l_byte    = 0;

  if (l_packed < 1) return FAILURE;
  if (l_method != ZIP_STORED && l_method != ZIP_DEFLATED) return FAILURE;
  if (safe_file_open(p_path, "rb", l_file) != 0) return FAILURE;

  File_seek(l_file, l_offset);
  if (pack_read_word_at(l_file) != ZIP_LOCAL_SIGNATURE) {
    File_close(l_file);
    return FAILURE;
  }
  File_seek(l_file, l_offset + 26);
  l_name  = pack_read_short_at(l_file);
  l_extra = pack_read_short_at(l_file);
  File_seek(l_file, l_offset + 30 + l_name + l_extra);

  if (l_method == ZIP_STORED) {
    pack_read_bytes(l_file, l_packed, PACK_BUFFER_FILE);
    File_close(l_file);
    return SUCCESS;
  }

  if (l_packed > PACK_IN_SIZE) {
    File_close(l_file);
    return FAILURE;
  }
  pack_read_bytes(l_file, l_packed, PACK_BUFFER_IN);
  File_close(l_file);

  l_written = pack_inflate(1, g_pack_in_count, PACK_FILE_SIZE);
  if (l_written < 1) return FAILURE;
  for (l_byte = 1; l_byte <= l_written; ++l_byte) g_pack_file[l_byte] = g_pack_out[l_byte];
  g_pack_file_count = l_written;
  return SUCCESS;
}

Integer pack_load_png_from_folder(Text p_folder, Text p_kind, Text p_name)
// ----------------------------------------------------------------
// Put <folder>\assets\minecraft\textures\<kind>\<name>.png into
// g_pack_file. Returns SUCCESS or FAILURE.
// ----------------------------------------------------------------
{
  File l_file;
  Text l_prefix = PACK_FOLDER_PREFIX;
  Text l_path   = "";

  l_path = p_folder + "\\" + l_prefix + p_kind + "\\" + pack_replace(p_name, "/", "\\") + ".png";
  if (!File_exists(l_path)) return FAILURE;
  if (safe_file_open(l_path, "rb", l_file) != 0) return FAILURE;
  pack_read_bytes(l_file, 0, PACK_BUFFER_FILE);
  File_close(l_file);
  return SUCCESS;
}

// ---------------------------------------------------------------- PNG

Integer png_number(Integer p_at)
// ----------------------------------------------------------------
// 4 byte big-endian number in g_pack_file at position p_at
// ----------------------------------------------------------------
{
  return ((g_pack_file[p_at] * 256 + g_pack_file[p_at + 1]) * 256 + g_pack_file[p_at + 2]) * 256 + g_pack_file[p_at + 3];
}

Integer png_is_chunk(Integer p_at, Integer p_a, Integer p_b, Integer p_c, Integer p_d)
// ----------------------------------------------------------------
// TRUE if the chunk type at p_at is the four letters given
// ----------------------------------------------------------------
{
  if (g_pack_file[p_at] != p_a)     return FALSE;
  if (g_pack_file[p_at + 1] != p_b) return FALSE;
  if (g_pack_file[p_at + 2] != p_c) return FALSE;
  if (g_pack_file[p_at + 3] != p_d) return FALSE;
  return TRUE;
}

Integer png_sample(Integer p_row_start, Integer p_x, Integer p_bit_depth, Integer p_channels, Integer p_channel)
// ----------------------------------------------------------------
// One channel (1-based) of pixel x (0-based) of an unfiltered row
// whose data starts at g_pack_out[p_row_start], scaled to 0..255
// for grey images below 8 bits (palette indexes are left as they are)
// ----------------------------------------------------------------
{
  Integer l_bit    = 0;
  Integer l_byte   = 0;
  Integer l_value  = 0;
  Integer l_n      = 0;
  Integer l_shift  = 0;

  if (p_bit_depth == 8) return g_pack_out[p_row_start + p_x * p_channels + p_channel - 1];
  if (p_bit_depth == 16) return g_pack_out[p_row_start + (p_x * p_channels + p_channel - 1) * 2];

  // 1, 2 or 4 bits, packed from the highest bit of each byte
  l_bit   = p_x * p_bit_depth;
  l_byte  = g_pack_out[p_row_start + floor_divide(l_bit, 8)];
  l_shift = 8 - (l_bit - floor_divide(l_bit, 8) * 8) - p_bit_depth;
  for (l_n = 0; l_n < p_bit_depth; ++l_n) {
    l_value = l_value + g_byte_bit[l_byte * 8 + l_shift + l_n + 1] * g_pow2[l_n + 1];
  }
  return l_value;
}

Integer png_decode(Integer p_map_x, Integer p_map_y)
// ----------------------------------------------------------------
// Decode the PNG in g_pack_file to a 16 x 16 RGBA picture in
// g_pack_r/g/b/a. A bigger image is sampled (a tall animation strip
// uses its top frame). If g_pack_region_w > 0 only that rectangle of
// the image is sampled (part of a mob skin), turned by
// g_pack_region_turn. With p_map_x >= 0 it reads just the colour at
// (p_map_x, p_map_y) of a 256 x 256 colormap into g_pack_r/g/b[1].
// Returns SUCCESS or FAILURE.
// ----------------------------------------------------------------
{
  Integer l_at          = 9;
  Integer l_length      = 0;
  Integer l_width       = 0;
  Integer l_height      = 0;
  Integer l_depth       = 0;
  Integer l_colour_type = 0;
  Integer l_interlaced  = 0;
  Integer l_channels    = 1;
  Integer l_pixel_bytes = 1;
  Integer l_row_bytes   = 0;
  Integer l_rows        = 0;
  Integer l_idat        = 0;
  Integer l_byte        = 0;
  Integer l_row         = 0;
  Integer l_filter      = 0;
  Integer l_start       = 0;
  Integer l_left        = 0;
  Integer l_up          = 0;
  Integer l_up_left     = 0;
  Integer l_value       = 0;
  Integer l_side        = 0;
  Integer l_u           = 0;
  Integer l_v           = 0;
  Integer l_x           = 0;
  Integer l_y           = 0;
  Integer l_pixel       = 0;
  Integer l_index       = 0;
  Integer l_grey        = 0;
  Integer l_have_trns   = FALSE;
  Integer l_written     = 0;
  Integer l_region_x    = 0;
  Integer l_region_y    = 0;
  Integer l_region_w    = 0;
  Integer l_region_h    = 0;
  Integer l_a           = 0;
  Integer l_b           = 0;

  // Signature
  if (g_pack_file_count < 33) return FAILURE;
  if (g_pack_file[1] != 137 || g_pack_file[2] != 80 || g_pack_file[3] != 78 || g_pack_file[4] != 71) return FAILURE;

  for (l_index = 1; l_index <= 256; ++l_index) {
    g_png_pal_r[l_index] = 0;
    g_png_pal_g[l_index] = 0;
    g_png_pal_b[l_index] = 0;
    g_png_pal_a[l_index] = 255;
  }

  // Chunks: IHDR, PLTE, tRNS and IDAT; the image data is gathered in g_pack_in
  g_pack_in_count = 0;
  while (l_at + 7 <= g_pack_file_count) {
    l_length = png_number(l_at);
    if (l_at + 11 + l_length > g_pack_file_count) {
      // a cut-off chunk: keep whatever image data there is
      if (!png_is_chunk(l_at + 4, 73, 68, 65, 84)) break;
    }
    if (png_is_chunk(l_at + 4, 73, 72, 68, 82)) {                        // IHDR
      l_width       = png_number(l_at + 8);
      l_height      = png_number(l_at + 12);
      l_depth       = g_pack_file[l_at + 16];
      l_colour_type = g_pack_file[l_at + 17];
      l_interlaced  = g_pack_file[l_at + 20];
    } else if (png_is_chunk(l_at + 4, 80, 76, 84, 69)) {                 // PLTE
      for (l_index = 1; l_index <= floor_divide(l_length, 3); ++l_index) {
        if (l_index <= 256) {
          g_png_pal_r[l_index] = g_pack_file[l_at + 8 + (l_index - 1) * 3];
          g_png_pal_g[l_index] = g_pack_file[l_at + 9 + (l_index - 1) * 3];
          g_png_pal_b[l_index] = g_pack_file[l_at + 10 + (l_index - 1) * 3];
        }
      }
    } else if (png_is_chunk(l_at + 4, 116, 82, 78, 83)) {                // tRNS
      if (l_colour_type == 3) {
        for (l_index = 1; l_index <= l_length; ++l_index) {
          if (l_index <= 256) g_png_pal_a[l_index] = g_pack_file[l_at + 7 + l_index];
        }
      } else if (l_colour_type == 0) {
        l_have_trns = TRUE;
        l_grey      = g_pack_file[l_at + 9];
      }
    } else if (png_is_chunk(l_at + 4, 73, 68, 65, 84)) {                 // IDAT
      for (l_index = 1; l_index <= l_length; ++l_index) {
        l_byte = l_at + 7 + l_index;
        if (l_byte <= g_pack_file_count && g_pack_in_count < PACK_IN_SIZE) {
          ++g_pack_in_count;
          g_pack_in[g_pack_in_count] = g_pack_file[l_byte];
        }
      }
      ++l_idat;
    } else if (png_is_chunk(l_at + 4, 73, 69, 78, 68)) {                 // IEND
      break;
    }
    l_at = l_at + 12 + l_length;
  }

  if (l_width < 1 || l_height < 1 || l_idat < 1) return FAILURE;
  if (l_interlaced != 0) return FAILURE;
  if (l_colour_type == 2) l_channels = 3;
  if (l_colour_type == 4) l_channels = 2;
  if (l_colour_type == 6) l_channels = 4;
  if (l_depth != 1 && l_depth != 2 && l_depth != 4 && l_depth != 8 && l_depth != 16) return FAILURE;

  l_pixel_bytes = floor_divide(l_channels * l_depth + 7, 8);
  l_row_bytes   = floor_divide(l_width * l_channels * l_depth + 7, 8);

  // Only decompress the rows we look at
  l_side = l_width;
  if (l_height < l_side) l_side = l_height;
  l_rows = l_side;
  l_region_w = l_side;
  l_region_h = l_side;
  if (p_map_x < 0 && g_pack_region_w > 0) {
    // a rectangle of a mob skin, scaled from a PACK_SKIN_WIDTH wide skin
    l_region_x = floor_divide(g_pack_region_x * l_width, PACK_SKIN_WIDTH);
    l_region_y = floor_divide(g_pack_region_y * l_width, PACK_SKIN_WIDTH);
    l_region_w = max_integer(1, floor_divide(g_pack_region_w * l_width, PACK_SKIN_WIDTH));
    l_region_h = max_integer(1, floor_divide(g_pack_region_h * l_width, PACK_SKIN_WIDTH));
    if (l_region_x + l_region_w > l_width || l_region_y + l_region_h > l_height) return FAILURE;
    l_rows = l_region_y + l_region_h;
  }
  if (p_map_x >= 0) {
    l_x    = floor_divide(p_map_x * l_width, 256);
    l_y    = floor_divide(p_map_y * l_height, 256);
    l_rows = l_y + 1;
  }
  if (l_rows * (l_row_bytes + 1) > PACK_OUT_SIZE) return FAILURE;

  // Skip the 2 byte zlib header
  l_written = pack_inflate(3, g_pack_in_count, l_rows * (l_row_bytes + 1));
  if (l_written < l_rows * (l_row_bytes + 1)) return FAILURE;

  // Undo the row filters in place
  for (l_row = 0; l_row < l_rows; ++l_row) {
    l_start  = l_row * (l_row_bytes + 1) + 1;
    l_filter = g_pack_out[l_start];
    for (l_byte = 1; l_byte <= l_row_bytes; ++l_byte) {
      l_left    = 0;
      l_up      = 0;
      l_up_left = 0;
      if (l_byte > l_pixel_bytes) l_left = g_pack_out[l_start + l_byte - l_pixel_bytes];
      if (l_row > 0) {
        l_up = g_pack_out[l_start + l_byte - l_row_bytes - 1];
        if (l_byte > l_pixel_bytes) l_up_left = g_pack_out[l_start + l_byte - l_pixel_bytes - l_row_bytes - 1];
      }
      l_value = g_pack_out[l_start + l_byte];
      if (l_filter == 1) l_value = l_value + l_left;
      if (l_filter == 2) l_value = l_value + l_up;
      if (l_filter == 3) l_value = l_value + floor_divide(l_left + l_up, 2);
      if (l_filter == 4) l_value = l_value + pack_paeth(l_left, l_up, l_up_left);
      if (l_value > 255) l_value = l_value - 256;
      g_pack_out[l_start + l_byte] = l_value;
    }
  }

  // Sample the pixels we need
  for (l_pixel = 1; l_pixel <= 256; ++l_pixel) {
    if (p_map_x >= 0) {
      if (l_pixel > 1) break;
    } else {
      l_u = l_pixel - floor_divide(l_pixel - 1, 16) * 16;     // 1..16
      l_v = floor_divide(l_pixel - 1, 16) + 1;                // 1..16
      // (a, b): the column and row of the rectangle, after turning
      l_a = l_u;
      l_b = l_v;
      if (g_pack_region_turn == PACK_TURN_RIGHT) {
        l_a = l_v;
        l_b = 17 - l_u;
      } else if (g_pack_region_turn == PACK_TURN_HALF) {
        l_a = 17 - l_u;
        l_b = 17 - l_v;
      } else if (g_pack_region_turn == PACK_TURN_LEFT) {
        l_a = 17 - l_v;
        l_b = l_u;
      }
      l_x = l_region_x + floor_divide((2 * l_a - 1) * l_region_w, 32);
      l_y = l_region_y + floor_divide((2 * l_b - 1) * l_region_h, 32);
    }
    l_start = l_y * (l_row_bytes + 1) + 2;

    if (l_colour_type == 3) {
      l_index = png_sample(l_start, l_x, l_depth, 1, 1) + 1;
      g_pack_r[l_pixel] = g_png_pal_r[l_index];
      g_pack_g[l_pixel] = g_png_pal_g[l_index];
      g_pack_b[l_pixel] = g_png_pal_b[l_index];
      g_pack_a[l_pixel] = g_png_pal_a[l_index];
    } else if (l_colour_type == 0 || l_colour_type == 4) {
      l_value = png_sample(l_start, l_x, l_depth, l_channels, 1);
      g_pack_a[l_pixel] = 255;
      if (l_have_trns && l_value == l_grey) g_pack_a[l_pixel] = 0;
      if (l_depth < 8) l_value = floor_divide(l_value * 255, g_pow2[l_depth + 1] - 1);
      g_pack_r[l_pixel] = l_value;
      g_pack_g[l_pixel] = l_value;
      g_pack_b[l_pixel] = l_value;
      if (l_colour_type == 4) g_pack_a[l_pixel] = png_sample(l_start, l_x, l_depth, l_channels, 2);
    } else {
      g_pack_r[l_pixel] = png_sample(l_start, l_x, l_depth, l_channels, 1);
      g_pack_g[l_pixel] = png_sample(l_start, l_x, l_depth, l_channels, 2);
      g_pack_b[l_pixel] = png_sample(l_start, l_x, l_depth, l_channels, 3);
      g_pack_a[l_pixel] = 255;
      if (l_colour_type == 6) g_pack_a[l_pixel] = png_sample(l_start, l_x, l_depth, l_channels, 4);
    }
  }
  return SUCCESS;
}

// ---------------------------------------------------------------- into a texture

void pack_tint(Integer p_red, Integer p_green, Integer p_blue)
// ----------------------------------------------------------------
// Multiply the decoded picture by a colour (for grey images)
// ----------------------------------------------------------------
{
  Integer l_pixel = 0;

  for (l_pixel = 1; l_pixel <= 256; ++l_pixel) {
    g_pack_r[l_pixel] = floor_divide(g_pack_r[l_pixel] * p_red,   255);
    g_pack_g[l_pixel] = floor_divide(g_pack_g[l_pixel] * p_green, 255);
    g_pack_b[l_pixel] = floor_divide(g_pack_b[l_pixel] * p_blue,  255);
  }
}

void pack_keep_overlay()
// ----------------------------------------------------------------
// Copy the decoded picture aside, to be drawn over the next one
// ----------------------------------------------------------------
{
  Integer l_pixel = 0;

  for (l_pixel = 1; l_pixel <= 256; ++l_pixel) {
    g_pack_overlay_r[l_pixel] = g_pack_r[l_pixel];
    g_pack_overlay_g[l_pixel] = g_pack_g[l_pixel];
    g_pack_overlay_b[l_pixel] = g_pack_b[l_pixel];
    g_pack_overlay_a[l_pixel] = g_pack_a[l_pixel];
  }
}

void pack_draw_overlay()
// ----------------------------------------------------------------
// Draw the kept overlay's solid pixels over the decoded picture
// ----------------------------------------------------------------
{
  Integer l_pixel = 0;

  for (l_pixel = 1; l_pixel <= 256; ++l_pixel) {
    if (g_pack_overlay_a[l_pixel] >= 128) {
      g_pack_r[l_pixel] = g_pack_overlay_r[l_pixel];
      g_pack_g[l_pixel] = g_pack_overlay_g[l_pixel];
      g_pack_b[l_pixel] = g_pack_overlay_b[l_pixel];
      g_pack_a[l_pixel] = 255;
    }
  }
}

Real pack_distance(Integer p_colour, Integer p_cluster)
// ----------------------------------------------------------------
// Squared distance from distinct colour p_colour to a cluster centre
// ----------------------------------------------------------------
{
  Real l_red   = g_pack_colour_r[p_colour] - g_pack_centre_r[p_cluster];
  Real l_green = g_pack_colour_g[p_colour] - g_pack_centre_g[p_cluster];
  Real l_blue  = g_pack_colour_b[p_colour] - g_pack_centre_b[p_cluster];

  return l_red * l_red + l_green * l_green + l_blue * l_blue;
}

Integer pack_count_colours()
// ----------------------------------------------------------------
// List the distinct solid colours of the decoded picture with how
// often each is used (g_pack_colour_*), and note each pixel's
// colour in g_pack_pixel_colour (0 for see-through pixels).
// Returns how many distinct colours there are.
// ----------------------------------------------------------------
{
  Integer l_pixel   = 0;
  Integer l_colour  = 0;
  Integer l_found   = 0;
  Integer l_colours = 0;

  for (l_pixel = 1; l_pixel <= 256; ++l_pixel) {
    g_pack_pixel_colour[l_pixel] = 0;
    if (g_pack_a[l_pixel] < 128) continue;

    l_found = 0;
    for (l_colour = 1; l_colour <= l_colours; ++l_colour) {
      if (l_found == 0) {
        if (g_pack_colour_r[l_colour] == g_pack_r[l_pixel]) {
          if (g_pack_colour_g[l_colour] == g_pack_g[l_pixel]) {
            if (g_pack_colour_b[l_colour] == g_pack_b[l_pixel]) l_found = l_colour;
          }
        }
      }
    }
    if (l_found == 0) {
      ++l_colours;
      l_found = l_colours;
      g_pack_colour_r[l_found] = g_pack_r[l_pixel];
      g_pack_colour_g[l_found] = g_pack_g[l_pixel];
      g_pack_colour_b[l_found] = g_pack_b[l_pixel];
      g_pack_colour_n[l_found] = 0;
    }
    g_pack_colour_n[l_found]     = g_pack_colour_n[l_found] + 1;
    g_pack_pixel_colour[l_pixel] = l_found;
  }
  return l_colours;
}

Integer pack_choose_palette(Integer p_colours)
// ----------------------------------------------------------------
// Pick at most PALETTE_SIZE centres for the distinct colours and put
// each colour's centre in g_pack_cluster. With few enough colours
// every colour is its own centre; otherwise k-means: start from the
// most used colour, add the colour furthest from the centres so far,
// then move each centre to the weighted average of its colours a
// few times. Returns the number of centres.
// ----------------------------------------------------------------
{
  Integer l_colour   = 0;
  Integer l_cluster  = 0;
  Integer l_clusters = 0;
  Integer l_best     = 1;
  Integer l_round    = 0;
  Real    l_distance = 0.0;
  Real    l_nearest  = 0.0;
  Real    l_far      = 0.0;

  if (p_colours <= PALETTE_SIZE) {
    for (l_colour = 1; l_colour <= p_colours; ++l_colour) {
      g_pack_centre_r[l_colour] = g_pack_colour_r[l_colour];
      g_pack_centre_g[l_colour] = g_pack_colour_g[l_colour];
      g_pack_centre_b[l_colour] = g_pack_colour_b[l_colour];
      g_pack_sum_n   [l_colour] = g_pack_colour_n[l_colour];
      g_pack_cluster [l_colour] = l_colour;
    }
    return p_colours;
  }

  for (l_colour = 1; l_colour <= p_colours; ++l_colour) {
    if (g_pack_colour_n[l_colour] > g_pack_colour_n[l_best]) l_best = l_colour;
  }
  l_clusters = 1;
  g_pack_centre_r[1] = g_pack_colour_r[l_best];
  g_pack_centre_g[1] = g_pack_colour_g[l_best];
  g_pack_centre_b[1] = g_pack_colour_b[l_best];

  while (l_clusters < PALETTE_SIZE) {
    l_far  = 0.0;
    l_best = 0;
    for (l_colour = 1; l_colour <= p_colours; ++l_colour) {
      l_nearest = 1.0e9;
      for (l_cluster = 1; l_cluster <= l_clusters; ++l_cluster) {
        l_distance = pack_distance(l_colour, l_cluster);
        if (l_distance < l_nearest) l_nearest = l_distance;
      }
      if (l_nearest > l_far) {
        l_far  = l_nearest;
        l_best = l_colour;
      }
    }
    if (l_best == 0) break;
    ++l_clusters;
    g_pack_centre_r[l_clusters] = g_pack_colour_r[l_best];
    g_pack_centre_g[l_clusters] = g_pack_colour_g[l_best];
    g_pack_centre_b[l_clusters] = g_pack_colour_b[l_best];
  }

  for (l_round = 1; l_round <= 4; ++l_round) {
    for (l_cluster = 1; l_cluster <= l_clusters; ++l_cluster) {
      g_pack_sum_r[l_cluster] = 0.0;
      g_pack_sum_g[l_cluster] = 0.0;
      g_pack_sum_b[l_cluster] = 0.0;
      g_pack_sum_n[l_cluster] = 0;
    }
    for (l_colour = 1; l_colour <= p_colours; ++l_colour) {
      l_nearest = 1.0e9;
      for (l_cluster = 1; l_cluster <= l_clusters; ++l_cluster) {
        l_distance = pack_distance(l_colour, l_cluster);
        if (l_distance < l_nearest) {
          l_nearest = l_distance;
          g_pack_cluster[l_colour] = l_cluster;
        }
      }
      l_cluster = g_pack_cluster[l_colour];
      g_pack_sum_r[l_cluster] = g_pack_sum_r[l_cluster] + g_pack_colour_r[l_colour] * g_pack_colour_n[l_colour];
      g_pack_sum_g[l_cluster] = g_pack_sum_g[l_cluster] + g_pack_colour_g[l_colour] * g_pack_colour_n[l_colour];
      g_pack_sum_b[l_cluster] = g_pack_sum_b[l_cluster] + g_pack_colour_b[l_colour] * g_pack_colour_n[l_colour];
      g_pack_sum_n[l_cluster] = g_pack_sum_n[l_cluster] + g_pack_colour_n[l_colour];
    }
    for (l_cluster = 1; l_cluster <= l_clusters; ++l_cluster) {
      if (g_pack_sum_n[l_cluster] > 0) {
        g_pack_centre_r[l_cluster] = g_pack_sum_r[l_cluster] / g_pack_sum_n[l_cluster];
        g_pack_centre_g[l_cluster] = g_pack_sum_g[l_cluster] / g_pack_sum_n[l_cluster];
        g_pack_centre_b[l_cluster] = g_pack_sum_b[l_cluster] / g_pack_sum_n[l_cluster];
      }
    }
  }
  return l_clusters;
}

void pack_to_texture(Integer p_tex, Integer p_sprite)
// ----------------------------------------------------------------
// Store the decoded picture as texture p_tex, reduced to at most
// PALETTE_SIZE colours. In a sprite, see-through pixels become
// TEX_TRANSPARENT; a block texture can't have holes, so there they
// take the most used colour.
// ----------------------------------------------------------------
{
  Integer l_colours  = pack_count_colours();
  Integer l_clusters = 0;
  Integer l_cluster  = 0;
  Integer l_best     = 1;
  Integer l_pixel    = 0;
  Integer l_index    = 0;

  if (l_colours == 0) return;
  l_clusters = pack_choose_palette(l_colours);

  for (l_cluster = 1; l_cluster <= l_clusters; ++l_cluster) {
    if (g_pack_sum_n[l_cluster] > g_pack_sum_n[l_best]) l_best = l_cluster;
  }

  for (l_cluster = 1; l_cluster <= PALETTE_SIZE; ++l_cluster) {
    l_index = l_cluster;
    if (l_index > l_clusters) l_index = l_best;
    texture_set_palette(p_tex, l_cluster, to_byte(g_pack_centre_r[l_index]), to_byte(g_pack_centre_g[l_index]), to_byte(g_pack_centre_b[l_index]));
  }
  for (l_pixel = 1; l_pixel <= 256; ++l_pixel) {
    l_cluster = TEX_TRANSPARENT;
    if (g_pack_pixel_colour[l_pixel] > 0) {
      l_cluster = g_pack_cluster[g_pack_pixel_colour[l_pixel]];
    } else if (!p_sprite) {
      l_cluster = l_best;
    }
    texture_set(p_tex, l_pixel - floor_divide(l_pixel - 1, 16) * 16, floor_divide(l_pixel - 1, 16) + 1, l_cluster);
  }
}

// ---------------------------------------------------------------- loading a pack

Integer pack_load_image(Text p_path, Integer p_zip, Attributes &p_index, Text p_kind, Text p_name, Integer p_map_x, Integer p_map_y)
// ----------------------------------------------------------------
// Load and decode one image of the pack (see png_decode)
// ----------------------------------------------------------------
{
  if (p_zip) {
    if (pack_load_png_from_zip(p_path, p_index, pack_key(p_kind, p_name)) != SUCCESS) return FAILURE;
  } else {
    if (pack_load_png_from_folder(p_path, p_kind, p_name) != SUCCESS) return FAILURE;
  }
  return png_decode(p_map_x, p_map_y);
}

Integer pack_apply(Text p_path, Text &p_report)
// ----------------------------------------------------------------
// Replace the textures with the pack's images, where it has them.
// p_path is a .zip file or the folder a pack was unzipped into.
// Call between textures_generate() and textures_finish_all().
// Returns how many textures were replaced; p_report says what
// happened.
// ----------------------------------------------------------------
{
  Attributes l_wanted;
  Attributes l_index;
  Integer    l_zip        = pack_is_zip(p_path);
  Integer    l_entry      = 1;
  Integer    l_tex        = 0;
  Integer    l_tint       = 0;
  Integer    l_loaded     = 0;
  Integer    l_missing    = 0;
  Integer    l_sprite     = FALSE;
  Integer    l_pixel      = 0;
  Integer    l_grass_r    = PACK_GRASS_R;
  Integer    l_grass_g    = PACK_GRASS_G;
  Integer    l_grass_b    = PACK_GRASS_B;
  Integer    l_foliage_r  = PACK_FOLIAGE_R;
  Integer    l_foliage_g  = PACK_FOLIAGE_G;
  Integer    l_foliage_b  = PACK_FOLIAGE_B;
  Text       l_kind       = "";
  Text       l_name       = "";
  Text       l_overlay    = "";
  Text       l_problem    = "";
  Integer    l_x          = 0;
  Integer    l_y          = 0;
  Integer    l_w          = 0;
  Integer    l_h          = 0;
  Integer    l_turn       = 0;
  Integer    l_result     = 0;

  pack_init_tables();
  p_report = "";
  g_pack_region_w = 0;

  if (l_zip) {
    if (!File_exists(p_path)) {
      p_report = "Can't find the resource pack " + p_path;
      return 0;
    }
    record_clear(l_wanted, DATATYPE_PACK_WANTED);
    record_set_integer(l_wanted, pack_key("colormap", "grass"),   TRUE);
    record_set_integer(l_wanted, pack_key("colormap", "foliage"), TRUE);
    while (pack_map_entry(l_entry, l_tex, l_kind, l_name, l_tint, l_overlay)) {
      record_set_integer(l_wanted, pack_key(l_kind, l_name), TRUE);
      if (l_overlay != "") record_set_integer(l_wanted, pack_key(l_kind, l_overlay), TRUE);
      ++l_entry;
    }
    l_entry = 1;
    while (pack_map_part(l_entry, l_tex, l_name, l_x, l_y, l_w, l_h, l_turn)) {
      record_set_integer(l_wanted, pack_key("entity", l_name), TRUE);
      ++l_entry;
    }
    if (pack_zip_index(p_path, l_wanted, l_index, l_problem) == 0) {
      p_report = l_problem;
      return 0;
    }
  } else if (!Directory_exists(p_path)) {
    p_report = "Can't find the resource pack folder " + p_path;
    return 0;
  }

  // Biome colours
  if (pack_load_image(p_path, l_zip, l_index, "colormap", "grass", PACK_COLORMAP_X, PACK_COLORMAP_Y) == SUCCESS) {
    l_grass_r = g_pack_r[1];
    l_grass_g = g_pack_g[1];
    l_grass_b = g_pack_b[1];
  }
  if (pack_load_image(p_path, l_zip, l_index, "colormap", "foliage", PACK_COLORMAP_X, PACK_COLORMAP_Y) == SUCCESS) {
    l_foliage_r = g_pack_r[1];
    l_foliage_g = g_pack_g[1];
    l_foliage_b = g_pack_b[1];
  }

  l_entry = 1;
  while (pack_map_entry(l_entry, l_tex, l_kind, l_name, l_tint, l_overlay)) {
    ++l_entry;
    l_sprite = texture_is_sprite(l_tex);

    if (l_overlay != "") {
      if (pack_load_image(p_path, l_zip, l_index, l_kind, l_overlay, -1, 0) == SUCCESS) {
        pack_tint(l_grass_r, l_grass_g, l_grass_b);
        pack_keep_overlay();
      } else {
        for (l_pixel = 1; l_pixel <= 256; ++l_pixel) g_pack_overlay_a[l_pixel] = 0;
      }
      l_tint = PACK_TINT_NONE;
    }

    if (pack_load_image(p_path, l_zip, l_index, l_kind, l_name, -1, 0) != SUCCESS) {
      ++l_missing;
      continue;
    }
    if (l_tint == PACK_TINT_GRASS  ) pack_tint(l_grass_r, l_grass_g, l_grass_b);
    if (l_tint == PACK_TINT_FOLIAGE) pack_tint(l_foliage_r, l_foliage_g, l_foliage_b);
    if (l_tint == PACK_TINT_WATER  ) pack_tint(PACK_WATER_R, PACK_WATER_G, PACK_WATER_B);
    if (l_overlay != "") pack_draw_overlay();

    pack_to_texture(l_tex, l_sprite);
    ++l_loaded;
  }

  // Mob textures: each one is a rectangle of a mob skin
  l_entry = 1;
  while (pack_map_part(l_entry, l_tex, l_name, l_x, l_y, l_w, l_h, l_turn)) {
    ++l_entry;
    g_pack_region_x    = l_x;
    g_pack_region_y    = l_y;
    g_pack_region_w    = l_w;
    g_pack_region_h    = l_h;
    g_pack_region_turn = l_turn;
    l_result = pack_load_image(p_path, l_zip, l_index, "entity", l_name, -1, 0);
    g_pack_region_w = 0;
    if (l_result != SUCCESS) {
      ++l_missing;
      continue;
    }
    pack_to_texture(l_tex, FALSE);
    ++l_loaded;
  }

  p_report = "Resource pack: " + To_text(l_loaded) + " textures loaded";
  if (l_missing > 0) p_report = p_report + ", " + To_text(l_missing) + " not in the pack (built-in kept)";
  return l_loaded;
}

#endif
