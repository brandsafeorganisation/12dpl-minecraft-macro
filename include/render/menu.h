#ifndef MENU_H_INCLUDED
#define MENU_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// The menus drawn inside the game's view: the title screen, the
// world list, creating a world, multiplayer, the options and the
// resource pack and skin pickers. There are no 12d buttons or boxes:
// each screen is laid out as a list of widgets (buttons, text fields,
// sliders and list rows) in the menu record every time it is drawn,
// and the controller (src/ui/*_panel.4dm) looks up which widget a
// click landed on.
//
// The menu record: the widgets of the screen drawn last ("kind_n",
// "id_n", "x0_n", "y0_n", "x1_n", "y1_n", "label_n", "enabled_n",
// "value_n" for n = 1..widgets), the text typed into each field
// ("field_<id>"), which field has the keyboard ("focus"), where the
// mouse is, which slider or scroll bar is being dragged, the picked
// list row and how far the list is scrolled, and a note shown at the
// bottom of the screen.
//
// Table functions: the panorama behind the title screen is a table
// of palette colours owned by render_menu.4dm (g_pano_*), filled
// from src/render/panorama_data.4dm.
// ----------------------------------------------------------------

#define DATATYPE_MENU        ("menu")

// widget kinds
#define MENU_BUTTON          1
#define MENU_FIELD           2
#define MENU_SLIDER          3
#define MENU_ROW             4     // a row of a list (the screen draws what is in it)
#define MENU_SCROLL          5     // a list's scroll bar (value_n is 0 top .. 1 bottom)

#define MENU_FIELD_LONGEST   48    // characters a text field takes
#define MENU_BUTTON_HEIGHT   32.0
#define MENU_BUTTON_GAP      6.0
#define MENU_WIDE            400.0 // a full width button (two half ones and a gap)
#define MENU_TEXT_SIZE       15.0
#define MENU_TITLE_SIZE      18.0
#define MENU_NOTE_SECONDS    6.0
#define MENU_LIST_ROW        76.0  // height of a world list row
#define MENU_PICK_ROW        28.0  // height of a pack or skin list row
#define MENU_SCREEN_SHADE    0.45  // the panorama is this bright behind every screen but the title

// The screens
#define SCREEN_TITLE         1
#define SCREEN_WORLDS        2
#define SCREEN_CREATE        3
#define SCREEN_DELETE        4
#define SCREEN_MULTIPLAYER   5
#define SCREEN_OPTIONS       6
#define SCREEN_PACKS         7
#define SCREEN_SKINS         8
#define SCREEN_PLAYER        9     // multiplayer name and folder, from the options
#define SCREEN_FONTS         10

// Widget ids (one set for every screen)
#define W_SINGLEPLAYER       1
#define W_MULTIPLAYER        2
#define W_OPTIONS            3
#define W_QUIT               4
#define W_PLAY               10
#define W_NEW_WORLD          11
#define W_HOST               12
#define W_DELETE             13
#define W_BACK               14
#define W_SEARCH             15
#define W_LIST_SCROLL        16
#define W_WORLD_NAME         20
#define W_SEED               21
#define W_GAME_MODE          22
#define W_CREATE             23
#define W_CANCEL             24
#define W_CONFIRM_DELETE     30
#define W_PLAYER_NAME        40
#define W_FOLDER             41
#define W_JOIN               42
#define W_DONE               43
#define W_FOV                50
#define W_RENDER             51
#define W_MOUSE              52
#define W_DETAIL             53
#define W_PLANTS             54
#define W_SHADING            55
#define W_AUTO_JUMP          56
#define W_SHOW_HUD           57
#define W_STATISTICS         58
#define W_FONT               59
#define W_SKINS              60
#define W_PACKS              61
#define W_DEFAULTS           62
#define W_PLAYER_SETTINGS    63
#define W_FONT_NAME          64
#define W_FONT_USE           65
#define W_WORLD_ROW          100   // + n: row n of the world list
#define W_AVAILABLE_ROW      200   // + n: available resource pack n
#define W_SELECTED_ROW       300   // + 1: the selected pack, + 2: the built-in textures
#define W_SKIN_ROW           400   // + n: skin n (+ 0: the built-in one)
#define W_FONT_ROW           500   // + n: font choice n, then the font files

