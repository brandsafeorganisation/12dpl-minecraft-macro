#ifndef MENU_PANEL_4DM_INCLUDED
#define MENU_PANEL_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/player/player.h"
#include "../../include/program/settings.h"
#include "../../include/program/save.h"
#include "../../include/program/game.h"
#include "../../include/render/render.h"
#include "../../include/render/menu.h"
#include "../../include/ui/panels.h"
#include "../../include/ui/font.h"

// ----------------------------------------------------------------
// The game's panel and the title screen's controller: the title
// screen, the world list, making and deleting worlds and joining a
// multiplayer game, all drawn in the view. The options have their
// own controller (settings_panel.4dm), shared with the game menu.
// ----------------------------------------------------------------

Integer app_run()
// ----------------------------------------------------------------
// Make the game's one panel (the view and the keys box), then show
// the title screen and play the worlds picked from it until the
// player quits or the panel is closed
// ----------------------------------------------------------------
{
  Text               l_title   = GAME_TITLE;
  Panel              l_panel   = Create_panel(l_title, 1);
  Vertical_Group     l_vgroup  = Create_vertical_group(0);
  Colour_Message_Box l_message = Create_colour_message_box("");
  Draw_Box           l_box     = Create_draw_box(GAME_VIEW_WIDTH, GAME_VIEW_HEIGHT, 0);
  Input_Box          l_keys    = Create_input_box(KEYS_BOX_TITLE, l_message);
  Integer            l_running = TRUE;
  Integer            l_result  = 0;

  Append(l_box , l_vgroup);
  Append(l_keys, l_vgroup);
  Append(l_vgroup, l_panel);
  Set_width_in_chars(l_keys, 4);
  // the view fills the panel when it is resized
  Set_sizing_constraints(l_box   , 2, 2);
  Set_sizing_constraints(l_vgroup, 2, 2);
  Set_notify_resizing(l_panel);
  Show_widget(l_panel);
  Set_focus(l_keys);

  while (l_running) {
    l_result = menu_panel_run(l_box, l_keys, g_game, g_random, g_settings);
    if (l_result == MENU_RESULT_QUIT || l_result == SHUTDOWN_CODE) {
      l_running = FALSE;
    } else {
      l_result = game_panel_run(l_box, l_keys, record_text(g_game, ATTR_MENU_WORLD), l_result, record_integer(g_game, ATTR_MENU_SEED),
                                record_integer(g_game, ATTR_MENU_MODE));
      if (l_result == SHUTDOWN_CODE || l_result == PANEL_CLOSED) l_running = FALSE;
    }
  }
  Hide_widget(l_panel);
  return l_result;
}

void menu_open_worlds(Attributes &p_menu, Attributes &p_worlds)
// ----------------------------------------------------------------
// Read the world list afresh and start it at the top with nothing
// picked and no search
// ----------------------------------------------------------------
{
  save_list_worlds_about(p_worlds);
  menu_set_pick      (p_menu, 0);
  record_set_integer (p_menu, ATTR_MENU_SCROLL, 0);
  menu_set_field_text(p_menu, W_SEARCH, "");
  menu_set_focus     (p_menu, 0);
}

Text menu_free_world_name(Text p_base)
// ----------------------------------------------------------------
// p_base, or "p_base 2", "p_base 3" ... whichever isn't taken
// ----------------------------------------------------------------
{
  Integer l_number = 2;

  if (!save_world_exists(p_base)) return p_base;
  while (save_world_exists(p_base + " " + To_text(l_number)) && l_number < 999) ++l_number;
  return p_base + " " + To_text(l_number);
}

Integer menu_turned(Real p_last_frame, Real p_now)
// ----------------------------------------------------------------
// TRUE if the panorama has turned a cell since the last frame
// ----------------------------------------------------------------
{
  return Floor(p_now * PANO_SPEED) != Floor(p_last_frame * PANO_SPEED);
}

Text menu_splash(Integer p_pick)
// ----------------------------------------------------------------
// One of the yellow lines on the title screen
// ----------------------------------------------------------------
{
  if (p_pick == 1) return "Made of cubes!";
  if (p_pick == 2) return "Now in a Draw_Box!";
  if (p_pick == 3) return "Records are Attributes!";
  if (p_pick == 4) return "Also try 12d Model!";
  if (p_pick == 5) return "Punch a tree!";
  if (p_pick == 6) return "Mind the zombies!";
  return "100% 12dPL!";
}

