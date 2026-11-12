#ifndef MESH_4DM_INCLUDED
#define MESH_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/world/world.h"
#include "../../include/world/mesh.h"

Integer mesh_section_index(Integer p_sx, Integer p_sy, Integer p_sz)
// ----------------------------------------------------------------
// Array position of section (sx, sy, sz), all 0-based
// ----------------------------------------------------------------
{
  return (p_sx * SECTIONS_Z + p_sz) * SECTIONS_Y + p_sy + 1;
}

void mesh_reset()
// ----------------------------------------------------------------
// Forget every cached face list (after generating or loading)
// ----------------------------------------------------------------
{
  Integer l_section = 0;

  if (!g_cell_tables_ready) mesh_fill_cell_tables();
  for (l_section = 1; l_section <= NUM_SECTIONS; ++l_section) {
    g_section_state[l_section] = SECTION_UNBUILT;
    g_section_count[l_section] = 0;
  }
  g_mesh_overflow = 0;
  g_mesh_builds   = 0;
}

void mesh_fill_cell_tables()
// ----------------------------------------------------------------
// Work out, for every possible g_world cell value, its block, torch
// light, kind (CELL_*) and solidity, so the mesh builder can read
// them straight from a table
// ----------------------------------------------------------------
{
  Integer l_value = 0;
  Integer l_block = 0;

  for (l_value = 0; l_value < CELL_VALUES; ++l_value) {
    l_block = world_cell_block(l_value);
    g_cell_block[l_value + 1] = l_block;
    g_cell_light[l_value + 1] = world_cell_light(l_value);
    g_cell_solid[l_value + 1] = block_is_solid(l_block) && !block_is_shaped(l_block);
    if (l_block == BLOCK_AIR) {
      g_cell_kind[l_value + 1] = CELL_AIR;
    } else if (l_block == BLOCK_WATER) {
      g_cell_kind[l_value + 1] = CELL_WATER;
    } else if (block_is_plant(l_block)) {
      g_cell_kind[l_value + 1] = CELL_PLANT;
    } else if (block_is_shaped(l_block)) {
      g_cell_kind[l_value + 1] = CELL_SHAPED;
    } else if (block_is_see_through(l_block)) {
      g_cell_kind[l_value + 1] = CELL_SEE_THROUGH;
    } else {
      g_cell_kind[l_value + 1] = CELL_HIDES;
    }
  }
  g_cell_tables_ready = TRUE;
}

Integer mesh_section_buried(Integer p_sx, Integer p_sy, Integer p_sz)
// ----------------------------------------------------------------
// TRUE if, as generated, every block of the section and of the
// columns around it is solid up to above the section's top, so it
// cannot have a visible face. Caves and ponds lower a column's
// solid depth. Only valid for unedited sections (edits mark
// sections dirty, which skips this shortcut).
// ----------------------------------------------------------------
{
  Integer l_top = p_sy * SECTION_SIZE + SECTION_SIZE - 1;
  Integer l_x   = 0;
  Integer l_z   = 0;
  Integer l_x0  = p_sx * SECTION_SIZE - 1;
  Integer l_z0  = p_sz * SECTION_SIZE - 1;

  for (l_x = l_x0; l_x <= l_x0 + SECTION_SIZE + 1; ++l_x) {
    if (l_x < 0 || l_x >= WORLD_SIZE_X) continue;
    for (l_z = l_z0; l_z <= l_z0 + SECTION_SIZE + 1; ++l_z) {
      if (l_z < 0 || l_z >= WORLD_SIZE_Z) continue;
      if (world_solid_below(l_x, l_z) <= l_top) return FALSE;
    }
  }
  return TRUE;
}

Integer mesh_add_face(Integer p_entry, Integer p_x, Integer p_y, Integer p_z, Integer p_direction, Integer p_flag, Integer p_block)
// ----------------------------------------------------------------
// Write face entry p_entry of the pool (direction 0 for a plant's
// one entry) and return p_entry
// ----------------------------------------------------------------
{
  Integer l_direction = p_direction;

  if (l_direction == 0) l_direction = DIR_PLANT;
  g_face_x    [p_entry] = p_x;
  g_face_y    [p_entry] = p_y;
  g_face_z    [p_entry] = p_z;
  g_face_dir  [p_entry] = l_direction + p_flag;
  g_face_light[p_entry] = mesh_face_light(p_x, p_y, p_z, p_direction);
  g_face_block[p_entry] = p_block;
  return p_entry;
}

