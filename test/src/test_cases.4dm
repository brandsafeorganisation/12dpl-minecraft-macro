#ifndef TEST_CASES_4DM_INCLUDED
#define TEST_CASES_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/records.h"
#include "../../include/core/util.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/items/inventory.h"
#include "../../include/items/crafting.h"
#include "../../include/world/world.h"
#include "../../include/world/physics.h"
#include "../../include/player/player.h"
#include "../../include/program/commands.h"
#include "../../include/program/game.h"
#include "../../include/render/ui.h"
#include "../../include/net/net.h"
#include "../include/test.h"

// fields of the record the records checks use
#define DATATYPE_CHECK          ("check")
#define ATTR_CHECK_COUNT        ("count")
#define ATTR_CHECK_SPEED        ("speed")
#define ATTR_CHECK_NAME         ("name")
#define ATTR_CHECK_MISSING      ("missing")
#define ATTR_CHECK_X            ("x")

// ----------------------------------------------------------------
// Unit tests: calls with the answers they must give. Each check is
// listed in the report, and the failures at the top. Add checks to
// test_cases_run, in a group named after the module.
//
// The world checks need "Make test world" (the panel makes it before
// running these). Checks that change the game's records put them
// back as they found them where it matters, or reset them.
// ----------------------------------------------------------------

void test_group(Attributes &p_results, Text p_group)
// ----------------------------------------------------------------
// The checks after this belong to p_group
// ----------------------------------------------------------------
{
  record_set_text(p_results, ATTR_TR_GROUP, p_group);
}

void test_check(Attributes &p_results, Text p_name, Text p_want, Text p_got, Integer p_ok)
// ----------------------------------------------------------------
// Record one check
// ----------------------------------------------------------------
{
  Integer l_check = record_integer(p_results, ATTR_TR_CHECKS) + 1;

  record_set_integer   (p_results, ATTR_TR_CHECKS,      l_check);
  record_set_text_at   (p_results, ATTR_TR_CHECK_GROUP, l_check, record_text(p_results, ATTR_TR_GROUP));
  record_set_text_at   (p_results, ATTR_TR_CHECK_NAME,  l_check, p_name);
  record_set_text_at   (p_results, ATTR_TR_CHECK_WANT,  l_check, p_want);
  record_set_text_at   (p_results, ATTR_TR_CHECK_GOT,   l_check, p_got);
  record_set_integer_at(p_results, ATTR_TR_CHECK_OK,    l_check, p_ok == TRUE);
}

void test_expect_integer(Attributes &p_results, Text p_name, Integer p_got, Integer p_want)
// ----------------------------------------------------------------
// p_got must equal p_want
// ----------------------------------------------------------------
{
  test_check(p_results, p_name, To_text(p_want), To_text(p_got), p_got == p_want);
}

void test_expect_real(Attributes &p_results, Text p_name, Real p_got, Real p_want, Real p_tolerance)
// ----------------------------------------------------------------
// p_got must be within p_tolerance of p_want
// ----------------------------------------------------------------
{
  test_check(p_results, p_name, To_text(p_want, 6), To_text(p_got, 6), Absolute(p_got - p_want) <= p_tolerance);
}

void test_expect_text(Attributes &p_results, Text p_name, Text p_got, Text p_want)
// ----------------------------------------------------------------
// p_got must equal p_want
// ----------------------------------------------------------------
{
  test_check(p_results, p_name, p_want, p_got, p_got == p_want);
}

void test_expect_true(Attributes &p_results, Text p_name, Integer p_got)
// ----------------------------------------------------------------
// p_got must be TRUE (not zero)
// ----------------------------------------------------------------
{
  Text l_got = "FALSE";

  if (p_got) l_got = "TRUE";
  test_check(p_results, p_name, "TRUE", l_got, p_got != 0);
}

Integer test_checks_failed(Attributes &p_results)
// ----------------------------------------------------------------
// How many checks failed
// ----------------------------------------------------------------
{
  Integer l_check  = 0;
  Integer l_failed = 0;

  for (l_check = 1; l_check <= record_integer(p_results, ATTR_TR_CHECKS); ++l_check) {
    if (record_integer_at(p_results, ATTR_TR_CHECK_OK, l_check) != TRUE) ++l_failed;
  }
  return l_failed;
}

