#ifndef HUD_H_INCLUDED
#define HUD_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// Everything drawn flat over the 3D view: crosshair, hotbar, health,
// the hand, messages, the status strip and the help / pause / death
// overlays. Also the item icons shared with the inventory screens.
//
// The HUD record keeps the messages ("text_n", "until_n" for
// n = 1..MAX_TOASTS, newest first), whether the help is showing and
// until when the selected item's name is shown.
// ----------------------------------------------------------------

#define MAX_TOASTS          4
#define TOAST_SECONDS       3.0
#define MAX_CHAT_LINES      8     // chat lines kept (shown while typing)
#define CHAT_SECONDS        10.0  // a chat line shows this long otherwise
#define TEXT_ALIGN_LEFT     0     // top left of the text at (x, y)
#define TEXT_ALIGN_CENTRE   30    // top centre of the text at (x, y)
#define ICON_QUICK          0     // block icons as 2 x 2 colours (hotbar, hand)
#define ICON_FULL           1     // block icons with their whole 16 x 16 texture
#define SLOT_STYLE_DARK     0     // hotbar slots over the world
#define SLOT_STYLE_LIGHT    1     // slots on the light inventory panel

// Inventory screen colours (light grey panel, dark text)
#define UI_BACKDROP_R       104.0
#define UI_BACKDROP_G       108.0
#define UI_BACKDROP_B       116.0
#define UI_PANEL_R          198.0
#define UI_PANEL_G          198.0
#define UI_PANEL_B          198.0
#define UI_FRAME_R          250.0
#define UI_FRAME_G          250.0
#define UI_FRAME_B          250.0
#define UI_TEXT_R           50
#define UI_TEXT_G           50
#define UI_TEXT_B           54
#define UI_HINT_R           92
#define UI_HINT_G           92
#define UI_HINT_B           100

#define DATATYPE_HUD        ("hud")
#define ATTR_HUD_UNTIL      ("until")
#define ATTR_HUD_HELP       ("show_help")
#define ATTR_HUD_NAME_UNTIL ("name_until")
#define ATTR_HUD_FRAMES     ("frames")          // frame times over the current second
#define ATTR_HUD_FRAME_SUM  ("frame_sum")
#define ATTR_HUD_FRAME_MIN  ("frame_min")
#define ATTR_HUD_FRAME_MAX  ("frame_max")
#define ATTR_HUD_WINDOW     ("window_start")
#define ATTR_HUD_STATS      ("frame_stats")     // the last full second, as text
#define ATTR_HUD_CHAT       ("chat")            // chat lines "chat_n", newest first
#define ATTR_HUD_CHAT_UNTIL ("chat_until")
#define ATTR_HUD_CHAT_OPEN  ("chat_open")       // TRUE while a chat line is being typed
#define ATTR_HUD_CHAT_INPUT ("chat_input")      // the line being typed
#define FRAME_STATS_SECONDS 1.0

/*Global variables*/ {
  // Polygon scratch for icons
  Real    g_icon_x[8];
  Real    g_icon_y[8];
}

void hud_clear          (Attributes &p_hud);
void hud_toast          (Attributes &p_hud, Text p_text, Real p_now);
void hud_chat           (Attributes &p_hud, Text p_text, Real p_now);
void hud_set_chat_input (Attributes &p_hud, Integer p_open, Text p_text);
Integer hud_chat_open   (Attributes &p_hud);
void hud_show_name      (Attributes &p_hud, Real p_now);
Integer hud_help_shown  (Attributes &p_hud);
void hud_set_help       (Attributes &p_hud, Integer p_shown);
void hud_note_frame     (Attributes &p_hud, Real p_frame_ms, Real p_now);
Text hud_frame_stats    (Attributes &p_hud);
void hud_on_event       (Attributes &p_event, Attributes &p_hud, Real p_now);
void hud_text           (Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_align, Integer p_red, Integer p_green, Integer p_blue, Text p_text);
void hud_shadow_text    (Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_align, Integer p_red, Integer p_green, Integer p_blue, Text p_text);
void hud_frame          (Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1);
void hud_texture_face   (Draw_Box p_box, Integer p_tex, Real p_shade, Integer p_quick,
                         Real p_origin_x, Real p_origin_y, Real p_u_x, Real p_u_y, Real p_v_x, Real p_v_y);
void hud_draw_item_icon (Draw_Box p_box, Integer p_item, Real p_centre_x, Real p_centre_y, Real p_size, Integer p_detail);
void hud_draw_slot      (Draw_Box p_box, Real p_x0, Real p_y0, Real p_size, Integer p_item, Integer p_count, Integer p_damage, Integer p_highlight);
void hud_draw_slot_style(Draw_Box p_box, Real p_x0, Real p_y0, Real p_size, Integer p_item, Integer p_count, Integer p_damage, Integer p_highlight,
                         Integer p_style);
Text hud_facing_name    (Real p_yaw);
void hud_draw_hand      (Draw_Box p_box, Real p_w, Real p_view_bottom, Real p_h, Integer p_item, Real p_bob, Real p_swing_time);
void hud_draw_health    (Draw_Box p_box, Real p_x0, Real p_y0, Real p_width, Integer p_health, Real p_now);
void hud_draw_help      (Draw_Box p_box, Real p_w, Real p_h);
void hud_draw           (Draw_Box p_box, Real p_w, Real p_h, Integer p_captured, Integer p_screen_open,
                         Attributes &p_hud, Attributes &p_player, Attributes &p_inventory, Attributes &p_settings,
                         Integer p_seed, Real p_time_of_day, Real p_frame_ms, Text p_render_stats, Real p_now);

#endif
