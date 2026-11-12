#ifndef EVENTS_H_INCLUDED
#define EVENTS_H_INCLUDED

#include "config.h"
#include "records.h"

// ----------------------------------------------------------------
// Game event queue
// Modules never call each other to report what happened, they emit
// an event instead. game_dispatch_events() takes each event off the
// queue into an event record and hands it to every module's
// *_on_event() handler. The queue and the event are both records
// (see records.h): the queue keeps entry n in fields "type_n",
// "i1_n", ... and the event has fields "type", "i1", ... "text".
// ----------------------------------------------------------------

#define EVENT_QUEUE_SIZE      512

// Event types and their payloads
#define EVT_NONE              0
#define EVT_BLOCK_BROKEN      1    // i1..i3 cell, i4 block that was there, r1 tool item used
#define EVT_BLOCK_PLACED      2    // i1..i3 cell, i4 new block
#define EVT_COW_HURT          3    // i1 cow
#define EVT_COW_KILLED        4    // i1 cow, r1..r3 position
#define EVT_ITEM_PICKED_UP    5    // i1 item, i2 count
#define EVT_PLAYER_HURT       6    // i1 amount
#define EVT_PLAYER_DIED       7
#define EVT_PLAYER_ATE        8    // i1 item, i2 health gained
#define EVT_OPEN_SCREEN       9    // i1 screen, i2..i4 cell of the block used
#define EVT_CLOSE_SCREEN      10
#define EVT_TOAST             11   // text
#define EVT_ITEM_CRAFTED      12   // i1 item, i2 count
#define EVT_SPAWN_DROP        13   // i1 item, i2 count, i3 tool wear, r1..r3 position
#define EVT_WORLD_SAVED       14   // text world name
#define EVT_PLAYER_RESPAWNED  15
#define EVT_SLEEP             16   // i1..i3 cell of the bed used
#define EVT_ZOMBIE_ATTACK     17   // i1 damage (a zombie hit the player)
#define EVT_LIGHT_CHANGED     18   // i1..i3 cell: block light may have changed up to LIGHT_RADIUS from it
#define EVT_FURNACE_LIT       19   // i1..i3 cell of a furnace, i4 TRUE if it started burning, FALSE if it went out

// Screens that EVT_OPEN_SCREEN can open
#define SCREEN_NONE           0
#define SCREEN_INVENTORY      1
#define SCREEN_CRAFTING       2
#define SCREEN_FURNACE        3
#define SCREEN_CHEST          4

#define DATATYPE_EVENT_QUEUE  ("event_queue")
#define DATATYPE_EVENT        ("event")
#define ATTR_EVENT_HEAD       ("head")
#define ATTR_EVENT_LOST       ("lost")
#define ATTR_EVENT_I1         ("i1")
#define ATTR_EVENT_I2         ("i2")
#define ATTR_EVENT_I3         ("i3")
#define ATTR_EVENT_I4         ("i4")
#define ATTR_EVENT_R1         ("r1")
#define ATTR_EVENT_R2         ("r2")
#define ATTR_EVENT_R3         ("r3")

void    events_clear     (Attributes &p_events);
void    emit_event       (Attributes &p_events, Integer p_type, Integer p_i1, Integer p_i2, Integer p_i3, Integer p_i4, Real p_r1, Real p_r2, Real p_r3, Text p_text);
void    emit_simple_event(Attributes &p_events, Integer p_type);
void    emit_cell_event  (Attributes &p_events, Integer p_type, Integer p_x, Integer p_y, Integer p_z, Integer p_block);
void    emit_item_event  (Attributes &p_events, Integer p_type, Integer p_item, Integer p_count);
void    emit_drop_event  (Attributes &p_events, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z);
void    emit_toast       (Attributes &p_events, Text p_text);
Integer events_pending   (Attributes &p_events);
Integer next_event       (Attributes &p_events, Attributes &p_event);
Integer event_type       (Attributes &p_event);
Integer event_integer    (Attributes &p_event, Integer p_which);
Real    event_real       (Attributes &p_event, Integer p_which);
Text    event_text       (Attributes &p_event);

#endif
