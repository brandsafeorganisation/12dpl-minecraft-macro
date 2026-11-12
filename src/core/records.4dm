#ifndef RECORDS_4DM_INCLUDED
#define RECORDS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/records.h"

// ---------------------------------------------------------------- field access

Integer record_integer(Attributes &p_record, Text p_field)
// ----------------------------------------------------------------
// Integer field of a record, 0 if the record doesn't have it
// ----------------------------------------------------------------
{
  Integer l_value = 0;

  if (Get_attribute(p_record, p_field, l_value) != 0) l_value = 0;

  return l_value;
}

Real record_real(Attributes &p_record, Text p_field)
// ----------------------------------------------------------------
// Real field of a record, 0.0 if the record doesn't have it
// ----------------------------------------------------------------
{
  Real l_value = 0.0;

  if (Get_attribute(p_record, p_field, l_value) != 0) l_value = 0.0;

  return l_value;
}

Text record_text(Attributes &p_record, Text p_field)
// ----------------------------------------------------------------
// Text field of a record, "" if the record doesn't have it
// ----------------------------------------------------------------
{
  Text l_value = "";

  if (Get_attribute(p_record, p_field, l_value) != 0) l_value = "";

  return l_value;
}

void record_set_integer(Attributes &p_record, Text p_field, Integer p_value)
// ----------------------------------------------------------------
// Set (creating if needed) an Integer field
// A field keeps the type it was created with, so always write a
// field with the same setter
// ----------------------------------------------------------------
{
  Set_attribute(p_record, p_field, p_value);
}

void record_set_real(Attributes &p_record, Text p_field, Real p_value)
// ----------------------------------------------------------------
// Set (creating if needed) a Real field
// ----------------------------------------------------------------
{
  Set_attribute(p_record, p_field, p_value);
}

void record_set_text(Attributes &p_record, Text p_field, Text p_value)
// ----------------------------------------------------------------
// Set (creating if needed) a Text field
// ----------------------------------------------------------------
{
  Set_attribute(p_record, p_field, p_value);
}

void record_clear(Attributes &p_record, Text p_datatype)
// ----------------------------------------------------------------
// Remove every field and stamp the record with its datatype, so a
// dump of the record says what it is
// ----------------------------------------------------------------
{
  Attribute_delete_all(p_record);
  Set_attribute(p_record, ATTR_DATATYPE, p_datatype);
}

Text record_datatype(Attributes &p_record)
// ----------------------------------------------------------------
// The datatype a record was stamped with by record_clear
// ----------------------------------------------------------------
{
  return record_text(p_record, ATTR_DATATYPE);
}

// ---------------------------------------------------------------- collections

Text record_field_at(Text p_field, Integer p_index)
// ----------------------------------------------------------------
// Name of field of entity number index: ("x", 3) -> "x_3"
// ----------------------------------------------------------------
{
  return p_field + "_" + To_text(p_index);
}

Integer record_integer_at(Attributes &p_record, Text p_field, Integer p_index)
// ----------------------------------------------------------------
// Integer field of entity number index
// ----------------------------------------------------------------
{
  return record_integer(p_record, record_field_at(p_field, p_index));
}

Real record_real_at(Attributes &p_record, Text p_field, Integer p_index)
// ----------------------------------------------------------------
// Real field of entity number index
// ----------------------------------------------------------------
{
  return record_real(p_record, record_field_at(p_field, p_index));
}

Text record_text_at(Attributes &p_record, Text p_field, Integer p_index)
// ----------------------------------------------------------------
// Text field of entity number index
// ----------------------------------------------------------------
{
  return record_text(p_record, record_field_at(p_field, p_index));
}

void record_set_integer_at(Attributes &p_record, Text p_field, Integer p_index, Integer p_value)
// ----------------------------------------------------------------
// Set an Integer field of entity number index
// ----------------------------------------------------------------
{
  record_set_integer(p_record, record_field_at(p_field, p_index), p_value);
}

void record_set_real_at(Attributes &p_record, Text p_field, Integer p_index, Real p_value)
// ----------------------------------------------------------------
// Set a Real field of entity number index
// ----------------------------------------------------------------
{
  record_set_real(p_record, record_field_at(p_field, p_index), p_value);
}

void record_set_text_at(Attributes &p_record, Text p_field, Integer p_index, Text p_value)
// ----------------------------------------------------------------
// Set a Text field of entity number index
// ----------------------------------------------------------------
{
  record_set_text(p_record, record_field_at(p_field, p_index), p_value);
}

// ---------------------------------------------------------------- random numbers

void random_seed(Attributes &p_random, Integer p_seed)
// ----------------------------------------------------------------
// Start a random sequence. The same seed gives the same sequence.
// ----------------------------------------------------------------
{
  Real l_state = Absolute(p_seed * 1.0);

  l_state = l_state - Floor(l_state / (RANDOM_MODULUS - 1.0)) * (RANDOM_MODULUS - 1.0) + 1.0;

  record_clear   (p_random, DATATYPE_RANDOM);
  record_set_real(p_random, ATTR_RANDOM_STATE, l_state);
}

Real random_next(Attributes &p_random)
// ----------------------------------------------------------------
// Next number in [0, 1) of the sequence (Park-Miller generator;
// every product fits exactly in a Real)
// ----------------------------------------------------------------
{
  Real l_state = record_real(p_random, ATTR_RANDOM_STATE);

  if (l_state < 1.0) l_state = 1.0;
  l_state = l_state * RANDOM_MULTIPLIER;
  l_state = l_state - Floor(l_state / RANDOM_MODULUS) * RANDOM_MODULUS;
  record_set_real(p_random, ATTR_RANDOM_STATE, l_state);

  return (l_state - 1.0) / (RANDOM_MODULUS - 1.0);
}

Integer random_range(Attributes &p_random, Integer p_low, Integer p_high)
// ----------------------------------------------------------------
// Random Integer in [low, high]
// ----------------------------------------------------------------
{
  Integer l_value = p_low + Floor(random_next(p_random) * (p_high - p_low + 1));

  if (l_value > p_high) l_value = p_high;

  return l_value;
}

Real random_between(Attributes &p_random, Real p_low, Real p_high)
// ----------------------------------------------------------------
// Random Real in [low, high)
// ----------------------------------------------------------------
{
  return p_low + random_next(p_random) * (p_high - p_low);
}

#endif
