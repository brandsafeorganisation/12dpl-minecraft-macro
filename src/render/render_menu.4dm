#ifndef RENDER_MENU_4DM_INCLUDED
#define RENDER_MENU_4DM_INCLUDED

#include "../../include/core/safety.h"
#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/render/render.h"
#include "../../include/render/hud.h"
#include "../../include/render/menu.h"

// ---------------------------------------------------------------- the menu record

void menu_clear(Attributes &p_menu)
// ----------------------------------------------------------------
// An empty menu: no widgets, no typed text, nothing picked
// ----------------------------------------------------------------
{
  record_clear      (p_menu, DATATYPE_MENU);
  record_set_integer(p_menu, ATTR_MENU_WIDGETS,   0);
  record_set_integer(p_menu, ATTR_MENU_FOCUS,     0);
  record_set_integer(p_menu, ATTR_MENU_DRAG,      0);
  record_set_integer(p_menu, ATTR_MENU_PICK,      0);
  record_set_integer(p_menu, ATTR_MENU_SCROLL,    0);
  record_set_real   (p_menu, ATTR_MENU_MOUSE_X,   -1.0);
  record_set_real   (p_menu, ATTR_MENU_MOUSE_Y,   -1.0);
  record_set_text   (p_menu, ATTR_MENU_NOTE,      "");
  record_set_integer(p_menu, ATTR_MENU_NOTE_RED,  FALSE);
  record_set_real   (p_menu, ATTR_MENU_NOTE_UNTIL, 0.0);
}

void menu_begin(Attributes &p_menu)
// ----------------------------------------------------------------
// Forget the widgets before a screen is laid out again (the typed
// text, focus, pick and scroll are kept)
// ----------------------------------------------------------------
{
  record_set_integer(p_menu, ATTR_MENU_WIDGETS, 0);
  menu_set_list     (p_menu, 0, 1);
}

Integer menu_add(Attributes &p_menu, Integer p_kind, Integer p_id, Real p_x0, Real p_y0, Real p_x1, Real p_y1,
                 Text p_label, Integer p_enabled)
// ----------------------------------------------------------------
// Add a widget of a kind (MENU_BUTTON ...) with the id the
// controller knows it by, covering (x0, y0)..(x1, y1); returns its
// number. A field's text is kept under its id.
// ----------------------------------------------------------------
{
  Integer l_widget = record_integer(p_menu, ATTR_MENU_WIDGETS) + 1;

  record_set_integer   (p_menu, ATTR_MENU_WIDGETS, l_widget);
  record_set_integer_at(p_menu, ATTR_MENU_KIND,    l_widget, p_kind);
  record_set_integer_at(p_menu, ATTR_MENU_ID,      l_widget, p_id);
  record_set_real_at   (p_menu, ATTR_MENU_X0,      l_widget, p_x0);
  record_set_real_at   (p_menu, ATTR_MENU_Y0,      l_widget, p_y0);
  record_set_real_at   (p_menu, ATTR_MENU_X1,      l_widget, p_x1);
  record_set_real_at   (p_menu, ATTR_MENU_Y1,      l_widget, p_y1);
  record_set_text_at   (p_menu, ATTR_MENU_LABEL,   l_widget, p_label);
  record_set_integer_at(p_menu, ATTR_MENU_ENABLED, l_widget, p_enabled);
  record_set_real_at   (p_menu, ATTR_MENU_VALUE,   l_widget, 0.0);
  return l_widget;
}

void menu_set_value(Attributes &p_menu, Integer p_widget, Real p_value)
// ----------------------------------------------------------------
// A slider's or scroll bar's position, 0..1
// ----------------------------------------------------------------
{
  record_set_real_at(p_menu, ATTR_MENU_VALUE, p_widget, clamp_real(p_value, 0.0, 1.0));
}

Integer menu_widgets(Attributes &p_menu)
// ----------------------------------------------------------------
// How many widgets the screen has
// ----------------------------------------------------------------
{
  return record_integer(p_menu, ATTR_MENU_WIDGETS);
}

Integer menu_widget_id(Attributes &p_menu, Integer p_widget)
// ----------------------------------------------------------------
// The id of widget number n
// ----------------------------------------------------------------
{
  if (p_widget < 1 || p_widget > menu_widgets(p_menu)) return 0;
  return record_integer_at(p_menu, ATTR_MENU_ID, p_widget);
}

