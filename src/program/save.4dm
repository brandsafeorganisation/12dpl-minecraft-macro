#ifndef SAVE_4DM_INCLUDED
#define SAVE_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/world/world.h"
#include "../../include/world/mesh.h"
#include "../../include/items/inventory.h"
#include "../../include/items/furnace.h"
#include "../../include/mobs/cows.h"
#include "../../include/items/drops.h"
#include "../../include/items/chest.h"
#include "../../include/player/player.h"
#include "../../include/core/records.h"
#include "../../include/program/settings.h"
#include "../../include/program/save.h"
#include "../../include/render/render.h"
#include "../../include/render/menu.h"

// ---------------------------------------------------------------- the edit list

void save_clear_edits()
// ----------------------------------------------------------------
// Forget every recorded block change (new or freshly loaded world)
// ----------------------------------------------------------------
{
  g_edit_count       = 0;
  g_edit_overflow    = 0;
  g_other_edit_count = 0;
}

void save_record_edit(Integer p_index, Integer p_block)
// ----------------------------------------------------------------
// Remember that the cell at world index now holds block
// Each cell is listed once, with its latest block
// ----------------------------------------------------------------
{
  Integer l_edit = 0;

  for (l_edit = g_edit_count; l_edit >= 1; --l_edit) {
    if (g_edit_index[l_edit] == p_index) {
      g_edit_block[l_edit] = p_block;
      return;
    }
  }

  if (g_edit_count >= MAX_EDITS) {
    ++g_edit_overflow;
    return;
  }
  ++g_edit_count;
  g_edit_index[g_edit_count] = p_index;
  g_edit_block[g_edit_count] = p_block;
}

void save_record_other_edit(Integer p_index, Integer p_block)
// ----------------------------------------------------------------
// A block change of the other dimension, read from a world file
// ----------------------------------------------------------------
{
  if (g_other_edit_count >= MAX_EDITS) return;
  ++g_other_edit_count;
  g_other_edit_index[g_other_edit_count] = p_index;
  g_other_edit_block[g_other_edit_count] = p_block;
}

void save_swap_edits()
// ----------------------------------------------------------------
// Going through a portal: this dimension's changes are put away and
// the other dimension's become the ones being recorded
// ----------------------------------------------------------------
{
  Integer l_edit  = 0;
  Integer l_count = max_integer(g_edit_count, g_other_edit_count);
  Integer l_keep  = 0;

  for (l_edit = 1; l_edit <= l_count; ++l_edit) {
    l_keep = g_edit_index[l_edit];
    g_edit_index[l_edit] = g_other_edit_index[l_edit];
    g_other_edit_index[l_edit] = l_keep;
    l_keep = g_edit_block[l_edit];
    g_edit_block[l_edit] = g_other_edit_block[l_edit];
    g_other_edit_block[l_edit] = l_keep;
  }
  l_keep = g_edit_count;
  g_edit_count = g_other_edit_count;
  g_other_edit_count = l_keep;
  g_edit_overflow = 0;
}

void save_apply_edits()
// ----------------------------------------------------------------
// Put the recorded changes into the freshly generated blocks (after
// a portal), with the light of any torches and glowstone among them
// ----------------------------------------------------------------
{
  Integer l_edit = 0;
  Integer l_x    = 0;
  Integer l_y    = 0;
  Integer l_z    = 0;

  for (l_edit = 1; l_edit <= g_edit_count; ++l_edit) {
    world_cell_of_index(g_edit_index[l_edit], l_x, l_y, l_z);
    world_set_block(l_x, l_y, l_z, g_edit_block[l_edit]);
  }
  world_finish_maps();
  for (l_edit = 1; l_edit <= g_edit_count; ++l_edit) {
    if (block_light_emission(g_edit_block[l_edit]) == 0) continue;
    world_cell_of_index(g_edit_index[l_edit], l_x, l_y, l_z);
    world_light_update(l_x, l_y, l_z);
  }
}

void save_on_event(Attributes &p_event)
// ----------------------------------------------------------------
// Event handler: record every block change for the world file
// ----------------------------------------------------------------
{
  Integer l_type = event_type(p_event);
  Integer l_x    = event_integer(p_event, 1);
  Integer l_y    = event_integer(p_event, 2);
  Integer l_z    = event_integer(p_event, 3);

  if (!world_in_bounds(l_x, l_y, l_z)) return;

  if (l_type == EVT_BLOCK_BROKEN) {
    save_record_edit(world_index(l_x, l_y, l_z), BLOCK_AIR);
  } else if (l_type == EVT_BLOCK_PLACED) {
    save_record_edit(world_index(l_x, l_y, l_z), event_integer(p_event, 4));
  }
}

Text save_world_folder(Text p_name)
// ----------------------------------------------------------------
// Folder holding a world (see WORLD_LEVEL_FILE)
// ----------------------------------------------------------------
{
  Text l_folder = WORLD_FOLDER;

  return l_folder + "\\" + p_name;
}

Text save_level_path(Text p_name)
// ----------------------------------------------------------------
// A world's level file: the world, player and inventory records
// ----------------------------------------------------------------
{
  Text l_file      = WORLD_LEVEL_FILE;
  Text l_extension = WORLD_EXTENSION;

  return save_world_folder(p_name) + "\\" + l_file + l_extension;
}

Text save_region_path(Text p_name, Integer p_dimension)
// ----------------------------------------------------------------
// File holding one dimension of a world: its block changes, mobs,
// drops, furnaces and chests (the Nether's in a folder of its own)
// ----------------------------------------------------------------
{
  Text l_file      = WORLD_REGION_FILE;
  Text l_extension = WORLD_EXTENSION;
  Text l_nether    = WORLD_NETHER_FOLDER;

  if (p_dimension == DIM_NETHER) return save_world_folder(p_name) + "\\" + l_nether + "\\" + l_file + l_extension;
  return save_world_folder(p_name) + "\\" + l_file + l_extension;
}

Text save_legacy_path(Text p_name)
// ----------------------------------------------------------------
// The single file an older version saved a world in
// ----------------------------------------------------------------
{
  Text l_folder    = WORLD_FOLDER;
  Text l_extension = WORLD_EXTENSION;

  return l_folder + "\\" + p_name + l_extension;
}

Integer save_file_in_use(Text p_path)
// ----------------------------------------------------------------
// TRUE if a world file is there and not marked deleted
// ----------------------------------------------------------------
{
  if (!File_exists(p_path)) return FALSE;
  return !save_file_is_deleted(p_path);
}

Text save_world_path(Text p_name)
// ----------------------------------------------------------------
// The file that describes a world (the about and thumb lines): its
// level file, or the single file of a world saved by an older
// version that hasn't been saved since
// ----------------------------------------------------------------
{
  if (!save_file_in_use(save_level_path(p_name)) && save_file_in_use(save_legacy_path(p_name))) return save_legacy_path(p_name);
  return save_level_path(p_name);
}

