#ifndef INVENTORY_H_INCLUDED
#define INVENTORY_H_INCLUDED

#include "../core/config.h"
#include "../core/records.h"

// ----------------------------------------------------------------
// Containers: records with numbered slots
// Slot n of a container record has the fields "item_n", "count_n"
// and "damage_n" (how worn a tool is). The same functions work on
// the player's inventory, a crafting grid and the furnaces.
//
// The inventory record: slots 1..9 are the hotbar, 10..36 the 9 x 3
// main inventory and slot CURSOR_SLOT (0) is the stack the mouse
// is carrying while a screen is open.
// ----------------------------------------------------------------

#define DATATYPE_INVENTORY   ("inventory")
#define ATTR_DAMAGE          ("damage")
#define CURSOR_SLOT          0

// ---------------------------------------------------------------- slots
Integer slot_item            (Attributes &p_container, Integer p_slot);
Integer slot_count           (Attributes &p_container, Integer p_slot);
Integer slot_damage          (Attributes &p_container, Integer p_slot);
Integer slot_is_empty        (Attributes &p_container, Integer p_slot);
void    slot_set             (Attributes &p_container, Integer p_slot, Integer p_item, Integer p_count, Integer p_damage);
void    slot_clear           (Attributes &p_container, Integer p_slot);
void    slot_swap            (Attributes &p_container, Integer p_slot_a, Integer p_slot_b);
void    slot_take_one        (Attributes &p_container, Integer p_slot);
Integer slot_wear            (Attributes &p_container, Integer p_slot);
void    slot_click_left      (Attributes &p_holder, Attributes &p_container, Integer p_slot, Integer p_take_only);
void    slot_click_right     (Attributes &p_holder, Attributes &p_container, Integer p_slot, Integer p_take_only);
void    slot_move_all        (Attributes &p_from, Integer p_from_slot, Attributes &p_to, Integer p_first, Integer p_last);

// ---------------------------------------------------------------- containers
void    container_clear      (Attributes &p_container, Text p_datatype, Integer p_first, Integer p_last);
Integer container_add        (Attributes &p_container, Integer p_first, Integer p_last, Integer p_item, Integer p_count, Integer p_damage);
Integer container_count_item (Attributes &p_container, Integer p_first, Integer p_last, Integer p_item);
Integer container_remove_item(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item, Integer p_count);

// ---------------------------------------------------------------- the player's inventory
void    inventory_clear      (Attributes &p_inventory);
Integer inventory_add        (Attributes &p_inventory, Integer p_item, Integer p_count);
Integer inventory_add_worn   (Attributes &p_inventory, Integer p_item, Integer p_count, Integer p_damage);
Integer inventory_count_item (Attributes &p_inventory, Integer p_item);
Integer inventory_remove_item(Attributes &p_inventory, Integer p_item, Integer p_count);
void    inventory_return_cursor(Attributes &p_inventory, Attributes &p_events, Real p_x, Real p_y, Real p_z);

#endif
