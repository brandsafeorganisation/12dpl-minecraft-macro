#ifndef PLAYER_4DM_INCLUDED
#define PLAYER_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/world/world.h"
#include "../../include/world/physics.h"
#include "../../include/items/inventory.h"
#include "../../include/mobs/cows.h"
#include "../../include/player/player.h"

// ---------------------------------------------------------------- accessors

void player_reset(Attributes &p_player, Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Stand the player at (x, y, z), alive and at full health, keeping
// the look direction and selected slot
// ----------------------------------------------------------------
{
  Real    l_yaw      = record_real   (p_player, ATTR_YAW);
  Real    l_pitch    = record_real   (p_player, ATTR_PITCH);
  Integer l_selected = record_integer(p_player, ATTR_PLAYER_SELECTED);

  if (l_selected < 1) l_selected = 1;

  record_clear(p_player, DATATYPE_PLAYER);
  player_set_position (p_player, p_x, p_y, p_z);
  player_set_velocity (p_player, 0.0, 0.0, 0.0);
  player_set_look     (p_player, l_yaw, l_pitch);
  player_set_health   (p_player, PLAYER_MAX_HEALTH);
  player_set_selected (p_player, l_selected);
  player_set_fall_peak(p_player, p_y);
  player_set_auto_walk(p_player, FALSE);

  record_set_integer(p_player, ATTR_PLAYER_DEAD,         FALSE);
  record_set_integer(p_player, ATTR_ON_GROUND,           FALSE);
  record_set_integer(p_player, ATTR_PLAYER_IN_WATER,     FALSE);
  record_set_integer(p_player, ATTR_PLAYER_EYE_IN_WATER, FALSE);
  record_set_real   (p_player, ATTR_PLAYER_REGEN,        0.0);
  record_set_real   (p_player, ATTR_PLAYER_HURT,         0.0);
  record_set_real   (p_player, ATTR_PLAYER_SWING,        0.0);
  record_set_real   (p_player, ATTR_PLAYER_BOB,          0.0);
  record_set_text   (p_player, ATTR_MOVE_KEY,            "");
  record_set_real   (p_player, ATTR_MOVE_UNTIL,          0.0);
  record_set_real   (p_player, ATTR_MOVE_LAST,           0.0);
  record_set_real   (p_player, ATTR_MOVE_START,          0.0);
  record_set_integer(p_player, ATTR_MOVE_HELD,           FALSE);
  record_set_real   (p_player, ATTR_JUMP_UNTIL,          0.0);
  record_set_integer(p_player, ATTR_TARGET_KIND,         TARGET_NONE);
  record_set_integer(p_player, ATTR_TARGET_X,            0);
  record_set_integer(p_player, ATTR_TARGET_Y,            0);
  record_set_integer(p_player, ATTR_TARGET_Z,            0);
  record_set_integer(p_player, ATTR_TARGET_NORMAL_X,     0);
  record_set_integer(p_player, ATTR_TARGET_NORMAL_Y,     0);
  record_set_integer(p_player, ATTR_TARGET_NORMAL_Z,     0);
  record_set_integer(p_player, ATTR_TARGET_COW,          0);
  record_set_integer(p_player, ATTR_BREAK_X,             0);
  record_set_integer(p_player, ATTR_BREAK_Y,             -1);
  record_set_integer(p_player, ATTR_BREAK_Z,             0);
  record_set_integer(p_player, ATTR_BREAK_HITS,          0);
  record_set_integer(p_player, ATTR_BREAK_NEEDED,        0);
  record_set_real   (p_player, ATTR_BREAK_TIME,          0.0);
}

void player_position(Attributes &p_player, Real &p_x, Real &p_y, Real &p_z)
// ----------------------------------------------------------------
// Feet position (x, z centre of the footprint, y the soles)
// ----------------------------------------------------------------
{
  p_x = record_real(p_player, ATTR_X);
  p_y = record_real(p_player, ATTR_Y);
  p_z = record_real(p_player, ATTR_Z);
}

void player_set_position(Attributes &p_player, Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Move the player without any collision checks
// ----------------------------------------------------------------
{
  record_set_real(p_player, ATTR_X, p_x);
  record_set_real(p_player, ATTR_Y, p_y);
  record_set_real(p_player, ATTR_Z, p_z);
}

void player_velocity(Attributes &p_player, Real &p_vx, Real &p_vy, Real &p_vz)
// ----------------------------------------------------------------
// Velocity in blocks per second
// ----------------------------------------------------------------
{
  p_vx = record_real(p_player, ATTR_VX);
  p_vy = record_real(p_player, ATTR_VY);
  p_vz = record_real(p_player, ATTR_VZ);
}

void player_set_velocity(Attributes &p_player, Real p_vx, Real p_vy, Real p_vz)
// ----------------------------------------------------------------
// Set the velocity in blocks per second
// ----------------------------------------------------------------
{
  record_set_real(p_player, ATTR_VX, p_vx);
  record_set_real(p_player, ATTR_VY, p_vy);
  record_set_real(p_player, ATTR_VZ, p_vz);
}

void player_look(Attributes &p_player, Real &p_yaw, Real &p_pitch)
// ----------------------------------------------------------------
// Look direction: yaw around the vertical, pitch up (+) and down
// ----------------------------------------------------------------
{
  p_yaw   = record_real(p_player, ATTR_YAW);
  p_pitch = record_real(p_player, ATTR_PITCH);
}

void player_set_look(Attributes &p_player, Real p_yaw, Real p_pitch)
// ----------------------------------------------------------------
// Set the look direction
// ----------------------------------------------------------------
{
  record_set_real(p_player, ATTR_YAW,   p_yaw);
  record_set_real(p_player, ATTR_PITCH, p_pitch);
}

Real player_eye_y(Attributes &p_player)
// ----------------------------------------------------------------
// Height of the player's eyes
// ----------------------------------------------------------------
{
  if (player_crouching(p_player)) return record_real(p_player, ATTR_Y) + CROUCH_EYE_HEIGHT;
  return record_real(p_player, ATTR_Y) + PLAYER_EYE_HEIGHT;
}

Integer player_crouching(Attributes &p_player)
// ----------------------------------------------------------------
// TRUE while the player is crouched (worked out each frame by
// player_update)
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_CROUCHING) == TRUE;
}