void mesh_build_section(Integer p_sx, Integer p_sy, Integer p_sz)
// ----------------------------------------------------------------
// Rebuild the face list of one section
// A solid block shows a face wherever its neighbour doesn't hide it
// (air or a plant); faces against water are kept too but flagged
// wet (only drawn when the camera is under water). Water only
// shows faces against air. Glass hides nothing but shows no face
// against glass. Plants, doors and beds are one DIR_PLANT entry.
// Outside the world counts as solid so the world edge isn't drawn.
// Cells are read straight from g_world and looked up in the
// g_cell_* tables: this runs for every cell of the section.
// ----------------------------------------------------------------
{
  Integer l_section   = mesh_section_index(p_sx, p_sy, p_sz);
  Integer l_start     = (l_section - 1) * SECTION_FACE_CAP;
  Integer l_count     = 0;
  Integer l_x0        = p_sx * SECTION_SIZE;
  Integer l_y0        = p_sy * SECTION_SIZE;
  Integer l_z0        = p_sz * SECTION_SIZE;
  Integer l_x         = 0;
  Integer l_y         = 0;
  Integer l_z         = 0;
  Integer l_column    = 0;
  Integer l_cell      = 0;
  Integer l_value     = 0;
  Integer l_kind      = 0;
  Integer l_block     = 0;
  Integer l_direction = 0;
  Integer l_other     = 0;
  Integer l_other_kind = 0;
  Integer l_flag      = 0;

  ++g_mesh_builds;

  if (g_section_state[l_section] == SECTION_UNBUILT) {
    if (mesh_section_buried(p_sx, p_sy, p_sz)) {
      g_section_count[l_section] = 0;
      g_section_state[l_section] = SECTION_BUILT;
      mesh_group_faces(l_section, l_x0, l_y0, l_z0);
      return;
    }
  }

  for (l_x = l_x0; l_x < l_x0 + SECTION_SIZE; ++l_x) {
    for (l_z = l_z0; l_z < l_z0 + SECTION_SIZE; ++l_z) {
      l_column = world_index(l_x, 0, l_z);
      for (l_y = l_y0; l_y < l_y0 + SECTION_SIZE; ++l_y) {
        l_cell  = l_column + l_y;
        l_value = g_world[l_cell];
        l_kind  = g_cell_kind[l_value + 1];
        if (l_kind == CELL_AIR) continue;
        l_block = g_cell_block[l_value + 1];

        if (l_kind == CELL_PLANT || l_kind == CELL_SHAPED) {
          if (l_count >= SECTION_FACE_CAP) {
            ++g_mesh_overflow;
            continue;
          }
          ++l_count;
          mesh_add_face(l_start + l_count, l_x, l_y, l_z, 0, 0, l_block);
          continue;
        }

        for (l_direction = DIR_PX; l_direction <= DIR_NZ; ++l_direction) {
          // the neighbour's value (outside the world: stone, or air above)
          l_other = BLOCK_STONE;
          if (l_direction == DIR_PX) {
            if (l_x + 1 < WORLD_SIZE_X) l_other = g_world[l_cell + WORLD_STRIDE_X];
          } else if (l_direction == DIR_NX) {
            if (l_x > 0) l_other = g_world[l_cell - WORLD_STRIDE_X];
          } else if (l_direction == DIR_PY) {
            l_other = BLOCK_AIR;
            if (l_y + 1 < WORLD_HEIGHT) l_other = g_world[l_cell + 1];
          } else if (l_direction == DIR_NY) {
            if (l_y > 0) l_other = g_world[l_cell - 1];
          } else if (l_direction == DIR_PZ) {
            if (l_z + 1 < WORLD_SIZE_Z) l_other = g_world[l_cell + WORLD_STRIDE_Z];
          } else {
            if (l_z > 0) l_other = g_world[l_cell - WORLD_STRIDE_Z];
          }
          l_other_kind = g_cell_kind[l_other + 1];

          if (l_other_kind == CELL_HIDES) continue;
          l_flag = 0;
          if (l_other_kind == CELL_SEE_THROUGH) {
            if (l_kind == CELL_SEE_THROUGH && g_cell_block[l_other + 1] == l_block) continue;   // glass against glass
          } else if (l_other_kind == CELL_WATER) {
            if (l_kind == CELL_WATER) continue;
            l_flag = DIR_WET_FLAG;
          }

          if (l_count >= SECTION_FACE_CAP) {
            ++g_mesh_overflow;
            continue;
          }
          ++l_count;
          mesh_add_face(l_start + l_count, l_x, l_y, l_z, l_direction, l_flag, l_block);
        }
      }
    }
  }

  g_section_count[l_section] = l_count;
  g_section_state[l_section] = SECTION_BUILT;
  mesh_group_faces(l_section, l_x0, l_y0, l_z0);
}

