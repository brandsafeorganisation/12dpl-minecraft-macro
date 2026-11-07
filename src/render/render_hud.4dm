#ifndef RENDER_HUD_4DM_INCLUDED
#define RENDER_HUD_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/blocks/textures.h"
#include "../../include/world/world.h"
#include "../../include/items/inventory.h"
#include "../../include/player/player.h"
#include "../../include/core/records.h"
#include "../../include/program/settings.h"
#include "../../include/render/render.h"
#include "../../include/render/hud.h"

// ---------------------------------------------------------------- messages

void hud_clear(Attributes &p_hud)
// ----------------------------------------------------------------
// Remove every message; the help shows until the player starts
// ----------------------------------------------------------------
{
  Integer l_toast = 0;

  record_clear(p_hud, DATATYPE_HUD);
  for (l_toast = 1; l_toast <= MAX_TOASTS; ++l_toast) {
    record_set_text_at(p_hud, ATTR_TEXT,      l_toast, "");
    record_set_real_at(p_hud, ATTR_HUD_UNTIL, l_toast, 0.0);
  }
  record_set_integer(p_hud, ATTR_HUD_HELP,       TRUE);
  record_set_real   (p_hud, ATTR_HUD_NAME_UNTIL, 0.0);
  record_set_integer(p_hud, ATTR_HUD_FRAMES,     0);
  record_set_real   (p_hud, ATTR_HUD_FRAME_SUM,  0.0);
  record_set_real   (p_hud, ATTR_HUD_FRAME_MIN,  0.0);
  record_set_real   (p_hud, ATTR_HUD_FRAME_MAX,  0.0);
  record_set_real   (p_hud, ATTR_HUD_WINDOW,     0.0);
  record_set_text   (p_hud, ATTR_HUD_STATS,      "");
}

void hud_note_frame(Attributes &p_hud, Real p_frame_ms, Real p_now)
// ----------------------------------------------------------------
// Count a drawn frame; once a second the fastest, average and
// slowest frame time of that second and the frame rate are kept
// as text for the statistics line
// ----------------------------------------------------------------
{
  Integer l_frames  = record_integer(p_hud, ATTR_HUD_FRAMES);
  Real    l_sum     = record_real   (p_hud, ATTR_HUD_FRAME_SUM);
  Real    l_fastest = record_real   (p_hud, ATTR_HUD_FRAME_MIN);
  Real    l_slowest = record_real   (p_hud, ATTR_HUD_FRAME_MAX);
  Real    l_start   = record_real   (p_hud, ATTR_HUD_WINDOW);
  Real    l_elapsed = 0.0;

  if (l_frames == 0 || p_frame_ms < l_fastest) l_fastest = p_frame_ms;
  if (l_frames == 0 || p_frame_ms > l_slowest) l_slowest = p_frame_ms;
  if (l_frames == 0 && l_start <= 0.0) l_start = p_now;
  ++l_frames;
  l_sum = l_sum + p_frame_ms;

  l_elapsed = p_now - l_start;
  if (l_elapsed >= FRAME_STATS_SECONDS) {
    record_set_text(p_hud, ATTR_HUD_STATS, "frame " + To_text(l_fastest, 1) + " / " + To_text(l_sum / l_frames, 1) + " / "
                    + To_text(l_slowest, 1) + " ms (min/avg/max), " + To_text(l_frames / l_elapsed, 1) + " fps");
    l_frames = 0;
    l_sum    = 0.0;
    l_start  = p_now;
  }
  record_set_integer(p_hud, ATTR_HUD_FRAMES,    l_frames);
  record_set_real   (p_hud, ATTR_HUD_FRAME_SUM, l_sum);
  record_set_real   (p_hud, ATTR_HUD_FRAME_MIN, l_fastest);
  record_set_real   (p_hud, ATTR_HUD_FRAME_MAX, l_slowest);
  record_set_real   (p_hud, ATTR_HUD_WINDOW,    l_start);
}

Text hud_frame_stats(Attributes &p_hud)
// ----------------------------------------------------------------
// Frame time statistics of the last full second ("" at first)
// ----------------------------------------------------------------
{
  return record_text(p_hud, ATTR_HUD_STATS);
}

void hud_toast(Attributes &p_hud, Text p_text, Real p_now)
// ----------------------------------------------------------------
// Show a short message above the hotbar; newest on top
// ----------------------------------------------------------------
{
  Integer l_toast = 0;

  for (l_toast = MAX_TOASTS; l_toast >= 2; --l_toast) {
    record_set_text_at(p_hud, ATTR_TEXT,      l_toast, record_text_at(p_hud, ATTR_TEXT,      l_toast - 1));
    record_set_real_at(p_hud, ATTR_HUD_UNTIL, l_toast, record_real_at(p_hud, ATTR_HUD_UNTIL, l_toast - 1));
  }
  record_set_text_at(p_hud, ATTR_TEXT,      1, p_text);
  record_set_real_at(p_hud, ATTR_HUD_UNTIL, 1, p_now + TOAST_SECONDS);
}