Text save_settings_path()
// ----------------------------------------------------------------
// File holding the settings (shared by every world)
// ----------------------------------------------------------------
{
  Text l_folder = WORLD_FOLDER;
  Text l_file   = SETTINGS_FILE;

  return l_folder + "\\" + l_file;
}

void save_ensure_folder()
// ----------------------------------------------------------------
// Make the worlds folder if it isn't there yet
// ----------------------------------------------------------------
{
  if (!Directory_exists(WORLD_FOLDER)) Directory_create(WORLD_FOLDER);
}

Integer save_file_is_deleted(Text p_path)
// ----------------------------------------------------------------
// TRUE if a world file only holds the "deleted" marker that
// save_delete_world() leaves behind (safety.h forbids deleting
// files, so a deleted world is emptied instead)
// ----------------------------------------------------------------
{
  File    l_file;
  Text    l_line    = "";
  Integer l_deleted = FALSE;

  if (safe_file_open(p_path, "r", l_file) != 0) return FALSE;
  if (File_read_line(l_file, l_line) == 0) {
    if (l_line == WORLD_DELETED_TAG) l_deleted = TRUE;
  }
  File_close(l_file);
  return l_deleted;
}

Integer save_world_exists(Text p_name)
// ----------------------------------------------------------------
// TRUE if a world of this name has been saved (and not deleted)
// ----------------------------------------------------------------
{
  if (p_name == "") return FALSE;
  if (save_file_in_use(save_level_path(p_name))) return TRUE;
  return save_file_in_use(save_legacy_path(p_name));
}

Integer save_list_worlds(Dynamic_Text &p_names)
// ----------------------------------------------------------------
// Names of every saved world (world folders, and the single files of
// older versions); returns how many there are
// ----------------------------------------------------------------
{
  Attributes l_found;
  Dynamic_Text l_files;
  Integer      l_count    = 0;
  Integer      l_file     = 0;
  Integer      l_listed   = 0;
  Text         l_path     = "";
  Text         l_pattern  = "*";
  Text         l_title    = "";

  Null(p_names);
  save_ensure_folder();
  record_clear(l_found, DATATYPE_WORLD_LIST);

  if (List_subfolders_in_folder(WORLD_FOLDER, "*", l_count, l_files) == 0) {
    for (l_file = 1; l_file <= l_count; ++l_file) {
      Get_item(l_files, l_file, l_path);
      l_title = save_file_name(l_path);
      if (l_title == "" || l_title == "." || l_title == "..") continue;
      if (!save_file_in_use(save_level_path(l_title))) continue;
      record_set_integer(l_found, l_title, TRUE);
      Append(l_title, p_names);
      ++l_listed;
    }
  }

  Null(l_files);
  l_count   = 0;
  l_pattern = l_pattern + WORLD_EXTENSION;
  if (List_files_in_folder(WORLD_FOLDER, l_pattern, l_count, l_files) == 0) {
    for (l_file = 1; l_file <= l_count; ++l_file) {
      Get_item(l_files, l_file, l_path);
      l_title = file_title_from_path(l_path);
      if (l_title == "") continue;
      if (record_integer(l_found, l_title) == TRUE) continue;
      if (!save_file_in_use(save_legacy_path(l_title))) continue;
      record_set_integer(l_found, l_title, TRUE);
      Append(l_title, p_names);
      ++l_listed;
    }
  }
  return l_listed;
}

Integer save_mark_deleted(Text p_path)
// ----------------------------------------------------------------
// Overwrite a world file with WORLD_DELETED_TAG (deleting files is
// blocked by safety.h), if it is there
// ----------------------------------------------------------------
{
  File l_file;

  if (!File_exists(p_path)) return SUCCESS;
  if (safe_file_open(p_path, "w", l_file) != 0) return FAILURE;
  File_write_line(l_file, WORLD_DELETED_TAG);
  File_close(l_file);
  return SUCCESS;
}

Integer save_delete_world(Text p_name)
// ----------------------------------------------------------------
// Delete a saved world. Deleting files is blocked by safety.h, so
// its files are overwritten with WORLD_DELETED_TAG instead: the menu
// no longer lists it and a new world can reuse the name. The emptied
// files can be removed by hand from the worlds folder.
// ----------------------------------------------------------------
{
  Integer l_result = SUCCESS;

  if (!save_world_exists(p_name)) return FAILURE;
  if (save_mark_deleted(save_level_path(p_name))              != SUCCESS) l_result = FAILURE;
  if (save_mark_deleted(save_region_path(p_name, DIM_OVERWORLD)) != SUCCESS) l_result = FAILURE;
  if (save_mark_deleted(save_region_path(p_name, DIM_NETHER))    != SUCCESS) l_result = FAILURE;
  if (save_mark_deleted(save_legacy_path(p_name))             != SUCCESS) l_result = FAILURE;
  return l_result;
}

// ---------------------------------------------------------------- the world list

void save_clear_thumbnail()
// ----------------------------------------------------------------
// The world being played has no picture yet
// ----------------------------------------------------------------
{
  g_thumb_ready = 0;
}

Integer save_thumbnail_ready()
// ----------------------------------------------------------------
// TRUE once the world being played has a picture
// ----------------------------------------------------------------
{
  return g_thumb_ready;
}

void save_take_thumbnail(Attributes &p_player, Real p_distance)
// ----------------------------------------------------------------
// Take the world's picture from the player's eyes, the way they
// look, by following a ray through each of its cells
// ----------------------------------------------------------------
{
  Integer l_row     = 0;
  Integer l_column  = 0;
  Real    l_x       = 0.0;
  Real    l_y       = 0.0;
  Real    l_z       = 0.0;
  Real    l_yaw     = 0.0;
  Real    l_pitch   = 0.0;
  Real    l_spread  = Sin(THUMB_FIELD_OF_VIEW / 2.0) / Cos(THUMB_FIELD_OF_VIEW / 2.0);
  Real    l_across  = 0.0;
  Real    l_up      = 0.0;
  Real    l_fwd_x   = 0.0;
  Real    l_fwd_y   = 0.0;
  Real    l_fwd_z   = 0.0;
  Real    l_up_x    = 0.0;
  Real    l_up_y    = 0.0;
  Real    l_up_z    = 0.0;
  Real    l_right_x = 0.0;
  Real    l_right_z = 0.0;

  player_position(p_player, l_x, l_y, l_z);
  player_look    (p_player, l_yaw, l_pitch);
  l_y       = player_eye_y(p_player);
  l_fwd_x   =  Cos(l_pitch) * Cos(l_yaw);
  l_fwd_y   =  Sin(l_pitch);
  l_fwd_z   =  Cos(l_pitch) * Sin(l_yaw);
  l_right_x = -Sin(l_yaw);
  l_right_z =  Cos(l_yaw);
  l_up_x    = -Sin(l_pitch) * Cos(l_yaw);
  l_up_y    =  Cos(l_pitch);
  l_up_z    = -Sin(l_pitch) * Sin(l_yaw);
  for (l_row = 1; l_row <= THUMB_SIZE; ++l_row) {
    l_up = (1.0 - (l_row - 0.5) * 2.0 / THUMB_SIZE) * l_spread;
    for (l_column = 1; l_column <= THUMB_SIZE; ++l_column) {
      l_across = ((l_column - 0.5) * 2.0 / THUMB_SIZE - 1.0) * l_spread;
      g_thumb_now[(l_row - 1) * THUMB_SIZE + l_column] =
        render_ray_colour(l_x, l_y, l_z, l_fwd_x + l_right_x * l_across + l_up_x * l_up, l_fwd_y + l_up_y * l_up,
                          l_fwd_z + l_right_z * l_across + l_up_z * l_up, p_distance);
    }
  }
  g_thumb_ready = 1;
}

