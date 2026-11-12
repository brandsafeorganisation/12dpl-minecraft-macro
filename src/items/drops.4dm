#ifndef DROPS_4DM_INCLUDED
#define DROPS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/world/physics.h"
#include "../../include/items/inventory.h"
#include "../../include/mobs/cows.h"
#include "../../include/core/slots.h"
#include "../../include/items/drops.h"

// ---------------------------------------------------------------- accessors

void drops_clear(Attributes &p_drops)
// ----------------------------------------------------------------
// Remove every dropped item
// ----------------------------------------------------------------
{
  Integer l_drop = 0;

  record_clear(p_drops, DATATYPE_DROPS);
  for (l_drop = 1; l_drop <= MAX_DROPS; ++l_drop) record_set_integer_at(p_drops, ATTR_USED, l_drop, FALSE);
  slots_reset(SLOT_POOL_DROPS);
}

void drops_rebuild_index(Attributes &p_drops)
// ----------------------------------------------------------------
// Rebuild the list of drops lying about from the record (after a
// world is loaded)
// ----------------------------------------------------------------
{
  slots_rebuild(SLOT_POOL_DROPS, p_drops, MAX_DROPS);
}

void drop_set_used(Attributes &p_drops, Integer p_drop, Integer p_used)
// ----------------------------------------------------------------
// A drop appears (used TRUE) or is gone: the record and the list of
// drops change together
// ----------------------------------------------------------------
{
  record_set_integer_at(p_drops, ATTR_USED, p_drop, p_used);
  slots_set(SLOT_POOL_DROPS, p_drop, p_used);
}

Integer drop_used(Attributes &p_drops, Integer p_drop)
// ----------------------------------------------------------------
// TRUE if drop number drop is lying in the world (from the list of
// drops, which mirrors the record's "used" fields)
// ----------------------------------------------------------------
{
  return slots_used(SLOT_POOL_DROPS, p_drop);
}

Integer drop_item(Attributes &p_drops, Integer p_drop)
// ----------------------------------------------------------------
// Item of a drop
// ----------------------------------------------------------------
{
  return record_integer_at(p_drops, ATTR_ITEM, p_drop);
}

Integer drop_count(Attributes &p_drops, Integer p_drop)
// ----------------------------------------------------------------
// Number of items in a drop
// ----------------------------------------------------------------
{
  return record_integer_at(p_drops, ATTR_COUNT, p_drop);
}

Integer drop_damage(Attributes &p_drops, Integer p_drop)
// ----------------------------------------------------------------
// Wear of a dropped tool
// ----------------------------------------------------------------
{
  return record_integer_at(p_drops, ATTR_DAMAGE, p_drop);
}

Real drop_age(Attributes &p_drops, Integer p_drop)
// ----------------------------------------------------------------
// Seconds since the drop appeared
// ----------------------------------------------------------------
{
  return record_real_at(p_drops, ATTR_AGE, p_drop);
}

void drop_position(Attributes &p_drops, Integer p_drop, Real &p_x, Real &p_y, Real &p_z)
// ----------------------------------------------------------------
// Centre of the bottom of a drop
// ----------------------------------------------------------------
{
  p_x = record_real_at(p_drops, ATTR_X, p_drop);
  p_y = record_real_at(p_drops, ATTR_Y, p_drop);
  p_z = record_real_at(p_drops, ATTR_Z, p_drop);
}

// ---------------------------------------------------------------- behaviour

Integer drops_restore(Attributes &p_drops, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z, Real p_age)
// ----------------------------------------------------------------
// Put a stack down at rest with its bottom at (x, y, z). If every
// drop number is in use the oldest drop is replaced. Returns the
// drop's number.
// ----------------------------------------------------------------
{
  Integer l_drop   = 0;
  Integer l_chosen = 0;
  Real    l_oldest = -1.0;

  if (p_item == ITEM_NONE || p_count <= 0) return 0;

  for (l_drop = 1; l_drop <= MAX_DROPS; ++l_drop) {
    if (!drop_used(p_drops, l_drop)) {
      l_chosen = l_drop;
      break;
    }
    if (drop_age(p_drops, l_drop) > l_oldest) {
      l_oldest = drop_age(p_drops, l_drop);
      l_chosen = l_drop;
    }
  }

  drop_set_used        (p_drops, l_chosen, TRUE);
  record_set_integer_at(p_drops, ATTR_ITEM,   l_chosen, p_item);
  record_set_integer_at(p_drops, ATTR_COUNT,  l_chosen, p_count);
  record_set_integer_at(p_drops, ATTR_DAMAGE, l_chosen, p_damage);
  record_set_real_at   (p_drops, ATTR_X,      l_chosen, p_x);
  record_set_real_at   (p_drops, ATTR_Y,      l_chosen, p_y);
  record_set_real_at   (p_drops, ATTR_Z,      l_chosen, p_z);
  record_set_real_at   (p_drops, ATTR_VX,     l_chosen, 0.0);
  record_set_real_at   (p_drops, ATTR_VY,     l_chosen, 0.0);
  record_set_real_at   (p_drops, ATTR_VZ,     l_chosen, 0.0);
  record_set_real_at   (p_drops, ATTR_AGE,    l_chosen, p_age);

  return l_chosen;
}