void hud_show_name(Attributes &p_hud, Real p_now)
// ----------------------------------------------------------------
// Show the selected item's name for a moment (after changing slot)
// ----------------------------------------------------------------
{
  record_set_real(p_hud, ATTR_HUD_NAME_UNTIL, p_now + 1.6);
}

Integer hud_help_shown(Attributes &p_hud)
// ----------------------------------------------------------------
// TRUE while the help panel is showing
// ----------------------------------------------------------------
{
  return record_integer(p_hud, ATTR_HUD_HELP);
}

void hud_set_help(Attributes &p_hud, Integer p_shown)
// ----------------------------------------------------------------
// Show or hide the help panel
// ----------------------------------------------------------------
{
  record_set_integer(p_hud, ATTR_HUD_HELP, p_shown);
}

void hud_on_event(Attributes &p_event, Attributes &p_hud, Real p_now)
// ----------------------------------------------------------------
// Event handler: turn things that happened into messages
// ----------------------------------------------------------------
{
  Integer l_type  = event_type(p_event);
  Integer l_item  = event_integer(p_event, 1);
  Integer l_count = event_integer(p_event, 2);

  if (l_type == EVT_ITEM_PICKED_UP) {
    hud_toast(p_hud, "+" + To_text(l_count) + " " + item_name(l_item), p_now);
  } else if (l_type == EVT_ITEM_CRAFTED) {
    hud_toast(p_hud, "Crafted " + To_text(l_count) + " " + item_name(l_item), p_now);
  } else if (l_type == EVT_PLAYER_ATE) {
    hud_toast(p_hud, "Ate " + item_name(l_item) + "  (+" + To_text(l_count) + " health)", p_now);
  } else if (l_type == EVT_TOAST) {
    hud_toast(p_hud, event_text(p_event), p_now);
  } else if (l_type == EVT_WORLD_SAVED) {
    hud_toast(p_hud, "Saved world " + event_text(p_event), p_now);
  }
}

// ---------------------------------------------------------------- drawing helpers

void hud_text(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_align, Integer p_red, Integer p_green, Integer p_blue, Text p_text)
// ----------------------------------------------------------------
// Draw text with its top left (or top centre) at (x, y)
// ----------------------------------------------------------------
{
  Set_bk_mode    (p_box, 1);
  Set_text_align (p_box, p_align);
  Set_text_colour(p_box, p_red, p_green, p_blue);
  Draw_text      (p_box, p_x, p_y, p_size, 0.0, p_text);
}

void hud_shadow_text(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_align, Integer p_red, Integer p_green, Integer p_blue, Text p_text)
// ----------------------------------------------------------------
// Text with a dark drop shadow so it reads over the world
// ----------------------------------------------------------------
{
  hud_text(p_box, p_x + 1.0, p_y - 1.0, p_size, p_align, 24, 24, 24, p_text);
  hud_text(p_box, p_x, p_y, p_size, p_align, p_red, p_green, p_blue, p_text);
}

void hud_frame(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)
// ----------------------------------------------------------------
// Outline of a rectangle in the current pen colour
// ----------------------------------------------------------------
{
  render_line(p_box, p_x0, p_y0, p_x1, p_y0);
  render_line(p_box, p_x1, p_y0, p_x1, p_y1);
  render_line(p_box, p_x1, p_y1, p_x0, p_y1);
  render_line(p_box, p_x0, p_y1, p_x0, p_y0);
}

void hud_texture_face(Draw_Box p_box, Integer p_tex, Real p_shade, Integer p_quick,
                      Real p_origin_x, Real p_origin_y, Real p_u_x, Real p_u_y, Real p_v_x, Real p_v_y)
