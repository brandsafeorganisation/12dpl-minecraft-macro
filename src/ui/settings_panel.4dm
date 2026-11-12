#ifndef SETTINGS_PANEL_4DM_INCLUDED
#define SETTINGS_PANEL_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/records.h"
#include "../../include/program/settings.h"
#include "../../include/program/save.h"
#include "../../include/ui/panels.h"
#include "../../include/program/game.h"
#include "../../include/ui/font.h"

// ----------------------------------------------------------------
// The settings panel: every setting is a line showing its value and
// a row of buttons that change it. 12d buttons can't change their
// own text, so the value is shown in a message box above them.
// Button replies start with "set_" so they can't be confused with
// the other panels' buttons.
// ----------------------------------------------------------------

void settings_panel_show(Attributes &p_settings, Colour_Message_Box p_render_row, Colour_Message_Box p_detail_row,
                         Colour_Message_Box p_fov_row, Colour_Message_Box p_mouse_row, Colour_Message_Box p_plants_row,
                         Colour_Message_Box p_shading_row, Colour_Message_Box p_jump_row, Colour_Message_Box p_hud_row,
                         Colour_Message_Box p_debug_row, Colour_Message_Box p_pack_row, Colour_Message_Box p_font_row)
// ----------------------------------------------------------------
// Show the current value of every setting
// ----------------------------------------------------------------
{
  Set_data(p_render_row , settings_describe(p_settings, ATTR_SET_RENDER_DISTANCE));
  Set_data(p_detail_row , settings_describe(p_settings, ATTR_SET_DETAIL));
  Set_data(p_fov_row    , settings_describe(p_settings, ATTR_SET_FOV));
  Set_data(p_mouse_row  , settings_describe(p_settings, ATTR_SET_SENSITIVITY));
  Set_data(p_plants_row , settings_describe(p_settings, ATTR_SET_PLANTS));
  Set_data(p_shading_row, settings_describe(p_settings, ATTR_SET_SHADING));
  Set_data(p_jump_row   , settings_describe(p_settings, ATTR_SET_AUTO_JUMP));
  Set_data(p_hud_row    , settings_describe(p_settings, ATTR_SET_SHOW_HUD));
  Set_data(p_debug_row  , settings_describe(p_settings, ATTR_SET_SHOW_DEBUG));
  Set_data(p_pack_row   , settings_describe(p_settings, ATTR_SET_RESOURCE_PACK));
  Set_data(p_font_row   , settings_describe(p_settings, ATTR_SET_FONT));
}

