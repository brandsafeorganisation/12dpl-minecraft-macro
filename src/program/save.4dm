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
#include "../../include/player/player.h"
#include "../../include/core/records.h"
#include "../../include/program/settings.h"
#include "../../include/program/save.h"

// ---------------------------------------------------------------- the edit list

void save_clear_edits()
// ----------------------------------------------------------------
// Forget every recorded block change (new or freshly loaded world)
// ----------------------------------------------------------------
{
  g_edit_count    = 0;
  g_edit_overflow = 0;
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

Text save_world_path(Text p_name)
// ----------------------------------------------------------------
// File holding a world
// ----------------------------------------------------------------
{
  Text l_folder    = WORLD_FOLDER;
  Text l_extension = WORLD_EXTENSION;

  return l_folder + "\\" + p_name + l_extension;
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
  Text l_path = save_world_path(p_name);

  if (!File_exists(l_path))         return FALSE;
  if (save_file_is_deleted(l_path)) return FALSE;
  return TRUE;
}

Integer save_list_worlds(Dynamic_Text &p_names)
// ----------------------------------------------------------------
// Names of every saved world; returns how many there are
// ----------------------------------------------------------------
{
  Dynamic_Text l_files;
  Integer      l_count    = 0;
  Integer      l_file     = 0;
  Integer      l_found    = 0;
  Text         l_path     = "";
  Text         l_pattern  = "*";
  Text         l_title    = "";

  Null(p_names);
  save_ensure_folder();

  l_pattern = l_pattern + WORLD_EXTENSION;
  if (List_files_in_folder(WORLD_FOLDER, l_pattern, l_count, l_files) != 0) return 0;

  for (l_file = 1; l_file <= l_count; ++l_file) {
    Get_item(l_files, l_file, l_path);
    l_title = file_title_from_path(l_path);
    if (l_title == "") continue;
    if (!save_world_exists(l_title)) continue;
    Append(l_title, p_names);
    ++l_found;
  }
  return l_found;
}

Integer save_delete_world(Text p_name)
// ----------------------------------------------------------------
// Delete a saved world. Deleting files is blocked by safety.h, so
// the file is overwritten with WORLD_DELETED_TAG instead: the menu
// no longer lists it and a new world can reuse the name. The empty
// file can be removed by hand from the worlds folder.
// ----------------------------------------------------------------
{
  File l_file;

  if (!save_world_exists(p_name)) return FAILURE;
  if (safe_file_open(save_world_path(p_name), "w", l_file) != 0) return FAILURE;
  File_write_line(l_file, WORLD_DELETED_TAG);
  File_close(l_file);
  return SUCCESS;
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

Integer save_world(Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                   Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events)
// ----------------------------------------------------------------
// Write a world to its file. Emits EVT_WORLD_SAVED.
// ----------------------------------------------------------------
{
  File    l_file;
  Text    l_line   = "";
  Integer l_edit   = 0;
  Integer l_on_row = 0;

  if (p_name == "") return FAILURE;

  save_ensure_folder();
  if (safe_file_open(save_world_path(p_name), "w", l_file) != 0) return FAILURE;

  l_line = WORLD_FILE_TAG;
  File_write_line(l_file, l_line + " " + To_text(WORLD_FILE_VERSION));
  File_write_line(l_file, "seed " + To_text(world_info_seed(p_info)));

  save_write_record(l_file, RECORD_WORLD,     p_info);
  save_write_record(l_file, RECORD_PLAYER,    p_player);
  save_write_record(l_file, RECORD_INVENTORY, p_inventory);
  save_write_record(l_file, RECORD_FURNACES,  p_furnaces);
  save_write_record(l_file, RECORD_COWS,      p_cows);
  save_write_record(l_file, RECORD_DROPS,     p_drops);

  // Block changes, several index/block pairs to a line
  l_line   = "";
  l_on_row = 0;
  for (l_edit = 1; l_edit <= g_edit_count; ++l_edit) {
    if (l_on_row == 0) l_line = "edits";
    l_line = l_line + " " + To_text(g_edit_index[l_edit]) + " " + To_text(g_edit_block[l_edit]);
    ++l_on_row;
    if (l_on_row >= EDITS_PER_LINE) {
      File_write_line(l_file, l_line);
      l_on_row = 0;
    }
  }
  if (l_on_row > 0) File_write_line(l_file, l_line);

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

Integer load_world(Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                   Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Text &p_problem)
// ----------------------------------------------------------------
// Read a world file: regenerate the terrain from its seed, apply
// the saved block changes and read the records back
// Returns SUCCESS, or FAILURE with problem saying why
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
  Integer      l_furnace  = 0;
  Integer      l_edit     = 0;
  Integer      l_cell_x   = 0;
  Integer      l_cell_y   = 0;
  Integer      l_cell_z   = 0;
  Integer      l_fx       = 0;
  Integer      l_fy       = 0;
  Integer      l_fz       = 0;
  Integer      l_seeded   = FALSE;

  p_problem = "";
  if (!save_world_exists(p_name)) {
    p_problem = "there is no saved world called " + p_name;
    return FAILURE;
  }
  if (safe_file_open(save_world_path(p_name), "r", l_file) != 0) {
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
  if (l_count < 2 || save_word_integer(l_words, 2) != WORLD_FILE_VERSION) {
    File_close(l_file);
    p_problem = "it was saved by an older version of Cubeland";
    return FAILURE;
  }

  save_clear_edits();
  inventory_clear (p_inventory);
  furnaces_clear  (p_furnaces);
  cows_clear      (p_cows);
  drops_clear     (p_drops);

  while (File_read_line(l_file, l_line) == 0) {
    Null(l_words);
    l_count = From_text(l_line, l_words);
    if (l_count < 1) continue;
    Get_item(l_words, 1, l_key);

    if (l_key == "end") break;

    if (l_key == "seed" && l_count >= 2) {
      world_generate(p_info, save_word_integer(l_words, 2));
      mesh_reset();
      player_reset(p_player, 0.0, 0.0, 0.0);
      l_seeded = TRUE;
    } else if (!l_seeded) {
      continue;
    } else if (l_key == "rec" && l_count >= 5) {
      Get_item(l_words, 2, l_target);
      if (l_target == RECORD_WORLD    ) save_read_field(l_words, l_count, p_info);
      if (l_target == RECORD_PLAYER   ) save_read_field(l_words, l_count, p_player);
      if (l_target == RECORD_INVENTORY) save_read_field(l_words, l_count, p_inventory);
      if (l_target == RECORD_FURNACES ) save_read_field(l_words, l_count, p_furnaces);
      if (l_target == RECORD_COWS     ) save_read_field(l_words, l_count, p_cows);
      if (l_target == RECORD_DROPS    ) save_read_field(l_words, l_count, p_drops);
    } else if (l_key == "edits") {
      for (l_word = 2; l_word + 1 <= l_count; l_word = l_word + 2) {
        l_index = save_word_integer(l_words, l_word);
        l_block = save_word_integer(l_words, l_word + 1);
        if (l_index < 1 || l_index > WORLD_CELLS) continue;
        save_record_edit(l_index, l_block);
        world_cell_of_index(l_index, l_cell_x, l_cell_y, l_cell_z);
        world_set_block(l_cell_x, l_cell_y, l_cell_z, l_block);
        mesh_mark_dirty(l_cell_x, l_cell_y, l_cell_z);
      }
    }
  }
  File_close(l_file);

  if (!l_seeded) {
    p_problem = "the world file has no seed";
    return FAILURE;
  }
  world_finish_maps();

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
    if (!furnace_used(p_furnaces, l_furnace)) continue;
    furnace_cell(p_furnaces, l_furnace, l_fx, l_fy, l_fz);
    if (!block_is_furnace(world_get_block(l_fx, l_fy, l_fz))) furnace_set_used(p_furnaces, l_furnace, FALSE);
  }

  return SUCCESS;
}

#endif