// ----------------------------------------------------------------
// Draw a texture on the parallelogram origin + u * (u_x, u_y) +
// v * (v_x, v_y), with u running left to right and v up the
// texture. quick draws a block face as its 2 x 2 quadrant colours;
// otherwise the base colour and every rectangle are drawn, giving
// all 16 x 16 pixels. Sprites always draw their rectangles.
// ----------------------------------------------------------------
{
  Integer l_quadrant = 0;
  Integer l_slot     = 0;
  Integer l_rect     = 0;
  Integer l_last     = 0;
  Integer l_colour   = 0;
  Integer l_current  = -1;
  Real    l_u0       = 0.0;
  Real    l_v0       = 0.0;
  Real    l_u1       = 0.0;
  Real    l_v1       = 0.0;

  if (p_quick && !g_tex_is_sprite[p_tex]) {
    for (l_quadrant = 1; l_quadrant <= 4; ++l_quadrant) {
      // quadrant 1 top left, 2 top right, 3 bottom left, 4 bottom right
      l_u0 = 0.0;
      l_v0 = 0.5;
      if (l_quadrant == 2 || l_quadrant == 4) l_u0 = 0.5;
      if (l_quadrant >= 3) l_v0 = 0.0;
      l_slot = (p_tex - 1) * 4 + l_quadrant;
      render_set_colour(p_box, g_tex_quad_r[l_slot] * p_shade, g_tex_quad_g[l_slot] * p_shade, g_tex_quad_b[l_slot] * p_shade);

      g_icon_x[1] = p_origin_x + l_u0 * p_u_x + l_v0 * p_v_x;
      g_icon_y[1] = p_origin_y + l_u0 * p_u_y + l_v0 * p_v_y;
      g_icon_x[2] = p_origin_x + (l_u0 + 0.5) * p_u_x + l_v0 * p_v_x;
      g_icon_y[2] = p_origin_y + (l_u0 + 0.5) * p_u_y + l_v0 * p_v_y;
      g_icon_x[3] = p_origin_x + (l_u0 + 0.5) * p_u_x + (l_v0 + 0.5) * p_v_x;
      g_icon_y[3] = p_origin_y + (l_u0 + 0.5) * p_u_y + (l_v0 + 0.5) * p_v_y;
      g_icon_x[4] = p_origin_x + l_u0 * p_u_x + (l_v0 + 0.5) * p_v_x;
      g_icon_y[4] = p_origin_y + l_u0 * p_u_y + (l_v0 + 0.5) * p_v_y;
      Draw_polygon(p_box, 4, g_icon_x, g_icon_y);
    }
    return;
  }

  if (g_tex_base[p_tex] > 0) {
    l_slot = texture_palette_index(p_tex, g_tex_base[p_tex]);
    render_set_colour(p_box, g_tex_pal_r[l_slot] * p_shade, g_tex_pal_g[l_slot] * p_shade, g_tex_pal_b[l_slot] * p_shade);
    g_icon_x[1] = p_origin_x;                    g_icon_y[1] = p_origin_y;
    g_icon_x[2] = p_origin_x + p_u_x;              g_icon_y[2] = p_origin_y + p_u_y;
    g_icon_x[3] = p_origin_x + p_u_x + p_v_x;        g_icon_y[3] = p_origin_y + p_u_y + p_v_y;
    g_icon_x[4] = p_origin_x + p_v_x;              g_icon_y[4] = p_origin_y + p_v_y;
    Draw_polygon(p_box, 4, g_icon_x, g_icon_y);
  }

  l_last = g_tex_rect_first[p_tex] + g_tex_rect_count[p_tex] - 1;
  for (l_rect = g_tex_rect_first[p_tex]; l_rect <= l_last; ++l_rect) {
    l_colour = g_rect_pal[l_rect];
    if (l_colour != l_current) {
      l_slot = texture_palette_index(p_tex, l_colour);
      render_set_colour(p_box, g_tex_pal_r[l_slot] * p_shade, g_tex_pal_g[l_slot] * p_shade, g_tex_pal_b[l_slot] * p_shade);
      l_current = l_colour;
    }
    l_u0 = g_rect_u0[l_rect];
    l_u1 = g_rect_u1[l_rect];
    l_v0 = g_rect_v0[l_rect];
    l_v1 = g_rect_v1[l_rect];
    g_icon_x[1] = p_origin_x + l_u0 * p_u_x + l_v0 * p_v_x;  g_icon_y[1] = p_origin_y + l_u0 * p_u_y + l_v0 * p_v_y;
    g_icon_x[2] = p_origin_x + l_u1 * p_u_x + l_v0 * p_v_x;  g_icon_y[2] = p_origin_y + l_u1 * p_u_y + l_v0 * p_v_y;
    g_icon_x[3] = p_origin_x + l_u1 * p_u_x + l_v1 * p_v_x;  g_icon_y[3] = p_origin_y + l_u1 * p_u_y + l_v1 * p_v_y;
    g_icon_x[4] = p_origin_x + l_u0 * p_u_x + l_v1 * p_v_x;  g_icon_y[4] = p_origin_y + l_u0 * p_u_y + l_v1 * p_v_y;
    Draw_polygon(p_box, 4, g_icon_x, g_icon_y);
  }
}

