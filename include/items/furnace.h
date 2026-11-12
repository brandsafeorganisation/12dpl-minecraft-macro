#ifndef FURNACE_H_INCLUDED
#define FURNACE_H_INCLUDED

#include "../core/config.h"
#include "../core/records.h"

// ----------------------------------------------------------------
// Furnaces: each placed furnace has an input, fuel and output slot
// Burning fuel cooks one input item every COOK_SECONDS
// Furnaces keep working on real time, even while a screen is open
//
// All furnaces live in one record. Furnace f has the fields
// "used_f", "x_f", "y_f", "z_f", "burn_f", "burn_total_f" and
// "progress_f"; its three slots are container slots (inventory.h)
// number furnace_slot(f, FURNACE_SLOT_*) of the same record.
// ----------------------------------------------------------------

#define DATATYPE_FURNACES       ("furnaces")
#define ATTR_FURNACE_BURN       ("burn")
#define ATTR_FURNACE_BURN_TOTAL ("burn_total")
#define ATTR_FURNACE_PROGRESS   ("progress")
#define FURNACE_SLOT_INPUT      1
#define FURNACE_SLOT_FUEL       2
#define FURNACE_SLOT_OUTPUT     3
#define FURNACE_SLOTS           3

void    furnaces_clear        (Attributes &p_furnaces);
void    furnaces_rebuild_index(Attributes &p_furnaces);
void    furnace_set_used      (Attributes &p_furnaces, Integer p_furnace, Integer p_used);
Integer furnace_slot          (Integer p_furnace, Integer p_which);
Integer furnace_used          (Attributes &p_furnaces, Integer p_furnace);
void    furnace_cell          (Attributes &p_furnaces, Integer p_furnace, Integer &p_x, Integer &p_y, Integer &p_z);
Real    furnace_burn_left     (Attributes &p_furnaces, Integer p_furnace);
Real    furnace_burn_total    (Attributes &p_furnaces, Integer p_furnace);
Real    furnace_progress      (Attributes &p_furnaces, Integer p_furnace);
void    furnace_set_state     (Attributes &p_furnaces, Integer p_furnace, Real p_burn_left, Real p_burn_total, Real p_progress);
Integer furnace_find          (Attributes &p_furnaces, Integer p_x, Integer p_y, Integer p_z);
Integer furnace_get_or_create (Attributes &p_furnaces, Integer p_x, Integer p_y, Integer p_z);
void    furnace_remove        (Attributes &p_furnaces, Attributes &p_events, Integer p_furnace);
Integer furnace_can_cook      (Attributes &p_furnaces, Integer p_furnace);
void    furnace_step          (Attributes &p_furnaces, Integer p_furnace, Real p_dt);
void    furnaces_update      (Attributes &p_furnaces, Attributes &p_events, Real p_dt);
void    furnace_on_event      (Attributes &p_event, Attributes &p_furnaces, Attributes &p_events);

#endif
