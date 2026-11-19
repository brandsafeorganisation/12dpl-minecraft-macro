#ifndef EVENTS_4DM_INCLUDED
#define EVENTS_4DM_INCLUDED

#include "../../include/core/common.h"
#include "../../include/core/util.h"
#include "../../include/core/records.h"
#include "../../include/core/events.h"

void events_clear(Attributes &p_events)
// ----------------------------------------------------------------
// Empty the queue
// ----------------------------------------------------------------
{
  record_clear      (p_events, DATATYPE_EVENT_QUEUE);
  record_set_integer(p_events, ATTR_EVENT_HEAD, 1);
  record_set_integer(p_events, ATTR_COUNT,      0);
  record_set_integer(p_events, ATTR_EVENT_LOST, 0);
}

void emit_event(Attributes &p_events, Integer p_type, Integer p_i1, Integer p_i2, Integer p_i3, Integer p_i4, Real p_r1, Real p_r2, Real p_r3, Text p_text)
// ----------------------------------------------------------------
// Add an event to the end of the queue
// The queue is a ring of EVENT_QUEUE_SIZE entries; if it is full
// the event is dropped and counted in the "lost" field
// ----------------------------------------------------------------
{
  Integer l_head  = record_integer(p_events, ATTR_EVENT_HEAD);
  Integer l_count = record_integer(p_events, ATTR_COUNT);
  Integer l_slot  = 0;

  if (l_count >= EVENT_QUEUE_SIZE) {
    record_set_integer(p_events, ATTR_EVENT_LOST, record_integer(p_events, ATTR_EVENT_LOST) + 1);
    return;
  }
  if (l_head < 1) l_head = 1;

  l_slot = l_head + l_count;
  if (l_slot > EVENT_QUEUE_SIZE) l_slot = l_slot - EVENT_QUEUE_SIZE;

  record_set_integer_at(p_events, ATTR_TYPE,     l_slot, p_type);
  record_set_integer_at(p_events, ATTR_EVENT_I1, l_slot, p_i1);
  record_set_integer_at(p_events, ATTR_EVENT_I2, l_slot, p_i2);
  record_set_integer_at(p_events, ATTR_EVENT_I3, l_slot, p_i3);
  record_set_integer_at(p_events, ATTR_EVENT_I4, l_slot, p_i4);
  record_set_real_at   (p_events, ATTR_EVENT_R1, l_slot, p_r1);
  record_set_real_at   (p_events, ATTR_EVENT_R2, l_slot, p_r2);
  record_set_real_at   (p_events, ATTR_EVENT_R3, l_slot, p_r3);
  record_set_text_at   (p_events, ATTR_TEXT,     l_slot, p_text);

  record_set_integer(p_events, ATTR_EVENT_HEAD, l_head);
  record_set_integer(p_events, ATTR_COUNT,      l_count + 1);
}

void emit_simple_event(Attributes &p_events, Integer p_type)
// ----------------------------------------------------------------
// Event with no payload
// ----------------------------------------------------------------
{
  emit_event(p_events, p_type, 0, 0, 0, 0, 0.0, 0.0, 0.0, "");
}

void emit_cell_event(Attributes &p_events, Integer p_type, Integer p_x, Integer p_y, Integer p_z, Integer p_block)
// ----------------------------------------------------------------
// Event about a block cell
// ----------------------------------------------------------------
{
  emit_event(p_events, p_type, p_x, p_y, p_z, p_block, 0.0, 0.0, 0.0, "");
}

void emit_item_event(Attributes &p_events, Integer p_type, Integer p_item, Integer p_count)
// ----------------------------------------------------------------
// Event about an item stack
// ----------------------------------------------------------------
{
  emit_event(p_events, p_type, p_item, p_count, 0, 0, 0.0, 0.0, 0.0, "");
}

void emit_drop_event(Attributes &p_events, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z)
// ----------------------------------------------------------------
// Ask for an item stack to be dropped into the world at (x, y, z)
// damage is the wear of a tool (0 for other items)
// ----------------------------------------------------------------
{
  emit_event(p_events, EVT_SPAWN_DROP, p_item, p_count, p_damage, 0, p_x, p_y, p_z, "");
}

void emit_throw_event(Attributes &p_events, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z,
                      Real p_yaw, Real p_pitch)
// ----------------------------------------------------------------
// Ask for an item stack to be thrown from (x, y, z) the way yaw and
// pitch look. The direction is packed into one integer: yaw in
// thousandths of a radian (0 .. 6283) times 10000, plus pitch in
// thousandths plus 5000.
// ----------------------------------------------------------------
{
  Real    l_yaw  = p_yaw - Floor(p_yaw / (2.0 * PI)) * 2.0 * PI;
  Integer l_code = Floor(l_yaw * 1000.0 + 0.5) * 10000 + Floor(clamp_real(p_pitch, -HALF_PI, HALF_PI) * 1000.0 + 0.5) + 5000;

  emit_event(p_events, EVT_THROW_DROP, p_item, p_count, p_damage, l_code, p_x, p_y, p_z, "");
}

