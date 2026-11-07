#ifndef PHYSICS_4DM_INCLUDED
#define PHYSICS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/blocks/blocks.h"
#include "../../include/world/world.h"
#include "../../include/world/physics.h"

Integer physics_cell_box(Integer p_x, Integer p_y, Integer p_z, Real &p_min_x, Real &p_min_y, Real &p_min_z,
                         Real &p_max_x, Real &p_max_y, Real &p_max_z)
// ----------------------------------------------------------------
// The solid box in cell (x, y, z), in world coordinates: the whole
// cell, or a door's panel or a bed's low box. Returns FALSE if
// nothing in the cell blocks movement.
// ----------------------------------------------------------------
{
  Integer l_block = 0;

  p_min_x = p_x;
  p_min_y = p_y;
  p_min_z = p_z;
  p_max_x = p_x + 1.0;
  p_max_y = p_y + 1.0;
  p_max_z = p_z + 1.0;
  if (!world_is_solid(p_x, p_y, p_z)) return FALSE;
  if (!world_in_bounds(p_x, p_y, p_z)) return TRUE;
  l_block = world_get_block(p_x, p_y, p_z);
  if (block_box(l_block, p_min_x, p_min_y, p_min_z, p_max_x, p_max_y, p_max_z)) {
    p_min_x = p_x + p_min_x;
    p_min_y = p_y + p_min_y;
    p_min_z = p_z + p_min_z;
    p_max_x = p_x + p_max_x;
    p_max_y = p_y + p_max_y;
    p_max_z = p_z + p_max_z;
  } else {
    p_min_x = p_x;
    p_min_y = p_y;
    p_min_z = p_z;
    p_max_x = p_x + 1.0;
    p_max_y = p_y + 1.0;
    p_max_z = p_z + 1.0;
  }
  return TRUE;
}

Real physics_box_limit(Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z,
                       Integer p_axis, Integer p_direction)
// ----------------------------------------------------------------
// Of the solid boxes that overlap the given box, the face a box
// moving along axis (1 x, 2 y, 3 z) in direction (+1 or -1) runs
// into: the highest top / far side for -1, the lowest bottom / near
// side for +1. Returns -1000000 (or +1000000) if nothing overlaps.
// ----------------------------------------------------------------
{
  Integer l_x0    = Floor(p_min_x);
  Integer l_y0    = Floor(p_min_y);
  Integer l_z0    = Floor(p_min_z);
  Integer l_x1    = Floor(p_max_x - COLLISION_EPSILON * 0.1);
  Integer l_y1    = Floor(p_max_y - COLLISION_EPSILON * 0.1);
  Integer l_z1    = Floor(p_max_z - COLLISION_EPSILON * 0.1);
  Integer l_x     = 0;
  Integer l_y     = 0;
  Integer l_z     = 0;
  Real    l_bx0   = 0.0;
  Real    l_by0   = 0.0;
  Real    l_bz0   = 0.0;
  Real    l_bx1   = 0.0;
  Real    l_by1   = 0.0;
  Real    l_bz1   = 0.0;
  Real    l_face  = 0.0;
  Real    l_limit = 1000000.0;

  if (p_direction < 0) l_limit = -1000000.0;
  for (l_x = l_x0; l_x <= l_x1; ++l_x) {
    for (l_z = l_z0; l_z <= l_z1; ++l_z) {
      for (l_y = l_y0; l_y <= l_y1; ++l_y) {
        if (!physics_cell_box(l_x, l_y, l_z, l_bx0, l_by0, l_bz0, l_bx1, l_by1, l_bz1)) continue;
        if (l_bx1 <= p_min_x || l_bx0 >= p_max_x) continue;
        if (l_by1 <= p_min_y || l_by0 >= p_max_y) continue;
        if (l_bz1 <= p_min_z || l_bz0 >= p_max_z) continue;
        if (p_axis == 1) {
          l_face = l_bx0;
          if (p_direction < 0) l_face = l_bx1;
        } else if (p_axis == 2) {
          l_face = l_by0;
          if (p_direction < 0) l_face = l_by1;
        } else {
          l_face = l_bz0;
          if (p_direction < 0) l_face = l_bz1;
        }
        if (p_direction < 0) {
          if (l_face > l_limit) l_limit = l_face;
        } else {
          if (l_face < l_limit) l_limit = l_face;
        }
      }
    }
  }
  return l_limit;
}

