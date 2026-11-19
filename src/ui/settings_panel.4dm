#ifndef SETTINGS_PANEL_4DM_INCLUDED
#define SETTINGS_PANEL_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/program/settings.h"
#include "../../include/program/save.h"
#include "../../include/program/game.h"
#include "../../include/render/menu.h"
#include "../../include/ui/panels.h"
#include "../../include/ui/font.h"

// ----------------------------------------------------------------
// The options (controller), drawn in the view over the panorama, or
// over the world darkened when opened from the game menu: the
// options screen itself, the resource pack and skin pickers and the
// multiplayer name and folder. Changes apply straight away and are
// saved to the settings file when Done is pressed.
// ----------------------------------------------------------------

void settings_slider(Attributes &p_settings, Integer p_id, Real p_value)
// ----------------------------------------------------------------
// Set the setting of a slider from where it is (0..1), in its steps
// ----------------------------------------------------------------
{
  Integer l_steps = 0;

  if (p_id == W_FOV) {
    l_steps = floor_integer(p_value * (FOV_MAX - FOV_MIN) / FOV_STEP + 0.5);
    record_set_integer(p_settings, ATTR_SET_FOV, clamp_integer(FOV_MIN + l_steps * FOV_STEP, FOV_MIN, FOV_MAX));
  } else if (p_id == W_RENDER) {
    l_steps = floor_integer(p_value * (RENDER_DISTANCE_MAX - RENDER_DISTANCE_MIN) / RENDER_DISTANCE_STEP + 0.5);
    record_set_integer(p_settings, ATTR_SET_RENDER_DISTANCE,
                       clamp_integer(RENDER_DISTANCE_MIN + l_steps * RENDER_DISTANCE_STEP, RENDER_DISTANCE_MIN, RENDER_DISTANCE_MAX));
  } else if (p_id == W_MOUSE) {
    l_steps = floor_integer(p_value * (SENSITIVITY_MAX - SENSITIVITY_MIN) + 0.5);
    record_set_integer(p_settings, ATTR_SET_SENSITIVITY, clamp_integer(SENSITIVITY_MIN + l_steps, SENSITIVITY_MIN, SENSITIVITY_MAX));
  }
}