void test_cases_run(Attributes &p_results)
// ----------------------------------------------------------------
// Every unit test
// ----------------------------------------------------------------
{
  Attributes l_record;
  Attributes l_random;
  Attributes l_other;
  Integer    l_i      = 0;
  Integer    l_value  = 0;
  Integer    l_inside = TRUE;
  Integer    l_same   = TRUE;
  Integer    l_block  = 0;
  Integer    l_x      = 0;
  Integer    l_y      = 0;
  Integer    l_z      = 0;
  Real       l_px     = 0.0;
  Real       l_py     = 0.0;
  Real       l_pz     = 0.0;
  Text       l_reply  = "";

  // ---------------------------------------------------- util
  test_group(p_results, "util");
  test_expect_integer(p_results, "floor_divide(7, 2)",          floor_divide(7, 2), 3);
  test_expect_integer(p_results, "floor_divide(-7, 2)",         floor_divide(-7, 2), -4);
  test_expect_integer(p_results, "floor_divide(-8, 2)",         floor_divide(-8, 2), -4);
  test_expect_integer(p_results, "positive_mod(-1, 9)",         positive_mod(-1, 9), 8);
  test_expect_integer(p_results, "positive_mod(10, 9)",         positive_mod(10, 9), 1);
  test_expect_integer(p_results, "clamp_integer(15, 0, 10)",    clamp_integer(15, 0, 10), 10);
  test_expect_integer(p_results, "clamp_integer(-3, 0, 10)",    clamp_integer(-3, 0, 10), 0);
  test_expect_real   (p_results, "clamp_real(0.5, 0, 1)",       clamp_real(0.5, 0.0, 1.0), 0.5, 0.0);
  test_expect_integer(p_results, "max_integer(3, 9)",           max_integer(3, 9), 9);
  test_expect_integer(p_results, "min_integer(3, 9)",           min_integer(3, 9), 3);
  test_expect_real   (p_results, "lerp_real(0, 10, 0.25)",      lerp_real(0.0, 10.0, 0.25), 2.5, 0.000001);
  test_expect_real   (p_results, "wrap_angle(-0.5)",            wrap_angle(-0.5), TWO_PI - 0.5, 0.000001);
  test_expect_real   (p_results, "wrap_angle(7)",               wrap_angle(7.0), 7.0 - TWO_PI, 0.000001);
  test_expect_integer(p_results, "floor_integer(-0.5)",         floor_integer(-0.5), -1);
  test_expect_integer(p_results, "to_byte(300)",                to_byte(300.0), 255);
  test_expect_integer(p_results, "to_byte(-4)",                 to_byte(-4.0), 0);
  test_expect_text   (p_results, "two_digits(5)",               two_digits(5), "05");
  test_expect_text   (p_results, "two_digits(12)",              two_digits(12), "12");
  test_expect_integer(p_results, "text_to_seed(123)",           text_to_seed("123"), 123);
  test_expect_integer(p_results, "text_to_seed(-45)",           text_to_seed("-45"), -45);
  test_expect_integer(p_results, "text_to_seed(blank)",         text_to_seed(""), 0);
  test_expect_true   (p_results, "text_to_seed(words) is the same each time", text_to_seed("hello") == text_to_seed("hello"));
  test_expect_text   (p_results, "file_title_from_path",        file_title_from_path("C:\\worlds\\My World.txt"), "My World");
  test_expect_text   (p_results, "file_title_from_path no dot", file_title_from_path("pack/textures"), "textures");
  test_expect_true   (p_results, "text_is_safe_name(My World 2)", text_is_safe_name("My World 2"));
  test_expect_integer(p_results, "text_is_safe_name(a/b)",      text_is_safe_name("a/b"), FALSE);
  test_expect_integer(p_results, "text_is_safe_name(blank)",    text_is_safe_name(""), FALSE);

  // ---------------------------------------------------- records
  test_group(p_results, "records");
  record_clear(l_record, DATATYPE_CHECK);
  record_set_integer(l_record, ATTR_CHECK_COUNT, 7);
  record_set_real   (l_record, ATTR_CHECK_SPEED, 2.5);
  record_set_text   (l_record, ATTR_CHECK_NAME,  "Steve");
  test_expect_integer(p_results, "Integer field reads back",    record_integer(l_record, ATTR_CHECK_COUNT), 7);
  test_expect_real   (p_results, "Real field reads back",       record_real(l_record, ATTR_CHECK_SPEED), 2.5, 0.0);
  test_expect_text   (p_results, "Text field reads back",       record_text(l_record, ATTR_CHECK_NAME), "Steve");
  test_expect_integer(p_results, "missing Integer field is 0",  record_integer(l_record, ATTR_CHECK_MISSING), 0);
  test_expect_text   (p_results, "missing Text field is blank", record_text(l_record, ATTR_CHECK_MISSING), "");
  test_expect_text   (p_results, "record_datatype",             record_datatype(l_record), "check");
  test_expect_text   (p_results, "record_field_at(x, 3)",       record_field_at("x", 3), "x_3");
  record_set_integer_at(l_record, ATTR_CHECK_X, 3, 42);
  test_expect_integer(p_results, "numbered field reads back",   record_integer_at(l_record, ATTR_CHECK_X, 3), 42);
  record_clear(l_record, DATATYPE_CHECK);
  test_expect_integer(p_results, "record_clear empties it",     record_integer(l_record, ATTR_CHECK_COUNT), 0);

  // ---------------------------------------------------- random
  test_group(p_results, "random");
  random_seed(l_random, 99);
  random_seed(l_other,  99);
  for (l_i = 1; l_i <= 50; ++l_i) {
    if (random_next(l_random) != random_next(l_other)) l_same = FALSE;
  }
  test_expect_true(p_results, "the same seed gives the same numbers", l_same);
  for (l_i = 1; l_i <= 500; ++l_i) {
    l_value = random_range(l_random, 3, 7);
    if (l_value < 3 || l_value > 7) l_inside = FALSE;
  }
  test_expect_true(p_results, "random_range(3, 7) stays in 3..7 (500 draws)", l_inside);
  l_inside = TRUE;
  for (l_i = 1; l_i <= 500; ++l_i) {
    l_px = random_next(l_random);
    if (l_px < 0.0 || l_px >= 1.0) l_inside = FALSE;
  }
  test_expect_true(p_results, "random_next stays in 0..1 (500 draws)", l_inside);

  // ---------------------------------------------------- blocks and items
  test_group(p_results, "blocks");
  test_expect_text   (p_results, "item_name(stone)",            item_name(ITEM_STONE), "Stone");
  test_expect_text   (p_results, "item_name(oak door)",         item_name(ITEM_DOOR), "Oak Door");
  test_expect_text   (p_results, "item_name(nothing)",          item_name(ITEM_NONE), "");
  test_expect_integer(p_results, "item_max_stack(stone)",       item_max_stack(ITEM_STONE), 64);
  test_expect_integer(p_results, "item_max_stack(pickaxe)",     item_max_stack(ITEM_WOODEN_PICKAXE), 1);
  test_expect_integer(p_results, "item_places_block(stone)",    item_places_block(ITEM_STONE), BLOCK_STONE);
  test_expect_integer(p_results, "item_places_block(stick)",    item_places_block(ITEM_STICK), BLOCK_AIR);
  test_expect_true   (p_results, "block_is_solid(stone)",       block_is_solid(BLOCK_STONE));
  test_expect_integer(p_results, "block_is_solid(air)",         block_is_solid(BLOCK_AIR), FALSE);
  test_expect_integer(p_results, "block_is_solid(water)",       block_is_solid(BLOCK_WATER), FALSE);
  test_expect_real   (p_results, "block_face_shade(top)",       block_face_shade(DIR_PY), 1.0, 0.0);

  // ---------------------------------------------------- inventory
  test_group(p_results, "inventory");
  inventory_clear(g_inventory);
  test_expect_integer(p_results, "inventory_add(stone, 70) leaves nothing over", inventory_add(g_inventory, ITEM_STONE, 70), 0);
  test_expect_integer(p_results, "the first slot holds a full stack", slot_count(g_inventory, 1), 64);
  test_expect_integer(p_results, "the second slot holds the rest",    slot_count(g_inventory, 2), 6);
  test_expect_integer(p_results, "inventory_count_item(stone)",       inventory_count_item(g_inventory, ITEM_STONE), 70);
  inventory_remove_item(g_inventory, ITEM_STONE, 5);
  test_expect_integer(p_results, "after removing 5",                  inventory_count_item(g_inventory, ITEM_STONE), 65);
  slot_swap(g_inventory, 1, 9);
  test_expect_integer(p_results, "slot_swap moves the stack",         slot_item(g_inventory, 9), ITEM_STONE);
  test_expect_true   (p_results, "slot_is_empty after the swap",      slot_is_empty(g_inventory, 1));
  inventory_clear(g_inventory);
  test_expect_integer(p_results, "inventory_clear empties it",        inventory_count_item(g_inventory, ITEM_STONE), 0);

  // ---------------------------------------------------- crafting
  test_group(p_results, "crafting");
  grid_clear(g_grid, GRID_INVENTORY_WIDTH);
  test_expect_integer(p_results, "grid_width of the inventory grid",  grid_width(g_grid), GRID_INVENTORY_WIDTH);
  test_expect_integer(p_results, "an empty grid makes nothing",       crafting_match(g_book, g_grid), 0);
  slot_set(g_grid, 1, ITEM_OAK_LOG, 1, 0);
  test_expect_integer(p_results, "a log makes planks",                crafting_recipe_output(g_book, crafting_match(g_book, g_grid)), ITEM_PLANKS);
  grid_clear(g_grid, GRID_INVENTORY_WIDTH);

  // ---------------------------------------------------- commands
  test_group(p_results, "commands");
  test_expect_integer(p_results, "command_find_item(stone)",          command_find_item("stone"), ITEM_STONE);
  test_expect_integer(p_results, "command_find_item(minecraft:torch)", command_find_item("minecraft:torch"), ITEM_TORCH);
  test_expect_integer(p_results, "command_find_item(diamond)",        command_find_item("diamond"), ITEM_NONE);
  inventory_clear(g_inventory);
  l_reply = command_run("/give @p cobblestone 5", g_info, g_player, g_inventory);
  test_expect_integer(p_results, "/give adds the items",              inventory_count_item(g_inventory, ITEM_COBBLESTONE), 5);
  l_reply = command_run("/frobnicate", g_info, g_player, g_inventory);
  test_expect_true   (p_results, "an unknown command says so",        Find_text(l_reply, "Unknown command") == 1);
  inventory_clear(g_inventory);

  // ---------------------------------------------------- game modes
  test_group(p_results, "game modes");
  l_reply = command_run("/gamemode spectator", g_info, g_player, g_inventory);
  test_expect_integer(p_results, "/gamemode spectator",               player_game_mode(g_player), GAMEMODE_SPECTATOR);
  test_expect_true   (p_results, "spectators always fly",             player_flying(g_player));
  l_reply = command_run("/gamemode creative", g_info, g_player, g_inventory);
  test_expect_integer(p_results, "/gamemode creative",                player_game_mode(g_player), GAMEMODE_CREATIVE);
  player_set_health(g_player, PLAYER_MAX_HEALTH);
  player_damage(g_player, g_events, 5);
  test_expect_integer(p_results, "creative takes no damage",          player_health(g_player), PLAYER_MAX_HEALTH);
  l_reply = command_run("/gamemode survival", g_info, g_player, g_inventory);
  test_expect_integer(p_results, "/gamemode survival",                player_game_mode(g_player), GAMEMODE_SURVIVAL);
  test_expect_integer(p_results, "survival can not fly",              player_flying(g_player), FALSE);
  player_damage(g_player, g_events, 5);
  test_expect_integer(p_results, "survival takes damage",             player_health(g_player), PLAYER_MAX_HEALTH - 5);
  l_reply = command_run("/gamemode bogus", g_info, g_player, g_inventory);
  test_expect_true   (p_results, "an unknown game mode says so",      Find_text(l_reply, "Unknown game mode") == 1);
  test_expect_text   (p_results, "player_game_mode_name(spectator)",  player_game_mode_name(GAMEMODE_SPECTATOR), "Spectator");
  player_set_health(g_player, PLAYER_MAX_HEALTH);
  events_clear(g_events);

  // ---------------------------------------------------- creative inventory
  test_group(p_results, "creative inventory");
  ui_set_search(g_ui, "");
  test_expect_true   (p_results, "every named item is listed",        ui_creative_count(g_ui) >= 40);
  test_expect_integer(p_results, "the list starts with bedrock",      ui_creative_item(g_ui, 1), ITEM_BEDROCK);
  ui_set_search(g_ui, "IRON");
  test_expect_integer(p_results, "searching iron (any case) finds 6", ui_creative_count(g_ui), 6);
  ui_type_search(g_ui, "backspace");
  test_expect_text   (p_results, "backspace rubs out a letter",       ui_search(g_ui), "IRO");
  ui_set_search(g_ui, "zzz");
  test_expect_integer(p_results, "a search with no match lists none", ui_creative_count(g_ui), 0);
  inventory_clear(g_inventory);
  ui_set_search(g_ui, "stone");
  ui_creative_click(g_ui, g_inventory, 1, FALSE);
  test_expect_integer(p_results, "a click takes a full stack",        slot_count(g_inventory, CURSOR_SLOT), item_max_stack(slot_item(g_inventory, CURSOR_SLOT)));
  ui_set_search(g_ui, "torch");
  ui_creative_click(g_ui, g_inventory, 1, FALSE);
  test_expect_integer(p_results, "putting a stack down on the list throws it away", slot_item(g_inventory, CURSOR_SLOT), ITEM_NONE);
  ui_set_search(g_ui, "");
  inventory_clear(g_inventory);

  // ---------------------------------------------------- events
  test_group(p_results, "events");
  events_clear(g_events);
  test_expect_integer(p_results, "no events after events_clear",      events_pending(g_events), 0);
  emit_cell_event(g_events, EVT_BLOCK_PLACED, 1, 2, 3, BLOCK_STONE);
  emit_toast(g_events, "hello");
  test_expect_integer(p_results, "two events waiting",                events_pending(g_events), 2);
  next_event(g_events, g_event);
  test_expect_integer(p_results, "the first out is the first in",     event_type(g_event), EVT_BLOCK_PLACED);
  test_expect_integer(p_results, "its cell z",                        event_integer(g_event, 3), 3);
  next_event(g_events, g_event);
  test_expect_text   (p_results, "the toast text",                    event_text(g_event), "hello");
  test_expect_integer(p_results, "a local event is not remote",       event_is_remote(g_event), FALSE);
  events_clear(g_events);

  // ---------------------------------------------------- multiplayer
  test_group(p_results, "multiplayer");
  test_expect_text   (p_results, "net_clean_name(Bob Smith!)",        net_clean_name("Bob Smith!"), "Bob_Smith");
  test_expect_text   (p_results, "net_clean_name(blank)",             net_clean_name("?!"), "player");
  test_expect_text   (p_results, "net_log_name",                      net_log_name("s1", "bob_12"), "log_s1_bob_12.txt");

  // ---------------------------------------------------- world (needs the test world)
  test_group(p_results, "world");
  test_expect_integer(p_results, "world_get_block outside the world is air", world_get_block(-5, 70, 3), BLOCK_AIR);
  test_expect_integer(p_results, "world_get_block below the world is bedrock", world_get_block(10, -1, 10), BLOCK_BEDROCK);
  test_expect_integer(p_results, "the bottom layer is bedrock",       world_get_block(10, 0, 10), BLOCK_BEDROCK);
  l_x = 20;
  l_z = 20;
  l_y = world_top_solid_y(l_x, l_z);
  test_expect_true   (p_results, "world_top_solid_y finds ground",    l_y > 0 && l_y < WORLD_HEIGHT);
  test_expect_true   (p_results, "the top block is solid or water",   block_is_solid(world_get_block(l_x, l_y, l_z)) || world_get_block(l_x, l_y, l_z) == BLOCK_WATER);
  l_block = world_get_block(l_x, l_y + 3, l_z);
  world_set_block(l_x, l_y + 3, l_z, BLOCK_GLASS);
  test_expect_integer(p_results, "world_set_block then world_get_block", world_get_block(l_x, l_y + 3, l_z), BLOCK_GLASS);
  world_set_block(l_x, l_y + 3, l_z, l_block);
  test_expect_integer(p_results, "and back again",                    world_get_block(l_x, l_y + 3, l_z), l_block);
  test_expect_true   (p_results, "physics: a box in the ground collides",
                      physics_box_collides(l_x + 0.2, 1.2, l_z + 0.2, l_x + 0.8, 1.8, l_z + 0.8));
  test_expect_integer(p_results, "physics: a box high in the air does not",
                      physics_box_collides(l_x + 0.2, WORLD_HEIGHT - 2.0, l_z + 0.2, l_x + 0.8, WORLD_HEIGHT - 1.2, l_z + 0.8), FALSE);
  world_info_spawn(g_info, l_px, l_py, l_pz);
  test_expect_true   (p_results, "the spawn point is in the world",
                      l_px > 0.0 && l_px < WORLD_SIZE_X && l_pz > 0.0 && l_pz < WORLD_SIZE_Z && l_py > 0.0);
}

#endif
