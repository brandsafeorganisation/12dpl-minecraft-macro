#ifndef COMMANDS_4DM_INCLUDED
#define COMMANDS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/blocks/blocks.h"
#include "../../include/items/inventory.h"
#include "../../include/world/world.h"
#include "../../include/player/player.h"
#include "../../include/program/commands.h"

Text command_word(Dynamic_Text &p_words, Integer p_position)
// ----------------------------------------------------------------
// Word number position of a split command line ("" past the end)
// ----------------------------------------------------------------
{
  Text l_word = "";

  Get_item(p_words, p_position, l_word);
  return l_word;
}

Text command_item_key(Text p_name)
// ----------------------------------------------------------------
// The name an item is typed as: lower case with "_" for spaces
// ("Oak Planks" is oak_planks), without a "minecraft:" in front
// ----------------------------------------------------------------
{
  Text    l_lower = Text_lower(p_name);
  Text    l_key   = "";
  Text    l_char  = "";
  Integer l_at    = 0;

  if (Text_length(l_lower) > 10) {
    if (Get_subtext(l_lower, 1, 10) == "minecraft:") l_lower = Get_subtext(l_lower, 11, Text_length(l_lower));
  }
  for (l_at = 1; l_at <= Text_length(l_lower); ++l_at) {
    l_char = Get_subtext(l_lower, l_at, l_at);
    if (l_char == " ") l_char = "_";
    l_key = l_key + l_char;
  }
  return l_key;
}

Integer command_find_item(Text p_name)
// ----------------------------------------------------------------
// The item a typed name means (its display name as an item key, or
// one of the block game's names for it), ITEM_NONE if none
// ----------------------------------------------------------------
{
  Text    l_key  = command_item_key(p_name);
  Integer l_item = 0;

  if (l_key == "beef"    ) return ITEM_RAW_BEEF;
  if (l_key == "porkchop") return ITEM_RAW_PORKCHOP;
  if (l_key == "red_bed" ) return ITEM_BED;
  if (l_key == "planks"  ) return ITEM_PLANKS;
  for (l_item = 1; l_item <= MAX_ITEM_ID; ++l_item) {
    if (item_name(l_item) == "") continue;
    if (command_item_key(item_name(l_item)) == l_key) return l_item;
  }
  return ITEM_NONE;
}

Integer command_time_value(Text p_word, Integer &p_ticks)
// ----------------------------------------------------------------
// A time of day typed as a name (day, noon, night, midnight,
// sunrise, sunset) or a number of ticks. Returns FALSE if it is
// neither.
// ----------------------------------------------------------------
{
  Text l_word = Text_lower(p_word);

  p_ticks = 0;
  if (l_word == "day"     ) { p_ticks = 1000;  return TRUE; }
  if (l_word == "noon"    ) { p_ticks = 6000;  return TRUE; }
  if (l_word == "sunset"  ) { p_ticks = 12000; return TRUE; }
  if (l_word == "night"   ) { p_ticks = 13000; return TRUE; }
  if (l_word == "midnight") { p_ticks = 18000; return TRUE; }
  if (l_word == "sunrise" ) { p_ticks = 23000; return TRUE; }
  if (l_word == "") return FALSE;
  if (Find_text("-0123456789", Get_subtext(l_word, 1, 1)) < 1) return FALSE;
  if (From_text(l_word, p_ticks) != 0) return FALSE;
  return TRUE;
}

Text command_time(Dynamic_Text &p_words, Integer p_count, Attributes &p_info)
// ----------------------------------------------------------------
// /time set <time>, /time add <ticks>, /time query <what>
// ----------------------------------------------------------------
{
  Text    l_action = Text_lower(command_word(p_words, 2));
  Text    l_what   = Text_lower(command_word(p_words, 3));
  Integer l_ticks  = 0;
  Integer l_now    = floor_integer(world_time_of_day(p_info) * TICKS_PER_DAY);
  Real    l_time   = 0.0;

  if (l_action == "set" || l_action == "add") {
    if (!command_time_value(command_word(p_words, 3), l_ticks)) return "Usage: /time " + l_action + " day|noon|night|midnight|<ticks>";
    if (l_action == "add" && Find_text("-0123456789", Get_subtext(l_what, 1, 1)) < 1) return "Usage: /time add <ticks>";
    l_time = l_ticks / (1.0 * TICKS_PER_DAY);
    if (l_action == "add") l_time = world_time_of_day(p_info) + l_time;
    world_set_time_of_day(p_info, l_time - Floor(l_time));
    return "Set the time to " + To_text(floor_integer(world_time_of_day(p_info) * TICKS_PER_DAY)) + " (" + world_clock_text(world_time_of_day(p_info)) + ")";
  }
  if (l_action == "query") {
    if (l_what == "day") return "The day is " + To_text(record_integer(p_info, ATTR_WORLD_DAYS));
    if (l_what == "gametime") return "The game time is " + To_text(record_integer(p_info, ATTR_WORLD_DAYS) * TICKS_PER_DAY + l_now);
    return "The time is " + To_text(l_now) + " (" + world_clock_text(world_time_of_day(p_info)) + ")";
  }
  return "Usage: /time set|add|query ...";
}

