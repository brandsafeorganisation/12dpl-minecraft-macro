#ifndef RENDER_H_INCLUDED
#define RENDER_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// First person 3D view drawn with Draw_Box polygons
//
// Every visible face is projected through a pinhole camera and
// painted far to near (painter's algorithm). For unit cubes on a
// grid, ordering by the distance from the eye to each cube's centre
// is a valid back to front order, so faces are bucket sorted by the
// squared distance of the cube (or entity box) they belong to.
//
// Close faces are drawn with their full 16 x 16 texture (base
// colour plus merged rectangles), faces a little further away with
// just the larger patches, distant faces as one average colour.
// Colours are shaded per face direction and by the light level the
// mesh stored for the face, and fade into the sky with distance.
// Plants are two pictures crossed in an X, fixed in the world;
// dropped non-block items are pictures that always face the camera.
//
// Table functions: everything in this module works on the frame
// scratch tables below. render_world copies what it needs from the
// records it is given (player, settings, ...) into the g_view_*
// globals at the start of a frame; nothing else writes them.
// ----------------------------------------------------------------

#define MAX_DRAW_FACES     20000
#define MAX_BUCKETS        4096
#define PLANT_HALF_WIDTH   0.45    // a plant's crossed pictures reach this far from the cell centre along x and z
#define PLANT_HEIGHT       0.9
#define NEAR_PLANE         0.05
#define GUARD_BAND         3000.0  // screen clipping only past this many pixels
#define MAX_POLY_POINTS    24
#define CRACK_LIGHTEST     330     // crack pixels lighter than this (red + green + blue) aren't drawn
#define CRACK_DARKEN       0.55    // crack pixels are drawn this much darker
#define MOB_MAX_PARTS      8       // boxes an animal is built from, at most
#define MOB_LEG_SWING      0.5     // how far legs swing from the hip while walking (radians)
#define PEER_NAME_DISTANCE 48.0    // other players' names show up to this far away
#define MOB_HEAD_TURN      0.9     // how far a head turns to look at you (radians)
#define MOB_HEAD_SWAY      0.35    // how far a head sways while looking round
#define MOB_LOOK_RANGE     8.0     // animals this close look at you
#define WATER_TOP          0.875   // height of a water surface in its cell
#define WATER_TINT         0.6     // share of the water colour over a face seen through water
#define WATER_TINT_R       40.0    // the colour water tints faces towards
#define WATER_TINT_G       90.0
#define WATER_TINT_B       200.0
#define WATER_GLINTS       2       // light glints drawn on a water surface seen from above
#define WATER_GLINT_LENGTH 0.4     // each glint's length and width, as a share of the face
#define WATER_GLINT_WIDTH  0.06
#define CUBE_RADIUS        0.87    // half the diagonal of a block
#define SECTION_RADIUS     13.9    // half the diagonal of a section
#define DETAIL_FLAT        0       // one average colour
#define DETAIL_MAJOR       1       // base colour and the larger patches
#define DETAIL_FULL        2       // every pixel of the texture
#define MAJOR_RECT_AREA    3       // patches of fewer pixels are left out at DETAIL_MAJOR
#define VERTICAL_RANGE     40      // sections further than this above or below the eye are skipped
#define NUM_STARS          70
#define OUTLINE_PIECES     8       // each edge of the target's outline is tested for being hidden in this many pieces
#define OUTLINE_NUDGE      0.03    // a piece's test point is moved this far towards the eye

// Hidden face removal: before painting, the queued faces are walked
// near to far, and vertical coverage lines every COVER_COLUMN_PIXELS
// across the screen remember which stretches of them (up to
// COVER_SPANS separate spans each) opaque faces already cover. A
// face that falls entirely inside covered spans of the lines it
// spans would be painted over, so it is not drawn at all.
#define COVER_COLUMN_PIXELS 4.0   // gap between coverage lines
#define MAX_COVER_COLUMNS   1600  // enough for a view 6400 pixels wide
#define COVER_SPANS         6     // separate covered spans a line can hold
#define COVER_SPAN_SLOTS    9600  // MAX_COVER_COLUMNS * COVER_SPANS
#define COVER_JOIN          0.5   // a face this close to the covered part extends it (pixels)
#define COVER_MARGIN        1.0   // a face must be this far inside the covered part to be dropped