// Folders read for the pickers, next to cubeland_worlds in the
// working folder
#define PACK_FOLDER          "resourcepacks"
#define SKIN_FOLDER          "skins"
#define FONT_FOLDER          "fonts"

// A list of files found in a folder (g_files): "count", "name_n"
// (the file or folder name), "path_n" (folder\\name)
#define DATATYPE_FILE_LIST   ("file_list")
#define ATTR_FL_COUNT        ("count")
#define ATTR_FL_NAME         ("name")
#define ATTR_FL_PATH         ("path")

#define ATTR_MENU_WIDGETS    ("widgets")
#define ATTR_MENU_KIND       ("kind")
#define ATTR_MENU_ID         ("id")
#define ATTR_MENU_X0         ("x0")
#define ATTR_MENU_Y0         ("y0")
#define ATTR_MENU_X1         ("x1")
#define ATTR_MENU_Y1         ("y1")
#define ATTR_MENU_LABEL      ("label")
#define ATTR_MENU_ENABLED    ("enabled")
#define ATTR_MENU_VALUE      ("value")
#define ATTR_MENU_FIELD      ("field")        // "field_<id>": the text typed into field id
#define ATTR_MENU_FOCUS      ("focus")        // id of the field that has the keyboard, 0 none
#define ATTR_MENU_MOUSE_X    ("mouse_x")
#define ATTR_MENU_MOUSE_Y    ("mouse_y")
#define ATTR_MENU_DRAG       ("drag")         // id of the slider or scroll bar held down, 0 none
#define ATTR_MENU_PICK       ("pick")         // the picked list row (1 = first), 0 none
#define ATTR_MENU_SCROLL     ("scroll")       // list rows scrolled past
#define ATTR_MENU_ROWS       ("rows")         // the list on show: how many rows it has
#define ATTR_MENU_SHOWN      ("shown")        // and how many fit on screen
#define ATTR_MENU_NOTE       ("note")
#define ATTR_MENU_NOTE_RED   ("note_red")
#define ATTR_MENU_NOTE_UNTIL ("note_until")

// The panorama: PANO_COLUMNS x PANO_ROWS cells all the way round,
// in PANO_COLOURS palette colours, turning PANO_SPEED cells a second
#define PANO_COLUMNS         640
#define PANO_ROWS            96
#define PANO_CELLS           61440
#define PANO_COLOURS         64
#define PANO_SPEED           3.0      // a redraw for each whole cell turned, so 3 a second
#define PANO_DRAWN_RUNS      12000    // runs of one colour drawn at most (a 4K screen needs ~9000)

/*Global variables*/ {
  Integer g_pano_ready = 0;
  Integer g_pano_cell[PANO_CELLS];        // palette colour of each cell, row by row from the top
  Integer g_pano_r[PANO_COLOURS];
  Integer g_pano_g[PANO_COLOURS];
  Integer g_pano_b[PANO_COLOURS];
  // the runs of one colour found on screen this frame, chained per
  // colour so each colour is set once (menu_draw_panorama)
  Integer g_pano_run_first[PANO_COLOURS];
  Integer g_pano_run_next [PANO_DRAWN_RUNS];
  Integer g_pano_run_row  [PANO_DRAWN_RUNS];
  Integer g_pano_run_start[PANO_DRAWN_RUNS];
  Integer g_pano_run_end  [PANO_DRAWN_RUNS];
}

void    menu_clear          (Attributes &p_menu);
void    menu_begin          (Attributes &p_menu);
Integer menu_add            (Attributes &p_menu, Integer p_kind, Integer p_id, Real p_x0, Real p_y0, Real p_x1, Real p_y1,
                             Text p_label, Integer p_enabled);