Integer mesh_face_light(Integer p_x, Integer p_y, Integer p_z, Integer p_direction)
// ----------------------------------------------------------------
// Light of the face of cell (x, y, z) facing direction, or of the
// cell itself for direction 0 (plants), as sky + FACE_TORCH_SCALE *
// torch, both 0..LIGHT_FULL. The renderer dims the sky part at night
// and uses whichever part is brighter.
// Daylight fades with depth below the sky top of the column in
// front of the face; then the face is darkened by solid blocks
// around the cell in front: 4 edge neighbours count 2, 4 corner
// neighbours count 1, out of 12.
// When the cell in front and all its neighbours across the face are
// inside the world (nearly always), they are read straight from
// g_world through the g_cell_* tables.
// ----------------------------------------------------------------
{
  Integer l_front_x  = p_x;
  Integer l_front_y  = p_y;
  Integer l_front_z  = p_z;
  Integer l_sky_top  = -1;
  Integer l_light    = LIGHT_FULL;
  Integer l_enclosed = 0;
  Integer l_a        = 0;
  Integer l_b        = 0;
  Integer l_torch    = 0;
  Integer l_front    = 0;
  Integer l_step_a   = 0;
  Integer l_step_b   = 0;
  Integer l_inside   = FALSE;
  Integer l_solid    = 0;

  if (p_direction == DIR_PX) l_front_x = p_x + 1;
  if (p_direction == DIR_NX) l_front_x = p_x - 1;
  if (p_direction == DIR_PY) l_front_y = p_y + 1;
  if (p_direction == DIR_NY) l_front_y = p_y - 1;
  if (p_direction == DIR_PZ) l_front_z = p_z + 1;
  if (p_direction == DIR_NZ) l_front_z = p_z - 1;

  // A whole block of neighbours around the front cell in the world?
  if (l_front_x >= 1 && l_front_x < WORLD_SIZE_X - 1) {
    if (l_front_z >= 1 && l_front_z < WORLD_SIZE_Z - 1) {
      if (l_front_y >= 1 && l_front_y < WORLD_HEIGHT - 1) l_inside = TRUE;
    }
  }

  if (l_inside) {
    l_sky_top = g_column_top[l_front_x * WORLD_SIZE_Z + l_front_z + 1];
    l_front   = (l_front_x * WORLD_SIZE_Z + l_front_z) * WORLD_HEIGHT + l_front_y + 1;
    l_torch   = g_cell_light[g_world[l_front] + 1];
  } else {
    l_sky_top = world_sky_top(l_front_x, l_front_z);
    l_torch   = world_get_light(l_front_x, l_front_y, l_front_z);
  }
  if (l_front_y <= l_sky_top) {
    l_light = LIGHT_FULL - (l_sky_top - l_front_y + 1) * LIGHT_DEPTH_STEP;
    if (l_light < LIGHT_MIN) l_light = LIGHT_MIN;
  }
  l_torch = floor_divide(l_torch * LIGHT_FULL, LIGHT_MAX_LEVEL);
  if (p_direction == 0) return l_light + FACE_TORCH_SCALE * l_torch;

  // The two axes across the face, a and b, as steps in g_world
  if (p_direction == DIR_PX || p_direction == DIR_NX) {
    l_step_a = 1;
    l_step_b = WORLD_STRIDE_Z;
  } else if (p_direction == DIR_PY || p_direction == DIR_NY) {
    l_step_a = WORLD_STRIDE_X;
    l_step_b = WORLD_STRIDE_Z;
  } else {
    l_step_a = WORLD_STRIDE_X;
    l_step_b = 1;
  }

  for (l_a = -1; l_a <= 1; ++l_a) {
    for (l_b = -1; l_b <= 1; ++l_b) {
      if (l_a == 0 && l_b == 0) continue;
      if (l_inside) {
        l_solid = g_cell_solid[g_world[l_front + l_a * l_step_a + l_b * l_step_b] + 1];
      } else if (p_direction == DIR_PX || p_direction == DIR_NX) {
        l_solid = world_is_solid(l_front_x, l_front_y + l_a, l_front_z + l_b);
      } else if (p_direction == DIR_PY || p_direction == DIR_NY) {
        l_solid = world_is_solid(l_front_x + l_a, l_front_y, l_front_z + l_b);
      } else {
        l_solid = world_is_solid(l_front_x + l_a, l_front_y + l_b, l_front_z);
      }
      if (!l_solid) continue;
      if (l_a == 0 || l_b == 0) {
        l_enclosed = l_enclosed + 2;
      } else {
        l_enclosed = l_enclosed + 1;
      }
    }
  }

  l_light = l_light - floor_divide(l_light * l_enclosed * LIGHT_AO_STRENGTH, 1200);
  l_torch = l_torch - floor_divide(l_torch * l_enclosed * LIGHT_AO_STRENGTH, 1200);
  return l_light + FACE_TORCH_SCALE * l_torch;
}