/*Global variables*/ {
  // Copied from the settings and the player at the start of a frame
  Integer g_render_distance  = 20;
  Real    g_lod_full_pixels  = 110.0;  // faces bigger than this get the whole texture
  Real    g_lod_major_pixels = 44.0;   // faces bigger than this get its larger patches
  Real    g_bucket_scale     = 1.0;    // buckets per unit of squared distance
  Integer g_view_eye_in_water = 0;
  Integer g_view_plants       = 1;
  Integer g_view_shading      = 1;
  Integer g_view_plant_range  = 16;
  Real    g_view_pitch        = 0.0;
  Integer g_view_break_stage  = 0;
  Integer g_view_break_x      = 0;
  Integer g_view_break_y      = -1;
  Integer g_view_break_z      = 0;
  Integer g_view_target_kind  = 0;
  Integer g_view_target_x     = 0;
  Integer g_view_target_y     = 0;
  Integer g_view_target_z     = 0;
  Real    g_view_daylight     = 1.0;   // 0..1, dims sky light at night
  Real    g_view_time         = 0.25;
  Real    g_view_now          = 0.0;   // clock for animation (water shimmer)  // time of day, 0 sunrise, 0.25 noon, 0.5 sunset, 0.75 midnight
  Real    g_box_light         = 1.0;   // light of the entity being queued

  // The boxes of the animal being queued (render_mob_begin .. end)
  Real    g_mob_x      = 0.0;
  Real    g_mob_y      = 0.0;
  Real    g_mob_z      = 0.0;
  Real    g_mob_yaw    = 0.0;
  Real    g_mob_tint   = 0.0;
  Integer g_mob_parts  = 0;
  Real    g_part_along [MOB_MAX_PARTS];
  Real    g_part_up    [MOB_MAX_PARTS];
  Real    g_part_across[MOB_MAX_PARTS];
  Real    g_part_half_f[MOB_MAX_PARTS];
  Real    g_part_half_y[MOB_MAX_PARTS];
  Real    g_part_half_s[MOB_MAX_PARTS];
  Real    g_part_turn  [MOB_MAX_PARTS];
  Real    g_part_pitch [MOB_MAX_PARTS];
  Integer g_part_side  [MOB_MAX_PARTS];
  Integer g_part_top   [MOB_MAX_PARTS];
  Integer g_part_front [MOB_MAX_PARTS];
  Integer g_part_back  [MOB_MAX_PARTS];
  Real    g_sky_top_r = 92.0;
  Real    g_sky_top_g = 146.0;
  Real    g_sky_top_b = 232.0;

  // Camera, rebuilt every frame
  Real    g_cam_x = 0.0;
  Real    g_cam_y = 0.0;
  Real    g_cam_z = 0.0;
  Real    g_right_x = 0.0;
  Real    g_right_z = 0.0;
  Real    g_up_x = 0.0;
  Real    g_up_y = 0.0;
  Real    g_up_z = 0.0;
  Real    g_fwd_x = 0.0;
  Real    g_fwd_y = 0.0;
  Real    g_fwd_z = 0.0;
  Real    g_focal    = 400.0;
  Real    g_screen_w = 800.0;
  Real    g_screen_h = 480.0;
  Real    g_centre_x = 400.0;
  Real    g_centre_y = 240.0;
  Real    g_view_bottom = 0.0;
  Real    g_cull_cos_x = 0.0;
  Real    g_cull_sin_x = 0.0;
  Real    g_cull_cos_y = 0.0;
  Real    g_cull_sin_y = 0.0;

  // Fog and sky
  Real    g_fog_start = 10.0;
  Real    g_fog_end   = 18.0;
  Real    g_fog_r = 170.0;
  Real    g_fog_g = 205.0;
  Real    g_fog_b = 245.0;

  // Face buffer for one frame
  Integer g_face_total = 0;
  Real    g_df_c0x[MAX_DRAW_FACES];
  Real    g_df_c0y[MAX_DRAW_FACES];
  Real    g_df_c0z[MAX_DRAW_FACES];
  Real    g_df_e1x[MAX_DRAW_FACES];
  Real    g_df_e1y[MAX_DRAW_FACES];
  Real    g_df_e1z[MAX_DRAW_FACES];
  Real    g_df_e2x[MAX_DRAW_FACES];
  Real    g_df_e2y[MAX_DRAW_FACES];
  Real    g_df_e2z[MAX_DRAW_FACES];
  Integer g_df_tex    [MAX_DRAW_FACES];
  Real    g_df_shade  [MAX_DRAW_FACES];
  Real    g_df_fog    [MAX_DRAW_FACES];
  Real    g_df_tint   [MAX_DRAW_FACES];
  Real    g_df_wet    [MAX_DRAW_FACES];   // 0..1: how far a face under water is tinted towards the water
  Real    g_df_phase  [MAX_DRAW_FACES];   // 0..1 per cell: where a water surface's glints sit
  Integer g_df_detail [MAX_DRAW_FACES];
  Integer g_df_front  [MAX_DRAW_FACES];
  Integer g_df_crack  [MAX_DRAW_FACES];
  Real    g_df_u0     [MAX_DRAW_FACES];   // part of the texture drawn across the face
  Real    g_df_u1     [MAX_DRAW_FACES];   // (0..1 except for half pictures)
  Integer g_df_next   [MAX_DRAW_FACES];
  Integer g_df_opaque [MAX_DRAW_FACES];   // hides what is behind it (an opaque block face)
  Integer g_df_hidden [MAX_DRAW_FACES];   // covered by nearer faces: not drawn
  Integer g_bucket_head[MAX_BUCKETS];
  Integer g_bucket_low  = 1;              // range of buckets used this frame
  Integer g_bucket_high = 0;
  Integer g_bucket_order[MAX_DRAW_FACES]; // one bucket's faces, while walking it backwards

  // Coverage (see COVER_*): line n is at screen x
  // (n - 1) * COVER_COLUMN_PIXELS and has g_cover_count[n] covered
  // spans, bottom first; span k runs from screen y g_cover_low to
  // g_cover_high at slot (n - 1) * COVER_SPANS + k
  Integer g_cover_columns = 0;
  Integer g_cover_count[MAX_COVER_COLUMNS];
  Real    g_cover_low  [COVER_SPAN_SLOTS];
  Real    g_cover_high [COVER_SPAN_SLOTS];
  Real    g_cover_x[4];                   // the face being checked, on screen
  Real    g_cover_y[4];

  // The face being drawn
  Real    g_q_c0x = 0.0;
  Real    g_q_c0y = 0.0;
  Real    g_q_c0z = 0.0;
  Real    g_q_e1x = 0.0;
  Real    g_q_e1y = 0.0;
  Real    g_q_e1z = 0.0;
  Real    g_q_e2x = 0.0;
  Real    g_q_e2y = 0.0;
  Real    g_q_e2z = 0.0;
  Integer g_q_front = 0;
  Integer g_q_safe  = 0;
  Real    g_q_keep  = 1.0;
  Real    g_q_add_r = 0.0;
  Real    g_q_add_g = 0.0;
  Real    g_q_add_b = 0.0;

  // Result of render_to_camera
  Real    g_tc_x = 0.0;
  Real    g_tc_y = 0.0;
  Real    g_tc_z = 0.0;

  // Polygon scratch: camera space input, clipped output, screen
  Integer g_clip_count = 0;
  Real    g_clip_x[MAX_POLY_POINTS];
  Real    g_clip_y[MAX_POLY_POINTS];
  Real    g_clip_z[MAX_POLY_POINTS];
  Real    g_poly_x[MAX_POLY_POINTS];
  Real    g_poly_y[MAX_POLY_POINTS];
  Real    g_temp_x[MAX_POLY_POINTS];
  Real    g_temp_y[MAX_POLY_POINTS];
  Real    g_temp_z[MAX_POLY_POINTS];

  // Star directions and brightness (set by render_init)
  Real    g_star_x    [NUM_STARS];
  Real    g_star_y    [NUM_STARS];
  Real    g_star_z    [NUM_STARS];
  Real    g_star_level[NUM_STARS];

  // A plant's four half pictures, while queueing them
  Real    g_fin_dist[4];
  Integer g_fin_done[4];

  // Statistics for the frame
  Integer g_stat_faces    = 0;
  Integer g_stat_polygons = 0;
  Integer g_stat_sections = 0;
  Integer g_stat_examined = 0;   // cached faces looked at
  Integer g_stat_hidden   = 0;   // queued faces dropped as covered
}

