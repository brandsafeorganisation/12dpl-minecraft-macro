#ifndef SLOTS_4DM_INCLUDED
#define SLOTS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/records.h"
#include "../../include/core/slots.h"

void slots_reset(Integer p_pool)
// ----------------------------------------------------------------
// Mark every slot of a pool free
// ----------------------------------------------------------------
{
  Integer l_slot = 0;
  Integer l_base = (p_pool - 1) * SLOT_CAPACITY;

  for (l_slot = 1; l_slot <= SLOT_CAPACITY; ++l_slot) g_slot_used[l_base + l_slot] = FALSE;
  g_slot_count[p_pool] = 0;
}

void slots_set(Integer p_pool, Integer p_slot, Integer p_used)
// ----------------------------------------------------------------
// A slot was taken (used TRUE) or freed: add it to the list in slot
// order, or take it out
// ----------------------------------------------------------------
{
  Integer l_base     = (p_pool - 1) * SLOT_CAPACITY;
  Integer l_count    = g_slot_count[p_pool];
  Integer l_position = 0;
  Integer l_at       = 0;
  Integer l_used     = FALSE;

  if (p_slot < 1 || p_slot > SLOT_CAPACITY) return;
  if (p_used) l_used = TRUE;
  if (g_slot_used[l_base + p_slot] == l_used) return;
  g_slot_used[l_base + p_slot] = l_used;

  if (l_used) {
    // shift the larger slot numbers up one place (no short-circuit
    // && in 12dPL, so the test of the slot before is inside)
    l_at = l_count + 1;
    while (l_at > 1) {
      if (g_slot_list[l_base + l_at - 1] < p_slot) break;
      g_slot_list[l_base + l_at] = g_slot_list[l_base + l_at - 1];
      --l_at;
    }
    g_slot_list[l_base + l_at] = p_slot;
    g_slot_count[p_pool] = l_count + 1;
    return;
  }

  // shift the ones after it down one place
  for (l_position = 1; l_position <= l_count; ++l_position) {
    if (g_slot_list[l_base + l_position] == p_slot) l_at = l_position;
  }
  if (l_at == 0) return;
  for (l_position = l_at; l_position < l_count; ++l_position) g_slot_list[l_base + l_position] = g_slot_list[l_base + l_position + 1];
  g_slot_count[p_pool] = l_count - 1;
}

Integer slots_used(Integer p_pool, Integer p_slot)
// ----------------------------------------------------------------
// TRUE if a slot of a pool is in use
// ----------------------------------------------------------------
{
  if (p_slot < 1 || p_slot > SLOT_CAPACITY) return FALSE;
  return g_slot_used[(p_pool - 1) * SLOT_CAPACITY + p_slot];
}

Integer slots_count(Integer p_pool)
// ----------------------------------------------------------------
// Number of used slots of a pool
// ----------------------------------------------------------------
{
  return g_slot_count[p_pool];
}

Integer slots_at(Integer p_pool, Integer p_position)
// ----------------------------------------------------------------
// The position'th used slot of a pool (1 .. slots_count), lowest
// slot number first
// ----------------------------------------------------------------
{
  return g_slot_list[(p_pool - 1) * SLOT_CAPACITY + p_position];
}

void slots_rebuild(Integer p_pool, Attributes &p_record, Integer p_capacity)
// ----------------------------------------------------------------
// Fill a pool's list from the "used_n" fields of its record, for
// slots 1 .. capacity (after loading a world)
// ----------------------------------------------------------------
{
  Integer l_slot = 0;

  slots_reset(p_pool);
  for (l_slot = 1; l_slot <= p_capacity; ++l_slot) {
    if (record_integer_at(p_record, ATTR_USED, l_slot)) slots_set(p_pool, l_slot, TRUE);
  }
}

#endif
