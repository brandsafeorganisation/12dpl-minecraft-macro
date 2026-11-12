#ifndef COWS_H_INCLUDED
#define COWS_H_INCLUDED

#include "../core/config.h"
#include "../core/records.h"

// ----------------------------------------------------------------
// Cows and pigs: wander about on land, run off when hit and drop raw
// beef or porkchops
// Zombies: come out at night, walk at the player and hit them, burn
// in daylight and drop rotten flesh. They all share the cows' record
// and code (field "kind_c" says which), so hitting, collisions,
// drawing order and saving work the same for every kind.
//
// All cows live in one record. Cow c has the fields "used_c" (alive),
// "x_c", "y_c", "z_c", "vy_c", "push_x_c", "push_z_c", "yaw_c",
// "goal_yaw_c", "health_c", "walking_c", "timer_c", "panic_c",
// "flash_c", "step_c" and "on_ground_c". Randomness comes from the
// random record passed in. Which numbers are alive is also kept in
// the slot index (slots.h): spawning and dying go through
// mob_set_used, so loops visit only the living ones.
// ----------------------------------------------------------------

#define COW_WALK_SPEED       1.1
#define COW_PANIC_SPEED      3.2
#define COW_JUMP_SPEED       7.6
#define COW_RESPAWN_SECONDS  25.0
#define COW_ACTIVE_DISTANCE  64.0

#define MOB_COW              0
#define MOB_ZOMBIE           1
#define MOB_PIG              2
#define PIG_TARGET_COUNT     6
#define PIG_HEALTH           5
#define PIG_HALF_WIDTH       0.45
#define PIG_HEIGHT           0.9
#define MAX_ZOMBIES          6
#define ZOMBIE_HEALTH        10
#define ZOMBIE_HALF_WIDTH    0.3
#define ZOMBIE_HEIGHT        1.9
#define ZOMBIE_SPEED         2.1
#define ZOMBIE_SIGHT         24.0     // blocks: closer than this it walks at the player
#define ZOMBIE_REACH         1.2      // blocks between centres to hit
#define ZOMBIE_DAMAGE        3
#define ZOMBIE_ATTACK_SECONDS 1.0
#define ZOMBIE_SPAWN_SECONDS 5.0
#define ZOMBIE_SPAWN_NEAR    14.0     // spawn between this ...
#define ZOMBIE_SPAWN_FAR     30.0     // ... and this far from the player
#define ZOMBIE_BURN_SECONDS  1.0      // in sunlight it loses health this often

#define DATATYPE_COWS        ("cows")
#define ATTR_COW_PUSH_X      ("push_x")
#define ATTR_COW_PUSH_Z      ("push_z")
#define ATTR_COW_GOAL_YAW    ("goal_yaw")
#define ATTR_COW_WALKING     ("walking")
#define ATTR_COW_PANIC       ("panic")
#define ATTR_COW_FLASH       ("flash")
#define ATTR_COW_STEP        ("step")
#define ATTR_COW_RESPAWN     ("respawn_timer")
#define ATTR_MOB_KIND        ("kind")
#define ATTR_MOB_ATTACK      ("attack_timer")
#define ATTR_ZOMBIE_SPAWN    ("zombie_timer")

void    cows_clear         (Attributes &p_cows);
void    mobs_rebuild_index (Attributes &p_cows);
void    mob_set_used       (Attributes &p_cows, Integer p_cow, Integer p_used);
Integer cow_alive          (Attributes &p_cows, Integer p_cow);
void    cow_position       (Attributes &p_cows, Integer p_cow, Real &p_x, Real &p_y, Real &p_z);
void    cow_set_position   (Attributes &p_cows, Integer p_cow, Real p_x, Real p_y, Real p_z);
Real    cow_yaw            (Attributes &p_cows, Integer p_cow);
Real    cow_flash          (Attributes &p_cows, Integer p_cow);
Real    cow_step           (Attributes &p_cows, Integer p_cow);
Integer cows_alive_count   (Attributes &p_cows);
Integer mob_kind           (Attributes &p_cows, Integer p_cow);
Real    mob_half_width     (Integer p_kind);
Real    mob_height         (Integer p_kind);
Integer mobs_count_kind    (Attributes &p_cows, Integer p_kind);
Integer mobs_spawn         (Attributes &p_cows, Attributes &p_random, Integer p_kind, Real p_x, Real p_y, Real p_z, Real p_yaw);
Integer zombies_spawn_near (Attributes &p_cows, Attributes &p_random, Real p_player_x, Real p_player_z);
void    zombie_sunlight    (Attributes &p_cows, Attributes &p_events, Integer p_cow, Real p_dt);
Integer cows_spawn         (Attributes &p_cows, Attributes &p_random, Real p_x, Real p_y, Real p_z, Real p_yaw);
Integer cows_spawn_random  (Attributes &p_cows, Attributes &p_random, Integer p_count, Real p_away_x, Real p_away_z, Real p_keep_away);
Integer mobs_spawn_random  (Attributes &p_cows, Attributes &p_random, Integer p_kind, Integer p_count, Real p_away_x, Real p_away_z, Real p_keep_away);
void    cow_update         (Attributes &p_cows, Attributes &p_random, Attributes &p_events, Integer p_cow,
                            Real p_player_x, Real p_player_y, Real p_player_z, Real p_dt);
void    cows_update        (Attributes &p_cows, Attributes &p_random, Attributes &p_events,
                            Real p_player_x, Real p_player_y, Real p_player_z, Integer p_night, Integer p_leave_player, Real p_dt);
Integer cows_ray_hit       (Attributes &p_cows, Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z,
                            Real p_max_distance, Real &p_distance);
void    cow_damage         (Attributes &p_cows, Attributes &p_events, Attributes &p_random, Integer p_cow, Integer p_amount, Real p_push_x, Real p_push_z);
Integer cows_box_overlaps  (Attributes &p_cows, Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z);

#endif
