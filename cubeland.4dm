//------------------------------------------------------------
// Cubeland
//
// A first person block building sandbox drawn in a 12d Draw_Box.
//
// Generate seeded worlds of hills, forests and oceans (water fills
// everything below y 62), walk and jump around them, break blocks
// and pick up what they drop, build with what you carry, punch
// trees for wood, craft planks, sticks, a crafting table and a
// furnace, and cook beef from the cows that wander the grassland.
//
//   Blocks      16 x 16 pixel textures, generated when the macro
//               starts or read from a resource pack (.zip or
//               folder); dirt, grass, stone, cobblestone, sand,
//               sandstone, gravel, coal and iron ore, oak logs,
//               leaves, planks, water, glass, bedrock, crafting
//               table, furnace, chest, bed and torches (whose light
//               spreads), plus grass and flowers
//   Day/night   a 20 minute day; zombies come out at night
//   Player      1.8 blocks tall, 5 blocks of reach, gravity and
//               collision, swimming, flying, fall damage and a
//               health bar
//   Inventory   9 slot hotbar and 27 slot (9 x 3) inventory, 2 x 2
//               crafting in the inventory and 3 x 3 at a table,
//               wooden, stone and iron tools
//   Worlds      saved in the "cubeland_worlds" folder of the 12d
//               working folder, made from a seed you can type in
//
// Controls are listed on the help screen (H) inside the game.
//
// Structure
//   cubeland.4dm      this file: main()
//   src/build.4dm     includes include/core/safety.h (which blocks
//                     every dangerous 12d call) and then every
//                     source file
//   src/<part>/       the code by part of the game: core, blocks,
//                     world, items, mobs, player and program (the
//                     model), render (the views) and ui (the
//                     controllers: the 12d panels)
//   include/<part>/   each module's constants, global data and
//                     prototypes, in the same folders
// Modules don't report to each other directly: they emit game
// events (include/core/events.h) and game_dispatch_events() passes each
// event to every module's *_on_event() handler.
// Game state lives in records (12d Attributes used like structs)
// that are passed to every function that uses them; see
// CLAUDE.md.
//------------------------------------------------------------

#ifdef CUBELAND_BASE_FILE_4DM_INCLUDED
#error Do not include the base file!
#endif
#define CUBELAND_BASE_FILE_4DM_INCLUDED

#include "src/build.4dm"

void main()
// --------------------------------------------------------
// Entry point: world menu, then the game, until Quit
// --------------------------------------------------------
{
  Integer l_running   = TRUE;
  Integer l_result    = 0;
  Integer l_time_seed = 0;

  Get_time(l_time_seed);
  game_init_once(g_game, g_book, g_settings, g_random, l_time_seed);

  while (l_running) {
    l_result = menu_panel_run(g_game, g_random, g_settings);

    if (l_result == MENU_RESULT_QUIT || l_result == SHUTDOWN_CODE) {
      l_running = FALSE;
    } else {
      l_result = game_panel_run(record_text(g_game, ATTR_MENU_WORLD), l_result, record_integer(g_game, ATTR_MENU_SEED));
      if (l_result == SHUTDOWN_CODE) l_running = FALSE;
    }
  }
}
