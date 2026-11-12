#ifndef FURNACE_4DM_INCLUDED
#define FURNACE_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/records.h"
#include "../../include/blocks/blocks.h"
#include "../../include/core/events.h"
#include "../../include/items/inventory.h"
#include "../../include/core/slots.h"
#include "../../include/world/world.h"
#include "../../include/items/furnace.h"

// ---------------------------------------------------------------- accessors

void furnaces_clear(Attributes &p_furnaces)
// ----------------------------------------------------------------
// Forget every furnace
// ----------------------------------------------------------------
{
  Integer l_furnace = 0;

  record_clear(p_furnaces, DATATYPE_FURNACES);
  for (l_furnace = 1; l_furnace <= MAX_FURNACES; ++l_furnace) record_set_integer_at(p_furnaces, ATTR_USED, l_furnace, FALSE);
  slots_reset(SLOT_POOL_FURNACES);
}

void furnaces_rebuild_index(Attributes &p_furnaces)
// ----------------------------------------------------------------
// Rebuild the list of furnaces from the record (after a world is
// loaded)
// ----------------------------------------------------------------
{
  slots_rebuild(SLOT_POOL_FURNACES, p_furnaces, MAX_FURNACES);
}

void furnace_set_used(Attributes &p_furnaces, Integer p_furnace, Integer p_used)
// ----------------------------------------------------------------
// A furnace is placed (used TRUE) or gone: the record and the list
// of furnaces change together
// ----------------------------------------------------------------
{
  record_set_integer_at(p_furnaces, ATTR_USED, p_furnace, p_used);
  slots_set(SLOT_POOL_FURNACES, p_furnace, p_used);
}

Integer furnace_slot(Integer p_furnace, Integer p_which)
// ----------------------------------------------------------------
// Container slot number of slot which (FURNACE_SLOT_*) of a furnace
// ----------------------------------------------------------------
{
  return (p_furnace - 1) * FURNACE_SLOTS + p_which;
}

Integer furnace_used(Attributes &p_furnaces, Integer p_furnace)
// ----------------------------------------------------------------
// TRUE if furnace number furnace exists
// ----------------------------------------------------------------
{
  if (p_furnace < 1 || p_furnace > MAX_FURNACES) return FALSE;
  return slots_used(SLOT_POOL_FURNACES, p_furnace);
}

void furnace_cell(Attributes &p_furnaces, Integer p_furnace, Integer &p_x, Integer &p_y, Integer &p_z)
// ----------------------------------------------------------------
// Block cell of a furnace
// ----------------------------------------------------------------
{
  p_x = record_integer_at(p_furnaces, ATTR_X, p_furnace);
  p_y = record_integer_at(p_furnaces, ATTR_Y, p_furnace);
  p_z = record_integer_at(p_furnaces, ATTR_Z, p_furnace);
}

Real furnace_burn_left(Attributes &p_furnaces, Integer p_furnace)
// ----------------------------------------------------------------
// Seconds of fuel left burning
// ----------------------------------------------------------------
{
  return record_real_at(p_furnaces, ATTR_FURNACE_BURN, p_furnace);
}

Real furnace_burn_total(Attributes &p_furnaces, Integer p_furnace)
// ----------------------------------------------------------------
// Seconds the current piece of fuel burns for in all
// ----------------------------------------------------------------
{
  return record_real_at(p_furnaces, ATTR_FURNACE_BURN_TOTAL, p_furnace);
}

Real furnace_progress(Attributes &p_furnaces, Integer p_furnace)
// ----------------------------------------------------------------
// Seconds the current input item has been cooking
// ----------------------------------------------------------------
{
  return record_real_at(p_furnaces, ATTR_FURNACE_PROGRESS, p_furnace);
}

void furnace_set_state(Attributes &p_furnaces, Integer p_furnace, Real p_burn_left, Real p_burn_total, Real p_progress)
// ----------------------------------------------------------------
// Set the burning and cooking state of a furnace
// ----------------------------------------------------------------
{
  record_set_real_at(p_furnaces, ATTR_FURNACE_BURN,       p_furnace, p_burn_left);
  record_set_real_at(p_furnaces, ATTR_FURNACE_BURN_TOTAL, p_furnace, p_burn_total);
  record_set_real_at(p_furnaces, ATTR_FURNACE_PROGRESS,   p_furnace, p_progress);
}

// ---------------------------------------------------------------- furnaces

