#ifndef RENDER_UI_4DM_INCLUDED
#define RENDER_UI_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/items/inventory.h"
#include "../../include/items/crafting.h"
#include "../../include/items/furnace.h"
#include "../../include/render/render.h"
#include "../../include/render/hud.h"
#include "../../include/items/chest.h"
#include "../../include/render/ui.h"

// ---------------------------------------------------------------- the UI record

void ui_clear(Attributes &p_ui)
// ----------------------------------------------------------------
// No screen open
// ----------------------------------------------------------------
{
  record_clear      (p_ui, DATATYPE_UI);
  record_set_integer(p_ui, ATTR_UI_SCREEN,  SCREEN_NONE);
  record_set_integer(p_ui, ATTR_UI_FURNACE, 0);
  record_set_integer(p_ui, ATTR_X,          0);
  record_set_integer(p_ui, ATTR_Y,          0);
  record_set_integer(p_ui, ATTR_Z,          0);
  record_set_integer(p_ui, ATTR_UI_TABS,    FALSE);
  record_set_integer(p_ui, ATTR_UI_SCROLL,  0);
  ui_set_mouse(p_ui, -1000.0, -1000.0);
  ui_set_search(p_ui, "");
}

Integer ui_screen(Attributes &p_ui)
// ----------------------------------------------------------------
// SCREEN_* that is open
// ----------------------------------------------------------------
{
  return record_integer(p_ui, ATTR_UI_SCREEN);
}

Integer ui_furnace(Attributes &p_ui)
// ----------------------------------------------------------------
// Number of the furnace whose screen is open, 0 if none
// ----------------------------------------------------------------
{
  return record_integer(p_ui, ATTR_UI_FURNACE);
}

void ui_mouse(Attributes &p_ui, Real &p_x, Real &p_y)
// ----------------------------------------------------------------
// Last mouse position over the screen
// ----------------------------------------------------------------
{
  p_x = record_real(p_ui, ATTR_UI_MOUSE_X);
  p_y = record_real(p_ui, ATTR_UI_MOUSE_Y);
}

void ui_set_mouse(Attributes &p_ui, Real p_x, Real p_y)
// ----------------------------------------------------------------
// Remember where the mouse is (for highlighting and the carried
// stack)
// ----------------------------------------------------------------
{
  record_set_real(p_ui, ATTR_UI_MOUSE_X, p_x);
  record_set_real(p_ui, ATTR_UI_MOUSE_Y, p_y);
}

// ---------------------------------------------------------------- creative mode

void ui_set_tabs(Attributes &p_ui, Integer p_creative)
// ----------------------------------------------------------------
// Show the creative tabs (TRUE in creative mode) on the inventory
// screens opened from now on
// ----------------------------------------------------------------
{
  record_set_integer(p_ui, ATTR_UI_TABS, p_creative == TRUE);
}

Text ui_search(Attributes &p_ui)
// ----------------------------------------------------------------
// What has been typed into the creative screen's search
// ----------------------------------------------------------------
{
  return record_text(p_ui, ATTR_UI_SEARCH);
}

void ui_set_search(Attributes &p_ui, Text p_search)
// ----------------------------------------------------------------
// Set the search and list the items whose names contain it (any
// case), in item order, back at the top of the list
// ----------------------------------------------------------------
{
  Text    l_search = Text_lower(p_search);
  Integer l_item   = 0;
  Integer l_count  = 0;
  Text    l_name   = "";

  record_set_text(p_ui, ATTR_UI_SEARCH, p_search);
  for (l_item = 1; l_item <= MAX_ITEM_ID; ++l_item) {
    l_name = item_name(l_item);
    if (l_name == "") continue;
    if (l_search != "") {
      if (Find_text(Text_lower(l_name), l_search) < 1) continue;
    }
    ++l_count;
    record_set_integer_at(p_ui, ATTR_UI_ITEM, l_count, l_item);
  }
  record_set_integer(p_ui, ATTR_UI_ITEM_COUNT, l_count);
  record_set_integer(p_ui, ATTR_UI_SCROLL,     0);
}

void ui_type_search(Attributes &p_ui, Text p_key)
// ----------------------------------------------------------------
// A key typed on the creative screen: "backspace" rubs out the
// last letter, any single character is added
// ----------------------------------------------------------------
{
  Text l_search = ui_search(p_ui);

  if (p_key == "backspace") {
    if (Text_length(l_search) > 0) ui_set_search(p_ui, Get_subtext(l_search, 1, Text_length(l_search) - 1));
    return;
  }
  if (Text_length(p_key) != 1 || Text_length(l_search) >= CREATIVE_SEARCH_MAX) return;
  ui_set_search(p_ui, l_search + p_key);
}

Integer ui_creative_count(Attributes &p_ui)
// ----------------------------------------------------------------
// How many items match the search
// ----------------------------------------------------------------
{
  return record_integer(p_ui, ATTR_UI_ITEM_COUNT);
}

Integer ui_creative_rows(Attributes &p_ui)
// ----------------------------------------------------------------
// Rows of matching items (9 to a row)
// ----------------------------------------------------------------
{
  return floor_divide(ui_creative_count(p_ui) + 8, 9);
}

