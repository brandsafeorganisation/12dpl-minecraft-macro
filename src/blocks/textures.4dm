#ifndef TEXTURES_4DM_INCLUDED
#define TEXTURES_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/blocks/blocks.h"
#include "../../include/blocks/textures.h"

// ---------------------------------------------------------------- texture access

Integer texture_palette_index(Integer p_tex, Integer p_index)
// ----------------------------------------------------------------
// Position of palette colour index (1..PALETTE_SIZE) of a texture
// in the g_tex_pal_* arrays
// ----------------------------------------------------------------
{
  return (p_tex - 1) * PALETTE_SIZE + p_index;
}

void texture_set_palette(Integer p_tex, Integer p_index, Integer p_red, Integer p_green, Integer p_blue)
// ----------------------------------------------------------------
// Define colour number index of a texture's palette
// ----------------------------------------------------------------
{
  Integer l_slot = texture_palette_index(p_tex, p_index);

  g_tex_pal_r[l_slot] = p_red;
  g_tex_pal_g[l_slot] = p_green;
  g_tex_pal_b[l_slot] = p_blue;
}

void texture_set(Integer p_tex, Integer p_u, Integer p_v, Integer p_index)
// ----------------------------------------------------------------
// Set one pixel; u is the column (1 = left), v is the row (1 = top)
// Pixels outside the texture are ignored
// ----------------------------------------------------------------
{
  if (p_u < 1 || p_u > TEX_SIZE || p_v < 1 || p_v > TEX_SIZE) return;

  g_tex_pixel[(p_tex - 1) * 256 + (p_v - 1) * TEX_SIZE + p_u] = p_index;
}

Integer texture_get(Integer p_tex, Integer p_u, Integer p_v)
// ----------------------------------------------------------------
// Palette index of one pixel, 0 outside the texture
// ----------------------------------------------------------------
{
  if (p_u < 1 || p_u > TEX_SIZE || p_v < 1 || p_v > TEX_SIZE) return 0;

  return g_tex_pixel[(p_tex - 1) * 256 + (p_v - 1) * TEX_SIZE + p_u];
}

void texture_fill(Integer p_tex, Integer p_index)
// ----------------------------------------------------------------
// Set every pixel of a texture
// ----------------------------------------------------------------
{
  texture_fill_rect(p_tex, 1, 1, TEX_SIZE, TEX_SIZE, p_index);
}

void texture_fill_rect(Integer p_tex, Integer p_u0, Integer p_v0, Integer p_u1, Integer p_v1, Integer p_index)
// ----------------------------------------------------------------
// Set every pixel in columns u0..u1 and rows v0..v1
// ----------------------------------------------------------------
{
  Integer l_u = 0;
  Integer l_v = 0;

  for (l_v = p_v0; l_v <= p_v1; ++l_v) {
    for (l_u = p_u0; l_u <= p_u1; ++l_u) {
      texture_set(p_tex, l_u, l_v, p_index);
    }
  }
}

void texture_copy(Integer p_from_tex, Integer p_to_tex)
// ----------------------------------------------------------------
// Copy the pixels and palette of one texture to another
// ----------------------------------------------------------------
{
  Integer l_pixel = 0;
  Integer l_index = 0;

  for (l_pixel = 1; l_pixel <= 256; ++l_pixel) {
    g_tex_pixel[(p_to_tex - 1) * 256 + l_pixel] = g_tex_pixel[(p_from_tex - 1) * 256 + l_pixel];
  }
  for (l_index = 1; l_index <= PALETTE_SIZE; ++l_index) {
    g_tex_pal_r[texture_palette_index(p_to_tex, l_index)] = g_tex_pal_r[texture_palette_index(p_from_tex, l_index)];
    g_tex_pal_g[texture_palette_index(p_to_tex, l_index)] = g_tex_pal_g[texture_palette_index(p_from_tex, l_index)];
    g_tex_pal_b[texture_palette_index(p_to_tex, l_index)] = g_tex_pal_b[texture_palette_index(p_from_tex, l_index)];
  }
}

void texture_row(Integer p_tex, Integer p_v, Text p_pixels)
// ----------------------------------------------------------------
// Set row v of a texture from 16 characters: "." is see-through,
// "1".."8" are palette colours. Used to draw sprites as pixel art.
// ----------------------------------------------------------------
{
  Text    l_digits    = "12345678";
  Text    l_character = "";
  Integer l_u         = 0;

  for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
    l_character = Get_subtext(p_pixels, l_u, l_u);
    texture_set(p_tex, l_u, p_v, Find_text(l_digits, l_character));
  }
}

Real texture_random(Integer p_tex, Integer p_u, Integer p_v, Integer p_salt)
// ----------------------------------------------------------------
// Repeatable random number in [0, 1) for one pixel
// ----------------------------------------------------------------
{
  return hash_real(p_tex * 13.37 + p_salt * 5.11, p_u * 1.0, p_v * 1.0);
}

Real texture_noise(Integer p_tex, Integer p_u, Integer p_v, Integer p_cell, Integer p_salt)
// ----------------------------------------------------------------
// Smooth value noise over the texture with lattice spacing cell
// (cell must divide 16); wraps so the texture tiles seamlessly
// ----------------------------------------------------------------
{
  Integer l_lattice = floor_divide(TEX_SIZE, p_cell);
  Real    l_x       = (p_u - 0.5) / p_cell;
  Real    l_y       = (p_v - 0.5) / p_cell;
  Integer l_x0      = Floor(l_x);
  Integer l_y0      = Floor(l_y);
  Real    l_fx      = smooth_curve(l_x - l_x0);
  Real    l_fy      = smooth_curve(l_y - l_y0);
  Integer l_x1      = positive_mod(l_x0 + 1, l_lattice);
  Integer l_y1      = positive_mod(l_y0 + 1, l_lattice);
  Real    l_v00     = 0.0;
  Real    l_v10     = 0.0;
  Real    l_v01     = 0.0;
  Real    l_v11     = 0.0;

  l_x0  = positive_mod(l_x0, l_lattice);
  l_y0  = positive_mod(l_y0, l_lattice);
  l_v00 = hash_real(p_tex * 7.3 + p_salt, l_x0 * 1.0, l_y0 * 1.0);
  l_v10 = hash_real(p_tex * 7.3 + p_salt, l_x1 * 1.0, l_y0 * 1.0);
  l_v01 = hash_real(p_tex * 7.3 + p_salt, l_x0 * 1.0, l_y1 * 1.0);
  l_v11 = hash_real(p_tex * 7.3 + p_salt, l_x1 * 1.0, l_y1 * 1.0);

  return lerp_real(lerp_real(l_v00, l_v10, l_fx), lerp_real(l_v01, l_v11, l_fx), l_fy);
}

// ---------------------------------------------------------------- finishing

void texture_finish(Integer p_tex)
// ----------------------------------------------------------------
// Work out the drawing data for a finished texture:
//  - the base (most common) colour and the average colour; a
//    texture with see-through pixels (index 0) is a sprite and has
//    no base colour
//  - the 2 x 2 quadrant colours
//  - rectangles covering every non-base pixel, grown greedily
//    right then down so that runs of one colour share a polygon
// ----------------------------------------------------------------
{
  Integer l_index     = 0;
  Integer l_base      = 1;
  Integer l_u         = 0;
  Integer l_v         = 0;
  Integer l_u_end     = 0;
  Integer l_v_end     = 0;
  Integer l_colour    = 0;
  Integer l_slot      = 0;
  Integer l_grow      = 0;
  Integer l_row_ok    = 0;
  Integer l_check_u   = 0;
  Integer l_quadrant  = 0;
  Real    l_sum_r     = 0.0;
  Real    l_sum_g     = 0.0;
  Real    l_sum_b     = 0.0;
  Integer l_opaque    = 0;

  for (l_index = 1; l_index <= PALETTE_SIZE; ++l_index) g_tex_count[l_index] = 0;
  for (l_quadrant = 1; l_quadrant <= 4; ++l_quadrant) {
    g_tex_sum_r[l_quadrant] = 0.0;
    g_tex_sum_g[l_quadrant] = 0.0;
    g_tex_sum_b[l_quadrant] = 0.0;
    g_tex_sum_n[l_quadrant] = 0;
  }
  g_tex_is_sprite[p_tex] = FALSE;

  for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
    for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
      l_colour = texture_get(p_tex, l_u, l_v);
      if (l_colour == TEX_TRANSPARENT) {
        g_tex_is_sprite[p_tex] = TRUE;
        continue;
      }
      if (l_colour < 1 || l_colour > PALETTE_SIZE) l_colour = 1;
      g_tex_count[l_colour] = g_tex_count[l_colour] + 1;
      ++l_opaque;

      l_slot  = texture_palette_index(p_tex, l_colour);
      l_sum_r = l_sum_r + g_tex_pal_r[l_slot];
      l_sum_g = l_sum_g + g_tex_pal_g[l_slot];
      l_sum_b = l_sum_b + g_tex_pal_b[l_slot];

      // quadrant 1 top left, 2 top right, 3 bottom left, 4 bottom right
      l_quadrant = 1;
      if (l_u > 8) l_quadrant = l_quadrant + 1;
      if (l_v > 8) l_quadrant = l_quadrant + 2;
      g_tex_sum_r[l_quadrant] = g_tex_sum_r[l_quadrant] + g_tex_pal_r[l_slot];
      g_tex_sum_g[l_quadrant] = g_tex_sum_g[l_quadrant] + g_tex_pal_g[l_slot];
      g_tex_sum_b[l_quadrant] = g_tex_sum_b[l_quadrant] + g_tex_pal_b[l_slot];
      g_tex_sum_n[l_quadrant] = g_tex_sum_n[l_quadrant] + 1;
    }
  }
  if (l_opaque < 1) l_opaque = 1;

  for (l_index = 1; l_index <= PALETTE_SIZE; ++l_index) {
    if (g_tex_count[l_index] > g_tex_count[l_base]) l_base = l_index;
  }
  if (g_tex_is_sprite[p_tex]) l_base = 0;
  g_tex_base [p_tex] = l_base;
  g_tex_avg_r[p_tex] = l_sum_r / l_opaque;
  g_tex_avg_g[p_tex] = l_sum_g / l_opaque;
  g_tex_avg_b[p_tex] = l_sum_b / l_opaque;
  for (l_quadrant = 1; l_quadrant <= 4; ++l_quadrant) {
    if (g_tex_sum_n[l_quadrant] < 1) g_tex_sum_n[l_quadrant] = 1;
    g_tex_quad_r[(p_tex - 1) * 4 + l_quadrant] = g_tex_sum_r[l_quadrant] / g_tex_sum_n[l_quadrant];
    g_tex_quad_g[(p_tex - 1) * 4 + l_quadrant] = g_tex_sum_g[l_quadrant] / g_tex_sum_n[l_quadrant];
    g_tex_quad_b[(p_tex - 1) * 4 + l_quadrant] = g_tex_sum_b[l_quadrant] / g_tex_sum_n[l_quadrant];
  }

  // Rectangles
  for (l_index = 1; l_index <= 256; ++l_index) g_tex_mark[l_index] = 0;
  g_tex_rect_first[p_tex] = g_rect_total + 1;
  g_tex_rect_count[p_tex] = 0;

  // One colour at a time, so a texture's rectangles come grouped by
  // colour and the renderer only changes colour between groups
  for (l_colour = 1; l_colour <= PALETTE_SIZE; ++l_colour) {
    if (l_colour == l_base) continue;
    for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
      for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
        if (texture_get(p_tex, l_u, l_v) != l_colour) continue;
        if (g_tex_mark[(l_v - 1) * TEX_SIZE + l_u] != 0) continue;

        // Grow right along the row
        l_u_end = l_u;
        l_grow  = TRUE;
        while (l_grow) {
          l_grow = FALSE;
          if (l_u_end < TEX_SIZE) {
            if (texture_get(p_tex, l_u_end + 1, l_v) == l_colour) {
              if (g_tex_mark[(l_v - 1) * TEX_SIZE + l_u_end + 1] == 0) {
                ++l_u_end;
                l_grow = TRUE;
              }
            }
          }
        }

        // Grow down while the whole span below matches
        l_v_end = l_v;
        l_grow  = TRUE;
        while (l_grow) {
          l_grow = FALSE;
          if (l_v_end < TEX_SIZE) {
            l_row_ok = TRUE;
            for (l_check_u = l_u; l_check_u <= l_u_end; ++l_check_u) {
              if (texture_get(p_tex, l_check_u, l_v_end + 1) != l_colour) l_row_ok = FALSE;
              if (g_tex_mark[l_v_end * TEX_SIZE + l_check_u] != 0) l_row_ok = FALSE;
            }
            if (l_row_ok) {
              ++l_v_end;
              l_grow = TRUE;
            }
          }
        }

        for (l_index = l_v; l_index <= l_v_end; ++l_index) {
          for (l_check_u = l_u; l_check_u <= l_u_end; ++l_check_u) {
            g_tex_mark[(l_index - 1) * TEX_SIZE + l_check_u] = 1;
          }
        }

        if (g_rect_total >= MAX_TEXTURE_RECTS) continue;

        ++g_rect_total;
        // Texture rows run top to bottom, face v runs bottom (0) to top (1)
        g_rect_u0  [g_rect_total] = (l_u - 1) / 16.0;
        g_rect_u1  [g_rect_total] = l_u_end / 16.0;
        g_rect_v0  [g_rect_total] = 1.0 - l_v_end / 16.0;
        g_rect_v1  [g_rect_total] = 1.0 - (l_v - 1) / 16.0;
        g_rect_pal [g_rect_total] = l_colour;
        g_rect_area[g_rect_total] = (l_u_end - l_u + 1) * (l_v_end - l_v + 1);
        g_tex_rect_count[p_tex] = g_tex_rect_count[p_tex] + 1;
      }
    }
  }
}

// ---------------------------------------------------------------- the textures

void texture_speckle(Integer p_tex, Integer p_index, Real p_chance, Integer p_salt)
// ----------------------------------------------------------------
// Scatter single pixels of colour index over a texture
// ----------------------------------------------------------------
{
  Integer l_u = 0;
  Integer l_v = 0;

  for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
    for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
      if (texture_random(p_tex, l_u, l_v, p_salt) < p_chance) texture_set(p_tex, l_u, l_v, p_index);
    }
  }
}

void texture_blotch(Integer p_tex, Integer p_index, Integer p_cell, Real p_below, Real p_above, Integer p_salt)
// ----------------------------------------------------------------
// Paint colour index wherever smooth noise lies in [below, above]
// ----------------------------------------------------------------
{
  Integer l_u     = 0;
  Integer l_v     = 0;
  Real    l_value = 0.0;

  for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
    for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
      l_value = texture_noise(p_tex, l_u, l_v, p_cell, p_salt);
      if (l_value >= p_below && l_value <= p_above) texture_set(p_tex, l_u, l_v, p_index);
    }
  }
}

void make_texture_stone(Integer p_tex)
// ----------------------------------------------------------------
// Grey rock with soft darker and lighter patches
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 128, 128, 128);
  texture_set_palette(p_tex, 2, 108, 108, 111);
  texture_set_palette(p_tex, 3, 147, 147, 147);
  texture_fill  (p_tex, 1);
  texture_blotch(p_tex, 2, 4, 0.0 , 0.33, 1);
  texture_blotch(p_tex, 3, 4, 0.74, 1.0 , 2);
}

