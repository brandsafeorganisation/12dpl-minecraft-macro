#ifndef CRAFTING_4DM_INCLUDED
#define CRAFTING_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/records.h"
#include "../../include/blocks/blocks.h"
#include "../../include/core/events.h"
#include "../../include/items/inventory.h"
#include "../../include/items/crafting.h"

// ---------------------------------------------------------------- the recipe book

void crafting_add_recipe(Attributes &p_book, Integer p_output, Integer p_output_count,
                         Integer p_width, Integer p_height, Text p_pattern, Integer p_item_a, Integer p_item_b)
// ----------------------------------------------------------------
// Add a recipe. pattern has width * height characters, row by row:
// "A" means item_a, "B" means item_b and "." an empty cell.
// Example, a pickaxe from planks (A) and sticks (B):
//   width 3, height 3, pattern "AAA" + ".B." + ".B." = "AAA.B..B."
// ----------------------------------------------------------------
{
  Integer l_recipe    = crafting_recipe_count(p_book) + 1;
  Integer l_cell      = 0;
  Integer l_item      = 0;
  Text    l_character = "";

  record_set_integer_at(p_book, ATTR_RECIPE_OUTPUT,    l_recipe, p_output);
  record_set_integer_at(p_book, ATTR_RECIPE_OUT_COUNT, l_recipe, p_output_count);
  record_set_integer_at(p_book, ATTR_RECIPE_WIDTH,     l_recipe, p_width);
  record_set_integer_at(p_book, ATTR_RECIPE_HEIGHT,    l_recipe, p_height);

  for (l_cell = 1; l_cell <= p_width * p_height; ++l_cell) {
    l_character = Get_subtext(p_pattern, l_cell, l_cell);
    l_item      = ITEM_NONE;
    if (l_character == "A") l_item = p_item_a;
    if (l_character == "B") l_item = p_item_b;
    record_set_integer(p_book, record_field_at(record_field_at(ATTR_RECIPE_CELL, l_recipe), l_cell), l_item);
  }

  record_set_integer(p_book, ATTR_COUNT, l_recipe);
}

void crafting_init_book(Attributes &p_book)
// ----------------------------------------------------------------
// Fill the recipe book
// ----------------------------------------------------------------
{
  record_clear      (p_book, DATATYPE_RECIPE_BOOK);
  record_set_integer(p_book, ATTR_COUNT, 0);

  //                        output               n  w  h  pattern      A                 B
  crafting_add_recipe(p_book, ITEM_PLANKS        , 4, 1, 1, "A"        , ITEM_OAK_LOG    , ITEM_NONE );
  crafting_add_recipe(p_book, ITEM_STICK         , 4, 1, 2, "AA"       , ITEM_PLANKS     , ITEM_NONE );
  crafting_add_recipe(p_book, ITEM_CRAFTING_TABLE, 1, 2, 2, "AAAA"     , ITEM_PLANKS     , ITEM_NONE );
  crafting_add_recipe(p_book, ITEM_SANDSTONE     , 1, 2, 2, "AAAA"     , ITEM_SAND       , ITEM_NONE );
  crafting_add_recipe(p_book, ITEM_FURNACE       , 1, 3, 3, "AAAA.AAAA", ITEM_COBBLESTONE, ITEM_NONE );
  crafting_add_recipe(p_book, ITEM_WOODEN_PICKAXE, 1, 3, 3, "AAA.B..B.", ITEM_PLANKS     , ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_STONE_PICKAXE , 1, 3, 3, "AAA.B..B.", ITEM_COBBLESTONE, ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_WOODEN_AXE    , 1, 2, 3, "AAAB.B"   , ITEM_PLANKS     , ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_STONE_AXE     , 1, 2, 3, "AAAB.B"   , ITEM_COBBLESTONE, ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_WOODEN_SHOVEL , 1, 1, 3, "ABB"      , ITEM_PLANKS     , ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_STONE_SHOVEL  , 1, 1, 3, "ABB"      , ITEM_COBBLESTONE, ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_WOODEN_SWORD  , 1, 1, 3, "AAB"      , ITEM_PLANKS     , ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_STONE_SWORD   , 1, 1, 3, "AAB"      , ITEM_COBBLESTONE, ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_TORCH         , 4, 1, 2, "AB"       , ITEM_COAL       , ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_CHEST         , 1, 3, 3, "AAAA.AAAA", ITEM_PLANKS     , ITEM_NONE );
  crafting_add_recipe(p_book, ITEM_BED           , 1, 3, 2, "AAABBB"   , ITEM_LEAVES     , ITEM_PLANKS);
  crafting_add_recipe(p_book, ITEM_DOOR          , 3, 2, 3, "AAAAAA"   , ITEM_PLANKS     , ITEM_NONE );
  crafting_add_recipe(p_book, ITEM_IRON_PICKAXE  , 1, 3, 3, "AAA.B..B.", ITEM_IRON_INGOT , ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_IRON_AXE      , 1, 2, 3, "AAAB.B"   , ITEM_IRON_INGOT , ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_IRON_SHOVEL   , 1, 1, 3, "ABB"      , ITEM_IRON_INGOT , ITEM_STICK);
  crafting_add_recipe(p_book, ITEM_IRON_SWORD    , 1, 1, 3, "AAB"      , ITEM_IRON_INGOT , ITEM_STICK);
}

