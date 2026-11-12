#ifndef GAME_4DM_INCLUDED
#define GAME_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/blocks/textures.h"
#include "../../include/blocks/resource_pack.h"
#include "../../include/program/settings.h"
#include "../../include/items/chest.h"
#include "../../include/world/world.h"
#include "../../include/world/mesh.h"
#include "../../include/world/physics.h"
#include "../../include/items/inventory.h"
#include "../../include/items/crafting.h"
#include "../../include/items/furnace.h"
#include "../../include/mobs/cows.h"
#include "../../include/items/drops.h"
#include "../../include/player/player.h"
#include "../../include/program/settings.h"
#include "../../include/render/render.h"
#include "../../include/render/hud.h"
#include "../../include/render/ui.h"
#include "../../include/program/save.h"
#include "../../include/program/game.h"

void game_init_once(Attributes &p_game, Attributes &p_book, Attributes &p_settings, Attributes &p_random, Integer p_time_seed)
// ----------------------------------------------------------------
// Work done once per run of the macro: textures, recipes, renderer
// tables, the settings and the random sequence for gameplay
// ----------------------------------------------------------------
{
  Text l_report = "";

  if (record_integer(p_game, ATTR_GAME_READY)) return;

  record_clear(p_game, DATATYPE_GAME);
  random_seed(p_random, p_time_seed);

  crafting_init_book(p_book);
  render_init();
  settings_load(p_settings, save_settings_path());
  game_load_textures(p_settings, l_report);
  record_set_text(p_game, ATTR_GAME_PACK_REPORT, l_report);

  record_set_integer(p_game, ATTR_GAME_READY, TRUE);
}

Integer game_load_textures(Attributes &p_settings, Text &p_report)
// ----------------------------------------------------------------
// Build the textures: the built-in ones, then the chosen resource
// pack's images over them. Returns how many textures came from the
// pack; p_report says how loading it went ("" without a pack).
// ----------------------------------------------------------------
{
  Text    l_path   = settings_resource_pack(p_settings);
  Integer l_loaded = 0;

  p_report = "";
  textures_generate();
  if (l_path != "") l_loaded = pack_apply(l_path, p_report);
  textures_finish_all();
  return l_loaded;
}

void game_reset_state(Attributes &p_game, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid,
                      Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events,
                      Attributes &p_hud, Attributes &p_ui)
// ----------------------------------------------------------------
// Empty every record before a world is created or loaded
// ----------------------------------------------------------------
{
  events_clear    (p_events);
  save_clear_edits();
  inventory_clear (p_inventory);
  grid_clear      (p_grid, GRID_INVENTORY_WIDTH);
  furnaces_clear  (p_furnaces);
  cows_clear      (p_cows);
  drops_clear     (p_drops);
  hud_clear       (p_hud);
  ui_clear        (p_ui);
  player_reset    (p_player, 0.0, 0.0, 0.0);
  player_set_creative(p_player, FALSE);   // a new world starts in survival
  record_set_real (p_game, ATTR_GAME_AUTOSAVE, 0.0);
}

Text game_world_name(Attributes &p_game)
// ----------------------------------------------------------------
// Name of the world being played
// ----------------------------------------------------------------
{
  return record_text(p_game, ATTR_GAME_WORLD_NAME);
}

Integer game_new_world(Text p_name, Integer p_seed, Attributes &p_game, Attributes &p_info, Attributes &p_player,
                       Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows,
                       Attributes &p_drops, Attributes &p_events, Attributes &p_hud, Attributes &p_ui)
