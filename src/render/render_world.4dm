#ifndef RENDER_WORLD_4DM_INCLUDED
#define RENDER_WORLD_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/blocks/blocks.h"
#include "../../include/blocks/textures.h"
#include "../../include/world/world.h"
#include "../../include/world/mesh.h"
#include "../../include/player/player.h"
#include "../../include/mobs/cows.h"
#include "../../include/core/slots.h"
#include "../../include/items/drops.h"
#include "../../include/core/records.h"
#include "../../include/program/settings.h"
#include "../../include/render/render.h"
#include "../../include/render/hud.h"
#include "../../include/net/net.h"

// ---------------------------------------------------------------- set up

void render_init()
// ----------------------------------------------------------------
// One-off set up: default detail, empty buckets
// (render_draw_faces empties the buckets it used) and the stars
// ----------------------------------------------------------------
{
  Integer l_bucket = 0;
  Integer l_star   = 0;

  render_set_detail(2);

  for (l_bucket = 1; l_bucket <= MAX_BUCKETS; ++l_bucket) g_bucket_head[l_bucket] = 0;
  g_bucket_low  = MAX_BUCKETS + 1;
  g_bucket_high = 0;

  // Fixed directions and brightness of the stars
  for (l_star = 1; l_star <= NUM_STARS; ++l_star) {
    g_star_x    [l_star] = hash_real(l_star * 1.0, 3.7, 11.0) * 2.0 - 1.0;
    g_star_z    [l_star] = hash_real(l_star * 1.0, 8.1, 5.0) * 2.0 - 1.0;
    g_star_y    [l_star] = 0.15 + hash_real(l_star * 1.0, 1.3, 7.0);
    g_star_level[l_star] = 150.0 + 100.0 * hash_real(l_star * 1.0, 2.0, 2.0);
  }
}

void render_set_detail(Integer p_level)
// ----------------------------------------------------------------
// Texture detail: 1 = low (textures only up close), 2 = normal,
// 3 = high (all 16 x 16 pixels from further out). Faces smaller
// on screen than these sizes get fewer texture rectangles.
// ----------------------------------------------------------------
{
  if (p_level <= 1) {
    g_lod_full_pixels  = 150.0;
    g_lod_major_pixels = 64.0;
    g_view_plant_range = 10;
  } else if (p_level == 2) {
    g_lod_full_pixels  = 96.0;
    g_lod_major_pixels = 40.0;
    g_view_plant_range = 16;
  } else {
    g_lod_full_pixels  = 48.0;
    g_lod_major_pixels = 24.0;
    g_view_plant_range = 24;
  }
}

void render_view_from(Attributes &p_player, Attributes &p_settings, Real p_time_of_day, Real p_now)
// ----------------------------------------------------------------
// Copy what this frame needs from the player and settings records
// into the renderer's frame globals (the only place they're set)
// ----------------------------------------------------------------
{
  g_render_distance   = settings_render_distance(p_settings);
  g_view_plants       = settings_flag(p_settings, ATTR_SET_PLANTS);
  g_view_shading      = settings_flag(p_settings, ATTR_SET_SHADING);
  g_view_eye_in_water = player_eye_in_water(p_player);
  g_view_target_kind  = player_target_kind(p_player);
  g_view_break_stage  = player_break_stage(p_player, p_now);
  g_view_break_x      = record_integer(p_player, ATTR_BREAK_X);
  g_view_break_y      = record_integer(p_player, ATTR_BREAK_Y);
  g_view_break_z      = record_integer(p_player, ATTR_BREAK_Z);
  player_target_cell(p_player, g_view_target_x, g_view_target_y, g_view_target_z);
  render_set_detail(settings_detail(p_settings));
  g_view_time     = p_time_of_day;
  g_view_now      = p_now;
  g_view_daylight = world_daylight(p_time_of_day);

  // Spread the squared distances out over the buckets
  g_bucket_scale = (MAX_BUCKETS - 1.0) / (g_render_distance * g_render_distance + 60.0);
}

Text render_stats_text()
// ----------------------------------------------------------------
// One line of drawing statistics for the last frame
// ----------------------------------------------------------------
{
  return "faces " + To_text(g_stat_faces) + "   polygons " + To_text(g_stat_polygons) + "   sections " + To_text(g_stat_sections) + "   looked at " + To_text(g_stat_examined) + "   hidden " + To_text(g_stat_hidden);
}

// ---------------------------------------------------------------- 2D helpers

void render_set_colour(Draw_Box p_box, Real p_red, Real p_green, Real p_blue)
// ----------------------------------------------------------------
// Set both the pen and the fill to one colour, so polygons have no
// differently coloured outline (and neighbours leave no gaps)
// ----------------------------------------------------------------
{
  Integer l_r = to_byte(p_red);
  Integer l_g = to_byte(p_green);
  Integer l_b = to_byte(p_blue);

  Set_colour     (p_box, l_r, l_g, l_b);
  Set_fill_colour(p_box, l_r, l_g, l_b);
}

void render_set_face_colour(Draw_Box p_box, Real p_red, Real p_green, Real p_blue)
// ----------------------------------------------------------------
// render_set_colour without the range checks, for face colours,
// which are always in range: palette * keep + add never passes 255
// because keep + fog <= 1 (see render_draw_face)
// ----------------------------------------------------------------
{
  Integer l_r = Floor(p_red);
  Integer l_g = Floor(p_green);
  Integer l_b = Floor(p_blue);

  Set_colour     (p_box, l_r, l_g, l_b);
  Set_fill_colour(p_box, l_r, l_g, l_b);
}

void render_fill_rect(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)
// ----------------------------------------------------------------
// Filled axis aligned rectangle in screen coordinates
// ----------------------------------------------------------------
{
  g_poly_x[1] = p_x0;
  g_poly_y[1] = p_y0;
  g_poly_x[2] = p_x1;
  g_poly_y[2] = p_y0;
  g_poly_x[3] = p_x1;
  g_poly_y[3] = p_y1;
  g_poly_x[4] = p_x0;
  g_poly_y[4] = p_y1;
  Draw_polygon(p_box, 4, g_poly_x, g_poly_y);
}

void render_line(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)
// ----------------------------------------------------------------
// Line in screen coordinates
// ----------------------------------------------------------------
{
  Move_to(p_box, p_x0, p_y0);
  Draw_to(p_box, p_x1, p_y1);
}

// ---------------------------------------------------------------- camera

void render_setup_camera(Real p_w, Real p_h, Real p_view_bottom, Real p_eye_x, Real p_eye_y, Real p_eye_z,
                         Real p_yaw, Real p_pitch, Real p_field_of_view)
// ----------------------------------------------------------------
// Camera at (eye_x, eye_y, eye_z) looking along yaw and pitch, for
// a w x h view whose bottom view_bottom pixels are covered by the
// status strip; field_of_view is horizontal, in radians
// ----------------------------------------------------------------
{
  Real l_cos_yaw   = Cos(p_yaw);
  Real l_sin_yaw   = Sin(p_yaw);
  Real l_cos_pitch = Cos(p_pitch);
  Real l_sin_pitch = Sin(p_pitch);
  Real l_tan_x     = 0.0;
  Real l_tan_y     = 0.0;

  g_screen_w    = p_w;
  g_screen_h    = p_h;
  g_view_bottom = p_view_bottom;
  g_centre_x    = p_w / 2.0;
  g_centre_y    = p_view_bottom + (p_h - p_view_bottom) / 2.0;
  g_focal       = (p_w / 2.0) * Cos(p_field_of_view / 2.0) / Sin(p_field_of_view / 2.0);
  g_view_pitch  = p_pitch;

  g_cam_x = p_eye_x;
  g_cam_y = p_eye_y;
  g_cam_z = p_eye_z;

  g_fwd_x   =  l_cos_pitch * l_cos_yaw;
  g_fwd_y   =  l_sin_pitch;
  g_fwd_z   =  l_cos_pitch * l_sin_yaw;
  g_right_x = -l_sin_yaw;
  g_right_z =  l_cos_yaw;
  g_up_x    = -l_sin_pitch * l_cos_yaw;
  g_up_y    =  l_cos_pitch;
  g_up_z    = -l_sin_pitch * l_sin_yaw;

  // Frustum side planes (with a little margin) for culling
  l_tan_x = (p_w / 2.0 + 8.0) / g_focal;
  l_tan_y = ((p_h - p_view_bottom) / 2.0 + 8.0) / g_focal;
  g_cull_cos_x = 1.0 / Sqrt(1.0 + l_tan_x * l_tan_x);
  g_cull_sin_x = l_tan_x * g_cull_cos_x;
  g_cull_cos_y = 1.0 / Sqrt(1.0 + l_tan_y * l_tan_y);
  g_cull_sin_y = l_tan_y * g_cull_cos_y;

  // Fog
  g_fog_end   = g_render_distance;
  g_fog_start = g_render_distance * 0.55;
  render_sky_colours(g_view_time);
  if (g_view_eye_in_water) {
    g_fog_start = 2.0;
    g_fog_end   = min_real(16.0, g_fog_end);
    g_fog_r     = 30.0;
    g_fog_g     = 62.0;
    g_fog_b     = 140.0;
  }
}

void render_to_camera(Real p_rel_x, Real p_rel_y, Real p_rel_z)
// ----------------------------------------------------------------
// Rotate a vector from the eye into camera space (x right, y up,
// z forward); the result is left in g_tc_x, g_tc_y, g_tc_z
// ----------------------------------------------------------------
{
  g_tc_x = p_rel_x * g_right_x + p_rel_z * g_right_z;
  g_tc_y = p_rel_x * g_up_x    + p_rel_y * g_up_y    + p_rel_z * g_up_z;
  g_tc_z = p_rel_x * g_fwd_x   + p_rel_y * g_fwd_y   + p_rel_z * g_fwd_z;
}

Integer render_sphere_visible(Real p_rel_x, Real p_rel_y, Real p_rel_z, Real p_radius)
// ----------------------------------------------------------------
// FALSE if a sphere (centre relative to the eye) is certainly
// outside the view: behind the camera or past a side of the screen
// ----------------------------------------------------------------
{
  render_to_camera(p_rel_x, p_rel_y, p_rel_z);

  if (g_tc_z < -p_radius) return FALSE;
  if ( g_tc_x * g_cull_cos_x - g_tc_z * g_cull_sin_x > p_radius) return FALSE;
  if (-g_tc_x * g_cull_cos_x - g_tc_z * g_cull_sin_x > p_radius) return FALSE;
  if ( g_tc_y * g_cull_cos_y - g_tc_z * g_cull_sin_y > p_radius) return FALSE;
  if (-g_tc_y * g_cull_cos_y - g_tc_z * g_cull_sin_y > p_radius) return FALSE;
  return TRUE;
}

// ---------------------------------------------------------------- collecting faces

void render_add_face(Real p_c0x, Real p_c0y, Real p_c0z, Real p_e1x, Real p_e1y, Real p_e1z, Real p_e2x, Real p_e2y, Real p_e2z,
                     Integer p_tex, Real p_shade, Real p_distance_squared, Real p_size, Real p_tint, Integer p_crack)
// ----------------------------------------------------------------
// Queue a face for drawing. Corners are c0, c0 + e1, c0 + e1 + e2
// and c0 + e2 in camera space; e1 runs along the texture's u and e2
// along v (up the texture). distance_squared orders the painting,
// size (the face's width in blocks) picks the level of detail.
// ----------------------------------------------------------------
{
  Real    l_z1       = p_c0z + p_e1z;
  Real    l_z2       = p_c0z + p_e1z + p_e2z;
  Real    l_z3       = p_c0z + p_e2z;
  Real    l_distance = 0.0;
  Real    l_fog      = 0.0;
  Real    l_pixels   = 0.0;
  Integer l_bucket   = 0;
  Integer l_face     = 0;

  if (g_face_total >= MAX_DRAW_FACES) return;
  if (p_c0z < NEAR_PLANE && l_z1 < NEAR_PLANE && l_z2 < NEAR_PLANE && l_z3 < NEAR_PLANE) return;

  l_distance = Sqrt(p_distance_squared);
  l_fog      = clamp_real((l_distance - g_fog_start) / (g_fog_end - g_fog_start), 0.0, 1.0);
  if (l_fog >= 0.999) return;

  ++g_face_total;
  l_face = g_face_total;

  g_df_c0x[l_face] = p_c0x;
  g_df_c0y[l_face] = p_c0y;
  g_df_c0z[l_face] = p_c0z;
  g_df_e1x[l_face] = p_e1x;
  g_df_e1y[l_face] = p_e1y;
  g_df_e1z[l_face] = p_e1z;
  g_df_e2x[l_face] = p_e2x;
  g_df_e2y[l_face] = p_e2y;
  g_df_e2z[l_face] = p_e2z;
  g_df_tex   [l_face] = p_tex;
  g_df_shade [l_face] = p_shade;
  g_df_fog   [l_face] = l_fog;
  g_df_tint  [l_face] = p_tint;
  g_df_wet   [l_face] = 0.0;
  g_df_phase [l_face] = 0.0;
  g_df_crack [l_face] = p_crack;
  g_df_u0    [l_face] = 0.0;
  g_df_u1    [l_face] = 1.0;
  g_df_opaque[l_face] = FALSE;
  g_df_hidden[l_face] = FALSE;
  l_pixels = g_focal * p_size / max_real(l_distance, 0.1);
  g_df_detail[l_face] = DETAIL_FLAT;
  if (l_pixels > g_lod_major_pixels) g_df_detail[l_face] = DETAIL_MAJOR;
  if (l_pixels > g_lod_full_pixels ) g_df_detail[l_face] = DETAIL_FULL;
  g_df_front [l_face] = p_c0z >= NEAR_PLANE && l_z1 >= NEAR_PLANE && l_z2 >= NEAR_PLANE && l_z3 >= NEAR_PLANE;

  l_bucket = Floor(p_distance_squared * g_bucket_scale) + 1;
  if (l_bucket > MAX_BUCKETS) l_bucket = MAX_BUCKETS;
  if (l_bucket < 1) l_bucket = 1;
  if (l_bucket < g_bucket_low ) g_bucket_low  = l_bucket;
  if (l_bucket > g_bucket_high) g_bucket_high = l_bucket;
  g_df_next[l_face]       = g_bucket_head[l_bucket];
  g_bucket_head[l_bucket] = l_face;
}

void render_add_block_face(Integer p_x, Integer p_y, Integer p_z, Integer p_direction, Integer p_block,
                           Real p_distance_squared, Integer p_crack, Real p_light, Real p_wet)