void player_look_direction(Attributes &p_player, Real &p_dir_x, Real &p_dir_y, Real &p_dir_z)
// ----------------------------------------------------------------
// Unit vector the player is looking along
// ----------------------------------------------------------------
{
  Real l_yaw   = 0.0;
  Real l_pitch = 0.0;

  player_look(p_player, l_yaw, l_pitch);
  p_dir_x = Cos(l_pitch) * Cos(l_yaw);
  p_dir_y = Sin(l_pitch);
  p_dir_z = Cos(l_pitch) * Sin(l_yaw);
}

Integer player_health(Attributes &p_player)
// ----------------------------------------------------------------
// Health points, 0..PLAYER_MAX_HEALTH
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_HEALTH);
}

void player_set_health(Attributes &p_player, Integer p_health)
// ----------------------------------------------------------------
// Set health, kept within 0..PLAYER_MAX_HEALTH
// ----------------------------------------------------------------
{
  record_set_integer(p_player, ATTR_HEALTH, clamp_integer(p_health, 0, PLAYER_MAX_HEALTH));
}

Integer player_is_dead(Attributes &p_player)
// ----------------------------------------------------------------
// TRUE between dying and respawning
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_PLAYER_DEAD);
}

Integer player_on_ground(Attributes &p_player)
// ----------------------------------------------------------------
// TRUE when standing on something
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_ON_GROUND);
}

Integer player_in_water(Attributes &p_player)
// ----------------------------------------------------------------
// TRUE when the body is in water (swimming)
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_PLAYER_IN_WATER);
}

Integer player_eye_in_water(Attributes &p_player)
// ----------------------------------------------------------------
// TRUE when the eyes are under water (the view turns blue)
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_PLAYER_EYE_IN_WATER);
}

Real player_hurt_time(Attributes &p_player)
// ----------------------------------------------------------------
// Seconds left of the red "hurt" flash
// ----------------------------------------------------------------
{
  return record_real(p_player, ATTR_PLAYER_HURT);
}

Real player_swing_time(Attributes &p_player)
// ----------------------------------------------------------------
// Seconds left of the arm swing
// ----------------------------------------------------------------
{
  return record_real(p_player, ATTR_PLAYER_SWING);
}

Real player_bob(Attributes &p_player)
// ----------------------------------------------------------------
// Walking phase, used to bob the held item
// ----------------------------------------------------------------
{
  return record_real(p_player, ATTR_PLAYER_BOB);
}

Real player_fall_peak(Attributes &p_player)
// ----------------------------------------------------------------
// Highest point since leaving the ground (for fall damage)
// ----------------------------------------------------------------
{
  return record_real(p_player, ATTR_PLAYER_FALL_PEAK);
}

void player_set_fall_peak(Attributes &p_player, Real p_peak)
// ----------------------------------------------------------------
// Set the highest point since leaving the ground
// ----------------------------------------------------------------
{
  record_set_real(p_player, ATTR_PLAYER_FALL_PEAK, p_peak);
}

Integer player_selected(Attributes &p_player)
// ----------------------------------------------------------------
// Selected hotbar slot, 1..HOTBAR_SLOTS
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_PLAYER_SELECTED);
}

void player_set_selected(Attributes &p_player, Integer p_slot)
// ----------------------------------------------------------------
// Select a hotbar slot
// ----------------------------------------------------------------
{
  record_set_integer(p_player, ATTR_PLAYER_SELECTED, clamp_integer(p_slot, 1, HOTBAR_SLOTS));
}

Integer player_auto_walk(Attributes &p_player)
// ----------------------------------------------------------------
// TRUE while auto-walk is on
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_PLAYER_AUTO_WALK);
}

void player_set_auto_walk(Attributes &p_player, Integer p_on)
// ----------------------------------------------------------------
// Turn auto-walk on or off
// ----------------------------------------------------------------
{
  record_set_integer(p_player, ATTR_PLAYER_AUTO_WALK, p_on);
}

Integer player_held_item(Attributes &p_player, Attributes &p_inventory)
// ----------------------------------------------------------------
// Item in the selected hotbar slot
// ----------------------------------------------------------------
{
  return slot_item(p_inventory, player_selected(p_player));
}

Integer player_target_kind(Attributes &p_player)
// ----------------------------------------------------------------
// TARGET_NONE, TARGET_BLOCK or TARGET_COW
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_TARGET_KIND);
}

void player_target_cell(Attributes &p_player, Integer &p_x, Integer &p_y, Integer &p_z)
// ----------------------------------------------------------------
// Cell of the targeted block
// ----------------------------------------------------------------
{
  p_x = record_integer(p_player, ATTR_TARGET_X);
  p_y = record_integer(p_player, ATTR_TARGET_Y);
  p_z = record_integer(p_player, ATTR_TARGET_Z);
}

void player_target_normal(Attributes &p_player, Integer &p_x, Integer &p_y, Integer &p_z)
// ----------------------------------------------------------------
// Outward normal of the targeted face (where a block would go)
// ----------------------------------------------------------------
{
  p_x = record_integer(p_player, ATTR_TARGET_NORMAL_X);
  p_y = record_integer(p_player, ATTR_TARGET_NORMAL_Y);
  p_z = record_integer(p_player, ATTR_TARGET_NORMAL_Z);
}

Integer player_target_cow(Attributes &p_player)
// ----------------------------------------------------------------
// Number of the targeted cow
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_TARGET_COW);
}

Integer player_break_stage(Attributes &p_player, Real p_now)
// ----------------------------------------------------------------
// How cracked the block being broken is: 0 (not started) to
// DESTROY_STAGES
// ----------------------------------------------------------------
{
  Integer l_hits   = record_integer(p_player, ATTR_BREAK_HITS);
  Integer l_needed = record_integer(p_player, ATTR_BREAK_NEEDED);

  if (l_hits <= 0 || record_integer(p_player, ATTR_BREAK_Y) < 0) return 0;
  if (p_now - record_real(p_player, ATTR_BREAK_TIME) > BREAK_RESET_SECONDS) return 0;
  if (l_needed <= 1) return 0;

  return clamp_integer(1 + floor_integer((DESTROY_STAGES - 1.0) * l_hits / l_needed), 1, DESTROY_STAGES);
}

// ---------------------------------------------------------------- behaviour