void make_texture_bedrock(Integer p_tex)
// ----------------------------------------------------------------
// Very dark mottled rock
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 72 , 72 , 72 );
  texture_set_palette(p_tex, 2, 38 , 38 , 40 );
  texture_set_palette(p_tex, 3, 112, 112, 112);
  texture_fill  (p_tex, 1);
  texture_blotch(p_tex, 2, 4, 0.0 , 0.42, 3);
  texture_blotch(p_tex, 3, 2, 0.80, 1.0 , 4);
}

void make_texture_cobblestone(Integer p_tex)
// ----------------------------------------------------------------
// Rounded stones set in dark mortar, built from the distance to a
// handful of random points (nearest point = which stone a pixel is
// part of, close to two points = mortar)
// ----------------------------------------------------------------
{
  Integer l_point    = 0;
  Integer l_u        = 0;
  Integer l_v        = 0;
  Integer l_nearest  = 0;
  Real    l_first    = 0.0;
  Real    l_second   = 0.0;
  Real    l_du       = 0.0;
  Real    l_dv       = 0.0;
  Real    l_distance = 0.0;

  texture_set_palette(p_tex, 1, 124, 124, 124);
  texture_set_palette(p_tex, 2, 142, 142, 142);
  texture_set_palette(p_tex, 3, 106, 106, 108);
  texture_set_palette(p_tex, 4, 66 , 66 , 68 );

  for (l_point = 1; l_point <= 9; ++l_point) {
    g_cobble_u[l_point] = 0.5 + texture_random(p_tex, l_point, 1, 7) * 15.0;
    g_cobble_v[l_point] = 0.5 + texture_random(p_tex, l_point, 2, 7) * 15.0;
  }

  for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
    for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
      l_first   = 1000.0;
      l_second  = 1000.0;
      l_nearest = 1;
      for (l_point = 1; l_point <= 9; ++l_point) {
        l_du = Absolute(l_u - 0.5 - g_cobble_u[l_point]);
        l_dv = Absolute(l_v - 0.5 - g_cobble_v[l_point]);
        if (l_du > 8.0) l_du = 16.0 - l_du;
        if (l_dv > 8.0) l_dv = 16.0 - l_dv;
        l_distance = Sqrt(l_du * l_du + l_dv * l_dv);
        if (l_distance < l_first) {
          l_second  = l_first;
          l_first   = l_distance;
          l_nearest = l_point;
        } else if (l_distance < l_second) {
          l_second = l_distance;
        }
      }
      if (l_second - l_first < 1.0) {
        texture_set(p_tex, l_u, l_v, 4);
      } else {
        texture_set(p_tex, l_u, l_v, 1 + positive_mod(l_nearest, 3));
      }
    }
  }
}

void make_texture_dirt(Integer p_tex)
// ----------------------------------------------------------------
// Brown earth with darker clods and a few light grains
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 134, 96 , 66);
  texture_set_palette(p_tex, 2, 110, 77 , 52);
  texture_set_palette(p_tex, 3, 156, 116, 83);
  texture_fill   (p_tex, 1);
  texture_blotch (p_tex, 2, 4, 0.0, 0.28, 5);
  texture_speckle(p_tex, 2, 0.03, 6);
  texture_speckle(p_tex, 3, 0.03, 8);
}

void make_texture_grass_top(Integer p_tex)
// ----------------------------------------------------------------
// Green turf seen from above
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 92 , 158, 52);
  texture_set_palette(p_tex, 2, 74 , 134, 41);
  texture_set_palette(p_tex, 3, 112, 178, 64);
  texture_fill   (p_tex, 1);
  texture_blotch (p_tex, 2, 4, 0.0, 0.30, 9);
  texture_speckle(p_tex, 3, 0.05, 10);
  texture_speckle(p_tex, 2, 0.02, 11);
}

void make_texture_grass_side(Integer p_tex)
// ----------------------------------------------------------------
// Dirt with a ragged band of turf along the top edge
// ----------------------------------------------------------------
{
  Integer l_u = 0;

  texture_copy(TEX_DIRT, p_tex);
  texture_set_palette(p_tex, 4, 92, 158, 52);
  texture_set_palette(p_tex, 5, 74, 134, 41);

  texture_fill_rect(p_tex, 1, 1, TEX_SIZE, 3, 4);
  for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
    if (texture_random(p_tex, l_u, 1, 12) < 0.6 ) texture_set(p_tex, l_u, 4, 4);
    if (texture_random(p_tex, l_u, 2, 12) < 0.22) texture_set(p_tex, l_u, 5, 5);
    if (texture_random(p_tex, l_u, 3, 12) < 0.25) texture_set(p_tex, l_u, 2, 5);
  }
}

void make_texture_log_side(Integer p_tex)
// ----------------------------------------------------------------
// Bark: vertical grooves of darker and lighter wood
// ----------------------------------------------------------------
{
  Integer l_u      = 0;
  Integer l_v      = 0;
  Integer l_stripe = 1;
  Real    l_choice = 0.0;

  texture_set_palette(p_tex, 1, 104, 82, 50);
  texture_set_palette(p_tex, 2, 82 , 63, 37);
  texture_set_palette(p_tex, 3, 124, 99, 62);
  texture_fill(p_tex, 1);

  for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
    l_choice = texture_random(p_tex, l_u, 0, 13);
    l_stripe = 1;
    if (l_choice < 0.38) l_stripe = 2;
    if (l_choice > 0.84) l_stripe = 3;
    for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
      if (texture_random(p_tex, l_u, l_v, 14) > 0.12) texture_set(p_tex, l_u, l_v, l_stripe);
    }
  }
}

void make_texture_log_top(Integer p_tex)
// ----------------------------------------------------------------
// Cut end of a log: growth rings inside a ring of bark
// ----------------------------------------------------------------
{
  Integer l_u        = 0;
  Integer l_v        = 0;
  Integer l_ring     = 0;
  Real    l_distance = 0.0;

  texture_set_palette(p_tex, 1, 178, 142, 90);
  texture_set_palette(p_tex, 2, 150, 116, 70);
  texture_set_palette(p_tex, 3, 104, 82 , 50);

  for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
    for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
      l_distance = Sqrt((l_u - 8.5) * (l_u - 8.5) + (l_v - 8.5) * (l_v - 8.5));
      l_ring     = Floor(l_distance / 2.2);
      if (l_distance > 7.1) {
        texture_set(p_tex, l_u, l_v, 3);
      } else if (positive_mod(l_ring, 2) == 1) {
        texture_set(p_tex, l_u, l_v, 2);
      } else {
        texture_set(p_tex, l_u, l_v, 1);
      }
    }
  }
}

void make_texture_leaves(Integer p_tex)
// ----------------------------------------------------------------
// Clumps of leaves with dark gaps between them
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 58 , 124, 40);
  texture_set_palette(p_tex, 2, 42 , 98 , 30);
  texture_set_palette(p_tex, 3, 28 , 66 , 20);
  texture_set_palette(p_tex, 4, 78 , 146, 54);
  texture_fill   (p_tex, 1);
  texture_blotch (p_tex, 2, 4, 0.0 , 0.36, 15);
  texture_blotch (p_tex, 4, 4, 0.72, 1.0 , 16);
  texture_speckle(p_tex, 3, 0.06, 17);
}

void make_texture_water(Integer p_tex)
// ----------------------------------------------------------------
// Blue water with broken bands of ripples
// ----------------------------------------------------------------
{
  Integer l_u = 0;

  texture_set_palette(p_tex, 1, 44, 92 , 186);
  texture_set_palette(p_tex, 2, 70, 124, 212);
  texture_set_palette(p_tex, 3, 36, 76 , 164);
  texture_fill(p_tex, 1);

  for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
    if (positive_mod(l_u + 1 , 8) < 4) texture_set(p_tex, l_u, 3 , 2);
    if (positive_mod(l_u + 5 , 8) < 3) texture_set(p_tex, l_u, 8 , 2);
    if (positive_mod(l_u + 3 , 8) < 4) texture_set(p_tex, l_u, 13, 2);
    if (positive_mod(l_u + 6 , 8) < 3) texture_set(p_tex, l_u, 5 , 3);
    if (positive_mod(l_u + 2 , 8) < 3) texture_set(p_tex, l_u, 11, 3);
  }
}

void make_texture_planks(Integer p_tex)
// ----------------------------------------------------------------
// Four horizontal boards with dark seams, staggered butt joints
// and a little grain
// ----------------------------------------------------------------
{
  Integer l_board = 0;
  Integer l_top   = 0;
  Integer l_joint = 0;
  Integer l_u     = 0;

  texture_set_palette(p_tex, 1, 172, 136, 84);
  texture_set_palette(p_tex, 2, 152, 118, 71);
  texture_set_palette(p_tex, 3, 112, 86 , 52);
  texture_fill(p_tex, 1);

  for (l_board = 0; l_board <= 3; ++l_board) {
    l_top = l_board * 4 + 1;
    texture_fill_rect(p_tex, 1, l_top + 3, TEX_SIZE, l_top + 3, 3);
    l_joint = 5 + positive_mod(l_board * 7, 9);
    texture_fill_rect(p_tex, l_joint, l_top, l_joint, l_top + 2, 3);
    for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
      if (texture_random(p_tex, l_u, l_board, 18) < 0.16) texture_set(p_tex, l_u, l_top + 1, 2);
    }
  }
}

void make_texture_table_top(Integer p_tex)
// ----------------------------------------------------------------
// Workbench top: planks inside a dark frame with a worn square
// ----------------------------------------------------------------
{
  texture_copy(TEX_PLANKS, p_tex);
  texture_set_palette(p_tex, 4, 96 , 70 , 42);
  texture_set_palette(p_tex, 5, 186, 152, 100);

  texture_fill_rect(p_tex, 1 , 1 , 16, 2 , 4);
  texture_fill_rect(p_tex, 1 , 15, 16, 16, 4);
  texture_fill_rect(p_tex, 1 , 1 , 2 , 16, 4);
  texture_fill_rect(p_tex, 15, 1 , 16, 16, 4);
  texture_fill_rect(p_tex, 5 , 5 , 12, 12, 5);
  texture_fill_rect(p_tex, 6 , 6 , 11, 11, 1);
}

void make_texture_table_side(Integer p_tex)
// ----------------------------------------------------------------
// Workbench side: planks with a saw and a mallet hanging on them
// ----------------------------------------------------------------
{
  texture_copy(TEX_PLANKS, p_tex);
  texture_set_palette(p_tex, 4, 96 , 70 , 42 );
  texture_set_palette(p_tex, 5, 176, 178, 184);
  texture_set_palette(p_tex, 6, 70 , 50 , 30 );

  texture_fill_rect(p_tex, 1 , 1 , 16, 2 , 4);
  // saw: blade and handle
  texture_fill_rect(p_tex, 2 , 5 , 8 , 7 , 5);
  texture_fill_rect(p_tex, 3 , 8 , 7 , 8 , 5);
  texture_fill_rect(p_tex, 9 , 4 , 10, 8 , 6);
  // mallet: head and handle
  texture_fill_rect(p_tex, 11, 5 , 15, 7 , 6);
  texture_fill_rect(p_tex, 13, 8 , 13, 13, 6);
}

void make_texture_furnace_side(Integer p_tex)
// ----------------------------------------------------------------
// Grey masonry: courses of blocks with offset joints
// ----------------------------------------------------------------
{
  Integer l_course = 0;
  Integer l_top    = 0;
  Integer l_offset = 0;

  texture_set_palette(p_tex, 1, 124, 124, 124);
  texture_set_palette(p_tex, 2, 92 , 92 , 94 );
  texture_set_palette(p_tex, 3, 142, 142, 142);
  texture_fill(p_tex, 1);
  texture_speckle(p_tex, 3, 0.06, 19);

  for (l_course = 0; l_course <= 3; ++l_course) {
    l_top    = l_course * 4 + 1;
    l_offset = 4 * positive_mod(l_course, 2);
    texture_fill_rect(p_tex, 1, l_top + 3, TEX_SIZE, l_top + 3, 2);
    texture_fill_rect(p_tex, 1 + l_offset, l_top, 1 + l_offset, l_top + 2, 2);
    texture_fill_rect(p_tex, 9 + l_offset, l_top, 9 + l_offset, l_top + 2, 2);
  }
}

void make_texture_furnace_top(Integer p_tex)
// ----------------------------------------------------------------
// Smooth grey slab with a bevelled rim
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 132, 132, 132);
  texture_set_palette(p_tex, 2, 100, 100, 102);
  texture_set_palette(p_tex, 3, 150, 150, 150);
  texture_fill     (p_tex, 1);
  texture_fill_rect(p_tex, 1 , 1 , 16, 1 , 2);
  texture_fill_rect(p_tex, 1 , 16, 16, 16, 2);
  texture_fill_rect(p_tex, 1 , 1 , 1 , 16, 2);
  texture_fill_rect(p_tex, 16, 1 , 16, 16, 2);
  texture_fill_rect(p_tex, 3 , 3 , 14, 3 , 3);
  texture_speckle  (p_tex, 2, 0.04, 20);
}

void make_texture_furnace_front(Integer p_tex, Integer p_lit)
// ----------------------------------------------------------------
// Masonry with a vent across the top and a fire box below
// lit = TRUE draws flames in the fire box
// ----------------------------------------------------------------
{
  Integer l_u = 0;
  Integer l_v = 0;

  texture_copy(TEX_FURNACE_SIDE, p_tex);
  texture_set_palette(p_tex, 4, 34 , 32 , 30 );
  texture_set_palette(p_tex, 5, 70 , 70 , 72 );
  texture_set_palette(p_tex, 6, 236, 132, 36 );
  texture_set_palette(p_tex, 7, 252, 214, 84 );

  // vent
  texture_fill_rect(p_tex, 3, 3, 14, 4, 4);
  // fire box with a frame
  texture_fill_rect(p_tex, 3, 8 , 14, 15, 5);
  texture_fill_rect(p_tex, 4, 9 , 13, 14, 4);

  if (p_lit) {
    texture_fill_rect(p_tex, 4, 12, 13, 14, 6);
    for (l_u = 4; l_u <= 13; ++l_u) {
      for (l_v = 9; l_v <= 11; ++l_v) {
        if (texture_random(p_tex, l_u, l_v, 21) < 0.25 + (l_v - 9) * 0.25) texture_set(p_tex, l_u, l_v, 6);
      }
      if (texture_random(p_tex, l_u, 13, 22) < 0.5) texture_set(p_tex, l_u, 13, 7);
    }
  }
}

void make_texture_sand(Integer p_tex)
// ----------------------------------------------------------------
// Pale sand with scattered darker and lighter grains
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 218, 206, 160);
  texture_set_palette(p_tex, 2, 200, 187, 141);
  texture_set_palette(p_tex, 3, 232, 222, 182);
  texture_fill   (p_tex, 1);
  texture_blotch (p_tex, 2, 4, 0.0, 0.25, 23);
  texture_speckle(p_tex, 3, 0.06, 24);
}

