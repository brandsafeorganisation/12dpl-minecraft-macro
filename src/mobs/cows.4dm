#ifndef COWS_4DM_INCLUDED
#define COWS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/config.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"
#include "../../include/blocks/blocks.h"
#include "../../include/world/world.h"
#include "../../include/world/physics.h"
#include "../../include/core/slots.h"
#include "../../include/mobs/cows.h"

// ---------------------------------------------------------------- accessors

void cows_clear(Attributes &p_cows)
// ----------------------------------------------------------------
// Remove every cow
// ----------------------------------------------------------------
{
  Integer l_cow = 0;

  record_clear   (p_cows, DATATYPE_COWS);
  record_set_real(p_cows, ATTR_COW_RESPAWN, 0.0);
  for (l_cow = 1; l_cow <= MAX_COWS; ++l_cow) record_set_integer_at(p_cows, ATTR_USED, l_cow, FALSE);
  slots_reset(SLOT_POOL_MOBS);
}

void mobs_rebuild_index(Attributes &p_cows)
// ----------------------------------------------------------------
// Rebuild the list of living animals from the record (after a
// world is loaded)
// ----------------------------------------------------------------
{
  slots_rebuild(SLOT_POOL_MOBS, p_cows, MAX_COWS);
}

void mob_set_used(Attributes &p_cows, Integer p_cow, Integer p_used)
// ----------------------------------------------------------------
// An animal appears (used TRUE) or is gone: the record and the
// list of living animals change together
// ----------------------------------------------------------------
{
  record_set_integer_at(p_cows, ATTR_USED, p_cow, p_used);
  slots_set(SLOT_POOL_MOBS, p_cow, p_used);
}

Integer cow_alive(Attributes &p_cows, Integer p_cow)
// ----------------------------------------------------------------
// TRUE if cow number cow exists (from the list of living animals,
// which mirrors the record's "used" fields)
// ----------------------------------------------------------------
{
  if (p_cow < 1 || p_cow > MAX_COWS) return FALSE;
  return slots_used(SLOT_POOL_MOBS, p_cow);
}

void cow_position(Attributes &p_cows, Integer p_cow, Real &p_x, Real &p_y, Real &p_z)
// ----------------------------------------------------------------
// Where a cow stands (centre of its footprint, y at its feet)
// ----------------------------------------------------------------
{
  p_x = record_real_at(p_cows, ATTR_X, p_cow);
  p_y = record_real_at(p_cows, ATTR_Y, p_cow);
  p_z = record_real_at(p_cows, ATTR_Z, p_cow);
}