Integer save_thumbnail_colour(Integer p_cell)
// ----------------------------------------------------------------
// Colour of cell n (1..THUMB_CELLS) of the playing world's picture
// ----------------------------------------------------------------
{
  if (p_cell < 1 || p_cell > THUMB_CELLS) return 0;
  return g_thumb_now[p_cell];
}

Text save_hex_colour(Integer p_colour)
// ----------------------------------------------------------------
// A colour as six hex digits ("rrggbb")
// ----------------------------------------------------------------
{
  Text    l_digits = "0123456789abcdef";
  Text    l_result = "";
  Integer l_value  = clamp_integer(p_colour, 0, 16777215);
  Integer l_digit  = 0;
  Integer l_count  = 0;

  for (l_count = 1; l_count <= 6; ++l_count) {
    l_digit  = l_value - floor_divide(l_value, 16) * 16;
    l_value  = floor_divide(l_value, 16);
    l_result = Get_subtext(l_digits, l_digit + 1, l_digit + 1) + l_result;
  }
  return l_result;
}

Integer save_hex_value(Text p_text, Integer p_position, Integer p_digits)
// ----------------------------------------------------------------
// The number written in hex by digits characters of text from
// position (0 for anything that isn't a hex digit)
// ----------------------------------------------------------------
{
  Integer l_value = 0;
  Integer l_code  = 0;
  Integer l_digit = 0;
  Integer l_count = 0;

  for (l_count = 0; l_count < p_digits; ++l_count) {
    l_code  = 48;
    Get_char(p_text, p_position + l_count, l_code);
    l_digit = 0;
    if (l_code >= 48 && l_code <= 57 ) l_digit = l_code - 48;
    if (l_code >= 97 && l_code <= 102) l_digit = l_code - 87;
    if (l_code >= 65 && l_code <= 70 ) l_digit = l_code - 55;
    l_value = l_value * 16 + l_digit;
  }
  return l_value;
}

void save_note_played(Attributes &p_info, Integer p_seconds, Text p_clock)
// ----------------------------------------------------------------
// When the world was played (for the world list): seconds since
// 1970 and the clock as 12d gives it ("Sun Nov 15 14:03:22 2026")
// ----------------------------------------------------------------
{
  record_set_integer(p_info, ATTR_SAVE_PLAYED, p_seconds);
  record_set_text   (p_info, ATTR_SAVE_PLAYED_TEXT, save_date_text(p_clock));
}

Text save_date_text(Text p_clock)
// ----------------------------------------------------------------
// "15 Nov 2026, 14:03" from a clock "Sun Nov 15 14:03:22 2026"
// ("" if it isn't one)
// ----------------------------------------------------------------
{
  Dynamic_Text l_words;
  Integer      l_count = 0;
  Text         l_month = "";
  Text         l_day   = "";
  Text         l_time  = "";
  Text         l_year  = "";

  l_count = From_text(p_clock, l_words);
  if (l_count < 5) return "";
  Get_item(l_words, 2, l_month);
  Get_item(l_words, 3, l_day);
  Get_item(l_words, 4, l_time);
  Get_item(l_words, 5, l_year);
  return l_day + " " + l_month + " " + l_year + ", " + Get_subtext(l_time, 1, 5);
}

Integer save_read_about(Text p_path, Attributes &p_list, Integer p_entry)
// ----------------------------------------------------------------
// Read the about and thumb lines at the top of a world file into
// entry n of the world list (and its picture into the list's table).
// A world saved before they were written has its game mode read
// from its player record instead. Returns SUCCESS or FAILURE.
// ----------------------------------------------------------------
{
  File         l_file;
  Dynamic_Text l_words;
  Text         l_line   = "";
  Text         l_key    = "";
  Text         l_word   = "";
  Text         l_date   = "";
  Integer      l_count  = 0;
  Integer      l_word_n = 0;
  Integer      l_row    = 0;
  Integer      l_column = 0;
  Integer      l_base   = (p_entry - 1) * THUMB_CELLS;
  Integer      l_about  = FALSE;

  record_set_integer_at(p_list, ATTR_WL_PLAYED, p_entry, 0);
  record_set_text_at   (p_list, ATTR_WL_DATE, p_entry, "");
  record_set_integer_at(p_list, ATTR_WL_MODE, p_entry, -1);
  record_set_integer_at(p_list, ATTR_WL_VERSION, p_entry, 0);
  record_set_text_at   (p_list, ATTR_WL_VERSION_TEXT, p_entry, "");
  record_set_integer_at(p_list, ATTR_WL_THUMB, p_entry, FALSE);
  if (p_entry < 1 || p_entry > MAX_LISTED_WORLDS) return FAILURE;
  if (safe_file_open(p_path, "r", l_file) != 0) return FAILURE;

  while (File_read_line(l_file, l_line) == 0) {
    Null(l_words);
    l_count = From_text(l_line, l_words);
    if (l_count < 1) continue;
    Get_item(l_words, 1, l_key);
    if (l_key == "about" && l_count >= 5) {
      l_about = TRUE;
      record_set_integer_at(p_list, ATTR_WL_VERSION, p_entry, save_word_integer(l_words, 2));
      record_set_integer_at(p_list, ATTR_WL_PLAYED , p_entry, save_word_integer(l_words, 3));
      record_set_integer_at(p_list, ATTR_WL_MODE   , p_entry, save_word_integer(l_words, 4));
      Get_item(l_words, 5, l_word);
      record_set_text_at(p_list, ATTR_WL_VERSION_TEXT, p_entry, l_word);
      l_date = "";
      for (l_word_n = 6; l_word_n <= l_count; ++l_word_n) {
        Get_item(l_words, l_word_n, l_word);
        if (l_date != "") l_date = l_date + " ";
        l_date = l_date + l_word;
      }
      record_set_text_at(p_list, ATTR_WL_DATE, p_entry, l_date);
    } else if (l_key == "thumb" && l_count >= 3) {
      l_row = save_word_integer(l_words, 2);
      Get_item(l_words, 3, l_word);
      if (l_row < 1 || l_row > THUMB_SIZE || Text_length(l_word) < 6 * THUMB_SIZE) continue;
      for (l_column = 1; l_column <= THUMB_SIZE; ++l_column) {
        g_thumb_list[l_base + (l_row - 1) * THUMB_SIZE + l_column] = save_hex_value(l_word, (l_column - 1) * 6 + 1, 6);
      }
      if (l_row == THUMB_SIZE) record_set_integer_at(p_list, ATTR_WL_THUMB, p_entry, TRUE);
    } else if (l_key == "seed" && l_about) {
      break;
    } else if (l_key == "rec" && l_count >= 5) {
      // an older world: its game mode is in the player record
      Get_item(l_words, 2, l_word);
      Get_item(l_words, 3, l_key);
      if (l_word == RECORD_PLAYER && l_key == ATTR_PLAYER_MODE) {
        record_set_integer_at(p_list, ATTR_WL_MODE, p_entry, save_word_integer(l_words, 5));
        break;
      }
    } else if (l_key == "edits") {
      break;
    }
  }
  File_close(l_file);
  return SUCCESS;
}