Integer settings_panel_run(Attributes &p_settings)
// ----------------------------------------------------------------
// Show the settings until Done is pressed; changes apply straight
// away and are saved to the settings file when the panel closes
// Returns 0, or SHUTDOWN_CODE if 12d asked the macro to stop
// ----------------------------------------------------------------
{
  Text               l_title          = GAME_TITLE;
  Panel              l_panel          = Create_panel(l_title + " - settings");
  Vertical_Group     l_vgroup         = Create_vertical_group(0);
  Colour_Message_Box l_message        = Create_colour_message_box("");

  Colour_Message_Box l_render_row     = Create_colour_message_box("");
  Horizontal_Group   l_render_buttons = Create_button_group();
  Button             l_render_less    = Create_button("- Shorter view", "set_render_down");
  Button             l_render_more    = Create_button("Longer view +", "set_render_up");
  Button             l_render_most    = Create_button("Furthest", "set_render_max");

  Colour_Message_Box l_detail_row     = Create_colour_message_box("");
  Horizontal_Group   l_detail_buttons = Create_button_group();
  Button             l_detail_low     = Create_button("Low", "set_detail_low");
  Button             l_detail_normal  = Create_button("Normal", "set_detail_normal");
  Button             l_detail_high    = Create_button("High", "set_detail_high");

  Colour_Message_Box l_fov_row        = Create_colour_message_box("");
  Horizontal_Group   l_fov_buttons    = Create_button_group();
  Button             l_fov_less       = Create_button("- Narrower", "set_fov_down");
  Button             l_fov_more       = Create_button("Wider +", "set_fov_up");

  Colour_Message_Box l_mouse_row      = Create_colour_message_box("");
  Horizontal_Group   l_mouse_buttons  = Create_button_group();
  Button             l_mouse_less     = Create_button("- Slower", "set_mouse_down");
  Button             l_mouse_more     = Create_button("Faster +", "set_mouse_up");

  Colour_Message_Box l_plants_row     = Create_colour_message_box("");
  Colour_Message_Box l_shading_row    = Create_colour_message_box("");
  Colour_Message_Box l_jump_row       = Create_colour_message_box("");
  Colour_Message_Box l_hud_row        = Create_colour_message_box("");
  Colour_Message_Box l_debug_row      = Create_colour_message_box("");
  Horizontal_Group   l_toggle_buttons = Create_button_group();
  Button             l_plants_toggle  = Create_button("Grass and flowers", "set_plants");
  Button             l_shading_toggle = Create_button("Shadows", "set_shading");
  Button             l_jump_toggle    = Create_button("Auto-jump", "set_jump");
  Button             l_hud_toggle     = Create_button("HUD", "set_hud");
  Button             l_debug_toggle   = Create_button("Statistics", "set_debug");

  Colour_Message_Box l_pack_row       = Create_colour_message_box("");
  File_Box           l_pack_box       = Create_file_box("Resource pack (.zip file or unzipped folder)", l_message, PACK_FILE_BOX_MODE, "*.zip");
  Horizontal_Group   l_pack_buttons   = Create_button_group();
  Button             l_pack_load      = Create_button("Use this resource pack", "set_pack_load");
  Button             l_pack_clear     = Create_button("Built-in textures", "set_pack_clear");

  Colour_Message_Box l_font_row       = Create_colour_message_box("");
  Horizontal_Group   l_font_buttons   = Create_button_group();
  Button             l_font_next      = Create_button("Next font", "set_font_next");
  Button             l_font_default   = Create_button("12d's default", "set_font_default");
  Input_Box          l_font_name_box  = Create_input_box("Font name (any font installed in Windows)", l_message);
  File_Box           l_font_file_box  = Create_file_box("... or a font file (.ttf, .otf or .ttc)", l_message, PACK_FILE_BOX_MODE, "*.ttf");
  Horizontal_Group   l_font_use       = Create_button_group();
  Button             l_font_name_use  = Create_button("Use this font name", "set_font_name");
  Button             l_font_file_use  = Create_button("Use this font file", "set_font_file");

  Horizontal_Group   l_end_buttons    = Create_button_group();
  Button             l_reset_button   = Create_button("Reset to defaults", "set_defaults");
  Button             l_done_button    = Create_finish_button("Done", "set_done");

  Integer            l_result         = 0;
  Integer            l_doit           = TRUE;
  Integer64          l_id             = 0;
  Text               l_cmd            = "";
  Text               l_msg            = "";
  Text               l_pack           = "";
  Text               l_report         = "";
  Text               l_font           = "";

  Append(l_render_less, l_render_buttons);
  Append(l_render_more, l_render_buttons);
  Append(l_render_most, l_render_buttons);
  Append(l_detail_low   , l_detail_buttons);
  Append(l_detail_normal, l_detail_buttons);
  Append(l_detail_high  , l_detail_buttons);
  Append(l_fov_less, l_fov_buttons);
  Append(l_fov_more, l_fov_buttons);
  Append(l_mouse_less, l_mouse_buttons);
  Append(l_mouse_more, l_mouse_buttons);
  Append(l_plants_toggle , l_toggle_buttons);
  Append(l_shading_toggle, l_toggle_buttons);
  Append(l_jump_toggle   , l_toggle_buttons);
  Append(l_hud_toggle    , l_toggle_buttons);
  Append(l_debug_toggle  , l_toggle_buttons);
  Append(l_pack_load , l_pack_buttons);
  Append(l_pack_clear, l_pack_buttons);
  Append(l_font_next   , l_font_buttons);
  Append(l_font_default, l_font_buttons);
  Append(l_font_name_use, l_font_use);
  Append(l_font_file_use, l_font_use);
  Append(l_reset_button, l_end_buttons);
  Append(l_done_button , l_end_buttons);

  Append(l_render_row    , l_vgroup);
  Append(l_render_buttons, l_vgroup);
  Append(l_detail_row    , l_vgroup);
  Append(l_detail_buttons, l_vgroup);
  Append(l_fov_row       , l_vgroup);
  Append(l_fov_buttons   , l_vgroup);
  Append(l_mouse_row     , l_vgroup);
  Append(l_mouse_buttons , l_vgroup);
  Append(l_plants_row    , l_vgroup);
  Append(l_shading_row   , l_vgroup);
  Append(l_jump_row      , l_vgroup);
  Append(l_hud_row       , l_vgroup);
  Append(l_debug_row     , l_vgroup);
  Append(l_toggle_buttons, l_vgroup);
  Append(l_pack_row      , l_vgroup);
  Append(l_pack_box      , l_vgroup);
  Append(l_pack_buttons  , l_vgroup);
  Append(l_font_row      , l_vgroup);
  Append(l_font_buttons  , l_vgroup);
  Append(l_font_name_box , l_vgroup);
  Append(l_font_file_box , l_vgroup);
  Append(l_font_use      , l_vgroup);
  Append(l_end_buttons   , l_vgroup);
  Append(l_message       , l_vgroup);
  Append(l_vgroup        , l_panel);

  Show_widget(l_panel);
  settings_panel_show(p_settings, l_render_row, l_detail_row, l_fov_row, l_mouse_row, l_plants_row, l_shading_row, l_jump_row, l_hud_row, l_debug_row, l_pack_row, l_font_row);
  Set_data(l_pack_box, settings_resource_pack(p_settings));
  Set_data(l_font_name_box, settings_font(p_settings));
  Set_data(l_font_file_box, settings_font_file(p_settings));
  Set_data(l_message, "Longer views and higher detail look better but draw more slowly.");

  while (l_doit) {
    l_id  = 0;
    l_cmd = "";
    l_msg = "";
    if (Wait_on_events(l_id, l_cmd, l_msg) != 0) continue;

    if (l_cmd == "CodeShutdown") {
      Set_exit_code(l_cmd);
      l_result = SHUTDOWN_CODE;
      l_doit   = FALSE;
    } else if (l_cmd == "Panel Quit" || l_cmd == "set_done") {
      l_doit = FALSE;
    } else if (l_cmd == "set_render_down") {
      settings_change(p_settings, ATTR_SET_RENDER_DISTANCE, -1);
    } else if (l_cmd == "set_render_up") {
      settings_change(p_settings, ATTR_SET_RENDER_DISTANCE, 1);
    } else if (l_cmd == "set_render_max") {
      record_set_integer(p_settings, ATTR_SET_RENDER_DISTANCE, RENDER_DISTANCE_MAX);
    } else if (l_cmd == "set_detail_low") {
      record_set_integer(p_settings, ATTR_SET_DETAIL, DETAIL_LOW);
    } else if (l_cmd == "set_detail_normal") {
      record_set_integer(p_settings, ATTR_SET_DETAIL, DETAIL_NORMAL);
    } else if (l_cmd == "set_detail_high") {
      record_set_integer(p_settings, ATTR_SET_DETAIL, DETAIL_HIGH);
    } else if (l_cmd == "set_fov_down") {
      settings_change(p_settings, ATTR_SET_FOV, -1);
    } else if (l_cmd == "set_fov_up") {
      settings_change(p_settings, ATTR_SET_FOV, 1);
    } else if (l_cmd == "set_mouse_down") {
      settings_change(p_settings, ATTR_SET_SENSITIVITY, -1);
    } else if (l_cmd == "set_mouse_up") {
      settings_change(p_settings, ATTR_SET_SENSITIVITY, 1);
    } else if (l_cmd == "set_plants") {
      settings_toggle(p_settings, ATTR_SET_PLANTS);
    } else if (l_cmd == "set_shading") {
      settings_toggle(p_settings, ATTR_SET_SHADING);
    } else if (l_cmd == "set_jump") {
      settings_toggle(p_settings, ATTR_SET_AUTO_JUMP);
    } else if (l_cmd == "set_hud") {
      settings_toggle(p_settings, ATTR_SET_SHOW_HUD);
    } else if (l_cmd == "set_debug") {
      settings_toggle(p_settings, ATTR_SET_SHOW_DEBUG);
    } else if (l_cmd == "set_pack_load") {
      l_pack = "";
      Get_data(l_pack_box, l_pack);
      settings_set_resource_pack(p_settings, l_pack);
      Set_data(l_message, "Loading the resource pack ...");
      if (game_load_textures(p_settings, l_report) == 0) {
        // nothing usable: go back to the built-in textures
        settings_set_resource_pack(p_settings, "");
        l_report = l_report + " Using the built-in textures.";
      }
      Set_data(l_message, l_report);
    } else if (l_cmd == "set_pack_clear") {
      settings_set_resource_pack(p_settings, "");
      Set_data(l_pack_box, "");
      game_load_textures(p_settings, l_report);
      Set_data(l_message, "Using the built-in textures.");
    } else if (l_cmd == "set_font_next") {
      settings_set_font(p_settings, font_next_choice(settings_font(p_settings)));
      settings_set_font_file(p_settings, "");
      Set_data(l_font_name_box, settings_font(p_settings));
      Set_data(l_font_file_box, "");
    } else if (l_cmd == "set_font_default") {
      settings_set_font(p_settings, "");
      settings_set_font_file(p_settings, "");
      Set_data(l_font_name_box, "");
      Set_data(l_font_file_box, "");
      Set_data(l_message, "The default font comes back when the game is next opened.");
    } else if (l_cmd == "set_font_name") {
      l_font = "";
      Get_data(l_font_name_box, l_font);
      settings_set_font(p_settings, l_font);
      settings_set_font_file(p_settings, "");
      Set_data(l_font_file_box, "");
      Set_data(l_message, "If that font isn't installed, Windows draws a similar one instead.");
    } else if (l_cmd == "set_font_file") {
      l_pack = "";
      Get_data(l_font_file_box, l_pack);
      if (font_family_from_file(l_pack, l_font, l_report) == SUCCESS) {
        settings_set_font(p_settings, l_font);
        settings_set_font_file(p_settings, l_pack);
        Set_data(l_font_name_box, l_font);
        Set_data(l_message, "Using " + l_font + ". The font has to be installed in Windows (double click the file, then Install) for 12d to draw with it.");
      } else {
        Set_data(l_message, l_report);
      }
    } else if (l_cmd == "set_defaults") {
      l_pack = settings_resource_pack(p_settings);
      settings_defaults(p_settings);
      settings_set_resource_pack(p_settings, l_pack);   // keep the textures: there's a button for that
      Set_data(l_font_name_box, "");
      Set_data(l_font_file_box, "");
    } else {
      continue;
    }
    settings_panel_show(p_settings, l_render_row, l_detail_row, l_fov_row, l_mouse_row, l_plants_row, l_shading_row, l_jump_row, l_hud_row, l_debug_row, l_pack_row, l_font_row);
  }

  save_ensure_folder();
  if (settings_save(p_settings, save_settings_path()) != SUCCESS) {
    Set_data(l_message, "Couldn't save the settings file.");
  }
  Hide_widget(l_panel);
  return l_result;
}

#endif