Text command_gamerule(Dynamic_Text &p_words, Integer p_count, Attributes &p_info)
// ----------------------------------------------------------------
// /gamerule doDaylightCycle [true|false] (the only rule there is):
// without a value it says what the rule is set to
// ----------------------------------------------------------------
{
  Text l_rule  = command_word(p_words, 2);
  Text l_value = Text_lower(command_word(p_words, 3));

  if (Text_lower(l_rule) != "dodaylightcycle") {
    if (l_rule == "") return "Usage: /gamerule doDaylightCycle [true|false]";
    return "Unknown game rule: " + l_rule + " (only doDaylightCycle is known)";
  }
  if (l_value == "") {
    if (world_daylight_cycle(p_info)) return "doDaylightCycle is currently set to: true";
    return "doDaylightCycle is currently set to: false";
  }
  if (l_value == "true") {
    world_set_daylight_cycle(p_info, TRUE);
    return "Game rule doDaylightCycle is now set to: true";
  }
  if (l_value == "false") {
    world_set_daylight_cycle(p_info, FALSE);
    return "Game rule doDaylightCycle is now set to: false";
  }
  return "doDaylightCycle takes true or false, not " + command_word(p_words, 3);
}

Text command_give(Dynamic_Text &p_words, Integer p_count, Attributes &p_inventory)
// ----------------------------------------------------------------
// /give <player> <item> [count]: there is only one player, so any
// name (or @p, @s, @a) means you
// ----------------------------------------------------------------
{
  Text    l_target = command_word(p_words, 2);
  Text    l_name   = command_word(p_words, 3);
  Integer l_item   = command_find_item(l_name);
  Integer l_amount = 1;
  Integer l_left   = 0;

  if (l_target == "" || l_name == "") return "Usage: /give <player> <item> [count]";
  if (l_item == ITEM_NONE) return "Unknown item: " + l_name;
  if (p_count >= 4) {
    if (From_text(command_word(p_words, 4), l_amount) != 0) return "The count must be a number, not " + command_word(p_words, 4);
  }
  if (l_amount < 1) return "The count must be at least 1";
  if (l_amount > GIVE_MAX_COUNT) l_amount = GIVE_MAX_COUNT;

  l_left = inventory_add(p_inventory, l_item, l_amount);
  if (l_left >= l_amount) return "No room in your inventory for " + item_name(l_item);
  if (l_left > 0) return "Gave " + To_text(l_amount - l_left) + " " + item_name(l_item) + " to " + l_target + " (" + To_text(l_left) + " didn't fit)";
  return "Gave " + To_text(l_amount) + " " + item_name(l_item) + " to " + l_target;
}

Text command_gamemode(Dynamic_Text &p_words, Attributes &p_player)
// ----------------------------------------------------------------
// /gamemode creative|survival (also c, s, 1, 0): creative has no
// health, isn't attacked and flies with a double tap of Space
// ----------------------------------------------------------------
{
  Text l_mode = Text_lower(command_word(p_words, 2));

  if (l_mode == "creative" || l_mode == "c" || l_mode == "1") {
    player_set_creative(p_player, TRUE);
    return "Set own game mode to Creative (double tap Space to fly)";
  }
  if (l_mode == "survival" || l_mode == "s" || l_mode == "0") {
    player_set_creative(p_player, FALSE);
    return "Set own game mode to Survival";
  }
  if (l_mode == "") {
    if (player_creative(p_player)) return "Your game mode is Creative";
    return "Your game mode is Survival";
  }
  return "Unknown game mode: " + command_word(p_words, 2) + " (creative or survival)";
}

Text command_run(Text p_line, Attributes &p_info, Attributes &p_player, Attributes &p_inventory)
// ----------------------------------------------------------------
// Carry out a chat command (p_line starts with "/") and return what
// to show in the chat
// ----------------------------------------------------------------
{
  Dynamic_Text l_words;
  Integer      l_count = 0;
  Text         l_name  = "";

  l_count = From_text(Get_subtext(p_line, 2, Text_length(p_line)), l_words);
  if (l_count < 1) return "Type a command after the /, for example /help";
  l_name = Text_lower(command_word(l_words, 1));

  if (l_name == "time"    ) return command_time    (l_words, l_count, p_info);
  if (l_name == "gamerule") return command_gamerule(l_words, l_count, p_info);
  if (l_name == "give"    ) return command_give    (l_words, l_count, p_inventory);
  if (l_name == "gamemode") return command_gamemode(l_words, p_player);
  if (l_name == "help"    ) return "Commands: /gamemode creative|survival, /time set|add|query, /gamerule doDaylightCycle true|false, /give <player> <item> [count]";
  return "Unknown command: /" + command_word(l_words, 1) + " (try /help)";
}

#endif
