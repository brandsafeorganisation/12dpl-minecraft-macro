#ifndef WORLD_4DM_INCLUDED
#define WORLD_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/world/physics.h"
#include "../../include/world/world.h"

// ---------------------------------------------------------------- grid access

Integer world_index(Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Array position of a cell; the cell must be in bounds
// ----------------------------------------------------------------
{
  return (p_x * WORLD_SIZE_Z + p_z) * WORLD_HEIGHT + p_y + 1;
}

void world_cell_of_index(Integer p_index, Integer &p_x, Integer &p_y, Integer &p_z)
// ----------------------------------------------------------------
// The cell at an array position (the opposite of world_index)
// index = (x * WORLD_SIZE_Z + z) * WORLD_HEIGHT + y + 1
// ----------------------------------------------------------------
{
  Integer l_cell = p_index - 1;

  p_y    = positive_mod(l_cell, WORLD_HEIGHT);
  l_cell = floor_divide(l_cell, WORLD_HEIGHT);
  p_z    = positive_mod(l_cell, WORLD_SIZE_Z);
  p_x    = floor_divide(l_cell, WORLD_SIZE_Z);
}

Integer world_column(Integer p_x, Integer p_z)
// ----------------------------------------------------------------
// Array position of a column in the column maps
// ----------------------------------------------------------------
{
  return p_x * WORLD_SIZE_Z + p_z + 1;
}

Integer world_in_bounds(Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// TRUE if the cell lies inside the world
// ----------------------------------------------------------------
{
  if (p_x < 0 || p_y < 0 || p_z < 0) return FALSE;
  if (p_x >= WORLD_SIZE_X || p_y >= WORLD_HEIGHT || p_z >= WORLD_SIZE_Z) return FALSE;
  return TRUE;
}

Integer world_get_block(Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Block at a cell; air outside the world (bedrock below it)
// ----------------------------------------------------------------
{
  Integer l_cell = 0;

  if (p_y < 0) return BLOCK_BEDROCK;
  if (!world_in_bounds(p_x, p_y, p_z)) return BLOCK_AIR;
  l_cell = g_world[world_index(p_x, p_y, p_z)];
  if (l_cell < LIGHT_SHIFT) return l_cell;
  return world_cell_block(l_cell);
}

Integer world_cell_block(Integer p_cell)
// ----------------------------------------------------------------
// Block number of a g_world value (which may carry block light)
// ----------------------------------------------------------------
{
  Integer l_block = p_cell;

  if (p_cell >= LIGHT_SHIFT) l_block = p_cell - LIGHT_SHIFT * Floor(p_cell / (1.0 * LIGHT_SHIFT));
  return l_block;
}

Integer world_cell_light(Integer p_cell)
// ----------------------------------------------------------------
// Block light level (0..LIGHT_MAX_LEVEL) of a g_world value
// ----------------------------------------------------------------
{
  Integer l_light = 0;

  if (p_cell >= LIGHT_SHIFT) l_light = Floor(p_cell / (1.0 * LIGHT_SHIFT));
  return l_light;
}

Integer world_get_light(Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Block light (from torches) at a cell, 0 outside the world
// ----------------------------------------------------------------
{
  if (!world_in_bounds(p_x, p_y, p_z)) return 0;
  return world_cell_light(g_world[world_index(p_x, p_y, p_z)]);
}

void world_set_block(Integer p_x, Integer p_y, Integer p_z, Integer p_block)
// ----------------------------------------------------------------
// Change a cell without telling anyone; used by generation and
// loading. Gameplay changes go through world_break_block and
// world_place_block so that other modules hear about them.
// ----------------------------------------------------------------
{
  Integer l_index = 0;

  if (!world_in_bounds(p_x, p_y, p_z)) return;
  l_index = world_index(p_x, p_y, p_z);
  g_world[l_index] = p_block + LIGHT_SHIFT * world_cell_light(g_world[l_index]);   // keep the light
}

Integer world_is_solid(Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// TRUE if a cell blocks movement. The sides of the world and the
// floor below it are solid, the sky above it is not.
// ----------------------------------------------------------------
{
  if (p_y < 0) return TRUE;
  if (p_y >= WORLD_HEIGHT) return FALSE;
  if (p_x < 0 || p_z < 0 || p_x >= WORLD_SIZE_X || p_z >= WORLD_SIZE_Z) return TRUE;
  return block_is_solid(world_cell_block(g_world[world_index(p_x, p_y, p_z)]));
}

Integer world_top_solid_y(Integer p_x, Integer p_z)
// ----------------------------------------------------------------
// y of the highest solid block in a column, -1 if there is none
// ----------------------------------------------------------------
{
  Integer l_y    = 0;
  Integer l_base = 0;

  if (!world_in_bounds(p_x, 0, p_z)) return -1;

  l_base = world_index(p_x, 0, p_z);
  for (l_y = WORLD_HEIGHT - 1; l_y >= 0; --l_y) {
    if (g_world[l_base + l_y] == BLOCK_AIR) continue;   // most of a column (quick, no calls)
    if (block_is_solid(world_cell_block(g_world[l_base + l_y]))) return l_y;
  }
  return -1;
}

Integer world_top_opaque_y(Integer p_x, Integer p_z)
// ----------------------------------------------------------------
// y of the highest block in a column that keeps daylight out (glass
// lets it through), -1 if there is none
// ----------------------------------------------------------------
{
  Integer l_y    = 0;
  Integer l_base = 0;

  if (!world_in_bounds(p_x, 0, p_z)) return -1;

  l_base = world_index(p_x, 0, p_z);
  for (l_y = WORLD_HEIGHT - 1; l_y >= 0; --l_y) {
    if (g_world[l_base + l_y] == BLOCK_AIR) continue;   // most of a column (quick, no calls)
    if (block_hides_faces(world_cell_block(g_world[l_base + l_y]))) return l_y;
  }
  return -1;
}

Integer world_sky_top(Integer p_x, Integer p_z)
// ----------------------------------------------------------------
// y of the highest sky-blocking block of a column (kept up to date
// as blocks change); cells above it are in daylight
// ----------------------------------------------------------------
{
  if (!world_in_bounds(p_x, 0, p_z)) return -1;
  return g_column_top[world_column(p_x, p_z)];
}

Integer world_solid_below(Integer p_x, Integer p_z)
// ----------------------------------------------------------------
// As generated, every cell of the column from 0 up to this y is
// solid (caves and ponds lower it). Used to skip buried sections.
// ----------------------------------------------------------------
{
  if (!world_in_bounds(p_x, 0, p_z)) return WORLD_HEIGHT;
  return g_solid_below[world_column(p_x, p_z)];
}

Integer world_biome(Integer p_x, Integer p_z)
// ----------------------------------------------------------------
// BIOME_* of a column
// ----------------------------------------------------------------
{
  if (!world_in_bounds(p_x, 0, p_z)) return BIOME_OCEAN;
  return g_biome_map[world_column(p_x, p_z)];
}

void world_update_column_top(Integer p_x, Integer p_z)
// ----------------------------------------------------------------
// Recompute the sky top of one column after a block changed
// ----------------------------------------------------------------
{
  if (!world_in_bounds(p_x, 0, p_z)) return;
  g_column_top[world_column(p_x, p_z)] = world_top_opaque_y(p_x, p_z);
}

void world_break_block(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_tool_item)
// ----------------------------------------------------------------
// Remove a block during play and announce it with EVT_BLOCK_BROKEN
// (tool_item is what it was broken with, so the drop can depend on
// it; ITEM_NONE for a bare hand)
// A broken block next to water fills with water, so oceans and
// ponds stay level when the shore is dug away
// ----------------------------------------------------------------
{
  Integer l_old_block = world_get_block(p_x, p_y, p_z);
  Integer l_new_block = BLOCK_AIR;
  Integer l_px        = 0;
  Integer l_py        = 0;
  Integer l_pz        = 0;

  if (!world_in_bounds(p_x, p_y, p_z)) return;
  if (l_old_block == BLOCK_AIR) return;

  if (world_get_block(p_x + 1, p_y, p_z) == BLOCK_WATER) l_new_block = BLOCK_WATER;
  if (world_get_block(p_x - 1, p_y, p_z) == BLOCK_WATER) l_new_block = BLOCK_WATER;
  if (world_get_block(p_x, p_y + 1, p_z) == BLOCK_WATER) l_new_block = BLOCK_WATER;
  if (world_get_block(p_x, p_y, p_z + 1) == BLOCK_WATER) l_new_block = BLOCK_WATER;
  if (world_get_block(p_x, p_y, p_z - 1) == BLOCK_WATER) l_new_block = BLOCK_WATER;

  world_set_block        (p_x, p_y, p_z, l_new_block);
  world_update_column_top(p_x, p_z);
  if (world_light_update(p_x, p_y, p_z)) emit_cell_event(p_events, EVT_LIGHT_CHANGED, p_x, p_y, p_z, 0);
  emit_event(p_events, EVT_BLOCK_BROKEN, p_x, p_y, p_z, l_old_block, p_tool_item * 1.0, 0.0, 0.0, "");
  if (l_new_block == BLOCK_WATER) emit_cell_event(p_events, EVT_BLOCK_PLACED, p_x, p_y, p_z, BLOCK_WATER);

  // A plant standing on the broken block goes with it
  if (block_is_plant(world_get_block(p_x, p_y + 1, p_z))) world_break_block(p_events, p_x, p_y + 1, p_z, ITEM_NONE);
  // and so does the other half of a door or bed (it drops nothing,
  // see block_drop_item, unless it is the half that carries the item)
  if (block_partner(l_old_block, p_x, p_y, p_z, l_px, l_py, l_pz)) {
    if (block_is_shaped(world_get_block(l_px, l_py, l_pz))) world_break_block(p_events, l_px, l_py, l_pz, ITEM_NONE);
  }
  // a door standing on the broken block falls too
  if (block_is_door(world_get_block(p_x, p_y + 1, p_z))) {
    if (!block_door_top(world_get_block(p_x, p_y + 1, p_z))) world_break_block(p_events, p_x, p_y + 1, p_z, ITEM_NONE);
  }
}

void world_place_block(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)
// ----------------------------------------------------------------
// Put a block down during play and announce it with
// EVT_BLOCK_PLACED
// ----------------------------------------------------------------
{
  if (!world_in_bounds(p_x, p_y, p_z)) return;

  world_set_block        (p_x, p_y, p_z, p_block);
  world_update_column_top(p_x, p_z);
  if (world_light_update(p_x, p_y, p_z)) emit_cell_event(p_events, EVT_LIGHT_CHANGED, p_x, p_y, p_z, 0);
  emit_cell_event(p_events, EVT_BLOCK_PLACED, p_x, p_y, p_z, p_block);
}

// ---------------------------------------------------------------- day and night

Real world_time_of_day(Attributes &p_info)
// ----------------------------------------------------------------
// Time of day, 0..1 (0 sunrise, 0.25 noon, 0.5 sunset, 0.75 midnight)
// ----------------------------------------------------------------
{
  return record_real(p_info, ATTR_WORLD_TIME);
}

void world_set_time_of_day(Attributes &p_info, Real p_time)
// ----------------------------------------------------------------
// Set the time of day (wrapped into 0..1)
// ----------------------------------------------------------------
{
  record_set_real(p_info, ATTR_WORLD_TIME, p_time - Floor(p_time));
}

Integer world_daylight_cycle(Attributes &p_info)
// ----------------------------------------------------------------
// TRUE if the clock runs (the doDaylightCycle game rule); worlds
// saved before the rule existed have it on
// ----------------------------------------------------------------
{
  return record_integer(p_info, ATTR_WORLD_NO_CYCLE) != TRUE;
}

void world_set_daylight_cycle(Attributes &p_info, Integer p_on)
// ----------------------------------------------------------------
// Start or stop the clock (saved with the world)
// ----------------------------------------------------------------
{
  record_set_integer(p_info, ATTR_WORLD_NO_CYCLE, !p_on);
}

void world_advance_time(Attributes &p_info, Real p_dt)
// ----------------------------------------------------------------
// Move the clock on by p_dt seconds, counting whole days
// ----------------------------------------------------------------
{
  Real l_time = world_time_of_day(p_info) + p_dt / DAY_SECONDS;

  if (l_time >= 1.0) record_set_integer(p_info, ATTR_WORLD_DAYS, record_integer(p_info, ATTR_WORLD_DAYS) + 1);
  world_set_time_of_day(p_info, l_time);
}

Real world_sun_height(Real p_time_of_day)
// ----------------------------------------------------------------
// Height of the sun, -1 (midnight) to 1 (noon)
// ----------------------------------------------------------------
{
  return Sin(p_time_of_day * TWO_PI);
}

Real world_daylight(Real p_time_of_day)
// ----------------------------------------------------------------
// How bright the sky light is, NIGHT_LIGHT..1; dawn and dusk fade
// while the sun is near the horizon
// ----------------------------------------------------------------
{
  Real l_amount = clamp_real((world_sun_height(p_time_of_day) + 0.1) / 0.4, 0.0, 1.0);

  return NIGHT_LIGHT + (1.0 - NIGHT_LIGHT) * smooth_curve(l_amount);
}

Integer world_is_night(Real p_time_of_day)
// ----------------------------------------------------------------
// TRUE when it is dark enough for zombies and for sleeping
// ----------------------------------------------------------------
{
  if (world_daylight(p_time_of_day) < NIGHT_DAYLIGHT) return TRUE;
  return FALSE;
}

Text world_clock_text(Real p_time_of_day)
// ----------------------------------------------------------------
// The time as "hh:mm" on a 24 hour clock (sunrise at 06:00)
// ----------------------------------------------------------------
{
  Integer l_minutes = Floor(p_time_of_day * 1440.0) + 360;
  Integer l_hours   = 0;

  if (l_minutes >= 1440) l_minutes = l_minutes - 1440;
  l_hours   = Floor(l_minutes / 60.0);
  l_minutes = l_minutes - l_hours * 60;
  return two_digits(l_hours) + ":" + two_digits(l_minutes);
}

void world_on_event(Attributes &p_event, Attributes &p_info, Attributes &p_events)
// ----------------------------------------------------------------
// EVT_FURNACE_LIT: a furnace started or stopped burning, so its
// block becomes the lit (light giving) or unlit furnace.
// EVT_SLEEP: a bed was used. At night the clock jumps to the next
// morning; either way the bed becomes the place to respawn.
// ----------------------------------------------------------------
{
  Integer l_x     = event_integer(p_event, 1);
  Integer l_y     = event_integer(p_event, 2);
  Integer l_z     = event_integer(p_event, 3);
  Integer l_block = 0;

  if (event_type(p_event) == EVT_FURNACE_LIT) {
    l_block = world_get_block(l_x, l_y, l_z);
    if (!block_is_furnace(l_block)) return;
    world_set_block(l_x, l_y, l_z, block_furnace_lit_as(l_block, event_integer(p_event, 4)));
    if (world_light_update(l_x, l_y, l_z)) emit_cell_event(p_events, EVT_LIGHT_CHANGED, l_x, l_y, l_z, 0);
    return;
  }

  if (event_type(p_event) != EVT_SLEEP) return;

  world_info_set_spawn(p_info, l_x + 0.5, l_y + 1.0 + COLLISION_EPSILON, l_z + 0.5);
  if (world_is_night(world_time_of_day(p_info))) {
    world_set_time_of_day(p_info, WAKE_UP_TIME);
    record_set_integer(p_info, ATTR_WORLD_DAYS, record_integer(p_info, ATTR_WORLD_DAYS) + 1);
    emit_toast(p_events, "You slept until morning. You'll wake up here.");
  } else {
    emit_toast(p_events, "You can only sleep at night - but you'll respawn here.");
  }
}

// ---------------------------------------------------------------- block light

void world_set_light_index(Integer p_index, Integer p_light)
// ----------------------------------------------------------------
// Set the light part of g_world[p_index], keeping its block
// ----------------------------------------------------------------
{
  g_world[p_index] = world_cell_block(g_world[p_index]) + LIGHT_SHIFT * p_light;
}

Integer world_light_push(Integer p_tail, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Add a cell to the relighting queue; returns the new tail
// ----------------------------------------------------------------
{
  if (p_tail >= LIGHT_QUEUE_SIZE) return p_tail;
  g_light_qx[p_tail + 1] = p_x;
  g_light_qy[p_tail + 1] = p_y;
  g_light_qz[p_tail + 1] = p_z;
  return p_tail + 1;
}

Integer world_light_seed_outside(Integer p_tail, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// A lit cell just outside the relighting box shines into it, so it
// goes in the queue (its own light doesn't change)
// ----------------------------------------------------------------
{
  if (!world_in_bounds(p_x, p_y, p_z)) return p_tail;
  if (world_get_light(p_x, p_y, p_z) <= 1) return p_tail;
  return world_light_push(p_tail, p_x, p_y, p_z);
}

Integer world_light_update(Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Work block light out again after the cell (x, y, z) changed.
// A change can only alter light within LIGHT_MAX_LEVEL - 1 cells of
// it, so: clear the light in a box of LIGHT_RADIUS round the cell,
// relight it from the light sources inside and from the lit cells
// just outside, then spread it with a breadth-first flood. Quick
// when there is no light nearby (the usual case in daylight).
// Returns TRUE if the light was worked out again (so the faces
// within LIGHT_RADIUS need rebuilding), FALSE if there was none.
// ----------------------------------------------------------------
{
  Integer l_x0    = max_integer(p_x - LIGHT_RADIUS, 0);
  Integer l_x1    = min_integer(p_x + LIGHT_RADIUS, WORLD_SIZE_X - 1);
  Integer l_y0    = max_integer(p_y - LIGHT_RADIUS, 0);
  Integer l_y1    = min_integer(p_y + LIGHT_RADIUS, WORLD_HEIGHT - 1);
  Integer l_z0    = max_integer(p_z - LIGHT_RADIUS, 0);
  Integer l_z1    = min_integer(p_z + LIGHT_RADIUS, WORLD_SIZE_Z - 1);
  Integer l_x     = 0;
  Integer l_y     = 0;
  Integer l_z     = 0;
  Integer l_index = 0;
  Integer l_light = 0;
  Integer l_head  = 0;
  Integer l_tail  = 0;
  Integer l_side  = 0;
  Integer l_nx    = 0;
  Integer l_ny    = 0;
  Integer l_nz    = 0;
  Integer l_block = 0;
  Integer l_near  = 0;

  if (!world_in_bounds(p_x, p_y, p_z)) return FALSE;

  // Nothing to do if nothing near the cell is or gives light
  l_near = block_light_emission(world_get_block(p_x, p_y, p_z)) + world_get_light(p_x, p_y, p_z)
         + world_get_light(p_x + 1, p_y, p_z) + world_get_light(p_x - 1, p_y, p_z)
         + world_get_light(p_x, p_y + 1, p_z) + world_get_light(p_x, p_y - 1, p_z)
         + world_get_light(p_x, p_y, p_z + 1) + world_get_light(p_x, p_y, p_z - 1);
  if (l_near == 0) return FALSE;

  // Clear the box and light its sources
  for (l_x = l_x0; l_x <= l_x1; ++l_x) {
    for (l_z = l_z0; l_z <= l_z1; ++l_z) {
      l_index = world_index(l_x, l_y0, l_z);
      for (l_y = l_y0; l_y <= l_y1; ++l_y) {
        if (g_world[l_index] >= LIGHT_SHIFT) world_set_light_index(l_index, 0);
        l_light = block_light_emission(g_world[l_index]);
        if (l_light > 0) {
          world_set_light_index(l_index, l_light);
          l_tail = world_light_push(l_tail, l_x, l_y, l_z);
        }
        ++l_index;
      }
    }
  }

  // Light coming in from just outside the box
  for (l_y = l_y0; l_y <= l_y1; ++l_y) {
    for (l_z = l_z0; l_z <= l_z1; ++l_z) {
      l_tail = world_light_seed_outside(l_tail, l_x0 - 1, l_y, l_z);
      l_tail = world_light_seed_outside(l_tail, l_x1 + 1, l_y, l_z);
    }
    for (l_x = l_x0; l_x <= l_x1; ++l_x) {
      l_tail = world_light_seed_outside(l_tail, l_x, l_y, l_z0 - 1);
      l_tail = world_light_seed_outside(l_tail, l_x, l_y, l_z1 + 1);
    }
  }
  for (l_x = l_x0; l_x <= l_x1; ++l_x) {
    for (l_z = l_z0; l_z <= l_z1; ++l_z) {
      l_tail = world_light_seed_outside(l_tail, l_x, l_y0 - 1, l_z);
      l_tail = world_light_seed_outside(l_tail, l_x, l_y1 + 1, l_z);
    }
  }

  // Flood: each step into a see-through cell inside the box loses 1
  while (l_head < l_tail) {
    ++l_head;
    l_x     = g_light_qx[l_head];
    l_y     = g_light_qy[l_head];
    l_z     = g_light_qz[l_head];
    l_light = world_get_light(l_x, l_y, l_z) - 1;
    if (l_light < 1) continue;
    for (l_side = 1; l_side <= 6; ++l_side) {
      l_nx = l_x;
      l_ny = l_y;
      l_nz = l_z;
      if (l_side == 1) l_nx = l_x + 1;
      if (l_side == 2) l_nx = l_x - 1;
      if (l_side == 3) l_ny = l_y + 1;
      if (l_side == 4) l_ny = l_y - 1;
      if (l_side == 5) l_nz = l_z + 1;
      if (l_side == 6) l_nz = l_z - 1;
      if (l_nx < l_x0 || l_nx > l_x1 || l_ny < l_y0 || l_ny > l_y1 || l_nz < l_z0 || l_nz > l_z1) continue;
      l_index = world_index(l_nx, l_ny, l_nz);
      l_block = world_cell_block(g_world[l_index]);
      if (block_hides_faces(l_block)) continue;
      if (world_cell_light(g_world[l_index]) >= l_light) continue;
      world_set_light_index(l_index, l_light);
      l_tail = world_light_push(l_tail, l_nx, l_ny, l_nz);
    }
  }
  g_light_steps = l_tail;
  return TRUE;
}

// ---------------------------------------------------------------- world record

void world_info_clear(Attributes &p_info, Integer p_seed)
// ----------------------------------------------------------------
// Start a world record for a seed
// ----------------------------------------------------------------
{
  Real l_shift_a = 0.0;
  Real l_shift_b = 0.0;

  world_seed_shifts(p_seed, l_shift_a, l_shift_b);

  record_clear      (p_info, DATATYPE_WORLD_INFO);
  record_set_integer(p_info, ATTR_WORLD_SEED, p_seed);
  record_set_real   (p_info, ATTR_SHIFT_A,    l_shift_a);
  record_set_real   (p_info, ATTR_SHIFT_B,    l_shift_b);
  world_info_set_spawn(p_info, WORLD_SIZE_X * 0.5, SEA_LEVEL + 8.0, WORLD_SIZE_Z * 0.5);
  record_set_real   (p_info, ATTR_WORLD_TIME, WORLD_START_TIME);
  record_set_integer(p_info, ATTR_WORLD_DAYS, 0);
}

Integer world_info_seed(Attributes &p_info)
// ----------------------------------------------------------------
// The seed a world was made from
// ----------------------------------------------------------------
{
  return record_integer(p_info, ATTR_WORLD_SEED);
}

void world_info_spawn(Attributes &p_info, Real &p_x, Real &p_y, Real &p_z)
// ----------------------------------------------------------------
// Where the player starts and respawns
// ----------------------------------------------------------------
{
  p_x = record_real(p_info, ATTR_SPAWN_X);
  p_y = record_real(p_info, ATTR_SPAWN_Y);
  p_z = record_real(p_info, ATTR_SPAWN_Z);
}

void world_info_set_spawn(Attributes &p_info, Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Set where the player starts and respawns
// ----------------------------------------------------------------
{
  record_set_real(p_info, ATTR_SPAWN_X, p_x);
  record_set_real(p_info, ATTR_SPAWN_Y, p_y);
  record_set_real(p_info, ATTR_SPAWN_Z, p_z);
}

// ---------------------------------------------------------------- noise

void world_seed_shifts(Integer p_seed, Real &p_shift_a, Real &p_shift_b)
// ----------------------------------------------------------------
// Turn the world seed into the offsets used by the noise functions
// Any Integer works, including negative and very large seeds
// ----------------------------------------------------------------
{
  Integer l_low  = positive_mod(p_seed, 9973);
  Integer l_high = positive_mod(floor_divide(p_seed, 9973), 9967);

  p_shift_a = l_low  * 0.7310 + 13.0;
  p_shift_b = l_high * 0.5170 + 7.0;
}

Real world_value_noise(Real p_x, Real p_z, Integer p_layer, Real p_shift_a, Real p_shift_b)
// ----------------------------------------------------------------
// Smooth 2D value noise in [0, 1] for a seed's shifts
// layer picks an independent pattern
// ----------------------------------------------------------------
{
  Integer l_cell_x  = Floor(p_x);
  Integer l_cell_z  = Floor(p_z);
  Real    l_blend_x = smooth_curve(p_x - l_cell_x);
  Real    l_blend_z = smooth_curve(p_z - l_cell_z);
  Real    l_salt    = p_layer * 19.19 + p_shift_b;
  Real    l_v00     = hash_real(l_cell_x       + p_shift_a, l_cell_z       * 1.0, l_salt);
  Real    l_v10     = hash_real(l_cell_x + 1.0 + p_shift_a, l_cell_z       * 1.0, l_salt);
  Real    l_v01     = hash_real(l_cell_x       + p_shift_a, l_cell_z + 1.0      , l_salt);
  Real    l_v11     = hash_real(l_cell_x + 1.0 + p_shift_a, l_cell_z + 1.0      , l_salt);

  return lerp_real(lerp_real(l_v00, l_v10, l_blend_x), lerp_real(l_v01, l_v11, l_blend_x), l_blend_z);
}

Real world_desert_weight(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)
// ----------------------------------------------------------------
// 0 outside deserts, 1 deep inside one, smooth in between so the
// land flattens gradually towards a desert instead of stepping
// ----------------------------------------------------------------
{
  Real l_heat = world_value_noise(p_x / 58.0, p_z / 58.0, 7, p_shift_a, p_shift_b);

  return smooth_curve(clamp_real((l_heat - 0.56) / 0.12, 0.0, 1.0));
}

Integer world_column_biome(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)
// ----------------------------------------------------------------
// Land biome of a column (oceans and beaches are decided from the
// height afterwards)
// ----------------------------------------------------------------
{
  if (world_desert_weight(p_x, p_z, p_shift_a, p_shift_b) > 0.5) return BIOME_DESERT;
  if (world_value_noise(p_x / 34.0, p_z / 34.0, 6, p_shift_a, p_shift_b) > 0.52) return BIOME_FOREST;
  return BIOME_PLAINS;
}

Integer world_terrain_height(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)
// ----------------------------------------------------------------
// y of the top block of a column
// A slow "continent" pattern decides land or sea and gentle hills
// sit on top. A third pattern makes a few areas hilly; most land
// is rolling. Deserts are flatter. Anything that comes out below
// SEA_LEVEL becomes ocean floor.
// ----------------------------------------------------------------
{
  Real    l_continent = world_value_noise(p_x / 64.0, p_z / 64.0, 1, p_shift_a, p_shift_b);
  Real    l_hills     = world_value_noise(p_x / 30.0, p_z / 30.0, 2, p_shift_a, p_shift_b) * 0.72
                    + world_value_noise(p_x / 13.0, p_z / 13.0, 3, p_shift_a, p_shift_b) * 0.28;
  Real    l_rugged    = world_value_noise(p_x / 40.0, p_z / 40.0, 5, p_shift_a, p_shift_b);
  Real    l_desert    = world_desert_weight(p_x, p_z, p_shift_a, p_shift_b);
  Real    l_base      = 53.0 + l_continent * 26.0;
  Real    l_amplitude = 2.5 + l_rugged * l_rugged * l_rugged * 22.0;
  Real    l_height    = 0.0;
  Integer l_result    = 0;

  l_amplitude = l_amplitude * (1.0 - 0.6 * l_desert);
  l_base      = l_base + 2.0 * l_desert;

  if (l_base < SEA_LEVEL) {
    // Deepen the sea floor away from the coast
    l_base      = SEA_LEVEL - (SEA_LEVEL - l_base) * 1.6;
    l_amplitude = 3.0;
  }

  l_height = l_base + (l_hills - 0.5) * l_amplitude * 2.0;
  l_result = Floor(l_height);

  return clamp_integer(l_result, 6, WORLD_HEIGHT - 14);
}

// ---------------------------------------------------------------- generation

void world_fill_columns(Real p_shift_a, Real p_shift_b)
// ----------------------------------------------------------------
// Fill every column: bedrock floor, stone, a biome surface (grass
// on dirt, sand on sandstone in deserts, sand on beaches and the
// sea bed, gravel in the deep sea) and water up to SEA_LEVEL
// ----------------------------------------------------------------
{
  Integer l_x       = 0;
  Integer l_z       = 0;
  Integer l_y       = 0;
  Integer l_height  = 0;
  Integer l_biome   = 0;
  Integer l_base    = 0;
  Integer l_column  = 0;
  Integer l_block   = 0;
  Integer l_surface = 0;
  Integer l_under   = 0;
  Integer l_deep    = 0;
  Integer l_depth   = 0;

  for (l_x = 0; l_x < WORLD_SIZE_X; ++l_x) {
    for (l_z = 0; l_z < WORLD_SIZE_Z; ++l_z) {
      l_height = world_terrain_height(l_x, l_z, p_shift_a, p_shift_b);
      l_biome  = world_column_biome  (l_x, l_z, p_shift_a, p_shift_b);
      l_base   = world_index (l_x, 0, l_z);
      l_column = world_column(l_x, l_z);

      l_surface = BLOCK_GRASS;
      l_under   = BLOCK_DIRT;
      l_deep    = BLOCK_DIRT;
      l_depth   = 3;
      if (l_biome == BIOME_DESERT) {
        l_surface = BLOCK_SAND;
        l_under   = BLOCK_SAND;
        l_deep    = BLOCK_SANDSTONE;
        l_depth   = 6;
      }
      if (l_height < SEA_LEVEL + 1) {
        l_biome   = BIOME_BEACH;
        l_surface = BLOCK_SAND;
        l_under   = BLOCK_SAND;
        l_deep    = BLOCK_SANDSTONE;
        if (l_height < SEA_LEVEL - 2) l_biome = BIOME_OCEAN;
        if (l_height < SEA_LEVEL - 9) {
          l_surface = BLOCK_GRAVEL;
          l_under   = BLOCK_DIRT;
          l_deep    = BLOCK_DIRT;
        }
      }

      g_height_map [l_column] = l_height;
      g_solid_below[l_column] = l_height;
      g_biome_map  [l_column] = l_biome;

      for (l_y = 0; l_y < WORLD_HEIGHT; ++l_y) {
        l_block = BLOCK_AIR;
        if (l_y == 0) {
          l_block = BLOCK_BEDROCK;
        } else if (l_y <= 3 && hash_real(l_x * 1.0, l_y * 1.0, l_z + p_shift_a) < 0.7 / l_y) {
          l_block = BLOCK_BEDROCK;
        } else if (l_y < l_height - l_depth) {
          l_block = BLOCK_STONE;
        } else if (l_y < l_height - 3) {
          l_block = l_deep;
        } else if (l_y < l_height) {
          l_block = l_under;
        } else if (l_y == l_height) {
          l_block = l_surface;
        } else if (l_y < SEA_LEVEL) {
          l_block = BLOCK_WATER;
        }
        g_world[l_base + l_y] = l_block;
      }
    }
  }
}

void world_mark_carved(Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Note that a generated column is no longer solid up to its
// surface (so meshing doesn't skip the hollow section)
// ----------------------------------------------------------------
{
  Integer l_column = 0;

  if (!world_in_bounds(p_x, p_y, p_z)) return;
  l_column = world_column(p_x, p_z);
  if (p_y - 1 < g_solid_below[l_column]) g_solid_below[l_column] = p_y - 1;
}

void world_carve_sphere(Real p_centre_x, Real p_centre_y, Real p_centre_z, Real p_radius)
// ----------------------------------------------------------------
// Hollow out a ball of underground blocks for a cave. Water, the
// cells next to water and the bottom of the world are left alone
// so caves never drain the sea or break through the bedrock.
// ----------------------------------------------------------------
{
  Integer l_x0    = Floor(p_centre_x - p_radius);
  Integer l_x1    = Floor(p_centre_x + p_radius);
  Integer l_y0    = Floor(p_centre_y - p_radius);
  Integer l_y1    = Floor(p_centre_y + p_radius);
  Integer l_z0    = Floor(p_centre_z - p_radius);
  Integer l_z1    = Floor(p_centre_z + p_radius);
  Integer l_x     = 0;
  Integer l_y     = 0;
  Integer l_z     = 0;
  Integer l_block = 0;
  Integer l_wet   = 0;
  Real    l_dx    = 0.0;
  Real    l_dy    = 0.0;
  Real    l_dz    = 0.0;

  for (l_x = l_x0; l_x <= l_x1; ++l_x) {
    for (l_z = l_z0; l_z <= l_z1; ++l_z) {
      for (l_y = l_y0; l_y <= l_y1; ++l_y) {
        if (l_y <= 4) continue;
        if (!world_in_bounds(l_x, l_y, l_z)) continue;
        l_dx = l_x + 0.5 - p_centre_x;
        l_dy = (l_y + 0.5 - p_centre_y) * 1.3;
        l_dz = l_z + 0.5 - p_centre_z;
        if (l_dx * l_dx + l_dy * l_dy + l_dz * l_dz > p_radius * p_radius) continue;

        l_block = world_get_block(l_x, l_y, l_z);
        if (l_block == BLOCK_AIR || l_block == BLOCK_WATER || l_block == BLOCK_BEDROCK) continue;

        l_wet = FALSE;
        if (world_get_block(l_x + 1, l_y, l_z) == BLOCK_WATER) l_wet = TRUE;
        if (world_get_block(l_x - 1, l_y, l_z) == BLOCK_WATER) l_wet = TRUE;
        if (world_get_block(l_x, l_y + 1, l_z) == BLOCK_WATER) l_wet = TRUE;
        if (world_get_block(l_x, l_y, l_z + 1) == BLOCK_WATER) l_wet = TRUE;
        if (world_get_block(l_x, l_y, l_z - 1) == BLOCK_WATER) l_wet = TRUE;
        if (l_wet) continue;

        world_set_block  (l_x, l_y, l_z, BLOCK_AIR);
        world_mark_carved(l_x, l_y, l_z);
      }
    }
  }
}

void world_carve_caves(Attributes &p_random)
// ----------------------------------------------------------------
// Caves are dug by "worms": each starts somewhere underground and
// wanders, turning a little at every step, hollowing out a ball
// whose size swells and shrinks. A few reach the surface.
// ----------------------------------------------------------------
{
  Integer l_worms  = random_range(p_random, MAX_CAVE_WORMS - 5, MAX_CAVE_WORMS);
  Integer l_worm   = 0;
  Integer l_step   = 0;
  Integer l_top    = 0;
  Real    l_x      = 0.0;
  Real    l_y      = 0.0;
  Real    l_z      = 0.0;
  Real    l_yaw    = 0.0;
  Real    l_pitch  = 0.0;
  Real    l_phase  = 0.0;
  Real    l_radius = 0.0;

  for (l_worm = 1; l_worm <= l_worms; ++l_worm) {
    l_x     = random_between(p_random, 10.0, WORLD_SIZE_X - 10.0);
    l_z     = random_between(p_random, 10.0, WORLD_SIZE_Z - 10.0);
    l_top   = g_height_map[world_column(floor_integer(l_x), floor_integer(l_z))];
    l_y     = random_between(p_random, 10.0, max_real(12.0, l_top - 4.0));
    l_yaw   = random_between(p_random, 0.0, TWO_PI);
    l_pitch = random_between(p_random, -0.25, 0.25);
    l_phase = random_between(p_random, 0.0, TWO_PI);

    for (l_step = 1; l_step <= CAVE_WORM_STEPS; ++l_step) {
      l_radius = 1.5 + 1.0 * Sin(l_step * 0.16 + l_phase);
      world_carve_sphere(l_x, l_y, l_z, l_radius);

      l_x     = l_x + Cos(l_yaw) * Cos(l_pitch);
      l_z     = l_z + Sin(l_yaw) * Cos(l_pitch);
      l_y     = l_y + Sin(l_pitch);
      l_yaw   = l_yaw + random_between(p_random, -0.35, 0.35);
      l_pitch = clamp_real(l_pitch * 0.9 + random_between(p_random, -0.18, 0.18), -0.6, 0.6);

      if (l_y < 7.0) l_pitch = Absolute(l_pitch);
      if (l_x < 4.0 || l_z < 4.0 || l_x > WORLD_SIZE_X - 4.0 || l_z > WORLD_SIZE_Z - 4.0) break;
    }
  }
}

void world_place_veins(Attributes &p_random, Integer p_block, Integer p_count, Integer p_length, Integer p_max_y)
// ----------------------------------------------------------------
// Scatter count small veins of block through the stone below
// max_y, each a short random walk of length cells
// ----------------------------------------------------------------
{
  Integer l_vein = 0;
  Integer l_cell = 0;
  Integer l_x    = 0;
  Integer l_y    = 0;
  Integer l_z    = 0;
  Integer l_axis = 0;

  for (l_vein = 1; l_vein <= p_count; ++l_vein) {
    l_x = random_range(p_random, 1, WORLD_SIZE_X - 2);
    l_z = random_range(p_random, 1, WORLD_SIZE_Z - 2);
    l_y = random_range(p_random, 5, p_max_y);

    for (l_cell = 1; l_cell <= p_length; ++l_cell) {
      if (world_get_block(l_x, l_y, l_z) == BLOCK_STONE) world_set_block(l_x, l_y, l_z, p_block);
      l_axis = random_range(p_random, 1, 6);
      if (l_axis == 1) ++l_x;
      if (l_axis == 2) --l_x;
      if (l_axis == 3) ++l_y;
      if (l_axis == 4) --l_y;
      if (l_axis == 5) ++l_z;
      if (l_axis == 6) --l_z;
    }
  }
}

void world_plant_tree(Integer p_x, Integer p_ground_y, Integer p_z, Real p_shift_a, Real p_shift_b)
// ----------------------------------------------------------------
// An oak: a trunk of logs with a rounded crown of leaves
// The ground under the trunk becomes dirt
// ----------------------------------------------------------------
{
  Integer l_trunk  = 4 + Floor(hash_real(p_x * 3.1 + p_shift_a, p_z * 1.7, 41.0) * 3.0);
  Integer l_top    = p_ground_y + l_trunk;
  Integer l_y      = 0;
  Integer l_dx     = 0;
  Integer l_dz     = 0;
  Integer l_radius = 0;
  Integer l_corner = 0;
  Integer l_here   = 0;

  for (l_y = l_top - 2; l_y <= l_top + 1; ++l_y) {
    l_radius = 2;
    if (l_y >= l_top) l_radius = 1;
    for (l_dx = -l_radius; l_dx <= l_radius; ++l_dx) {
      for (l_dz = -l_radius; l_dz <= l_radius; ++l_dz) {
        l_corner = Absolute(l_dx) == l_radius && Absolute(l_dz) == l_radius;
        if (l_corner) {
          if (l_y == l_top + 1) continue;
          if (hash_real(p_x + l_dx * 1.0, l_y * 1.0, p_z + l_dz + p_shift_b) < 0.55) continue;
        }
        l_here = world_get_block(p_x + l_dx, l_y, p_z + l_dz);
        if (l_here == BLOCK_AIR || block_is_plant(l_here)) world_set_block(p_x + l_dx, l_y, p_z + l_dz, BLOCK_LEAVES);
      }
    }
  }

  for (l_y = p_ground_y + 1; l_y <= l_top; ++l_y) world_set_block(p_x, l_y, p_z, BLOCK_OAK_LOG);
  world_set_block(p_x, p_ground_y, p_z, BLOCK_DIRT);
}

void world_plant_trees(Real p_shift_a, Real p_shift_b)
// ----------------------------------------------------------------
// At most one tree per 5 x 5 patch: many in forests, the odd one on
// the plains (leaving open clearings), none in deserts or on sand
// ----------------------------------------------------------------
{
  Integer l_cell_x = 0;
  Integer l_cell_z = 0;
  Integer l_tree_x = 0;
  Integer l_tree_z = 0;
  Integer l_height = 0;
  Integer l_biome  = 0;
  Real    l_forest = 0.0;
  Real    l_chance = 0.0;

  for (l_cell_x = 0; l_cell_x < floor_divide(WORLD_SIZE_X, 5); ++l_cell_x) {
    for (l_cell_z = 0; l_cell_z < floor_divide(WORLD_SIZE_Z, 5); ++l_cell_z) {
      l_tree_x = l_cell_x * 5 + 1 + Floor(hash_real(l_cell_x * 1.0, l_cell_z * 1.0, 51.0 + p_shift_a) * 3.0);
      l_tree_z = l_cell_z * 5 + 1 + Floor(hash_real(l_cell_x * 1.0, l_cell_z * 1.0, 52.0 + p_shift_b) * 3.0);
      if (l_tree_x < 3 || l_tree_z < 3 || l_tree_x > WORLD_SIZE_X - 4 || l_tree_z > WORLD_SIZE_Z - 4) continue;

      l_biome  = world_biome(l_tree_x, l_tree_z);
      l_forest = world_value_noise(l_tree_x / 34.0, l_tree_z / 34.0, 6, p_shift_a, p_shift_b);
      l_chance = 0.04;
      if (l_biome == BIOME_FOREST) l_chance = 0.25 + (l_forest - 0.52) * 3.0;
      if (l_biome != BIOME_FOREST && l_biome != BIOME_PLAINS) l_chance = 0.0;
      if (hash_real(l_cell_x * 1.0, l_cell_z * 1.0, 53.0 + p_shift_a) > l_chance) continue;

      l_height = g_height_map[world_column(l_tree_x, l_tree_z)];
      if (world_get_block(l_tree_x, l_height, l_tree_z) != BLOCK_GRASS) continue;
      if (world_get_block(l_tree_x, l_height + 1, l_tree_z) != BLOCK_AIR) continue;
      if (l_height + 8 >= WORLD_HEIGHT) continue;

      world_plant_tree(l_tree_x, l_height, l_tree_z, p_shift_a, p_shift_b);
    }
  }
}

void world_plant_cactus(Integer p_x, Integer p_ground_y, Integer p_z, Integer p_tall)
// ----------------------------------------------------------------
// A cactus of tall blocks on sand, if nothing is next to it
// ----------------------------------------------------------------
{
  Integer l_y = 0;

  if (world_get_block(p_x + 1, p_ground_y + 1, p_z) != BLOCK_AIR) return;
  if (world_get_block(p_x - 1, p_ground_y + 1, p_z) != BLOCK_AIR) return;
  if (world_get_block(p_x, p_ground_y + 1, p_z + 1) != BLOCK_AIR) return;
  if (world_get_block(p_x, p_ground_y + 1, p_z - 1) != BLOCK_AIR) return;

  for (l_y = p_ground_y + 1; l_y <= p_ground_y + p_tall; ++l_y) world_set_block(p_x, l_y, p_z, BLOCK_CACTUS);
}

void world_add_plants(Attributes &p_random, Real p_shift_a, Real p_shift_b)
// ----------------------------------------------------------------
// Grass tufts and patches of flowers on open grass (thickest in
// meadows), cacti and dead bushes in the desert
// ----------------------------------------------------------------
{
  Integer l_x      = 0;
  Integer l_z      = 0;
  Integer l_top    = 0;
  Integer l_biome  = 0;
  Integer l_ground = 0;
  Real    l_meadow = 0.0;
  Real    l_roll   = 0.0;

  for (l_x = 1; l_x < WORLD_SIZE_X - 1; ++l_x) {
    for (l_z = 1; l_z < WORLD_SIZE_Z - 1; ++l_z) {
      l_top    = g_height_map[world_column(l_x, l_z)];
      l_ground = world_get_block(l_x, l_top, l_z);
      if (world_get_block(l_x, l_top + 1, l_z) != BLOCK_AIR) continue;
      l_biome  = world_biome(l_x, l_z);
      l_roll   = random_next(p_random);

      if (l_ground == BLOCK_GRASS) {
        l_meadow = world_value_noise(l_x / 18.0, l_z / 18.0, 8, p_shift_a, p_shift_b);
        if (l_roll < 0.06 + l_meadow * 0.22) {
          world_set_block(l_x, l_top + 1, l_z, BLOCK_TALL_GRASS);
        } else if (l_roll > 0.995 - l_meadow * 0.02) {
          if (world_value_noise(l_x / 9.0, l_z / 9.0, 9, p_shift_a, p_shift_b) > 0.5) {
            world_set_block(l_x, l_top + 1, l_z, BLOCK_POPPY);
          } else {
            world_set_block(l_x, l_top + 1, l_z, BLOCK_DANDELION);
          }
        }
      } else if (l_ground == BLOCK_SAND && l_biome == BIOME_DESERT) {
        if (l_roll < 0.012) {
          world_set_block(l_x, l_top + 1, l_z, BLOCK_DEAD_BUSH);
        } else if (l_roll < 0.030) {
          world_plant_cactus(l_x, l_top, l_z, random_range(p_random, 1, 3));
        }
      }
    }
  }
}

Integer world_area_is_flat(Integer p_x0, Integer p_z0, Integer p_x1, Integer p_z1, Integer &p_ground_y)
// ----------------------------------------------------------------
// TRUE if every generated surface in the rectangle is dry grass or
// sand within one block of the others; ground_y is set to the most
// common lower height to build on
// ----------------------------------------------------------------
{
  Integer l_x      = 0;
  Integer l_z      = 0;
  Integer l_height = 0;
  Integer l_low    = WORLD_HEIGHT;
  Integer l_high   = -1;
  Integer l_block  = 0;

  for (l_x = p_x0; l_x <= p_x1; ++l_x) {
    for (l_z = p_z0; l_z <= p_z1; ++l_z) {
      if (!world_in_bounds(l_x, 0, l_z)) return FALSE;
      l_height = g_height_map[world_column(l_x, l_z)];
      l_block  = world_get_block(l_x, l_height, l_z);
      if (l_height <= SEA_LEVEL) return FALSE;
      if (l_block != BLOCK_GRASS && l_block != BLOCK_SAND) return FALSE;
      if (l_height < l_low ) l_low  = l_height;
      if (l_height > l_high) l_high = l_height;
    }
  }
  p_ground_y = l_low;
  if (l_high - l_low > 1) return FALSE;
  return TRUE;
}

void world_dig_pond(Integer p_centre_x, Integer p_centre_z)
// ----------------------------------------------------------------
// A small round pond, 2 deep in the middle, in flat grassland
// ----------------------------------------------------------------
{
  Integer l_ground = 0;
  Integer l_x      = 0;
  Integer l_z      = 0;
  Integer l_y      = 0;
  Integer l_depth  = 0;
  Real    l_reach  = 0.0;

  if (!world_area_is_flat(p_centre_x - 4, p_centre_z - 4, p_centre_x + 4, p_centre_z + 4, l_ground)) return;

  for (l_x = p_centre_x - 3; l_x <= p_centre_x + 3; ++l_x) {
    for (l_z = p_centre_z - 3; l_z <= p_centre_z + 3; ++l_z) {
      l_reach = (l_x - p_centre_x) * (l_x - p_centre_x) + (l_z - p_centre_z) * (l_z - p_centre_z);
      if (l_reach > 10.5) continue;
      l_depth = 1;
      if (l_reach < 4.5) l_depth = 2;
      for (l_y = l_ground + 1; l_y <= l_ground + 3; ++l_y) world_set_block(l_x, l_y, l_z, BLOCK_AIR);
      for (l_y = l_ground - l_depth + 1; l_y <= l_ground; ++l_y) {
        world_set_block  (l_x, l_y, l_z, BLOCK_WATER);
        world_mark_carved(l_x, l_y, l_z);
      }
      world_set_block(l_x, l_ground - l_depth, l_z, BLOCK_SAND);
    }
  }
}

void world_add_ponds(Attributes &p_random)
// ----------------------------------------------------------------
// Try a few spots for ponds; most worlds get one or two
// ----------------------------------------------------------------
{
  Integer l_attempt = 0;
  Integer l_x       = 0;
  Integer l_z       = 0;
  Integer l_biome   = 0;

  for (l_attempt = 1; l_attempt <= MAX_PONDS * 6; ++l_attempt) {
    l_x     = random_range(p_random, 10, WORLD_SIZE_X - 11);
    l_z     = random_range(p_random, 10, WORLD_SIZE_Z - 11);
    l_biome = world_biome(l_x, l_z);
    if (l_biome != BIOME_PLAINS && l_biome != BIOME_FOREST) continue;
    if (random_next(p_random) > 0.25) continue;
    world_dig_pond(l_x, l_z);
  }
}

void world_build_house(Attributes &p_info, Integer p_origin_x, Integer p_ground_y, Integer p_origin_z)
// ----------------------------------------------------------------
// The starter house: a 7 x 7 cabin with a cobblestone floor, log
// corner posts, plank walls, a doorway facing -z, a window in each
// other wall and a stepped plank roof. An open door hangs in the
// doorway. Inside are a crafting table, a furnace, a two block bed,
// a chest and two torches. The ground is levelled under it and cleared around
// it. The spawn point is put inside.
// ----------------------------------------------------------------
{
  Integer l_x0     = p_origin_x;
  Integer l_z0     = p_origin_z;
  Integer l_x1     = p_origin_x + 6;
  Integer l_z1     = p_origin_z + 6;
  Integer l_floor_y  = p_ground_y;
  Integer l_x      = 0;
  Integer l_y      = 0;
  Integer l_z      = 0;
  Integer l_edge_x = 0;
  Integer l_edge_z = 0;
  Integer l_block  = 0;

  // Level: solid foundation below, open air above (one block of
  // margin all round so trees and plants don't touch the walls)
  for (l_x = l_x0 - 1; l_x <= l_x1 + 1; ++l_x) {
    for (l_z = l_z0 - 1; l_z <= l_z1 + 1; ++l_z) {
      for (l_y = l_floor_y + 1; l_y <= l_floor_y + 8; ++l_y) world_set_block(l_x, l_y, l_z, BLOCK_AIR);
      for (l_y = l_floor_y - 4; l_y <= l_floor_y; ++l_y) {
        if (!block_is_solid(world_get_block(l_x, l_y, l_z))) world_set_block(l_x, l_y, l_z, BLOCK_DIRT);
      }
      if (l_x < l_x0 || l_x > l_x1 || l_z < l_z0 || l_z > l_z1) world_set_block(l_x, l_floor_y, l_z, BLOCK_GRASS);
    }
  }

  for (l_x = l_x0; l_x <= l_x1; ++l_x) {
    for (l_z = l_z0; l_z <= l_z1; ++l_z) {
      l_edge_x = l_x == l_x0 || l_x == l_x1;
      l_edge_z = l_z == l_z0 || l_z == l_z1;

      world_set_block(l_x, l_floor_y, l_z, BLOCK_COBBLESTONE);

      for (l_y = l_floor_y + 1; l_y <= l_floor_y + 3; ++l_y) {
        l_block = BLOCK_AIR;
        if (l_edge_x || l_edge_z) l_block = BLOCK_PLANKS;
        if (l_edge_x && l_edge_z) l_block = BLOCK_OAK_LOG;
        world_set_block(l_x, l_y, l_z, l_block);
      }

      // Roof: a plank layer with log trim, then a smaller layer
      l_block = BLOCK_PLANKS;
      if (l_edge_x || l_edge_z) l_block = BLOCK_OAK_LOG;
      world_set_block(l_x, l_floor_y + 4, l_z, l_block);
      if (!l_edge_x && !l_edge_z) world_set_block(l_x, l_floor_y + 5, l_z, BLOCK_PLANKS);
    }
  }

  // Doorway in the middle of the -z wall, windows in the others
  world_set_block(l_x0 + 3, l_floor_y + 1, l_z0    , BLOCK_AIR);
  world_set_block(l_x0 + 3, l_floor_y + 2, l_z0    , BLOCK_AIR);
  world_set_block(l_x0    , l_floor_y + 2, l_z0 + 3, BLOCK_AIR);
  world_set_block(l_x1    , l_floor_y + 2, l_z0 + 3, BLOCK_AIR);
  world_set_block(l_x0 + 3, l_floor_y + 2, l_z1    , BLOCK_AIR);

  // Furniture along the back wall; the furnace faces the door
  world_set_block(l_x0 + 1, l_floor_y + 1, l_z1 - 1, BLOCK_CRAFTING_TABLE);
  world_set_block(l_x1 - 1, l_floor_y + 1, l_z1 - 1, BLOCK_FURNACE_NZ);
  world_set_block(l_x1 - 1, l_floor_y + 1, l_z0 + 3, block_bed(FACING_PZ, FALSE));
  world_set_block(l_x1 - 1, l_floor_y + 1, l_z0 + 4, block_bed(FACING_PZ, TRUE));
  // an open door in the doorway
  world_set_block(l_x0 + 3, l_floor_y + 1, l_z0    , block_door(FACING_NZ, TRUE, FALSE));
  world_set_block(l_x0 + 3, l_floor_y + 2, l_z0    , block_door(FACING_NZ, TRUE, TRUE));
  world_set_block(l_x0 + 1, l_floor_y + 1, l_z1 - 2, BLOCK_CHEST);
  world_set_block(l_x0 + 1, l_floor_y + 1, l_z0 + 1, BLOCK_TORCH);
  world_set_block(l_x1 - 1, l_floor_y + 1, l_z0 + 1, BLOCK_TORCH);

  record_set_integer(p_info, ATTR_HOUSE_X, l_x0);
  record_set_integer(p_info, ATTR_HOUSE_Y, l_floor_y);
  record_set_integer(p_info, ATTR_HOUSE_Z, l_z0);
  world_info_set_spawn(p_info, l_x0 + 3.5, l_floor_y + 1.0, l_z0 + 2.5);
}

void world_place_house_near(Attributes &p_info, Real p_spawn_x, Real p_spawn_z)
// ----------------------------------------------------------------
// Find the flattest dry spot for the starter house close to the
// spawn point, searching outwards in growing squares. If none is
// flat enough the house is built on the spawn point regardless
// (the foundation fills any dips).
// ----------------------------------------------------------------
{
  Integer l_centre_x = floor_integer(p_spawn_x) - 3;
  Integer l_centre_z = floor_integer(p_spawn_z) - 3;
  Integer l_radius   = 0;
  Integer l_x        = 0;
  Integer l_z        = 0;
  Integer l_ground   = 0;

  for (l_radius = 0; l_radius <= 24; ++l_radius) {
    for (l_x = l_centre_x - l_radius; l_x <= l_centre_x + l_radius; ++l_x) {
      for (l_z = l_centre_z - l_radius; l_z <= l_centre_z + l_radius; ++l_z) {
        if (Absolute(l_x - l_centre_x) != l_radius && Absolute(l_z - l_centre_z) != l_radius) continue;
        if (l_x < 3 || l_z < 3 || l_x + 10 > WORLD_SIZE_X || l_z + 10 > WORLD_SIZE_Z) continue;
        if (!world_area_is_flat(l_x - 1, l_z - 1, l_x + 7, l_z + 7, l_ground)) continue;
        world_build_house(p_info, l_x, l_ground, l_z);
        return;
      }
    }
  }

  l_x = clamp_integer(l_centre_x, 3, WORLD_SIZE_X - 10);
  l_z = clamp_integer(l_centre_z, 3, WORLD_SIZE_Z - 10);
  l_ground = g_height_map[world_column(l_x + 3, l_z + 3)];
  if (l_ground < SEA_LEVEL) l_ground = SEA_LEVEL;
  world_build_house(p_info, l_x, l_ground, l_z);
}

void world_find_spawn(Real &p_spawn_x, Real &p_spawn_y, Real &p_spawn_z)
// ----------------------------------------------------------------
// Pick the grass column nearest the middle of the world, searching
// outwards in growing squares
// ----------------------------------------------------------------
{
  Integer l_centre_x = floor_divide(WORLD_SIZE_X, 2);
  Integer l_centre_z = floor_divide(WORLD_SIZE_Z, 2);
  Integer l_radius   = 0;
  Integer l_x        = 0;
  Integer l_z        = 0;
  Integer l_top      = 0;

  for (l_radius = 0; l_radius < l_centre_x - 2; ++l_radius) {
    for (l_x = l_centre_x - l_radius; l_x <= l_centre_x + l_radius; ++l_x) {
      for (l_z = l_centre_z - l_radius; l_z <= l_centre_z + l_radius; ++l_z) {
        if (Absolute(l_x - l_centre_x) != l_radius && Absolute(l_z - l_centre_z) != l_radius) continue;
        l_top = world_top_solid_y(l_x, l_z);
        if (l_top < SEA_LEVEL) continue;
        if (world_get_block(l_x, l_top, l_z) != BLOCK_GRASS) continue;
        p_spawn_x = l_x + 0.5;
        p_spawn_y = l_top + 1.0;
        p_spawn_z = l_z + 0.5;
        return;
      }
    }
  }

  // No land at all: stand on top of whatever is in the middle
  l_top = world_top_solid_y(l_centre_x, l_centre_z);
  if (l_top < SEA_LEVEL - 1) l_top = SEA_LEVEL - 1;
  p_spawn_x = l_centre_x + 0.5;
  p_spawn_y = l_top + 1.0;
  p_spawn_z = l_centre_z + 0.5;
}

void world_finish_maps()
// ----------------------------------------------------------------
// Work out the sky top of every column (after generating, and
// again after a save's edits are applied)
// ----------------------------------------------------------------
{
  Integer l_x = 0;
  Integer l_z = 0;

  for (l_x = 0; l_x < WORLD_SIZE_X; ++l_x) {
    for (l_z = 0; l_z < WORLD_SIZE_Z; ++l_z) {
      g_column_top[world_column(l_x, l_z)] = world_top_opaque_y(l_x, l_z);
    }
  }
}

void world_generate(Attributes &p_info, Integer p_seed)
// ----------------------------------------------------------------
// Make the whole world from a seed: terrain and biomes, caves,
// coal and gravel, ponds, trees, plants, then the starter house
// near the middle where the player spawns
// ----------------------------------------------------------------
{
  Attributes l_random;
  Real       l_shift_a = 0.0;
  Real       l_shift_b = 0.0;
  Real       l_spawn_x = 0.0;
  Real       l_spawn_y = 0.0;
  Real       l_spawn_z = 0.0;

  world_info_clear (p_info, p_seed);
  world_seed_shifts(p_seed, l_shift_a, l_shift_b);
  random_seed      (l_random, p_seed);

  world_fill_columns(l_shift_a, l_shift_b);
  world_carve_caves (l_random);
  world_place_veins (l_random, BLOCK_COAL_ORE, COAL_VEINS, 6, 56);
  world_place_veins (l_random, BLOCK_GRAVEL, GRAVEL_POCKETS, 10, 50);
  world_place_veins (l_random, BLOCK_IRON_ORE, IRON_VEINS, 5, 44);
  world_add_ponds   (l_random);
  world_plant_trees (l_shift_a, l_shift_b);
  world_add_plants  (l_random, l_shift_a, l_shift_b);

  world_find_spawn      (l_spawn_x, l_spawn_y, l_spawn_z);
  world_info_set_spawn  (p_info, l_spawn_x, l_spawn_y, l_spawn_z);
  world_place_house_near(p_info, l_spawn_x, l_spawn_z);

  world_finish_maps();

  // The house torches light it (light is only worked out on changes)
  world_light_update(record_integer(p_info, ATTR_HOUSE_X) + 1, record_integer(p_info, ATTR_HOUSE_Y) + 1, record_integer(p_info, ATTR_HOUSE_Z) + 1);
  world_light_update(record_integer(p_info, ATTR_HOUSE_X) + 5, record_integer(p_info, ATTR_HOUSE_Y) + 1, record_integer(p_info, ATTR_HOUSE_Z) + 1);
}

#endif
