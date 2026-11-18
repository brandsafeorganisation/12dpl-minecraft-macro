#ifndef GAME_PANEL_4DM_INCLUDED
#define GAME_PANEL_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/items/inventory.h"
#include "../../include/player/player.h"
#include "../../include/program/settings.h"
#include "../../include/items/crafting.h"
#include "../../include/render/render.h"
#include "../../include/render/hud.h"
#include "../../include/render/ui.h"
#include "../../include/program/save.h"
#include "../../include/program/game.h"
#include "../../include/program/commands.h"
#include "../../include/ui/panels.h"
#include "../../include/ui/font.h"
#include "../../include/net/net.h"
#include "../../include/render/menu.h"

// ----------------------------------------------------------------
// Real-time play inside a 12d panel
//
// 12dPL has no timer and no key-up events. The game clock is the
// stream of mouse_move events: while the mouse is captured, every
// mouse_move turns the camera by how far the cursor moved from a
// parking spot, then puts the cursor back there (alternating by one
// pixel so each warp makes a fresh event). That gives a steady
// stream of frames with the mouse still. The parking spot is well
// inside the view (PARK_HEIGHT_SHARE up from its bottom), so a quick
// flick doesn't carry the cursor out of it between two events, and
// if it does the cursor is pulled back. Keys arrive in the Keys
// input box, which keeps the keyboard focus: if something inside 12d
// takes it, the game takes it back. The mouse is released with Q,
// when a screen opens, when another window keeps the focus, when the
// mouse keeps leaving the view, or after IDLE_RELEASE_SECONDS without
// input. When paused, a click on the view or a movement key carries
// on.
//
// This is the controller: it is the only place (with the menu and
// settings panels) that names the game's global records, and it
// passes them to the model and view functions it calls.
// ----------------------------------------------------------------

Integer game_panel_split_xy(Text p_msg, Real &p_x, Real &p_y)
// ----------------------------------------------------------------
// Read "x y" from a Draw_Box event message; SUCCESS if found
// ----------------------------------------------------------------
{
  Integer l_space = Find_text(p_msg, " ");

  if (l_space <= 1) return FAILURE;

  From_text(Get_subtext(p_msg, 1, l_space - 1), p_x);
  From_text(Get_subtext(p_msg, l_space + 1, Text_length(p_msg)), p_y);
  return SUCCESS;
}

Integer game_panel_calibrate(Draw_Box p_box, Real p_box_x, Real p_box_y, Integer p_width, Integer p_height, Integer &p_origin_x, Integer &p_origin_y)
// ----------------------------------------------------------------
// Work out how Draw_Box coordinates map to the screen from an event
// at box point (box_x, box_y) and the cursor's screen position:
//   screen x = box x + origin_x,  screen y = origin_y - box y
// Checked against the box's position on screen.
// Returns 0 if good, 1 if the point is outside the box, 2 if the
// mapping looks wrong.
// ----------------------------------------------------------------
{
  Integer l_screen_x = 0;
  Integer l_screen_y = 0;
  Integer l_widget_x = 0;
  Integer l_widget_y = 0;
  Integer l_guess_x  = 0;
  Integer l_guess_y  = 0;

  if (p_box_x < 0.0 || p_box_x > p_width || p_box_y < 0.0 || p_box_y > p_height) return 1;

  Get_cursor_position(l_screen_x, l_screen_y);
  l_guess_x = l_screen_x - Floor(p_box_x);
  l_guess_y = l_screen_y + Floor(p_box_y);

  Get_position(p_box, l_widget_x, l_widget_y);
  if (Absolute(l_guess_x - l_widget_x) > 60 || Absolute(l_guess_y - l_widget_y - p_height) > 80) return 2;

  p_origin_x = l_guess_x;
  p_origin_y = l_guess_y;
  return 0;
}

void game_panel_notice(Draw_Box p_box, Text p_title, Text p_line)
// ----------------------------------------------------------------
// A message over the panorama (loading, errors)
// ----------------------------------------------------------------
{
  Real    l_now    = 0.0;
  Integer l_width  = 0;
  Integer l_height = 0;
  Real    l_w      = 0.0;
  Real    l_h      = 0.0;

  Get_size(p_box, l_width, l_height);
  l_w = l_width;
  l_h = l_height;

  Get_time(l_now);
  Start_batch_draw(p_box);
  render_forget_colour();
  font_apply(p_box, settings_font(g_settings));
  menu_background(p_box, l_w, l_h, FALSE, l_now);
  hud_shadow_text(p_box, l_w / 2.0, l_h / 2.0 + 30.0, 18.0, TEXT_ALIGN_CENTRE, 255, 255, 255, p_title);
  hud_shadow_text(p_box, l_w / 2.0, l_h / 2.0 - 4.0, 14.0, TEXT_ALIGN_CENTRE, 200, 200, 200, p_line);
  End_batch_draw(p_box);
}