// ----------------------------------------------------------------
// Queue one face of the block at cell (x, y, z), lit by light
// (0..1, from the mesh) and tinted by wet (0..1) when it is seen
// through water
// The face corners are built from the camera space images of the
// three world axes, so each corner is just a few additions
// ----------------------------------------------------------------
{
  Real    l_rel_x = p_x - g_cam_x;
  Real    l_rel_y = p_y - g_cam_y;
  Real    l_rel_z = p_z - g_cam_z;
  // camera space images of the unit x, y and z axes
  Real    l_ax_x  = g_right_x;
  Real    l_ax_y  = g_up_x;
  Real    l_ax_z  = g_fwd_x;
  Real    l_ay_y  = g_up_y;
  Real    l_ay_z  = g_fwd_y;
  Real    l_az_x  = g_right_z;
  Real    l_az_y  = g_up_z;
  Real    l_az_z  = g_fwd_z;
  Real    l_ox    = l_rel_x * l_ax_x + l_rel_z * l_az_x;
  Real    l_oy    = l_rel_x * l_ax_y + l_rel_y * l_ay_y + l_rel_z * l_az_y;
  Real    l_oz    = l_rel_x * l_ax_z + l_rel_y * l_ay_z + l_rel_z * l_az_z;
  Real    l_top   = 1.0;
  Integer l_tex   = block_face_texture(p_block, p_direction);
  Real    l_shade = block_face_shade(p_direction) * p_light;
  Integer l_before = 0;
  Real    l_phase  = 0.0;

  if (p_block == BLOCK_WATER) {
    l_top = WATER_TOP;
    // Ripples: light and dark bands drift across the surface
    if (p_direction == DIR_PY) {
      l_shade = l_shade * (1.0 + 0.08 * Sin(p_x * 0.9 + p_z * 0.6 + g_view_now * 1.8)
                               + 0.05 * Sin(p_z * 1.3 - p_x * 0.4 + g_view_now * 2.7));
    }
  }
  l_before = g_face_total;
  // A burning furnace's door glows whatever the light around it
  if (l_tex == TEX_FURNACE_FRONT_LIT) l_shade = block_face_shade(p_direction);

  if (p_direction == DIR_PX) {
    render_add_face(l_ox + l_ax_x + l_az_x, l_oy + l_ax_y + l_az_y, l_oz + l_ax_z + l_az_z,
                    -l_az_x, -l_az_y, -l_az_z,  0.0, l_ay_y * l_top, l_ay_z * l_top,
                    l_tex, l_shade, p_distance_squared, 1.0, 0.0, p_crack);
  } else if (p_direction == DIR_NX) {
    render_add_face(l_ox, l_oy, l_oz,
                    l_az_x, l_az_y, l_az_z,  0.0, l_ay_y * l_top, l_ay_z * l_top,
                    l_tex, l_shade, p_distance_squared, 1.0, 0.0, p_crack);
  } else if (p_direction == DIR_PY) {
    render_add_face(l_ox, l_oy + l_ay_y * l_top, l_oz + l_ay_z * l_top,
                    l_ax_x, l_ax_y, l_ax_z,  l_az_x, l_az_y, l_az_z,
                    l_tex, l_shade, p_distance_squared, 1.0, 0.0, p_crack);
  } else if (p_direction == DIR_NY) {
    render_add_face(l_ox + l_az_x, l_oy + l_az_y, l_oz + l_az_z,
                    l_ax_x, l_ax_y, l_ax_z,  -l_az_x, -l_az_y, -l_az_z,
                    l_tex, l_shade, p_distance_squared, 1.0, 0.0, p_crack);
  } else if (p_direction == DIR_PZ) {
    render_add_face(l_ox + l_az_x, l_oy + l_az_y, l_oz + l_az_z,
                    l_ax_x, l_ax_y, l_ax_z,  0.0, l_ay_y * l_top, l_ay_z * l_top,
                    l_tex, l_shade, p_distance_squared, 1.0, 0.0, p_crack);
  } else {
    render_add_face(l_ox + l_ax_x, l_oy + l_ax_y, l_oz + l_ax_z,
                    -l_ax_x, -l_ax_y, -l_ax_z,  0.0, l_ay_y * l_top, l_ay_z * l_top,
                    l_tex, l_shade, p_distance_squared, 1.0, 0.0, p_crack);
  }

  // Faces of opaque blocks with a solid base colour hide what is
  // behind them (not glass, water or textures with holes)
  if (g_face_total > l_before) {
    if (g_tex_base[l_tex] > 0) {
      if (block_hides_faces(p_block)) g_df_opaque[g_face_total] = TRUE;
    }
    g_df_wet[g_face_total] = p_wet;
    if (p_block == BLOCK_WATER) {
      l_phase = p_x * 0.618 + p_z * 0.382 + p_y * 0.271;
      g_df_phase[g_face_total] = l_phase - Floor(l_phase);
    }
  }
}

void render_add_sprite(Real p_rel_x, Real p_rel_y, Real p_rel_z, Real p_half_width, Real p_height, Integer p_tex,
                       Real p_shade, Real p_distance_squared)
// ----------------------------------------------------------------
// Queue a picture standing upright at (rel_x, rel_y, rel_z)
// (bottom centre, relative to the eye) that turns to face the
// camera: plants and dropped items that aren't blocks
// ----------------------------------------------------------------
{
  render_to_camera(p_rel_x, p_rel_y, p_rel_z);
  if (g_tc_z < NEAR_PLANE) return;

  render_add_face(g_tc_x - p_half_width, g_tc_y, g_tc_z,
                  p_half_width * 2.0, 0.0, 0.0,
                  0.0, g_up_y * p_height, g_fwd_y * p_height,
                  p_tex, p_shade, p_distance_squared, p_half_width * 2.0, 0.0, 0);
}

void render_add_shaped(Integer p_x, Integer p_y, Integer p_z, Integer p_block, Real p_light)
// ----------------------------------------------------------------
// Queue a door or bed half in cell (x, y, z) as a box filling its
// block_box, lit by light. A door shows its picture on both broad
// faces; a bed shows its blanket (and pillow at the head) on top,
// lengthways from foot to head.
// ----------------------------------------------------------------
{
  Real    l_min_x  = 0.0;
  Real    l_min_y  = 0.0;
  Real    l_min_z  = 0.0;
  Real    l_max_x  = 1.0;
  Real    l_max_y  = 1.0;
  Real    l_max_z  = 1.0;
  Real    l_yaw    = 0.0;
  Real    l_half_f = 0.0;
  Real    l_half_s = 0.0;
  Integer l_tex    = 0;
  Integer l_edge   = 0;
  Integer l_facing = 0;

  block_box(p_block, l_min_x, l_min_y, l_min_z, l_max_x, l_max_y, l_max_z);
  g_box_light = p_light;

  if (block_is_door(p_block)) {
    l_tex  = TEX_DOOR_BOTTOM;
    l_edge = TEX_DOOR_EDGE_BOTTOM;
    if (block_door_top(p_block)) {
      l_tex  = TEX_DOOR_TOP;
      l_edge = TEX_DOOR_EDGE_TOP;
    }
    // the box faces across its thin side
    l_yaw    = 0.0;
    l_half_f = (l_max_x - l_min_x) * 0.5;
    l_half_s = (l_max_z - l_min_z) * 0.5;
    if (l_max_x - l_min_x > l_max_z - l_min_z) {
      l_yaw    = PI * 0.5;
      l_half_f = (l_max_z - l_min_z) * 0.5;
      l_half_s = (l_max_x - l_min_x) * 0.5;
    }
    render_add_box(p_x + (l_min_x + l_max_x) * 0.5, p_y + 0.5, p_z + (l_min_z + l_max_z) * 0.5, l_yaw, 0.0,
                   l_half_f, 0.5, l_half_s, l_edge, l_edge, l_tex, l_tex, 0.0, -1.0);
    return;
  }

  // a bed: facing points from foot to head, so the box's front is the
  // head end; the top texture's u runs from foot to head
  l_facing = block_bed_facing(p_block);
  if (l_facing == FACING_PX) l_yaw = 0.0;
  if (l_facing == FACING_PZ) l_yaw = PI * 0.5;
  if (l_facing == FACING_NX) l_yaw = PI;
  if (l_facing == FACING_NZ) l_yaw = PI * 1.5;
  l_tex = TEX_BED_FOOT_TOP;
  if (block_bed_head(p_block)) l_tex = TEX_BED_TOP;
  render_add_box(p_x + 0.5, p_y + BED_HEIGHT * 0.5, p_z + 0.5, l_yaw, 0.0, 0.5, BED_HEIGHT * 0.5, 0.5,
                 TEX_BED_SIDE, l_tex, TEX_BED_SIDE, TEX_BED_SIDE, 0.0, -1.0);
}

void render_add_plant(Integer p_x, Integer p_y, Integer p_z, Integer p_tex, Real p_light)
// ----------------------------------------------------------------
// Queue a plant in cell (x, y, z): two pictures crossed in an X
// along the cell's diagonals, fixed in the world (seen from both
// sides). Two crossing pictures can't be painted one after the
// other, so each is split at the crossing into two halves ("fins")
// that only meet along the middle; the fins are queued by the
// distance to their own middle, nearest first, so in a shared
// bucket the farther ones are painted first.
// ----------------------------------------------------------------
{
  Real    l_half    = PLANT_HALF_WIDTH;
  Real    l_height  = PLANT_HEIGHT;
  Real    l_mid_x   = p_x + 0.5 - g_cam_x;
  Real    l_mid_y   = p_y + l_height * 0.5 - g_cam_y;
  Real    l_mid_z   = p_z + 0.5 - g_cam_z;
  Real    l_up_x    = 0.0;
  Real    l_up_y    = 0.0;
  Real    l_up_z    = 0.0;
  Real    l_c0_x    = 0.0;
  Real    l_c0_y    = 0.0;
  Real    l_c0_z    = 0.0;
  Real    l_e1_x    = 0.0;
  Real    l_e1_y    = 0.0;
  Real    l_e1_z    = 0.0;
  Real    l_dir_x   = 0.0;
  Real    l_dir_z   = 0.0;
  Real    l_fin_x   = 0.0;
  Real    l_fin_z   = 0.0;
  Integer l_fin     = 0;
  Integer l_pick    = 0;
  Integer l_picked  = 0;
  Integer l_before  = 0;

  if (p_tex <= 0) return;

  // Distance to each fin's middle: fins 1 and 2 are the first and
  // second halves of the picture from (-1, -1) to (+1, +1), fins 3
  // and 4 of the one from (-1, +1) to (+1, -1)
  for (l_fin = 1; l_fin <= 4; ++l_fin) {
    l_fin_x = l_half * 0.5;
    l_fin_z = l_half * 0.5;
    if (l_fin == 1) {
      l_fin_x = -l_fin_x;
      l_fin_z = -l_fin_z;
    }
    if (l_fin == 3) l_fin_x = -l_fin_x;
    if (l_fin == 4) l_fin_z = -l_fin_z;
    g_fin_dist[l_fin] = (l_mid_x + l_fin_x) * (l_mid_x + l_fin_x) + l_mid_y * l_mid_y + (l_mid_z + l_fin_z) * (l_mid_z + l_fin_z);
    g_fin_done[l_fin] = FALSE;
  }

  render_to_camera(0.0, l_height, 0.0);
  l_up_x = g_tc_x;
  l_up_y = g_tc_y;
  l_up_z = g_tc_z;

  for (l_pick = 1; l_pick <= 4; ++l_pick) {
    // nearest fin not queued yet
    l_picked = 0;
    for (l_fin = 1; l_fin <= 4; ++l_fin) {
      if (g_fin_done[l_fin]) continue;
      if (l_picked == 0) {
        l_picked = l_fin;
      } else if (g_fin_dist[l_fin] < g_fin_dist[l_picked]) {
        l_picked = l_fin;
      }
    }
    g_fin_done[l_picked] = TRUE;

    // The whole picture runs from the corner at -dir to +dir; the
    // fin is its first or second half (u 0..0.5 or 0.5..1)
    l_dir_x = l_half;
    l_dir_z = l_half;
    if (l_picked >= 3) l_dir_z = -l_half;
    render_to_camera(l_mid_x - l_dir_x, l_mid_y - l_height * 0.5, l_mid_z - l_dir_z);
    l_c0_x = g_tc_x;
    l_c0_y = g_tc_y;
    l_c0_z = g_tc_z;
    render_to_camera(2.0 * l_dir_x, 0.0, 2.0 * l_dir_z);
    l_e1_x = g_tc_x;
    l_e1_y = g_tc_y;
    l_e1_z = g_tc_z;

    l_before = g_face_total;
    render_add_face(l_c0_x, l_c0_y, l_c0_z, l_e1_x, l_e1_y, l_e1_z, l_up_x, l_up_y, l_up_z,
                    p_tex, p_light, g_fin_dist[l_picked], 2.0 * l_half, 0.0, 0);
    if (g_face_total > l_before) {
      if (l_picked == 1 || l_picked == 3) {
        g_df_u1[g_face_total] = 0.5;
      } else {
        g_df_u0[g_face_total] = 0.5;
      }
    }
  }
}

Integer render_layer_count(Real p_limit)
// ----------------------------------------------------------------
// How many of a section's layers 0..15 lie below limit (layer k
// counts if k < limit): clamp(ceiling(limit), 0, 16)
// ----------------------------------------------------------------
{
  Integer l_count = -floor_integer(-p_limit);

  if (l_count < 0) return 0;
  if (l_count > SECTION_SIZE) return SECTION_SIZE;
  return l_count;
}