void save_swap_listed(Attributes &p_list, Integer p_a, Integer p_b)
// ----------------------------------------------------------------
// Swap two entries of the world list, pictures and all
// ----------------------------------------------------------------
{
  Integer l_cell    = 0;
  Integer l_keep    = 0;
  Integer l_number  = 0;
  Text    l_text    = "";

  l_text = record_text_at(p_list, ATTR_WL_NAME, p_a);
  record_set_text_at(p_list, ATTR_WL_NAME, p_a, record_text_at(p_list, ATTR_WL_NAME, p_b));
  record_set_text_at(p_list, ATTR_WL_NAME, p_b, l_text);
  l_text = record_text_at(p_list, ATTR_WL_DATE, p_a);
  record_set_text_at(p_list, ATTR_WL_DATE, p_a, record_text_at(p_list, ATTR_WL_DATE, p_b));
  record_set_text_at(p_list, ATTR_WL_DATE, p_b, l_text);
  l_text = record_text_at(p_list, ATTR_WL_VERSION_TEXT, p_a);
  record_set_text_at(p_list, ATTR_WL_VERSION_TEXT, p_a, record_text_at(p_list, ATTR_WL_VERSION_TEXT, p_b));
  record_set_text_at(p_list, ATTR_WL_VERSION_TEXT, p_b, l_text);
  l_number = record_integer_at(p_list, ATTR_WL_PLAYED, p_a);
  record_set_integer_at(p_list, ATTR_WL_PLAYED, p_a, record_integer_at(p_list, ATTR_WL_PLAYED, p_b));
  record_set_integer_at(p_list, ATTR_WL_PLAYED, p_b, l_number);
  l_number = record_integer_at(p_list, ATTR_WL_MODE, p_a);
  record_set_integer_at(p_list, ATTR_WL_MODE, p_a, record_integer_at(p_list, ATTR_WL_MODE, p_b));
  record_set_integer_at(p_list, ATTR_WL_MODE, p_b, l_number);
  l_number = record_integer_at(p_list, ATTR_WL_VERSION, p_a);
  record_set_integer_at(p_list, ATTR_WL_VERSION, p_a, record_integer_at(p_list, ATTR_WL_VERSION, p_b));
  record_set_integer_at(p_list, ATTR_WL_VERSION, p_b, l_number);
  l_number = record_integer_at(p_list, ATTR_WL_THUMB, p_a);
  record_set_integer_at(p_list, ATTR_WL_THUMB, p_a, record_integer_at(p_list, ATTR_WL_THUMB, p_b));
  record_set_integer_at(p_list, ATTR_WL_THUMB, p_b, l_number);
  for (l_cell = 1; l_cell <= THUMB_CELLS; ++l_cell) {
    l_keep = g_thumb_list[(p_a - 1) * THUMB_CELLS + l_cell];
    g_thumb_list[(p_a - 1) * THUMB_CELLS + l_cell] = g_thumb_list[(p_b - 1) * THUMB_CELLS + l_cell];
    g_thumb_list[(p_b - 1) * THUMB_CELLS + l_cell] = l_keep;
  }
}

Integer save_list_worlds_about(Attributes &p_list)
// ----------------------------------------------------------------
// Fill the world list with every saved world (up to
// MAX_LISTED_WORLDS), last played first; returns how many
// ----------------------------------------------------------------
{
  Dynamic_Text l_names;
  Integer      l_count = save_list_worlds(l_names);
  Integer      l_entry = 0;
  Integer      l_other = 0;
  Integer      l_best  = 0;
  Text         l_name  = "";

  record_clear(p_list, DATATYPE_WORLD_LIST);
  if (l_count > MAX_LISTED_WORLDS) l_count = MAX_LISTED_WORLDS;
  for (l_entry = 1; l_entry <= l_count; ++l_entry) {
    Get_item(l_names, l_entry, l_name);
    record_set_text_at(p_list, ATTR_WL_NAME, l_entry, l_name);
    save_read_about(save_world_path(l_name), p_list, l_entry);
  }
  record_set_integer(p_list, ATTR_WL_COUNT, l_count);
  // last played first (a few dozen worlds at most, so a plain sort)
  for (l_entry = 1; l_entry < l_count; ++l_entry) {
    l_best = l_entry;
    for (l_other = l_entry + 1; l_other <= l_count; ++l_other) {
      if (record_integer_at(p_list, ATTR_WL_PLAYED, l_other) > record_integer_at(p_list, ATTR_WL_PLAYED, l_best)) l_best = l_other;
    }
    if (l_best != l_entry) save_swap_listed(p_list, l_entry, l_best);
  }
  return l_count;
}

Integer save_listed_colour(Integer p_entry, Integer p_cell)
// ----------------------------------------------------------------
// Colour of cell n of listed world entry's picture
// ----------------------------------------------------------------
{
  if (p_entry < 1 || p_entry > MAX_LISTED_WORLDS || p_cell < 1 || p_cell > THUMB_CELLS) return 0;
  return g_thumb_list[(p_entry - 1) * THUMB_CELLS + p_cell];
}