void game_panel_dispatch(Real p_now)
// ----------------------------------------------------------------
// Dispatch the events an action caused, straight away
// ----------------------------------------------------------------
{
  game_dispatch_events(g_events, g_event, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_random, g_hud, g_ui, g_net, p_now);
}

Integer game_panel_save()
// ----------------------------------------------------------------
// Save the world being played
// ----------------------------------------------------------------
{
  Integer l_seconds = 0;
  Text    l_clock   = "";

  // when it was last played, for the world list
  Get_time(l_seconds);
  Get_time(l_clock);
  save_note_played(g_info, l_seconds, l_clock);
  return game_save_world(g_game, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_events);
}

void game_panel_close_screen()
// ----------------------------------------------------------------
// Close the open screen, returning carried and grid items
// ----------------------------------------------------------------
{
  Real l_x = 0.0;
  Real l_y = 0.0;
  Real l_z = 0.0;

  player_position(g_player, l_x, l_y, l_z);
  if (ui_screen(g_ui) != SCREEN_NONE) ui_close(g_ui, g_inventory, g_grid, g_events, l_x, l_y + 1.3, l_z);
}

void game_panel_backdrop(Draw_Box p_box, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// The world darkened, behind the options opened from the game menu
// ----------------------------------------------------------------
{
  render_set_shade(MENU_WORLD_SHADE);
  render_world(p_box, p_w, p_h, STATUS_STRIP_HEIGHT, g_player, g_inventory, g_cows, g_drops, g_peers, g_settings, world_time_of_day(g_info), p_now);
  render_set_shade(1.0);
}

void game_panel_render(Draw_Box p_box, Integer p_captured, Real p_frame_ms, Real p_now)
// ----------------------------------------------------------------
// Draw one frame: the 3D view and HUD, or the open screen
// ----------------------------------------------------------------
{
  Integer l_width  = 0;
  Integer l_height = 0;
  Real    l_w      = 0.0;
  Real    l_h      = 0.0;

  Get_size(p_box, l_width, l_height);
  l_w = l_width;
  l_h = l_height;

  Start_batch_draw(p_box);
  render_forget_colour();
  font_apply(p_box, settings_font(g_settings));
  if (ui_screen(g_ui) != SCREEN_NONE) {
    // the screen over the world, darkened
    render_set_shade(MENU_WORLD_SHADE);
    render_world(p_box, l_w, l_h, STATUS_STRIP_HEIGHT, g_player, g_inventory, g_cows, g_drops, g_peers, g_settings, world_time_of_day(g_info), p_now);
    render_set_shade(1.0);
    hud_draw(p_box, l_w, l_h, p_captured, TRUE, g_hud, g_player, g_inventory, g_settings, world_info_seed(g_info),
             world_time_of_day(g_info), p_frame_ms, render_stats_text(), p_now);
    ui_draw (p_box, l_w, l_h, g_ui, g_inventory, g_grid, g_furnaces, g_book);
  } else if (!p_captured) {
    // paused (the game menu), the help or the death screen, over the
    // world darkened
    render_set_shade(MENU_WORLD_SHADE);
    render_world(p_box, l_w, l_h, STATUS_STRIP_HEIGHT, g_player, g_inventory, g_cows, g_drops, g_peers, g_settings, world_time_of_day(g_info), p_now);
    render_set_shade(1.0);
    hud_draw    (p_box, l_w, l_h, p_captured, FALSE, g_hud, g_player, g_inventory, g_settings, world_info_seed(g_info),
                 world_time_of_day(g_info), p_frame_ms, render_stats_text(), p_now);
  } else {
    render_world(p_box, l_w, l_h, STATUS_STRIP_HEIGHT, g_player, g_inventory, g_cows, g_drops, g_peers, g_settings, world_time_of_day(g_info), p_now);
    hud_draw    (p_box, l_w, l_h, p_captured, FALSE, g_hud, g_player, g_inventory, g_settings, world_info_seed(g_info),
                 world_time_of_day(g_info), p_frame_ms, render_stats_text(), p_now);
    // who is playing, top right
    if (net_mode(g_net) != NET_OFF) {
      hud_text(p_box, l_w - 8.0 - 6.5 * Text_length(net_players_text(g_net, g_peers, p_now)), l_h - 8.0, 11.0, TEXT_ALIGN_LEFT,
               228, 228, 228, net_players_text(g_net, g_peers, p_now));
    }
  }
  End_batch_draw(p_box);
}

Integer game_panel_run(Draw_Box p_box, Input_Box p_keys, Text p_world_name, Integer p_mode, Integer p_seed, Integer p_game_mode)
// ----------------------------------------------------------------
// Play a world in the view until the player quits to the title
// screen. mode is the menu's choice: MENU_RESULT_CREATE generates a
// new world from seed in game_mode, MENU_RESULT_PLAY loads the saved
// world, MENU_RESULT_HOST loads it and hosts it for other players,
// MENU_RESULT_JOIN joins the game hosted in the multiplayer folder
// (world name unused). Returns 0, PANEL_CLOSED if the window was
// closed, or SHUTDOWN_CODE if 12d asked the macro to stop.
// ----------------------------------------------------------------
{
  Integer   l_result          = 0;
  Integer   l_button          = 0;
  Integer   l_hover_button    = 0;
  Integer   l_mode            = 0;
  Integer   l_running         = TRUE;
  Integer   l_loaded          = FAILURE;
  Integer64 l_id              = 0;
  Text      l_cmd             = "";
  Text      l_msg             = "";
  Text      l_key             = "";
  Integer   l_chatting        = FALSE;   // a chat line is being typed (T or /)
  Integer   l_was_flying      = FALSE;   // flying before a key that may have toggled it
  Text      l_chat            = "";
  Text      l_reply           = "";
  Text      l_why             = "";
  Real      l_now             = 0.0;
  Real      l_frame_start     = 0.0;
  Real      l_frame_end       = 0.0;
  Real      l_last_frame      = 0.0;
  Real      l_real_dt         = 0.0;
  Real      l_dt              = 0.0;
  Real      l_box_x           = 0.0;
  Real      l_box_y           = 0.0;
  Real      l_move_x          = 0.0;
  Real      l_move_y          = 0.0;
  Real      l_leave_window    = 0.0;
  Real      l_last_input      = 0.0;
  Integer   l_want_frame      = TRUE;
  Integer   l_playing         = FALSE;
  Integer   l_captured        = FALSE;
  Integer   l_start_request   = FALSE;
  Integer   l_start_by_click  = FALSE;
  Integer   l_release         = FALSE;
  Integer   l_has_xy          = FALSE;
  Integer   l_width           = 0;
  Integer   l_height          = 0;
  Integer   l_last_w          = 0;
  Integer   l_last_h          = 0;
  Integer   l_resize_pending  = FALSE;
  Integer   l_origin_x        = 0;
  Integer   l_origin_y        = 0;
  Integer   l_request_x       = 0;
  Integer   l_request_y       = 0;
  Integer   l_seen_x          = 0;
  Integer   l_seen_y          = 0;
  Integer   l_have_seen       = FALSE;
  Integer   l_have_origin     = FALSE;
  Integer   l_warp_x          = 0;
  Integer   l_warp_y          = 0;
  Integer   l_jiggle          = 0;
  Integer   l_confirmed       = FALSE;
  Integer   l_leaves          = 0;
  Integer   l_refocus         = 0;
  Real      l_refocus_window  = 0.0;
  Integer   l_calibration     = 0;
  Real      l_frame_ms        = 0.0;
  Text      l_report          = "";
  Integer   l_open_settings   = FALSE;
  Text      l_problem         = "";
  Text      l_player_name     = settings_player_name(g_settings);
  Text      l_player_id       = "";
  Text      l_folder          = settings_mp_folder(g_settings);
  Integer   l_session         = 0;
  Integer   l_settings_result = 0;
  Real      l_played          = 0.0;   // seconds played since the world opened (for its picture)
  Integer   l_seconds         = 0;
  Text      l_clock           = "";

  Set_focus(p_keys);
  menu_begin(g_menu);   // the title screen's widgets are gone

  // Multiplayer: who you are to the others (a name and a number, so
  // two players with the same name have different logs)
  net_clear(g_net, g_peers, g_net_inbox);
  if (l_player_name == "") Get_user_name(l_player_name);
  l_player_name = net_clean_name(l_player_name);
  l_player_id   = l_player_name + "_" + To_text(random_range(g_random, 1000, 9999));
  Get_time(l_now);

  // Generate or load the world
  if (p_mode == MENU_RESULT_JOIN) {
    game_panel_notice(p_box, "Joining", l_folder);
    l_loaded = game_join(l_folder, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_events,
                         g_hud, g_ui, g_net, g_peers, g_net_inbox, l_player_id, l_player_name, l_now, l_problem);
  } else if (p_mode == MENU_RESULT_CREATE) {
    game_panel_notice(p_box, "Generating world", "Seed " + To_text(p_seed) + " - this takes a few seconds");
    l_loaded = game_new_world(p_world_name, p_seed, p_game_mode, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows,
                            g_drops, g_events, g_hud, g_ui);
    l_problem = "it could not be saved";
  } else {
    game_panel_notice(p_box, "Loading world", p_world_name);
    l_loaded = game_load_world(p_world_name, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows,
                             g_drops, g_events, g_hud, g_ui, l_problem);
    if (l_loaded == SUCCESS && p_mode == MENU_RESULT_HOST) {
      // the session is named after the time, so old logs in the
      // folder (files are never deleted) aren't mistaken for new ones
      l_session = Floor(l_now - Floor(l_now / 1000000000.0) * 1000000000.0);
      l_loaded  = game_host(g_game, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_events,
                            g_net, g_peers, g_net_inbox, l_folder, To_text(l_session), l_player_id, l_player_name,
                            l_now, l_problem);
    }
  }

  if (l_loaded != SUCCESS) {
    // say why, until a click or a key goes back to the title screen
    if (p_mode == MENU_RESULT_JOIN) {
      game_panel_notice(p_box, "Couldn't join the game", l_problem + ". Click to go back.");
    } else {
      game_panel_notice(p_box, "Couldn't open " + p_world_name, l_problem + ". Click to go back.");
    }
    while (l_running) {
      l_id = 0;
      l_cmd = "";
      l_msg = "";
      if (Wait_on_events(l_id, l_cmd, l_msg) != 0) continue;
      if (l_cmd == "CodeShutdown") {
        Set_exit_code(l_cmd);
        return SHUTDOWN_CODE;
      }
      if (l_cmd == "Panel Quit") return PANEL_CLOSED;
      if (l_cmd == "click_lb" || l_cmd == "keystroke" || l_cmd == "text selected") l_running = FALSE;
    }
    return 0;
  }

  game_panel_notice(p_box, "Building the view", "Nearly there");
  game_build_nearby(g_player, settings_render_distance(g_settings));

  // when it was opened, for the world list
  Get_time(l_seconds);
  Get_time(l_clock);
  save_note_played(g_info, l_seconds, l_clock);
  if (net_mode(g_net) == NET_HOST) {
    hud_chat(g_hud, "Hosting as " + l_player_name + ": others press Join game with the multiplayer folder set to " + l_folder, l_now);
  } else if (net_mode(g_net) == NET_GUEST) {
    hud_chat(g_hud, "Joined as " + l_player_name + " (your copy is saved as " + game_world_name(g_game) + ")", l_now);
  }
  Get_size(p_box, l_last_w, l_last_h);
  Get_time(l_now);
  l_last_frame = l_now;
  l_last_input = l_now;

  while (l_running) {
    // ------------------------------------------------ frame
    if (l_want_frame) {
      Get_time(l_frame_start);
      l_real_dt = l_frame_start - l_last_frame;
      if (l_real_dt < 0.0) l_real_dt = 0.0;
      l_dt = l_real_dt;
      if (l_dt > MAX_FRAME_DT) l_dt = MAX_FRAME_DT;
      l_last_frame = l_frame_start;

      l_playing = l_captured && ui_screen(g_ui) == SCREEN_NONE && !hud_help_shown(g_hud) && !player_is_dead(g_player);
      net_poll(g_net, g_peers, g_net_inbox, l_frame_start);
      game_update(l_dt, l_real_dt, l_frame_start, l_playing, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces,
                  g_cows, g_drops, g_events, g_event, g_random, g_settings, g_hud, g_ui, g_net, g_peers, g_net_inbox);

      // Through a portal: the other dimension is made while a notice
      // says where you are going
      if (player_wants_travel(g_player)) {
        if (world_dimension() == DIM_NETHER) {
          game_panel_notice(p_box, "Leaving the Nether", "Building the overworld");
        } else {
          game_panel_notice(p_box, "Entering the Nether", "Building the Nether");
        }
        game_travel(g_info, g_player, g_cows, g_drops, g_furnaces, g_events);
        game_panel_dispatch(l_frame_start);
        game_build_nearby(g_player, settings_render_distance(g_settings));
        Get_time(l_frame_start);
        l_last_frame = l_frame_start;
      }

      // The world's picture for the world list, a couple of seconds in
      if (l_playing && l_played < THUMB_AFTER_SECONDS) {
        l_played = l_played + l_real_dt;
        if (l_played >= THUMB_AFTER_SECONDS) save_take_thumbnail(g_player, THUMB_DISTANCE);
      }

      // A screen is open (crafting table, furnace): free the mouse
      if (ui_screen(g_ui) != SCREEN_NONE && l_captured) {
        l_captured = FALSE;
      }
      if (player_is_dead(g_player) && l_captured) {
        l_captured = FALSE;
      }

      game_panel_render(p_box, l_captured, l_frame_ms, l_frame_start);
      Get_time(l_frame_end);
      l_frame_ms = (l_frame_end - l_frame_start) * 1000.0;
      hud_note_frame(g_hud, l_frame_ms, l_frame_end);
      net_flush(g_net);
      l_want_frame = FALSE;
    }

    // ------------------------------------------------ next event
    l_id  = 0;
    l_cmd = "";
    l_msg = "";
    if (Wait_on_events(l_id, l_cmd, l_msg) != 0) continue;
    Get_time(l_now);

    if (l_cmd == "CodeShutdown") {
      game_panel_close_screen();
      game_panel_save();
      net_leave(g_net);
      Set_exit_code(l_cmd);
      return SHUTDOWN_CODE;
    }
    if (l_cmd == "Panel Quit") {
      // the window was closed: save and stop
      game_panel_close_screen();
      game_panel_save();
      net_leave(g_net);
      return PANEL_CLOSED;
    }

    Get_size(p_box, l_width, l_height);
    l_release        = FALSE;
    l_start_request  = FALSE;
    l_start_by_click = FALSE;
    l_why            = "";

    // The panel was resized: the parking spot moved with the view
    if (l_width != l_last_w || l_height != l_last_h) {
      l_last_w    = l_width;
      l_last_h    = l_height;
      l_have_seen = FALSE;
      if (l_captured) {
        l_release = TRUE;
        l_why     = "the window was resized";
      }
      l_resize_pending = TRUE;
    }
    if (l_cmd == "Panel_Resize") {
      if (l_now - l_last_frame >= 0.1) {
        l_want_frame     = TRUE;
        l_resize_pending = FALSE;
      }
    } else if (l_resize_pending) {
      l_want_frame     = TRUE;
      l_resize_pending = FALSE;
    }

    if (l_id == Get_id64(p_box)) {
      // ------------------------------------------------ mouse
      l_has_xy = game_panel_split_xy(l_msg, l_box_x, l_box_y) == SUCCESS;

      if (l_cmd == "mouse_move" && l_has_xy && l_captured) {
        l_move_x = l_box_x - (l_warp_x + l_jiggle);
        l_move_y = l_box_y - l_warp_y;
        if (Absolute(l_move_x) < 3.0 && Absolute(l_move_y) < 3.0) l_confirmed = TRUE;
        if (Absolute(l_move_x) >= 1.0 || Absolute(l_move_y) >= 1.0) {
          player_turn(g_player, l_move_x * settings_mouse_scale(g_settings), l_move_y * settings_mouse_scale(g_settings));
          l_last_input = l_now;
        }
        // Park the cursor again, even if a quick move took it just
        // outside the view (the parking spot is near the bottom edge)
        l_jiggle = 1 - l_jiggle;
        Set_cursor_position(l_origin_x + l_warp_x + l_jiggle, l_origin_y - l_warp_y);
        l_want_frame = TRUE;

      } else if (l_cmd == "mouse_move" && l_has_xy) {
        // Remember a checked screen mapping so a key or closing a
        // screen can start play without a click
        if (game_panel_calibrate(p_box, l_box_x, l_box_y, l_width, l_height, l_request_x, l_request_y) == 0) {
          l_seen_x    = l_request_x;
          l_seen_y    = l_request_y;
          l_have_seen = TRUE;
        }
        if (ui_screen(g_ui) != SCREEN_NONE) {
          ui_set_mouse(g_ui, l_box_x, l_box_y);
          l_want_frame = TRUE;
        } else {
          // the pause menu lights the button under the mouse
          l_button = hud_pause_button_at(l_width, l_height, l_box_x, l_box_y);
          hud_set_mouse(g_hud, l_box_x, l_box_y);
          if (l_button != l_hover_button) l_want_frame = TRUE;
          l_hover_button = l_button;
          if (l_now - l_last_frame > PAUSED_FRAME_GAP) l_want_frame = TRUE;
        }

      } else if (l_cmd == "mouse_leave" && l_captured) {
        // A fast flick can leave the view between events: pull the
        // cursor back, unless it keeps happening
        if (l_now - l_leave_window > 1.0) {
          l_leave_window = l_now;
          l_leaves       = 0;
        }
        ++l_leaves;
        if (!l_confirmed || l_leaves > LEAVES_BEFORE_RELEASE) {
          l_release = TRUE;
          l_why     = "the mouse left the view";
        } else {
          Set_cursor_position(l_origin_x + l_warp_x + l_jiggle, l_origin_y - l_warp_y);
        }

      } else if (l_captured && (l_cmd == "click_lb_down" || l_cmd == "double_click_lb")) {
        player_primary_action(g_player, g_inventory, g_cows, g_events, g_random, l_now);
        game_panel_dispatch(l_now);
        l_last_input = l_now;
        l_want_frame = TRUE;

      } else if (l_captured && (l_cmd == "click_rb" || l_cmd == "double_click_rb")) {
        player_secondary_action(g_player, g_inventory, g_cows, g_events, l_now);
        game_panel_dispatch(l_now);
        if (ui_screen(g_ui) != SCREEN_NONE) l_release = TRUE;
        l_last_input = l_now;
        l_want_frame = TRUE;

      } else if (!l_captured && ui_screen(g_ui) != SCREEN_NONE && l_has_xy) {
        if (l_cmd == "click_lb" || l_cmd == "double_click_lb") {
          ui_set_mouse(g_ui, l_box_x, l_box_y);
          ui_click(g_ui, g_inventory, g_grid, g_furnaces, g_book, g_events, l_box_x, l_box_y, FALSE, l_width, l_height);
          game_panel_dispatch(l_now);
          l_want_frame = TRUE;
        } else if (l_cmd == "click_rb" || l_cmd == "double_click_rb") {
          ui_set_mouse(g_ui, l_box_x, l_box_y);
          ui_click(g_ui, g_inventory, g_grid, g_furnaces, g_book, g_events, l_box_x, l_box_y, TRUE, l_width, l_height);
          game_panel_dispatch(l_now);
          l_want_frame = TRUE;
        }

      } else if (!l_captured && l_has_xy && (l_cmd == "click_lb" || l_cmd == "click_rb") && hud_menu_help(g_hud)) {
        // The help opened from the game menu: a click goes back to it
        hud_set_help(g_hud, FALSE);
        l_want_frame = TRUE;

      } else if (!l_captured && l_has_xy && l_cmd == "click_lb" && !player_is_dead(g_player) && !hud_help_shown(g_hud) &&
                 hud_pause_button_at(l_width, l_height, l_box_x, l_box_y) != PAUSE_BUTTON_BACK) {
        // The game menu's buttons (a click beside them does nothing)
        l_button = hud_pause_button_at(l_width, l_height, l_box_x, l_box_y);
        if (l_button == PAUSE_BUTTON_OPTIONS) l_open_settings = TRUE;
        if (l_button == PAUSE_BUTTON_CONTROLS) {
          hud_set_help     (g_hud, TRUE);
          hud_set_menu_help(g_hud, TRUE);
        }
        if (l_button == PAUSE_BUTTON_SAVE) {
          if (game_panel_save() == SUCCESS) {
            hud_toast(g_hud, "Saved " + p_world_name, l_now);
          } else {
            hud_toast(g_hud, "Couldn't save " + p_world_name, l_now);
          }
          game_panel_dispatch(l_now);
        }
        if (l_button == PAUSE_BUTTON_MODE) {
          // survival, creative, spectator and round again
          l_mode = GAMEMODE_SURVIVAL;
          if (player_survival(g_player)) l_mode = GAMEMODE_CREATIVE;
          if (player_creative(g_player)) l_mode = GAMEMODE_SPECTATOR;
          player_set_game_mode(g_player, l_mode);
          hud_toast(g_hud, "Game mode: " + player_game_mode_name(l_mode), l_now);
        }
        if (l_button == PAUSE_BUTTON_QUIT) {
          game_panel_close_screen();
          game_panel_save();
          l_running = FALSE;
          continue;
        }
        l_want_frame = TRUE;

      } else if (!l_captured && l_has_xy && (l_cmd == "click_lb" || l_cmd == "click_rb")) {
        // Clicking the view (Back to Game, the help or the death
        // screen) starts or resumes play
        l_calibration = game_panel_calibrate(p_box, l_box_x, l_box_y, l_width, l_height, l_request_x, l_request_y);
        if (l_calibration == 1) {
          hud_toast(g_hud, "Click inside the view to play", l_now);
        } else if (l_calibration == 2) {
          hud_toast(g_hud, "Couldn't grab the mouse: try moving the panel, then click again", l_now);
        } else {
          if (player_is_dead(g_player)) game_respawn(g_info, g_player, g_cows, g_drops, g_furnaces, g_events);
          l_start_request  = TRUE;
          l_start_by_click = TRUE;
        }
        l_want_frame = TRUE;
      }

    } else if (l_id == Get_id64(p_keys)) {
      // ------------------------------------------------ keyboard
      if (l_cmd == "keystroke") {
        l_key = key_name(l_msg);
        l_last_input = l_now;
        // Escape works as Q, except while typing a chat line
        if (l_key == "escape" && !l_chatting) l_key = "q";

        if (l_chatting) {
          // Typing a chat line: every key is text until Enter (or
          // Escape, which drops the line)
          if (l_key == "escape") {
            l_chatting = FALSE;
            l_chat     = "";
          } else {
            l_chat = text_after_key(l_chat, l_msg, CHAT_LONGEST);
          }
          hud_set_chat_input(g_hud, l_chatting, l_chat);
        } else if (ui_screen(g_ui) == SCREEN_CREATIVE) {
          // The creative screen's search takes every key but Escape
          if (Text_lower(l_msg) == "escape") {
            game_panel_close_screen();
            game_panel_dispatch(l_now);
            if (l_have_origin || l_have_seen) l_start_request = TRUE;
          } else {
            ui_type_search(g_ui, l_msg);
          }
        } else if (ui_screen(g_ui) != SCREEN_NONE) {
          if (l_key == "e" || l_key == "q") {
            game_panel_close_screen();
            game_panel_dispatch(l_now);
            if (l_have_origin || l_have_seen) l_start_request = TRUE;
          }
        } else if (player_is_dead(g_player)) {
          if (l_key == "r") {
            game_respawn(g_info, g_player, g_cows, g_drops, g_furnaces, g_events);
            if (l_have_origin || l_have_seen) l_start_request = TRUE;
          }
        } else {
          // Shift can't be seen on its own, but turns w a s d into
          // capitals; a "shift" message is taken too in case 12d sends one
          if (l_key == "shift") player_shift_pressed(g_player, l_now);
          if (l_key == "w" || l_key == "a" || l_key == "s" || l_key == "d" || l_key == " " || l_key == "c") {
            if (l_msg != l_key) player_shift_pressed(g_player, l_now);
            l_was_flying = player_flying(g_player);
            player_key_pressed(g_player, l_key, l_now);
            if (player_flying(g_player) != l_was_flying && player_creative(g_player)) {
              if (l_was_flying) {
                hud_toast(g_hud, "Flying off", l_now);
              } else {
                hud_toast(g_hud, "Flying: Space goes up, Shift or C goes down, double Space lands", l_now);
              }
            }
            // a movement key while paused carries on (the keys only
            // reach the game while its panel has the focus)
            if (!l_captured) {
              if (l_have_origin || l_have_seen) {
                l_start_request = TRUE;
              } else {
                hud_toast(g_hud, "Click the view to carry on", l_now);
              }
            }
          }
          if (Text_length(l_key) == 1 && Find_text("123456789", l_key) > 0) {
            game_select_slot(g_player, g_hud, Find_text("123456789", l_key), l_now);
          }
          if (l_key == "e" && player_spectator(g_player)) {
            hud_toast(g_hud, "Spectators have no inventory (/gamemode survival or creative)", l_now);
          } else if (l_key == "e") {
            // creative mode opens on every item, with a tab for your own inventory
            ui_set_tabs(g_ui, player_creative(g_player));
            if (player_creative(g_player)) {
              emit_event(g_events, EVT_OPEN_SCREEN, SCREEN_CREATIVE, 0, 0, 0, 0.0, 0.0, 0.0, "");
            } else {
              emit_event(g_events, EVT_OPEN_SCREEN, SCREEN_INVENTORY, 0, 0, 0, 0.0, 0.0, 0.0, "");
            }
            game_panel_dispatch(l_now);
            if (l_captured) l_release = TRUE;
          }
          if (l_key == "q" && l_captured) l_release = TRUE;
          if (l_key == "h") {
            hud_set_help(g_hud, !hud_help_shown(g_hud));
            if (hud_help_shown(g_hud) && l_captured) l_release = TRUE;
          }
          if (l_key == "f") player_set_auto_walk(g_player, !player_auto_walk(g_player));
          // X swaps the selected hotbar item with the offhand (F in
          // the block game, where it isn't auto-walk)
          if (l_key == "x") inventory_swap_hands(g_inventory, player_selected(g_player));
          // the camera: your eyes, behind you, in front of you (F5 if
          // 12d passes it on, otherwise V)
          if (l_key == "v" || l_key == "f5") player_next_camera(g_player);
          if (l_key == "j") {
            settings_toggle(g_settings, ATTR_SET_AUTO_JUMP);
            hud_toast(g_hud, settings_describe(g_settings, ATTR_SET_AUTO_JUMP), l_now);
            settings_save(g_settings, save_settings_path());
          }
          if (l_key == "i") {
            settings_toggle(g_settings, ATTR_SET_SHOW_DEBUG);
            settings_save(g_settings, save_settings_path());
          }
          if (l_key == "-" || l_key == "=" || l_key == "+") {
            if (l_key == "-") {
              settings_change(g_settings, ATTR_SET_RENDER_DISTANCE, -1);
            } else {
              settings_change(g_settings, ATTR_SET_RENDER_DISTANCE, 1);
            }
            hud_toast(g_hud, settings_describe(g_settings, ATTR_SET_RENDER_DISTANCE), l_now);
            settings_save(g_settings, save_settings_path());
          }
          if (l_key == "o") l_open_settings = TRUE;
          if (l_key == "p") {
            if (player_pick_block(g_player, g_inventory, l_report)) {
              hud_show_name(g_hud, l_now);
            } else if (l_report != "") {
              hud_toast(g_hud, l_report, l_now);
            }
          }
          if (l_key == "u") {
            settings_toggle(g_settings, ATTR_SET_SHOW_HUD);
            settings_save(g_settings, save_settings_path());
          }
          // T opens the chat line, / opens it with the / typed
          if (l_key == "t" || l_key == "/") {
            l_chatting = TRUE;
            l_chat     = "";
            if (l_key == "/") l_chat = "/";
            hud_set_chat_input(g_hud, TRUE, l_chat);
          }
        }

        Set_data(p_keys, "");
        if (!l_captured) l_want_frame = TRUE;

      } else if (l_cmd == "text selected") {
        // Enter sends a chat line being typed: a command if it starts
        // with /, otherwise something said
        if (l_chatting) {
          if (Get_subtext(l_chat, 1, 1) == "/") {
            hud_chat(g_hud, l_chat, l_now);
            l_reply = command_run(l_chat, g_info, g_player, g_inventory);
            hud_chat(g_hud, l_reply, l_now);
          } else if (l_chat != "") {
            hud_chat(g_hud, "<You> " + l_chat, l_now);
            net_say (g_net, l_chat);
          }
          l_chatting = FALSE;
          l_chat     = "";
          hud_set_chat_input(g_hud, FALSE, "");
          if (!l_captured) l_want_frame = TRUE;
        }
        // Enter takes the focus away; take it back for the game keys
        Set_data(p_keys, "");
        Set_focus(p_keys);
      } else if (l_cmd == "kill_focus" && l_captured) {
        // Something took the keyboard focus (often a click inside 12d
        // itself): take it back, and only give up if it keeps going
        if (l_now - l_refocus_window > 2.0) {
          l_refocus_window = l_now;
          l_refocus        = 0;
        }
        ++l_refocus;
        if (l_refocus > REFOCUS_LIMIT) {
          l_release = TRUE;
          l_why     = "another window has the keyboard";
        } else {
          Set_focus(p_keys);
        }
      }

    }

    // ------------------------------------------------ settings
    if (l_open_settings) {
      l_open_settings = FALSE;
      if (l_captured) {
        l_captured    = FALSE;
        l_have_origin = FALSE;
      }
      l_settings_result = settings_panel_run(p_box, p_keys, g_settings, TRUE);
      if (l_settings_result == SHUTDOWN_CODE || l_settings_result == PANEL_CLOSED) {
        game_panel_close_screen();
        game_panel_save();
        net_leave(g_net);
        return l_settings_result;
      }
      game_build_nearby(g_player, settings_render_distance(g_settings));
      Set_focus(p_keys);
      l_want_frame = TRUE;
    }

    // ------------------------------------------------ grab / free the mouse
    if (l_start_request && !l_captured) {
      // A click carries its own fresh mapping; a key uses the last
      // one seen from the mouse, else the one from the last capture
      if (!l_start_by_click) {
        if (l_have_seen) {
          l_request_x = l_seen_x;
          l_request_y = l_seen_y;
        } else {
          l_request_x = l_origin_x;
          l_request_y = l_origin_y;
        }
      }
      l_origin_x    = l_request_x;
      l_origin_y    = l_request_y;
      l_have_origin = TRUE;
      l_warp_x      = Floor(l_width / 2.0);
      l_warp_y      = Floor(STATUS_STRIP_HEIGHT + (l_height - STATUS_STRIP_HEIGHT) * PARK_HEIGHT_SHARE);
      l_jiggle      = 0;
      l_confirmed   = FALSE;
      l_leaves      = 0;
      l_captured    = TRUE;
      hud_set_help(g_hud, FALSE);
      l_last_input  = l_now;
      Set_cursor_position(l_origin_x + l_warp_x, l_origin_y - l_warp_y);
      Set_focus(p_keys);
      l_want_frame = TRUE;
    }

    if (l_captured && l_now - l_last_input > IDLE_RELEASE_SECONDS) {
      l_release = TRUE;
      l_why     = "no input for a while";
    }
    if (l_release && l_captured) {
      l_captured = FALSE;
      if (l_why != "") hud_toast(g_hud, "Paused: " + l_why, l_now);
      // The panel may have moved: check the mapping again next time
      if (l_why != "") l_have_origin = FALSE;
      l_want_frame = TRUE;
    }
  }

  net_leave(g_net);
  return l_result;
}

#endif
