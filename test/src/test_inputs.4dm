#ifndef TEST_INPUTS_4DM_INCLUDED
#define TEST_INPUTS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/records.h"
#include "../../include/blocks/blocks.h"
#include "../../include/blocks/textures.h"
#include "../../include/items/inventory.h"
#include "../../include/net/net.h"
#include "../include/test.h"
#include "../include/test_registry.h"

// ----------------------------------------------------------------
// The values each parameter gets, chosen by its name (and, where a
// name means different things, by its function). A typical call uses
// the "typical" value; random calls pick from the range, or from the
// list for Text. Names follow the code's own: p_x is a cell or a
// position, p_item an item, p_now the clock and so on. Add a rule
// here when a function needs values its names don't give it.
// ----------------------------------------------------------------

void test_reset_words(Dynamic_Text &p_words, Text p_text)
// ----------------------------------------------------------------
// Fill a Dynamic_Text with the words of p_text
// ----------------------------------------------------------------
{
  Null(p_words);
  From_text(p_text, p_words);
}

Text test_words_text(Dynamic_Text &p_words)
// ----------------------------------------------------------------
// The words of a Dynamic_Text joined with spaces
// ----------------------------------------------------------------
{
  Integer l_count = 0;
  Integer l_word  = 0;
  Text    l_text  = "";
  Text    l_item  = "";

  Get_number_of_items(p_words, l_count);
  for (l_word = 1; l_word <= l_count; ++l_word) {
    Get_item(p_words, l_word, l_item);
    if (l_word > 1) l_text = l_text + " ";
    l_text = l_text + l_item;
  }
  return l_text;
}

Text test_quote()
// ----------------------------------------------------------------
// A double quote mark (made from its character code rather than
// written as an escape inside a string)
// ----------------------------------------------------------------
{
  Text l_quote = " ";

  Set_char(l_quote, 1, 34);
  return l_quote;
}

Integer test_name_ends(Text p_name, Text p_end)
// ----------------------------------------------------------------
// TRUE if the parameter name is p_end or ends in "_" + p_end
// ("p_x", "p_cell_x" and "p_player_x" all end in x)
// ----------------------------------------------------------------
{
  Integer l_length = Text_length(p_name);
  Integer l_end    = Text_length(p_end);

  if (p_name == "p_" + p_end) return TRUE;
  if (l_length <= l_end + 1) return FALSE;
  if (Get_subtext(p_name, l_length - l_end, l_length) == "_" + p_end) return TRUE;
  return FALSE;
}