void hud_draw_item_icon(Draw_Box p_box, Integer p_item, Real p_centre_x, Real p_centre_y, Real p_size, Integer p_detail)
// ----------------------------------------------------------------
// Picture of an item about size pixels across, centred on a point
// Blocks are little isometric cubes (ICON_FULL draws every texture
// pixel, ICON_QUICK just 2 x 2 colours per face); every other item
// is its own 16 x 16 pixel-art sprite
// ----------------------------------------------------------------
{
  Real    l_a       = p_size * 0.5;
  Real    l_w       = l_a * 0.87;
  Integer l_top_tex = 0;
  Integer l_side    = 0;
  Integer l_quick   = p_detail == ICON_QUICK;
  Integer l_sprite  = 0;

  if (p_item == ITEM_NONE) return;

  if (item_is_block(p_item)) {
    l_top_tex = item_top_texture(p_item);
    l_side    = item_side_texture(p_item);
    // top: L, T, R, C   left: LB, B, C, L   right: B, RB, R, C
    hud_texture_face(p_box, l_top_tex, 1.0 , l_quick, p_centre_x - l_w, p_centre_y + l_a * 0.5,  l_w, -l_a * 0.5,  l_w,  l_a * 0.5);
    hud_texture_face(p_box, l_side   , 0.80, l_quick, p_centre_x - l_w, p_centre_y - l_a * 0.5,  l_w, -l_a * 0.5,  0.0, l_a);
    hud_texture_face(p_box, l_side   , 0.62, l_quick, p_centre_x    , p_centre_y - l_a      ,  l_w,  l_a * 0.5,  0.0, l_a);
    return;
  }

  l_sprite = item_sprite_texture(p_item);
  if (l_sprite > 0) hud_texture_face(p_box, l_sprite, 1.0, FALSE, p_centre_x - l_a, p_centre_y - l_a, p_size, 0.0, 0.0, p_size);
}

void hud_draw_slot(Draw_Box p_box, Real p_x0, Real p_y0, Real p_size, Integer p_item, Integer p_count, Integer p_damage, Integer p_highlight)
// ----------------------------------------------------------------
// A dark slot (the hotbar), see hud_draw_slot_style
// ----------------------------------------------------------------
{
  hud_draw_slot_style(p_box, p_x0, p_y0, p_size, p_item, p_count, p_damage, p_highlight, SLOT_STYLE_DARK);
}

void hud_draw_slot_style(Draw_Box p_box, Real p_x0, Real p_y0, Real p_size, Integer p_item, Integer p_count, Integer p_damage, Integer p_highlight,
                         Integer p_style)
// ----------------------------------------------------------------
// A square inventory slot with its bottom left at (x0, y0), the
// item's icon, the stack size and, for a worn tool, a wear bar.
// SLOT_STYLE_LIGHT slots are sunk into the light inventory panel:
// dark top and left edges, light bottom and right edges.
// ----------------------------------------------------------------
{
  Text    l_count_text = "";
  Real    l_text_size  = clamp_real(p_size * 0.32, 9.0, 14.0);
  Integer l_uses       = item_max_uses(p_item);
  Real    l_left       = 0.0;

  if (p_style == SLOT_STYLE_LIGHT) {
    render_set_colour(p_box, 250.0, 250.0, 250.0);
    render_fill_rect (p_box, p_x0, p_y0, p_x0 + p_size, p_y0 + p_size);
    render_set_colour(p_box, 86.0, 86.0, 86.0);
    render_fill_rect (p_box, p_x0, p_y0 + 2.0, p_x0 + p_size - 2.0, p_y0 + p_size);
    render_set_colour(p_box, 150.0, 150.0, 152.0);
    render_fill_rect (p_box, p_x0 + 2.0, p_y0 + 2.0, p_x0 + p_size - 2.0, p_y0 + p_size - 2.0);
  } else {
    render_set_colour(p_box, 26.0, 27.0, 32.0);
    render_fill_rect (p_box, p_x0, p_y0, p_x0 + p_size, p_y0 + p_size);
    render_set_colour(p_box, 70.0, 74.0, 84.0);
    render_fill_rect (p_box, p_x0 + 2.0, p_y0 + 2.0, p_x0 + p_size - 2.0, p_y0 + p_size - 2.0);
  }
  if (p_highlight) {
    render_set_colour(p_box, 250.0, 246.0, 220.0);
    hud_frame(p_box, p_x0, p_y0, p_x0 + p_size, p_y0 + p_size);
    hud_frame(p_box, p_x0 + 1.0, p_y0 + 1.0, p_x0 + p_size - 1.0, p_y0 + p_size - 1.0);
  }

  if (p_item == ITEM_NONE) return;

  hud_draw_item_icon(p_box, p_item, p_x0 + p_size / 2.0, p_y0 + p_size / 2.0 + 1.0, p_size * 0.62, ICON_QUICK);

  if (p_count > 1) {
    l_count_text = To_text(p_count);
    hud_shadow_text(p_box, p_x0 + p_size - 3.0 - Text_length(l_count_text) * l_text_size * 0.58, p_y0 + l_text_size + 2.0,
                    l_text_size, TEXT_ALIGN_LEFT, 255, 255, 255, l_count_text);
  }

  if (l_uses > 0 && p_damage > 0) {
    l_left = clamp_real(1.0 - p_damage * 1.0 / l_uses, 0.0, 1.0);
    render_set_colour(p_box, 20.0, 20.0, 20.0);
    render_fill_rect (p_box, p_x0 + 4.0, p_y0 + 3.0, p_x0 + p_size - 4.0, p_y0 + 6.0);
    render_set_colour(p_box, 255.0 * (1.0 - l_left), 220.0 * l_left, 40.0);
    render_fill_rect (p_box, p_x0 + 4.0, p_y0 + 3.0, p_x0 + 4.0 + (p_size - 8.0) * l_left, p_y0 + 6.0);
  }
}

