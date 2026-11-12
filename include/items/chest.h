#ifndef CHEST_H_INCLUDED
#define CHEST_H_INCLUDED

#include "../core/config.h"
#include "../core/records.h"

// ----------------------------------------------------------------
// Chests: each placed chest holds CHEST_SLOTS stacks
//
// Chests live in the same block storage record as the furnaces
// (g_furnaces), which already reaches the screens, the event
// handlers and the save file. Chest c has the fields "chest_used_c",
// "chest_x_c", "chest_y_c" and "chest_z_c"; its slots are container
// slots (inventory.h) number chest_slot(c, n) of that record, from
// CHEST_SLOT_BASE up, well clear of the furnaces' slots.
// ----------------------------------------------------------------

#define MAX_CHESTS          32
#define CHEST_SLOTS         27
#define CHEST_SLOT_BASE     1000
#define ATTR_CHEST_USED     ("chest_used")
#define ATTR_CHEST_X        ("chest_x")
#define ATTR_CHEST_Y        ("chest_y")
#define ATTR_CHEST_Z        ("chest_z")

Integer chest_slot          (Integer p_chest, Integer p_which);
Integer chest_used          (Attributes &p_store, Integer p_chest);
Integer chest_find          (Attributes &p_store, Integer p_x, Integer p_y, Integer p_z);
Integer chest_get_or_create (Attributes &p_store, Integer p_x, Integer p_y, Integer p_z);
void    chest_remove        (Attributes &p_store, Attributes &p_events, Integer p_chest);
Integer chest_item_count    (Attributes &p_store, Integer p_chest);
void    chest_on_event      (Attributes &p_event, Attributes &p_store, Attributes &p_events);

#endif