void test_number_rule(Text p_function, Integer p_kind, Text p_name, Real &p_low, Real &p_high, Real &p_typical, Text &p_rule)
// ----------------------------------------------------------------
// Range and typical value of an Integer (p_kind TEST_KIND_INTEGER)
// or Real parameter, and the name of the rule that chose them
// ----------------------------------------------------------------
{
  Integer l_integer = p_kind == TEST_KIND_INTEGER;

  // (whole numbers start at 1: most of the game's tables are numbered
  // from 1, so 0 would only find that a table has no entry 0)
  p_rule = "default";
  p_low = 1.0;  p_high = 10.0;  p_typical = 1.0;
  if (!l_integer) {
    p_low = -10.0;  p_high = 10.0;  p_typical = 1.5;
  }

  // -------- functions whose numbers mean something special
  if (p_function == "Set_char" && p_name == "p_position") {
    p_rule = "a letter of the text";  p_low = 1.0;  p_high = 5.0;  p_typical = 1.0;  return;
  }
  if (p_function == "Set_char" && p_name == "p_char") {
    p_rule = "a character code";  p_low = 32.0;  p_high = 126.0;  p_typical = 65.0;  return;
  }
  if (p_function == "Get_subtext" || p_function == "To_text") {
    if (p_name == "p_start" || p_name == "p_end" || p_name == "p_decimals") {
      p_rule = "a position in the text";  p_low = 0.0;  p_high = 12.0;  p_typical = 3.0;  return;
    }
  }
  if (Find_text(p_function, "inflate_") == 1 && p_name == "p_table") {
    p_rule = "a Huffman table";  p_low = 1.0;  p_high = 2.0;  p_typical = 1.0;  return;
  }
  if (p_function == "inflate_build" && p_name == "p_first") {
    p_rule = "the first code length";  p_low = 1.0;  p_high = 30.0;  p_typical = 1.0;  return;
  }
  if (p_function == "inflate_build" && p_name == "p_count") {
    p_rule = "code lengths in the table";  p_low = 1.0;  p_high = 288.0;  p_typical = 30.0;  return;
  }
  if (p_name == "p_bit_depth") {
    p_rule = "8 bits a sample (1, 2 and 4 are packed differently; 16 is read as 8)";  p_low = 8.0;  p_high = 8.0;  p_typical = 8.0;  return;
  }
  if (p_function == "png_sample" && p_name == "p_channels") {
    p_rule = "channels a pixel";  p_low = 1.0;  p_high = 4.0;  p_typical = 3.0;  return;
  }
  if (p_function == "png_sample" && p_name == "p_channel") {
    p_rule = "the first channel";  p_low = 1.0;  p_high = 1.0;  p_typical = 1.0;  return;
  }
  if (p_name == "p_row_start") {
    p_rule = "where a row starts in the image data";  p_low = 1.0;  p_high = 64.0;  p_typical = 1.0;  return;
  }
  if (p_function == "pack_distance" && p_name == "p_colour") {
    p_rule = "a distinct colour";  p_low = 1.0;  p_high = 256.0;  p_typical = 1.0;  return;
  }
  if (p_name == "p_cluster") {
    p_rule = "a palette cluster";  p_low = 1.0;  p_high = PALETTE_SIZE;  p_typical = 1.0;  return;
  }
  if (p_function == "render_mob_part_nearer" && (p_name == "p_a" || p_name == "p_b")) {
    p_rule = "a part of the animal being drawn";  p_low = 1.0;  p_high = MOB_MAX_PARTS;  p_typical = 1.0;  return;
  }
  if (p_name == "p_positive") {
    p_rule = "zero or more";  p_low = 0.0;  p_high = 10000.0;  p_typical = 2.0;  return;
  }
  if ((p_function == "texture_noise" || p_function == "texture_blotch") && p_name == "p_cell") {
    p_rule = "noise spacing in pixels (divides 16)";  p_low = 1.0;  p_high = 16.0;  p_typical = 4.0;  return;
  }
  if (p_name == "p_cell") {
    p_rule = "a cell value (block + light)";  p_low = 0.0;  p_high = CELL_VALUES - 1;  p_typical = BLOCK_STONE;  return;
  }
  if (p_name == "p_sx" || p_name == "p_sz") {
    p_rule = "a mesh section across";  p_low = 0.0;  p_high = SECTIONS_X - 1;  p_typical = 4.0;  return;
  }
  if (p_name == "p_sy") {
    p_rule = "a mesh section up";  p_low = 0.0;  p_high = SECTIONS_Y - 1;  p_typical = 3.0;  return;
  }
  if (p_name == "p_entry") {
    p_rule = "a table entry";  p_low = 1.0;  p_high = 10.0;  p_typical = 1.0;  return;
  }

  // -------- whole numbers
  if (l_integer) {
    if (test_name_ends(p_name, "x") || test_name_ends(p_name, "x0") || test_name_ends(p_name, "x1") ||
        test_name_ends(p_name, "z") || test_name_ends(p_name, "z0") || test_name_ends(p_name, "z1")) {
      p_rule = "a cell across the world";  p_low = 0.0;  p_high = WORLD_SIZE_X - 1;  p_typical = 64.0;  return;
    }
    if (test_name_ends(p_name, "y") || test_name_ends(p_name, "y0") || test_name_ends(p_name, "y1")) {
      p_rule = "a cell height";  p_low = 0.0;  p_high = WORLD_HEIGHT - 1;  p_typical = 70.0;  return;
    }
    if (test_name_ends(p_name, "block")) {
      p_rule = "a block";  p_low = 0.0;  p_high = BLOCK_BED_LAST;  p_typical = BLOCK_STONE;  return;
    }
    if (test_name_ends(p_name, "item") || p_name == "p_food") {
      p_rule = "an item";  p_low = 0.0;  p_high = MAX_ITEM_ID;  p_typical = ITEM_STONE;  return;
    }
    if (test_name_ends(p_name, "slot")) {
      p_rule = "an inventory slot";  p_low = 0.0;  p_high = INVENTORY_SLOTS;  p_typical = 1.0;  return;
    }
    if (p_name == "p_count" || p_name == "p_amount") {
      p_rule = "a stack size";  p_low = 0.0;  p_high = 64.0;  p_typical = 3.0;  return;
    }
    if (p_name == "p_damage") {
      p_rule = "tool wear";  p_low = 0.0;  p_high = 60.0;  p_typical = 0.0;  return;
    }
    if (p_name == "p_tex" || Find_text(p_name, "p_tex_") == 1 || test_name_ends(p_name, "tex")) {
      p_rule = "a texture";  p_low = 1.0;  p_high = NUM_TEXTURES;  p_typical = 1.0;  return;
    }
    if (p_name == "p_cow" || p_name == "p_mob") {
      p_rule = "a mob";  p_low = 1.0;  p_high = MAX_COWS;  p_typical = 1.0;  return;
    }
    if (p_name == "p_drop") {
      p_rule = "a dropped item";  p_low = 1.0;  p_high = MAX_DROPS;  p_typical = 1.0;  return;
    }
    if (p_name == "p_furnace" || p_name == "p_chest") {
      p_rule = "a furnace or chest";  p_low = 1.0;  p_high = MAX_FURNACES;  p_typical = 1.0;  return;
    }
    if (p_name == "p_peer") {
      p_rule = "another player";  p_low = 1.0;  p_high = MAX_PEERS;  p_typical = 1.0;  return;
    }
    if (p_name == "p_direction" || p_name == "p_face" || p_name == "p_facing") {
      p_rule = "a direction";  p_low = DIR_PX;  p_high = DIR_NZ;  p_typical = DIR_PY;  return;
    }
    if (p_name == "p_seed" || p_name == "p_salt") {
      p_rule = "a seed";  p_low = 1.0;  p_high = 999999.0;  p_typical = TEST_WORLD_SEED;  return;
    }
    if (p_name == "p_screen") {
      p_rule = "a screen";  p_low = 0.0;  p_high = 5.0;  p_typical = 1.0;  return;
    }
    if (p_name == "p_mode") {
      p_rule = "a mode";  p_low = 0.0;  p_high = 2.0;  p_typical = 1.0;  return;
    }
    if (p_name == "p_kind") {
      p_rule = "a mob kind";  p_low = 0.0;  p_high = 2.0;  p_typical = 0.0;  return;
    }
    if (p_name == "p_type") {
      p_rule = "an event";  p_low = 1.0;  p_high = 19.0;  p_typical = 1.0;  return;
    }
    if (p_name == "p_pool") {
      p_rule = "a slot pool";  p_low = 1.0;  p_high = 3.0;  p_typical = 1.0;  return;
    }
    if (p_name == "p_u" || p_name == "p_v" || p_name == "p_u0" || p_name == "p_v0" || p_name == "p_u1" || p_name == "p_v1") {
      p_rule = "a texture pixel";  p_low = 1.0;  p_high = 16.0;  p_typical = 8.0;  return;
    }
    if (p_name == "p_red" || p_name == "p_green" || p_name == "p_blue") {
      p_rule = "a colour";  p_low = 0.0;  p_high = 255.0;  p_typical = 128.0;  return;
    }
    if (p_name == "p_grid_width") {
      p_rule = "a crafting grid";  p_low = 2.0;  p_high = 3.0;  p_typical = 2.0;  return;
    }
    if (p_name == "p_column" || p_name == "p_row" || p_name == "p_left" || p_name == "p_top") {
      p_rule = "a grid row or column";  p_low = 1.0;  p_high = 3.0;  p_typical = 1.0;  return;
    }
    if (p_name == "p_first") {
      p_rule = "a first slot";  p_low = 1.0;  p_high = 9.0;  p_typical = 1.0;  return;
    }
    if (p_name == "p_last") {
      p_rule = "a last slot";  p_low = 10.0;  p_high = INVENTORY_SLOTS;  p_typical = INVENTORY_SLOTS;  return;
    }
    if (p_name == "p_health") {
      p_rule = "health";  p_low = 0.0;  p_high = PLAYER_MAX_HEALTH;  p_typical = 10.0;  return;
    }
    if (p_name == "p_crack") {
      p_rule = "a crack stage";  p_low = 0.0;  p_high = 9.0;  p_typical = 3.0;  return;
    }
    if (p_name == "p_on" || p_name == "p_open" || p_name == "p_up" || p_name == "p_captured" || p_name == "p_take_only" ||
        p_name == "p_right_button" || p_name == "p_highlight" || p_name == "p_hovered" || p_name == "p_flying" ||
        p_name == "p_creative" || p_name == "p_running" || p_name == "p_quick" || p_name == "p_auto_jump" ||
        p_name == "p_used" || p_name == "p_mirrored" || p_name == "p_leave_player" || p_name == "p_dead" ||
        p_name == "p_screen_open" || p_name == "p_lit") {
      p_rule = "TRUE or FALSE";  p_low = 0.0;  p_high = 1.0;  p_typical = 1.0;  return;
    }
    if (p_name == "p_position" || p_name == "p_index" || p_name == "p_which" || p_name == "p_recipe" || p_name == "p_word" ||
        p_name == "p_byte" || p_name == "p_part") {
      p_rule = "a small number from 1";  p_low = 1.0;  p_high = 4.0;  p_typical = 1.0;  return;
    }
    if (p_name == "p_width" || p_name == "p_height" || p_name == "p_range" || p_name == "p_radius") {
      p_rule = "a small size";  p_low = 1.0;  p_high = 16.0;  p_typical = 4.0;  return;
    }
    return;
  }

  // -------- Reals
  if (test_name_ends(p_name, "x") || test_name_ends(p_name, "z") || test_name_ends(p_name, "x0") || test_name_ends(p_name, "z0") ||
      test_name_ends(p_name, "x1") || test_name_ends(p_name, "z1")) {
    p_rule = "a position across the world";  p_low = 1.0;  p_high = WORLD_SIZE_X - 1;  p_typical = 64.5;
    if (Find_text(p_name, "dir") > 0 || Find_text(p_name, "push") > 0 || Find_text(p_name, "away") > 0 || Find_text(p_name, "rel") > 0) {
      p_rule = "part of a direction";  p_low = -1.0;  p_high = 1.0;  p_typical = 0.6;
    }
    if (Find_text(p_name, "box") > 0) {
      p_rule = "a point in the view";  p_low = 0.0;  p_high = 860.0;  p_typical = 400.0;
    }
    return;
  }
  if (test_name_ends(p_name, "y") || test_name_ends(p_name, "y0") || test_name_ends(p_name, "y1")) {
    p_rule = "a height in the world";  p_low = 1.0;  p_high = WORLD_HEIGHT - 1;  p_typical = 72.0;
    if (Find_text(p_name, "dir") > 0 || Find_text(p_name, "rel") > 0) {
      p_rule = "part of a direction";  p_low = -1.0;  p_high = 1.0;  p_typical = -0.3;
    }
    if (Find_text(p_name, "box") > 0 || Find_text(p_name, "centre") > 0) {
      p_rule = "a point in the view";  p_low = 0.0;  p_high = 520.0;  p_typical = 260.0;
    }
    return;
  }
  if (p_name == "p_now" || p_name == "p_time" || p_name == "p_age") {
    p_rule = "the clock (seconds)";  p_low = 0.0;  p_high = 100000.0;  p_typical = 100.0;  return;
  }
  if (p_name == "p_dt" || p_name == "p_real_dt") {
    p_rule = "a frame time";  p_low = 0.0;  p_high = 0.1;  p_typical = 0.033;  return;
  }
  if (p_name == "p_yaw" || p_name == "p_angle" || p_name == "p_turn" || p_name == "p_yaw_change") {
    p_rule = "an angle";  p_low = 0.0;  p_high = 6.283;  p_typical = 1.0;  return;
  }
  if (p_name == "p_pitch" || p_name == "p_pitch_change") {
    p_rule = "looking up or down";  p_low = -1.5;  p_high = 1.5;  p_typical = -0.2;  return;
  }
  if (p_name == "p_time_of_day") {
    p_rule = "a time of day";  p_low = 0.0;  p_high = 1.0;  p_typical = 0.3;  return;
  }
  if (p_name == "p_w" || p_name == "p_width") {
    p_rule = "a view width";  p_low = 200.0;  p_high = 1600.0;  p_typical = 860.0;  return;
  }
  if (p_name == "p_h" || p_name == "p_height") {
    p_rule = "a view height";  p_low = 150.0;  p_high = 1000.0;  p_typical = 520.0;  return;
  }
  if (p_name == "p_size" || p_name == "p_length" || p_name == "p_slot_size") {
    p_rule = "a size on screen";  p_low = 4.0;  p_high = 64.0;  p_typical = 32.0;  return;
  }
  if (p_name == "p_red" || p_name == "p_green" || p_name == "p_blue") {
    p_rule = "a colour";  p_low = 0.0;  p_high = 255.0;  p_typical = 128.0;  return;
  }
  if (p_name == "p_tint" || p_name == "p_shade" || p_name == "p_light" || p_name == "p_brightness" || p_name == "p_amount" ||
      p_name == "p_progress" || p_name == "p_wet" || p_name == "p_swing" || p_name == "p_swing_time" || p_name == "p_bob" ||
      p_name == "p_idle" || p_name == "p_first" || p_name == "p_second" || p_name == "p_third") {
    p_rule = "0 to 1";  p_low = 0.0;  p_high = 1.0;  p_typical = 0.5;  return;
  }
  if (p_name == "p_frame_ms") {
    p_rule = "milliseconds";  p_low = 0.0;  p_high = 100.0;  p_typical = 16.0;  return;
  }
  if (p_name == "p_max_distance" || p_name == "p_radius" || p_name == "p_keep_away" || p_name == "p_limit") {
    p_rule = "a distance";  p_low = 0.0;  p_high = 50.0;  p_typical = 5.0;  return;
  }
  if (p_name == "p_distance_squared" || p_name == "p_sort_dist_sq") {
    p_rule = "a squared distance";  p_low = 0.0;  p_high = 10000.0;  p_typical = 25.0;  return;
  }
}