Integer settings_panel_run(Draw_Box p_box, Input_Box p_keys, Attributes &p_settings, Integer p_in_game, Integer p_screen)
// ----------------------------------------------------------------
// Show the options (screen SCREEN_OPTIONS) or the key binds
// (SCREEN_CONTROLS, from the game menu) until Done (or Escape).
// Returns 0, PANEL_CLOSED if the window was closed, or SHUTDOWN_CODE
// if 12d asked the macro to stop.
// ----------------------------------------------------------------
{
  Integer   l_screen     = p_screen;
  Integer   l_listening  = 0;        // the action waiting for a key on the Key Binds screen
  Integer   l_action     = 0;
  Integer   l_result     = 0;
  Integer   l_doit       = TRUE;
  Integer   l_want_frame = TRUE;
  Integer   l_has_xy     = FALSE;
  Integer   l_widget     = 0;
  Integer   l_id         = 0;
  Integer   l_hover      = 0;
  Integer   l_drag       = 0;
  Integer   l_width      = 0;
  Integer   l_height     = 0;
  Integer64 l_event_id   = 0;
  Real      l_now        = 0.0;
  Real      l_last_frame = 0.0;
  Real      l_x          = 0.0;
  Real      l_y          = 0.0;
  Real      l_w          = 0.0;
  Real      l_h          = 0.0;
  Text      l_cmd        = "";
  Text      l_msg        = "";
  Text      l_key        = "";
  Text      l_pack       = settings_resource_pack(p_settings);
  Text      l_report     = "";
  Text      l_keep       = "";
  Text      l_binds[BIND_ACTIONS];

  menu_clear(g_menu);
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
      if (p_in_game) {
        game_panel_backdrop(p_box, l_w, l_h, l_now);
      } else {
        menu_background(p_box, l_w, l_h, FALSE, l_now);
      }
      if (l_screen == SCREEN_OPTIONS) screen_options(p_box, g_menu, p_settings, l_w, l_h, l_now);
      if (l_screen == SCREEN_PACKS  ) screen_packs  (p_box, g_menu, g_files, l_pack, l_w, l_h, l_now);
      if (l_screen == SCREEN_SKINS  ) screen_skins  (p_box, g_menu, g_files, settings_skin(p_settings), l_w, l_h, l_now);
      if (l_screen == SCREEN_PLAYER ) screen_player (p_box, g_menu, FALSE, l_w, l_h, l_now);
      if (l_screen == SCREEN_FONTS  ) screen_fonts  (p_box, g_menu, g_files, settings_font(p_settings), settings_font_file(p_settings), l_w, l_h, l_now);
      if (l_screen == SCREEN_CONTROLS) screen_controls(p_box, g_menu, p_settings, l_listening, l_w, l_h, l_now);
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
      l_result = SHUTDOWN_CODE;
      l_doit   = FALSE;
      continue;
    }
    if (l_cmd == "Panel Quit") {
      l_result = PANEL_CLOSED;
      l_doit   = FALSE;
      continue;
    }
    if (l_cmd == "Panel_Resize") l_want_frame = TRUE;

    if (l_event_id == Get_id64(p_box)) {
      // ------------------------------------------------ mouse
      l_has_xy = game_panel_split_xy(l_msg, l_x, l_y) == SUCCESS;
      if (!l_has_xy) continue;
      menu_set_mouse(g_menu, l_x, l_y);
      l_widget = menu_at(g_menu, l_x, l_y);
      l_drag   = record_integer(g_menu, ATTR_MENU_DRAG);
      // a slider or scroll bar held down follows the mouse
      if ((l_cmd == "mouse_move" && l_drag != 0) || (l_cmd == "click_lb_down" && menu_widget_kind(g_menu, l_widget) >= MENU_SLIDER &&
                                                    menu_widget_kind(g_menu, l_widget) != MENU_ROW)) {
        if (l_cmd == "click_lb_down") {
          l_drag = menu_widget_id(g_menu, l_widget);
          record_set_integer(g_menu, ATTR_MENU_DRAG, l_drag);
        }
        if (l_drag == W_LIST_SCROLL) {
          if (menu_widget_of(g_menu, W_LIST_SCROLL) > 0) menu_scroll_to(g_menu, menu_slider_value_at(g_menu, menu_widget_of(g_menu, W_LIST_SCROLL), l_x, l_y));
        } else if (menu_widget_of(g_menu, l_drag) > 0) {
          settings_slider(p_settings, l_drag, menu_slider_value_at(g_menu, menu_widget_of(g_menu, l_drag), l_x, l_y));
        }
        // a drag redraws at most every MENU_DRAG_GAP (a frame can
        // cost more than the mouse's events come); letting go draws
        // where it ended
        if (l_cmd == "click_lb_down" || l_now - l_last_frame >= MENU_DRAG_GAP) l_want_frame = TRUE;
        continue;
      }
      if (l_cmd == "mouse_move") {
        // the title screen's panorama turns; the world behind the
        // in-game options stands still
        if (l_widget != l_hover || (!p_in_game && menu_turned(l_last_frame, l_now))) l_want_frame = TRUE;
        l_hover = l_widget;
        continue;
      }
      if (l_cmd != "click_lb" && l_cmd != "double_click_lb") continue;
      Set_focus(p_keys);
      l_want_frame = TRUE;
      if (l_drag != 0) {
        record_set_integer(g_menu, ATTR_MENU_DRAG, 0);
        continue;
      }
      l_id = menu_widget_id(g_menu, l_widget);
      if (menu_widget_kind(g_menu, l_widget) == MENU_FIELD) {
        menu_set_focus(g_menu, l_id);
        continue;
      }
      // a click anywhere else stops waiting for a key
      if (l_screen == SCREEN_CONTROLS && (l_id < W_KEY_ROW || l_id > W_KEY_ROW + BIND_ACTIONS)) l_listening = 0;
      if (l_id == 0) continue;

    } else if (l_event_id == Get_id64(p_keys)) {
      // ------------------------------------------------ keys
      if (l_cmd == "keystroke") {
        l_key = key_name(l_msg);
        Set_data(p_keys, "");
        l_want_frame = TRUE;
        if (l_listening > 0) {
          // the key for the action being changed: Shift or Ctrl if
          // one was held, Escape for none
          l_keep = key_modifier(l_msg);
          if (l_keep == "") l_keep = key_base(l_msg);
          if (l_key == "escape") l_keep = "";
          settings_set_bind(p_settings, l_listening, l_keep);
          l_listening = 0;
          continue;
        } else if (l_key == "escape") {
          l_id = W_DONE;
        } else if (menu_type_key(g_menu, l_key, l_msg)) {
          continue;
        } else {
          continue;
        }
      } else if (l_cmd == "text selected") {
        Set_data(p_keys, "");
        Set_focus(p_keys);
        l_id = W_DONE;
        if (l_listening > 0) l_id = 0;
        l_listening = 0;
        if (l_screen == SCREEN_FONTS && menu_focus(g_menu) == W_FONT_NAME) l_id = W_FONT_USE;
        l_want_frame = TRUE;
      } else {
        continue;
      }
    } else {
      continue;
    }

    // ------------------------------------------------ the widget's action
    if (l_screen == SCREEN_OPTIONS) {
      if (l_id == W_DONE) {
        l_doit = FALSE;
      } else if (l_id == W_DETAIL) {
        record_set_integer(p_settings, ATTR_SET_DETAIL, settings_detail(p_settings) + 1);
        if (settings_detail(p_settings) > DETAIL_HIGH) record_set_integer(p_settings, ATTR_SET_DETAIL, DETAIL_LOW);
      } else if (l_id == W_PLANTS) {
        settings_toggle(p_settings, ATTR_SET_PLANTS);
      } else if (l_id == W_SHADING) {
        settings_toggle(p_settings, ATTR_SET_SHADING);
      } else if (l_id == W_AUTO_JUMP) {
        settings_toggle(p_settings, ATTR_SET_AUTO_JUMP);
      } else if (l_id == W_SHOW_HUD) {
        settings_toggle(p_settings, ATTR_SET_SHOW_HUD);
      } else if (l_id == W_STATISTICS) {
        settings_toggle(p_settings, ATTR_SET_SHOW_DEBUG);
      } else if (l_id == W_FONT) {
        save_list_files(g_files, FONT_FOLDER, "*.*", FALSE);
        record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
        menu_set_field_text(g_menu, W_FONT_NAME, "");
        menu_set_focus(g_menu, 0);
        l_screen = SCREEN_FONTS;
      } else if (l_id == W_PACKS) {
        save_list_files(g_files, PACK_FOLDER, "*.zip", TRUE);
        l_pack = settings_resource_pack(p_settings);
        record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
        l_screen = SCREEN_PACKS;
      } else if (l_id == W_SKINS) {
        save_list_files(g_files, SKIN_FOLDER, "*.png", FALSE);
        record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
        l_screen = SCREEN_SKINS;
      } else if (l_id == W_CONTROLS) {
        record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
        l_listening = 0;
        l_screen    = SCREEN_CONTROLS;
      } else if (l_id == W_PLAYER_SETTINGS) {
        menu_set_field_text(g_menu, W_PLAYER_NAME, settings_player_name(p_settings));
        menu_set_field_text(g_menu, W_FOLDER, settings_mp_folder(p_settings));
        menu_set_focus(g_menu, 0);
        l_screen = SCREEN_PLAYER;
      } else if (l_id == W_DEFAULTS) {
        // the textures, skin, font and keys stay: they have screens of their own
        l_pack = settings_resource_pack(p_settings);
        l_keep = settings_skin(p_settings);
        l_key  = settings_font(p_settings);
        for (l_action = 1; l_action <= BIND_ACTIONS; ++l_action) l_binds[l_action] = settings_bind(p_settings, l_action);
        settings_defaults(p_settings);
        settings_set_resource_pack(p_settings, l_pack);
        settings_set_text(p_settings, ATTR_SET_SKIN, l_keep);
        settings_set_font(p_settings, l_key);
        for (l_action = 1; l_action <= BIND_ACTIONS; ++l_action) settings_set_bind(p_settings, l_action, l_binds[l_action]);
        menu_note(g_menu, "Settings back to their defaults.", FALSE, l_now);
      }

    } else if (l_screen == SCREEN_PACKS) {
      if (l_id > W_AVAILABLE_ROW && l_id <= W_AVAILABLE_ROW + record_integer(g_files, ATTR_FL_COUNT)) {
        l_pack = record_text_at(g_files, ATTR_FL_PATH, l_id - W_AVAILABLE_ROW);
      } else if (l_id == W_SELECTED_ROW + 1) {
        l_pack = "";
      } else if (l_id == W_DONE) {
        if (l_pack != settings_resource_pack(p_settings)) {
          // loading a pack takes a while: say so first
          game_panel_notice(p_box, "Loading resource pack", save_file_name(l_pack));
          settings_set_resource_pack(p_settings, l_pack);
          if (game_load_textures(p_settings, l_report) == 0 && l_pack != "") {
            settings_set_resource_pack(p_settings, "");
            game_load_textures(p_settings, l_keep);
            menu_note(g_menu, l_report + " Using the built-in textures.", TRUE, l_now);
          } else if (l_pack != "") {
            menu_note(g_menu, l_report, FALSE, l_now);
          } else {
            menu_note(g_menu, "Using the built-in textures.", FALSE, l_now);
          }
        }
        record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
        l_screen = SCREEN_OPTIONS;
      }

    } else if (l_screen == SCREEN_SKINS) {
      if (l_id >= W_SKIN_ROW && l_id <= W_SKIN_ROW + record_integer(g_files, ATTR_FL_COUNT)) {
        l_keep = "";
        if (l_id > W_SKIN_ROW) l_keep = record_text_at(g_files, ATTR_FL_PATH, l_id - W_SKIN_ROW);
        settings_set_text(p_settings, ATTR_SET_SKIN, l_keep);
        game_load_textures(p_settings, l_report);
        if (l_keep != "" && Find_text(l_report, "Skin: ") == 0) {
          // not a skin that could be read: back to the built-in one
          settings_set_text(p_settings, ATTR_SET_SKIN, "");
          game_load_textures(p_settings, l_key);
          menu_note(g_menu, l_report + " Using the built-in skin.", TRUE, l_now);
        }
      } else if (l_id == W_DONE) {
        record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
        l_screen = SCREEN_OPTIONS;
      }

    } else if (l_screen == SCREEN_FONTS) {
      if (l_id > W_FONT_ROW && l_id <= W_FONT_ROW + FONT_CHOICES) {
        settings_set_font(p_settings, font_choice(l_id - W_FONT_ROW));
        settings_set_font_file(p_settings, "");
      } else if (l_id > W_FONT_ROW + FONT_CHOICES && l_id <= W_FONT_ROW + FONT_CHOICES + record_integer(g_files, ATTR_FL_COUNT)) {
        l_keep = record_text_at(g_files, ATTR_FL_PATH, l_id - W_FONT_ROW - FONT_CHOICES);
        if (font_family_from_file(l_keep, l_key, l_report) == SUCCESS) {
          settings_set_font(p_settings, l_key);
          settings_set_font_file(p_settings, l_keep);
          menu_note(g_menu, "Using " + l_key + " (12d draws it once the file is installed in Windows).", FALSE, l_now);
        } else {
          menu_note(g_menu, l_report, TRUE, l_now);
        }
      } else if (l_id == W_FONT_USE) {
        l_key = Text_justify(menu_field_text(g_menu, W_FONT_NAME));
        settings_set_font(p_settings, l_key);
        settings_set_font_file(p_settings, "");
        if (l_key != "") menu_note(g_menu, "If " + l_key + " isn't installed, Windows draws a similar font instead.", FALSE, l_now);
      } else if (l_id == W_DONE) {
        record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
        menu_set_focus(g_menu, 0);
        l_screen = SCREEN_OPTIONS;
      }

    } else if (l_screen == SCREEN_CONTROLS) {
      if (l_id > W_KEY_ROW && l_id <= W_KEY_ROW + BIND_ACTIONS) {
        l_listening = l_id - W_KEY_ROW;
      } else if (l_id > W_KEY_RESET && l_id <= W_KEY_RESET + BIND_ACTIONS) {
        settings_set_bind(p_settings, l_id - W_KEY_RESET, settings_bind_default(l_id - W_KEY_RESET));
      } else if (l_id == W_RESET_KEYS) {
        settings_reset_binds(p_settings);
      } else if (l_id == W_DONE) {
        l_listening = 0;
        record_set_integer(g_menu, ATTR_MENU_SCROLL, 0);
        // opened from the game menu: Done goes back to it
        if (p_screen == SCREEN_CONTROLS) {
          l_doit = FALSE;
        } else {
          l_screen = SCREEN_OPTIONS;
        }
      }

    } else if (l_screen == SCREEN_PLAYER) {
      if (l_id == W_DONE) {
        settings_set_text(p_settings, ATTR_SET_PLAYER_NAME, Text_justify(menu_field_text(g_menu, W_PLAYER_NAME)));
        settings_set_text(p_settings, ATTR_SET_MP_FOLDER, Text_justify(menu_field_text(g_menu, W_FOLDER)));
        menu_set_focus(g_menu, 0);
        l_screen = SCREEN_OPTIONS;
      }
    }
  }

  save_ensure_folder();
  settings_save(p_settings, save_settings_path());
  menu_begin(g_menu);   // the options' widgets are gone
  return l_result;
}

#endif