void    render_init            ();
void    render_set_detail      (Integer p_level);
void    render_set_colour      (Draw_Box p_box, Real p_red, Real p_green, Real p_blue);
void    render_set_face_colour (Draw_Box p_box, Real p_red, Real p_green, Real p_blue);
void    render_fill_rect       (Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1);
void    render_line            (Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1);
void    render_setup_camera    (Real p_w, Real p_h, Real p_view_bottom, Real p_eye_x, Real p_eye_y, Real p_eye_z,
                                Real p_yaw, Real p_pitch, Real p_field_of_view);
void    render_to_camera       (Real p_rel_x, Real p_rel_y, Real p_rel_z);
Integer render_sphere_visible  (Real p_rel_x, Real p_rel_y, Real p_rel_z, Real p_radius);
void    render_add_face        (Real p_c0x, Real p_c0y, Real p_c0z, Real p_e1x, Real p_e1y, Real p_e1z, Real p_e2x, Real p_e2y, Real p_e2z,
                                Integer p_tex, Real p_shade, Real p_distance_squared, Real p_size, Real p_tint, Integer p_crack);
void    render_add_block_face  (Integer p_x, Integer p_y, Integer p_z, Integer p_direction, Integer p_block,
                                Real p_distance_squared, Integer p_crack, Real p_light, Real p_wet);
