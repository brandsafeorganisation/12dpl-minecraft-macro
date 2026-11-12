#ifndef UTIL_4DM_INCLUDED
#define UTIL_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"

Real clamp_real(Real p_value, Real p_low, Real p_high)
// ----------------------------------------------------------------
// Limit value to the range [low, high]
// ----------------------------------------------------------------
{
  Real l_result = p_value;

  if (l_result < p_low ) l_result = p_low;
  if (l_result > p_high) l_result = p_high;

  return l_result;
}

Real angle_of(Real p_y, Real p_x)
// ----------------------------------------------------------------
// Angle of the direction (x, y) in radians, -PI..PI, like atan2
// (12dPL has no arctangent). A polynomial approximation, good to
// about 0.005 radians, which is plenty for turning animals.
// ----------------------------------------------------------------
{
  Real l_ax    = Absolute(p_x);
  Real l_ay    = Absolute(p_y);
  Real l_ratio = 0.0;
  Real l_angle = 0.0;

  if (l_ax < 1.0e-9 && l_ay < 1.0e-9) return 0.0;
  if (l_ax >= l_ay) {
    l_ratio = l_ay / l_ax;
    l_angle = l_ratio * (PI / 4.0) + 0.273 * l_ratio * (1.0 - l_ratio);
  } else {
    l_ratio = l_ax / l_ay;
    l_angle = HALF_PI - (l_ratio * (PI / 4.0) + 0.273 * l_ratio * (1.0 - l_ratio));
  }
  if (p_x < 0.0) l_angle = PI - l_angle;
  if (p_y < 0.0) l_angle = -l_angle;
  return l_angle;
}

Text two_digits(Integer p_value)
// ----------------------------------------------------------------
// A number 0..99 as two digits ("07")
// ----------------------------------------------------------------
{
  if (p_value < 10) return "0" + To_text(p_value);
  return To_text(p_value);
}

Integer max_integer(Integer p_a, Integer p_b)
// ----------------------------------------------------------------
// The larger of two Integers
// ----------------------------------------------------------------
{
  if (p_a > p_b) return p_a;
  return p_b;
}

Integer min_integer(Integer p_a, Integer p_b)
// ----------------------------------------------------------------
// The smaller of two Integers
// ----------------------------------------------------------------
{
  if (p_a < p_b) return p_a;
  return p_b;
}

Integer clamp_integer(Integer p_value, Integer p_low, Integer p_high)
// ----------------------------------------------------------------
// Limit value to the range [low, high]
// ----------------------------------------------------------------
{
  Integer l_result = p_value;

  if (l_result < p_low ) l_result = p_low;
  if (l_result > p_high) l_result = p_high;

  return l_result;
}

Real min_real(Real p_first, Real p_second)
// ----------------------------------------------------------------
// The smaller of two values
// ----------------------------------------------------------------
{
  if (p_first < p_second) return p_first;
  return p_second;
}

Real max_real(Real p_first, Real p_second)
// ----------------------------------------------------------------
// The larger of two values
// ----------------------------------------------------------------
{
  if (p_first > p_second) return p_first;
  return p_second;
}

Integer floor_integer(Real p_value)
// ----------------------------------------------------------------
// Round towards negative infinity and return as an Integer
// ----------------------------------------------------------------
{
  Integer l_result = Floor(p_value);
  return l_result;
}

Integer floor_divide(Integer p_numerator, Integer p_denominator)
// ----------------------------------------------------------------
// Integer division rounding towards negative infinity
// Done in Reals so the result never depends on how the language
// rounds negative Integer division
// ----------------------------------------------------------------
{
  Integer l_result = Floor(p_numerator / (1.0 * p_denominator));
  return l_result;
}

Integer positive_mod(Integer p_value, Integer p_modulus)
// ----------------------------------------------------------------
// value modulo modulus, always in the range [0, modulus - 1]
// ----------------------------------------------------------------
{
  Integer l_result = p_value - floor_divide(p_value, p_modulus) * p_modulus;
  return l_result;
}

Integer to_byte(Real p_value)
// ----------------------------------------------------------------
// Convert a colour channel to an Integer in [0, 255]
// ----------------------------------------------------------------
{
  Integer l_result = Floor(clamp_real(p_value, 0.0, 255.0));
  return l_result;
}

Real lerp_real(Real p_from, Real p_to, Real p_amount)
// ----------------------------------------------------------------
// Linear interpolation, amount 0 gives from and 1 gives to
// ----------------------------------------------------------------
{
  return p_from + (p_to - p_from) * p_amount;
}

