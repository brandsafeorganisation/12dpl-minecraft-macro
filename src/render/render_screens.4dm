#ifndef RENDER_SCREENS_4DM_INCLUDED
#define RENDER_SCREENS_4DM_INCLUDED

#include "../../include/core/safety.h"
#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/blocks/blocks.h"
#include "../../include/blocks/textures.h"
#include "../../include/player/player.h"
#include "../../include/program/settings.h"
#include "../../include/program/save.h"
#include "../../include/render/render.h"
#include "../../include/render/hud.h"
#include "../../include/render/menu.h"
#include "../../include/ui/font.h"

// ----------------------------------------------------------------
// The menu screens (views). Each lays its widgets out in the menu
// record and draws them, over whatever the controller drew behind
// (the panorama, or the world darkened). Heights count up from the
// bottom of the view.
// ----------------------------------------------------------------

Text menu_on_off(Integer p_on)
// ----------------------------------------------------------------
// "ON" or "OFF"
// ----------------------------------------------------------------
{
  if (p_on) return "ON";
  return "OFF";
}

Integer menu_thumbnail_colour(Integer p_entry, Integer p_row, Integer p_column)
// ----------------------------------------------------------------
// Colour of square (row, column) of a listed world's picture drawn
// THUMB_SIZE / 2 squares across: the average of its 2 x 2 cells,
// each channel rounded to a multiple of 8 so that neighbours of
// almost the same colour join into one run
// ----------------------------------------------------------------
{
  Integer l_cell   = ((p_row - 1) * 2) * THUMB_SIZE + (p_column - 1) * 2 + 1;
  Integer l_red    = 0;
  Integer l_green  = 0;
  Integer l_blue   = 0;
  Integer l_colour = 0;
  Integer l_corner = 0;

  for (l_corner = 0; l_corner <= 3; ++l_corner) {
    l_colour = save_listed_colour(p_entry, l_cell + positive_mod(l_corner, 2) + floor_divide(l_corner, 2) * THUMB_SIZE);
    l_red    = l_red   + floor_divide(l_colour, 65536);
    l_green  = l_green + positive_mod(floor_divide(l_colour, 256), 256);
    l_blue   = l_blue  + positive_mod(l_colour, 256);
  }
  l_red   = floor_divide(l_red,   32) * 8;
  l_green = floor_divide(l_green, 32) * 8;
  l_blue  = floor_divide(l_blue,  32) * 8;
  return l_red * 65536 + l_green * 256 + l_blue;
}

void menu_draw_thumbnail(Draw_Box p_box, Integer p_entry, Integer p_has_picture, Real p_x0, Real p_y0, Real p_size)
// ----------------------------------------------------------------
// A listed world's picture as a size x size square with its bottom
// left at (x0, y0), a world without one shows a grass block. It is
// drawn at half its resolution (menu_thumbnail_colour), each row as
// runs of one colour: a list of full pictures was thousands of
// polygons a frame.
// ----------------------------------------------------------------
{
  Integer l_row    = 0;
  Integer l_column = 0;
  Integer l_start  = 0;
  Integer l_colour = 0;
  Integer l_run    = 0;
  Integer l_across = floor_divide(THUMB_SIZE, 2);
  Real    l_cell   = p_size / l_across;
  Real    l_top    = 0.0;

  if (!p_has_picture) {
    render_set_colour(p_box, 40.0, 40.0, 44.0);
    render_fill_rect (p_box, p_x0, p_y0, p_x0 + p_size, p_y0 + p_size);
    hud_draw_item_icon(p_box, ITEM_GRASS, p_x0 + p_size / 2.0, p_y0 + p_size / 2.0, p_size * 0.7, ICON_FULL);
    return;
  }
  for (l_row = 1; l_row <= l_across; ++l_row) {
    l_top   = p_y0 + p_size - (l_row - 1) * l_cell;
    l_start = 1;
    l_run   = menu_thumbnail_colour(p_entry, l_row, 1);
    for (l_column = 2; l_column <= l_across + 1; ++l_column) {
      l_colour = -1;
      if (l_column <= l_across) l_colour = menu_thumbnail_colour(p_entry, l_row, l_column);
      if (l_colour == l_run) continue;
      render_set_colour(p_box, floor_divide(l_run, 65536) * 1.0, positive_mod(floor_divide(l_run, 256), 256) * 1.0, positive_mod(l_run, 256) * 1.0);
      render_fill_rect(p_box, p_x0 + (l_start - 1) * l_cell, l_top - l_cell, p_x0 + (l_column - 1) * l_cell + 0.5, l_top);
      l_run   = l_colour;
      l_start = l_column;
    }
  }
}

// ---------------------------------------------------------------- the title screen

void screen_title(Draw_Box p_box, Attributes &p_menu, Real p_w, Real p_h, Text p_splash, Real p_now)
// ----------------------------------------------------------------
// The game's name and Singleplayer, Multiplayer, Options... and
// Quit Game (the panorama is already drawn behind)
// ----------------------------------------------------------------
{
  Real l_left  = p_w / 2.0 - MENU_WIDE / 2.0;
  Real l_half  = (MENU_WIDE - MENU_BUTTON_GAP) / 2.0;
  Real l_top   = p_h / 2.0 + 40.0;
  Real l_row   = MENU_BUTTON_HEIGHT + MENU_BUTTON_GAP;
  Text l_line  = GAME_TITLE;
  Text l_ver   = GAME_VERSION;

  menu_begin(p_menu);
  menu_add(p_menu, MENU_BUTTON, W_SINGLEPLAYER, l_left, l_top - MENU_BUTTON_HEIGHT, l_left + MENU_WIDE, l_top, "Singleplayer", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_MULTIPLAYER, l_left, l_top - l_row - MENU_BUTTON_HEIGHT, l_left + MENU_WIDE, l_top - l_row, "Multiplayer", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_OPTIONS, l_left, l_top - 2.0 * l_row - 12.0 - MENU_BUTTON_HEIGHT, l_left + l_half,
           l_top - 2.0 * l_row - 12.0, "Options...", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_QUIT, l_left + MENU_WIDE - l_half, l_top - 2.0 * l_row - 12.0 - MENU_BUTTON_HEIGHT, l_left + MENU_WIDE,
           l_top - 2.0 * l_row - 12.0, "Quit Game", TRUE);

  menu_draw_logo(p_box, p_w, p_h, p_splash);
  menu_draw_widgets(p_box, p_menu, p_now);
  l_line = l_line + " " + l_ver;
  hud_shadow_text(p_box, 6.0, 40.0, 13.0, TEXT_ALIGN_LEFT, 255, 255, 255, l_line);
  hud_shadow_text(p_box, p_w - 6.0 - 1.3 * menu_text_width("Made in 12d Model", 13.0), 40.0, 13.0, TEXT_ALIGN_LEFT, 255, 255, 255, "Made in 12d Model");
}