void make_texture_cow_palette(Integer p_tex)
// ----------------------------------------------------------------
// The colours every cow texture uses
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 92 , 62 , 42 );   // brown hide
  texture_set_palette(p_tex, 2, 66 , 44 , 30 );   // darker brown
  texture_set_palette(p_tex, 3, 230, 226, 216);   // white patches
  texture_set_palette(p_tex, 4, 22 , 20 , 20 );   // eyes
  texture_set_palette(p_tex, 5, 206, 176, 156);   // muzzle
  texture_set_palette(p_tex, 6, 112, 82 , 72 );   // nostrils
  texture_set_palette(p_tex, 7, 64 , 60 , 58 );   // hooves
  texture_set_palette(p_tex, 8, 214, 206, 188);   // horn
}

void make_texture_cow_hide(Integer p_tex)
// ----------------------------------------------------------------
// Side of the cow's body: brown hide with big white patches
// ----------------------------------------------------------------
{
  make_texture_cow_palette(p_tex);
  texture_fill  (p_tex, 1);
  texture_blotch(p_tex, 2, 4, 0.0, 0.18, 23);
  texture_blotch(p_tex, 3, 8, 0.0, 0.34, 25);
}

void make_texture_cow_face(Integer p_tex)
// ----------------------------------------------------------------
// Front of the cow's head: white blaze between the eyes and a pale
// muzzle with nostrils
// ----------------------------------------------------------------
{
  make_texture_cow_palette(p_tex);
  texture_row(p_tex, 1 , "1111113333111111");
  texture_row(p_tex, 2 , "1111113333111111");
  texture_row(p_tex, 3 , "1111133333311111");
  texture_row(p_tex, 4 , "1111133333311111");
  texture_row(p_tex, 5 , "1111113333111111");
  texture_row(p_tex, 6 , "1344113333114431");
  texture_row(p_tex, 7 , "1344113333114431");
  texture_row(p_tex, 8 , "1111113333111111");
  texture_row(p_tex, 9 , "2111111331111112");
  texture_row(p_tex, 10, "2211111111111122");
  texture_row(p_tex, 11, "1155555555555511");
  texture_row(p_tex, 12, "1555555555555551");
  texture_row(p_tex, 13, "1556655555566551");
  texture_row(p_tex, 14, "1556655555566551");
  texture_row(p_tex, 15, "1555555555555551");
  texture_row(p_tex, 16, "1155555555555511");
}

void make_texture_cow(Integer p_tex, Integer p_part)
// ----------------------------------------------------------------
// The other faces of a cow: head side (p_part 1), head top (2),
// back (3), chest and rump (4), leg (5) and horn (6)
// ----------------------------------------------------------------
{
  make_texture_cow_palette(p_tex);
  texture_fill(p_tex, 1);
  if (p_part == 1) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.20, 31);
    texture_fill_rect(p_tex, 1, 6, 3, 7, 4);           // the eye seen from the side
    texture_fill_rect(p_tex, 1, 11, 4, 16, 5);         // muzzle
  } else if (p_part == 2) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.20, 33);
    texture_fill_rect(p_tex, 6, 1, 11, 16, 3);         // the blaze runs over the top
  } else if (p_part == 3) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 35);
    texture_blotch   (p_tex, 3, 6, 0.0, 0.28, 37);
  } else if (p_part == 4) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 39);
    texture_blotch   (p_tex, 3, 8, 0.0, 0.30, 41);
  } else if (p_part == 5) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 43);
    texture_fill_rect(p_tex, 1, 9 , 16, 13, 3);        // white socks
    texture_fill_rect(p_tex, 1, 14, 16, 16, 7);        // hooves
  } else {
    texture_fill     (p_tex, 8);
    texture_fill_rect(p_tex, 1, 1, 16, 4, 2);          // dark tip
  }
}

void make_texture_sandstone_side(Integer p_tex)
// ----------------------------------------------------------------
// Sandy rock in layers, with a smooth band along the top
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 216, 202, 150);
  texture_set_palette(p_tex, 2, 196, 180, 128);
  texture_set_palette(p_tex, 3, 230, 220, 172);
  texture_fill     (p_tex, 1);
  texture_fill_rect(p_tex, 1, 1 , TEX_SIZE, 3 , 3);
  texture_fill_rect(p_tex, 1, 4 , TEX_SIZE, 4 , 2);
  texture_fill_rect(p_tex, 1, 10, TEX_SIZE, 10, 2);
  texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 41);
}

void make_texture_sandstone_top(Integer p_tex)
// ----------------------------------------------------------------
// Smooth sandstone with a few darker grains
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 224, 212, 162);
  texture_set_palette(p_tex, 2, 204, 190, 140);
  texture_fill   (p_tex, 1);
  texture_speckle(p_tex, 2, 0.05, 42);
}

void make_texture_cactus_side(Integer p_tex)
// ----------------------------------------------------------------
// Green ribs with pale spines
// ----------------------------------------------------------------
{
  Integer l_u = 0;

  texture_set_palette(p_tex, 1, 58 , 128, 48 );
  texture_set_palette(p_tex, 2, 38 , 96 , 34 );
  texture_set_palette(p_tex, 3, 214, 226, 170);
  texture_fill(p_tex, 1);
  for (l_u = 2; l_u <= TEX_SIZE; l_u = l_u + 4) texture_fill_rect(p_tex, l_u, 1, l_u, TEX_SIZE, 2);
  texture_speckle(p_tex, 3, 0.05, 43);
}

void make_texture_cactus_top(Integer p_tex)
// ----------------------------------------------------------------
// Top of a cactus: lighter centre with a dark rim
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 76 , 146, 62);
  texture_set_palette(p_tex, 2, 38 , 96 , 34);
  texture_set_palette(p_tex, 3, 110, 170, 84);
  texture_fill     (p_tex, 2);
  texture_fill_rect(p_tex, 2, 2, 15, 15, 1);
  texture_fill_rect(p_tex, 6, 6, 11, 11, 3);
}

void make_texture_coal_ore(Integer p_tex)
// ----------------------------------------------------------------
// Stone with black lumps of coal
// ----------------------------------------------------------------
{
  make_texture_stone(p_tex);
  texture_set_palette(p_tex, 4, 34, 34, 36);
  texture_set_palette(p_tex, 5, 64, 64, 68);
  texture_fill_rect(p_tex, 3 , 3 , 5 , 4 , 4);
  texture_fill_rect(p_tex, 4 , 5 , 5 , 5 , 5);
  texture_fill_rect(p_tex, 10, 5 , 13, 7 , 4);
  texture_fill_rect(p_tex, 11, 8 , 12, 8 , 5);
  texture_fill_rect(p_tex, 5 , 11, 7 , 13, 4);
  texture_fill_rect(p_tex, 12, 12, 13, 14, 4);
}

void make_texture_gravel(Integer p_tex)
// ----------------------------------------------------------------
// Loose grey and brown pebbles
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 132, 126, 124);
  texture_set_palette(p_tex, 2, 96 , 90 , 88 );
  texture_set_palette(p_tex, 3, 168, 160, 156);
  texture_set_palette(p_tex, 4, 120, 100, 86 );
  texture_fill  (p_tex, 1);
  texture_blotch(p_tex, 2, 2, 0.0 , 0.25, 44);
  texture_blotch(p_tex, 3, 2, 0.78, 1.0 , 45);
  texture_speckle(p_tex, 4, 0.08, 46);
}

void make_texture_plant_grass(Integer p_tex)
// ----------------------------------------------------------------
// A tuft of grass blades (sprite)
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 2, 82 , 150, 56);
  texture_set_palette(p_tex, 3, 120, 186, 80);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "................");
  texture_row(p_tex,  4, "................");
  texture_row(p_tex,  5, "......2.....2...");
  texture_row(p_tex,  6, "..2...2....23...");
  texture_row(p_tex,  7, "..23..32...2....");
  texture_row(p_tex,  8, "...2..2...32..2.");
  texture_row(p_tex,  9, "...32.2..2...32.");
  texture_row(p_tex, 10, "....2.32.2..2...");
  texture_row(p_tex, 11, ".2..2..2.2.32...");
  texture_row(p_tex, 12, ".32..2.2.2.2....");
  texture_row(p_tex, 13, "..2..2.22.2.....");
  texture_row(p_tex, 14, "..32.22.2.2.....");
  texture_row(p_tex, 15, "...2.2.222......");
  texture_row(p_tex, 16, "...2222222......");
}

void make_texture_plant_flower(Integer p_tex, Integer p_red, Integer p_green, Integer p_blue)
// ----------------------------------------------------------------
// A flower on a stem (sprite) with petals of the given colour
// ----------------------------------------------------------------
{
  Integer l_dark_red     = Floor(p_red   * 0.55);
  Integer l_dark_green   = Floor(p_green * 0.55);
  Integer l_dark_blue    = Floor(p_blue  * 0.55);
  Integer l_light_red    = Floor(p_red   * 0.75 + 60.0);
  Integer l_light_green  = Floor(p_green * 0.75 + 60.0);
  Integer l_light_blue   = Floor(p_blue  * 0.75 + 60.0);

  texture_set_palette(p_tex, 1, l_dark_red , l_dark_green , l_dark_blue );
  texture_set_palette(p_tex, 2, p_red      , p_green      , p_blue      );
  texture_set_palette(p_tex, 3, l_light_red, l_light_green, l_light_blue);
  texture_set_palette(p_tex, 4, 60 , 44 , 20 );
  texture_set_palette(p_tex, 5, 70 , 136, 50 );
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, ".....1111.......");
  texture_row(p_tex,  4, "....122221......");
  texture_row(p_tex,  5, "...12233221.....");
  texture_row(p_tex,  6, "...12234321.....");
  texture_row(p_tex,  7, "...12233221.....");
  texture_row(p_tex,  8, "....122221......");
  texture_row(p_tex,  9, ".....1551.......");
  texture_row(p_tex, 10, "......5.........");
  texture_row(p_tex, 11, "......5..55.....");
  texture_row(p_tex, 12, ".....55.555.....");
  texture_row(p_tex, 13, "..55..5.55......");
  texture_row(p_tex, 14, "...55.555.......");
  texture_row(p_tex, 15, "....5555........");
  texture_row(p_tex, 16, "......5.........");
}

void make_texture_plant_dead_bush(Integer p_tex)
// ----------------------------------------------------------------
// Dry twigs for the desert (sprite)
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 128, 86, 40);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "..1.......1.....");
  texture_row(p_tex,  4, "...1..1..1...1..");
  texture_row(p_tex,  5, "...1..1.1...1...");
  texture_row(p_tex,  6, "1...1.1.1..1....");
  texture_row(p_tex,  7, ".1..1..11.1..1..");
  texture_row(p_tex,  8, "..1..1.1.11.1...");
  texture_row(p_tex,  9, "...1.1.1.1.1....");
  texture_row(p_tex, 10, "....11.111......");
  texture_row(p_tex, 11, ".....1.11.......");
  texture_row(p_tex, 12, "......111.......");
  texture_row(p_tex, 13, "......11........");
  texture_row(p_tex, 14, "......1.........");
  texture_row(p_tex, 15, "......1.........");
  texture_row(p_tex, 16, "......1.........");
}

void make_texture_item_stick(Integer p_tex)
// ----------------------------------------------------------------
// Item picture: a stick (sprite)
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 40 , 28 , 12);
  texture_set_palette(p_tex, 4, 104, 76 , 44);
  texture_set_palette(p_tex, 5, 150, 112, 66);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "............11..");
  texture_row(p_tex,  4, "...........1551.");
  texture_row(p_tex,  5, "..........15541.");
  texture_row(p_tex,  6, ".........15441..");
  texture_row(p_tex,  7, "........15441...");
  texture_row(p_tex,  8, ".......15441....");
  texture_row(p_tex,  9, "......15441.....");
  texture_row(p_tex, 10, ".....15441......");
  texture_row(p_tex, 11, "....15441.......");
  texture_row(p_tex, 12, "...15441........");
  texture_row(p_tex, 13, "..15441.........");
  texture_row(p_tex, 14, ".1441...........");
  texture_row(p_tex, 15, ".111............");
  texture_row(p_tex, 16, "................");
}

void make_texture_pig(Integer p_tex, Integer p_part)
// ----------------------------------------------------------------
// The faces of a pig: face with eyes (p_part 1), head side (2),
// body side (3), back and belly (4), ends of the body (5), leg with
// a dark trotter (6) and the snout (7)
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 238, 156, 156);   // pink skin
  texture_set_palette(p_tex, 2, 220, 132, 136);   // darker pink
  texture_set_palette(p_tex, 3, 248, 186, 184);   // light pink
  texture_set_palette(p_tex, 4, 24 , 20 , 22 );   // eyes, nostrils
  texture_set_palette(p_tex, 5, 250, 250, 250);   // whites of the eyes
  texture_set_palette(p_tex, 6, 236, 140, 150);   // snout
  texture_set_palette(p_tex, 7, 160, 96 , 96 );   // trotters
  texture_set_palette(p_tex, 8, 200, 116, 120);   // shadow
  texture_fill(p_tex, 1);
  if (p_part == 1) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.16, 51);
    texture_fill_rect(p_tex, 3 , 7, 5 , 8, 5);       // eyes: white, then the pupil inside
    texture_fill_rect(p_tex, 12, 7, 14, 8, 5);
    texture_fill_rect(p_tex, 4 , 7, 5 , 8, 4);
    texture_fill_rect(p_tex, 12, 7, 13, 8, 4);
    texture_fill_rect(p_tex, 5 , 12, 12, 15, 8);     // shadow under the snout
  } else if (p_part == 2) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 53);
    texture_fill_rect(p_tex, 1, 1, 3, 4, 2);         // the ear
  } else if (p_part == 3) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 55);
    texture_blotch   (p_tex, 3, 6, 0.0, 0.14, 57);
    texture_fill_rect(p_tex, 1, 14, 16, 16, 8);      // belly shadow
  } else if (p_part == 4) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 59);
    texture_blotch   (p_tex, 3, 6, 0.0, 0.16, 61);
  } else if (p_part == 5) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 63);
    texture_fill_rect(p_tex, 8, 5, 9, 6, 6);         // a curly tail at the back end
    texture_fill_rect(p_tex, 9, 4, 10, 5, 6);
  } else if (p_part == 6) {
    texture_blotch   (p_tex, 2, 4, 0.0, 0.18, 65);
    texture_fill_rect(p_tex, 1, 13, 16, 16, 7);      // trotters
  } else {
    texture_fill     (p_tex, 6);
    texture_fill_rect(p_tex, 1, 1, 16, 2, 2);        // rim
    texture_fill_rect(p_tex, 3, 6, 6, 11, 4);        // nostrils
    texture_fill_rect(p_tex, 11, 6, 14, 11, 4);
  }
}