Integer test_text_choices(Text p_function, Text p_name)
// ----------------------------------------------------------------
// How many values a Text parameter can have (test_text_choice)
// ----------------------------------------------------------------
{
  Integer l_pick  = 0;
  Integer l_count = 0;

  // count the list rather than keep a second copy of its length
  for (l_pick = 1; l_pick <= 20; ++l_pick) {
    if (test_text_choice(p_function, p_name, l_pick) == "<end>") return l_count;
    ++l_count;
  }
  return l_count;
}

Text test_text_choice(Text p_function, Text p_name, Integer p_pick)
// ----------------------------------------------------------------
// Value p_pick of a Text parameter (0 is the typical one, past the
// end of the list "<end>"). Paths and names all start "zz_test" and
// stay in cubeland_worlds, so nothing a test writes can land on a
// saved world.
// ----------------------------------------------------------------
{
  Integer l_pick = p_pick;

  if (l_pick == 0) l_pick = 1;
  if (p_name == "p_key" || p_name == "p_msg") {
    if (l_pick == 1) return "w";
    if (l_pick == 2) return "a";
    if (l_pick == 3) return " ";
    if (l_pick == 4) return "e";
    if (l_pick == 5) return "c";
    if (l_pick == 6) return "backspace";
    if (l_pick == 7) return "escape";
    if (l_pick == 8) return "x";
    return "<end>";
  }
  if (p_name == "p_name" || p_name == "p_world_name" || p_name == "p_title") {
    if (l_pick == 1) return "zz_test";
    if (l_pick == 2) return "zz test world";
    if (l_pick == 3) return "";
    if (l_pick == 4) return "zz_test_2";
    return "<end>";
  }
  if (p_name == "p_path" || p_name == "p_file") {
    if (l_pick == 1) return "cubeland_worlds\\zz_test_missing.txt";
    if (l_pick == 2) return "cubeland_worlds\\zz_test_file.txt";
    if (l_pick == 3) return "";
    return "<end>";
  }
  if (p_name == "p_folder") {
    if (l_pick == 1) return "cubeland_worlds\\zz_test_mp";
    if (l_pick == 2) return "cubeland_worlds\\zz_test_missing";
    return "<end>";
  }
  if (p_name == "p_field") {
    // a field of the function's own, so functions that write a field
    // as one type never meet one that reads it as another
    if (l_pick == 1) return "zz_" + p_function;
    if (l_pick == 2) return "zz_" + p_function + "_2";
    return "<end>";
  }
  if (p_name == "p_line") {
    if (l_pick == 1) return "/give @p stone 3";
    if (l_pick == 2) return "/time set night";
    if (l_pick == 3) return "/gamemode creative";
    if (l_pick == 4) return "hello";
    if (l_pick == 5) return "";
    if (l_pick == 6) return "P 1.5 70 2.5 0.3 0.1 ~";
    if (l_pick == 7) return "B 10 70 10 3 ~";
    if (l_pick == 8) return "J bob ~";
    return "<end>";
  }
  if (p_name == "p_search" || p_name == "p_find" || p_name == "p_pattern") {
    if (l_pick == 1) return "o";
    if (l_pick == 2) return "iron";
    if (l_pick == 3) return "";
    if (l_pick == 4) return "zz";
    return "<end>";
  }
  if (p_name == "p_number") {
    if (l_pick == 1) return "42";
    if (l_pick == 2) return "-7.5";
    if (l_pick == 3) return "abc";
    if (l_pick == 4) return "";
    if (l_pick == 5) return "3 4";
    return "<end>";
  }
  if (p_name == "p_session" || p_name == "p_id" || p_name == "p_host_id") {
    if (l_pick == 1) return "zz_test_1234";
    if (l_pick == 2) return "bob_5678";
    return "<end>";
  }
  if (p_name == "p_word") {
    if (l_pick == 1) return "creative";
    if (l_pick == 2) return "s";
    if (l_pick == 3) return "3";
    if (l_pick == 4) return "zz";
    return "<end>";
  }
  if (p_name == "p_font") {
    if (l_pick == 1) return "Arial";
    if (l_pick == 2) return "";
    if (l_pick == 3) return "Courier New";
    return "<end>";
  }
  if (p_name == "p_datatype" || p_name == "p_kind" || p_name == "p_mode") {
    if (l_pick == 1) return "test";
    if (l_pick == 2) return "";
    return "<end>";
  }
  if (p_name == "p_with" || p_name == "p_text" && p_function == "Set_char") {
    if (l_pick == 1) return "Hello";
    return "<end>";
  }
  if (l_pick == 1) return "Hello World";
  if (l_pick == 2) return "";
  if (l_pick == 3) return "a";
  if (l_pick == 4) return "42";
  if (l_pick == 5) return "stone";
  if (l_pick == 6) return "  padded  ";
  return "<end>";
}