Integer menu_widget_kind(Attributes &p_menu, Integer p_widget)
// ----------------------------------------------------------------
// The kind of widget number n (0 if there is none)
// ----------------------------------------------------------------
{
  if (p_widget < 1 || p_widget > menu_widgets(p_menu)) return 0;
  return record_integer_at(p_menu, ATTR_MENU_KIND, p_widget);
}

Integer menu_widget_of(Attributes &p_menu, Integer p_id)
// ----------------------------------------------------------------
// The number of the widget with an id, 0 if the screen has none
// ----------------------------------------------------------------
{
  Integer l_widget = 0;

  for (l_widget = 1; l_widget <= menu_widgets(p_menu); ++l_widget) {
    if (record_integer_at(p_menu, ATTR_MENU_ID, l_widget) == p_id) return l_widget;
  }
  return 0;
}

Integer menu_at(Attributes &p_menu, Real p_x, Real p_y)
// ----------------------------------------------------------------
// The enabled widget at (x, y), 0 if none (the last one added wins)
// ----------------------------------------------------------------
{
  Integer l_widget = 0;

  for (l_widget = menu_widgets(p_menu); l_widget >= 1; --l_widget) {
    if (!record_integer_at(p_menu, ATTR_MENU_ENABLED, l_widget)) continue;
    if (p_x < record_real_at(p_menu, ATTR_MENU_X0, l_widget) || p_x > record_real_at(p_menu, ATTR_MENU_X1, l_widget)) continue;
    if (p_y < record_real_at(p_menu, ATTR_MENU_Y0, l_widget) || p_y > record_real_at(p_menu, ATTR_MENU_Y1, l_widget)) continue;
    return l_widget;
  }
  return 0;
}

Integer menu_id_at(Attributes &p_menu, Real p_x, Real p_y)
// ----------------------------------------------------------------
// The id of the enabled widget at (x, y), 0 if none
// ----------------------------------------------------------------
{
  return menu_widget_id(p_menu, menu_at(p_menu, p_x, p_y));
}

Real menu_slider_value_at(Attributes &p_menu, Integer p_widget, Real p_x, Real p_y)
// ----------------------------------------------------------------
// The value (0..1) a slider takes with the mouse at x, or a scroll
// bar (up and down) with the mouse at y
// ----------------------------------------------------------------
{
  Real l_x0 = record_real_at(p_menu, ATTR_MENU_X0, p_widget);
  Real l_x1 = record_real_at(p_menu, ATTR_MENU_X1, p_widget);
  Real l_y0 = record_real_at(p_menu, ATTR_MENU_Y0, p_widget);
  Real l_y1 = record_real_at(p_menu, ATTR_MENU_Y1, p_widget);

  if (menu_widget_kind(p_menu, p_widget) == MENU_SCROLL) {
    if (l_y1 - l_y0 < 1.0) return 0.0;
    return clamp_real((l_y1 - p_y) / (l_y1 - l_y0), 0.0, 1.0);
  }
  if (l_x1 - l_x0 < 9.0) return 0.0;
  return clamp_real((p_x - l_x0 - 4.0) / (l_x1 - l_x0 - 8.0), 0.0, 1.0);
}

Text menu_field_text(Attributes &p_menu, Integer p_id)
// ----------------------------------------------------------------
// The text typed into field id
// ----------------------------------------------------------------
{
  return record_text(p_menu, record_field_at(ATTR_MENU_FIELD, p_id));
}

void menu_set_field_text(Attributes &p_menu, Integer p_id, Text p_text)
// ----------------------------------------------------------------
// Put text in field id
// ----------------------------------------------------------------
{
  record_set_text(p_menu, record_field_at(ATTR_MENU_FIELD, p_id), p_text);
}

Integer menu_focus(Attributes &p_menu)
// ----------------------------------------------------------------
// The field typing goes to, 0 if none
// ----------------------------------------------------------------
{
  return record_integer(p_menu, ATTR_MENU_FOCUS);
}