void make_texture_item_porkchop(Integer p_tex, Integer p_cooked)
// ----------------------------------------------------------------
// Item picture: a chop with a rim of fat, pink when raw and brown
// when cooked
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 84 , 34 , 34 );
  texture_set_palette(p_tex, 2, 232, 128, 132);
  texture_set_palette(p_tex, 3, 250, 226, 214);
  texture_set_palette(p_tex, 4, 200, 92 , 100);
  if (p_cooked) {
    texture_set_palette(p_tex, 1, 54 , 30 , 16 );
    texture_set_palette(p_tex, 2, 160, 98 , 54 );
    texture_set_palette(p_tex, 3, 226, 196, 140);
    texture_set_palette(p_tex, 4, 118, 68 , 36 );
  }
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, ".........111....");
  texture_row(p_tex,  4, ".......1133311..");
  texture_row(p_tex,  5, ".....113222231..");
  texture_row(p_tex,  6, "....13222442231.");
  texture_row(p_tex,  7, "...132224422231.");
  texture_row(p_tex,  8, "..1322222222231.");
  texture_row(p_tex,  9, "..1322244222231.");
  texture_row(p_tex, 10, ".13222244222331.");
  texture_row(p_tex, 11, ".1322222222331..");
  texture_row(p_tex, 12, ".132222233311...");
  texture_row(p_tex, 13, "..13333311......");
  texture_row(p_tex, 14, "...11111........");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

void make_texture_item_beef(Integer p_tex, Integer p_cooked)
// ----------------------------------------------------------------
// Item picture: a steak, red when raw and brown when cooked
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 60 , 20 , 16 );
  texture_set_palette(p_tex, 2, 196, 58 , 54 );
  texture_set_palette(p_tex, 3, 232, 160, 150);
  texture_set_palette(p_tex, 4, 156, 38 , 36 );
  if (p_cooked) {
    texture_set_palette(p_tex, 1, 50 , 28 , 14 );
    texture_set_palette(p_tex, 2, 136, 82 , 48 );
    texture_set_palette(p_tex, 3, 176, 120, 74 );
    texture_set_palette(p_tex, 4, 92 , 54 , 32 );
  }
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "......1111......");
  texture_row(p_tex,  4, "....11222211....");
  texture_row(p_tex,  5, "...1223322221...");
  texture_row(p_tex,  6, "..122333222221..");
  texture_row(p_tex,  7, "..123322244221..");
  texture_row(p_tex,  8, ".12222224442221.");
  texture_row(p_tex,  9, ".12244222222221.");
  texture_row(p_tex, 10, ".12244222233321.");
  texture_row(p_tex, 11, "..1222222333221.");
  texture_row(p_tex, 12, "..112222222211..");
  texture_row(p_tex, 13, "....11122111....");
  texture_row(p_tex, 14, ".......11.......");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

void make_texture_iron_ore(Integer p_tex)
// ----------------------------------------------------------------
// Stone with tan and rusty flecks of iron
// ----------------------------------------------------------------
{
  make_texture_stone(p_tex);
  texture_set_palette(p_tex, 4, 216, 175, 147);
  texture_set_palette(p_tex, 5, 175, 140, 119);
  texture_fill_rect(p_tex, 3 , 3 , 4 , 4 , 4);
  texture_fill_rect(p_tex, 5 , 4 , 5 , 5 , 5);
  texture_fill_rect(p_tex, 11, 4 , 12, 5 , 4);
  texture_fill_rect(p_tex, 12, 6 , 13, 6 , 5);
  texture_fill_rect(p_tex, 6 , 10, 7 , 11, 4);
  texture_fill_rect(p_tex, 8 , 11, 8 , 12, 5);
  texture_fill_rect(p_tex, 12, 12, 13, 13, 4);
  texture_fill_rect(p_tex, 2 , 13, 3 , 13, 5);
}

void make_texture_item_ingot(Integer p_tex)
// ----------------------------------------------------------------
// Item picture: an iron ingot
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 60 , 60 , 64 );
  texture_set_palette(p_tex, 2, 160, 160, 164);
  texture_set_palette(p_tex, 3, 214, 214, 218);
  texture_set_palette(p_tex, 4, 250, 250, 252);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "................");
  texture_row(p_tex,  4, "................");
  texture_row(p_tex,  5, "................");
  texture_row(p_tex,  6, ".......1111111..");
  texture_row(p_tex,  7, ".....1144433331.");
  texture_row(p_tex,  8, "...113333333221.");
  texture_row(p_tex,  9, ".11333333332221.");
  texture_row(p_tex, 10, "1433333332221...");
  texture_row(p_tex, 11, "13333332221.....");
  texture_row(p_tex, 12, "1222222211......");
  texture_row(p_tex, 13, ".1111111........");
  texture_row(p_tex, 14, "................");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

void make_texture_bed_top(Integer p_tex)
// ----------------------------------------------------------------
// Top of a bed: a red blanket with a white pillow at one end
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 176, 36 , 36 );
  texture_set_palette(p_tex, 2, 140, 24 , 26 );
  texture_set_palette(p_tex, 3, 236, 232, 226);
  texture_set_palette(p_tex, 4, 200, 196, 190);
  texture_set_palette(p_tex, 5, 120, 86 , 50 );
  texture_fill     (p_tex, 1);
  texture_fill_rect(p_tex, 1 , 1 , 16, 1 , 5);
  texture_fill_rect(p_tex, 1 , 16, 16, 16, 5);
  texture_fill_rect(p_tex, 1 , 1 , 1 , 16, 5);
  texture_fill_rect(p_tex, 16, 1 , 16, 16, 5);
  texture_fill_rect(p_tex, 3 , 2 , 14, 5 , 3);
  texture_fill_rect(p_tex, 3 , 5 , 14, 5 , 4);
  texture_fill_rect(p_tex, 2 , 7 , 15, 7 , 2);
  texture_fill_rect(p_tex, 2 , 11, 15, 11, 2);
}

void make_texture_bed_side(Integer p_tex, Integer p_head)
// ----------------------------------------------------------------
// Side of a bed's mattress: red blanket over a wooden frame; the
// head half (p_head) shows the pillow's edge at its head end (u
// runs from the foot to the head)
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 176, 36 , 36 );
  texture_set_palette(p_tex, 2, 140, 24 , 26 );
  texture_set_palette(p_tex, 3, 150, 112, 66 );
  texture_set_palette(p_tex, 4, 104, 76 , 44 );
  texture_set_palette(p_tex, 5, 236, 232, 226);
  texture_fill     (p_tex, 3);
  texture_fill_rect(p_tex, 1 , 1 , 16, 9 , 1);
  texture_fill_rect(p_tex, 1 , 9 , 16, 9 , 2);
  texture_fill_rect(p_tex, 1 , 10, 16, 10, 4);
  texture_fill_rect(p_tex, 1 , 16, 16, 16, 4);
  if (p_head) texture_fill_rect(p_tex, 11, 1 , 15, 4 , 5);
}

void make_texture_bed_end(Integer p_tex, Integer p_head)
// ----------------------------------------------------------------
// An end of a bed's mattress: the blanket (or at the head the
// pillow under it) over the wooden frame
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 176, 36 , 36 );
  texture_set_palette(p_tex, 2, 140, 24 , 26 );
  texture_set_palette(p_tex, 3, 150, 112, 66 );
  texture_set_palette(p_tex, 4, 104, 76 , 44 );
  texture_set_palette(p_tex, 5, 236, 232, 226);
  texture_fill     (p_tex, 3);
  texture_fill_rect(p_tex, 1 , 1 , 16, 9 , 1);
  texture_fill_rect(p_tex, 1 , 9 , 16, 9 , 2);
  if (p_head) texture_fill_rect(p_tex, 3 , 1 , 14, 4 , 5);
  texture_fill_rect(p_tex, 1 , 10, 16, 10, 4);
  texture_fill_rect(p_tex, 1 , 16, 16, 16, 4);
}

void make_texture_bed_leg(Integer p_tex)
// ----------------------------------------------------------------
// A bed's leg: dark wood
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 104, 76 , 44 );
  texture_set_palette(p_tex, 2, 82 , 58 , 32 );
  texture_fill     (p_tex, 1);
  texture_blotch   (p_tex, 2, 4, 0.0, 0.35, 91);
}

void make_texture_chest_part(Integer p_tex, Integer p_part, Integer p_type)
// ----------------------------------------------------------------
// Face p_part (CHEST_*) of a chest of type CHEST_*: planks in a dark
// rim, with no rim along the edge where the halves of a double chest
// meet; the lid's sides have their seam at the bottom, the base's at
// the top. The latch is iron.
// ----------------------------------------------------------------
{
  Integer l_inner = 0;   // 1 left column, 2 right column, 3 top row, 4 bottom row

  texture_set_palette(p_tex, 1, 160, 112, 52 );
  texture_set_palette(p_tex, 2, 128, 86 , 38 );
  texture_set_palette(p_tex, 3, 82 , 54 , 24 );
  texture_set_palette(p_tex, 4, 200, 200, 204);
  texture_set_palette(p_tex, 5, 60 , 60 , 64 );

  if (p_part == CHEST_LATCH) {
    texture_fill     (p_tex, 4);
    texture_fill_rect(p_tex, 1, 13, 16, 16, 5);
    return;
  }

  texture_fill     (p_tex, 1);
  texture_fill_rect(p_tex, 2, 5 , 15, 5 , 2);
  texture_fill_rect(p_tex, 2, 10, 15, 10, 2);
  // the edge against the other half of a double chest (see
  // render_add_box for which way each face's u and v run)
  if (p_type == CHEST_RIGHT) {
    if (p_part == CHEST_LID_FRONT || p_part == CHEST_BASE_FRONT) l_inner = 1;
    if (p_part == CHEST_LID_BACK  || p_part == CHEST_BASE_BACK ) l_inner = 2;
    if (p_part == CHEST_LID_TOP   ) l_inner = 3;
    if (p_part == CHEST_BASE_BOTTOM) l_inner = 4;
  }
  if (p_type == CHEST_LEFT) {
    if (p_part == CHEST_LID_FRONT || p_part == CHEST_BASE_FRONT) l_inner = 2;
    if (p_part == CHEST_LID_BACK  || p_part == CHEST_BASE_BACK ) l_inner = 1;
    if (p_part == CHEST_LID_TOP   ) l_inner = 4;
    if (p_part == CHEST_BASE_BOTTOM) l_inner = 3;
  }
  if (l_inner != 3) texture_fill_rect(p_tex, 1 , 1 , 16, 1 , 3);
  if (l_inner != 4) texture_fill_rect(p_tex, 1 , 16, 16, 16, 3);
  if (l_inner != 1) texture_fill_rect(p_tex, 1 , 1 , 1 , 16, 3);
  if (l_inner != 2) texture_fill_rect(p_tex, 16, 1 , 16, 16, 3);
  // the seam between the lid and the base is darker
  if (p_part == CHEST_LID_FRONT || p_part == CHEST_LID_SIDE || p_part == CHEST_LID_BACK) {
    texture_fill_rect(p_tex, 1, 15, 16, 16, 3);
  }
  if (p_part == CHEST_BASE_FRONT || p_part == CHEST_BASE_SIDE || p_part == CHEST_BASE_BACK) {
    texture_fill_rect(p_tex, 1, 1, 16, 2, 3);
  }
}

void make_texture_zombie(Integer p_tex, Integer p_part)
// ----------------------------------------------------------------
// The undead walker: green skin (p_part 1), its face (2), a torn
// blue shirt (3), dark trousers (4), the side of its shirt (5) and
// an arm held out in front, sleeve at the shoulder end (6). The top
// of the head (7) has dark matted hair.
// ----------------------------------------------------------------
{
  if (p_part == 5) {
    texture_set_palette(p_tex, 1, 40 , 120, 136);
    texture_set_palette(p_tex, 2, 30 , 96 , 110);
    texture_fill  (p_tex, 1);
    texture_blotch(p_tex, 2, 4, 0.0, 0.30, 63);
    return;
  }
  if (p_part == 6) {
    texture_set_palette(p_tex, 1, 96 , 150, 82 );
    texture_set_palette(p_tex, 2, 78 , 126, 66 );
    texture_set_palette(p_tex, 3, 40 , 120, 136);
    texture_fill     (p_tex, 1);
    texture_blotch   (p_tex, 2, 4, 0.0, 0.32, 73);
    texture_fill_rect(p_tex, 1, 1, 5, 16, 3);          // sleeve
    return;
  }
  if (p_part == 3) {
    texture_set_palette(p_tex, 1, 40 , 120, 136);
    texture_set_palette(p_tex, 2, 30 , 96 , 110);
    texture_set_palette(p_tex, 3, 90 , 140, 80 );
    texture_fill  (p_tex, 1);
    texture_blotch(p_tex, 2, 4, 0.0, 0.30, 61);
    texture_fill_rect(p_tex, 6, 14, 8, 16, 3);
    return;
  }
  if (p_part == 4) {
    texture_set_palette(p_tex, 1, 58 , 52 , 120);
    texture_set_palette(p_tex, 2, 44 , 40 , 96 );
    texture_fill  (p_tex, 1);
    texture_blotch(p_tex, 2, 4, 0.0, 0.30, 67);
    return;
  }
  texture_set_palette(p_tex, 1, 96 , 150, 82 );
  texture_set_palette(p_tex, 2, 78 , 126, 66 );
  texture_set_palette(p_tex, 3, 20 , 24 , 20 );
  texture_set_palette(p_tex, 4, 60 , 96 , 50 );
  texture_fill  (p_tex, 1);
  texture_blotch(p_tex, 2, 4, 0.0, 0.32, 71);
  if (p_part == 7) texture_blotch(p_tex, 4, 4, 0.0, 0.45, 75);
  if (p_part == 2) {
    texture_fill_rect(p_tex, 1 , 1 , 16, 2 , 4);       // hairline
    texture_fill_rect(p_tex, 3 , 6 , 6 , 8 , 3);
    texture_fill_rect(p_tex, 11, 6 , 14, 8 , 3);
    texture_fill_rect(p_tex, 7 , 10, 10, 11, 4);
    texture_fill_rect(p_tex, 5 , 13, 12, 14, 3);
  }
}

void make_texture_chest(Integer p_tex, Integer p_side)
// ----------------------------------------------------------------
// A wooden chest: dark rim and planks; the sides (p_side) have the
// lid seam and an iron latch
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 160, 112, 52 );
  texture_set_palette(p_tex, 2, 128, 86 , 38 );
  texture_set_palette(p_tex, 3, 82 , 54 , 24 );
  texture_set_palette(p_tex, 4, 200, 200, 204);
  texture_set_palette(p_tex, 5, 60 , 60 , 64 );
  texture_fill     (p_tex, 1);
  texture_fill_rect(p_tex, 1 , 1 , 16, 1 , 3);
  texture_fill_rect(p_tex, 1 , 16, 16, 16, 3);
  texture_fill_rect(p_tex, 1 , 1 , 1 , 16, 3);
  texture_fill_rect(p_tex, 16, 1 , 16, 16, 3);
  texture_fill_rect(p_tex, 2 , 6 , 15, 6 , 2);
  texture_fill_rect(p_tex, 2 , 11, 15, 11, 2);
  if (p_side) {
    texture_fill_rect(p_tex, 2 , 6 , 15, 6 , 3);
    texture_fill_rect(p_tex, 7 , 5 , 10, 9 , 4);
    texture_fill_rect(p_tex, 8 , 7 , 9 , 8 , 5);
  }
}

