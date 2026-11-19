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
#include "../../include/net/net.h"
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
// pack's images over them, then the player's skin. Returns how many
// textures came from the pack; p_report says how loading the pack
// and the skin went ("" with neither).
// ----------------------------------------------------------------
{
  Text    l_path   = settings_resource_pack(p_settings);
  Text    l_skin   = "";
  Integer l_loaded = 0;

  p_report = "";
  textures_generate();
  if (l_path != "") l_loaded = pack_apply(l_path, p_report);
  if (settings_skin(p_settings) != "") {
    pack_apply_skin(settings_skin(p_settings), l_skin);
    if (p_report != "") p_report = p_report + ". ";
    p_report = p_report + l_skin;
  }
  textures_finish_all();
  return l_loaded;
}

void game_reset_state(Attributes &p_game, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid,
                      Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events,
                      Attributes &p_hud, Attributes &p_ui)
// ----------------------------------------------------------------
// Empty every record before a world is created or loaded
// ----------------------------------------------------------------
{
  events_clear    (p_events);
  save_clear_edits();
  save_clear_thumbnail();
  inventory_clear (p_inventory);
  grid_clear      (p_grid, GRID_INVENTORY_WIDTH);
  furnaces_clear  (p_furnaces);
  cows_clear      (p_cows);
  drops_clear     (p_drops);
  record_clear    (p_away, DATATYPE_AWAY);
  hud_clear       (p_hud);
  ui_clear        (p_ui);
  player_reset    (p_player, 0.0, 0.0, 0.0);
  player_set_game_mode(p_player, GAMEMODE_SURVIVAL);   // a new world starts in survival
  record_set_real (p_game, ATTR_GAME_AUTOSAVE, 0.0);
}

Text game_world_name(Attributes &p_game)
// ----------------------------------------------------------------
// Name of the world being played
// ----------------------------------------------------------------
{
  return record_text(p_game, ATTR_GAME_WORLD_NAME);
}

Integer game_new_world(Text p_name, Integer p_seed, Integer p_mode, Attributes &p_game, Attributes &p_info, Attributes &p_player,
                       Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows,
                       Attributes &p_drops, Attributes &p_away, Attributes &p_events, Attributes &p_hud, Attributes &p_ui)
// ----------------------------------------------------------------
// Generate a fresh world from a seed, put the player in the starter
// house with some cows about in a game mode (GAMEMODE_...), and save
// it straight away
// ----------------------------------------------------------------
{
  Attributes l_cow_random;
  Real       l_spawn_x = 0.0;
  Real       l_spawn_y = 0.0;
  Real       l_spawn_z = 0.0;

  game_reset_state(p_game, p_player, p_inventory, p_grid, p_furnaces, p_cows, p_drops, p_away, p_events, p_hud, p_ui);
  record_set_text (p_game, ATTR_GAME_WORLD_NAME, p_name);

  world_generate(p_info, p_seed);
  mesh_reset();

  world_info_spawn(p_info, l_spawn_x, l_spawn_y, l_spawn_z);
  player_reset    (p_player, l_spawn_x, l_spawn_y + COLLISION_EPSILON, l_spawn_z);
  player_set_look (p_player, HALF_PI * 3.0, -0.1);
  player_set_game_mode(p_player, p_mode);

  // Cows and pigs come from the seed too, so a seed always starts
  // the same (pigs from a sequence of their own, so they don't move
  // the cows of a seed)
  random_seed      (l_cow_random, p_seed);
  cows_spawn_random(p_cows, l_cow_random, COW_TARGET_COUNT, l_spawn_x, l_spawn_z, 10.0);
  random_seed      (l_cow_random, p_seed + 7919);
  mobs_spawn_random(p_cows, l_cow_random, MOB_PIG, PIG_TARGET_COUNT, l_spawn_x, l_spawn_z, 10.0);

  if (game_save_world(p_game, p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_away, p_events) != SUCCESS) return FAILURE;
  events_clear(p_events);
  return SUCCESS;
}

Integer game_load_world(Text p_name, Attributes &p_game, Attributes &p_info, Attributes &p_player,
                        Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows,
                        Attributes &p_drops, Attributes &p_away, Attributes &p_events, Attributes &p_hud, Attributes &p_ui,
                        Text &p_problem)