void menu_set_focus(Attributes &p_menu, Integer p_id)
// ----------------------------------------------------------------
// Send typing to field id (0: to no field)
// ----------------------------------------------------------------
{
  record_set_integer(p_menu, ATTR_MENU_FOCUS, p_id);
}

Integer menu_type_key(Attributes &p_menu, Text p_key, Text p_raw)
// ----------------------------------------------------------------
// A key typed while a field has the keyboard: a character (raw, as
// typed, so capitals stay) goes on the end, Backspace takes the
// last one off and Ctrl+Backspace the last word (text_after_key).
// p_key is its name (key_name). Returns TRUE if the key was used.
// ----------------------------------------------------------------
{
  Integer l_id   = menu_focus(p_menu);

  if (l_id == 0) return FALSE;
  if (p_key != "backspace" && p_key != "backspace_word" && !key_is_text(p_raw)) return FALSE;
  menu_set_field_text(p_menu, l_id, text_after_key(menu_field_text(p_menu, l_id), p_raw, MENU_FIELD_LONGEST));
  return TRUE;
}

void menu_set_mouse(Attributes &p_menu, Real p_x, Real p_y)
// ----------------------------------------------------------------
// Where the mouse is (the widget under it lights up)
// ----------------------------------------------------------------
{
  record_set_real(p_menu, ATTR_MENU_MOUSE_X, p_x);
  record_set_real(p_menu, ATTR_MENU_MOUSE_Y, p_y);
}

void menu_note(Attributes &p_menu, Text p_text, Integer p_red, Real p_now)
// ----------------------------------------------------------------
// Show a line at the bottom of the screen for a few seconds (red
// for a problem)
// ----------------------------------------------------------------
{
  record_set_text   (p_menu, ATTR_MENU_NOTE,       p_text);
  record_set_integer(p_menu, ATTR_MENU_NOTE_RED,   p_red);
  record_set_real   (p_menu, ATTR_MENU_NOTE_UNTIL, p_now + MENU_NOTE_SECONDS);
}

Integer menu_pick(Attributes &p_menu)
// ----------------------------------------------------------------
// The picked list row, 0 if none
// ----------------------------------------------------------------
{
  return record_integer(p_menu, ATTR_MENU_PICK);
}

void menu_set_pick(Attributes &p_menu, Integer p_pick)
// ----------------------------------------------------------------
// Pick a list row (0: none)
// ----------------------------------------------------------------
{
  record_set_integer(p_menu, ATTR_MENU_PICK, p_pick);
}

Integer menu_scroll(Attributes &p_menu)
// ----------------------------------------------------------------
// List rows scrolled past
// ----------------------------------------------------------------
{
  return record_integer(p_menu, ATTR_MENU_SCROLL);
}

void menu_set_scroll(Attributes &p_menu, Integer p_scroll, Integer p_rows, Integer p_shown)
// ----------------------------------------------------------------
// Scroll a list of rows with shown of them on screen, keeping the
// last row at the bottom at most
// ----------------------------------------------------------------
{
  record_set_integer(p_menu, ATTR_MENU_SCROLL, clamp_integer(p_scroll, 0, max_integer(0, p_rows - p_shown)));
}

void menu_set_list(Attributes &p_menu, Integer p_rows, Integer p_shown)
// ----------------------------------------------------------------
// The list on show has rows rows, shown of them on screen (set by
// the screen when it is drawn, for its scroll bar)
// ----------------------------------------------------------------
{
  record_set_integer(p_menu, ATTR_MENU_ROWS,  p_rows);
  record_set_integer(p_menu, ATTR_MENU_SHOWN, p_shown);
}

void menu_scroll_to(Attributes &p_menu, Real p_value)
// ----------------------------------------------------------------
// Scroll the list on show to value (0 top .. 1 bottom)
// ----------------------------------------------------------------
{
  Integer l_rows  = record_integer(p_menu, ATTR_MENU_ROWS);
  Integer l_shown = record_integer(p_menu, ATTR_MENU_SHOWN);

  menu_set_scroll(p_menu, floor_integer(clamp_real(p_value, 0.0, 1.0) * max_integer(0, l_rows - l_shown) + 0.5), l_rows, l_shown);
}