Real smooth_curve(Real p_amount)
// ----------------------------------------------------------------
// Smoothstep easing of amount in [0, 1]
// ----------------------------------------------------------------
{
  return p_amount * p_amount * (3.0 - 2.0 * p_amount);
}

Real hash_real(Real p_first, Real p_second, Real p_third)
// ----------------------------------------------------------------
// Deterministic pseudo random number in [0, 1) from three values
// Used by terrain and texture generation so that a seed always
// produces the same result regardless of call order
// ----------------------------------------------------------------
{
  Real l_value = Sin(p_first * 127.1 + p_second * 311.7 + p_third * 74.7) * 43758.5453123;
  return l_value - Floor(l_value);
}

Real wrap_angle(Real p_angle)
// ----------------------------------------------------------------
// Bring an angle into the range [0, 2 pi)
// ----------------------------------------------------------------
{
  return p_angle - Floor(p_angle / TWO_PI) * TWO_PI;
}

Integer text_to_seed(Text p_text)
// ----------------------------------------------------------------
// Turn the seed typed by the player into an Integer seed
// Whole numbers (optionally negative) are used as they are, any
// other text is hashed so that words make repeatable worlds too
// ----------------------------------------------------------------
{
  Text    l_trimmed    = Text_justify(p_text);
  Text    l_digits     = "0123456789";
  Text    l_charset    = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -_.,!?:;()+=*/@#$%&";
  Text    l_character  = "";
  Integer l_length     = Text_length(l_trimmed);
  Integer l_position   = 0;
  Integer l_digit      = 0;
  Integer l_is_number  = TRUE;
  Integer l_negative   = FALSE;
  Integer l_start      = 1;
  Integer l_seed       = 0;
  Real    l_accumulate = 0.0;

  if (l_length == 0) return 0;

  if (Get_subtext(l_trimmed, 1, 1) == "-") {
    l_negative = TRUE;
    l_start    = 2;
  }
  if (l_start > l_length) l_is_number = FALSE;
  if (l_length - l_start + 1 > 9) l_is_number = FALSE;

  for (l_position = l_start; l_position <= l_length; ++l_position) {
    l_character = Get_subtext(l_trimmed, l_position, l_position);
    if (Find_text(l_digits, l_character) == 0) l_is_number = FALSE;
  }

  if (l_is_number) {
    for (l_position = l_start; l_position <= l_length; ++l_position) {
      l_character = Get_subtext(l_trimmed, l_position, l_position);
      l_digit     = Find_text(l_digits, l_character) - 1;
      l_seed      = l_seed * 10 + l_digit;
    }
    if (l_negative) l_seed = -l_seed;
    return l_seed;
  }

  for (l_position = 1; l_position <= l_length; ++l_position) {
    l_character  = Get_subtext(l_trimmed, l_position, l_position);
    l_accumulate = l_accumulate * 31.0 + Find_text(l_charset, l_character) + 1.0;
    l_accumulate = l_accumulate - Floor(l_accumulate / 2147483.0) * 2147483.0;
  }
  l_seed = Floor(l_accumulate);

  return l_seed;
}

Text file_title_from_path(Text p_path)
// ----------------------------------------------------------------
// "C:\folder\name.ext" -> "name"
// Accepts either slash style
// ----------------------------------------------------------------
{
  Integer l_length    = Text_length(p_path);
  Integer l_position  = 0;
  Integer l_first     = 1;
  Integer l_last      = l_length;
  Text    l_character = "";

  for (l_position = 1; l_position <= l_length; ++l_position) {
    l_character = Get_subtext(p_path, l_position, l_position);
    if (l_character == "/" || l_character == "\\") l_first = l_position + 1;
  }
  for (l_position = l_length; l_position >= l_first; --l_position) {
    l_character = Get_subtext(p_path, l_position, l_position);
    if (l_character == ".") {
      l_last = l_position - 1;
      break;
    }
  }

  if (l_last < l_first) return "";

  return Get_subtext(p_path, l_first, l_last);
}

Integer text_is_safe_name(Text p_name)
// ----------------------------------------------------------------
// TRUE if name only uses letters, digits, spaces, - and _
// so that it can be used as a file name
// ----------------------------------------------------------------
{
  Text    l_allowed   = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -_";
  Text    l_character = "";
  Integer l_length    = Text_length(p_name);
  Integer l_position  = 0;

  if (l_length == 0 || l_length > 40) return FALSE;

  for (l_position = 1; l_position <= l_length; ++l_position) {
    l_character = Get_subtext(p_name, l_position, l_position);
    if (Find_text(l_allowed, l_character) == 0) return FALSE;
  }

  return TRUE;
}

#endif