// ----------------------------------------------------------------
// Load a saved world; problem says why if it fails
// ----------------------------------------------------------------
{
  game_reset_state(p_game, p_player, p_inventory, p_grid, p_furnaces, p_cows, p_drops, p_away, p_events, p_hud, p_ui);
  record_set_text (p_game, ATTR_GAME_WORLD_NAME, p_name);
  if (load_world(p_name, p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_away, p_problem) != SUCCESS) return FAILURE;
  // Worlds saved while flying land you unless they are in creative
  // or spectator
  if (player_survival(p_player)) player_set_flying(p_player, FALSE);
  events_clear(p_events);
  return SUCCESS;
}

Integer game_host(Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                  Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events,
                  Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Text p_folder, Text p_session,
                  Text p_id, Text p_name, Real p_now, Text &p_problem)
// ----------------------------------------------------------------
// Host the world being played: put a copy of it in the multiplayer
// folder and name the session there, so others can join
// ----------------------------------------------------------------
{
  p_problem = "";
  if (!net_ensure_folder(p_folder)) {
    p_problem = "the multiplayer folder " + p_folder + " couldn't be made";
    return FAILURE;
  }
  if (save_world_to(net_snapshot_path(p_folder, p_session), game_world_name(p_game), p_info, p_player, p_inventory,
                    p_furnaces, p_cows, p_drops, p_away, p_events) != SUCCESS) {
    p_problem = "the world couldn't be written to " + p_folder;
    return FAILURE;
  }
  if (net_write_session(p_folder, p_session, p_id, world_info_seed(p_info), game_world_name(p_game)) != SUCCESS) {
    p_problem = "the session file couldn't be written in " + p_folder;
    return FAILURE;
  }
  net_start(p_net, p_peers, p_inbox, NET_HOST, p_folder, p_session, p_id, p_id, p_name, p_now);
  events_clear(p_events);
  return SUCCESS;
}

Integer game_join(Text p_folder, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                  Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away,
                  Attributes &p_events, Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Attributes &p_peers, Attributes &p_inbox,
                  Text p_id, Text p_name, Real p_now, Text &p_problem)
// ----------------------------------------------------------------
// Join the game hosted in the multiplayer folder: load the host's
// world as it was when hosting started (everyone's changes since
// then are read from their logs) and start at the spawn point with
// an empty inventory, in survival. Your own copy is saved as
// "MP <world>".
// ----------------------------------------------------------------
{
  Text    l_session = "";
  Text    l_host    = "";
  Text    l_world   = "";
  Integer l_seed    = 0;
  Real    l_x       = 0.0;
  Real    l_y       = 0.0;
  Real    l_z       = 0.0;

  if (net_read_session(p_folder, l_session, l_host, l_seed, l_world, p_problem) != SUCCESS) return FAILURE;

  game_reset_state(p_game, p_player, p_inventory, p_grid, p_furnaces, p_cows, p_drops, p_away, p_events, p_hud, p_ui);
  record_set_text (p_game, ATTR_GAME_WORLD_NAME, "MP " + l_world);
  if (load_world_from(net_snapshot_path(p_folder, l_session), p_info, p_player, p_inventory, p_furnaces, p_cows,
                      p_drops, p_away, p_problem) != SUCCESS) return FAILURE;

  // the snapshot holds the host's player, chests and furnaces: start
  // afresh (chests and furnaces fill up as you use them)
  world_info_spawn   (p_info, l_x, l_y, l_z);
  player_reset       (p_player, l_x, l_y + COLLISION_EPSILON, l_z);
  player_set_game_mode(p_player, GAMEMODE_SURVIVAL);
  inventory_clear    (p_inventory);
  furnaces_clear     (p_furnaces);
  drops_clear        (p_drops);
  game_clear_away    (p_away);

  net_start(p_net, p_peers, p_inbox, NET_GUEST, p_folder, l_session, l_host, p_id, p_name, p_now);
  events_clear(p_events);
  return SUCCESS;
}

