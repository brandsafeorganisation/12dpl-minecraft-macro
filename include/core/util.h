#ifndef UTIL_H_INCLUDED
#define UTIL_H_INCLUDED

// ----------------------------------------------------------------
// Small maths, hashing and text helpers (all honest: they only use
// their arguments). Random sequences are in records.h.
// ----------------------------------------------------------------

Real    clamp_real          (Real p_value, Real p_low, Real p_high);
Real    angle_of            (Real p_y, Real p_x);
Text    two_digits          (Integer p_value);
Integer max_integer         (Integer p_a, Integer p_b);
Integer min_integer         (Integer p_a, Integer p_b);
Integer clamp_integer       (Integer p_value, Integer p_low, Integer p_high);
Real    min_real            (Real p_first, Real p_second);
Real    max_real            (Real p_first, Real p_second);
Integer floor_integer       (Real p_value);
Integer floor_divide        (Integer p_numerator, Integer p_denominator);
Integer positive_mod        (Integer p_value, Integer p_modulus);
Integer to_byte             (Real p_value);
Real    lerp_real           (Real p_from, Real p_to, Real p_amount);
Real    smooth_curve        (Real p_amount);
Real    hash_real           (Real p_first, Real p_second, Real p_third);
Real    wrap_angle          (Real p_angle);
Integer text_to_seed        (Text p_text);
Text    file_title_from_path(Text p_path);
Integer text_is_safe_name   (Text p_name);

#endif
