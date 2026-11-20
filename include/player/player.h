#ifndef PLAYER_H_INCLUDED
#define PLAYER_H_INCLUDED

#include "../core/config.h"
#include "../core/records.h"

// ----------------------------------------------------------------
// The player record: position, look direction, health, movement
// input, what the crosshair is on, and the hit / use actions
//
// Every function takes the player record (and whatever else it
// uses) as a parameter. Other modules use the accessors below
// rather than naming fields.
// ----------------------------------------------------------------

#define TARGET_NONE   0
#define TARGET_BLOCK  1
#define TARGET_COW    2

// Game modes (/gamemode): only survival has health and is attacked;
// creative flies with a double tap of Space; spectator always flies,
// passes through blocks and can't touch anything
#define GAMEMODE_SURVIVAL   0
#define GAMEMODE_CREATIVE   1
#define GAMEMODE_SPECTATOR  2

#define DATATYPE_PLAYER          ("player")
#define ATTR_PLAYER_DEAD         ("dead")
#define ATTR_PLAYER_IN_WATER     ("in_water")
#define ATTR_PLAYER_EYE_IN_WATER ("eye_in_water")
#define ATTR_PLAYER_FALL_PEAK    ("fall_peak")
#define ATTR_PLAYER_REGEN        ("regen")
#define ATTR_PLAYER_HURT         ("hurt")
#define ATTR_PLAYER_SWING        ("swing")
#define ATTR_PLAYER_BOB          ("bob")
#define ATTR_PLAYER_SELECTED     ("selected")
#define ATTR_PLAYER_AUTO_WALK    ("auto_walk")
#define ATTR_PLAYER_FLYING       ("flying")
// The camera (F5, or V where 12d keeps F5): your own eyes, behind you
// looking past your head, and in front of you looking back at you
#define CAMERA_FIRST             0
#define CAMERA_BEHIND            1
#define CAMERA_FRONT             2
#define CAMERA_DISTANCE          4.0     // blocks from the eyes in the two outside views

// The body as seen from outside: the head turns up to HEAD_TURN_LIMIT
// (radians) before the body follows; walking turns the body to the
// head at BODY_TURN_RATE, and the legs settle at STRIDE_RATE
#define HEAD_TURN_LIMIT          0.6
#define BODY_TURN_RATE           6.0
#define STRIDE_RATE              8.0

#define ATTR_PLAYER_CAMERA       ("camera")            // CAMERA_... (not saved)
#define ATTR_PLAYER_MODE         ("creative")          // GAMEMODE_...; the field name is from when it was TRUE in creative, so older worlds load
#define ATTR_SPACE_LAST          ("space_last")        // when Space last arrived
#define ATTR_SPACE_GAP           ("space_gap")         // seconds between the last two Spaces
#define ATTR_FLY_DOWN_UNTIL      ("fly_down_until")
#define ATTR_CROUCH_UNTIL        ("crouch_until")      // crouched by the sneak key until then
#define ATTR_SPRINTING           ("sprinting")         // TRUE from the sprint key until you stop walking forward
#define ATTR_CROUCHING           ("crouching")         // crouched this frame
#define ATTR_PLAYER_BODY_YAW     ("body_yaw")          // which way the body faces (the head turns first)
#define ATTR_PLAYER_STRIDE       ("stride")            // 0 standing .. 1 walking: how far the legs swing
#define ATTR_PLAYER_STEP         ("step")              // walking phase of the legs (also while flying or swimming)
#define ATTR_PLAYER_IN_LAVA      ("in_lava")
#define ATTR_PLAYER_LAVA_TIMER   ("lava_timer")        // time to the next burn
#define ATTR_PLAYER_FIRE_TIMER   ("fire_timer")        // seconds until standing in fire burns again
#define ATTR_PLAYER_PORTAL_TIME  ("portal_time")       // seconds stood in a portal
#define ATTR_PLAYER_PORTAL_DONE  ("portal_done")       // TRUE after going through, until out of the portal
#define ATTR_PLAYER_TRAVEL       ("travel")            // TRUE: take the player through (game_travel)
#define ATTR_MOVE_KEY            ("move_key")
#define ATTR_MOVE_UNTIL          ("move_until")
#define ATTR_MOVE_LAST           ("move_last")
#define ATTR_MOVE_START          ("move_start")
#define ATTR_MOVE_HELD           ("move_held")
#define ATTR_JUMP_UNTIL          ("jump_until")
#define ATTR_TARGET_KIND         ("target_kind")
#define ATTR_TARGET_X            ("target_x")
#define ATTR_TARGET_Y            ("target_y")
#define ATTR_TARGET_Z            ("target_z")
#define ATTR_TARGET_NORMAL_X     ("target_normal_x")
#define ATTR_TARGET_NORMAL_Y     ("target_normal_y")
#define ATTR_TARGET_NORMAL_Z     ("target_normal_z")
#define ATTR_TARGET_COW          ("target_cow")
#define ATTR_BREAK_X             ("break_x")
#define ATTR_BREAK_Y             ("break_y")
#define ATTR_BREAK_Z             ("break_z")
#define ATTR_BREAK_HITS          ("break_hits")
#define ATTR_BREAK_TIME          ("break_time")
#define ATTR_BREAK_NEEDED        ("break_needed")