// ----------------------------------------------------------------
// Generate a fresh world from a seed, put the player in the starter
// house with some cows about, and save it straight away
// ----------------------------------------------------------------
{
  Attributes l_cow_random;
  Real       l_spawn_x = 0.0;
  Real       l_spawn_y = 0.0;
  Real       l_spawn_z = 0.0;

  game_reset_state(p_game, p_player, p_inventory, p_grid, p_furnaces, p_cows, p_drops, p_events, p_hud, p_ui);
  record_set_text (p_game, ATTR_GAME_WORLD_NAME, p_name);

  world_generate(p_info, p_seed);
  mesh_reset();

  world_info_spawn(p_info, l_spawn_x, l_spawn_y, l_spawn_z);
  player_reset    (p_player, l_spawn_x, l_spawn_y + COLLISION_EPSILON, l_spawn_z);
  player_set_look (p_player, HALF_PI * 3.0, -0.1);

  // Cows and pigs come from the seed too, so a seed always starts
  // the same (pigs from a sequence of their own, so they don't move
  // the cows of a seed)
  random_seed      (l_cow_random, p_seed);
  cows_spawn_random(p_cows, l_cow_random, COW_TARGET_COUNT, l_spawn_x, l_spawn_z, 10.0);
  random_seed      (l_cow_random, p_seed + 7919);
  mobs_spawn_random(p_cows, l_cow_random, MOB_PIG, PIG_TARGET_COUNT, l_spawn_x, l_spawn_z, 10.0);

  if (game_save_world(p_game, p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_events) != SUCCESS) return FAILURE;
  events_clear(p_events);
  return SUCCESS;
}

Integer game_load_world(Text p_name, Attributes &p_game, Attributes &p_info, Attributes &p_player,
                        Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows,
                        Attributes &p_drops, Attributes &p_events, Attributes &p_hud, Attributes &p_ui, Text &p_problem)
// ----------------------------------------------------------------
// Load a saved world; problem says why if it fails
// ----------------------------------------------------------------
{
  game_reset_state(p_game, p_player, p_inventory, p_grid, p_furnaces, p_cows, p_drops, p_events, p_hud, p_ui);
  record_set_text (p_game, ATTR_GAME_WORLD_NAME, p_name);
  if (load_world(p_name, p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_problem) != SUCCESS) return FAILURE;
  // Worlds saved while flying land you unless they are in creative
  player_set_creative(p_player, player_creative(p_player));
  events_clear(p_events);
  return SUCCESS;
}

Integer game_save_world(Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                        Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events)
// ----------------------------------------------------------------
// Save the world being played
// ----------------------------------------------------------------
{
  return save_world(game_world_name(p_game), p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_events);
}

void game_build_nearby(Attributes &p_player, Integer p_range)
// ----------------------------------------------------------------
// Build the face lists within range of the player up front, so the
// first frame doesn't stall
// ----------------------------------------------------------------
{
  Integer l_sx    = 0;
  Integer l_sy    = 0;
  Integer l_sz    = 0;
  Integer l_reach = p_range + SECTION_SIZE;
  Real    l_x     = 0.0;
  Real    l_y     = 0.0;
  Real    l_z     = 0.0;
  Integer l_sx0   = 0;
  Integer l_sx1   = 0;
  Integer l_sz0   = 0;
  Integer l_sz1   = 0;

  player_position(p_player, l_x, l_y, l_z);
  l_sx0 = clamp_integer(floor_integer((l_x - l_reach) / SECTION_SIZE), 0, SECTIONS_X - 1);
  l_sx1 = clamp_integer(floor_integer((l_x + l_reach) / SECTION_SIZE), 0, SECTIONS_X - 1);
  l_sz0 = clamp_integer(floor_integer((l_z - l_reach) / SECTION_SIZE), 0, SECTIONS_Z - 1);
  l_sz1 = clamp_integer(floor_integer((l_z + l_reach) / SECTION_SIZE), 0, SECTIONS_Z - 1);

  for (l_sx = l_sx0; l_sx <= l_sx1; ++l_sx) {
    for (l_sz = l_sz0; l_sz <= l_sz1; ++l_sz) {
      for (l_sy = 0; l_sy < SECTIONS_Y; ++l_sy) mesh_ensure_section(l_sx, l_sy, l_sz);
    }
  }
}

