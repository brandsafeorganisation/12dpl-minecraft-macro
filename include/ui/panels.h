#ifndef PANELS_H_INCLUDED
#define PANELS_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// The game's one 12d panel and its controllers. The panel holds the
// view (a Draw_Box) and a small "Keys" input box that keeps the
// keyboard focus (a Draw_Box gets no key presses in 12d). Every
// screen, the title screen, the world list, the options and the game
// itself, is drawn in the view. These are the only functions that
// name the global records in game.h.
// ----------------------------------------------------------------

#define MENU_RESULT_QUIT     0
#define MENU_RESULT_PLAY     1   // load the world named ATTR_MENU_WORLD
#define MENU_RESULT_CREATE   2   // create it from ATTR_MENU_SEED in ATTR_MENU_MODE
// 3 was MENU_RESULT_HOST: worlds are opened to LAN from the game menu now
#define MENU_RESULT_JOIN     4   // join the game hosted in the multiplayer folder
#define PANEL_CLOSED         2   // settings_panel_run / game_panel_run: the window was closed

#define GAME_VIEW_WIDTH      860
#define GAME_VIEW_HEIGHT     520
#define PAUSED_FRAME_GAP     0.25
#define MENU_DRAG_GAP        0.05   // a slider or scroll bar being dragged redraws at most this often
#define DOUBLE_CLICK_SECONDS 0.4
#define KEYS_BOX_TITLE       "Keys"

// The menu's choice is left in the game record
#define ATTR_MENU_WORLD      ("menu_world")
#define ATTR_MENU_SEED       ("menu_seed")
#define ATTR_MENU_MODE       ("menu_mode")    // game mode of a new world

Integer app_run              ();
Integer menu_panel_run       (Draw_Box p_box, Input_Box p_keys, Attributes &p_game, Attributes &p_random, Attributes &p_settings);
void    menu_open_worlds     (Attributes &p_menu, Attributes &p_worlds);
Text    menu_free_world_name (Text p_base);
Integer menu_turned           (Real p_last_frame, Real p_now);
Text    menu_splash          (Integer p_pick);
void    menu_background      (Draw_Box p_box, Real p_w, Real p_h, Integer p_title, Real p_now);
Integer settings_panel_run   (Draw_Box p_box, Input_Box p_keys, Attributes &p_settings, Integer p_in_game, Integer p_screen);
void    settings_slider      (Attributes &p_settings, Integer p_id, Real p_value);
Integer game_panel_split_xy  (Text p_msg, Real &p_x, Real &p_y);
Integer game_panel_calibrate (Draw_Box p_box, Real p_box_x, Real p_box_y, Integer p_width, Integer p_height, Integer &p_origin_x, Integer &p_origin_y);
void    game_panel_notice    (Draw_Box p_box, Text p_title, Text p_line);
Integer game_panel_lan_join  (Draw_Box p_box, Text p_found, Text p_player_id, Text &p_folder, Text &p_problem);
Integer game_panel_lan_host  (Draw_Box p_box, Text p_session, Text p_player_id, Text &p_problem);
void    game_panel_lan_stop  ();
void    game_panel_dispatch  (Real p_now);
Integer game_panel_save      ();
void    game_panel_close_screen();
void    game_panel_backdrop  (Draw_Box p_box, Real p_w, Real p_h, Real p_now);
void    game_panel_render    (Draw_Box p_box, Integer p_captured, Real p_frame_ms, Real p_now);
Integer game_panel_run       (Draw_Box p_box, Input_Box p_keys, Text p_world_name, Integer p_mode, Integer p_seed, Integer p_game_mode);

#endif
