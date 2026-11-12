#ifndef SLOTS_H_INCLUDED
#define SLOTS_H_INCLUDED

#include "records.h"

// ----------------------------------------------------------------
// Slot index: which numbered slots of a record are in use
//
// Mobs, drops and furnaces live in records of numbered slots, and
// "used_n" says whether slot n holds anything. Asking a record is an
// Attributes call, which is slow in 12dPL, and the per-frame loops
// used to ask every slot (24 mobs, 128 drops) every frame.
//
// Instead each pool keeps a list of its used slots here, in slot
// order. The owning module tells the index when a slot is taken or
// freed (slots_set) as the same step that writes "used_n", and loops
// go through the list. The record stays the saved copy: after a
// world is loaded, slots_rebuild reads the "used_n" fields once.
//
// Table functions: everything here reads or writes the g_slot_*
// tables, which belong to this module.
// ----------------------------------------------------------------

#define SLOT_POOL_MOBS       1
#define SLOT_POOL_DROPS      2
#define SLOT_POOL_FURNACES   3
#define SLOT_POOLS           3
#define SLOT_CAPACITY        128     // largest pool (MAX_DROPS)
#define SLOT_TABLE_SIZE      384     // SLOT_POOLS * SLOT_CAPACITY

/*Global variables*/ {
  Integer g_slot_used [SLOT_TABLE_SIZE];   // 1 if slot n of pool p is used, at (p - 1) * SLOT_CAPACITY + n
  Integer g_slot_list [SLOT_TABLE_SIZE];   // used slot numbers of pool p in order, from (p - 1) * SLOT_CAPACITY + 1
  Integer g_slot_count[SLOT_POOLS];
}

void    slots_reset   (Integer p_pool);
void    slots_set     (Integer p_pool, Integer p_slot, Integer p_used);
Integer slots_used    (Integer p_pool, Integer p_slot);
Integer slots_count   (Integer p_pool);
Integer slots_at      (Integer p_pool, Integer p_position);
void    slots_rebuild (Integer p_pool, Attributes &p_record, Integer p_capacity);

#endif