void make_texture_torch(Integer p_tex)
// ----------------------------------------------------------------
// Picture of a torch: a stick with a glowing tip
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 104, 76 , 44 );
  texture_set_palette(p_tex, 2, 150, 112, 66 );
  texture_set_palette(p_tex, 3, 255, 236, 120);
  texture_set_palette(p_tex, 4, 255, 170, 40 );
  texture_set_palette(p_tex, 5, 210, 90 , 20 );
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, ".......5........");
  texture_row(p_tex,  4, "......545.......");
  texture_row(p_tex,  5, "......4345......");
  texture_row(p_tex,  6, ".....54334......");
  texture_row(p_tex,  7, "......4334......");
  texture_row(p_tex,  8, "......5445......");
  texture_row(p_tex,  9, ".......21.......");
  texture_row(p_tex, 10, ".......21.......");
  texture_row(p_tex, 11, ".......21.......");
  texture_row(p_tex, 12, ".......21.......");
  texture_row(p_tex, 13, ".......21.......");
  texture_row(p_tex, 14, ".......21.......");
  texture_row(p_tex, 15, ".......21.......");
  texture_row(p_tex, 16, ".......21.......");
}

void make_texture_glass(Integer p_tex)
// ----------------------------------------------------------------
// Glass: a pale frame and a few streaks; the middle is see-through
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 206, 232, 238);
  texture_set_palette(p_tex, 2, 160, 196, 206);
  texture_set_palette(p_tex, 3, 244, 252, 252);
  texture_row(p_tex,  1, "1111111111111111");
  texture_row(p_tex,  2, "1..............2");
  texture_row(p_tex,  3, "1.3............2");
  texture_row(p_tex,  4, "1..3...........2");
  texture_row(p_tex,  5, "1...3..........2");
  texture_row(p_tex,  6, "1..............2");
  texture_row(p_tex,  7, "1..............2");
  texture_row(p_tex,  8, "1..............2");
  texture_row(p_tex,  9, "1..............2");
  texture_row(p_tex, 10, "1..........3...2");
  texture_row(p_tex, 11, "1...........3..2");
  texture_row(p_tex, 12, "1............3.2");
  texture_row(p_tex, 13, "1..............2");
  texture_row(p_tex, 14, "1..............2");
  texture_row(p_tex, 15, "1..............2");
  texture_row(p_tex, 16, "2222222222222222");
}

void make_texture_item_rotten_flesh(Integer p_tex)
// ----------------------------------------------------------------
// Item picture: a greenish lump of rotten flesh
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 70 , 40 , 30 );
  texture_set_palette(p_tex, 2, 150, 84 , 60 );
  texture_set_palette(p_tex, 3, 110, 130, 70 );
  texture_set_palette(p_tex, 4, 190, 120, 90 );
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "................");
  texture_row(p_tex,  4, "......111.......");
  texture_row(p_tex,  5, "....11223111....");
  texture_row(p_tex,  6, "...1224223321...");
  texture_row(p_tex,  7, "..12332222241...");
  texture_row(p_tex,  8, "..12222432221...");
  texture_row(p_tex,  9, ".122342223321...");
  texture_row(p_tex, 10, ".123322222221...");
  texture_row(p_tex, 11, "..1222234321....");
  texture_row(p_tex, 12, "...112222211....");
  texture_row(p_tex, 13, ".....11111......");
  texture_row(p_tex, 14, "................");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

void make_texture_item_coal(Integer p_tex)
// ----------------------------------------------------------------
// Item picture: a lump of coal
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 14 , 14 , 16 );
  texture_set_palette(p_tex, 2, 46 , 46 , 50 );
  texture_set_palette(p_tex, 3, 90 , 90 , 98 );
  texture_set_palette(p_tex, 4, 30 , 30 , 34 );
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "................");
  texture_row(p_tex,  4, ".......111......");
  texture_row(p_tex,  5, ".....1122211....");
  texture_row(p_tex,  6, "....122332221...");
  texture_row(p_tex,  7, "...12233222221..");
  texture_row(p_tex,  8, "...12322222221..");
  texture_row(p_tex,  9, "..122222222221..");
  texture_row(p_tex, 10, "..122224222221..");
  texture_row(p_tex, 11, "..112222222211..");
  texture_row(p_tex, 12, "...1122222211...");
  texture_row(p_tex, 13, ".....111111.....");
  texture_row(p_tex, 14, "................");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

void make_tool_palette(Integer p_tex, Integer p_tier)
// ----------------------------------------------------------------
// Colours of a tool picture: 1 outline, 2 and 3 the head (wood or
// stone), 4 and 5 the wooden handle
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 40 , 28 , 12 );
  texture_set_palette(p_tex, 4, 104, 76 , 44 );
  texture_set_palette(p_tex, 5, 150, 112, 66 );
  if (p_tier == TIER_DIAMOND) {
    texture_set_palette(p_tex, 2, 40 , 180, 176);
    texture_set_palette(p_tex, 3, 130, 236, 232);
  } else if (p_tier == TIER_IRON) {
    texture_set_palette(p_tex, 2, 196, 196, 196);
    texture_set_palette(p_tex, 3, 236, 236, 236);
  } else if (p_tier == TIER_STONE) {
    texture_set_palette(p_tex, 2, 118, 118, 118);
    texture_set_palette(p_tex, 3, 170, 170, 170);
  } else {
    texture_set_palette(p_tex, 2, 150, 112, 66 );
    texture_set_palette(p_tex, 3, 188, 152, 98 );
  }
}

void make_texture_item_pickaxe(Integer p_tex, Integer p_tier)
// ----------------------------------------------------------------
// Item picture: a pickaxe
// ----------------------------------------------------------------
{
  make_tool_palette(p_tex, p_tier);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "....111111......");
  texture_row(p_tex,  3, "...12333321.....");
  texture_row(p_tex,  4, "....1112222.1...");
  texture_row(p_tex,  5, "........11221...");
  texture_row(p_tex,  6, "........154121..");
  texture_row(p_tex,  7, ".......1541.121.");
  texture_row(p_tex,  8, "......15441..11.");
  texture_row(p_tex,  9, ".....15441......");
  texture_row(p_tex, 10, "....15441.......");
  texture_row(p_tex, 11, "...15441........");
  texture_row(p_tex, 12, "..15441.........");
  texture_row(p_tex, 13, ".15441..........");
  texture_row(p_tex, 14, ".1441...........");
  texture_row(p_tex, 15, ".111............");
  texture_row(p_tex, 16, "................");
}

void make_texture_item_axe(Integer p_tex, Integer p_tier)
// ----------------------------------------------------------------
// Item picture: an axe
// ----------------------------------------------------------------
{
  make_tool_palette(p_tex, p_tier);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "........111.....");
  texture_row(p_tex,  3, ".......12331....");
  texture_row(p_tex,  4, "......1233331...");
  texture_row(p_tex,  5, "......12333331..");
  texture_row(p_tex,  6, ".......1223331..");
  texture_row(p_tex,  7, "........15411...");
  texture_row(p_tex,  8, ".......15441....");
  texture_row(p_tex,  9, "......15441.....");
  texture_row(p_tex, 10, ".....15441......");
  texture_row(p_tex, 11, "....15441.......");
  texture_row(p_tex, 12, "...15441........");
  texture_row(p_tex, 13, "..15441.........");
  texture_row(p_tex, 14, ".1441...........");
  texture_row(p_tex, 15, ".111............");
  texture_row(p_tex, 16, "................");
}

void make_texture_item_shovel(Integer p_tex, Integer p_tier)
// ----------------------------------------------------------------
// Item picture: a shovel
// ----------------------------------------------------------------
{
  make_tool_palette(p_tex, p_tier);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "...........111..");
  texture_row(p_tex,  3, "..........12331.");
  texture_row(p_tex,  4, ".........123321.");
  texture_row(p_tex,  5, ".........122321.");
  texture_row(p_tex,  6, "..........1221..");
  texture_row(p_tex,  7, ".........1541...");
  texture_row(p_tex,  8, "........15441...");
  texture_row(p_tex,  9, ".......15441....");
  texture_row(p_tex, 10, "......15441.....");
  texture_row(p_tex, 11, ".....15441......");
  texture_row(p_tex, 12, "....15441.......");
  texture_row(p_tex, 13, "...15441........");
  texture_row(p_tex, 14, "..1441..........");
  texture_row(p_tex, 15, "..111...........");
  texture_row(p_tex, 16, "................");
}

void make_texture_item_sword(Integer p_tex, Integer p_tier)
// ----------------------------------------------------------------
// Item picture: a sword
// ----------------------------------------------------------------
{
  make_tool_palette(p_tex, p_tier);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "............111.");
  texture_row(p_tex,  3, "...........13321");
  texture_row(p_tex,  4, "..........133321");
  texture_row(p_tex,  5, ".........133321.");
  texture_row(p_tex,  6, "........133321..");
  texture_row(p_tex,  7, ".......133321...");
  texture_row(p_tex,  8, "..1...133321....");
  texture_row(p_tex,  9, "..11.133321.....");
  texture_row(p_tex, 10, "...113321.......");
  texture_row(p_tex, 11, "...11321........");
  texture_row(p_tex, 12, "..15411.........");
  texture_row(p_tex, 13, ".1541.11........");
  texture_row(p_tex, 14, ".141...1........");
  texture_row(p_tex, 15, ".11.............");
  texture_row(p_tex, 16, "................");
}

void make_texture_destroy(Integer p_tex, Integer p_stage)
// ----------------------------------------------------------------
// Crack stage 1..DESTROY_STAGES drawn over a block being broken:
// pixel cracks that grow out from the middle along a few branches.
// Each stage shows a longer stretch of every branch, so a stage
// contains all the pixels of the stages before it.
// ----------------------------------------------------------------
{
  Integer l_branch = 0;
  Integer l_step   = 0;
  Integer l_steps  = 0;
  Integer l_u      = 0;
  Integer l_v      = 0;
  Integer l_du     = 0;
  Integer l_dv     = 0;
  Real    l_pick   = 0.0;

  texture_set_palette(p_tex, 1, 40, 38, 36);
  texture_set_palette(p_tex, 2, 72, 68, 64);
  texture_fill(p_tex, TEX_TRANSPARENT);
  l_steps = floor_divide(p_stage * 9, DESTROY_STAGES);

  for (l_branch = 1; l_branch <= 6; ++l_branch) {
    l_u  = 8 + floor_integer(hash_real(l_branch * 3.1, 1.0, 7.0) * 2.0);
    l_v  = 8 + floor_integer(hash_real(l_branch * 3.1, 2.0, 7.0) * 2.0);
    // each branch heads off in its own direction around the middle
    l_du = 1;
    l_dv = 0;
    if (l_branch == 2) { l_du = -1; l_dv =  1; }
    if (l_branch == 3) { l_du =  0; l_dv = -1; }
    if (l_branch == 4) { l_du =  1; l_dv =  1; }
    if (l_branch == 5) { l_du = -1; l_dv = -1; }
    if (l_branch == 6) { l_du = -1; l_dv =  0; }
    for (l_step = 1; l_step <= l_steps; ++l_step) {
      if (l_u < 1 || l_u > TEX_SIZE || l_v < 1 || l_v > TEX_SIZE) break;
      texture_set(p_tex, l_u, l_v, 1);
      // a lighter pixel beside the crack now and then
      if (hash_real(l_branch * 1.3, l_step * 1.0, 9.0) < 0.3) {
        if (l_u + 1 <= TEX_SIZE) {
          if (texture_get(p_tex, l_u + 1, l_v) == TEX_TRANSPARENT) texture_set(p_tex, l_u + 1, l_v, 2);
        }
      }
      // wander: mostly straight on, sometimes a step to one side
      l_pick = hash_real(l_branch * 2.9, l_step * 1.0, 4.0);
      if (l_pick < 0.25) {
        l_u = l_u + l_dv;
        l_v = l_v + l_du;
      } else if (l_pick < 0.5) {
        l_u = l_u - l_dv;
        l_v = l_v - l_du;
      }
      l_u = l_u + l_du;
      l_v = l_v + l_dv;
    }
  }
}

void make_texture_heart(Integer p_tex, Integer p_fill)
// ----------------------------------------------------------------
// A health bar heart. p_fill 0 is the empty container: one solid
// dark heart. 2 (full) and 1 (the left half) are only the red inside
// with a shine, drawn over the container. Each is a few large
// rectangles: an outline in its own colour broke a heart into ~36
// one-pixel pieces, and the bar drew 20 of them every frame.
// ----------------------------------------------------------------
{
  Integer l_u = 0;
  Integer l_v = 0;

  texture_set_palette(p_tex, 1, 36 , 14 , 14 );
  texture_set_palette(p_tex, 2, 220, 30 , 30 );
  texture_set_palette(p_tex, 3, 255, 150, 150);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "..1111....1111..");
  texture_row(p_tex,  4, ".111111..111111.");
  texture_row(p_tex,  5, "1111111111111111");
  texture_row(p_tex,  6, "1111111111111111");
  texture_row(p_tex,  7, "1111111111111111");
  texture_row(p_tex,  8, "1111111111111111");
  texture_row(p_tex,  9, ".11111111111111.");
  texture_row(p_tex, 10, "..111111111111..");
  texture_row(p_tex, 11, "...1111111111...");
  texture_row(p_tex, 12, "....11111111....");
  texture_row(p_tex, 13, ".....111111.....");
  texture_row(p_tex, 14, "......1111......");
  texture_row(p_tex, 15, ".......11.......");
  texture_row(p_tex, 16, "................");
  if (p_fill == 0) return;
  // the inside: one pixel in from the edge of the container
  texture_row(p_tex,  3, "................");
  texture_row(p_tex,  4, "..2222....2222..");
  texture_row(p_tex,  5, ".22222222222222.");
  texture_row(p_tex,  6, ".22222222222222.");
  texture_row(p_tex,  7, ".22222222222222.");
  texture_row(p_tex,  8, ".22222222222222.");
  texture_row(p_tex,  9, "..222222222222..");
  texture_row(p_tex, 10, "...2222222222...");
  texture_row(p_tex, 11, "....22222222....");
  texture_row(p_tex, 12, ".....222222.....");
  texture_row(p_tex, 13, "......2222......");
  texture_row(p_tex, 14, ".......22.......");
  texture_row(p_tex, 15, "................");
  texture_fill_rect(p_tex, 3, 5, 4, 6, 3);   // shine
  if (p_fill == 2) return;
  for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
    for (l_u = 9; l_u <= TEX_SIZE; ++l_u) texture_set(p_tex, l_u, l_v, TEX_TRANSPARENT);
  }
}