Integer game_save_world(Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                        Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events)
// ----------------------------------------------------------------
// Save the world being played
// ----------------------------------------------------------------
{
  return save_world(game_world_name(p_game), p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_away, p_events);
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

void game_clear_away(Attributes &p_away)
// ----------------------------------------------------------------
// The other dimension has no furnaces, chests or drops (its mobs
// stay): used when joining a game, which starts those afresh
// ----------------------------------------------------------------
{
  Attributes l_cows;

  record_copy_unprefixed(p_away, l_cows, AWAY_COWS);
  record_clear          (p_away, DATATYPE_AWAY);
  record_copy_prefixed  (l_cows, p_away, AWAY_COWS);
}

void game_swap_away(Attributes &p_record, Attributes &p_away, Attributes &p_keep, Text p_prefix)
// ----------------------------------------------------------------
// Part of game_switch_dimension for one kind of thing: the record
// being played is kept in keep under prefix, and the record takes
// what away held under prefix (an empty record of the same type if
// it held nothing yet)
// ----------------------------------------------------------------
{
  Text l_type = record_datatype(p_record);

  record_copy_prefixed  (p_record, p_keep, p_prefix);
  record_copy_unprefixed(p_away, p_record, p_prefix);
  if (record_datatype(p_record) == "") record_clear(p_record, l_type);
}

void game_switch_dimension(Attributes &p_info, Attributes &p_cows, Attributes &p_drops, Attributes &p_furnaces,
                           Attributes &p_away, Integer p_to)
// ----------------------------------------------------------------
// Swap the blocks in g_world for the other dimension: this one's
// changes are put away, the other is generated from the seed (into a
// scratch record, so the world record keeps its spawn point and
// clock) with its own changes put back. Each dimension keeps its own
// mobs, drops, furnaces and chests: this one's go into the away
// record and the other's come out of it.
// ----------------------------------------------------------------
{
  Attributes l_scratch;
  Attributes l_keep;

  if (p_to == world_dimension()) return;
  record_clear  (l_keep, DATATYPE_AWAY);
  game_swap_away(p_cows,     p_away, l_keep, AWAY_COWS);
  game_swap_away(p_drops,    p_away, l_keep, AWAY_DROPS);
  game_swap_away(p_furnaces, p_away, l_keep, AWAY_FURNACES);
  record_copy           (l_keep, p_away);
  save_swap_edits();
  world_generate_dimension(l_scratch, world_info_seed(p_info), p_to);
  record_set_integer(p_info, ATTR_WORLD_DIMENSION, p_to);
  mesh_reset();
  save_apply_edits();
  mobs_rebuild_index    (p_cows);
  drops_rebuild_index   (p_drops);
  furnaces_rebuild_index(p_furnaces);
}

Integer game_travel(Attributes &p_info, Attributes &p_player, Attributes &p_cows, Attributes &p_drops,
                    Attributes &p_furnaces, Attributes &p_away, Attributes &p_events)
// ----------------------------------------------------------------
// Take the player through the portal they are standing in to the
// other dimension, at the same place across (the world is too small
// for the block game's 1 : 8). They come out in the portal there that
// they last used, or the nearest one, or a new portal built for them.
// Returns the dimension they are now in.
// ----------------------------------------------------------------
{
  Integer l_from  = world_dimension();
  Integer l_to    = DIM_NETHER;
  Integer l_found = FALSE;
  Integer l_px    = 0;
  Integer l_py    = 0;
  Integer l_pz    = 0;
  Real    l_x     = 0.0;
  Real    l_y     = 0.0;
  Real    l_z     = 0.0;

  if (l_from == DIM_NETHER) l_to = DIM_OVERWORLD;
  player_position(p_player, l_x, l_y, l_z);

  // remember this portal, to come back out of it
  if (world_find_portal(floor_integer(l_x), floor_integer(l_y), floor_integer(l_z), 2, l_px, l_py, l_pz)) {
    record_set_integer_at(p_info, ATTR_PORTAL_X,     l_from + 1, l_px);
    record_set_integer_at(p_info, ATTR_PORTAL_Y,     l_from + 1, l_py);
    record_set_integer_at(p_info, ATTR_PORTAL_Z,     l_from + 1, l_pz);
    record_set_integer_at(p_info, ATTR_PORTAL_KNOWN, l_from + 1, TRUE);
  }

  game_switch_dimension(p_info, p_cows, p_drops, p_furnaces, p_away, l_to);

  if (record_integer_at(p_info, ATTR_PORTAL_KNOWN, l_to + 1) == TRUE) {
    l_found = world_find_portal(record_integer_at(p_info, ATTR_PORTAL_X, l_to + 1), record_integer_at(p_info, ATTR_PORTAL_Y, l_to + 1),
                                record_integer_at(p_info, ATTR_PORTAL_Z, l_to + 1), 1, l_px, l_py, l_pz);
  }
  if (!l_found) l_found = world_find_portal(floor_integer(l_x), floor_integer(l_y), floor_integer(l_z), PORTAL_SEARCH, l_px, l_py, l_pz);
  if (!l_found) {
    // a new portal (its inside starts one cell along and up)
    world_portal_spot (floor_integer(l_x), floor_integer(l_z), l_px, l_py, l_pz);
    world_build_portal(p_events, l_px, l_py, l_pz);
    l_px = l_px + 1;
    l_py = l_py + 1;
  }
  player_set_position(p_player, l_px + 0.5, l_py + COLLISION_EPSILON, l_pz + 0.5);
  player_arrived     (p_player);
  // face out of the portal: across its frame
  if (world_get_block(l_px + 1, l_py, l_pz) == BLOCK_PORTAL || world_get_block(l_px - 1, l_py, l_pz) == BLOCK_PORTAL) {
    player_set_look(p_player, HALF_PI, 0.0);
  } else {
    player_set_look(p_player, 0.0, 0.0);
  }
  if (l_to == DIM_NETHER) {
    emit_toast(p_events, "The Nether: mind the lava. Step back into the portal to go home.");
  }
  return l_to;
}

void game_respawn(Attributes &p_info, Attributes &p_player, Attributes &p_cows, Attributes &p_drops, Attributes &p_furnaces,
                  Attributes &p_away, Attributes &p_events)
// ----------------------------------------------------------------
// Back to the spawn point with full health (the inventory is kept),
// which is in the overworld
// ----------------------------------------------------------------
{
  Real l_x = 0.0;
  Real l_y = 0.0;
  Real l_z = 0.0;

  game_switch_dimension(p_info, p_cows, p_drops, p_furnaces, p_away, DIM_OVERWORLD);
  world_info_spawn(p_info, l_x, l_y, l_z);
  player_reset    (p_player, l_x, l_y + COLLISION_EPSILON, l_z);
  player_set_look (p_player, HALF_PI * 3.0, -0.1);
  emit_simple_event(p_events, EVT_PLAYER_RESPAWNED);
}

void game_dispatch_events(Attributes &p_events, Attributes &p_event, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                          Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_random,
                          Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Real p_now)
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
    player_on_event (p_event, p_player, p_inventory, p_events);
    cows_on_event   (p_event, p_cows, p_random, p_events);
    save_on_event   (p_event);
    furnace_on_event(p_event, p_furnaces, p_events);
    chest_on_event  (p_event, p_furnaces, p_events);
    drops_on_event  (p_event, p_drops, p_random);
    hud_on_event    (p_event, p_hud, p_now);
    ui_on_event     (p_event, p_ui, p_inventory, p_grid, p_furnaces, p_events, l_x, l_y + 1.3, l_z);
    net_on_event    (p_event, p_net);

    ++l_guard;
    if (l_guard > EVENT_QUEUE_SIZE * 4) break;
  }
}