Real menu_text_width(Text p_text, Real p_size)
// ----------------------------------------------------------------
// About how wide text is at a size (12d can't measure text)
// ----------------------------------------------------------------
{
  return 0.46 * p_size * Text_length(p_text);
}

Text menu_fit_text(Text p_text, Real p_size, Real p_width)
// ----------------------------------------------------------------
// The text cut short with "..." if it is wider than width
// ----------------------------------------------------------------
{
  Integer l_keep = 0;

  if (menu_text_width(p_text, p_size) <= p_width) return p_text;
  l_keep = floor_integer(p_width / (0.46 * p_size)) - 3;
  if (l_keep < 1) return "...";
  return Get_subtext(p_text, 1, l_keep) + "...";
}

// ---------------------------------------------------------------- drawing widgets

void menu_draw_button(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_hover, Integer p_enabled)
// ----------------------------------------------------------------
// A stone grey button (see hud_draw_button); one that can't be
// pressed is flat dark grey with grey text
// ----------------------------------------------------------------
{
  Real l_middle = (p_y0 + p_y1) / 2.0;
  Real l_centre = (p_x0 + p_x1) / 2.0;
  Text l_text   = menu_fit_text(p_text, MENU_TEXT_SIZE, p_x1 - p_x0 - 12.0);

  if (p_enabled) {
    hud_draw_button(p_box, p_x0, p_y0, p_x1, p_y1, l_text, p_hover);
    return;
  }
  render_set_colour(p_box, 0.0, 0.0, 0.0);
  render_fill_rect (p_box, p_x0, p_y0, p_x1, p_y1);
  render_set_colour(p_box, 44.0, 44.0, 44.0);
  render_fill_rect (p_box, p_x0 + 2.0, p_y0 + 2.0, p_x1 - 2.0, p_y1 - 2.0);
  hud_text(p_box, l_centre, l_middle + 8.0, 16.0, TEXT_ALIGN_CENTRE, 160, 160, 160, l_text);
}

void menu_draw_field(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_focused)
// ----------------------------------------------------------------
// A text box: black with a grey edge (white with the keyboard) and
// a _ after the text while typing goes to it
// ----------------------------------------------------------------
{
  Real l_middle = (p_y0 + p_y1) / 2.0;
  Text l_text   = p_text;

  if (p_focused) {
    render_set_colour(p_box, 255.0, 255.0, 255.0);
    l_text = l_text + "_";
  } else {
    render_set_colour(p_box, 160.0, 160.0, 160.0);
  }
  render_fill_rect (p_box, p_x0, p_y0, p_x1, p_y1);
  render_set_colour(p_box, 0.0, 0.0, 0.0);
  render_fill_rect (p_box, p_x0 + 2.0, p_y0 + 2.0, p_x1 - 2.0, p_y1 - 2.0);
  // keep the end of the text (where typing goes) in view
  while (menu_text_width(l_text, MENU_TEXT_SIZE) > p_x1 - p_x0 - 16.0 && Text_length(l_text) > 1) {
    l_text = Get_subtext(l_text, 2, Text_length(l_text));
  }
  hud_text(p_box, p_x0 + 8.0, l_middle + 8.0, 16.0, TEXT_ALIGN_LEFT, 224, 224, 224, l_text);
}

void menu_draw_slider(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Real p_value, Integer p_hover)
// ----------------------------------------------------------------
// A slider: a dark sunken bar with a stone knob at value (0..1) and
// its label across the middle
// ----------------------------------------------------------------
{
  Real l_knob   = p_x0 + (p_x1 - p_x0 - 16.0) * clamp_real(p_value, 0.0, 1.0);
  Real l_middle = (p_y0 + p_y1) / 2.0;
  Real l_centre = (p_x0 + p_x1) / 2.0;

  render_set_colour(p_box, 0.0, 0.0, 0.0);
  render_fill_rect (p_box, p_x0, p_y0, p_x1, p_y1);
  render_set_colour(p_box, 52.0, 52.0, 52.0);
  render_fill_rect (p_box, p_x0 + 2.0, p_y0 + 2.0, p_x1 - 2.0, p_y1 - 2.0);
  hud_draw_button(p_box, l_knob, p_y0, l_knob + 16.0, p_y1, "", p_hover);
  hud_text(p_box, l_centre + 2.0, l_middle + 6.0, 16.0, TEXT_ALIGN_CENTRE, 56, 56, 56, p_text);
  if (p_hover) {
    hud_text(p_box, l_centre, l_middle + 8.0, 16.0, TEXT_ALIGN_CENTRE, 255, 255, 160, p_text);
  } else {
    hud_text(p_box, l_centre, l_middle + 8.0, 16.0, TEXT_ALIGN_CENTRE, 230, 230, 230, p_text);
  }
}