void render_collect_blocks()
// ----------------------------------------------------------------
// Walk the cached face lists of the sections in view and queue the
// faces that point towards the eye, are within the view distance
// and inside the screen
// Faces are sorted by direction and layer (see mesh.h), so for each
// direction only the layers on the eye's side of the faces are
// walked: a face of DIR_PX at x faces the eye when x + 1 < eye x.
// ----------------------------------------------------------------
{
  Integer l_range     = g_render_distance;
  Real    l_range_sq  = l_range * l_range;
  Integer l_sx0       = clamp_integer(floor_integer((g_cam_x - l_range) / SECTION_SIZE), 0, SECTIONS_X - 1);
  Integer l_sx1       = clamp_integer(floor_integer((g_cam_x + l_range) / SECTION_SIZE), 0, SECTIONS_X - 1);
  Integer l_sy0       = 0;
  Integer l_sy1       = 0;
  Integer l_sz0       = clamp_integer(floor_integer((g_cam_z - l_range) / SECTION_SIZE), 0, SECTIONS_Z - 1);
  Integer l_sz1       = clamp_integer(floor_integer((g_cam_z + l_range) / SECTION_SIZE), 0, SECTIONS_Z - 1);
  Integer l_sx        = 0;
  Integer l_sy        = 0;
  Integer l_sz        = 0;
  Integer l_section   = 0;
  Integer l_base      = 0;
  Integer l_table     = 0;
  Integer l_key0      = 0;
  Integer l_layer0    = 0;
  Integer l_layer1    = 0;
  Integer l_start     = 0;
  Integer l_last      = 0;
  Integer l_entry     = 0;
  Integer l_x         = 0;
  Integer l_y         = 0;
  Integer l_z         = 0;
  Integer l_direction = 0;
  Integer l_group     = 0;
  Integer l_block     = 0;
  Integer l_crack     = 0;
  Integer l_stage     = g_view_break_stage;
  Integer l_plant_sq  = g_view_plant_range * g_view_plant_range;
  Integer l_in_water  = g_view_eye_in_water;
  Real    l_light     = 1.0;
  Integer l_code      = 0;
  Integer l_torch     = 0;
  Integer l_sky       = 0;
  Integer l_vertical  = min_integer(l_range, VERTICAL_RANGE);
  Real    l_origin_x  = 0.0;
  Real    l_origin_y  = 0.0;
  Real    l_origin_z  = 0.0;
  Real    l_centre_x  = 0.0;
  Real    l_centre_y  = 0.0;
  Real    l_centre_z  = 0.0;
  Real    l_reach     = l_range + SECTION_RADIUS;
  Real    l_rel_x     = 0.0;
  Real    l_rel_y     = 0.0;
  Real    l_rel_z     = 0.0;
  Real    l_dist_sq   = 0.0;
  Real    l_offset_x  = 0.0;
  Real    l_offset_y  = 0.0;
  Real    l_offset_z  = 0.0;
  Real    l_radius    = 0.72;
  Real    l_tc_x      = 0.0;
  Real    l_tc_y      = 0.0;
  Real    l_tc_z      = 0.0;
  Real    l_daylight  = g_view_daylight;
  Real    l_cos_x     = g_cull_cos_x;
  Real    l_sin_x     = g_cull_sin_x;
  Real    l_cos_y     = g_cull_cos_y;
  Real    l_sin_y     = g_cull_sin_y;
  Integer l_shading   = g_view_shading;
  Real    l_wet       = 0.0;

  // Not much is worth drawing far above or below the eye
  l_sy0 = clamp_integer(floor_integer((g_cam_y - l_vertical) / SECTION_SIZE), 0, SECTIONS_Y - 1);
  l_sy1 = clamp_integer(floor_integer((g_cam_y + l_vertical) / SECTION_SIZE), 0, SECTIONS_Y - 1);

  for (l_sx = l_sx0; l_sx <= l_sx1; ++l_sx) {
    for (l_sz = l_sz0; l_sz <= l_sz1; ++l_sz) {
      for (l_sy = l_sy0; l_sy <= l_sy1; ++l_sy) {
        l_origin_x = l_sx * SECTION_SIZE;
        l_origin_y = l_sy * SECTION_SIZE;
        l_origin_z = l_sz * SECTION_SIZE;
        l_centre_x = l_origin_x + 8.0 - g_cam_x;
        l_centre_y = l_origin_y + 8.0 - g_cam_y;
        l_centre_z = l_origin_z + 8.0 - g_cam_z;
        if (l_centre_x * l_centre_x + l_centre_y * l_centre_y + l_centre_z * l_centre_z > l_reach * l_reach) continue;
        if (!render_sphere_visible(l_centre_x, l_centre_y, l_centre_z, SECTION_RADIUS)) continue;

        l_section = mesh_ensure_section(l_sx, l_sy, l_sz);
        if (g_section_count[l_section] == 0) continue;
        ++g_stat_sections;
        l_base  = (l_section - 1) * SECTION_FACE_CAP;
        l_table = (l_section - 1) * SECTION_LAYER_SLOTS;

        for (l_group = 1; l_group <= NUM_FACE_GROUPS; ++l_group) {
          // The run of layers whose faces point towards the eye, and
          // the offset from a cell's corner to its face's centre
          l_layer0   = 0;
          l_layer1   = SECTION_SIZE;
          l_offset_x = 0.5;
          l_offset_y = 0.5;
          l_offset_z = 0.5;
          if (l_group == DIR_PX) {
            l_layer1   = render_layer_count(g_cam_x - 1.0 - l_origin_x);
            l_offset_x = 1.0;
          } else if (l_group == DIR_NX) {
            l_layer0   = clamp_integer(floor_integer(g_cam_x - l_origin_x) + 1, 0, SECTION_SIZE);
            l_offset_x = 0.0;
          } else if (l_group == DIR_PY) {
            // under water, water surfaces are seen from below too
            if (!l_in_water) l_layer1 = render_layer_count(g_cam_y - 1.0 - l_origin_y);
            l_offset_y = 1.0;
          } else if (l_group == DIR_NY) {
            l_layer0   = clamp_integer(floor_integer(g_cam_y - l_origin_y) + 1, 0, SECTION_SIZE);
            l_offset_y = 0.0;
          } else if (l_group == DIR_PZ) {
            l_layer1   = render_layer_count(g_cam_z - 1.0 - l_origin_z);
            l_offset_z = 1.0;
          } else if (l_group == DIR_NZ) {
            l_layer0   = clamp_integer(floor_integer(g_cam_z - l_origin_z) + 1, 0, SECTION_SIZE);
            l_offset_z = 0.0;
          } else {
            // plants (when shown), doors and beds
            l_offset_y = 0.45;
          }
          if (l_layer0 >= l_layer1) continue;

          l_key0  = l_table + (l_group - 1) * SECTION_SIZE;
          l_start = l_base + g_section_layer_start[l_key0 + l_layer0 + 1];
          l_last  = l_base + g_section_layer_start[l_key0 + l_layer1 + 1] - 1;

          for (l_entry = l_start; l_entry <= l_last; ++l_entry) {
            ++g_stat_examined;
            // A face against water is seen through the water from
            // outside it (tinted) and plainly from inside it
            l_direction = g_face_dir[l_entry];
            l_wet       = 0.0;
            if (l_direction > DIR_WET_FLAG) {
              l_direction = l_direction - DIR_WET_FLAG;
              if (!l_in_water) l_wet = WATER_TINT;
            }
            l_x = g_face_x[l_entry];
            l_y = g_face_y[l_entry];
            l_z = g_face_z[l_entry];
            l_block = g_face_block[l_entry];
            l_rel_x = l_x - g_cam_x;
            l_rel_y = l_y - g_cam_y;
            l_rel_z = l_z - g_cam_z;

            // Under water a top face seen from below must be water
            if (l_direction == DIR_PY) {
              if (l_rel_y + 1.0 >= 0.0) {
                if (l_block != BLOCK_WATER) continue;
              }
            }

            // Within range (by the cell's centre) and on screen (a
            // ball around the face's centre); the camera space test
            // is written out here, it runs for every face
            l_dist_sq = (l_rel_x + 0.5) * (l_rel_x + 0.5) + (l_rel_y + 0.5) * (l_rel_y + 0.5) + (l_rel_z + 0.5) * (l_rel_z + 0.5);
            if (l_dist_sq > l_range_sq) continue;
            if (l_direction == DIR_PLANT) {
              if (!block_is_shaped(l_block)) {
                if (!g_view_plants) continue;
                if (l_dist_sq > l_plant_sq) continue;
              }
            }
            l_rel_x = l_rel_x + l_offset_x;
            l_rel_y = l_rel_y + l_offset_y;
            l_rel_z = l_rel_z + l_offset_z;
            l_tc_z  = l_rel_x * g_fwd_x + l_rel_y * g_fwd_y + l_rel_z * g_fwd_z;
            if (l_tc_z < -l_radius) continue;
            l_tc_x  = l_rel_x * g_right_x + l_rel_z * g_right_z;
            if ( l_tc_x * l_cos_x - l_tc_z * l_sin_x > l_radius) continue;
            if (-l_tc_x * l_cos_x - l_tc_z * l_sin_x > l_radius) continue;
            l_tc_y  = l_rel_x * g_up_x + l_rel_y * g_up_y + l_rel_z * g_up_z;
            if ( l_tc_y * l_cos_y - l_tc_z * l_sin_y > l_radius) continue;
            if (-l_tc_y * l_cos_y - l_tc_z * l_sin_y > l_radius) continue;

            // Sky light (dimmed at night) or torch light, whichever is brighter
            l_code  = g_face_light[l_entry];
            l_torch = 0;
            if (l_code >= FACE_TORCH_SCALE) l_torch = Floor(l_code / (1.0 * FACE_TORCH_SCALE));
            l_sky   = l_code - FACE_TORCH_SCALE * l_torch;
            if (!l_shading) l_sky = LIGHT_FULL;
            l_light = max_real(l_sky * l_daylight, l_torch * 1.0) / LIGHT_FULL;

            if (l_direction == DIR_PLANT) {
              if (block_is_shaped(l_block)) {
                render_add_shaped(l_x, l_y, l_z, l_block, l_light);
              } else {
                render_add_plant(l_x, l_y, l_z, block_plant_texture(l_block), l_light);
              }
              continue;
            }

            l_crack = 0;
            if (l_stage > 0) {
              if (l_x == g_view_break_x && l_y == g_view_break_y && l_z == g_view_break_z) l_crack = l_stage;
            }
            render_add_block_face(l_x, l_y, l_z, l_direction, l_block, l_dist_sq, l_crack, l_light, l_wet);
          }
        }
      }
    }
  }
}

Real render_side_shade(Real p_normal_x, Real p_normal_z)
// ----------------------------------------------------------------
// Light level of an upright face of an entity box from its normal,
// matching block_face_shade for faces that line up with the grid
// ----------------------------------------------------------------
{
  return 0.70 * p_normal_x * p_normal_x + 0.84 * p_normal_z * p_normal_z;
}

void render_add_box(Real p_centre_x, Real p_centre_y, Real p_centre_z, Real p_yaw, Real p_pitch, Real p_half_f, Real p_half_y, Real p_half_s,
                    Integer p_tex_side, Integer p_tex_top, Integer p_tex_front, Integer p_tex_back, Real p_tint, Real p_sort_dist_sq)
// ----------------------------------------------------------------
// Queue the visible faces of a box turned to yaw and tipped by pitch
// (its front rises for a positive pitch)
// half_f is its half length along the facing direction, half_s its
// half width and half_y its half height. tex_front is drawn on the
// face it looks out of, tex_back on the opposite one, tex_side on
// the left and right and tex_top on the top and bottom. On the
// sides and the top the texture's u runs from the back to the
// front, so both sides show the same picture (mirrored, like a
// model's left and right legs). The faces are ordered by
// sort_dist_sq, or by the distance to the box's centre if that is
// negative.
// ----------------------------------------------------------------
{
  Real    l_cos_yaw  = Cos(p_yaw);
  Real    l_sin_yaw  = Sin(p_yaw);
  Real    l_cos_tip  = Cos(p_pitch);
  Real    l_sin_tip  = Sin(p_pitch);
  // the box's axes in the world: facing, up and side
  Real    l_fw_x     = l_cos_yaw * l_cos_tip;
  Real    l_fw_y     = l_sin_tip;
  Real    l_fw_z     = l_sin_yaw * l_cos_tip;
  Real    l_up_x     = -l_cos_yaw * l_sin_tip;
  Real    l_up_y     = l_cos_tip;
  Real    l_up_z     = -l_sin_yaw * l_sin_tip;
  Real    l_side_x   = -l_sin_yaw;
  Real    l_side_z   =  l_cos_yaw;
  Real    l_rel_x    = p_centre_x - g_cam_x;
  Real    l_rel_y    = p_centre_y - g_cam_y;
  Real    l_rel_z    = p_centre_z - g_cam_z;
  Real    l_dist_sq  = l_rel_x * l_rel_x + l_rel_y * l_rel_y + l_rel_z * l_rel_z;
  Real    l_sort_sq  = p_sort_dist_sq;
  Real    l_size     = 2.0 * max_real(p_half_f, max_real(p_half_y, p_half_s));
  // where the eye is along each of the box's axes
  Real    l_eye_f    = -(l_rel_x * l_fw_x + l_rel_y * l_fw_y + l_rel_z * l_fw_z);
  Real    l_eye_u    = -(l_rel_x * l_up_x + l_rel_y * l_up_y + l_rel_z * l_up_z);
  Real    l_eye_s    = -(l_rel_x * l_side_x + l_rel_z * l_side_z);
  Real    l_m_x      = 0.0;
  Real    l_m_y      = 0.0;
  Real    l_m_z      = 0.0;
  Real    l_f_x      = 0.0;
  Real    l_f_y      = 0.0;
  Real    l_f_z      = 0.0;
  Real    l_u_x      = 0.0;
  Real    l_u_y      = 0.0;
  Real    l_u_z      = 0.0;
  Real    l_s_x      = 0.0;
  Real    l_s_y      = 0.0;
  Real    l_s_z      = 0.0;

  if (l_dist_sq > g_render_distance * g_render_distance) return;
  if (!render_sphere_visible(l_rel_x, l_rel_y, l_rel_z, Sqrt(p_half_f * p_half_f + p_half_y * p_half_y + p_half_s * p_half_s))) return;
  if (l_sort_sq < 0.0) l_sort_sq = l_dist_sq;

  // Corner with the lowest f, u and s, and the three edge vectors,
  // all in camera space
  render_to_camera(l_rel_x - l_fw_x * p_half_f - l_up_x * p_half_y - l_side_x * p_half_s,
                   l_rel_y - l_fw_y * p_half_f - l_up_y * p_half_y,
                   l_rel_z - l_fw_z * p_half_f - l_up_z * p_half_y - l_side_z * p_half_s);
  l_m_x = g_tc_x;
  l_m_y = g_tc_y;
  l_m_z = g_tc_z;
  render_to_camera(l_fw_x * p_half_f * 2.0, l_fw_y * p_half_f * 2.0, l_fw_z * p_half_f * 2.0);
  l_f_x = g_tc_x;
  l_f_y = g_tc_y;
  l_f_z = g_tc_z;
  render_to_camera(l_up_x * p_half_y * 2.0, l_up_y * p_half_y * 2.0, l_up_z * p_half_y * 2.0);
  l_u_x = g_tc_x;
  l_u_y = g_tc_y;
  l_u_z = g_tc_z;
  render_to_camera(l_side_x * p_half_s * 2.0, 0.0, l_side_z * p_half_s * 2.0);
  l_s_x = g_tc_x;
  l_s_y = g_tc_y;
  l_s_z = g_tc_z;

  if (l_eye_f > p_half_f) {
    render_add_face(l_m_x + l_f_x + l_s_x, l_m_y + l_f_y + l_s_y, l_m_z + l_f_z + l_s_z, -l_s_x, -l_s_y, -l_s_z, l_u_x, l_u_y, l_u_z,
                    p_tex_front, g_box_light * render_side_shade(l_fw_x, l_fw_z), l_sort_sq, l_size, p_tint, 0);
  }
  if (l_eye_f < -p_half_f) {
    render_add_face(l_m_x, l_m_y, l_m_z, l_s_x, l_s_y, l_s_z, l_u_x, l_u_y, l_u_z,
                    p_tex_back, g_box_light * render_side_shade(l_fw_x, l_fw_z), l_sort_sq, l_size, p_tint, 0);
  }
  if (l_eye_s > p_half_s) {
    render_add_face(l_m_x + l_s_x, l_m_y + l_s_y, l_m_z + l_s_z, l_f_x, l_f_y, l_f_z, l_u_x, l_u_y, l_u_z,
                    p_tex_side, g_box_light * render_side_shade(l_side_x, l_side_z), l_sort_sq, l_size, p_tint, 0);
  }
  if (l_eye_s < -p_half_s) {
    render_add_face(l_m_x, l_m_y, l_m_z, l_f_x, l_f_y, l_f_z, l_u_x, l_u_y, l_u_z,
                    p_tex_side, g_box_light * render_side_shade(l_side_x, l_side_z), l_sort_sq, l_size, p_tint, 0);
  }
  if (l_eye_u > p_half_y) {
    render_add_face(l_m_x + l_u_x, l_m_y + l_u_y, l_m_z + l_u_z, l_f_x, l_f_y, l_f_z, l_s_x, l_s_y, l_s_z,
                    p_tex_top, g_box_light, l_sort_sq, l_size, p_tint, 0);
  }
  if (l_eye_u < -p_half_y) {
    render_add_face(l_m_x + l_s_x, l_m_y + l_s_y, l_m_z + l_s_z, l_f_x, l_f_y, l_f_z, -l_s_x, -l_s_y, -l_s_z,
                    p_tex_top, 0.55 * g_box_light, l_sort_sq, l_size, p_tint, 0);
  }
}

