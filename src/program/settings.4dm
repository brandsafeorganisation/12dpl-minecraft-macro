#ifndef SETTINGS_4DM_INCLUDED
#define SETTINGS_4DM_INCLUDED

#include "../../include/core/safety.h"
#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/program/settings.h"

void settings_defaults(Attributes &p_settings)
// ----------------------------------------------------------------
// Fill a settings record with the defaults
// ----------------------------------------------------------------
{
  record_clear      (p_settings, DATATYPE_SETTINGS);
  record_set_integer(p_settings, ATTR_SET_RENDER_DISTANCE, RENDER_DISTANCE_DEFAULT);
  record_set_integer(p_settings, ATTR_SET_DETAIL,          DETAIL_NORMAL);
  record_set_integer(p_settings, ATTR_SET_PLANTS,          TRUE);
  record_set_integer(p_settings, ATTR_SET_SHADING,         TRUE);
  record_set_integer(p_settings, ATTR_SET_AUTO_JUMP,       TRUE);
  record_set_integer(p_settings, ATTR_SET_FOV,             FOV_DEFAULT);
  record_set_integer(p_settings, ATTR_SET_SENSITIVITY,     SENSITIVITY_DEFAULT);
  record_set_integer(p_settings, ATTR_SET_SHOW_HUD,        TRUE);
  record_set_integer(p_settings, ATTR_SET_SHOW_DEBUG,      FALSE);
  record_set_text   (p_settings, ATTR_SET_RESOURCE_PACK,   "");
  record_set_text   (p_settings, ATTR_SET_FONT,            "");
  record_set_text   (p_settings, ATTR_SET_FONT_FILE,       "");
}

Text settings_font_file(Attributes &p_settings)
// ----------------------------------------------------------------
// The font file the font was chosen from, "" if it was chosen by
// name
// ----------------------------------------------------------------
{
  return record_text(p_settings, ATTR_SET_FONT_FILE);
}

void settings_set_font_file(Attributes &p_settings, Text p_path)
// ----------------------------------------------------------------
// Remember the font file the font was chosen from ("" for none)
// ----------------------------------------------------------------
{
  record_set_text(p_settings, ATTR_SET_FONT_FILE, Text_justify(p_path));
}

Text settings_font(Attributes &p_settings)
// ----------------------------------------------------------------
// The font for the game's text, "" for 12d's default
// ----------------------------------------------------------------
{
  return record_text(p_settings, ATTR_SET_FONT);
}

void settings_set_font(Attributes &p_settings, Text p_font)
// ----------------------------------------------------------------
// Choose the font for the game's text ("" for 12d's default)
// ----------------------------------------------------------------
{
  record_set_text(p_settings, ATTR_SET_FONT, Text_justify(p_font));
}

Text settings_resource_pack(Attributes &p_settings)
// ----------------------------------------------------------------
// The resource pack in use (a .zip file or a folder), "" for none
// ----------------------------------------------------------------
{
  return record_text(p_settings, ATTR_SET_RESOURCE_PACK);
}

void settings_set_resource_pack(Attributes &p_settings, Text p_path)
// ----------------------------------------------------------------
// Choose a resource pack ("" for the built-in textures)
// ----------------------------------------------------------------
{
  record_set_text(p_settings, ATTR_SET_RESOURCE_PACK, p_path);
}

Integer settings_render_distance(Attributes &p_settings)
// ----------------------------------------------------------------
// How far the world is drawn, in blocks
// ----------------------------------------------------------------
{
  return clamp_integer(record_integer(p_settings, ATTR_SET_RENDER_DISTANCE), RENDER_DISTANCE_MIN, RENDER_DISTANCE_MAX);
}

Integer settings_detail(Attributes &p_settings)
// ----------------------------------------------------------------
// Texture detail: DETAIL_LOW, DETAIL_NORMAL or DETAIL_HIGH
// ----------------------------------------------------------------
{
  return clamp_integer(record_integer(p_settings, ATTR_SET_DETAIL), DETAIL_LOW, DETAIL_HIGH);
}

Integer settings_flag(Attributes &p_settings, Text p_field)
// ----------------------------------------------------------------
// An on/off setting (plants, shading, auto jump, HUD, debug)
// ----------------------------------------------------------------
{
  return record_integer(p_settings, p_field);
}

Integer settings_fov_degrees(Attributes &p_settings)
// ----------------------------------------------------------------
// Horizontal field of view in degrees
// ----------------------------------------------------------------
{
  return clamp_integer(record_integer(p_settings, ATTR_SET_FOV), FOV_MIN, FOV_MAX);
}

Real settings_fov_radians(Attributes &p_settings)
// ----------------------------------------------------------------
// Horizontal field of view in radians
// ----------------------------------------------------------------
{
  return settings_fov_degrees(p_settings) * PI / 180.0;
}