void menu_draw_scroll(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Real p_value, Real p_share)
// ----------------------------------------------------------------
// A list's scroll bar: a black track and a grey thumb share of its
// height long, value (0 top .. 1 bottom) of the way down
// ----------------------------------------------------------------
{
  Real l_length = max_real(16.0, (p_y1 - p_y0) * clamp_real(p_share, 0.0, 1.0));
  Real l_top    = p_y1 - (p_y1 - p_y0 - l_length) * clamp_real(p_value, 0.0, 1.0);

  render_set_colour(p_box, 0.0, 0.0, 0.0);
  render_fill_rect (p_box, p_x0, p_y0, p_x1, p_y1);
  render_set_colour(p_box, 128.0, 128.0, 128.0);
  render_fill_rect (p_box, p_x0, l_top - l_length, p_x1, l_top);
  render_set_colour(p_box, 192.0, 192.0, 192.0);
  render_fill_rect (p_box, p_x0, l_top - l_length + 1.0, p_x1 - 1.0, l_top);
}

void menu_draw_widgets(Draw_Box p_box, Attributes &p_menu, Real p_now)
// ----------------------------------------------------------------
// Draw the screen's buttons, fields and sliders (the screen draws
// its list rows), lighting the one under the mouse
// ----------------------------------------------------------------
{
  Integer l_widget = 0;
  Integer l_kind   = 0;
  Integer l_hover  = menu_at(p_menu, record_real(p_menu, ATTR_MENU_MOUSE_X), record_real(p_menu, ATTR_MENU_MOUSE_Y));
  Real    l_x0     = 0.0;
  Real    l_y0     = 0.0;
  Real    l_x1     = 0.0;
  Real    l_y1     = 0.0;
  Text    l_label  = "";

  for (l_widget = 1; l_widget <= menu_widgets(p_menu); ++l_widget) {
    l_kind  = record_integer_at(p_menu, ATTR_MENU_KIND, l_widget);
    l_x0    = record_real_at(p_menu, ATTR_MENU_X0, l_widget);
    l_y0    = record_real_at(p_menu, ATTR_MENU_Y0, l_widget);
    l_x1    = record_real_at(p_menu, ATTR_MENU_X1, l_widget);
    l_y1    = record_real_at(p_menu, ATTR_MENU_Y1, l_widget);
    l_label = record_text_at(p_menu, ATTR_MENU_LABEL, l_widget);
    if (l_kind == MENU_BUTTON) {
      menu_draw_button(p_box, l_x0, l_y0, l_x1, l_y1, l_label, l_widget == l_hover,
                       record_integer_at(p_menu, ATTR_MENU_ENABLED, l_widget));
    } else if (l_kind == MENU_FIELD) {
      if (l_label != "") hud_shadow_text(p_box, l_x0, l_y1 + 20.0, 14.0, TEXT_ALIGN_LEFT, 160, 160, 160, l_label);
      menu_draw_field(p_box, l_x0, l_y0, l_x1, l_y1, menu_field_text(p_menu, record_integer_at(p_menu, ATTR_MENU_ID, l_widget)),
                      record_integer_at(p_menu, ATTR_MENU_ID, l_widget) == menu_focus(p_menu));
    } else if (l_kind == MENU_SLIDER) {
      menu_draw_slider(p_box, l_x0, l_y0, l_x1, l_y1, l_label, record_real_at(p_menu, ATTR_MENU_VALUE, l_widget), l_widget == l_hover);
    }
  }
  menu_draw_note(p_box, p_menu, 0.0, p_now);
}

void menu_draw_title(Draw_Box p_box, Real p_w, Real p_y, Text p_text)
// ----------------------------------------------------------------
// A screen's title, white with a shadow, centred at height y
// ----------------------------------------------------------------
{
  hud_shadow_text(p_box, p_w / 2.0, p_y, MENU_TITLE_SIZE, TEXT_ALIGN_CENTRE, 255, 255, 255, p_text);
}

