#ifndef BLOCKS_H_INCLUDED
#define BLOCKS_H_INCLUDED

// ----------------------------------------------------------------
// Block, item and face direction identifiers, and the rules that
// go with them (hardness, tools, drops, food, fuel, smelting)
// Items 1..63 are the blocks of the same number, 64+ are items that
// cannot be placed. Every function here is honest: it only looks
// at its arguments (and the finished texture numbers).
// ----------------------------------------------------------------

#define BLOCK_AIR             0
#define BLOCK_BEDROCK         1
#define BLOCK_STONE           2
#define BLOCK_COBBLESTONE     3
#define BLOCK_DIRT            4
#define BLOCK_GRASS           5
#define BLOCK_OAK_LOG         6
#define BLOCK_LEAVES          7
#define BLOCK_WATER           8
#define BLOCK_PLANKS          9
#define BLOCK_CRAFTING_TABLE  10
#define BLOCK_FURNACE_PX      11   // furnace with its door facing +x
#define BLOCK_FURNACE_NX      12   //                              -x
#define BLOCK_FURNACE_PZ      13   //                              +z
#define BLOCK_FURNACE_NZ      14   //                              -z
#define BLOCK_SAND            15
#define BLOCK_SANDSTONE       16
#define BLOCK_CACTUS          17
#define BLOCK_COAL_ORE        18
#define BLOCK_GRAVEL          19
#define BLOCK_TALL_GRASS      20   // plants: drawn as two pictures crossed
#define BLOCK_POPPY           21   // in an X, nothing collides
#define BLOCK_DANDELION       22   // with them and placing a block
#define BLOCK_DEAD_BUSH       23   // replaces them
#define BLOCK_IRON_ORE        24
#define BLOCK_TORCH           25   // drawn like a plant; gives light
#define BLOCK_GLASS           26   // solid, but you see through it
#define BLOCK_BED             27   // right click at night to sleep
#define BLOCK_CHEST           28   // right click to store things
#define BLOCK_LIT_FURNACE_PX  29   // a burning furnace (gives light): the
#define BLOCK_LIT_FURNACE_NX  30   // furnace's block is swapped for one
#define BLOCK_LIT_FURNACE_PZ  31   // of these while it burns; there is no
#define BLOCK_LIT_FURNACE_NZ  32   // item for them
#define BLOCK_DOOR_FIRST      33   // doors: 33 + facing * 4 + open * 2 + top
#define BLOCK_DOOR_LAST       48   // (facing 0..3 is FACING_*)
#define BLOCK_BED_FIRST       49   // the two halves of a bed: 49 + facing * 2
#define BLOCK_BED_LAST        56   // + head (facing points from foot to head);
                                   // BLOCK_BED is an older one block bed
#define MAX_BLOCK_ID          28   // highest block that is also an item
#define TORCH_LIGHT           14
#define FACING_PX             0    // directions a door or bed can face
#define FACING_NX             1
#define FACING_PZ             2
#define FACING_NZ             3
#define DOOR_THICKNESS        0.1875
#define BED_HEIGHT            0.5625
#define DESTROY_STAGES        10   // crack stages shown while a block is broken
#define FURNACE_LIGHT         13

#define ITEM_NONE             0
#define ITEM_BEDROCK          1
#define ITEM_STONE            2
#define ITEM_COBBLESTONE      3
#define ITEM_DIRT             4
#define ITEM_GRASS            5
#define ITEM_OAK_LOG          6
#define ITEM_LEAVES           7
#define ITEM_PLANKS           9
#define ITEM_CRAFTING_TABLE   10
#define ITEM_FURNACE          11
#define ITEM_SAND             15
#define ITEM_SANDSTONE        16
#define ITEM_CACTUS           17
#define ITEM_COAL_ORE         18
#define ITEM_GRAVEL           19
#define ITEM_POPPY            21
#define ITEM_DANDELION        22
#define ITEM_IRON_ORE         24
#define ITEM_TORCH            25
#define ITEM_GLASS            26
#define ITEM_BED              27
#define ITEM_CHEST            28
#define FIRST_PURE_ITEM       64   // items from here on are not blocks
#define ITEM_STICK            64
#define ITEM_RAW_BEEF         65
#define ITEM_COOKED_BEEF      66
#define ITEM_COAL             67
#define ITEM_WOODEN_PICKAXE   68
#define ITEM_STONE_PICKAXE    69
#define ITEM_WOODEN_AXE       70
#define ITEM_STONE_AXE        71
#define ITEM_WOODEN_SHOVEL    72
#define ITEM_STONE_SHOVEL     73
#define ITEM_WOODEN_SWORD     74
#define ITEM_STONE_SWORD      75
#define ITEM_IRON_INGOT       76
#define ITEM_IRON_PICKAXE     77
#define ITEM_IRON_AXE         78
#define ITEM_IRON_SHOVEL      79
#define ITEM_IRON_SWORD       80
#define ITEM_ROTTEN_FLESH     81
#define ITEM_RAW_PORKCHOP     82
#define ITEM_COOKED_PORKCHOP  83
#define ITEM_DOOR             84   // places the two halves of a door
#define MAX_ITEM_ID           84

