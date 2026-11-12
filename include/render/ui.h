#ifndef UI_H_INCLUDED
#define UI_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// Inventory, crafting table and furnace screens
// While a screen is open the mouse is free: slots are clicked to
// pick up / put down stacks. The inventory screen has a 2 x 2
// crafting grid, the crafting table a 3 x 3 one; clicking the
// output slot crafts.
//
// The UI record holds which screen is open ("screen"), the furnace
// being used ("furnace"), the block that opened it ("x", "y", "z")
// and where the mouse is ("mouse_x", "mouse_y").
//
// Slot numbers on screen: 1..36 the inventory, UI_SLOT_GRID + n
// grid slot n (1..9), UI_SLOT_OUTPUT the crafting result, and
// UI_SLOT_FURNACE + FURNACE_SLOT_* the furnace's slots and
// UI_SLOT_CHEST + n slot n of the open chest.
// ----------------------------------------------------------------

#define DATATYPE_UI             ("ui")
#define ATTR_UI_SCREEN          ("screen")
#define ATTR_UI_FURNACE         ("furnace")
#define ATTR_UI_CHEST           ("chest")
#define ATTR_UI_MOUSE_X         ("mouse_x")
#define ATTR_UI_MOUSE_Y         ("mouse_y")

#define UI_SLOT_GRID            40
#define UI_SLOT_OUTPUT          50
#define UI_SLOT_FURNACE         50   // + FURNACE_SLOT_INPUT .. FURNACE_SLOT_OUTPUT (51..53)
#define UI_SLOT_CHEST           60   // + 1 .. CHEST_SLOTS (61..87)
#define UI_SLOT_LAST            87
#define UI_PADDING              14.0
#define UI_TITLE_HEIGHT         30.0

void    ui_clear          (Attributes &p_ui);
Integer ui_screen         (Attributes &p_ui);
Integer ui_furnace        (Attributes &p_ui);
void    ui_mouse          (Attributes &p_ui, Real &p_x, Real &p_y);
void    ui_set_mouse      (Attributes &p_ui, Real p_x, Real p_y);
void    ui_open           (Attributes &p_ui, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_events,
                           Integer p_screen, Integer p_x, Integer p_y, Integer p_z);
void    ui_close          (Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_events,
                           Real p_drop_x, Real p_drop_y, Real p_drop_z);
void    ui_on_event       (Attributes &p_event, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid,
                           Attributes &p_furnaces, Attributes &p_events, Real p_drop_x, Real p_drop_y, Real p_drop_z);
void    ui_layout         (Integer p_screen, Real p_w, Real p_h, Real &p_slot_size, Real &p_x0, Real &p_y0, Real &p_x1, Real &p_y1,
                           Real &p_inv_x, Real &p_inv_y, Real &p_top_y);
Integer ui_slot_rect      (Integer p_screen, Integer p_grid_width, Integer p_slot, Real p_w, Real p_h, Real &p_x, Real &p_y, Real &p_size);
Integer ui_slot_at        (Integer p_screen, Integer p_grid_width, Real p_px, Real p_py, Real p_w, Real p_h);
void    ui_click          (Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces,
                           Attributes &p_book, Attributes &p_events, Real p_x, Real p_y, Integer p_right_button, Real p_w, Real p_h);
void    ui_draw_arrow     (Draw_Box p_box, Real p_x, Real p_y, Real p_length, Real p_size, Real p_progress);
void    ui_draw_furnace   (Draw_Box p_box, Attributes &p_furnaces, Integer p_furnace, Real p_w, Real p_h);
void    ui_draw           (Draw_Box p_box, Real p_w, Real p_h, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid,
                           Attributes &p_furnaces, Attributes &p_book);

#endif