// ---------------------------------------------------------------- accessors
void    player_reset           (Attributes &p_player, Real p_x, Real p_y, Real p_z);
void    player_position        (Attributes &p_player, Real &p_x, Real &p_y, Real &p_z);
void    player_set_position    (Attributes &p_player, Real p_x, Real p_y, Real p_z);
void    player_velocity        (Attributes &p_player, Real &p_vx, Real &p_vy, Real &p_vz);
void    player_set_velocity    (Attributes &p_player, Real p_vx, Real p_vy, Real p_vz);
void    player_look            (Attributes &p_player, Real &p_yaw, Real &p_pitch);
void    player_set_look        (Attributes &p_player, Real p_yaw, Real p_pitch);
Real    player_eye_y           (Attributes &p_player);
void    player_look_direction  (Attributes &p_player, Real &p_dir_x, Real &p_dir_y, Real &p_dir_z);
Integer player_health          (Attributes &p_player);
void    player_set_health      (Attributes &p_player, Integer p_health);
Integer player_is_dead         (Attributes &p_player);
Integer player_on_ground       (Attributes &p_player);
Integer player_in_water        (Attributes &p_player);
Integer player_eye_in_water    (Attributes &p_player);
Real    player_hurt_time       (Attributes &p_player);
Real    player_swing_time      (Attributes &p_player);
Real    player_bob             (Attributes &p_player);
Real    player_body_yaw        (Attributes &p_player);
Real    player_stride          (Attributes &p_player);
Real    player_step            (Attributes &p_player);
void    player_update_body     (Attributes &p_player, Integer p_walking, Real p_dt);
Real    player_fall_peak       (Attributes &p_player);
void    player_set_fall_peak   (Attributes &p_player, Real p_peak);
Integer player_selected        (Attributes &p_player);
void    player_set_selected    (Attributes &p_player, Integer p_slot);
Integer player_auto_walk       (Attributes &p_player);
void    player_set_auto_walk   (Attributes &p_player, Integer p_on);
Integer player_held_item       (Attributes &p_player, Attributes &p_inventory);
Integer player_target_kind     (Attributes &p_player);
void    player_target_cell     (Attributes &p_player, Integer &p_x, Integer &p_y, Integer &p_z);
void    player_target_normal   (Attributes &p_player, Integer &p_x, Integer &p_y, Integer &p_z);
Integer player_target_cow      (Attributes &p_player);
Integer player_break_stage     (Attributes &p_player, Real p_now);

// ---------------------------------------------------------------- behaviour
void    player_turn            (Attributes &p_player, Real p_yaw_change, Real p_pitch_change);
void    player_key_pressed     (Attributes &p_player, Text p_key, Real p_now);
void    player_sneak_pressed   (Attributes &p_player, Real p_now);
void    player_sprint_pressed  (Attributes &p_player);
Integer player_sprinting       (Attributes &p_player);
Integer player_drop_selected   (Attributes &p_player, Attributes &p_inventory, Attributes &p_events, Integer p_whole_stack);
Integer player_look_facing     (Attributes &p_player);
Integer player_cell_free       (Attributes &p_player, Attributes &p_cows, Integer p_x, Integer p_y, Integer p_z);
Integer player_place_double    (Attributes &p_player, Attributes &p_cows, Attributes &p_events, Integer p_item,
                                Integer p_x, Integer p_y, Integer p_z);
void    player_toggle_door     (Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block);
Integer player_crouching       (Attributes &p_player);
void    player_on_event        (Attributes &p_event, Attributes &p_player, Attributes &p_inventory, Attributes &p_events);
Integer player_flying          (Attributes &p_player);
Integer player_camera          (Attributes &p_player);
void    player_next_camera     (Attributes &p_player);
void    player_set_flying      (Attributes &p_player, Integer p_flying);
Integer player_game_mode       (Attributes &p_player);
void    player_set_game_mode   (Attributes &p_player, Integer p_mode);
Integer player_creative        (Attributes &p_player);
Integer player_spectator       (Attributes &p_player);
Integer player_survival        (Attributes &p_player);
Text    player_game_mode_name  (Integer p_mode);
Integer player_pick_block      (Attributes &p_player, Attributes &p_inventory, Text &p_report);
Integer player_key_active      (Attributes &p_player, Text p_key, Real p_now);
void    player_damage          (Attributes &p_player, Attributes &p_events, Integer p_amount);
void    player_update          (Attributes &p_player, Attributes &p_cows, Attributes &p_events, Integer p_auto_jump, Real p_dt, Real p_now);
void    player_update_target   (Attributes &p_player, Attributes &p_cows);
Integer player_overlaps_cell   (Attributes &p_player, Integer p_x, Integer p_y, Integer p_z);
void    player_wear_tool       (Attributes &p_player, Attributes &p_inventory, Attributes &p_events);
void    player_primary_action  (Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events,
                                Attributes &p_random, Real p_now);
Integer player_in_lava         (Attributes &p_player);
Real    player_portal_time     (Attributes &p_player);
Integer player_wants_travel    (Attributes &p_player);
void    player_arrived         (Attributes &p_player);
void    player_lava_and_portal (Attributes &p_player, Attributes &p_events, Real p_x, Real p_y, Real p_z, Real p_dt);
Integer player_use_slot        (Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Integer p_slot);
void    player_secondary_action(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Real p_now);
Integer player_furnace_facing  (Real p_player_x, Real p_player_z, Integer p_cell_x, Integer p_cell_z);
Integer player_facing_toward   (Real p_player_x, Real p_player_z, Integer p_cell_x, Integer p_cell_z);

#endif
