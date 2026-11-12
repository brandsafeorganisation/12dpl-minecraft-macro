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
// changes and reads the records back.
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
}

void    save_clear_edits  ();
void    save_record_edit  (Integer p_index, Integer p_block);
void    save_on_event     (Attributes &p_event);
Text    save_world_path   (Text p_name);
Text    save_settings_path();
void    save_ensure_folder();
Integer save_file_is_deleted(Text p_path);
Integer save_world_exists (Text p_name);
Integer save_list_worlds  (Dynamic_Text &p_names);
Integer save_delete_world (Text p_name);
Integer save_word_integer (Dynamic_Text &p_words, Integer p_position);
Real    save_word_real    (Dynamic_Text &p_words, Integer p_position);
Text    text_escape       (Text p_value);
Text    text_unescape     (Text p_value);
void    save_write_record (File &p_file, Text p_name, Attributes &p_record);
Integer save_read_field   (Dynamic_Text &p_words, Integer p_count, Attributes &p_record);
Integer save_world        (Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                           Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events);
Integer load_world        (Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                           Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Text &p_problem);

#endif
