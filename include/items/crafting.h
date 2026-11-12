#ifndef CRAFTING_H_INCLUDED
#define CRAFTING_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// Shaped crafting
//
// Items are laid out in a crafting grid: 2 x 2 in the inventory
// screen, 3 x 3 at a crafting table. The grid is a container record
// (see inventory.h) with slots 1..9 numbered row by row and a
// "width" field (2 or 3); with width 2 only slots 1, 2, 4, 5 are
// used, so the numbering is the same for both sizes.
//
// The recipe book is a record too. Recipe r has fields
// "output_r", "output_count_r", "width_r", "height_r" and its
// pattern cells "cell_r_1".."cell_r_9" (row by row, width_r cells
// per row, ITEM_NONE for a gap). A pattern can sit anywhere in the
// grid and may be mirrored left to right.
// ----------------------------------------------------------------

#define DATATYPE_RECIPE_BOOK  ("recipe_book")
#define DATATYPE_CRAFT_GRID   ("craft_grid")
#define ATTR_RECIPE_OUTPUT    ("output")
#define ATTR_RECIPE_OUT_COUNT ("output_count")
#define ATTR_RECIPE_WIDTH     ("width")
#define ATTR_RECIPE_HEIGHT    ("height")
#define ATTR_RECIPE_CELL      ("cell")
#define ATTR_GRID_WIDTH       ("width")
#define GRID_SLOTS            9
#define GRID_INVENTORY_WIDTH  2
#define GRID_TABLE_WIDTH      3

void    crafting_init_book    (Attributes &p_book);
void    crafting_add_recipe   (Attributes &p_book, Integer p_output, Integer p_output_count,
                               Integer p_width, Integer p_height, Text p_pattern, Integer p_item_a, Integer p_item_b);
Integer crafting_recipe_count (Attributes &p_book);
Integer crafting_recipe_output(Attributes &p_book, Integer p_recipe);
Integer crafting_recipe_cell  (Attributes &p_book, Integer p_recipe, Integer p_column, Integer p_row);

void    grid_clear            (Attributes &p_grid, Integer p_width);
Integer grid_width            (Attributes &p_grid);
Integer grid_slot             (Integer p_column, Integer p_row);
Integer grid_slot_used        (Attributes &p_grid, Integer p_slot);
Integer crafting_match        (Attributes &p_book, Attributes &p_grid);
Integer crafting_match_at     (Attributes &p_book, Integer p_recipe, Attributes &p_grid,
                               Integer p_left, Integer p_top, Integer p_mirrored);
Integer crafting_take_output  (Attributes &p_book, Attributes &p_grid, Attributes &p_holder, Attributes &p_events);
void    grid_return_items     (Attributes &p_grid, Attributes &p_inventory, Attributes &p_events, Real p_x, Real p_y, Real p_z);

#endif