void event_throw_direction(Attributes &p_event, Real &p_yaw, Real &p_pitch)
// ----------------------------------------------------------------
// The yaw and pitch packed into an EVT_THROW_DROP event
// ----------------------------------------------------------------
{
  Integer l_code  = event_integer(p_event, 4);
  Integer l_yaw   = Floor(l_code / 10000.0);

  p_yaw   = l_yaw / 1000.0;
  p_pitch = (l_code - l_yaw * 10000 - 5000) / 1000.0;
}

void emit_toast(Attributes &p_events, Text p_text)
// ----------------------------------------------------------------
// Ask the HUD to show a short message
// ----------------------------------------------------------------
{
  emit_event(p_events, EVT_TOAST, 0, 0, 0, 0, 0.0, 0.0, 0.0, p_text);
}

Integer events_pending(Attributes &p_events)
// ----------------------------------------------------------------
// Number of events waiting in the queue
// ----------------------------------------------------------------
{
  return record_integer(p_events, ATTR_COUNT);
}

Integer next_event(Attributes &p_events, Attributes &p_event)
// ----------------------------------------------------------------
// Move the oldest event off the queue into the event record
// Returns TRUE if there was one, FALSE if the queue was empty
// ----------------------------------------------------------------
{
  Integer l_head  = record_integer(p_events, ATTR_EVENT_HEAD);
  Integer l_count = record_integer(p_events, ATTR_COUNT);

  record_clear(p_event, DATATYPE_EVENT);
  if (l_count <= 0) {
    record_set_integer(p_event, ATTR_TYPE, EVT_NONE);
    return FALSE;
  }

  record_set_integer(p_event, ATTR_TYPE,     record_integer_at(p_events, ATTR_TYPE,     l_head));
  record_set_integer(p_event, ATTR_EVENT_I1, record_integer_at(p_events, ATTR_EVENT_I1, l_head));
  record_set_integer(p_event, ATTR_EVENT_I2, record_integer_at(p_events, ATTR_EVENT_I2, l_head));
  record_set_integer(p_event, ATTR_EVENT_I3, record_integer_at(p_events, ATTR_EVENT_I3, l_head));
  record_set_integer(p_event, ATTR_EVENT_I4, record_integer_at(p_events, ATTR_EVENT_I4, l_head));
  record_set_real   (p_event, ATTR_EVENT_R1, record_real_at   (p_events, ATTR_EVENT_R1, l_head));
  record_set_real   (p_event, ATTR_EVENT_R2, record_real_at   (p_events, ATTR_EVENT_R2, l_head));
  record_set_real   (p_event, ATTR_EVENT_R3, record_real_at   (p_events, ATTR_EVENT_R3, l_head));
  record_set_text   (p_event, ATTR_TEXT,     record_text_at   (p_events, ATTR_TEXT,     l_head));

  ++l_head;
  if (l_head > EVENT_QUEUE_SIZE) l_head = 1;
  record_set_integer(p_events, ATTR_EVENT_HEAD, l_head);
  record_set_integer(p_events, ATTR_COUNT,      l_count - 1);

  return TRUE;
}

Integer event_type(Attributes &p_event)
// ----------------------------------------------------------------
// EVT_* type of an event record
// ----------------------------------------------------------------
{
  return record_integer(p_event, ATTR_TYPE);
}

Integer event_integer(Attributes &p_event, Integer p_which)
// ----------------------------------------------------------------
// Integer payload number which (1..4) of an event record
// ----------------------------------------------------------------
{
  if (p_which == 1) return record_integer(p_event, ATTR_EVENT_I1);
  if (p_which == 2) return record_integer(p_event, ATTR_EVENT_I2);
  if (p_which == 3) return record_integer(p_event, ATTR_EVENT_I3);
  return record_integer(p_event, ATTR_EVENT_I4);
}

Real event_real(Attributes &p_event, Integer p_which)
// ----------------------------------------------------------------
// Real payload number which (1..3) of an event record
// ----------------------------------------------------------------
{
  if (p_which == 1) return record_real(p_event, ATTR_EVENT_R1);
  if (p_which == 2) return record_real(p_event, ATTR_EVENT_R2);
  return record_real(p_event, ATTR_EVENT_R3);
}

Text event_text(Attributes &p_event)
// ----------------------------------------------------------------
// Text payload of an event record
// ----------------------------------------------------------------
{
  return record_text(p_event, ATTR_TEXT);
}

Integer event_is_remote(Attributes &p_event)
// ----------------------------------------------------------------
// TRUE for a block event caused by another player: it was already
// handled on their machine, so it drops nothing here and isn't sent
// back to them
// ----------------------------------------------------------------
{
  return event_real(p_event, 3) > EVENT_REMOTE * 0.5;
}

#endif