// ---------------------------------------------------------------- the world list

void menu_list_area(Real p_h, Real &p_top, Real &p_bottom)
// ----------------------------------------------------------------
// Where the world list goes: between the search box and the buttons
// ----------------------------------------------------------------
{
  p_top    = p_h - 88.0;
  p_bottom = 2.0 * (MENU_BUTTON_HEIGHT + MENU_BUTTON_GAP) + 18.0;
}

Integer menu_world_rows_shown(Real p_h)
// ----------------------------------------------------------------
// How many world rows fit in the list
// ----------------------------------------------------------------
{
  Real l_top    = 0.0;
  Real l_bottom = 0.0;

  menu_list_area(p_h, l_top, l_bottom);
  return max_integer(1, floor_integer((l_top - l_bottom - 4.0) / MENU_LIST_ROW));
}

Integer menu_world_matches(Attributes &p_worlds, Integer p_entry, Text p_search)
// ----------------------------------------------------------------
// TRUE if a listed world's name has the search text in it (any
// case), or the search is empty
// ----------------------------------------------------------------
{
  if (p_search == "") return TRUE;
  return Find_text(Text_lower(record_text_at(p_worlds, ATTR_WL_NAME, p_entry)), Text_lower(p_search)) > 0;
}

Integer menu_worlds_shown(Attributes &p_worlds, Text p_search)
// ----------------------------------------------------------------
// How many listed worlds match the search
// ----------------------------------------------------------------
{
  Integer l_entry = 0;
  Integer l_count = 0;

  for (l_entry = 1; l_entry <= record_integer(p_worlds, ATTR_WL_COUNT); ++l_entry) {
    if (menu_world_matches(p_worlds, l_entry, p_search)) ++l_count;
  }
  return l_count;
}

Integer menu_world_entry(Attributes &p_worlds, Text p_search, Integer p_shown)
// ----------------------------------------------------------------
// The world list entry shown as row n of the search's matches, 0 if
// there is none
// ----------------------------------------------------------------
{
  Integer l_entry = 0;
  Integer l_count = 0;

  for (l_entry = 1; l_entry <= record_integer(p_worlds, ATTR_WL_COUNT); ++l_entry) {
    if (!menu_world_matches(p_worlds, l_entry, p_search)) continue;
    ++l_count;
    if (l_count == p_shown) return l_entry;
  }
  return 0;
}