void player_turn(Attributes &p_player, Real p_yaw_change, Real p_pitch_change)
// ----------------------------------------------------------------
// Mouse look; pitch stops just short of straight up and down
// ----------------------------------------------------------------
{
  Real l_yaw   = 0.0;
  Real l_pitch = 0.0;

  player_look    (p_player, l_yaw, l_pitch);
  player_set_look(p_player, wrap_angle(l_yaw + p_yaw_change), clamp_real(l_pitch + p_pitch_change, -MAX_PITCH, MAX_PITCH));
}

void player_on_event(Attributes &p_event, Attributes &p_player, Attributes &p_events)
// ----------------------------------------------------------------
// EVT_ZOMBIE_ATTACK: a zombie hit the player (i1 damage, r1 and r3
// the direction it was facing), which hurts and knocks back
// ----------------------------------------------------------------
{
  Real l_vx = 0.0;
  Real l_vy = 0.0;
  Real l_vz = 0.0;

  if (event_type(p_event) != EVT_ZOMBIE_ATTACK) return;
  if (player_is_dead(p_player)) return;

  player_damage(p_player, p_events, event_integer(p_event, 1));
  player_velocity(p_player, l_vx, l_vy, l_vz);
  player_set_velocity(p_player, event_real(p_event, 1) * 6.0, 4.5, event_real(p_event, 3) * 6.0);
}

Integer player_flying(Attributes &p_player)
// ----------------------------------------------------------------
// TRUE while fly mode is on (no gravity, Space rises, C sinks)
// ----------------------------------------------------------------
{
  return record_integer(p_player, ATTR_PLAYER_FLYING);
}

void player_set_flying(Attributes &p_player, Integer p_flying)
// ----------------------------------------------------------------
// Turn fly mode on or off; landing after flying does no harm
// ----------------------------------------------------------------
{
  Real l_x = 0.0;
  Real l_y = 0.0;
  Real l_z = 0.0;

  player_position(p_player, l_x, l_y, l_z);
  record_set_integer  (p_player, ATTR_PLAYER_FLYING, p_flying);
  player_set_fall_peak(p_player, l_y);
}

Integer player_pick_block(Attributes &p_player, Attributes &p_inventory, Text &p_report)
// ----------------------------------------------------------------
// Pick block: select the hotbar slot holding the item of the block
// under the crosshair, or swap it into the selected hotbar slot
// from the rest of the inventory. Returns TRUE if the held item
// changed; p_report says what happened.
// ----------------------------------------------------------------
{
  Integer l_x        = 0;
  Integer l_y        = 0;
  Integer l_z        = 0;
  Integer l_block    = BLOCK_AIR;
  Integer l_item     = ITEM_NONE;
  Integer l_slot     = 0;
  Integer l_selected = player_selected(p_player);

  p_report = "";
  if (player_target_kind(p_player) != TARGET_BLOCK) return FALSE;
  player_target_cell(p_player, l_x, l_y, l_z);
  l_block = world_get_block(l_x, l_y, l_z);
  l_item  = block_pick_item(l_block);
  if (l_item == ITEM_NONE) return FALSE;

  for (l_slot = 1; l_slot <= HOTBAR_SLOTS; ++l_slot) {
    if (slot_item(p_inventory, l_slot) == l_item) {
      player_set_selected(p_player, l_slot);
      return TRUE;
    }
  }
  for (l_slot = HOTBAR_SLOTS + 1; l_slot <= INVENTORY_SLOTS; ++l_slot) {
    if (slot_item(p_inventory, l_slot) == l_item) {
      slot_swap(p_inventory, l_slot, l_selected);
      return TRUE;
    }
  }
  p_report = "No " + item_name(l_item) + " in your inventory";
  return FALSE;
}

void player_key_pressed(Attributes &p_player, Text p_key, Real p_now)
// ----------------------------------------------------------------
// A movement key (w a s d, space) arrived from the keyboard box
// Only the last key held down auto-repeats, and there is no key-up
// event, so a fresh press moves for TAP_TIME and every repeat keeps
// the key alive a little longer. Jumping keeps the last movement
// going so you can run and jump.
// ----------------------------------------------------------------
{
  Text l_move_key   = record_text(p_player, ATTR_MOVE_KEY);
  Real l_move_last  = record_real(p_player, ATTR_MOVE_LAST);
  Real l_move_until = record_real(p_player, ATTR_MOVE_UNTIL);

  if (p_key == "w" || p_key == "a" || p_key == "s" || p_key == "d") {
    if (p_key == l_move_key && p_now - l_move_last < HELD_KEY_WINDOW) {
      record_set_real   (p_player, ATTR_MOVE_UNTIL, p_now + HELD_KEY_EXTEND);
      record_set_integer(p_player, ATTR_MOVE_HELD,  TRUE);
    } else {
      record_set_real   (p_player, ATTR_MOVE_UNTIL, p_now + TAP_TIME);
      record_set_real   (p_player, ATTR_MOVE_START, p_now);
      record_set_integer(p_player, ATTR_MOVE_HELD,  FALSE);
    }
    record_set_text(p_player, ATTR_MOVE_KEY,  p_key);
    record_set_real(p_player, ATTR_MOVE_LAST, p_now);
    if (p_key == "s") player_set_auto_walk(p_player, FALSE);
    return;
  }

  if (p_key == "c") {
    if (player_flying(p_player)) {
      record_set_real(p_player, ATTR_FLY_DOWN_UNTIL, p_now + FLY_KEY_SECONDS);
    } else {
      record_set_integer(p_player, ATTR_CROUCH_TOGGLE, record_integer(p_player, ATTR_CROUCH_TOGGLE) != TRUE);
    }
    return;
  }

  if (p_key == " ") {
    record_set_real(p_player, ATTR_JUMP_UNTIL, p_now + 0.25);
    if (l_move_until > p_now - 0.15) {
      record_set_real   (p_player, ATTR_MOVE_UNTIL, max_real(l_move_until, p_now + 0.55));
      record_set_integer(p_player, ATTR_MOVE_HELD,  TRUE);
    }
  }
}