Integer ui_creative_item(Attributes &p_ui, Integer p_slot)
// ----------------------------------------------------------------
// Item shown in creative slot p_slot (1..CREATIVE_SLOTS) after
// scrolling, ITEM_NONE past the end of the list
// ----------------------------------------------------------------
{
  Integer l_index = record_integer(p_ui, ATTR_UI_SCROLL) * 9 + p_slot;

  if (p_slot < 1 || p_slot > CREATIVE_SLOTS) return ITEM_NONE;
  if (l_index > ui_creative_count(p_ui)) return ITEM_NONE;
  return record_integer_at(p_ui, ATTR_UI_ITEM, l_index);
}

void ui_creative_click(Attributes &p_ui, Attributes &p_inventory, Integer p_slot, Integer p_right_button)
// ----------------------------------------------------------------
// A click on creative slot p_slot. Carrying a different item (or
// clicking an empty slot) throws the carried stack away. Otherwise
// a left click takes a full stack and a right click takes one more;
// the list never runs out.
// ----------------------------------------------------------------
{
  Integer l_item    = ui_creative_item(p_ui, p_slot);
  Integer l_carried = slot_item (p_inventory, CURSOR_SLOT);
  Integer l_count   = slot_count(p_inventory, CURSOR_SLOT);

  if (l_carried != ITEM_NONE && l_carried != l_item) {
    slot_clear(p_inventory, CURSOR_SLOT);
    return;
  }
  if (l_item == ITEM_NONE) return;
  if (p_right_button) {
    if (l_carried == ITEM_NONE) l_count = 0;
    if (l_count < item_max_stack(l_item)) slot_set(p_inventory, CURSOR_SLOT, l_item, l_count + 1, 0);
  } else {
    slot_set(p_inventory, CURSOR_SLOT, l_item, item_max_stack(l_item), 0);
  }
}

// ---------------------------------------------------------------- opening and closing

