#ifndef SAVE_H_INCLUDED
#define SAVE_H_INCLUDED

#include "../core/config.h"
#include "../core/records.h"

// ----------------------------------------------------------------
// World files
// A world is saved as its seed plus everything that differs from
// what the seed generates: the blocks that were changed and the
// game records (player, inventory, furnaces, cows, drops, world
// info). Loading regenerates the terrain from the seed, applies the
// changes and reads the records back. A "dimension" line says which
// dimension the player is in (that one is generated); "edits" lines
// are its changes and "other_edits" lines the other dimension's.
//
// Records are written generically, one field per line:
//   rec <record> <field> <i|r|t> <value>
// so a new field is saved without changing this module. Text values
// have "%" and spaces escaped.
//
// Table functions: the block edit list (g_edit_*) is a table owned
// by this module; up to MAX_EDITS entries is too many for a record.
// Files live in WORLD_FOLDER inside the 12d working folder.
// ----------------------------------------------------------------

#define WORLD_FOLDER        "cubeland_worlds"
#define WORLD_EXTENSION     ".cubeworld"
#define WORLD_FILE_TAG      "CUBELAND_WORLD"
#define WORLD_DELETED_TAG   "CUBELAND_DELETED_WORLD"
#define WORLD_FILE_VERSION  2
#define EDITS_PER_LINE      16

// The top of a world file describes it for the world list without
// reading the rest: "about <version code> <last played, seconds since
// 1970> <game mode> <version> <date words>" and THUMB_SIZE lines
// "thumb <row> <colours>" of a picture of the world taken a couple of
// seconds after it was opened (six hex digits a colour)
#define THUMB_SIZE          32
#define THUMB_CELLS         1024      // THUMB_SIZE * THUMB_SIZE
#define MAX_LISTED_WORLDS   48
#define THUMB_TABLE         49152     // MAX_LISTED_WORLDS * THUMB_CELLS
#define THUMB_FIELD_OF_VIEW 1.2       // radians across the picture
#define THUMB_DISTANCE      64.0      // blocks the picture sees
#define THUMB_AFTER_SECONDS 2.5       // the picture is taken this long after the world opens

// Kept in the world info record (and saved with it) for the about line
#define ATTR_SAVE_PLAYED      ("last_played")       // seconds since 1970
#define ATTR_SAVE_PLAYED_TEXT ("last_played_text")  // as the clock showed it

// The world list (save_list_worlds_about): "count", and for n = 1..count
#define DATATYPE_WORLD_LIST ("world_list")
#define ATTR_WL_COUNT       ("count")
#define ATTR_WL_NAME        ("name")
#define ATTR_WL_PLAYED      ("played")      // seconds since 1970, 0 if not known
#define ATTR_WL_DATE        ("date")        // "" if not known
#define ATTR_WL_MODE        ("mode")        // GAMEMODE_..., -1 if not known
#define ATTR_WL_VERSION     ("version")     // version code, 0 if not known
#define ATTR_WL_VERSION_TEXT ("version_text")
#define ATTR_WL_THUMB       ("thumb")       // TRUE if it has a picture

#define RECORD_WORLD        "world"
#define RECORD_PLAYER       "player"
#define RECORD_INVENTORY    "inventory"
#define RECORD_FURNACES     "furnaces"
#define RECORD_COWS         "cows"
#define RECORD_DROPS        "drops"

/*Global variables*/ {
  Integer g_edit_count = 0;
  Integer g_edit_index[MAX_EDITS];
  Integer g_edit_block[MAX_EDITS];
  Integer g_edit_overflow = 0;

  // The block changes of the other dimension (the one not in g_world),
  // kept while you are away and saved as "other_edits" lines
  Integer g_other_edit_count = 0;
  Integer g_other_edit_index[MAX_EDITS];
  Integer g_other_edit_block[MAX_EDITS];

  // The picture of the world being played (red * 65536 + green * 256
  // + blue, row by row from the top), and those of the listed worlds
  Integer g_thumb_ready = 0;
  Integer g_thumb_now[THUMB_CELLS];
  Integer g_thumb_list[THUMB_TABLE];
}

void    save_clear_edits  ();
void    save_record_edit  (Integer p_index, Integer p_block);
void    save_record_other_edit(Integer p_index, Integer p_block);
void    save_swap_edits   ();
void    save_apply_edits  ();
void    save_on_event     (Attributes &p_event);
Text    save_world_path   (Text p_name);
Text    save_settings_path();
void    save_ensure_folder();
Integer save_file_is_deleted(Text p_path);
Integer save_world_exists (Text p_name);
Integer save_list_worlds  (Dynamic_Text &p_names);
Integer save_delete_world (Text p_name);
void    save_clear_thumbnail();
Integer save_thumbnail_ready();
void    save_take_thumbnail (Attributes &p_player, Real p_distance);
Integer save_thumbnail_colour(Integer p_cell);
Text    save_hex_colour     (Integer p_colour);
Integer save_hex_value      (Text p_text, Integer p_position, Integer p_digits);
void    save_note_played    (Attributes &p_info, Integer p_seconds, Text p_clock);
Text    save_date_text      (Text p_clock);
Integer save_read_about     (Text p_path, Attributes &p_list, Integer p_entry);
void    save_swap_listed    (Attributes &p_list, Integer p_a, Integer p_b);
Integer save_list_worlds_about(Attributes &p_list);
Integer save_listed_colour  (Integer p_entry, Integer p_cell);
Integer save_list_files     (Attributes &p_files, Text p_folder, Text p_pattern, Integer p_with_folders);
Text    save_file_name      (Text p_path);
Integer save_word_integer (Dynamic_Text &p_words, Integer p_position);
Real    save_word_real    (Dynamic_Text &p_words, Integer p_position);
Text    text_escape       (Text p_value);
Text    text_unescape     (Text p_value);
void    save_write_record (File &p_file, Text p_name, Attributes &p_record);
Integer save_read_field   (Dynamic_Text &p_words, Integer p_count, Attributes &p_record);
Integer save_world        (Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                           Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events);
Integer save_world_to     (Text p_path, Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                           Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events);
Integer load_world_from   (Text p_path, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                           Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Text &p_problem);
Integer load_world        (Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                           Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Text &p_problem);

#endif