Integer physics_box_collides(Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)
// ----------------------------------------------------------------
// TRUE if any solid box (a whole cell, or the part of it a door or
// bed fills) overlaps the box
// ----------------------------------------------------------------
{
  return physics_box_limit(p_min_x, p_min_y, p_min_z, p_max_x, p_max_y, p_max_z, 2, -1) > -999999.0;
}

void physics_move_box(Real &p_x, Real &p_y, Real &p_z, Real p_half_width, Real p_height, Real p_dx, Real p_dy, Real p_dz,
                      Integer &p_hit_x, Integer &p_hit_z, Integer &p_hit_down, Integer &p_hit_up)
// ----------------------------------------------------------------
// Move a box by (dx, dy, dz), one axis at a time (y, then x, then
// z) so it slides along walls. When an axis is blocked the box is
// pushed back to touch the blocking cell. Each step must be under
// one block; callers split long moves into steps of MAX_MOVE_STEP.
// Reports which way it was blocked in hit_x, hit_z, hit_down and
// hit_up.
// ----------------------------------------------------------------
{
  Real l_new_x = p_x;
  Real l_new_y = p_y;
  Real l_new_z = p_z;

  p_hit_x    = FALSE;
  p_hit_z    = FALSE;
  p_hit_down = FALSE;
  p_hit_up   = FALSE;

  if (p_dy != 0.0) {
    l_new_y = p_y + p_dy;
    if (physics_box_collides(p_x - p_half_width, l_new_y, p_z - p_half_width, p_x + p_half_width, l_new_y + p_height, p_z + p_half_width)) {
      if (p_dy < 0.0) {
        l_new_y    = physics_box_limit(p_x - p_half_width, l_new_y, p_z - p_half_width, p_x + p_half_width, l_new_y + p_height, p_z + p_half_width, 2, -1) + COLLISION_EPSILON;
        p_hit_down = TRUE;
      } else {
        l_new_y  = physics_box_limit(p_x - p_half_width, l_new_y, p_z - p_half_width, p_x + p_half_width, l_new_y + p_height, p_z + p_half_width, 2, 1) - p_height - COLLISION_EPSILON;
        p_hit_up = TRUE;
      }
      if (physics_box_collides(p_x - p_half_width, l_new_y, p_z - p_half_width, p_x + p_half_width, l_new_y + p_height, p_z + p_half_width)) {
        l_new_y = p_y;
      }
    }
    p_y = l_new_y;
  }

  if (p_dx != 0.0) {
    l_new_x = p_x + p_dx;
    if (physics_box_collides(l_new_x - p_half_width, p_y, p_z - p_half_width, l_new_x + p_half_width, p_y + p_height, p_z + p_half_width)) {
      if (p_dx < 0.0) {
        l_new_x = physics_box_limit(l_new_x - p_half_width, p_y, p_z - p_half_width, l_new_x + p_half_width, p_y + p_height, p_z + p_half_width, 1, -1) + p_half_width + COLLISION_EPSILON;
      } else {
        l_new_x = physics_box_limit(l_new_x - p_half_width, p_y, p_z - p_half_width, l_new_x + p_half_width, p_y + p_height, p_z + p_half_width, 1, 1) - p_half_width - COLLISION_EPSILON;
      }
      if (physics_box_collides(l_new_x - p_half_width, p_y, p_z - p_half_width, l_new_x + p_half_width, p_y + p_height, p_z + p_half_width)) {
        l_new_x = p_x;
      }
      p_hit_x = TRUE;
    }
    p_x = l_new_x;
  }

  if (p_dz != 0.0) {
    l_new_z = p_z + p_dz;
    if (physics_box_collides(p_x - p_half_width, p_y, l_new_z - p_half_width, p_x + p_half_width, p_y + p_height, l_new_z + p_half_width)) {
      if (p_dz < 0.0) {
        l_new_z = physics_box_limit(p_x - p_half_width, p_y, l_new_z - p_half_width, p_x + p_half_width, p_y + p_height, l_new_z + p_half_width, 3, -1) + p_half_width + COLLISION_EPSILON;
      } else {
        l_new_z = physics_box_limit(p_x - p_half_width, p_y, l_new_z - p_half_width, p_x + p_half_width, p_y + p_height, l_new_z + p_half_width, 3, 1) - p_half_width - COLLISION_EPSILON;
      }
      if (physics_box_collides(p_x - p_half_width, p_y, l_new_z - p_half_width, p_x + p_half_width, p_y + p_height, l_new_z + p_half_width)) {
        l_new_z = p_z;
      }
      p_hit_z = TRUE;
    }
    p_z = l_new_z;
  }
}

