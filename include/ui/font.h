#ifndef FONT_H_INCLUDED
#define FONT_H_INCLUDED

// ----------------------------------------------------------------
// Fonts for the game's text
// 12d draws text in a Draw_Box with a TrueType font chosen by name
// (Set_text_font), and only fonts installed in Windows can be used.
// A font can be picked from a list of fonts that come with Windows,
// typed in by name, or read from a .ttf / .otf / .ttc file: the
// file's name table gives the font's family name (the file must
// still be installed for 12d to draw with it).
//
// All honest apart from font_family_from_file, which reads the file
// it is given.
// ----------------------------------------------------------------

#define FONT_CHOICES         10   // entries of font_choice, the first is the default font
#define FONT_MAX_NAME        64   // longest family name read from a file

// TrueType file tags as two big-endian 16 bit halves
#define FONT_TAG_NAME_HIGH   28257   // "na"
#define FONT_TAG_NAME_LOW    28005   // "me"
#define FONT_TAG_TTCF_HIGH   29812   // "tt"
#define FONT_TAG_TTCF_LOW    25446   // "cf"

#define FONT_PLATFORM_MAC     1
#define FONT_PLATFORM_WINDOWS 3
#define FONT_NAME_FAMILY      1
#define FONT_LANGUAGE_ENGLISH 1033   // Windows en-US

Text    font_choice          (Integer p_index);
Integer font_choice_index    (Text p_font);
Text    font_next_choice     (Text p_font);
Integer font_read_u16        (File &p_file, Integer p_position);
Integer font_read_u32_high   (File &p_file, Integer p_position);
Integer font_family_from_file(Text p_path, Text &p_family, Text &p_report);
void    font_apply           (Draw_Box p_box, Text p_font);

#endif