void make_texture_door(Integer p_tex, Integer p_top)
// ----------------------------------------------------------------
// One half of an oak door: planks in a frame; the top half has a
// four pane window you can see through
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 150, 112, 66 );
  texture_set_palette(p_tex, 2, 120, 88 , 50 );
  texture_set_palette(p_tex, 3, 96 , 70 , 40 );
  texture_set_palette(p_tex, 4, 60 , 60 , 64 );
  texture_fill     (p_tex, 1);
  texture_fill_rect(p_tex, 1 , 1 , 1 , 16, 3);
  texture_fill_rect(p_tex, 16, 1 , 16, 16, 3);
  texture_fill_rect(p_tex, 1 , 1 , 16, 1 , 3);
  texture_fill_rect(p_tex, 1 , 16, 16, 16, 3);
  texture_fill_rect(p_tex, 6 , 2 , 6 , 15, 2);
  texture_fill_rect(p_tex, 11, 2 , 11, 15, 2);
  if (p_top) {
    texture_fill_rect(p_tex, 4 , 4 , 7 , 7 , TEX_TRANSPARENT);
    texture_fill_rect(p_tex, 10, 4 , 13, 7 , TEX_TRANSPARENT);
    texture_fill_rect(p_tex, 4 , 10, 7 , 13, TEX_TRANSPARENT);
    texture_fill_rect(p_tex, 10, 10, 13, 13, TEX_TRANSPARENT);
  } else {
    texture_fill_rect(p_tex, 3 , 4 , 14, 4 , 2);
    texture_fill_rect(p_tex, 3 , 10, 14, 10, 2);
    texture_fill_rect(p_tex, 13, 7 , 14, 8 , 4);
  }
}

void make_texture_item_door(Integer p_tex)
// ----------------------------------------------------------------
// Picture of a door for the inventory
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 150, 112, 66 );
  texture_set_palette(p_tex, 2, 96 , 70 , 40 );
  texture_set_palette(p_tex, 3, 60 , 60 , 64 );
  texture_row(p_tex,  1, "....22222222....");
  texture_row(p_tex,  2, "....21111112....");
  texture_row(p_tex,  3, "....21.21.12....");
  texture_row(p_tex,  4, "....21.21.12....");
  texture_row(p_tex,  5, "....21111112....");
  texture_row(p_tex,  6, "....21.21.12....");
  texture_row(p_tex,  7, "....21.21.12....");
  texture_row(p_tex,  8, "....21111112....");
  texture_row(p_tex,  9, "....21111112....");
  texture_row(p_tex, 10, "....22222212....");
  texture_row(p_tex, 11, "....21111312....");
  texture_row(p_tex, 12, "....21111112....");
  texture_row(p_tex, 13, "....22222212....");
  texture_row(p_tex, 14, "....21111112....");
  texture_row(p_tex, 15, "....21111112....");
  texture_row(p_tex, 16, "....22222222....");
}

void make_texture_bed_foot_top(Integer p_tex)
// ----------------------------------------------------------------
// Top of a bed's foot half: blanket only, folded over at the end
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 176, 36 , 36 );
  texture_set_palette(p_tex, 2, 140, 24 , 26 );
  texture_set_palette(p_tex, 5, 120, 86 , 50 );
  texture_fill     (p_tex, 1);
  texture_fill_rect(p_tex, 1 , 1 , 16, 1 , 5);
  texture_fill_rect(p_tex, 1 , 16, 16, 16, 5);
  texture_fill_rect(p_tex, 1 , 1 , 1 , 16, 5);
  texture_fill_rect(p_tex, 16, 1 , 16, 16, 5);
  texture_fill_rect(p_tex, 2 , 5 , 15, 5 , 2);
  texture_fill_rect(p_tex, 2 , 12, 15, 13, 2);
}

void make_texture_person(Integer p_tex, Integer p_part)
// ----------------------------------------------------------------
// Another player: a face (p_part 1), the side (2) and top (3) of a
// head of brown hair, an orange shirt (4) and its side (5), an arm
// with the sleeve at the shoulder (6), grey trousers (7) and the
// back of the head (8). A skin (pack_apply_skin) replaces them all.
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 214, 164, 128);   // skin
  texture_set_palette(p_tex, 2, 196, 146, 112);
  texture_set_palette(p_tex, 3, 96 , 62 , 36 );   // hair
  texture_set_palette(p_tex, 4, 74 , 46 , 26 );
  texture_set_palette(p_tex, 5, 214, 112, 40 );   // shirt
  texture_set_palette(p_tex, 6, 184, 92 , 30 );
  texture_set_palette(p_tex, 7, 92 , 92 , 104);   // trousers
  texture_set_palette(p_tex, 8, 40 , 40 , 52 );   // eyes, mouth
  if (p_part == 1) {
    texture_fill     (p_tex, 1);
    texture_blotch   (p_tex, 2, 4, 0.0, 0.25, 81);
    texture_fill_rect(p_tex, 1 , 1 , 16, 4 , 3);    // hair
    texture_fill_rect(p_tex, 1 , 5 , 2 , 7 , 3);
    texture_fill_rect(p_tex, 15, 5 , 16, 7 , 3);
    texture_fill_rect(p_tex, 4 , 8 , 6 , 9 , 8);    // eyes
    texture_fill_rect(p_tex, 11, 8 , 13, 9 , 8);
    texture_fill_rect(p_tex, 7 , 11, 10, 11, 2);    // nose
    texture_fill_rect(p_tex, 6 , 13, 11, 13, 8);    // mouth
    return;
  }
  if (p_part == 2) {
    texture_fill     (p_tex, 1);
    texture_blotch   (p_tex, 2, 4, 0.0, 0.25, 83);
    texture_fill_rect(p_tex, 1, 1, 16, 5 , 3);
    texture_fill_rect(p_tex, 9, 6, 16, 9 , 3);      // hair over the back of the head
    texture_blotch   (p_tex, 4, 3, 0.0, 0.20, 85);
    return;
  }
  if (p_part == 3 || p_part == 8) {
    texture_fill  (p_tex, 3);
    texture_blotch(p_tex, 4, 3, 0.0, 0.35, 87);
    return;
  }
  if (p_part == 4 || p_part == 5) {
    texture_fill  (p_tex, 5);
    texture_blotch(p_tex, 6, 4, 0.0, 0.30, 89);
    if (p_part == 4) texture_fill_rect(p_tex, 6, 1, 11, 2, 1);   // neck
    return;
  }
  if (p_part == 6) {
    texture_fill     (p_tex, 1);
    texture_blotch   (p_tex, 2, 4, 0.0, 0.25, 91);
    texture_fill_rect(p_tex, 1, 1, 16, 6, 5);       // sleeve
    return;
  }
  texture_fill  (p_tex, 7);
  texture_blotch(p_tex, 8, 4, 0.0, 0.10, 93);
}

void make_texture_door_edge(Integer p_tex, Integer p_door_tex)
// ----------------------------------------------------------------
// The thin edge of a door: its picture's three outer columns
// stretched across, so squeezed onto the 3 pixel wide edge they look
// like the door's own frame (and follow a resource pack's door)
// ----------------------------------------------------------------
{
  Integer l_u     = 0;
  Integer l_v     = 0;
  Integer l_index = 0;
  Integer l_from  = 0;

  for (l_index = 1; l_index <= PALETTE_SIZE; ++l_index) {
    g_tex_pal_r[texture_palette_index(p_tex, l_index)] = g_tex_pal_r[texture_palette_index(p_door_tex, l_index)];
    g_tex_pal_g[texture_palette_index(p_tex, l_index)] = g_tex_pal_g[texture_palette_index(p_door_tex, l_index)];
    g_tex_pal_b[texture_palette_index(p_tex, l_index)] = g_tex_pal_b[texture_palette_index(p_door_tex, l_index)];
  }
  for (l_v = 1; l_v <= 16; ++l_v) {
    for (l_u = 1; l_u <= 16; ++l_u) {
      l_from = Floor((l_u - 1) * 3.0 / 16.0);
      texture_set(p_tex, l_u, l_v, texture_get(p_door_tex, 1 + l_from, l_v));
    }
  }
}

void make_armour_palette(Integer p_tex)
// ----------------------------------------------------------------
// Colours of iron armour: 1 outline, 2 shadow, 3 iron, 4 shine
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 60 , 60 , 64 );
  texture_set_palette(p_tex, 2, 150, 150, 156);
  texture_set_palette(p_tex, 3, 206, 206, 212);
  texture_set_palette(p_tex, 4, 250, 250, 252);
}

void make_texture_item_armour(Integer p_tex, Integer p_place)
// ----------------------------------------------------------------
// Item picture: a piece of iron armour (p_place ARMOUR_HEAD ..
// ARMOUR_FEET)
// ----------------------------------------------------------------
{
  make_armour_palette(p_tex);
  if (p_place == ARMOUR_HEAD) {
    texture_row(p_tex,  1, "................");
    texture_row(p_tex,  2, "................");
    texture_row(p_tex,  3, "................");
    texture_row(p_tex,  4, "....11111111....");
    texture_row(p_tex,  5, "...1443333331...");
    texture_row(p_tex,  6, "..143333333321..");
    texture_row(p_tex,  7, "..133222222231..");
    texture_row(p_tex,  8, "..1321....1231..");
    texture_row(p_tex,  9, "..1321....1231..");
    texture_row(p_tex, 10, "..1221....1221..");
    texture_row(p_tex, 11, "..111......111..");
    texture_row(p_tex, 12, "................");
    texture_row(p_tex, 13, "................");
    texture_row(p_tex, 14, "................");
    texture_row(p_tex, 15, "................");
    texture_row(p_tex, 16, "................");
    return;
  }
  if (p_place == ARMOUR_CHEST) {
    texture_row(p_tex,  1, "................");
    texture_row(p_tex,  2, ".1111......1111.");
    texture_row(p_tex,  3, ".14331111113341.");
    texture_row(p_tex,  4, ".14333333333341.");
    texture_row(p_tex,  5, ".12333333333321.");
    texture_row(p_tex,  6, ".11233333333211.");
    texture_row(p_tex,  7, "..123333333321..");
    texture_row(p_tex,  8, "..133333333331..");
    texture_row(p_tex,  9, "..133333333331..");
    texture_row(p_tex, 10, "..123333333321..");
    texture_row(p_tex, 11, "..122333333221..");
    texture_row(p_tex, 12, "..122222222221..");
    texture_row(p_tex, 13, "..111111111111..");
    texture_row(p_tex, 14, "................");
    texture_row(p_tex, 15, "................");
    texture_row(p_tex, 16, "................");
    return;
  }
  if (p_place == ARMOUR_LEGS) {
    texture_row(p_tex,  1, "................");
    texture_row(p_tex,  2, "................");
    texture_row(p_tex,  3, "..111111111111..");
    texture_row(p_tex,  4, "..143333333341..");
    texture_row(p_tex,  5, "..133333333331..");
    texture_row(p_tex,  6, "..133322223331..");
    texture_row(p_tex,  7, "..13321..12331..");
    texture_row(p_tex,  8, "..1331....1331..");
    texture_row(p_tex,  9, "..1331....1331..");
    texture_row(p_tex, 10, "..1331....1331..");
    texture_row(p_tex, 11, "..1331....1331..");
    texture_row(p_tex, 12, "..1331....1331..");
    texture_row(p_tex, 13, "..1331....1331..");
    texture_row(p_tex, 14, "..1221....1221..");
    texture_row(p_tex, 15, "..1111....1111..");
    texture_row(p_tex, 16, "................");
    return;
  }
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "................");
  texture_row(p_tex,  4, "................");
  texture_row(p_tex,  5, "................");
  texture_row(p_tex,  6, "................");
  texture_row(p_tex,  7, "................");
  texture_row(p_tex,  8, "..1111....1111..");
  texture_row(p_tex,  9, "..1431....1341..");
  texture_row(p_tex, 10, "..1331....1331..");
  texture_row(p_tex, 11, ".11331....13311.");
  texture_row(p_tex, 12, "1433331..1333341");
  texture_row(p_tex, 13, "1222221..1222221");
  texture_row(p_tex, 14, "1111111..1111111");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

void make_texture_spawn_egg(Integer p_tex, Integer p_red, Integer p_green, Integer p_blue,
                            Integer p_spot_red, Integer p_spot_green, Integer p_spot_blue)
// ----------------------------------------------------------------
// Item picture: a spawn egg in the mob's colour with spots
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, floor_integer(p_red * 0.45), floor_integer(p_green * 0.45), floor_integer(p_blue * 0.45));
  texture_set_palette(p_tex, 2, p_red, p_green, p_blue);
  texture_set_palette(p_tex, 3, min_integer(255, p_red + 60), min_integer(255, p_green + 60), min_integer(255, p_blue + 60));
  texture_set_palette(p_tex, 4, p_spot_red, p_spot_green, p_spot_blue);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "......1111......");
  texture_row(p_tex,  3, ".....122221.....");
  texture_row(p_tex,  4, "....12232221....");
  texture_row(p_tex,  5, "....12322421....");
  texture_row(p_tex,  6, "...1232222221...");
  texture_row(p_tex,  7, "...1222242221...");
  texture_row(p_tex,  8, "..122422222221..");
  texture_row(p_tex,  9, "..122222224221..");
  texture_row(p_tex, 10, "..122242222221..");
  texture_row(p_tex, 11, "..122222222221..");
  texture_row(p_tex, 12, "..124222242221..");
  texture_row(p_tex, 13, "...1222222221...");
  texture_row(p_tex, 14, "....11222211....");
  texture_row(p_tex, 15, "......1111......");
  texture_row(p_tex, 16, "................");
}

void make_texture_armour_icon(Integer p_tex, Integer p_fill)
// ----------------------------------------------------------------
// An armour bar icon (a little chestplate). p_fill 0 is the empty
// one, a solid dark shape; 2 (full) and 1 (the left half) are only
// the iron inside, drawn over it (few rectangles each, like the
// hearts)
// ----------------------------------------------------------------
{
  Integer l_u = 0;
  Integer l_v = 0;

  texture_set_palette(p_tex, 1, 30 , 30 , 34 );
  texture_set_palette(p_tex, 2, 226, 226, 232);
  texture_set_palette(p_tex, 3, 168, 168, 176);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "..1111....1111..");
  texture_row(p_tex,  4, ".11111111111111.");
  texture_row(p_tex,  5, ".11111111111111.");
  texture_row(p_tex,  6, ".11111111111111.");
  texture_row(p_tex,  7, "..111111111111..");
  texture_row(p_tex,  8, "...1111111111...");
  texture_row(p_tex,  9, "...1111111111...");
  texture_row(p_tex, 10, "...1111111111...");
  texture_row(p_tex, 11, "...1111111111...");
  texture_row(p_tex, 12, "...1111111111...");
  texture_row(p_tex, 13, "................");
  if (p_fill == 0) return;
  texture_fill_rect(p_tex, 1, 1, TEX_SIZE, TEX_SIZE, TEX_TRANSPARENT);
  texture_row(p_tex,  4, "..222......222..");
  texture_row(p_tex,  5, "..222222222222..");
  texture_row(p_tex,  6, "..222222222222..");
  texture_row(p_tex,  7, "...2222222222...");
  texture_row(p_tex,  8, "....33333333....");
  texture_row(p_tex,  9, "....33333333....");
  texture_row(p_tex, 10, "....33333333....");
  texture_row(p_tex, 11, "....33333333....");
  if (p_fill == 2) return;
  for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
    for (l_u = 9; l_u <= TEX_SIZE; ++l_u) texture_set(p_tex, l_u, l_v, TEX_TRANSPARENT);
  }
}