Real settings_mouse_scale(Attributes &p_settings)
// ----------------------------------------------------------------
// Radians turned per pixel of mouse movement
// ----------------------------------------------------------------
{
  return MOUSE_SENSITIVITY * clamp_integer(record_integer(p_settings, ATTR_SET_SENSITIVITY), SENSITIVITY_MIN, SENSITIVITY_MAX) / SENSITIVITY_DEFAULT;
}

void settings_change(Attributes &p_settings, Text p_field, Integer p_direction)
// ----------------------------------------------------------------
// Step a numeric setting up (direction 1) or down (-1), staying
// within its range
// ----------------------------------------------------------------
{
  Integer l_value = record_integer(p_settings, p_field);

  if (p_field == ATTR_SET_RENDER_DISTANCE) {
    l_value = clamp_integer(l_value + p_direction * RENDER_DISTANCE_STEP, RENDER_DISTANCE_MIN, RENDER_DISTANCE_MAX);
  } else if (p_field == ATTR_SET_DETAIL) {
    l_value = clamp_integer(l_value + p_direction, DETAIL_LOW, DETAIL_HIGH);
  } else if (p_field == ATTR_SET_FOV) {
    l_value = clamp_integer(l_value + p_direction * FOV_STEP, FOV_MIN, FOV_MAX);
  } else if (p_field == ATTR_SET_SENSITIVITY) {
    l_value = clamp_integer(l_value + p_direction, SENSITIVITY_MIN, SENSITIVITY_MAX);
  } else {
    return;
  }
  record_set_integer(p_settings, p_field, l_value);
}

void settings_toggle(Attributes &p_settings, Text p_field)
// ----------------------------------------------------------------
// Flip an on/off setting
// ----------------------------------------------------------------
{
  record_set_integer(p_settings, p_field, !record_integer(p_settings, p_field));
}

Text settings_describe(Attributes &p_settings, Text p_field)
// ----------------------------------------------------------------
// One line describing the current value of a setting
// ----------------------------------------------------------------
{
  Integer l_value  = 0;
  Text    l_on_off = "Off";

  if (p_field == ATTR_SET_RESOURCE_PACK) {
    if (settings_resource_pack(p_settings) == "") return "Textures: built in";
    return "Textures: " + settings_resource_pack(p_settings);
  }
  if (p_field == ATTR_SET_FONT) {
    if (settings_font(p_settings) == "") return "Font: 12d's default";
    return "Font: " + settings_font(p_settings);
  }

  l_value = record_integer(p_settings, p_field);
  if (l_value) l_on_off = "On";

  if (p_field == ATTR_SET_RENDER_DISTANCE) return "Render distance: " + To_text(settings_render_distance(p_settings)) + " blocks";
  if (p_field == ATTR_SET_FOV            ) return "Field of view: " + To_text(settings_fov_degrees(p_settings)) + " degrees";
  if (p_field == ATTR_SET_SENSITIVITY    ) return "Mouse sensitivity: " + To_text(l_value) + " / " + To_text(SENSITIVITY_MAX);
  if (p_field == ATTR_SET_DETAIL) {
    if (l_value == DETAIL_LOW ) return "Texture detail: Low (textures only up close)";
    if (l_value == DETAIL_HIGH) return "Texture detail: High (full textures further out)";
    return "Texture detail: Normal";
  }
  if (p_field == ATTR_SET_PLANTS    ) return "Grass and flowers: " + l_on_off;
  if (p_field == ATTR_SET_SHADING   ) return "Shadows and corner shading: " + l_on_off;
  if (p_field == ATTR_SET_AUTO_JUMP ) return "Auto-jump: " + l_on_off;
  if (p_field == ATTR_SET_SHOW_HUD  ) return "Show HUD: " + l_on_off;
  if (p_field == ATTR_SET_SHOW_DEBUG) return "Show position and frame statistics: " + l_on_off;
  return p_field;
}

Text settings_line(Text p_name, Integer p_value)
// ----------------------------------------------------------------
// "name value", one line of the settings file
// ----------------------------------------------------------------
{
  return p_name + " " + To_text(p_value);
}

