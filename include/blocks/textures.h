#ifndef TEXTURES_H_INCLUDED
#define TEXTURES_H_INCLUDED

// ----------------------------------------------------------------
// 16 x 16 pixel textures, generated when the macro starts (and
// replaced by a resource pack's images if one is chosen, see
// resource_pack.h)
// Each texture is a grid of palette indices. For drawing, the most
// common index is the base colour and every other colour is merged
// into rectangles, so a face is one base polygon plus a few rects.
// Sprites (plants and item pictures) use index 0 for see-through
// pixels: they have no base polygon, only rectangles.
//
// Table functions: everything here reads or writes the g_tex_*
// and g_rect_* tables. They are filled once by textures_init and
// are read-only afterwards.
// ----------------------------------------------------------------

#define TEX_SIZE               16
#define TEX_TRANSPARENT        0      // palette index of see-through pixels
#define TEX_BEDROCK            1
#define TEX_STONE              2
#define TEX_COBBLESTONE        3
#define TEX_DIRT               4
#define TEX_GRASS_TOP          5
#define TEX_GRASS_SIDE         6
#define TEX_LOG_SIDE           7
#define TEX_LOG_TOP            8
#define TEX_LEAVES             9
#define TEX_WATER              10
#define TEX_PLANKS             11
#define TEX_TABLE_TOP          12
#define TEX_TABLE_SIDE         13
#define TEX_FURNACE_FRONT      14
#define TEX_FURNACE_FRONT_LIT  15
#define TEX_FURNACE_SIDE       16
#define TEX_FURNACE_TOP        17
#define TEX_SAND               18
#define TEX_COW_HIDE           19
#define TEX_COW_FACE           20
#define TEX_SANDSTONE_TOP      21
#define TEX_SANDSTONE_SIDE     22
#define TEX_CACTUS_TOP         23
#define TEX_CACTUS_SIDE        24
#define TEX_COAL_ORE           25
#define TEX_GRAVEL             26
#define TEX_IRON_ORE           27
#define TEX_BED_TOP            28
#define TEX_BED_SIDE           29
#define TEX_ZOMBIE_SKIN        30
#define TEX_ZOMBIE_FACE        31
#define TEX_ZOMBIE_SHIRT       32
#define TEX_ZOMBIE_PANTS       33
#define TEX_CHEST_TOP          34
#define TEX_CHEST_SIDE         35
#define TEX_COW_HEAD_SIDE      36     // mob parts (see render_cow, render_zombie)
#define TEX_COW_HEAD_TOP       37
#define TEX_COW_BODY_TOP       38
#define TEX_COW_BODY_END       39
#define TEX_COW_LEG            40
#define TEX_COW_HORN           41
#define TEX_ZOMBIE_HEAD_SIDE   42
#define TEX_ZOMBIE_HEAD_TOP    43
#define TEX_ZOMBIE_ARM         44
#define TEX_ZOMBIE_SHIRT_SIDE  45
#define TEX_PIG_FACE           46     // pig parts (see render_pig)
#define TEX_PIG_HEAD_SIDE      47
#define TEX_PIG_BODY_SIDE      48
#define TEX_PIG_BODY_TOP       49
#define TEX_PIG_BODY_END       50
#define TEX_PIG_LEG            51
#define TEX_PIG_SNOUT          52
#define TEX_PLANT_GRASS        53     // plants, glass and items are sprites:
#define TEX_PLANT_POPPY        54     // they have see-through pixels and
#define TEX_PLANT_DANDELION    55     // no base colour
#define TEX_PLANT_DEAD_BUSH    56
#define TEX_TORCH              57
#define TEX_GLASS              58
#define TEX_ITEM_STICK         59
#define TEX_ITEM_RAW_BEEF      60
#define TEX_ITEM_COOKED_BEEF   61
#define TEX_ITEM_COAL          62
#define TEX_ITEM_IRON_INGOT    63
#define TEX_ITEM_ROTTEN_FLESH  64
#define TEX_ITEM_WOODEN_PICKAXE 65
#define TEX_ITEM_STONE_PICKAXE 66
#define TEX_ITEM_IRON_PICKAXE  67
#define TEX_ITEM_WOODEN_AXE    68
#define TEX_ITEM_STONE_AXE     69
#define TEX_ITEM_IRON_AXE      70
#define TEX_ITEM_WOODEN_SHOVEL 71
#define TEX_ITEM_STONE_SHOVEL  72
#define TEX_ITEM_IRON_SHOVEL   73
#define TEX_ITEM_WOODEN_SWORD  74
#define TEX_ITEM_STONE_SWORD   75
#define TEX_ITEM_IRON_SWORD    76
#define TEX_ITEM_RAW_PORKCHOP  77
#define TEX_ITEM_COOKED_PORKCHOP 78
#define TEX_DESTROY_FIRST      79     // 10 crack stages drawn over a block being broken
#define TEX_DESTROY_LAST       88
#define TEX_HEART_FULL         89     // health bar hearts
#define TEX_HEART_HALF         90
#define TEX_HEART_CONTAINER    91
#define TEX_DOOR_TOP           92     // the two halves of a door, and its item
#define TEX_DOOR_BOTTOM        93
#define TEX_ITEM_DOOR          94
#define TEX_BED_FOOT_TOP       95     // top of a bed's foot half (TEX_BED_TOP is the head)
#define TEX_DOOR_EDGE_TOP      96     // the thin edges of a door, made from the door's outer columns
#define TEX_DOOR_EDGE_BOTTOM   97
#define NUM_TEXTURES           97
#define TEX_FIRST_SPRITE       TEX_PLANT_GRASS   // every texture from here on is a sprite

