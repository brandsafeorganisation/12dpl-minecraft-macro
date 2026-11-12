#ifndef PANELS_H_INCLUDED
#define PANELS_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// The 12d panels: the world menu, the settings and the game itself
// (the controllers that turn 12d events into game actions). These
// are the only functions that name the global records in game.h.
// ----------------------------------------------------------------

#define MENU_RESULT_QUIT     0
#define MENU_RESULT_PLAY     1   // load the world named ATTR_MENU_WORLD
#define MENU_RESULT_CREATE   2   // create it from ATTR_MENU_SEED

#define GAME_VIEW_WIDTH      860
#define GAME_VIEW_HEIGHT     520
#define PAUSED_FRAME_GAP     0.25

// The menu's choice is left in the game record
#define ATTR_MENU_WORLD      ("menu_world")
#define ATTR_MENU_SEED       ("menu_seed")

Integer menu_panel_run       (Attributes &p_game, Attributes &p_random, Attributes &p_settings);
Integer settings_panel_run   (Attributes &p_settings);
void    settings_panel_show  (Attributes &p_settings, Colour_Message_Box p_render_row, Colour_Message_Box p_detail_row,
                              Colour_Message_Box p_fov_row, Colour_Message_Box p_mouse_row, Colour_Message_Box p_plants_row,
                              Colour_Message_Box p_shading_row, Colour_Message_Box p_jump_row, Colour_Message_Box p_hud_row,
                              Colour_Message_Box p_debug_row, Colour_Message_Box p_pack_row, Colour_Message_Box p_font_row);
Integer menu_refresh_worlds  (List_Box p_world_list);
Integer game_panel_split_xy  (Text p_msg, Real &p_x, Real &p_y);
Integer game_panel_calibrate (Draw_Box p_box, Real p_box_x, Real p_box_y, Integer p_width, Integer p_height, Integer &p_origin_x, Integer &p_origin_y);
void    game_panel_notice    (Draw_Box p_box, Text p_title, Text p_line);
void    game_panel_dispatch  (Real p_now);
Integer game_panel_save      ();
void    game_panel_close_screen();
void    game_panel_render    (Draw_Box p_box, Integer p_captured, Real p_frame_ms, Real p_now);
Integer game_panel_run       (Text p_world_name, Integer p_create, Integer p_seed);

#endif
