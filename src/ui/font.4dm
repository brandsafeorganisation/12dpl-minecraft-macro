#ifndef FONT_4DM_INCLUDED
#define FONT_4DM_INCLUDED

#include "../../include/core/safety.h"
#include "../../include/core/common.h"
#include "../../include/ui/font.h"

Text font_choice(Integer p_index)
// ----------------------------------------------------------------
// Font number index (1..FONT_CHOICES) of the list the settings
// cycle through: "" (12d's default), then fonts that come with
// Windows
// ----------------------------------------------------------------
{
  if (p_index == 2 ) return "Arial";
  if (p_index == 3 ) return "Segoe UI";
  if (p_index == 4 ) return "Consolas";
  if (p_index == 5 ) return "Courier New";
  if (p_index == 6 ) return "Verdana";
  if (p_index == 7 ) return "Tahoma";
  if (p_index == 8 ) return "Trebuchet MS";
  if (p_index == 9 ) return "Georgia";
  if (p_index == 10) return "Comic Sans MS";
  return "";
}

Integer font_choice_index(Text p_font)
// ----------------------------------------------------------------
// Position of a font in the list, 0 if it isn't in it
// ----------------------------------------------------------------
{
  Integer l_index = 0;

  for (l_index = 1; l_index <= FONT_CHOICES; ++l_index) {
    if (font_choice(l_index) == p_font) return l_index;
  }
  return 0;
}

Text font_next_choice(Text p_font)
// ----------------------------------------------------------------
// The font after p_font in the list (a font typed in or read from a
// file goes back to the start of the list)
// ----------------------------------------------------------------
{
  Integer l_index = font_choice_index(p_font) + 1;

  if (l_index > FONT_CHOICES) l_index = 1;
  return font_choice(l_index);
}

Integer font_read_u16(File &p_file, Integer p_position)
// ----------------------------------------------------------------
// The big-endian 16 bit number at a position of a font file
// (File_read_short reads little-endian, signed), -1 past the end
// ----------------------------------------------------------------
{
  Integer l_value = 0;
  Integer l_low   = 0;

  File_seek(p_file, p_position);
  if (File_read_short(p_file, l_value) != 0) return -1;
  if (l_value < 0) l_value = l_value + 65536;
  l_low = l_value - 256 * Floor(l_value / 256.0);
  return l_low * 256 + Floor(l_value / 256.0);
}

Integer font_read_u32_high(File &p_file, Integer p_position)
// ----------------------------------------------------------------
// A big-endian 32 bit offset or length of a font file (these are
// well below 2^31, so they fit in an Integer)
// ----------------------------------------------------------------
{
  return font_read_u16(p_file, p_position) * 65536 + font_read_u16(p_file, p_position + 2);
}