void test_params_prepare(Attributes &p_info, Attributes &p_params)
// ----------------------------------------------------------------
// Work out a function's parameters from its registry entry ("I:p_x
// &R:p_y A:p_player"): kind, name, input field and the values it
// gets
// ----------------------------------------------------------------
{
  Dynamic_Text l_words;
  Integer      l_count    = 0;
  Integer      l_param    = 0;
  Integer      l_kind     = 0;
  Integer      l_ref      = FALSE;
  Integer      l_colon    = 0;
  Integer      l_integers = 0;
  Integer      l_reals    = 0;
  Integer      l_texts    = 0;
  Real         l_low      = 0.0;
  Real         l_high     = 0.0;
  Real         l_typical  = 0.0;
  Text         l_word     = "";
  Text         l_letter   = "";
  Text         l_name     = "";
  Text         l_field    = "";
  Text         l_rule     = "";
  Text         l_function = record_text(p_info, ATTR_TEST_NAME);

  record_clear(p_params, DATATYPE_TEST_PARAMS);
  From_text(record_text(p_info, ATTR_TEST_PARAMS), l_words);
  Get_number_of_items(l_words, l_count);
  for (l_param = 1; l_param <= l_count; ++l_param) {
    Get_item(l_words, l_param, l_word);
    l_ref = FALSE;
    if (Get_subtext(l_word, 1, 1) == "&") {
      l_ref  = TRUE;
      l_word = Get_subtext(l_word, 2, Text_length(l_word));
    }
    l_colon  = Find_text(l_word, ":");
    l_letter = Get_subtext(l_word, 1, l_colon - 1);
    l_name   = Get_subtext(l_word, l_colon + 1, Text_length(l_word));
    l_field  = "";
    l_rule   = "";
    l_low    = 0.0;
    l_high   = 0.0;
    l_typical= 0.0;
    l_kind   = TEST_KIND_RECORD;
    if (l_letter == "I") {
      l_kind = TEST_KIND_INTEGER;
      ++l_integers;
      l_field = "i" + To_text(l_integers);
    } else if (l_letter == "R") {
      l_kind = TEST_KIND_REAL;
      ++l_reals;
      l_field = "r" + To_text(l_reals);
    } else if (l_letter == "T") {
      l_kind = TEST_KIND_TEXT;
      ++l_texts;
      l_field = "t" + To_text(l_texts);
      l_high  = test_text_choices(l_function, l_name);
      l_rule  = To_text(floor_integer(l_high)) + " values";
    } else if (l_letter == "B") {
      l_kind = TEST_KIND_BOX;
      l_rule = "the panel drawing box";
    } else if (l_letter == "D") {
      l_kind = TEST_KIND_WORDS;
      l_rule = TEST_TYPICAL_WORDS;
      l_rule = "the words of " + l_rule;
    } else if (l_letter == "M") {
      l_kind = TEST_KIND_MESSAGE;
      l_rule = "the panel message line";
    } else {
      l_rule = "the game record";
    }
    if (l_kind == TEST_KIND_INTEGER || l_kind == TEST_KIND_REAL) {
      l_high = 0.0;
      test_number_rule(l_function, l_kind, l_name, l_low, l_high, l_typical, l_rule);
    }
    record_set_integer_at(p_params, ATTR_TP_KIND,    l_param, l_kind);
    record_set_text_at   (p_params, ATTR_TP_NAME,    l_param, l_name);
    record_set_integer_at(p_params, ATTR_TP_REF,     l_param, l_ref);
    record_set_text_at   (p_params, ATTR_TP_FIELD,   l_param, l_field);
    record_set_real_at   (p_params, ATTR_TP_LOW,     l_param, l_low);
    record_set_real_at   (p_params, ATTR_TP_HIGH,    l_param, l_high);
    record_set_real_at   (p_params, ATTR_TP_TYPICAL, l_param, l_typical);
    record_set_text_at   (p_params, ATTR_TP_RULE,    l_param, l_rule);
  }
  record_set_integer(p_params, ATTR_TP_COUNT, l_count);
}