void    menu_set_value      (Attributes &p_menu, Integer p_widget, Real p_value);
Integer menu_widgets        (Attributes &p_menu);
Integer menu_widget_id      (Attributes &p_menu, Integer p_widget);
Integer menu_widget_kind    (Attributes &p_menu, Integer p_widget);
Integer menu_widget_of      (Attributes &p_menu, Integer p_id);
Integer menu_at             (Attributes &p_menu, Real p_x, Real p_y);
Integer menu_id_at          (Attributes &p_menu, Real p_x, Real p_y);
Real    menu_slider_value_at(Attributes &p_menu, Integer p_widget, Real p_x, Real p_y);
Text    menu_field_text     (Attributes &p_menu, Integer p_id);
void    menu_set_field_text (Attributes &p_menu, Integer p_id, Text p_text);
Integer menu_focus          (Attributes &p_menu);
void    menu_set_focus      (Attributes &p_menu, Integer p_id);
Integer menu_type_key       (Attributes &p_menu, Text p_key, Text p_raw);
void    menu_set_mouse      (Attributes &p_menu, Real p_x, Real p_y);
void    menu_note           (Attributes &p_menu, Text p_text, Integer p_red, Real p_now);
Integer menu_pick           (Attributes &p_menu);
void    menu_set_pick       (Attributes &p_menu, Integer p_pick);
Integer menu_scroll         (Attributes &p_menu);
void    menu_set_scroll     (Attributes &p_menu, Integer p_scroll, Integer p_rows, Integer p_shown);
void    menu_set_list       (Attributes &p_menu, Integer p_rows, Integer p_shown);
void    menu_scroll_to      (Attributes &p_menu, Real p_value);
Real    menu_text_width     (Text p_text, Real p_size);
Text    menu_fit_text       (Text p_text, Real p_size, Real p_width);

void    menu_draw_button    (Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_hover, Integer p_enabled);
void    menu_draw_field     (Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_focused);
void    menu_draw_slider    (Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Real p_value, Integer p_hover);
void    menu_draw_scroll    (Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Real p_value, Real p_share);
void    menu_draw_widgets   (Draw_Box p_box, Attributes &p_menu, Real p_now);
void    menu_draw_title     (Draw_Box p_box, Real p_w, Real p_y, Text p_text);
void    menu_draw_note      (Draw_Box p_box, Attributes &p_menu, Real p_w, Real p_now);
void    menu_dark_band      (Draw_Box p_box, Real p_w, Real p_y0, Real p_y1);

void    panorama_set_colour (Integer p_colour, Integer p_red, Integer p_green, Integer p_blue);
void    panorama_set_row    (Integer p_row, Text p_cells);
void    panorama_load       ();
void    menu_draw_panorama  (Draw_Box p_box, Real p_w, Real p_h, Real p_turn, Real p_shade);
void    menu_draw_logo      (Draw_Box p_box, Real p_w, Real p_h, Text p_splash);
void    menu_draw_thumbnail (Draw_Box p_box, Integer p_entry, Integer p_has_picture, Real p_x0, Real p_y0, Real p_size);
Integer menu_world_rows_shown(Real p_h);
void    menu_list_area      (Real p_h, Real &p_top, Real &p_bottom);
Text    menu_on_off         (Integer p_on);
void    screen_title        (Draw_Box p_box, Attributes &p_menu, Real p_w, Real p_h, Text p_splash, Real p_now);
void    screen_worlds       (Draw_Box p_box, Attributes &p_menu, Attributes &p_worlds, Real p_w, Real p_h, Real p_now);
void    screen_create       (Draw_Box p_box, Attributes &p_menu, Integer p_mode, Real p_w, Real p_h, Real p_now);
void    screen_delete       (Draw_Box p_box, Attributes &p_menu, Text p_name, Real p_w, Real p_h, Real p_now);
void    screen_player       (Draw_Box p_box, Attributes &p_menu, Integer p_join, Real p_w, Real p_h, Real p_now);
void    screen_options      (Draw_Box p_box, Attributes &p_menu, Attributes &p_settings, Real p_w, Real p_h, Real p_now);
void    screen_packs        (Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_selected, Real p_w, Real p_h, Real p_now);
void    screen_skins        (Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_selected, Real p_w, Real p_h, Real p_now);
void    screen_fonts        (Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_font, Text p_font_file, Real p_w, Real p_h, Real p_now);
Integer menu_world_matches  (Attributes &p_worlds, Integer p_entry, Text p_search);
Integer menu_world_entry    (Attributes &p_worlds, Text p_search, Integer p_shown);
Integer menu_worlds_shown   (Attributes &p_worlds, Text p_search);

#endif
