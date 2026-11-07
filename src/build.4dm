#ifndef INCLUDE_BUILD_4DM
#define INCLUDE_BUILD_4DM

// Safety first: blocks every dangerous library call for all the
// source files below (see the header). Keep it the first include.
#include "../include/core/safety.h"

// Build settings

#define RELEASE
//#define DEBUG


// Build logic
#if defined(DEBUG) && defined(RELEASE)
#warning Conflicting build modes enabled <RELEASE|DEBUG>
#elif !defined(DEBUG) && !defined(RELEASE)
#warning Build mode unspecified : <RELEASE|DEBUG>
#endif

#ifdef RELEASE
#undef DEBUG
#endif

#include "../include/core/debug.h"


// Source files, one folder per part of the game (each file includes
// the headers it needs, so the order here doesn't matter). The
// headers are in the same folders under include/.

// core: helpers, records, slot lists and the event queue
#include "core/util.4dm"
#include "core/records.4dm"
#include "core/slots.4dm"
#include "core/events.4dm"

// blocks: block and item rules, textures, resource packs
#include "blocks/blocks.4dm"
#include "blocks/textures.4dm"
#include "blocks/resource_pack.4dm"

// world: the block grid and terrain, cached faces, collision
#include "world/world.4dm"
#include "world/mesh.4dm"
#include "world/physics.4dm"

// items: inventory, crafting, furnaces, chests, dropped items
#include "items/inventory.4dm"
#include "items/crafting.4dm"
#include "items/furnace.4dm"
#include "items/chest.4dm"
#include "items/drops.4dm"

// mobs: cows, pigs and zombies
#include "mobs/cows.4dm"

// player: movement and actions
#include "player/player.4dm"

// render: the 3D view, the HUD and the inventory screens (views)
#include "render/render_world.4dm"
#include "render/render_hud.4dm"
#include "render/render_ui.4dm"

// program: settings, saving, starting worlds and the frame update
#include "program/settings.4dm"
#include "program/save.4dm"
#include "program/commands.4dm"
#include "program/game.4dm"

// ui: the 12d panels (controllers) and fonts
#include "ui/font.4dm"
#include "ui/menu_panel.4dm"
#include "ui/settings_panel.4dm"
#include "ui/game_panel.4dm"


// Error for multiple inclusions of build.4dm
#else
#error Don't include build.4dm more than once
#endif
