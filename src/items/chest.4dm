#ifndef CHEST_4DM_INCLUDED
#define CHEST_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/items/inventory.h"
#include "../../include/items/chest.h"

Integer chest_slot(Integer p_chest, Integer p_which)
// ----------------------------------------------------------------
// Container slot number of slot p_which (1..CHEST_SLOTS) of a chest
// ----------------------------------------------------------------
{
  return CHEST_SLOT_BASE + (p_chest - 1) * CHEST_SLOTS + p_which;
}

Integer chest_used(Attributes &p_store, Integer p_chest)
// ----------------------------------------------------------------
// TRUE if chest number p_chest exists
// ----------------------------------------------------------------
{
  if (p_chest < 1 || p_chest > MAX_CHESTS) return FALSE;
  return record_integer_at(p_store, ATTR_CHEST_USED, p_chest);
}

Integer chest_find(Attributes &p_store, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Number of the chest at a cell, 0 if there isn't one
// ----------------------------------------------------------------
{
  Integer l_chest = 0;

  for (l_chest = 1; l_chest <= MAX_CHESTS; ++l_chest) {
    if (!chest_used(p_store, l_chest)) continue;
    if (record_integer_at(p_store, ATTR_CHEST_X, l_chest) != p_x) continue;
    if (record_integer_at(p_store, ATTR_CHEST_Y, l_chest) != p_y) continue;
    if (record_integer_at(p_store, ATTR_CHEST_Z, l_chest) != p_z) continue;
    return l_chest;
  }
  return 0;
}

Integer chest_get_or_create(Attributes &p_store, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Number of the chest at a cell, making an empty one if needed
// Returns 0 if every chest number is taken
// ----------------------------------------------------------------
{
  Integer l_chest = chest_find(p_store, p_x, p_y, p_z);
  Integer l_which = 0;

  if (l_chest > 0) return l_chest;

  for (l_chest = 1; l_chest <= MAX_CHESTS; ++l_chest) {
    if (chest_used(p_store, l_chest)) continue;
    record_set_integer_at(p_store, ATTR_CHEST_USED, l_chest, TRUE);
    record_set_integer_at(p_store, ATTR_CHEST_X,    l_chest, p_x);
    record_set_integer_at(p_store, ATTR_CHEST_Y,    l_chest, p_y);
    record_set_integer_at(p_store, ATTR_CHEST_Z,    l_chest, p_z);
    for (l_which = 1; l_which <= CHEST_SLOTS; ++l_which) slot_clear(p_store, chest_slot(l_chest, l_which));
    return l_chest;
  }
  return 0;
}

Integer chest_item_count(Attributes &p_store, Integer p_chest)
// ----------------------------------------------------------------
// How many items a chest holds in total
// ----------------------------------------------------------------
{
  Integer l_which = 0;
  Integer l_total = 0;

  if (!chest_used(p_store, p_chest)) return 0;
  for (l_which = 1; l_which <= CHEST_SLOTS; ++l_which) l_total = l_total + slot_count(p_store, chest_slot(p_chest, l_which));
  return l_total;
}

void chest_remove(Attributes &p_store, Attributes &p_events, Integer p_chest)
// ----------------------------------------------------------------
// The chest block is gone: spill its contents and free it
// ----------------------------------------------------------------
{
  Integer l_which = 0;
  Integer l_slot  = 0;
  Integer l_x     = 0;
  Integer l_y     = 0;
  Integer l_z     = 0;

  if (!chest_used(p_store, p_chest)) return;

  l_x = record_integer_at(p_store, ATTR_CHEST_X, p_chest);
  l_y = record_integer_at(p_store, ATTR_CHEST_Y, p_chest);
  l_z = record_integer_at(p_store, ATTR_CHEST_Z, p_chest);
  for (l_which = 1; l_which <= CHEST_SLOTS; ++l_which) {
    l_slot = chest_slot(p_chest, l_which);
    if (!slot_is_empty(p_store, l_slot)) {
      emit_drop_event(p_events, slot_item(p_store, l_slot), slot_count(p_store, l_slot), slot_damage(p_store, l_slot), l_x + 0.5, l_y + 0.5, l_z + 0.5);
    }
    slot_clear(p_store, l_slot);
  }
  record_set_integer_at(p_store, ATTR_CHEST_USED, p_chest, FALSE);
}

void chest_on_event(Attributes &p_event, Attributes &p_store, Attributes &p_events)
// ----------------------------------------------------------------
// Event handler: chests appear and disappear with their blocks
// ----------------------------------------------------------------
{
  Integer l_type  = event_type(p_event);
  Integer l_x     = event_integer(p_event, 1);
  Integer l_y     = event_integer(p_event, 2);
  Integer l_z     = event_integer(p_event, 3);
  Integer l_block = event_integer(p_event, 4);

  if (l_block != BLOCK_CHEST) return;

  if (l_type == EVT_BLOCK_PLACED) {
    chest_get_or_create(p_store, l_x, l_y, l_z);
  } else if (l_type == EVT_BLOCK_BROKEN) {
    chest_remove(p_store, p_events, chest_find(p_store, l_x, l_y, l_z));
  }
}

#endif