void game_respawn(Attributes &p_info, Attributes &p_player, Attributes &p_events)
// ----------------------------------------------------------------
// Back to the spawn point with full health (the inventory is kept)
// ----------------------------------------------------------------
{
  Real l_x = 0.0;
  Real l_y = 0.0;
  Real l_z = 0.0;

  world_info_spawn(p_info, l_x, l_y, l_z);
  player_reset    (p_player, l_x, l_y + COLLISION_EPSILON, l_z);
  player_set_look (p_player, HALF_PI * 3.0, -0.1);
  emit_simple_event(p_events, EVT_PLAYER_RESPAWNED);
}

void game_dispatch_events(Attributes &p_events, Attributes &p_event, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                          Attributes &p_grid, Attributes &p_furnaces, Attributes &p_drops, Attributes &p_random,
                          Attributes &p_hud, Attributes &p_ui, Real p_now)
// ----------------------------------------------------------------
// Hand every queued event to each module's handler. Handlers may
// emit more events; those are dispatched in the same pass.
// ----------------------------------------------------------------
{
  Integer l_guard = 0;
  Real    l_x     = 0.0;
  Real    l_y     = 0.0;
  Real    l_z     = 0.0;

  player_position(p_player, l_x, l_y, l_z);

  while (next_event(p_events, p_event)) {
    mesh_on_event   (p_event);
    world_on_event  (p_event, p_info, p_events);
    player_on_event (p_event, p_player, p_events);
    save_on_event   (p_event);
    furnace_on_event(p_event, p_furnaces, p_events);
    chest_on_event  (p_event, p_furnaces, p_events);
    drops_on_event  (p_event, p_drops, p_random);
    hud_on_event    (p_event, p_hud, p_now);
    ui_on_event     (p_event, p_ui, p_inventory, p_grid, p_furnaces, p_events, l_x, l_y + 1.3, l_z);

    ++l_guard;
    if (l_guard > EVENT_QUEUE_SIZE * 4) break;
  }
}

void game_update(Real p_dt, Real p_real_dt, Real p_now, Integer p_running,
                 Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                 Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops,
                 Attributes &p_events, Attributes &p_event, Attributes &p_random, Attributes &p_settings,
                 Attributes &p_hud, Attributes &p_ui)
// ----------------------------------------------------------------
// Advance the game by dt seconds (capped so a slow frame can't make
// things jump). running is FALSE while paused or in a screen; then
// only furnaces keep going. Furnaces run on real_dt, the actual time
// since the last frame, so they cook while the game is paused too.
// ----------------------------------------------------------------
{
  Real l_x        = 0.0;
  Real l_y        = 0.0;
  Real l_z        = 0.0;
  Real l_autosave = record_real(p_game, ATTR_GAME_AUTOSAVE);

  furnaces_update(p_furnaces, p_events, p_real_dt);

  if (p_running) {
    if (world_daylight_cycle(p_info)) world_advance_time(p_info, p_dt);
    player_update(p_player, p_cows, p_events, settings_flag(p_settings, ATTR_SET_AUTO_JUMP), p_dt, p_now);
    player_position(p_player, l_x, l_y, l_z);
    cows_update (p_cows, p_random, p_events, l_x, l_y, l_z, world_is_night(world_time_of_day(p_info)),
                 player_is_dead(p_player) || player_creative(p_player), p_dt);
    drops_update(p_drops, p_inventory, p_events, l_x, l_y, l_z, player_is_dead(p_player), p_dt);

    l_autosave = l_autosave + p_dt;
    if (l_autosave > AUTOSAVE_SECONDS) {
      l_autosave = 0.0;
      game_save_world(p_game, p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_events);
    }
    record_set_real(p_game, ATTR_GAME_AUTOSAVE, l_autosave);
  }

  game_dispatch_events(p_events, p_event, p_info, p_player, p_inventory, p_grid, p_furnaces, p_drops, p_random, p_hud, p_ui, p_now);
}

void game_select_slot(Attributes &p_player, Attributes &p_hud, Integer p_slot, Real p_now)
// ----------------------------------------------------------------
// Choose a hotbar slot and briefly show the item's name
// ----------------------------------------------------------------
{
  player_set_selected(p_player, p_slot);
  hud_show_name      (p_hud, p_now);
}

#endif