Integer mesh_layer_key(Integer p_direction, Integer p_local_x, Integer p_local_y, Integer p_local_z)
// ----------------------------------------------------------------
// Sort key 1..LAYER_KEYS of a face: its direction group, then its
// layer (the cell's 0..15 position in the section along the face's
// axis). direction may carry DIR_WET_FLAG.
// ----------------------------------------------------------------
{
  Integer l_group = p_direction;
  Integer l_layer = 0;

  if (l_group > DIR_WET_FLAG) l_group = l_group - DIR_WET_FLAG;
  if (l_group == DIR_PX || l_group == DIR_NX) l_layer = p_local_x;
  if (l_group == DIR_PY || l_group == DIR_NY) l_layer = p_local_y;
  if (l_group == DIR_PZ || l_group == DIR_NZ) l_layer = p_local_z;

  return (l_group - 1) * SECTION_SIZE + l_layer + 1;
}

void mesh_group_faces(Integer p_section, Integer p_x0, Integer p_y0, Integer p_z0)
// ----------------------------------------------------------------
// Sort a section (whose lowest cell is x0, y0, z0) by layer key (a
// counting sort) and record where each key starts. The renderer
// then takes, for each direction, only the layers whose faces point
// towards the eye, instead of testing every face.
// ----------------------------------------------------------------
{
  Integer l_start    = (p_section - 1) * SECTION_FACE_CAP;
  Integer l_table    = (p_section - 1) * SECTION_LAYER_SLOTS;
  Integer l_count    = g_section_count[p_section];
  Integer l_entry    = 0;
  Integer l_key      = 0;
  Integer l_position = 0;
  Integer l_running  = 0;

  for (l_key = 1; l_key <= SECTION_LAYER_SLOTS; ++l_key) g_sort_next[l_key] = 0;

  for (l_entry = 1; l_entry <= l_count; ++l_entry) {
    l_key = mesh_layer_key(g_face_dir[l_start + l_entry], g_face_x[l_start + l_entry] - p_x0,
                           g_face_y[l_start + l_entry] - p_y0, g_face_z[l_start + l_entry] - p_z0);
    g_sort_key[l_entry] = l_key;
    g_sort_next[l_key]  = g_sort_next[l_key] + 1;
  }

  // Counts to starting entries
  l_running = 1;
  for (l_key = 1; l_key <= LAYER_KEYS; ++l_key) {
    g_section_layer_start[l_table + l_key] = l_running;
    l_running          = l_running + g_sort_next[l_key];
    g_sort_next[l_key] = g_section_layer_start[l_table + l_key];
  }
  g_section_layer_start[l_table + SECTION_LAYER_SLOTS] = l_running;

  for (l_entry = 1; l_entry <= l_count; ++l_entry) {
    l_key      = g_sort_key[l_entry];
    l_position = g_sort_next[l_key];
    g_sort_next[l_key] = l_position + 1;
    g_sort_x    [l_position] = g_face_x    [l_start + l_entry];
    g_sort_y    [l_position] = g_face_y    [l_start + l_entry];
    g_sort_z    [l_position] = g_face_z    [l_start + l_entry];
    g_sort_dir  [l_position] = g_face_dir  [l_start + l_entry];
    g_sort_light[l_position] = g_face_light[l_start + l_entry];
    g_sort_block[l_position] = g_face_block[l_start + l_entry];
  }

  for (l_entry = 1; l_entry <= l_count; ++l_entry) {
    g_face_x    [l_start + l_entry] = g_sort_x    [l_entry];
    g_face_y    [l_start + l_entry] = g_sort_y    [l_entry];
    g_face_z    [l_start + l_entry] = g_sort_z    [l_entry];
    g_face_dir  [l_start + l_entry] = g_sort_dir  [l_entry];
    g_face_light[l_start + l_entry] = g_sort_light[l_entry];
    g_face_block[l_start + l_entry] = g_sort_block[l_entry];
  }
}