// ---------------------------------------------------------------- the HUD

void hud_banner(Draw_Box p_box, Real p_centre_x, Real p_centre_y, Real p_half_w, Real p_half_h, Text p_title, Text p_line,
                Integer p_red, Integer p_green, Integer p_blue)
// ----------------------------------------------------------------
// Dark box with a coloured title and a line of white text
// ----------------------------------------------------------------
{
  render_set_colour(p_box, 22.0, 22.0, 28.0);
  render_fill_rect (p_box, p_centre_x - p_half_w, p_centre_y - p_half_h, p_centre_x + p_half_w, p_centre_y + p_half_h);
  render_set_colour(p_box, p_red, p_green, p_blue);
  hud_frame(p_box, p_centre_x - p_half_w, p_centre_y - p_half_h, p_centre_x + p_half_w, p_centre_y + p_half_h);

  hud_text(p_box, p_centre_x, p_centre_y + p_half_h - 10.0, 26.0, TEXT_ALIGN_CENTRE, p_red, p_green, p_blue, p_title);
  hud_text(p_box, p_centre_x, p_centre_y - p_half_h + 30.0, 13.0, TEXT_ALIGN_CENTRE, 225, 225, 225, p_line);
}

void hud_help_line(Draw_Box p_box, Real p_x, Real &p_y, Text p_key, Text p_what)
// ----------------------------------------------------------------
// One line of the help: key in yellow, description in white
// ----------------------------------------------------------------
{
  hud_text(p_box, p_x        , p_y, 12.0, TEXT_ALIGN_LEFT, 250, 215, 90 , p_key);
  hud_text(p_box, p_x + 140.0, p_y, 12.0, TEXT_ALIGN_LEFT, 228, 228, 228, p_what);
  p_y = p_y - 15.0;
}

void hud_help_heading(Draw_Box p_box, Real p_x, Real &p_y, Text p_text)
// ----------------------------------------------------------------
// A heading in the help
// ----------------------------------------------------------------
{
  p_y = p_y - 4.0;
  hud_text(p_box, p_x, p_y, 13.0, TEXT_ALIGN_LEFT, 120, 210, 110, p_text);
  p_y = p_y - 17.0;
}

