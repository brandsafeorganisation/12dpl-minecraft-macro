#ifndef SETTINGS_H_INCLUDED
#define SETTINGS_H_INCLUDED

#include "../core/records.h"

// ----------------------------------------------------------------
// Player settings: one record, changed from the settings panel (and
// a few keys in game), saved to SETTINGS_FILE between sessions
// ----------------------------------------------------------------

#define DATATYPE_SETTINGS        ("settings")
#define ATTR_SET_RENDER_DISTANCE ("render_distance")
#define ATTR_SET_DETAIL          ("texture_detail")
#define ATTR_SET_PLANTS          ("plants")
#define ATTR_SET_SHADING         ("shading")
#define ATTR_SET_AUTO_JUMP       ("auto_jump")
#define ATTR_SET_FOV             ("field_of_view")
#define ATTR_SET_SENSITIVITY     ("mouse_sensitivity")
#define ATTR_SET_SHOW_HUD        ("show_hud")
#define ATTR_SET_SHOW_DEBUG      ("show_debug")
#define ATTR_SET_RESOURCE_PACK   ("resource_pack")   // .zip file or folder, "" for the built-in textures
#define ATTR_SET_FONT            ("font")            // installed TrueType font for the game's text, "" for 12d's default
#define ATTR_SET_FONT_FILE       ("font_file")       // the font file it was read from, if one was chosen

#define RENDER_DISTANCE_MIN      8
#define RENDER_DISTANCE_MAX      64
#define RENDER_DISTANCE_STEP     4
#define RENDER_DISTANCE_DEFAULT  50
#define DETAIL_LOW               1
#define DETAIL_NORMAL            2
#define DETAIL_HIGH              3
#define FOV_MIN                  50
#define FOV_MAX                  100
#define FOV_STEP                 5
#define FOV_DEFAULT              70
#define SENSITIVITY_MIN          1
#define SENSITIVITY_MAX          10
#define SENSITIVITY_DEFAULT      5
#define SETTINGS_FILE            "cubeland_settings.txt"
#define PACK_FILE_BOX_MODE       0      // File_Box mode: no automatic check (the panel checks the path itself)

void    settings_defaults       (Attributes &p_settings);
Integer settings_render_distance(Attributes &p_settings);
Integer settings_detail         (Attributes &p_settings);
Integer settings_flag           (Attributes &p_settings, Text p_field);
Integer settings_fov_degrees    (Attributes &p_settings);
Real    settings_fov_radians    (Attributes &p_settings);
Real    settings_mouse_scale    (Attributes &p_settings);
void    settings_change         (Attributes &p_settings, Text p_field, Integer p_direction);
void    settings_toggle         (Attributes &p_settings, Text p_field);
Text    settings_describe       (Attributes &p_settings, Text p_field);
Text    settings_line           (Text p_name, Integer p_value);
Integer settings_save           (Attributes &p_settings, Text p_path);
Integer settings_load           (Attributes &p_settings, Text p_path);
Text    settings_resource_pack  (Attributes &p_settings);
void    settings_set_resource_pack(Attributes &p_settings, Text p_path);
Text    settings_font           (Attributes &p_settings);
Text    settings_font_file     (Attributes &p_settings);
void    settings_set_font_file (Attributes &p_settings, Text p_path);
void    settings_set_font       (Attributes &p_settings, Text p_font);

#endif
