#ifndef INVENTORY_4DM_INCLUDED
#define INVENTORY_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/blocks/blocks.h"
#include "../../include/core/events.h"
#include "../../include/items/inventory.h"

// ---------------------------------------------------------------- slots

Integer slot_item(Attributes &p_container, Integer p_slot)
// ----------------------------------------------------------------
// Item in a slot, ITEM_NONE if it is empty
// ----------------------------------------------------------------
{
  return record_integer_at(p_container, ATTR_ITEM, p_slot);
}

Integer slot_count(Attributes &p_container, Integer p_slot)
// ----------------------------------------------------------------
// Number of items in a slot
// ----------------------------------------------------------------
{
  return record_integer_at(p_container, ATTR_COUNT, p_slot);
}

Integer slot_damage(Attributes &p_container, Integer p_slot)
// ----------------------------------------------------------------
// How many uses the tool in a slot has had
// ----------------------------------------------------------------
{
  return record_integer_at(p_container, ATTR_DAMAGE, p_slot);
}

Integer slot_is_empty(Attributes &p_container, Integer p_slot)
// ----------------------------------------------------------------
// TRUE if nothing is in a slot
// ----------------------------------------------------------------
{
  if (slot_item(p_container, p_slot) == ITEM_NONE) return TRUE;
  if (slot_count(p_container, p_slot) <= 0) return TRUE;
  return FALSE;
}

void slot_set(Attributes &p_container, Integer p_slot, Integer p_item, Integer p_count, Integer p_damage)
// ----------------------------------------------------------------
// Put a stack into a slot; a count of 0 or less empties it
// ----------------------------------------------------------------
{
  Integer l_stored_item   = p_item;
  Integer l_stored_count  = p_count;
  Integer l_stored_damage = p_damage;

  if (p_item == ITEM_NONE || p_count <= 0) {
    l_stored_item   = ITEM_NONE;
    l_stored_count  = 0;
    l_stored_damage = 0;
  }
  record_set_integer_at(p_container, ATTR_ITEM,   p_slot, l_stored_item);
  record_set_integer_at(p_container, ATTR_COUNT,  p_slot, l_stored_count);
  record_set_integer_at(p_container, ATTR_DAMAGE, p_slot, l_stored_damage);
}

void slot_clear(Attributes &p_container, Integer p_slot)
// ----------------------------------------------------------------
// Empty a slot
// ----------------------------------------------------------------
{
  slot_set(p_container, p_slot, ITEM_NONE, 0, 0);
}

void slot_swap(Attributes &p_container, Integer p_slot_a, Integer p_slot_b)
// ----------------------------------------------------------------
// Exchange the contents of two slots of a container
// ----------------------------------------------------------------
{
  Integer l_item   = slot_item  (p_container, p_slot_a);
  Integer l_count  = slot_count (p_container, p_slot_a);
  Integer l_damage = slot_damage(p_container, p_slot_a);

  slot_set(p_container, p_slot_a, slot_item(p_container, p_slot_b), slot_count(p_container, p_slot_b), slot_damage(p_container, p_slot_b));
  slot_set(p_container, p_slot_b, l_item, l_count, l_damage);
}

void slot_take_one(Attributes &p_container, Integer p_slot)
// ----------------------------------------------------------------
// Use up one item from a slot (placing a block, eating)
// ----------------------------------------------------------------
{
  slot_set(p_container, p_slot, slot_item(p_container, p_slot), slot_count(p_container, p_slot) - 1, slot_damage(p_container, p_slot));
}

Integer slot_wear(Attributes &p_container, Integer p_slot)
// ----------------------------------------------------------------
// Use a tool in a slot once. Returns TRUE if that wore it out (the
// slot is then empty). Items that don't wear are left alone.
// ----------------------------------------------------------------
{
  Integer l_item   = slot_item(p_container, p_slot);
  Integer l_uses   = item_max_uses(l_item);
  Integer l_damage = slot_damage(p_container, p_slot) + 1;

  if (l_uses <= 0) return FALSE;

  if (l_damage >= l_uses) {
    slot_clear(p_container, p_slot);
    return TRUE;
  }
  record_set_integer_at(p_container, ATTR_DAMAGE, p_slot, l_damage);

  return FALSE;
}