Text save_file_name(Text p_path)
// ----------------------------------------------------------------
// The last part of a path (after the last \\ or /)
// ----------------------------------------------------------------
{
  Integer l_position = 0;
  Integer l_code     = 0;

  for (l_position = Text_length(p_path); l_position >= 1; --l_position) {
    Get_char(p_path, l_position, l_code);
    if (l_code == 92 || l_code == 47) return Get_subtext(p_path, l_position + 1, Text_length(p_path));
  }
  return p_path;
}

Integer save_list_files(Attributes &p_files, Text p_folder, Text p_pattern, Integer p_with_folders)
// ----------------------------------------------------------------
// List the files in a folder that match a pattern ("*.zip"), and its
// folders too if with_folders, into a file list; returns how many
// (none if the folder isn't there)
// ----------------------------------------------------------------
{
  Dynamic_Text l_names;
  Integer      l_count = 0;
  Integer      l_item  = 0;
  Integer      l_found = 0;
  Text         l_name  = "";

  record_clear      (p_files, DATATYPE_FILE_LIST);
  record_set_integer(p_files, ATTR_FL_COUNT, 0);
  if (!Directory_exists(p_folder)) return 0;
  if (p_with_folders) {
    if (List_subfolders_in_folder(p_folder, "*", l_count, l_names) == 0) {
      for (l_item = 1; l_item <= l_count; ++l_item) {
        Get_item(l_names, l_item, l_name);
        l_name = save_file_name(l_name);
        if (l_name == "" || l_name == "." || l_name == "..") continue;
        ++l_found;
        record_set_text_at(p_files, ATTR_FL_NAME, l_found, l_name);
        record_set_text_at(p_files, ATTR_FL_PATH, l_found, p_folder + "\\" + l_name);
      }
    }
  }
  Null(l_names);
  l_count = 0;
  if (List_files_in_folder(p_folder, p_pattern, l_count, l_names) == 0) {
    for (l_item = 1; l_item <= l_count; ++l_item) {
      Get_item(l_names, l_item, l_name);
      l_name = save_file_name(l_name);
      if (l_name == "") continue;
      ++l_found;
      record_set_text_at(p_files, ATTR_FL_NAME, l_found, l_name);
      record_set_text_at(p_files, ATTR_FL_PATH, l_found, p_folder + "\\" + l_name);
    }
  }
  record_set_integer(p_files, ATTR_FL_COUNT, l_found);
  return l_found;
}

// ---------------------------------------------------------------- saving

// ---------------------------------------------------------------- records

Text text_escape(Text p_value)
// ----------------------------------------------------------------
// Make a Text value safe to store as one word: "%" becomes "%25",
// a space "%20", and an empty value "%00"
// ----------------------------------------------------------------
{
  Integer l_length    = Text_length(p_value);
  Integer l_position  = 0;
  Text    l_character = "";
  Text    l_result    = "";

  if (l_length == 0) return "%00";

  for (l_position = 1; l_position <= l_length; ++l_position) {
    l_character = Get_subtext(p_value, l_position, l_position);
    if (l_character == "%") {
      l_result = l_result + "%25";
    } else if (l_character == " ") {
      l_result = l_result + "%20";
    } else {
      l_result = l_result + l_character;
    }
  }
  return l_result;
}

Text text_unescape(Text p_value)
// ----------------------------------------------------------------
// Undo text_escape
// ----------------------------------------------------------------
{
  Integer l_length    = Text_length(p_value);
  Integer l_position  = 1;
  Text    l_character = "";
  Text    l_code      = "";
  Text    l_result    = "";

  while (l_position <= l_length) {
    l_character = Get_subtext(p_value, l_position, l_position);
    if (l_character == "%" && l_position + 2 <= l_length) {
      l_code = Get_subtext(p_value, l_position + 1, l_position + 2);
      if (l_code == "25") l_result = l_result + "%";
      if (l_code == "20") l_result = l_result + " ";
      l_position = l_position + 3;
      continue;
    }
    l_result   = l_result + l_character;
    l_position = l_position + 1;
  }
  return l_result;
}

void save_write_record(File &p_file, Text p_name, Attributes &p_record)
// ----------------------------------------------------------------
// Write every field of a record as "rec <name> <field> <type>
// <value>" lines. A field's type is found by trying to read it as
// an Integer, then a Real, then a Text.
// ----------------------------------------------------------------
{
  Integer l_fields        = 0;
  Integer l_field         = 0;
  Integer l_integer_value = 0;
  Real    l_real_value    = 0.0;
  Text    l_text_value    = "";
  Text    l_field_name    = "";
  Text    l_start         = "";

  Get_number_of_attributes(p_record, l_fields);
  for (l_field = 1; l_field <= l_fields; ++l_field) {
    if (Get_attribute_name(p_record, l_field, l_field_name) != 0) continue;
    l_start = "rec " + p_name + " " + l_field_name;
    if (Get_attribute(p_record, l_field, l_integer_value) == 0) {
      File_write_line(p_file, l_start + " i " + To_text(l_integer_value));
    } else if (Get_attribute(p_record, l_field, l_real_value) == 0) {
      File_write_line(p_file, l_start + " r " + To_text(l_real_value, 6));
    } else if (Get_attribute(p_record, l_field, l_text_value) == 0) {
      File_write_line(p_file, l_start + " t " + text_escape(l_text_value));
    }
  }
}

Integer save_read_field(Dynamic_Text &p_words, Integer p_count, Attributes &p_record)
// ----------------------------------------------------------------
// Apply one "rec <name> <field> <type> <value>" line (already split
// into words) to a record. Returns SUCCESS or FAILURE.
// ----------------------------------------------------------------
{
  Text l_field = "";
  Text l_type  = "";
  Text l_value = "";

  if (p_count < 5) return FAILURE;

  Get_item(p_words, 3, l_field);
  Get_item(p_words, 4, l_type);
  Get_item(p_words, 5, l_value);

  if (l_type == "i") {
    record_set_integer(p_record, l_field, save_word_integer(p_words, 5));
  } else if (l_type == "r") {
    record_set_real(p_record, l_field, save_word_real(p_words, 5));
  } else if (l_type == "t") {
    record_set_text(p_record, l_field, text_unescape(l_value));
  } else {
    return FAILURE;
  }
  return SUCCESS;
}

// ---------------------------------------------------------------- worlds

