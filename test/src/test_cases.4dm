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
#include "../../include/program/save.h"
#include "../../include/player/player.h"
#include "../../include/program/commands.h"
#include "../../include/program/game.h"
#include "../../include/render/ui.h"
#include "../../include/net/net.h"
#include "../../include/net/lan.h"
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
  Attributes l_menu;
  Attributes l_set;
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
  Text       l_state  = "";
  Text       l_detail = "";
  Text       l_dir    = "";
  Text       l_line   = "";
  Integer    l_port   = 0;
  File       l_lan_file;
  Real       l_x0     = 0.0;
  Real       l_y0     = 0.0;
  Real       l_x1     = 0.0;
  Real       l_y1     = 0.0;
  Integer    l_tex    = 0;
  Integer    l_w      = 0;
  Integer    l_h      = 0;
  Integer    l_over_x = 0;
  Integer    l_over_y = 0;
  Integer    l_fx     = 0;
  Integer    l_fy     = 0;
  Integer    l_fz     = 0;
  Integer    l_j      = 0;
  Text       l_bs     = " ";
  Text       l_ctrl_bs = " ";
  Text       l_ctrl_w  = " ";
  Integer    l_drop    = 0;

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

  // ---------------------------------------------------- typed keys
  test_group(p_results, "typed keys");
  Set_char(l_bs, 1, KEY_CODE_BACKSPACE);
  Set_char(l_ctrl_bs, 1, KEY_CODE_DELETE_WORD);
  test_expect_text   (p_results, "12d's Backspace character is named",   key_name(l_bs), "backspace");
  test_expect_text   (p_results, "Ctrl+Backspace is named",               key_name(l_ctrl_bs), "backspace_word");
  test_expect_text   (p_results, "a letter's name is lower case",         key_name("W"), "w");
  test_expect_text   (p_results, "Backspace rubs out a character",        text_after_key("Hello", l_bs, 48), "Hell");
  test_expect_text   (p_results, "the name works as well",                text_after_key("Hello", "backspace", 48), "Hell");
  test_expect_text   (p_results, "Ctrl+Backspace rubs out the last word", text_after_key("New World 2", l_ctrl_bs, 48), "New World ");
  test_expect_text   (p_results, "and the spaces after it",               text_after_key("New World  ", l_ctrl_bs, 48), "New ");
  test_expect_text   (p_results, "a single word goes",                    text_after_key("Hello", l_ctrl_bs, 48), "");
  test_expect_text   (p_results, "a capital is typed as it is",           text_after_key("a", "B", 48), "aB");
  test_expect_text   (p_results, "nothing past the longest",              text_after_key("abc", "d", 3), "abc");
  test_expect_text   (p_results, "Backspace on nothing stays nothing",    text_after_key("", l_bs, 48), "");

  // ---------------------------------------------------- key binds
  test_group(p_results, "key binds");
  Set_char(l_ctrl_w, 1, 23);
  test_expect_text   (p_results, "Ctrl+W's key is w",                     key_base(l_ctrl_w), "w");
  test_expect_text   (p_results, "Ctrl+W was pressed with Ctrl",          key_modifier(l_ctrl_w), KEY_CONTROL);
  test_expect_text   (p_results, "a capital W is w with Shift",           key_modifier("W"), KEY_SHIFT);
  test_expect_text   (p_results, "Backspace isn't Ctrl+H",                key_base(l_bs), "backspace");
  test_expect_text   (p_results, "a plain key has no modifier",           key_modifier("w"), "");
  test_expect_text   (p_results, "Space is written Space",                key_label(" "), "Space");
  test_expect_text   (p_results, "Shift is written Left Shift",           key_label(KEY_SHIFT), "Left Shift");
  test_expect_text   (p_results, "a letter is written as a capital",      key_label("q"), "Q");
  test_expect_text   (p_results, "no key is Not Bound",                   key_label(""), "Not Bound");
  settings_defaults(g_settings);
  test_expect_text   (p_results, "Q drops by default",                    settings_bind(g_settings, BIND_DROP), "q");
  test_expect_true   (p_results, "C does nothing by default",             !settings_bind_pressed(g_settings, BIND_SNEAK, "c", ""));
  test_expect_true   (p_results, "Shift + W sneaks",                      settings_bind_pressed(g_settings, BIND_SNEAK, "w", KEY_SHIFT));
  test_expect_true   (p_results, "Shift + W walks forward too",           settings_bind_pressed(g_settings, BIND_FORWARD, "w", KEY_SHIFT));
  test_expect_true   (p_results, "Ctrl + W sprints",                      settings_bind_pressed(g_settings, BIND_SPRINT, "w", KEY_CONTROL));
  test_expect_true   (p_results, "the defaults are unchanged",            !settings_binds_changed(g_settings));
  settings_set_bind(g_settings, BIND_JUMP, "w");
  test_expect_true   (p_results, "a shared key clashes",                  settings_bind_clashes(g_settings, BIND_FORWARD));
  test_expect_true   (p_results, "a changed key is noticed",              settings_binds_changed(g_settings));
  settings_reset_binds(g_settings);
  test_expect_text   (p_results, "Reset Keys puts Space back",            settings_bind(g_settings, BIND_JUMP), " ");
  test_expect_integer(p_results, "the list starts with a heading",        menu_key_row_action(1), -BIND_GROUP_MOVEMENT);
  test_expect_integer(p_results, "then Jump",                             menu_key_row_action(2), BIND_JUMP);
  test_expect_integer(p_results, "Gameplay's heading after Auto-Walk",    menu_key_row_action(BIND_AUTO_WALK + 2), -BIND_GROUP_GAMEPLAY);
  test_expect_integer(p_results, "the last row is the last action",       menu_key_row_action(menu_key_rows()), BIND_ACTIONS);
  test_expect_text   (p_results, "keys are saved by number",              settings_bind_field(3), "key_3");

  // ---------------------------------------------------- armour, the offhand and spawn eggs
  test_group(p_results, "armour, offhand and spawn eggs");
  inventory_clear(g_inventory);
  test_expect_integer(p_results, "a chestplate is worn on the chest",  item_armour_place(ITEM_IRON_CHESTPLATE), ARMOUR_CHEST);
  test_expect_integer(p_results, "armour doesn't stack",               item_max_stack(ITEM_IRON_BOOTS), 1);
  test_expect_true   (p_results, "only a helmet fits the head slot",   !inventory_fits_slot(ITEM_IRON_BOOTS, inventory_armour_slot(ARMOUR_HEAD)));
  test_expect_true   (p_results, "anything fits the offhand",          inventory_fits_slot(ITEM_STONE, OFFHAND_SLOT));
  test_expect_integer(p_results, "a hit with nothing worn",            inventory_armour_damage(g_inventory, 3), 3);
  slot_set(g_inventory, 5, ITEM_IRON_HELMET, 1, 0);
  test_expect_true   (p_results, "inventory_equip puts a helmet on",   inventory_equip(g_inventory, 5));
  test_expect_integer(p_results, "the helmet is in the head slot",     slot_item(g_inventory, inventory_armour_slot(ARMOUR_HEAD)), ITEM_IRON_HELMET);
  slot_set(g_inventory, inventory_armour_slot(ARMOUR_CHEST), ITEM_IRON_CHESTPLATE, 1, 0);
  slot_set(g_inventory, inventory_armour_slot(ARMOUR_LEGS),  ITEM_IRON_LEGGINGS,   1, 0);
  slot_set(g_inventory, inventory_armour_slot(ARMOUR_FEET),  ITEM_IRON_BOOTS,      1, 0);
  test_expect_integer(p_results, "a full iron set gives 15 points",    inventory_armour_points(g_inventory), 15);
  test_expect_integer(p_results, "a zombie's 3 becomes 1 in full iron", inventory_armour_damage(g_inventory, 3), 1);
  test_expect_integer(p_results, "a hit of 10 becomes 4",              inventory_armour_damage(g_inventory, 10), 4);
  inventory_wear_armour(g_inventory, g_events);
  test_expect_integer(p_results, "a hit wears the boots",              slot_damage(g_inventory, inventory_armour_slot(ARMOUR_FEET)), 1);
  slot_set(g_inventory, inventory_armour_slot(ARMOUR_HEAD), ITEM_IRON_HELMET, 1, item_max_uses(ITEM_IRON_HELMET) - 1);
  test_expect_integer(p_results, "a worn out helmet breaks",           inventory_wear_armour(g_inventory, g_events), 1);
  test_expect_true   (p_results, "and the head slot is empty",         slot_is_empty(g_inventory, inventory_armour_slot(ARMOUR_HEAD)));
  slot_set(g_inventory, 2, ITEM_TORCH, 8, 0);
  inventory_swap_hands(g_inventory, 2);
  test_expect_integer(p_results, "swapping hands moves the torch",     slot_item(g_inventory, OFFHAND_SLOT), ITEM_TORCH);
  test_expect_true   (p_results, "and empties the hotbar slot",        slot_is_empty(g_inventory, 2));
  inventory_clear(g_inventory);
  test_expect_true   (p_results, "inventory_clear takes the armour off", slot_is_empty(g_inventory, inventory_armour_slot(ARMOUR_CHEST)));
  test_expect_integer(p_results, "a pig egg makes pigs",               item_spawn_egg_mob(ITEM_PIG_SPAWN_EGG), MOB_PIG);
  test_expect_integer(p_results, "a stone is no spawn egg",            item_spawn_egg_mob(ITEM_STONE), NOT_A_SPAWN_EGG);
  test_expect_text   (p_results, "the zombie egg's name",              item_name(ITEM_ZOMBIE_SPAWN_EGG), "Zombie Spawn Egg");
  test_expect_integer(p_results, "ui slot 152 is the chest slot",      ui_inventory_slot(UI_SLOT_ARMOUR + ARMOUR_CHEST), inventory_armour_slot(ARMOUR_CHEST));

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
  test_expect_integer(p_results, "command_find_item(emerald)",        command_find_item("emerald"), ITEM_NONE);
  inventory_clear(g_inventory);
  l_reply = command_run("/give @p cobblestone 5", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_integer(p_results, "/give adds the items",              inventory_count_item(g_inventory, ITEM_COBBLESTONE), 5);
  l_reply = command_run("/frobnicate", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_true   (p_results, "an unknown command says so",        Find_text(l_reply, "Unknown command") == 1);
  inventory_clear(g_inventory);
  // cheats: allowed alone; in a LAN world only if the host allowed them
  test_expect_true   (p_results, "playing alone allows cheats",       net_cheats(g_net));
  l_reply = command_run("/w bob hi", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_true   (p_results, "a whisper alone has nobody to go to", Find_text(l_reply, "nobody") > 0);
  test_expect_true   (p_results, "a LAN world has a session file",    Find_text(net_session_path("mp", "77"), "lan_77.txt") > 0);
  record_set_integer(g_net, ATTR_NET_MODE, NET_GUEST);
  net_set_session(g_net, 1, "w", GAMEMODE_SURVIVAL, FALSE);
  l_reply = command_run("/time set day", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_true   (p_results, "cheats off refuses /time",          Find_text(l_reply, "Cheats aren't allowed") == 1);
  l_reply = command_run("/give @p stone 1", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_integer(p_results, "cheats off refuses /give",          inventory_count_item(g_inventory, ITEM_STONE), 0);
  net_set_session(g_net, 1, "w", GAMEMODE_SURVIVAL, TRUE);
  l_reply = command_run("/give @p stone 1", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_integer(p_results, "cheats on allows /give",            inventory_count_item(g_inventory, ITEM_STONE), 1);
  net_clear(g_net, g_peers, g_net_inbox);
  inventory_clear(g_inventory);

  // ---------------------------------------------------- game modes
  test_group(p_results, "game modes");
  l_reply = command_run("/gamemode spectator", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_integer(p_results, "/gamemode spectator",               player_game_mode(g_player), GAMEMODE_SPECTATOR);
  test_expect_true   (p_results, "spectators always fly",             player_flying(g_player));
  l_reply = command_run("/gamemode creative", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_integer(p_results, "/gamemode creative",                player_game_mode(g_player), GAMEMODE_CREATIVE);
  player_set_health(g_player, PLAYER_MAX_HEALTH);
  player_damage(g_player, g_events, 5);
  test_expect_integer(p_results, "creative takes no damage",          player_health(g_player), PLAYER_MAX_HEALTH);
  l_reply = command_run("/gamemode survival", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_integer(p_results, "/gamemode survival",                player_game_mode(g_player), GAMEMODE_SURVIVAL);
  test_expect_integer(p_results, "survival can not fly",              player_flying(g_player), FALSE);
  player_damage(g_player, g_events, 5);
  test_expect_integer(p_results, "survival takes damage",             player_health(g_player), PLAYER_MAX_HEALTH - 5);
  l_reply = command_run("/gamemode bogus", g_info, g_player, g_inventory, g_net, g_peers);
  test_expect_true   (p_results, "an unknown game mode says so",      Find_text(l_reply, "Unknown game mode") == 1);
  test_expect_text   (p_results, "player_game_mode_name(spectator)",  player_game_mode_name(GAMEMODE_SPECTATOR), "Spectator");
  player_set_health(g_player, PLAYER_MAX_HEALTH);
  events_clear(g_events);

  // ---------------------------------------------------- camera, pause menu, skins
  test_group(p_results, "camera and menu");
  record_set_integer(g_player, ATTR_PLAYER_CAMERA, CAMERA_FIRST);
  player_next_camera(g_player);
  test_expect_integer(p_results, "V once: the camera behind you",     player_camera(g_player), CAMERA_BEHIND);
  player_next_camera(g_player);
  test_expect_integer(p_results, "V twice: in front, looking back",   player_camera(g_player), CAMERA_FRONT);
  player_next_camera(g_player);
  test_expect_integer(p_results, "V three times: your eyes again",    player_camera(g_player), CAMERA_FIRST);
  hud_pause_button_rect(860.0, 520.0, PAUSE_BUTTON_BACK, l_x0, l_y0, l_x1, l_y1);
  test_expect_integer(p_results, "the middle of Back to Game",        hud_pause_button_at(860.0, 520.0, (l_x0 + l_x1) / 2.0, (l_y0 + l_y1) / 2.0), PAUSE_BUTTON_BACK);
  hud_pause_button_rect(860.0, 520.0, PAUSE_BUTTON_CONTROLS, l_x0, l_y0, l_x1, l_y1);
  test_expect_integer(p_results, "the middle of Controls",            hud_pause_button_at(860.0, 520.0, (l_x0 + l_x1) / 2.0, (l_y0 + l_y1) / 2.0), PAUSE_BUTTON_CONTROLS);
  test_expect_integer(p_results, "between the half buttons: none",    hud_pause_button_at(860.0, 520.0, 430.0, (l_y0 + l_y1) / 2.0), 0);
  test_expect_integer(p_results, "a corner of the view: no button",   hud_pause_button_at(860.0, 520.0, 5.0, 500.0), 0);
  l_i = 1;
  while (pack_map_skin_part(l_i, l_tex, l_x, l_y, l_w, l_h, l_over_x, l_over_y)) ++l_i;
  test_expect_integer(p_results, "a skin dresses 12 model textures",  l_i - 1, 12);
  pack_map_skin_part(1, l_tex, l_x, l_y, l_w, l_h, l_over_x, l_over_y);
  test_expect_integer(p_results, "the face is at 8, 8 of the skin",   l_x * 100 + l_y, 808);
  test_expect_integer(p_results, "its second layer at 40, 8",         l_over_x * 100 + l_over_y, 4008);
  test_expect_integer(p_results, "no skin file: nothing replaced",    pack_apply_skin("zz_no_such_skin.png", l_reply, l_i), 0);

  // ---------------------------------------------------- menus and the world list
  test_group(p_results, "menus and the world list");
  menu_clear(l_menu);
  menu_begin(l_menu);
  menu_add(l_menu, MENU_BUTTON, W_PLAY, 10.0, 10.0, 110.0, 40.0, "Play", TRUE);
  menu_add(l_menu, MENU_BUTTON, W_DELETE, 120.0, 10.0, 220.0, 40.0, "Delete", FALSE);
  menu_add(l_menu, MENU_FIELD, W_SEARCH, 10.0, 50.0, 220.0, 80.0, "", TRUE);
  test_expect_integer(p_results, "a click on a button finds its id",   menu_id_at(l_menu, 60.0, 25.0), W_PLAY);
  test_expect_integer(p_results, "a button that is off can't be hit",  menu_id_at(l_menu, 170.0, 25.0), 0);
  test_expect_integer(p_results, "a click beside them finds nothing",  menu_id_at(l_menu, 300.0, 25.0), 0);
  menu_set_focus(l_menu, W_SEARCH);
  menu_type_key(l_menu, "a", "A");
  menu_type_key(l_menu, "b", "b");
  menu_type_key(l_menu, "backspace", "backspace");
  menu_type_key(l_menu, "c", "c");
  test_expect_text   (p_results, "typing keeps capitals, backspace rubs out", menu_field_text(l_menu, W_SEARCH), "Ac");
  menu_set_focus(l_menu, 0);
  test_expect_integer(p_results, "with no field chosen typing is ignored", menu_type_key(l_menu, "x", "x"), FALSE);
  test_expect_text   (p_results, "long text is cut short with ...",   menu_fit_text("A very long world name indeed", 10.0, 60.0), "A very lon...");
  test_expect_text   (p_results, "short text is kept",                menu_fit_text("Short", 10.0, 60.0), "Short");
  menu_set_scroll(l_menu, 9, 5, 3);
  test_expect_integer(p_results, "a list scrolls no further than its end", menu_scroll(l_menu), 2);
  settings_defaults(l_set);
  settings_slider(l_set, W_FOV, 1.0);
  test_expect_integer(p_results, "the FOV slider at its right end",   settings_fov_degrees(l_set), FOV_MAX);
  settings_slider(l_set, W_RENDER, 0.0);
  test_expect_integer(p_results, "the render slider at its left end", settings_render_distance(l_set), RENDER_DISTANCE_MIN);
  settings_slider(l_set, W_MOUSE, 0.5);
  test_expect_integer(p_results, "the mouse slider halfway",          record_integer(l_set, ATTR_SET_SENSITIVITY), 6);
  test_expect_text   (p_results, "a colour as hex",                   save_hex_colour(16711680 + 2 * 256 + 171), "ff02ab");
  test_expect_integer(p_results, "hex back to a colour",              save_hex_value("ff02ab", 1, 6), 16711680 + 2 * 256 + 171);
  test_expect_text   (p_results, "12d's clock as a date",             save_date_text("Sun Nov 15 14:03:22 2026"), "15 Nov 2026, 14:03");
  test_expect_text   (p_results, "the last part of a path",           save_file_name("resourcepacks\\faithful.zip"), "faithful.zip");
  test_expect_text   (p_results, "a world name is kept when free",    menu_free_world_name("zz_no_such_world"), "zz_no_such_world");

  // ---------------------------------------------------- creative inventory
  test_group(p_results, "creative inventory");
  ui_set_search(g_ui, "");
  test_expect_true   (p_results, "every named item is listed",        ui_creative_count(g_ui) >= 40);
  test_expect_integer(p_results, "the list starts with bedrock",      ui_creative_item(g_ui, 1), ITEM_BEDROCK);
  ui_set_search(g_ui, "IRON");
  test_expect_integer(p_results, "searching iron (any case) finds 10 (with the armour)", ui_creative_count(g_ui), 10);
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
  emit_throw_event(g_events, ITEM_STONE, 1, 0, 1.0, 2.0, 3.0, -1.0, 0.5);
  next_event(g_events, g_event);
  event_throw_direction(g_event, l_x0, l_y0);
  test_expect_true   (p_results, "a throw keeps its yaw (round)",     Absolute(l_x0 - (2.0 * PI - 1.0)) < 0.002);
  test_expect_true   (p_results, "and its pitch",                     Absolute(l_y0 - 0.5) < 0.002);
  inventory_clear(g_inventory);
  player_set_selected(g_player, 1);
  slot_set(g_inventory, 1, ITEM_STONE, 5, 0);
  player_set_game_mode(g_player, GAMEMODE_SURVIVAL);
  test_expect_true   (p_results, "Q drops the held item",             player_drop_selected(g_player, g_inventory, g_events, FALSE));
  test_expect_integer(p_results, "one of them",                       slot_count(g_inventory, 1), 4);
  test_expect_true   (p_results, "Ctrl+Q drops the stack",            player_drop_selected(g_player, g_inventory, g_events, TRUE));
  test_expect_true   (p_results, "and the slot is empty",             slot_is_empty(g_inventory, 1));
  test_expect_true   (p_results, "nothing to drop with an empty hand", !player_drop_selected(g_player, g_inventory, g_events, FALSE));
  next_event(g_events, g_event);
  test_expect_integer(p_results, "a drop is thrown",                  event_type(g_event), EVT_THROW_DROP);
  drops_clear(g_drops);
  l_drop = drops_throw(g_drops, ITEM_STONE, 1, 0, 0.5, 70.0, 0.5, 0.0, 0.0);
  test_expect_true   (p_results, "a thrown drop flies forward",       record_real_at(g_drops, ATTR_VX, l_drop) > 1.0);
  test_expect_true   (p_results, "and can't be picked up at once",    drop_age(g_drops, l_drop) < 0.0);
  drops_clear(g_drops);
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

  // ---------------------------------------------------- the Nether
  test_group(p_results, "the Nether");
  test_expect_true   (p_results, "lava is a liquid",                  block_is_liquid(BLOCK_LAVA));
  test_expect_integer(p_results, "lava doesn't stop you",             block_is_solid(BLOCK_LAVA), FALSE);
  test_expect_true   (p_results, "but hides what is behind it",       block_hides_faces(BLOCK_LAVA));
  test_expect_integer(p_results, "obsidian is placed by its item",    item_places_block(ITEM_OBSIDIAN), BLOCK_OBSIDIAN);
  test_expect_integer(p_results, "obsidian needs a diamond pickaxe",  block_drop_item(BLOCK_OBSIDIAN, ITEM_IRON_PICKAXE), ITEM_NONE);
  test_expect_integer(p_results, "and drops itself with one",         block_drop_item(BLOCK_OBSIDIAN, ITEM_DIAMOND_PICKAXE), ITEM_OBSIDIAN);
  test_expect_integer(p_results, "quartz ore drops nether quartz",    block_drop_item(BLOCK_QUARTZ_ORE, ITEM_WOODEN_PICKAXE), ITEM_NETHER_QUARTZ);
  test_expect_integer(p_results, "glowstone gives light",             block_light_emission(BLOCK_GLOWSTONE), GLOWSTONE_LIGHT);
  test_expect_integer(p_results, "a portal can't be broken by hand",  block_hand_hits(BLOCK_PORTAL), 0);
  // an obsidian frame high in the air, 2 wide and 3 high inside,
  // along x
  l_x = 30;
  l_y = WORLD_HEIGHT - 10;
  l_z = 30;
  for (l_i = -1; l_i <= 4; ++l_i) {
    for (l_j = -1; l_j <= 5; ++l_j) world_set_block(l_x + l_i, l_y + l_j, l_z, BLOCK_AIR);
  }
  for (l_i = 0; l_i <= 3; ++l_i) {
    for (l_j = 0; l_j <= 4; ++l_j) {
      if (l_i == 0 || l_i == 3 || l_j == 0 || l_j == 4) world_set_block(l_x + l_i, l_y + l_j, l_z, BLOCK_OBSIDIAN);
    }
  }
  test_expect_true   (p_results, "a frame is found from inside it",   world_portal_frame(l_x + 2, l_y + 3, l_z, TRUE, l_fx, l_fy, l_fz, l_w, l_h));
  test_expect_integer(p_results, "its inside is 2 wide",              l_w, 2);
  test_expect_integer(p_results, "and 3 high",                        l_h, 3);
  test_expect_integer(p_results, "from its lowest cell",              l_fy, l_y + 1);
  test_expect_integer(p_results, "not along z",                       world_portal_frame(l_x + 2, l_y + 3, l_z, FALSE, l_fx, l_fy, l_fz, l_w, l_h), FALSE);
  world_set_block(l_x + 3, l_y + 2, l_z, BLOCK_AIR);
  test_expect_integer(p_results, "a gap in the frame: no portal",     world_portal_frame(l_x + 1, l_y + 1, l_z, TRUE, l_fx, l_fy, l_fz, l_w, l_h), FALSE);
  world_set_block(l_x + 3, l_y + 2, l_z, BLOCK_OBSIDIAN);
  test_expect_true   (p_results, "flint and steel lights it",         world_light_portal(g_events, l_x + 1, l_y + 1, l_z));
  test_expect_integer(p_results, "with portal inside",                world_get_block(l_x + 2, l_y + 3, l_z), BLOCK_PORTAL);
  test_expect_true   (p_results, "and the portal is found",           world_find_portal(l_x, l_y, l_z, 3, l_fx, l_fy, l_fz));
  test_expect_integer(p_results, "at its bottom",                     l_fy, l_y + 1);
  for (l_i = 0; l_i <= 3; ++l_i) {
    for (l_j = 0; l_j <= 4; ++l_j) world_set_block(l_x + l_i, l_y + l_j, l_z, BLOCK_AIR);
  }
  events_clear(g_events);

  test_group(p_results, "records kept for the other dimension");
  record_clear(l_record, DATATYPE_RANDOM);
  record_set_integer_at(l_record, ATTR_X, 3, 30);
  record_set_real_at   (l_record, ATTR_Y, 3, 1.5);
  record_set_integer_at(l_record, ATTR_X, 13, 130);
  record_clear(l_other, DATATYPE_AWAY);
  record_copy_prefixed(l_record, l_other, AWAY_COWS);
  test_expect_integer(p_results, "a field is kept under its prefix",  record_integer(l_other, "cows__x_3"), 30);
  record_copy_unprefixed(l_other, l_set, AWAY_COWS);
  test_expect_integer(p_results, "and comes back without it",         record_integer_at(l_set, ATTR_X, 3), 30);
  test_expect_real   (p_results, "with its type",                     record_real_at(l_set, ATTR_Y, 3), 1.5, 0.0);
  test_expect_text   (p_results, "and the datatype",                  record_datatype(l_set), DATATYPE_RANDOM);
  record_clear(l_other, DATATYPE_AWAY);
  test_expect_integer(p_results, "an entity's fields are copied",     record_copy_entity(l_record, l_other, 3), 2);
  test_expect_integer(p_results, "not another's ending the same",     record_integer_at(l_other, ATTR_X, 13), 0);
  record_copy(l_record, l_other);
  test_expect_integer(p_results, "record_copy copies every field",     record_integer_at(l_other, ATTR_X, 13), 130);
  test_expect_text   (p_results, "a world is a folder",               save_file_name(save_region_path("W", DIM_NETHER)), "region.cubeworld");
  test_expect_true   (p_results, "with the Nether in DIM-1",          Find_text(save_region_path("W", DIM_NETHER), "\\DIM-1\\") > 0);

  test_group(p_results, "diamonds, jukebox and fire");
  test_expect_real   (p_results, "angle_difference the short way",    angle_difference(0.1, TWO_PI - 0.1), -0.2, 0.0001);
  test_expect_real   (p_results, "and the other way",                 angle_difference(TWO_PI - 0.1, 0.1), 0.2, 0.0001);
  test_expect_integer(p_results, "diamond ore needs an iron pickaxe", block_drop_item(BLOCK_DIAMOND_ORE, ITEM_STONE_PICKAXE), ITEM_NONE);
  test_expect_integer(p_results, "and drops a diamond",               block_drop_item(BLOCK_DIAMOND_ORE, ITEM_IRON_PICKAXE), ITEM_DIAMOND);
  test_expect_integer(p_results, "a diamond pickaxe is diamond tier", item_tool_tier(ITEM_DIAMOND_PICKAXE), TIER_DIAMOND);
  test_expect_true   (p_results, "and digs faster than iron",         block_hits_with(BLOCK_STONE, ITEM_DIAMOND_PICKAXE) < block_hits_with(BLOCK_STONE, ITEM_IRON_PICKAXE) || block_hits_with(BLOCK_STONE, ITEM_DIAMOND_PICKAXE) == 1);
  test_expect_integer(p_results, "diamond armour goes on the chest",  item_armour_place(ITEM_DIAMOND_CHESTPLATE), ARMOUR_CHEST);
  test_expect_integer(p_results, "and is worn in diamond",            item_worn_texture(ITEM_DIAMOND_HELMET, WORN_HELMET_FRONT), TEX_WORN_DIAMOND + WORN_HELMET_FRONT);
  test_expect_integer(p_results, "iron in iron",                      item_worn_texture(ITEM_IRON_BOOTS, WORN_BOOT_SIDE), TEX_WORN_IRON + WORN_BOOT_SIDE);
  test_expect_integer(p_results, "a jukebox is placed by its item",   item_places_block(ITEM_JUKEBOX), BLOCK_JUKEBOX);
  test_expect_integer(p_results, "fire has no item",                  block_drop_item(BLOCK_FIRE, ITEM_NONE), ITEM_NONE);
  test_expect_true   (p_results, "fire gives light",                  block_light_emission(BLOCK_FIRE) > 0);
  test_expect_true   (p_results, "planks burn",                       block_is_flammable(BLOCK_PLANKS));
  test_expect_integer(p_results, "stone doesn't",                     block_is_flammable(BLOCK_STONE), FALSE);
  // a stone slab high in the air to light fires on
  l_x = 40;
  l_y = WORLD_HEIGHT - 12;
  l_z = 40;
  for (l_i = -1; l_i <= 1; ++l_i) {
    for (l_j = 0; l_j <= 2; ++l_j) world_set_block(l_x + l_i, l_y + l_j, l_z, BLOCK_AIR);
  }
  world_set_block(l_x, l_y, l_z, BLOCK_STONE);
  test_expect_integer(p_results, "no fire in the air",                world_light_fire(g_events, l_x + 1, l_y + 2, l_z), FALSE);
  test_expect_true   (p_results, "fire is lit on a block",            world_light_fire(g_events, l_x, l_y + 1, l_z));
  test_expect_integer(p_results, "and burns there",                   world_get_block(l_x, l_y + 1, l_z), BLOCK_FIRE);
  world_set_block(l_x, l_y, l_z, BLOCK_NETHERRACK);
  random_seed(l_random, 77);
  for (l_i = 1; l_i <= 30; ++l_i) world_burn_cell(g_events, l_random, l_x, l_y + 1, l_z);
  test_expect_integer(p_results, "fire on netherrack never goes out", world_get_block(l_x, l_y + 1, l_z), BLOCK_FIRE);
  world_set_block(l_x, l_y, l_z, BLOCK_STONE);
  for (l_i = 1; l_i <= 60; ++l_i) world_burn_cell(g_events, l_random, l_x, l_y + 1, l_z);
  test_expect_integer(p_results, "but on stone it does",              world_get_block(l_x, l_y + 1, l_z), BLOCK_AIR);
  world_set_block(l_x - 1, l_y + 1, l_z, BLOCK_WATER);
  test_expect_integer(p_results, "no fire next to water",             world_light_fire(g_events, l_x, l_y + 1, l_z), FALSE);
  world_set_block(l_x - 1, l_y + 1, l_z, BLOCK_AIR);
  world_set_block(l_x, l_y, l_z, BLOCK_AIR);
  events_clear(g_events);

  // ---------------------------------------------------- the LAN helper
  test_group(p_results, "LAN helper");
  l_line = safe_helper_command_line("host", "h_77", "77", "77", "bob_1234", "", 24461, "cubeland_lan.ps1");
  test_expect_text   (p_results, "the host's command line",           l_line,
                      "powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -File cubeland_lan.ps1 -Mode host -Dir h_77 -Run 77 -Port 24461 -Session 77 -Id bob_1234");
  l_line = safe_helper_command_line("join", "j_5", "5", "77", "bob_1234", "192.168.1.23", 24461, "cubeland_lan.ps1");
  test_expect_true   (p_results, "a join names the host's address",   Find_text(l_line, "-Address 192.168.1.23") > 0);
  test_expect_text   (p_results, "no command for a name with ;",      safe_helper_command_line("host", "h_77", "77", "77", "bob;calc", "", 24461, "cubeland_lan.ps1"), "");
  test_expect_text   (p_results, "no command for a folder with ..",   safe_helper_command_line("scan", "..", "77", "", "", "", 24461, "cubeland_lan.ps1"), "");
  test_expect_text   (p_results, "no command for a name with a space", safe_helper_command_line("host", "h_77", "77", "77", "bob 2", "", 24461, "cubeland_lan.ps1"), "");
  test_expect_text   (p_results, "no command for a bad address",      safe_helper_command_line("join", "j_5", "5", "77", "bob", "10.0.0.300", 24461, "cubeland_lan.ps1"), "");
  test_expect_text   (p_results, "no command for port 80",            safe_helper_command_line("join", "j_5", "5", "77", "bob", "10.0.0.3", 80, "cubeland_lan.ps1"), "");
  test_expect_text   (p_results, "no command for another mode",       safe_helper_command_line("run", "j_5", "5", "77", "bob", "", 24461, "cubeland_lan.ps1"), "");
  test_expect_text   (p_results, "no command for another script",     safe_helper_command_line("scan", "s_5", "5", "", "", "", 24461, "evil.ps1"), "");
  test_expect_true   (p_results, "PowerShell under Windows' folder",  Find_text(safe_helper_program("C:\\WINDOWS"), "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe") > 0);
  test_expect_text   (p_results, "no program for an odd Windows folder", safe_helper_program("C:\\Program Files"), "");
  test_expect_true   (p_results, "the helper folder is a start folder", safe_helper_start_folder("D:\\12d\\Work\\cubeland_worlds\\lan\\") == SAFE_YES);
  test_expect_true   (p_results, "another folder isn't",              safe_helper_start_folder("D:\\12d\\Work") == SAFE_NO);
  test_expect_true   (p_results, "the test build never starts it",    safe_run_helper("C:\\WINDOWS", "scan", "s_1", "1", "", "", "", 24461) == SAFE_OPEN_REFUSED);
  test_expect_text   (p_results, "lan_word makes a plain word",       lan_word("bob-smith!"), "bob_smith_");
  test_expect_true   (p_results, "a refused join says firewall",      Find_text(lan_status_problem("failed", "the host did not answer"), "firewall") > 0);
  test_expect_text   (p_results, "hosting is no problem",             lan_status_problem("hosting", "24461"), "");
  test_expect_text   (p_results, "a closed world is told",            lan_status_problem("closed", "the host closed the world"), "The host closed the world");
  l_dir = lan_folder("t_test");
  safe_folder_create(LAN_FOLDER);
  safe_folder_create(l_dir);
  if (safe_file_open(l_dir + "\\status_1.txt", "w", l_lan_file) == 0) {
    File_write_line(l_lan_file, "ready 12 ~");
    File_close(l_lan_file);
  }
  test_expect_integer(p_results, "a status is read",                  lan_read_status(l_dir, "1", l_state, l_detail), SUCCESS);
  test_expect_text   (p_results, "its state",                         l_state, "ready");
  test_expect_text   (p_results, "and the rest",                      l_detail, "12");
  if (safe_file_open(l_dir + "\\status_1.txt", "w", l_lan_file) == 0) {
    File_write_line(l_lan_file, "hosting 244");
    File_close(l_lan_file);
  }
  test_expect_integer(p_results, "a half written status isn't",       lan_read_status(l_dir, "1", l_state, l_detail), FAILURE);
  if (safe_file_open(l_dir + "\\lan_9.txt", "w", l_lan_file) == 0) {
    File_write_line(l_lan_file, "session 9");
    File_write_line(l_lan_file, "address 10.0.0.2");
    File_write_line(l_lan_file, "port 24462");
    File_write_line(l_lan_file, "world My World");
    File_close(l_lan_file);
  }
  test_expect_integer(p_results, "a found world has an address",     net_read_session_address(l_dir + "\\lan_9.txt", l_state, l_port), SUCCESS);
  test_expect_text   (p_results, "which is the host's",               l_state, "10.0.0.2");
  test_expect_integer(p_results, "and its port",                      l_port, 24462);

  // ---------------------------------------------------- chests and beds
  test_group(p_results, "chests and beds");
  l_block = block_chest(FACING_NX, CHEST_RIGHT);
  test_expect_true   (p_results, "a chest block is a chest",           block_is_chest(l_block));
  test_expect_integer(p_results, "it keeps its facing",                block_chest_facing(l_block), FACING_NX);
  test_expect_integer(p_results, "and which half it is",               block_chest_type(l_block), CHEST_RIGHT);
  test_expect_integer(p_results, "an old chest faces +z",              block_chest_facing(BLOCK_CHEST), FACING_PZ);
  test_expect_integer(p_results, "every chest drops a chest",          block_drop_item(l_block, ITEM_NONE), ITEM_CHEST);
  test_expect_integer(p_results, "the chest item places a chest",      block_is_chest(item_places_block(ITEM_CHEST)), TRUE);
  test_expect_integer(p_results, "a single chest has no partner",      block_partner(block_chest(FACING_PX, CHEST_SINGLE), 5, 5, 5, l_fx, l_fy, l_fz), FALSE);
  // facing -x, the viewer's left is -z: the right half's partner is there
  block_partner(l_block, 5, 5, 5, l_fx, l_fy, l_fz);
  test_expect_integer(p_results, "the right half's partner is left",   l_fx * 100 + l_fz, 504);
  block_partner(block_chest(FACING_NX, CHEST_LEFT), 5, 5, 4, l_fx, l_fy, l_fz);
  test_expect_integer(p_results, "and the left half's is right",       l_fx * 100 + l_fz, 505);
  block_box(block_chest(FACING_PX, CHEST_SINGLE), l_x0, l_y0, l_px, l_x1, l_y1, l_pz);
  test_expect_real   (p_results, "a chest is 14/16 wide",              l_x1 - l_x0, 0.875, 0.0001);
  test_expect_real   (p_results, "and 14/16 tall",                     l_y1 - l_y0, 0.875, 0.0001);
  block_box(l_block, l_x0, l_y0, l_px, l_x1, l_y1, l_pz);
  test_expect_real   (p_results, "half a double chest meets the other", l_px, 0.0, 0.0001);
  test_expect_true   (p_results, "chests hide nothing beside them",    !block_hides_faces(l_block));
  test_expect_integer(p_results, "chest pictures are not sprites",     texture_is_sprite(chest_texture(CHEST_LEFT) + CHEST_LATCH), FALSE);
  test_expect_integer(p_results, "nor the bed's legs",                 texture_is_sprite(TEX_BED_LEG), FALSE);
  test_expect_integer(p_results, "a chest put down faces the player",  player_facing_toward(10.5, 3.0, 10, 8), FACING_NZ);
  // two chests side by side join, and breaking one leaves the other single
  l_x = 40;
  l_y = WORLD_HEIGHT - 12;
  l_z = 40;
  world_set_block(l_x, l_y - 1, l_z, BLOCK_STONE);
  world_set_block(l_x, l_y - 1, l_z + 1, BLOCK_STONE);
  world_set_block(l_x, l_y, l_z, block_chest(FACING_NX, CHEST_SINGLE));
  world_set_block(l_x, l_y, l_z + 1, block_chest(FACING_NX, CHEST_SINGLE));
  chest_join(g_events, l_x, l_y, l_z + 1, block_chest(FACING_NX, CHEST_SINGLE));
  test_expect_integer(p_results, "a chest joins the one beside it",    world_get_block(l_x, l_y, l_z + 1), block_chest(FACING_NX, CHEST_RIGHT));
  test_expect_integer(p_results, "which becomes the left half",        world_get_block(l_x, l_y, l_z), block_chest(FACING_NX, CHEST_LEFT));
  world_set_block(l_x, l_y, l_z + 1, BLOCK_AIR);
  chest_split(g_events, l_x, l_y, l_z + 1, block_chest(FACING_NX, CHEST_RIGHT));
  test_expect_integer(p_results, "breaking a half leaves a single",    world_get_block(l_x, l_y, l_z), block_chest(FACING_NX, CHEST_SINGLE));
  world_set_block(l_x, l_y, l_z, BLOCK_AIR);
  world_set_block(l_x, l_y - 1, l_z, BLOCK_AIR);
  world_set_block(l_x, l_y - 1, l_z + 1, BLOCK_AIR);
  events_clear(g_events);
  test_expect_integer(p_results, "the right half has its own rows",     ui_slot_rect(SCREEN_LARGE_CHEST, 2, UI_SLOT_CHEST2 + 27, 860.0, 520.0, l_x0, l_y0, l_x1), TRUE);
  test_expect_integer(p_results, "no right half on a single chest",    ui_slot_rect(SCREEN_CHEST, 2, UI_SLOT_CHEST2 + 1, 860.0, 520.0, l_x0, l_y0, l_x1), FALSE);
}

#endif
