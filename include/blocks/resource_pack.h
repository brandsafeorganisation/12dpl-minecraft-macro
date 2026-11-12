#ifndef RESOURCE_PACK_H_INCLUDED
#define RESOURCE_PACK_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// Resource packs: replace the built-in textures with the PNG images
// of a block game resource pack, read straight from its .zip file or
// from a folder it was unzipped into.
//
// 12dPL has no image or zip library, so this module reads the files
// byte by byte and decodes them itself:
//   zip       the central directory at the end of the file says
//             where each image is stored
//   deflate   zip entries and PNG image data are compressed with
//             deflate (RFC 1951); pack_inflate() undoes it
//   PNG       chunks, palettes and transparency, the five row
//             filters; 8 bit images plus 1, 2 and 4 bit palette and
//             grey images. Interlaced PNGs aren't supported.
// Each image is sampled down to 16 x 16 pixels and reduced to the
// PALETTE_SIZE colours the textures use (most packs at 16 x 16 use
// fewer than that anyway).
//
// Images are looked up under assets/minecraft/textures/ (block/...,
// item/..., entity/...). Mob skins (entity/cow/cow.png,
// entity/pig/pig.png, entity/zombie/zombie.png) hold every face of
// the model in one image: each of our mob part textures is sampled
// from its own rectangle of the skin (pack_map_part), given in
// pixels of a 64 pixel wide skin so larger skins work too. Grey
// images that the game colours by biome (grass, leaves, water) are
// tinted with the pack's colormap/grass.png and colormap/foliage.png,
// or fixed colours if those are missing.
//
// Table functions: everything here reads or writes the g_pack_* and
// g_inflate_* byte buffers, which belong to this module, and writes
// textures through texture_set() and texture_set_palette().
// ----------------------------------------------------------------

#define PACK_IN_SIZE          131072   // compressed bytes (a zip entry or a PNG's image data)
#define PACK_FILE_SIZE        131072   // one PNG file
#define PACK_OUT_SIZE         270336   // decompressed bytes (a 256 x 256 RGBA image fits)
#define PACK_HUFFMAN_SYMBOLS  320

#define PACK_TEXTURE_PREFIX   "assets/minecraft/textures/"
#define PACK_FOLDER_PREFIX    "assets\\minecraft\\textures\\"
#define PACK_ZIP_EXTENSION    ".zip"

#define PACK_TINT_NONE        0
#define PACK_TINT_GRASS       1
#define PACK_TINT_FOLIAGE     2
#define PACK_TINT_WATER       3

// Fixed tints when the pack has no colormap
#define PACK_GRASS_R          145
#define PACK_GRASS_G          189
#define PACK_GRASS_B          89
#define PACK_FOLIAGE_R        119
#define PACK_FOLIAGE_G        171
#define PACK_FOLIAGE_B        47
#define PACK_WATER_R          63
#define PACK_WATER_G          118
#define PACK_WATER_B          228

// Where a temperate meadow sits on a 256 x 256 colormap
#define PACK_COLORMAP_X       51
#define PACK_COLORMAP_Y       173

// A skin rectangle can be turned a quarter (or more) clockwise, for
// parts whose picture lies on its side in the skin
#define PACK_SKIN_WIDTH       64
#define PACK_TURN_NONE        0
#define PACK_TURN_RIGHT       1
#define PACK_TURN_HALF        2
#define PACK_TURN_LEFT        3

// Zip record signatures (little-endian 4 byte words)
#define ZIP_END_SIGNATURE     101010256   // 0x06054b50
#define ZIP_ENTRY_SIGNATURE   33639248    // 0x02014b50
#define ZIP_LOCAL_SIGNATURE   67324752    // 0x04034b50
#define ZIP_STORED            0
#define ZIP_DEFLATED          8

// Byte buffers that a read or inflate can write to
#define PACK_BUFFER_IN        1
#define PACK_BUFFER_FILE      2

// Records
#define DATATYPE_PACK_INDEX   ("pack_index")
#define DATATYPE_PACK_WANTED  ("pack_wanted")
#define ATTR_PACK_OFFSET      ("_offset")      // suffixes added to an image key
#define ATTR_PACK_SIZE        ("_size")
#define ATTR_PACK_METHOD      ("_method")