Integer font_family_from_file(Text p_path, Text &p_family, Text &p_report)
// ----------------------------------------------------------------
// Read the family name ("Arial", "Fira Code", ...) of a TrueType or
// OpenType font file (.ttf, .otf, or the first font of a .ttc).
// Prefers the Windows English name, then any Windows name, then a
// Mac Roman one. Returns SUCCESS and sets family, or FAILURE with
// the reason in report.
// The file starts with a table directory (number of tables at 4,
// then 16 byte records from 12: tag, checksum, offset, length);
// the "name" table holds records of platform, encoding, language,
// name id, length and offset into its strings.
// ----------------------------------------------------------------
{
  File    l_file;
  Integer l_base      = 0;
  Integer l_tables    = 0;
  Integer l_table     = 0;
  Integer l_record    = 0;
  Integer l_name_at   = -1;
  Integer l_count     = 0;
  Integer l_strings   = 0;
  Integer l_platform  = 0;
  Integer l_language  = 0;
  Integer l_name_id   = 0;
  Integer l_length    = 0;
  Integer l_offset    = 0;
  Integer l_score     = 0;
  Integer l_best      = 0;
  Integer l_best_at   = 0;
  Integer l_best_len  = 0;
  Integer l_best_wide = FALSE;
  Integer l_char      = 0;
  Integer l_step      = 1;
  Integer l_position  = 0;
  Integer l_used      = 0;
  Text    l_name      = "";

  p_family = "";
  p_report = "";
  if (!File_exists(p_path)) {
    p_report = "There is no font file " + p_path + ".";
    return FAILURE;
  }
  if (safe_file_open(p_path, "rb", l_file) != 0) {
    p_report = "Couldn't open " + p_path + ".";
    return FAILURE;
  }

  // A collection (.ttc) lists its fonts; take the first
  if (font_read_u16(l_file, 0) == FONT_TAG_TTCF_HIGH && font_read_u16(l_file, 2) == FONT_TAG_TTCF_LOW) {
    l_base = font_read_u32_high(l_file, 12);
  }

  l_tables = font_read_u16(l_file, l_base + 4);
  if (l_tables < 1 || l_tables > 200) {
    File_close(l_file);
    p_report = p_path + " doesn't look like a TrueType or OpenType font.";
    return FAILURE;
  }
  for (l_table = 0; l_table < l_tables; ++l_table) {
    l_record = l_base + 12 + 16 * l_table;
    if (font_read_u16(l_file, l_record) != FONT_TAG_NAME_HIGH) continue;
    if (font_read_u16(l_file, l_record + 2) != FONT_TAG_NAME_LOW) continue;
    l_name_at = font_read_u32_high(l_file, l_record + 8);
    break;
  }
  if (l_name_at < 0) {
    File_close(l_file);
    p_report = p_path + " has no font name in it.";
    return FAILURE;
  }

  l_count   = font_read_u16(l_file, l_name_at + 2);
  l_strings = l_name_at + font_read_u16(l_file, l_name_at + 4);
  for (l_record = 0; l_record < l_count; ++l_record) {
    l_position = l_name_at + 6 + 12 * l_record;
    l_platform = font_read_u16(l_file, l_position);
    l_language = font_read_u16(l_file, l_position + 4);
    l_name_id  = font_read_u16(l_file, l_position + 6);
    l_length   = font_read_u16(l_file, l_position + 8);
    l_offset   = font_read_u16(l_file, l_position + 10);
    if (l_name_id != FONT_NAME_FAMILY || l_length < 1) continue;
    l_score = 0;
    if (l_platform == FONT_PLATFORM_MAC) l_score = 1;
    if (l_platform == FONT_PLATFORM_WINDOWS) {
      l_score = 2;
      if (l_language == FONT_LANGUAGE_ENGLISH) l_score = 3;
    }
    if (l_score <= l_best) continue;
    l_best      = l_score;
    l_best_at   = l_strings + l_offset;
    l_best_len  = l_length;
    l_best_wide = l_platform == FONT_PLATFORM_WINDOWS;
  }
  if (l_best == 0) {
    File_close(l_file);
    p_report = p_path + " has no family name that 12d can use.";
    return FAILURE;
  }

  // Windows names are UTF-16 (two bytes a character), Mac Roman one;
  // characters past ASCII become "?"
  if (l_best_wide) l_step = 2;
  l_name = "";
  for (l_position = 0; l_position < l_best_len; l_position = l_position + l_step) {
    if (l_used >= FONT_MAX_NAME) break;
    if (l_best_wide) {
      l_char = font_read_u16(l_file, l_best_at + l_position);
    } else {
      l_char = font_read_u16(l_file, l_best_at + l_position);
      l_char = Floor(l_char / 256.0);
    }
    if (l_char < 32) continue;
    if (l_char > 126) l_char = 63;
    ++l_used;
    l_name = l_name + " ";
    Set_char(l_name, l_used, l_char);
  }
  File_close(l_file);

  if (l_name == "") {
    p_report = p_path + " has an empty family name.";
    return FAILURE;
  }
  p_family = l_name;
  return SUCCESS;
}

void font_apply(Draw_Box p_box, Text p_font)
// ----------------------------------------------------------------
// Use a font for the text drawn next in a Draw_Box ("" leaves 12d's
// default font)
// ----------------------------------------------------------------
{
  if (p_font != "") Set_text_font(p_box, p_font);
}

#endif