Integer physics_box_in_water(Real p_x, Real p_y, Real p_z, Real p_half_width, Real p_height)
// ----------------------------------------------------------------
// TRUE if the lower part of a box is in a water cell
// ----------------------------------------------------------------
{
  Integer l_cell_x = Floor(p_x);
  Integer l_cell_y = Floor(p_y + p_height * 0.3);
  Integer l_cell_z = Floor(p_z);

  if (world_get_block(l_cell_x, l_cell_y, l_cell_z) == BLOCK_WATER) return TRUE;
  return FALSE;
}

Integer physics_raycast_blocks(Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_max_distance,
                               Integer &p_hit_x, Integer &p_hit_y, Integer &p_hit_z,
                               Integer &p_normal_x, Integer &p_normal_y, Integer &p_normal_z, Real &p_distance)
// ----------------------------------------------------------------
// Walk a ray through the grid cell by cell (3D DDA) and stop at the
// first block that is neither air nor water (plants count, so they
// can be broken; blocks smaller than their cell only inside their
// block_box). dir must be a unit vector. Returns TRUE on a hit
// within max_distance and sets hit_x/y/z (the cell), normal_* (the
// face that was hit) and distance.
// ----------------------------------------------------------------
{
  Integer l_cell_x     = Floor(p_origin_x);
  Integer l_cell_y     = Floor(p_origin_y);
  Integer l_cell_z     = Floor(p_origin_z);
  Integer l_step_x     = 1;
  Integer l_step_y     = 1;
  Integer l_step_z     = 1;
  Real    l_delta_x    = 1000000.0;
  Real    l_delta_y    = 1000000.0;
  Real    l_delta_z    = 1000000.0;
  Real    l_next_x     = 1000000.0;
  Real    l_next_y     = 1000000.0;
  Real    l_next_z     = 1000000.0;
  Real    l_travelled  = 0.0;
  Integer l_block      = 0;
  Integer l_guard      = 0;
  Real    l_min_x      = 0.0;
  Real    l_min_y      = 0.0;
  Real    l_min_z      = 0.0;
  Real    l_max_x      = 1.0;
  Real    l_max_y      = 1.0;
  Real    l_max_z      = 1.0;
  Real    l_along      = 0.0;

  p_normal_x = 0;
  p_normal_y = 0;
  p_normal_z = 0;
  p_distance = 0.0;

  if (p_dir_x != 0.0) l_delta_x = Absolute(1.0 / p_dir_x);
  if (p_dir_y != 0.0) l_delta_y = Absolute(1.0 / p_dir_y);
  if (p_dir_z != 0.0) l_delta_z = Absolute(1.0 / p_dir_z);

  if (p_dir_x < 0.0) {
    l_step_x = -1;
    l_next_x = (p_origin_x - l_cell_x) * l_delta_x;
  } else {
    l_next_x = (l_cell_x + 1.0 - p_origin_x) * l_delta_x;
  }
  if (p_dir_y < 0.0) {
    l_step_y = -1;
    l_next_y = (p_origin_y - l_cell_y) * l_delta_y;
  } else {
    l_next_y = (l_cell_y + 1.0 - p_origin_y) * l_delta_y;
  }
  if (p_dir_z < 0.0) {
    l_step_z = -1;
    l_next_z = (p_origin_z - l_cell_z) * l_delta_z;
  } else {
    l_next_z = (l_cell_z + 1.0 - p_origin_z) * l_delta_z;
  }

  while (l_guard < 64) {
    ++l_guard;

    l_block = world_get_block(l_cell_x, l_cell_y, l_cell_z);
    if (l_block != BLOCK_AIR && l_block != BLOCK_WATER && world_in_bounds(l_cell_x, l_cell_y, l_cell_z)) {
      // a block smaller than its cell is only hit inside its box
      l_along = l_travelled;
      if (block_box(l_block, l_min_x, l_min_y, l_min_z, l_max_x, l_max_y, l_max_z)) {
        l_along = physics_ray_box(p_origin_x, p_origin_y, p_origin_z, p_dir_x, p_dir_y, p_dir_z,
                                  l_cell_x + l_min_x, l_cell_y + l_min_y, l_cell_z + l_min_z,
                                  l_cell_x + l_max_x, l_cell_y + l_max_y, l_cell_z + l_max_z);
      }
      if (l_along >= 0.0 && l_along <= p_max_distance) {
        p_hit_x    = l_cell_x;
        p_hit_y    = l_cell_y;
        p_hit_z    = l_cell_z;
        p_distance = l_along;
        return TRUE;
      }
    }

    p_normal_x = 0;
    p_normal_y = 0;
    p_normal_z = 0;
    if (l_next_x <= l_next_y && l_next_x <= l_next_z) {
      l_travelled = l_next_x;
      l_next_x    = l_next_x + l_delta_x;
      l_cell_x    = l_cell_x + l_step_x;
      p_normal_x  = -l_step_x;
    } else if (l_next_y <= l_next_z) {
      l_travelled = l_next_y;
      l_next_y    = l_next_y + l_delta_y;
      l_cell_y    = l_cell_y + l_step_y;
      p_normal_y  = -l_step_y;
    } else {
      l_travelled = l_next_z;
      l_next_z    = l_next_z + l_delta_z;
      l_cell_z    = l_cell_z + l_step_z;
      p_normal_z  = -l_step_z;
    }

    if (l_travelled > p_max_distance) return FALSE;
  }
  return FALSE;
}