/*Global variables*/ {
  // Byte buffers (values 0..255)
  Integer g_pack_in  [PACK_IN_SIZE];
  Integer g_pack_file[PACK_FILE_SIZE];
  Integer g_pack_out [PACK_OUT_SIZE];
  Integer g_pack_in_count   = 0;
  Integer g_pack_file_count = 0;

  // The decoded 16 x 16 image
  Integer g_pack_r[256];
  Integer g_pack_g[256];
  Integer g_pack_b[256];
  Integer g_pack_a[256];
  Integer g_pack_overlay_r[256];
  Integer g_pack_overlay_g[256];
  Integer g_pack_overlay_b[256];
  Integer g_pack_overlay_a[256];

  // PNG palette (index 0..255 stored at 1..256)
  Integer g_png_pal_r[256];
  Integer g_png_pal_g[256];
  Integer g_png_pal_b[256];
  Integer g_png_pal_a[256];

  // Colour reduction scratch
  Integer g_pack_pixel_colour[256];   // distinct colour of each pixel
  Integer g_pack_colour_r [256];      // distinct colours and their use
  Integer g_pack_colour_g [256];
  Integer g_pack_colour_b [256];
  Integer g_pack_colour_n [256];
  Integer g_pack_cluster  [256];      // centre of each distinct colour
  Real    g_pack_centre_r [8];
  Real    g_pack_centre_g [8];
  Real    g_pack_centre_b [8];
  Real    g_pack_sum_r    [8];
  Real    g_pack_sum_g    [8];
  Real    g_pack_sum_b    [8];
  Integer g_pack_sum_n    [8];

  // Part of the image png_decode samples: a rectangle in pixels of a
  // PACK_SKIN_WIDTH wide skin, or the whole top square if width is 0
  Integer g_pack_region_x     = 0;
  Integer g_pack_region_y     = 0;
  Integer g_pack_region_w     = 0;
  Integer g_pack_region_h     = 0;
  Integer g_pack_region_turn  = PACK_TURN_NONE;

  // Inflate state
  Integer g_inflate_pos       = 0;   // next input byte (1-based)
  Integer g_inflate_bit       = 0;   // next bit of that byte (0..7)
  Integer g_inflate_end       = 0;   // last input byte
  Integer g_inflate_out       = 0;   // bytes written so far
  Integer g_inflate_limit     = 0;   // stop once this many bytes are written
  Integer g_inflate_failed    = 0;
  Integer g_inflate_lengths   [PACK_HUFFMAN_SYMBOLS];
  Integer g_inflate_offsets   [16];
  Integer g_huffman_count     [32];                    // table 1 at 1..16, table 2 at 17..32
  Integer g_huffman_symbol    [640];                   // table 1 at 1..320, table 2 at 321..640

  // Constant tables, filled by pack_init_tables()
  Integer g_pack_tables_ready = 0;
  Integer g_pow2              [32];    // g_pow2[n + 1] = 2^n
  Integer g_byte_bit          [2048];  // bit k of byte b at [b * 8 + k + 1]
  Integer g_length_base       [29];
  Integer g_length_extra      [29];
  Integer g_distance_base     [30];
  Integer g_distance_extra    [30];
  Integer g_code_order        [19];
}

// Table functions
void    pack_init_tables      ();
Integer pack_apply            (Text p_path, Text &p_report);

// Honest helpers
Integer pack_is_zip           (Text p_path);
Integer pack_map_entry        (Integer p_entry, Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_tint, Text &p_overlay);
Integer pack_map_part         (Integer p_entry, Integer &p_tex, Text &p_name, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h,
                               Integer &p_turn);
Text    pack_replace          (Text p_text, Text p_find, Text p_with);
Text    pack_key              (Text p_kind, Text p_name);
Integer pack_word_byte        (Integer p_word, Integer p_byte);
Integer pack_paeth            (Integer p_left, Integer p_up, Integer p_up_left);

#endif