Integer crafting_recipe_count(Attributes &p_book)
// ----------------------------------------------------------------
// Number of recipes in the book
// ----------------------------------------------------------------
{
  return record_integer(p_book, ATTR_COUNT);
}

Integer crafting_recipe_output(Attributes &p_book, Integer p_recipe)
// ----------------------------------------------------------------
// Item a recipe makes
// ----------------------------------------------------------------
{
  return record_integer_at(p_book, ATTR_RECIPE_OUTPUT, p_recipe);
}

Integer crafting_recipe_cell(Attributes &p_book, Integer p_recipe, Integer p_column, Integer p_row)
// ----------------------------------------------------------------
// Item in a pattern cell (column and row from 1), ITEM_NONE for a
// gap or a cell outside the pattern
// ----------------------------------------------------------------
{
  Integer l_width  = record_integer_at(p_book, ATTR_RECIPE_WIDTH,  p_recipe);
  Integer l_height = record_integer_at(p_book, ATTR_RECIPE_HEIGHT, p_recipe);

  if (p_column < 1 || p_column > l_width ) return ITEM_NONE;
  if (p_row    < 1 || p_row    > l_height) return ITEM_NONE;

  return record_integer(p_book, record_field_at(record_field_at(ATTR_RECIPE_CELL, p_recipe), (p_row - 1) * l_width + p_column));
}

// ---------------------------------------------------------------- the grid

void grid_clear(Attributes &p_grid, Integer p_width)
// ----------------------------------------------------------------
// Empty crafting grid of width 2 or 3
// ----------------------------------------------------------------
{
  container_clear   (p_grid, DATATYPE_CRAFT_GRID, 1, GRID_SLOTS);
  record_set_integer(p_grid, ATTR_GRID_WIDTH, p_width);
}

Integer grid_width(Attributes &p_grid)
// ----------------------------------------------------------------
// 2 for the inventory grid, 3 at a crafting table
// ----------------------------------------------------------------
{
  return record_integer(p_grid, ATTR_GRID_WIDTH);
}

Integer grid_slot(Integer p_column, Integer p_row)
// ----------------------------------------------------------------
// Slot of a grid cell (column and row from 1, top left first)
// ----------------------------------------------------------------
{
  return (p_row - 1) * GRID_TABLE_WIDTH + p_column;
}

Integer grid_slot_used(Attributes &p_grid, Integer p_slot)
// ----------------------------------------------------------------
// TRUE if a slot number is part of this grid's size
// ----------------------------------------------------------------
{
  Integer l_width  = grid_width(p_grid);
  Integer l_column = p_slot - Floor((p_slot - 1) / 3.0) * 3;
  Integer l_row    = Floor((p_slot - 1) / 3.0) + 1;

  if (p_slot < 1 || p_slot > GRID_SLOTS) return FALSE;
  if (l_column > l_width || l_row > l_width) return FALSE;
  return TRUE;
}

Integer crafting_match_at(Attributes &p_book, Integer p_recipe, Attributes &p_grid,
                          Integer p_left, Integer p_top, Integer p_mirrored)
// ----------------------------------------------------------------
// TRUE if the grid holds exactly the recipe's pattern with its top
// left cell at grid column left, row top (optionally mirrored),
// and nothing anywhere else
// ----------------------------------------------------------------
{
  Integer l_width        = grid_width(p_grid);
  Integer l_recipe_width = record_integer_at(p_book, ATTR_RECIPE_WIDTH, p_recipe);
  Integer l_column       = 0;
  Integer l_row          = 0;
  Integer l_pattern_col  = 0;
  Integer l_wanted       = 0;

  for (l_row = 1; l_row <= l_width; ++l_row) {
    for (l_column = 1; l_column <= l_width; ++l_column) {
      l_pattern_col = l_column - p_left + 1;
      if (p_mirrored) l_pattern_col = l_recipe_width - l_pattern_col + 1;
      l_wanted = crafting_recipe_cell(p_book, p_recipe, l_pattern_col, l_row - p_top + 1);
      if (slot_item(p_grid, grid_slot(l_column, l_row)) != l_wanted) return FALSE;
    }
  }
  return TRUE;
}