void player_shift_pressed(Attributes &p_player, Real p_now)
// ----------------------------------------------------------------
// A key arrived with Shift held (a capital W, A, S or D): Shift
// sinks while flying and crouches otherwise. There is no key-up
// event, so it lasts a moment and each repeat of the key renews it.
// ----------------------------------------------------------------
{
  if (player_flying(p_player)) {
    record_set_real(p_player, ATTR_FLY_DOWN_UNTIL, p_now + FLY_KEY_SECONDS);
  } else {
    record_set_real(p_player, ATTR_CROUCH_UNTIL, p_now + CROUCH_HOLD_SECONDS);
  }
}

Integer player_key_active(Attributes &p_player, Text p_key, Real p_now)
// ----------------------------------------------------------------
// TRUE while a movement key counts as held down
// ----------------------------------------------------------------
{
  if (record_text(p_player, ATTR_MOVE_KEY) == p_key && p_now < record_real(p_player, ATTR_MOVE_UNTIL)) return TRUE;
  return FALSE;
}

void player_damage(Attributes &p_player, Attributes &p_events, Integer p_amount)
// ----------------------------------------------------------------
// Take damage; emits EVT_PLAYER_HURT and EVT_PLAYER_DIED
// ----------------------------------------------------------------
{
  Integer l_health = player_health(p_player) - p_amount;

  if (player_is_dead(p_player) || p_amount <= 0) return;

  player_set_health(p_player, l_health);
  record_set_real  (p_player, ATTR_PLAYER_HURT,  0.4);
  record_set_real  (p_player, ATTR_PLAYER_REGEN, 0.0);
  emit_item_event(p_events, EVT_PLAYER_HURT, p_amount, 0);

  if (l_health <= 0) {
    record_set_integer(p_player, ATTR_PLAYER_DEAD, TRUE);
    emit_simple_event(p_events, EVT_PLAYER_DIED);
  }
}