// Tool kinds and tiers
#define TOOL_NONE             0
#define TOOL_PICKAXE          1
#define TOOL_AXE              2
#define TOOL_SHOVEL           3
#define TOOL_SWORD            4
#define TIER_NONE             0
#define TIER_WOOD             1
#define TIER_STONE            2
#define TIER_IRON             3

// Face directions (outward normal of a block face)
#define DIR_PX                1
#define DIR_NX                2
#define DIR_PY                3
#define DIR_NY                4
#define DIR_PZ                5
#define DIR_NZ                6
#define DIR_PLANT             7    // a plant picture (not a cube face)
#define NUM_FACE_GROUPS       7
#define DIR_WET_FLAG          8    // added to a face that touches water

Integer block_is_solid       (Integer p_block);
Integer block_is_plant       (Integer p_block);
Integer block_box            (Integer p_block, Real &p_min_x, Real &p_min_y, Real &p_min_z, Real &p_max_x, Real &p_max_y, Real &p_max_z);
Integer block_is_door        (Integer p_block);
Integer block_is_bed         (Integer p_block);
Integer block_is_shaped      (Integer p_block);
Integer block_door           (Integer p_facing, Integer p_open, Integer p_top);
Integer block_door_facing    (Integer p_block);
Integer block_door_open      (Integer p_block);
Integer block_door_top       (Integer p_block);
Integer block_bed            (Integer p_facing, Integer p_head);
Integer block_bed_facing     (Integer p_block);
Integer block_bed_head       (Integer p_block);
void    block_facing_step    (Integer p_facing, Integer &p_dx, Integer &p_dz);
Integer block_partner        (Integer p_block, Integer p_x, Integer p_y, Integer p_z, Integer &p_px, Integer &p_py, Integer &p_pz);
Integer block_hides_faces    (Integer p_block);
Integer block_light_emission (Integer p_block);
Integer block_is_see_through (Integer p_block);
Integer block_is_furnace     (Integer p_block);
Integer block_furnace_front  (Integer p_block);
Integer block_furnace_is_lit (Integer p_block);
Integer block_furnace_lit_as (Integer p_block, Integer p_lit);
Integer block_falls          (Integer p_block);
Integer block_hand_hits      (Integer p_block);
Integer block_tool_kind      (Integer p_block);
Integer block_needs_tool     (Integer p_block);
Integer block_tier_needed    (Integer p_block);
Integer block_hits_with      (Integer p_block, Integer p_tool_item);
Integer block_drop_item      (Integer p_block, Integer p_tool_item);
Integer block_pick_item      (Integer p_block);
Integer block_face_texture   (Integer p_block, Integer p_direction);
Real    block_face_shade     (Integer p_direction);
Text    item_name            (Integer p_item);
Integer item_places_block    (Integer p_item);
Integer item_is_block        (Integer p_item);
Integer item_max_stack       (Integer p_item);
Integer item_tool_kind       (Integer p_item);
Integer item_tool_tier       (Integer p_item);
Integer item_max_uses        (Integer p_item);
Integer item_attack_damage   (Integer p_item);
Integer item_food_value      (Integer p_item);
Integer item_fuel_seconds    (Integer p_item);
Integer item_smelt_result    (Integer p_item);
Integer item_top_texture     (Integer p_item);
Integer item_side_texture    (Integer p_item);
Integer item_sprite_texture  (Integer p_item);
Integer block_plant_texture  (Integer p_block);

#endif