void mesh_build_nearby(Real p_eye_x, Real p_eye_y, Real p_eye_z, Integer p_range, Integer p_budget)
// ----------------------------------------------------------------
// Background loading: build up to budget sections that are within
// range of the eye but not current yet, nearest first, whether or
// not they are in view. The renderer builds the sections it is
// about to draw itself; this gets the others ready a few per frame,
// so turning round doesn't have to build them all in one frame.
// ----------------------------------------------------------------
{
  Integer l_sx0     = clamp_integer(floor_integer((p_eye_x - p_range) / SECTION_SIZE), 0, SECTIONS_X - 1);
  Integer l_sx1     = clamp_integer(floor_integer((p_eye_x + p_range) / SECTION_SIZE), 0, SECTIONS_X - 1);
  Integer l_sy0     = clamp_integer(floor_integer((p_eye_y - p_range) / SECTION_SIZE), 0, SECTIONS_Y - 1);
  Integer l_sy1     = clamp_integer(floor_integer((p_eye_y + p_range) / SECTION_SIZE), 0, SECTIONS_Y - 1);
  Integer l_sz0     = clamp_integer(floor_integer((p_eye_z - p_range) / SECTION_SIZE), 0, SECTIONS_Z - 1);
  Integer l_sz1     = clamp_integer(floor_integer((p_eye_z + p_range) / SECTION_SIZE), 0, SECTIONS_Z - 1);
  Integer l_sx      = 0;
  Integer l_sy      = 0;
  Integer l_sz      = 0;
  Integer l_built   = 0;
  Integer l_best_x  = 0;
  Integer l_best_y  = 0;
  Integer l_best_z  = 0;
  Integer l_found   = FALSE;
  Real    l_reach   = p_range + 14.0;
  Real    l_dx      = 0.0;
  Real    l_dy      = 0.0;
  Real    l_dz      = 0.0;
  Real    l_dist_sq = 0.0;
  Real    l_best_sq = 0.0;

  for (l_built = 1; l_built <= p_budget; ++l_built) {
    l_found = FALSE;
    for (l_sx = l_sx0; l_sx <= l_sx1; ++l_sx) {
      for (l_sz = l_sz0; l_sz <= l_sz1; ++l_sz) {
        for (l_sy = l_sy0; l_sy <= l_sy1; ++l_sy) {
          if (g_section_state[mesh_section_index(l_sx, l_sy, l_sz)] == SECTION_BUILT) continue;
          l_dx = l_sx * SECTION_SIZE + 8.0 - p_eye_x;
          l_dy = l_sy * SECTION_SIZE + 8.0 - p_eye_y;
          l_dz = l_sz * SECTION_SIZE + 8.0 - p_eye_z;
          l_dist_sq = l_dx * l_dx + l_dy * l_dy + l_dz * l_dz;
          if (l_dist_sq > l_reach * l_reach) continue;
          if (l_found) {
            if (l_dist_sq >= l_best_sq) continue;
          }
          l_found   = TRUE;
          l_best_sq = l_dist_sq;
          l_best_x  = l_sx;
          l_best_y  = l_sy;
          l_best_z  = l_sz;
        }
      }
    }
    if (!l_found) return;
    mesh_build_section(l_best_x, l_best_y, l_best_z);
  }
}

Integer mesh_ensure_section(Integer p_sx, Integer p_sy, Integer p_sz)
// ----------------------------------------------------------------
// Make sure a section's face list is current and return its index
// ----------------------------------------------------------------
{
  Integer l_section = mesh_section_index(p_sx, p_sy, p_sz);

  if (g_section_state[l_section] != SECTION_BUILT) mesh_build_section(p_sx, p_sy, p_sz);

  return l_section;
}