void slot_click_left(Attributes &p_holder, Attributes &p_container, Integer p_slot, Integer p_take_only)
// ----------------------------------------------------------------
// Left click on a slot of container while holder's cursor slot
// holds what the mouse carries:
//  - empty cursor: pick the whole stack up
//  - same item:    drop as much of the cursor in as fits
//  - otherwise:    swap the cursor and the slot
// take_only slots (outputs) can only be emptied, and only into an
// empty or matching cursor
// ----------------------------------------------------------------
{
  Integer l_cursor_item   = slot_item  (p_holder, CURSOR_SLOT);
  Integer l_cursor_count  = slot_count (p_holder, CURSOR_SLOT);
  Integer l_cursor_damage = slot_damage(p_holder, CURSOR_SLOT);
  Integer l_item          = slot_item  (p_container, p_slot);
  Integer l_count         = slot_count (p_container, p_slot);
  Integer l_damage        = slot_damage(p_container, p_slot);
  Integer l_limit         = item_max_stack(l_item);
  Integer l_moved         = 0;

  if (p_take_only) {
    if (l_item == ITEM_NONE) return;
    if (l_cursor_item == ITEM_NONE) {
      slot_set  (p_holder, CURSOR_SLOT, l_item, l_count, l_damage);
      slot_clear(p_container, p_slot);
    } else if (l_cursor_item == l_item) {
      l_moved = l_limit - l_cursor_count;
      if (l_moved > l_count) l_moved = l_count;
      if (l_moved <= 0) return;
      slot_set(p_holder,    CURSOR_SLOT, l_item, l_cursor_count + l_moved, l_cursor_damage);
      slot_set(p_container, p_slot,        l_item, l_count - l_moved,        l_damage);
    }
    return;
  }

  if (l_cursor_item != ITEM_NONE && l_cursor_item == l_item && l_limit > 1) {
    l_moved = l_limit - l_count;
    if (l_moved > l_cursor_count) l_moved = l_cursor_count;
    slot_set(p_container, p_slot,        l_item, l_count + l_moved,        l_damage);
    slot_set(p_holder,    CURSOR_SLOT, l_item, l_cursor_count - l_moved, l_cursor_damage);
    return;
  }

  slot_set(p_container, p_slot,        l_cursor_item, l_cursor_count, l_cursor_damage);
  slot_set(p_holder,    CURSOR_SLOT, l_item,        l_count,        l_damage);
}

void slot_click_right(Attributes &p_holder, Attributes &p_container, Integer p_slot, Integer p_take_only)
// ----------------------------------------------------------------
// Right click on a slot of container:
//  - empty cursor: pick up half the stack (rounded up)
//  - otherwise:    put one item from the cursor into the slot
// ----------------------------------------------------------------
{
  Integer l_cursor_item   = slot_item  (p_holder, CURSOR_SLOT);
  Integer l_cursor_count  = slot_count (p_holder, CURSOR_SLOT);
  Integer l_cursor_damage = slot_damage(p_holder, CURSOR_SLOT);
  Integer l_item          = slot_item  (p_container, p_slot);
  Integer l_count         = slot_count (p_container, p_slot);
  Integer l_damage        = slot_damage(p_container, p_slot);
  Integer l_half          = 0;

  if (l_cursor_item == ITEM_NONE) {
    if (l_item == ITEM_NONE) return;
    l_half = l_count - floor_divide(l_count, 2);
    slot_set(p_holder,    CURSOR_SLOT, l_item, l_half,         l_damage);
    slot_set(p_container, p_slot,        l_item, l_count - l_half, l_damage);
    return;
  }

  if (p_take_only) return;
  if (l_item != ITEM_NONE && l_item != l_cursor_item) return;
  if (l_count >= item_max_stack(l_cursor_item)) return;

  slot_set(p_container, p_slot,        l_cursor_item, l_count + 1,        l_cursor_damage);
  slot_set(p_holder,    CURSOR_SLOT, l_cursor_item, l_cursor_count - 1, l_cursor_damage);
}

void slot_move_all(Attributes &p_from, Integer p_from_slot, Attributes &p_to, Integer p_first, Integer p_last)
// ----------------------------------------------------------------
// Move as much of a stack as fits into slots first..last of
// another container (shift-click style); the rest stays put
// ----------------------------------------------------------------
{
  Integer l_left = container_add(p_to, p_first, p_last, slot_item(p_from, p_from_slot), slot_count(p_from, p_from_slot), slot_damage(p_from, p_from_slot));

  slot_set(p_from, p_from_slot, slot_item(p_from, p_from_slot), l_left, slot_damage(p_from, p_from_slot));
}

// ---------------------------------------------------------------- containers

void container_clear(Attributes &p_container, Text p_datatype, Integer p_first, Integer p_last)
// ----------------------------------------------------------------
// Make container an empty record of the given datatype whose slots
// first..last exist and are empty
// ----------------------------------------------------------------
{
  Integer l_slot = 0;

  record_clear(p_container, p_datatype);
  for (l_slot = p_first; l_slot <= p_last; ++l_slot) slot_clear(p_container, l_slot);
}

