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
// Remove every message
// ----------------------------------------------------------------
{
  Integer l_toast = 0;

  record_clear(p_hud, DATATYPE_HUD);
  for (l_toast = 1; l_toast <= MAX_TOASTS; ++l_toast) {
    record_set_text_at(p_hud, ATTR_TEXT,      l_toast, "");
    record_set_real_at(p_hud, ATTR_HUD_UNTIL, l_toast, 0.0);
  }
  record_set_real   (p_hud, ATTR_HUD_NAME_UNTIL, 0.0);
  record_set_integer(p_hud, ATTR_HUD_WAITING,    TRUE);
  record_set_integer(p_hud, ATTR_HUD_FRAMES,     0);
  record_set_real   (p_hud, ATTR_HUD_FRAME_SUM,  0.0);
  record_set_real   (p_hud, ATTR_HUD_FRAME_MIN,  0.0);
  record_set_real   (p_hud, ATTR_HUD_FRAME_MAX,  0.0);
  record_set_real   (p_hud, ATTR_HUD_WINDOW,     0.0);
  record_set_text   (p_hud, ATTR_HUD_STATS,      "");
  record_set_real   (p_hud, ATTR_HUD_MOUSE_X,    -1.0);
  record_set_real   (p_hud, ATTR_HUD_MOUSE_Y,    -1.0);
  for (l_toast = 1; l_toast <= MAX_CHAT_LINES; ++l_toast) {
    record_set_text_at(p_hud, ATTR_HUD_CHAT,       l_toast, "");
    record_set_real_at(p_hud, ATTR_HUD_CHAT_UNTIL, l_toast, 0.0);
  }
  hud_set_chat_input(p_hud, FALSE, "");
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

void hud_chat(Attributes &p_hud, Text p_text, Real p_now)
// ----------------------------------------------------------------
// Add a line to the chat (what you said, or a command's answer)
// ----------------------------------------------------------------
{
  Integer l_line = 0;

  for (l_line = MAX_CHAT_LINES; l_line >= 2; --l_line) {
    record_set_text_at(p_hud, ATTR_HUD_CHAT,       l_line, record_text_at(p_hud, ATTR_HUD_CHAT,       l_line - 1));
    record_set_real_at(p_hud, ATTR_HUD_CHAT_UNTIL, l_line, record_real_at(p_hud, ATTR_HUD_CHAT_UNTIL, l_line - 1));
  }
  record_set_text_at(p_hud, ATTR_HUD_CHAT,       1, p_text);
  record_set_real_at(p_hud, ATTR_HUD_CHAT_UNTIL, 1, p_now + CHAT_SECONDS);
}

void hud_set_chat_input(Attributes &p_hud, Integer p_open, Text p_text)
// ----------------------------------------------------------------
// Show (open TRUE) or hide the chat line being typed
// ----------------------------------------------------------------
{
  record_set_integer(p_hud, ATTR_HUD_CHAT_OPEN,  p_open);
  record_set_text   (p_hud, ATTR_HUD_CHAT_INPUT, p_text);
}

Integer hud_chat_open(Attributes &p_hud)
// ----------------------------------------------------------------
// TRUE while a chat line is being typed
// ----------------------------------------------------------------
{
  return record_integer(p_hud, ATTR_HUD_CHAT_OPEN) == TRUE;
}

void hud_show_name(Attributes &p_hud, Real p_now)
// ----------------------------------------------------------------
// Show the selected item's name for a moment (after changing slot)
// ----------------------------------------------------------------
{
  record_set_real(p_hud, ATTR_HUD_NAME_UNTIL, p_now + 1.6);
}

Integer hud_waiting(Attributes &p_hud)
// ----------------------------------------------------------------
// TRUE while a world just opened waits for a click to start play
// (instead of the game menu, "Click to play" shows)
// ----------------------------------------------------------------
{
  return record_integer(p_hud, ATTR_HUD_WAITING) == TRUE;
}

void hud_set_waiting(Attributes &p_hud, Integer p_waiting)
// ----------------------------------------------------------------
// Note whether play has started yet
// ----------------------------------------------------------------
{
  record_set_integer(p_hud, ATTR_HUD_WAITING, p_waiting);
}

void hud_set_mouse(Attributes &p_hud, Real p_x, Real p_y)
// ----------------------------------------------------------------
// Where the mouse is over the view (for the pause menu's buttons)
// ----------------------------------------------------------------
{
  record_set_real(p_hud, ATTR_HUD_MOUSE_X, p_x);
  record_set_real(p_hud, ATTR_HUD_MOUSE_Y, p_y);
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

void hud_pause_button_rect(Real p_w, Real p_h, Integer p_button, Real &p_x0, Real &p_y0, Real &p_x1, Real &p_y1)
// ----------------------------------------------------------------
// Where pause menu button p_button is in a w x h view: a full width
// button, two half width ones, two more, then a full width one,
// centred in the view below the status strip
// ----------------------------------------------------------------
{
  Real    l_width  = min_real(PAUSE_BUTTON_WIDTH, p_w - 40.0);
  Real    l_half   = (l_width - PAUSE_BUTTON_GAP) / 2.0;
  Real    l_row_h  = PAUSE_BUTTON_HEIGHT + PAUSE_BUTTON_GAP;
  Real    l_middle = STATUS_STRIP_HEIGHT + (p_h - STATUS_STRIP_HEIGHT) / 2.0;
  Real    l_top    = l_middle + 2.0 * l_row_h - PAUSE_BUTTON_GAP / 2.0;
  Real    l_left   = p_w / 2.0 - l_width / 2.0;
  Integer l_row    = 1;

  if (p_button == PAUSE_BUTTON_OPTIONS || p_button == PAUSE_BUTTON_CONTROLS) l_row = 2;
  if (p_button == PAUSE_BUTTON_SAVE    || p_button == PAUSE_BUTTON_MODE    ) l_row = 3;
  if (p_button == PAUSE_BUTTON_QUIT) l_row = 4;
  p_y1 = l_top - (l_row - 1) * l_row_h;
  p_y0 = p_y1 - PAUSE_BUTTON_HEIGHT;
  p_x0 = l_left;
  p_x1 = l_left + l_width;
  if (p_button == PAUSE_BUTTON_OPTIONS || p_button == PAUSE_BUTTON_SAVE) p_x1 = l_left + l_half;
  if (p_button == PAUSE_BUTTON_CONTROLS || p_button == PAUSE_BUTTON_MODE) p_x0 = l_left + l_width - l_half;
}

Integer hud_pause_button_at(Real p_w, Real p_h, Real p_x, Real p_y)
// ----------------------------------------------------------------
// The pause menu button at (x, y) in a w x h view, 0 if none
// ----------------------------------------------------------------
{
  Integer l_button = 0;
  Real    l_x0     = 0.0;
  Real    l_y0     = 0.0;
  Real    l_x1     = 0.0;
  Real    l_y1     = 0.0;

  for (l_button = 1; l_button <= PAUSE_BUTTONS; ++l_button) {
    hud_pause_button_rect(p_w, p_h, l_button, l_x0, l_y0, l_x1, l_y1);
    if (p_x >= l_x0 && p_x <= l_x1 && p_y >= l_y0 && p_y <= l_y1) return l_button;
  }
  return 0;
}

void hud_draw_button(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_hover)
// ----------------------------------------------------------------
// A stone grey button with a black edge, a light top and left and a
// dark bottom and right, and white text with a shadow; the button
// under the mouse gets a white edge and a lighter face
// ----------------------------------------------------------------
{
  Real l_middle = (p_y0 + p_y1) / 2.0;
  Real l_centre = (p_x0 + p_x1) / 2.0;

  if (p_hover) {
    render_set_colour(p_box, 255.0, 255.0, 255.0);
  } else {
    render_set_colour(p_box, 0.0, 0.0, 0.0);
  }
  render_fill_rect(p_box, p_x0, p_y0, p_x1, p_y1);
  // dark bottom and right, light top and left, then the face
  render_set_colour(p_box, 76.0, 76.0, 76.0);
  render_fill_rect(p_box, p_x0 + 2.0, p_y0 + 2.0, p_x1 - 2.0, p_y1 - 2.0);
  render_set_colour(p_box, 168.0, 168.0, 168.0);
  render_fill_rect(p_box, p_x0 + 2.0, p_y0 + 5.0, p_x1 - 4.0, p_y1 - 2.0);
  if (p_hover) {
    render_set_colour(p_box, 132.0, 132.0, 140.0);
  } else {
    render_set_colour(p_box, 111.0, 111.0, 111.0);
  }
  render_fill_rect(p_box, p_x0 + 4.0, p_y0 + 5.0, p_x1 - 4.0, p_y1 - 4.0);

  hud_text(p_box, l_centre + 2.0, l_middle + 6.0, 16.0, TEXT_ALIGN_CENTRE, 56, 56, 56, p_text);
  if (p_hover) {
    hud_text(p_box, l_centre, l_middle + 8.0, 16.0, TEXT_ALIGN_CENTRE, 255, 255, 160, p_text);
  } else {
    hud_text(p_box, l_centre, l_middle + 8.0, 16.0, TEXT_ALIGN_CENTRE, 230, 230, 230, p_text);
  }
}

void hud_draw_pause_menu(Draw_Box p_box, Real p_w, Real p_h, Real p_mouse_x, Real p_mouse_y, Text p_mode_name)
// ----------------------------------------------------------------
// The pause menu: "Game Menu" and its buttons (the world is already
// drawn behind it, darkened)
// ----------------------------------------------------------------
{
  Integer l_button = 0;
  Integer l_hover  = hud_pause_button_at(p_w, p_h, p_mouse_x, p_mouse_y);
  Real    l_x0     = 0.0;
  Real    l_y0     = 0.0;
  Real    l_x1     = 0.0;
  Real    l_y1     = 0.0;
  Text    l_label  = "";

  hud_pause_button_rect(p_w, p_h, PAUSE_BUTTON_BACK, l_x0, l_y0, l_x1, l_y1);
  hud_shadow_text(p_box, p_w / 2.0, l_y1 + 44.0, 18.0, TEXT_ALIGN_CENTRE, 255, 255, 255, "Game Menu");

  for (l_button = 1; l_button <= PAUSE_BUTTONS; ++l_button) {
    hud_pause_button_rect(p_w, p_h, l_button, l_x0, l_y0, l_x1, l_y1);
    if (l_button == PAUSE_BUTTON_BACK    ) l_label = "Back to Game";
    if (l_button == PAUSE_BUTTON_OPTIONS ) l_label = "Options...";
    if (l_button == PAUSE_BUTTON_CONTROLS) l_label = "Controls...";
    if (l_button == PAUSE_BUTTON_SAVE    ) l_label = "Save Game";
    if (l_button == PAUSE_BUTTON_MODE    ) l_label = "Mode: " + p_mode_name;
    if (l_button == PAUSE_BUTTON_QUIT    ) l_label = "Save and Quit to Title";
    hud_draw_button(p_box, l_x0, l_y0, l_x1, l_y1, l_label, l_button == l_hover);
  }
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

void hud_draw_figure(Draw_Box p_box, Real p_centre_x, Real p_base_y, Real p_unit,
                     Integer p_helmet, Integer p_chestplate, Integer p_leggings, Integer p_boots)
// ----------------------------------------------------------------
// The player from the front in their skin, standing on base_y and
// 32 units tall (1 unit is a skin pixel), with the armour worn
// (ITEM_NONE where nothing is worn) drawn over it half a unit
// bigger all round
// ----------------------------------------------------------------
{
  Real l_x = p_centre_x;
  Real l_y = p_base_y;
  Real l_u = p_unit;
  Real l_a = p_unit * 0.5;

  hud_texture_face(p_box, TEX_PERSON_LEG_FRONT, 1.0, FALSE, l_x - 4.0 * l_u, l_y, 4.0 * l_u, 0.0, 0.0, 12.0 * l_u);
  hud_texture_face(p_box, TEX_PERSON_LEG_FRONT, 1.0, FALSE, l_x, l_y, 4.0 * l_u, 0.0, 0.0, 12.0 * l_u);
  hud_texture_face(p_box, TEX_PERSON_SHIRT, 1.0, FALSE, l_x - 4.0 * l_u, l_y + 12.0 * l_u, 8.0 * l_u, 0.0, 0.0, 12.0 * l_u);
  hud_texture_face(p_box, TEX_PERSON_ARM_FRONT, 1.0, FALSE, l_x - 8.0 * l_u, l_y + 12.0 * l_u, 4.0 * l_u, 0.0, 0.0, 12.0 * l_u);
  hud_texture_face(p_box, TEX_PERSON_ARM_FRONT, 1.0, FALSE, l_x + 4.0 * l_u, l_y + 12.0 * l_u, 4.0 * l_u, 0.0, 0.0, 12.0 * l_u);
  hud_texture_face(p_box, TEX_PERSON_FACE, 1.0, FALSE, l_x - 4.0 * l_u, l_y + 24.0 * l_u, 8.0 * l_u, 0.0, 0.0, 8.0 * l_u);

  // leggings from the waist down, boots over the feet
  if (p_leggings != ITEM_NONE) {
    hud_texture_face(p_box, TEX_ARMOUR_IRON, 0.92, FALSE, l_x - 4.0 * l_u - l_a, l_y + 3.0 * l_u, 4.0 * l_u + l_a, 0.0, 0.0, 11.0 * l_u);
    hud_texture_face(p_box, TEX_ARMOUR_IRON, 0.92, FALSE, l_x, l_y + 3.0 * l_u, 4.0 * l_u + l_a, 0.0, 0.0, 11.0 * l_u);
  }
  if (p_boots != ITEM_NONE) {
    hud_texture_face(p_box, TEX_ARMOUR_IRON, 0.85, FALSE, l_x - 4.0 * l_u - l_a, l_y - l_a, 4.0 * l_u, 0.0, 0.0, 4.0 * l_u + l_a);
    hud_texture_face(p_box, TEX_ARMOUR_IRON, 0.85, FALSE, l_x + l_a, l_y - l_a, 4.0 * l_u, 0.0, 0.0, 4.0 * l_u + l_a);
  }
  // the chestplate covers the body and the tops of the arms
  if (p_chestplate != ITEM_NONE) {
    hud_texture_face(p_box, TEX_ARMOUR_IRON, 1.0, FALSE, l_x - 4.0 * l_u - l_a, l_y + 12.0 * l_u, 8.0 * l_u + 2.0 * l_a, 0.0, 0.0, 12.0 * l_u + l_a);
    hud_texture_face(p_box, TEX_ARMOUR_IRON, 0.9, FALSE, l_x - 8.0 * l_u - l_a, l_y + 19.0 * l_u, 4.0 * l_u, 0.0, 0.0, 5.0 * l_u + l_a);
    hud_texture_face(p_box, TEX_ARMOUR_IRON, 0.9, FALSE, l_x + 4.0 * l_u + l_a, l_y + 19.0 * l_u, 4.0 * l_u, 0.0, 0.0, 5.0 * l_u + l_a);
  }
  if (p_helmet != ITEM_NONE) {
    hud_texture_face(p_box, TEX_ARMOUR_HELMET_FRONT, 1.0, FALSE, l_x - 4.0 * l_u - l_a, l_y + 24.0 * l_u, 8.0 * l_u + 2.0 * l_a, 0.0, 0.0, 8.0 * l_u + l_a);
  }
}

void hud_draw_armour(Draw_Box p_box, Real p_x0, Real p_y0, Real p_width, Integer p_points)
// ----------------------------------------------------------------
// Armour bar of ten icons (from the resource pack if it has them),
// each worth two points, like the health bar: an empty icon with a
// full or half one over it
// ----------------------------------------------------------------
{
  Integer l_icon = 0;
  Integer l_left = 0;
  Real    l_size = p_width / 10.0;
  Real    l_ix   = 0.0;

  for (l_icon = 1; l_icon <= 10; ++l_icon) {
    l_ix   = p_x0 + (l_icon - 1) * l_size;
    l_left = p_points - (l_icon - 1) * 2;
    // the empty icon, with the full or half one over it
    hud_texture_face(p_box, TEX_ARMOUR_EMPTY, 1.0, FALSE, l_ix, p_y0, l_size, 0.0, 0.0, l_size);
    if (l_left >= 2) {
      hud_texture_face(p_box, TEX_ARMOUR_FULL, 1.0, FALSE, l_ix, p_y0, l_size, 0.0, 0.0, l_size);
    } else if (l_left == 1) {
      hud_texture_face(p_box, TEX_ARMOUR_HALF, 1.0, FALSE, l_ix, p_y0, l_size, 0.0, 0.0, l_size);
    }
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
  if (player_creative(p_player)) l_info = l_info + "   CREATIVE";
  if (player_spectator(p_player)) l_info = l_info + "   SPECTATOR";
  if (player_flying(p_player) && !player_spectator(p_player)) l_info = l_info + "   FLYING";
  if (player_crouching(p_player)) l_info = l_info + "   CROUCHING";
  if (player_sprinting(p_player)) l_info = l_info + "   SPRINTING";
  if (world_dimension() == DIM_NETHER) l_info = l_info + "   NETHER";
  if (player_auto_walk(p_player)) l_info = l_info + "   AUTO-WALK";
  if (!settings_flag(p_settings, ATTR_SET_AUTO_JUMP)) l_info = l_info + "   auto-jump off";
  hud_text(p_box, 8.0, l_strip - 5.0, 11.0, TEXT_ALIGN_LEFT, 170, 176, 186, l_info);

  if (p_screen_open) return;

  // Paused: the game menu over the darkened world, nothing else
  if (!p_captured && !l_dead && !hud_waiting(p_hud)) {
    hud_draw_pause_menu(p_box, p_w, p_h, record_real(p_hud, ATTR_HUD_MOUSE_X), record_real(p_hud, ATTR_HUD_MOUSE_Y),
                        player_game_mode_name(player_game_mode(p_player)));
    return;
  }

  // Spectators hold nothing and touch nothing: no hand, crosshair or hotbar
  if (settings_flag(p_settings, ATTR_SET_SHOW_HUD) && !player_spectator(p_player)) {
    // Hand, crosshair, hotbar and health (only survival has health)
    // (seen from outside, your body shows instead of the hand and
    // the crosshair)
    if (player_camera(p_player) == CAMERA_FIRST) {
      if (!l_dead) hud_draw_hand(p_box, p_w, l_strip, p_h, l_held, player_bob(p_player), player_swing_time(p_player));
      // the offhand's item in the lower left
      if (!l_dead && slot_item(p_inventory, OFFHAND_SLOT) != ITEM_NONE) {
        hud_draw_item_icon(p_box, slot_item(p_inventory, OFFHAND_SLOT), p_w * 0.16 - Sin(player_bob(p_player)) * 6.0,
                           l_strip + (p_h - l_strip) * 0.16 + Absolute(Cos(player_bob(p_player))) * 5.0, 70.0 * (p_h - l_strip) / 480.0, ICON_FULL);
      }
      render_set_colour(p_box, 240.0, 240.0, 240.0);
      render_line(p_box, p_w / 2.0 - 9.0, l_centre_y, p_w / 2.0 - 3.0, l_centre_y);
      render_line(p_box, p_w / 2.0 + 3.0, l_centre_y, p_w / 2.0 + 9.0, l_centre_y);
      render_line(p_box, p_w / 2.0, l_centre_y - 9.0, p_w / 2.0, l_centre_y - 3.0);
      render_line(p_box, p_w / 2.0, l_centre_y + 3.0, p_w / 2.0, l_centre_y + 9.0);
    }

    for (l_slot = 1; l_slot <= HOTBAR_SLOTS; ++l_slot) {
      hud_draw_slot(p_box, l_bar_x + (l_slot - 1) * l_slot_size, l_bar_y, l_slot_size,
                    slot_item(p_inventory, l_slot), slot_count(p_inventory, l_slot), slot_damage(p_inventory, l_slot),
                    l_slot == player_selected(p_player));
    }
    // the offhand slot to the left of the hotbar when it holds something
    if (slot_item(p_inventory, OFFHAND_SLOT) != ITEM_NONE) {
      hud_draw_slot(p_box, l_bar_x - l_slot_size * 1.3, l_bar_y, l_slot_size, slot_item(p_inventory, OFFHAND_SLOT),
                    slot_count(p_inventory, OFFHAND_SLOT), slot_damage(p_inventory, OFFHAND_SLOT), FALSE);
    }
    if (player_survival(p_player)) {
      hud_draw_health(p_box, l_bar_x, l_bar_y + l_slot_size + 8.0, l_slot_size * 4.5 - 4.0, player_health(p_player), p_now);
      // the armour bar above the hearts while anything is worn
      if (inventory_armour_points(p_inventory) > 0) {
        hud_draw_armour(p_box, l_bar_x, l_bar_y + l_slot_size + 10.0 + (l_slot_size * 4.5 - 4.0) / 10.0, l_slot_size * 4.5 - 4.0,
                        inventory_armour_points(p_inventory));
      }
    }

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

  // Chat: recent lines above the messages, newest at the bottom (all
  // kept lines while typing), and the line being typed with a caret
  l_y = l_bar_y + l_slot_size + 84.0 + MAX_TOASTS * 17.0;
  for (l_toast = 1; l_toast <= MAX_CHAT_LINES; ++l_toast) {
    l_message = record_text_at(p_hud, ATTR_HUD_CHAT, l_toast);
    if (l_message == "") continue;
    if (!hud_chat_open(p_hud) && p_now > record_real_at(p_hud, ATTR_HUD_CHAT_UNTIL, l_toast)) continue;
    hud_shadow_text(p_box, 12.0, l_y, 13.0, TEXT_ALIGN_LEFT, 255, 255, 255, l_message);
    l_y = l_y + 17.0;
  }
  if (hud_chat_open(p_hud)) {
    l_y = l_bar_y + l_slot_size + 58.0;
    render_set_colour(p_box, 20.0, 20.0, 24.0);
    render_fill_rect (p_box, 6.0, l_y - 19.0, p_w * 0.6, l_y + 3.0);
    l_info = "> " + record_text(p_hud, ATTR_HUD_CHAT_INPUT);
    if (Floor(p_now * 2.0) - 2.0 * Floor(p_now) < 0.5) l_info = l_info + "_";
    hud_text(p_box, 12.0, l_y, 14.0, TEXT_ALIGN_LEFT, 255, 255, 255, l_info);
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

  // A portal's purple closing in while you stand in it, lava's orange
  l_edge = 0.0;
  if (player_portal_time(p_player) > 0.0 && !l_dead) {
    l_edge = 6.0 + 90.0 * clamp_real(player_portal_time(p_player) / PORTAL_SECONDS, 0.0, 1.0);
    render_set_colour(p_box, 128.0, 52.0, 210.0);
  }
  if (player_in_lava(p_player) && !l_dead) {
    l_edge = 40.0;
    render_set_colour(p_box, 236.0, 110.0, 20.0);
  }
  if (l_edge > 0.0) {
    render_fill_rect(p_box, 0.0, l_strip, p_w, l_strip + l_edge);
    render_fill_rect(p_box, 0.0, p_h - l_edge, p_w, p_h);
    render_fill_rect(p_box, 0.0, l_strip, l_edge, p_h);
    render_fill_rect(p_box, p_w - l_edge, l_strip, p_w, p_h);
  }

  if (l_dead) {
    hud_banner(p_box, p_w / 2.0, l_centre_y, 210.0, 54.0, "You died", "Press R or click the view to respawn", 230, 60, 50);
  } else if (!p_captured && hud_waiting(p_hud)) {
    hud_banner(p_box, p_w / 2.0, l_centre_y, 210.0, 54.0, "Click to play", "The mouse turns the camera; Escape pauses", 255, 255, 255);
  }
}

#endif