void player_update(Attributes &p_player, Attributes &p_cows, Attributes &p_events, Integer p_auto_jump, Real p_dt, Real p_now)
// ----------------------------------------------------------------
// Walk, jump, swim, fall and collide; fall damage, regeneration
// and what the crosshair points at
// The record is read into locals at the start and written back at
// the end, since a frame uses each field many times.
// ----------------------------------------------------------------
{
  Real    l_x            = 0.0;
  Real    l_y            = 0.0;
  Real    l_z            = 0.0;
  Real    l_vx           = 0.0;
  Real    l_vy           = 0.0;
  Real    l_vz           = 0.0;
  Real    l_yaw          = 0.0;
  Real    l_pitch        = 0.0;
  Integer l_on_ground    = player_on_ground(p_player);
  Integer l_in_water     = player_in_water(p_player);
  Integer l_auto_walk    = player_auto_walk(p_player);
  Integer l_move_held    = record_integer(p_player, ATTR_MOVE_HELD);
  Real    l_move_start   = record_real   (p_player, ATTR_MOVE_START);
  Real    l_jump_until   = record_real   (p_player, ATTR_JUMP_UNTIL);
  Real    l_fall_peak    = player_fall_peak(p_player);
  Real    l_regen        = record_real   (p_player, ATTR_PLAYER_REGEN);
  Integer l_health       = player_health(p_player);
  Real    l_forward      = 0.0;
  Real    l_strafe       = 0.0;
  Real    l_ease         = 1.0;
  Real    l_speed        = 0.0;
  Real    l_heading_x    = 0.0;
  Real    l_heading_z    = 0.0;
  Real    l_wish_x       = 0.0;
  Real    l_wish_z       = 0.0;
  Real    l_wish_length  = 0.0;
  Real    l_blend        = 0.0;
  Real    l_move_x       = 0.0;
  Real    l_move_y       = 0.0;
  Real    l_move_z       = 0.0;
  Real    l_fall         = 0.0;
  Real    l_longest      = 0.0;
  Integer l_steps        = 1;
  Integer l_step         = 0;
  Integer l_was_grounded = l_on_ground;
  Integer l_blocked      = FALSE;
  Integer l_moving       = FALSE;
  Integer l_hit_x        = FALSE;
  Integer l_hit_z        = FALSE;
  Integer l_hit_down     = FALSE;
  Integer l_hit_up       = FALSE;
  Integer l_flying       = player_flying(p_player);
  Real    l_down_until   = record_real(p_player, ATTR_FLY_DOWN_UNTIL);
  Integer l_crouching    = FALSE;
  Real    l_eye_height   = PLAYER_EYE_HEIGHT;

  record_set_real(p_player, ATTR_PLAYER_HURT,  player_hurt_time (p_player) - p_dt);
  record_set_real(p_player, ATTR_PLAYER_SWING, player_swing_time(p_player) - p_dt);
  if (player_is_dead(p_player)) return;

  player_position(p_player, l_x, l_y, l_z);
  player_velocity(p_player, l_vx, l_vy, l_vz);
  player_look    (p_player, l_yaw, l_pitch);
  l_heading_x = Cos(l_yaw);
  l_heading_z = Sin(l_yaw);

  // Movement input
  if (player_key_active(p_player, "w", p_now)) l_forward =  1.0;
  if (player_key_active(p_player, "s", p_now)) l_forward = -1.0;
  if (player_key_active(p_player, "a", p_now)) l_strafe  = -1.0;
  if (player_key_active(p_player, "d", p_now)) l_strafe  =  1.0;
  if (l_auto_walk && l_forward == 0.0) l_forward = 1.0;

  if (!l_move_held && !l_auto_walk) {
    l_ease = TAP_START_SPEED + (1.0 - TAP_START_SPEED) * clamp_real((p_now - l_move_start) / TAP_RAMP, 0.0, 1.0);
  }
  l_speed = WALK_SPEED * l_ease;
  // Crouching (C, or Shift with a movement key; not while flying):
  // slower, lower eyes, and you don't walk off edges
  if (!l_flying) {
    if (record_integer(p_player, ATTR_CROUCH_TOGGLE) == TRUE || p_now < record_real(p_player, ATTR_CROUCH_UNTIL)) l_crouching = TRUE;
  }
  record_set_integer(p_player, ATTR_CROUCHING, l_crouching);
  if (l_crouching) l_eye_height = CROUCH_EYE_HEIGHT;

  if (l_in_water) l_speed = l_speed * WATER_SPEED_FACTOR;
  if (l_flying)   l_speed = l_speed * FLY_SPEED_FACTOR;
  if (l_crouching) l_speed = l_speed * CROUCH_SPEED_FACTOR;

  l_wish_x = l_heading_x * l_forward - l_heading_z * l_strafe;
  l_wish_z = l_heading_z * l_forward + l_heading_x * l_strafe;
  l_wish_length = Sqrt(l_wish_x * l_wish_x + l_wish_z * l_wish_z);
  if (l_wish_length > 0.001) {
    l_wish_x = l_wish_x / l_wish_length;
    l_wish_z = l_wish_z / l_wish_length;
    l_moving = TRUE;
  }

  if (l_on_ground || l_flying) {
    l_vx = l_wish_x * l_speed;
    l_vz = l_wish_z * l_speed;
  } else {
    l_blend = min_real(1.0, p_dt * 5.0);
    l_vx = l_vx + (l_wish_x * l_speed - l_vx) * l_blend;
    l_vz = l_vz + (l_wish_z * l_speed - l_vz) * l_blend;
  }

  // Flying: no gravity, Space rises and C sinks while pressed
  if (l_flying) {
    l_vy = 0.0;
    if (p_now < l_jump_until) l_vy = FLY_VERTICAL_SPEED;
    if (p_now < l_down_until) l_vy = -FLY_VERTICAL_SPEED;
  }

  // Jumping and swimming
  if (l_flying) {
    // handled above
  } else if (p_now < l_jump_until) {
    if (l_in_water) {
      l_vy = SWIM_UP_SPEED;
    } else if (l_on_ground) {
      l_vy         = JUMP_SPEED;
      l_jump_until = 0.0;
    }
  }

  if (l_flying) {
    // no gravity
  } else if (l_in_water) {
    l_vy = l_vy - SWIM_GRAVITY * p_dt;
    if (l_vy < -SWIM_SINK_SPEED) l_vy = -SWIM_SINK_SPEED;
  } else {
    l_vy = l_vy - GRAVITY * p_dt;
    if (l_vy < -TERMINAL_SPEED) l_vy = -TERMINAL_SPEED;
  }

  // Move in steps short enough not to pass through a block
  l_move_x  = l_vx * p_dt;
  l_move_y  = l_vy * p_dt;
  l_move_z  = l_vz * p_dt;
  // crouched on the ground: refuse a step along x or z that would
  // leave nothing under you
  if (l_crouching && l_on_ground && !l_in_water) {
    if (!physics_box_collides(l_x + l_move_x - PLAYER_HALF_WIDTH, l_y - 0.1, l_z - PLAYER_HALF_WIDTH,
                              l_x + l_move_x + PLAYER_HALF_WIDTH, l_y - 0.01, l_z + PLAYER_HALF_WIDTH)) {
      l_move_x = 0.0;
      l_vx     = 0.0;
    }
    if (!physics_box_collides(l_x + l_move_x - PLAYER_HALF_WIDTH, l_y - 0.1, l_z + l_move_z - PLAYER_HALF_WIDTH,
                              l_x + l_move_x + PLAYER_HALF_WIDTH, l_y - 0.01, l_z + l_move_z + PLAYER_HALF_WIDTH)) {
      l_move_z = 0.0;
      l_vz     = 0.0;
    }
  }
  l_longest = max_real(Absolute(l_move_y), max_real(Absolute(l_move_x), Absolute(l_move_z)));
  l_steps   = 1 + Floor(l_longest / MAX_MOVE_STEP);

  l_on_ground = FALSE;
  for (l_step = 1; l_step <= l_steps; ++l_step) {
    physics_move_box(l_x, l_y, l_z, PLAYER_HALF_WIDTH, PLAYER_HEIGHT, l_move_x / l_steps, l_move_y / l_steps, l_move_z / l_steps,
                     l_hit_x, l_hit_z, l_hit_down, l_hit_up);
    if (l_hit_down) {
      l_on_ground = TRUE;
      if (l_vy < 0.0) l_vy = 0.0;
    }
    if (l_hit_up && l_vy > 0.0) l_vy = 0.0;
    if (l_hit_x || l_hit_z) l_blocked = TRUE;
  }

  // Auto-jump: walking into a one block step hops up it, and
  // swimming into the shore climbs out (only if the body, one block
  // higher and a little further on, would be clear: not at a wall or
  // a shut door)
  if (l_blocked && l_moving) {
    if (!physics_box_collides(l_x + l_wish_x * 0.2 - PLAYER_HALF_WIDTH, l_y + 1.05, l_z + l_wish_z * 0.2 - PLAYER_HALF_WIDTH,
                              l_x + l_wish_x * 0.2 + PLAYER_HALF_WIDTH, l_y + 1.05 + PLAYER_HEIGHT, l_z + l_wish_z * 0.2 + PLAYER_HALF_WIDTH)) {
      if (l_in_water) {
        l_vy = SWIM_UP_SPEED * 1.6;
      } else if (l_on_ground && p_auto_jump) {
        l_vy = JUMP_SPEED;
      }
    }
  }

  // Water
  l_in_water = physics_box_in_water(l_x, l_y, l_z, PLAYER_HALF_WIDTH, PLAYER_HEIGHT);
  record_set_integer(p_player, ATTR_PLAYER_IN_WATER,     l_in_water);
  record_set_integer(p_player, ATTR_PLAYER_EYE_IN_WATER, world_get_block(floor_integer(l_x), floor_integer(l_y + l_eye_height), floor_integer(l_z)) == BLOCK_WATER);

  player_set_position(p_player, l_x, l_y, l_z);
  player_set_velocity(p_player, l_vx, l_vy, l_vz);
  record_set_integer (p_player, ATTR_ON_GROUND,  l_on_ground);
  record_set_real    (p_player, ATTR_JUMP_UNTIL, l_jump_until);

  // Fall damage: measured from the highest point since leaving the
  // ground; water (and flying) breaks any fall
  if (l_in_water || l_flying) {
    l_fall_peak = l_y;
  } else if (l_on_ground) {
    if (!l_was_grounded) {
      l_fall = l_fall_peak - l_y;
      if (l_fall > FALL_DAMAGE_START) player_damage(p_player, p_events, floor_integer(l_fall - FALL_DAMAGE_START + 0.5));
    }
    l_fall_peak = l_y;
  } else if (l_y > l_fall_peak) {
    l_fall_peak = l_y;
  }
  player_set_fall_peak(p_player, l_fall_peak);

  if (l_on_ground && l_moving) record_set_real(p_player, ATTR_PLAYER_BOB, player_bob(p_player) + p_dt * 9.0 * l_ease);

  // Slow healing
  l_health = player_health(p_player);
  if (l_health < PLAYER_MAX_HEALTH && !player_is_dead(p_player)) {
    l_regen = l_regen + p_dt;
    if (l_regen >= REGEN_SECONDS) {
      l_regen = 0.0;
      player_set_health(p_player, l_health + 1);
    }
  }
  record_set_real(p_player, ATTR_PLAYER_REGEN, l_regen);

  if (p_now - record_real(p_player, ATTR_BREAK_TIME) > BREAK_RESET_SECONDS) record_set_integer(p_player, ATTR_BREAK_HITS, 0);

  player_update_target(p_player, p_cows);
}