void ui_open(Attributes &p_ui, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_events,
             Integer p_screen, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Open a screen; (x, y, z) is the block that was used (the furnace
// or crafting table)
// ----------------------------------------------------------------
{
  Integer l_furnace = 0;

  record_set_integer(p_ui, ATTR_UI_SCREEN,  p_screen);
  record_set_integer(p_ui, ATTR_UI_FURNACE, 0);
  record_set_integer(p_ui, ATTR_UI_CHEST,   0);
  record_set_integer(p_ui, ATTR_X,          p_x);
  record_set_integer(p_ui, ATTR_Y,          p_y);
  record_set_integer(p_ui, ATTR_Z,          p_z);

  if (p_screen == SCREEN_INVENTORY) grid_clear(p_grid, GRID_INVENTORY_WIDTH);
  if (p_screen == SCREEN_CREATIVE ) ui_set_search(p_ui, "");
  if (p_screen == SCREEN_CRAFTING ) grid_clear(p_grid, GRID_TABLE_WIDTH);

  if (p_screen == SCREEN_CHEST) {
    l_furnace = chest_get_or_create(p_furnaces, p_x, p_y, p_z);
    record_set_integer(p_ui, ATTR_UI_CHEST, l_furnace);
    if (l_furnace == 0) {
      record_set_integer(p_ui, ATTR_UI_SCREEN, SCREEN_NONE);
      emit_toast(p_events, "Too many chests in this world");
    }
  }

  if (p_screen == SCREEN_FURNACE) {
    l_furnace = furnace_get_or_create(p_furnaces, p_x, p_y, p_z);
    record_set_integer(p_ui, ATTR_UI_FURNACE, l_furnace);
    if (l_furnace == 0) {
      record_set_integer(p_ui, ATTR_UI_SCREEN, SCREEN_NONE);
      emit_toast(p_events, "Too many furnaces in this world");
    }
  }
}

void ui_close(Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_events,
              Real p_drop_x, Real p_drop_y, Real p_drop_z)
// ----------------------------------------------------------------
// Close the open screen; the carried stack and anything left in the
// crafting grid go back into the inventory (or onto the ground at
// the drop point if there is no room)
// ----------------------------------------------------------------
{
  inventory_return_cursor(p_inventory, p_events, p_drop_x, p_drop_y, p_drop_z);
  grid_return_items      (p_grid, p_inventory, p_events, p_drop_x, p_drop_y, p_drop_z);
  record_set_integer(p_ui, ATTR_UI_SCREEN,  SCREEN_NONE);
  record_set_integer(p_ui, ATTR_UI_FURNACE, 0);
}

void ui_on_event(Attributes &p_event, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid,
                 Attributes &p_furnaces, Attributes &p_events, Real p_drop_x, Real p_drop_y, Real p_drop_z)
// ----------------------------------------------------------------
// Event handler: open screens on request; close the open screen if
// the player dies or its block is broken
// ----------------------------------------------------------------
{
  Integer l_type = event_type(p_event);

  if (l_type == EVT_OPEN_SCREEN) {
    ui_open(p_ui, p_grid, p_furnaces, p_events, event_integer(p_event, 1), event_integer(p_event, 2), event_integer(p_event, 3), event_integer(p_event, 4));
  } else if (l_type == EVT_CLOSE_SCREEN || l_type == EVT_PLAYER_DIED) {
    if (ui_screen(p_ui) != SCREEN_NONE) ui_close(p_ui, p_inventory, p_grid, p_events, p_drop_x, p_drop_y, p_drop_z);
  } else if (l_type == EVT_BLOCK_BROKEN) {
    if (ui_screen(p_ui) == SCREEN_FURNACE || ui_screen(p_ui) == SCREEN_CRAFTING || ui_screen(p_ui) == SCREEN_CHEST) {
      if (event_integer(p_event, 1) == record_integer(p_ui, ATTR_X) && event_integer(p_event, 2) == record_integer(p_ui, ATTR_Y) &&
          event_integer(p_event, 3) == record_integer(p_ui, ATTR_Z)) {
        ui_close(p_ui, p_inventory, p_grid, p_events, p_drop_x, p_drop_y, p_drop_z);
      }
    }
  }
}

// ---------------------------------------------------------------- layout

void ui_layout(Integer p_screen, Real p_w, Real p_h, Real &p_slot_size, Real &p_x0, Real &p_y0, Real &p_x1, Real &p_y1,
               Real &p_inv_x, Real &p_inv_y, Real &p_top_y)
// ----------------------------------------------------------------
// Size and place a screen in a w x h view
// From the bottom: the hotbar, the 3 rows of the main inventory,
// then (from top_y up) the crafting grid or the furnace
// ----------------------------------------------------------------
{
  Real l_width  = 0.0;
  Real l_height = 0.0;

  p_slot_size = clamp_real(min_real((p_w - 60.0) / 9.0, (p_h - STATUS_STRIP_HEIGHT - 60.0) / 8.4), 26.0, 44.0);

  l_width  = p_slot_size * 9.0 + UI_PADDING * 2.0;
  l_height = UI_PADDING + p_slot_size * 4.0 + 8.0 + 22.0 + p_slot_size * 3.0 + 10.0 + UI_TITLE_HEIGHT;
  // creative: the hotbar, the item rows and the search line
  if (p_screen == SCREEN_CREATIVE) l_height = UI_PADDING * 2.0 + p_slot_size * (CREATIVE_ROWS + 1.7) + 16.0;
  // the inventory: four rows above for the armour column
  if (p_screen == SCREEN_INVENTORY) l_height = l_height + p_slot_size;

  p_x0 = p_w / 2.0 - l_width / 2.0;
  p_x1 = p_x0 + l_width;
  p_y0 = max_real(STATUS_STRIP_HEIGHT + 4.0, STATUS_STRIP_HEIGHT + (p_h - STATUS_STRIP_HEIGHT - l_height) / 2.0);
  p_y1 = p_y0 + l_height;

  p_inv_x = p_x0 + UI_PADDING;
  p_inv_y = p_y0 + UI_PADDING;
  p_top_y = p_inv_y + p_slot_size * 4.0 + 8.0 + 22.0;
}

Integer ui_slot_rect(Integer p_screen, Integer p_grid_width, Integer p_slot, Real p_w, Real p_h, Real &p_x, Real &p_y, Real &p_size)
// ----------------------------------------------------------------
// Bottom left corner (x, y) and size of a slot on a screen
// Returns FALSE if the slot isn't on that screen
// ----------------------------------------------------------------
{
  Real    l_x0     = 0.0;
  Real    l_y0     = 0.0;
  Real    l_x1     = 0.0;
  Real    l_y1     = 0.0;
  Real    l_inv_x  = 0.0;
  Real    l_inv_y  = 0.0;
  Real    l_top_y  = 0.0;
  Real    l_grid_x = 0.0;
  Real    l_grid_y = 0.0;
  Integer l_row    = 0;
  Integer l_column = 0;
  Integer l_cell   = 0;

  ui_layout(p_screen, p_w, p_h, p_size, l_x0, l_y0, l_x1, l_y1, l_inv_x, l_inv_y, l_top_y);

  if (p_slot >= 1 && p_slot <= HOTBAR_SLOTS) {
    p_x = l_inv_x + (p_slot - 1) * p_size;
    p_y = l_inv_y;
    return TRUE;
  }
  // Creative tabs: two slot-sized tabs just above the panel's top
  // left corner
  if (p_slot == UI_SLOT_TAB_INVENTORY || p_slot == UI_SLOT_TAB_CREATIVE) {
    if (p_screen != SCREEN_INVENTORY && p_screen != SCREEN_CREATIVE) return FALSE;
    p_x = l_x0 + (p_slot - UI_SLOT_TAB_INVENTORY) * (p_size + 4.0);
    p_y = l_y1 + 2.0;
    return TRUE;
  }

  if (p_screen == SCREEN_CREATIVE) {
    // the hotbar, then the item rows, then the search line with the
    // scroll buttons at its right
    if (p_slot > UI_SLOT_CREATIVE && p_slot <= UI_SLOT_CREATIVE + CREATIVE_SLOTS) {
      l_cell   = p_slot - UI_SLOT_CREATIVE - 1;
      l_row    = floor_divide(l_cell, 9);
      l_column = l_cell - l_row * 9;
      p_x = l_inv_x + l_column * p_size;
      p_y = l_inv_y + p_size + 8.0 + (CREATIVE_ROWS - 1 - l_row) * p_size;
      return TRUE;
    }
    if (p_slot == UI_SLOT_SCROLL_UP || p_slot == UI_SLOT_SCROLL_DOWN) {
      p_x = l_inv_x + (9 - 2 + p_slot - UI_SLOT_SCROLL_UP) * p_size;
      p_y = l_inv_y + p_size + 8.0 + CREATIVE_ROWS * p_size + 8.0;
      return TRUE;
    }
    return FALSE;
  }

  if (p_slot > HOTBAR_SLOTS && p_slot <= INVENTORY_SLOTS) {
    // 10..18 is the top row, 28..36 the bottom row
    l_row    = 3 - floor_divide(p_slot - 10, 9);
    l_column = positive_mod(p_slot - 10, 9);
    p_x = l_inv_x + l_column * p_size;
    p_y = l_inv_y + p_size + 8.0 + (l_row - 1) * p_size;
    return TRUE;
  }

  if (p_screen == SCREEN_INVENTORY) {
    // the armour column at the left (head at the top) and the
    // offhand at the bottom right of the player's picture
    if (p_slot > UI_SLOT_ARMOUR && p_slot <= UI_SLOT_ARMOUR + ARMOUR_PLACES) {
      p_x = l_inv_x;
      p_y = l_top_y + (UI_SLOT_ARMOUR + ARMOUR_PLACES - p_slot) * p_size;
      return TRUE;
    }
    if (p_slot == UI_SLOT_OFFHAND) {
      p_x = l_inv_x + p_size * 4.0;
      p_y = l_top_y;
      return TRUE;
    }
  }

  if (p_screen == SCREEN_INVENTORY || p_screen == SCREEN_CRAFTING) {
    // The grid, centred in the three slot rows above the inventory,
    // then an arrow and the output slot (on the inventory screen the
    // 2 x 2 grid is at the top right, beside the player)
    l_grid_x = l_inv_x + p_size * 1.5;
    l_grid_y = l_top_y + (3 - p_grid_width) * p_size * 0.5;
    if (p_screen == SCREEN_INVENTORY) {
      l_grid_x = l_inv_x + p_size * 5.0;
      l_grid_y = l_top_y + p_size * 2.0;
    }
    if (p_slot > UI_SLOT_GRID && p_slot <= UI_SLOT_GRID + GRID_SLOTS) {
      l_cell   = p_slot - UI_SLOT_GRID;
      l_column = positive_mod(l_cell - 1, 3) + 1;
      l_row    = floor_divide(l_cell - 1, 3) + 1;
      if (l_column > p_grid_width || l_row > p_grid_width) return FALSE;
      p_x = l_grid_x + (l_column - 1) * p_size;
      p_y = l_grid_y + (p_grid_width - l_row) * p_size;
      return TRUE;
    }
    if (p_slot == UI_SLOT_OUTPUT) {
      p_x = l_grid_x + p_grid_width * p_size + p_size * 1.9;
      p_y = l_top_y + p_size;
      if (p_screen == SCREEN_INVENTORY) {
        p_x = l_inv_x + p_size * 8.2;
        p_y = l_top_y + p_size * 2.5;
      }
      return TRUE;
    }
    return FALSE;
  }

  if (p_screen == SCREEN_CHEST) {
    // three rows of nine above the inventory, slot 1 at the top left
    if (p_slot > UI_SLOT_CHEST && p_slot <= UI_SLOT_CHEST + CHEST_SLOTS) {
      l_cell   = p_slot - UI_SLOT_CHEST - 1;
      l_row    = floor_divide(l_cell, 9);
      l_column = l_cell - l_row * 9;
      p_x = l_inv_x + l_column * p_size;
      p_y = l_top_y + (2 - l_row) * p_size;
      return TRUE;
    }
    return FALSE;
  }

  if (p_screen == SCREEN_FURNACE) {
    if (p_slot == UI_SLOT_FURNACE + FURNACE_SLOT_INPUT) {
      p_x = l_inv_x + p_size * 2.0;
      p_y = l_top_y + p_size * 2.0;
      return TRUE;
    }
    if (p_slot == UI_SLOT_FURNACE + FURNACE_SLOT_FUEL) {
      p_x = l_inv_x + p_size * 2.0;
      p_y = l_top_y;
      return TRUE;
    }
    if (p_slot == UI_SLOT_FURNACE + FURNACE_SLOT_OUTPUT) {
      p_x = l_inv_x + p_size * 5.6;
      p_y = l_top_y + p_size;
      return TRUE;
    }
  }
  return FALSE;
}

Integer ui_inventory_slot(Integer p_slot)
// ----------------------------------------------------------------
// Slot of the inventory record a screen slot shows (the hotbar, the
// main inventory, the armour and the offhand), 0 for other slots
// ----------------------------------------------------------------
{
  if (p_slot >= 1 && p_slot <= INVENTORY_SLOTS) return p_slot;
  if (p_slot > UI_SLOT_ARMOUR && p_slot <= UI_SLOT_ARMOUR + ARMOUR_PLACES) return inventory_armour_slot(p_slot - UI_SLOT_ARMOUR);
  if (p_slot == UI_SLOT_OFFHAND) return OFFHAND_SLOT;
  return 0;
}

Integer ui_slot_at(Integer p_screen, Integer p_grid_width, Real p_px, Real p_py, Real p_w, Real p_h)
// ----------------------------------------------------------------
// Slot under the point (px, py), 0 if none
// ----------------------------------------------------------------
{
  Integer l_slot = 0;
  Real    l_x    = 0.0;
  Real    l_y    = 0.0;
  Real    l_size = 0.0;

  for (l_slot = 1; l_slot <= UI_SLOT_LAST; ++l_slot) {
    if (!ui_slot_rect(p_screen, p_grid_width, l_slot, p_w, p_h, l_x, l_y, l_size)) continue;
    if (p_px >= l_x && p_px < l_x + l_size && p_py >= l_y && p_py < l_y + l_size) return l_slot;
  }
  return 0;
}

// ---------------------------------------------------------------- clicking

void ui_click(Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces,
              Attributes &p_book, Attributes &p_events, Real p_x, Real p_y, Integer p_right_button, Real p_w, Real p_h)
// ----------------------------------------------------------------
// A click on the open screen at (x, y)
// ----------------------------------------------------------------
{
  Integer l_screen    = ui_screen(p_ui);
  Integer l_furnace   = ui_furnace(p_ui);
  Integer l_slot      = ui_slot_at(l_screen, grid_width(p_grid), p_x, p_y, p_w, p_h);
  Integer l_target    = 0;
  Integer l_carried   = slot_item(p_inventory, CURSOR_SLOT);

  if (l_slot == 0) return;

  // Tabs: close this screen (which returns the grid and the carried
  // stack) and open the other
  if (l_slot == UI_SLOT_TAB_INVENTORY && l_screen == SCREEN_CREATIVE) {
    emit_simple_event(p_events, EVT_CLOSE_SCREEN);
    emit_event(p_events, EVT_OPEN_SCREEN, SCREEN_INVENTORY, 0, 0, 0, 0.0, 0.0, 0.0, "");
    return;
  }
  if (l_slot == UI_SLOT_TAB_CREATIVE && l_screen == SCREEN_INVENTORY) {
    emit_simple_event(p_events, EVT_CLOSE_SCREEN);
    emit_event(p_events, EVT_OPEN_SCREEN, SCREEN_CREATIVE, 0, 0, 0, 0.0, 0.0, 0.0, "");
    return;
  }
  if (l_slot == UI_SLOT_TAB_INVENTORY || l_slot == UI_SLOT_TAB_CREATIVE) return;
  if (l_slot == UI_SLOT_SCROLL_UP) {
    record_set_integer(p_ui, ATTR_UI_SCROLL, max_integer(0, record_integer(p_ui, ATTR_UI_SCROLL) - 1));
    return;
  }
  if (l_slot == UI_SLOT_SCROLL_DOWN) {
    record_set_integer(p_ui, ATTR_UI_SCROLL, min_integer(max_integer(0, ui_creative_rows(p_ui) - CREATIVE_ROWS),
                                                         record_integer(p_ui, ATTR_UI_SCROLL) + 1));
    return;
  }
  if (ui_inventory_slot(l_slot) > 0) {
    l_target = ui_inventory_slot(l_slot);
    // an armour slot only takes the piece worn there
    if (!inventory_fits_slot(l_carried, l_target)) return;
    if (p_right_button) {
      slot_click_right(p_inventory, p_inventory, l_target, FALSE);
    } else {
      slot_click_left(p_inventory, p_inventory, l_target, FALSE);
    }
    return;
  }

  if (l_slot > UI_SLOT_CREATIVE) {
    ui_creative_click(p_ui, p_inventory, l_slot - UI_SLOT_CREATIVE, p_right_button);
    return;
  }

  if (l_slot == UI_SLOT_OUTPUT) {
    crafting_take_output(p_book, p_grid, p_inventory, p_events);
    return;
  }

  if (l_slot > UI_SLOT_GRID && l_slot <= UI_SLOT_GRID + GRID_SLOTS) {
    l_target = l_slot - UI_SLOT_GRID;
    if (p_right_button) {
      slot_click_right(p_inventory, p_grid, l_target, FALSE);
    } else {
      slot_click_left(p_inventory, p_grid, l_target, FALSE);
    }
    return;
  }

  if (l_screen == SCREEN_CHEST && record_integer(p_ui, ATTR_UI_CHEST) > 0) {
    if (l_slot > UI_SLOT_CHEST && l_slot <= UI_SLOT_CHEST + CHEST_SLOTS) {
      l_target = chest_slot(record_integer(p_ui, ATTR_UI_CHEST), l_slot - UI_SLOT_CHEST);
      if (p_right_button) {
        slot_click_right(p_inventory, p_furnaces, l_target, FALSE);
      } else {
        slot_click_left(p_inventory, p_furnaces, l_target, FALSE);
      }
    }
    return;
  }

  if (l_screen == SCREEN_FURNACE && l_furnace > 0) {
    l_target = furnace_slot(l_furnace, l_slot - UI_SLOT_FURNACE);

    // Only fuel goes in the fuel slot
    if (l_slot == UI_SLOT_FURNACE + FURNACE_SLOT_FUEL && l_carried != ITEM_NONE && item_fuel_seconds(l_carried) == 0) {
      emit_toast(p_events, "Only wood and coal burn in the fuel slot");
      return;
    }

    if (p_right_button) {
      slot_click_right(p_inventory, p_furnaces, l_target, l_slot == UI_SLOT_FURNACE + FURNACE_SLOT_OUTPUT);
    } else {
      slot_click_left(p_inventory, p_furnaces, l_target, l_slot == UI_SLOT_FURNACE + FURNACE_SLOT_OUTPUT);
    }
  }
}

// ---------------------------------------------------------------- drawing

void ui_draw_arrow(Draw_Box p_box, Real p_x, Real p_y, Real p_length, Real p_size, Real p_progress)
// ----------------------------------------------------------------
// A right-pointing arrow centred vertically on y, filled white up to
// progress (0..1)
// ----------------------------------------------------------------
{
  render_set_colour(p_box, 128.0, 128.0, 132.0);
  render_fill_rect (p_box, p_x, p_y - p_size * 0.12, p_x + p_length, p_y + p_size * 0.12);
  g_icon_x[1] = p_x + p_length;               g_icon_y[1] = p_y - p_size * 0.3;
  g_icon_x[2] = p_x + p_length + p_size * 0.4;  g_icon_y[2] = p_y;
  g_icon_x[3] = p_x + p_length;               g_icon_y[3] = p_y + p_size * 0.3;
  Draw_polygon(p_box, 3, g_icon_x, g_icon_y);
  if (p_progress > 0.0) {
    render_set_colour(p_box, 255.0, 255.0, 255.0);
    render_fill_rect (p_box, p_x, p_y - p_size * 0.12, p_x + p_length * min_real(1.0, p_progress), p_y + p_size * 0.12);
  }
}

void ui_draw_furnace(Draw_Box p_box, Attributes &p_furnaces, Integer p_furnace, Real p_w, Real p_h)
// ----------------------------------------------------------------
// The furnace section: input above fuel, a flame showing the fuel
// left, an arrow showing cooking progress, and the output
// ----------------------------------------------------------------
{
  Real l_slot_size = 0.0;
  Real l_x0        = 0.0;
  Real l_y0        = 0.0;
  Real l_x1        = 0.0;
  Real l_y1        = 0.0;
  Real l_inv_x     = 0.0;
  Real l_inv_y     = 0.0;
  Real l_top_y     = 0.0;
  Real l_flame_x   = 0.0;
  Real l_flame_y   = 0.0;
  Real l_burn      = 0.0;
  Real l_total     = 0.0;
  Real l_progress  = 0.0;

  if (p_furnace == 0) return;

  ui_layout(SCREEN_FURNACE, p_w, p_h, l_slot_size, l_x0, l_y0, l_x1, l_y1, l_inv_x, l_inv_y, l_top_y);
  l_flame_x = l_inv_x + l_slot_size * 2.0;
  l_flame_y = l_top_y + l_slot_size * 1.2;

  l_total = furnace_burn_total(p_furnaces, p_furnace);
  if (l_total > 0.0) l_burn = clamp_real(furnace_burn_left(p_furnaces, p_furnace) / l_total, 0.0, 1.0);
  l_progress = clamp_real(furnace_progress(p_furnaces, p_furnace) / COOK_SECONDS, 0.0, 1.0);

  // Flame between the input and fuel slots
  render_set_colour(p_box, 128.0, 128.0, 132.0);
  render_fill_rect (p_box, l_flame_x + l_slot_size * 0.3, l_flame_y, l_flame_x + l_slot_size * 0.7, l_flame_y + l_slot_size * 0.5);
  if (l_burn > 0.0) {
    render_set_colour(p_box, 240.0, 140.0, 40.0);
    render_fill_rect (p_box, l_flame_x + l_slot_size * 0.3, l_flame_y, l_flame_x + l_slot_size * 0.7, l_flame_y + l_slot_size * 0.5 * l_burn);
    render_set_colour(p_box, 252.0, 214.0, 90.0);
    render_fill_rect (p_box, l_flame_x + l_slot_size * 0.4, l_flame_y, l_flame_x + l_slot_size * 0.6, l_flame_y + l_slot_size * 0.3 * l_burn);
  }

  ui_draw_arrow(p_box, l_inv_x + l_slot_size * 3.4, l_top_y + l_slot_size * 1.5, l_slot_size * 1.6, l_slot_size, l_progress);
}

void ui_draw_tab(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_slot, Integer p_screen, Integer p_hovered)
// ----------------------------------------------------------------
// A creative tab: a chest for your inventory, a grass block for
// every item; the open one is joined to the panel below it
// ----------------------------------------------------------------
{
  Integer l_open = (p_slot == UI_SLOT_TAB_INVENTORY && p_screen == SCREEN_INVENTORY) ||
                   (p_slot == UI_SLOT_TAB_CREATIVE  && p_screen == SCREEN_CREATIVE);
  Integer l_item = ITEM_CHEST;

  if (p_slot == UI_SLOT_TAB_CREATIVE) l_item = ITEM_GRASS;
  if (l_open) {
    render_set_colour(p_box, UI_PANEL_R, UI_PANEL_G, UI_PANEL_B);
    render_fill_rect (p_box, p_x, p_y - 4.0, p_x + p_size, p_y + p_size);
  } else {
    render_set_colour(p_box, UI_PANEL_R * 0.75, UI_PANEL_G * 0.75, UI_PANEL_B * 0.75);
    render_fill_rect (p_box, p_x, p_y, p_x + p_size, p_y + p_size);
  }
  render_set_colour(p_box, UI_FRAME_R, UI_FRAME_G, UI_FRAME_B);
  if (p_hovered) hud_frame(p_box, p_x, p_y, p_x + p_size, p_y + p_size);
  hud_draw_item_icon(p_box, l_item, p_x + p_size * 0.5, p_y + p_size * 0.5, p_size * 0.6, ICON_FULL);
}

void ui_draw_scroll(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_up, Integer p_hovered)
// ----------------------------------------------------------------
// A scroll button of the creative screen: a slot with a triangle
// ----------------------------------------------------------------
{
  Real l_cx = p_x + p_size * 0.5;
  Real l_cy = p_y + p_size * 0.5;
  Real l_d  = p_size * 0.25;

  hud_draw_slot_style(p_box, p_x, p_y, p_size, ITEM_NONE, 0, 0, p_hovered, SLOT_STYLE_LIGHT);
  render_set_colour(p_box, 70.0, 70.0, 76.0);
  if (p_up) {
    g_icon_x[1] = l_cx - l_d;  g_icon_y[1] = l_cy - l_d * 0.6;
    g_icon_x[2] = l_cx + l_d;  g_icon_y[2] = l_cy - l_d * 0.6;
    g_icon_x[3] = l_cx;        g_icon_y[3] = l_cy + l_d * 0.8;
  } else {
    g_icon_x[1] = l_cx - l_d;  g_icon_y[1] = l_cy + l_d * 0.6;
    g_icon_x[2] = l_cx + l_d;  g_icon_y[2] = l_cy + l_d * 0.6;
    g_icon_x[3] = l_cx;        g_icon_y[3] = l_cy - l_d * 0.8;
  }
  Draw_polygon(p_box, 3, g_icon_x, g_icon_y);
}

void ui_draw_search(Draw_Box p_box, Attributes &p_ui, Real p_x, Real p_y, Real p_width, Real p_size)
// ----------------------------------------------------------------
// The creative screen's search line with a magnifying glass, the
// typed text and a cursor bar
// ----------------------------------------------------------------
{
  Real l_height = p_size * 0.7;
  Real l_text_x = p_x + l_height + 4.0;
  Real l_cx     = p_x + l_height * 0.45;
  Real l_cy     = p_y + l_height * 0.55;
  Real l_r      = l_height * 0.22;

  render_set_colour(p_box, 40.0, 40.0, 44.0);
  render_fill_rect (p_box, p_x, p_y, p_x + p_width, p_y + l_height);
  render_set_colour(p_box, 220.0, 220.0, 224.0);
  render_line(p_box, l_cx - l_r, l_cy - l_r, l_cx + l_r, l_cy - l_r);
  render_line(p_box, l_cx + l_r, l_cy - l_r, l_cx + l_r, l_cy + l_r);
  render_line(p_box, l_cx + l_r, l_cy + l_r, l_cx - l_r, l_cy + l_r);
  render_line(p_box, l_cx - l_r, l_cy + l_r, l_cx - l_r, l_cy - l_r);
  render_line(p_box, l_cx + l_r, l_cy - l_r, l_cx + l_r * 2.4, l_cy - l_r * 2.4);
  hud_text(p_box, l_text_x, p_y + l_height * 0.85, l_height * 0.55, TEXT_ALIGN_LEFT, 240, 240, 240, ui_search(p_ui) + "_");
}

void ui_draw(Draw_Box p_box, Real p_w, Real p_h, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid,
             Attributes &p_furnaces, Attributes &p_book)
// ----------------------------------------------------------------
// Draw the open screen over the 3D view (which the controller draws
// first, darkened).
// ----------------------------------------------------------------
{
  Integer l_screen    = ui_screen(p_ui);
  Integer l_furnace   = ui_furnace(p_ui);
  Integer l_width     = grid_width(p_grid);
  Integer l_slot      = 0;
  Integer l_hovered   = 0;
  Integer l_item      = 0;
  Integer l_count     = 0;
  Integer l_damage    = 0;
  Integer l_recipe    = 0;
  Integer l_target    = 0;
  Integer l_carried   = slot_item(p_inventory, CURSOR_SLOT);
  Real    l_mouse_x   = 0.0;
  Real    l_mouse_y   = 0.0;
  Real    l_slot_size = 0.0;
  Real    l_x0        = 0.0;
  Real    l_y0        = 0.0;
  Real    l_x1        = 0.0;
  Real    l_y1        = 0.0;
  Real    l_inv_x     = 0.0;
  Real    l_inv_y     = 0.0;
  Real    l_top_y     = 0.0;
  Real    l_x         = 0.0;
  Real    l_y         = 0.0;
  Real    l_size      = 0.0;
  Text    l_name      = "";
  Integer l_tabs      = record_integer(p_ui, ATTR_UI_TABS) == TRUE;

  ui_mouse (p_ui, l_mouse_x, l_mouse_y);
  ui_layout(l_screen, p_w, p_h, l_slot_size, l_x0, l_y0, l_x1, l_y1, l_inv_x, l_inv_y, l_top_y);
  l_hovered = ui_slot_at(l_screen, l_width, l_mouse_x, l_mouse_y, p_w, p_h);
  l_recipe  = crafting_match(p_book, p_grid);

  render_set_colour(p_box, UI_PANEL_R, UI_PANEL_G, UI_PANEL_B);
  render_fill_rect (p_box, l_x0, l_y0, l_x1, l_y1);
  render_set_colour(p_box, UI_FRAME_R, UI_FRAME_G, UI_FRAME_B);
  hud_frame(p_box, l_x0, l_y0, l_x1, l_y1);

  for (l_slot = 1; l_slot <= UI_SLOT_LAST; ++l_slot) {
    if (!ui_slot_rect(l_screen, l_width, l_slot, p_w, p_h, l_x, l_y, l_size)) continue;
    l_item   = ITEM_NONE;
    l_count  = 0;
    l_damage = 0;
    if (l_slot == UI_SLOT_TAB_INVENTORY || l_slot == UI_SLOT_TAB_CREATIVE) {
      if (!l_tabs) continue;
      ui_draw_tab(p_box, l_x, l_y, l_size, l_slot, l_screen, l_slot == l_hovered);
      continue;
    }
    if (l_slot == UI_SLOT_SCROLL_UP || l_slot == UI_SLOT_SCROLL_DOWN) {
      if (ui_creative_rows(p_ui) > CREATIVE_ROWS) ui_draw_scroll(p_box, l_x, l_y, l_size, l_slot == UI_SLOT_SCROLL_UP, l_slot == l_hovered);
      continue;
    }
    if (ui_inventory_slot(l_slot) > 0) {
      l_target = ui_inventory_slot(l_slot);
      l_item   = slot_item  (p_inventory, l_target);
      l_count  = slot_count (p_inventory, l_target);
      l_damage = slot_damage(p_inventory, l_target);
    } else if (l_slot > UI_SLOT_CREATIVE) {
      l_item  = ui_creative_item(p_ui, l_slot - UI_SLOT_CREATIVE);
      l_count = 1;
    } else if (l_slot == UI_SLOT_OUTPUT) {
      if (l_recipe > 0) {
        l_item  = crafting_recipe_output(p_book, l_recipe);
        l_count = record_integer_at(p_book, ATTR_RECIPE_OUT_COUNT, l_recipe);
      }
    } else if (l_slot > UI_SLOT_GRID && l_slot <= UI_SLOT_GRID + GRID_SLOTS) {
      l_item   = slot_item  (p_grid, l_slot - UI_SLOT_GRID);
      l_count  = slot_count (p_grid, l_slot - UI_SLOT_GRID);
      l_damage = slot_damage(p_grid, l_slot - UI_SLOT_GRID);
    } else if (l_slot > UI_SLOT_CHEST && record_integer(p_ui, ATTR_UI_CHEST) > 0) {
      l_target = chest_slot(record_integer(p_ui, ATTR_UI_CHEST), l_slot - UI_SLOT_CHEST);
      l_item   = slot_item  (p_furnaces, l_target);
      l_count  = slot_count (p_furnaces, l_target);
      l_damage = slot_damage(p_furnaces, l_target);
    } else if (l_furnace > 0) {
      l_target = furnace_slot(l_furnace, l_slot - UI_SLOT_FURNACE);
      l_item   = slot_item  (p_furnaces, l_target);
      l_count  = slot_count (p_furnaces, l_target);
      l_damage = slot_damage(p_furnaces, l_target);
    }
    hud_draw_slot_style(p_box, l_x, l_y, l_size, l_item, l_count, l_damage, l_slot == l_hovered, SLOT_STYLE_LIGHT);
    if (l_slot == l_hovered && l_carried == ITEM_NONE) l_name = item_name(l_item);
  }

  // the player in the armour worn, between the armour and the grid
  if (l_screen == SCREEN_INVENTORY) {
    render_set_colour(p_box, 22.0, 22.0, 24.0);
    render_fill_rect (p_box, l_inv_x + l_slot_size * 1.15, l_top_y, l_inv_x + l_slot_size * 3.85, l_top_y + l_slot_size * 4.0);
    hud_draw_figure(p_box, l_inv_x + l_slot_size * 2.5, l_top_y + l_slot_size * 0.3, l_slot_size * 3.4 / 32.0,
                    slot_item(p_inventory, inventory_armour_slot(ARMOUR_HEAD)), slot_item(p_inventory, inventory_armour_slot(ARMOUR_CHEST)),
                    slot_item(p_inventory, inventory_armour_slot(ARMOUR_LEGS)), slot_item(p_inventory, inventory_armour_slot(ARMOUR_FEET)));
  }

  if (l_screen == SCREEN_FURNACE) {
    ui_draw_furnace(p_box, p_furnaces, l_furnace, p_w, p_h);
  } else if (l_screen == SCREEN_CHEST) {
    // nothing more to draw
  } else if (l_screen == SCREEN_CREATIVE) {
    ui_draw_search(p_box, p_ui, l_inv_x, l_inv_y + l_slot_size * (CREATIVE_ROWS + 1) + 16.0, l_slot_size * 6.8, l_slot_size);
  } else {
    // Arrow from the grid to the output slot
    if (ui_slot_rect(l_screen, l_width, UI_SLOT_OUTPUT, p_w, p_h, l_x, l_y, l_size)) {
      if (l_recipe > 0) {
        ui_draw_arrow(p_box, l_x - l_size * 1.5, l_y + l_size * 0.5, l_size * 0.9, l_size, 1.0);
      } else {
        ui_draw_arrow(p_box, l_x - l_size * 1.5, l_y + l_size * 0.5, l_size * 0.9, l_size, 0.0);
      }
    }
  }

  // Name of the item under the mouse
  if (l_name != "") hud_shadow_text(p_box, l_mouse_x + 14.0, l_mouse_y + 20.0, 13.0, TEXT_ALIGN_LEFT, 255, 255, 210, l_name);

  // The stack being carried follows the mouse
  if (l_carried != ITEM_NONE) {
    hud_draw_item_icon(p_box, l_carried, l_mouse_x, l_mouse_y, l_slot_size * 0.62, ICON_FULL);
    if (slot_count(p_inventory, CURSOR_SLOT) > 1) {
      hud_shadow_text(p_box, l_mouse_x + 6.0, l_mouse_y - 4.0, 12.0, TEXT_ALIGN_LEFT, 255, 255, 255, To_text(slot_count(p_inventory, CURSOR_SLOT)));
    }
  }
}

#endif