Integer test_edge_side(Integer p_call, Integer p_param)
// ----------------------------------------------------------------
// Which end of its range parameter p_param takes in call p_call of
// the edge data set: 1 the low end, 2 the high end. Calls go round
// all low, all high, then low and high taking turns both ways.
// ----------------------------------------------------------------
{
  Integer l_round = positive_mod(p_call - 1, 4);

  if (l_round == 0) return 1;
  if (l_round == 1) return 2;
  if (l_round == 2) return 1 + positive_mod(p_param, 2);
  return 2 - positive_mod(p_param, 2);
}

Text test_set_name(Integer p_set)
// ----------------------------------------------------------------
// The name of data set p_set (TEST_SET_*)
// ----------------------------------------------------------------
{
  if (p_set == TEST_SET_TYPICAL) return "typical";
  if (p_set == TEST_SET_RANDOM ) return "random";
  if (p_set == TEST_SET_EDGES  ) return "edges";
  return "?";
}

void test_make_inputs(Attributes &p_info, Attributes &p_params, Integer p_set, Integer p_call, Attributes &p_random, Attributes &p_in)
// ----------------------------------------------------------------
// Fill the input record for call p_call of data set p_set:
//   TEST_SET_TYPICAL  each parameter's typical value
//   TEST_SET_RANDOM   random values from each parameter's range
//   TEST_SET_EDGES    the ends of each range (see test_edge_side)
// ----------------------------------------------------------------
{
  Integer l_count    = record_integer(p_params, ATTR_TP_COUNT);
  Integer l_param    = 0;
  Integer l_kind     = 0;
  Integer l_pick     = 0;
  Integer l_choices  = 0;
  Integer l_value    = 0;
  Integer l_side     = 0;
  Real    l_low      = 0.0;
  Real    l_high     = 0.0;
  Real    l_real     = 0.0;
  Text    l_field    = "";
  Text    l_name     = "";
  Text    l_function = record_text(p_info, ATTR_TEST_NAME);

  record_clear   (p_in, DATATYPE_TEST_INFO);
  record_set_text(p_in, ATTR_TEST_WORDS, TEST_TYPICAL_WORDS);
  for (l_param = 1; l_param <= l_count; ++l_param) {
    l_kind  = record_integer_at(p_params, ATTR_TP_KIND,  l_param);
    l_field = record_text_at   (p_params, ATTR_TP_FIELD, l_param);
    l_name  = record_text_at   (p_params, ATTR_TP_NAME,  l_param);
    l_low   = record_real_at   (p_params, ATTR_TP_LOW,   l_param);
    l_high  = record_real_at   (p_params, ATTR_TP_HIGH,  l_param);
    l_side  = test_edge_side(p_call, l_param);
    if (l_kind == TEST_KIND_INTEGER) {
      l_value = floor_integer(record_real_at(p_params, ATTR_TP_TYPICAL, l_param));
      if (p_set == TEST_SET_RANDOM) l_value = random_range(p_random, floor_integer(l_low), floor_integer(l_high));
      if (p_set == TEST_SET_EDGES && l_side == 1) l_value = floor_integer(l_low);
      if (p_set == TEST_SET_EDGES && l_side == 2) l_value = floor_integer(l_high);
      record_set_integer(p_in, l_field, l_value);
    } else if (l_kind == TEST_KIND_REAL) {
      l_real = record_real_at(p_params, ATTR_TP_TYPICAL, l_param);
      if (p_set == TEST_SET_RANDOM) l_real = random_between(p_random, l_low, l_high);
      if (p_set == TEST_SET_EDGES && l_side == 1) l_real = l_low;
      if (p_set == TEST_SET_EDGES && l_side == 2) l_real = l_high;
      record_set_real(p_in, l_field, l_real);
    } else if (l_kind == TEST_KIND_TEXT) {
      l_pick    = 0;
      l_choices = floor_integer(l_high);
      if (l_choices > 0) {
        if (p_set == TEST_SET_RANDOM) l_pick = random_range(p_random, 1, l_choices);
        if (p_set == TEST_SET_EDGES && l_side == 1) l_pick = 1;
        if (p_set == TEST_SET_EDGES && l_side == 2) l_pick = l_choices;
      }
      record_set_text(p_in, l_field, test_text_choice(l_function, l_name, l_pick));
    }
  }
}