Integer settings_save(Attributes &p_settings, Text p_path)
// ----------------------------------------------------------------
// Write the settings as "name value" lines. Returns SUCCESS or
// FAILURE. The resource pack, font and font file lines keep the rest
// of the line as the path or name, so they may contain spaces.
// ----------------------------------------------------------------
{
  File l_file;
  Text l_pack_line = "";
  Text l_font_line = ATTR_SET_FONT;
  Text l_file_line = ATTR_SET_FONT_FILE;

  if (safe_file_open(p_path, "w", l_file) != 0) return FAILURE;

  File_write_line(l_file, settings_line(ATTR_SET_RENDER_DISTANCE, settings_render_distance(p_settings)));
  File_write_line(l_file, settings_line(ATTR_SET_DETAIL, settings_detail(p_settings)));
  File_write_line(l_file, settings_line(ATTR_SET_PLANTS, settings_flag(p_settings, ATTR_SET_PLANTS)));
  File_write_line(l_file, settings_line(ATTR_SET_SHADING, settings_flag(p_settings, ATTR_SET_SHADING)));
  File_write_line(l_file, settings_line(ATTR_SET_AUTO_JUMP, settings_flag(p_settings, ATTR_SET_AUTO_JUMP)));
  File_write_line(l_file, settings_line(ATTR_SET_FOV, settings_fov_degrees(p_settings)));
  File_write_line(l_file, settings_line(ATTR_SET_SENSITIVITY, record_integer(p_settings, ATTR_SET_SENSITIVITY)));
  File_write_line(l_file, settings_line(ATTR_SET_SHOW_HUD, settings_flag(p_settings, ATTR_SET_SHOW_HUD)));
  File_write_line(l_file, settings_line(ATTR_SET_SHOW_DEBUG, settings_flag(p_settings, ATTR_SET_SHOW_DEBUG)));
  l_pack_line = ATTR_SET_RESOURCE_PACK;
  File_write_line(l_file, l_pack_line + " " + settings_resource_pack(p_settings));
  File_write_line(l_file, l_font_line + " " + settings_font(p_settings));
  File_write_line(l_file, l_file_line + " " + settings_font_file(p_settings));

  File_close(l_file);
  return SUCCESS;
}

Integer settings_load(Attributes &p_settings, Text p_path)
// ----------------------------------------------------------------
// Start from the defaults and apply any "name value" lines found in
// the file. Unknown names are ignored. Returns SUCCESS, or FAILURE
// if there is no file (the defaults are kept).
// ----------------------------------------------------------------
{
  File         l_file;
  Text         l_line      = "";
  Text         l_name      = "";
  Text         l_word      = "";
  Integer      l_value     = 0;
  Integer      l_count     = 0;
  Text         l_pack      = ATTR_SET_RESOURCE_PACK;
  Integer      l_skip      = 0;
  Text         l_font      = ATTR_SET_FONT;
  Integer      l_font_skip = 0;
  Text         l_path_name = ATTR_SET_FONT_FILE;
  Integer      l_path_skip = 0;
  Dynamic_Text l_words;

  settings_defaults(p_settings);
  if (!File_exists(p_path)) return FAILURE;
  if (safe_file_open(p_path, "r", l_file) != 0) return FAILURE;

  l_pack      = l_pack + " ";
  l_skip      = Text_length(l_pack);
  l_font      = l_font + " ";
  l_font_skip = Text_length(l_font);
  l_path_name = l_path_name + " ";
  l_path_skip = Text_length(l_path_name);
  while (File_read_line(l_file, l_line) == 0) {
    if (Text_length(l_line) > l_skip) {
      if (Get_subtext(l_line, 1, l_skip) == l_pack) {
        settings_set_resource_pack(p_settings, Get_subtext(l_line, l_skip + 1, Text_length(l_line)));
        continue;
      }
    }
    if (Text_length(l_line) > l_path_skip) {
      if (Get_subtext(l_line, 1, l_path_skip) == l_path_name) {
        settings_set_font_file(p_settings, Get_subtext(l_line, l_path_skip + 1, Text_length(l_line)));
        continue;
      }
    }
    if (Text_length(l_line) > l_font_skip) {
      if (Get_subtext(l_line, 1, l_font_skip) == l_font) {
        settings_set_font(p_settings, Get_subtext(l_line, l_font_skip + 1, Text_length(l_line)));
        continue;
      }
    }
    Null(l_words);
    l_count = From_text(l_line, l_words);
    if (l_count < 2) continue;
    Get_item(l_words, 1, l_name);
    Get_item(l_words, 2, l_word);
    if (From_text(l_word, l_value) != 0) continue;
    if (l_name == ATTR_SET_RENDER_DISTANCE || l_name == ATTR_SET_DETAIL    || l_name == ATTR_SET_PLANTS   ||
        l_name == ATTR_SET_SHADING         || l_name == ATTR_SET_AUTO_JUMP || l_name == ATTR_SET_FOV      ||
        l_name == ATTR_SET_SENSITIVITY     || l_name == ATTR_SET_SHOW_HUD  || l_name == ATTR_SET_SHOW_DEBUG) {
      record_set_integer(p_settings, l_name, l_value);
    }
  }

  File_close(l_file);
  return SUCCESS;
}

#endif