void hud_draw_help(Draw_Box p_box, Real p_w, Real p_h)
// ----------------------------------------------------------------
// The controls, shown at the start and with H
// ----------------------------------------------------------------
{
  Real l_panel_w = min_real(620.0, p_w - 30.0);
  Real l_panel_h = min_real(386.0, p_h - STATUS_STRIP_HEIGHT - 16.0);
  Real l_centre  = p_w / 2.0;
  Real l_middle  = STATUS_STRIP_HEIGHT + (p_h - STATUS_STRIP_HEIGHT) / 2.0;
  Real l_left    = l_centre - l_panel_w / 2.0;
  Real l_top     = l_middle + l_panel_h / 2.0;
  Real l_x       = l_left + 22.0;
  Real l_y       = l_top - 50.0;
  Text l_title   = GAME_TITLE;

  render_set_colour(p_box, 20.0, 22.0, 26.0);
  render_fill_rect (p_box, l_left, l_middle - l_panel_h / 2.0, l_left + l_panel_w, l_top);
  render_set_colour(p_box, 92.0, 168.0, 80.0);
  hud_frame(p_box, l_left, l_middle - l_panel_h / 2.0, l_left + l_panel_w, l_top);

  hud_text(p_box, l_centre, l_top - 12.0, 22.0, TEXT_ALIGN_CENTRE, 132, 220, 116, l_title + " - how to play");

  hud_help_heading(p_box, l_x, l_y, "MOUSE");
  hud_help_line(p_box, l_x, l_y, "Click the view" , "start playing (the mouse turns the camera)");
  hud_help_line(p_box, l_x, l_y, "Left click"     , "break blocks (harder blocks take more hits), hit animals");
  hud_help_line(p_box, l_x, l_y, "Right click"    , "place blocks, eat, use crafting tables and furnaces");
  hud_help_heading(p_box, l_x, l_y, "KEYBOARD");
  hud_help_line(p_box, l_x, l_y, "W A S D"        , "walk (hold one key at a time)");
  hud_help_line(p_box, l_x, l_y, "Space"          , "jump, swim up, fly up");
  hud_help_line(p_box, l_x, l_y, "1 - 9"          , "choose a hotbar slot");
  hud_help_line(p_box, l_x, l_y, "E"              , "inventory and 2 x 2 crafting");
  hud_help_line(p_box, l_x, l_y, "Q"              , "pause and free the mouse, or close a screen");
  hud_help_line(p_box, l_x, l_y, "F / J"          , "auto-walk on/off, auto-jump on/off");
  hud_help_line(p_box, l_x, l_y, "G / C"          , "fly on/off, fly down");
  hud_help_line(p_box, l_x, l_y, "P / U"          , "pick the block you look at, hide the HUD");
  hud_help_line(p_box, l_x, l_y, "- / ="          , "shorter / longer view distance");
  hud_help_line(p_box, l_x, l_y, "I / H / O"      , "position info, this help, settings");
  hud_help_heading(p_box, l_x, l_y, "GETTING STARTED");
  hud_text(p_box, l_x, l_y, 12.0, TEXT_ALIGN_LEFT, 228, 228, 228, "Your house has a crafting table and a furnace. Punch trees for logs, lay out planks");
  l_y = l_y - 15.0;
  hud_text(p_box, l_x, l_y, 12.0, TEXT_ALIGN_LEFT, 228, 228, 228, "and sticks in the grid for a pickaxe - stone only drops if you mine it with one.");
  l_y = l_y - 15.0;
  hud_text(p_box, l_x, l_y, 12.0, TEXT_ALIGN_LEFT, 228, 228, 228, "Zombies come out at night: make torches (coal over a stick) or sleep in a bed.");

  hud_text(p_box, l_centre, l_middle - l_panel_h / 2.0 + 22.0, 13.0, TEXT_ALIGN_CENTRE, 250, 215, 90, "Click the view to play");
}

Text hud_facing_name(Real p_yaw)
// ----------------------------------------------------------------
// Compass direction for a yaw (north is -z)
// ----------------------------------------------------------------
{
  Integer l_quarter = positive_mod(floor_integer(p_yaw / HALF_PI + 0.5), 4);

  if (l_quarter == 0) return "east";
  if (l_quarter == 1) return "south";
  if (l_quarter == 2) return "west";
  return "north";
}

void hud_draw_hand(Draw_Box p_box, Real p_w, Real p_view_bottom, Real p_h, Integer p_item, Real p_bob, Real p_swing_time)
// ----------------------------------------------------------------
// The player's arm in the lower right, holding item; it bobs while
// walking (bob is the walking phase) and swings when used
// ----------------------------------------------------------------
{
  Real l_swing  = 0.0;
  Real l_bob_x  = Sin(p_bob) * 6.0;
  Real l_bob_y  = Absolute(Cos(p_bob)) * 5.0;
  Real l_scale  = (p_h - p_view_bottom) / 480.0;
  Real l_base_x = 0.0;
  Real l_base_y = 0.0;

  if (p_swing_time > 0.0) l_swing = Sin(p_swing_time / 0.25 * PI);

  l_base_x = p_w * 0.80 + l_bob_x - l_swing * 60.0 * l_scale;
  l_base_y = p_view_bottom + l_bob_y + l_swing * 40.0 * l_scale;

  // Sleeve and hand
  render_set_colour(p_box, 64.0, 96.0, 168.0);
  g_icon_x[1] = l_base_x + 30.0 * l_scale;   g_icon_y[1] = l_base_y - 10.0 * l_scale;
  g_icon_x[2] = l_base_x + 120.0 * l_scale;  g_icon_y[2] = l_base_y - 10.0 * l_scale;
  g_icon_x[3] = l_base_x + 64.0 * l_scale;   g_icon_y[3] = l_base_y + 96.0 * l_scale;
  g_icon_x[4] = l_base_x - 4.0 * l_scale;    g_icon_y[4] = l_base_y + 84.0 * l_scale;
  Draw_polygon(p_box, 4, g_icon_x, g_icon_y);
  render_set_colour(p_box, 214.0, 164.0, 124.0);
  g_icon_x[1] = l_base_x - 4.0 * l_scale;    g_icon_y[1] = l_base_y + 84.0 * l_scale;
  g_icon_x[2] = l_base_x + 64.0 * l_scale;   g_icon_y[2] = l_base_y + 96.0 * l_scale;
  g_icon_x[3] = l_base_x + 46.0 * l_scale;   g_icon_y[3] = l_base_y + 134.0 * l_scale;
  g_icon_x[4] = l_base_x - 18.0 * l_scale;   g_icon_y[4] = l_base_y + 120.0 * l_scale;
  Draw_polygon(p_box, 4, g_icon_x, g_icon_y);

  if (p_item != ITEM_NONE) {
    hud_draw_item_icon(p_box, p_item, l_base_x + 4.0 * l_scale, l_base_y + 148.0 * l_scale, 82.0 * l_scale, ICON_FULL);
  }
}