Text test_inputs_text(Attributes &p_params, Attributes &p_in)
// ----------------------------------------------------------------
// One call's inputs for the report: "p_x = 64, p_name = "zz_test""
// ----------------------------------------------------------------
{
  Integer l_count = record_integer(p_params, ATTR_TP_COUNT);
  Integer l_param = 0;
  Integer l_kind  = 0;
  Text    l_field = "";
  Text    l_text  = "";
  Text    l_quote = test_quote();

  for (l_param = 1; l_param <= l_count; ++l_param) {
    l_kind  = record_integer_at(p_params, ATTR_TP_KIND,  l_param);
    l_field = record_text_at   (p_params, ATTR_TP_FIELD, l_param);
    if (l_param > 1) l_text = l_text + ", ";
    l_text = l_text + record_text_at(p_params, ATTR_TP_NAME, l_param) + " = ";
    if (l_kind == TEST_KIND_INTEGER) {
      l_text = l_text + To_text(record_integer(p_in, l_field));
    } else if (l_kind == TEST_KIND_REAL) {
      l_text = l_text + To_text(record_real(p_in, l_field), 4);
    } else if (l_kind == TEST_KIND_TEXT) {
      l_text = l_text + l_quote + record_text(p_in, l_field) + l_quote;
    } else if (l_kind == TEST_KIND_WORDS) {
      l_text = l_text + "{" + record_text(p_in, ATTR_TEST_WORDS) + "}";
    } else if (l_kind == TEST_KIND_BOX) {
      l_text = l_text + "(draw box)";
    } else if (l_kind == TEST_KIND_MESSAGE) {
      l_text = l_text + "(message line)";
    } else {
      l_text = l_text + "(record)";
    }
  }
  return l_text;
}

