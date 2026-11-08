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
  ui_set_mouse(p_ui, -1000.0, -1000.0);
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
  if (p_slot > HOTBAR_SLOTS && p_slot <= INVENTORY_SLOTS) {
    // 10..18 is the top row, 28..36 the bottom row
    l_row    = 3 - floor_divide(p_slot - 10, 9);
    l_column = positive_mod(p_slot - 10, 9);
    p_x = l_inv_x + l_column * p_size;
    p_y = l_inv_y + p_size + 8.0 + (l_row - 1) * p_size;
    return TRUE;
  }

  if (p_screen == SCREEN_INVENTORY || p_screen == SCREEN_CRAFTING) {
    // The grid, centred in the three slot rows above the inventory,
    // then an arrow and the output slot
    l_grid_x = l_inv_x + p_size * 1.5;
    l_grid_y = l_top_y + (3 - p_grid_width) * p_size * 0.5;
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

  if (l_slot <= INVENTORY_SLOTS) {
    if (p_right_button) {
      slot_click_right(p_inventory, p_inventory, l_slot, FALSE);
    } else {
      slot_click_left(p_inventory, p_inventory, l_slot, FALSE);
    }
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

void ui_draw(Draw_Box p_box, Real p_w, Real p_h, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid,
             Attributes &p_furnaces, Attributes &p_book)
// ----------------------------------------------------------------
// Draw the open screen. The 3D view isn't drawn behind it, which
// keeps the screen quick to redraw as the mouse moves.
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

  ui_mouse (p_ui, l_mouse_x, l_mouse_y);
  ui_layout(l_screen, p_w, p_h, l_slot_size, l_x0, l_y0, l_x1, l_y1, l_inv_x, l_inv_y, l_top_y);
  l_hovered = ui_slot_at(l_screen, l_width, l_mouse_x, l_mouse_y, p_w, p_h);
  l_recipe  = crafting_match(p_book, p_grid);

  render_set_colour(p_box, UI_BACKDROP_R, UI_BACKDROP_G, UI_BACKDROP_B);
  render_fill_rect (p_box, 0.0, STATUS_STRIP_HEIGHT, p_w, p_h);

  render_set_colour(p_box, UI_PANEL_R, UI_PANEL_G, UI_PANEL_B);
  render_fill_rect (p_box, l_x0, l_y0, l_x1, l_y1);
  render_set_colour(p_box, UI_FRAME_R, UI_FRAME_G, UI_FRAME_B);
  hud_frame(p_box, l_x0, l_y0, l_x1, l_y1);

  for (l_slot = 1; l_slot <= UI_SLOT_LAST; ++l_slot) {
    if (!ui_slot_rect(l_screen, l_width, l_slot, p_w, p_h, l_x, l_y, l_size)) continue;
    l_item   = ITEM_NONE;
    l_count  = 0;
    l_damage = 0;
    if (l_slot <= INVENTORY_SLOTS) {
      l_item   = slot_item  (p_inventory, l_slot);
      l_count  = slot_count (p_inventory, l_slot);
      l_damage = slot_damage(p_inventory, l_slot);
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

  if (l_screen == SCREEN_FURNACE) {
    ui_draw_furnace(p_box, p_furnaces, l_furnace, p_w, p_h);
  } else if (l_screen == SCREEN_CHEST) {
    // nothing more to draw
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
