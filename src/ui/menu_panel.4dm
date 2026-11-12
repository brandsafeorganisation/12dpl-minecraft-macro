#ifndef MENU_PANEL_4DM_INCLUDED
#define MENU_PANEL_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/program/settings.h"
#include "../../include/program/save.h"
#include "../../include/ui/panels.h"

Integer menu_refresh_worlds(List_Box p_world_list)
// ----------------------------------------------------------------
// Fill the list box with the saved worlds; returns how many
// ----------------------------------------------------------------
{
  Dynamic_Text l_names;
  Integer      l_count    = 0;
  Integer      l_existing = 0;
  Integer      l_index    = 0;
  Text         l_name     = "";

  Get_number_of_items(p_world_list, l_existing);
  for (l_index = l_existing; l_index >= 1; --l_index) Delete_item(p_world_list, l_index);

  l_count = save_list_worlds(l_names);
  for (l_index = 1; l_index <= l_count; ++l_index) {
    Get_item(l_names, l_index, l_name);
    Add_item(p_world_list, l_name);
  }
  if (l_count > 0) Set_selection(p_world_list, 1);

  return l_count;
}

Integer menu_panel_run(Attributes &p_game, Attributes &p_random, Attributes &p_settings)
// ----------------------------------------------------------------
// The world menu: pick a saved world to play, delete one, make a
// new one with a name and an optional seed, or change the settings
// Returns a MENU_RESULT_* code (or SHUTDOWN_CODE) and leaves the
// chosen world in the game record (ATTR_MENU_WORLD, ATTR_MENU_SEED)
// ----------------------------------------------------------------
{
  Text               l_title          = GAME_TITLE;
  Panel              l_panel          = Create_panel(l_title + " - worlds");
  Vertical_Group     l_vgroup         = Create_vertical_group(0);
  Colour_Message_Box l_message        = Create_colour_message_box("");
  List_Box           l_world_list     = Create_list_box("Saved worlds", l_message, 8);
  Input_Box          l_name_box       = Create_input_box("New world name", l_message);
  Input_Box          l_seed_box       = Create_input_box("Seed (blank for random)", l_message);
  Horizontal_Group   l_buttons        = Create_button_group();
  Button             l_play_button    = Create_button("&Play selected", "play");
  Button             l_create_button  = Create_button("&Create new world", "create");
  Button             l_delete_button  = Create_button("&Delete selected", "delete");
  Button             l_settings_button= Create_button("&Settings", "menu_settings");
  Button             l_quit_button    = Create_finish_button("Quit", "quit");
  Integer            l_result         = MENU_RESULT_QUIT;
  Integer            l_doit           = TRUE;
  Integer            l_count          = 0;
  Integer            l_selected       = 0;
  Integer64          l_id             = 0;
  Text               l_cmd            = "";
  Text               l_msg            = "";
  Text               l_name           = "";
  Text               l_seed_text      = "";
  Text               l_pending_delete = "";

  Append(l_play_button  , l_buttons);
  Append(l_create_button, l_buttons);
  Append(l_delete_button, l_buttons);
  Append(l_settings_button, l_buttons);
  Append(l_quit_button  , l_buttons);

  Append(l_world_list, l_vgroup);
  Append(l_name_box  , l_vgroup);
  Append(l_seed_box  , l_vgroup);
  Append(l_buttons   , l_vgroup);
  Append(l_message   , l_vgroup);
  Append(l_vgroup    , l_panel);

  Show_widget(l_panel);

  l_count = menu_refresh_worlds(l_world_list);
  Set_data(l_name_box, "World " + To_text(l_count + 1));
  if (l_count == 0) {
    Set_data(l_message, "No saved worlds yet - type a name (and a seed if you like) and press Create new world.");
  } else {
    Set_data(l_message, "Pick a world and press Play, or make a new one.");
  }
  if (record_text(p_game, ATTR_GAME_PACK_REPORT) != "") {
    Set_data(l_message, record_text(p_game, ATTR_GAME_PACK_REPORT));
  }

  while (l_doit) {
    l_id  = 0;
    l_cmd = "";
    l_msg = "";
    if (Wait_on_events(l_id, l_cmd, l_msg) != 0) continue;

    if (l_cmd == "keystroke" || l_cmd == "set_focus" || l_cmd == "kill_focus") continue;

    if (l_cmd == "CodeShutdown") {
      Set_exit_code(l_cmd);
      l_result = SHUTDOWN_CODE;
      l_doit   = FALSE;
    } else if (l_cmd == "Panel Quit" || l_cmd == "quit") {
      l_result = MENU_RESULT_QUIT;
      l_doit   = FALSE;
    } else if (l_cmd == "play") {
      l_selected = 0;
      Get_selection(l_world_list, l_selected);
      if (l_selected < 1) {
        Set_data(l_message, "Select a world in the list first.");
      } else {
        Get_item(l_world_list, l_selected, l_name);
        record_set_text(p_game, ATTR_MENU_WORLD, l_name);
        l_result = MENU_RESULT_PLAY;
        l_doit   = FALSE;
      }
    } else if (l_cmd == "create") {
      Get_data(l_name_box, l_name);
      l_name = Text_justify(l_name);
      Get_data(l_seed_box, l_seed_text);
      l_seed_text = Text_justify(l_seed_text);
      if (!text_is_safe_name(l_name)) {
        Set_data(l_message, "World names can use letters, numbers, spaces, - and _ (up to 40 characters).");
      } else if (save_world_exists(l_name)) {
        Set_data(l_message, "There is already a world called " + l_name + ".");
      } else {
        record_set_text(p_game, ATTR_MENU_WORLD, l_name);
        if (l_seed_text == "") {
          record_set_integer(p_game, ATTR_MENU_SEED, random_range(p_random, 1, 999999999));
        } else {
          record_set_integer(p_game, ATTR_MENU_SEED, text_to_seed(l_seed_text));
        }
        l_result = MENU_RESULT_CREATE;
        l_doit   = FALSE;
      }
    } else if (l_cmd == "menu_settings") {
      if (settings_panel_run(p_settings) == SHUTDOWN_CODE) {
        l_result = SHUTDOWN_CODE;
        l_doit   = FALSE;
      } else {
        Set_data(l_message, "Settings saved.");
      }
    } else if (l_cmd == "delete") {
      l_selected = 0;
      Get_selection(l_world_list, l_selected);
      if (l_selected < 1) {
        Set_data(l_message, "Select a world in the list first.");
      } else {
        Get_item(l_world_list, l_selected, l_name);
        if (l_pending_delete != l_name) {
          l_pending_delete = l_name;
          Set_data(l_message, "Press Delete selected again to delete " + l_name + " for good.");
        } else {
          l_pending_delete = "";
          if (save_delete_world(l_name) == SUCCESS) {
            Set_data(l_message, "Deleted " + l_name + ".");
          } else {
            Set_data(l_message, "Couldn't delete " + l_name + ".");
          }
          menu_refresh_worlds(l_world_list);
        }
      }
    }
  }

  Hide_widget(l_panel);
  return l_result;
}

#endif