void hud_draw_health(Draw_Box p_box, Real p_x0, Real p_y0, Real p_width, Integer p_health, Real p_now)
// ----------------------------------------------------------------
// Health bar of ten hearts (from the resource pack if it has them),
// each worth two points: an empty heart with a full or half heart
// over it. The hearts flash when health is low.
// ----------------------------------------------------------------
{
  Integer l_heart = 0;
  Integer l_left  = 0;
  Real    l_size  = p_width / 10.0;
  Real    l_hx    = 0.0;
  Real    l_pulse = 1.0;

  if (p_health <= 6 && Floor(p_now * 4.0) - 2.0 * Floor(p_now * 2.0) > 0.5) l_pulse = 0.6;

  for (l_heart = 1; l_heart <= 10; ++l_heart) {
    l_hx   = p_x0 + (l_heart - 1) * l_size;
    l_left = p_health - (l_heart - 1) * 2;
    hud_texture_face(p_box, TEX_HEART_CONTAINER, 1.0, FALSE, l_hx, p_y0, l_size, 0.0, 0.0, l_size);
    if (l_left >= 2) {
      hud_texture_face(p_box, TEX_HEART_FULL, l_pulse, FALSE, l_hx, p_y0, l_size, 0.0, 0.0, l_size);
    } else if (l_left == 1) {
      hud_texture_face(p_box, TEX_HEART_HALF, l_pulse, FALSE, l_hx, p_y0, l_size, 0.0, 0.0, l_size);
    }
  }
}

void hud_draw(Draw_Box p_box, Real p_w, Real p_h, Integer p_captured, Integer p_screen_open,
              Attributes &p_hud, Attributes &p_player, Attributes &p_inventory, Attributes &p_settings,
              Integer p_seed, Real p_time_of_day, Real p_frame_ms, Text p_render_stats, Real p_now)