void make_texture_armour_worn(Integer p_tex, Integer p_helmet_front)
// ----------------------------------------------------------------
// Iron armour as worn on the player model: brushed iron, or (for
// the front of the helmet) only a rim round the face
// ----------------------------------------------------------------
{
  make_armour_palette(p_tex);
  texture_fill   (p_tex, 3);
  texture_blotch (p_tex, 2, 4, 0.0, 0.22, 95);
  texture_speckle(p_tex, 4, 0.05, 97);
  texture_fill_rect(p_tex, 1, 16, 16, 16, 2);
  if (p_helmet_front) {
    texture_fill_rect(p_tex, 1, 1, 16, 1, 4);
    texture_fill_rect(p_tex, 3, 5, 14, 16, TEX_TRANSPARENT);
  }
}

void make_texture_obsidian(Integer p_tex)
// ----------------------------------------------------------------
// Obsidian: purple-black glass with a few lighter purple streaks
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 20 , 16 , 32 );
  texture_set_palette(p_tex, 2, 38 , 26 , 60 );
  texture_set_palette(p_tex, 3, 86 , 62 , 130);
  texture_fill   (p_tex, 1);
  texture_blotch (p_tex, 2, 6, 0.62, 1.0, 101);
  texture_speckle(p_tex, 3, 0.04, 103);
}

void make_texture_netherrack(Integer p_tex)
// ----------------------------------------------------------------
// Netherrack: dull red rock with darker patches (kept plain: it is
// most of the Nether, and every patch is another polygon)
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 112, 44 , 42 );
  texture_set_palette(p_tex, 2, 82 , 28 , 28 );
  texture_set_palette(p_tex, 3, 140, 66 , 62 );
  texture_fill   (p_tex, 1);
  texture_blotch (p_tex, 2, 5, 0.0, 0.28, 105);
  texture_blotch (p_tex, 3, 5, 0.80, 1.0, 107);
}

void make_texture_soul_sand(Integer p_tex)
// ----------------------------------------------------------------
// Soul sand: dark brown sand with faint faces in it
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 84 , 64 , 50 );
  texture_set_palette(p_tex, 2, 60 , 44 , 34 );
  texture_set_palette(p_tex, 3, 42 , 30 , 24 );
  texture_fill     (p_tex, 1);
  texture_blotch   (p_tex, 2, 4, 0.0, 0.3, 109);
  texture_fill_rect(p_tex, 3 , 4 , 4 , 5 , 3);    // eyes and a mouth
  texture_fill_rect(p_tex, 7 , 4 , 8 , 5 , 3);
  texture_fill_rect(p_tex, 4 , 8 , 7 , 9 , 3);
  texture_fill_rect(p_tex, 10, 10, 11, 11, 3);
  texture_fill_rect(p_tex, 13, 10, 14, 11, 3);
  texture_fill_rect(p_tex, 11, 14, 13, 15, 3);
}

void make_texture_glowstone(Integer p_tex)
// ----------------------------------------------------------------
// Glowstone: bright yellow crystals with orange between them
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 250, 210, 110);
  texture_set_palette(p_tex, 2, 196, 132, 60 );
  texture_set_palette(p_tex, 3, 255, 244, 196);
  texture_fill   (p_tex, 1);
  texture_blotch (p_tex, 2, 4, 0.0, 0.3, 111);
  texture_speckle(p_tex, 3, 0.08, 113);
}

void make_texture_quartz_ore(Integer p_tex)
// ----------------------------------------------------------------
// Netherrack with white crystals of quartz
// ----------------------------------------------------------------
{
  make_texture_netherrack(p_tex);
  texture_set_palette(p_tex, 4, 236, 230, 220);
  texture_set_palette(p_tex, 5, 196, 182, 170);
  texture_fill_rect(p_tex, 3 , 3 , 5 , 3 , 4);
  texture_fill_rect(p_tex, 4 , 4 , 4 , 5 , 5);
  texture_fill_rect(p_tex, 10, 5 , 13, 5 , 4);
  texture_fill_rect(p_tex, 11, 6 , 12, 6 , 5);
  texture_fill_rect(p_tex, 5 , 11, 8 , 11, 4);
  texture_fill_rect(p_tex, 6 , 12, 7 , 12, 5);
  texture_fill_rect(p_tex, 12, 12, 14, 13, 4);
}

void make_texture_lava(Integer p_tex)
// ----------------------------------------------------------------
// Lava: orange with yellow-hot and darker red swirls
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 226, 104, 24 );
  texture_set_palette(p_tex, 2, 252, 176, 52 );
  texture_set_palette(p_tex, 3, 178, 52 , 14 );
  texture_fill  (p_tex, 1);
  texture_blotch(p_tex, 2, 5, 0.66, 1.0, 115);
  texture_blotch(p_tex, 3, 5, 0.0, 0.2, 117);
}

void make_texture_portal(Integer p_tex, Integer p_frame)
// ----------------------------------------------------------------
// One frame (0 .. PORTAL_FRAMES - 1) of the inside of a lit Nether
// portal: purple arms swirling round the middle, with gaps you can
// see through; each frame turns the swirl a little further
// ----------------------------------------------------------------
{
  Integer l_u     = 0;
  Integer l_v     = 0;
  Real    l_x     = 0.0;
  Real    l_y     = 0.0;
  Real    l_wave  = 0.0;
  Real    l_phase = TWO_PI * p_frame / PORTAL_FRAMES;

  texture_set_palette(p_tex, 1, 110, 40 , 200);
  texture_set_palette(p_tex, 2, 160, 90 , 240);
  texture_set_palette(p_tex, 3, 70 , 18 , 150);
  texture_set_palette(p_tex, 4, 200, 150, 255);
  for (l_v = 1; l_v <= TEX_SIZE; ++l_v) {
    for (l_u = 1; l_u <= TEX_SIZE; ++l_u) {
      l_x    = l_u - 8.5;
      l_y    = l_v - 8.5;
      l_wave = Sin(2.0 * angle_of(l_y, l_x) + 0.8 * Sqrt(l_x * l_x + l_y * l_y) - l_phase)
             + 0.35 * Sin(l_u * 1.3 + l_v * 0.7 + l_phase);
      if (l_wave > 1.05) {
        texture_set(p_tex, l_u, l_v, 4);
      } else if (l_wave > 0.45) {
        texture_set(p_tex, l_u, l_v, 2);
      } else if (l_wave > -0.2) {
        texture_set(p_tex, l_u, l_v, 1);
      } else if (l_wave > -0.75) {
        texture_set(p_tex, l_u, l_v, 3);
      } else {
        texture_set(p_tex, l_u, l_v, TEX_TRANSPARENT);
      }
    }
  }
}

void make_texture_fire(Integer p_tex, Integer p_frame)
// ----------------------------------------------------------------
// Fire, drawn like a plant: tongues of flame, yellow at the root
// and red at the tips (two frames that flicker)
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 200, 50 , 10 );
  texture_set_palette(p_tex, 2, 240, 120, 20 );
  texture_set_palette(p_tex, 3, 255, 200, 60 );
  texture_set_palette(p_tex, 4, 255, 240, 160);
  if (p_frame == 0) {
    texture_row(p_tex,  1, "................");
    texture_row(p_tex,  2, ".....1..........");
    texture_row(p_tex,  3, ".....1.....1....");
    texture_row(p_tex,  4, "....11.....11...");
    texture_row(p_tex,  5, "....121...121...");
    texture_row(p_tex,  6, ".1..121..1221...");
    texture_row(p_tex,  7, ".1.1221..1221.1.");
    texture_row(p_tex,  8, ".1112321.12321.1");
    texture_row(p_tex,  9, "1122332112332111");
    texture_row(p_tex, 10, "1223332223332211");
    texture_row(p_tex, 11, "1233433233433321");
    texture_row(p_tex, 12, "2334443334443332");
    texture_row(p_tex, 13, "2344444344444432");
    texture_row(p_tex, 14, "3344444444444443");
    texture_row(p_tex, 15, "3444444444444443");
    texture_row(p_tex, 16, "3444444444444444");
    return;
  }
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "..........1.....");
  texture_row(p_tex,  3, "...1......1.....");
  texture_row(p_tex,  4, "...11....11.....");
  texture_row(p_tex,  5, "...121...121..1.");
  texture_row(p_tex,  6, "..1221...121..1.");
  texture_row(p_tex,  7, "1.1221..1221.11.");
  texture_row(p_tex,  8, "1112321.12321121");
  texture_row(p_tex,  9, "1123321123321121");
  texture_row(p_tex, 10, "1233322233332221");
  texture_row(p_tex, 11, "2334332334333321");
  texture_row(p_tex, 12, "2344433344433332");
  texture_row(p_tex, 13, "3344443444444432");
  texture_row(p_tex, 14, "3444444444444443");
  texture_row(p_tex, 15, "3444444444444444");
  texture_row(p_tex, 16, "4444444444444444");
}

void make_texture_diamond_ore(Integer p_tex)
// ----------------------------------------------------------------
// Stone with pale blue diamond flecks
// ----------------------------------------------------------------
{
  make_texture_stone(p_tex);
  texture_set_palette(p_tex, 4, 120, 230, 228);
  texture_set_palette(p_tex, 5, 40 , 170, 170);
  texture_set_palette(p_tex, 6, 220, 255, 255);
  texture_fill_rect(p_tex, 3 , 3 , 4 , 4 , 4);
  texture_fill_rect(p_tex, 4 , 4 , 4 , 4 , 6);
  texture_fill_rect(p_tex, 5 , 5 , 5 , 5 , 5);
  texture_fill_rect(p_tex, 11, 3 , 12, 4 , 4);
  texture_fill_rect(p_tex, 12, 5 , 13, 5 , 5);
  texture_fill_rect(p_tex, 7 , 8 , 8 , 9 , 4);
  texture_fill_rect(p_tex, 8 , 8 , 8 , 8 , 6);
  texture_fill_rect(p_tex, 9 , 10, 9 , 10, 5);
  texture_fill_rect(p_tex, 2 , 11, 3 , 12, 4);
  texture_fill_rect(p_tex, 12, 12, 13, 13, 4);
  texture_fill_rect(p_tex, 13, 13, 13, 13, 6);
  texture_fill_rect(p_tex, 11, 14, 11, 14, 5);
}

void make_texture_jukebox(Integer p_tex, Integer p_top)
// ----------------------------------------------------------------
// A jukebox: dark wood with a lighter frame round each side, and a
// record slot across the top
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 96 , 64 , 46 );
  texture_set_palette(p_tex, 2, 128, 88 , 62 );
  texture_set_palette(p_tex, 3, 62 , 40 , 28 );
  texture_set_palette(p_tex, 4, 24 , 16 , 12 );
  texture_fill     (p_tex, 1);
  texture_blotch   (p_tex, 3, 3, 0.0, 0.25, 125);
  texture_fill_rect(p_tex, 1 , 1 , 16, 2 , 2);
  texture_fill_rect(p_tex, 1 , 15, 16, 16, 2);
  texture_fill_rect(p_tex, 1 , 1 , 2 , 16, 2);
  texture_fill_rect(p_tex, 15, 1 , 16, 16, 2);
  if (p_top) {
    texture_fill_rect(p_tex, 3, 7, 14, 10, 3);
    texture_fill_rect(p_tex, 4, 8, 13, 9 , 4);
  } else {
    texture_fill_rect(p_tex, 3, 3, 14, 3 , 3);
    texture_fill_rect(p_tex, 3, 14, 14, 14, 3);
  }
}

void make_texture_item_diamond(Integer p_tex)
// ----------------------------------------------------------------
// Item picture: a cut diamond
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 14 , 60 , 64 );
  texture_set_palette(p_tex, 2, 40 , 170, 170);
  texture_set_palette(p_tex, 3, 120, 230, 228);
  texture_set_palette(p_tex, 4, 230, 255, 255);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "....11111111....");
  texture_row(p_tex,  4, "...1343334331...");
  texture_row(p_tex,  5, "..134333334331..");
  texture_row(p_tex,  6, ".11111111111111.");
  texture_row(p_tex,  7, ".13332233322331.");
  texture_row(p_tex,  8, "..133223332231..");
  texture_row(p_tex,  9, "...1332332231...");
  texture_row(p_tex, 10, "....13323221....");
  texture_row(p_tex, 11, ".....133221.....");
  texture_row(p_tex, 12, "......1321......");
  texture_row(p_tex, 13, ".......11.......");
  texture_row(p_tex, 14, "................");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

void make_diamond_armour_palette(Integer p_tex)
// ----------------------------------------------------------------
// Recolour an iron armour picture as diamond (the same indexes as
// make_armour_palette: 1 outline, 2 shadow, 3 diamond, 4 shine)
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 14 , 70 , 74 );
  texture_set_palette(p_tex, 2, 40 , 170, 170);
  texture_set_palette(p_tex, 3, 100, 220, 216);
  texture_set_palette(p_tex, 4, 210, 255, 252);
}

void make_texture_item_flint(Integer p_tex)
// ----------------------------------------------------------------
// Item picture: a chip of flint
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 20 , 20 , 22 );
  texture_set_palette(p_tex, 2, 64 , 62 , 66 );
  texture_set_palette(p_tex, 3, 118, 116, 120);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "................");
  texture_row(p_tex,  4, "......111.......");
  texture_row(p_tex,  5, ".....12221......");
  texture_row(p_tex,  6, "....1223321.....");
  texture_row(p_tex,  7, "....12233321....");
  texture_row(p_tex,  8, "...122223321....");
  texture_row(p_tex,  9, "...122222221....");
  texture_row(p_tex, 10, "...12222221.....");
  texture_row(p_tex, 11, "....1222221.....");
  texture_row(p_tex, 12, "....112221......");
  texture_row(p_tex, 13, ".....11111......");
  texture_row(p_tex, 14, "................");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

void make_texture_item_flint_and_steel(Integer p_tex)
// ----------------------------------------------------------------
// Item picture: a steel ring with a flint
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 30 , 30 , 34 );
  texture_set_palette(p_tex, 2, 200, 200, 206);
  texture_set_palette(p_tex, 3, 70 , 68 , 72 );
  texture_set_palette(p_tex, 4, 120, 118, 124);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "..........1111..");
  texture_row(p_tex,  4, "........11222211");
  texture_row(p_tex,  5, "........12111121");
  texture_row(p_tex,  6, "........121..121");
  texture_row(p_tex,  7, "......1..1....11");
  texture_row(p_tex,  8, ".....131.11111..");
  texture_row(p_tex,  9, "....13331.......");
  texture_row(p_tex, 10, "...1344331......");
  texture_row(p_tex, 11, "..13444431......");
  texture_row(p_tex, 12, "..1344431.......");
  texture_row(p_tex, 13, "...13431........");
  texture_row(p_tex, 14, "....131.........");
  texture_row(p_tex, 15, ".....1..........");
  texture_row(p_tex, 16, "................");
}