void menu_background(Draw_Box p_box, Real p_w, Real p_h, Integer p_title, Real p_now)
// ----------------------------------------------------------------
// The turning panorama, darker behind every screen but the title. It
// turns a whole cell at a time, so a frame is only needed for each
// cell (menu_turned)
// ----------------------------------------------------------------
{
  Real l_turn  = Floor(p_now * PANO_SPEED);
  Real l_shade = MENU_SCREEN_SHADE;

  l_turn = l_turn - Floor(l_turn / PANO_COLUMNS) * PANO_COLUMNS;
  if (p_title) l_shade = 1.0;
  menu_draw_panorama(p_box, p_w, p_h, l_turn, l_shade);
}

Integer menu_panel_run(Draw_Box p_box, Input_Box p_keys, Attributes &p_game, Attributes &p_random, Attributes &p_settings)
// ----------------------------------------------------------------
// The title screen and the screens it leads to. Returns a
// MENU_RESULT_* code (or SHUTDOWN_CODE) and leaves the chosen world
// in the game record (ATTR_MENU_WORLD, ATTR_MENU_SEED, ATTR_MENU_MODE)
// ----------------------------------------------------------------
{
  Integer   l_screen     = SCREEN_TITLE;
  Integer   l_result     = MENU_RESULT_QUIT;
  Integer   l_doit       = TRUE;
  Integer   l_want_frame = TRUE;
  Integer   l_has_xy     = FALSE;
  Integer   l_widget     = 0;
  Integer   l_id         = 0;
  Integer   l_hover      = 0;
  Integer   l_new_mode   = GAMEMODE_SURVIVAL;
  Integer   l_width      = 0;
  Integer   l_height     = 0;
  Integer64 l_event_id   = 0;
  Real      l_now        = 0.0;
  Real      l_last_frame = 0.0;
  Real      l_last_click = 0.0;
  Real      l_x          = 0.0;
  Real      l_y          = 0.0;
  Real      l_w          = 0.0;
  Real      l_h          = 0.0;
  Text      l_cmd        = "";
  Text      l_msg        = "";
  Text      l_key        = "";
  Text      l_name       = "";
  Text      l_seed_text  = "";
  Text      l_splash     = menu_splash(random_range(p_random, 1, 7));

  menu_clear(g_menu);
  if (record_text(p_game, ATTR_GAME_PACK_REPORT) != "") {
    Get_time(l_now);
    menu_note(g_menu, record_text(p_game, ATTR_GAME_PACK_REPORT), FALSE, l_now);
    record_set_text(p_game, ATTR_GAME_PACK_REPORT, "");
  }
  Set_focus(p_keys);

  while (l_doit) {
    // ------------------------------------------------ frame
    if (l_want_frame) {
      Get_time(l_now);
      Get_size(p_box, l_width, l_height);
      l_w = l_width;
      l_h = l_height;
      Start_batch_draw(p_box);
      render_forget_colour();
      font_apply(p_box, settings_font(p_settings));
      menu_background(p_box, l_w, l_h, l_screen == SCREEN_TITLE, l_now);
      if (l_screen == SCREEN_TITLE      ) screen_title (p_box, g_menu, l_w, l_h, l_splash, l_now);
      if (l_screen == SCREEN_WORLDS     ) screen_worlds(p_box, g_menu, g_worlds, l_w, l_h, l_now);
      if (l_screen == SCREEN_CREATE     ) screen_create(p_box, g_menu, l_new_mode, l_w, l_h, l_now);
      if (l_screen == SCREEN_DELETE     ) screen_delete(p_box, g_menu, l_name, l_w, l_h, l_now);
      if (l_screen == SCREEN_MULTIPLAYER) screen_player(p_box, g_menu, TRUE, l_w, l_h, l_now);
      End_batch_draw(p_box);
      l_last_frame = l_now;
      l_want_frame = FALSE;
    }

    // ------------------------------------------------ next event
    l_event_id = 0;
    l_cmd      = "";
    l_msg      = "";
    if (Wait_on_events(l_event_id, l_cmd, l_msg) != 0) continue;
    Get_time(l_now);
    l_id = 0;

    if (l_cmd == "CodeShutdown") {
      Set_exit_code(l_cmd);
      return SHUTDOWN_CODE;
    }
    if (l_cmd == "Panel Quit") return MENU_RESULT_QUIT;
    if (l_cmd == "Panel_Resize") l_want_frame = TRUE;

    if (l_event_id == Get_id64(p_box)) {
      // ------------------------------------------------ mouse
      l_has_xy = game_panel_split_xy(l_msg, l_x, l_y) == SUCCESS;
      if (!l_has_xy) continue;
      menu_set_mouse(g_menu, l_x, l_y);
      l_widget = menu_at(g_menu, l_x, l_y);
      if (l_cmd == "mouse_move") {
        if (record_integer(g_menu, ATTR_MENU_DRAG) == W_LIST_SCROLL && menu_widget_of(g_menu, W_LIST_SCROLL) > 0) {
          menu_scroll_to(g_menu, menu_slider_value_at(g_menu, menu_widget_of(g_menu, W_LIST_SCROLL), l_x, l_y));
          l_want_frame = TRUE;
        }
        if (l_widget != l_hover || menu_turned(l_last_frame, l_now)) l_want_frame = TRUE;
        l_hover = l_widget;
        continue;
      }
      if (l_cmd == "click_lb_down") {
        if (menu_widget_kind(g_menu, l_widget) == MENU_SCROLL) {
          record_set_integer(g_menu, ATTR_MENU_DRAG, W_LIST_SCROLL);
          menu_scroll_to(g_menu, menu_slider_value_at(g_menu, l_widget, l_x, l_y));
          l_want_frame = TRUE;
        }
        continue;
      }
      if (l_cmd != "click_lb" && l_cmd != "double_click_lb") continue;
      Set_focus(p_keys);
      l_want_frame = TRUE;
      if (record_integer(g_menu, ATTR_MENU_DRAG) != 0) {
        record_set_integer(g_menu, ATTR_MENU_DRAG, 0);
        continue;
      }
      l_id = menu_widget_id(g_menu, l_widget);
      if (menu_widget_kind(g_menu, l_widget) == MENU_FIELD) {
        menu_set_focus(g_menu, l_id);
        continue;
      }
      // a world row: pick it; a second click on it soon after plays it
      if (l_id > W_WORLD_ROW && l_id <= W_WORLD_ROW + MAX_LISTED_WORLDS) {
        if (menu_pick(g_menu) == l_id - W_WORLD_ROW && (l_cmd == "double_click_lb" || l_now - l_last_click < DOUBLE_CLICK_SECONDS)) {
          l_id = W_PLAY;
        } else {
          menu_set_pick(g_menu, l_id - W_WORLD_ROW);
          l_last_click = l_now;
          continue;
        }
      }
      if (l_id == 0) continue;

    } else if (l_event_id == Get_id64(p_keys)) {
      // ------------------------------------------------ keys
      if (l_cmd == "keystroke") {
        l_key = key_name(l_msg);
        Set_data(p_keys, "");
        l_want_frame = TRUE;
        if (l_key == "escape") {
          // Escape is Back (or Cancel)
          if (l_screen == SCREEN_WORLDS || l_screen == SCREEN_MULTIPLAYER) l_id = W_BACK;
          if (l_screen == SCREEN_CREATE || l_screen == SCREEN_DELETE) l_id = W_CANCEL;
          if (l_screen == SCREEN_MULTIPLAYER) l_id = W_DONE;
        } else if (menu_type_key(g_menu, l_key, l_msg)) {
          // the world list follows the search as it is typed
          if (menu_focus(g_menu) == W_SEARCH) {
            menu_set_pick(g_menu, 0);
            record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
          }
          continue;
        }
        if (l_id == 0) continue;
      } else if (l_cmd == "text selected") {
        // Enter does the screen's main button
        Set_data(p_keys, "");
        Set_focus(p_keys);
        if (l_screen == SCREEN_CREATE) l_id = W_CREATE;
        if (l_screen == SCREEN_WORLDS && menu_pick(g_menu) > 0) l_id = W_PLAY;
        if (l_screen == SCREEN_MULTIPLAYER) l_id = W_JOIN;
        if (l_id == 0) continue;
        l_want_frame = TRUE;
      } else {
        continue;
      }
    } else {
      continue;
    }

    // ------------------------------------------------ the widget's action
    if (l_screen == SCREEN_TITLE) {
      if (l_id == W_SINGLEPLAYER) {
        menu_open_worlds(g_menu, g_worlds);
        l_screen = SCREEN_WORLDS;
      } else if (l_id == W_MULTIPLAYER) {
        menu_set_field_text(g_menu, W_PLAYER_NAME, settings_player_name(p_settings));
        menu_set_field_text(g_menu, W_FOLDER, settings_mp_folder(p_settings));
        menu_set_focus(g_menu, 0);
        l_screen = SCREEN_MULTIPLAYER;
      } else if (l_id == W_OPTIONS) {
        l_result = settings_panel_run(p_box, p_keys, p_settings, FALSE, SCREEN_OPTIONS);
        if (l_result == SHUTDOWN_CODE) return SHUTDOWN_CODE;
        if (l_result == PANEL_CLOSED) return MENU_RESULT_QUIT;
        l_result = MENU_RESULT_QUIT;
        menu_clear(g_menu);
      } else if (l_id == W_QUIT) {
        return MENU_RESULT_QUIT;
      }

    } else if (l_screen == SCREEN_WORLDS) {
      l_name = "";
      if (menu_pick(g_menu) > 0) l_name = record_text_at(g_worlds, ATTR_WL_NAME, menu_pick(g_menu));
      if (l_id == W_BACK) {
        menu_set_focus(g_menu, 0);
        l_screen = SCREEN_TITLE;
      } else if (l_id == W_NEW_WORLD) {
        menu_set_field_text(g_menu, W_WORLD_NAME, menu_free_world_name("New World"));
        menu_set_field_text(g_menu, W_SEED, "");
        menu_set_focus(g_menu, W_WORLD_NAME);
        l_new_mode = GAMEMODE_SURVIVAL;
        l_screen   = SCREEN_CREATE;
      } else if (l_id == W_DELETE && l_name != "") {
        l_screen = SCREEN_DELETE;
      } else if ((l_id == W_PLAY || l_id == W_HOST) && l_name != "") {
        record_set_text(p_game, ATTR_MENU_WORLD, l_name);
        l_result = MENU_RESULT_PLAY;
        if (l_id == W_HOST) l_result = MENU_RESULT_HOST;
        return l_result;
      }

    } else if (l_screen == SCREEN_CREATE) {
      if (l_id == W_CANCEL) {
        menu_open_worlds(g_menu, g_worlds);
        l_screen = SCREEN_WORLDS;
      } else if (l_id == W_GAME_MODE) {
        // survival and creative in turn
        if (l_new_mode == GAMEMODE_CREATIVE) {
          l_new_mode = GAMEMODE_SURVIVAL;
        } else {
          l_new_mode = GAMEMODE_CREATIVE;
        }
      } else if (l_id == W_CREATE) {
        l_name      = Text_justify(menu_field_text(g_menu, W_WORLD_NAME));
        l_seed_text = Text_justify(menu_field_text(g_menu, W_SEED));
        if (!text_is_safe_name(l_name)) {
          menu_note(g_menu, "World names can use letters, numbers, spaces, - and _ (up to 40 characters).", TRUE, l_now);
        } else if (save_world_exists(l_name)) {
          menu_note(g_menu, "There is already a world called " + l_name + ".", TRUE, l_now);
        } else {
          record_set_text(p_game, ATTR_MENU_WORLD, l_name);
          if (l_seed_text == "") {
            record_set_integer(p_game, ATTR_MENU_SEED, random_range(p_random, 1, 999999999));
          } else {
            record_set_integer(p_game, ATTR_MENU_SEED, text_to_seed(l_seed_text));
          }
          record_set_integer(p_game, ATTR_MENU_MODE, l_new_mode);
          return MENU_RESULT_CREATE;
        }
      }

    } else if (l_screen == SCREEN_DELETE) {
      l_name = "";
      if (menu_pick(g_menu) > 0) l_name = record_text_at(g_worlds, ATTR_WL_NAME, menu_pick(g_menu));
      if (l_id == W_CONFIRM_DELETE && l_name != "") {
        if (save_delete_world(l_name) == SUCCESS) {
          menu_open_worlds(g_menu, g_worlds);
          menu_note(g_menu, "Deleted " + l_name + ".", FALSE, l_now);
        } else {
          menu_note(g_menu, "Couldn't delete " + l_name + ".", TRUE, l_now);
        }
        l_screen = SCREEN_WORLDS;
      } else if (l_id == W_CANCEL) {
        l_screen = SCREEN_WORLDS;
      }

    } else if (l_screen == SCREEN_MULTIPLAYER) {
      if (l_id == W_DONE || l_id == W_JOIN) {
        settings_set_text(p_settings, ATTR_SET_PLAYER_NAME, Text_justify(menu_field_text(g_menu, W_PLAYER_NAME)));
        settings_set_text(p_settings, ATTR_SET_MP_FOLDER, Text_justify(menu_field_text(g_menu, W_FOLDER)));
        save_ensure_folder();
        settings_save(p_settings, save_settings_path());
        menu_set_focus(g_menu, 0);
        l_screen = SCREEN_TITLE;
      }
      if (l_id == W_JOIN) {
        record_set_text(p_game, ATTR_MENU_WORLD, "Multiplayer");
        return MENU_RESULT_JOIN;
      }
    }
  }
  return l_result;
}

#endif