Real physics_ray_box(Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z,
                     Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)
// ----------------------------------------------------------------
// Distance along a ray to where it enters a box (slab method)
// Returns -1 if the ray misses or the box is behind the origin
// ----------------------------------------------------------------
{
  Real l_enter = -1000000.0;
  Real l_leave =  1000000.0;
  Real l_t0    = 0.0;
  Real l_t1    = 0.0;
  Real l_swap  = 0.0;

  if (p_dir_x == 0.0) {
    if (p_origin_x < p_min_x || p_origin_x > p_max_x) return -1.0;
  } else {
    l_t0 = (p_min_x - p_origin_x) / p_dir_x;
    l_t1 = (p_max_x - p_origin_x) / p_dir_x;
    if (l_t0 > l_t1) {
      l_swap = l_t0;
      l_t0   = l_t1;
      l_t1   = l_swap;
    }
    l_enter = max_real(l_enter, l_t0);
    l_leave = min_real(l_leave, l_t1);
  }

  if (p_dir_y == 0.0) {
    if (p_origin_y < p_min_y || p_origin_y > p_max_y) return -1.0;
  } else {
    l_t0 = (p_min_y - p_origin_y) / p_dir_y;
    l_t1 = (p_max_y - p_origin_y) / p_dir_y;
    if (l_t0 > l_t1) {
      l_swap = l_t0;
      l_t0   = l_t1;
      l_t1   = l_swap;
    }
    l_enter = max_real(l_enter, l_t0);
    l_leave = min_real(l_leave, l_t1);
  }

  if (p_dir_z == 0.0) {
    if (p_origin_z < p_min_z || p_origin_z > p_max_z) return -1.0;
  } else {
    l_t0 = (p_min_z - p_origin_z) / p_dir_z;
    l_t1 = (p_max_z - p_origin_z) / p_dir_z;
    if (l_t0 > l_t1) {
      l_swap = l_t0;
      l_t0   = l_t1;
      l_t1   = l_swap;
    }
    l_enter = max_real(l_enter, l_t0);
    l_leave = min_real(l_leave, l_t1);
  }

  if (l_enter > l_leave || l_leave < 0.0) return -1.0;
  if (l_enter < 0.0) return 0.0;
  return l_enter;
}

#endif
