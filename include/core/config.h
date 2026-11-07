#ifndef CONFIG_H_INCLUDED
#define CONFIG_H_INCLUDED

// ----------------------------------------------------------------
// Tunable sizes and constants
// Array sizes must be plain numbers, so the products are written
// out and the formula is kept in the comment beside them
// ----------------------------------------------------------------

// ---------------------------------------------------------------- world
#define WORLD_SIZE_X         128
#define WORLD_SIZE_Z         128
#define WORLD_HEIGHT         96
#define WORLD_CELLS          1572864   // WORLD_SIZE_X * WORLD_SIZE_Z * WORLD_HEIGHT
#define WORLD_COLUMNS        16384     // WORLD_SIZE_X * WORLD_SIZE_Z
#define WORLD_STRIDE_Z       96        // index step for z + 1 (WORLD_HEIGHT)
#define WORLD_STRIDE_X       12288     // index step for x + 1 (WORLD_SIZE_Z * WORLD_HEIGHT)
#define SEA_LEVEL            62        // every open cell with y below this is water

// ---------------------------------------------------------------- sections (meshing)
#define SECTION_SIZE         16
#define SECTIONS_X           8         // WORLD_SIZE_X / SECTION_SIZE
#define SECTIONS_Y           6         // WORLD_HEIGHT / SECTION_SIZE
#define SECTIONS_Z           8         // WORLD_SIZE_Z / SECTION_SIZE
#define NUM_SECTIONS         384       // SECTIONS_X * SECTIONS_Y * SECTIONS_Z
#define SECTION_FACE_CAP     2048      // faces one section can hold (dense forest needs ~1300)
#define FACE_POOL_SIZE       786432    // NUM_SECTIONS * SECTION_FACE_CAP

// ---------------------------------------------------------------- player
#define PLAYER_HALF_WIDTH    0.3
#define PLAYER_HEIGHT        1.8       // a little shorter than two blocks
#define PLAYER_EYE_HEIGHT    1.62
#define PLAYER_REACH         5.0
#define PLAYER_MAX_HEALTH    20
#define WALK_SPEED           4.3
#define GRAVITY              28.0
#define JUMP_SPEED           8.6       // about 1.3 blocks high
#define TERMINAL_SPEED       40.0
#define SWIM_GRAVITY         7.0
#define SWIM_UP_SPEED        3.6
#define SWIM_SINK_SPEED      2.5
#define WATER_SPEED_FACTOR   0.55
#define FLY_SPEED_FACTOR     1.8      // horizontal speed while flying
#define FLY_VERTICAL_SPEED   6.0      // blocks per second up (Space) or down (C)
#define FLY_KEY_SECONDS      0.25     // a press of Space or C moves this long
#define CROUCH_EYE_HEIGHT    1.27     // eye height while crouching
#define CROUCH_SPEED_FACTOR  0.3      // walking speed while crouching
#define CROUCH_HOLD_SECONDS  0.6      // a Shift + key press keeps you crouched this long
#define FALL_DAMAGE_START    3.0
#define REGEN_SECONDS        4.0
#define BREAK_RESET_SECONDS  1.2

// Movement keys: a fresh press moves for TAP_TIME seconds, easing from
// TAP_START_SPEED to full speed over TAP_RAMP seconds. Auto-repeat of
// a held key keeps it going. There are no key-up events in 12d.
#define TAP_TIME             0.36
#define TAP_START_SPEED      0.6
#define TAP_RAMP             0.3
#define HELD_KEY_WINDOW      0.6
#define HELD_KEY_EXTEND      0.12

// ---------------------------------------------------------------- inventory
#define HOTBAR_SLOTS         9
#define INVENTORY_SLOTS      36        // 9 hotbar + 27 (9 x 3) main
#define MAX_STACK            64

// ---------------------------------------------------------------- entities
#define MAX_COWS             24
#define COW_TARGET_COUNT     10
#define COW_HEALTH           5
#define COW_HALF_WIDTH       0.42
#define COW_HEIGHT           1.3
#define MAX_DROPS            128
#define DROP_HALF_SIZE       0.125
#define DROP_LIFETIME        300.0
#define MAX_FURNACES         32
#define COOK_SECONDS         5.0

// ---------------------------------------------------------------- saving
#define MAX_EDITS            65536
#define AUTOSAVE_SECONDS     120.0

// ---------------------------------------------------------------- input / timing
#define MOUSE_SENSITIVITY    0.0045
#define MAX_PITCH            1.55
#define MAX_FRAME_DT         0.1
#define IDLE_RELEASE_SECONDS 180.0     // a captured mouse is freed after this long without input
#define PARK_HEIGHT_SHARE    0.3       // the cursor is parked this far up the view (share of its height)
#define LEAVES_BEFORE_RELEASE 12       // the mouse is freed if it leaves the view this often in a second
#define REFOCUS_LIMIT        3         // keyboard focus is taken back this often in two seconds before giving up
#define STATUS_STRIP_HEIGHT  22.0

#endif