void screen_worlds(Draw_Box p_box, Attributes &p_menu, Attributes &p_worlds, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// "Select World": a search box, the saved worlds (picture, name,
// file and when it was last played, game mode and the version it
// was last played in, red if newer than this one) and the buttons
// ----------------------------------------------------------------
{
  Text    l_search  = menu_field_text(p_menu, W_SEARCH);
  Integer l_matches = menu_worlds_shown(p_worlds, l_search);
  Integer l_shown   = menu_world_rows_shown(p_h);
  Integer l_scroll  = menu_scroll(p_menu);
  Integer l_row     = 0;
  Integer l_entry   = 0;
  Integer l_pick    = menu_pick(p_menu);
  Integer l_has     = FALSE;
  Integer l_version = 0;
  Integer l_mode    = 0;
  Integer l_scroll_bar = 0;
  Real    l_top     = 0.0;
  Real    l_bottom  = 0.0;
  Real    l_left    = p_w / 2.0 - 220.0;
  Real    l_right   = p_w / 2.0 + 220.0;
  Real    l_y1      = 0.0;
  Real    l_y0      = 0.0;
  Real    l_half    = (MENU_WIDE - MENU_BUTTON_GAP) / 2.0;
  Real    l_third   = (MENU_WIDE - 2.0 * MENU_BUTTON_GAP) / 3.0;
  Real    l_bl      = p_w / 2.0 - MENU_WIDE / 2.0;
  Real    l_row1    = MENU_BUTTON_GAP + MENU_BUTTON_HEIGHT + MENU_BUTTON_GAP;
  Text    l_name    = "";
  Text    l_line    = "";
  Text    l_mode_text = "";

  menu_list_area(p_h, l_top, l_bottom);
  menu_begin(p_menu);
  menu_add(p_menu, MENU_FIELD, W_SEARCH, p_w / 2.0 - 160.0, p_h - 74.0, p_w / 2.0 + 160.0, p_h - 46.0, "", TRUE);
  for (l_row = 1; l_row <= l_shown; ++l_row) {
    l_entry = menu_world_entry(p_worlds, l_search, l_scroll + l_row);
    if (l_entry == 0) continue;
    l_y1 = l_top - 4.0 - (l_row - 1) * MENU_LIST_ROW;
    menu_add(p_menu, MENU_ROW, W_WORLD_ROW + l_entry, l_left, l_y1 - MENU_LIST_ROW + 4.0, l_right, l_y1, "", TRUE);
  }
  menu_set_list(p_menu, l_matches, l_shown);
  if (l_matches > l_shown) {
    l_scroll_bar = menu_add(p_menu, MENU_SCROLL, W_LIST_SCROLL, l_right + 6.0, l_bottom + 2.0, l_right + 14.0, l_top - 2.0, "", TRUE);
    menu_set_value(p_menu, l_scroll_bar, l_scroll * 1.0 / (l_matches - l_shown));
  }
  l_has = l_pick > 0;
  menu_add(p_menu, MENU_BUTTON, W_PLAY, l_bl, l_row1, l_bl + l_half, l_row1 + MENU_BUTTON_HEIGHT, "Play Selected World", l_has);
  menu_add(p_menu, MENU_BUTTON, W_NEW_WORLD, l_bl + MENU_WIDE - l_half, l_row1, l_bl + MENU_WIDE, l_row1 + MENU_BUTTON_HEIGHT, "Create New World", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_HOST, l_bl, MENU_BUTTON_GAP, l_bl + l_third, MENU_BUTTON_GAP + MENU_BUTTON_HEIGHT, "Host Selected", l_has);
  menu_add(p_menu, MENU_BUTTON, W_DELETE, l_bl + l_third + MENU_BUTTON_GAP, MENU_BUTTON_GAP, l_bl + 2.0 * l_third + MENU_BUTTON_GAP,
           MENU_BUTTON_GAP + MENU_BUTTON_HEIGHT, "Delete", l_has);
  menu_add(p_menu, MENU_BUTTON, W_BACK, l_bl + MENU_WIDE - l_third, MENU_BUTTON_GAP, l_bl + MENU_WIDE, MENU_BUTTON_GAP + MENU_BUTTON_HEIGHT, "Back", TRUE);

  // the list's dark band, then each row
  menu_dark_band(p_box, p_w, l_bottom, l_top);
  for (l_row = 1; l_row <= l_shown; ++l_row) {
    l_entry = menu_world_entry(p_worlds, l_search, l_scroll + l_row);
    if (l_entry == 0) continue;
    l_y1 = l_top - 4.0 - (l_row - 1) * MENU_LIST_ROW;
    l_y0 = l_y1 - MENU_LIST_ROW + 4.0;
    if (l_entry == l_pick) {
      render_set_colour(p_box, 128.0, 128.0, 128.0);
      render_fill_rect (p_box, l_left, l_y0, l_right, l_y1);
      render_set_colour(p_box, 0.0, 0.0, 0.0);
      render_fill_rect (p_box, l_left + 2.0, l_y0 + 2.0, l_right - 2.0, l_y1 - 2.0);
    }
    menu_draw_thumbnail(p_box, l_entry, record_integer_at(p_worlds, ATTR_WL_THUMB, l_entry), l_left + 4.0, l_y0 + 4.0, l_y1 - l_y0 - 8.0);
    l_name = record_text_at(p_worlds, ATTR_WL_NAME, l_entry);
    hud_shadow_text(p_box, l_left + 80.0, l_y1 - 8.0, 16.0, TEXT_ALIGN_LEFT, 255, 255, 255, menu_fit_text(l_name, 16.0, l_right - l_left - 90.0));
    l_line = l_name + WORLD_EXTENSION;
    if (record_text_at(p_worlds, ATTR_WL_DATE, l_entry) != "") l_line = l_line + " (" + record_text_at(p_worlds, ATTR_WL_DATE, l_entry) + ")";
    hud_text(p_box, l_left + 80.0, l_y1 - 30.0, 14.0, TEXT_ALIGN_LEFT, 160, 160, 160, menu_fit_text(l_line, 14.0, l_right - l_left - 90.0));
    l_mode      = record_integer_at(p_worlds, ATTR_WL_MODE, l_entry);
    l_version   = record_integer_at(p_worlds, ATTR_WL_VERSION, l_entry);
    l_mode_text = "";
    if (l_mode >= 0) l_mode_text = player_game_mode_name(l_mode) + " Mode, ";
    hud_text(p_box, l_left + 80.0, l_y1 - 50.0, 14.0, TEXT_ALIGN_LEFT, 160, 160, 160, l_mode_text + "Version: ");
    l_line = record_text_at(p_worlds, ATTR_WL_VERSION_TEXT, l_entry);
    if (l_version == 0) l_line = "older";
    if (l_version > GAME_VERSION_CODE) {
      hud_text(p_box, l_left + 80.0 + menu_text_width(l_mode_text + "Version: ", 14.0), l_y1 - 50.0, 14.0, TEXT_ALIGN_LEFT, 255, 80, 80, l_line);
    } else {
      hud_text(p_box, l_left + 80.0 + menu_text_width(l_mode_text + "Version: ", 14.0), l_y1 - 50.0, 14.0, TEXT_ALIGN_LEFT, 160, 160, 160, l_line);
    }
  }
  if (record_integer(p_worlds, ATTR_WL_COUNT) == 0) {
    hud_shadow_text(p_box, p_w / 2.0, (l_top + l_bottom) / 2.0 + 10.0, 15.0, TEXT_ALIGN_CENTRE, 200, 200, 200, "No worlds yet: press Create New World");
  }
  if (l_scroll_bar > 0) {
    menu_draw_scroll(p_box, l_right + 6.0, l_bottom + 2.0, l_right + 14.0, l_top - 2.0, l_scroll * 1.0 / (l_matches - l_shown), l_shown * 1.0 / l_matches);
  }
  menu_draw_title(p_box, p_w, p_h - 14.0, "Select World");
  menu_draw_widgets(p_box, p_menu, p_now);
}

// ---------------------------------------------------------------- making and deleting worlds

void screen_create(Draw_Box p_box, Attributes &p_menu, Integer p_mode, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// "Create New World": the name, the seed and the game mode
// ----------------------------------------------------------------
{
  Real l_left = p_w / 2.0 - MENU_WIDE / 2.0;
  Real l_half = (MENU_WIDE - MENU_BUTTON_GAP) / 2.0;
  Real l_top  = p_h - 90.0;

  menu_begin(p_menu);
  menu_add(p_menu, MENU_FIELD, W_WORLD_NAME, l_left, l_top - 30.0, l_left + MENU_WIDE, l_top, "World Name", TRUE);
  menu_add(p_menu, MENU_FIELD, W_SEED, l_left, l_top - 110.0, l_left + MENU_WIDE, l_top - 80.0, "Seed for the World Generator", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_GAME_MODE, l_left, l_top - 190.0, l_left + MENU_WIDE, l_top - 190.0 + MENU_BUTTON_HEIGHT,
           "Game Mode: " + player_game_mode_name(p_mode), TRUE);
  menu_add(p_menu, MENU_BUTTON, W_CREATE, l_left, MENU_BUTTON_GAP + 10.0, l_left + l_half, MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT,
           "Create New World", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_CANCEL, l_left + MENU_WIDE - l_half, MENU_BUTTON_GAP + 10.0, l_left + MENU_WIDE,
           MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Cancel", TRUE);

  menu_draw_title(p_box, p_w, p_h - 30.0, "Create New World");
  hud_shadow_text(p_box, l_left, l_top - 118.0, 13.0, TEXT_ALIGN_LEFT, 160, 160, 160, "Leave blank for a random seed");
  if (p_mode == GAMEMODE_CREATIVE) {
    hud_shadow_text(p_box, l_left, l_top - 196.0, 13.0, TEXT_ALIGN_LEFT, 160, 160, 160, "Every block and item, flying, no damage");
  } else if (p_mode == GAMEMODE_SPECTATOR) {
    hud_shadow_text(p_box, l_left, l_top - 196.0, 13.0, TEXT_ALIGN_LEFT, 160, 160, 160, "Fly through anything and just look");
  } else {
    hud_shadow_text(p_box, l_left, l_top - 196.0, 13.0, TEXT_ALIGN_LEFT, 160, 160, 160, "Gather what you need, look after your health");
  }
  menu_draw_widgets(p_box, p_menu, p_now);
}

void screen_delete(Draw_Box p_box, Attributes &p_menu, Text p_name, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// "Are you sure you want to delete this world?"
// ----------------------------------------------------------------
{
  Real l_left = p_w / 2.0 - MENU_WIDE / 2.0;
  Real l_half = (MENU_WIDE - MENU_BUTTON_GAP) / 2.0;
  Real l_mid  = p_h / 2.0;

  menu_begin(p_menu);
  menu_add(p_menu, MENU_BUTTON, W_CONFIRM_DELETE, l_left, l_mid - 70.0, l_left + l_half, l_mid - 70.0 + MENU_BUTTON_HEIGHT, "Delete", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_CANCEL, l_left + MENU_WIDE - l_half, l_mid - 70.0, l_left + MENU_WIDE, l_mid - 70.0 + MENU_BUTTON_HEIGHT,
           "Cancel", TRUE);
  menu_draw_title(p_box, p_w, l_mid + 60.0, "Are you sure you want to delete this world?");
  hud_shadow_text(p_box, p_w / 2.0, l_mid + 24.0, 15.0, TEXT_ALIGN_CENTRE, 200, 200, 200, "'" + p_name + "' will be lost forever! (A long time!)");
  menu_draw_widgets(p_box, p_menu, p_now);
}

// ---------------------------------------------------------------- multiplayer

void screen_player(Draw_Box p_box, Attributes &p_menu, Integer p_join, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// The multiplayer name and shared folder; from the title screen
// also Join Game
// ----------------------------------------------------------------
{
  Real l_left = p_w / 2.0 - MENU_WIDE / 2.0;
  Real l_half = (MENU_WIDE - MENU_BUTTON_GAP) / 2.0;
  Real l_top  = p_h - 90.0;

  menu_begin(p_menu);
  menu_add(p_menu, MENU_FIELD, W_PLAYER_NAME, l_left, l_top - 30.0, l_left + MENU_WIDE, l_top, "Your Name (blank for your Windows name)", TRUE);
  menu_add(p_menu, MENU_FIELD, W_FOLDER, l_left, l_top - 110.0, l_left + MENU_WIDE, l_top - 80.0, "Shared Folder (the same for every player)", TRUE);
  if (p_join) {
    menu_add(p_menu, MENU_BUTTON, W_JOIN, l_left, MENU_BUTTON_GAP + 10.0, l_left + l_half, MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Join Game", TRUE);
    menu_add(p_menu, MENU_BUTTON, W_DONE, l_left + MENU_WIDE - l_half, MENU_BUTTON_GAP + 10.0, l_left + MENU_WIDE,
             MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Back", TRUE);
  } else {
    menu_add(p_menu, MENU_BUTTON, W_DONE, l_left, MENU_BUTTON_GAP + 10.0, l_left + MENU_WIDE, MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Done", TRUE);
  }
  menu_draw_title(p_box, p_w, p_h - 30.0, "Multiplayer");
  hud_shadow_text(p_box, p_w / 2.0, l_top - 150.0, 13.0, TEXT_ALIGN_CENTRE, 200, 200, 200,
                  "Every player sets the same shared folder (a network folder, or the default on one PC).");
  hud_shadow_text(p_box, p_w / 2.0, l_top - 170.0, 13.0, TEXT_ALIGN_CENTRE, 200, 200, 200,
                  "To host, pick a world in Singleplayer and press Host Selected; the others press Join Game.");
  menu_draw_widgets(p_box, p_menu, p_now);
}

// ---------------------------------------------------------------- options

void screen_options(Draw_Box p_box, Attributes &p_menu, Attributes &p_settings, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// "Options": two columns of sliders and buttons showing each
// setting, then Done
// ----------------------------------------------------------------
{
  Real    l_left   = p_w / 2.0 - MENU_WIDE / 2.0;
  Real    l_half   = (MENU_WIDE - MENU_BUTTON_GAP) / 2.0;
  Real    l_right  = l_left + MENU_WIDE - l_half;
  Real    l_row    = MENU_BUTTON_HEIGHT + MENU_BUTTON_GAP;
  Real    l_top    = p_h - 56.0;
  Integer l_widget = 0;
  Integer l_detail = settings_detail(p_settings);
  Text    l_text   = "Normal";

  if (l_detail == DETAIL_LOW ) l_text = "Low";
  if (l_detail == DETAIL_HIGH) l_text = "High";

  menu_begin(p_menu);
  l_widget = menu_add(p_menu, MENU_SLIDER, W_FOV, l_left, l_top - MENU_BUTTON_HEIGHT, l_left + l_half, l_top,
                      "FOV: " + To_text(settings_fov_degrees(p_settings)), TRUE);
  menu_set_value(p_menu, l_widget, (settings_fov_degrees(p_settings) - FOV_MIN) * 1.0 / (FOV_MAX - FOV_MIN));
  l_widget = menu_add(p_menu, MENU_SLIDER, W_RENDER, l_right, l_top - MENU_BUTTON_HEIGHT, l_right + l_half, l_top,
                      "Render Distance: " + To_text(settings_render_distance(p_settings)), TRUE);
  menu_set_value(p_menu, l_widget, (settings_render_distance(p_settings) - RENDER_DISTANCE_MIN) * 1.0 / (RENDER_DISTANCE_MAX - RENDER_DISTANCE_MIN));
  l_widget = menu_add(p_menu, MENU_SLIDER, W_MOUSE, l_left, l_top - l_row - MENU_BUTTON_HEIGHT, l_left + l_half, l_top - l_row,
                      "Sensitivity: " + To_text(record_integer(p_settings, ATTR_SET_SENSITIVITY)), TRUE);
  menu_set_value(p_menu, l_widget, (record_integer(p_settings, ATTR_SET_SENSITIVITY) - SENSITIVITY_MIN) * 1.0 / (SENSITIVITY_MAX - SENSITIVITY_MIN));
  menu_add(p_menu, MENU_BUTTON, W_DETAIL, l_right, l_top - l_row - MENU_BUTTON_HEIGHT, l_right + l_half, l_top - l_row,
           "Texture Detail: " + l_text, TRUE);
  menu_add(p_menu, MENU_BUTTON, W_PLANTS, l_left, l_top - 2.0 * l_row - MENU_BUTTON_HEIGHT, l_left + l_half, l_top - 2.0 * l_row,
           "Grass and Flowers: " + menu_on_off(settings_flag(p_settings, ATTR_SET_PLANTS)), TRUE);
  menu_add(p_menu, MENU_BUTTON, W_SHADING, l_right, l_top - 2.0 * l_row - MENU_BUTTON_HEIGHT, l_right + l_half, l_top - 2.0 * l_row,
           "Shadows: " + menu_on_off(settings_flag(p_settings, ATTR_SET_SHADING)), TRUE);
  menu_add(p_menu, MENU_BUTTON, W_AUTO_JUMP, l_left, l_top - 3.0 * l_row - MENU_BUTTON_HEIGHT, l_left + l_half, l_top - 3.0 * l_row,
           "Auto-Jump: " + menu_on_off(settings_flag(p_settings, ATTR_SET_AUTO_JUMP)), TRUE);
  menu_add(p_menu, MENU_BUTTON, W_SHOW_HUD, l_right, l_top - 3.0 * l_row - MENU_BUTTON_HEIGHT, l_right + l_half, l_top - 3.0 * l_row,
           "Show HUD: " + menu_on_off(settings_flag(p_settings, ATTR_SET_SHOW_HUD)), TRUE);
  menu_add(p_menu, MENU_BUTTON, W_STATISTICS, l_left, l_top - 4.0 * l_row - MENU_BUTTON_HEIGHT, l_left + l_half, l_top - 4.0 * l_row,
           "Statistics: " + menu_on_off(settings_flag(p_settings, ATTR_SET_SHOW_DEBUG)), TRUE);
  menu_add(p_menu, MENU_BUTTON, W_FONT, l_right, l_top - 4.0 * l_row - MENU_BUTTON_HEIGHT, l_right + l_half, l_top - 4.0 * l_row,
           "Font...", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_SKINS, l_left, l_top - 5.0 * l_row - 12.0 - MENU_BUTTON_HEIGHT, l_left + l_half, l_top - 5.0 * l_row - 12.0,
           "Skin...", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_CONTROLS, l_right, l_top - 5.0 * l_row - 12.0 - MENU_BUTTON_HEIGHT, l_right + l_half, l_top - 5.0 * l_row - 12.0,
           "Controls...", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_PACKS, l_left, l_top - 6.0 * l_row - 12.0 - MENU_BUTTON_HEIGHT, l_left + l_half, l_top - 6.0 * l_row - 12.0,
           "Resource Packs...", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_PLAYER_SETTINGS, l_right, l_top - 6.0 * l_row - 12.0 - MENU_BUTTON_HEIGHT, l_right + l_half,
           l_top - 6.0 * l_row - 12.0, "Multiplayer...", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_DEFAULTS, l_left, l_top - 7.0 * l_row - 12.0 - MENU_BUTTON_HEIGHT, l_left + MENU_WIDE,
           l_top - 7.0 * l_row - 12.0, "Reset to Defaults", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_DONE, l_left, MENU_BUTTON_GAP + 10.0, l_left + MENU_WIDE, MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Done", TRUE);

  menu_draw_title(p_box, p_w, p_h - 18.0, "Options");
  menu_draw_widgets(p_box, p_menu, p_now);
}

// ---------------------------------------------------------------- key binds

Integer menu_key_rows()
// ----------------------------------------------------------------
// Rows of the Key Binds list: a heading for each group, then its
// actions
// ----------------------------------------------------------------
{
  return BIND_GROUP_MISC + BIND_ACTIONS;
}

Integer menu_key_row_action(Integer p_row)
// ----------------------------------------------------------------
// The action on a row of the Key Binds list (1 = first), or minus
// the group for a heading row, 0 past the end. Actions are numbered
// group by group, so a heading comes before a group's first action.
// ----------------------------------------------------------------
{
  Integer l_row    = 0;
  Integer l_action = 0;
  Integer l_group  = 0;

  for (l_action = 1; l_action <= BIND_ACTIONS; ++l_action) {
    if (settings_bind_group(l_action) != l_group) {
      l_group = settings_bind_group(l_action);
      ++l_row;
      if (l_row == p_row) return -l_group;
    }
    ++l_row;
    if (l_row == p_row) return l_action;
  }
  return 0;
}

void screen_controls(Draw_Box p_box, Attributes &p_menu, Attributes &p_settings, Integer p_listening, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// "Key Binds": each action under its heading, with the key it is
// bound to on a button (click it, then press a key) and a Reset
// button; a key two actions share shows red, the one being changed
// shows "> key <". Reset Keys and Done along the bottom.
// ----------------------------------------------------------------
{
  Integer l_rows   = menu_key_rows();
  Integer l_row    = 0;
  Integer l_last   = 0;
  Integer l_shown  = 0;
  Integer l_scroll = menu_scroll(p_menu);
  Integer l_bar    = 0;
  Integer l_action = 0;
  Integer l_widget = 0;
  Integer l_hover  = menu_id_at(p_menu, record_real(p_menu, ATTR_MENU_MOUSE_X), record_real(p_menu, ATTR_MENU_MOUSE_Y));
  Real    l_top    = p_h - 44.0;
  Real    l_bottom = MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT + 32.0;
  Real    l_centre = p_w / 2.0;
  Real    l_label  = l_centre - 250.0;
  Real    l_key0   = l_centre + 30.0;
  Real    l_key1   = l_centre + 180.0;
  Real    l_reset0 = l_centre + 188.0;
  Real    l_reset1 = l_centre + 258.0;
  Real    l_half   = (MENU_WIDE - MENU_BUTTON_GAP) / 2.0;
  Real    l_left   = l_centre - MENU_WIDE / 2.0;
  Real    l_y0     = 0.0;
  Real    l_y1     = 0.0;
  Real    l_middle = 0.0;
  Text    l_text   = "";

  l_shown  = max_integer(1, floor_integer((l_top - l_bottom - 6.0) / MENU_KEY_ROW));
  l_scroll = clamp_integer(l_scroll, 0, max_integer(0, l_rows - l_shown));
  l_last   = min_integer(l_rows, l_scroll + l_shown);
  menu_begin(p_menu);
  for (l_row = l_scroll + 1; l_row <= l_last; ++l_row) {
    l_action = menu_key_row_action(l_row);
    if (l_action <= 0) continue;
    l_y1 = l_top - 4.0 - (l_row - l_scroll - 1) * MENU_KEY_ROW;
    menu_add(p_menu, MENU_ROW, W_KEY_ROW + l_action, l_key0, l_y1 - MENU_KEY_ROW + 4.0, l_key1, l_y1, "", TRUE);
    menu_add(p_menu, MENU_BUTTON, W_KEY_RESET + l_action, l_reset0, l_y1 - MENU_KEY_ROW + 4.0, l_reset1, l_y1, "Reset",
             settings_bind(p_settings, l_action) != settings_bind_default(l_action));
  }
  menu_set_list(p_menu, l_rows, l_shown);
  if (l_rows > l_shown) {
    l_bar = menu_add(p_menu, MENU_SCROLL, W_LIST_SCROLL, l_reset1 + 16.0, l_bottom, l_reset1 + 24.0, l_top, "", TRUE);
    menu_set_value(p_menu, l_bar, l_scroll * 1.0 / (l_rows - l_shown));
  }
  menu_add(p_menu, MENU_BUTTON, W_RESET_KEYS, l_left, MENU_BUTTON_GAP + 10.0, l_left + l_half, MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT,
           "Reset Keys", settings_binds_changed(p_settings));
  menu_add(p_menu, MENU_BUTTON, W_DONE, l_left + MENU_WIDE - l_half, MENU_BUTTON_GAP + 10.0, l_left + MENU_WIDE,
           MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Done", TRUE);

  menu_dark_band(p_box, p_w, l_bottom, l_top);
  // headings and action names
  for (l_row = l_scroll + 1; l_row <= l_last; ++l_row) {
    l_action = menu_key_row_action(l_row);
    l_y1     = l_top - 4.0 - (l_row - l_scroll - 1) * MENU_KEY_ROW;
    l_middle = l_y1 - (MENU_KEY_ROW - 4.0) / 2.0;
    if (l_action < 0) {
      hud_shadow_text(p_box, l_centre, l_middle + 8.0, 15.0, TEXT_ALIGN_CENTRE, 255, 255, 255, settings_bind_group_title(-l_action));
    } else if (l_action > 0) {
      hud_shadow_text(p_box, l_label, l_middle + 8.0, 15.0, TEXT_ALIGN_LEFT, 255, 255, 255, settings_bind_title(l_action));
    }
  }
  // the key buttons: yellow while waiting for a key, red if shared
  for (l_widget = 1; l_widget <= menu_widgets(p_menu); ++l_widget) {
    if (menu_widget_kind(p_menu, l_widget) != MENU_ROW) continue;
    l_action = menu_widget_id(p_menu, l_widget) - W_KEY_ROW;
    l_y0     = record_real_at(p_menu, ATTR_MENU_Y0, l_widget);
    l_y1     = record_real_at(p_menu, ATTR_MENU_Y1, l_widget);
    l_middle = (l_y0 + l_y1) / 2.0;
    hud_draw_button(p_box, l_key0, l_y0, l_key1, l_y1, "", menu_widget_id(p_menu, l_widget) == l_hover || l_action == p_listening);
    l_text = key_label(settings_bind(p_settings, l_action));
    if (l_action == p_listening) {
      hud_text(p_box, (l_key0 + l_key1) / 2.0, l_middle + 8.0, 16.0, TEXT_ALIGN_CENTRE, 255, 255, 85, "> " + l_text + " <");
    } else if (settings_bind_clashes(p_settings, l_action)) {
      hud_text(p_box, (l_key0 + l_key1) / 2.0, l_middle + 8.0, 16.0, TEXT_ALIGN_CENTRE, 255, 85, 85, l_text);
    } else {
      hud_text(p_box, (l_key0 + l_key1) / 2.0, l_middle + 8.0, 16.0, TEXT_ALIGN_CENTRE, 255, 255, 255, l_text);
    }
  }
  if (l_bar > 0) menu_draw_scroll(p_box, l_reset1 + 16.0, l_bottom, l_reset1 + 24.0, l_top, l_scroll * 1.0 / (l_rows - l_shown), l_shown * 1.0 / l_rows);

  menu_draw_title(p_box, p_w, p_h - 14.0, "Key Binds");
  if (p_listening > 0) {
    hud_shadow_text(p_box, l_centre, l_bottom - 8.0, 13.0, TEXT_ALIGN_CENTRE, 255, 255, 160,
                    "Press a key. For Shift or Ctrl, hold it and press a letter. Escape leaves it Not Bound.");
  } else {
    hud_shadow_text(p_box, l_centre, l_bottom - 8.0, 13.0, TEXT_ALIGN_CENTRE, 200, 200, 200,
                    "Click a key to change it. Escape always pauses the game and closes screens.");
  }
  menu_draw_widgets(p_box, p_menu, p_now);
}

// ---------------------------------------------------------------- resource packs and skins

void screen_packs(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_selected, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// "Select Resource Packs": the packs in the resourcepacks folder on
// the left (click one to use it) and the one in use on the right,
// above the built-in textures (click it to stop using it)
// ----------------------------------------------------------------
{
  Integer l_count  = record_integer(p_files, ATTR_FL_COUNT);
  Integer l_file   = 0;
  Integer l_row    = 0;
  Integer l_shown  = 0;
  Integer l_scroll = menu_scroll(p_menu);
  Integer l_bar    = 0;
  Integer l_hover  = menu_id_at(p_menu, record_real(p_menu, ATTR_MENU_MOUSE_X), record_real(p_menu, ATTR_MENU_MOUSE_Y));
  Real    l_top    = p_h - 78.0;
  Real    l_bottom = MENU_BUTTON_HEIGHT + MENU_BUTTON_GAP + 44.0;
  Real    l_left0  = p_w / 2.0 - 316.0;
  Real    l_left1  = p_w / 2.0 + 16.0;
  Real    l_width  = 300.0;
  Real    l_y1     = 0.0;
  Text    l_name   = "";
  Text    l_path   = "";

  l_shown = max_integer(1, floor_integer((l_top - l_bottom) / MENU_PICK_ROW));
  menu_begin(p_menu);
  // available: every pack but the one in use
  l_row = 0;
  for (l_file = 1; l_file <= l_count; ++l_file) {
    if (record_text_at(p_files, ATTR_FL_PATH, l_file) == p_selected) continue;
    ++l_row;
    if (l_row <= l_scroll || l_row > l_scroll + l_shown) continue;
    l_y1 = l_top - (l_row - l_scroll - 1) * MENU_PICK_ROW;
    menu_add(p_menu, MENU_ROW, W_AVAILABLE_ROW + l_file, l_left0, l_y1 - MENU_PICK_ROW + 2.0, l_left0 + l_width, l_y1, record_text_at(p_files, ATTR_FL_NAME, l_file), TRUE);
  }
  menu_set_list(p_menu, l_row, l_shown);
  if (l_row > l_shown) {
    l_bar = menu_add(p_menu, MENU_SCROLL, W_LIST_SCROLL, l_left0 - 12.0, l_bottom, l_left0 - 4.0, l_top, "", TRUE);
    menu_set_value(p_menu, l_bar, l_scroll * 1.0 / (l_row - l_shown));
  }
  if (p_selected != "") {
    l_name = save_file_name(p_selected);
    menu_add(p_menu, MENU_ROW, W_SELECTED_ROW + 1, l_left1, l_top - MENU_PICK_ROW + 2.0, l_left1 + l_width, l_top, l_name, TRUE);
    menu_add(p_menu, MENU_ROW, W_SELECTED_ROW + 2, l_left1, l_top - 2.0 * MENU_PICK_ROW + 2.0, l_left1 + l_width, l_top - MENU_PICK_ROW, "Default (built in)", FALSE);
  } else {
    menu_add(p_menu, MENU_ROW, W_SELECTED_ROW + 2, l_left1, l_top - MENU_PICK_ROW + 2.0, l_left1 + l_width, l_top, "Default (built in)", FALSE);
  }
  menu_add(p_menu, MENU_BUTTON, W_DONE, p_w / 2.0 - MENU_WIDE / 2.0, MENU_BUTTON_GAP + 10.0, p_w / 2.0 + MENU_WIDE / 2.0,
           MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Done", TRUE);

  menu_dark_band(p_box, p_w, l_bottom - 6.0, l_top + 4.0);
  hud_shadow_text(p_box, l_left0 + l_width / 2.0, l_top + 26.0, 15.0, TEXT_ALIGN_CENTRE, 255, 255, 255, "Available");
  hud_shadow_text(p_box, l_left1 + l_width / 2.0, l_top + 26.0, 15.0, TEXT_ALIGN_CENTRE, 255, 255, 255, "Selected");
  for (l_file = 1; l_file <= menu_widgets(p_menu); ++l_file) {
    if (menu_widget_kind(p_menu, l_file) != MENU_ROW) continue;
    l_y1 = record_real_at(p_menu, ATTR_MENU_Y1, l_file);
    if (menu_widget_id(p_menu, l_file) == l_hover) {
      render_set_colour(p_box, 128.0, 128.0, 128.0);
      render_fill_rect (p_box, record_real_at(p_menu, ATTR_MENU_X0, l_file), l_y1 - MENU_PICK_ROW + 2.0, record_real_at(p_menu, ATTR_MENU_X1, l_file), l_y1);
      render_set_colour(p_box, 0.0, 0.0, 0.0);
      render_fill_rect (p_box, record_real_at(p_menu, ATTR_MENU_X0, l_file) + 2.0, l_y1 - MENU_PICK_ROW + 4.0, record_real_at(p_menu, ATTR_MENU_X1, l_file) - 2.0, l_y1 - 2.0);
    }
    l_name = record_text_at(p_menu, ATTR_MENU_LABEL, l_file);
    hud_text(p_box, record_real_at(p_menu, ATTR_MENU_X0, l_file) + 8.0, l_y1 - 5.0, 15.0, TEXT_ALIGN_LEFT, 255, 255, 255,
             menu_fit_text(l_name, 15.0, l_width - 16.0));
  }
  if (l_count == 0) {
    hud_text(p_box, l_left0 + 8.0, l_top - 5.0, 14.0, TEXT_ALIGN_LEFT, 160, 160, 160, "No packs found");
  }
  if (l_bar > 0) menu_draw_scroll(p_box, l_left0 - 12.0, l_bottom, l_left0 - 4.0, l_top, l_scroll * 1.0 / (l_row - l_shown), l_shown * 1.0 / l_row);
  menu_draw_title(p_box, p_w, p_h - 14.0, "Select Resource Packs");
  l_path = PACK_FOLDER;
  hud_shadow_text(p_box, p_w / 2.0, l_bottom - 12.0, 13.0, TEXT_ALIGN_CENTRE, 200, 200, 200,
                  "Put packs (.zip files or unzipped folders) in the " + l_path + " folder next to cubeland_worlds");
  menu_draw_widgets(p_box, p_menu, p_now);
}

void screen_skins(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_selected, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// "Skin": the built-in skin and the .png skins in the skins folder
// on the left (the one in use outlined), and the skin in use drawn
// from the front on the right
// ----------------------------------------------------------------
{
  Integer l_count  = record_integer(p_files, ATTR_FL_COUNT);
  Integer l_file   = 0;
  Integer l_shown  = 0;
  Integer l_scroll = menu_scroll(p_menu);
  Integer l_bar    = 0;
  Integer l_hover  = menu_id_at(p_menu, record_real(p_menu, ATTR_MENU_MOUSE_X), record_real(p_menu, ATTR_MENU_MOUSE_Y));
  Integer l_id     = 0;
  Real    l_top    = p_h - 60.0;
  Real    l_bottom = MENU_BUTTON_HEIGHT + MENU_BUTTON_GAP + 44.0;
  Real    l_left   = p_w / 2.0 - 316.0;
  Real    l_width  = 300.0;
  Real    l_y1     = 0.0;
  Real    l_unit   = 0.0;
  Real    l_cx     = p_w / 2.0 + 166.0;
  Real    l_base   = 0.0;
  Text    l_name   = "";
  Text    l_path   = "";

  l_shown = max_integer(1, floor_integer((l_top - l_bottom) / MENU_PICK_ROW));
  menu_begin(p_menu);
  for (l_file = 0; l_file <= l_count; ++l_file) {
    if (l_file < l_scroll || l_file > l_scroll + l_shown - 1) continue;
    l_y1 = l_top - (l_file - l_scroll) * MENU_PICK_ROW;
    l_name = "Built-in skin";
    if (l_file > 0) l_name = record_text_at(p_files, ATTR_FL_NAME, l_file);
    menu_add(p_menu, MENU_ROW, W_SKIN_ROW + l_file, l_left, l_y1 - MENU_PICK_ROW + 2.0, l_left + l_width, l_y1, l_name, TRUE);
  }
  menu_set_list(p_menu, l_count + 1, l_shown);
  if (l_count + 1 > l_shown) {
    l_bar = menu_add(p_menu, MENU_SCROLL, W_LIST_SCROLL, l_left - 12.0, l_bottom, l_left - 4.0, l_top, "", TRUE);
    menu_set_value(p_menu, l_bar, l_scroll * 1.0 / (l_count + 1 - l_shown));
  }
  menu_add(p_menu, MENU_BUTTON, W_DONE, p_w / 2.0 - MENU_WIDE / 2.0, MENU_BUTTON_GAP + 10.0, p_w / 2.0 + MENU_WIDE / 2.0,
           MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Done", TRUE);

  menu_dark_band(p_box, p_w, l_bottom - 6.0, l_top + 4.0);
  for (l_file = 1; l_file <= menu_widgets(p_menu); ++l_file) {
    if (menu_widget_kind(p_menu, l_file) != MENU_ROW) continue;
    l_id   = menu_widget_id(p_menu, l_file);
    l_y1   = record_real_at(p_menu, ATTR_MENU_Y1, l_file);
    l_path = "";
    if (l_id > W_SKIN_ROW) l_path = record_text_at(p_files, ATTR_FL_PATH, l_id - W_SKIN_ROW);
    if (l_id == l_hover || l_path == p_selected) {
      if (l_path == p_selected) {
        render_set_colour(p_box, 255.0, 255.0, 255.0);
      } else {
        render_set_colour(p_box, 128.0, 128.0, 128.0);
      }
      render_fill_rect (p_box, l_left, l_y1 - MENU_PICK_ROW + 2.0, l_left + l_width, l_y1);
      render_set_colour(p_box, 0.0, 0.0, 0.0);
      render_fill_rect (p_box, l_left + 2.0, l_y1 - MENU_PICK_ROW + 4.0, l_left + l_width - 2.0, l_y1 - 2.0);
    }
    hud_text(p_box, l_left + 8.0, l_y1 - 5.0, 15.0, TEXT_ALIGN_LEFT, 255, 255, 255,
             menu_fit_text(record_text_at(p_menu, ATTR_MENU_LABEL, l_file), 15.0, l_width - 16.0));
  }
  if (l_bar > 0) menu_draw_scroll(p_box, l_left - 12.0, l_bottom, l_left - 4.0, l_top, l_scroll * 1.0 / (l_count + 1 - l_shown), l_shown * 1.0 / (l_count + 1));

  // the skin from the front: a player is 32 skin pixels tall
  l_unit = min_real(8.0, (l_top - l_bottom - 20.0) / 32.0);
  l_base = l_bottom + 10.0;
  hud_draw_figure(p_box, l_cx, l_base, l_unit, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE);

  menu_draw_title(p_box, p_w, p_h - 14.0, "Skin");
  l_path = SKIN_FOLDER;
  hud_shadow_text(p_box, p_w / 2.0, l_bottom - 12.0, 13.0, TEXT_ALIGN_CENTRE, 200, 200, 200,
                  "Put skins (64 x 64 or 64 x 32 .png files) in the " + l_path + " folder next to cubeland_worlds");
  menu_draw_widgets(p_box, p_menu, p_now);
}

void screen_fonts(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_font, Text p_font_file, Real p_w, Real p_h, Real p_now)
// ----------------------------------------------------------------
// "Font": the fonts that come with Windows (each written in itself)
// and the font files in the fonts folder, the one in use outlined,
// and a box to type any installed font's name
// ----------------------------------------------------------------
{
  Integer l_count  = FONT_CHOICES + record_integer(p_files, ATTR_FL_COUNT);
  Integer l_row    = 0;
  Integer l_shown  = 0;
  Integer l_scroll = menu_scroll(p_menu);
  Integer l_bar    = 0;
  Integer l_widget = 0;
  Integer l_id     = 0;
  Integer l_in_use = FALSE;
  Integer l_hover  = menu_id_at(p_menu, record_real(p_menu, ATTR_MENU_MOUSE_X), record_real(p_menu, ATTR_MENU_MOUSE_Y));
  Real    l_top    = p_h - 60.0;
  Real    l_bottom = 2.0 * (MENU_BUTTON_HEIGHT + MENU_BUTTON_GAP) + 70.0;
  Real    l_left   = p_w / 2.0 - 200.0;
  Real    l_width  = 400.0;
  Real    l_y1     = 0.0;
  Real    l_half   = (MENU_WIDE - MENU_BUTTON_GAP) / 2.0;
  Text    l_name   = "";
  Text    l_path   = "";

  l_shown = max_integer(1, floor_integer((l_top - l_bottom) / MENU_PICK_ROW));
  menu_begin(p_menu);
  for (l_row = 1; l_row <= l_count; ++l_row) {
    if (l_row <= l_scroll || l_row > l_scroll + l_shown) continue;
    l_y1 = l_top - (l_row - l_scroll - 1) * MENU_PICK_ROW;
    if (l_row <= FONT_CHOICES) {
      l_name = font_choice(l_row);
      if (l_name == "") l_name = "Default";
    } else {
      l_name = record_text_at(p_files, ATTR_FL_NAME, l_row - FONT_CHOICES);
    }
    menu_add(p_menu, MENU_ROW, W_FONT_ROW + l_row, l_left, l_y1 - MENU_PICK_ROW + 2.0, l_left + l_width, l_y1, l_name, TRUE);
  }
  menu_set_list(p_menu, l_count, l_shown);
  if (l_count > l_shown) {
    l_bar = menu_add(p_menu, MENU_SCROLL, W_LIST_SCROLL, l_left - 12.0, l_bottom, l_left - 4.0, l_top, "", TRUE);
    menu_set_value(p_menu, l_bar, l_scroll * 1.0 / (l_count - l_shown));
  }
  menu_add(p_menu, MENU_FIELD, W_FONT_NAME, p_w / 2.0 - MENU_WIDE / 2.0, l_bottom - 56.0, p_w / 2.0 + MENU_WIDE / 2.0 - l_half / 2.0 - MENU_BUTTON_GAP,
           l_bottom - 26.0, "Or type the name of a font installed in Windows", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_FONT_USE, p_w / 2.0 + MENU_WIDE / 2.0 - l_half / 2.0, l_bottom - 57.0, p_w / 2.0 + MENU_WIDE / 2.0,
           l_bottom - 57.0 + MENU_BUTTON_HEIGHT, "Use", TRUE);
  menu_add(p_menu, MENU_BUTTON, W_DONE, p_w / 2.0 - MENU_WIDE / 2.0, MENU_BUTTON_GAP + 10.0, p_w / 2.0 + MENU_WIDE / 2.0,
           MENU_BUTTON_GAP + 10.0 + MENU_BUTTON_HEIGHT, "Done", TRUE);

  menu_dark_band(p_box, p_w, l_bottom - 6.0, l_top + 4.0);
  for (l_widget = 1; l_widget <= menu_widgets(p_menu); ++l_widget) {
    if (menu_widget_kind(p_menu, l_widget) != MENU_ROW) continue;
    l_id   = menu_widget_id(p_menu, l_widget) - W_FONT_ROW;
    l_y1   = record_real_at(p_menu, ATTR_MENU_Y1, l_widget);
    l_name = "";
    l_path = "";
    if (l_id <= FONT_CHOICES) {
      l_name   = font_choice(l_id);
      l_in_use = p_font_file == "" && l_name == p_font;
    } else {
      l_path   = record_text_at(p_files, ATTR_FL_PATH, l_id - FONT_CHOICES);
      l_in_use = l_path == p_font_file;
    }
    if (l_id + W_FONT_ROW == l_hover || l_in_use) {
      if (l_in_use) {
        render_set_colour(p_box, 255.0, 255.0, 255.0);
      } else {
        render_set_colour(p_box, 128.0, 128.0, 128.0);
      }
      render_fill_rect (p_box, l_left, l_y1 - MENU_PICK_ROW + 2.0, l_left + l_width, l_y1);
      render_set_colour(p_box, 0.0, 0.0, 0.0);
      render_fill_rect (p_box, l_left + 2.0, l_y1 - MENU_PICK_ROW + 4.0, l_left + l_width - 2.0, l_y1 - 2.0);
    }
    // each font written in itself
    if (l_id <= FONT_CHOICES) font_apply(p_box, l_name);
    hud_text(p_box, l_left + 8.0, l_y1 - 5.0, 15.0, TEXT_ALIGN_LEFT, 255, 255, 255,
             menu_fit_text(record_text_at(p_menu, ATTR_MENU_LABEL, l_widget), 15.0, l_width - 16.0));
    font_apply(p_box, p_font);
  }
  if (l_bar > 0) menu_draw_scroll(p_box, l_left - 12.0, l_bottom, l_left - 4.0, l_top, l_scroll * 1.0 / (l_count - l_shown), l_shown * 1.0 / l_count);
  menu_draw_title(p_box, p_w, p_h - 14.0, "Font");
  l_path = FONT_FOLDER;
  hud_shadow_text(p_box, p_w / 2.0, l_bottom - 72.0, 13.0, TEXT_ALIGN_CENTRE, 200, 200, 200,
                  "Font files (.ttf, .otf, .ttc) in the " + l_path + " folder are listed too; 12d needs them installed in Windows");
  menu_draw_widgets(p_box, p_menu, p_now);
}

#endif