void save_write_level(File &p_file, Attributes &p_info, Attributes &p_player, Attributes &p_inventory)
// ----------------------------------------------------------------
// The top of a world: the tag and version, the about and thumb lines
// for the world list, the dimension being played, the seed and the
// world, player and inventory records
// ----------------------------------------------------------------
{
  Text    l_line   = "";
  Text    l_text   = "";
  Integer l_row    = 0;
  Integer l_column = 0;

  l_line = WORLD_FILE_TAG;
  File_write_line(p_file, l_line + " " + To_text(WORLD_FILE_VERSION));
  l_line = GAME_VERSION;
  l_text = record_text(p_info, ATTR_SAVE_PLAYED_TEXT);
  File_write_line(p_file, "about " + To_text(GAME_VERSION_CODE) + " " + To_text(record_integer(p_info, ATTR_SAVE_PLAYED)) + " " +
                  To_text(player_game_mode(p_player)) + " " + l_line + " " + l_text);
  if (g_thumb_ready) {
    for (l_row = 1; l_row <= THUMB_SIZE; ++l_row) {
      l_line = "";
      for (l_column = 1; l_column <= THUMB_SIZE; ++l_column) l_line = l_line + save_hex_colour(g_thumb_now[(l_row - 1) * THUMB_SIZE + l_column]);
      File_write_line(p_file, "thumb " + To_text(l_row) + " " + l_line);
    }
  }
  File_write_line(p_file, "dimension " + To_text(world_dimension()));
  File_write_line(p_file, "seed " + To_text(world_info_seed(p_info)));

  save_write_record(p_file, RECORD_WORLD,     p_info);
  save_write_record(p_file, RECORD_PLAYER,    p_player);
  save_write_record(p_file, RECORD_INVENTORY, p_inventory);
}

void save_write_edits(File &p_file, Integer p_other)
// ----------------------------------------------------------------
// The block changes of the dimension being played (or, with other
// TRUE, of the other one), several index/block pairs to a line
// ----------------------------------------------------------------
{
  Text    l_line   = "";
  Integer l_edit   = 0;
  Integer l_count  = g_edit_count;
  Integer l_on_row = 0;

  if (p_other) l_count = g_other_edit_count;
  for (l_edit = 1; l_edit <= l_count; ++l_edit) {
    if (l_on_row == 0) l_line = "edits";
    if (p_other) {
      l_line = l_line + " " + To_text(g_other_edit_index[l_edit]) + " " + To_text(g_other_edit_block[l_edit]);
    } else {
      l_line = l_line + " " + To_text(g_edit_index[l_edit]) + " " + To_text(g_edit_block[l_edit]);
    }
    ++l_on_row;
    if (l_on_row >= EDITS_PER_LINE) {
      File_write_line(p_file, l_line);
      l_on_row = 0;
    }
  }
  if (l_on_row > 0) File_write_line(p_file, l_line);
}

void save_write_region(File &p_file, Integer p_dimension, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops,
                       Attributes &p_away)
// ----------------------------------------------------------------
// One dimension's part of a world: "region <dimension>", then its
// furnaces and chests, mobs and drops and its block changes. They
// come from the records being played if it is the dimension being
// played, otherwise from the away record.
// ----------------------------------------------------------------
{
  Attributes l_furnaces;
  Attributes l_cows;
  Attributes l_drops;

  File_write_line(p_file, "region " + To_text(p_dimension));
  if (p_dimension == world_dimension()) {
    save_write_record(p_file, RECORD_FURNACES, p_furnaces);
    save_write_record(p_file, RECORD_COWS,     p_cows);
    save_write_record(p_file, RECORD_DROPS,    p_drops);
    save_write_edits (p_file, FALSE);
    return;
  }
  record_copy_unprefixed(p_away, l_furnaces, AWAY_FURNACES);
  record_copy_unprefixed(p_away, l_cows,     AWAY_COWS);
  record_copy_unprefixed(p_away, l_drops,    AWAY_DROPS);
  save_write_record(p_file, RECORD_FURNACES, l_furnaces);
  save_write_record(p_file, RECORD_COWS,     l_cows);
  save_write_record(p_file, RECORD_DROPS,    l_drops);
  save_write_edits (p_file, TRUE);
}

Integer save_region_file(Text p_path, Integer p_dimension, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops,
                         Attributes &p_away)
// ----------------------------------------------------------------
// Write one dimension of a world to a file of its own (see
// save_write_region). Returns SUCCESS or FAILURE.
// ----------------------------------------------------------------
{
  File l_file;
  Text l_line = WORLD_FILE_TAG;

  if (safe_file_open(p_path, "w", l_file) != 0) return FAILURE;
  File_write_line  (l_file, l_line + " " + To_text(WORLD_FILE_VERSION));
  save_write_region(l_file, p_dimension, p_furnaces, p_cows, p_drops, p_away);
  File_write_line  (l_file, "end");
  File_close(l_file);
  return SUCCESS;
}

Integer save_world(Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                   Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events)
// ----------------------------------------------------------------
// Write a world to its folder, as the block game does: the level
// file, the overworld's region file and the Nether's in DIM-1.
// Emits EVT_WORLD_SAVED.
// ----------------------------------------------------------------
{
  File l_file;
  Text l_nether = WORLD_NETHER_FOLDER;

  if (p_name == "") return FAILURE;

  save_ensure_folder();
  if (safe_folder_create(save_world_folder(p_name)) != 0) return FAILURE;
  if (safe_folder_create(save_world_folder(p_name) + "\\" + l_nether) != 0) return FAILURE;

  if (save_region_file(save_region_path(p_name, DIM_OVERWORLD), DIM_OVERWORLD, p_furnaces, p_cows, p_drops, p_away) != SUCCESS) return FAILURE;
  if (save_region_file(save_region_path(p_name, DIM_NETHER),    DIM_NETHER,    p_furnaces, p_cows, p_drops, p_away) != SUCCESS) return FAILURE;
  // the level file last: a world is only listed once it is complete
  if (safe_file_open(save_level_path(p_name), "w", l_file) != 0) return FAILURE;
  save_write_level(l_file, p_info, p_player, p_inventory);
  File_write_line (l_file, "end");
  File_close(l_file);

  emit_event(p_events, EVT_WORLD_SAVED, 0, 0, 0, 0, 0.0, 0.0, 0.0, p_name);
  return SUCCESS;
}

Integer save_world_to(Text p_path, Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                      Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events)
// ----------------------------------------------------------------
// Write a whole world to the one file p_path (a multiplayer
// snapshot): the level lines and both dimensions' regions. Emits
// EVT_WORLD_SAVED with p_name.
// ----------------------------------------------------------------
{
  File l_file;

  if (safe_file_open(p_path, "w", l_file) != 0) return FAILURE;
  save_write_level (l_file, p_info, p_player, p_inventory);
  save_write_region(l_file, DIM_OVERWORLD, p_furnaces, p_cows, p_drops, p_away);
  save_write_region(l_file, DIM_NETHER,    p_furnaces, p_cows, p_drops, p_away);
  File_write_line(l_file, "end");
  File_close(l_file);

  emit_event(p_events, EVT_WORLD_SAVED, 0, 0, 0, 0, 0.0, 0.0, 0.0, p_name);
  return SUCCESS;
}