void menu_draw_note(Draw_Box p_box, Attributes &p_menu, Real p_w, Real p_now)
// ----------------------------------------------------------------
// The note at the bottom left of the screen while it lasts
// ----------------------------------------------------------------
{
  if (p_now > record_real(p_menu, ATTR_MENU_NOTE_UNTIL)) return;
  if (record_text(p_menu, ATTR_MENU_NOTE) == "") return;
  if (record_integer(p_menu, ATTR_MENU_NOTE_RED)) {
    hud_shadow_text(p_box, 8.0, 22.0, 13.0, TEXT_ALIGN_LEFT, 255, 96, 96, record_text(p_menu, ATTR_MENU_NOTE));
  } else {
    hud_shadow_text(p_box, 8.0, 22.0, 13.0, TEXT_ALIGN_LEFT, 255, 255, 160, record_text(p_menu, ATTR_MENU_NOTE));
  }
}

void menu_dark_band(Draw_Box p_box, Real p_w, Real p_y0, Real p_y1)
// ----------------------------------------------------------------
// The dark band a list sits in, with a light line along its top and
// bottom edges
// ----------------------------------------------------------------
{
  render_set_colour(p_box, 14.0, 14.0, 18.0);
  render_fill_rect (p_box, 0.0, p_y0, p_w, p_y1);
  render_set_colour(p_box, 110.0, 110.0, 116.0);
  render_fill_rect (p_box, 0.0, p_y1, p_w, p_y1 + 2.0);
  render_fill_rect (p_box, 0.0, p_y0 - 2.0, p_w, p_y0);
}

// ---------------------------------------------------------------- the panorama

void panorama_set_colour(Integer p_colour, Integer p_red, Integer p_green, Integer p_blue)
// ----------------------------------------------------------------
// Palette colour n (1..PANO_COLOURS) of the panorama
// ----------------------------------------------------------------
{
  if (p_colour < 1 || p_colour > PANO_COLOURS) return;
  g_pano_r[p_colour] = p_red;
  g_pano_g[p_colour] = p_green;
  g_pano_b[p_colour] = p_blue;
}

void panorama_set_row(Integer p_row, Text p_cells)
// ----------------------------------------------------------------
// Row n (1 = top) of the panorama: one character a cell, the
// palette colour less one counted from "0" (so "0" is colour 1),
// except that "~" stands for the backslash and "!" for the question
// mark, which can't be written plainly in a 12d string
// ----------------------------------------------------------------
{
  Integer l_column = 0;
  Integer l_code   = 0;
  Integer l_colour = 0;
  Integer l_length = min_integer(Text_length(p_cells), PANO_COLUMNS);

  if (p_row < 1 || p_row > PANO_ROWS) return;
  for (l_column = 1; l_column <= l_length; ++l_column) {
    Get_char(p_cells, l_column, l_code);
    l_colour = l_code - 47;
    if (l_code == 126) l_colour = 45;   // "~": 92 - 47
    if (l_code == 33 ) l_colour = 16;   // "!": 63 - 47
    if (l_colour < 1 || l_colour > PANO_COLOURS) l_colour = 1;
    g_pano_cell[(p_row - 1) * PANO_COLUMNS + l_column] = l_colour;
  }
}