void player_update_target(Attributes &p_player, Attributes &p_cows)
// ----------------------------------------------------------------
// Find what the crosshair is on within reach: a cow or a block
// ----------------------------------------------------------------
{
  Real    l_eye_x          = record_real(p_player, ATTR_X);
  Real    l_eye_y          = player_eye_y(p_player);
  Real    l_eye_z          = record_real(p_player, ATTR_Z);
  Real    l_dir_x          = 0.0;
  Real    l_dir_y          = 0.0;
  Real    l_dir_z          = 0.0;
  Real    l_block_distance = PLAYER_REACH;
  Real    l_cow_distance   = 0.0;
  Integer l_block_hit      = FALSE;
  Integer l_hit_x          = 0;
  Integer l_hit_y          = 0;
  Integer l_hit_z          = 0;
  Integer l_normal_x       = 0;
  Integer l_normal_y       = 0;
  Integer l_normal_z       = 0;
  Integer l_cow            = 0;
  Integer l_kind           = TARGET_NONE;

  player_look_direction(p_player, l_dir_x, l_dir_y, l_dir_z);

  l_block_hit = physics_raycast_blocks(l_eye_x, l_eye_y, l_eye_z, l_dir_x, l_dir_y, l_dir_z, PLAYER_REACH,
                                     l_hit_x, l_hit_y, l_hit_z, l_normal_x, l_normal_y, l_normal_z, l_block_distance);
  if (l_block_hit) {
    record_set_integer(p_player, ATTR_TARGET_X,        l_hit_x);
    record_set_integer(p_player, ATTR_TARGET_Y,        l_hit_y);
    record_set_integer(p_player, ATTR_TARGET_Z,        l_hit_z);
    record_set_integer(p_player, ATTR_TARGET_NORMAL_X, l_normal_x);
    record_set_integer(p_player, ATTR_TARGET_NORMAL_Y, l_normal_y);
    record_set_integer(p_player, ATTR_TARGET_NORMAL_Z, l_normal_z);
    l_kind = TARGET_BLOCK;
  } else {
    l_block_distance = PLAYER_REACH;
  }

  l_cow = cows_ray_hit(p_cows, l_eye_x, l_eye_y, l_eye_z, l_dir_x, l_dir_y, l_dir_z, l_block_distance, l_cow_distance);
  if (l_cow > 0) {
    l_kind = TARGET_COW;
    record_set_integer(p_player, ATTR_TARGET_COW, l_cow);
  }
  record_set_integer(p_player, ATTR_TARGET_KIND, l_kind);
}