Integer save_word_integer(Dynamic_Text &p_words, Integer p_position)
// ----------------------------------------------------------------
// Word number position of a split line as an Integer (0 if bad)
// ----------------------------------------------------------------
{
  Text    l_word  = "";
  Integer l_value = 0;

  Get_item(p_words, p_position, l_word);
  if (Get_subtext(l_word, 1, 1) == "-") {
    From_text(Get_subtext(l_word, 2, Text_length(l_word)), l_value);
    return -l_value;
  }
  From_text(l_word, l_value);
  return l_value;
}

Real save_word_real(Dynamic_Text &p_words, Integer p_position)
// ----------------------------------------------------------------
// Word number position of a split line as a Real (0 if bad)
// ----------------------------------------------------------------
{
  Text l_word  = "";
  Real l_value = 0.0;

  Get_item(p_words, p_position, l_word);
  From_text(l_word, l_value);
  return l_value;
}

Integer load_world_file(Text p_path, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                        Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops,
                        Attributes &p_away_furnaces, Attributes &p_away_cows, Attributes &p_away_drops,
                        Integer &p_dimension, Integer &p_seeded, Integer &p_version, Text &p_problem)
// ----------------------------------------------------------------
// Read one world file: a level file, a region file, a multiplayer
// snapshot (both in one) or an older version's single file. The
// seed line makes the dimension being played from the seed; the
// records and block changes after "region <dimension>" go to that
// dimension (the away records and the other edit list if it isn't
// the one being played). dimension, seeded and version carry over
// from one file of a world to the next.
// Returns SUCCESS, or FAILURE with problem saying why.
// ----------------------------------------------------------------
{
  File         l_file;
  Dynamic_Text l_words;
  Text         l_line     = "";
  Text         l_key      = "";
  Text         l_target   = "";
  Integer      l_count    = 0;
  Integer      l_word     = 0;
  Integer      l_index    = 0;
  Integer      l_block    = 0;
  Integer      l_cell_x   = 0;
  Integer      l_cell_y   = 0;
  Integer      l_cell_z   = 0;
  Integer      l_version  = 0;
  Integer      l_here     = TRUE;    // the lines are about the dimension being played

  if (!File_exists(p_path)) {
    p_problem = "there is no world file " + p_path;
    return FAILURE;
  }
  if (safe_file_open(p_path, "r", l_file) != 0) {
    p_problem = "the world file couldn't be opened";
    return FAILURE;
  }
  if (File_read_line(l_file, l_line) != 0) {
    File_close(l_file);
    p_problem = "the world file is empty";
    return FAILURE;
  }
  Null(l_words);
  l_count = From_text(l_line, l_words);
  Get_item(l_words, 1, l_key);
  if (l_key != WORLD_FILE_TAG) {
    File_close(l_file);
    p_problem = "it isn't a Cubeland world file";
    return FAILURE;
  }
  if (l_count >= 2) l_version = save_word_integer(l_words, 2);
  if (l_version != WORLD_FILE_VERSION && l_version != WORLD_LEGACY_VERSION) {
    File_close(l_file);
    p_problem = "it was saved by an older version of Cubeland";
    return FAILURE;
  }
  p_version = l_version;

  while (File_read_line(l_file, l_line) == 0) {
    Null(l_words);
    l_count = From_text(l_line, l_words);
    if (l_count < 1) continue;
    Get_item(l_words, 1, l_key);

    if (l_key == "end") break;

    if (l_key == "thumb" && l_count >= 3) {
      l_index = save_word_integer(l_words, 2);
      Get_item(l_words, 3, l_target);
      if (l_index < 1 || l_index > THUMB_SIZE || Text_length(l_target) < 6 * THUMB_SIZE) continue;
      for (l_word = 1; l_word <= THUMB_SIZE; ++l_word) {
        g_thumb_now[(l_index - 1) * THUMB_SIZE + l_word] = save_hex_value(l_target, (l_word - 1) * 6 + 1, 6);
      }
      if (l_index == THUMB_SIZE) g_thumb_ready = 1;
    } else if (l_key == "dimension" && l_count >= 2) {
      p_dimension = save_word_integer(l_words, 2);
      if (p_dimension != DIM_NETHER) p_dimension = DIM_OVERWORLD;
    } else if (l_key == "seed" && l_count >= 2) {
      world_generate_dimension(p_info, save_word_integer(l_words, 2), p_dimension);
      mesh_reset();
      player_reset(p_player, 0.0, 0.0, 0.0);
      p_seeded = TRUE;
    } else if (!p_seeded) {
      continue;
    } else if (l_key == WORLD_REGION_TAG && l_count >= 2) {
      l_here = save_word_integer(l_words, 2) == p_dimension;
    } else if (l_key == "rec" && l_count >= 5) {
      Get_item(l_words, 2, l_target);
      if (l_target == RECORD_WORLD    ) save_read_field(l_words, l_count, p_info);
      if (l_target == RECORD_PLAYER   ) save_read_field(l_words, l_count, p_player);
      if (l_target == RECORD_INVENTORY) save_read_field(l_words, l_count, p_inventory);
      if (l_here) {
        if (l_target == RECORD_FURNACES) save_read_field(l_words, l_count, p_furnaces);
        if (l_target == RECORD_COWS    ) save_read_field(l_words, l_count, p_cows);
        if (l_target == RECORD_DROPS   ) save_read_field(l_words, l_count, p_drops);
      } else {
        if (l_target == RECORD_FURNACES) save_read_field(l_words, l_count, p_away_furnaces);
        if (l_target == RECORD_COWS    ) save_read_field(l_words, l_count, p_away_cows);
        if (l_target == RECORD_DROPS   ) save_read_field(l_words, l_count, p_away_drops);
      }
    } else if (l_key == "edits" && l_here) {
      for (l_word = 2; l_word + 1 <= l_count; l_word = l_word + 2) {
        l_index = save_word_integer(l_words, l_word);
        l_block = save_word_integer(l_words, l_word + 1);
        if (l_index < 1 || l_index > WORLD_CELLS) continue;
        save_record_edit(l_index, l_block);
        world_cell_of_index(l_index, l_cell_x, l_cell_y, l_cell_z);
        world_set_block(l_cell_x, l_cell_y, l_cell_z, l_block);
        mesh_mark_dirty(l_cell_x, l_cell_y, l_cell_z);
      }
    } else if (l_key == "other_edits" || l_key == "edits") {
      // the other dimension's ("other_edits" in an older version's file)
      for (l_word = 2; l_word + 1 <= l_count; l_word = l_word + 2) {
        l_index = save_word_integer(l_words, l_word);
        if (l_index < 1 || l_index > WORLD_CELLS) continue;
        save_record_other_edit(l_index, save_word_integer(l_words, l_word + 1));
      }
    }
  }
  File_close(l_file);
  return SUCCESS;
}