Integer drops_spawn(Attributes &p_drops, Attributes &p_random, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Drop a stack centred on (x, y, z) with a little pop upwards
// Returns the drop's number
// ----------------------------------------------------------------
{
  Integer l_drop = drops_restore(p_drops, p_item, p_count, p_damage, p_x, p_y - DROP_HALF_SIZE, p_z, 0.0);

  if (l_drop == 0) return 0;

  record_set_real_at(p_drops, ATTR_VX, l_drop, random_between(p_random, -1.0, 1.0));
  record_set_real_at(p_drops, ATTR_VY, l_drop, random_between(p_random, 3.5, 5.0));
  record_set_real_at(p_drops, ATTR_VZ, l_drop, random_between(p_random, -1.0, 1.0));

  return l_drop;
}

void drops_update(Attributes &p_drops, Attributes &p_inventory, Attributes &p_events,
                  Real p_player_x, Real p_player_y, Real p_player_z, Integer p_player_dead, Real p_dt)
// ----------------------------------------------------------------
// Drops fall, slide to a stop, drift towards a nearby player and
// are picked up when close enough. Emits EVT_ITEM_PICKED_UP.
// ----------------------------------------------------------------
{
  Integer l_drop     = 0;
  Integer l_item     = 0;
  Integer l_count    = 0;
  Integer l_left     = 0;
  Integer l_steps    = 0;
  Integer l_step     = 0;
  Integer l_hit_x    = FALSE;
  Integer l_hit_z    = FALSE;
  Integer l_hit_down = FALSE;
  Integer l_hit_up   = FALSE;
  Integer l_landed   = FALSE;
  Real    l_age      = 0.0;
  Real    l_x        = 0.0;
  Real    l_y        = 0.0;
  Real    l_z        = 0.0;
  Real    l_vx       = 0.0;
  Real    l_vy       = 0.0;
  Real    l_vz       = 0.0;
  Real    l_dx       = 0.0;
  Real    l_dy       = 0.0;
  Real    l_dz       = 0.0;
  Real    l_distance = 0.0;
  Real    l_friction = 0.0;
  Real    l_longest  = 0.0;
  Integer l_live     = 0;
  Integer l_live_count = slots_count(SLOT_POOL_DROPS);
  Integer l_order[MAX_DROPS];

  // Drops are picked up or vanish during the loop, which changes the
  // list, so go through a copy of it
  for (l_live = 1; l_live <= l_live_count; ++l_live) l_order[l_live] = slots_at(SLOT_POOL_DROPS, l_live);
  for (l_live = 1; l_live <= l_live_count; ++l_live) {
    l_drop = l_order[l_live];

    l_age = drop_age(p_drops, l_drop) + p_dt;
    if (l_age > DROP_LIFETIME) {
      drop_set_used(p_drops, l_drop, FALSE);
      continue;
    }

    drop_position(p_drops, l_drop, l_x, l_y, l_z);
    l_vx = record_real_at(p_drops, ATTR_VX, l_drop);
    l_vy = record_real_at(p_drops, ATTR_VY, l_drop);
    l_vz = record_real_at(p_drops, ATTR_VZ, l_drop);

    // Pull towards the player once it can be picked up
    l_dx = p_player_x - l_x;
    l_dy = p_player_y + 0.9 - (l_y + DROP_HALF_SIZE);
    l_dz = p_player_z - l_z;
    l_distance = Sqrt(l_dx * l_dx + l_dy * l_dy + l_dz * l_dz);
    if (!p_player_dead && l_age > DROP_PICKUP_DELAY && l_distance < DROP_PULL_DISTANCE && l_distance > 0.01) {
      l_vx = l_dx / l_distance * 5.0;
      l_vz = l_dz / l_distance * 5.0;
      if (l_dy > 0.3) l_vy = max_real(l_vy, 2.0);
    }

    if (physics_box_in_water(l_x, l_y, l_z, DROP_HALF_SIZE, DROP_HALF_SIZE * 2.0)) {
      l_vy = l_vy + (1.0 - l_vy) * min_real(1.0, p_dt * 3.0);
    } else {
      l_vy = l_vy - GRAVITY * 0.7 * p_dt;
      if (l_vy < -TERMINAL_SPEED) l_vy = -TERMINAL_SPEED;
    }

    l_landed  = FALSE;
    l_longest = max_real(Absolute(l_vy), max_real(Absolute(l_vx), Absolute(l_vz))) * p_dt;
    l_steps   = 1 + Floor(l_longest / MAX_MOVE_STEP);
    for (l_step = 1; l_step <= l_steps; ++l_step) {
      physics_move_box(l_x, l_y, l_z, DROP_HALF_SIZE, DROP_HALF_SIZE * 2.0, l_vx * p_dt / l_steps, l_vy * p_dt / l_steps, l_vz * p_dt / l_steps,
                       l_hit_x, l_hit_z, l_hit_down, l_hit_up);
      if (l_hit_down || l_hit_up) l_vy = 0.0;
      if (l_hit_x) l_vx = 0.0;
      if (l_hit_z) l_vz = 0.0;
      if (l_hit_down) l_landed = TRUE;
    }
    if (l_landed) {
      l_friction = 1.0 - min_real(1.0, p_dt * 8.0);
      l_vx = l_vx * l_friction;
      l_vz = l_vz * l_friction;
    }

    record_set_real_at(p_drops, ATTR_X,   l_drop, l_x);
    record_set_real_at(p_drops, ATTR_Y,   l_drop, l_y);
    record_set_real_at(p_drops, ATTR_Z,   l_drop, l_z);
    record_set_real_at(p_drops, ATTR_VX,  l_drop, l_vx);
    record_set_real_at(p_drops, ATTR_VY,  l_drop, l_vy);
    record_set_real_at(p_drops, ATTR_VZ,  l_drop, l_vz);
    record_set_real_at(p_drops, ATTR_AGE, l_drop, l_age);

    if (p_player_dead) continue;
    if (l_age <= DROP_PICKUP_DELAY) continue;
    if (l_distance > DROP_PICKUP_DISTANCE) continue;

    l_item  = drop_item (p_drops, l_drop);
    l_count = drop_count(p_drops, l_drop);
    l_left  = inventory_add_worn(p_inventory, l_item, l_count, drop_damage(p_drops, l_drop));
    if (l_left < l_count) emit_item_event(p_events, EVT_ITEM_PICKED_UP, l_item, l_count - l_left);
    record_set_integer_at(p_drops, ATTR_COUNT, l_drop, l_left);
    if (l_left <= 0) drop_set_used(p_drops, l_drop, FALSE);
  }
}

void drops_on_event(Attributes &p_event, Attributes &p_drops, Attributes &p_random)
// ----------------------------------------------------------------
// Event handler: broken blocks (depending on the tool used) and
// killed cows leave items behind, and anyone can ask for a drop
// with EVT_SPAWN_DROP
// ----------------------------------------------------------------
{
  Integer l_type = event_type(p_event);
  Integer l_item = ITEM_NONE;
  Integer l_tool = 0;

  if (l_type == EVT_BLOCK_BROKEN) {
    l_tool = floor_integer(event_real(p_event, 1) + 0.5);
    l_item = block_drop_item(event_integer(p_event, 4), l_tool);
    if (l_item != ITEM_NONE) {
      drops_spawn(p_drops, p_random, l_item, 1, 0, event_integer(p_event, 1) + 0.5, event_integer(p_event, 2) + 0.5, event_integer(p_event, 3) + 0.5);
    }
  } else if (l_type == EVT_COW_KILLED) {
    if (event_integer(p_event, 2) == MOB_ZOMBIE) {
      drops_spawn(p_drops, p_random, ITEM_ROTTEN_FLESH, random_range(p_random, 1, 2), 0, event_real(p_event, 1), event_real(p_event, 2), event_real(p_event, 3));
    } else if (event_integer(p_event, 2) == MOB_PIG) {
      drops_spawn(p_drops, p_random, ITEM_RAW_PORKCHOP, random_range(p_random, 1, 3), 0, event_real(p_event, 1), event_real(p_event, 2), event_real(p_event, 3));
    } else {
      drops_spawn(p_drops, p_random, ITEM_RAW_BEEF, random_range(p_random, 1, 3), 0, event_real(p_event, 1), event_real(p_event, 2), event_real(p_event, 3));
    }
  } else if (l_type == EVT_SPAWN_DROP) {
    drops_spawn(p_drops, p_random, event_integer(p_event, 1), event_integer(p_event, 2), event_integer(p_event, 3),
                event_real(p_event, 1), event_real(p_event, 2), event_real(p_event, 3));
  }
}

#endif