Real render_light_at(Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Light (0..1) for an entity at a point: daylight, or the torch
// light of its cell if that is brighter
// ----------------------------------------------------------------
{
  Real l_torch = world_get_light(floor_integer(p_x), floor_integer(p_y), floor_integer(p_z)) / (1.0 * LIGHT_MAX_LEVEL);

  return max_real(g_view_daylight, l_torch);
}

void render_mob_begin(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_tint)
// ----------------------------------------------------------------
// Start collecting the boxes of one animal standing at (x, y, z)
// facing yaw (see render_mob_part and render_mob_end)
// ----------------------------------------------------------------
{
  g_mob_x     = p_x;
  g_mob_y     = p_y;
  g_mob_z     = p_z;
  g_mob_yaw   = p_yaw;
  g_mob_tint  = p_tint;
  g_mob_parts = 0;
}

void render_mob_part(Real p_along, Real p_up, Real p_across, Real p_half_f, Real p_half_y, Real p_half_s,
                     Real p_turn, Real p_pitch, Integer p_hip,
                     Integer p_tex_side, Integer p_tex_top, Integer p_tex_front, Integer p_tex_back)
// ----------------------------------------------------------------
// One box of the animal started by render_mob_begin, with its own
// textures: its centre is along / up / across from the animal's
// feet in the animal's frame. turn adds to the animal's yaw (a head
// looking round). pitch tips the box about its centre, or about the
// middle of its top if hip is TRUE (a leg swinging from the hip).
// ----------------------------------------------------------------
{
  Real    l_along     = p_along;
  Real    l_up        = p_up;
  Integer l_part      = 0;

  if (g_mob_parts >= MOB_MAX_PARTS) return;
  if (p_hip) {
    l_along = p_along + p_half_y * Sin(p_pitch);
    l_up    = p_up + p_half_y - p_half_y * Cos(p_pitch);
  }

  ++g_mob_parts;
  l_part = g_mob_parts;
  g_part_along [l_part] = l_along;
  g_part_up    [l_part] = l_up;
  g_part_across[l_part] = p_across;
  g_part_half_f[l_part] = p_half_f;
  g_part_half_y[l_part] = p_half_y;
  g_part_half_s[l_part] = p_half_s;
  g_part_turn  [l_part] = p_turn;
  g_part_pitch [l_part] = p_pitch;
  g_part_side  [l_part] = p_tex_side;
  g_part_top   [l_part] = p_tex_top;
  g_part_front [l_part] = p_tex_front;
  g_part_back  [l_part] = p_tex_back;
}

Integer render_mob_part_nearer(Integer p_a, Integer p_b, Real p_eye_along, Real p_eye_up, Real p_eye_across)
// ----------------------------------------------------------------
// TRUE if part a of the animal being queued is nearer the eye than
// part b, so it must be painted after it. The parts are boxes lined
// up with the animal, so along the axis on which they overlap least
// (usually one where they don't overlap at all) the one whose centre
// is nearer the eye is in front. (Tipped and turned parts are taken
// as their untipped boxes, which is close enough for this.)
// ----------------------------------------------------------------
{
  Real l_overlap_a = Absolute(g_part_along[p_a] - g_part_along[p_b])   - g_part_half_f[p_a] - g_part_half_f[p_b];
  Real l_overlap_u = Absolute(g_part_up[p_a] - g_part_up[p_b])         - g_part_half_y[p_a] - g_part_half_y[p_b];
  Real l_overlap_s = Absolute(g_part_across[p_a] - g_part_across[p_b]) - g_part_half_s[p_a] - g_part_half_s[p_b];

  // each l_overlap_* is the gap between the boxes along that axis
  // (negative where they overlap); use the axis with the widest gap
  if (l_overlap_a >= l_overlap_u && l_overlap_a >= l_overlap_s) {
    return Absolute(g_part_along[p_a] - p_eye_along) < Absolute(g_part_along[p_b] - p_eye_along);
  }
  if (l_overlap_u >= l_overlap_s) {
    return Absolute(g_part_up[p_a] - p_eye_up) < Absolute(g_part_up[p_b] - p_eye_up);
  }
  return Absolute(g_part_across[p_a] - p_eye_across) < Absolute(g_part_across[p_b] - p_eye_across);
}

void render_mob_end()
// ----------------------------------------------------------------
// Queue the collected boxes of the animal, all at the animal's own
// distance so they share a bucket, nearest first (a bucket paints
// the face queued last first), so nearer parts cover farther ones
// ----------------------------------------------------------------
{
  Real    l_facing_x  = Cos(g_mob_yaw);
  Real    l_facing_z  = Sin(g_mob_yaw);
  Real    l_to_x      = g_cam_x - g_mob_x;
  Real    l_to_z      = g_cam_z - g_mob_z;
  Real    l_eye_along =  l_to_x * l_facing_x + l_to_z * l_facing_z;
  Real    l_eye_across = -l_to_x * l_facing_z + l_to_z * l_facing_x;
  Real    l_eye_up    = g_cam_y - g_mob_y;
  Real    l_sort_sq   = l_to_x * l_to_x + (g_mob_y + 0.8 - g_cam_y) * (g_mob_y + 0.8 - g_cam_y) + l_to_z * l_to_z;
  Integer l_order[MOB_MAX_PARTS];
  Integer l_i         = 0;
  Integer l_j         = 0;
  Integer l_part      = 0;
  Integer l_moving    = 0;

  // insertion sort, nearest first
  for (l_i = 1; l_i <= g_mob_parts; ++l_i) {
    l_moving = l_i;
    l_j = l_i - 1;
    while (l_j >= 1) {
      if (!render_mob_part_nearer(l_moving, l_order[l_j], l_eye_along, l_eye_up, l_eye_across)) break;
      l_order[l_j + 1] = l_order[l_j];
      --l_j;
    }
    l_order[l_j + 1] = l_moving;
  }

  for (l_i = 1; l_i <= g_mob_parts; ++l_i) {
    l_part = l_order[l_i];
    render_add_box(g_mob_x + l_facing_x * g_part_along[l_part] - l_facing_z * g_part_across[l_part],
                   g_mob_y + g_part_up[l_part],
                   g_mob_z + l_facing_z * g_part_along[l_part] + l_facing_x * g_part_across[l_part],
                   g_mob_yaw + g_part_turn[l_part], g_part_pitch[l_part],
                   g_part_half_f[l_part], g_part_half_y[l_part], g_part_half_s[l_part],
                   g_part_side[l_part], g_part_top[l_part], g_part_front[l_part], g_part_back[l_part], g_mob_tint, l_sort_sq);
  }
  g_mob_parts = 0;
}

void render_mob_head_look(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_head_up, Real p_idle, Real &p_turn, Real &p_pitch)
// ----------------------------------------------------------------
// How far an animal's head turns from its body (turn) and tips up
// (pitch): towards the camera when it is near, otherwise a slow
// look around (idle is a number per animal that varies the sway)
// ----------------------------------------------------------------
{
  Real l_to_x  = g_cam_x - p_x;
  Real l_to_z  = g_cam_z - p_z;
  Real l_apart = Sqrt(l_to_x * l_to_x + l_to_z * l_to_z);
  Real l_turn  = 0.0;

  p_turn  = MOB_HEAD_SWAY * Sin(g_view_now * 0.6 + p_idle * 2.3);
  p_pitch = 0.15 * Sin(g_view_now * 0.4 + p_idle * 1.7);
  if (l_apart < MOB_LOOK_RANGE && l_apart > 0.3) {
    l_turn = wrap_angle(angle_of(l_to_z, l_to_x) - p_yaw + PI) - PI;
    if (Absolute(l_turn) < 2.0) {
      p_turn  = clamp_real(l_turn, -MOB_HEAD_TURN, MOB_HEAD_TURN);
      p_pitch = clamp_real(angle_of(g_cam_y - p_y - p_head_up, l_apart), -0.5, 0.5);
    }
  }
}

void render_zombie(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)
// ----------------------------------------------------------------
// A zombie: two legs and two arms held out in front that swing
// from the hip and shoulder, a body and a head that looks at you
// ----------------------------------------------------------------
{
  Real l_turn  = 0.0;
  Real l_pitch = 0.0;

  render_mob_head_look(p_x, p_y, p_z, p_yaw, 1.65, p_idle, l_turn, l_pitch);
  render_mob_begin(p_x, p_y, p_z, p_yaw, p_tint);
  //              along  up     across  half f  half y  half s  turn    pitch       hip    side                   top                    front             back
  render_mob_part(0.0  , 0.375,  0.12 , 0.12  , 0.375 , 0.12  , 0.0   ,  p_swing  , TRUE , TEX_ZOMBIE_PANTS     , TEX_ZOMBIE_PANTS     , TEX_ZOMBIE_PANTS, TEX_ZOMBIE_PANTS    );
  render_mob_part(0.0  , 0.375, -0.12 , 0.12  , 0.375 , 0.12  , 0.0   , -p_swing  , TRUE , TEX_ZOMBIE_PANTS     , TEX_ZOMBIE_PANTS     , TEX_ZOMBIE_PANTS, TEX_ZOMBIE_PANTS    );
  render_mob_part(0.0  , 1.125,  0.0  , 0.13  , 0.375 , 0.25  , 0.0   ,  0.0      , FALSE, TEX_ZOMBIE_SHIRT_SIDE, TEX_ZOMBIE_SHIRT_SIDE, TEX_ZOMBIE_SHIRT, TEX_ZOMBIE_SHIRT    );
  render_mob_part(0.30 , 1.38 ,  0.37 , 0.32  , 0.11  , 0.11  , 0.0   ,  p_swing * 0.3, FALSE, TEX_ZOMBIE_ARM   , TEX_ZOMBIE_ARM       , TEX_ZOMBIE_SKIN , TEX_ZOMBIE_SHIRT_SIDE);
  render_mob_part(0.30 , 1.38 , -0.37 , 0.32  , 0.11  , 0.11  , 0.0   , -p_swing * 0.3, FALSE, TEX_ZOMBIE_ARM   , TEX_ZOMBIE_ARM       , TEX_ZOMBIE_SKIN , TEX_ZOMBIE_SHIRT_SIDE);
  render_mob_part(0.0  , 1.65 ,  0.0  , 0.25  , 0.25  , 0.25  , l_turn,  l_pitch  , FALSE, TEX_ZOMBIE_HEAD_SIDE , TEX_ZOMBIE_HEAD_TOP  , TEX_ZOMBIE_FACE , TEX_ZOMBIE_HEAD_SIDE);
  render_mob_end();
}

void render_cow(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)
// ----------------------------------------------------------------
// A cow, sized like the block game's model (1 pixel of its skin is
// 1/16 block): a 12 x 10 x 18 body on four 4 x 12 legs that swing
// from the hip, an 8 x 8 x 6 head with two small horns that looks
// round. The model is moved back 0.15 so it sits over the cow's
// collision box.
// ----------------------------------------------------------------
{
  Real l_turn  = 0.0;
  Real l_pitch = 0.0;
  Real l_horn  = 0.0;

  render_mob_head_look(p_x, p_y, p_z, p_yaw, 1.25, p_idle, l_turn, l_pitch);
  render_mob_begin(p_x, p_y, p_z, p_yaw, p_tint);
  //              along    up      across  half f  half y  half s  turn    pitch     hip    side              top               front             back
  render_mob_part(-0.150 , 1.0625,  0.0  , 0.5625, 0.3125, 0.375 , 0.0   ,  0.0    , FALSE, TEX_COW_HIDE     , TEX_COW_BODY_TOP , TEX_COW_BODY_END , TEX_COW_BODY_END );
  render_mob_part( 0.5375, 1.25  ,  0.0  , 0.1875, 0.25  , 0.25  , l_turn,  l_pitch, FALSE, TEX_COW_HEAD_SIDE, TEX_COW_HEAD_TOP , TEX_COW_FACE     , TEX_COW_HEAD_SIDE);
  // horns ride on the head as it turns
  l_horn = 0.28;
  render_mob_part( 0.5375 + 0.0325 * Cos(l_turn) - l_horn * Sin(l_turn), 1.47,  l_horn * Cos(l_turn) + 0.0325 * Sin(l_turn), 0.031, 0.094, 0.031, l_turn, 0.0, FALSE, TEX_COW_HORN, TEX_COW_HORN, TEX_COW_HORN, TEX_COW_HORN);
  render_mob_part( 0.5375 + 0.0325 * Cos(l_turn) + l_horn * Sin(l_turn), 1.47, -l_horn * Cos(l_turn) + 0.0325 * Sin(l_turn), 0.031, 0.094, 0.031, l_turn, 0.0, FALSE, TEX_COW_HORN, TEX_COW_HORN, TEX_COW_HORN, TEX_COW_HORN);
  render_mob_part( 0.1625, 0.375 ,  0.25 , 0.125 , 0.375 , 0.125 , 0.0   ,  p_swing, TRUE , TEX_COW_LEG      , TEX_COW_LEG      , TEX_COW_LEG      , TEX_COW_LEG      );
  render_mob_part( 0.1625, 0.375 , -0.25 , 0.125 , 0.375 , 0.125 , 0.0   , -p_swing, TRUE , TEX_COW_LEG      , TEX_COW_LEG      , TEX_COW_LEG      , TEX_COW_LEG      );
  render_mob_part(-0.5875, 0.375 ,  0.25 , 0.125 , 0.375 , 0.125 , 0.0   , -p_swing, TRUE , TEX_COW_LEG      , TEX_COW_LEG      , TEX_COW_LEG      , TEX_COW_LEG      );
  render_mob_part(-0.5875, 0.375 , -0.25 , 0.125 , 0.375 , 0.125 , 0.0   ,  p_swing, TRUE , TEX_COW_LEG      , TEX_COW_LEG      , TEX_COW_LEG      , TEX_COW_LEG      );
  render_mob_end();
}

void render_pig(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)
// ----------------------------------------------------------------
// A pig, sized like the block game's model: a 10 x 8 x 16 body on
// four 4 x 6 legs that swing from the hip, an 8 x 8 x 8 head with a
// 4 x 3 snout that looks round. Moved back 0.19 so it sits over the
// pig's collision box.
// ----------------------------------------------------------------
{
  Real l_turn  = 0.0;
  Real l_pitch = 0.0;

  render_mob_head_look(p_x, p_y, p_z, p_yaw, 0.75, p_idle, l_turn, l_pitch);
  render_mob_begin(p_x, p_y, p_z, p_yaw, p_tint);
  //              along   up      across   half f  half y  half s  turn    pitch     hip    side               top                front             back
  render_mob_part(-0.19 , 0.625 ,  0.0   , 0.5   , 0.25  , 0.3125, 0.0   ,  0.0    , FALSE, TEX_PIG_BODY_SIDE , TEX_PIG_BODY_TOP , TEX_PIG_BODY_END , TEX_PIG_BODY_END );
  render_mob_part( 0.435, 0.75  ,  0.0   , 0.25  , 0.25  , 0.25  , l_turn,  l_pitch, FALSE, TEX_PIG_HEAD_SIDE , TEX_PIG_HEAD_SIDE, TEX_PIG_FACE     , TEX_PIG_HEAD_SIDE);
  // the snout sits on the front of the head as it turns
  render_mob_part( 0.435 + 0.281 * Cos(l_turn), 0.66 + 0.281 * Sin(l_pitch), 0.281 * Sin(l_turn), 0.031, 0.094, 0.125, l_turn, l_pitch, FALSE, TEX_PIG_SNOUT, TEX_PIG_SNOUT, TEX_PIG_SNOUT, TEX_PIG_SNOUT);
  render_mob_part( 0.12 , 0.1875,  0.1875, 0.125 , 0.1875, 0.125 , 0.0   ,  p_swing, TRUE , TEX_PIG_LEG       , TEX_PIG_LEG      , TEX_PIG_LEG      , TEX_PIG_LEG      );
  render_mob_part( 0.12 , 0.1875, -0.1875, 0.125 , 0.1875, 0.125 , 0.0   , -p_swing, TRUE , TEX_PIG_LEG       , TEX_PIG_LEG      , TEX_PIG_LEG      , TEX_PIG_LEG      );
  render_mob_part(-0.50 , 0.1875,  0.1875, 0.125 , 0.1875, 0.125 , 0.0   , -p_swing, TRUE , TEX_PIG_LEG       , TEX_PIG_LEG      , TEX_PIG_LEG      , TEX_PIG_LEG      );
  render_mob_part(-0.50 , 0.1875, -0.1875, 0.125 , 0.1875, 0.125 , 0.0   ,  p_swing, TRUE , TEX_PIG_LEG       , TEX_PIG_LEG      , TEX_PIG_LEG      , TEX_PIG_LEG      );
  render_mob_end();
}

void render_person(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_pitch, Real p_swing)
// ----------------------------------------------------------------
// Another player: legs and arms that swing as they walk, a body,
// and a head that looks up and down where they look
// ----------------------------------------------------------------
{
  render_mob_begin(p_x, p_y, p_z, p_yaw, 0.0);
  //              along  up     across  half f  half y  half s  turn  pitch     hip    side                   top                    front              back
  render_mob_part(0.0  , 0.375,  0.12 , 0.12  , 0.375 , 0.12  , 0.0 ,  p_swing, TRUE , TEX_PERSON_PANTS     , TEX_PERSON_PANTS     , TEX_PERSON_PANTS , TEX_PERSON_PANTS     );
  render_mob_part(0.0  , 0.375, -0.12 , 0.12  , 0.375 , 0.12  , 0.0 , -p_swing, TRUE , TEX_PERSON_PANTS     , TEX_PERSON_PANTS     , TEX_PERSON_PANTS , TEX_PERSON_PANTS     );
  render_mob_part(0.0  , 1.125,  0.0  , 0.13  , 0.375 , 0.25  , 0.0 ,  0.0    , FALSE, TEX_PERSON_SHIRT_SIDE, TEX_PERSON_SHIRT_SIDE, TEX_PERSON_SHIRT , TEX_PERSON_SHIRT     );
  render_mob_part(0.0  , 1.125,  0.37 , 0.11  , 0.375 , 0.11  , 0.0 , -p_swing, TRUE , TEX_PERSON_ARM       , TEX_PERSON_SHIRT_SIDE, TEX_PERSON_ARM   , TEX_PERSON_ARM       );
  render_mob_part(0.0  , 1.125, -0.37 , 0.11  , 0.375 , 0.11  , 0.0 ,  p_swing, TRUE , TEX_PERSON_ARM       , TEX_PERSON_SHIRT_SIDE, TEX_PERSON_ARM   , TEX_PERSON_ARM       );
  render_mob_part(0.0  , 1.75 ,  0.0  , 0.25  , 0.25  , 0.25  , 0.0 ,  p_pitch, FALSE, TEX_PERSON_HEAD_SIDE , TEX_PERSON_HEAD_TOP  , TEX_PERSON_FACE  , TEX_PERSON_HEAD_SIDE );
  render_mob_end();
}

void render_collect_peers(Attributes &p_peers)
// ----------------------------------------------------------------
// Queue the other players of a multiplayer game
// ----------------------------------------------------------------
{
  Integer l_peer = 0;
  Real    l_x    = 0.0;
  Real    l_y    = 0.0;
  Real    l_z    = 0.0;

  for (l_peer = 1; l_peer <= peers_count(p_peers); ++l_peer) {
    if (!peer_here(p_peers, l_peer)) continue;
    peer_position(p_peers, l_peer, l_x, l_y, l_z);
    if ((l_x - g_cam_x) * (l_x - g_cam_x) + (l_z - g_cam_z) * (l_z - g_cam_z) > (g_render_distance + 2.0) * (g_render_distance + 2.0)) continue;
    g_box_light = render_light_at(l_x, l_y + 1.0, l_z);
    render_person(l_x, l_y, l_z, peer_yaw(p_peers, l_peer), peer_pitch(p_peers, l_peer), Sin(peer_step(p_peers, l_peer)) * MOB_LEG_SWING);
  }
}

void render_peer_names(Draw_Box p_box, Attributes &p_peers)
// ----------------------------------------------------------------
// Each other player's name above their head (drawn over everything,
// so you can find them behind a hill)
// ----------------------------------------------------------------
{
  Integer l_peer  = 0;
  Real    l_x     = 0.0;
  Real    l_y     = 0.0;
  Real    l_z     = 0.0;
  Real    l_sx    = 0.0;
  Real    l_sy    = 0.0;
  Real    l_half  = 0.0;
  Text    l_name  = "";

  for (l_peer = 1; l_peer <= peers_count(p_peers); ++l_peer) {
    if (!peer_here(p_peers, l_peer)) continue;
    peer_position(p_peers, l_peer, l_x, l_y, l_z);
    if ((l_x - g_cam_x) * (l_x - g_cam_x) + (l_z - g_cam_z) * (l_z - g_cam_z) > PEER_NAME_DISTANCE * PEER_NAME_DISTANCE) continue;
    render_to_camera(l_x - g_cam_x, l_y + 2.25 - g_cam_y, l_z - g_cam_z);
    if (g_tc_z < 0.3) continue;
    l_sx   = g_centre_x + g_tc_x * g_focal / g_tc_z;
    l_sy   = g_centre_y + g_tc_y * g_focal / g_tc_z;
    l_name = peer_name(p_peers, l_peer);
    l_half = Text_length(l_name) * 3.5 + 4.0;
    render_set_colour(p_box, 30.0, 30.0, 34.0);
    render_fill_rect (p_box, l_sx - l_half, l_sy - 15.0, l_sx + l_half, l_sy + 2.0);
    hud_text(p_box, l_sx, l_sy, 12.0, TEXT_ALIGN_CENTRE, 240, 240, 240, l_name);
  }
}

void render_collect_cows(Attributes &p_cows)
// ----------------------------------------------------------------
// Queue every animal in view: cows, pigs and zombies, each made of
// boxes with swinging legs
// ----------------------------------------------------------------
{
  Integer l_cow   = 0;
  Integer l_live  = 0;
  Real    l_tint  = 0.0;
  Real    l_swing = 0.0;
  Real    l_x     = 0.0;
  Real    l_y     = 0.0;
  Real    l_z     = 0.0;
  Real    l_yaw   = 0.0;

  for (l_live = 1; l_live <= slots_count(SLOT_POOL_MOBS); ++l_live) {
    l_cow = slots_at(SLOT_POOL_MOBS, l_live);
    cow_position(p_cows, l_cow, l_x, l_y, l_z);
    if ((l_x - g_cam_x) * (l_x - g_cam_x) + (l_z - g_cam_z) * (l_z - g_cam_z) > (g_render_distance + 2.0) * (g_render_distance + 2.0)) continue;

    g_box_light = render_light_at(l_x, l_y + 1.0, l_z);
    l_yaw  = cow_yaw(p_cows, l_cow);
    l_tint = 0.0;
    if (cow_flash(p_cows, l_cow) > 0.0) l_tint = 0.55;
    // legs swing from the hip by up to MOB_LEG_SWING radians
    l_swing = Sin(cow_step(p_cows, l_cow)) * MOB_LEG_SWING;
    if (mob_kind(p_cows, l_cow) == MOB_ZOMBIE) {
      render_zombie(l_x, l_y, l_z, l_yaw, l_swing, l_tint, l_cow * 1.0);
      continue;
    }
    if (mob_kind(p_cows, l_cow) == MOB_PIG) {
      render_pig(l_x, l_y, l_z, l_yaw, l_swing, l_tint, l_cow * 1.0);
      continue;
    }

    render_cow(l_x, l_y, l_z, l_yaw, l_swing, l_tint, l_cow * 1.0);
  }
}

void render_collect_drops(Attributes &p_drops)
// ----------------------------------------------------------------
// Queue dropped items: blocks as small spinning, bobbing cubes,
// everything else as its picture facing the camera
// ----------------------------------------------------------------
{
  Integer l_drop    = 0;
  Integer l_live    = 0;
  Integer l_item    = 0;
  Real    l_bob     = 0.0;
  Real    l_age     = 0.0;
  Real    l_x       = 0.0;
  Real    l_y       = 0.0;
  Real    l_z       = 0.0;
  Real    l_dist_sq = 0.0;

  for (l_live = 1; l_live <= slots_count(SLOT_POOL_DROPS); ++l_live) {
    l_drop = slots_at(SLOT_POOL_DROPS, l_live);
    l_item = drop_item(p_drops, l_drop);
    l_age  = drop_age (p_drops, l_drop);
    drop_position(p_drops, l_drop, l_x, l_y, l_z);
    l_bob = 0.06 + Sin(l_age * 3.0) * 0.05;
    g_box_light = render_light_at(l_x, l_y + 0.3, l_z);

    if (item_is_block(l_item)) {
      render_add_box(l_x, l_y + DROP_HALF_SIZE + l_bob, l_z, l_age * 1.8, 0.0, DROP_HALF_SIZE, DROP_HALF_SIZE, DROP_HALF_SIZE,
                     item_side_texture(l_item), item_top_texture(l_item), item_side_texture(l_item), item_side_texture(l_item), 0.0, -1.0);
    } else {
      l_dist_sq = (l_x - g_cam_x) * (l_x - g_cam_x) + (l_y - g_cam_y) * (l_y - g_cam_y) + (l_z - g_cam_z) * (l_z - g_cam_z);
      if (l_dist_sq > g_render_distance * g_render_distance) continue;
      if (!render_sphere_visible(l_x - g_cam_x, l_y + 0.2 - g_cam_y, l_z - g_cam_z, 0.3)) continue;
      render_add_sprite(l_x - g_cam_x, l_y + l_bob - g_cam_y, l_z - g_cam_z, 0.2, 0.4, item_sprite_texture(l_item), 0.95 * g_box_light, l_dist_sq);
    }
  }
}

// ---------------------------------------------------------------- drawing faces

void render_clip_screen_edge(Integer p_axis, Real p_limit, Integer p_keep_above)
// ----------------------------------------------------------------
// Clip the screen polygon in g_poly_x/y (g_clip_count points)
// against one edge: axis 1 = x, 2 = y; keeps the side above limit
// if keep_above, else the side below
// ----------------------------------------------------------------
{
  Integer l_count  = 0;
  Integer l_point  = 0;
  Integer l_next   = 0;
  Real    l_value  = 0.0;
  Real    l_other  = 0.0;
  Integer l_inside = 0;
  Integer l_next_inside = 0;
  Real    l_t      = 0.0;

  for (l_point = 1; l_point <= g_clip_count; ++l_point) {
    l_next = l_point + 1;
    if (l_next > g_clip_count) l_next = 1;

    l_value = g_poly_x[l_point];
    l_other = g_poly_x[l_next];
    if (p_axis == 2) {
      l_value = g_poly_y[l_point];
      l_other = g_poly_y[l_next];
    }
    l_inside      = l_value >= p_limit;
    l_next_inside = l_other >= p_limit;
    if (!p_keep_above) {
      l_inside      = l_value <= p_limit;
      l_next_inside = l_other <= p_limit;
    }

    if (l_inside) {
      ++l_count;
      g_temp_x[l_count] = g_poly_x[l_point];
      g_temp_y[l_count] = g_poly_y[l_point];
    }
    if (l_inside != l_next_inside) {
      l_t = (p_limit - l_value) / (l_other - l_value);
      ++l_count;
      g_temp_x[l_count] = g_poly_x[l_point] + (g_poly_x[l_next] - g_poly_x[l_point]) * l_t;
      g_temp_y[l_count] = g_poly_y[l_point] + (g_poly_y[l_next] - g_poly_y[l_point]) * l_t;
    }
  }

  for (l_point = 1; l_point <= l_count; ++l_point) {
    g_poly_x[l_point] = g_temp_x[l_point];
    g_poly_y[l_point] = g_temp_y[l_point];
  }
  g_clip_count = l_count;
}

Integer render_clip_and_draw(Draw_Box p_box)
// ----------------------------------------------------------------
// Draw the camera space polygon in g_clip_x/y/z (g_clip_count
// points): clip it to the near plane (unless the face is known to
// be in front), project it, clip it to the screen if it reaches far
// outside, and fill it. Returns TRUE if anything was drawn.
// ----------------------------------------------------------------
{
  Integer l_count       = 0;
  Integer l_point       = 0;
  Integer l_next        = 0;
  Integer l_inside      = 0;
  Integer l_next_inside = 0;
  Integer l_far_out     = FALSE;
  Real    l_t           = 0.0;
  Real    l_scale       = 0.0;

  if (!g_q_front) {
    for (l_point = 1; l_point <= g_clip_count; ++l_point) {
      l_next = l_point + 1;
      if (l_next > g_clip_count) l_next = 1;
      l_inside      = g_clip_z[l_point] >= NEAR_PLANE;
      l_next_inside = g_clip_z[l_next ] >= NEAR_PLANE;
      if (l_inside) {
        ++l_count;
        g_temp_x[l_count] = g_clip_x[l_point];
        g_temp_y[l_count] = g_clip_y[l_point];
        g_temp_z[l_count] = g_clip_z[l_point];
      }
      if (l_inside != l_next_inside) {
        l_t = (NEAR_PLANE - g_clip_z[l_point]) / (g_clip_z[l_next] - g_clip_z[l_point]);
        ++l_count;
        g_temp_x[l_count] = g_clip_x[l_point] + (g_clip_x[l_next] - g_clip_x[l_point]) * l_t;
        g_temp_y[l_count] = g_clip_y[l_point] + (g_clip_y[l_next] - g_clip_y[l_point]) * l_t;
        g_temp_z[l_count] = NEAR_PLANE;
      }
    }
    if (l_count < 3) return FALSE;
    for (l_point = 1; l_point <= l_count; ++l_point) {
      g_clip_x[l_point] = g_temp_x[l_point];
      g_clip_y[l_point] = g_temp_y[l_point];
      g_clip_z[l_point] = g_temp_z[l_point];
    }
    g_clip_count = l_count;
  }

  for (l_point = 1; l_point <= g_clip_count; ++l_point) {
    l_scale = g_focal / g_clip_z[l_point];
    g_poly_x[l_point] = g_centre_x + g_clip_x[l_point] * l_scale;
    g_poly_y[l_point] = g_centre_y + g_clip_y[l_point] * l_scale;
    if (g_poly_x[l_point] < -GUARD_BAND || g_poly_x[l_point] > g_screen_w + GUARD_BAND) l_far_out = TRUE;
    if (g_poly_y[l_point] < -GUARD_BAND || g_poly_y[l_point] > g_screen_h + GUARD_BAND) l_far_out = TRUE;
  }

  if (l_far_out) {
    render_clip_screen_edge(1, -2.0, TRUE);
    if (g_clip_count >= 3) render_clip_screen_edge(1, g_screen_w + 2.0, FALSE);
    if (g_clip_count >= 3) render_clip_screen_edge(2, -2.0, TRUE);
    if (g_clip_count >= 3) render_clip_screen_edge(2, g_screen_h + 2.0, FALSE);
    if (g_clip_count < 3) return FALSE;
  }

  Draw_polygon(p_box, g_clip_count, g_poly_x, g_poly_y);
  ++g_stat_polygons;
  return TRUE;
}

void render_quad(Draw_Box p_box, Real p_u0, Real p_v0, Real p_u1, Real p_v1)
// ----------------------------------------------------------------
// Draw the part u0..u1, v0..v1 of the current face (g_q_*)
// Because a face is flat, a point on it is c0 + u e1 + v e2 in
// camera space, which keeps the perspective exact
// ----------------------------------------------------------------
{
  Real l_scale = 0.0;
  Real l_x     = 0.0;
  Real l_y     = 0.0;
  Real l_z     = 0.0;

  // Whole face in front of the camera and well inside the guard
  // band: every part of it can be projected and drawn directly
  if (g_q_safe) {
    l_x = g_q_c0x + p_u0 * g_q_e1x + p_v0 * g_q_e2x;
    l_y = g_q_c0y + p_u0 * g_q_e1y + p_v0 * g_q_e2y;
    l_z = g_q_c0z + p_u0 * g_q_e1z + p_v0 * g_q_e2z;
    l_scale = g_focal / l_z;
    g_poly_x[1] = g_centre_x + l_x * l_scale;
    g_poly_y[1] = g_centre_y + l_y * l_scale;
    l_x = g_q_c0x + p_u1 * g_q_e1x + p_v0 * g_q_e2x;
    l_y = g_q_c0y + p_u1 * g_q_e1y + p_v0 * g_q_e2y;
    l_z = g_q_c0z + p_u1 * g_q_e1z + p_v0 * g_q_e2z;
    l_scale = g_focal / l_z;
    g_poly_x[2] = g_centre_x + l_x * l_scale;
    g_poly_y[2] = g_centre_y + l_y * l_scale;
    l_x = g_q_c0x + p_u1 * g_q_e1x + p_v1 * g_q_e2x;
    l_y = g_q_c0y + p_u1 * g_q_e1y + p_v1 * g_q_e2y;
    l_z = g_q_c0z + p_u1 * g_q_e1z + p_v1 * g_q_e2z;
    l_scale = g_focal / l_z;
    g_poly_x[3] = g_centre_x + l_x * l_scale;
    g_poly_y[3] = g_centre_y + l_y * l_scale;
    l_x = g_q_c0x + p_u0 * g_q_e1x + p_v1 * g_q_e2x;
    l_y = g_q_c0y + p_u0 * g_q_e1y + p_v1 * g_q_e2y;
    l_z = g_q_c0z + p_u0 * g_q_e1z + p_v1 * g_q_e2z;
    l_scale = g_focal / l_z;
    g_poly_x[4] = g_centre_x + l_x * l_scale;
    g_poly_y[4] = g_centre_y + l_y * l_scale;
    Draw_polygon(p_box, 4, g_poly_x, g_poly_y);
    ++g_stat_polygons;
    return;
  }

  g_clip_x[1] = g_q_c0x + p_u0 * g_q_e1x + p_v0 * g_q_e2x;
  g_clip_y[1] = g_q_c0y + p_u0 * g_q_e1y + p_v0 * g_q_e2y;
  g_clip_z[1] = g_q_c0z + p_u0 * g_q_e1z + p_v0 * g_q_e2z;
  g_clip_x[2] = g_q_c0x + p_u1 * g_q_e1x + p_v0 * g_q_e2x;
  g_clip_y[2] = g_q_c0y + p_u1 * g_q_e1y + p_v0 * g_q_e2y;
  g_clip_z[2] = g_q_c0z + p_u1 * g_q_e1z + p_v0 * g_q_e2z;
  g_clip_x[3] = g_q_c0x + p_u1 * g_q_e1x + p_v1 * g_q_e2x;
  g_clip_y[3] = g_q_c0y + p_u1 * g_q_e1y + p_v1 * g_q_e2y;
  g_clip_z[3] = g_q_c0z + p_u1 * g_q_e1z + p_v1 * g_q_e2z;
  g_clip_x[4] = g_q_c0x + p_u0 * g_q_e1x + p_v1 * g_q_e2x;
  g_clip_y[4] = g_q_c0y + p_u0 * g_q_e1y + p_v1 * g_q_e2y;
  g_clip_z[4] = g_q_c0z + p_u0 * g_q_e1z + p_v1 * g_q_e2z;
  g_clip_count = 4;

  render_clip_and_draw(p_box);
}

void render_face_line(Draw_Box p_box, Real p_u0, Real p_v0, Real p_u1, Real p_v1)
// ----------------------------------------------------------------
// Draw a line across the current face between two (u, v) points
// Lines that cross the near plane are shortened to it
// ----------------------------------------------------------------
{
  Real l_x0 = g_q_c0x + p_u0 * g_q_e1x + p_v0 * g_q_e2x;
  Real l_y0 = g_q_c0y + p_u0 * g_q_e1y + p_v0 * g_q_e2y;
  Real l_z0 = g_q_c0z + p_u0 * g_q_e1z + p_v0 * g_q_e2z;
  Real l_x1 = g_q_c0x + p_u1 * g_q_e1x + p_v1 * g_q_e2x;
  Real l_y1 = g_q_c0y + p_u1 * g_q_e1y + p_v1 * g_q_e2y;
  Real l_z1 = g_q_c0z + p_u1 * g_q_e1z + p_v1 * g_q_e2z;
  Real l_t  = 0.0;

  if (l_z0 < NEAR_PLANE && l_z1 < NEAR_PLANE) return;
  if (l_z0 < NEAR_PLANE) {
    l_t  = (NEAR_PLANE - l_z0) / (l_z1 - l_z0);
    l_x0 = l_x0 + (l_x1 - l_x0) * l_t;
    l_y0 = l_y0 + (l_y1 - l_y0) * l_t;
    l_z0 = NEAR_PLANE;
  } else if (l_z1 < NEAR_PLANE) {
    l_t  = (NEAR_PLANE - l_z1) / (l_z0 - l_z1);
    l_x1 = l_x1 + (l_x0 - l_x1) * l_t;
    l_y1 = l_y1 + (l_y0 - l_y1) * l_t;
    l_z1 = NEAR_PLANE;
  }

  render_line(p_box, g_centre_x + l_x0 * g_focal / l_z0, g_centre_y + l_y0 * g_focal / l_z0,
                   g_centre_x + l_x1 * g_focal / l_z1, g_centre_y + l_y1 * g_focal / l_z1);
}

void render_palette_colour(Draw_Box p_box, Integer p_tex, Integer p_index)
// ----------------------------------------------------------------
// Set the colour of palette entry index of a texture, lit and
// fogged for the current face
// ----------------------------------------------------------------
{
  Integer l_slot = texture_palette_index(p_tex, p_index);

  render_set_face_colour(p_box, g_tex_pal_r[l_slot] * g_q_keep + g_q_add_r,
                         g_tex_pal_g[l_slot] * g_q_keep + g_q_add_g,
                         g_tex_pal_b[l_slot] * g_q_keep + g_q_add_b);
}

void render_draw_crack(Draw_Box p_box, Integer p_tex)
// ----------------------------------------------------------------
// Draw crack texture p_tex over the face set up by render_draw_face.
// A pack's crack images are greys meant to darken or lighten the
// block beneath, which can't be done here, so only their darker
// pixels are drawn, darkened further, as marks over the face.
// ----------------------------------------------------------------
{
  Integer l_rect   = 0;
  Integer l_first  = g_tex_rect_first[p_tex];
  Integer l_last   = l_first + g_tex_rect_count[p_tex] - 1;
  Integer l_slot   = 0;
  Integer l_colour = 0;
  Integer l_skip   = FALSE;

  for (l_rect = l_first; l_rect <= l_last; ++l_rect) {
    if (g_rect_pal[l_rect] != l_colour) {
      l_colour = g_rect_pal[l_rect];
      l_slot   = texture_palette_index(p_tex, l_colour);
      l_skip   = g_tex_pal_r[l_slot] + g_tex_pal_g[l_slot] + g_tex_pal_b[l_slot] > CRACK_LIGHTEST;
      if (!l_skip) {
        render_set_face_colour(p_box, g_tex_pal_r[l_slot] * CRACK_DARKEN * g_q_keep + g_q_add_r,
                               g_tex_pal_g[l_slot] * CRACK_DARKEN * g_q_keep + g_q_add_g,
                               g_tex_pal_b[l_slot] * CRACK_DARKEN * g_q_keep + g_q_add_b);
      }
    }
    if (l_skip) continue;
    render_quad(p_box, g_rect_u0[l_rect], g_rect_v0[l_rect], g_rect_u1[l_rect], g_rect_v1[l_rect]);
  }
}

void render_draw_face(Draw_Box p_box, Integer p_face)
// ----------------------------------------------------------------
// Paint one queued face: the base colour over the whole face, then
// (when close enough) the rectangles of the texture's other colours
// ----------------------------------------------------------------
{
  Integer l_tex     = g_df_tex[p_face];
  Integer l_detail  = g_df_detail[p_face];
  Real    l_fog     = g_df_fog[p_face];
  Real    l_tint    = g_df_tint[p_face];
  Real    l_lit     = g_df_shade[p_face] * (1.0 - l_fog);
  Integer l_rect    = 0;
  Integer l_first   = 0;
  Integer l_last    = 0;
  Integer l_colour  = 0;
  Integer l_corner  = 0;
  Real    l_x       = 0.0;
  Real    l_y       = 0.0;
  Real    l_z       = 0.0;
  Real    l_px      = 0.0;
  Real    l_py      = 0.0;
  Real    l_u0      = g_df_u0[p_face];
  Real    l_u1      = g_df_u1[p_face];
  Real    l_rect_u0 = 0.0;
  Real    l_rect_u1 = 0.0;
  Real    l_wet     = g_df_wet[p_face];
  Real    l_glint_u = 0.0;
  Real    l_glint_v = 0.0;
  Integer l_glint   = 0;

  g_q_c0x   = g_df_c0x[p_face];
  g_q_c0y   = g_df_c0y[p_face];
  g_q_c0z   = g_df_c0z[p_face];
  g_q_e1x   = g_df_e1x[p_face];
  g_q_e1y   = g_df_e1y[p_face];
  g_q_e1z   = g_df_e1z[p_face];
  g_q_e2x   = g_df_e2x[p_face];
  g_q_e2y   = g_df_e2y[p_face];
  g_q_e2z   = g_df_e2z[p_face];
  g_q_front = g_df_front[p_face];

  // Safe to project parts of the face directly if all four corners
  // are in front of the camera and inside the guard band
  g_q_safe = g_q_front;
  if (g_q_safe) {
    for (l_corner = 1; l_corner <= 4; ++l_corner) {
      l_x = g_q_c0x;
      l_y = g_q_c0y;
      l_z = g_q_c0z;
      if (l_corner == 2 || l_corner == 3) {
        l_x = l_x + g_q_e1x;
        l_y = l_y + g_q_e1y;
        l_z = l_z + g_q_e1z;
      }
      if (l_corner >= 3) {
        l_x = l_x + g_q_e2x;
        l_y = l_y + g_q_e2y;
        l_z = l_z + g_q_e2z;
      }
      l_px = g_centre_x + l_x * g_focal / l_z;
      l_py = g_centre_y + l_y * g_focal / l_z;
      if (l_px < -GUARD_BAND || l_px > g_screen_w + GUARD_BAND) g_q_safe = FALSE;
      if (l_py < -GUARD_BAND || l_py > g_screen_h + GUARD_BAND) g_q_safe = FALSE;
    }
  }

  // colour = palette * keep + add (shade, red hurt flash, then fog)
  g_q_keep  = l_lit * (1.0 - l_tint);
  g_q_add_r = l_fog * g_fog_r + l_lit * l_tint * 230.0;
  g_q_add_g = l_fog * g_fog_g + l_lit * l_tint * 40.0;
  g_q_add_b = l_fog * g_fog_b + l_lit * l_tint * 30.0;
  // seen through water: part water colour
  if (l_wet > 0.0) {
    g_q_keep  = g_q_keep * (1.0 - l_wet);
    g_q_add_r = g_q_add_r + l_lit * l_wet * WATER_TINT_R;
    g_q_add_g = g_q_add_g + l_lit * l_wet * WATER_TINT_G;
    g_q_add_b = g_q_add_b + l_lit * l_wet * WATER_TINT_B;
  }

  // Water seen from above can't be drawn see-through, so only a few
  // short light glints drifting across it are drawn, placed by the
  // cell (g_df_phase) so they don't line up; what is under it is
  // drawn tinted (see g_df_wet). Far away the tint is enough.
  if (l_tex == TEX_WATER && !g_view_eye_in_water) {
    if (l_detail == DETAIL_FLAT) return;
    render_set_colour(p_box, (0.4 * g_tex_avg_r[l_tex] + 130.0) * g_q_keep + g_q_add_r,
                      (0.4 * g_tex_avg_g[l_tex] + 150.0) * g_q_keep + g_q_add_g,
                      (0.4 * g_tex_avg_b[l_tex] + 160.0) * g_q_keep + g_q_add_b);
    for (l_glint = 1; l_glint <= WATER_GLINTS; ++l_glint) {
      l_glint_u = g_df_phase[p_face] * 3.7 + l_glint * 0.45;
      l_glint_u = (l_glint_u - Floor(l_glint_u)) * (1.0 - WATER_GLINT_LENGTH);
      l_glint_v = g_df_phase[p_face] + l_glint / (1.0 * WATER_GLINTS) + g_view_now * 0.1;
      l_glint_v = (l_glint_v - Floor(l_glint_v)) * (1.0 - WATER_GLINT_WIDTH);
      render_quad(p_box, l_glint_u, l_glint_v, l_glint_u + WATER_GLINT_LENGTH, l_glint_v + WATER_GLINT_WIDTH);
    }
    return;
  }

  // Pictures have no base colour: never draw them as one block of
  // colour, at least their larger patches
  if (g_tex_is_sprite[l_tex] && l_detail == DETAIL_FLAT) l_detail = DETAIL_MAJOR;

  if (l_detail == DETAIL_FLAT) {
    render_set_face_colour(p_box, g_tex_avg_r[l_tex] * g_q_keep + g_q_add_r,
                           g_tex_avg_g[l_tex] * g_q_keep + g_q_add_g,
                           g_tex_avg_b[l_tex] * g_q_keep + g_q_add_b);
    render_quad(p_box, l_u0, 0.0, l_u1, 1.0);
  } else {
    if (g_tex_base[l_tex] > 0) {
      render_palette_colour(p_box, l_tex, g_tex_base[l_tex]);
      render_quad(p_box, l_u0, 0.0, l_u1, 1.0);
    }

    l_first = g_tex_rect_first[l_tex];
    l_last  = l_first + g_tex_rect_count[l_tex] - 1;
    // Rectangles are grouped by colour, so the colour is only set
    // when it changes
    l_colour = 0;
    for (l_rect = l_first; l_rect <= l_last; ++l_rect) {
      if (l_detail == DETAIL_MAJOR && g_rect_area[l_rect] < MAJOR_RECT_AREA) continue;
      // only the part inside the face's u span (half pictures)
      l_rect_u0 = g_rect_u0[l_rect];
      l_rect_u1 = g_rect_u1[l_rect];
      if (l_rect_u1 <= l_u0 || l_rect_u0 >= l_u1) continue;
      if (l_rect_u0 < l_u0) l_rect_u0 = l_u0;
      if (l_rect_u1 > l_u1) l_rect_u1 = l_u1;
      if (g_rect_pal[l_rect] != l_colour) {
        l_colour = g_rect_pal[l_rect];
        render_palette_colour(p_box, l_tex, l_colour);
      }
      render_quad(p_box, l_rect_u0, g_rect_v0[l_rect], l_rect_u1, g_rect_v1[l_rect]);
    }
  }

  if (g_df_crack[p_face] > 0) render_draw_crack(p_box, TEX_DESTROY_FIRST + g_df_crack[p_face] - 1);
}

void render_cover_reset()
// ----------------------------------------------------------------
// Nothing covered yet, apart from what is below the view (the
// status strip) and above the top of the screen
// ----------------------------------------------------------------
{
  Integer l_line = 0;
  Integer l_slot = 0;

  g_cover_columns = Floor(g_screen_w / COVER_COLUMN_PIXELS) + 2;
  if (g_cover_columns > MAX_COVER_COLUMNS) g_cover_columns = MAX_COVER_COLUMNS;
  for (l_line = 1; l_line <= g_cover_columns; ++l_line) {
    l_slot = (l_line - 1) * COVER_SPANS;
    g_cover_count[l_line] = 2;
    g_cover_low [l_slot + 1] = -1.0e30;
    g_cover_high[l_slot + 1] = g_view_bottom;
    g_cover_low [l_slot + 2] = g_screen_h;
    g_cover_high[l_slot + 2] = 1.0e30;
  }
}

void render_cover_add(Integer p_line, Real p_low, Real p_high)
// ----------------------------------------------------------------
// Add the stretch low..high to a line's covered spans, merging it
// with every span it overlaps or nearly touches (COVER_JOIN). The
// spans are kept in order, bottom first. If the line already has
// COVER_SPANS separate spans, a stretch that joins none of them is
// left out (that only means less is hidden).
// ----------------------------------------------------------------
{
  Integer l_base  = (p_line - 1) * COVER_SPANS;
  Integer l_count = g_cover_count[p_line];
  Integer l_first = 0;
  Integer l_last  = 0;
  Integer l_span  = 0;
  Integer l_gone  = 0;

  // Spans that touch the stretch form one run, first..last
  for (l_span = 1; l_span <= l_count; ++l_span) {
    if (g_cover_high[l_base + l_span] < p_low - COVER_JOIN) continue;
    if (g_cover_low [l_base + l_span] > p_high + COVER_JOIN) break;
    if (l_first == 0) l_first = l_span;
    l_last = l_span;
  }

  if (l_first == 0) {
    // A separate span: insert it before the first span above it
    if (l_count >= COVER_SPANS) return;
    l_span = l_count;
    while (l_span >= 1) {
      if (g_cover_low[l_base + l_span] < p_low) break;
      g_cover_low [l_base + l_span + 1] = g_cover_low [l_base + l_span];
      g_cover_high[l_base + l_span + 1] = g_cover_high[l_base + l_span];
      --l_span;
    }
    g_cover_low [l_base + l_span + 1] = p_low;
    g_cover_high[l_base + l_span + 1] = p_high;
    g_cover_count[p_line] = l_count + 1;
    return;
  }

  // Merge the run into its first span and close the gap after it
  if (p_low < g_cover_low[l_base + l_first]) g_cover_low[l_base + l_first] = p_low;
  g_cover_high[l_base + l_first] = g_cover_high[l_base + l_last];
  if (p_high > g_cover_high[l_base + l_first]) g_cover_high[l_base + l_first] = p_high;
  l_gone = l_last - l_first;
  if (l_gone == 0) return;
  for (l_span = l_last + 1; l_span <= l_count; ++l_span) {
    g_cover_low [l_base + l_span - l_gone] = g_cover_low [l_base + l_span];
    g_cover_high[l_base + l_span - l_gone] = g_cover_high[l_base + l_span];
  }
  g_cover_count[p_line] = l_count - l_gone;
}

void render_cover_corners(Integer p_face)
// ----------------------------------------------------------------
// Screen positions of a queued face's corners into g_cover_x/y
// (the face must be in front of the camera)
// ----------------------------------------------------------------
{
  Integer l_corner = 0;
  Real    l_x      = 0.0;
  Real    l_y      = 0.0;
  Real    l_z      = 0.0;

  for (l_corner = 1; l_corner <= 4; ++l_corner) {
    l_x = g_df_c0x[p_face];
    l_y = g_df_c0y[p_face];
    l_z = g_df_c0z[p_face];
    if (l_corner == 2 || l_corner == 3) {
      l_x = l_x + g_df_e1x[p_face];
      l_y = l_y + g_df_e1y[p_face];
      l_z = l_z + g_df_e1z[p_face];
    }
    if (l_corner >= 3) {
      l_x = l_x + g_df_e2x[p_face];
      l_y = l_y + g_df_e2y[p_face];
      l_z = l_z + g_df_e2z[p_face];
    }
    g_cover_x[l_corner] = g_centre_x + l_x * g_focal / l_z;
    g_cover_y[l_corner] = g_centre_y + l_y * g_focal / l_z;
  }
}

void render_cover_face(Integer p_face)
// ----------------------------------------------------------------
// Check one queued face against the coverage so far (every face
// checked before it is nearer, see render_hide_covered): mark it
// hidden if, on every coverage line from just left of it to just
// right of it, its whole height range lies inside one covered span,
// or if it is off the screen. Otherwise, if it is opaque, add the
// stretch it covers on each line that crosses it.
// ----------------------------------------------------------------
{
  Integer l_corner  = 0;
  Integer l_line    = 0;
  Integer l_first   = 0;
  Integer l_last    = 0;
  Integer l_base    = 0;
  Integer l_span    = 0;
  Integer l_inside  = FALSE;
  Integer l_covered = TRUE;
  Real    l_min_x   =  1.0e30;
  Real    l_max_x   = -1.0e30;
  Real    l_min_y   =  1.0e30;
  Real    l_max_y   = -1.0e30;
  Real    l_low     = 0.0;
  Real    l_high    = 0.0;
  Real    l_line_x  = 0.0;
  Real    l_x0      = 0.0;
  Real    l_x1      = 0.0;
  Real    l_y       = 0.0;
  Integer l_next    = 0;

  // Faces cut by the near plane are always drawn and hide nothing
  if (!g_df_front[p_face]) return;

  render_cover_corners(p_face);
  for (l_corner = 1; l_corner <= 4; ++l_corner) {
    if (g_cover_x[l_corner] < l_min_x) l_min_x = g_cover_x[l_corner];
    if (g_cover_x[l_corner] > l_max_x) l_max_x = g_cover_x[l_corner];
    if (g_cover_y[l_corner] < l_min_y) l_min_y = g_cover_y[l_corner];
    if (g_cover_y[l_corner] > l_max_y) l_max_y = g_cover_y[l_corner];
  }

  // Off the screen: nothing to draw
  if (l_max_x < 0.0 || l_min_x > g_screen_w || l_max_y < g_view_bottom || l_min_y > g_screen_h) {
    g_df_hidden[p_face] = TRUE;
    return;
  }
  // Huge on screen (very close): leave it to the clipping
  if (l_min_x < -GUARD_BAND || l_max_x > g_screen_w + GUARD_BAND) return;
  if (l_min_y < -GUARD_BAND || l_max_y > g_screen_h + GUARD_BAND) return;

  l_first = clamp_integer(Floor(l_min_x / COVER_COLUMN_PIXELS) + 1, 1, g_cover_columns);
  l_last  = clamp_integer(Floor(l_max_x / COVER_COLUMN_PIXELS) + 2, 1, g_cover_columns);
  for (l_line = l_first; l_line <= l_last; ++l_line) {
    l_base   = (l_line - 1) * COVER_SPANS;
    l_inside = FALSE;
    for (l_span = 1; l_span <= g_cover_count[l_line]; ++l_span) {
      if (g_cover_high[l_base + l_span] < l_max_y + COVER_MARGIN) continue;
      if (g_cover_low [l_base + l_span] <= l_min_y - COVER_MARGIN) l_inside = TRUE;
      break;
    }
    if (!l_inside) {
      l_covered = FALSE;
      break;
    }
  }
  if (l_covered) {
    g_df_hidden[p_face] = TRUE;
    ++g_stat_hidden;
    return;
  }

  if (!g_df_opaque[p_face]) return;

  // Lines that cross the face: where each crosses the face's edges
  // (written out here rather than calling render_cover_extent, this
  // runs for every line of every opaque face)
  l_first = Floor(l_min_x / COVER_COLUMN_PIXELS) + 1;
  if ((l_first - 1) * COVER_COLUMN_PIXELS < l_min_x) ++l_first;
  l_last  = Floor(l_max_x / COVER_COLUMN_PIXELS) + 1;
  if (l_first < 1) l_first = 1;
  if (l_last > g_cover_columns) l_last = g_cover_columns;
  for (l_line = l_first; l_line <= l_last; ++l_line) {
    l_line_x = (l_line - 1) * COVER_COLUMN_PIXELS;
    l_low    =  1.0e30;
    l_high   = -1.0e30;
    for (l_corner = 1; l_corner <= 4; ++l_corner) {
      l_next = l_corner + 1;
      if (l_next > 4) l_next = 1;
      l_x0 = g_cover_x[l_corner];
      l_x1 = g_cover_x[l_next];
      if (l_x0 < l_line_x && l_x1 < l_line_x) continue;
      if (l_x0 > l_line_x && l_x1 > l_line_x) continue;
      if (l_x0 == l_x1) continue;   // an upright edge on the line: its ends are on the other edges
      l_y = g_cover_y[l_corner] + (l_line_x - l_x0) * (g_cover_y[l_next] - g_cover_y[l_corner]) / (l_x1 - l_x0);
      if (l_y < l_low ) l_low  = l_y;
      if (l_y > l_high) l_high = l_y;
    }
    if (l_high > l_low) render_cover_add(l_line, l_low, l_high);
  }
}

void render_hide_covered()
// ----------------------------------------------------------------
// Walk the queued faces in the opposite order to painting (nearest
// bucket first, and each bucket's list backwards) and mark the
// faces that nearer ones would paint over
// ----------------------------------------------------------------
{
  Integer l_bucket = 0;
  Integer l_face   = 0;
  Integer l_count  = 0;
  Integer l_index  = 0;

  render_cover_reset();
  for (l_bucket = g_bucket_low; l_bucket <= g_bucket_high; ++l_bucket) {
    l_count = 0;
    l_face  = g_bucket_head[l_bucket];
    while (l_face > 0) {
      ++l_count;
      g_bucket_order[l_count] = l_face;
      l_face = g_df_next[l_face];
    }
    for (l_index = l_count; l_index >= 1; --l_index) render_cover_face(g_bucket_order[l_index]);
  }
}

void render_draw_faces(Draw_Box p_box)
// ----------------------------------------------------------------
// Paint every queued face that isn't hidden, farthest bucket first,
// and empty the buckets for the next frame
// ----------------------------------------------------------------
{
  Integer l_bucket = 0;
  Integer l_face   = 0;

  for (l_bucket = g_bucket_high; l_bucket >= g_bucket_low; --l_bucket) {
    l_face = g_bucket_head[l_bucket];
    while (l_face > 0) {
      if (!g_df_hidden[l_face]) render_draw_face(p_box, l_face);
      l_face = g_df_next[l_face];
    }
    g_bucket_head[l_bucket] = 0;
  }
  g_bucket_low  = MAX_BUCKETS + 1;
  g_bucket_high = 0;
}

// ---------------------------------------------------------------- sky and overlays

void render_sky_colours(Real p_time_of_day)
// ----------------------------------------------------------------
// Horizon (fog) and overhead sky colours for a time of day: blue by
// day, dark navy at night, orange at the horizon around sunrise and
// sunset
// ----------------------------------------------------------------
{
  Real l_day    = clamp_real((world_sun_height(p_time_of_day) + 0.15) / 0.45, 0.0, 1.0);
  Real l_glow   = 1.0 - clamp_real(Absolute(world_sun_height(p_time_of_day)) / 0.25, 0.0, 1.0);

  g_fog_r     = lerp_real(14.0, 170.0, l_day);
  g_fog_g     = lerp_real(18.0, 205.0, l_day);
  g_fog_b     = lerp_real(34.0, 245.0, l_day);
  g_sky_top_r = lerp_real(4.0 , 92.0 , l_day);
  g_sky_top_g = lerp_real(6.0 , 146.0, l_day);
  g_sky_top_b = lerp_real(18.0, 232.0, l_day);

  // sunrise and sunset glow at the horizon
  g_fog_r = lerp_real(g_fog_r, 236.0, l_glow * 0.65);
  g_fog_g = lerp_real(g_fog_g, 140.0, l_glow * 0.65);
  g_fog_b = lerp_real(g_fog_b, 84.0 , l_glow * 0.65);
}

void render_sky_disc(Draw_Box p_box, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_size, Integer p_moon)
// ----------------------------------------------------------------
// The sun (a bright square with a paler core) or the moon (a pale
// square with darker patches) in a direction from the eye
// ----------------------------------------------------------------
{
  Real l_px   = 0.0;
  Real l_py   = 0.0;
  Real l_size = g_focal * p_size;

  render_to_camera(p_dir_x, p_dir_y, p_dir_z);
  if (g_tc_z <= 0.1) return;
  l_px = g_centre_x + g_tc_x * g_focal / g_tc_z;
  l_py = g_centre_y + g_tc_y * g_focal / g_tc_z;
  if (p_moon) {
    render_set_colour(p_box, 214.0, 218.0, 226.0);
    render_fill_rect(p_box, l_px - l_size, l_py - l_size, l_px + l_size, l_py + l_size);
    render_set_colour(p_box, 168.0, 172.0, 184.0);
    render_fill_rect(p_box, l_px - l_size * 0.5, l_py + l_size * 0.1, l_px - l_size * 0.1, l_py + l_size * 0.5);
    render_fill_rect(p_box, l_px + l_size * 0.2, l_py - l_size * 0.5, l_px + l_size * 0.55, l_py - l_size * 0.2);
  } else {
    render_set_colour(p_box, 255.0, 246.0, 200.0);
    render_fill_rect(p_box, l_px - l_size, l_py - l_size, l_px + l_size, l_py + l_size);
    render_set_colour(p_box, 255.0, 255.0, 236.0);
    render_fill_rect(p_box, l_px - l_size * 0.6, l_py - l_size * 0.6, l_px + l_size * 0.6, l_py + l_size * 0.6);
  }
}

void render_stars(Draw_Box p_box, Real p_brightness)
// ----------------------------------------------------------------
// Fixed stars over the sky, fading in as the light goes
// ----------------------------------------------------------------
{
  Integer l_star  = 0;
  Real    l_px    = 0.0;
  Real    l_py    = 0.0;
  Real    l_level = 0.0;

  for (l_star = 1; l_star <= NUM_STARS; ++l_star) {
    render_to_camera(g_star_x[l_star], g_star_y[l_star], g_star_z[l_star]);
    if (g_tc_z <= 0.1) continue;
    l_px = g_centre_x + g_tc_x * g_focal / g_tc_z;
    l_py = g_centre_y + g_tc_y * g_focal / g_tc_z;
    if (l_px < 0.0 || l_px > g_screen_w || l_py < g_view_bottom || l_py > g_screen_h) continue;
    l_level = p_brightness * g_star_level[l_star];
    render_set_colour(p_box, lerp_real(g_sky_top_r, 255.0, l_level / 255.0), lerp_real(g_sky_top_g, 255.0, l_level / 255.0), lerp_real(g_sky_top_b, 240.0, l_level / 255.0));
    render_fill_rect(p_box, l_px - 1.0, l_py - 1.0, l_px + 1.0, l_py + 1.0);
  }
}

void render_sky(Draw_Box p_box)
// ----------------------------------------------------------------
// Sky gradient (pale at the horizon, deep blue overhead, both
// following the time of day), a haze below the horizon, stars, the
// sun and the moon. Under water: murky blue.
// ----------------------------------------------------------------
{
  Real    l_horizon  = g_centre_y - g_focal * Sin(g_view_pitch) / Cos(g_view_pitch);
  Real    l_band_h   = (g_screen_h - g_view_bottom) / 16.0;
  Real    l_y0       = 0.0;
  Real    l_y1       = 0.0;
  Real    l_height   = 0.0;
  Real    l_amount   = 0.0;
  Real    l_sun_x    = 0.42;
  Real    l_sun_y    = 0.62;
  Real    l_sun_z    = 0.66;
  Integer l_band     = 0;

  if (g_view_eye_in_water) {
    render_set_colour(p_box, g_fog_r, g_fog_g, g_fog_b);
    render_fill_rect(p_box, 0.0, g_view_bottom, g_screen_w, g_screen_h);
    return;
  }

  for (l_band = 1; l_band <= 16; ++l_band) {
    l_y0     = g_view_bottom + (l_band - 1) * l_band_h;
    l_y1     = g_view_bottom + l_band * l_band_h + 1.0;
    l_height = (l_y0 + l_band_h / 2.0 - l_horizon) / (g_screen_h - g_view_bottom);
    if (l_height >= 0.0) {
      l_amount = clamp_real(l_height * 1.7, 0.0, 1.0);
      render_set_colour(p_box, lerp_real(g_fog_r, g_sky_top_r, l_amount), lerp_real(g_fog_g, g_sky_top_g, l_amount), lerp_real(g_fog_b, g_sky_top_b, l_amount));
    } else {
      l_amount = clamp_real(-l_height * 2.0, 0.0, 1.0);
      render_set_colour(p_box, lerp_real(g_fog_r, g_fog_r * 0.75, l_amount), lerp_real(g_fog_g, g_fog_g * 0.78, l_amount), lerp_real(g_fog_b, g_fog_b * 0.8, l_amount));
    }
    render_fill_rect(p_box, 0.0, l_y0, g_screen_w, l_y1);
  }

  // Stars at night, then the sun and moon, which cross the sky from
  // east (+x) to west through the day
  if (g_view_daylight < 0.6) render_stars(p_box, clamp_real((0.6 - g_view_daylight) / 0.4, 0.0, 1.0));
  l_sun_x = Cos(g_view_time * TWO_PI);
  l_sun_y = Sin(g_view_time * TWO_PI);
  l_sun_z = 0.3;
  render_sky_disc(p_box,  l_sun_x,  l_sun_y,  l_sun_z, 0.07, FALSE);
  render_sky_disc(p_box, -l_sun_x, -l_sun_y, -l_sun_z, 0.05, TRUE);
}

Integer render_point_visible(Real p_x, Real p_y, Real p_z, Integer p_skip_x, Integer p_skip_y, Integer p_skip_z)
// ----------------------------------------------------------------
// TRUE if no block that hides faces lies on the straight line from
// the eye to the point (x, y, z), apart from the cell skip_x/y/z
// (a 3D DDA walk through the cells the line crosses)
// ----------------------------------------------------------------
{
  Real    l_dir_x  = p_x - g_cam_x;
  Real    l_dir_y  = p_y - g_cam_y;
  Real    l_dir_z  = p_z - g_cam_z;
  Integer l_cell_x = Floor(g_cam_x);
  Integer l_cell_y = Floor(g_cam_y);
  Integer l_cell_z = Floor(g_cam_z);
  Integer l_step_x = 1;
  Integer l_step_y = 1;
  Integer l_step_z = 1;
  Real    l_delta_x = 1.0e30;
  Real    l_delta_y = 1.0e30;
  Real    l_delta_z = 1.0e30;
  Real    l_next_x = 1.0e30;
  Real    l_next_y = 1.0e30;
  Real    l_next_z = 1.0e30;
  Real    l_t      = 0.0;
  Integer l_guard  = 0;

  // t runs from 0 at the eye to 1 at the point
  if (l_dir_x != 0.0) l_delta_x = Absolute(1.0 / l_dir_x);
  if (l_dir_y != 0.0) l_delta_y = Absolute(1.0 / l_dir_y);
  if (l_dir_z != 0.0) l_delta_z = Absolute(1.0 / l_dir_z);
  if (l_dir_x < 0.0) {
    l_step_x = -1;
    l_next_x = (g_cam_x - l_cell_x) * l_delta_x;
  } else {
    l_next_x = (l_cell_x + 1.0 - g_cam_x) * l_delta_x;
  }
  if (l_dir_y < 0.0) {
    l_step_y = -1;
    l_next_y = (g_cam_y - l_cell_y) * l_delta_y;
  } else {
    l_next_y = (l_cell_y + 1.0 - g_cam_y) * l_delta_y;
  }
  if (l_dir_z < 0.0) {
    l_step_z = -1;
    l_next_z = (g_cam_z - l_cell_z) * l_delta_z;
  } else {
    l_next_z = (l_cell_z + 1.0 - g_cam_z) * l_delta_z;
  }

  while (l_guard < 64) {
    ++l_guard;
    // step into the next cell, unless the point comes first
    if (l_next_x <= l_next_y && l_next_x <= l_next_z) {
      l_t      = l_next_x;
      l_next_x = l_next_x + l_delta_x;
      l_cell_x = l_cell_x + l_step_x;
    } else if (l_next_y <= l_next_z) {
      l_t      = l_next_y;
      l_next_y = l_next_y + l_delta_y;
      l_cell_y = l_cell_y + l_step_y;
    } else {
      l_t      = l_next_z;
      l_next_z = l_next_z + l_delta_z;
      l_cell_z = l_cell_z + l_step_z;
    }
    if (l_t >= 1.0) return TRUE;

    if (l_cell_x == p_skip_x && l_cell_y == p_skip_y && l_cell_z == p_skip_z) continue;
    if (block_hides_faces(world_get_block(l_cell_x, l_cell_y, l_cell_z))) return FALSE;
  }
  return TRUE;
}

void render_world_line(Draw_Box p_box, Real p_x0, Real p_y0, Real p_z0, Real p_x1, Real p_y1, Real p_z1)
// ----------------------------------------------------------------
// Line between two world points, shortened where it crosses the
// near plane
// ----------------------------------------------------------------
{
  Real l_ax = 0.0;
  Real l_ay = 0.0;
  Real l_az = 0.0;
  Real l_bx = 0.0;
  Real l_by = 0.0;
  Real l_bz = 0.0;
  Real l_t  = 0.0;

  render_to_camera(p_x0 - g_cam_x, p_y0 - g_cam_y, p_z0 - g_cam_z);
  l_ax = g_tc_x;
  l_ay = g_tc_y;
  l_az = g_tc_z;
  render_to_camera(p_x1 - g_cam_x, p_y1 - g_cam_y, p_z1 - g_cam_z);
  l_bx = g_tc_x;
  l_by = g_tc_y;
  l_bz = g_tc_z;

  if (l_az < NEAR_PLANE && l_bz < NEAR_PLANE) return;
  if (l_az < NEAR_PLANE) {
    l_t  = (NEAR_PLANE - l_az) / (l_bz - l_az);
    l_ax = l_ax + (l_bx - l_ax) * l_t;
    l_ay = l_ay + (l_by - l_ay) * l_t;
    l_az = NEAR_PLANE;
  } else if (l_bz < NEAR_PLANE) {
    l_t  = (NEAR_PLANE - l_bz) / (l_az - l_bz);
    l_bx = l_bx + (l_ax - l_bx) * l_t;
    l_by = l_by + (l_ay - l_by) * l_t;
    l_bz = NEAR_PLANE;
  }

  render_line(p_box, g_centre_x + l_ax * g_focal / l_az, g_centre_y + l_ay * g_focal / l_az,
                     g_centre_x + l_bx * g_focal / l_bz, g_centre_y + l_by * g_focal / l_bz);
}

void render_target_outline(Draw_Box p_box)
// ----------------------------------------------------------------
// Thin dark frame around the targeted block: each of its 12 edges
// that borders a face pointing towards the eye, split into
// OUTLINE_PIECES pieces, and only the pieces that no other block
// hides from the eye (a ray to each piece's middle). The outline is
// drawn after the world, so without this test it would show
// through blocks in front of the target.
// ----------------------------------------------------------------
{
  Integer l_edge    = 0;
  Integer l_piece   = 0;
  Integer l_axis    = 0;
  Integer l_a       = 0;
  Integer l_b       = 0;
  Integer l_bx      = g_view_target_x;
  Integer l_by      = g_view_target_y;
  Integer l_bz      = g_view_target_z;
  Integer l_front_a = 0;
  Integer l_front_b = 0;
  Real    l_x0      = 0.0;
  Real    l_y0      = 0.0;
  Real    l_z0      = 0.0;
  Real    l_dx      = 0.0;
  Real    l_dy      = 0.0;
  Real    l_dz      = 0.0;
  Real    l_px      = 0.0;
  Real    l_py      = 0.0;
  Real    l_pz      = 0.0;
  Real    l_mx      = 0.0;
  Real    l_my      = 0.0;
  Real    l_mz      = 0.0;
  Real    l_to_x    = 0.0;
  Real    l_to_y    = 0.0;
  Real    l_to_z    = 0.0;
  Real    l_length  = 0.0;
  Real    l_lo_x    = 0.0;
  Real    l_lo_y    = 0.0;
  Real    l_lo_z    = 0.0;
  Real    l_hi_x    = 1.0;
  Real    l_hi_y    = 1.0;
  Real    l_hi_z    = 1.0;

  if (g_view_target_kind != TARGET_BLOCK) return;

  // the block's box (smaller than the cell for torches and plants),
  // a little larger so the frame isn't buried in the faces
  block_box(world_get_block(l_bx, l_by, l_bz), l_lo_x, l_lo_y, l_lo_z, l_hi_x, l_hi_y, l_hi_z);
  l_lo_x = l_bx + l_lo_x - 0.004;
  l_lo_y = l_by + l_lo_y - 0.004;
  l_lo_z = l_bz + l_lo_z - 0.004;
  l_hi_x = l_bx + l_hi_x + 0.004;
  l_hi_y = l_by + l_hi_y + 0.004;
  l_hi_z = l_bz + l_hi_z + 0.004;

  render_set_colour(p_box, 16.0, 16.0, 16.0);

  // Edge number 1..12: axis 1 (x), 2 (y) or 3 (z) it runs along, and
  // which side (a, b) of the box it is on across the other two axes
  for (l_edge = 1; l_edge <= 12; ++l_edge) {
    l_axis = Floor((l_edge - 1) / 4.0) + 1;
    l_a    = Floor((l_edge - 1) / 2.0) - (l_axis - 1) * 2;
    l_b    = l_edge - 1 - (l_axis - 1) * 4 - l_a * 2;

    // The two faces beside the edge; draw it if either faces the eye
    l_front_a = FALSE;
    l_front_b = FALSE;
    if (l_axis == 1) {
      // across: y (a) and z (b)
      if (l_a == 1) l_front_a = g_cam_y > l_hi_y;
      if (l_a == 0) l_front_a = g_cam_y < l_lo_y;
      if (l_b == 1) l_front_b = g_cam_z > l_hi_z;
      if (l_b == 0) l_front_b = g_cam_z < l_lo_z;
      l_x0 = l_lo_x;
      l_y0 = l_lo_y + l_a * (l_hi_y - l_lo_y);
      l_z0 = l_lo_z + l_b * (l_hi_z - l_lo_z);
      l_dx = l_hi_x - l_lo_x;
      l_dy = 0.0;
      l_dz = 0.0;
    } else if (l_axis == 2) {
      // across: x (a) and z (b)
      if (l_a == 1) l_front_a = g_cam_x > l_hi_x;
      if (l_a == 0) l_front_a = g_cam_x < l_lo_x;
      if (l_b == 1) l_front_b = g_cam_z > l_hi_z;
      if (l_b == 0) l_front_b = g_cam_z < l_lo_z;
      l_x0 = l_lo_x + l_a * (l_hi_x - l_lo_x);
      l_y0 = l_lo_y;
      l_z0 = l_lo_z + l_b * (l_hi_z - l_lo_z);
      l_dx = 0.0;
      l_dy = l_hi_y - l_lo_y;
      l_dz = 0.0;
    } else {
      // across: x (a) and y (b)
      if (l_a == 1) l_front_a = g_cam_x > l_hi_x;
      if (l_a == 0) l_front_a = g_cam_x < l_lo_x;
      if (l_b == 1) l_front_b = g_cam_y > l_hi_y;
      if (l_b == 0) l_front_b = g_cam_y < l_lo_y;
      l_x0 = l_lo_x + l_a * (l_hi_x - l_lo_x);
      l_y0 = l_lo_y + l_b * (l_hi_y - l_lo_y);
      l_z0 = l_lo_z;
      l_dx = 0.0;
      l_dy = 0.0;
      l_dz = l_hi_z - l_lo_z;
    }
    if (!l_front_a && !l_front_b) continue;

    for (l_piece = 1; l_piece <= OUTLINE_PIECES; ++l_piece) {
      // middle of the piece, moved a little towards the eye so the
      // ray doesn't end inside a block that shares the edge
      l_px = l_x0 + l_dx * (l_piece - 1) / OUTLINE_PIECES;
      l_py = l_y0 + l_dy * (l_piece - 1) / OUTLINE_PIECES;
      l_pz = l_z0 + l_dz * (l_piece - 1) / OUTLINE_PIECES;
      l_mx = l_px + l_dx * 0.5 / OUTLINE_PIECES;
      l_my = l_py + l_dy * 0.5 / OUTLINE_PIECES;
      l_mz = l_pz + l_dz * 0.5 / OUTLINE_PIECES;
      l_to_x = g_cam_x - l_mx;
      l_to_y = g_cam_y - l_my;
      l_to_z = g_cam_z - l_mz;
      l_length = Sqrt(l_to_x * l_to_x + l_to_y * l_to_y + l_to_z * l_to_z);
      if (l_length > 0.05) {
        l_mx = l_mx + l_to_x * OUTLINE_NUDGE / l_length;
        l_my = l_my + l_to_y * OUTLINE_NUDGE / l_length;
        l_mz = l_mz + l_to_z * OUTLINE_NUDGE / l_length;
      }
      if (!render_point_visible(l_mx, l_my, l_mz, l_bx, l_by, l_bz)) continue;

      render_world_line(p_box, l_px, l_py, l_pz, l_px + l_dx / OUTLINE_PIECES, l_py + l_dy / OUTLINE_PIECES, l_pz + l_dz / OUTLINE_PIECES);
    }
  }
}

void render_world(Draw_Box p_box, Real p_w, Real p_h, Real p_view_bottom, Attributes &p_player, Attributes &p_cows,
                  Attributes &p_drops, Attributes &p_peers, Attributes &p_settings, Real p_time_of_day, Real p_now)
// ----------------------------------------------------------------
// Draw the 3D view from the player's eyes: sky, then every face far
// to near, then the outline of the targeted block. Must be inside a
// batch draw.
// ----------------------------------------------------------------
{
  Real    l_x      = 0.0;
  Real    l_y      = 0.0;
  Real    l_z      = 0.0;
  Real    l_yaw    = 0.0;
  Real    l_pitch  = 0.0;

  render_view_from(p_player, p_settings, p_time_of_day, p_now);
  player_position (p_player, l_x, l_y, l_z);
  player_look     (p_player, l_yaw, l_pitch);
  render_setup_camera(p_w, p_h, p_view_bottom, l_x, player_eye_y(p_player), l_z, l_yaw, l_pitch, settings_fov_radians(p_settings));

  g_face_total     = 0;
  g_stat_faces     = 0;
  g_stat_polygons  = 0;
  g_stat_sections  = 0;
  g_stat_examined  = 0;
  g_stat_hidden    = 0;

  render_sky(p_box);
  render_collect_blocks();
  mesh_build_nearby(g_cam_x, g_cam_y, g_cam_z, min_integer(g_render_distance, VERTICAL_RANGE + SECTION_SIZE), BACKGROUND_BUILDS);
  render_collect_cows  (p_cows);
  render_collect_drops (p_drops);
  render_collect_peers (p_peers);
  g_box_light = 1.0;
  g_stat_faces = g_face_total;

  render_hide_covered();
  render_draw_faces(p_box);
  render_target_outline(p_box);
  render_peer_names(p_box, p_peers);
}

#endif