Integer container_add(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item, Integer p_count, Integer p_damage)
// ----------------------------------------------------------------
// Put items into slots first..last: first topping up stacks of the
// same item, then into empty slots in order
// Returns how many did not fit
// ----------------------------------------------------------------
{
  Integer l_left  = p_count;
  Integer l_limit = item_max_stack(p_item);
  Integer l_slot  = 0;
  Integer l_space = 0;
  Integer l_moved = 0;

  if (p_item == ITEM_NONE || p_count <= 0) return 0;

  if (l_limit > 1) {
    for (l_slot = p_first; l_slot <= p_last; ++l_slot) {
      if (l_left <= 0) break;
      if (slot_item(p_container, l_slot) != p_item) continue;
      l_space = l_limit - slot_count(p_container, l_slot);
      if (l_space <= 0) continue;
      l_moved = l_left;
      if (l_moved > l_space) l_moved = l_space;
      slot_set(p_container, l_slot, p_item, slot_count(p_container, l_slot) + l_moved, 0);
      l_left = l_left - l_moved;
    }
  }

  for (l_slot = p_first; l_slot <= p_last; ++l_slot) {
    if (l_left <= 0) break;
    if (!slot_is_empty(p_container, l_slot)) continue;
    l_moved = l_left;
    if (l_moved > l_limit) l_moved = l_limit;
    slot_set(p_container, l_slot, p_item, l_moved, p_damage);
    l_left = l_left - l_moved;
  }

  return l_left;
}

Integer container_count_item(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item)
// ----------------------------------------------------------------
// Total number of an item across slots first..last
// ----------------------------------------------------------------
{
  Integer l_slot  = 0;
  Integer l_total = 0;

  for (l_slot = p_first; l_slot <= p_last; ++l_slot) {
    if (slot_item(p_container, l_slot) == p_item) l_total = l_total + slot_count(p_container, l_slot);
  }
  return l_total;
}

Integer container_remove_item(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item, Integer p_count)
// ----------------------------------------------------------------
// Take count of an item out of slots first..last, from the last
// slot backwards. Returns FALSE (and removes nothing) if there are
// not enough.
// ----------------------------------------------------------------
{
  Integer l_left  = p_count;
  Integer l_slot  = 0;
  Integer l_taken = 0;
  Integer l_have  = 0;

  if (container_count_item(p_container, p_first, p_last, p_item) < p_count) return FALSE;

  for (l_slot = p_last; l_slot >= p_first; --l_slot) {
    if (l_left <= 0) break;
    if (slot_item(p_container, l_slot) != p_item) continue;
    l_have  = slot_count(p_container, l_slot);
    l_taken = l_left;
    if (l_taken > l_have) l_taken = l_have;
    slot_set(p_container, l_slot, p_item, l_have - l_taken, slot_damage(p_container, l_slot));
    l_left = l_left - l_taken;
  }
  return TRUE;
}

// ---------------------------------------------------------------- the player's inventory

void inventory_clear(Attributes &p_inventory)
// ----------------------------------------------------------------
// Empty every slot and the cursor
// ----------------------------------------------------------------
{
  container_clear(p_inventory, DATATYPE_INVENTORY, CURSOR_SLOT, INVENTORY_SLOTS);
}

Integer inventory_add(Attributes &p_inventory, Integer p_item, Integer p_count)
// ----------------------------------------------------------------
// Add new items, hotbar first. Returns how many did not fit.
// ----------------------------------------------------------------
{
  return container_add(p_inventory, 1, INVENTORY_SLOTS, p_item, p_count, 0);
}

Integer inventory_add_worn(Attributes &p_inventory, Integer p_item, Integer p_count, Integer p_damage)
// ----------------------------------------------------------------
// Add items that keep their wear (a tool coming back from a
// crafting grid or being picked up). Returns how many did not fit.
// ----------------------------------------------------------------
{
  return container_add(p_inventory, 1, INVENTORY_SLOTS, p_item, p_count, p_damage);
}

Integer inventory_count_item(Attributes &p_inventory, Integer p_item)
// ----------------------------------------------------------------
// Total number of an item in the inventory
// ----------------------------------------------------------------
{
  return container_count_item(p_inventory, 1, INVENTORY_SLOTS, p_item);
}

Integer inventory_remove_item(Attributes &p_inventory, Integer p_item, Integer p_count)
// ----------------------------------------------------------------
// Take items out, main inventory before hotbar. FALSE if there are
// not enough (nothing is removed then).
// ----------------------------------------------------------------
{
  return container_remove_item(p_inventory, 1, INVENTORY_SLOTS, p_item, p_count);
}

void inventory_return_cursor(Attributes &p_inventory, Attributes &p_events, Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Put the cursor stack back into the inventory when a screen
// closes; anything that does not fit is dropped at (x, y, z)
// ----------------------------------------------------------------
{
  Integer l_item = slot_item(p_inventory, CURSOR_SLOT);
  Integer l_left = 0;

  if (l_item == ITEM_NONE) return;

  l_left = inventory_add_worn(p_inventory, l_item, slot_count(p_inventory, CURSOR_SLOT), slot_damage(p_inventory, CURSOR_SLOT));
  if (l_left > 0) emit_drop_event(p_events, l_item, l_left, slot_damage(p_inventory, CURSOR_SLOT), p_x, p_y, p_z);

  slot_clear(p_inventory, CURSOR_SLOT);
}

#endif
