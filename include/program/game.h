#ifndef GAME_H_INCLUDED
#define GAME_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// Game model glue: starting worlds, the per-frame update and the
// event dispatcher that hands each event to every module
//
// The game's records are declared here. Only the controllers
// (*_panel.4dm) name these globals; they pass the records to the
// functions below, which pass them on, so every function's
// signature shows what it uses.
// ----------------------------------------------------------------

#define DATATYPE_GAME        ("game")
#define ATTR_GAME_WORLD_NAME ("world_name")
#define ATTR_GAME_AUTOSAVE   ("autosave_timer")
#define ATTR_GAME_READY      ("initialised")
#define ATTR_GAME_PACK_REPORT ("pack_report")   // how loading the resource pack went

/*Global variables*/ {
  Attributes g_game;        // world name, autosave timer
  Attributes g_info;        // the world: seed, spawn point, house
  Attributes g_player;
  Attributes g_inventory;
  Attributes g_grid;        // the crafting grid of the open screen
  Attributes g_furnaces;
  Attributes g_cows;
  Attributes g_drops;
  Attributes g_events;      // queue of events waiting to be dispatched
  Attributes g_event;       // the event being dispatched
  Attributes g_random;
  Attributes g_settings;
  Attributes g_hud;
  Attributes g_ui;
  Attributes g_book;        // recipes
}

Integer game_load_textures    (Attributes &p_settings, Text &p_report);
void    game_init_once        (Attributes &p_game, Attributes &p_book, Attributes &p_settings, Attributes &p_random, Integer p_time_seed);
void    game_reset_state      (Attributes &p_game, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid,
                               Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events,
                               Attributes &p_hud, Attributes &p_ui);
Text    game_world_name       (Attributes &p_game);
Integer game_new_world        (Text p_name, Integer p_seed, Attributes &p_game, Attributes &p_info, Attributes &p_player,
                               Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows,
                               Attributes &p_drops, Attributes &p_events, Attributes &p_hud, Attributes &p_ui);
Integer game_load_world       (Text p_name, Attributes &p_game, Attributes &p_info, Attributes &p_player,
                               Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows,
                               Attributes &p_drops, Attributes &p_events, Attributes &p_hud, Attributes &p_ui, Text &p_problem);
Integer game_save_world       (Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                               Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events);
void    game_build_nearby     (Attributes &p_player, Integer p_range);
void    game_respawn          (Attributes &p_info, Attributes &p_player, Attributes &p_events);
void    game_dispatch_events  (Attributes &p_events, Attributes &p_event, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                               Attributes &p_grid, Attributes &p_furnaces, Attributes &p_drops, Attributes &p_random,
                               Attributes &p_hud, Attributes &p_ui, Real p_now);
void    game_update           (Real p_dt, Real p_real_dt, Real p_now, Integer p_running,
                               Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                               Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops,
                               Attributes &p_events, Attributes &p_event, Attributes &p_random, Attributes &p_settings,
                               Attributes &p_hud, Attributes &p_ui);
void    game_select_slot      (Attributes &p_player, Attributes &p_hud, Integer p_slot, Real p_now);

#endif