void mesh_mark_dirty(Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// A block changed: its section, and any section it borders, must
// be rebuilt before it is next drawn. Light depends on the blocks
// above and around, so the sections below the change (shadows) and
// the diagonal neighbours (corner shading) are rebuilt too.
// ----------------------------------------------------------------
{
  Integer l_dx = 0;
  Integer l_dy = 0;
  Integer l_dz = 0;
  Integer l_sx = 0;
  Integer l_sy = 0;
  Integer l_sz = 0;

  for (l_dx = -1; l_dx <= 1; ++l_dx) {
    for (l_dy = -1; l_dy <= 1; ++l_dy) {
      for (l_dz = -1; l_dz <= 1; ++l_dz) {
        if (!world_in_bounds(p_x + l_dx, p_y + l_dy, p_z + l_dz)) continue;
        l_sx = floor_divide(p_x + l_dx, SECTION_SIZE);
        l_sy = floor_divide(p_y + l_dy, SECTION_SIZE);
        l_sz = floor_divide(p_z + l_dz, SECTION_SIZE);
        g_section_state[mesh_section_index(l_sx, l_sy, l_sz)] = SECTION_DIRTY;
      }
    }
  }

  // Shadow below: the section under the change in this column (the
  // shadow reaches further, but rebuilding every section down to
  // the bedrock would stall the game; deeper ones catch up when
  // something near them changes)
  l_sx = floor_divide(p_x, SECTION_SIZE);
  l_sz = floor_divide(p_z, SECTION_SIZE);
  l_sy = floor_divide(p_y, SECTION_SIZE) - 1;
  if (l_sy >= 0) g_section_state[mesh_section_index(l_sx, l_sy, l_sz)] = SECTION_DIRTY;
}

void mesh_mark_box_dirty(Integer p_x, Integer p_y, Integer p_z, Integer p_radius)
// ----------------------------------------------------------------
// Every section touching the box of radius cells round (x, y, z)
// must be rebuilt (its faces' light may have changed)
// ----------------------------------------------------------------
{
  Integer l_sx0 = clamp_integer(floor_divide(p_x - p_radius, SECTION_SIZE), 0, SECTIONS_X - 1);
  Integer l_sx1 = clamp_integer(floor_divide(p_x + p_radius, SECTION_SIZE), 0, SECTIONS_X - 1);
  Integer l_sy0 = clamp_integer(floor_divide(p_y - p_radius, SECTION_SIZE), 0, SECTIONS_Y - 1);
  Integer l_sy1 = clamp_integer(floor_divide(p_y + p_radius, SECTION_SIZE), 0, SECTIONS_Y - 1);
  Integer l_sz0 = clamp_integer(floor_divide(p_z - p_radius, SECTION_SIZE), 0, SECTIONS_Z - 1);
  Integer l_sz1 = clamp_integer(floor_divide(p_z + p_radius, SECTION_SIZE), 0, SECTIONS_Z - 1);
  Integer l_sx  = 0;
  Integer l_sy  = 0;
  Integer l_sz  = 0;

  for (l_sx = l_sx0; l_sx <= l_sx1; ++l_sx) {
    for (l_sy = l_sy0; l_sy <= l_sy1; ++l_sy) {
      for (l_sz = l_sz0; l_sz <= l_sz1; ++l_sz) {
        if (g_section_state[mesh_section_index(l_sx, l_sy, l_sz)] == SECTION_BUILT) {
          g_section_state[mesh_section_index(l_sx, l_sy, l_sz)] = SECTION_DIRTY;
        }
      }
    }
  }
}

void mesh_on_event(Attributes &p_event)
// ----------------------------------------------------------------
// Event handler: rebuild sections around changed blocks, and every
// section a change of block light can reach
// ----------------------------------------------------------------
{
  Integer l_type = event_type(p_event);

  if (l_type == EVT_BLOCK_BROKEN || l_type == EVT_BLOCK_PLACED || l_type == EVT_FURNACE_LIT) {
    mesh_mark_dirty(event_integer(p_event, 1), event_integer(p_event, 2), event_integer(p_event, 3));
  } else if (l_type == EVT_LIGHT_CHANGED) {
    mesh_mark_box_dirty(event_integer(p_event, 1), event_integer(p_event, 2), event_integer(p_event, 3), LIGHT_RADIUS + 1);
  }
}

#endif