void make_texture_item_nether_quartz(Integer p_tex)
// ----------------------------------------------------------------
// Item picture: white crystals of nether quartz
// ----------------------------------------------------------------
{
  texture_set_palette(p_tex, 1, 120, 104, 96 );
  texture_set_palette(p_tex, 2, 226, 220, 210);
  texture_set_palette(p_tex, 3, 255, 255, 252);
  texture_row(p_tex,  1, "................");
  texture_row(p_tex,  2, "................");
  texture_row(p_tex,  3, "................");
  texture_row(p_tex,  4, ".......1........");
  texture_row(p_tex,  5, "......121.......");
  texture_row(p_tex,  6, ".....12321......");
  texture_row(p_tex,  7, ".....12321...1..");
  texture_row(p_tex,  8, "....123321..121.");
  texture_row(p_tex,  9, "....122221.12321");
  texture_row(p_tex, 10, "...12322221.1221");
  texture_row(p_tex, 11, "...1222221..121.");
  texture_row(p_tex, 12, "..1222221....1..");
  texture_row(p_tex, 13, "...111111.......");
  texture_row(p_tex, 14, "................");
  texture_row(p_tex, 15, "................");
  texture_row(p_tex, 16, "................");
}

Integer texture_is_sprite(Integer p_tex)
// ----------------------------------------------------------------
// TRUE for the textures drawn as pictures with see-through pixels
// (plants and items) rather than block faces
// ----------------------------------------------------------------
{
  // the block faces numbered after the sprites (worn armour, the
  // Nether's blocks, diamond ore and the jukebox) are not sprites;
  // the portal and fire are
  if (p_tex == TEX_ARMOUR_IRON) return FALSE;
  if (p_tex >= TEX_OBSIDIAN && p_tex <= TEX_LAVA) return FALSE;
  if (p_tex >= TEX_DIAMOND_ORE && p_tex <= TEX_JUKEBOX_TOP) return FALSE;
  if (p_tex >= TEX_CHEST_PARTS && p_tex <= TEX_BED_LEG) return FALSE;
  if (p_tex >= TEX_FIRST_SPRITE) return TRUE;
  return FALSE;
}

void textures_init()
// ----------------------------------------------------------------
// Generate every built-in texture and its drawing data
// ----------------------------------------------------------------
{
  textures_generate();
  textures_finish_all();
}

void textures_finish_all()
// ----------------------------------------------------------------
// Work out the drawing data of every texture (after generating them
// and after a resource pack has replaced some)
// ----------------------------------------------------------------
{
  Integer l_tex = 0;

  // made from other textures here, so they follow a resource pack's
  make_texture_door_edge(TEX_DOOR_EDGE_TOP,    TEX_DOOR_TOP);
  make_texture_door_edge(TEX_DOOR_EDGE_BOTTOM, TEX_DOOR_BOTTOM);

  g_rect_total = 0;
  for (l_tex = 1; l_tex <= NUM_TEXTURES; ++l_tex) texture_finish(l_tex);
}

void textures_generate()
// ----------------------------------------------------------------
// Draw the pixels of every built-in texture
// Order matters where one texture starts as a copy of another
// ----------------------------------------------------------------
{
  Integer l_tex   = 0;
  Integer l_frame = 0;

  make_texture_bedrock      (TEX_BEDROCK);
  make_texture_stone        (TEX_STONE);
  make_texture_cobblestone  (TEX_COBBLESTONE);
  make_texture_dirt         (TEX_DIRT);
  make_texture_grass_top    (TEX_GRASS_TOP);
  make_texture_grass_side   (TEX_GRASS_SIDE);
  make_texture_log_side     (TEX_LOG_SIDE);
  make_texture_log_top      (TEX_LOG_TOP);
  make_texture_leaves       (TEX_LEAVES);
  make_texture_water        (TEX_WATER);
  make_texture_planks       (TEX_PLANKS);
  make_texture_table_top    (TEX_TABLE_TOP);
  make_texture_table_side   (TEX_TABLE_SIDE);
  make_texture_furnace_side (TEX_FURNACE_SIDE);
  make_texture_furnace_top  (TEX_FURNACE_TOP);
  make_texture_furnace_front(TEX_FURNACE_FRONT, FALSE);
  make_texture_furnace_front(TEX_FURNACE_FRONT_LIT, TRUE);
  make_texture_sand         (TEX_SAND);
  make_texture_cow_hide     (TEX_COW_HIDE);
  make_texture_cow_face     (TEX_COW_FACE);
  make_texture_sandstone_top (TEX_SANDSTONE_TOP);
  make_texture_sandstone_side(TEX_SANDSTONE_SIDE);
  make_texture_cactus_top    (TEX_CACTUS_TOP);
  make_texture_cactus_side   (TEX_CACTUS_SIDE);
  make_texture_coal_ore      (TEX_COAL_ORE);
  make_texture_gravel        (TEX_GRAVEL);
  make_texture_plant_grass   (TEX_PLANT_GRASS);
  make_texture_plant_flower  (TEX_PLANT_POPPY, 214, 40, 34);
  make_texture_plant_flower  (TEX_PLANT_DANDELION, 240, 214, 40);
  make_texture_plant_dead_bush(TEX_PLANT_DEAD_BUSH);
  make_texture_item_stick    (TEX_ITEM_STICK);
  make_texture_item_beef     (TEX_ITEM_RAW_BEEF, FALSE);
  make_texture_item_beef     (TEX_ITEM_COOKED_BEEF, TRUE);
  make_texture_item_coal     (TEX_ITEM_COAL);
  make_texture_item_pickaxe  (TEX_ITEM_WOODEN_PICKAXE, TIER_WOOD);
  make_texture_item_pickaxe  (TEX_ITEM_STONE_PICKAXE, TIER_STONE);
  make_texture_item_axe      (TEX_ITEM_WOODEN_AXE, TIER_WOOD);
  make_texture_item_axe      (TEX_ITEM_STONE_AXE, TIER_STONE);
  make_texture_item_shovel   (TEX_ITEM_WOODEN_SHOVEL, TIER_WOOD);
  make_texture_item_shovel   (TEX_ITEM_STONE_SHOVEL, TIER_STONE);
  make_texture_item_sword    (TEX_ITEM_WOODEN_SWORD, TIER_WOOD);
  make_texture_item_sword    (TEX_ITEM_STONE_SWORD, TIER_STONE);
  make_texture_iron_ore      (TEX_IRON_ORE);
  make_texture_item_ingot    (TEX_ITEM_IRON_INGOT);
  make_texture_item_pickaxe  (TEX_ITEM_IRON_PICKAXE, TIER_IRON);
  make_texture_item_axe      (TEX_ITEM_IRON_AXE, TIER_IRON);
  make_texture_item_shovel   (TEX_ITEM_IRON_SHOVEL, TIER_IRON);
  make_texture_item_sword    (TEX_ITEM_IRON_SWORD, TIER_IRON);
  make_texture_bed_top       (TEX_BED_TOP);
  make_texture_bed_side      (TEX_BED_SIDE, TRUE);
  make_texture_zombie        (TEX_ZOMBIE_SKIN, 1);
  make_texture_zombie        (TEX_ZOMBIE_FACE, 2);
  make_texture_zombie        (TEX_ZOMBIE_SHIRT, 3);
  make_texture_zombie        (TEX_ZOMBIE_PANTS, 4);
  make_texture_zombie        (TEX_ZOMBIE_SHIRT_SIDE, 5);
  make_texture_zombie        (TEX_ZOMBIE_ARM, 6);
  make_texture_zombie        (TEX_ZOMBIE_HEAD_SIDE, 1);
  make_texture_zombie        (TEX_ZOMBIE_HEAD_TOP, 7);
  make_texture_cow           (TEX_COW_HEAD_SIDE, 1);
  make_texture_cow           (TEX_COW_HEAD_TOP, 2);
  make_texture_cow           (TEX_COW_BODY_TOP, 3);
  make_texture_cow           (TEX_COW_BODY_END, 4);
  make_texture_cow           (TEX_COW_LEG, 5);
  make_texture_cow           (TEX_COW_HORN, 6);
  make_texture_pig           (TEX_PIG_FACE, 1);
  make_texture_pig           (TEX_PIG_HEAD_SIDE, 2);
  make_texture_pig           (TEX_PIG_BODY_SIDE, 3);
  make_texture_pig           (TEX_PIG_BODY_TOP, 4);
  make_texture_pig           (TEX_PIG_BODY_END, 5);
  make_texture_pig           (TEX_PIG_LEG, 6);
  make_texture_pig           (TEX_PIG_SNOUT, 7);
  make_texture_torch         (TEX_TORCH);
  make_texture_chest         (TEX_CHEST_TOP, FALSE);
  make_texture_chest         (TEX_CHEST_SIDE, TRUE);
  make_texture_glass         (TEX_GLASS);
  make_texture_item_rotten_flesh(TEX_ITEM_ROTTEN_FLESH);
  make_texture_item_porkchop (TEX_ITEM_RAW_PORKCHOP, FALSE);
  make_texture_item_porkchop (TEX_ITEM_COOKED_PORKCHOP, TRUE);
  for (l_tex = TEX_DESTROY_FIRST; l_tex <= TEX_DESTROY_LAST; ++l_tex) make_texture_destroy(l_tex, l_tex - TEX_DESTROY_FIRST + 1);
  make_texture_heart         (TEX_HEART_FULL, 2);
  make_texture_heart         (TEX_HEART_HALF, 1);
  make_texture_heart         (TEX_HEART_CONTAINER, 0);
  make_texture_door          (TEX_DOOR_TOP, TRUE);
  make_texture_door          (TEX_DOOR_BOTTOM, FALSE);
  make_texture_item_door     (TEX_ITEM_DOOR);
  make_texture_bed_foot_top  (TEX_BED_FOOT_TOP);
  make_texture_person        (TEX_PERSON_FACE,       1);
  make_texture_person        (TEX_PERSON_HEAD_SIDE,  2);
  make_texture_person        (TEX_PERSON_HEAD_TOP,   3);
  make_texture_person        (TEX_PERSON_SHIRT,      4);
  make_texture_person        (TEX_PERSON_SHIRT_SIDE, 5);
  make_texture_person        (TEX_PERSON_ARM,        6);
  make_texture_person        (TEX_PERSON_PANTS,      7);
  make_texture_person        (TEX_PERSON_HEAD_BACK,  8);
  make_texture_person        (TEX_PERSON_SHIRT_BACK, 4);
  make_texture_person        (TEX_PERSON_ARM_FRONT,  6);
  make_texture_person        (TEX_PERSON_ARM_TOP,    5);
  make_texture_person        (TEX_PERSON_LEG_FRONT,  7);
  make_texture_item_armour   (TEX_ITEM_IRON_HELMET,     ARMOUR_HEAD);
  make_texture_item_armour   (TEX_ITEM_IRON_CHESTPLATE, ARMOUR_CHEST);
  make_texture_item_armour   (TEX_ITEM_IRON_LEGGINGS,   ARMOUR_LEGS);
  make_texture_item_armour   (TEX_ITEM_IRON_BOOTS,      ARMOUR_FEET);
  make_texture_spawn_egg     (TEX_ITEM_COW_SPAWN_EGG,    68 , 52 , 36 , 168, 168, 168);
  make_texture_spawn_egg     (TEX_ITEM_PIG_SPAWN_EGG,    236, 156, 156, 204, 96 , 96 );
  make_texture_spawn_egg     (TEX_ITEM_ZOMBIE_SPAWN_EGG, 0  , 170, 170, 112, 150, 92 );
  make_texture_armour_icon   (TEX_ARMOUR_FULL,  2);
  make_texture_armour_icon   (TEX_ARMOUR_HALF,  1);
  make_texture_armour_icon   (TEX_ARMOUR_EMPTY, 0);
  make_texture_armour_worn   (TEX_ARMOUR_IRON,         FALSE);
  make_texture_armour_worn   (TEX_ARMOUR_HELMET_FRONT, TRUE);
  make_texture_obsidian      (TEX_OBSIDIAN);
  make_texture_netherrack    (TEX_NETHERRACK);
  make_texture_soul_sand     (TEX_SOUL_SAND);
  make_texture_glowstone     (TEX_GLOWSTONE);
  make_texture_quartz_ore    (TEX_QUARTZ_ORE);
  make_texture_lava          (TEX_LAVA);
  make_texture_portal        (TEX_PORTAL, 0);
  make_texture_item_flint    (TEX_ITEM_FLINT);
  make_texture_item_flint_and_steel(TEX_ITEM_FLINT_AND_STEEL);
  make_texture_item_nether_quartz  (TEX_ITEM_NETHER_QUARTZ);
  for (l_frame = 1; l_frame < PORTAL_FRAMES; ++l_frame) make_texture_portal(TEX_PORTAL_2 + l_frame - 1, l_frame);
  make_texture_diamond_ore   (TEX_DIAMOND_ORE);
  make_texture_jukebox       (TEX_JUKEBOX_SIDE, FALSE);
  make_texture_jukebox       (TEX_JUKEBOX_TOP,  TRUE);
  make_texture_fire          (TEX_FIRE,   0);
  make_texture_fire          (TEX_FIRE_2, 1);
  make_texture_item_diamond  (TEX_ITEM_DIAMOND);
  make_texture_item_pickaxe  (TEX_ITEM_DIAMOND_PICKAXE, TIER_DIAMOND);
  make_texture_item_axe      (TEX_ITEM_DIAMOND_AXE,     TIER_DIAMOND);
  make_texture_item_shovel   (TEX_ITEM_DIAMOND_SHOVEL,  TIER_DIAMOND);
  make_texture_item_sword    (TEX_ITEM_DIAMOND_SWORD,   TIER_DIAMOND);
  make_texture_item_armour   (TEX_ITEM_DIAMOND_HELMET,     ARMOUR_HEAD);
  make_texture_item_armour   (TEX_ITEM_DIAMOND_CHESTPLATE, ARMOUR_CHEST);
  make_texture_item_armour   (TEX_ITEM_DIAMOND_LEGGINGS,   ARMOUR_LEGS);
  make_texture_item_armour   (TEX_ITEM_DIAMOND_BOOTS,      ARMOUR_FEET);
  for (l_tex = TEX_ITEM_DIAMOND_HELMET; l_tex <= TEX_ITEM_DIAMOND_BOOTS; ++l_tex) make_diamond_armour_palette(l_tex);
  for (l_frame = 0; l_frame < WORN_PARTS; ++l_frame) {
    make_texture_armour_worn(TEX_WORN_IRON    + l_frame, l_frame == WORN_HELMET_FRONT);
    make_texture_armour_worn(TEX_WORN_DIAMOND + l_frame, l_frame == WORN_HELMET_FRONT);
    make_diamond_armour_palette(TEX_WORN_DIAMOND + l_frame);
  }
  for (l_tex = 0; l_tex < 3 * CHEST_PARTS; ++l_tex) {
    make_texture_chest_part(TEX_CHEST_PARTS + l_tex, positive_mod(l_tex, CHEST_PARTS), floor_divide(l_tex, CHEST_PARTS));
  }
  make_texture_bed_side      (TEX_BED_FOOT_SIDE, FALSE);
  make_texture_bed_end       (TEX_BED_HEAD_END,  TRUE);
  make_texture_bed_end       (TEX_BED_FOOT_END,  FALSE);
  make_texture_bed_leg       (TEX_BED_LEG);
}

#endif