void cow_set_position(Attributes &p_cows, Integer p_cow, Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Move a cow without any collision checks
// ----------------------------------------------------------------
{
  record_set_real_at(p_cows, ATTR_X, p_cow, p_x);
  record_set_real_at(p_cows, ATTR_Y, p_cow, p_y);
  record_set_real_at(p_cows, ATTR_Z, p_cow, p_z);
}

Real cow_yaw(Attributes &p_cows, Integer p_cow)
// ----------------------------------------------------------------
// Direction a cow faces
// ----------------------------------------------------------------
{
  return record_real_at(p_cows, ATTR_YAW, p_cow);
}

Real cow_flash(Attributes &p_cows, Integer p_cow)
// ----------------------------------------------------------------
// Seconds left of the red flash after being hit
// ----------------------------------------------------------------
{
  return record_real_at(p_cows, ATTR_COW_FLASH, p_cow);
}

Real cow_step(Attributes &p_cows, Integer p_cow)
// ----------------------------------------------------------------
// Leg swing phase
// ----------------------------------------------------------------
{
  return record_real_at(p_cows, ATTR_COW_STEP, p_cow);
}

Integer cows_alive_count(Attributes &p_cows)
// ----------------------------------------------------------------
// Number of living cows (not counting zombies)
// ----------------------------------------------------------------
{
  return mobs_count_kind(p_cows, MOB_COW);
}

Integer mob_kind(Attributes &p_cows, Integer p_cow)
// ----------------------------------------------------------------
// MOB_COW, MOB_PIG or MOB_ZOMBIE
// ----------------------------------------------------------------
{
  return record_integer_at(p_cows, ATTR_MOB_KIND, p_cow);
}

Real mob_half_width(Integer p_kind)
// ----------------------------------------------------------------
// Half the width of a kind's collision box
// ----------------------------------------------------------------
{
  if (p_kind == MOB_ZOMBIE) return ZOMBIE_HALF_WIDTH;
  if (p_kind == MOB_PIG   ) return PIG_HALF_WIDTH;
  return COW_HALF_WIDTH;
}

Real mob_height(Integer p_kind)
// ----------------------------------------------------------------
// Height of a kind's collision box
// ----------------------------------------------------------------
{
  if (p_kind == MOB_ZOMBIE) return ZOMBIE_HEIGHT;
  if (p_kind == MOB_PIG   ) return PIG_HEIGHT;
  return COW_HEIGHT;
}

Integer mobs_count_kind(Attributes &p_cows, Integer p_kind)
// ----------------------------------------------------------------
// Number of living animals of one kind
// ----------------------------------------------------------------
{
  Integer l_cow   = 0;
  Integer l_live  = 0;
  Integer l_count = 0;

  for (l_live = 1; l_live <= slots_count(SLOT_POOL_MOBS); ++l_live) {
    l_cow = slots_at(SLOT_POOL_MOBS, l_live);
    if (mob_kind(p_cows, l_cow) == p_kind) ++l_count;
  }
  return l_count;
}

// ---------------------------------------------------------------- behaviour

Integer cows_spawn(Attributes &p_cows, Attributes &p_random, Real p_x, Real p_y, Real p_z, Real p_yaw)
// ----------------------------------------------------------------
// Add a cow standing at (x, y, z); returns its number, 0 if full
// ----------------------------------------------------------------
{
  return mobs_spawn(p_cows, p_random, MOB_COW, p_x, p_y, p_z, p_yaw);
}

Integer mobs_spawn(Attributes &p_cows, Attributes &p_random, Integer p_kind, Real p_x, Real p_y, Real p_z, Real p_yaw)
// ----------------------------------------------------------------
// Add an animal of a kind at (x, y, z); returns its number, 0 if
// the record is full
// ----------------------------------------------------------------
{
  Integer l_cow = 0;

  for (l_cow = 1; l_cow <= MAX_COWS; ++l_cow) {
    if (cow_alive(p_cows, l_cow)) continue;
    mob_set_used         (p_cows, l_cow, TRUE);
    record_set_integer_at(p_cows, ATTR_MOB_KIND,     l_cow, p_kind);
    record_set_real_at   (p_cows, ATTR_MOB_ATTACK,   l_cow, 0.0);
    cow_set_position     (p_cows, l_cow, p_x, p_y, p_z);
    record_set_real_at   (p_cows, ATTR_VY,           l_cow, 0.0);
    record_set_real_at   (p_cows, ATTR_COW_PUSH_X,   l_cow, 0.0);
    record_set_real_at   (p_cows, ATTR_COW_PUSH_Z,   l_cow, 0.0);
    record_set_real_at   (p_cows, ATTR_YAW,          l_cow, p_yaw);
    record_set_real_at   (p_cows, ATTR_COW_GOAL_YAW, l_cow, p_yaw);
    record_set_integer_at(p_cows, ATTR_HEALTH,       l_cow, COW_HEALTH);
    if (p_kind == MOB_ZOMBIE) record_set_integer_at(p_cows, ATTR_HEALTH, l_cow, ZOMBIE_HEALTH);
    if (p_kind == MOB_PIG   ) record_set_integer_at(p_cows, ATTR_HEALTH, l_cow, PIG_HEALTH);
    record_set_integer_at(p_cows, ATTR_COW_WALKING,  l_cow, FALSE);
    record_set_real_at   (p_cows, ATTR_TIMER,        l_cow, random_between(p_random, 1.0, 4.0));
    record_set_real_at   (p_cows, ATTR_COW_PANIC,    l_cow, 0.0);
    record_set_real_at   (p_cows, ATTR_COW_FLASH,    l_cow, 0.0);
    record_set_real_at   (p_cows, ATTR_COW_STEP,     l_cow, 0.0);
    record_set_integer_at(p_cows, ATTR_ON_GROUND,    l_cow, FALSE);
    return l_cow;
  }
  return 0;
}

Integer cows_spawn_random(Attributes &p_cows, Attributes &p_random, Integer p_count, Real p_away_x, Real p_away_z, Real p_keep_away)
// ----------------------------------------------------------------
// Put up to count cows on random grass blocks (see mobs_spawn_random)
// ----------------------------------------------------------------
{
  return mobs_spawn_random(p_cows, p_random, MOB_COW, p_count, p_away_x, p_away_z, p_keep_away);
}

Integer mobs_spawn_random(Attributes &p_cows, Attributes &p_random, Integer p_kind, Integer p_count, Real p_away_x, Real p_away_z, Real p_keep_away)
// ----------------------------------------------------------------
// Put up to count animals of a kind on random grass blocks at least
// keep_away blocks from (away_x, away_z). Returns how many spawned.
// ----------------------------------------------------------------
{
  Integer l_spawned = 0;
  Integer l_tries   = 0;
  Integer l_x       = 0;
  Integer l_z       = 0;
  Integer l_top     = 0;
  Real    l_dx      = 0.0;
  Real    l_dz      = 0.0;

  while (l_spawned < p_count && l_tries < p_count * 60) {
    ++l_tries;
    l_x   = random_range(p_random, 2, WORLD_SIZE_X - 3);
    l_z   = random_range(p_random, 2, WORLD_SIZE_Z - 3);
    l_top = world_top_solid_y(l_x, l_z);
    if (l_top < SEA_LEVEL) continue;
    if (world_get_block(l_x, l_top, l_z) != BLOCK_GRASS) continue;
    l_dx = l_x + 0.5 - p_away_x;
    l_dz = l_z + 0.5 - p_away_z;
    if (l_dx * l_dx + l_dz * l_dz < p_keep_away * p_keep_away) continue;
    if (mobs_spawn(p_cows, p_random, p_kind, l_x + 0.5, l_top + 1.0 + COLLISION_EPSILON, l_z + 0.5, random_between(p_random, 0.0, TWO_PI)) == 0) break;
    ++l_spawned;
  }
  return l_spawned;
}

Integer zombies_spawn_near(Attributes &p_cows, Attributes &p_random, Real p_player_x, Real p_player_z)
// ----------------------------------------------------------------
// Try to put a zombie on dry ground open to the sky, between
// ZOMBIE_SPAWN_NEAR and ZOMBIE_SPAWN_FAR blocks from the player.
// Returns its number, 0 if no spot was found this time.
// ----------------------------------------------------------------
{
  Integer l_try   = 0;
  Integer l_x     = 0;
  Integer l_z     = 0;
  Integer l_top   = 0;
  Integer l_block = 0;
  Real    l_angle = 0.0;
  Real    l_far   = 0.0;

  for (l_try = 1; l_try <= 12; ++l_try) {
    l_angle = random_between(p_random, 0.0, TWO_PI);
    l_far   = random_between(p_random, ZOMBIE_SPAWN_NEAR, ZOMBIE_SPAWN_FAR);
    l_x     = floor_integer(p_player_x + Cos(l_angle) * l_far);
    l_z     = floor_integer(p_player_z + Sin(l_angle) * l_far);
    if (l_x < 2 || l_z < 2 || l_x > WORLD_SIZE_X - 3 || l_z > WORLD_SIZE_Z - 3) continue;
    l_top   = world_top_solid_y(l_x, l_z);
    if (l_top < SEA_LEVEL - 1) continue;
    l_block = world_get_block(l_x, l_top, l_z);
    if (l_block == BLOCK_LEAVES || l_block == BLOCK_CACTUS) continue;
    if (world_get_light(l_x, l_top + 1, l_z) > 7) continue;      // not next to torches
    return mobs_spawn(p_cows, p_random, MOB_ZOMBIE, l_x + 0.5, l_top + 1.0 + COLLISION_EPSILON, l_z + 0.5, l_angle + PI);
  }
  return 0;
}

void zombie_sunlight(Attributes &p_cows, Attributes &p_events, Integer p_cow, Real p_dt)
// ----------------------------------------------------------------
// A zombie standing under open sky in daylight smoulders and loses
// health every ZOMBIE_BURN_SECONDS until it falls apart
// ----------------------------------------------------------------
{
  Real    l_x      = 0.0;
  Real    l_y      = 0.0;
  Real    l_z      = 0.0;
  Real    l_timer  = record_real_at(p_cows, ATTR_MOB_ATTACK, p_cow);
  Integer l_health = 0;

  cow_position(p_cows, p_cow, l_x, l_y, l_z);
  if (world_sky_top(floor_integer(l_x), floor_integer(l_z)) >= floor_integer(l_y + ZOMBIE_HEIGHT)) return;   // shaded

  l_timer = l_timer - p_dt;
  if (l_timer > 0.0) {
    record_set_real_at(p_cows, ATTR_MOB_ATTACK, p_cow, l_timer);
    return;
  }
  record_set_real_at(p_cows, ATTR_MOB_ATTACK, p_cow, ZOMBIE_BURN_SECONDS);
  record_set_real_at(p_cows, ATTR_COW_FLASH,  p_cow, 0.3);
  l_health = record_integer_at(p_cows, ATTR_HEALTH, p_cow) - 2;
  record_set_integer_at(p_cows, ATTR_HEALTH, p_cow, l_health);
  if (l_health <= 0) {
    mob_set_used(p_cows, p_cow, FALSE);
    emit_event(p_events, EVT_COW_KILLED, p_cow, MOB_ZOMBIE, 0, 0, l_x, l_y + 0.9, l_z, "");
  }
}

void cow_update(Attributes &p_cows, Attributes &p_random, Attributes &p_events, Integer p_cow,
                Real p_player_x, Real p_player_y, Real p_player_z, Real p_dt)
// ----------------------------------------------------------------
// One cow: pick something to do now and then, turn smoothly, walk,
// fall, swim, hop up single blocks and avoid drops and water
// A zombie instead heads for the player when it is near, doesn't
// mind drops, and hits the player when close enough
// (EVT_ZOMBIE_ATTACK)
// The cow's fields are read into locals and written back at the end
// ----------------------------------------------------------------
{
  Integer l_kind      = mob_kind(p_cows, p_cow);
  Real    l_half      = mob_half_width(l_kind);
  Real    l_height    = mob_height(l_kind);
  Real    l_to_x      = 0.0;
  Real    l_to_z      = 0.0;
  Real    l_apart     = 0.0;
  Real    l_attack    = record_real_at(p_cows, ATTR_MOB_ATTACK, p_cow) - p_dt;
  Real    l_x         = record_real_at   (p_cows, ATTR_X,            p_cow);
  Real    l_y         = record_real_at   (p_cows, ATTR_Y,            p_cow);
  Real    l_z         = record_real_at   (p_cows, ATTR_Z,            p_cow);
  Real    l_vy        = record_real_at   (p_cows, ATTR_VY,           p_cow);
  Real    l_push_x    = record_real_at   (p_cows, ATTR_COW_PUSH_X,   p_cow);
  Real    l_push_z    = record_real_at   (p_cows, ATTR_COW_PUSH_Z,   p_cow);
  Real    l_yaw       = record_real_at   (p_cows, ATTR_YAW,          p_cow);
  Real    l_goal_yaw  = record_real_at   (p_cows, ATTR_COW_GOAL_YAW, p_cow);
  Integer l_walking   = record_integer_at(p_cows, ATTR_COW_WALKING,  p_cow);
  Real    l_timer     = record_real_at   (p_cows, ATTR_TIMER,        p_cow) - p_dt;
  Real    l_panic     = record_real_at   (p_cows, ATTR_COW_PANIC,    p_cow) - p_dt;
  Real    l_flash     = record_real_at   (p_cows, ATTR_COW_FLASH,    p_cow) - p_dt;
  Real    l_step_phase= record_real_at   (p_cows, ATTR_COW_STEP,     p_cow);
  Integer l_on_ground = record_integer_at(p_cows, ATTR_ON_GROUND,    p_cow);
  Real    l_speed     = 0.0;
  Real    l_turn      = 0.0;
  Real    l_dir_x     = 0.0;
  Real    l_dir_z     = 0.0;
  Real    l_move_x    = 0.0;
  Real    l_move_z    = 0.0;
  Real    l_fall      = 0.0;
  Integer l_in_water  = physics_box_in_water(l_x, l_y, l_z, l_half, l_height);
  Integer l_steps     = 1;
  Integer l_step      = 0;
  Integer l_blocked   = FALSE;
  Integer l_ahead_x   = 0;
  Integer l_ahead_z   = 0;
  Integer l_foot_y    = 0;
  Integer l_hit_x     = FALSE;
  Integer l_hit_z     = FALSE;
  Integer l_hit_down  = FALSE;
  Integer l_hit_up    = FALSE;

  // Zombies: chase the player when near enough
  if (l_kind == MOB_ZOMBIE) {
    l_to_x  = p_player_x - l_x;
    l_to_z  = p_player_z - l_z;
    l_apart = Sqrt(l_to_x * l_to_x + l_to_z * l_to_z);
    if (l_apart < ZOMBIE_SIGHT) {
      l_goal_yaw = wrap_angle(angle_of(l_to_z, l_to_x));
      l_walking  = l_apart > ZOMBIE_REACH * 0.7;
      l_timer    = 0.5;
      l_panic    = 0.0;
      if (l_apart < ZOMBIE_REACH && Absolute(p_player_y - l_y) < 1.6 && l_attack <= 0.0) {
        l_attack = ZOMBIE_ATTACK_SECONDS;
        emit_event(p_events, EVT_ZOMBIE_ATTACK, ZOMBIE_DAMAGE, p_cow, 0, 0, l_to_x / max_real(l_apart, 0.1), 0.0, l_to_z / max_real(l_apart, 0.1), "");
      }
    }
  }

  // Decide what to do next
  if (l_timer <= 0.0) {
    if (l_panic > 0.0) {
      l_goal_yaw = l_yaw + random_between(p_random, -0.8, 0.8);
      l_walking  = TRUE;
      l_timer    = random_between(p_random, 0.6, 1.2);
    } else if (random_next(p_random) < 0.45) {
      l_walking  = FALSE;
      l_timer    = random_between(p_random, 2.0, 6.0);
    } else {
      l_goal_yaw = random_between(p_random, 0.0, TWO_PI);
      l_walking  = TRUE;
      l_timer    = random_between(p_random, 2.0, 5.0);
    }
  }

  // Turn towards the goal direction by the shortest way round
  l_turn = wrap_angle(l_goal_yaw - l_yaw + PI) - PI;
  if (l_turn >  p_dt * 3.0) l_turn =  p_dt * 3.0;
  if (l_turn < -p_dt * 3.0) l_turn = -p_dt * 3.0;
  l_yaw   = wrap_angle(l_yaw + l_turn);
  l_dir_x = Cos(l_yaw);
  l_dir_z = Sin(l_yaw);

  if (l_walking) {
    l_speed = COW_WALK_SPEED;
    if (l_panic > 0.0) l_speed = COW_PANIC_SPEED;
    if (l_kind == MOB_ZOMBIE) l_speed = ZOMBIE_SPEED;
    if (l_in_water) l_speed = l_speed * WATER_SPEED_FACTOR;

    // Don't walk off a drop of more than one block or into water
    l_ahead_x = Floor(l_x + l_dir_x * 0.9);
    l_ahead_z = Floor(l_z + l_dir_z * 0.9);
    l_foot_y  = Floor(l_y + 0.1);
    if (!l_in_water && l_on_ground && l_kind != MOB_ZOMBIE) {
      if (!world_is_solid(l_ahead_x, l_foot_y - 1, l_ahead_z) && !world_is_solid(l_ahead_x, l_foot_y - 2, l_ahead_z)) {
        l_speed    = 0.0;
        l_goal_yaw = l_yaw + PI;
      }
      if (world_get_block(l_ahead_x, l_foot_y - 1, l_ahead_z) == BLOCK_WATER) {
        l_speed    = 0.0;
        l_goal_yaw = l_yaw + PI;
      }
    }
    l_step_phase = l_step_phase + p_dt * l_speed * 3.0;
  }

  // Knock-back fades away
  l_push_x = l_push_x * (1.0 - min_real(1.0, p_dt * 4.0));
  l_push_z = l_push_z * (1.0 - min_real(1.0, p_dt * 4.0));

  l_move_x = (l_dir_x * l_speed + l_push_x) * p_dt;
  l_move_z = (l_dir_z * l_speed + l_push_z) * p_dt;

  if (l_in_water) {
    l_vy = l_vy + (2.0 - l_vy) * min_real(1.0, p_dt * 3.0);
  } else {
    l_vy = l_vy - GRAVITY * p_dt;
    if (l_vy < -TERMINAL_SPEED) l_vy = -TERMINAL_SPEED;
  }
  l_fall = l_vy * p_dt;

  l_steps = 1 + Floor(max_real(Absolute(l_fall), max_real(Absolute(l_move_x), Absolute(l_move_z))) / MAX_MOVE_STEP);
  l_on_ground = FALSE;
  for (l_step = 1; l_step <= l_steps; ++l_step) {
    physics_move_box(l_x, l_y, l_z, l_half, l_height, l_move_x / l_steps, l_fall / l_steps, l_move_z / l_steps,
                     l_hit_x, l_hit_z, l_hit_down, l_hit_up);
    if (l_hit_down) {
      l_on_ground = TRUE;
      l_vy        = 0.0;
    }
    if (l_hit_up) l_vy = 0.0;
    if (l_hit_x || l_hit_z) l_blocked = TRUE;
  }

  // Walked into a wall: hop if there is room above, else turn away
  if (l_blocked && l_walking) {
    if (l_on_ground && !world_is_solid(floor_integer(l_x + l_dir_x * 0.9), floor_integer(l_y + 1.1), floor_integer(l_z + l_dir_z * 0.9))) {
      l_vy = COW_JUMP_SPEED;
    } else {
      l_goal_yaw = l_yaw + PI * 0.5 + random_between(p_random, 0.0, PI);
    }
  }

  cow_set_position     (p_cows, p_cow, l_x, l_y, l_z);
  record_set_real_at   (p_cows, ATTR_VY,           p_cow, l_vy);
  record_set_real_at   (p_cows, ATTR_COW_PUSH_X,   p_cow, l_push_x);
  record_set_real_at   (p_cows, ATTR_COW_PUSH_Z,   p_cow, l_push_z);
  record_set_real_at   (p_cows, ATTR_YAW,          p_cow, l_yaw);
  record_set_real_at   (p_cows, ATTR_COW_GOAL_YAW, p_cow, l_goal_yaw);
  record_set_integer_at(p_cows, ATTR_COW_WALKING,  p_cow, l_walking);
  record_set_real_at   (p_cows, ATTR_TIMER,        p_cow, l_timer);
  record_set_real_at   (p_cows, ATTR_COW_PANIC,    p_cow, l_panic);
  record_set_real_at   (p_cows, ATTR_COW_FLASH,    p_cow, l_flash);
  record_set_real_at   (p_cows, ATTR_COW_STEP,     p_cow, l_step_phase);
  record_set_integer_at(p_cows, ATTR_ON_GROUND,    p_cow, l_on_ground);
  if (l_kind == MOB_ZOMBIE) record_set_real_at(p_cows, ATTR_MOB_ATTACK, p_cow, l_attack);
}

void cows_update(Attributes &p_cows, Attributes &p_random, Attributes &p_events,
                 Real p_player_x, Real p_player_y, Real p_player_z, Integer p_night, Integer p_leave_player, Real p_dt)
// ----------------------------------------------------------------
// Move every cow and zombie near the player, top the herd back up
// now and then away from where the player can see it happen, bring
// zombies out at night and burn them in the day
// ----------------------------------------------------------------
{
  Integer l_cow     = 0;
  Integer l_live    = 0;
  Integer l_count   = slots_count(SLOT_POOL_MOBS);
  Integer l_order[MAX_COWS];
  Real    l_x       = 0.0;
  Real    l_y       = 0.0;
  Real    l_z       = 0.0;
  Real    l_target_x = p_player_x;
  Real    l_target_z = p_player_z;
  Real    l_respawn = record_real(p_cows, ATTR_COW_RESPAWN) + p_dt;
  Real    l_zombies = record_real(p_cows, ATTR_ZOMBIE_SPAWN) + p_dt;

  // A dead player, or one in creative mode, isn't chased
  if (p_leave_player) {
    l_target_x = -1000.0;
    l_target_z = -1000.0;
  }

  // A zombie can burn up during the loop, which changes the list, so
  // go through a copy of it
  for (l_live = 1; l_live <= l_count; ++l_live) l_order[l_live] = slots_at(SLOT_POOL_MOBS, l_live);
  for (l_live = 1; l_live <= l_count; ++l_live) {
    l_cow = l_order[l_live];
    if (!cow_alive(p_cows, l_cow)) continue;
    cow_position(p_cows, l_cow, l_x, l_y, l_z);
    if ((l_x - p_player_x) * (l_x - p_player_x) + (l_z - p_player_z) * (l_z - p_player_z) > COW_ACTIVE_DISTANCE * COW_ACTIVE_DISTANCE) continue;
    cow_update(p_cows, p_random, p_events, l_cow, l_target_x, p_player_y, l_target_z, p_dt);
    if (mob_kind(p_cows, l_cow) == MOB_ZOMBIE && !p_night) zombie_sunlight(p_cows, p_events, l_cow, p_dt);
  }

  if (l_zombies > ZOMBIE_SPAWN_SECONDS) {
    l_zombies = 0.0;
    if (p_night && !p_leave_player && mobs_count_kind(p_cows, MOB_ZOMBIE) < MAX_ZOMBIES) zombies_spawn_near(p_cows, p_random, p_player_x, p_player_z);
  }
  record_set_real(p_cows, ATTR_ZOMBIE_SPAWN, l_zombies);

  if (l_respawn > COW_RESPAWN_SECONDS) {
    l_respawn = 0.0;
    if (cows_alive_count(p_cows) < COW_TARGET_COUNT) {
      cows_spawn_random(p_cows, p_random, 1, p_player_x, p_player_z, 24.0);
    } else if (mobs_count_kind(p_cows, MOB_PIG) < PIG_TARGET_COUNT) {
      mobs_spawn_random(p_cows, p_random, MOB_PIG, 1, p_player_x, p_player_z, 24.0);
    }
  }
  record_set_real(p_cows, ATTR_COW_RESPAWN, l_respawn);
}

Integer cows_ray_hit(Attributes &p_cows, Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z,
                     Real p_max_distance, Real &p_distance)
// ----------------------------------------------------------------
// Nearest cow the ray hits within max_distance, 0 for none;
// distance is set to how far along the ray it is
// ----------------------------------------------------------------
{
  Integer l_cow     = 0;
  Integer l_live    = 0;
  Integer l_best    = 0;
  Real    l_along   = 0.0;
  Real    l_nearest = p_max_distance;
  Real    l_half    = 0.0;
  Real    l_height  = 0.0;
  Real    l_x       = 0.0;
  Real    l_y       = 0.0;
  Real    l_z       = 0.0;

  for (l_live = 1; l_live <= slots_count(SLOT_POOL_MOBS); ++l_live) {
    l_cow = slots_at(SLOT_POOL_MOBS, l_live);
    cow_position(p_cows, l_cow, l_x, l_y, l_z);
    l_half   = mob_half_width(mob_kind(p_cows, l_cow));
    l_height = mob_height(mob_kind(p_cows, l_cow));
    l_along = physics_ray_box(p_origin_x, p_origin_y, p_origin_z, p_dir_x, p_dir_y, p_dir_z,
                            l_x - l_half, l_y           , l_z - l_half,
                            l_x + l_half, l_y + l_height, l_z + l_half);
    if (l_along < 0.0 || l_along > l_nearest) continue;
    l_nearest = l_along;
    l_best    = l_cow;
  }

  p_distance = l_nearest;
  return l_best;
}

void cow_damage(Attributes &p_cows, Attributes &p_events, Attributes &p_random, Integer p_cow, Integer p_amount, Real p_push_x, Real p_push_z)
// ----------------------------------------------------------------
// Hurt a cow and knock it back along (push_x, push_z)
// Emits EVT_COW_HURT, or EVT_COW_KILLED when it runs out of health
// ----------------------------------------------------------------
{
  Integer l_health = 0;
  Real    l_x      = 0.0;
  Real    l_y      = 0.0;
  Real    l_z      = 0.0;

  if (!cow_alive(p_cows, p_cow)) return;

  l_health = record_integer_at(p_cows, ATTR_HEALTH, p_cow) - p_amount;
  record_set_integer_at(p_cows, ATTR_HEALTH,       p_cow, l_health);
  record_set_real_at   (p_cows, ATTR_COW_FLASH,    p_cow, 0.3);
  record_set_real_at   (p_cows, ATTR_COW_PANIC,    p_cow, 5.0);
  record_set_real_at   (p_cows, ATTR_TIMER,        p_cow, 0.0);
  record_set_real_at   (p_cows, ATTR_COW_PUSH_X,   p_cow, p_push_x * 6.0);
  record_set_real_at   (p_cows, ATTR_COW_PUSH_Z,   p_cow, p_push_z * 6.0);
  record_set_real_at   (p_cows, ATTR_COW_GOAL_YAW, p_cow, random_between(p_random, 0.0, TWO_PI));
  if (record_integer_at(p_cows, ATTR_ON_GROUND, p_cow)) record_set_real_at(p_cows, ATTR_VY, p_cow, 4.5);
  if (mob_kind(p_cows, p_cow) == MOB_ZOMBIE) {
    // zombies don't run away: they get knocked back and keep coming
    record_set_real_at(p_cows, ATTR_COW_PANIC,  p_cow, 0.0);
    record_set_real_at(p_cows, ATTR_COW_PUSH_X, p_cow, p_push_x * 8.0);
    record_set_real_at(p_cows, ATTR_COW_PUSH_Z, p_cow, p_push_z * 8.0);
  }

  cow_position(p_cows, p_cow, l_x, l_y, l_z);
  if (l_health <= 0) {
    mob_set_used(p_cows, p_cow, FALSE);
    emit_event(p_events, EVT_COW_KILLED, p_cow, mob_kind(p_cows, p_cow), 0, 0, l_x, l_y + 0.6, l_z, "");
  } else {
    emit_event(p_events, EVT_COW_HURT, p_cow, 0, 0, 0, l_x, l_y, l_z, "");
  }
}

Integer cows_box_overlaps(Attributes &p_cows, Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)
// ----------------------------------------------------------------
// TRUE if any cow overlaps the box (blocks can't be placed there)
// ----------------------------------------------------------------
{
  Integer l_cow    = 0;
  Integer l_live   = 0;
  Real    l_x      = 0.0;
  Real    l_y      = 0.0;
  Real    l_z      = 0.0;
  Real    l_half   = 0.0;
  Real    l_height = 0.0;

  for (l_live = 1; l_live <= slots_count(SLOT_POOL_MOBS); ++l_live) {
    l_cow = slots_at(SLOT_POOL_MOBS, l_live);
    cow_position(p_cows, l_cow, l_x, l_y, l_z);
    l_half   = mob_half_width(mob_kind(p_cows, l_cow));
    l_height = mob_height(mob_kind(p_cows, l_cow));
    if (l_x + l_half   <= p_min_x || l_x - l_half >= p_max_x) continue;
    if (l_z + l_half   <= p_min_z || l_z - l_half >= p_max_z) continue;
    if (l_y + l_height <= p_min_y || l_y          >= p_max_y) continue;
    return TRUE;
  }
  return FALSE;
}

#endif