void menu_draw_panorama(Draw_Box p_box, Real p_w, Real p_h, Real p_turn, Real p_shade)
// ----------------------------------------------------------------
// The view all round a world behind the title screen, turned by
// turn cells and made shade (0..1) as bright. Each row is cut into
// runs of cells of one colour (so the sky is a few long strips),
// and the runs are drawn colour by colour: setting a colour is a
// 12d call as dear as drawing, so each is set once, not per run.
// ----------------------------------------------------------------
{
  Integer l_row    = 0;
  Integer l_column = 0;
  Integer l_first  = 0;
  Integer l_shown  = 0;
  Integer l_step   = 0;
  Integer l_colour = 0;
  Integer l_run    = 0;
  Integer l_start  = 0;
  Integer l_runs   = 0;
  Integer l_index  = 0;
  Real    l_cell   = 0.0;
  Real    l_y0     = 0.0;
  Real    l_x0     = 0.0;

  panorama_load();
  l_cell  = p_h / PANO_ROWS;
  l_shown = floor_integer(p_w / l_cell) + 2;
  l_first = positive_mod(floor_integer(p_turn), PANO_COLUMNS);
  l_x0    = -(p_turn - Floor(p_turn)) * l_cell;
  for (l_colour = 1; l_colour <= PANO_COLOURS; ++l_colour) g_pano_run_first[l_colour] = 0;

  // the runs on screen, chained by colour
  for (l_row = 1; l_row <= PANO_ROWS; ++l_row) {
    l_start = 0;
    l_run   = 0;
    for (l_step = 0; l_step <= l_shown; ++l_step) {
      l_colour = 0;
      if (l_step < l_shown) {
        l_column = positive_mod(l_first + l_step, PANO_COLUMNS) + 1;
        l_colour = g_pano_cell[(l_row - 1) * PANO_COLUMNS + l_column];
      }
      if (l_colour == l_run) continue;
      if (l_run > 0) {
        if (l_runs < PANO_DRAWN_RUNS) {
          ++l_runs;
          g_pano_run_row  [l_runs] = l_row;
          g_pano_run_start[l_runs] = l_start;
          g_pano_run_end  [l_runs] = l_step;
          g_pano_run_next [l_runs] = g_pano_run_first[l_run];
          g_pano_run_first[l_run]  = l_runs;
        } else {
          // more runs than the table holds: draw this one straight away
          l_y0 = p_h - l_row * l_cell;
          render_set_colour(p_box, g_pano_r[l_run] * p_shade, g_pano_g[l_run] * p_shade, g_pano_b[l_run] * p_shade);
          render_fill_rect (p_box, l_x0 + l_start * l_cell, l_y0, l_x0 + l_step * l_cell + 0.5, l_y0 + l_cell + 0.5);
        }
      }
      l_run   = l_colour;
      l_start = l_step;
    }
  }

  // each colour once, then all its runs
  for (l_colour = 1; l_colour <= PANO_COLOURS; ++l_colour) {
    l_index = g_pano_run_first[l_colour];
    if (l_index == 0) continue;
    render_set_colour(p_box, g_pano_r[l_colour] * p_shade, g_pano_g[l_colour] * p_shade, g_pano_b[l_colour] * p_shade);
    while (l_index > 0) {
      l_y0 = p_h - g_pano_run_row[l_index] * l_cell;
      render_fill_rect(p_box, l_x0 + g_pano_run_start[l_index] * l_cell, l_y0, l_x0 + g_pano_run_end[l_index] * l_cell + 0.5, l_y0 + l_cell + 0.5);
      l_index = g_pano_run_next[l_index];
    }
  }
}

void menu_draw_logo(Draw_Box p_box, Real p_w, Real p_h, Text p_splash)
// ----------------------------------------------------------------
// The game's name in big stone letters near the top of the title
// screen, with the yellow splash line tipped across its corner
// ----------------------------------------------------------------
{
  Real l_top  = p_h - 40.0;
  Text l_name = GAME_LOGO;

  hud_text(p_box, p_w / 2.0 + 4.0, l_top - 4.0, 64.0, TEXT_ALIGN_CENTRE, 30, 30, 30, l_name);
  hud_text(p_box, p_w / 2.0 + 2.0, l_top - 2.0, 64.0, TEXT_ALIGN_CENTRE, 90, 90, 90, l_name);
  hud_text(p_box, p_w / 2.0, l_top, 64.0, TEXT_ALIGN_CENTRE, 200, 200, 200, l_name);
  if (p_splash == "") return;
  Set_text_align (p_box, TEXT_ALIGN_CENTRE);
  Set_text_colour(p_box, 60, 60, 0);
  Draw_text      (p_box, p_w / 2.0 + 172.0, l_top - 80.0, 17.0, 0.35, p_splash);
  Set_text_colour(p_box, 255, 255, 0);
  Draw_text      (p_box, p_w / 2.0 + 170.0, l_top - 78.0, 17.0, 0.35, p_splash);
}

#include "panorama_data.4dm"

#endif