Text test_outputs_text(Attributes &p_info, Attributes &p_params, Attributes &p_out)
// ----------------------------------------------------------------
// One call's outputs for the report: the return value, then each
// reference parameter as it was afterwards
// ----------------------------------------------------------------
{
  Integer l_count   = record_integer(p_params, ATTR_TP_COUNT);
  Integer l_param   = 0;
  Integer l_kind    = 0;
  Text    l_field   = "";
  Text    l_text    = "";
  Text    l_returns = record_text(p_info, ATTR_TEST_RETURNS);
  Text    l_quote   = test_quote();

  if (l_returns == "Integer") l_text = "returns " + To_text(record_integer(p_out, ATTR_TEST_RET_I));
  if (l_returns == "Real"   ) l_text = "returns " + To_text(record_real(p_out, ATTR_TEST_RET_R), 6);
  if (l_returns == "Text"   ) l_text = "returns " + l_quote + record_text(p_out, ATTR_TEST_RET_T) + l_quote;
  for (l_param = 1; l_param <= l_count; ++l_param) {
    if (record_integer_at(p_params, ATTR_TP_REF, l_param) != TRUE) continue;
    l_kind  = record_integer_at(p_params, ATTR_TP_KIND,  l_param);
    l_field = record_text_at   (p_params, ATTR_TP_FIELD, l_param);
    if (l_kind != TEST_KIND_INTEGER && l_kind != TEST_KIND_REAL && l_kind != TEST_KIND_TEXT && l_kind != TEST_KIND_WORDS) continue;
    if (l_text != "") l_text = l_text + ", ";
    l_text = l_text + record_text_at(p_params, ATTR_TP_NAME, l_param) + " = ";
    if (l_kind == TEST_KIND_INTEGER) l_text = l_text + To_text(record_integer(p_out, l_field));
    if (l_kind == TEST_KIND_REAL   ) l_text = l_text + To_text(record_real(p_out, l_field), 4);
    if (l_kind == TEST_KIND_TEXT   ) l_text = l_text + l_quote + record_text(p_out, l_field) + l_quote;
    if (l_kind == TEST_KIND_WORDS  ) l_text = l_text + "{" + record_text(p_out, ATTR_TEST_WORDS) + "}";
  }
  if (l_text == "") l_text = "(nothing returned)";
  return l_text;
}