Integer crafting_match(Attributes &p_book, Attributes &p_grid)
// ----------------------------------------------------------------
// The recipe laid out in the grid, 0 if none
// ----------------------------------------------------------------
{
  Integer l_width  = grid_width(p_grid);
  Integer l_recipe = 0;
  Integer l_rw     = 0;
  Integer l_rh     = 0;
  Integer l_left   = 0;
  Integer l_top    = 0;
  Integer l_slot   = 0;
  Integer l_filled = 0;

  for (l_slot = 1; l_slot <= GRID_SLOTS; ++l_slot) {
    if (!slot_is_empty(p_grid, l_slot)) ++l_filled;
  }
  if (l_filled == 0) return 0;

  for (l_recipe = 1; l_recipe <= crafting_recipe_count(p_book); ++l_recipe) {
    l_rw = record_integer_at(p_book, ATTR_RECIPE_WIDTH,  l_recipe);
    l_rh = record_integer_at(p_book, ATTR_RECIPE_HEIGHT, l_recipe);
    if (l_rw > l_width || l_rh > l_width) continue;
    for (l_top = 1; l_top <= l_width - l_rh + 1; ++l_top) {
      for (l_left = 1; l_left <= l_width - l_rw + 1; ++l_left) {
        if (crafting_match_at(p_book, l_recipe, p_grid, l_left, l_top, FALSE)) return l_recipe;
        if (crafting_match_at(p_book, l_recipe, p_grid, l_left, l_top, TRUE )) return l_recipe;
      }
    }
  }
  return 0;
}

Integer crafting_take_output(Attributes &p_book, Attributes &p_grid, Attributes &p_holder, Attributes &p_events)
// ----------------------------------------------------------------
// Click on the output slot: if the grid makes something and the
// cursor (holder's CURSOR_SLOT) can take it, use one item from each
// grid cell and add the result to the cursor
// Emits EVT_ITEM_CRAFTED. Returns the item made, ITEM_NONE if not.
// ----------------------------------------------------------------
{
  Integer l_recipe       = crafting_match(p_book, p_grid);
  Integer l_output       = 0;
  Integer l_output_count = 0;
  Integer l_cursor_item  = slot_item (p_holder, CURSOR_SLOT);
  Integer l_cursor_count = slot_count(p_holder, CURSOR_SLOT);
  Integer l_slot         = 0;

  if (l_recipe == 0) return ITEM_NONE;

  l_output       = crafting_recipe_output(p_book, l_recipe);
  l_output_count = record_integer_at(p_book, ATTR_RECIPE_OUT_COUNT, l_recipe);

  if (l_cursor_item != ITEM_NONE) {
    if (l_cursor_item != l_output) return ITEM_NONE;
    if (l_cursor_count + l_output_count > item_max_stack(l_output)) return ITEM_NONE;
  }

  for (l_slot = 1; l_slot <= GRID_SLOTS; ++l_slot) {
    if (!slot_is_empty(p_grid, l_slot)) slot_take_one(p_grid, l_slot);
  }
  slot_set(p_holder, CURSOR_SLOT, l_output, l_cursor_count + l_output_count, 0);

  emit_item_event(p_events, EVT_ITEM_CRAFTED, l_output, l_output_count);
  return l_output;
}

void grid_return_items(Attributes &p_grid, Attributes &p_inventory, Attributes &p_events, Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Move everything left in the grid back into the inventory when
// the screen closes; what doesn't fit is dropped at (x, y, z)
// ----------------------------------------------------------------
{
  Integer l_slot = 0;
  Integer l_left = 0;

  for (l_slot = 1; l_slot <= GRID_SLOTS; ++l_slot) {
    if (slot_is_empty(p_grid, l_slot)) continue;
    l_left = inventory_add_worn(p_inventory, slot_item(p_grid, l_slot), slot_count(p_grid, l_slot), slot_damage(p_grid, l_slot));
    if (l_left > 0) emit_drop_event(p_events, slot_item(p_grid, l_slot), l_left, slot_damage(p_grid, l_slot), p_x, p_y, p_z);
    slot_clear(p_grid, l_slot);
  }
}

#endif
