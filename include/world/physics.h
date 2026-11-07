#ifndef PHYSICS_H_INCLUDED
#define PHYSICS_H_INCLUDED

// ----------------------------------------------------------------
// Box collision against the block grid and ray casting
// A moving body is an upright box: (x, z) is the centre of its
// footprint, y is the bottom, half_width and height its size
// ----------------------------------------------------------------

#define COLLISION_EPSILON  0.0005
#define MAX_MOVE_STEP      0.4

// Table functions: these read the block grid through world_get_block.
// Results come back through reference parameters.

Integer physics_cell_box      (Integer p_x, Integer p_y, Integer p_z, Real &p_min_x, Real &p_min_y, Real &p_min_z,
                               Real &p_max_x, Real &p_max_y, Real &p_max_z);
Real    physics_box_limit     (Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z,
                               Integer p_axis, Integer p_direction);
Integer physics_box_collides  (Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z);
void    physics_move_box      (Real &p_x, Real &p_y, Real &p_z, Real p_half_width, Real p_height, Real p_dx, Real p_dy, Real p_dz,
                               Integer &p_hit_x, Integer &p_hit_z, Integer &p_hit_down, Integer &p_hit_up);
Integer physics_box_in_water  (Real p_x, Real p_y, Real p_z, Real p_half_width, Real p_height);
Integer physics_raycast_blocks(Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_max_distance,
                               Integer &p_hit_x, Integer &p_hit_y, Integer &p_hit_z,
                               Integer &p_normal_x, Integer &p_normal_y, Integer &p_normal_z, Real &p_distance);
Real    physics_ray_box       (Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z,
                               Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z);

#endif