Integer player_overlaps_cell(Attributes &p_player, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// TRUE if the player's body overlaps block cell (x, y, z)
// ----------------------------------------------------------------
{
  Real l_px = 0.0;
  Real l_py = 0.0;
  Real l_pz = 0.0;

  player_position(p_player, l_px, l_py, l_pz);
  if (l_px + PLAYER_HALF_WIDTH <= p_x || l_px - PLAYER_HALF_WIDTH >= p_x + 1.0) return FALSE;
  if (l_pz + PLAYER_HALF_WIDTH <= p_z || l_pz - PLAYER_HALF_WIDTH >= p_z + 1.0) return FALSE;
  if (l_py + PLAYER_HEIGHT     <= p_y || l_py                     >= p_y + 1.0) return FALSE;
  return TRUE;
}

void player_wear_tool(Attributes &p_player, Attributes &p_inventory, Attributes &p_events)
// ----------------------------------------------------------------
// The held item was used once; tools wear and may break
// ----------------------------------------------------------------
{
  Integer l_slot = player_selected(p_player);
  Integer l_item = slot_item(p_inventory, l_slot);

  if (slot_wear(p_inventory, l_slot)) {
    emit_toast(p_events, item_name(l_item) + " broke");
  }
}

void player_primary_action(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events,
                           Attributes &p_random, Real p_now)
// ----------------------------------------------------------------
// Left click: hit a cow, or chip away at a block until it breaks
// Harder blocks take more hits, the right tool takes fewer; a pause
// of BREAK_RESET_SECONDS starts the count again
// ----------------------------------------------------------------
{
  Integer l_held   = player_held_item(p_player, p_inventory);
  Integer l_block  = 0;
  Integer l_needed = 0;
  Integer l_hits   = 0;
  Integer l_x      = 0;
  Integer l_y      = 0;
  Integer l_z      = 0;
  Real    l_yaw    = 0.0;
  Real    l_pitch  = 0.0;

  if (player_is_dead(p_player)) return;

  record_set_real     (p_player, ATTR_PLAYER_SWING, 0.25);
  player_update_target(p_player, p_cows);
  player_look         (p_player, l_yaw, l_pitch);

  if (player_target_kind(p_player) == TARGET_COW) {
    cow_damage(p_cows, p_events, p_random, player_target_cow(p_player), item_attack_damage(l_held), Cos(l_yaw), Sin(l_yaw));
    if (item_tool_kind(l_held) != TOOL_NONE) player_wear_tool(p_player, p_inventory, p_events);
    return;
  }
  if (player_target_kind(p_player) != TARGET_BLOCK) return;

  player_target_cell(p_player, l_x, l_y, l_z);
  l_block  = world_get_block(l_x, l_y, l_z);
  l_needed = block_hits_with(l_block, l_held);
  if (l_needed <= 0) {
    emit_toast(p_events, "That is far too hard to break");
    return;
  }

  l_hits = record_integer(p_player, ATTR_BREAK_HITS);
  if (l_x == record_integer(p_player, ATTR_BREAK_X) && l_y == record_integer(p_player, ATTR_BREAK_Y) &&
      l_z == record_integer(p_player, ATTR_BREAK_Z) && p_now - record_real(p_player, ATTR_BREAK_TIME) <= BREAK_RESET_SECONDS && l_hits > 0) {
    ++l_hits;
  } else {
    record_set_integer(p_player, ATTR_BREAK_X, l_x);
    record_set_integer(p_player, ATTR_BREAK_Y, l_y);
    record_set_integer(p_player, ATTR_BREAK_Z, l_z);
    l_hits = 1;
  }
  record_set_integer(p_player, ATTR_BREAK_HITS, l_hits);
  record_set_integer(p_player, ATTR_BREAK_NEEDED, l_needed);
  record_set_real   (p_player, ATTR_BREAK_TIME, p_now);

  if (l_hits >= l_needed) {
    if (block_needs_tool(l_block) && item_tool_kind(l_held) != block_tool_kind(l_block)) {
      emit_toast(p_events, "You need a pickaxe to collect that");
    }
    world_break_block(p_events, l_x, l_y, l_z, l_held);
    if (item_tool_kind(l_held) != TOOL_NONE) player_wear_tool(p_player, p_inventory, p_events);
    record_set_integer(p_player, ATTR_BREAK_HITS, 0);
    record_set_integer(p_player, ATTR_BREAK_Y,    -1);
    player_update_target(p_player, p_cows);
  }
}

Integer player_look_facing(Attributes &p_player)
// ----------------------------------------------------------------
// FACING_* nearest to the direction the player is looking
// ----------------------------------------------------------------
{
  Real l_yaw    = 0.0;
  Real l_pitch  = 0.0;
  Real l_look_x = 0.0;
  Real l_look_z = 0.0;

  player_look(p_player, l_yaw, l_pitch);
  l_look_x = Cos(l_yaw);
  l_look_z = Sin(l_yaw);
  if (Absolute(l_look_x) >= Absolute(l_look_z)) {
    if (l_look_x > 0.0) return FACING_PX;
    return FACING_NX;
  }
  if (l_look_z > 0.0) return FACING_PZ;
  return FACING_NZ;
}

Integer player_cell_free(Attributes &p_player, Attributes &p_cows, Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// TRUE if a block could go in cell (x, y, z): it is in the world,
// holds air, water or a plant, and no one is standing in it
// ----------------------------------------------------------------
{
  Integer l_existing = 0;

  if (!world_in_bounds(p_x, p_y, p_z)) return FALSE;
  l_existing = world_get_block(p_x, p_y, p_z);
  if (l_existing != BLOCK_AIR && l_existing != BLOCK_WATER && !block_is_plant(l_existing)) return FALSE;
  if (player_overlaps_cell(p_player, p_x, p_y, p_z)) return FALSE;
  if (cows_box_overlaps(p_cows, p_x, p_y, p_z, p_x + 1.0, p_y + 1.0, p_z + 1.0)) return FALSE;
  return TRUE;
}

Integer player_place_double(Attributes &p_player, Attributes &p_cows, Attributes &p_events, Integer p_item,
                            Integer p_x, Integer p_y, Integer p_z)
// ----------------------------------------------------------------
// Put down a door (its bottom half in cell x, y, z and its top half
// above, shut, on the side of the cell the player is looking
// towards) or a bed (its foot in the cell and its head one cell
// further on the way the player is looking). Both cells must be free
// and stand on something solid. Returns TRUE if it was placed.
// ----------------------------------------------------------------
{
  Integer l_facing = player_look_facing(p_player);
  Integer l_dx     = 0;
  Integer l_dz     = 0;

  if (p_item == ITEM_DOOR) {
    if (!world_is_solid(p_x, p_y - 1, p_z) || !player_cell_free(p_player, p_cows, p_x, p_y + 1, p_z)) {
      emit_toast(p_events, "A door needs two free blocks on solid ground");
      return FALSE;
    }
    if (!player_cell_free(p_player, p_cows, p_x, p_y, p_z)) return FALSE;
    world_place_block(p_events, p_x, p_y,     p_z, block_door(l_facing, FALSE, FALSE));
    world_place_block(p_events, p_x, p_y + 1, p_z, block_door(l_facing, FALSE, TRUE));
    return TRUE;
  }

  block_facing_step(l_facing, l_dx, l_dz);
  if (!world_is_solid(p_x, p_y - 1, p_z) || !world_is_solid(p_x + l_dx, p_y - 1, p_z + l_dz) ||
      !player_cell_free(p_player, p_cows, p_x + l_dx, p_y, p_z + l_dz)) {
    emit_toast(p_events, "A bed needs two free blocks side by side on solid ground");
    return FALSE;
  }
  if (!player_cell_free(p_player, p_cows, p_x, p_y, p_z)) return FALSE;
  world_place_block(p_events, p_x,        p_y, p_z,        block_bed(l_facing, FALSE));
  world_place_block(p_events, p_x + l_dx, p_y, p_z + l_dz, block_bed(l_facing, TRUE));
  return TRUE;
}

void player_toggle_door(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)
// ----------------------------------------------------------------
// Open a shut door or shut an open one (both halves)
// ----------------------------------------------------------------
{
  Integer l_open   = !block_door_open(p_block);
  Integer l_facing = block_door_facing(p_block);
  Integer l_px     = 0;
  Integer l_py     = 0;
  Integer l_pz     = 0;

  world_place_block(p_events, p_x, p_y, p_z, block_door(l_facing, l_open, block_door_top(p_block)));
  if (block_partner(p_block, p_x, p_y, p_z, l_px, l_py, l_pz)) {
    if (block_is_door(world_get_block(l_px, l_py, l_pz))) {
      world_place_block(p_events, l_px, l_py, l_pz, block_door(l_facing, l_open, !block_door_top(p_block)));
    }
  }
}

Integer player_furnace_facing(Real p_player_x, Real p_player_z, Integer p_cell_x, Integer p_cell_z)
// ----------------------------------------------------------------
// The furnace block that turns its door towards the player
// ----------------------------------------------------------------
{
  Real l_toward_x = p_player_x - (p_cell_x + 0.5);
  Real l_toward_z = p_player_z - (p_cell_z + 0.5);

  if (Absolute(l_toward_x) >= Absolute(l_toward_z)) {
    if (l_toward_x > 0.0) return BLOCK_FURNACE_PX;
    return BLOCK_FURNACE_NX;
  }
  if (l_toward_z > 0.0) return BLOCK_FURNACE_PZ;
  return BLOCK_FURNACE_NZ;
}

void player_secondary_action(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Real p_now)
// ----------------------------------------------------------------
// Right click: open a crafting table or furnace, eat food, or
// place the held block against the face the crosshair is on
// (a plant there is replaced)
// ----------------------------------------------------------------
{
  Integer l_held     = player_held_item(p_player, p_inventory);
  Integer l_slot     = player_selected(p_player);
  Integer l_block    = 0;
  Integer l_place    = BLOCK_AIR;
  Integer l_x        = 0;
  Integer l_y        = 0;
  Integer l_z        = 0;
  Integer l_normal_x = 0;
  Integer l_normal_y = 0;
  Integer l_normal_z = 0;
  Integer l_cell_x   = 0;
  Integer l_cell_y   = 0;
  Integer l_cell_z   = 0;
  Integer l_existing = 0;
  Integer l_food     = 0;
  Real    l_px       = 0.0;
  Real    l_py       = 0.0;
  Real    l_pz       = 0.0;

  if (player_is_dead(p_player)) return;

  player_update_target(p_player, p_cows);
  player_target_cell  (p_player, l_x, l_y, l_z);
  player_target_normal(p_player, l_normal_x, l_normal_y, l_normal_z);

  if (player_target_kind(p_player) == TARGET_BLOCK) {
    l_block = world_get_block(l_x, l_y, l_z);
    if (l_block == BLOCK_CRAFTING_TABLE) {
      emit_event(p_events, EVT_OPEN_SCREEN, SCREEN_CRAFTING, l_x, l_y, l_z, 0.0, 0.0, 0.0, "");
      return;
    }
    if (block_is_furnace(l_block)) {
      emit_event(p_events, EVT_OPEN_SCREEN, SCREEN_FURNACE, l_x, l_y, l_z, 0.0, 0.0, 0.0, "");
      return;
    }
    if (l_block == BLOCK_CHEST) {
      emit_event(p_events, EVT_OPEN_SCREEN, SCREEN_CHEST, l_x, l_y, l_z, 0.0, 0.0, 0.0, "");
      return;
    }
    if (l_block == BLOCK_BED || block_is_bed(l_block)) {
      emit_event(p_events, EVT_SLEEP, l_x, l_y, l_z, 0, 0.0, 0.0, 0.0, "");
      return;
    }
    if (block_is_door(l_block)) {
      player_toggle_door(p_events, l_x, l_y, l_z, l_block);
      record_set_real(p_player, ATTR_PLAYER_SWING, 0.25);
      return;
    }
  }

  l_food = item_food_value(l_held);
  if (l_food > 0) {
    if (player_health(p_player) >= PLAYER_MAX_HEALTH) {
      emit_toast(p_events, "You are already at full health");
      return;
    }
    player_set_health(p_player, player_health(p_player) + l_food);
    slot_take_one    (p_inventory, l_slot);
    record_set_real  (p_player, ATTR_PLAYER_SWING, 0.25);
    emit_item_event(p_events, EVT_PLAYER_ATE, l_held, l_food);
    return;
  }

  l_place = item_places_block(l_held);
  if (l_held == ITEM_DOOR) l_place = BLOCK_DOOR_FIRST;
  if (l_place == BLOCK_AIR) return;
  if (player_target_kind(p_player) != TARGET_BLOCK) return;

  // Clicking a plant replaces it; otherwise the block goes against
  // the face that was clicked
  l_cell_x = l_x + l_normal_x;
  l_cell_y = l_y + l_normal_y;
  l_cell_z = l_z + l_normal_z;
  if (block_is_plant(world_get_block(l_x, l_y, l_z))) {
    l_cell_x = l_x;
    l_cell_y = l_y;
    l_cell_z = l_z;
  } else if (l_normal_x == 0 && l_normal_y == 0 && l_normal_z == 0) {
    return;
  }
  if (!world_in_bounds(l_cell_x, l_cell_y, l_cell_z)) return;

  l_existing = world_get_block(l_cell_x, l_cell_y, l_cell_z);
  if (l_existing != BLOCK_AIR && l_existing != BLOCK_WATER && !block_is_plant(l_existing)) return;

  // Plants need ground to stand on; a torch needs any solid block
  if (l_place == BLOCK_TORCH) {
    if (!world_is_solid(l_cell_x, l_cell_y - 1, l_cell_z)) {
      emit_toast(p_events, "Torches go on top of a block");
      return;
    }
  } else if (block_is_plant(l_place)) {
    if (world_get_block(l_cell_x, l_cell_y - 1, l_cell_z) != BLOCK_GRASS && world_get_block(l_cell_x, l_cell_y - 1, l_cell_z) != BLOCK_DIRT) return;
  } else {
    // Not inside the player or a cow
    if (player_overlaps_cell(p_player, l_cell_x, l_cell_y, l_cell_z)) return;
    if (cows_box_overlaps(p_cows, l_cell_x, l_cell_y, l_cell_z, l_cell_x + 1.0, l_cell_y + 1.0, l_cell_z + 1.0)) return;
  }

  if (l_held == ITEM_FURNACE) {
    player_position(p_player, l_px, l_py, l_pz);
    l_place = player_furnace_facing(l_px, l_pz, l_cell_x, l_cell_z);
  }

  // Doors and beds take two cells
  if (l_held == ITEM_DOOR || l_held == ITEM_BED) {
    if (!player_place_double(p_player, p_cows, p_events, l_held, l_cell_x, l_cell_y, l_cell_z)) return;
    slot_take_one       (p_inventory, l_slot);
    record_set_real     (p_player, ATTR_PLAYER_SWING, 0.25);
    player_update_target(p_player, p_cows);
    return;
  }

  world_place_block(p_events, l_cell_x, l_cell_y, l_cell_z, l_place);
  slot_take_one    (p_inventory, l_slot);
  record_set_real  (p_player, ATTR_PLAYER_SWING, 0.25);
  player_update_target(p_player, p_cows);
}

#endif