#define TEXTURE_PIXELS         24832  // NUM_TEXTURES * 256
#define PALETTE_SIZE           8      // colours per texture
#define TEXTURE_PALETTES       776    // NUM_TEXTURES * PALETTE_SIZE
#define TEXTURE_QUADRANTS      388    // NUM_TEXTURES * 4
#define MAX_TEXTURE_RECTS      12000  // resource pack images can need more than the built-in ones

/*Global variables*/ {
  Integer g_tex_pixel     [TEXTURE_PIXELS];
  Integer g_tex_pal_r     [TEXTURE_PALETTES];
  Integer g_tex_pal_g     [TEXTURE_PALETTES];
  Integer g_tex_pal_b     [TEXTURE_PALETTES];
  Integer g_tex_base      [NUM_TEXTURES];   // 0 for sprites (no base polygon)
  Integer g_tex_is_sprite [NUM_TEXTURES];
  Real    g_tex_avg_r     [NUM_TEXTURES];
  Real    g_tex_avg_g     [NUM_TEXTURES];
  Real    g_tex_avg_b     [NUM_TEXTURES];
  Real    g_tex_quad_r    [TEXTURE_QUADRANTS];   // 2 x 2 average colours for icons
  Real    g_tex_quad_g    [TEXTURE_QUADRANTS];
  Real    g_tex_quad_b    [TEXTURE_QUADRANTS];
  Integer g_tex_rect_first[NUM_TEXTURES];
  Integer g_tex_rect_count[NUM_TEXTURES];

  Integer g_rect_total = 0;
  Real    g_rect_u0 [MAX_TEXTURE_RECTS];
  Real    g_rect_u1 [MAX_TEXTURE_RECTS];
  Real    g_rect_v0 [MAX_TEXTURE_RECTS];
  Real    g_rect_v1 [MAX_TEXTURE_RECTS];
  Integer g_rect_pal[MAX_TEXTURE_RECTS];
  Integer g_rect_area[MAX_TEXTURE_RECTS];   // in pixels, small ones are skipped at medium detail

  // Scratch space used while generating
  Integer g_tex_mark [256];
  Integer g_tex_count[PALETTE_SIZE];
  Real    g_tex_sum_r[4];
  Real    g_tex_sum_g[4];
  Real    g_tex_sum_b[4];
  Integer g_tex_sum_n[4];
  Real    g_cobble_u [9];
  Real    g_cobble_v [9];
}

void    textures_init          ();
void    textures_generate      ();
void    textures_finish_all    ();
Integer texture_is_sprite      (Integer p_tex);
void    texture_set_palette    (Integer p_tex, Integer p_index, Integer p_red, Integer p_green, Integer p_blue);
void    texture_set            (Integer p_tex, Integer p_u, Integer p_v, Integer p_index);
Integer texture_get            (Integer p_tex, Integer p_u, Integer p_v);
void    texture_fill           (Integer p_tex, Integer p_index);
void    texture_fill_rect      (Integer p_tex, Integer p_u0, Integer p_v0, Integer p_u1, Integer p_v1, Integer p_index);
Real    texture_random         (Integer p_tex, Integer p_u, Integer p_v, Integer p_salt);
Real    texture_noise          (Integer p_tex, Integer p_u, Integer p_v, Integer p_cell, Integer p_salt);
void    texture_copy           (Integer p_from_tex, Integer p_to_tex);
void    texture_row            (Integer p_tex, Integer p_v, Text p_pixels);
void    texture_finish         (Integer p_tex);
Integer texture_palette_index  (Integer p_tex, Integer p_index);

#endif
