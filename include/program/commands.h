#ifndef COMMANDS_H_INCLUDED
#define COMMANDS_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// Chat commands typed after a "/" in the chat line (T or /):
//   /time set day|noon|night|midnight|<ticks>
//   /time add <ticks>
//   /time query daytime|gametime|day
//   /gamerule doDaylightCycle [true|false]
//   /give <player> <item> [count]
//   /gamemode creative|survival
//   /help
// Times are in the block game's ticks: 24000 to a day, 0 at
// sunrise, 6000 at noon.
// ----------------------------------------------------------------

#define TICKS_PER_DAY        24000
#define GIVE_MAX_COUNT       2304   // a whole inventory of full stacks

Text    command_word         (Dynamic_Text &p_words, Integer p_position);
Text    command_item_key     (Text p_name);
Integer command_find_item    (Text p_name);
Integer command_time_value   (Text p_word, Integer &p_ticks);
Text    command_time         (Dynamic_Text &p_words, Integer p_count, Attributes &p_info);
Text    command_gamerule     (Dynamic_Text &p_words, Integer p_count, Attributes &p_info);
Text    command_give         (Dynamic_Text &p_words, Integer p_count, Attributes &p_inventory);
Text    command_gamemode     (Dynamic_Text &p_words, Attributes &p_player);
Text    command_run          (Text p_line, Attributes &p_info, Attributes &p_player, Attributes &p_inventory);

#endif