void game_update(Real p_dt, Real p_real_dt, Real p_now, Integer p_running,
                 Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory,
                 Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away,
                 Attributes &p_events, Attributes &p_event, Attributes &p_random, Attributes &p_settings,
                 Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Attributes &p_peers, Attributes &p_inbox)
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

  // Multiplayer: what the others did since the last frame (read by
  // the controller's net_poll), and where you are for them
  net_apply     (p_net, p_peers, p_inbox, p_info, p_hud, p_events, p_real_dt, p_now);
  net_send_state(p_net, p_player, p_info, p_now);

  if (p_running) {
    if (world_daylight_cycle(p_info)) world_advance_time(p_info, p_dt);
    player_update(p_player, p_cows, p_events, settings_flag(p_settings, ATTR_SET_AUTO_JUMP), p_dt, p_now);
    player_position(p_player, l_x, l_y, l_z);
    cows_update (p_cows, p_random, p_events, l_x, l_y, l_z, world_is_night(world_time_of_day(p_info)),
                 player_is_dead(p_player) || !player_survival(p_player), p_dt);
    drops_update(p_drops, p_inventory, p_events, l_x, l_y, l_z, player_is_dead(p_player) || player_spectator(p_player), p_dt);
    world_fire_ticks(p_events, p_random, l_x, l_y, l_z, p_dt);

    l_autosave = l_autosave + p_dt;
    if (l_autosave > AUTOSAVE_SECONDS) {
      l_autosave = 0.0;
      game_save_world(p_game, p_info, p_player, p_inventory, p_furnaces, p_cows, p_drops, p_away, p_events);
    }
    record_set_real(p_game, ATTR_GAME_AUTOSAVE, l_autosave);
  }

  game_dispatch_events(p_events, p_event, p_info, p_player, p_inventory, p_grid, p_furnaces, p_cows, p_drops, p_random, p_hud, p_ui, p_net, p_now);
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