Integer furnace_find(Attributes &p_furnaces, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Number of the furnace at a cell, 0 if there isn't one
// ----------------------------------------------------------------
{
  Integer l_furnace = 0;
  Integer l_fx      = 0;
  Integer l_fy      = 0;
  Integer l_fz      = 0;

  for (l_furnace = 1; l_furnace <= MAX_FURNACES; ++l_furnace) {
    if (!furnace_used(p_furnaces, l_furnace)) continue;
    furnace_cell(p_furnaces, l_furnace, l_fx, l_fy, l_fz);
    if (l_fx == p_x && l_fy == p_y && l_fz == p_z) return l_furnace;
  }
  return 0;
}

Integer furnace_get_or_create(Attributes &p_furnaces, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Number of the furnace at a cell, making an empty one if needed
// Returns 0 if every furnace number is taken
// ----------------------------------------------------------------
{
  Integer l_furnace = furnace_find(p_furnaces, p_x, p_y, p_z);
  Integer l_which   = 0;

  if (l_furnace > 0) return l_furnace;

  for (l_furnace = 1; l_furnace <= MAX_FURNACES; ++l_furnace) {
    if (furnace_used(p_furnaces, l_furnace)) continue;
    furnace_set_used     (p_furnaces, l_furnace, TRUE);
    record_set_integer_at(p_furnaces, ATTR_X,    l_furnace, p_x);
    record_set_integer_at(p_furnaces, ATTR_Y,    l_furnace, p_y);
    record_set_integer_at(p_furnaces, ATTR_Z,    l_furnace, p_z);
    for (l_which = 1; l_which <= FURNACE_SLOTS; ++l_which) slot_clear(p_furnaces, furnace_slot(l_furnace, l_which));
    furnace_set_state(p_furnaces, l_furnace, 0.0, 0.0, 0.0);
    return l_furnace;
  }
  return 0;
}

void furnace_remove(Attributes &p_furnaces, Attributes &p_events, Integer p_furnace)
// ----------------------------------------------------------------
// The furnace block is gone: drop whatever it held and free it
// ----------------------------------------------------------------
{
  Integer l_which = 0;
  Integer l_slot  = 0;
  Integer l_x     = 0;
  Integer l_y     = 0;
  Integer l_z     = 0;

  if (!furnace_used(p_furnaces, p_furnace)) return;

  furnace_cell(p_furnaces, p_furnace, l_x, l_y, l_z);
  for (l_which = 1; l_which <= FURNACE_SLOTS; ++l_which) {
    l_slot = furnace_slot(p_furnace, l_which);
    if (!slot_is_empty(p_furnaces, l_slot)) {
      emit_drop_event(p_events, slot_item(p_furnaces, l_slot), slot_count(p_furnaces, l_slot), slot_damage(p_furnaces, l_slot), l_x + 0.5, l_y + 0.5, l_z + 0.5);
    }
    slot_clear(p_furnaces, l_slot);
  }

  furnace_set_used(p_furnaces, p_furnace, FALSE);
}

Integer furnace_can_cook(Attributes &p_furnaces, Integer p_furnace)
// ----------------------------------------------------------------
// TRUE if the input can be cooked and the output has room for it
// ----------------------------------------------------------------
{
  Integer l_input  = furnace_slot(p_furnace, FURNACE_SLOT_INPUT);
  Integer l_output = furnace_slot(p_furnace, FURNACE_SLOT_OUTPUT);
  Integer l_result = ITEM_NONE;

  if (slot_is_empty(p_furnaces, l_input)) return FALSE;

  l_result = item_smelt_result(slot_item(p_furnaces, l_input));
  if (l_result == ITEM_NONE) return FALSE;
  if (slot_is_empty(p_furnaces, l_output)) return TRUE;
  if (slot_item(p_furnaces, l_output) != l_result) return FALSE;
  if (slot_count(p_furnaces, l_output) >= item_max_stack(l_result)) return FALSE;
  return TRUE;
}

void furnace_step(Attributes &p_furnaces, Integer p_furnace, Real p_dt)
// ----------------------------------------------------------------
// Advance one furnace by dt seconds (dt should be small)
// A new piece of fuel is only lit when there is something to cook
// ----------------------------------------------------------------
{
  Integer l_can_cook   = furnace_can_cook(p_furnaces, p_furnace);
  Integer l_input      = furnace_slot(p_furnace, FURNACE_SLOT_INPUT);
  Integer l_fuel_slot  = furnace_slot(p_furnace, FURNACE_SLOT_FUEL);
  Integer l_output     = furnace_slot(p_furnace, FURNACE_SLOT_OUTPUT);
  Real    l_burn_left  = furnace_burn_left (p_furnaces, p_furnace);
  Real    l_burn_total = furnace_burn_total(p_furnaces, p_furnace);
  Real    l_progress   = furnace_progress  (p_furnaces, p_furnace);
  Integer l_fuel       = 0;
  Integer l_result     = 0;

  if (l_burn_left <= 0.0 && l_can_cook && !slot_is_empty(p_furnaces, l_fuel_slot)) {
    l_fuel = item_fuel_seconds(slot_item(p_furnaces, l_fuel_slot));
    if (l_fuel > 0) {
      l_burn_left  = l_fuel;
      l_burn_total = l_fuel;
      slot_take_one(p_furnaces, l_fuel_slot);
    }
  }

  if (l_burn_left > 0.0) {
    l_burn_left = l_burn_left - p_dt;
    if (l_burn_left < 0.0) l_burn_left = 0.0;

    if (l_can_cook) {
      l_progress = l_progress + p_dt;
      if (l_progress >= COOK_SECONDS) {
        l_progress = 0.0;
        l_result   = item_smelt_result(slot_item(p_furnaces, l_input));
        slot_set     (p_furnaces, l_output, l_result, slot_count(p_furnaces, l_output) + 1, 0);
        slot_take_one(p_furnaces, l_input);
      }
    } else {
      l_progress = 0.0;
    }
  } else {
    // Cools down without fuel
    l_progress = l_progress - p_dt * 2.0;
    if (l_progress < 0.0) l_progress = 0.0;
  }

  furnace_set_state(p_furnaces, p_furnace, l_burn_left, l_burn_total, l_progress);
}

void furnaces_update(Attributes &p_furnaces, Attributes &p_events, Real p_dt)
// ----------------------------------------------------------------
// Advance every furnace by dt seconds, in small steps so a long
// gap between frames (paused game) still cooks correctly. A furnace
// whose block doesn't show whether it is burning (it just lit or
// went out, or the world was just loaded) asks for its block to be
// swapped with EVT_FURNACE_LIT.
// ----------------------------------------------------------------
{
  Integer l_furnace   = 0;
  Integer l_live      = 0;
  Integer l_lit       = FALSE;
  Integer l_x         = 0;
  Integer l_y         = 0;
  Integer l_z         = 0;
  Integer l_block     = 0;
  Real    l_remaining = p_dt;
  Real    l_step      = 0.0;

  for (l_live = 1; l_live <= slots_count(SLOT_POOL_FURNACES); ++l_live) {
    l_furnace   = slots_at(SLOT_POOL_FURNACES, l_live);
    l_remaining = p_dt;
    if (l_remaining > 3600.0) l_remaining = 3600.0;
    while (l_remaining > 0.0) {
      l_step = l_remaining;
      if (l_step > 0.5) l_step = 0.5;
      l_remaining = l_remaining - l_step;
      furnace_step(p_furnaces, l_furnace, l_step);
    }

    l_lit = FALSE;
    if (furnace_burn_left(p_furnaces, l_furnace) > 0.0) l_lit = TRUE;
    furnace_cell(p_furnaces, l_furnace, l_x, l_y, l_z);
    l_block = world_get_block(l_x, l_y, l_z);
    if (!block_is_furnace(l_block)) continue;
    if (block_furnace_is_lit(l_block) == l_lit) continue;
    emit_event(p_events, EVT_FURNACE_LIT, l_x, l_y, l_z, l_lit, 0.0, 0.0, 0.0, "");
  }
}

void furnace_on_event(Attributes &p_event, Attributes &p_furnaces, Attributes &p_events)
// ----------------------------------------------------------------
// Event handler: furnaces appear and disappear with their blocks
// ----------------------------------------------------------------
{
  Integer l_type  = event_type(p_event);
  Integer l_x     = event_integer(p_event, 1);
  Integer l_y     = event_integer(p_event, 2);
  Integer l_z     = event_integer(p_event, 3);
  Integer l_block = event_integer(p_event, 4);

  if (!block_is_furnace(l_block)) return;

  if (l_type == EVT_BLOCK_PLACED) {
    furnace_get_or_create(p_furnaces, l_x, l_y, l_z);
  } else if (l_type == EVT_BLOCK_BROKEN) {
    furnace_remove(p_furnaces, p_events, furnace_find(p_furnaces, l_x, l_y, l_z));
  }
}

#endif
