#ifndef DROPS_H_INCLUDED
#define DROPS_H_INCLUDED

#include "../core/config.h"
#include "../core/records.h"

// ----------------------------------------------------------------
// Items lying in the world, waiting to be picked up
//
// All drops live in one record. Drop d has the fields "used_d",
// "item_d", "count_d", "damage_d" (tool wear), "x_d", "y_d", "z_d",
// "vx_d", "vy_d", "vz_d" and "age_d". Which numbers are in use is also
// kept in the slot index (slots.h), written through drop_set_used.
// ----------------------------------------------------------------

#define DROP_PICKUP_DELAY     0.5
#define DROP_PICKUP_DISTANCE  1.6
#define DROP_PULL_DISTANCE    2.6
#define DATATYPE_DROPS        ("drops")

void    drops_clear    (Attributes &p_drops);
void    drops_rebuild_index(Attributes &p_drops);
void    drop_set_used  (Attributes &p_drops, Integer p_drop, Integer p_used);
Integer drop_used      (Attributes &p_drops, Integer p_drop);
Integer drop_item      (Attributes &p_drops, Integer p_drop);
Integer drop_count     (Attributes &p_drops, Integer p_drop);
Integer drop_damage    (Attributes &p_drops, Integer p_drop);
Real    drop_age       (Attributes &p_drops, Integer p_drop);
void    drop_position  (Attributes &p_drops, Integer p_drop, Real &p_x, Real &p_y, Real &p_z);
Integer drops_spawn    (Attributes &p_drops, Attributes &p_random, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z);
Integer drops_restore  (Attributes &p_drops, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z, Real p_age);
void    drops_update   (Attributes &p_drops, Attributes &p_inventory, Attributes &p_events,
                        Real p_player_x, Real p_player_y, Real p_player_z, Integer p_player_dead, Real p_dt);
void    drops_on_event (Attributes &p_event, Attributes &p_drops, Attributes &p_random);

#endif