Integer load_world_finish(Attributes &p_info, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away,
                          Attributes &p_away_furnaces, Attributes &p_away_cows, Attributes &p_away_drops,
                          Integer p_dimension, Integer p_seeded, Integer p_version, Text &p_problem)
// ----------------------------------------------------------------
// After a world's files are read: an older version's things marked
// with the other dimension are moved to the away records, which go
// into the away record; the lists of used mobs, drops and furnaces
// are rebuilt; torches light their surroundings again
// ----------------------------------------------------------------
{
  Integer l_edit    = 0;
  Integer l_cell_x  = 0;
  Integer l_cell_y  = 0;
  Integer l_cell_z  = 0;
  Integer l_furnace = 0;
  Integer l_fx      = 0;
  Integer l_fy      = 0;
  Integer l_fz      = 0;

  if (!p_seeded) {
    p_problem = "the world file has no seed";
    return FAILURE;
  }
  world_finish_maps();

  if (p_version == WORLD_LEGACY_VERSION) {
    mobs_split_legacy    (p_cows,     p_away_cows,     p_dimension);
    drops_split_legacy   (p_drops,    p_away_drops,    p_dimension);
    furnaces_split_legacy(p_furnaces, p_away_furnaces, p_dimension);
    chests_split_legacy  (p_furnaces, p_away_furnaces, p_dimension);
  }
  record_clear        (p_away, DATATYPE_AWAY);
  record_copy_prefixed(p_away_furnaces, p_away, AWAY_FURNACES);
  record_copy_prefixed(p_away_cows,     p_away, AWAY_COWS);
  record_copy_prefixed(p_away_drops,    p_away, AWAY_DROPS);

  // The lists of used mob, drop and furnace numbers come from the
  // "used" fields just read
  mobs_rebuild_index    (p_cows);
  drops_rebuild_index   (p_drops);
  furnaces_rebuild_index(p_furnaces);

  // Torches light their surroundings again
  for (l_edit = 1; l_edit <= g_edit_count; ++l_edit) {
    if (block_light_emission(g_edit_block[l_edit]) == 0) continue;
    world_cell_of_index(g_edit_index[l_edit], l_cell_x, l_cell_y, l_cell_z);
    world_light_update(l_cell_x, l_cell_y, l_cell_z);
  }

  // Furnaces that lost their block (shouldn't happen) are forgotten
  for (l_furnace = 1; l_furnace <= MAX_FURNACES; ++l_furnace) {
    if (!furnace_here(p_furnaces, l_furnace)) continue;
    furnace_cell(p_furnaces, l_furnace, l_fx, l_fy, l_fz);
    if (!block_is_furnace(world_get_block(l_fx, l_fy, l_fz))) furnace_set_used(p_furnaces, l_furnace, FALSE);
  }
  return SUCCESS;
}

void load_world_start(Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops,
                      Attributes &p_away_furnaces, Attributes &p_away_cows, Attributes &p_away_drops)
// ----------------------------------------------------------------
// Empty what a world file fills in, before reading one
// ----------------------------------------------------------------
{
  save_clear_edits();
  save_clear_thumbnail();
  inventory_clear(p_inventory);
  furnaces_clear (p_furnaces);
  cows_clear     (p_cows);
  drops_clear    (p_drops);
  furnaces_clear (p_away_furnaces);
  cows_clear     (p_away_cows);
  drops_clear    (p_away_drops);
}

Integer load_world(Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                   Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Text &p_problem)
// ----------------------------------------------------------------
// Read a saved world by name: its folder (level file, then each
// dimension's region file), or an older version's single file
// ----------------------------------------------------------------
{
  Attributes l_away_furnaces;
  Attributes l_away_cows;
  Attributes l_away_drops;
  Integer    l_dimension = DIM_OVERWORLD;
  Integer    l_seeded    = FALSE;
  Integer    l_version   = 0;

  p_problem = "";
  if (!save_world_exists(p_name)) {
    p_problem = "there is no saved world called " + p_name;
    return FAILURE;
  }
  if (save_world_path(p_name) == save_legacy_path(p_name)) {
    return load_world_from(save_legacy_path(p_name), p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_away, p_problem);
  }

  load_world_start(p_inventory, p_furnaces, p_cows, p_drops, l_away_furnaces, l_away_cows, l_away_drops);
  if (load_world_file(save_level_path(p_name), p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops,
                      l_away_furnaces, l_away_cows, l_away_drops, l_dimension, l_seeded, l_version, p_problem) != SUCCESS) return FAILURE;
  if (save_file_in_use(save_region_path(p_name, DIM_OVERWORLD))) {
    if (load_world_file(save_region_path(p_name, DIM_OVERWORLD), p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops,
                        l_away_furnaces, l_away_cows, l_away_drops, l_dimension, l_seeded, l_version, p_problem) != SUCCESS) return FAILURE;
  }
  if (save_file_in_use(save_region_path(p_name, DIM_NETHER))) {
    if (load_world_file(save_region_path(p_name, DIM_NETHER), p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops,
                        l_away_furnaces, l_away_cows, l_away_drops, l_dimension, l_seeded, l_version, p_problem) != SUCCESS) return FAILURE;
  }
  return load_world_finish(p_info, p_furnaces, p_cows, p_drops, p_away, l_away_furnaces, l_away_cows, l_away_drops,
                           l_dimension, l_seeded, l_version, p_problem);
}

Integer load_world_from(Text p_path, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                        Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Text &p_problem)
// ----------------------------------------------------------------
// Read a whole world from one file (a multiplayer snapshot, or an
// older version's world file): regenerate the terrain from its seed,
// apply the saved block changes and read the records back
// Returns SUCCESS, or FAILURE with problem saying why
// ----------------------------------------------------------------
{
  Attributes l_away_furnaces;
  Attributes l_away_cows;
  Attributes l_away_drops;
  Integer    l_dimension = DIM_OVERWORLD;
  Integer    l_seeded    = FALSE;
  Integer    l_version   = 0;

  p_problem = "";
  load_world_start(p_inventory, p_furnaces, p_cows, p_drops, l_away_furnaces, l_away_cows, l_away_drops);
  if (load_world_file(p_path, p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops,
                      l_away_furnaces, l_away_cows, l_away_drops, l_dimension, l_seeded, l_version, p_problem) != SUCCESS) return FAILURE;
  return load_world_finish(p_info, p_furnaces, p_cows, p_drops, p_away, l_away_furnaces, l_away_cows, l_away_drops,
                           l_dimension, l_seeded, l_version, p_problem);
}

#endif
