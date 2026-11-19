#ifndef UTIL_H_INCLUDED
#define UTIL_H_INCLUDED

// ----------------------------------------------------------------
// Small maths, hashing and text helpers (all honest: they only use
// their arguments). Random sequences are in records.h.
// ----------------------------------------------------------------

// Characters 12d sends in a "keystroke" event for keys that type
// nothing (see key_name)
#define KEY_CODE_BACKSPACE    8
#define KEY_CODE_ENTER        13
#define KEY_CODE_ESCAPE       27
#define KEY_CODE_DELETE_WORD  127    // Ctrl+Backspace
#define KEY_CODE_TAB          9
#define KEY_CODE_LINE_FEED    10
#define KEY_CODE_CTRL_Z       26     // Ctrl+A .. Ctrl+Z come as characters 1 .. 26

// Shift and Ctrl alone send nothing in 12d, so a key pressed with one
// held stands for it too (key_modifier): a capital letter for Shift,
// a control character for Ctrl
#define KEY_SHIFT             "shift"
#define KEY_CONTROL           "control"

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
Text    key_name            (Text p_msg);
Integer key_is_text         (Text p_msg);
Integer key_is_control_letter(Integer p_code);
Text    key_base            (Text p_msg);
Text    key_modifier        (Text p_msg);
Text    key_label           (Text p_key);
Text    text_upper          (Text p_text);
Text    text_without_last_word(Text p_text);
Text    text_after_key      (Text p_text, Text p_msg, Integer p_longest);

#endif