void    render_add_sprite      (Real p_rel_x, Real p_rel_y, Real p_rel_z, Real p_half_width, Real p_height, Integer p_tex,
                                Real p_shade, Real p_distance_squared);
void    render_add_shaped      (Integer p_x, Integer p_y, Integer p_z, Integer p_block, Real p_light);
void    render_add_plant       (Integer p_x, Integer p_y, Integer p_z, Integer p_tex, Real p_light);
Integer render_layer_count     (Real p_limit);
void    render_collect_blocks  ();
void    render_add_box         (Real p_centre_x, Real p_centre_y, Real p_centre_z, Real p_yaw, Real p_pitch, Real p_half_f, Real p_half_y, Real p_half_s,
                                Integer p_tex_side, Integer p_tex_top, Integer p_tex_front, Integer p_tex_back, Real p_tint, Real p_sort_dist_sq);
void    render_collect_cows    (Attributes &p_cows);
void    render_collect_drops   (Attributes &p_drops);
Integer render_clip_and_draw   (Draw_Box p_box);
void    render_quad            (Draw_Box p_box, Real p_u0, Real p_v0, Real p_u1, Real p_v1);
void    render_draw_crack      (Draw_Box p_box, Integer p_tex);
void    render_draw_face       (Draw_Box p_box, Integer p_face);
void    render_cover_reset     ();
void    render_cover_add       (Integer p_line, Real p_low, Real p_high);
void    render_cover_corners   (Integer p_face);
void    render_cover_face      (Integer p_face);
void    render_hide_covered    ();
void    render_draw_faces      (Draw_Box p_box);
void    render_sky             (Draw_Box p_box);
Integer render_point_visible   (Real p_x, Real p_y, Real p_z, Integer p_skip_x, Integer p_skip_y, Integer p_skip_z);
void    render_world_line      (Draw_Box p_box, Real p_x0, Real p_y0, Real p_z0, Real p_x1, Real p_y1, Real p_z1);
void    render_target_outline  (Draw_Box p_box);
void    render_view_from       (Attributes &p_player, Attributes &p_settings, Real p_time_of_day, Real p_now);
Text    render_stats_text      ();
Real    render_light_at        (Real p_x, Real p_y, Real p_z);
void    render_mob_begin       (Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_tint);
void    render_mob_part        (Real p_along, Real p_up, Real p_across, Real p_half_f, Real p_half_y, Real p_half_s,
                                Real p_turn, Real p_pitch, Integer p_hip,
                                Integer p_tex_side, Integer p_tex_top, Integer p_tex_front, Integer p_tex_back);
Integer render_mob_part_nearer (Integer p_a, Integer p_b, Real p_eye_along, Real p_eye_up, Real p_eye_across);
void    render_mob_end         ();
void    render_mob_head_look   (Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_head_up, Real p_idle, Real &p_turn, Real &p_pitch);
void    render_zombie          (Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle);
void    render_cow             (Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle);
void    render_pig             (Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle);
void    render_sky_colours     (Real p_time_of_day);
void    render_sky_disc        (Draw_Box p_box, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_size, Integer p_moon);
void    render_stars           (Draw_Box p_box, Real p_brightness);
void    render_world           (Draw_Box p_box, Real p_w, Real p_h, Real p_view_bottom, Attributes &p_player, Attributes &p_cows,
                                Attributes &p_drops, Attributes &p_peers, Attributes &p_settings, Real p_time_of_day, Real p_now);
void    render_person          (Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_pitch, Real p_swing);
void    render_collect_peers   (Attributes &p_peers);
void    render_peer_names      (Draw_Box p_box, Attributes &p_peers);

#endif
