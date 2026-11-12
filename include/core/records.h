#ifndef RECORDS_H_INCLUDED
#define RECORDS_H_INCLUDED

// ----------------------------------------------------------------
// Records: 12d Attributes used like structs
//
// A record is an Attributes value with named fields. Collections
// (all the cows, all the drops, ...) are one record whose fields
// carry the entity number: "x_3" is field "x" of entity 3. Every
// function that reads or writes a record takes it as a parameter,
// so its signature shows everything it touches (see
// CLAUDE.md, "Honest functions").
//
// Field names are object-like macros so a typo is a compile error
// instead of a silently empty field. Shared field names live here,
// record specific ones in the owning module's header.
// ----------------------------------------------------------------

// ---------------------------------------------------------------- shared field names
#define ATTR_DATATYPE      ("datatype")
#define ATTR_USED          ("used")
#define ATTR_X             ("x")
#define ATTR_Y             ("y")
#define ATTR_Z             ("z")
#define ATTR_VX            ("vx")
#define ATTR_VY            ("vy")
#define ATTR_VZ            ("vz")
#define ATTR_YAW           ("yaw")
#define ATTR_PITCH         ("pitch")
#define ATTR_HEALTH        ("health")
#define ATTR_ITEM          ("item")
#define ATTR_COUNT         ("count")
#define ATTR_AGE           ("age")
#define ATTR_TIMER         ("timer")
#define ATTR_ON_GROUND     ("on_ground")
#define ATTR_TEXT          ("text")
#define ATTR_TYPE          ("type")

// ---------------------------------------------------------------- random number record
#define DATATYPE_RANDOM    ("random")
#define ATTR_RANDOM_STATE  ("state")
#define RANDOM_MODULUS     2147483647.0
#define RANDOM_MULTIPLIER  16807.0

// Generic field access (missing fields read as 0, 0.0 or "")
Integer record_integer       (Attributes &p_record, Text p_field);
Real    record_real          (Attributes &p_record, Text p_field);
Text    record_text          (Attributes &p_record, Text p_field);
void    record_set_integer   (Attributes &p_record, Text p_field, Integer p_value);
void    record_set_real      (Attributes &p_record, Text p_field, Real p_value);
void    record_set_text      (Attributes &p_record, Text p_field, Text p_value);
void    record_clear         (Attributes &p_record, Text p_datatype);
Text    record_datatype      (Attributes &p_record);

// Fields of entity number index inside a collection record
Text    record_field_at      (Text p_field, Integer p_index);
Integer record_integer_at    (Attributes &p_record, Text p_field, Integer p_index);
Real    record_real_at       (Attributes &p_record, Text p_field, Integer p_index);
Text    record_text_at       (Attributes &p_record, Text p_field, Integer p_index);
void    record_set_integer_at(Attributes &p_record, Text p_field, Integer p_index, Integer p_value);
void    record_set_real_at   (Attributes &p_record, Text p_field, Integer p_index, Real p_value);
void    record_set_text_at   (Attributes &p_record, Text p_field, Integer p_index, Text p_value);

// Seeded random numbers; the state lives in the record passed in,
// so a function that needs randomness says so in its signature
void    random_seed          (Attributes &p_random, Integer p_seed);
Real    random_next          (Attributes &p_random);
Integer random_range         (Attributes &p_random, Integer p_low, Integer p_high);
Real    random_between       (Attributes &p_random, Real p_low, Real p_high);

#endif