Text test_domains_text(Attributes &p_params)
// ----------------------------------------------------------------
// Where each parameter's values come from, for the report:
// "p_x: a cell across the world, 0 to 127 (typical 64) ; p_y: ..."
// ----------------------------------------------------------------
{
  Integer l_count = record_integer(p_params, ATTR_TP_COUNT);
  Integer l_param = 0;
  Integer l_kind  = 0;
  Text    l_text  = "";

  for (l_param = 1; l_param <= l_count; ++l_param) {
    l_kind = record_integer_at(p_params, ATTR_TP_KIND, l_param);
    if (l_param > 1) l_text = l_text + " ; ";
    l_text = l_text + record_text_at(p_params, ATTR_TP_NAME, l_param) + ": " + record_text_at(p_params, ATTR_TP_RULE, l_param);
    if (l_kind == TEST_KIND_INTEGER) {
      l_text = l_text + ", " + To_text(floor_integer(record_real_at(p_params, ATTR_TP_LOW, l_param))) + " to " +
               To_text(floor_integer(record_real_at(p_params, ATTR_TP_HIGH, l_param))) + " (typical " +
               To_text(floor_integer(record_real_at(p_params, ATTR_TP_TYPICAL, l_param))) + ")";
    } else if (l_kind == TEST_KIND_REAL) {
      l_text = l_text + ", " + To_text(record_real_at(p_params, ATTR_TP_LOW, l_param), 3) + " to " +
               To_text(record_real_at(p_params, ATTR_TP_HIGH, l_param), 3) + " (typical " +
               To_text(record_real_at(p_params, ATTR_TP_TYPICAL, l_param), 3) + ")";
    }
  }
  return l_text;
}

#endif