// ----------------------------------------------------------------
// Draw the HUD over the 3D view (or just the status strip behind an
// inventory screen)
// ----------------------------------------------------------------
{
  Real    l_strip     = STATUS_STRIP_HEIGHT;
  Real    l_slot_size = clamp_real((p_w - 40.0) / 9.0, 26.0, 44.0);
  Real    l_bar_x     = p_w / 2.0 - l_slot_size * 4.5;
  Real    l_bar_y     = l_strip + 6.0;
  Real    l_centre_y  = l_strip + (p_h - l_strip) / 2.0;
  Real    l_edge      = 0.0;
  Real    l_y         = 0.0;
  Real    l_px        = 0.0;
  Real    l_py        = 0.0;
  Real    l_pz        = 0.0;
  Real    l_yaw       = 0.0;
  Real    l_pitch     = 0.0;
  Real    l_hurt      = player_hurt_time(p_player);
  Integer l_dead      = player_is_dead(p_player);
  Integer l_held      = player_held_item(p_player, p_inventory);
  Integer l_slot      = 0;
  Integer l_toast     = 0;
  Text    l_info      = "";
  Text    l_message   = "";

  // Status strip along the bottom (the mouse is parked here)
  render_set_colour(p_box, 22.0, 24.0, 28.0);
  render_fill_rect (p_box, 0.0, 0.0, p_w, l_strip);
  l_info = GAME_TITLE;
  l_info = l_info + "   " + world_clock_text(p_time_of_day);
  if (world_is_night(p_time_of_day)) l_info = l_info + " (night)";
  l_info = l_info + "   seed " + To_text(p_seed) + "   view " + To_text(settings_render_distance(p_settings))
       + "   " + To_text(p_frame_ms, 1) + " ms";
  if (settings_flag(p_settings, ATTR_SET_SHOW_DEBUG) && hud_frame_stats(p_hud) != "") l_info = l_info + "   " + hud_frame_stats(p_hud);
  if (player_flying(p_player)) l_info = l_info + "   FLYING";
  if (player_crouching(p_player)) l_info = l_info + "   CROUCHING";
  if (player_auto_walk(p_player)) l_info = l_info + "   AUTO-WALK";
  if (!settings_flag(p_settings, ATTR_SET_AUTO_JUMP)) l_info = l_info + "   auto-jump off";
  hud_text(p_box, 8.0, l_strip - 5.0, 11.0, TEXT_ALIGN_LEFT, 170, 176, 186, l_info);

  if (p_screen_open) return;

  if (settings_flag(p_settings, ATTR_SET_SHOW_HUD)) {
    // Hand, crosshair, hotbar and health
    if (!l_dead) hud_draw_hand(p_box, p_w, l_strip, p_h, l_held, player_bob(p_player), player_swing_time(p_player));

    render_set_colour(p_box, 240.0, 240.0, 240.0);
    render_line(p_box, p_w / 2.0 - 9.0, l_centre_y, p_w / 2.0 - 3.0, l_centre_y);
    render_line(p_box, p_w / 2.0 + 3.0, l_centre_y, p_w / 2.0 + 9.0, l_centre_y);
    render_line(p_box, p_w / 2.0, l_centre_y - 9.0, p_w / 2.0, l_centre_y - 3.0);
    render_line(p_box, p_w / 2.0, l_centre_y + 3.0, p_w / 2.0, l_centre_y + 9.0);

    for (l_slot = 1; l_slot <= HOTBAR_SLOTS; ++l_slot) {
      hud_draw_slot(p_box, l_bar_x + (l_slot - 1) * l_slot_size, l_bar_y, l_slot_size,
                    slot_item(p_inventory, l_slot), slot_count(p_inventory, l_slot), slot_damage(p_inventory, l_slot),
                    l_slot == player_selected(p_player));
    }
    hud_draw_health(p_box, l_bar_x, l_bar_y + l_slot_size + 8.0, l_slot_size * 4.5 - 4.0, player_health(p_player), p_now);

    // Name of the item just selected
    if (p_now < record_real(p_hud, ATTR_HUD_NAME_UNTIL) && l_held != ITEM_NONE) {
      hud_shadow_text(p_box, p_w / 2.0, l_bar_y + l_slot_size + 40.0, 14.0, TEXT_ALIGN_CENTRE, 255, 255, 255, item_name(l_held));
    }
  }

  // Messages, newest at the bottom of the list
  l_y = l_bar_y + l_slot_size + 74.0;
  for (l_toast = MAX_TOASTS; l_toast >= 1; --l_toast) {
    l_message = record_text_at(p_hud, ATTR_TEXT, l_toast);
    if (l_message == "" || p_now > record_real_at(p_hud, ATTR_HUD_UNTIL, l_toast)) continue;
    hud_shadow_text(p_box, 12.0, l_y, 13.0, TEXT_ALIGN_LEFT, 250, 238, 190, l_message);
    l_y = l_y + 17.0;
  }

  // Position read-out
  if (settings_flag(p_settings, ATTR_SET_SHOW_DEBUG)) {
    player_position(p_player, l_px, l_py, l_pz);
    player_look    (p_player, l_yaw, l_pitch);
    l_info = "x " + To_text(l_px, 1) + "   y " + To_text(l_py, 1) + "   z " + To_text(l_pz, 1) + "   facing " + hud_facing_name(l_yaw);
    hud_shadow_text(p_box, 10.0, p_h - 8.0, 12.0, TEXT_ALIGN_LEFT, 255, 255, 255, l_info);
    hud_shadow_text(p_box, 10.0, p_h - 24.0, 12.0, TEXT_ALIGN_LEFT, 200, 200, 200, p_render_stats);
  }

  // Red edge when hurt
  if (l_hurt > 0.0 && !l_dead) {
    l_edge = 4.0 + l_hurt * 24.0;
    render_set_colour(p_box, 200.0, 16.0, 16.0);
    render_fill_rect(p_box, 0.0, l_strip, p_w, l_strip + l_edge);
    render_fill_rect(p_box, 0.0, p_h - l_edge, p_w, p_h);
    render_fill_rect(p_box, 0.0, l_strip, l_edge, p_h);
    render_fill_rect(p_box, p_w - l_edge, l_strip, p_w, p_h);
  }

  if (l_dead) {
    hud_banner(p_box, p_w / 2.0, l_centre_y, 210.0, 54.0, "You died", "Press R or click the view to respawn", 230, 60, 50);
  } else if (hud_help_shown(p_hud)) {
    hud_draw_help(p_box, p_w, p_h);
  } else if (!p_captured) {
    hud_banner(p_box, p_w / 2.0, l_centre_y, 210.0, 54.0, "Paused", "Click the view to play  -  H for help", 250, 215, 90);
  }
}

#endif
