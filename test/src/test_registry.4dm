#ifndef TEST_REGISTRY_4DM_INCLUDED
#define TEST_REGISTRY_4DM_INCLUDED

// Written by tools/make_test_registry.py: do not edit (see the header)

#include "../../include/core/records.h"
#include "../include/test.h"
#include "../include/test_registry.h"

void test_info_set(Attributes &p_info, Text p_name, Text p_kind, Text p_part, Text p_module, Text p_file,
                   Integer p_first, Integer p_last, Text p_returns, Text p_params, Text p_signature,
                   Integer p_flags, Text p_why, Text p_calls)
// ----------------------------------------------------------------
// Fill an info record
// ----------------------------------------------------------------
{
  record_clear      (p_info, DATATYPE_TEST_INFO);
  record_set_text   (p_info, ATTR_TEST_NAME, p_name);
  record_set_text   (p_info, ATTR_TEST_KIND, p_kind);
  record_set_text   (p_info, ATTR_TEST_PART, p_part);
  record_set_text   (p_info, ATTR_TEST_MODULE, p_module);
  record_set_text   (p_info, ATTR_TEST_FILE, p_file);
  record_set_integer(p_info, ATTR_TEST_FIRST, p_first);
  record_set_integer(p_info, ATTR_TEST_LAST, p_last);
  record_set_text   (p_info, ATTR_TEST_RETURNS, p_returns);
  record_set_text   (p_info, ATTR_TEST_PARAMS, p_params);
  record_set_text   (p_info, ATTR_TEST_SIGNATURE, p_signature);
  record_set_integer(p_info, ATTR_TEST_FLAGS, p_flags);
  record_set_text   (p_info, ATTR_TEST_WHY, p_why);
  record_set_text   (p_info, ATTR_TEST_CALLS, p_calls);
}

void test_registry_info_1(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 1 to 40 are
// ----------------------------------------------------------------
{
  if (p_id == 1) test_info_set(p_info, "block_is_solid", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 12, 21, "Integer", "I:p_block",
                              "Integer block_is_solid(Integer p_block)", 0, "", "block_is_plant");
  if (p_id == 2) test_info_set(p_info, "block_is_plant", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 23, 33, "Integer", "I:p_block",
                              "Integer block_is_plant(Integer p_block)", 0, "", "");
  if (p_id == 3) test_info_set(p_info, "block_is_door", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 37, 43, "Integer", "I:p_block",
                              "Integer block_is_door(Integer p_block)", 0, "", "");
  if (p_id == 4) test_info_set(p_info, "block_is_bed", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 45, 52, "Integer", "I:p_block",
                              "Integer block_is_bed(Integer p_block)", 0, "", "");
  if (p_id == 5) test_info_set(p_info, "block_is_shaped", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 54, 61, "Integer", "I:p_block",
                              "Integer block_is_shaped(Integer p_block)", 0, "", "block_is_bed, block_is_door");
  if (p_id == 6) test_info_set(p_info, "block_door", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 63, 74, "Integer", "I:p_facing I:p_open I:p_top",
                              "Integer block_door(Integer p_facing, Integer p_open, Integer p_top)", 0, "", "");
  if (p_id == 7) test_info_set(p_info, "block_door_facing", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 76, 82, "Integer", "I:p_block",
                              "Integer block_door_facing(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 8) test_info_set(p_info, "block_door_open", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 84, 90, "Integer", "I:p_block",
                              "Integer block_door_open(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 9) test_info_set(p_info, "block_door_top", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 92, 98, "Integer", "I:p_block",
                              "Integer block_door_top(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 10) test_info_set(p_info, "block_bed", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 100, 109, "Integer", "I:p_facing I:p_head",
                              "Integer block_bed(Integer p_facing, Integer p_head)", 0, "", "");
  if (p_id == 11) test_info_set(p_info, "block_bed_facing", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 111, 117, "Integer", "I:p_block",
                              "Integer block_bed_facing(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 12) test_info_set(p_info, "block_bed_head", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 119, 125, "Integer", "I:p_block",
                              "Integer block_bed_head(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 13) test_info_set(p_info, "block_facing_step", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 127, 138, "void", "I:p_facing &I:p_dx &I:p_dz",
                              "void block_facing_step(Integer p_facing, Integer &p_dx, Integer &p_dz)", 0, "", "");
  if (p_id == 14) test_info_set(p_info, "block_partner", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 140, 172, "Integer", "I:p_block I:p_x I:p_y I:p_z &I:p_px &I:p_py &I:p_pz",
                              "Integer block_partner(Integer p_block, Integer p_x, Integer p_y, Integer p_z, Integer &p_px, Integer &p_py, Integer &p_pz)", 0, "", "block_bed_facing, block_bed_head, block_door_top, block_facing_step, block_is_bed, block_is_door");
  if (p_id == 15) test_info_set(p_info, "block_box", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 174, 232, "Integer", "I:p_block &R:p_min_x &R:p_min_y &R:p_min_z &R:p_max_x &R:p_max_y &R:p_max_z",
                              "Integer block_box(Integer p_block, Real &p_min_x, Real &p_min_y, Real &p_min_z, Real &p_max_x, Real &p_max_y, Real &p_max_z)", 0, "", "block_door_facing, block_door_open, block_is_bed, block_is_door, block_is_plant");
  if (p_id == 16) test_info_set(p_info, "block_light_emission", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 234, 242, "Integer", "I:p_block",
                              "Integer block_light_emission(Integer p_block)", 0, "", "block_furnace_is_lit");
  if (p_id == 17) test_info_set(p_info, "block_is_see_through", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 244, 253, "Integer", "I:p_block",
                              "Integer block_is_see_through(Integer p_block)", 0, "", "");
  if (p_id == 18) test_info_set(p_info, "block_hides_faces", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 255, 265, "Integer", "I:p_block",
                              "Integer block_hides_faces(Integer p_block)", 0, "", "block_is_see_through, block_is_shaped, block_is_solid");
  if (p_id == 19) test_info_set(p_info, "block_plant_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 267, 278, "Integer", "I:p_block",
                              "Integer block_plant_texture(Integer p_block)", 0, "", "");
  if (p_id == 20) test_info_set(p_info, "block_is_furnace", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 280, 288, "Integer", "I:p_block",
                              "Integer block_is_furnace(Integer p_block)", 0, "", "");
  if (p_id == 21) test_info_set(p_info, "block_furnace_is_lit", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 290, 297, "Integer", "I:p_block",
                              "Integer block_furnace_is_lit(Integer p_block)", 0, "", "");
  if (p_id == 22) test_info_set(p_info, "block_furnace_lit_as", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 299, 310, "Integer", "I:p_block I:p_lit",
                              "Integer block_furnace_lit_as(Integer p_block, Integer p_lit)", 0, "", "block_furnace_is_lit");
  if (p_id == 23) test_info_set(p_info, "block_furnace_front", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 312, 324, "Integer", "I:p_block",
                              "Integer block_furnace_front(Integer p_block)", 0, "", "block_furnace_lit_as");
  if (p_id == 24) test_info_set(p_info, "block_falls", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 326, 334, "Integer", "I:p_block",
                              "Integer block_falls(Integer p_block)", 0, "", "");
  if (p_id == 25) test_info_set(p_info, "block_hand_hits", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 336, 364, "Integer", "I:p_block",
                              "Integer block_hand_hits(Integer p_block)", 0, "", "block_is_bed, block_is_door, block_is_plant");
  if (p_id == 26) test_info_set(p_info, "block_tool_kind", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 366, 389, "Integer", "I:p_block",
                              "Integer block_tool_kind(Integer p_block)", 0, "", "block_is_bed, block_is_door, block_is_furnace");
  if (p_id == 27) test_info_set(p_info, "block_needs_tool", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 391, 399, "Integer", "I:p_block",
                              "Integer block_needs_tool(Integer p_block)", 0, "", "block_tool_kind");
  if (p_id == 28) test_info_set(p_info, "block_tier_needed", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 401, 409, "Integer", "I:p_block",
                              "Integer block_tier_needed(Integer p_block)", 0, "", "");
  if (p_id == 29) test_info_set(p_info, "block_hits_with", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 411, 433, "Integer", "I:p_block I:p_tool_item",
                              "Integer block_hits_with(Integer p_block, Integer p_tool_item)", 0, "", "block_hand_hits, block_tool_kind, item_tool_kind, item_tool_tier");
  if (p_id == 30) test_info_set(p_info, "block_drop_item", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 435, 467, "Integer", "I:p_block I:p_tool_item",
                              "Integer block_drop_item(Integer p_block, Integer p_tool_item)", 0, "", "block_bed_head, block_door_top, block_is_bed, block_is_door, block_is_furnace, block_needs_tool, block_tier_needed, block_tool_kind, item_tool_kind, item_tool_tier");
  if (p_id == 31) test_info_set(p_info, "block_pick_item", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 469, 480, "Integer", "I:p_block",
                              "Integer block_pick_item(Integer p_block)", 0, "", "block_is_bed, block_is_door, block_is_furnace, item_places_block");
  if (p_id == 32) test_info_set(p_info, "block_face_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 482, 543, "Integer", "I:p_block I:p_direction",
                              "Integer block_face_texture(Integer p_block, Integer p_direction)", 0, "", "block_furnace_front, block_furnace_is_lit, block_is_furnace");
  if (p_id == 33) test_info_set(p_info, "block_face_shade", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 545, 555, "Real", "I:p_direction",
                              "Real block_face_shade(Integer p_direction)", 0, "", "");
  if (p_id == 34) test_info_set(p_info, "item_name", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 559, 615, "Text", "I:p_item",
                              "Text item_name(Integer p_item)", 0, "", "");
  if (p_id == 35) test_info_set(p_info, "item_places_block", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 617, 630, "Integer", "I:p_item",
                              "Integer item_places_block(Integer p_item)", 0, "", "");
  if (p_id == 36) test_info_set(p_info, "item_is_block", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 632, 640, "Integer", "I:p_item",
                              "Integer item_is_block(Integer p_item)", 0, "", "block_is_plant, item_places_block");
  if (p_id == 37) test_info_set(p_info, "item_max_stack", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 642, 650, "Integer", "I:p_item",
                              "Integer item_max_stack(Integer p_item)", 0, "", "item_armour_place, item_tool_kind");
  if (p_id == 38) test_info_set(p_info, "item_tool_kind", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 652, 662, "Integer", "I:p_item",
                              "Integer item_tool_kind(Integer p_item)", 0, "", "");
  if (p_id == 39) test_info_set(p_info, "item_tool_tier", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 664, 676, "Integer", "I:p_item",
                              "Integer item_tool_tier(Integer p_item)", 0, "", "");
  if (p_id == 40) test_info_set(p_info, "item_max_uses", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 678, 692, "Integer", "I:p_item",
                              "Integer item_max_uses(Integer p_item)", 0, "", "item_tool_tier");
}

void test_registry_call_1(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 1 to 40 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 1) {   // block_is_solid
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_solid(l_i1);
    Get_time(l_end);
  } else if (p_id == 2) {   // block_is_plant
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_plant(l_i1);
    Get_time(l_end);
  } else if (p_id == 3) {   // block_is_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_door(l_i1);
    Get_time(l_end);
  } else if (p_id == 4) {   // block_is_bed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_bed(l_i1);
    Get_time(l_end);
  } else if (p_id == 5) {   // block_is_shaped
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_shaped(l_i1);
    Get_time(l_end);
  } else if (p_id == 6) {   // block_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = block_door(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 7) {   // block_door_facing
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_door_facing(l_i1);
    Get_time(l_end);
  } else if (p_id == 8) {   // block_door_open
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_door_open(l_i1);
    Get_time(l_end);
  } else if (p_id == 9) {   // block_door_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_door_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 10) {   // block_bed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_bed(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 11) {   // block_bed_facing
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_bed_facing(l_i1);
    Get_time(l_end);
  } else if (p_id == 12) {   // block_bed_head
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_bed_head(l_i1);
    Get_time(l_end);
  } else if (p_id == 13) {   // block_facing_step
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    block_facing_step(l_i1, l_i2, l_i3);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
  } else if (p_id == 14) {   // block_partner
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    Get_time(l_start);
    l_ret_i = block_partner(l_i1, l_i2, l_i3, l_i4, l_i5, l_i6, l_i7);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
    record_set_integer(p_out, ATTR_TEST_I7, l_i7);
  } else if (p_id == 15) {   // block_box
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    l_ret_i = block_box(l_i1, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
    record_set_real(p_out, ATTR_TEST_R4, l_r4);
    record_set_real(p_out, ATTR_TEST_R5, l_r5);
    record_set_real(p_out, ATTR_TEST_R6, l_r6);
  } else if (p_id == 16) {   // block_light_emission
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_light_emission(l_i1);
    Get_time(l_end);
  } else if (p_id == 17) {   // block_is_see_through
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_see_through(l_i1);
    Get_time(l_end);
  } else if (p_id == 18) {   // block_hides_faces
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_hides_faces(l_i1);
    Get_time(l_end);
  } else if (p_id == 19) {   // block_plant_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_plant_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 20) {   // block_is_furnace
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_furnace(l_i1);
    Get_time(l_end);
  } else if (p_id == 21) {   // block_furnace_is_lit
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_furnace_is_lit(l_i1);
    Get_time(l_end);
  } else if (p_id == 22) {   // block_furnace_lit_as
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_furnace_lit_as(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 23) {   // block_furnace_front
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_furnace_front(l_i1);
    Get_time(l_end);
  } else if (p_id == 24) {   // block_falls
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_falls(l_i1);
    Get_time(l_end);
  } else if (p_id == 25) {   // block_hand_hits
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_hand_hits(l_i1);
    Get_time(l_end);
  } else if (p_id == 26) {   // block_tool_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_tool_kind(l_i1);
    Get_time(l_end);
  } else if (p_id == 27) {   // block_needs_tool
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_needs_tool(l_i1);
    Get_time(l_end);
  } else if (p_id == 28) {   // block_tier_needed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_tier_needed(l_i1);
    Get_time(l_end);
  } else if (p_id == 29) {   // block_hits_with
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_hits_with(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 30) {   // block_drop_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_drop_item(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 31) {   // block_pick_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_pick_item(l_i1);
    Get_time(l_end);
  } else if (p_id == 32) {   // block_face_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_face_texture(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 33) {   // block_face_shade
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = block_face_shade(l_i1);
    Get_time(l_end);
  } else if (p_id == 34) {   // item_name
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = item_name(l_i1);
    Get_time(l_end);
  } else if (p_id == 35) {   // item_places_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_places_block(l_i1);
    Get_time(l_end);
  } else if (p_id == 36) {   // item_is_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_is_block(l_i1);
    Get_time(l_end);
  } else if (p_id == 37) {   // item_max_stack
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_max_stack(l_i1);
    Get_time(l_end);
  } else if (p_id == 38) {   // item_tool_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_tool_kind(l_i1);
    Get_time(l_end);
  } else if (p_id == 39) {   // item_tool_tier
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_tool_tier(l_i1);
    Get_time(l_end);
  } else if (p_id == 40) {   // item_max_uses
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_max_uses(l_i1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_2(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 41 to 80 are
// ----------------------------------------------------------------
{
  if (p_id == 41) test_info_set(p_info, "item_attack_damage", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 694, 706, "Integer", "I:p_item",
                              "Integer item_attack_damage(Integer p_item)", 0, "", "item_tool_kind, item_tool_tier");
  if (p_id == 42) test_info_set(p_info, "item_food_value", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 708, 719, "Integer", "I:p_item",
                              "Integer item_food_value(Integer p_item)", 0, "", "");
  if (p_id == 43) test_info_set(p_info, "item_armour_place", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 721, 732, "Integer", "I:p_item",
                              "Integer item_armour_place(Integer p_item)", 0, "", "");
  if (p_id == 44) test_info_set(p_info, "item_armour_points", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 734, 744, "Integer", "I:p_item",
                              "Integer item_armour_points(Integer p_item)", 0, "", "");
  if (p_id == 45) test_info_set(p_info, "item_spawn_egg_mob", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 746, 755, "Integer", "I:p_item",
                              "Integer item_spawn_egg_mob(Integer p_item)", 0, "", "");
  if (p_id == 46) test_info_set(p_info, "item_fuel_seconds", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 757, 771, "Integer", "I:p_item",
                              "Integer item_fuel_seconds(Integer p_item)", 0, "", "item_tool_tier");
  if (p_id == 47) test_info_set(p_info, "item_smelt_result", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 773, 785, "Integer", "I:p_item",
                              "Integer item_smelt_result(Integer p_item)", 0, "", "");
  if (p_id == 48) test_info_set(p_info, "item_top_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 787, 794, "Integer", "I:p_item",
                              "Integer item_top_texture(Integer p_item)", 0, "", "block_face_texture, item_places_block");
  if (p_id == 49) test_info_set(p_info, "item_side_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 796, 803, "Integer", "I:p_item",
                              "Integer item_side_texture(Integer p_item)", 0, "", "block_face_texture, item_places_block");
  if (p_id == 50) test_info_set(p_info, "item_sprite_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 805, 840, "Integer", "I:p_item",
                              "Integer item_sprite_texture(Integer p_item)", 0, "", "block_plant_texture");
  if (p_id == 51) test_info_set(p_info, "pack_init_tables", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 14, 68, "void", "",
                              "void pack_init_tables()", 0, "", "floor_divide");
  if (p_id == 52) test_info_set(p_info, "pack_word_byte", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 72, 89, "Integer", "I:p_word I:p_byte",
                              "Integer pack_word_byte(Integer p_word, Integer p_byte)", 0, "", "floor_divide");
  if (p_id == 53) test_info_set(p_info, "pack_paeth", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 91, 104, "Integer", "I:p_left I:p_up I:p_up_left",
                              "Integer pack_paeth(Integer p_left, Integer p_up, Integer p_up_left)", 0, "", "");
  if (p_id == 54) test_info_set(p_info, "pack_is_zip", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 106, 117, "Integer", "T:p_path",
                              "Integer pack_is_zip(Text p_path)", 0, "", "");
  if (p_id == 55) test_info_set(p_info, "pack_key", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 119, 126, "Text", "T:p_kind T:p_name",
                              "Text pack_key(Text p_kind, Text p_name)", 0, "", "pack_replace");
  if (p_id == 56) test_info_set(p_info, "pack_replace", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 128, 143, "Text", "T:p_text T:p_find T:p_with",
                              "Text pack_replace(Text p_text, Text p_find, Text p_with)", 0, "", "");
  if (p_id == 57) test_info_set(p_info, "pack_part", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 145, 159, "Integer", "&I:p_tex &T:p_name &I:p_x &I:p_y &I:p_w &I:p_h &I:p_turn I:p_set_tex T:p_set_name I:p_set_x I:p_set_y I:p_set_w I:p_set_h I:p_set_turn",
                              "Integer pack_part(Integer &p_tex, Text &p_name, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h, Integer &p_turn, Integer p_set_tex, Text p_set_name, Integer p_set_x, Integer p_set_y, Integer p_set_w, Integer p_set_h, Integer p_set_turn)", 0, "", "");
  if (p_id == 58) test_info_set(p_info, "pack_map_part", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 161, 199, "Integer", "I:p_entry &I:p_tex &T:p_name &I:p_x &I:p_y &I:p_w &I:p_h &I:p_turn",
                              "Integer pack_map_part(Integer p_entry, Integer &p_tex, Text &p_name, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h, Integer &p_turn)", 0, "", "pack_part");
  if (p_id == 59) test_info_set(p_info, "pack_entry", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 201, 213, "Integer", "&I:p_tex &T:p_kind &T:p_name &I:p_tint &T:p_overlay I:p_set_tex T:p_set_kind T:p_set_name I:p_set_tint T:p_set_overlay",
                              "Integer pack_entry(Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_tint, Text &p_overlay, Integer p_set_tex, Text p_set_kind, Text p_set_name, Integer p_set_tint, Text p_set_overlay)", 0, "", "");
  if (p_id == 60) test_info_set(p_info, "pack_map_entry", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 215, 302, "Integer", "I:p_entry &I:p_tex &T:p_kind &T:p_name &I:p_tint &T:p_overlay",
                              "Integer pack_map_entry(Integer p_entry, Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_tint, Text &p_overlay)", 0, "", "pack_entry");
  if (p_id == 61) test_info_set(p_info, "pack_store_byte", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 306, 317, "void", "I:p_buffer I:p_position I:p_value",
                              "void pack_store_byte(Integer p_buffer, Integer p_position, Integer p_value)", 0, "", "");
  if (p_id == 62) test_info_set(p_info, "pack_read_bytes", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 319, 361, "Integer", "&?:p_file I:p_count I:p_buffer",
                              "Integer pack_read_bytes(File &p_file, Integer p_count, Integer p_buffer)", 0, "takes an open File", "pack_store_byte, pack_word_byte");
  if (p_id == 63) test_info_set(p_info, "pack_read_short_at", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 363, 373, "Integer", "&?:p_file",
                              "Integer pack_read_short_at(File &p_file)", 0, "takes an open File", "");
  if (p_id == 64) test_info_set(p_info, "pack_read_word_at", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 375, 385, "Integer", "&?:p_file",
                              "Integer pack_read_word_at(File &p_file)", 0, "takes an open File", "");
  if (p_id == 65) test_info_set(p_info, "pack_file_size", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 387, 412, "Integer", "&?:p_file",
                              "Integer pack_file_size(File &p_file)", 0, "takes an open File", "floor_divide");
  if (p_id == 66) test_info_set(p_info, "inflate_bit", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 416, 434, "Integer", "",
                              "Integer inflate_bit()", 0, "", "");
  if (p_id == 67) test_info_set(p_info, "inflate_bits", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 436, 448, "Integer", "I:p_count",
                              "Integer inflate_bits(Integer p_count)", 0, "", "inflate_bit");
  if (p_id == 68) test_info_set(p_info, "inflate_put", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 450, 458, "void", "I:p_byte",
                              "void inflate_put(Integer p_byte)", 0, "", "");
  if (p_id == 69) test_info_set(p_info, "inflate_build", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 460, 499, "Integer", "I:p_table I:p_first I:p_count",
                              "Integer inflate_build(Integer p_table, Integer p_first, Integer p_count)", 0, "", "");
  if (p_id == 70) test_info_set(p_info, "inflate_decode", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 501, 526, "Integer", "I:p_table",
                              "Integer inflate_decode(Integer p_table)", 0, "", "inflate_bit");
  if (p_id == 71) test_info_set(p_info, "inflate_codes", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 528, 567, "Integer", "",
                              "Integer inflate_codes()", 0, "", "inflate_bits, inflate_decode, inflate_put");
  if (p_id == 72) test_info_set(p_info, "inflate_stored", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 569, 591, "Integer", "",
                              "Integer inflate_stored()", 0, "", "inflate_put");
  if (p_id == 73) test_info_set(p_info, "inflate_fixed", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 593, 610, "Integer", "",
                              "Integer inflate_fixed()", 0, "", "inflate_build, inflate_codes");
  if (p_id == 74) test_info_set(p_info, "inflate_dynamic", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 612, 672, "Integer", "",
                              "Integer inflate_dynamic()", 0, "", "inflate_bits, inflate_build, inflate_codes, inflate_decode");
  if (p_id == 75) test_info_set(p_info, "pack_inflate", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 674, 710, "Integer", "I:p_first I:p_last I:p_limit",
                              "Integer pack_inflate(Integer p_first, Integer p_last, Integer p_limit)", 0, "", "inflate_bit, inflate_bits, inflate_dynamic, inflate_fixed, inflate_stored, pack_init_tables");
  if (p_id == 76) test_info_set(p_info, "pack_zip_index", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 714, 802, "Integer", "T:p_path &A:p_wanted &A:p_index &T:p_problem",
                              "Integer pack_zip_index(Text p_path, Attributes &p_wanted, Attributes &p_index, Text &p_problem)", 0, "", "pack_file_size, pack_key, pack_read_short_at, pack_read_word_at, record_clear, record_integer, record_set_integer");
  if (p_id == 77) test_info_set(p_info, "pack_load_png_from_zip", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 804, 851, "Integer", "T:p_path &A:p_index T:p_key",
                              "Integer pack_load_png_from_zip(Text p_path, Attributes &p_index, Text p_key)", 0, "", "pack_inflate, pack_read_bytes, pack_read_short_at, pack_read_word_at, record_integer");
  if (p_id == 78) test_info_set(p_info, "pack_load_png_from_folder", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 853, 869, "Integer", "T:p_folder T:p_kind T:p_name",
                              "Integer pack_load_png_from_folder(Text p_folder, Text p_kind, Text p_name)", 0, "", "pack_read_bytes, pack_replace");
  if (p_id == 79) test_info_set(p_info, "png_number", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 873, 879, "Integer", "I:p_at",
                              "Integer png_number(Integer p_at)", 0, "", "");
  if (p_id == 80) test_info_set(p_info, "png_is_chunk", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 881, 891, "Integer", "I:p_at I:p_a I:p_b I:p_c I:p_d",
                              "Integer png_is_chunk(Integer p_at, Integer p_a, Integer p_b, Integer p_c, Integer p_d)", 0, "", "");
}

void test_registry_call_2(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 41 to 80 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 41) {   // item_attack_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_attack_damage(l_i1);
    Get_time(l_end);
  } else if (p_id == 42) {   // item_food_value
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_food_value(l_i1);
    Get_time(l_end);
  } else if (p_id == 43) {   // item_armour_place
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_armour_place(l_i1);
    Get_time(l_end);
  } else if (p_id == 44) {   // item_armour_points
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_armour_points(l_i1);
    Get_time(l_end);
  } else if (p_id == 45) {   // item_spawn_egg_mob
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_spawn_egg_mob(l_i1);
    Get_time(l_end);
  } else if (p_id == 46) {   // item_fuel_seconds
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_fuel_seconds(l_i1);
    Get_time(l_end);
  } else if (p_id == 47) {   // item_smelt_result
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_smelt_result(l_i1);
    Get_time(l_end);
  } else if (p_id == 48) {   // item_top_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_top_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 49) {   // item_side_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_side_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 50) {   // item_sprite_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_sprite_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 51) {   // pack_init_tables
    Get_time(l_start);
    pack_init_tables();
    Get_time(l_end);
  } else if (p_id == 52) {   // pack_word_byte
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = pack_word_byte(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 53) {   // pack_paeth
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = pack_paeth(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 54) {   // pack_is_zip
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = pack_is_zip(l_t1);
    Get_time(l_end);
  } else if (p_id == 55) {   // pack_key
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = pack_key(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 56) {   // pack_replace
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_t = pack_replace(l_t1, l_t2, l_t3);
    Get_time(l_end);
  } else if (p_id == 57) {   // pack_part
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i8 = record_integer(p_in, ATTR_TEST_I8);
    l_i9 = record_integer(p_in, ATTR_TEST_I9);
    l_i10 = record_integer(p_in, ATTR_TEST_I10);
    l_i11 = record_integer(p_in, ATTR_TEST_I11);
    l_i12 = record_integer(p_in, ATTR_TEST_I12);
    Get_time(l_start);
    l_ret_i = pack_part(l_i1, l_t1, l_i2, l_i3, l_i4, l_i5, l_i6, l_i7, l_t2, l_i8, l_i9, l_i10, l_i11, l_i12);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
  } else if (p_id == 58) {   // pack_map_part
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    Get_time(l_start);
    l_ret_i = pack_map_part(l_i1, l_i2, l_t1, l_i3, l_i4, l_i5, l_i6, l_i7);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
    record_set_integer(p_out, ATTR_TEST_I7, l_i7);
  } else if (p_id == 59) {   // pack_entry
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_t6 = record_text(p_in, ATTR_TEST_T6);
    Get_time(l_start);
    l_ret_i = pack_entry(l_i1, l_t1, l_t2, l_i2, l_t3, l_i3, l_t4, l_t5, l_i4, l_t6);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
  } else if (p_id == 60) {   // pack_map_entry
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = pack_map_entry(l_i1, l_i2, l_t1, l_t2, l_i3, l_t3);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
  } else if (p_id == 61) {   // pack_store_byte
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    pack_store_byte(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 66) {   // inflate_bit
    Get_time(l_start);
    l_ret_i = inflate_bit();
    Get_time(l_end);
  } else if (p_id == 67) {   // inflate_bits
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inflate_bits(l_i1);
    Get_time(l_end);
  } else if (p_id == 68) {   // inflate_put
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    inflate_put(l_i1);
    Get_time(l_end);
  } else if (p_id == 69) {   // inflate_build
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = inflate_build(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 70) {   // inflate_decode
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inflate_decode(l_i1);
    Get_time(l_end);
  } else if (p_id == 71) {   // inflate_codes
    Get_time(l_start);
    l_ret_i = inflate_codes();
    Get_time(l_end);
  } else if (p_id == 72) {   // inflate_stored
    Get_time(l_start);
    l_ret_i = inflate_stored();
    Get_time(l_end);
  } else if (p_id == 73) {   // inflate_fixed
    Get_time(l_start);
    l_ret_i = inflate_fixed();
    Get_time(l_end);
  } else if (p_id == 74) {   // inflate_dynamic
    Get_time(l_start);
    l_ret_i = inflate_dynamic();
    Get_time(l_end);
  } else if (p_id == 75) {   // pack_inflate
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = pack_inflate(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 76) {   // pack_zip_index
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = pack_zip_index(l_t1, g_test_record, g_test_record_2, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 77) {   // pack_load_png_from_zip
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = pack_load_png_from_zip(l_t1, g_test_record, l_t2);
    Get_time(l_end);
  } else if (p_id == 78) {   // pack_load_png_from_folder
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = pack_load_png_from_folder(l_t1, l_t2, l_t3);
    Get_time(l_end);
  } else if (p_id == 79) {   // png_number
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = png_number(l_i1);
    Get_time(l_end);
  } else if (p_id == 80) {   // png_is_chunk
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = png_is_chunk(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_3(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 81 to 120 are
// ----------------------------------------------------------------
{
  if (p_id == 81) test_info_set(p_info, "png_sample", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 893, 917, "Integer", "I:p_row_start I:p_x I:p_bit_depth I:p_channels I:p_channel",
                              "Integer png_sample(Integer p_row_start, Integer p_x, Integer p_bit_depth, Integer p_channels, Integer p_channel)", 0, "", "floor_divide");
  if (p_id == 82) test_info_set(p_info, "png_decode", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 919, 1132, "Integer", "I:p_map_x I:p_map_y",
                              "Integer png_decode(Integer p_map_x, Integer p_map_y)", 0, "", "floor_divide, max_integer, pack_inflate, pack_paeth, png_is_chunk, png_number, png_sample");
  if (p_id == 83) test_info_set(p_info, "pack_tint", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1136, 1148, "void", "I:p_red I:p_green I:p_blue",
                              "void pack_tint(Integer p_red, Integer p_green, Integer p_blue)", 0, "", "floor_divide");
  if (p_id == 84) test_info_set(p_info, "pack_keep_overlay", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1150, 1163, "void", "",
                              "void pack_keep_overlay()", 0, "", "");
  if (p_id == 85) test_info_set(p_info, "pack_draw_overlay", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1165, 1180, "void", "",
                              "void pack_draw_overlay()", 0, "", "");
  if (p_id == 86) test_info_set(p_info, "pack_distance", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1182, 1192, "Real", "I:p_colour I:p_cluster",
                              "Real pack_distance(Integer p_colour, Integer p_cluster)", 0, "", "");
  if (p_id == 87) test_info_set(p_info, "pack_count_colours", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1194, 1233, "Integer", "",
                              "Integer pack_count_colours()", 0, "", "");
  if (p_id == 88) test_info_set(p_info, "pack_choose_palette", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1235, 1325, "Integer", "I:p_colours",
                              "Integer pack_choose_palette(Integer p_colours)", 0, "", "pack_distance");
  if (p_id == 89) test_info_set(p_info, "pack_to_texture", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1327, 1363, "void", "I:p_tex I:p_sprite",
                              "void pack_to_texture(Integer p_tex, Integer p_sprite)", 0, "", "floor_divide, pack_choose_palette, pack_count_colours, texture_set, texture_set_palette, to_byte");
  if (p_id == 90) test_info_set(p_info, "pack_load_image", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1367, 1378, "Integer", "T:p_path I:p_zip &A:p_index T:p_kind T:p_name I:p_map_x I:p_map_y",
                              "Integer pack_load_image(Text p_path, Integer p_zip, Attributes &p_index, Text p_kind, Text p_name, Integer p_map_x, Integer p_map_y)", 0, "", "pack_key, pack_load_png_from_folder, pack_load_png_from_zip, png_decode");
  if (p_id == 91) test_info_set(p_info, "pack_apply", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1380, 1509, "Integer", "T:p_path &T:p_report",
                              "Integer pack_apply(Text p_path, Text &p_report)", 0, "", "pack_draw_overlay, pack_init_tables, pack_is_zip, pack_keep_overlay, pack_key, pack_load_image, pack_map_entry, pack_map_part, pack_tint, pack_to_texture, pack_zip_index, record_clear, record_set_integer, texture_is_sprite");
  if (p_id == 92) test_info_set(p_info, "pack_map_skin_part", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1513, 1539, "Integer", "I:p_entry &I:p_tex &I:p_x &I:p_y &I:p_w &I:p_h &I:p_over_x &I:p_over_y",
                              "Integer pack_map_skin_part(Integer p_entry, Integer &p_tex, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h, Integer &p_over_x, Integer &p_over_y)", 0, "", "");
  if (p_id == 93) test_info_set(p_info, "pack_load_png_file", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1541, 1555, "Integer", "T:p_path",
                              "Integer pack_load_png_file(Text p_path)", 0, "", "pack_read_bytes, png_is_chunk");
  if (p_id == 94) test_info_set(p_info, "pack_skin_region", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1557, 1573, "Integer", "I:p_x I:p_y I:p_w I:p_h",
                              "Integer pack_skin_region(Integer p_x, Integer p_y, Integer p_w, Integer p_h)", 0, "", "png_decode");
  if (p_id == 95) test_info_set(p_info, "pack_apply_skin", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1575, 1626, "Integer", "T:p_path &T:p_report",
                              "Integer pack_apply_skin(Text p_path, Text &p_report)", 0, "", "pack_draw_overlay, pack_init_tables, pack_keep_overlay, pack_load_png_file, pack_map_skin_part, pack_skin_region, pack_to_texture, png_number");
  if (p_id == 96) test_info_set(p_info, "texture_palette_index", "macro", "blocks", "textures", "src/blocks/textures.4dm", 11, 18, "Integer", "I:p_tex I:p_index",
                              "Integer texture_palette_index(Integer p_tex, Integer p_index)", 0, "", "");
  if (p_id == 97) test_info_set(p_info, "texture_set_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 20, 30, "void", "I:p_tex I:p_index I:p_red I:p_green I:p_blue",
                              "void texture_set_palette(Integer p_tex, Integer p_index, Integer p_red, Integer p_green, Integer p_blue)", 0, "", "texture_palette_index");
  if (p_id == 98) test_info_set(p_info, "texture_set", "macro", "blocks", "textures", "src/blocks/textures.4dm", 32, 41, "void", "I:p_tex I:p_u I:p_v I:p_index",
                              "void texture_set(Integer p_tex, Integer p_u, Integer p_v, Integer p_index)", 0, "", "");
  if (p_id == 99) test_info_set(p_info, "texture_get", "macro", "blocks", "textures", "src/blocks/textures.4dm", 43, 51, "Integer", "I:p_tex I:p_u I:p_v",
                              "Integer texture_get(Integer p_tex, Integer p_u, Integer p_v)", 0, "", "");
  if (p_id == 100) test_info_set(p_info, "texture_fill", "macro", "blocks", "textures", "src/blocks/textures.4dm", 53, 59, "void", "I:p_tex I:p_index",
                              "void texture_fill(Integer p_tex, Integer p_index)", 0, "", "texture_fill_rect");
  if (p_id == 101) test_info_set(p_info, "texture_fill_rect", "macro", "blocks", "textures", "src/blocks/textures.4dm", 61, 74, "void", "I:p_tex I:p_u0 I:p_v0 I:p_u1 I:p_v1 I:p_index",
                              "void texture_fill_rect(Integer p_tex, Integer p_u0, Integer p_v0, Integer p_u1, Integer p_v1, Integer p_index)", 0, "", "texture_set");
  if (p_id == 102) test_info_set(p_info, "texture_copy", "macro", "blocks", "textures", "src/blocks/textures.4dm", 76, 92, "void", "I:p_from_tex I:p_to_tex",
                              "void texture_copy(Integer p_from_tex, Integer p_to_tex)", 0, "", "texture_palette_index");
  if (p_id == 103) test_info_set(p_info, "texture_row", "macro", "blocks", "textures", "src/blocks/textures.4dm", 94, 108, "void", "I:p_tex I:p_v T:p_pixels",
                              "void texture_row(Integer p_tex, Integer p_v, Text p_pixels)", 0, "", "texture_set");
  if (p_id == 104) test_info_set(p_info, "texture_random", "macro", "blocks", "textures", "src/blocks/textures.4dm", 110, 116, "Real", "I:p_tex I:p_u I:p_v I:p_salt",
                              "Real texture_random(Integer p_tex, Integer p_u, Integer p_v, Integer p_salt)", 0, "", "hash_real");
  if (p_id == 105) test_info_set(p_info, "texture_noise", "macro", "blocks", "textures", "src/blocks/textures.4dm", 118, 146, "Real", "I:p_tex I:p_u I:p_v I:p_cell I:p_salt",
                              "Real texture_noise(Integer p_tex, Integer p_u, Integer p_v, Integer p_cell, Integer p_salt)", 0, "", "floor_divide, hash_real, lerp_real, positive_mod, smooth_curve");
  if (p_id == 106) test_info_set(p_info, "texture_finish", "macro", "blocks", "textures", "src/blocks/textures.4dm", 150, 297, "void", "I:p_tex",
                              "void texture_finish(Integer p_tex)", 0, "", "texture_get, texture_palette_index");
  if (p_id == 107) test_info_set(p_info, "texture_speckle", "macro", "blocks", "textures", "src/blocks/textures.4dm", 301, 314, "void", "I:p_tex I:p_index R:p_chance I:p_salt",
                              "void texture_speckle(Integer p_tex, Integer p_index, Real p_chance, Integer p_salt)", 0, "", "texture_random, texture_set");
  if (p_id == 108) test_info_set(p_info, "texture_blotch", "macro", "blocks", "textures", "src/blocks/textures.4dm", 316, 331, "void", "I:p_tex I:p_index I:p_cell R:p_below R:p_above I:p_salt",
                              "void texture_blotch(Integer p_tex, Integer p_index, Integer p_cell, Real p_below, Real p_above, Integer p_salt)", 0, "", "texture_noise, texture_set");
  if (p_id == 109) test_info_set(p_info, "make_texture_stone", "macro", "blocks", "textures", "src/blocks/textures.4dm", 333, 344, "void", "I:p_tex",
                              "void make_texture_stone(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette");
  if (p_id == 110) test_info_set(p_info, "make_texture_bedrock", "macro", "blocks", "textures", "src/blocks/textures.4dm", 346, 357, "void", "I:p_tex",
                              "void make_texture_bedrock(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette");
  if (p_id == 111) test_info_set(p_info, "make_texture_cobblestone", "macro", "blocks", "textures", "src/blocks/textures.4dm", 359, 412, "void", "I:p_tex",
                              "void make_texture_cobblestone(Integer p_tex)", 0, "", "positive_mod, texture_random, texture_set, texture_set_palette");
  if (p_id == 112) test_info_set(p_info, "make_texture_dirt", "macro", "blocks", "textures", "src/blocks/textures.4dm", 414, 426, "void", "I:p_tex",
                              "void make_texture_dirt(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 113) test_info_set(p_info, "make_texture_grass_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 428, 440, "void", "I:p_tex",
                              "void make_texture_grass_top(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 114) test_info_set(p_info, "make_texture_grass_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 442, 459, "void", "I:p_tex",
                              "void make_texture_grass_side(Integer p_tex)", 0, "", "texture_copy, texture_fill_rect, texture_random, texture_set, texture_set_palette");
  if (p_id == 115) test_info_set(p_info, "make_texture_log_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 461, 485, "void", "I:p_tex",
                              "void make_texture_log_side(Integer p_tex)", 0, "", "texture_fill, texture_random, texture_set, texture_set_palette");
  if (p_id == 116) test_info_set(p_info, "make_texture_log_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 487, 514, "void", "I:p_tex",
                              "void make_texture_log_top(Integer p_tex)", 0, "", "positive_mod, texture_set, texture_set_palette");
  if (p_id == 117) test_info_set(p_info, "make_texture_leaves", "macro", "blocks", "textures", "src/blocks/textures.4dm", 516, 529, "void", "I:p_tex",
                              "void make_texture_leaves(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 118) test_info_set(p_info, "make_texture_water", "macro", "blocks", "textures", "src/blocks/textures.4dm", 531, 550, "void", "I:p_tex",
                              "void make_texture_water(Integer p_tex)", 0, "", "positive_mod, texture_fill, texture_set, texture_set_palette");
  if (p_id == 119) test_info_set(p_info, "make_texture_planks", "macro", "blocks", "textures", "src/blocks/textures.4dm", 552, 577, "void", "I:p_tex",
                              "void make_texture_planks(Integer p_tex)", 0, "", "positive_mod, texture_fill, texture_fill_rect, texture_random, texture_set, texture_set_palette");
  if (p_id == 120) test_info_set(p_info, "make_texture_table_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 579, 594, "void", "I:p_tex",
                              "void make_texture_table_top(Integer p_tex)", 0, "", "texture_copy, texture_fill_rect, texture_set_palette");
}

void test_registry_call_3(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 81 to 120 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 81) {   // png_sample
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = png_sample(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 82) {   // png_decode
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = png_decode(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 83) {   // pack_tint
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    pack_tint(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 84) {   // pack_keep_overlay
    Get_time(l_start);
    pack_keep_overlay();
    Get_time(l_end);
  } else if (p_id == 85) {   // pack_draw_overlay
    Get_time(l_start);
    pack_draw_overlay();
    Get_time(l_end);
  } else if (p_id == 86) {   // pack_distance
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_r = pack_distance(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 87) {   // pack_count_colours
    Get_time(l_start);
    l_ret_i = pack_count_colours();
    Get_time(l_end);
  } else if (p_id == 88) {   // pack_choose_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = pack_choose_palette(l_i1);
    Get_time(l_end);
  } else if (p_id == 89) {   // pack_to_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    pack_to_texture(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 90) {   // pack_load_image
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = pack_load_image(l_t1, l_i1, g_test_record, l_t2, l_t3, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 91) {   // pack_apply
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = pack_apply(l_t1, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 92) {   // pack_map_skin_part
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    l_i8 = record_integer(p_in, ATTR_TEST_I8);
    Get_time(l_start);
    l_ret_i = pack_map_skin_part(l_i1, l_i2, l_i3, l_i4, l_i5, l_i6, l_i7, l_i8);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
    record_set_integer(p_out, ATTR_TEST_I7, l_i7);
    record_set_integer(p_out, ATTR_TEST_I8, l_i8);
  } else if (p_id == 93) {   // pack_load_png_file
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = pack_load_png_file(l_t1);
    Get_time(l_end);
  } else if (p_id == 94) {   // pack_skin_region
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = pack_skin_region(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 95) {   // pack_apply_skin
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = pack_apply_skin(l_t1, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 96) {   // texture_palette_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = texture_palette_index(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 97) {   // texture_set_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    texture_set_palette(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 98) {   // texture_set
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    texture_set(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 99) {   // texture_get
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = texture_get(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 100) {   // texture_fill
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    texture_fill(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 101) {   // texture_fill_rect
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    Get_time(l_start);
    texture_fill_rect(l_i1, l_i2, l_i3, l_i4, l_i5, l_i6);
    Get_time(l_end);
  } else if (p_id == 102) {   // texture_copy
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    texture_copy(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 103) {   // texture_row
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    texture_row(l_i1, l_i2, l_t1);
    Get_time(l_end);
  } else if (p_id == 104) {   // texture_random
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_r = texture_random(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 105) {   // texture_noise
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_r = texture_noise(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 106) {   // texture_finish
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    texture_finish(l_i1);
    Get_time(l_end);
  } else if (p_id == 107) {   // texture_speckle
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    texture_speckle(l_i1, l_i2, l_r1, l_i3);
    Get_time(l_end);
  } else if (p_id == 108) {   // texture_blotch
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    texture_blotch(l_i1, l_i2, l_i3, l_r1, l_r2, l_i4);
    Get_time(l_end);
  } else if (p_id == 109) {   // make_texture_stone
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_stone(l_i1);
    Get_time(l_end);
  } else if (p_id == 110) {   // make_texture_bedrock
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_bedrock(l_i1);
    Get_time(l_end);
  } else if (p_id == 111) {   // make_texture_cobblestone
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cobblestone(l_i1);
    Get_time(l_end);
  } else if (p_id == 112) {   // make_texture_dirt
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_dirt(l_i1);
    Get_time(l_end);
  } else if (p_id == 113) {   // make_texture_grass_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_grass_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 114) {   // make_texture_grass_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_grass_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 115) {   // make_texture_log_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_log_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 116) {   // make_texture_log_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_log_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 117) {   // make_texture_leaves
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_leaves(l_i1);
    Get_time(l_end);
  } else if (p_id == 118) {   // make_texture_water
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_water(l_i1);
    Get_time(l_end);
  } else if (p_id == 119) {   // make_texture_planks
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_planks(l_i1);
    Get_time(l_end);
  } else if (p_id == 120) {   // make_texture_table_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_table_top(l_i1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_4(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 121 to 160 are
// ----------------------------------------------------------------
{
  if (p_id == 121) test_info_set(p_info, "make_texture_table_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 596, 614, "void", "I:p_tex",
                              "void make_texture_table_side(Integer p_tex)", 0, "", "texture_copy, texture_fill_rect, texture_set_palette");
  if (p_id == 122) test_info_set(p_info, "make_texture_furnace_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 616, 638, "void", "I:p_tex",
                              "void make_texture_furnace_side(Integer p_tex)", 0, "", "positive_mod, texture_fill, texture_fill_rect, texture_set_palette, texture_speckle");
  if (p_id == 123) test_info_set(p_info, "make_texture_furnace_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 640, 655, "void", "I:p_tex",
                              "void make_texture_furnace_top(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette, texture_speckle");
  if (p_id == 124) test_info_set(p_info, "make_texture_furnace_front", "macro", "blocks", "textures", "src/blocks/textures.4dm", 657, 687, "void", "I:p_tex I:p_lit",
                              "void make_texture_furnace_front(Integer p_tex, Integer p_lit)", 0, "", "texture_copy, texture_fill_rect, texture_random, texture_set, texture_set_palette");
  if (p_id == 125) test_info_set(p_info, "make_texture_sand", "macro", "blocks", "textures", "src/blocks/textures.4dm", 689, 700, "void", "I:p_tex",
                              "void make_texture_sand(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 126) test_info_set(p_info, "make_texture_cow_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 702, 715, "void", "I:p_tex",
                              "void make_texture_cow_palette(Integer p_tex)", 0, "", "texture_set_palette");
  if (p_id == 127) test_info_set(p_info, "make_texture_cow_hide", "macro", "blocks", "textures", "src/blocks/textures.4dm", 717, 726, "void", "I:p_tex",
                              "void make_texture_cow_hide(Integer p_tex)", 0, "", "make_texture_cow_palette, texture_blotch, texture_fill");
  if (p_id == 128) test_info_set(p_info, "make_texture_cow_face", "macro", "blocks", "textures", "src/blocks/textures.4dm", 728, 751, "void", "I:p_tex",
                              "void make_texture_cow_face(Integer p_tex)", 0, "", "make_texture_cow_palette, texture_row");
  if (p_id == 129) test_info_set(p_info, "make_texture_cow", "macro", "blocks", "textures", "src/blocks/textures.4dm", 753, 782, "void", "I:p_tex I:p_part",
                              "void make_texture_cow(Integer p_tex, Integer p_part)", 0, "", "make_texture_cow_palette, texture_blotch, texture_fill, texture_fill_rect");
  if (p_id == 130) test_info_set(p_info, "make_texture_sandstone_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 784, 797, "void", "I:p_tex",
                              "void make_texture_sandstone_side(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 131) test_info_set(p_info, "make_texture_sandstone_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 799, 808, "void", "I:p_tex",
                              "void make_texture_sandstone_top(Integer p_tex)", 0, "", "texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 132) test_info_set(p_info, "make_texture_cactus_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 810, 823, "void", "I:p_tex",
                              "void make_texture_cactus_side(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette, texture_speckle");
  if (p_id == 133) test_info_set(p_info, "make_texture_cactus_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 825, 836, "void", "I:p_tex",
                              "void make_texture_cactus_top(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 134) test_info_set(p_info, "make_texture_coal_ore", "macro", "blocks", "textures", "src/blocks/textures.4dm", 838, 852, "void", "I:p_tex",
                              "void make_texture_coal_ore(Integer p_tex)", 0, "", "make_texture_stone, texture_fill_rect, texture_set_palette");
  if (p_id == 135) test_info_set(p_info, "make_texture_gravel", "macro", "blocks", "textures", "src/blocks/textures.4dm", 854, 867, "void", "I:p_tex",
                              "void make_texture_gravel(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 136) test_info_set(p_info, "make_texture_plant_grass", "macro", "blocks", "textures", "src/blocks/textures.4dm", 869, 892, "void", "I:p_tex",
                              "void make_texture_plant_grass(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 137) test_info_set(p_info, "make_texture_plant_flower", "macro", "blocks", "textures", "src/blocks/textures.4dm", 894, 927, "void", "I:p_tex I:p_red I:p_green I:p_blue",
                              "void make_texture_plant_flower(Integer p_tex, Integer p_red, Integer p_green, Integer p_blue)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 138) test_info_set(p_info, "make_texture_plant_dead_bush", "macro", "blocks", "textures", "src/blocks/textures.4dm", 929, 951, "void", "I:p_tex",
                              "void make_texture_plant_dead_bush(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 139) test_info_set(p_info, "make_texture_item_stick", "macro", "blocks", "textures", "src/blocks/textures.4dm", 953, 977, "void", "I:p_tex",
                              "void make_texture_item_stick(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 140) test_info_set(p_info, "make_texture_pig", "macro", "blocks", "textures", "src/blocks/textures.4dm", 979, 1025, "void", "I:p_tex I:p_part",
                              "void make_texture_pig(Integer p_tex, Integer p_part)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 141) test_info_set(p_info, "make_texture_item_porkchop", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1027, 1059, "void", "I:p_tex I:p_cooked",
                              "void make_texture_item_porkchop(Integer p_tex, Integer p_cooked)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 142) test_info_set(p_info, "make_texture_item_beef", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1061, 1092, "void", "I:p_tex I:p_cooked",
                              "void make_texture_item_beef(Integer p_tex, Integer p_cooked)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 143) test_info_set(p_info, "make_texture_iron_ore", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1094, 1110, "void", "I:p_tex",
                              "void make_texture_iron_ore(Integer p_tex)", 0, "", "make_texture_stone, texture_fill_rect, texture_set_palette");
  if (p_id == 144) test_info_set(p_info, "make_texture_item_ingot", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1112, 1137, "void", "I:p_tex",
                              "void make_texture_item_ingot(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 145) test_info_set(p_info, "make_texture_bed_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1139, 1158, "void", "I:p_tex",
                              "void make_texture_bed_top(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 146) test_info_set(p_info, "make_texture_bed_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1160, 1178, "void", "I:p_tex",
                              "void make_texture_bed_side(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 147) test_info_set(p_info, "make_texture_zombie", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1180, 1234, "void", "I:p_tex I:p_part",
                              "void make_texture_zombie(Integer p_tex, Integer p_part)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 148) test_info_set(p_info, "make_texture_chest", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1236, 1259, "void", "I:p_tex I:p_side",
                              "void make_texture_chest(Integer p_tex, Integer p_side)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 149) test_info_set(p_info, "make_texture_torch", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1261, 1287, "void", "I:p_tex",
                              "void make_texture_torch(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 150) test_info_set(p_info, "make_texture_glass", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1289, 1313, "void", "I:p_tex",
                              "void make_texture_glass(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 151) test_info_set(p_info, "make_texture_item_rotten_flesh", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1315, 1340, "void", "I:p_tex",
                              "void make_texture_item_rotten_flesh(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 152) test_info_set(p_info, "make_texture_item_coal", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1342, 1367, "void", "I:p_tex",
                              "void make_texture_item_coal(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 153) test_info_set(p_info, "make_tool_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1369, 1388, "void", "I:p_tex I:p_tier",
                              "void make_tool_palette(Integer p_tex, Integer p_tier)", 0, "", "texture_set_palette");
  if (p_id == 154) test_info_set(p_info, "make_texture_item_pickaxe", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1390, 1412, "void", "I:p_tex I:p_tier",
                              "void make_texture_item_pickaxe(Integer p_tex, Integer p_tier)", 0, "", "make_tool_palette, texture_row");
  if (p_id == 155) test_info_set(p_info, "make_texture_item_axe", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1414, 1436, "void", "I:p_tex I:p_tier",
                              "void make_texture_item_axe(Integer p_tex, Integer p_tier)", 0, "", "make_tool_palette, texture_row");
  if (p_id == 156) test_info_set(p_info, "make_texture_item_shovel", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1438, 1460, "void", "I:p_tex I:p_tier",
                              "void make_texture_item_shovel(Integer p_tex, Integer p_tier)", 0, "", "make_tool_palette, texture_row");
  if (p_id == 157) test_info_set(p_info, "make_texture_item_sword", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1462, 1484, "void", "I:p_tex I:p_tier",
                              "void make_texture_item_sword(Integer p_tex, Integer p_tier)", 0, "", "make_tool_palette, texture_row");
  if (p_id == 158) test_info_set(p_info, "make_texture_destroy", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1486, 1541, "void", "I:p_tex I:p_stage",
                              "void make_texture_destroy(Integer p_tex, Integer p_stage)", 0, "", "floor_divide, floor_integer, hash_real, texture_fill, texture_get, texture_set, texture_set_palette");
  if (p_id == 159) test_info_set(p_info, "make_texture_heart", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1543, 1594, "void", "I:p_tex I:p_fill",
                              "void make_texture_heart(Integer p_tex, Integer p_fill)", 0, "", "texture_fill_rect, texture_row, texture_set, texture_set_palette");
  if (p_id == 160) test_info_set(p_info, "make_texture_door", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1596, 1623, "void", "I:p_tex I:p_top",
                              "void make_texture_door(Integer p_tex, Integer p_top)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
}

void test_registry_call_4(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 121 to 160 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 121) {   // make_texture_table_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_table_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 122) {   // make_texture_furnace_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_furnace_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 123) {   // make_texture_furnace_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_furnace_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 124) {   // make_texture_furnace_front
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_furnace_front(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 125) {   // make_texture_sand
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_sand(l_i1);
    Get_time(l_end);
  } else if (p_id == 126) {   // make_texture_cow_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cow_palette(l_i1);
    Get_time(l_end);
  } else if (p_id == 127) {   // make_texture_cow_hide
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cow_hide(l_i1);
    Get_time(l_end);
  } else if (p_id == 128) {   // make_texture_cow_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cow_face(l_i1);
    Get_time(l_end);
  } else if (p_id == 129) {   // make_texture_cow
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_cow(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 130) {   // make_texture_sandstone_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_sandstone_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 131) {   // make_texture_sandstone_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_sandstone_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 132) {   // make_texture_cactus_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cactus_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 133) {   // make_texture_cactus_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cactus_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 134) {   // make_texture_coal_ore
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_coal_ore(l_i1);
    Get_time(l_end);
  } else if (p_id == 135) {   // make_texture_gravel
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_gravel(l_i1);
    Get_time(l_end);
  } else if (p_id == 136) {   // make_texture_plant_grass
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_plant_grass(l_i1);
    Get_time(l_end);
  } else if (p_id == 137) {   // make_texture_plant_flower
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    make_texture_plant_flower(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 138) {   // make_texture_plant_dead_bush
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_plant_dead_bush(l_i1);
    Get_time(l_end);
  } else if (p_id == 139) {   // make_texture_item_stick
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_stick(l_i1);
    Get_time(l_end);
  } else if (p_id == 140) {   // make_texture_pig
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_pig(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 141) {   // make_texture_item_porkchop
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_porkchop(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 142) {   // make_texture_item_beef
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_beef(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 143) {   // make_texture_iron_ore
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_iron_ore(l_i1);
    Get_time(l_end);
  } else if (p_id == 144) {   // make_texture_item_ingot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_ingot(l_i1);
    Get_time(l_end);
  } else if (p_id == 145) {   // make_texture_bed_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_bed_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 146) {   // make_texture_bed_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_bed_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 147) {   // make_texture_zombie
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_zombie(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 148) {   // make_texture_chest
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_chest(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 149) {   // make_texture_torch
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_torch(l_i1);
    Get_time(l_end);
  } else if (p_id == 150) {   // make_texture_glass
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_glass(l_i1);
    Get_time(l_end);
  } else if (p_id == 151) {   // make_texture_item_rotten_flesh
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_rotten_flesh(l_i1);
    Get_time(l_end);
  } else if (p_id == 152) {   // make_texture_item_coal
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_coal(l_i1);
    Get_time(l_end);
  } else if (p_id == 153) {   // make_tool_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_tool_palette(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 154) {   // make_texture_item_pickaxe
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_pickaxe(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 155) {   // make_texture_item_axe
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_axe(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 156) {   // make_texture_item_shovel
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_shovel(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 157) {   // make_texture_item_sword
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_sword(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 158) {   // make_texture_destroy
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_destroy(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 159) {   // make_texture_heart
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_heart(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 160) {   // make_texture_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_door(l_i1, l_i2);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_5(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 161 to 200 are
// ----------------------------------------------------------------
{
  if (p_id == 161) test_info_set(p_info, "make_texture_item_door", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1625, 1649, "void", "I:p_tex",
                              "void make_texture_item_door(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 162) test_info_set(p_info, "make_texture_bed_foot_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1651, 1666, "void", "I:p_tex",
                              "void make_texture_bed_foot_top(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 163) test_info_set(p_info, "make_texture_person", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1668, 1723, "void", "I:p_tex I:p_part",
                              "void make_texture_person(Integer p_tex, Integer p_part)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 164) test_info_set(p_info, "make_texture_door_edge", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1725, 1748, "void", "I:p_tex I:p_door_tex",
                              "void make_texture_door_edge(Integer p_tex, Integer p_door_tex)", 0, "", "texture_get, texture_palette_index, texture_set");
  if (p_id == 165) test_info_set(p_info, "make_armour_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1750, 1759, "void", "I:p_tex",
                              "void make_armour_palette(Integer p_tex)", 0, "", "texture_set_palette");
  if (p_id == 166) test_info_set(p_info, "make_texture_item_armour", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1761, 1841, "void", "I:p_tex I:p_place",
                              "void make_texture_item_armour(Integer p_tex, Integer p_place)", 0, "", "make_armour_palette, texture_row");
  if (p_id == 167) test_info_set(p_info, "make_texture_spawn_egg", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1843, 1869, "void", "I:p_tex I:p_red I:p_green I:p_blue I:p_spot_red I:p_spot_green I:p_spot_blue",
                              "void make_texture_spawn_egg(Integer p_tex, Integer p_red, Integer p_green, Integer p_blue, Integer p_spot_red, Integer p_spot_green, Integer p_spot_blue)", 0, "", "floor_integer, min_integer, texture_row, texture_set_palette");
  if (p_id == 168) test_info_set(p_info, "make_texture_armour_icon", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1871, 1912, "void", "I:p_tex I:p_fill",
                              "void make_texture_armour_icon(Integer p_tex, Integer p_fill)", 0, "", "texture_fill_rect, texture_row, texture_set, texture_set_palette");
  if (p_id == 169) test_info_set(p_info, "make_texture_armour_worn", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1914, 1929, "void", "I:p_tex I:p_helmet_front",
                              "void make_texture_armour_worn(Integer p_tex, Integer p_helmet_front)", 0, "", "make_armour_palette, texture_blotch, texture_fill, texture_fill_rect, texture_speckle");
  if (p_id == 170) test_info_set(p_info, "texture_is_sprite", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1931, 1939, "Integer", "I:p_tex",
                              "Integer texture_is_sprite(Integer p_tex)", 0, "", "");
  if (p_id == 171) test_info_set(p_info, "textures_init", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1941, 1948, "void", "",
                              "void textures_init()", 0, "", "textures_finish_all, textures_generate");
  if (p_id == 172) test_info_set(p_info, "textures_finish_all", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1950, 1964, "void", "",
                              "void textures_finish_all()", 0, "", "make_texture_door_edge, texture_finish");
  if (p_id == 173) test_info_set(p_info, "textures_generate", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1966, 2084, "void", "",
                              "void textures_generate()", 0, "", "make_texture_armour_icon, make_texture_armour_worn, make_texture_bed_foot_top, make_texture_bed_side, make_texture_bed_top, make_texture_bedrock, make_texture_cactus_side, make_texture_cactus_top, make_texture_chest, make_texture_coal_ore, make_texture_cobblestone, make_texture_cow, make_texture_cow_face, make_texture_cow_hide, make_texture_destroy, make_texture_dirt, make_texture_door, make_texture_furnace_front, make_texture_furnace_side, make_texture_furnace_top, make_texture_glass, make_texture_grass_side, make_texture_grass_top, make_texture_gravel, make_texture_heart, make_texture_iron_ore, make_texture_item_armour, make_texture_item_axe, make_texture_item_beef, make_texture_item_coal, make_texture_item_door, make_texture_item_ingot, make_texture_item_pickaxe, make_texture_item_porkchop, make_texture_item_rotten_flesh, make_texture_item_shovel, make_texture_item_stick, make_texture_item_sword, make_texture_leaves, make_texture_log_side, make_texture_log_top, make_texture_person, make_texture_pig, make_texture_planks, make_texture_plant_dead_bush, make_texture_plant_flower, make_texture_plant_grass, make_texture_sand, make_texture_sandstone_side, make_texture_sandstone_top, make_texture_spawn_egg, make_texture_stone, make_texture_table_side, make_texture_table_top, make_texture_torch, make_texture_water, make_texture_zombie");
  if (p_id == 174) test_info_set(p_info, "events_clear", "macro", "core", "events", "src/core/events.4dm", 8, 17, "void", "&A:p_events",
                              "void events_clear(Attributes &p_events)", 0, "", "record_clear, record_set_integer");
  if (p_id == 175) test_info_set(p_info, "emit_event", "macro", "core", "events", "src/core/events.4dm", 19, 51, "void", "&A:p_events I:p_type I:p_i1 I:p_i2 I:p_i3 I:p_i4 R:p_r1 R:p_r2 R:p_r3 T:p_text",
                              "void emit_event(Attributes &p_events, Integer p_type, Integer p_i1, Integer p_i2, Integer p_i3, Integer p_i4, Real p_r1, Real p_r2, Real p_r3, Text p_text)", 0, "", "record_integer, record_set_integer, record_set_integer_at, record_set_real_at, record_set_text_at");
  if (p_id == 176) test_info_set(p_info, "emit_simple_event", "macro", "core", "events", "src/core/events.4dm", 53, 59, "void", "&A:p_events I:p_type",
                              "void emit_simple_event(Attributes &p_events, Integer p_type)", 0, "", "emit_event");
  if (p_id == 177) test_info_set(p_info, "emit_cell_event", "macro", "core", "events", "src/core/events.4dm", 61, 67, "void", "&A:p_events I:p_type I:p_x I:p_y I:p_z I:p_block",
                              "void emit_cell_event(Attributes &p_events, Integer p_type, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "emit_event");
  if (p_id == 178) test_info_set(p_info, "emit_item_event", "macro", "core", "events", "src/core/events.4dm", 69, 75, "void", "&A:p_events I:p_type I:p_item I:p_count",
                              "void emit_item_event(Attributes &p_events, Integer p_type, Integer p_item, Integer p_count)", 0, "", "emit_event");
  if (p_id == 179) test_info_set(p_info, "emit_drop_event", "macro", "core", "events", "src/core/events.4dm", 77, 84, "void", "&A:p_events I:p_item I:p_count I:p_damage R:p_x R:p_y R:p_z",
                              "void emit_drop_event(Attributes &p_events, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z)", 0, "", "emit_event");
  if (p_id == 180) test_info_set(p_info, "emit_toast", "macro", "core", "events", "src/core/events.4dm", 86, 92, "void", "&A:p_events T:p_text",
                              "void emit_toast(Attributes &p_events, Text p_text)", 0, "", "emit_event");
  if (p_id == 181) test_info_set(p_info, "events_pending", "macro", "core", "events", "src/core/events.4dm", 94, 100, "Integer", "&A:p_events",
                              "Integer events_pending(Attributes &p_events)", 0, "", "record_integer");
  if (p_id == 182) test_info_set(p_info, "next_event", "macro", "core", "events", "src/core/events.4dm", 102, 133, "Integer", "&A:p_events &A:p_event",
                              "Integer next_event(Attributes &p_events, Attributes &p_event)", 0, "", "record_clear, record_integer, record_integer_at, record_real_at, record_set_integer, record_set_real, record_set_text, record_text_at");
  if (p_id == 183) test_info_set(p_info, "event_type", "macro", "core", "events", "src/core/events.4dm", 135, 141, "Integer", "&A:p_event",
                              "Integer event_type(Attributes &p_event)", 0, "", "record_integer");
  if (p_id == 184) test_info_set(p_info, "event_integer", "macro", "core", "events", "src/core/events.4dm", 143, 152, "Integer", "&A:p_event I:p_which",
                              "Integer event_integer(Attributes &p_event, Integer p_which)", 0, "", "record_integer");
  if (p_id == 185) test_info_set(p_info, "event_real", "macro", "core", "events", "src/core/events.4dm", 154, 162, "Real", "&A:p_event I:p_which",
                              "Real event_real(Attributes &p_event, Integer p_which)", 0, "", "record_real");
  if (p_id == 186) test_info_set(p_info, "event_text", "macro", "core", "events", "src/core/events.4dm", 164, 170, "Text", "&A:p_event",
                              "Text event_text(Attributes &p_event)", 0, "", "record_text");
  if (p_id == 187) test_info_set(p_info, "event_is_remote", "macro", "core", "events", "src/core/events.4dm", 172, 180, "Integer", "&A:p_event",
                              "Integer event_is_remote(Attributes &p_event)", 0, "", "event_real");
  if (p_id == 188) test_info_set(p_info, "record_integer", "macro", "core", "records", "src/core/records.4dm", 9, 19, "Integer", "&A:p_record T:p_field",
                              "Integer record_integer(Attributes &p_record, Text p_field)", 0, "", "");
  if (p_id == 189) test_info_set(p_info, "record_real", "macro", "core", "records", "src/core/records.4dm", 21, 31, "Real", "&A:p_record T:p_field",
                              "Real record_real(Attributes &p_record, Text p_field)", 0, "", "");
  if (p_id == 190) test_info_set(p_info, "record_text", "macro", "core", "records", "src/core/records.4dm", 33, 43, "Text", "&A:p_record T:p_field",
                              "Text record_text(Attributes &p_record, Text p_field)", 0, "", "");
  if (p_id == 191) test_info_set(p_info, "record_set_integer", "macro", "core", "records", "src/core/records.4dm", 45, 53, "void", "&A:p_record T:p_field I:p_value",
                              "void record_set_integer(Attributes &p_record, Text p_field, Integer p_value)", 0, "", "");
  if (p_id == 192) test_info_set(p_info, "record_set_real", "macro", "core", "records", "src/core/records.4dm", 55, 61, "void", "&A:p_record T:p_field R:p_value",
                              "void record_set_real(Attributes &p_record, Text p_field, Real p_value)", 0, "", "");
  if (p_id == 193) test_info_set(p_info, "record_set_text", "macro", "core", "records", "src/core/records.4dm", 63, 69, "void", "&A:p_record T:p_field T:p_value",
                              "void record_set_text(Attributes &p_record, Text p_field, Text p_value)", 0, "", "");
  if (p_id == 194) test_info_set(p_info, "record_clear", "macro", "core", "records", "src/core/records.4dm", 71, 79, "void", "&A:p_record T:p_datatype",
                              "void record_clear(Attributes &p_record, Text p_datatype)", 0, "", "");
  if (p_id == 195) test_info_set(p_info, "record_datatype", "macro", "core", "records", "src/core/records.4dm", 81, 87, "Text", "&A:p_record",
                              "Text record_datatype(Attributes &p_record)", 0, "", "record_text");
  if (p_id == 196) test_info_set(p_info, "record_field_at", "macro", "core", "records", "src/core/records.4dm", 91, 97, "Text", "T:p_field I:p_index",
                              "Text record_field_at(Text p_field, Integer p_index)", 0, "", "");
  if (p_id == 197) test_info_set(p_info, "record_integer_at", "macro", "core", "records", "src/core/records.4dm", 99, 105, "Integer", "&A:p_record T:p_field I:p_index",
                              "Integer record_integer_at(Attributes &p_record, Text p_field, Integer p_index)", 0, "", "record_field_at, record_integer");
  if (p_id == 198) test_info_set(p_info, "record_real_at", "macro", "core", "records", "src/core/records.4dm", 107, 113, "Real", "&A:p_record T:p_field I:p_index",
                              "Real record_real_at(Attributes &p_record, Text p_field, Integer p_index)", 0, "", "record_field_at, record_real");
  if (p_id == 199) test_info_set(p_info, "record_text_at", "macro", "core", "records", "src/core/records.4dm", 115, 121, "Text", "&A:p_record T:p_field I:p_index",
                              "Text record_text_at(Attributes &p_record, Text p_field, Integer p_index)", 0, "", "record_field_at, record_text");
  if (p_id == 200) test_info_set(p_info, "record_set_integer_at", "macro", "core", "records", "src/core/records.4dm", 123, 129, "void", "&A:p_record T:p_field I:p_index I:p_value",
                              "void record_set_integer_at(Attributes &p_record, Text p_field, Integer p_index, Integer p_value)", 0, "", "record_field_at, record_set_integer");
}

void test_registry_call_5(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 161 to 200 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 161) {   // make_texture_item_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_door(l_i1);
    Get_time(l_end);
  } else if (p_id == 162) {   // make_texture_bed_foot_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_bed_foot_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 163) {   // make_texture_person
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_person(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 164) {   // make_texture_door_edge
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_door_edge(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 165) {   // make_armour_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_armour_palette(l_i1);
    Get_time(l_end);
  } else if (p_id == 166) {   // make_texture_item_armour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_armour(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 167) {   // make_texture_spawn_egg
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    Get_time(l_start);
    make_texture_spawn_egg(l_i1, l_i2, l_i3, l_i4, l_i5, l_i6, l_i7);
    Get_time(l_end);
  } else if (p_id == 168) {   // make_texture_armour_icon
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_armour_icon(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 169) {   // make_texture_armour_worn
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_armour_worn(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 170) {   // texture_is_sprite
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = texture_is_sprite(l_i1);
    Get_time(l_end);
  } else if (p_id == 171) {   // textures_init
    Get_time(l_start);
    textures_init();
    Get_time(l_end);
  } else if (p_id == 172) {   // textures_finish_all
    Get_time(l_start);
    textures_finish_all();
    Get_time(l_end);
  } else if (p_id == 173) {   // textures_generate
    Get_time(l_start);
    textures_generate();
    Get_time(l_end);
  } else if (p_id == 174) {   // events_clear
    Get_time(l_start);
    events_clear(g_events);
    Get_time(l_end);
  } else if (p_id == 175) {   // emit_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    emit_event(g_events, l_i1, l_i2, l_i3, l_i4, l_i5, l_r1, l_r2, l_r3, l_t1);
    Get_time(l_end);
  } else if (p_id == 176) {   // emit_simple_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    emit_simple_event(g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 177) {   // emit_cell_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    emit_cell_event(g_events, l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 178) {   // emit_item_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    emit_item_event(g_events, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 179) {   // emit_drop_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    emit_drop_event(g_events, l_i1, l_i2, l_i3, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 180) {   // emit_toast
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    emit_toast(g_events, l_t1);
    Get_time(l_end);
  } else if (p_id == 181) {   // events_pending
    Get_time(l_start);
    l_ret_i = events_pending(g_events);
    Get_time(l_end);
  } else if (p_id == 182) {   // next_event
    Get_time(l_start);
    l_ret_i = next_event(g_events, g_event);
    Get_time(l_end);
  } else if (p_id == 183) {   // event_type
    Get_time(l_start);
    l_ret_i = event_type(g_event);
    Get_time(l_end);
  } else if (p_id == 184) {   // event_integer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = event_integer(g_event, l_i1);
    Get_time(l_end);
  } else if (p_id == 185) {   // event_real
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = event_real(g_event, l_i1);
    Get_time(l_end);
  } else if (p_id == 186) {   // event_text
    Get_time(l_start);
    l_ret_t = event_text(g_event);
    Get_time(l_end);
  } else if (p_id == 187) {   // event_is_remote
    Get_time(l_start);
    l_ret_i = event_is_remote(g_event);
    Get_time(l_end);
  } else if (p_id == 188) {   // record_integer
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = record_integer(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 189) {   // record_real
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_r = record_real(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 190) {   // record_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = record_text(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 191) {   // record_set_integer
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    record_set_integer(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 192) {   // record_set_real
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    record_set_real(g_test_record, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 193) {   // record_set_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    record_set_text(g_test_record, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 194) {   // record_clear
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    record_clear(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 195) {   // record_datatype
    Get_time(l_start);
    l_ret_t = record_datatype(g_test_record);
    Get_time(l_end);
  } else if (p_id == 196) {   // record_field_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = record_field_at(l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 197) {   // record_integer_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = record_integer_at(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 198) {   // record_real_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = record_real_at(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 199) {   // record_text_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = record_text_at(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 200) {   // record_set_integer_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    record_set_integer_at(g_test_record, l_t1, l_i1, l_i2);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_6(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 201 to 240 are
// ----------------------------------------------------------------
{
  if (p_id == 201) test_info_set(p_info, "record_set_real_at", "macro", "core", "records", "src/core/records.4dm", 131, 137, "void", "&A:p_record T:p_field I:p_index R:p_value",
                              "void record_set_real_at(Attributes &p_record, Text p_field, Integer p_index, Real p_value)", 0, "", "record_field_at, record_set_real");
  if (p_id == 202) test_info_set(p_info, "record_set_text_at", "macro", "core", "records", "src/core/records.4dm", 139, 145, "void", "&A:p_record T:p_field I:p_index T:p_value",
                              "void record_set_text_at(Attributes &p_record, Text p_field, Integer p_index, Text p_value)", 0, "", "record_field_at, record_set_text");
  if (p_id == 203) test_info_set(p_info, "random_seed", "macro", "core", "records", "src/core/records.4dm", 149, 160, "void", "&A:p_random I:p_seed",
                              "void random_seed(Attributes &p_random, Integer p_seed)", 0, "", "record_clear, record_set_real");
  if (p_id == 204) test_info_set(p_info, "random_next", "macro", "core", "records", "src/core/records.4dm", 162, 176, "Real", "&A:p_random",
                              "Real random_next(Attributes &p_random)", 0, "", "record_real, record_set_real");
  if (p_id == 205) test_info_set(p_info, "random_range", "macro", "core", "records", "src/core/records.4dm", 178, 188, "Integer", "&A:p_random I:p_low I:p_high",
                              "Integer random_range(Attributes &p_random, Integer p_low, Integer p_high)", 0, "", "random_next");
  if (p_id == 206) test_info_set(p_info, "random_between", "macro", "core", "records", "src/core/records.4dm", 190, 196, "Real", "&A:p_random R:p_low R:p_high",
                              "Real random_between(Attributes &p_random, Real p_low, Real p_high)", 0, "", "random_next");
  if (p_id == 207) test_info_set(p_info, "slots_reset", "macro", "core", "slots", "src/core/slots.4dm", 8, 18, "void", "I:p_pool",
                              "void slots_reset(Integer p_pool)", 0, "", "");
  if (p_id == 208) test_info_set(p_info, "slots_set", "macro", "core", "slots", "src/core/slots.4dm", 20, 58, "void", "I:p_pool I:p_slot I:p_used",
                              "void slots_set(Integer p_pool, Integer p_slot, Integer p_used)", 0, "", "");
  if (p_id == 209) test_info_set(p_info, "slots_used", "macro", "core", "slots", "src/core/slots.4dm", 60, 67, "Integer", "I:p_pool I:p_slot",
                              "Integer slots_used(Integer p_pool, Integer p_slot)", 0, "", "");
  if (p_id == 210) test_info_set(p_info, "slots_count", "macro", "core", "slots", "src/core/slots.4dm", 69, 75, "Integer", "I:p_pool",
                              "Integer slots_count(Integer p_pool)", 0, "", "");
  if (p_id == 211) test_info_set(p_info, "slots_at", "macro", "core", "slots", "src/core/slots.4dm", 77, 84, "Integer", "I:p_pool I:p_position",
                              "Integer slots_at(Integer p_pool, Integer p_position)", 0, "", "");
  if (p_id == 212) test_info_set(p_info, "slots_rebuild", "macro", "core", "slots", "src/core/slots.4dm", 86, 98, "void", "I:p_pool &A:p_record I:p_capacity",
                              "void slots_rebuild(Integer p_pool, Attributes &p_record, Integer p_capacity)", 0, "", "record_integer_at, slots_reset, slots_set");
  if (p_id == 213) test_info_set(p_info, "clamp_real", "macro", "core", "util", "src/core/util.4dm", 7, 18, "Real", "R:p_value R:p_low R:p_high",
                              "Real clamp_real(Real p_value, Real p_low, Real p_high)", 0, "", "");
  if (p_id == 214) test_info_set(p_info, "angle_of", "macro", "core", "util", "src/core/util.4dm", 20, 43, "Real", "R:p_y R:p_x",
                              "Real angle_of(Real p_y, Real p_x)", 0, "", "");
  if (p_id == 215) test_info_set(p_info, "two_digits", "macro", "core", "util", "src/core/util.4dm", 45, 52, "Text", "I:p_value",
                              "Text two_digits(Integer p_value)", 0, "", "");
  if (p_id == 216) test_info_set(p_info, "max_integer", "macro", "core", "util", "src/core/util.4dm", 54, 61, "Integer", "I:p_a I:p_b",
                              "Integer max_integer(Integer p_a, Integer p_b)", 0, "", "");
  if (p_id == 217) test_info_set(p_info, "min_integer", "macro", "core", "util", "src/core/util.4dm", 63, 70, "Integer", "I:p_a I:p_b",
                              "Integer min_integer(Integer p_a, Integer p_b)", 0, "", "");
  if (p_id == 218) test_info_set(p_info, "clamp_integer", "macro", "core", "util", "src/core/util.4dm", 72, 83, "Integer", "I:p_value I:p_low I:p_high",
                              "Integer clamp_integer(Integer p_value, Integer p_low, Integer p_high)", 0, "", "");
  if (p_id == 219) test_info_set(p_info, "min_real", "macro", "core", "util", "src/core/util.4dm", 85, 92, "Real", "R:p_first R:p_second",
                              "Real min_real(Real p_first, Real p_second)", 0, "", "");
  if (p_id == 220) test_info_set(p_info, "max_real", "macro", "core", "util", "src/core/util.4dm", 94, 101, "Real", "R:p_first R:p_second",
                              "Real max_real(Real p_first, Real p_second)", 0, "", "");
  if (p_id == 221) test_info_set(p_info, "floor_integer", "macro", "core", "util", "src/core/util.4dm", 103, 110, "Integer", "R:p_value",
                              "Integer floor_integer(Real p_value)", 0, "", "");
  if (p_id == 222) test_info_set(p_info, "floor_divide", "macro", "core", "util", "src/core/util.4dm", 112, 121, "Integer", "I:p_numerator I:p_denominator",
                              "Integer floor_divide(Integer p_numerator, Integer p_denominator)", 0, "", "");
  if (p_id == 223) test_info_set(p_info, "positive_mod", "macro", "core", "util", "src/core/util.4dm", 123, 130, "Integer", "I:p_value I:p_modulus",
                              "Integer positive_mod(Integer p_value, Integer p_modulus)", 0, "", "floor_divide");
  if (p_id == 224) test_info_set(p_info, "to_byte", "macro", "core", "util", "src/core/util.4dm", 132, 139, "Integer", "R:p_value",
                              "Integer to_byte(Real p_value)", 0, "", "clamp_real");
  if (p_id == 225) test_info_set(p_info, "lerp_real", "macro", "core", "util", "src/core/util.4dm", 141, 147, "Real", "R:p_from R:p_to R:p_amount",
                              "Real lerp_real(Real p_from, Real p_to, Real p_amount)", 0, "", "");
  if (p_id == 226) test_info_set(p_info, "smooth_curve", "macro", "core", "util", "src/core/util.4dm", 149, 155, "Real", "R:p_amount",
                              "Real smooth_curve(Real p_amount)", 0, "", "");
  if (p_id == 227) test_info_set(p_info, "hash_real", "macro", "core", "util", "src/core/util.4dm", 157, 166, "Real", "R:p_first R:p_second R:p_third",
                              "Real hash_real(Real p_first, Real p_second, Real p_third)", 0, "", "");
  if (p_id == 228) test_info_set(p_info, "wrap_angle", "macro", "core", "util", "src/core/util.4dm", 168, 174, "Real", "R:p_angle",
                              "Real wrap_angle(Real p_angle)", 0, "", "");
  if (p_id == 229) test_info_set(p_info, "text_to_seed", "macro", "core", "util", "src/core/util.4dm", 176, 228, "Integer", "T:p_text",
                              "Integer text_to_seed(Text p_text)", 0, "", "");
  if (p_id == 230) test_info_set(p_info, "file_title_from_path", "macro", "core", "util", "src/core/util.4dm", 230, 257, "Text", "T:p_path",
                              "Text file_title_from_path(Text p_path)", 0, "", "");
  if (p_id == 231) test_info_set(p_info, "text_is_safe_name", "macro", "core", "util", "src/core/util.4dm", 259, 278, "Integer", "T:p_name",
                              "Integer text_is_safe_name(Text p_name)", 0, "", "");
  if (p_id == 232) test_info_set(p_info, "key_name", "macro", "core", "util", "src/core/util.4dm", 282, 301, "Text", "T:p_msg",
                              "Text key_name(Text p_msg)", 0, "", "");
  if (p_id == 233) test_info_set(p_info, "key_is_text", "macro", "core", "util", "src/core/util.4dm", 303, 315, "Integer", "T:p_msg",
                              "Integer key_is_text(Text p_msg)", 0, "", "");
  if (p_id == 234) test_info_set(p_info, "text_without_last_word", "macro", "core", "util", "src/core/util.4dm", 317, 335, "Text", "T:p_text",
                              "Text text_without_last_word(Text p_text)", 0, "", "");
  if (p_id == 235) test_info_set(p_info, "text_after_key", "macro", "core", "util", "src/core/util.4dm", 337, 355, "Text", "T:p_text T:p_msg I:p_longest",
                              "Text text_after_key(Text p_text, Text p_msg, Integer p_longest)", 0, "", "key_is_text, key_name, text_without_last_word");
  if (p_id == 236) test_info_set(p_info, "chest_slot", "macro", "items", "chest", "src/items/chest.4dm", 12, 18, "Integer", "I:p_chest I:p_which",
                              "Integer chest_slot(Integer p_chest, Integer p_which)", 0, "", "");
  if (p_id == 237) test_info_set(p_info, "chest_used", "macro", "items", "chest", "src/items/chest.4dm", 20, 27, "Integer", "&A:p_store I:p_chest",
                              "Integer chest_used(Attributes &p_store, Integer p_chest)", 0, "", "record_integer_at");
  if (p_id == 238) test_info_set(p_info, "chest_find", "macro", "items", "chest", "src/items/chest.4dm", 29, 44, "Integer", "&A:p_store I:p_x I:p_y I:p_z",
                              "Integer chest_find(Attributes &p_store, Integer p_x, Integer p_y, Integer p_z)", 0, "", "chest_used, record_integer_at");
  if (p_id == 239) test_info_set(p_info, "chest_get_or_create", "macro", "items", "chest", "src/items/chest.4dm", 46, 67, "Integer", "&A:p_store I:p_x I:p_y I:p_z",
                              "Integer chest_get_or_create(Attributes &p_store, Integer p_x, Integer p_y, Integer p_z)", 0, "", "chest_find, chest_slot, chest_used, record_set_integer_at, slot_clear");
  if (p_id == 240) test_info_set(p_info, "chest_item_count", "macro", "items", "chest", "src/items/chest.4dm", 69, 80, "Integer", "&A:p_store I:p_chest",
                              "Integer chest_item_count(Attributes &p_store, Integer p_chest)", 0, "", "chest_slot, chest_used, slot_count");
}

void test_registry_call_6(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 201 to 240 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 201) {   // record_set_real_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    record_set_real_at(g_test_record, l_t1, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 202) {   // record_set_text_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    record_set_text_at(g_test_record, l_t1, l_i1, l_t2);
    Get_time(l_end);
  } else if (p_id == 203) {   // random_seed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    random_seed(g_random, l_i1);
    Get_time(l_end);
  } else if (p_id == 204) {   // random_next
    Get_time(l_start);
    l_ret_r = random_next(g_random);
    Get_time(l_end);
  } else if (p_id == 205) {   // random_range
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = random_range(g_random, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 206) {   // random_between
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = random_between(g_random, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 207) {   // slots_reset
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    slots_reset(l_i1);
    Get_time(l_end);
  } else if (p_id == 208) {   // slots_set
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    slots_set(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 209) {   // slots_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = slots_used(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 210) {   // slots_count
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slots_count(l_i1);
    Get_time(l_end);
  } else if (p_id == 211) {   // slots_at
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = slots_at(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 212) {   // slots_rebuild
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    slots_rebuild(l_i1, g_test_record, l_i2);
    Get_time(l_end);
  } else if (p_id == 213) {   // clamp_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = clamp_real(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 214) {   // angle_of
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = angle_of(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 215) {   // two_digits
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = two_digits(l_i1);
    Get_time(l_end);
  } else if (p_id == 216) {   // max_integer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = max_integer(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 217) {   // min_integer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = min_integer(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 218) {   // clamp_integer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = clamp_integer(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 219) {   // min_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = min_real(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 220) {   // max_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = max_real(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 221) {   // floor_integer
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = floor_integer(l_r1);
    Get_time(l_end);
  } else if (p_id == 222) {   // floor_divide
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = floor_divide(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 223) {   // positive_mod
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = positive_mod(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 224) {   // to_byte
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = to_byte(l_r1);
    Get_time(l_end);
  } else if (p_id == 225) {   // lerp_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = lerp_real(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 226) {   // smooth_curve
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = smooth_curve(l_r1);
    Get_time(l_end);
  } else if (p_id == 227) {   // hash_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = hash_real(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 228) {   // wrap_angle
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = wrap_angle(l_r1);
    Get_time(l_end);
  } else if (p_id == 229) {   // text_to_seed
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = text_to_seed(l_t1);
    Get_time(l_end);
  } else if (p_id == 230) {   // file_title_from_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = file_title_from_path(l_t1);
    Get_time(l_end);
  } else if (p_id == 231) {   // text_is_safe_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = text_is_safe_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 232) {   // key_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = key_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 233) {   // key_is_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = key_is_text(l_t1);
    Get_time(l_end);
  } else if (p_id == 234) {   // text_without_last_word
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = text_without_last_word(l_t1);
    Get_time(l_end);
  } else if (p_id == 235) {   // text_after_key
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = text_after_key(l_t1, l_t2, l_i1);
    Get_time(l_end);
  } else if (p_id == 236) {   // chest_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = chest_slot(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 237) {   // chest_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = chest_used(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 238) {   // chest_find
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = chest_find(g_test_record, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 239) {   // chest_get_or_create
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = chest_get_or_create(g_test_record, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 240) {   // chest_item_count
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = chest_item_count(g_test_record, l_i1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_7(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 241 to 280 are
// ----------------------------------------------------------------
{
  if (p_id == 241) test_info_set(p_info, "chest_remove", "macro", "items", "chest", "src/items/chest.4dm", 82, 106, "void", "&A:p_store &A:p_events I:p_chest",
                              "void chest_remove(Attributes &p_store, Attributes &p_events, Integer p_chest)", 0, "", "chest_slot, chest_used, emit_drop_event, record_integer_at, record_set_integer_at, slot_clear, slot_count, slot_damage, slot_is_empty, slot_item");
  if (p_id == 242) test_info_set(p_info, "chest_on_event", "macro", "items", "chest", "src/items/chest.4dm", 108, 126, "void", "&A:p_event &A:p_store &A:p_events",
                              "void chest_on_event(Attributes &p_event, Attributes &p_store, Attributes &p_events)", 0, "", "chest_find, chest_get_or_create, chest_remove, event_integer, event_type");
  if (p_id == 243) test_info_set(p_info, "crafting_add_recipe", "macro", "items", "crafting", "src/items/crafting.4dm", 13, 41, "void", "&A:p_book I:p_output I:p_output_count I:p_width I:p_height T:p_pattern I:p_item_a I:p_item_b",
                              "void crafting_add_recipe(Attributes &p_book, Integer p_output, Integer p_output_count, Integer p_width, Integer p_height, Text p_pattern, Integer p_item_a, Integer p_item_b)", 0, "", "crafting_recipe_count, record_field_at, record_set_integer, record_set_integer_at");
  if (p_id == 244) test_info_set(p_info, "crafting_init_book", "macro", "items", "crafting", "src/items/crafting.4dm", 43, 77, "void", "&A:p_book",
                              "void crafting_init_book(Attributes &p_book)", 0, "", "crafting_add_recipe, record_clear, record_set_integer");
  if (p_id == 245) test_info_set(p_info, "crafting_recipe_count", "macro", "items", "crafting", "src/items/crafting.4dm", 79, 85, "Integer", "&A:p_book",
                              "Integer crafting_recipe_count(Attributes &p_book)", 0, "", "record_integer");
  if (p_id == 246) test_info_set(p_info, "crafting_recipe_output", "macro", "items", "crafting", "src/items/crafting.4dm", 87, 93, "Integer", "&A:p_book I:p_recipe",
                              "Integer crafting_recipe_output(Attributes &p_book, Integer p_recipe)", 0, "", "record_integer_at");
  if (p_id == 247) test_info_set(p_info, "crafting_recipe_cell", "macro", "items", "crafting", "src/items/crafting.4dm", 95, 108, "Integer", "&A:p_book I:p_recipe I:p_column I:p_row",
                              "Integer crafting_recipe_cell(Attributes &p_book, Integer p_recipe, Integer p_column, Integer p_row)", 0, "", "record_field_at, record_integer, record_integer_at");
  if (p_id == 248) test_info_set(p_info, "grid_clear", "macro", "items", "crafting", "src/items/crafting.4dm", 112, 119, "void", "&A:p_grid I:p_width",
                              "void grid_clear(Attributes &p_grid, Integer p_width)", 0, "", "container_clear, record_set_integer");
  if (p_id == 249) test_info_set(p_info, "grid_width", "macro", "items", "crafting", "src/items/crafting.4dm", 121, 127, "Integer", "&A:p_grid",
                              "Integer grid_width(Attributes &p_grid)", 0, "", "record_integer");
  if (p_id == 250) test_info_set(p_info, "grid_slot", "macro", "items", "crafting", "src/items/crafting.4dm", 129, 135, "Integer", "I:p_column I:p_row",
                              "Integer grid_slot(Integer p_column, Integer p_row)", 0, "", "");
  if (p_id == 251) test_info_set(p_info, "grid_slot_used", "macro", "items", "crafting", "src/items/crafting.4dm", 137, 149, "Integer", "&A:p_grid I:p_slot",
                              "Integer grid_slot_used(Attributes &p_grid, Integer p_slot)", 0, "", "grid_width");
  if (p_id == 252) test_info_set(p_info, "crafting_match_at", "macro", "items", "crafting", "src/items/crafting.4dm", 151, 175, "Integer", "&A:p_book I:p_recipe &A:p_grid I:p_left I:p_top I:p_mirrored",
                              "Integer crafting_match_at(Attributes &p_book, Integer p_recipe, Attributes &p_grid, Integer p_left, Integer p_top, Integer p_mirrored)", 0, "", "crafting_recipe_cell, grid_slot, grid_width, record_integer_at, slot_item");
  if (p_id == 253) test_info_set(p_info, "crafting_match", "macro", "items", "crafting", "src/items/crafting.4dm", 177, 208, "Integer", "&A:p_book &A:p_grid",
                              "Integer crafting_match(Attributes &p_book, Attributes &p_grid)", 0, "", "crafting_match_at, crafting_recipe_count, grid_width, record_integer_at, slot_is_empty");
  if (p_id == 254) test_info_set(p_info, "crafting_take_output", "macro", "items", "crafting", "src/items/crafting.4dm", 210, 242, "Integer", "&A:p_book &A:p_grid &A:p_holder &A:p_events",
                              "Integer crafting_take_output(Attributes &p_book, Attributes &p_grid, Attributes &p_holder, Attributes &p_events)", 0, "", "crafting_match, crafting_recipe_output, emit_item_event, item_max_stack, record_integer_at, slot_count, slot_is_empty, slot_item, slot_set, slot_take_one");
  if (p_id == 255) test_info_set(p_info, "grid_return_items", "macro", "items", "crafting", "src/items/crafting.4dm", 244, 259, "void", "&A:p_grid &A:p_inventory &A:p_events R:p_x R:p_y R:p_z",
                              "void grid_return_items(Attributes &p_grid, Attributes &p_inventory, Attributes &p_events, Real p_x, Real p_y, Real p_z)", 0, "", "emit_drop_event, inventory_add_worn, slot_clear, slot_count, slot_damage, slot_is_empty, slot_item");
  if (p_id == 256) test_info_set(p_info, "drops_clear", "macro", "items", "drops", "src/items/drops.4dm", 18, 28, "void", "&A:p_drops",
                              "void drops_clear(Attributes &p_drops)", 0, "", "record_clear, record_set_integer_at, slots_reset");
  if (p_id == 257) test_info_set(p_info, "drops_rebuild_index", "macro", "items", "drops", "src/items/drops.4dm", 30, 37, "void", "&A:p_drops",
                              "void drops_rebuild_index(Attributes &p_drops)", 0, "", "slots_rebuild");
  if (p_id == 258) test_info_set(p_info, "drop_set_used", "macro", "items", "drops", "src/items/drops.4dm", 39, 47, "void", "&A:p_drops I:p_drop I:p_used",
                              "void drop_set_used(Attributes &p_drops, Integer p_drop, Integer p_used)", 0, "", "record_set_integer_at, slots_set");
  if (p_id == 259) test_info_set(p_info, "drop_used", "macro", "items", "drops", "src/items/drops.4dm", 49, 56, "Integer", "&A:p_drops I:p_drop",
                              "Integer drop_used(Attributes &p_drops, Integer p_drop)", 0, "", "slots_used");
  if (p_id == 260) test_info_set(p_info, "drop_item", "macro", "items", "drops", "src/items/drops.4dm", 58, 64, "Integer", "&A:p_drops I:p_drop",
                              "Integer drop_item(Attributes &p_drops, Integer p_drop)", 0, "", "record_integer_at");
  if (p_id == 261) test_info_set(p_info, "drop_count", "macro", "items", "drops", "src/items/drops.4dm", 66, 72, "Integer", "&A:p_drops I:p_drop",
                              "Integer drop_count(Attributes &p_drops, Integer p_drop)", 0, "", "record_integer_at");
  if (p_id == 262) test_info_set(p_info, "drop_damage", "macro", "items", "drops", "src/items/drops.4dm", 74, 80, "Integer", "&A:p_drops I:p_drop",
                              "Integer drop_damage(Attributes &p_drops, Integer p_drop)", 0, "", "record_integer_at");
  if (p_id == 263) test_info_set(p_info, "drop_age", "macro", "items", "drops", "src/items/drops.4dm", 82, 88, "Real", "&A:p_drops I:p_drop",
                              "Real drop_age(Attributes &p_drops, Integer p_drop)", 0, "", "record_real_at");
  if (p_id == 264) test_info_set(p_info, "drop_position", "macro", "items", "drops", "src/items/drops.4dm", 90, 98, "void", "&A:p_drops I:p_drop &R:p_x &R:p_y &R:p_z",
                              "void drop_position(Attributes &p_drops, Integer p_drop, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real_at");
  if (p_id == 265) test_info_set(p_info, "drops_restore", "macro", "items", "drops", "src/items/drops.4dm", 102, 139, "Integer", "&A:p_drops I:p_item I:p_count I:p_damage R:p_x R:p_y R:p_z R:p_age",
                              "Integer drops_restore(Attributes &p_drops, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z, Real p_age)", 0, "", "drop_age, drop_set_used, drop_used, record_set_integer_at, record_set_real_at");
  if (p_id == 266) test_info_set(p_info, "drops_spawn", "macro", "items", "drops", "src/items/drops.4dm", 141, 156, "Integer", "&A:p_drops &A:p_random I:p_item I:p_count I:p_damage R:p_x R:p_y R:p_z",
                              "Integer drops_spawn(Attributes &p_drops, Attributes &p_random, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z)", 0, "", "drops_restore, random_between, record_set_real_at");
  if (p_id == 267) test_info_set(p_info, "drops_update", "macro", "items", "drops", "src/items/drops.4dm", 158, 264, "void", "&A:p_drops &A:p_inventory &A:p_events R:p_player_x R:p_player_y R:p_player_z I:p_player_dead R:p_dt",
                              "void drops_update(Attributes &p_drops, Attributes &p_inventory, Attributes &p_events, Real p_player_x, Real p_player_y, Real p_player_z, Integer p_player_dead, Real p_dt)", 0, "", "drop_age, drop_count, drop_damage, drop_item, drop_position, drop_set_used, emit_item_event, inventory_add_worn, max_real, min_real, physics_box_in_water, physics_move_box, record_real_at, record_set_integer_at, record_set_real_at, slots_at, slots_count");
  if (p_id == 268) test_info_set(p_info, "drops_on_event", "macro", "items", "drops", "src/items/drops.4dm", 266, 296, "void", "&A:p_event &A:p_drops &A:p_random",
                              "void drops_on_event(Attributes &p_event, Attributes &p_drops, Attributes &p_random)", 0, "", "block_drop_item, drops_spawn, event_integer, event_is_remote, event_real, event_type, floor_integer, random_range");
  if (p_id == 269) test_info_set(p_info, "furnaces_clear", "macro", "items", "furnace", "src/items/furnace.4dm", 16, 26, "void", "&A:p_furnaces",
                              "void furnaces_clear(Attributes &p_furnaces)", 0, "", "record_clear, record_set_integer_at, slots_reset");
  if (p_id == 270) test_info_set(p_info, "furnaces_rebuild_index", "macro", "items", "furnace", "src/items/furnace.4dm", 28, 35, "void", "&A:p_furnaces",
                              "void furnaces_rebuild_index(Attributes &p_furnaces)", 0, "", "slots_rebuild");
  if (p_id == 271) test_info_set(p_info, "furnace_set_used", "macro", "items", "furnace", "src/items/furnace.4dm", 37, 45, "void", "&A:p_furnaces I:p_furnace I:p_used",
                              "void furnace_set_used(Attributes &p_furnaces, Integer p_furnace, Integer p_used)", 0, "", "record_set_integer_at, slots_set");
  if (p_id == 272) test_info_set(p_info, "furnace_slot", "macro", "items", "furnace", "src/items/furnace.4dm", 47, 53, "Integer", "I:p_furnace I:p_which",
                              "Integer furnace_slot(Integer p_furnace, Integer p_which)", 0, "", "");
  if (p_id == 273) test_info_set(p_info, "furnace_used", "macro", "items", "furnace", "src/items/furnace.4dm", 55, 62, "Integer", "&A:p_furnaces I:p_furnace",
                              "Integer furnace_used(Attributes &p_furnaces, Integer p_furnace)", 0, "", "slots_used");
  if (p_id == 274) test_info_set(p_info, "furnace_cell", "macro", "items", "furnace", "src/items/furnace.4dm", 64, 72, "void", "&A:p_furnaces I:p_furnace &I:p_x &I:p_y &I:p_z",
                              "void furnace_cell(Attributes &p_furnaces, Integer p_furnace, Integer &p_x, Integer &p_y, Integer &p_z)", 0, "", "record_integer_at");
  if (p_id == 275) test_info_set(p_info, "furnace_burn_left", "macro", "items", "furnace", "src/items/furnace.4dm", 74, 80, "Real", "&A:p_furnaces I:p_furnace",
                              "Real furnace_burn_left(Attributes &p_furnaces, Integer p_furnace)", 0, "", "record_real_at");
  if (p_id == 276) test_info_set(p_info, "furnace_burn_total", "macro", "items", "furnace", "src/items/furnace.4dm", 82, 88, "Real", "&A:p_furnaces I:p_furnace",
                              "Real furnace_burn_total(Attributes &p_furnaces, Integer p_furnace)", 0, "", "record_real_at");
  if (p_id == 277) test_info_set(p_info, "furnace_progress", "macro", "items", "furnace", "src/items/furnace.4dm", 90, 96, "Real", "&A:p_furnaces I:p_furnace",
                              "Real furnace_progress(Attributes &p_furnaces, Integer p_furnace)", 0, "", "record_real_at");
  if (p_id == 278) test_info_set(p_info, "furnace_set_state", "macro", "items", "furnace", "src/items/furnace.4dm", 98, 106, "void", "&A:p_furnaces I:p_furnace R:p_burn_left R:p_burn_total R:p_progress",
                              "void furnace_set_state(Attributes &p_furnaces, Integer p_furnace, Real p_burn_left, Real p_burn_total, Real p_progress)", 0, "", "record_set_real_at");
  if (p_id == 279) test_info_set(p_info, "furnace_find", "macro", "items", "furnace", "src/items/furnace.4dm", 110, 126, "Integer", "&A:p_furnaces I:p_x I:p_y I:p_z",
                              "Integer furnace_find(Attributes &p_furnaces, Integer p_x, Integer p_y, Integer p_z)", 0, "", "furnace_cell, furnace_used");
  if (p_id == 280) test_info_set(p_info, "furnace_get_or_create", "macro", "items", "furnace", "src/items/furnace.4dm", 128, 150, "Integer", "&A:p_furnaces I:p_x I:p_y I:p_z",
                              "Integer furnace_get_or_create(Attributes &p_furnaces, Integer p_x, Integer p_y, Integer p_z)", 0, "", "furnace_find, furnace_set_state, furnace_set_used, furnace_slot, furnace_used, record_set_integer_at, slot_clear");
}

void test_registry_call_7(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 241 to 280 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 241) {   // chest_remove
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    chest_remove(g_test_record, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 242) {   // chest_on_event
    Get_time(l_start);
    chest_on_event(g_event, g_test_record, g_events);
    Get_time(l_end);
  } else if (p_id == 243) {   // crafting_add_recipe
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    Get_time(l_start);
    crafting_add_recipe(g_book, l_i1, l_i2, l_i3, l_i4, l_t1, l_i5, l_i6);
    Get_time(l_end);
  } else if (p_id == 244) {   // crafting_init_book
    Get_time(l_start);
    crafting_init_book(g_book);
    Get_time(l_end);
  } else if (p_id == 245) {   // crafting_recipe_count
    Get_time(l_start);
    l_ret_i = crafting_recipe_count(g_book);
    Get_time(l_end);
  } else if (p_id == 246) {   // crafting_recipe_output
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = crafting_recipe_output(g_book, l_i1);
    Get_time(l_end);
  } else if (p_id == 247) {   // crafting_recipe_cell
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = crafting_recipe_cell(g_book, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 248) {   // grid_clear
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    grid_clear(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 249) {   // grid_width
    Get_time(l_start);
    l_ret_i = grid_width(g_grid);
    Get_time(l_end);
  } else if (p_id == 250) {   // grid_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = grid_slot(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 251) {   // grid_slot_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = grid_slot_used(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 252) {   // crafting_match_at
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = crafting_match_at(g_book, l_i1, g_grid, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 253) {   // crafting_match
    Get_time(l_start);
    l_ret_i = crafting_match(g_book, g_grid);
    Get_time(l_end);
  } else if (p_id == 254) {   // crafting_take_output
    Get_time(l_start);
    l_ret_i = crafting_take_output(g_book, g_grid, g_inventory, g_events);
    Get_time(l_end);
  } else if (p_id == 255) {   // grid_return_items
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    grid_return_items(g_grid, g_inventory, g_events, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 256) {   // drops_clear
    Get_time(l_start);
    drops_clear(g_drops);
    Get_time(l_end);
  } else if (p_id == 257) {   // drops_rebuild_index
    Get_time(l_start);
    drops_rebuild_index(g_drops);
    Get_time(l_end);
  } else if (p_id == 258) {   // drop_set_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    drop_set_used(g_drops, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 259) {   // drop_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = drop_used(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 260) {   // drop_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = drop_item(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 261) {   // drop_count
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = drop_count(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 262) {   // drop_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = drop_damage(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 263) {   // drop_age
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = drop_age(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 264) {   // drop_position
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    drop_position(g_drops, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 265) {   // drops_restore
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = drops_restore(g_drops, l_i1, l_i2, l_i3, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 266) {   // drops_spawn
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_i = drops_spawn(g_drops, g_random, l_i1, l_i2, l_i3, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 267) {   // drops_update
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    drops_update(g_drops, g_inventory, g_events, l_r1, l_r2, l_r3, l_i1, l_r4);
    Get_time(l_end);
  } else if (p_id == 268) {   // drops_on_event
    Get_time(l_start);
    drops_on_event(g_event, g_drops, g_random);
    Get_time(l_end);
  } else if (p_id == 269) {   // furnaces_clear
    Get_time(l_start);
    furnaces_clear(g_furnaces);
    Get_time(l_end);
  } else if (p_id == 270) {   // furnaces_rebuild_index
    Get_time(l_start);
    furnaces_rebuild_index(g_furnaces);
    Get_time(l_end);
  } else if (p_id == 271) {   // furnace_set_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    furnace_set_used(g_furnaces, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 272) {   // furnace_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = furnace_slot(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 273) {   // furnace_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = furnace_used(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 274) {   // furnace_cell
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    furnace_cell(g_furnaces, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
  } else if (p_id == 275) {   // furnace_burn_left
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = furnace_burn_left(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 276) {   // furnace_burn_total
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = furnace_burn_total(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 277) {   // furnace_progress
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = furnace_progress(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 278) {   // furnace_set_state
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    furnace_set_state(g_furnaces, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 279) {   // furnace_find
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = furnace_find(g_furnaces, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 280) {   // furnace_get_or_create
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = furnace_get_or_create(g_furnaces, l_i1, l_i2, l_i3);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_8(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 281 to 320 are
// ----------------------------------------------------------------
{
  if (p_id == 281) test_info_set(p_info, "furnace_remove", "macro", "items", "furnace", "src/items/furnace.4dm", 152, 175, "void", "&A:p_furnaces &A:p_events I:p_furnace",
                              "void furnace_remove(Attributes &p_furnaces, Attributes &p_events, Integer p_furnace)", 0, "", "emit_drop_event, furnace_cell, furnace_set_used, furnace_slot, furnace_used, slot_clear, slot_count, slot_damage, slot_is_empty, slot_item");
  if (p_id == 282) test_info_set(p_info, "furnace_can_cook", "macro", "items", "furnace", "src/items/furnace.4dm", 177, 194, "Integer", "&A:p_furnaces I:p_furnace",
                              "Integer furnace_can_cook(Attributes &p_furnaces, Integer p_furnace)", 0, "", "furnace_slot, item_max_stack, item_smelt_result, slot_count, slot_is_empty, slot_item");
  if (p_id == 283) test_info_set(p_info, "furnace_step", "macro", "items", "furnace", "src/items/furnace.4dm", 196, 243, "void", "&A:p_furnaces I:p_furnace R:p_dt",
                              "void furnace_step(Attributes &p_furnaces, Integer p_furnace, Real p_dt)", 0, "", "furnace_burn_left, furnace_burn_total, furnace_can_cook, furnace_progress, furnace_set_state, furnace_slot, item_fuel_seconds, item_smelt_result, slot_count, slot_is_empty, slot_item, slot_set, slot_take_one");
  if (p_id == 284) test_info_set(p_info, "furnaces_update", "macro", "items", "furnace", "src/items/furnace.4dm", 245, 283, "void", "&A:p_furnaces &A:p_events R:p_dt",
                              "void furnaces_update(Attributes &p_furnaces, Attributes &p_events, Real p_dt)", 0, "", "block_furnace_is_lit, block_is_furnace, emit_event, furnace_burn_left, furnace_cell, furnace_step, slots_at, slots_count, world_get_block");
  if (p_id == 285) test_info_set(p_info, "furnace_on_event", "macro", "items", "furnace", "src/items/furnace.4dm", 285, 303, "void", "&A:p_event &A:p_furnaces &A:p_events",
                              "void furnace_on_event(Attributes &p_event, Attributes &p_furnaces, Attributes &p_events)", 0, "", "block_is_furnace, event_integer, event_type, furnace_find, furnace_get_or_create, furnace_remove");
  if (p_id == 286) test_info_set(p_info, "slot_item", "macro", "items", "inventory", "src/items/inventory.4dm", 14, 20, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_item(Attributes &p_container, Integer p_slot)", 0, "", "record_integer_at");
  if (p_id == 287) test_info_set(p_info, "slot_count", "macro", "items", "inventory", "src/items/inventory.4dm", 22, 28, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_count(Attributes &p_container, Integer p_slot)", 0, "", "record_integer_at");
  if (p_id == 288) test_info_set(p_info, "slot_damage", "macro", "items", "inventory", "src/items/inventory.4dm", 30, 36, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_damage(Attributes &p_container, Integer p_slot)", 0, "", "record_integer_at");
  if (p_id == 289) test_info_set(p_info, "slot_is_empty", "macro", "items", "inventory", "src/items/inventory.4dm", 38, 46, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_is_empty(Attributes &p_container, Integer p_slot)", 0, "", "slot_count, slot_item");
  if (p_id == 290) test_info_set(p_info, "slot_set", "macro", "items", "inventory", "src/items/inventory.4dm", 48, 65, "void", "&A:p_container I:p_slot I:p_item I:p_count I:p_damage",
                              "void slot_set(Attributes &p_container, Integer p_slot, Integer p_item, Integer p_count, Integer p_damage)", 0, "", "record_set_integer_at");
  if (p_id == 291) test_info_set(p_info, "slot_clear", "macro", "items", "inventory", "src/items/inventory.4dm", 67, 73, "void", "&A:p_container I:p_slot",
                              "void slot_clear(Attributes &p_container, Integer p_slot)", 0, "", "slot_set");
  if (p_id == 292) test_info_set(p_info, "slot_swap", "macro", "items", "inventory", "src/items/inventory.4dm", 75, 86, "void", "&A:p_container I:p_slot_a I:p_slot_b",
                              "void slot_swap(Attributes &p_container, Integer p_slot_a, Integer p_slot_b)", 0, "", "slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 293) test_info_set(p_info, "slot_take_one", "macro", "items", "inventory", "src/items/inventory.4dm", 88, 94, "void", "&A:p_container I:p_slot",
                              "void slot_take_one(Attributes &p_container, Integer p_slot)", 0, "", "slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 294) test_info_set(p_info, "slot_wear", "macro", "items", "inventory", "src/items/inventory.4dm", 96, 115, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_wear(Attributes &p_container, Integer p_slot)", 0, "", "item_max_uses, record_set_integer_at, slot_clear, slot_damage, slot_item");
  if (p_id == 295) test_info_set(p_info, "slot_click_left", "macro", "items", "inventory", "src/items/inventory.4dm", 117, 162, "void", "&A:p_holder &A:p_container I:p_slot I:p_take_only",
                              "void slot_click_left(Attributes &p_holder, Attributes &p_container, Integer p_slot, Integer p_take_only)", 0, "", "item_max_stack, slot_clear, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 296) test_info_set(p_info, "slot_click_right", "macro", "items", "inventory", "src/items/inventory.4dm", 164, 193, "void", "&A:p_holder &A:p_container I:p_slot I:p_take_only",
                              "void slot_click_right(Attributes &p_holder, Attributes &p_container, Integer p_slot, Integer p_take_only)", 0, "", "floor_divide, item_max_stack, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 297) test_info_set(p_info, "slot_move_all", "macro", "items", "inventory", "src/items/inventory.4dm", 195, 204, "void", "&A:p_from I:p_from_slot &A:p_to I:p_first I:p_last",
                              "void slot_move_all(Attributes &p_from, Integer p_from_slot, Attributes &p_to, Integer p_first, Integer p_last)", 0, "", "container_add, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 298) test_info_set(p_info, "container_clear", "macro", "items", "inventory", "src/items/inventory.4dm", 208, 218, "void", "&A:p_container T:p_datatype I:p_first I:p_last",
                              "void container_clear(Attributes &p_container, Text p_datatype, Integer p_first, Integer p_last)", 0, "", "record_clear, slot_clear");
  if (p_id == 299) test_info_set(p_info, "container_add", "macro", "items", "inventory", "src/items/inventory.4dm", 220, 258, "Integer", "&A:p_container I:p_first I:p_last I:p_item I:p_count I:p_damage",
                              "Integer container_add(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item, Integer p_count, Integer p_damage)", 0, "", "item_max_stack, slot_count, slot_is_empty, slot_item, slot_set");
  if (p_id == 300) test_info_set(p_info, "container_count_item", "macro", "items", "inventory", "src/items/inventory.4dm", 260, 272, "Integer", "&A:p_container I:p_first I:p_last I:p_item",
                              "Integer container_count_item(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item)", 0, "", "slot_count, slot_item");
  if (p_id == 301) test_info_set(p_info, "container_remove_item", "macro", "items", "inventory", "src/items/inventory.4dm", 274, 298, "Integer", "&A:p_container I:p_first I:p_last I:p_item I:p_count",
                              "Integer container_remove_item(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item, Integer p_count)", 0, "", "container_count_item, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 302) test_info_set(p_info, "inventory_clear", "macro", "items", "inventory", "src/items/inventory.4dm", 302, 308, "void", "&A:p_inventory",
                              "void inventory_clear(Attributes &p_inventory)", 0, "", "container_clear");
  if (p_id == 303) test_info_set(p_info, "inventory_add", "macro", "items", "inventory", "src/items/inventory.4dm", 310, 316, "Integer", "&A:p_inventory I:p_item I:p_count",
                              "Integer inventory_add(Attributes &p_inventory, Integer p_item, Integer p_count)", 0, "", "container_add");
  if (p_id == 304) test_info_set(p_info, "inventory_add_worn", "macro", "items", "inventory", "src/items/inventory.4dm", 318, 325, "Integer", "&A:p_inventory I:p_item I:p_count I:p_damage",
                              "Integer inventory_add_worn(Attributes &p_inventory, Integer p_item, Integer p_count, Integer p_damage)", 0, "", "container_add");
  if (p_id == 305) test_info_set(p_info, "inventory_count_item", "macro", "items", "inventory", "src/items/inventory.4dm", 327, 333, "Integer", "&A:p_inventory I:p_item",
                              "Integer inventory_count_item(Attributes &p_inventory, Integer p_item)", 0, "", "container_count_item");
  if (p_id == 306) test_info_set(p_info, "inventory_remove_item", "macro", "items", "inventory", "src/items/inventory.4dm", 335, 342, "Integer", "&A:p_inventory I:p_item I:p_count",
                              "Integer inventory_remove_item(Attributes &p_inventory, Integer p_item, Integer p_count)", 0, "", "container_remove_item");
  if (p_id == 307) test_info_set(p_info, "inventory_return_cursor", "macro", "items", "inventory", "src/items/inventory.4dm", 344, 359, "void", "&A:p_inventory &A:p_events R:p_x R:p_y R:p_z",
                              "void inventory_return_cursor(Attributes &p_inventory, Attributes &p_events, Real p_x, Real p_y, Real p_z)", 0, "", "emit_drop_event, inventory_add_worn, slot_clear, slot_count, slot_damage, slot_item");
  if (p_id == 308) test_info_set(p_info, "inventory_armour_slot", "macro", "items", "inventory", "src/items/inventory.4dm", 363, 370, "Integer", "I:p_place",
                              "Integer inventory_armour_slot(Integer p_place)", 0, "", "");
  if (p_id == 309) test_info_set(p_info, "inventory_fits_slot", "macro", "items", "inventory", "src/items/inventory.4dm", 372, 381, "Integer", "I:p_item I:p_slot",
                              "Integer inventory_fits_slot(Integer p_item, Integer p_slot)", 0, "", "inventory_armour_slot, item_armour_place");
  if (p_id == 310) test_info_set(p_info, "inventory_armour_points", "macro", "items", "inventory", "src/items/inventory.4dm", 383, 395, "Integer", "&A:p_inventory",
                              "Integer inventory_armour_points(Attributes &p_inventory)", 0, "", "item_armour_points, min_integer, slot_item");
  if (p_id == 311) test_info_set(p_info, "inventory_armour_damage", "macro", "items", "inventory", "src/items/inventory.4dm", 397, 407, "Integer", "&A:p_inventory I:p_amount",
                              "Integer inventory_armour_damage(Attributes &p_inventory, Integer p_amount)", 0, "", "floor_integer, inventory_armour_points");
  if (p_id == 312) test_info_set(p_info, "inventory_wear_armour", "macro", "items", "inventory", "src/items/inventory.4dm", 409, 428, "Integer", "&A:p_inventory &A:p_events",
                              "Integer inventory_wear_armour(Attributes &p_inventory, Attributes &p_events)", 0, "", "emit_toast, item_name, slot_item, slot_wear");
  if (p_id == 313) test_info_set(p_info, "inventory_equip", "macro", "items", "inventory", "src/items/inventory.4dm", 430, 441, "Integer", "&A:p_inventory I:p_slot",
                              "Integer inventory_equip(Attributes &p_inventory, Integer p_slot)", 0, "", "inventory_armour_slot, item_armour_place, slot_item, slot_swap");
  if (p_id == 314) test_info_set(p_info, "inventory_swap_hands", "macro", "items", "inventory", "src/items/inventory.4dm", 443, 449, "void", "&A:p_inventory I:p_selected",
                              "void inventory_swap_hands(Attributes &p_inventory, Integer p_selected)", 0, "", "slot_swap");
  if (p_id == 315) test_info_set(p_info, "cows_clear", "macro", "mobs", "cows", "src/mobs/cows.4dm", 17, 28, "void", "&A:p_cows",
                              "void cows_clear(Attributes &p_cows)", 0, "", "record_clear, record_set_integer_at, record_set_real, slots_reset");
  if (p_id == 316) test_info_set(p_info, "mobs_rebuild_index", "macro", "mobs", "cows", "src/mobs/cows.4dm", 30, 37, "void", "&A:p_cows",
                              "void mobs_rebuild_index(Attributes &p_cows)", 0, "", "slots_rebuild");
  if (p_id == 317) test_info_set(p_info, "mob_set_used", "macro", "mobs", "cows", "src/mobs/cows.4dm", 39, 47, "void", "&A:p_cows I:p_cow I:p_used",
                              "void mob_set_used(Attributes &p_cows, Integer p_cow, Integer p_used)", 0, "", "record_set_integer_at, slots_set");
  if (p_id == 318) test_info_set(p_info, "cow_alive", "macro", "mobs", "cows", "src/mobs/cows.4dm", 49, 57, "Integer", "&A:p_cows I:p_cow",
                              "Integer cow_alive(Attributes &p_cows, Integer p_cow)", 0, "", "slots_used");
  if (p_id == 319) test_info_set(p_info, "cow_position", "macro", "mobs", "cows", "src/mobs/cows.4dm", 59, 67, "void", "&A:p_cows I:p_cow &R:p_x &R:p_y &R:p_z",
                              "void cow_position(Attributes &p_cows, Integer p_cow, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real_at");
  if (p_id == 320) test_info_set(p_info, "cow_set_position", "macro", "mobs", "cows", "src/mobs/cows.4dm", 69, 77, "void", "&A:p_cows I:p_cow R:p_x R:p_y R:p_z",
                              "void cow_set_position(Attributes &p_cows, Integer p_cow, Real p_x, Real p_y, Real p_z)", 0, "", "record_set_real_at");
}

void test_registry_call_8(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 281 to 320 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 281) {   // furnace_remove
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    furnace_remove(g_furnaces, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 282) {   // furnace_can_cook
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = furnace_can_cook(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 283) {   // furnace_step
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    furnace_step(g_furnaces, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 284) {   // furnaces_update
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    furnaces_update(g_furnaces, g_events, l_r1);
    Get_time(l_end);
  } else if (p_id == 285) {   // furnace_on_event
    Get_time(l_start);
    furnace_on_event(g_event, g_furnaces, g_events);
    Get_time(l_end);
  } else if (p_id == 286) {   // slot_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_item(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 287) {   // slot_count
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_count(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 288) {   // slot_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_damage(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 289) {   // slot_is_empty
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_is_empty(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 290) {   // slot_set
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    slot_set(g_grid, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 291) {   // slot_clear
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    slot_clear(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 292) {   // slot_swap
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    slot_swap(g_grid, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 293) {   // slot_take_one
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    slot_take_one(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 294) {   // slot_wear
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_wear(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 295) {   // slot_click_left
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    slot_click_left(g_inventory, g_grid, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 296) {   // slot_click_right
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    slot_click_right(g_inventory, g_grid, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 297) {   // slot_move_all
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    slot_move_all(g_inventory, l_i1, g_grid, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 298) {   // container_clear
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    container_clear(g_grid, l_t1, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 299) {   // container_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = container_add(g_grid, l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 300) {   // container_count_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = container_count_item(g_grid, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 301) {   // container_remove_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = container_remove_item(g_grid, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 302) {   // inventory_clear
    Get_time(l_start);
    inventory_clear(g_inventory);
    Get_time(l_end);
  } else if (p_id == 303) {   // inventory_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = inventory_add(g_inventory, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 304) {   // inventory_add_worn
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = inventory_add_worn(g_inventory, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 305) {   // inventory_count_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inventory_count_item(g_inventory, l_i1);
    Get_time(l_end);
  } else if (p_id == 306) {   // inventory_remove_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = inventory_remove_item(g_inventory, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 307) {   // inventory_return_cursor
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    inventory_return_cursor(g_inventory, g_events, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 308) {   // inventory_armour_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inventory_armour_slot(l_i1);
    Get_time(l_end);
  } else if (p_id == 309) {   // inventory_fits_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = inventory_fits_slot(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 310) {   // inventory_armour_points
    Get_time(l_start);
    l_ret_i = inventory_armour_points(g_inventory);
    Get_time(l_end);
  } else if (p_id == 311) {   // inventory_armour_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inventory_armour_damage(g_inventory, l_i1);
    Get_time(l_end);
  } else if (p_id == 312) {   // inventory_wear_armour
    Get_time(l_start);
    l_ret_i = inventory_wear_armour(g_inventory, g_events);
    Get_time(l_end);
  } else if (p_id == 313) {   // inventory_equip
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inventory_equip(g_inventory, l_i1);
    Get_time(l_end);
  } else if (p_id == 314) {   // inventory_swap_hands
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    inventory_swap_hands(g_inventory, l_i1);
    Get_time(l_end);
  } else if (p_id == 315) {   // cows_clear
    Get_time(l_start);
    cows_clear(g_cows);
    Get_time(l_end);
  } else if (p_id == 316) {   // mobs_rebuild_index
    Get_time(l_start);
    mobs_rebuild_index(g_cows);
    Get_time(l_end);
  } else if (p_id == 317) {   // mob_set_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    mob_set_used(g_cows, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 318) {   // cow_alive
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = cow_alive(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 319) {   // cow_position
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    cow_position(g_cows, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 320) {   // cow_set_position
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    cow_set_position(g_cows, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_9(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 321 to 360 are
// ----------------------------------------------------------------
{
  if (p_id == 321) test_info_set(p_info, "cow_yaw", "macro", "mobs", "cows", "src/mobs/cows.4dm", 79, 85, "Real", "&A:p_cows I:p_cow",
                              "Real cow_yaw(Attributes &p_cows, Integer p_cow)", 0, "", "record_real_at");
  if (p_id == 322) test_info_set(p_info, "cow_flash", "macro", "mobs", "cows", "src/mobs/cows.4dm", 87, 93, "Real", "&A:p_cows I:p_cow",
                              "Real cow_flash(Attributes &p_cows, Integer p_cow)", 0, "", "record_real_at");
  if (p_id == 323) test_info_set(p_info, "cow_step", "macro", "mobs", "cows", "src/mobs/cows.4dm", 95, 101, "Real", "&A:p_cows I:p_cow",
                              "Real cow_step(Attributes &p_cows, Integer p_cow)", 0, "", "record_real_at");
  if (p_id == 324) test_info_set(p_info, "cows_alive_count", "macro", "mobs", "cows", "src/mobs/cows.4dm", 103, 109, "Integer", "&A:p_cows",
                              "Integer cows_alive_count(Attributes &p_cows)", 0, "", "mobs_count_kind");
  if (p_id == 325) test_info_set(p_info, "mob_kind", "macro", "mobs", "cows", "src/mobs/cows.4dm", 111, 117, "Integer", "&A:p_cows I:p_cow",
                              "Integer mob_kind(Attributes &p_cows, Integer p_cow)", 0, "", "record_integer_at");
  if (p_id == 326) test_info_set(p_info, "mob_half_width", "macro", "mobs", "cows", "src/mobs/cows.4dm", 119, 127, "Real", "I:p_kind",
                              "Real mob_half_width(Integer p_kind)", 0, "", "");
  if (p_id == 327) test_info_set(p_info, "mob_height", "macro", "mobs", "cows", "src/mobs/cows.4dm", 129, 137, "Real", "I:p_kind",
                              "Real mob_height(Integer p_kind)", 0, "", "");
  if (p_id == 328) test_info_set(p_info, "mobs_count_kind", "macro", "mobs", "cows", "src/mobs/cows.4dm", 139, 153, "Integer", "&A:p_cows I:p_kind",
                              "Integer mobs_count_kind(Attributes &p_cows, Integer p_kind)", 0, "", "mob_kind, slots_at, slots_count");
  if (p_id == 329) test_info_set(p_info, "cows_spawn", "macro", "mobs", "cows", "src/mobs/cows.4dm", 157, 163, "Integer", "&A:p_cows &A:p_random R:p_x R:p_y R:p_z R:p_yaw",
                              "Integer cows_spawn(Attributes &p_cows, Attributes &p_random, Real p_x, Real p_y, Real p_z, Real p_yaw)", 0, "", "mobs_spawn");
  if (p_id == 330) test_info_set(p_info, "mobs_spawn", "macro", "mobs", "cows", "src/mobs/cows.4dm", 165, 196, "Integer", "&A:p_cows &A:p_random I:p_kind R:p_x R:p_y R:p_z R:p_yaw",
                              "Integer mobs_spawn(Attributes &p_cows, Attributes &p_random, Integer p_kind, Real p_x, Real p_y, Real p_z, Real p_yaw)", 0, "", "cow_alive, cow_set_position, mob_set_used, random_between, record_set_integer_at, record_set_real_at");
  if (p_id == 331) test_info_set(p_info, "cows_spawn_random", "macro", "mobs", "cows", "src/mobs/cows.4dm", 198, 204, "Integer", "&A:p_cows &A:p_random I:p_count R:p_away_x R:p_away_z R:p_keep_away",
                              "Integer cows_spawn_random(Attributes &p_cows, Attributes &p_random, Integer p_count, Real p_away_x, Real p_away_z, Real p_keep_away)", 0, "", "mobs_spawn_random");
  if (p_id == 332) test_info_set(p_info, "mobs_spawn_random", "macro", "mobs", "cows", "src/mobs/cows.4dm", 206, 234, "Integer", "&A:p_cows &A:p_random I:p_kind I:p_count R:p_away_x R:p_away_z R:p_keep_away",
                              "Integer mobs_spawn_random(Attributes &p_cows, Attributes &p_random, Integer p_kind, Integer p_count, Real p_away_x, Real p_away_z, Real p_keep_away)", 0, "", "mobs_spawn, random_between, random_range, world_get_block, world_top_solid_y");
  if (p_id == 333) test_info_set(p_info, "zombies_spawn_near", "macro", "mobs", "cows", "src/mobs/cows.4dm", 236, 265, "Integer", "&A:p_cows &A:p_random R:p_player_x R:p_player_z",
                              "Integer zombies_spawn_near(Attributes &p_cows, Attributes &p_random, Real p_player_x, Real p_player_z)", 0, "", "floor_integer, mobs_spawn, random_between, world_get_block, world_get_light, world_top_solid_y");
  if (p_id == 334) test_info_set(p_info, "zombie_sunlight", "macro", "mobs", "cows", "src/mobs/cows.4dm", 267, 295, "void", "&A:p_cows &A:p_events I:p_cow R:p_dt",
                              "void zombie_sunlight(Attributes &p_cows, Attributes &p_events, Integer p_cow, Real p_dt)", 0, "", "cow_position, emit_event, floor_integer, mob_set_used, record_integer_at, record_real_at, record_set_integer_at, record_set_real_at, world_sky_top");
  if (p_id == 335) test_info_set(p_info, "cow_update", "macro", "mobs", "cows", "src/mobs/cows.4dm", 297, 462, "void", "&A:p_cows &A:p_random &A:p_events I:p_cow R:p_player_x R:p_player_y R:p_player_z R:p_dt",
                              "void cow_update(Attributes &p_cows, Attributes &p_random, Attributes &p_events, Integer p_cow, Real p_player_x, Real p_player_y, Real p_player_z, Real p_dt)", 0, "", "angle_of, cow_set_position, emit_event, floor_integer, max_real, min_real, mob_half_width, mob_height, mob_kind, physics_box_in_water, physics_move_box, random_between, random_next, record_integer_at, record_real_at, record_set_integer_at, record_set_real_at, world_get_block, world_is_solid, wrap_angle");
  if (p_id == 336) test_info_set(p_info, "cows_update", "macro", "mobs", "cows", "src/mobs/cows.4dm", 464, 517, "void", "&A:p_cows &A:p_random &A:p_events R:p_player_x R:p_player_y R:p_player_z I:p_night I:p_leave_player R:p_dt",
                              "void cows_update(Attributes &p_cows, Attributes &p_random, Attributes &p_events, Real p_player_x, Real p_player_y, Real p_player_z, Integer p_night, Integer p_leave_player, Real p_dt)", 0, "", "cow_alive, cow_position, cow_update, cows_alive_count, cows_spawn_random, mob_kind, mobs_count_kind, mobs_spawn_random, record_real, record_set_real, slots_at, slots_count, zombie_sunlight, zombies_spawn_near");
  if (p_id == 337) test_info_set(p_info, "cows_ray_hit", "macro", "mobs", "cows", "src/mobs/cows.4dm", 519, 552, "Integer", "&A:p_cows R:p_origin_x R:p_origin_y R:p_origin_z R:p_dir_x R:p_dir_y R:p_dir_z R:p_max_distance &R:p_distance",
                              "Integer cows_ray_hit(Attributes &p_cows, Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_max_distance, Real &p_distance)", 0, "", "cow_position, mob_half_width, mob_height, mob_kind, physics_ray_box, slots_at, slots_count");
  if (p_id == 338) test_info_set(p_info, "cow_damage", "macro", "mobs", "cows", "src/mobs/cows.4dm", 554, 590, "void", "&A:p_cows &A:p_events &A:p_random I:p_cow I:p_amount R:p_push_x R:p_push_z",
                              "void cow_damage(Attributes &p_cows, Attributes &p_events, Attributes &p_random, Integer p_cow, Integer p_amount, Real p_push_x, Real p_push_z)", 0, "", "cow_alive, cow_position, emit_event, mob_kind, mob_set_used, random_between, record_integer_at, record_set_integer_at, record_set_real_at");
  if (p_id == 339) test_info_set(p_info, "cows_box_overlaps", "macro", "mobs", "cows", "src/mobs/cows.4dm", 592, 616, "Integer", "&A:p_cows R:p_min_x R:p_min_y R:p_min_z R:p_max_x R:p_max_y R:p_max_z",
                              "Integer cows_box_overlaps(Attributes &p_cows, Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)", 0, "", "cow_position, mob_half_width, mob_height, mob_kind, slots_at, slots_count");
  if (p_id == 340) test_info_set(p_info, "cows_on_event", "macro", "mobs", "cows", "src/mobs/cows.4dm", 618, 629, "void", "&A:p_event &A:p_cows &A:p_random &A:p_events",
                              "void cows_on_event(Attributes &p_event, Attributes &p_cows, Attributes &p_random, Attributes &p_events)", 0, "", "emit_toast, event_integer, event_real, event_type, mobs_spawn");
  if (p_id == 341) test_info_set(p_info, "net_clear", "macro", "net", "net", "src/net/net.4dm", 15, 28, "void", "&A:p_net &A:p_peers &A:p_inbox",
                              "void net_clear(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox)", 0, "", "record_clear, record_set_integer, record_set_text");
  if (p_id == 342) test_info_set(p_info, "net_mode", "macro", "net", "net", "src/net/net.4dm", 30, 36, "Integer", "&A:p_net",
                              "Integer net_mode(Attributes &p_net)", 0, "", "record_integer");
  if (p_id == 343) test_info_set(p_info, "net_clean_name", "macro", "net", "net", "src/net/net.4dm", 38, 58, "Text", "T:p_name",
                              "Text net_clean_name(Text p_name)", 0, "", "");
  if (p_id == 344) test_info_set(p_info, "net_session_path", "macro", "net", "net", "src/net/net.4dm", 60, 66, "Text", "T:p_folder",
                              "Text net_session_path(Text p_folder)", 0, "", "");
  if (p_id == 345) test_info_set(p_info, "net_snapshot_path", "macro", "net", "net", "src/net/net.4dm", 68, 74, "Text", "T:p_folder T:p_session",
                              "Text net_snapshot_path(Text p_folder, Text p_session)", 0, "", "");
  if (p_id == 346) test_info_set(p_info, "net_log_name", "macro", "net", "net", "src/net/net.4dm", 76, 82, "Text", "T:p_session T:p_id",
                              "Text net_log_name(Text p_session, Text p_id)", 0, "", "");
  if (p_id == 347) test_info_set(p_info, "net_ensure_folder", "macro", "net", "net", "src/net/net.4dm", 84, 96, "Integer", "T:p_folder",
                              "Integer net_ensure_folder(Text p_folder)", 1, "", "");
  if (p_id == 348) test_info_set(p_info, "net_write_session", "macro", "net", "net", "src/net/net.4dm", 98, 114, "Integer", "T:p_folder T:p_session T:p_host_id I:p_seed T:p_world_name",
                              "Integer net_write_session(Text p_folder, Text p_session, Text p_host_id, Integer p_seed, Text p_world_name)", 1, "", "net_session_path");
  if (p_id == 349) test_info_set(p_info, "net_read_session", "macro", "net", "net", "src/net/net.4dm", 116, 166, "Integer", "T:p_folder &T:p_session &T:p_host_id &I:p_seed &T:p_world_name &T:p_problem",
                              "Integer net_read_session(Text p_folder, Text &p_session, Text &p_host_id, Integer &p_seed, Text &p_world_name, Text &p_problem)", 0, "", "net_rest_of_line, net_session_path, net_snapshot_path, net_word_integer");
  if (p_id == 350) test_info_set(p_info, "net_start", "macro", "net", "net", "src/net/net.4dm", 168, 190, "void", "&A:p_net &A:p_peers &A:p_inbox I:p_mode T:p_folder T:p_session T:p_host_id T:p_id T:p_name R:p_now",
                              "void net_start(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Integer p_mode, Text p_folder, Text p_session, Text p_host_id, Text p_id, Text p_name, Real p_now)", 1, "", "net_clear, net_flush, net_log_name, net_queue, record_set_integer, record_set_real, record_set_text");
  if (p_id == 351) test_info_set(p_info, "net_queue", "macro", "net", "net", "src/net/net.4dm", 194, 205, "void", "&A:p_net T:p_line",
                              "void net_queue(Attributes &p_net, Text p_line)", 0, "", "net_mode, record_integer, record_set_integer, record_set_text_at");
  if (p_id == 352) test_info_set(p_info, "net_flush", "macro", "net", "net", "src/net/net.4dm", 207, 232, "Integer", "&A:p_net",
                              "Integer net_flush(Attributes &p_net)", 1, "", "net_log_name, net_mode, record_integer, record_set_integer, record_set_text, record_text, record_text_at");
  if (p_id == 353) test_info_set(p_info, "net_leave", "macro", "net", "net", "src/net/net.4dm", 234, 243, "void", "&A:p_net",
                              "void net_leave(Attributes &p_net)", 1, "", "net_flush, net_mode, net_queue, record_set_integer");
  if (p_id == 354) test_info_set(p_info, "net_say", "macro", "net", "net", "src/net/net.4dm", 245, 251, "void", "&A:p_net T:p_text",
                              "void net_say(Attributes &p_net, Text p_text)", 0, "", "net_queue");
  if (p_id == 355) test_info_set(p_info, "net_send_state", "macro", "net", "net", "src/net/net.4dm", 253, 295, "void", "&A:p_net &A:p_player &A:p_info R:p_now",
                              "void net_send_state(Attributes &p_net, Attributes &p_player, Attributes &p_info, Real p_now)", 0, "", "net_mode, net_queue, player_look, player_position, record_real, record_set_real, world_time_of_day");
  if (p_id == 356) test_info_set(p_info, "net_on_event", "macro", "net", "net", "src/net/net.4dm", 297, 312, "void", "&A:p_event &A:p_net",
                              "void net_on_event(Attributes &p_event, Attributes &p_net)", 0, "", "event_integer, event_is_remote, event_type, net_mode, net_queue, world_get_block");
  if (p_id == 357) test_info_set(p_info, "net_find_peer", "macro", "net", "net", "src/net/net.4dm", 316, 327, "Integer", "&A:p_peers T:p_file",
                              "Integer net_find_peer(Attributes &p_peers, Text p_file)", 0, "", "peers_count, record_text_at");
  if (p_id == 358) test_info_set(p_info, "net_add_peer", "macro", "net", "net", "src/net/net.4dm", 329, 355, "Integer", "&A:p_peers T:p_file R:p_now",
                              "Integer net_add_peer(Attributes &p_peers, Text p_file, Real p_now)", 0, "", "peers_count, record_set_integer, record_set_integer_at, record_set_real_at, record_set_text_at");
  if (p_id == 359) test_info_set(p_info, "net_scan", "macro", "net", "net", "src/net/net.4dm", 357, 381, "void", "&A:p_net &A:p_peers R:p_now",
                              "void net_scan(Attributes &p_net, Attributes &p_peers, Real p_now)", 0, "", "file_title_from_path, net_add_peer, net_find_peer, net_log_name, record_text");
  if (p_id == 360) test_info_set(p_info, "net_inbox_add", "macro", "net", "net", "src/net/net.4dm", 383, 393, "void", "&A:p_inbox I:p_peer T:p_line",
                              "void net_inbox_add(Attributes &p_inbox, Integer p_peer, Text p_line)", 0, "", "record_integer, record_set_integer, record_set_integer_at, record_set_text_at");
}

void test_registry_call_9(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 321 to 360 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 321) {   // cow_yaw
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = cow_yaw(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 322) {   // cow_flash
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = cow_flash(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 323) {   // cow_step
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = cow_step(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 324) {   // cows_alive_count
    Get_time(l_start);
    l_ret_i = cows_alive_count(g_cows);
    Get_time(l_end);
  } else if (p_id == 325) {   // mob_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = mob_kind(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 326) {   // mob_half_width
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = mob_half_width(l_i1);
    Get_time(l_end);
  } else if (p_id == 327) {   // mob_height
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = mob_height(l_i1);
    Get_time(l_end);
  } else if (p_id == 328) {   // mobs_count_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = mobs_count_kind(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 329) {   // cows_spawn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = cows_spawn(g_cows, g_random, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 330) {   // mobs_spawn
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = mobs_spawn(g_cows, g_random, l_i1, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 331) {   // cows_spawn_random
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_i = cows_spawn_random(g_cows, g_random, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 332) {   // mobs_spawn_random
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_i = mobs_spawn_random(g_cows, g_random, l_i1, l_i2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 333) {   // zombies_spawn_near
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = zombies_spawn_near(g_cows, g_random, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 334) {   // zombie_sunlight
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    zombie_sunlight(g_cows, g_events, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 335) {   // cow_update
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    cow_update(g_cows, g_random, g_events, l_i1, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 336) {   // cows_update
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    cows_update(g_cows, g_random, g_events, l_r1, l_r2, l_r3, l_i1, l_i2, l_r4);
    Get_time(l_end);
  } else if (p_id == 337) {   // cows_ray_hit
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    Get_time(l_start);
    l_ret_i = cows_ray_hit(g_cows, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R8, l_r8);
  } else if (p_id == 338) {   // cow_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    cow_damage(g_cows, g_events, g_random, l_i1, l_i2, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 339) {   // cows_box_overlaps
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    l_ret_i = cows_box_overlaps(g_cows, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
  } else if (p_id == 340) {   // cows_on_event
    Get_time(l_start);
    cows_on_event(g_event, g_cows, g_random, g_events);
    Get_time(l_end);
  } else if (p_id == 341) {   // net_clear
    Get_time(l_start);
    net_clear(g_net, g_peers, g_net_inbox);
    Get_time(l_end);
  } else if (p_id == 342) {   // net_mode
    Get_time(l_start);
    l_ret_i = net_mode(g_net);
    Get_time(l_end);
  } else if (p_id == 343) {   // net_clean_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = net_clean_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 344) {   // net_session_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = net_session_path(l_t1);
    Get_time(l_end);
  } else if (p_id == 345) {   // net_snapshot_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = net_snapshot_path(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 346) {   // net_log_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = net_log_name(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 347) {   // net_ensure_folder
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = net_ensure_folder(l_t1);
    Get_time(l_end);
  } else if (p_id == 348) {   // net_write_session
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    Get_time(l_start);
    l_ret_i = net_write_session(l_t1, l_t2, l_t3, l_i1, l_t4);
    Get_time(l_end);
  } else if (p_id == 349) {   // net_read_session
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    Get_time(l_start);
    l_ret_i = net_read_session(l_t1, l_t2, l_t3, l_i1, l_t4, l_t5);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_text(p_out, ATTR_TEST_T4, l_t4);
    record_set_text(p_out, ATTR_TEST_T5, l_t5);
  } else if (p_id == 350) {   // net_start
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_start(g_net, g_peers, g_net_inbox, l_i1, l_t1, l_t2, l_t3, l_t4, l_t5, l_r1);
    Get_time(l_end);
  } else if (p_id == 351) {   // net_queue
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    net_queue(g_net, l_t1);
    Get_time(l_end);
  } else if (p_id == 352) {   // net_flush
    Get_time(l_start);
    l_ret_i = net_flush(g_net);
    Get_time(l_end);
  } else if (p_id == 353) {   // net_leave
    Get_time(l_start);
    net_leave(g_net);
    Get_time(l_end);
  } else if (p_id == 354) {   // net_say
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    net_say(g_net, l_t1);
    Get_time(l_end);
  } else if (p_id == 355) {   // net_send_state
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_send_state(g_net, g_player, g_info, l_r1);
    Get_time(l_end);
  } else if (p_id == 356) {   // net_on_event
    Get_time(l_start);
    net_on_event(g_event, g_net);
    Get_time(l_end);
  } else if (p_id == 357) {   // net_find_peer
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = net_find_peer(g_peers, l_t1);
    Get_time(l_end);
  } else if (p_id == 358) {   // net_add_peer
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = net_add_peer(g_peers, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 359) {   // net_scan
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_scan(g_net, g_peers, l_r1);
    Get_time(l_end);
  } else if (p_id == 360) {   // net_inbox_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    net_inbox_add(g_net_inbox, l_i1, l_t1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_10(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 361 to 400 are
// ----------------------------------------------------------------
{
  if (p_id == 361) test_info_set(p_info, "net_read_peer", "macro", "net", "net", "src/net/net.4dm", 395, 426, "Integer", "&A:p_net &A:p_peers &A:p_inbox I:p_peer",
                              "Integer net_read_peer(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Integer p_peer)", 0, "", "net_inbox_add, record_integer_at, record_set_integer_at, record_text, record_text_at");
  if (p_id == 362) test_info_set(p_info, "net_poll", "macro", "net", "net", "src/net/net.4dm", 428, 445, "void", "&A:p_net &A:p_peers &A:p_inbox R:p_now",
                              "void net_poll(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Real p_now)", 0, "", "net_mode, net_read_peer, net_scan, peers_count, record_real, record_set_real");
  if (p_id == 363) test_info_set(p_info, "net_word_real", "macro", "net", "net", "src/net/net.4dm", 449, 464, "Real", "&D:p_words I:p_position",
                              "Real net_word_real(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 364) test_info_set(p_info, "net_word_integer", "macro", "net", "net", "src/net/net.4dm", 466, 481, "Integer", "&D:p_words I:p_position",
                              "Integer net_word_integer(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 365) test_info_set(p_info, "net_rest_of_line", "macro", "net", "net", "src/net/net.4dm", 483, 493, "Text", "T:p_line",
                              "Text net_rest_of_line(Text p_line)", 0, "", "");
  if (p_id == 366) test_info_set(p_info, "net_apply_line", "macro", "net", "net", "src/net/net.4dm", 495, 546, "void", "&A:p_net &A:p_peers I:p_peer T:p_line &A:p_info &A:p_hud &A:p_events R:p_now",
                              "void net_apply_line(Attributes &p_net, Attributes &p_peers, Integer p_peer, Text p_line, Attributes &p_info, Attributes &p_hud, Attributes &p_events, Real p_now)", 0, "", "hud_chat, hud_toast, net_clean_name, net_rest_of_line, net_word_integer, net_word_real, peer_here, peer_name, record_real_at, record_set_integer_at, record_set_real_at, record_set_text_at, record_text, record_text_at, world_apply_remote_block, world_set_time_of_day");
  if (p_id == 367) test_info_set(p_info, "net_apply", "macro", "net", "net", "src/net/net.4dm", 548, 588, "void", "&A:p_net &A:p_peers &A:p_inbox &A:p_info &A:p_hud &A:p_events R:p_dt R:p_now",
                              "void net_apply(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Attributes &p_info, Attributes &p_hud, Attributes &p_events, Real p_dt, Real p_now)", 0, "", "hud_chat, min_real, net_apply_line, peer_here, peer_name, peer_position, peer_step, peers_count, record_clear, record_integer, record_integer_at, record_real_at, record_set_integer, record_set_integer_at, record_set_real_at, record_text_at");
  if (p_id == 368) test_info_set(p_info, "peers_count", "macro", "net", "net", "src/net/net.4dm", 592, 598, "Integer", "&A:p_peers",
                              "Integer peers_count(Attributes &p_peers)", 0, "", "record_integer");
  if (p_id == 369) test_info_set(p_info, "peer_here", "macro", "net", "net", "src/net/net.4dm", 600, 606, "Integer", "&A:p_peers I:p_peer",
                              "Integer peer_here(Attributes &p_peers, Integer p_peer)", 0, "", "record_integer_at");
  if (p_id == 370) test_info_set(p_info, "peer_name", "macro", "net", "net", "src/net/net.4dm", 608, 614, "Text", "&A:p_peers I:p_peer",
                              "Text peer_name(Attributes &p_peers, Integer p_peer)", 0, "", "record_text_at");
  if (p_id == 371) test_info_set(p_info, "peer_position", "macro", "net", "net", "src/net/net.4dm", 616, 624, "void", "&A:p_peers I:p_peer &R:p_x &R:p_y &R:p_z",
                              "void peer_position(Attributes &p_peers, Integer p_peer, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real_at");
  if (p_id == 372) test_info_set(p_info, "peer_yaw", "macro", "net", "net", "src/net/net.4dm", 626, 632, "Real", "&A:p_peers I:p_peer",
                              "Real peer_yaw(Attributes &p_peers, Integer p_peer)", 0, "", "record_real_at");
  if (p_id == 373) test_info_set(p_info, "peer_pitch", "macro", "net", "net", "src/net/net.4dm", 634, 640, "Real", "&A:p_peers I:p_peer",
                              "Real peer_pitch(Attributes &p_peers, Integer p_peer)", 0, "", "record_real_at");
  if (p_id == 374) test_info_set(p_info, "peer_step", "macro", "net", "net", "src/net/net.4dm", 642, 648, "Real", "&A:p_peers I:p_peer",
                              "Real peer_step(Attributes &p_peers, Integer p_peer)", 0, "", "record_real_at");
  if (p_id == 375) test_info_set(p_info, "net_players_text", "macro", "net", "net", "src/net/net.4dm", 650, 672, "Text", "&A:p_net &A:p_peers R:p_now",
                              "Text net_players_text(Attributes &p_net, Attributes &p_peers, Real p_now)", 0, "", "net_mode, peer_here, peer_name, peers_count, record_real_at, record_text");
  if (p_id == 376) test_info_set(p_info, "player_reset", "macro", "player", "player", "src/player/player.4dm", 18, 74, "void", "&A:p_player R:p_x R:p_y R:p_z",
                              "void player_reset(Attributes &p_player, Real p_x, Real p_y, Real p_z)", 0, "", "player_set_auto_walk, player_set_fall_peak, player_set_health, player_set_look, player_set_position, player_set_selected, player_set_velocity, record_clear, record_integer, record_real, record_set_integer, record_set_real, record_set_text");
  if (p_id == 377) test_info_set(p_info, "player_position", "macro", "player", "player", "src/player/player.4dm", 76, 84, "void", "&A:p_player &R:p_x &R:p_y &R:p_z",
                              "void player_position(Attributes &p_player, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real");
  if (p_id == 378) test_info_set(p_info, "player_set_position", "macro", "player", "player", "src/player/player.4dm", 86, 94, "void", "&A:p_player R:p_x R:p_y R:p_z",
                              "void player_set_position(Attributes &p_player, Real p_x, Real p_y, Real p_z)", 0, "", "record_set_real");
  if (p_id == 379) test_info_set(p_info, "player_velocity", "macro", "player", "player", "src/player/player.4dm", 96, 104, "void", "&A:p_player &R:p_vx &R:p_vy &R:p_vz",
                              "void player_velocity(Attributes &p_player, Real &p_vx, Real &p_vy, Real &p_vz)", 0, "", "record_real");
  if (p_id == 380) test_info_set(p_info, "player_set_velocity", "macro", "player", "player", "src/player/player.4dm", 106, 114, "void", "&A:p_player R:p_vx R:p_vy R:p_vz",
                              "void player_set_velocity(Attributes &p_player, Real p_vx, Real p_vy, Real p_vz)", 0, "", "record_set_real");
  if (p_id == 381) test_info_set(p_info, "player_look", "macro", "player", "player", "src/player/player.4dm", 116, 123, "void", "&A:p_player &R:p_yaw &R:p_pitch",
                              "void player_look(Attributes &p_player, Real &p_yaw, Real &p_pitch)", 0, "", "record_real");
  if (p_id == 382) test_info_set(p_info, "player_set_look", "macro", "player", "player", "src/player/player.4dm", 125, 132, "void", "&A:p_player R:p_yaw R:p_pitch",
                              "void player_set_look(Attributes &p_player, Real p_yaw, Real p_pitch)", 0, "", "record_set_real");
  if (p_id == 383) test_info_set(p_info, "player_eye_y", "macro", "player", "player", "src/player/player.4dm", 134, 141, "Real", "&A:p_player",
                              "Real player_eye_y(Attributes &p_player)", 0, "", "player_crouching, record_real");
  if (p_id == 384) test_info_set(p_info, "player_crouching", "macro", "player", "player", "src/player/player.4dm", 143, 150, "Integer", "&A:p_player",
                              "Integer player_crouching(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 385) test_info_set(p_info, "player_look_direction", "macro", "player", "player", "src/player/player.4dm", 152, 164, "void", "&A:p_player &R:p_dir_x &R:p_dir_y &R:p_dir_z",
                              "void player_look_direction(Attributes &p_player, Real &p_dir_x, Real &p_dir_y, Real &p_dir_z)", 0, "", "player_look");
  if (p_id == 386) test_info_set(p_info, "player_health", "macro", "player", "player", "src/player/player.4dm", 166, 172, "Integer", "&A:p_player",
                              "Integer player_health(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 387) test_info_set(p_info, "player_set_health", "macro", "player", "player", "src/player/player.4dm", 174, 180, "void", "&A:p_player I:p_health",
                              "void player_set_health(Attributes &p_player, Integer p_health)", 0, "", "clamp_integer, record_set_integer");
  if (p_id == 388) test_info_set(p_info, "player_is_dead", "macro", "player", "player", "src/player/player.4dm", 182, 188, "Integer", "&A:p_player",
                              "Integer player_is_dead(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 389) test_info_set(p_info, "player_on_ground", "macro", "player", "player", "src/player/player.4dm", 190, 196, "Integer", "&A:p_player",
                              "Integer player_on_ground(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 390) test_info_set(p_info, "player_in_water", "macro", "player", "player", "src/player/player.4dm", 198, 204, "Integer", "&A:p_player",
                              "Integer player_in_water(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 391) test_info_set(p_info, "player_eye_in_water", "macro", "player", "player", "src/player/player.4dm", 206, 212, "Integer", "&A:p_player",
                              "Integer player_eye_in_water(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 392) test_info_set(p_info, "player_hurt_time", "macro", "player", "player", "src/player/player.4dm", 214, 220, "Real", "&A:p_player",
                              "Real player_hurt_time(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 393) test_info_set(p_info, "player_swing_time", "macro", "player", "player", "src/player/player.4dm", 222, 228, "Real", "&A:p_player",
                              "Real player_swing_time(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 394) test_info_set(p_info, "player_bob", "macro", "player", "player", "src/player/player.4dm", 230, 236, "Real", "&A:p_player",
                              "Real player_bob(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 395) test_info_set(p_info, "player_body_yaw", "macro", "player", "player", "src/player/player.4dm", 238, 244, "Real", "&A:p_player",
                              "Real player_body_yaw(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 396) test_info_set(p_info, "player_stride", "macro", "player", "player", "src/player/player.4dm", 246, 252, "Real", "&A:p_player",
                              "Real player_stride(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 397) test_info_set(p_info, "player_update_body", "macro", "player", "player", "src/player/player.4dm", 254, 280, "void", "&A:p_player I:p_walking R:p_dt",
                              "void player_update_body(Attributes &p_player, Integer p_walking, Real p_dt)", 0, "", "min_real, player_look, record_real, record_set_real, wrap_angle");
  if (p_id == 398) test_info_set(p_info, "player_fall_peak", "macro", "player", "player", "src/player/player.4dm", 282, 288, "Real", "&A:p_player",
                              "Real player_fall_peak(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 399) test_info_set(p_info, "player_set_fall_peak", "macro", "player", "player", "src/player/player.4dm", 290, 296, "void", "&A:p_player R:p_peak",
                              "void player_set_fall_peak(Attributes &p_player, Real p_peak)", 0, "", "record_set_real");
  if (p_id == 400) test_info_set(p_info, "player_selected", "macro", "player", "player", "src/player/player.4dm", 298, 304, "Integer", "&A:p_player",
                              "Integer player_selected(Attributes &p_player)", 0, "", "record_integer");
}

void test_registry_call_10(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 361 to 400 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 361) {   // net_read_peer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = net_read_peer(g_net, g_peers, g_net_inbox, l_i1);
    Get_time(l_end);
  } else if (p_id == 362) {   // net_poll
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_poll(g_net, g_peers, g_net_inbox, l_r1);
    Get_time(l_end);
  } else if (p_id == 363) {   // net_word_real
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = net_word_real(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 364) {   // net_word_integer
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = net_word_integer(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 365) {   // net_rest_of_line
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = net_rest_of_line(l_t1);
    Get_time(l_end);
  } else if (p_id == 366) {   // net_apply_line
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_apply_line(g_net, g_peers, l_i1, l_t1, g_info, g_hud, g_events, l_r1);
    Get_time(l_end);
  } else if (p_id == 367) {   // net_apply
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    net_apply(g_net, g_peers, g_net_inbox, g_info, g_hud, g_events, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 368) {   // peers_count
    Get_time(l_start);
    l_ret_i = peers_count(g_peers);
    Get_time(l_end);
  } else if (p_id == 369) {   // peer_here
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = peer_here(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 370) {   // peer_name
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = peer_name(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 371) {   // peer_position
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    peer_position(g_peers, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 372) {   // peer_yaw
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = peer_yaw(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 373) {   // peer_pitch
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = peer_pitch(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 374) {   // peer_step
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = peer_step(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 375) {   // net_players_text
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_t = net_players_text(g_net, g_peers, l_r1);
    Get_time(l_end);
  } else if (p_id == 376) {   // player_reset
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_reset(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 377) {   // player_position
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_position(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 378) {   // player_set_position
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_set_position(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 379) {   // player_velocity
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_velocity(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 380) {   // player_set_velocity
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_set_velocity(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 381) {   // player_look
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    player_look(g_player, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 382) {   // player_set_look
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    player_set_look(g_player, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 383) {   // player_eye_y
    Get_time(l_start);
    l_ret_r = player_eye_y(g_player);
    Get_time(l_end);
  } else if (p_id == 384) {   // player_crouching
    Get_time(l_start);
    l_ret_i = player_crouching(g_player);
    Get_time(l_end);
  } else if (p_id == 385) {   // player_look_direction
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_look_direction(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 386) {   // player_health
    Get_time(l_start);
    l_ret_i = player_health(g_player);
    Get_time(l_end);
  } else if (p_id == 387) {   // player_set_health
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_health(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 388) {   // player_is_dead
    Get_time(l_start);
    l_ret_i = player_is_dead(g_player);
    Get_time(l_end);
  } else if (p_id == 389) {   // player_on_ground
    Get_time(l_start);
    l_ret_i = player_on_ground(g_player);
    Get_time(l_end);
  } else if (p_id == 390) {   // player_in_water
    Get_time(l_start);
    l_ret_i = player_in_water(g_player);
    Get_time(l_end);
  } else if (p_id == 391) {   // player_eye_in_water
    Get_time(l_start);
    l_ret_i = player_eye_in_water(g_player);
    Get_time(l_end);
  } else if (p_id == 392) {   // player_hurt_time
    Get_time(l_start);
    l_ret_r = player_hurt_time(g_player);
    Get_time(l_end);
  } else if (p_id == 393) {   // player_swing_time
    Get_time(l_start);
    l_ret_r = player_swing_time(g_player);
    Get_time(l_end);
  } else if (p_id == 394) {   // player_bob
    Get_time(l_start);
    l_ret_r = player_bob(g_player);
    Get_time(l_end);
  } else if (p_id == 395) {   // player_body_yaw
    Get_time(l_start);
    l_ret_r = player_body_yaw(g_player);
    Get_time(l_end);
  } else if (p_id == 396) {   // player_stride
    Get_time(l_start);
    l_ret_r = player_stride(g_player);
    Get_time(l_end);
  } else if (p_id == 397) {   // player_update_body
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_update_body(g_player, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 398) {   // player_fall_peak
    Get_time(l_start);
    l_ret_r = player_fall_peak(g_player);
    Get_time(l_end);
  } else if (p_id == 399) {   // player_set_fall_peak
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_set_fall_peak(g_player, l_r1);
    Get_time(l_end);
  } else if (p_id == 400) {   // player_selected
    Get_time(l_start);
    l_ret_i = player_selected(g_player);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_11(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 401 to 440 are
// ----------------------------------------------------------------
{
  if (p_id == 401) test_info_set(p_info, "player_set_selected", "macro", "player", "player", "src/player/player.4dm", 306, 312, "void", "&A:p_player I:p_slot",
                              "void player_set_selected(Attributes &p_player, Integer p_slot)", 0, "", "clamp_integer, record_set_integer");
  if (p_id == 402) test_info_set(p_info, "player_auto_walk", "macro", "player", "player", "src/player/player.4dm", 314, 320, "Integer", "&A:p_player",
                              "Integer player_auto_walk(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 403) test_info_set(p_info, "player_set_auto_walk", "macro", "player", "player", "src/player/player.4dm", 322, 328, "void", "&A:p_player I:p_on",
                              "void player_set_auto_walk(Attributes &p_player, Integer p_on)", 0, "", "record_set_integer");
  if (p_id == 404) test_info_set(p_info, "player_held_item", "macro", "player", "player", "src/player/player.4dm", 330, 336, "Integer", "&A:p_player &A:p_inventory",
                              "Integer player_held_item(Attributes &p_player, Attributes &p_inventory)", 0, "", "player_selected, slot_item");
  if (p_id == 405) test_info_set(p_info, "player_target_kind", "macro", "player", "player", "src/player/player.4dm", 338, 344, "Integer", "&A:p_player",
                              "Integer player_target_kind(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 406) test_info_set(p_info, "player_target_cell", "macro", "player", "player", "src/player/player.4dm", 346, 354, "void", "&A:p_player &I:p_x &I:p_y &I:p_z",
                              "void player_target_cell(Attributes &p_player, Integer &p_x, Integer &p_y, Integer &p_z)", 0, "", "record_integer");
  if (p_id == 407) test_info_set(p_info, "player_target_normal", "macro", "player", "player", "src/player/player.4dm", 356, 364, "void", "&A:p_player &I:p_x &I:p_y &I:p_z",
                              "void player_target_normal(Attributes &p_player, Integer &p_x, Integer &p_y, Integer &p_z)", 0, "", "record_integer");
  if (p_id == 408) test_info_set(p_info, "player_target_cow", "macro", "player", "player", "src/player/player.4dm", 366, 372, "Integer", "&A:p_player",
                              "Integer player_target_cow(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 409) test_info_set(p_info, "player_break_stage", "macro", "player", "player", "src/player/player.4dm", 374, 388, "Integer", "&A:p_player R:p_now",
                              "Integer player_break_stage(Attributes &p_player, Real p_now)", 0, "", "clamp_integer, floor_integer, record_integer, record_real");
  if (p_id == 410) test_info_set(p_info, "player_turn", "macro", "player", "player", "src/player/player.4dm", 392, 402, "void", "&A:p_player R:p_yaw_change R:p_pitch_change",
                              "void player_turn(Attributes &p_player, Real p_yaw_change, Real p_pitch_change)", 0, "", "clamp_real, player_look, player_set_look, wrap_angle");
  if (p_id == 411) test_info_set(p_info, "player_on_event", "macro", "player", "player", "src/player/player.4dm", 404, 424, "void", "&A:p_event &A:p_player &A:p_inventory &A:p_events",
                              "void player_on_event(Attributes &p_event, Attributes &p_player, Attributes &p_inventory, Attributes &p_events)", 0, "", "event_integer, event_real, event_type, inventory_armour_damage, inventory_wear_armour, player_damage, player_is_dead, player_set_velocity, player_survival, player_velocity");
  if (p_id == 412) test_info_set(p_info, "player_camera", "macro", "player", "player", "src/player/player.4dm", 426, 433, "Integer", "&A:p_player",
                              "Integer player_camera(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 413) test_info_set(p_info, "player_next_camera", "macro", "player", "player", "src/player/player.4dm", 435, 441, "void", "&A:p_player",
                              "void player_next_camera(Attributes &p_player)", 0, "", "player_camera, positive_mod, record_set_integer");
  if (p_id == 414) test_info_set(p_info, "player_flying", "macro", "player", "player", "src/player/player.4dm", 443, 451, "Integer", "&A:p_player",
                              "Integer player_flying(Attributes &p_player)", 0, "", "player_spectator, record_integer");
  if (p_id == 415) test_info_set(p_info, "player_set_flying", "macro", "player", "player", "src/player/player.4dm", 453, 465, "void", "&A:p_player I:p_flying",
                              "void player_set_flying(Attributes &p_player, Integer p_flying)", 0, "", "player_position, player_set_fall_peak, record_set_integer");
  if (p_id == 416) test_info_set(p_info, "player_game_mode", "macro", "player", "player", "src/player/player.4dm", 467, 476, "Integer", "&A:p_player",
                              "Integer player_game_mode(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 417) test_info_set(p_info, "player_set_game_mode", "macro", "player", "player", "src/player/player.4dm", 478, 499, "void", "&A:p_player I:p_mode",
                              "void player_set_game_mode(Attributes &p_player, Integer p_mode)", 0, "", "player_game_mode, player_set_flying, player_set_health, record_set_integer");
  if (p_id == 418) test_info_set(p_info, "player_creative", "macro", "player", "player", "src/player/player.4dm", 501, 508, "Integer", "&A:p_player",
                              "Integer player_creative(Attributes &p_player)", 0, "", "player_game_mode");
  if (p_id == 419) test_info_set(p_info, "player_spectator", "macro", "player", "player", "src/player/player.4dm", 510, 517, "Integer", "&A:p_player",
                              "Integer player_spectator(Attributes &p_player)", 0, "", "player_game_mode");
  if (p_id == 420) test_info_set(p_info, "player_survival", "macro", "player", "player", "src/player/player.4dm", 519, 525, "Integer", "&A:p_player",
                              "Integer player_survival(Attributes &p_player)", 0, "", "player_game_mode");
  if (p_id == 421) test_info_set(p_info, "player_game_mode_name", "macro", "player", "player", "src/player/player.4dm", 527, 535, "Text", "I:p_mode",
                              "Text player_game_mode_name(Integer p_mode)", 0, "", "");
  if (p_id == 422) test_info_set(p_info, "player_pick_block", "macro", "player", "player", "src/player/player.4dm", 537, 579, "Integer", "&A:p_player &A:p_inventory &T:p_report",
                              "Integer player_pick_block(Attributes &p_player, Attributes &p_inventory, Text &p_report)", 0, "", "block_pick_item, item_max_stack, item_name, player_creative, player_selected, player_set_selected, player_target_cell, player_target_kind, slot_item, slot_set, slot_swap, world_get_block");
  if (p_id == 423) test_info_set(p_info, "player_key_pressed", "macro", "player", "player", "src/player/player.4dm", 581, 637, "void", "&A:p_player T:p_key R:p_now",
                              "void player_key_pressed(Attributes &p_player, Text p_key, Real p_now)", 0, "", "max_real, player_creative, player_flying, player_set_auto_walk, player_set_flying, record_integer, record_real, record_set_integer, record_set_real, record_set_text, record_text");
  if (p_id == 424) test_info_set(p_info, "player_shift_pressed", "macro", "player", "player", "src/player/player.4dm", 639, 651, "void", "&A:p_player R:p_now",
                              "void player_shift_pressed(Attributes &p_player, Real p_now)", 0, "", "player_flying, record_set_real");
  if (p_id == 425) test_info_set(p_info, "player_key_active", "macro", "player", "player", "src/player/player.4dm", 653, 660, "Integer", "&A:p_player T:p_key R:p_now",
                              "Integer player_key_active(Attributes &p_player, Text p_key, Real p_now)", 0, "", "record_real, record_text");
  if (p_id == 426) test_info_set(p_info, "player_damage", "macro", "player", "player", "src/player/player.4dm", 662, 681, "void", "&A:p_player &A:p_events I:p_amount",
                              "void player_damage(Attributes &p_player, Attributes &p_events, Integer p_amount)", 0, "", "emit_item_event, emit_simple_event, player_health, player_is_dead, player_set_health, player_survival, record_set_integer, record_set_real");
  if (p_id == 427) test_info_set(p_info, "player_update", "macro", "player", "player", "src/player/player.4dm", 683, 927, "void", "&A:p_player &A:p_cows &A:p_events I:p_auto_jump R:p_dt R:p_now",
                              "void player_update(Attributes &p_player, Attributes &p_cows, Attributes &p_events, Integer p_auto_jump, Real p_dt, Real p_now)", 0, "", "clamp_real, floor_integer, max_real, min_real, physics_box_collides, physics_box_in_water, physics_move_box, player_auto_walk, player_bob, player_damage, player_fall_peak, player_flying, player_health, player_hurt_time, player_in_water, player_is_dead, player_key_active, player_look, player_on_ground, player_position, player_set_fall_peak, player_set_flying, player_set_health, player_set_position, player_set_velocity, player_spectator, player_swing_time, player_update_body, player_update_target, player_velocity, record_integer, record_real, record_set_integer, record_set_real, world_get_block");
  if (p_id == 428) test_info_set(p_info, "player_update_target", "macro", "player", "player", "src/player/player.4dm", 929, 979, "void", "&A:p_player &A:p_cows",
                              "void player_update_target(Attributes &p_player, Attributes &p_cows)", 0, "", "cows_ray_hit, physics_raycast_blocks, player_eye_y, player_look_direction, player_spectator, record_real, record_set_integer");
  if (p_id == 429) test_info_set(p_info, "player_overlaps_cell", "macro", "player", "player", "src/player/player.4dm", 981, 995, "Integer", "&A:p_player I:p_x I:p_y I:p_z",
                              "Integer player_overlaps_cell(Attributes &p_player, Integer p_x, Integer p_y, Integer p_z)", 0, "", "player_position");
  if (p_id == 430) test_info_set(p_info, "player_wear_tool", "macro", "player", "player", "src/player/player.4dm", 997, 1008, "void", "&A:p_player &A:p_inventory &A:p_events",
                              "void player_wear_tool(Attributes &p_player, Attributes &p_inventory, Attributes &p_events)", 0, "", "emit_toast, item_name, player_selected, slot_item, slot_wear");
  if (p_id == 431) test_info_set(p_info, "player_primary_action", "macro", "player", "player", "src/player/player.4dm", 1010, 1074, "void", "&A:p_player &A:p_inventory &A:p_cows &A:p_events &A:p_random R:p_now",
                              "void player_primary_action(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Attributes &p_random, Real p_now)", 0, "", "block_hits_with, block_needs_tool, block_tool_kind, cow_damage, emit_toast, item_attack_damage, item_tool_kind, player_held_item, player_is_dead, player_look, player_spectator, player_target_cell, player_target_cow, player_target_kind, player_update_target, player_wear_tool, record_integer, record_real, record_set_integer, record_set_real, world_break_block, world_get_block");
  if (p_id == 432) test_info_set(p_info, "player_look_facing", "macro", "player", "player", "src/player/player.4dm", 1076, 1095, "Integer", "&A:p_player",
                              "Integer player_look_facing(Attributes &p_player)", 0, "", "player_look");
  if (p_id == 433) test_info_set(p_info, "player_cell_free", "macro", "player", "player", "src/player/player.4dm", 1097, 1111, "Integer", "&A:p_player &A:p_cows I:p_x I:p_y I:p_z",
                              "Integer player_cell_free(Attributes &p_player, Attributes &p_cows, Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_is_plant, cows_box_overlaps, player_overlaps_cell, world_get_block, world_in_bounds");
  if (p_id == 434) test_info_set(p_info, "player_place_double", "macro", "player", "player", "src/player/player.4dm", 1113, 1148, "Integer", "&A:p_player &A:p_cows &A:p_events I:p_item I:p_x I:p_y I:p_z",
                              "Integer player_place_double(Attributes &p_player, Attributes &p_cows, Attributes &p_events, Integer p_item, Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_bed, block_door, block_facing_step, emit_toast, player_cell_free, player_look_facing, world_is_solid, world_place_block");
  if (p_id == 435) test_info_set(p_info, "player_toggle_door", "macro", "player", "player", "src/player/player.4dm", 1150, 1167, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_block",
                              "void player_toggle_door(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "block_door, block_door_facing, block_door_open, block_door_top, block_is_door, block_partner, world_get_block, world_place_block");
  if (p_id == 436) test_info_set(p_info, "player_furnace_facing", "macro", "player", "player", "src/player/player.4dm", 1169, 1183, "Integer", "R:p_player_x R:p_player_z I:p_cell_x I:p_cell_z",
                              "Integer player_furnace_facing(Real p_player_x, Real p_player_z, Integer p_cell_x, Integer p_cell_z)", 0, "", "");
  if (p_id == 437) test_info_set(p_info, "player_use_slot", "macro", "player", "player", "src/player/player.4dm", 1185, 1304, "Integer", "&A:p_player &A:p_inventory &A:p_cows &A:p_events I:p_slot",
                              "Integer player_use_slot(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Integer p_slot)", 0, "", "block_is_plant, cows_box_overlaps, emit_event, emit_item_event, emit_toast, floor_integer, inventory_equip, item_armour_place, item_food_value, item_places_block, item_spawn_egg_mob, player_creative, player_furnace_facing, player_health, player_look, player_overlaps_cell, player_place_double, player_position, player_set_health, player_target_cell, player_target_kind, player_target_normal, player_update_target, record_set_real, slot_item, slot_take_one, world_get_block, world_in_bounds, world_is_solid, world_place_block, wrap_angle");
  if (p_id == 438) test_info_set(p_info, "player_secondary_action", "macro", "player", "player", "src/player/player.4dm", 1306, 1351, "void", "&A:p_player &A:p_inventory &A:p_cows &A:p_events R:p_now",
                              "void player_secondary_action(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Real p_now)", 0, "", "block_is_bed, block_is_door, block_is_furnace, emit_event, player_is_dead, player_selected, player_spectator, player_target_cell, player_target_kind, player_toggle_door, player_update_target, player_use_slot, record_set_real, world_get_block");
  if (p_id == 439) test_info_set(p_info, "command_word", "macro", "program", "commands", "src/program/commands.4dm", 13, 22, "Text", "&D:p_words I:p_position",
                              "Text command_word(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 440) test_info_set(p_info, "command_item_key", "macro", "program", "commands", "src/program/commands.4dm", 24, 44, "Text", "T:p_name",
                              "Text command_item_key(Text p_name)", 0, "", "");
}

void test_registry_call_11(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 401 to 440 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 401) {   // player_set_selected
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_selected(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 402) {   // player_auto_walk
    Get_time(l_start);
    l_ret_i = player_auto_walk(g_player);
    Get_time(l_end);
  } else if (p_id == 403) {   // player_set_auto_walk
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_auto_walk(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 404) {   // player_held_item
    Get_time(l_start);
    l_ret_i = player_held_item(g_player, g_inventory);
    Get_time(l_end);
  } else if (p_id == 405) {   // player_target_kind
    Get_time(l_start);
    l_ret_i = player_target_kind(g_player);
    Get_time(l_end);
  } else if (p_id == 406) {   // player_target_cell
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    player_target_cell(g_player, l_i1, l_i2, l_i3);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
  } else if (p_id == 407) {   // player_target_normal
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    player_target_normal(g_player, l_i1, l_i2, l_i3);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
  } else if (p_id == 408) {   // player_target_cow
    Get_time(l_start);
    l_ret_i = player_target_cow(g_player);
    Get_time(l_end);
  } else if (p_id == 409) {   // player_break_stage
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = player_break_stage(g_player, l_r1);
    Get_time(l_end);
  } else if (p_id == 410) {   // player_turn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    player_turn(g_player, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 411) {   // player_on_event
    Get_time(l_start);
    player_on_event(g_event, g_player, g_inventory, g_events);
    Get_time(l_end);
  } else if (p_id == 412) {   // player_camera
    Get_time(l_start);
    l_ret_i = player_camera(g_player);
    Get_time(l_end);
  } else if (p_id == 413) {   // player_next_camera
    Get_time(l_start);
    player_next_camera(g_player);
    Get_time(l_end);
  } else if (p_id == 414) {   // player_flying
    Get_time(l_start);
    l_ret_i = player_flying(g_player);
    Get_time(l_end);
  } else if (p_id == 415) {   // player_set_flying
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_flying(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 416) {   // player_game_mode
    Get_time(l_start);
    l_ret_i = player_game_mode(g_player);
    Get_time(l_end);
  } else if (p_id == 417) {   // player_set_game_mode
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_game_mode(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 418) {   // player_creative
    Get_time(l_start);
    l_ret_i = player_creative(g_player);
    Get_time(l_end);
  } else if (p_id == 419) {   // player_spectator
    Get_time(l_start);
    l_ret_i = player_spectator(g_player);
    Get_time(l_end);
  } else if (p_id == 420) {   // player_survival
    Get_time(l_start);
    l_ret_i = player_survival(g_player);
    Get_time(l_end);
  } else if (p_id == 421) {   // player_game_mode_name
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = player_game_mode_name(l_i1);
    Get_time(l_end);
  } else if (p_id == 422) {   // player_pick_block
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = player_pick_block(g_player, g_inventory, l_t1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 423) {   // player_key_pressed
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_key_pressed(g_player, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 424) {   // player_shift_pressed
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_shift_pressed(g_player, l_r1);
    Get_time(l_end);
  } else if (p_id == 425) {   // player_key_active
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = player_key_active(g_player, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 426) {   // player_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_damage(g_player, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 427) {   // player_update
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    player_update(g_player, g_cows, g_events, l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 428) {   // player_update_target
    Get_time(l_start);
    player_update_target(g_player, g_cows);
    Get_time(l_end);
  } else if (p_id == 429) {   // player_overlaps_cell
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = player_overlaps_cell(g_player, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 430) {   // player_wear_tool
    Get_time(l_start);
    player_wear_tool(g_player, g_inventory, g_events);
    Get_time(l_end);
  } else if (p_id == 431) {   // player_primary_action
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_primary_action(g_player, g_inventory, g_cows, g_events, g_random, l_r1);
    Get_time(l_end);
  } else if (p_id == 432) {   // player_look_facing
    Get_time(l_start);
    l_ret_i = player_look_facing(g_player);
    Get_time(l_end);
  } else if (p_id == 433) {   // player_cell_free
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = player_cell_free(g_player, g_cows, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 434) {   // player_place_double
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = player_place_double(g_player, g_cows, g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 435) {   // player_toggle_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    player_toggle_door(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 436) {   // player_furnace_facing
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = player_furnace_facing(l_r1, l_r2, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 437) {   // player_use_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = player_use_slot(g_player, g_inventory, g_cows, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 438) {   // player_secondary_action
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_secondary_action(g_player, g_inventory, g_cows, g_events, l_r1);
    Get_time(l_end);
  } else if (p_id == 439) {   // command_word
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_word(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 440) {   // command_item_key
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = command_item_key(l_t1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_12(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 441 to 480 are
// ----------------------------------------------------------------
{
  if (p_id == 441) test_info_set(p_info, "command_find_item", "macro", "program", "commands", "src/program/commands.4dm", 46, 64, "Integer", "T:p_name",
                              "Integer command_find_item(Text p_name)", 0, "", "command_item_key, item_name");
  if (p_id == 442) test_info_set(p_info, "command_time_value", "macro", "program", "commands", "src/program/commands.4dm", 66, 86, "Integer", "T:p_word &I:p_ticks",
                              "Integer command_time_value(Text p_word, Integer &p_ticks)", 0, "", "");
  if (p_id == 443) test_info_set(p_info, "command_time", "macro", "program", "commands", "src/program/commands.4dm", 88, 113, "Text", "&D:p_words I:p_count &A:p_info",
                              "Text command_time(Dynamic_Text &p_words, Integer p_count, Attributes &p_info)", 0, "", "command_time_value, command_word, floor_integer, record_integer, world_clock_text, world_set_time_of_day, world_time_of_day");
  if (p_id == 444) test_info_set(p_info, "command_gamerule", "macro", "program", "commands", "src/program/commands.4dm", 115, 141, "Text", "&D:p_words I:p_count &A:p_info",
                              "Text command_gamerule(Dynamic_Text &p_words, Integer p_count, Attributes &p_info)", 0, "", "command_word, world_daylight_cycle, world_set_daylight_cycle");
  if (p_id == 445) test_info_set(p_info, "command_give", "macro", "program", "commands", "src/program/commands.4dm", 143, 167, "Text", "&D:p_words I:p_count &A:p_inventory",
                              "Text command_give(Dynamic_Text &p_words, Integer p_count, Attributes &p_inventory)", 0, "", "command_find_item, command_word, inventory_add, item_name");
  if (p_id == 446) test_info_set(p_info, "command_gamemode", "macro", "program", "commands", "src/program/commands.4dm", 169, 189, "Text", "&D:p_words &A:p_player",
                              "Text command_gamemode(Dynamic_Text &p_words, Attributes &p_player)", 0, "", "command_word, player_game_mode, player_game_mode_name, player_set_game_mode");
  if (p_id == 447) test_info_set(p_info, "command_run", "macro", "program", "commands", "src/program/commands.4dm", 191, 211, "Text", "T:p_line &A:p_info &A:p_player &A:p_inventory",
                              "Text command_run(Text p_line, Attributes &p_info, Attributes &p_player, Attributes &p_inventory)", 0, "", "command_gamemode, command_gamerule, command_give, command_time, command_word");
  if (p_id == 448) test_info_set(p_info, "game_init_once", "macro", "program", "game", "src/program/game.4dm", 31, 51, "void", "&A:p_game &A:p_book &A:p_settings &A:p_random I:p_time_seed",
                              "void game_init_once(Attributes &p_game, Attributes &p_book, Attributes &p_settings, Attributes &p_random, Integer p_time_seed)", 0, "", "crafting_init_book, game_load_textures, random_seed, record_clear, record_integer, record_set_integer, record_set_text, render_init, save_settings_path, settings_load");
  if (p_id == 449) test_info_set(p_info, "game_load_textures", "macro", "program", "game", "src/program/game.4dm", 53, 75, "Integer", "&A:p_settings &T:p_report",
                              "Integer game_load_textures(Attributes &p_settings, Text &p_report)", 0, "", "pack_apply, pack_apply_skin, settings_resource_pack, settings_skin, textures_finish_all, textures_generate");
  if (p_id == 450) test_info_set(p_info, "game_reset_state", "macro", "program", "game", "src/program/game.4dm", 77, 97, "void", "&A:p_game &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_events &A:p_hud &A:p_ui",
                              "void game_reset_state(Attributes &p_game, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events, Attributes &p_hud, Attributes &p_ui)", 0, "", "cows_clear, drops_clear, events_clear, furnaces_clear, grid_clear, hud_clear, inventory_clear, player_reset, player_set_game_mode, record_set_real, save_clear_edits, save_clear_thumbnail, ui_clear");
  if (p_id == 451) test_info_set(p_info, "game_world_name", "macro", "program", "game", "src/program/game.4dm", 99, 105, "Text", "&A:p_game",
                              "Text game_world_name(Attributes &p_game)", 0, "", "record_text");
  if (p_id == 452) test_info_set(p_info, "game_new_world", "macro", "program", "game", "src/program/game.4dm", 107, 143, "Integer", "T:p_name I:p_seed I:p_mode &A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_events &A:p_hud &A:p_ui",
                              "Integer game_new_world(Text p_name, Integer p_seed, Integer p_mode, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events, Attributes &p_hud, Attributes &p_ui)", 1, "", "cows_spawn_random, events_clear, game_reset_state, game_save_world, mesh_reset, mobs_spawn_random, player_reset, player_set_game_mode, player_set_look, random_seed, record_set_text, world_generate, world_info_spawn");
  if (p_id == 453) test_info_set(p_info, "game_load_world", "macro", "program", "game", "src/program/game.4dm", 145, 160, "Integer", "T:p_name &A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_events &A:p_hud &A:p_ui &T:p_problem",
                              "Integer game_load_world(Text p_name, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events, Attributes &p_hud, Attributes &p_ui, Text &p_problem)", 0, "", "events_clear, game_reset_state, load_world, player_set_flying, player_survival, record_set_text");
  if (p_id == 454) test_info_set(p_info, "game_host", "macro", "program", "game", "src/program/game.4dm", 162, 188, "Integer", "&A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_events &A:p_net &A:p_peers &A:p_inbox T:p_folder T:p_session T:p_id T:p_name R:p_now &T:p_problem",
                              "Integer game_host(Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events, Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Text p_folder, Text p_session, Text p_id, Text p_name, Real p_now, Text &p_problem)", 1, "", "events_clear, game_world_name, net_ensure_folder, net_snapshot_path, net_start, net_write_session, save_world_to, world_info_seed");
  if (p_id == 455) test_info_set(p_info, "game_join", "macro", "program", "game", "src/program/game.4dm", 190, 229, "Integer", "T:p_folder &A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_events &A:p_hud &A:p_ui &A:p_net &A:p_peers &A:p_inbox T:p_id T:p_name R:p_now &T:p_problem",
                              "Integer game_join(Text p_folder, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events, Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Text p_id, Text p_name, Real p_now, Text &p_problem)", 1, "", "drops_clear, events_clear, furnaces_clear, game_reset_state, inventory_clear, load_world_from, net_read_session, net_snapshot_path, net_start, player_reset, player_set_game_mode, record_set_text, world_info_spawn");
  if (p_id == 456) test_info_set(p_info, "game_save_world", "macro", "program", "game", "src/program/game.4dm", 231, 238, "Integer", "&A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_events",
                              "Integer game_save_world(Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events)", 1, "", "game_world_name, save_world");
  if (p_id == 457) test_info_set(p_info, "game_build_nearby", "macro", "program", "game", "src/program/game.4dm", 240, 269, "void", "&A:p_player I:p_range",
                              "void game_build_nearby(Attributes &p_player, Integer p_range)", 0, "", "clamp_integer, floor_integer, mesh_ensure_section, player_position");
  if (p_id == 458) test_info_set(p_info, "game_respawn", "macro", "program", "game", "src/program/game.4dm", 271, 284, "void", "&A:p_info &A:p_player &A:p_events",
                              "void game_respawn(Attributes &p_info, Attributes &p_player, Attributes &p_events)", 0, "", "emit_simple_event, player_reset, player_set_look, world_info_spawn");
  if (p_id == 459) test_info_set(p_info, "game_dispatch_events", "macro", "program", "game", "src/program/game.4dm", 286, 317, "void", "&A:p_events &A:p_event &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_random &A:p_hud &A:p_ui &A:p_net R:p_now",
                              "void game_dispatch_events(Attributes &p_events, Attributes &p_event, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_random, Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Real p_now)", 0, "", "chest_on_event, cows_on_event, drops_on_event, furnace_on_event, hud_on_event, mesh_on_event, net_on_event, next_event, player_on_event, player_position, save_on_event, ui_on_event, world_on_event");
  if (p_id == 460) test_info_set(p_info, "game_update", "macro", "program", "game", "src/program/game.4dm", 319, 360, "void", "R:p_dt R:p_real_dt R:p_now I:p_running &A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_events &A:p_event &A:p_random &A:p_settings &A:p_hud &A:p_ui &A:p_net &A:p_peers &A:p_inbox",
                              "void game_update(Real p_dt, Real p_real_dt, Real p_now, Integer p_running, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events, Attributes &p_event, Attributes &p_random, Attributes &p_settings, Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Attributes &p_peers, Attributes &p_inbox)", 1, "", "cows_update, drops_update, furnaces_update, game_dispatch_events, game_save_world, net_apply, net_send_state, player_is_dead, player_position, player_spectator, player_survival, player_update, record_real, record_set_real, settings_flag, world_advance_time, world_daylight_cycle, world_is_night, world_time_of_day");
  if (p_id == 461) test_info_set(p_info, "game_select_slot", "macro", "program", "game", "src/program/game.4dm", 362, 369, "void", "&A:p_player &A:p_hud I:p_slot R:p_now",
                              "void game_select_slot(Attributes &p_player, Attributes &p_hud, Integer p_slot, Real p_now)", 0, "", "hud_show_name, player_set_selected");
  if (p_id == 462) test_info_set(p_info, "save_clear_edits", "macro", "program", "save", "src/program/save.4dm", 24, 31, "void", "",
                              "void save_clear_edits()", 0, "", "");
  if (p_id == 463) test_info_set(p_info, "save_record_edit", "macro", "program", "save", "src/program/save.4dm", 33, 55, "void", "I:p_index I:p_block",
                              "void save_record_edit(Integer p_index, Integer p_block)", 0, "", "");
  if (p_id == 464) test_info_set(p_info, "save_on_event", "macro", "program", "save", "src/program/save.4dm", 57, 74, "void", "&A:p_event",
                              "void save_on_event(Attributes &p_event)", 0, "", "event_integer, event_type, save_record_edit, world_in_bounds, world_index");
  if (p_id == 465) test_info_set(p_info, "save_world_path", "macro", "program", "save", "src/program/save.4dm", 76, 85, "Text", "T:p_name",
                              "Text save_world_path(Text p_name)", 0, "", "");
  if (p_id == 466) test_info_set(p_info, "save_settings_path", "macro", "program", "save", "src/program/save.4dm", 87, 96, "Text", "",
                              "Text save_settings_path()", 0, "", "");
  if (p_id == 467) test_info_set(p_info, "save_ensure_folder", "macro", "program", "save", "src/program/save.4dm", 98, 104, "void", "",
                              "void save_ensure_folder()", 1, "", "");
  if (p_id == 468) test_info_set(p_info, "save_file_is_deleted", "macro", "program", "save", "src/program/save.4dm", 106, 123, "Integer", "T:p_path",
                              "Integer save_file_is_deleted(Text p_path)", 0, "", "");
  if (p_id == 469) test_info_set(p_info, "save_world_exists", "macro", "program", "save", "src/program/save.4dm", 125, 135, "Integer", "T:p_name",
                              "Integer save_world_exists(Text p_name)", 0, "", "save_file_is_deleted, save_world_path");
  if (p_id == 470) test_info_set(p_info, "save_list_worlds", "macro", "program", "save", "src/program/save.4dm", 137, 165, "Integer", "&D:p_names",
                              "Integer save_list_worlds(Dynamic_Text &p_names)", 1, "", "file_title_from_path, save_ensure_folder, save_world_exists");
  if (p_id == 471) test_info_set(p_info, "save_delete_world", "macro", "program", "save", "src/program/save.4dm", 167, 182, "Integer", "T:p_name",
                              "Integer save_delete_world(Text p_name)", 1, "", "save_world_exists, save_world_path");
  if (p_id == 472) test_info_set(p_info, "save_clear_thumbnail", "macro", "program", "save", "src/program/save.4dm", 186, 192, "void", "",
                              "void save_clear_thumbnail()", 0, "", "");
  if (p_id == 473) test_info_set(p_info, "save_thumbnail_ready", "macro", "program", "save", "src/program/save.4dm", 194, 200, "Integer", "",
                              "Integer save_thumbnail_ready()", 0, "", "");
  if (p_id == 474) test_info_set(p_info, "save_take_thumbnail", "macro", "program", "save", "src/program/save.4dm", 202, 248, "void", "&A:p_player R:p_distance",
                              "void save_take_thumbnail(Attributes &p_player, Real p_distance)", 0, "", "player_eye_y, player_look, player_position, render_ray_colour");
  if (p_id == 475) test_info_set(p_info, "save_thumbnail_colour", "macro", "program", "save", "src/program/save.4dm", 250, 257, "Integer", "I:p_cell",
                              "Integer save_thumbnail_colour(Integer p_cell)", 0, "", "");
  if (p_id == 476) test_info_set(p_info, "save_hex_colour", "macro", "program", "save", "src/program/save.4dm", 259, 276, "Text", "I:p_colour",
                              "Text save_hex_colour(Integer p_colour)", 0, "", "clamp_integer, floor_divide");
  if (p_id == 477) test_info_set(p_info, "save_hex_value", "macro", "program", "save", "src/program/save.4dm", 278, 299, "Integer", "T:p_text I:p_position I:p_digits",
                              "Integer save_hex_value(Text p_text, Integer p_position, Integer p_digits)", 0, "", "");
  if (p_id == 478) test_info_set(p_info, "save_note_played", "macro", "program", "save", "src/program/save.4dm", 301, 309, "void", "&A:p_info I:p_seconds T:p_clock",
                              "void save_note_played(Attributes &p_info, Integer p_seconds, Text p_clock)", 0, "", "record_set_integer, record_set_text, save_date_text");
  if (p_id == 479) test_info_set(p_info, "save_date_text", "macro", "program", "save", "src/program/save.4dm", 311, 331, "Text", "T:p_clock",
                              "Text save_date_text(Text p_clock)", 0, "", "");
  if (p_id == 480) test_info_set(p_info, "save_read_about", "macro", "program", "save", "src/program/save.4dm", 333, 406, "Integer", "T:p_path &A:p_list I:p_entry",
                              "Integer save_read_about(Text p_path, Attributes &p_list, Integer p_entry)", 0, "", "record_set_integer_at, record_set_text_at, save_hex_value, save_word_integer");
}

void test_registry_call_12(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 441 to 480 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 441) {   // command_find_item
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = command_find_item(l_t1);
    Get_time(l_end);
  } else if (p_id == 442) {   // command_time_value
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = command_time_value(l_t1, l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 443) {   // command_time
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_time(g_test_words, l_i1, g_info);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 444) {   // command_gamerule
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_gamerule(g_test_words, l_i1, g_info);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 445) {   // command_give
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_give(g_test_words, l_i1, g_inventory);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 446) {   // command_gamemode
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    Get_time(l_start);
    l_ret_t = command_gamemode(g_test_words, g_player);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 447) {   // command_run
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = command_run(l_t1, g_info, g_player, g_inventory);
    Get_time(l_end);
  } else if (p_id == 448) {   // game_init_once
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    game_init_once(g_game, g_book, g_settings, g_random, l_i1);
    Get_time(l_end);
  } else if (p_id == 449) {   // game_load_textures
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = game_load_textures(g_settings, l_t1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 450) {   // game_reset_state
    Get_time(l_start);
    game_reset_state(g_game, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_events, g_hud, g_ui);
    Get_time(l_end);
  } else if (p_id == 451) {   // game_world_name
    Get_time(l_start);
    l_ret_t = game_world_name(g_game);
    Get_time(l_end);
  } else if (p_id == 452) {   // game_new_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = game_new_world(l_t1, l_i1, l_i2, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_events, g_hud, g_ui);
    Get_time(l_end);
  } else if (p_id == 453) {   // game_load_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = game_load_world(l_t1, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_events, g_hud, g_ui, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 454) {   // game_host
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    Get_time(l_start);
    l_ret_i = game_host(g_game, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_events, g_net, g_peers, g_net_inbox, l_t1, l_t2, l_t3, l_t4, l_r1, l_t5);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T5, l_t5);
  } else if (p_id == 455) {   // game_join
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    Get_time(l_start);
    l_ret_i = game_join(l_t1, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_events, g_hud, g_ui, g_net, g_peers, g_net_inbox, l_t2, l_t3, l_r1, l_t4);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T4, l_t4);
  } else if (p_id == 456) {   // game_save_world
    Get_time(l_start);
    l_ret_i = game_save_world(g_game, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_events);
    Get_time(l_end);
  } else if (p_id == 457) {   // game_build_nearby
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    game_build_nearby(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 458) {   // game_respawn
    Get_time(l_start);
    game_respawn(g_info, g_player, g_events);
    Get_time(l_end);
  } else if (p_id == 459) {   // game_dispatch_events
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    game_dispatch_events(g_events, g_event, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_random, g_hud, g_ui, g_net, l_r1);
    Get_time(l_end);
  } else if (p_id == 460) {   // game_update
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    game_update(l_r1, l_r2, l_r3, l_i1, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_events, g_event, g_random, g_settings, g_hud, g_ui, g_net, g_peers, g_net_inbox);
    Get_time(l_end);
  } else if (p_id == 461) {   // game_select_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    game_select_slot(g_player, g_hud, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 462) {   // save_clear_edits
    Get_time(l_start);
    save_clear_edits();
    Get_time(l_end);
  } else if (p_id == 463) {   // save_record_edit
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    save_record_edit(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 464) {   // save_on_event
    Get_time(l_start);
    save_on_event(g_event);
    Get_time(l_end);
  } else if (p_id == 465) {   // save_world_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_world_path(l_t1);
    Get_time(l_end);
  } else if (p_id == 466) {   // save_settings_path
    Get_time(l_start);
    l_ret_t = save_settings_path();
    Get_time(l_end);
  } else if (p_id == 467) {   // save_ensure_folder
    Get_time(l_start);
    save_ensure_folder();
    Get_time(l_end);
  } else if (p_id == 468) {   // save_file_is_deleted
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_file_is_deleted(l_t1);
    Get_time(l_end);
  } else if (p_id == 469) {   // save_world_exists
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_world_exists(l_t1);
    Get_time(l_end);
  } else if (p_id == 470) {   // save_list_worlds
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    Get_time(l_start);
    l_ret_i = save_list_worlds(g_test_words);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 471) {   // save_delete_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_delete_world(l_t1);
    Get_time(l_end);
  } else if (p_id == 472) {   // save_clear_thumbnail
    Get_time(l_start);
    save_clear_thumbnail();
    Get_time(l_end);
  } else if (p_id == 473) {   // save_thumbnail_ready
    Get_time(l_start);
    l_ret_i = save_thumbnail_ready();
    Get_time(l_end);
  } else if (p_id == 474) {   // save_take_thumbnail
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    save_take_thumbnail(g_player, l_r1);
    Get_time(l_end);
  } else if (p_id == 475) {   // save_thumbnail_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_thumbnail_colour(l_i1);
    Get_time(l_end);
  } else if (p_id == 476) {   // save_hex_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = save_hex_colour(l_i1);
    Get_time(l_end);
  } else if (p_id == 477) {   // save_hex_value
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = save_hex_value(l_t1, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 478) {   // save_note_played
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    save_note_played(g_info, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 479) {   // save_date_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_date_text(l_t1);
    Get_time(l_end);
  } else if (p_id == 480) {   // save_read_about
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_read_about(l_t1, g_test_record, l_i1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_13(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 481 to 520 are
// ----------------------------------------------------------------
{
  if (p_id == 481) test_info_set(p_info, "save_swap_listed", "macro", "program", "save", "src/program/save.4dm", 408, 444, "void", "&A:p_list I:p_a I:p_b",
                              "void save_swap_listed(Attributes &p_list, Integer p_a, Integer p_b)", 0, "", "record_integer_at, record_set_integer_at, record_set_text_at, record_text_at");
  if (p_id == 482) test_info_set(p_info, "save_list_worlds_about", "macro", "program", "save", "src/program/save.4dm", 446, 476, "Integer", "&A:p_list",
                              "Integer save_list_worlds_about(Attributes &p_list)", 1, "", "record_clear, record_integer_at, record_set_integer, record_set_text_at, save_list_worlds, save_read_about, save_swap_listed, save_world_path");
  if (p_id == 483) test_info_set(p_info, "save_listed_colour", "macro", "program", "save", "src/program/save.4dm", 478, 485, "Integer", "I:p_entry I:p_cell",
                              "Integer save_listed_colour(Integer p_entry, Integer p_cell)", 0, "", "");
  if (p_id == 484) test_info_set(p_info, "save_file_name", "macro", "program", "save", "src/program/save.4dm", 487, 500, "Text", "T:p_path",
                              "Text save_file_name(Text p_path)", 0, "", "");
  if (p_id == 485) test_info_set(p_info, "save_list_files", "macro", "program", "save", "src/program/save.4dm", 502, 544, "Integer", "&A:p_files T:p_folder T:p_pattern I:p_with_folders",
                              "Integer save_list_files(Attributes &p_files, Text p_folder, Text p_pattern, Integer p_with_folders)", 0, "", "record_clear, record_set_integer, record_set_text_at, save_file_name");
  if (p_id == 486) test_info_set(p_info, "text_escape", "macro", "program", "save", "src/program/save.4dm", 550, 574, "Text", "T:p_value",
                              "Text text_escape(Text p_value)", 0, "", "");
  if (p_id == 487) test_info_set(p_info, "text_unescape", "macro", "program", "save", "src/program/save.4dm", 576, 600, "Text", "T:p_value",
                              "Text text_unescape(Text p_value)", 0, "", "");
  if (p_id == 488) test_info_set(p_info, "save_write_record", "macro", "program", "save", "src/program/save.4dm", 602, 629, "void", "&?:p_file T:p_name &A:p_record",
                              "void save_write_record(File &p_file, Text p_name, Attributes &p_record)", 0, "takes an open File", "text_escape");
  if (p_id == 489) test_info_set(p_info, "save_read_field", "macro", "program", "save", "src/program/save.4dm", 631, 657, "Integer", "&D:p_words I:p_count &A:p_record",
                              "Integer save_read_field(Dynamic_Text &p_words, Integer p_count, Attributes &p_record)", 0, "", "record_set_integer, record_set_real, record_set_text, save_word_integer, save_word_real, text_unescape");
  if (p_id == 490) test_info_set(p_info, "save_world", "macro", "program", "save", "src/program/save.4dm", 661, 671, "Integer", "T:p_name &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_events",
                              "Integer save_world(Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events)", 1, "", "save_ensure_folder, save_world_path, save_world_to");
  if (p_id == 491) test_info_set(p_info, "save_world_to", "macro", "program", "save", "src/program/save.4dm", 673, 731, "Integer", "T:p_path T:p_name &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_events",
                              "Integer save_world_to(Text p_path, Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_events)", 1, "", "emit_event, player_game_mode, record_integer, record_text, save_hex_colour, save_write_record, world_info_seed");
  if (p_id == 492) test_info_set(p_info, "save_word_integer", "macro", "program", "save", "src/program/save.4dm", 733, 748, "Integer", "&D:p_words I:p_position",
                              "Integer save_word_integer(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 493) test_info_set(p_info, "save_word_real", "macro", "program", "save", "src/program/save.4dm", 750, 761, "Real", "&D:p_words I:p_position",
                              "Real save_word_real(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 494) test_info_set(p_info, "load_world", "macro", "program", "save", "src/program/save.4dm", 763, 775, "Integer", "T:p_name &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &T:p_problem",
                              "Integer load_world(Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Text &p_problem)", 0, "", "load_world_from, save_world_exists, save_world_path");
  if (p_id == 495) test_info_set(p_info, "load_world_from", "macro", "program", "save", "src/program/save.4dm", 777, 912, "Integer", "T:p_path &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &T:p_problem",
                              "Integer load_world_from(Text p_path, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Text &p_problem)", 0, "", "block_is_furnace, block_light_emission, cows_clear, drops_clear, drops_rebuild_index, furnace_cell, furnace_set_used, furnace_used, furnaces_clear, furnaces_rebuild_index, inventory_clear, mesh_mark_dirty, mesh_reset, mobs_rebuild_index, player_reset, save_clear_edits, save_clear_thumbnail, save_hex_value, save_read_field, save_record_edit, save_word_integer, world_cell_of_index, world_finish_maps, world_generate, world_get_block, world_light_update, world_set_block");
  if (p_id == 496) test_info_set(p_info, "settings_defaults", "macro", "program", "settings", "src/program/settings.4dm", 11, 32, "void", "&A:p_settings",
                              "void settings_defaults(Attributes &p_settings)", 0, "", "record_clear, record_set_integer, record_set_text");
  if (p_id == 497) test_info_set(p_info, "settings_skin", "macro", "program", "settings", "src/program/settings.4dm", 34, 40, "Text", "&A:p_settings",
                              "Text settings_skin(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 498) test_info_set(p_info, "settings_mp_folder", "macro", "program", "settings", "src/program/settings.4dm", 42, 52, "Text", "&A:p_settings",
                              "Text settings_mp_folder(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 499) test_info_set(p_info, "settings_player_name", "macro", "program", "settings", "src/program/settings.4dm", 54, 60, "Text", "&A:p_settings",
                              "Text settings_player_name(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 500) test_info_set(p_info, "settings_set_text", "macro", "program", "settings", "src/program/settings.4dm", 62, 68, "void", "&A:p_settings T:p_field T:p_value",
                              "void settings_set_text(Attributes &p_settings, Text p_field, Text p_value)", 0, "", "record_set_text");
  if (p_id == 501) test_info_set(p_info, "settings_line_text", "macro", "program", "settings", "src/program/settings.4dm", 70, 83, "Integer", "T:p_line T:p_name &T:p_value",
                              "Integer settings_line_text(Text p_line, Text p_name, Text &p_value)", 0, "", "");
  if (p_id == 502) test_info_set(p_info, "settings_font_file", "macro", "program", "settings", "src/program/settings.4dm", 85, 92, "Text", "&A:p_settings",
                              "Text settings_font_file(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 503) test_info_set(p_info, "settings_set_font_file", "macro", "program", "settings", "src/program/settings.4dm", 94, 100, "void", "&A:p_settings T:p_path",
                              "void settings_set_font_file(Attributes &p_settings, Text p_path)", 0, "", "record_set_text");
  if (p_id == 504) test_info_set(p_info, "settings_font", "macro", "program", "settings", "src/program/settings.4dm", 102, 108, "Text", "&A:p_settings",
                              "Text settings_font(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 505) test_info_set(p_info, "settings_set_font", "macro", "program", "settings", "src/program/settings.4dm", 110, 116, "void", "&A:p_settings T:p_font",
                              "void settings_set_font(Attributes &p_settings, Text p_font)", 0, "", "record_set_text");
  if (p_id == 506) test_info_set(p_info, "settings_resource_pack", "macro", "program", "settings", "src/program/settings.4dm", 118, 124, "Text", "&A:p_settings",
                              "Text settings_resource_pack(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 507) test_info_set(p_info, "settings_set_resource_pack", "macro", "program", "settings", "src/program/settings.4dm", 126, 132, "void", "&A:p_settings T:p_path",
                              "void settings_set_resource_pack(Attributes &p_settings, Text p_path)", 0, "", "record_set_text");
  if (p_id == 508) test_info_set(p_info, "settings_render_distance", "macro", "program", "settings", "src/program/settings.4dm", 134, 140, "Integer", "&A:p_settings",
                              "Integer settings_render_distance(Attributes &p_settings)", 0, "", "clamp_integer, record_integer");
  if (p_id == 509) test_info_set(p_info, "settings_detail", "macro", "program", "settings", "src/program/settings.4dm", 142, 148, "Integer", "&A:p_settings",
                              "Integer settings_detail(Attributes &p_settings)", 0, "", "clamp_integer, record_integer");
  if (p_id == 510) test_info_set(p_info, "settings_flag", "macro", "program", "settings", "src/program/settings.4dm", 150, 156, "Integer", "&A:p_settings T:p_field",
                              "Integer settings_flag(Attributes &p_settings, Text p_field)", 0, "", "record_integer");
  if (p_id == 511) test_info_set(p_info, "settings_fov_degrees", "macro", "program", "settings", "src/program/settings.4dm", 158, 164, "Integer", "&A:p_settings",
                              "Integer settings_fov_degrees(Attributes &p_settings)", 0, "", "clamp_integer, record_integer");
  if (p_id == 512) test_info_set(p_info, "settings_fov_radians", "macro", "program", "settings", "src/program/settings.4dm", 166, 172, "Real", "&A:p_settings",
                              "Real settings_fov_radians(Attributes &p_settings)", 0, "", "settings_fov_degrees");
  if (p_id == 513) test_info_set(p_info, "settings_mouse_scale", "macro", "program", "settings", "src/program/settings.4dm", 174, 180, "Real", "&A:p_settings",
                              "Real settings_mouse_scale(Attributes &p_settings)", 0, "", "clamp_integer, record_integer");
  if (p_id == 514) test_info_set(p_info, "settings_change", "macro", "program", "settings", "src/program/settings.4dm", 182, 202, "void", "&A:p_settings T:p_field I:p_direction",
                              "void settings_change(Attributes &p_settings, Text p_field, Integer p_direction)", 0, "", "clamp_integer, record_integer, record_set_integer");
  if (p_id == 515) test_info_set(p_info, "settings_toggle", "macro", "program", "settings", "src/program/settings.4dm", 204, 210, "void", "&A:p_settings T:p_field",
                              "void settings_toggle(Attributes &p_settings, Text p_field)", 0, "", "record_integer, record_set_integer");
  if (p_id == 516) test_info_set(p_info, "settings_describe", "macro", "program", "settings", "src/program/settings.4dm", 212, 250, "Text", "&A:p_settings T:p_field",
                              "Text settings_describe(Attributes &p_settings, Text p_field)", 0, "", "record_integer, settings_font, settings_fov_degrees, settings_render_distance, settings_resource_pack, settings_skin");
  if (p_id == 517) test_info_set(p_info, "settings_line", "macro", "program", "settings", "src/program/settings.4dm", 252, 258, "Text", "T:p_name I:p_value",
                              "Text settings_line(Text p_name, Integer p_value)", 0, "", "");
  if (p_id == 518) test_info_set(p_info, "settings_save", "macro", "program", "settings", "src/program/settings.4dm", 260, 296, "Integer", "&A:p_settings T:p_path",
                              "Integer settings_save(Attributes &p_settings, Text p_path)", 1, "", "record_integer, settings_detail, settings_flag, settings_font, settings_font_file, settings_fov_degrees, settings_line, settings_mp_folder, settings_player_name, settings_render_distance, settings_resource_pack, settings_skin");
  if (p_id == 519) test_info_set(p_info, "settings_load", "macro", "program", "settings", "src/program/settings.4dm", 298, 375, "Integer", "&A:p_settings T:p_path",
                              "Integer settings_load(Attributes &p_settings, Text p_path)", 0, "", "record_set_integer, settings_defaults, settings_line_text, settings_set_font, settings_set_font_file, settings_set_resource_pack, settings_set_text");
  if (p_id == 520) test_info_set(p_info, "panorama_load", "macro", "render", "panorama_data", "src/render/panorama_data.4dm", 7, 174, "void", "",
                              "void panorama_load()", 0, "", "panorama_set_colour, panorama_set_row");
}

void test_registry_call_13(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 481 to 520 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 481) {   // save_swap_listed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    save_swap_listed(g_test_record, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 482) {   // save_list_worlds_about
    Get_time(l_start);
    l_ret_i = save_list_worlds_about(g_test_record);
    Get_time(l_end);
  } else if (p_id == 483) {   // save_listed_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = save_listed_colour(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 484) {   // save_file_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_file_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 485) {   // save_list_files
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_list_files(g_test_record, l_t1, l_t2, l_i1);
    Get_time(l_end);
  } else if (p_id == 486) {   // text_escape
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = text_escape(l_t1);
    Get_time(l_end);
  } else if (p_id == 487) {   // text_unescape
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = text_unescape(l_t1);
    Get_time(l_end);
  } else if (p_id == 489) {   // save_read_field
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_read_field(g_test_words, l_i1, g_test_record);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 490) {   // save_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_world(l_t1, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_events);
    Get_time(l_end);
  } else if (p_id == 491) {   // save_world_to
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = save_world_to(l_t1, l_t2, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_events);
    Get_time(l_end);
  } else if (p_id == 492) {   // save_word_integer
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_word_integer(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 493) {   // save_word_real
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = save_word_real(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 494) {   // load_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = load_world(l_t1, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 495) {   // load_world_from
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = load_world_from(l_t1, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 496) {   // settings_defaults
    Get_time(l_start);
    settings_defaults(g_settings);
    Get_time(l_end);
  } else if (p_id == 497) {   // settings_skin
    Get_time(l_start);
    l_ret_t = settings_skin(g_settings);
    Get_time(l_end);
  } else if (p_id == 498) {   // settings_mp_folder
    Get_time(l_start);
    l_ret_t = settings_mp_folder(g_settings);
    Get_time(l_end);
  } else if (p_id == 499) {   // settings_player_name
    Get_time(l_start);
    l_ret_t = settings_player_name(g_settings);
    Get_time(l_end);
  } else if (p_id == 500) {   // settings_set_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    settings_set_text(g_settings, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 501) {   // settings_line_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = settings_line_text(l_t1, l_t2, l_t3);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
  } else if (p_id == 502) {   // settings_font_file
    Get_time(l_start);
    l_ret_t = settings_font_file(g_settings);
    Get_time(l_end);
  } else if (p_id == 503) {   // settings_set_font_file
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_set_font_file(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 504) {   // settings_font
    Get_time(l_start);
    l_ret_t = settings_font(g_settings);
    Get_time(l_end);
  } else if (p_id == 505) {   // settings_set_font
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_set_font(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 506) {   // settings_resource_pack
    Get_time(l_start);
    l_ret_t = settings_resource_pack(g_settings);
    Get_time(l_end);
  } else if (p_id == 507) {   // settings_set_resource_pack
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_set_resource_pack(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 508) {   // settings_render_distance
    Get_time(l_start);
    l_ret_i = settings_render_distance(g_settings);
    Get_time(l_end);
  } else if (p_id == 509) {   // settings_detail
    Get_time(l_start);
    l_ret_i = settings_detail(g_settings);
    Get_time(l_end);
  } else if (p_id == 510) {   // settings_flag
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = settings_flag(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 511) {   // settings_fov_degrees
    Get_time(l_start);
    l_ret_i = settings_fov_degrees(g_settings);
    Get_time(l_end);
  } else if (p_id == 512) {   // settings_fov_radians
    Get_time(l_start);
    l_ret_r = settings_fov_radians(g_settings);
    Get_time(l_end);
  } else if (p_id == 513) {   // settings_mouse_scale
    Get_time(l_start);
    l_ret_r = settings_mouse_scale(g_settings);
    Get_time(l_end);
  } else if (p_id == 514) {   // settings_change
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    settings_change(g_settings, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 515) {   // settings_toggle
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_toggle(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 516) {   // settings_describe
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = settings_describe(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 517) {   // settings_line
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = settings_line(l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 518) {   // settings_save
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = settings_save(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 519) {   // settings_load
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = settings_load(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 520) {   // panorama_load
    Get_time(l_start);
    panorama_load();
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_14(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 521 to 560 are
// ----------------------------------------------------------------
{
  if (p_id == 521) test_info_set(p_info, "hud_clear", "macro", "render", "render_hud", "src/render/render_hud.4dm", 20, 48, "void", "&A:p_hud",
                              "void hud_clear(Attributes &p_hud)", 0, "", "hud_set_chat_input, record_clear, record_set_integer, record_set_real, record_set_real_at, record_set_text, record_set_text_at");
  if (p_id == 522) test_info_set(p_info, "hud_note_frame", "macro", "render", "render_hud", "src/render/render_hud.4dm", 50, 83, "void", "&A:p_hud R:p_frame_ms R:p_now",
                              "void hud_note_frame(Attributes &p_hud, Real p_frame_ms, Real p_now)", 0, "", "record_integer, record_real, record_set_integer, record_set_real, record_set_text");
  if (p_id == 523) test_info_set(p_info, "hud_frame_stats", "macro", "render", "render_hud", "src/render/render_hud.4dm", 85, 91, "Text", "&A:p_hud",
                              "Text hud_frame_stats(Attributes &p_hud)", 0, "", "record_text");
  if (p_id == 524) test_info_set(p_info, "hud_toast", "macro", "render", "render_hud", "src/render/render_hud.4dm", 93, 106, "void", "&A:p_hud T:p_text R:p_now",
                              "void hud_toast(Attributes &p_hud, Text p_text, Real p_now)", 0, "", "record_real_at, record_set_real_at, record_set_text_at, record_text_at");
  if (p_id == 525) test_info_set(p_info, "hud_chat", "macro", "render", "render_hud", "src/render/render_hud.4dm", 108, 121, "void", "&A:p_hud T:p_text R:p_now",
                              "void hud_chat(Attributes &p_hud, Text p_text, Real p_now)", 0, "", "record_real_at, record_set_real_at, record_set_text_at, record_text_at");
  if (p_id == 526) test_info_set(p_info, "hud_set_chat_input", "macro", "render", "render_hud", "src/render/render_hud.4dm", 123, 130, "void", "&A:p_hud I:p_open T:p_text",
                              "void hud_set_chat_input(Attributes &p_hud, Integer p_open, Text p_text)", 0, "", "record_set_integer, record_set_text");
  if (p_id == 527) test_info_set(p_info, "hud_chat_open", "macro", "render", "render_hud", "src/render/render_hud.4dm", 132, 138, "Integer", "&A:p_hud",
                              "Integer hud_chat_open(Attributes &p_hud)", 0, "", "record_integer");
  if (p_id == 528) test_info_set(p_info, "hud_show_name", "macro", "render", "render_hud", "src/render/render_hud.4dm", 140, 146, "void", "&A:p_hud R:p_now",
                              "void hud_show_name(Attributes &p_hud, Real p_now)", 0, "", "record_set_real");
  if (p_id == 529) test_info_set(p_info, "hud_help_shown", "macro", "render", "render_hud", "src/render/render_hud.4dm", 148, 154, "Integer", "&A:p_hud",
                              "Integer hud_help_shown(Attributes &p_hud)", 0, "", "record_integer");
  if (p_id == 530) test_info_set(p_info, "hud_set_help", "macro", "render", "render_hud", "src/render/render_hud.4dm", 156, 163, "void", "&A:p_hud I:p_shown",
                              "void hud_set_help(Attributes &p_hud, Integer p_shown)", 0, "", "record_set_integer");
  if (p_id == 531) test_info_set(p_info, "hud_set_menu_help", "macro", "render", "render_hud", "src/render/render_hud.4dm", 165, 172, "void", "&A:p_hud I:p_from_menu",
                              "void hud_set_menu_help(Attributes &p_hud, Integer p_from_menu)", 0, "", "record_set_integer");
  if (p_id == 532) test_info_set(p_info, "hud_menu_help", "macro", "render", "render_hud", "src/render/render_hud.4dm", 174, 180, "Integer", "&A:p_hud",
                              "Integer hud_menu_help(Attributes &p_hud)", 0, "", "record_integer");
  if (p_id == 533) test_info_set(p_info, "hud_set_mouse", "macro", "render", "render_hud", "src/render/render_hud.4dm", 182, 189, "void", "&A:p_hud R:p_x R:p_y",
                              "void hud_set_mouse(Attributes &p_hud, Real p_x, Real p_y)", 0, "", "record_set_real");
  if (p_id == 534) test_info_set(p_info, "hud_on_event", "macro", "render", "render_hud", "src/render/render_hud.4dm", 191, 211, "void", "&A:p_event &A:p_hud R:p_now",
                              "void hud_on_event(Attributes &p_event, Attributes &p_hud, Real p_now)", 0, "", "event_integer, event_text, event_type, hud_toast, item_name");
  if (p_id == 535) test_info_set(p_info, "hud_text", "macro", "render", "render_hud", "src/render/render_hud.4dm", 215, 224, "void", "B:p_box R:p_x R:p_y R:p_size I:p_align I:p_red I:p_green I:p_blue T:p_text",
                              "void hud_text(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_align, Integer p_red, Integer p_green, Integer p_blue, Text p_text)", 0, "", "");
  if (p_id == 536) test_info_set(p_info, "hud_shadow_text", "macro", "render", "render_hud", "src/render/render_hud.4dm", 226, 233, "void", "B:p_box R:p_x R:p_y R:p_size I:p_align I:p_red I:p_green I:p_blue T:p_text",
                              "void hud_shadow_text(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_align, Integer p_red, Integer p_green, Integer p_blue, Text p_text)", 0, "", "hud_text");
  if (p_id == 537) test_info_set(p_info, "hud_frame", "macro", "render", "render_hud", "src/render/render_hud.4dm", 235, 244, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1",
                              "void hud_frame(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)", 0, "", "render_line");
  if (p_id == 538) test_info_set(p_info, "hud_texture_face", "macro", "render", "render_hud", "src/render/render_hud.4dm", 246, 318, "void", "B:p_box I:p_tex R:p_shade I:p_quick R:p_origin_x R:p_origin_y R:p_u_x R:p_u_y R:p_v_x R:p_v_y",
                              "void hud_texture_face(Draw_Box p_box, Integer p_tex, Real p_shade, Integer p_quick, Real p_origin_x, Real p_origin_y, Real p_u_x, Real p_u_y, Real p_v_x, Real p_v_y)", 0, "", "render_set_colour, texture_palette_index");
  if (p_id == 539) test_info_set(p_info, "hud_draw_item_icon", "macro", "render", "render_hud", "src/render/render_hud.4dm", 320, 349, "void", "B:p_box I:p_item R:p_centre_x R:p_centre_y R:p_size I:p_detail",
                              "void hud_draw_item_icon(Draw_Box p_box, Integer p_item, Real p_centre_x, Real p_centre_y, Real p_size, Integer p_detail)", 0, "", "hud_texture_face, item_is_block, item_side_texture, item_sprite_texture, item_top_texture");
  if (p_id == 540) test_info_set(p_info, "hud_draw_slot", "macro", "render", "render_hud", "src/render/render_hud.4dm", 351, 357, "void", "B:p_box R:p_x0 R:p_y0 R:p_size I:p_item I:p_count I:p_damage I:p_highlight",
                              "void hud_draw_slot(Draw_Box p_box, Real p_x0, Real p_y0, Real p_size, Integer p_item, Integer p_count, Integer p_damage, Integer p_highlight)", 0, "", "hud_draw_slot_style");
  if (p_id == 541) test_info_set(p_info, "hud_draw_slot_style", "macro", "render", "render_hud", "src/render/render_hud.4dm", 359, 409, "void", "B:p_box R:p_x0 R:p_y0 R:p_size I:p_item I:p_count I:p_damage I:p_highlight I:p_style",
                              "void hud_draw_slot_style(Draw_Box p_box, Real p_x0, Real p_y0, Real p_size, Integer p_item, Integer p_count, Integer p_damage, Integer p_highlight, Integer p_style)", 0, "", "clamp_real, hud_draw_item_icon, hud_frame, hud_shadow_text, item_max_uses, render_fill_rect, render_set_colour");
  if (p_id == 542) test_info_set(p_info, "hud_banner", "macro", "render", "render_hud", "src/render/render_hud.4dm", 413, 426, "void", "B:p_box R:p_centre_x R:p_centre_y R:p_half_w R:p_half_h T:p_title T:p_line I:p_red I:p_green I:p_blue",
                              "void hud_banner(Draw_Box p_box, Real p_centre_x, Real p_centre_y, Real p_half_w, Real p_half_h, Text p_title, Text p_line, Integer p_red, Integer p_green, Integer p_blue)", 0, "", "hud_frame, hud_text, render_fill_rect, render_set_colour");
  if (p_id == 543) test_info_set(p_info, "hud_pause_button_rect", "macro", "render", "render_hud", "src/render/render_hud.4dm", 428, 452, "void", "R:p_w R:p_h I:p_button &R:p_x0 &R:p_y0 &R:p_x1 &R:p_y1",
                              "void hud_pause_button_rect(Real p_w, Real p_h, Integer p_button, Real &p_x0, Real &p_y0, Real &p_x1, Real &p_y1)", 0, "", "min_real");
  if (p_id == 544) test_info_set(p_info, "hud_pause_button_at", "macro", "render", "render_hud", "src/render/render_hud.4dm", 454, 470, "Integer", "R:p_w R:p_h R:p_x R:p_y",
                              "Integer hud_pause_button_at(Real p_w, Real p_h, Real p_x, Real p_y)", 0, "", "hud_pause_button_rect");
  if (p_id == 545) test_info_set(p_info, "hud_draw_button", "macro", "render", "render_hud", "src/render/render_hud.4dm", 472, 506, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_text I:p_hover",
                              "void hud_draw_button(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_hover)", 0, "", "hud_text, render_fill_rect, render_set_colour");
  if (p_id == 546) test_info_set(p_info, "hud_draw_pause_menu", "macro", "render", "render_hud", "src/render/render_hud.4dm", 508, 535, "void", "B:p_box R:p_w R:p_h R:p_mouse_x R:p_mouse_y T:p_mode_name",
                              "void hud_draw_pause_menu(Draw_Box p_box, Real p_w, Real p_h, Real p_mouse_x, Real p_mouse_y, Text p_mode_name)", 0, "", "hud_draw_button, hud_pause_button_at, hud_pause_button_rect, hud_shadow_text");
  if (p_id == 547) test_info_set(p_info, "hud_help_line", "macro", "render", "render_hud", "src/render/render_hud.4dm", 537, 545, "void", "B:p_box R:p_x &R:p_y T:p_key T:p_what",
                              "void hud_help_line(Draw_Box p_box, Real p_x, Real &p_y, Text p_key, Text p_what)", 0, "", "hud_text");
  if (p_id == 548) test_info_set(p_info, "hud_help_heading", "macro", "render", "render_hud", "src/render/render_hud.4dm", 547, 555, "void", "B:p_box R:p_x &R:p_y T:p_text",
                              "void hud_help_heading(Draw_Box p_box, Real p_x, Real &p_y, Text p_text)", 0, "", "hud_text");
  if (p_id == 549) test_info_set(p_info, "hud_draw_help", "macro", "render", "render_hud", "src/render/render_hud.4dm", 557, 607, "void", "B:p_box R:p_w R:p_h I:p_from_menu",
                              "void hud_draw_help(Draw_Box p_box, Real p_w, Real p_h, Integer p_from_menu)", 0, "", "hud_frame, hud_help_heading, hud_help_line, hud_text, min_real, render_fill_rect, render_set_colour");
  if (p_id == 550) test_info_set(p_info, "hud_facing_name", "macro", "render", "render_hud", "src/render/render_hud.4dm", 609, 620, "Text", "R:p_yaw",
                              "Text hud_facing_name(Real p_yaw)", 0, "", "floor_integer, positive_mod");
  if (p_id == 551) test_info_set(p_info, "hud_draw_hand", "macro", "render", "render_hud", "src/render/render_hud.4dm", 622, 657, "void", "B:p_box R:p_w R:p_view_bottom R:p_h I:p_item R:p_bob R:p_swing_time",
                              "void hud_draw_hand(Draw_Box p_box, Real p_w, Real p_view_bottom, Real p_h, Integer p_item, Real p_bob, Real p_swing_time)", 0, "", "hud_draw_item_icon, render_set_colour");
  if (p_id == 552) test_info_set(p_info, "hud_draw_figure", "macro", "render", "render_hud", "src/render/render_hud.4dm", 659, 698, "void", "B:p_box R:p_centre_x R:p_base_y R:p_unit I:p_helmet I:p_chestplate I:p_leggings I:p_boots",
                              "void hud_draw_figure(Draw_Box p_box, Real p_centre_x, Real p_base_y, Real p_unit, Integer p_helmet, Integer p_chestplate, Integer p_leggings, Integer p_boots)", 0, "", "hud_texture_face");
  if (p_id == 553) test_info_set(p_info, "hud_draw_armour", "macro", "render", "render_hud", "src/render/render_hud.4dm", 700, 723, "void", "B:p_box R:p_x0 R:p_y0 R:p_width I:p_points",
                              "void hud_draw_armour(Draw_Box p_box, Real p_x0, Real p_y0, Real p_width, Integer p_points)", 0, "", "hud_texture_face");
  if (p_id == 554) test_info_set(p_info, "hud_draw_health", "macro", "render", "render_hud", "src/render/render_hud.4dm", 725, 750, "void", "B:p_box R:p_x0 R:p_y0 R:p_width I:p_health R:p_now",
                              "void hud_draw_health(Draw_Box p_box, Real p_x0, Real p_y0, Real p_width, Integer p_health, Real p_now)", 0, "", "hud_texture_face");
  if (p_id == 555) test_info_set(p_info, "hud_draw", "macro", "render", "render_hud", "src/render/render_hud.4dm", 752, 902, "void", "B:p_box R:p_w R:p_h I:p_captured I:p_screen_open &A:p_hud &A:p_player &A:p_inventory &A:p_settings I:p_seed R:p_time_of_day R:p_frame_ms T:p_render_stats R:p_now",
                              "void hud_draw(Draw_Box p_box, Real p_w, Real p_h, Integer p_captured, Integer p_screen_open, Attributes &p_hud, Attributes &p_player, Attributes &p_inventory, Attributes &p_settings, Integer p_seed, Real p_time_of_day, Real p_frame_ms, Text p_render_stats, Real p_now)", 0, "", "clamp_real, hud_banner, hud_chat_open, hud_draw_armour, hud_draw_hand, hud_draw_health, hud_draw_help, hud_draw_item_icon, hud_draw_pause_menu, hud_draw_slot, hud_facing_name, hud_frame_stats, hud_help_shown, hud_menu_help, hud_shadow_text, hud_text, inventory_armour_points, item_name, player_auto_walk, player_bob, player_camera, player_creative, player_crouching, player_flying, player_game_mode, player_game_mode_name, player_health, player_held_item, player_hurt_time, player_is_dead, player_look, player_position, player_selected, player_spectator, player_survival, player_swing_time, record_real, record_real_at, record_text, record_text_at, render_fill_rect, render_line, render_set_colour, settings_flag, settings_render_distance, slot_count, slot_damage, slot_item, world_clock_text, world_is_night");
  if (p_id == 556) test_info_set(p_info, "menu_clear", "macro", "render", "render_menu", "src/render/render_menu.4dm", 14, 30, "void", "&A:p_menu",
                              "void menu_clear(Attributes &p_menu)", 0, "", "record_clear, record_set_integer, record_set_real, record_set_text");
  if (p_id == 557) test_info_set(p_info, "menu_begin", "macro", "render", "render_menu", "src/render/render_menu.4dm", 32, 40, "void", "&A:p_menu",
                              "void menu_begin(Attributes &p_menu)", 0, "", "menu_set_list, record_set_integer");
  if (p_id == 558) test_info_set(p_info, "menu_add", "macro", "render", "render_menu", "src/render/render_menu.4dm", 42, 63, "Integer", "&A:p_menu I:p_kind I:p_id R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_label I:p_enabled",
                              "Integer menu_add(Attributes &p_menu, Integer p_kind, Integer p_id, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_label, Integer p_enabled)", 0, "", "record_integer, record_set_integer, record_set_integer_at, record_set_real_at, record_set_text_at");
  if (p_id == 559) test_info_set(p_info, "menu_set_value", "macro", "render", "render_menu", "src/render/render_menu.4dm", 65, 71, "void", "&A:p_menu I:p_widget R:p_value",
                              "void menu_set_value(Attributes &p_menu, Integer p_widget, Real p_value)", 0, "", "clamp_real, record_set_real_at");
  if (p_id == 560) test_info_set(p_info, "menu_widgets", "macro", "render", "render_menu", "src/render/render_menu.4dm", 73, 79, "Integer", "&A:p_menu",
                              "Integer menu_widgets(Attributes &p_menu)", 0, "", "record_integer");
}

void test_registry_call_14(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 521 to 560 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 521) {   // hud_clear
    Get_time(l_start);
    hud_clear(g_hud);
    Get_time(l_end);
  } else if (p_id == 522) {   // hud_note_frame
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    hud_note_frame(g_hud, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 523) {   // hud_frame_stats
    Get_time(l_start);
    l_ret_t = hud_frame_stats(g_hud);
    Get_time(l_end);
  } else if (p_id == 524) {   // hud_toast
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    hud_toast(g_hud, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 525) {   // hud_chat
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    hud_chat(g_hud, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 526) {   // hud_set_chat_input
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    hud_set_chat_input(g_hud, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 527) {   // hud_chat_open
    Get_time(l_start);
    l_ret_i = hud_chat_open(g_hud);
    Get_time(l_end);
  } else if (p_id == 528) {   // hud_show_name
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    hud_show_name(g_hud, l_r1);
    Get_time(l_end);
  } else if (p_id == 529) {   // hud_help_shown
    Get_time(l_start);
    l_ret_i = hud_help_shown(g_hud);
    Get_time(l_end);
  } else if (p_id == 530) {   // hud_set_help
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_set_help(g_hud, l_i1);
    Get_time(l_end);
  } else if (p_id == 531) {   // hud_set_menu_help
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_set_menu_help(g_hud, l_i1);
    Get_time(l_end);
  } else if (p_id == 532) {   // hud_menu_help
    Get_time(l_start);
    l_ret_i = hud_menu_help(g_hud);
    Get_time(l_end);
  } else if (p_id == 533) {   // hud_set_mouse
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    hud_set_mouse(g_hud, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 534) {   // hud_on_event
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    hud_on_event(g_event, g_hud, l_r1);
    Get_time(l_end);
  } else if (p_id == 535) {   // hud_text
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    hud_text(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2, l_i3, l_i4, l_t1);
    Get_time(l_end);
  } else if (p_id == 536) {   // hud_shadow_text
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    hud_shadow_text(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2, l_i3, l_i4, l_t1);
    Get_time(l_end);
  } else if (p_id == 537) {   // hud_frame
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    hud_frame(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 538) {   // hud_texture_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    Get_time(l_start);
    hud_texture_face(g_test_box, l_i1, l_r1, l_i2, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7);
    Get_time(l_end);
  } else if (p_id == 539) {   // hud_draw_item_icon
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    hud_draw_item_icon(g_test_box, l_i1, l_r1, l_r2, l_r3, l_i2);
    Get_time(l_end);
  } else if (p_id == 540) {   // hud_draw_slot
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    hud_draw_slot(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 541) {   // hud_draw_slot_style
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    hud_draw_slot_style(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 542) {   // hud_banner
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    hud_banner(g_test_box, l_r1, l_r2, l_r3, l_r4, l_t1, l_t2, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 543) {   // hud_pause_button_rect
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    hud_pause_button_rect(l_r1, l_r2, l_i1, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
    record_set_real(p_out, ATTR_TEST_R4, l_r4);
    record_set_real(p_out, ATTR_TEST_R5, l_r5);
    record_set_real(p_out, ATTR_TEST_R6, l_r6);
  } else if (p_id == 544) {   // hud_pause_button_at
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = hud_pause_button_at(l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 545) {   // hud_draw_button
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_draw_button(g_test_box, l_r1, l_r2, l_r3, l_r4, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 546) {   // hud_draw_pause_menu
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    hud_draw_pause_menu(g_test_box, l_r1, l_r2, l_r3, l_r4, l_t1);
    Get_time(l_end);
  } else if (p_id == 547) {   // hud_help_line
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    hud_help_line(g_test_box, l_r1, l_r2, l_t1, l_t2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 548) {   // hud_help_heading
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    hud_help_heading(g_test_box, l_r1, l_r2, l_t1);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 549) {   // hud_draw_help
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_draw_help(g_test_box, l_r1, l_r2, l_i1);
    Get_time(l_end);
  } else if (p_id == 550) {   // hud_facing_name
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_t = hud_facing_name(l_r1);
    Get_time(l_end);
  } else if (p_id == 551) {   // hud_draw_hand
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    hud_draw_hand(g_test_box, l_r1, l_r2, l_r3, l_i1, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 552) {   // hud_draw_figure
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    hud_draw_figure(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 553) {   // hud_draw_armour
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_draw_armour(g_test_box, l_r1, l_r2, l_r3, l_i1);
    Get_time(l_end);
  } else if (p_id == 554) {   // hud_draw_health
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    hud_draw_health(g_test_box, l_r1, l_r2, l_r3, l_i1, l_r4);
    Get_time(l_end);
  } else if (p_id == 555) {   // hud_draw
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    hud_draw(g_test_box, l_r1, l_r2, l_i1, l_i2, g_hud, g_player, g_inventory, g_settings, l_i3, l_r3, l_r4, l_t1, l_r5);
    Get_time(l_end);
  } else if (p_id == 556) {   // menu_clear
    Get_time(l_start);
    menu_clear(g_test_record);
    Get_time(l_end);
  } else if (p_id == 557) {   // menu_begin
    Get_time(l_start);
    menu_begin(g_test_record);
    Get_time(l_end);
  } else if (p_id == 558) {   // menu_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = menu_add(g_test_record, l_i1, l_i2, l_r1, l_r2, l_r3, l_r4, l_t1, l_i3);
    Get_time(l_end);
  } else if (p_id == 559) {   // menu_set_value
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    menu_set_value(g_test_record, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 560) {   // menu_widgets
    Get_time(l_start);
    l_ret_i = menu_widgets(g_test_record);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_15(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 561 to 600 are
// ----------------------------------------------------------------
{
  if (p_id == 561) test_info_set(p_info, "menu_widget_id", "macro", "render", "render_menu", "src/render/render_menu.4dm", 81, 88, "Integer", "&A:p_menu I:p_widget",
                              "Integer menu_widget_id(Attributes &p_menu, Integer p_widget)", 0, "", "menu_widgets, record_integer_at");
  if (p_id == 562) test_info_set(p_info, "menu_widget_kind", "macro", "render", "render_menu", "src/render/render_menu.4dm", 90, 97, "Integer", "&A:p_menu I:p_widget",
                              "Integer menu_widget_kind(Attributes &p_menu, Integer p_widget)", 0, "", "menu_widgets, record_integer_at");
  if (p_id == 563) test_info_set(p_info, "menu_widget_of", "macro", "render", "render_menu", "src/render/render_menu.4dm", 99, 110, "Integer", "&A:p_menu I:p_id",
                              "Integer menu_widget_of(Attributes &p_menu, Integer p_id)", 0, "", "menu_widgets, record_integer_at");
  if (p_id == 564) test_info_set(p_info, "menu_at", "macro", "render", "render_menu", "src/render/render_menu.4dm", 112, 126, "Integer", "&A:p_menu R:p_x R:p_y",
                              "Integer menu_at(Attributes &p_menu, Real p_x, Real p_y)", 0, "", "menu_widgets, record_integer_at, record_real_at");
  if (p_id == 565) test_info_set(p_info, "menu_id_at", "macro", "render", "render_menu", "src/render/render_menu.4dm", 128, 134, "Integer", "&A:p_menu R:p_x R:p_y",
                              "Integer menu_id_at(Attributes &p_menu, Real p_x, Real p_y)", 0, "", "menu_at, menu_widget_id");
  if (p_id == 566) test_info_set(p_info, "menu_slider_value_at", "macro", "render", "render_menu", "src/render/render_menu.4dm", 136, 153, "Real", "&A:p_menu I:p_widget R:p_x R:p_y",
                              "Real menu_slider_value_at(Attributes &p_menu, Integer p_widget, Real p_x, Real p_y)", 0, "", "clamp_real, menu_widget_kind, record_real_at");
  if (p_id == 567) test_info_set(p_info, "menu_field_text", "macro", "render", "render_menu", "src/render/render_menu.4dm", 155, 161, "Text", "&A:p_menu I:p_id",
                              "Text menu_field_text(Attributes &p_menu, Integer p_id)", 0, "", "record_field_at, record_text");
  if (p_id == 568) test_info_set(p_info, "menu_set_field_text", "macro", "render", "render_menu", "src/render/render_menu.4dm", 163, 169, "void", "&A:p_menu I:p_id T:p_text",
                              "void menu_set_field_text(Attributes &p_menu, Integer p_id, Text p_text)", 0, "", "record_field_at, record_set_text");
  if (p_id == 569) test_info_set(p_info, "menu_focus", "macro", "render", "render_menu", "src/render/render_menu.4dm", 171, 177, "Integer", "&A:p_menu",
                              "Integer menu_focus(Attributes &p_menu)", 0, "", "record_integer");
  if (p_id == 570) test_info_set(p_info, "menu_set_focus", "macro", "render", "render_menu", "src/render/render_menu.4dm", 179, 185, "void", "&A:p_menu I:p_id",
                              "void menu_set_focus(Attributes &p_menu, Integer p_id)", 0, "", "record_set_integer");
  if (p_id == 571) test_info_set(p_info, "menu_type_key", "macro", "render", "render_menu", "src/render/render_menu.4dm", 187, 201, "Integer", "&A:p_menu T:p_key T:p_raw",
                              "Integer menu_type_key(Attributes &p_menu, Text p_key, Text p_raw)", 0, "", "key_is_text, menu_field_text, menu_focus, menu_set_field_text, text_after_key");
  if (p_id == 572) test_info_set(p_info, "menu_set_mouse", "macro", "render", "render_menu", "src/render/render_menu.4dm", 203, 210, "void", "&A:p_menu R:p_x R:p_y",
                              "void menu_set_mouse(Attributes &p_menu, Real p_x, Real p_y)", 0, "", "record_set_real");
  if (p_id == 573) test_info_set(p_info, "menu_note", "macro", "render", "render_menu", "src/render/render_menu.4dm", 212, 221, "void", "&A:p_menu T:p_text I:p_red R:p_now",
                              "void menu_note(Attributes &p_menu, Text p_text, Integer p_red, Real p_now)", 0, "", "record_set_integer, record_set_real, record_set_text");
  if (p_id == 574) test_info_set(p_info, "menu_pick", "macro", "render", "render_menu", "src/render/render_menu.4dm", 223, 229, "Integer", "&A:p_menu",
                              "Integer menu_pick(Attributes &p_menu)", 0, "", "record_integer");
  if (p_id == 575) test_info_set(p_info, "menu_set_pick", "macro", "render", "render_menu", "src/render/render_menu.4dm", 231, 237, "void", "&A:p_menu I:p_pick",
                              "void menu_set_pick(Attributes &p_menu, Integer p_pick)", 0, "", "record_set_integer");
  if (p_id == 576) test_info_set(p_info, "menu_scroll", "macro", "render", "render_menu", "src/render/render_menu.4dm", 239, 245, "Integer", "&A:p_menu",
                              "Integer menu_scroll(Attributes &p_menu)", 0, "", "record_integer");
  if (p_id == 577) test_info_set(p_info, "menu_set_scroll", "macro", "render", "render_menu", "src/render/render_menu.4dm", 247, 254, "void", "&A:p_menu I:p_scroll I:p_rows I:p_shown",
                              "void menu_set_scroll(Attributes &p_menu, Integer p_scroll, Integer p_rows, Integer p_shown)", 0, "", "clamp_integer, max_integer, record_set_integer");
  if (p_id == 578) test_info_set(p_info, "menu_set_list", "macro", "render", "render_menu", "src/render/render_menu.4dm", 256, 264, "void", "&A:p_menu I:p_rows I:p_shown",
                              "void menu_set_list(Attributes &p_menu, Integer p_rows, Integer p_shown)", 0, "", "record_set_integer");
  if (p_id == 579) test_info_set(p_info, "menu_scroll_to", "macro", "render", "render_menu", "src/render/render_menu.4dm", 266, 275, "void", "&A:p_menu R:p_value",
                              "void menu_scroll_to(Attributes &p_menu, Real p_value)", 0, "", "clamp_real, floor_integer, max_integer, menu_set_scroll, record_integer");
  if (p_id == 580) test_info_set(p_info, "menu_text_width", "macro", "render", "render_menu", "src/render/render_menu.4dm", 277, 283, "Real", "T:p_text R:p_size",
                              "Real menu_text_width(Text p_text, Real p_size)", 0, "", "");
  if (p_id == 581) test_info_set(p_info, "menu_fit_text", "macro", "render", "render_menu", "src/render/render_menu.4dm", 285, 296, "Text", "T:p_text R:p_size R:p_width",
                              "Text menu_fit_text(Text p_text, Real p_size, Real p_width)", 0, "", "floor_integer, menu_text_width");
  if (p_id == 582) test_info_set(p_info, "menu_draw_button", "macro", "render", "render_menu", "src/render/render_menu.4dm", 300, 319, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_text I:p_hover I:p_enabled",
                              "void menu_draw_button(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_hover, Integer p_enabled)", 0, "", "hud_draw_button, hud_text, menu_fit_text, render_fill_rect, render_set_colour");
  if (p_id == 583) test_info_set(p_info, "menu_draw_field", "macro", "render", "render_menu", "src/render/render_menu.4dm", 321, 344, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_text I:p_focused",
                              "void menu_draw_field(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_focused)", 0, "", "hud_text, menu_text_width, render_fill_rect, render_set_colour");
  if (p_id == 584) test_info_set(p_info, "menu_draw_slider", "macro", "render", "render_menu", "src/render/render_menu.4dm", 346, 367, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_text R:p_value I:p_hover",
                              "void menu_draw_slider(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Real p_value, Integer p_hover)", 0, "", "clamp_real, hud_draw_button, hud_text, render_fill_rect, render_set_colour");
  if (p_id == 585) test_info_set(p_info, "menu_draw_scroll", "macro", "render", "render_menu", "src/render/render_menu.4dm", 369, 384, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 R:p_value R:p_share",
                              "void menu_draw_scroll(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Real p_value, Real p_share)", 0, "", "clamp_real, max_real, render_fill_rect, render_set_colour");
  if (p_id == 586) test_info_set(p_info, "menu_draw_widgets", "macro", "render", "render_menu", "src/render/render_menu.4dm", 386, 420, "void", "B:p_box &A:p_menu R:p_now",
                              "void menu_draw_widgets(Draw_Box p_box, Attributes &p_menu, Real p_now)", 0, "", "hud_shadow_text, menu_at, menu_draw_button, menu_draw_field, menu_draw_note, menu_draw_slider, menu_field_text, menu_focus, menu_widgets, record_integer_at, record_real, record_real_at, record_text_at");
  if (p_id == 587) test_info_set(p_info, "menu_draw_title", "macro", "render", "render_menu", "src/render/render_menu.4dm", 422, 428, "void", "B:p_box R:p_w R:p_y T:p_text",
                              "void menu_draw_title(Draw_Box p_box, Real p_w, Real p_y, Text p_text)", 0, "", "hud_shadow_text");
  if (p_id == 588) test_info_set(p_info, "menu_draw_note", "macro", "render", "render_menu", "src/render/render_menu.4dm", 430, 442, "void", "B:p_box &A:p_menu R:p_w R:p_now",
                              "void menu_draw_note(Draw_Box p_box, Attributes &p_menu, Real p_w, Real p_now)", 0, "", "hud_shadow_text, record_integer, record_real, record_text");
  if (p_id == 589) test_info_set(p_info, "menu_dark_band", "macro", "render", "render_menu", "src/render/render_menu.4dm", 444, 455, "void", "B:p_box R:p_w R:p_y0 R:p_y1",
                              "void menu_dark_band(Draw_Box p_box, Real p_w, Real p_y0, Real p_y1)", 0, "", "render_fill_rect, render_set_colour");
  if (p_id == 590) test_info_set(p_info, "panorama_set_colour", "macro", "render", "render_menu", "src/render/render_menu.4dm", 459, 468, "void", "I:p_colour I:p_red I:p_green I:p_blue",
                              "void panorama_set_colour(Integer p_colour, Integer p_red, Integer p_green, Integer p_blue)", 0, "", "");
  if (p_id == 591) test_info_set(p_info, "panorama_set_row", "macro", "render", "render_menu", "src/render/render_menu.4dm", 470, 492, "void", "I:p_row T:p_cells",
                              "void panorama_set_row(Integer p_row, Text p_cells)", 0, "", "min_integer");
  if (p_id == 592) test_info_set(p_info, "menu_draw_panorama", "macro", "render", "render_menu", "src/render/render_menu.4dm", 494, 566, "void", "B:p_box R:p_w R:p_h R:p_turn R:p_shade",
                              "void menu_draw_panorama(Draw_Box p_box, Real p_w, Real p_h, Real p_turn, Real p_shade)", 0, "", "floor_integer, panorama_load, positive_mod, render_fill_rect, render_set_colour");
  if (p_id == 593) test_info_set(p_info, "menu_draw_logo", "macro", "render", "render_menu", "src/render/render_menu.4dm", 568, 586, "void", "B:p_box R:p_w R:p_h T:p_splash",
                              "void menu_draw_logo(Draw_Box p_box, Real p_w, Real p_h, Text p_splash)", 0, "", "hud_text");
  if (p_id == 594) test_info_set(p_info, "menu_on_off", "macro", "render", "render_screens", "src/render/render_screens.4dm", 25, 32, "Text", "I:p_on",
                              "Text menu_on_off(Integer p_on)", 0, "", "");
  if (p_id == 595) test_info_set(p_info, "menu_thumbnail_colour", "macro", "render", "render_screens", "src/render/render_screens.4dm", 34, 59, "Integer", "I:p_entry I:p_row I:p_column",
                              "Integer menu_thumbnail_colour(Integer p_entry, Integer p_row, Integer p_column)", 0, "", "floor_divide, positive_mod, save_listed_colour");
  if (p_id == 596) test_info_set(p_info, "menu_draw_thumbnail", "macro", "render", "render_screens", "src/render/render_screens.4dm", 61, 99, "void", "B:p_box I:p_entry I:p_has_picture R:p_x0 R:p_y0 R:p_size",
                              "void menu_draw_thumbnail(Draw_Box p_box, Integer p_entry, Integer p_has_picture, Real p_x0, Real p_y0, Real p_size)", 0, "", "floor_divide, hud_draw_item_icon, menu_thumbnail_colour, positive_mod, render_fill_rect, render_set_colour");
  if (p_id == 597) test_info_set(p_info, "screen_title", "macro", "render", "render_screens", "src/render/render_screens.4dm", 103, 129, "void", "B:p_box &A:p_menu R:p_w R:p_h T:p_splash R:p_now",
                              "void screen_title(Draw_Box p_box, Attributes &p_menu, Real p_w, Real p_h, Text p_splash, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_logo, menu_draw_widgets, menu_text_width");
  if (p_id == 598) test_info_set(p_info, "menu_list_area", "macro", "render", "render_screens", "src/render/render_screens.4dm", 133, 140, "void", "R:p_h &R:p_top &R:p_bottom",
                              "void menu_list_area(Real p_h, Real &p_top, Real &p_bottom)", 0, "", "");
  if (p_id == 599) test_info_set(p_info, "menu_world_rows_shown", "macro", "render", "render_screens", "src/render/render_screens.4dm", 142, 152, "Integer", "R:p_h",
                              "Integer menu_world_rows_shown(Real p_h)", 0, "", "floor_integer, max_integer, menu_list_area");
  if (p_id == 600) test_info_set(p_info, "menu_world_matches", "macro", "render", "render_screens", "src/render/render_screens.4dm", 154, 162, "Integer", "&A:p_worlds I:p_entry T:p_search",
                              "Integer menu_world_matches(Attributes &p_worlds, Integer p_entry, Text p_search)", 0, "", "record_text_at");
}

void test_registry_call_15(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 561 to 600 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 561) {   // menu_widget_id
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_widget_id(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 562) {   // menu_widget_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_widget_kind(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 563) {   // menu_widget_of
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_widget_of(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 564) {   // menu_at
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = menu_at(g_test_record, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 565) {   // menu_id_at
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = menu_id_at(g_test_record, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 566) {   // menu_slider_value_at
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = menu_slider_value_at(g_test_record, l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 567) {   // menu_field_text
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = menu_field_text(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 568) {   // menu_set_field_text
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    menu_set_field_text(g_test_record, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 569) {   // menu_focus
    Get_time(l_start);
    l_ret_i = menu_focus(g_test_record);
    Get_time(l_end);
  } else if (p_id == 570) {   // menu_set_focus
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    menu_set_focus(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 571) {   // menu_type_key
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = menu_type_key(g_test_record, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 572) {   // menu_set_mouse
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    menu_set_mouse(g_test_record, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 573) {   // menu_note
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    menu_note(g_test_record, l_t1, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 574) {   // menu_pick
    Get_time(l_start);
    l_ret_i = menu_pick(g_test_record);
    Get_time(l_end);
  } else if (p_id == 575) {   // menu_set_pick
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    menu_set_pick(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 576) {   // menu_scroll
    Get_time(l_start);
    l_ret_i = menu_scroll(g_test_record);
    Get_time(l_end);
  } else if (p_id == 577) {   // menu_set_scroll
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    menu_set_scroll(g_test_record, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 578) {   // menu_set_list
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    menu_set_list(g_test_record, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 579) {   // menu_scroll_to
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    menu_scroll_to(g_test_record, l_r1);
    Get_time(l_end);
  } else if (p_id == 580) {   // menu_text_width
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = menu_text_width(l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 581) {   // menu_fit_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_t = menu_fit_text(l_t1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 582) {   // menu_draw_button
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    menu_draw_button(g_test_box, l_r1, l_r2, l_r3, l_r4, l_t1, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 583) {   // menu_draw_field
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    menu_draw_field(g_test_box, l_r1, l_r2, l_r3, l_r4, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 584) {   // menu_draw_slider
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    menu_draw_slider(g_test_box, l_r1, l_r2, l_r3, l_r4, l_t1, l_r5, l_i1);
    Get_time(l_end);
  } else if (p_id == 585) {   // menu_draw_scroll
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    menu_draw_scroll(g_test_box, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
  } else if (p_id == 586) {   // menu_draw_widgets
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    menu_draw_widgets(g_test_box, g_test_record, l_r1);
    Get_time(l_end);
  } else if (p_id == 587) {   // menu_draw_title
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    menu_draw_title(g_test_box, l_r1, l_r2, l_t1);
    Get_time(l_end);
  } else if (p_id == 588) {   // menu_draw_note
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    menu_draw_note(g_test_box, g_test_record, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 589) {   // menu_dark_band
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    menu_dark_band(g_test_box, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 590) {   // panorama_set_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    panorama_set_colour(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 591) {   // panorama_set_row
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    panorama_set_row(l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 592) {   // menu_draw_panorama
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    menu_draw_panorama(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 593) {   // menu_draw_logo
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    menu_draw_logo(g_test_box, l_r1, l_r2, l_t1);
    Get_time(l_end);
  } else if (p_id == 594) {   // menu_on_off
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = menu_on_off(l_i1);
    Get_time(l_end);
  } else if (p_id == 595) {   // menu_thumbnail_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = menu_thumbnail_colour(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 596) {   // menu_draw_thumbnail
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    menu_draw_thumbnail(g_test_box, l_i1, l_i2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 597) {   // screen_title
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_title(g_test_box, g_test_record, l_r1, l_r2, l_t1, l_r3);
    Get_time(l_end);
  } else if (p_id == 598) {   // menu_list_area
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    menu_list_area(l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 599) {   // menu_world_rows_shown
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = menu_world_rows_shown(l_r1);
    Get_time(l_end);
  } else if (p_id == 600) {   // menu_world_matches
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = menu_world_matches(g_test_record, l_i1, l_t1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_16(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 601 to 640 are
// ----------------------------------------------------------------
{
  if (p_id == 601) test_info_set(p_info, "menu_worlds_shown", "macro", "render", "render_screens", "src/render/render_screens.4dm", 164, 176, "Integer", "&A:p_worlds T:p_search",
                              "Integer menu_worlds_shown(Attributes &p_worlds, Text p_search)", 0, "", "menu_world_matches, record_integer");
  if (p_id == 602) test_info_set(p_info, "menu_world_entry", "macro", "render", "render_screens", "src/render/render_screens.4dm", 178, 193, "Integer", "&A:p_worlds T:p_search I:p_shown",
                              "Integer menu_world_entry(Attributes &p_worlds, Text p_search, Integer p_shown)", 0, "", "menu_world_matches, record_integer");
  if (p_id == 603) test_info_set(p_info, "screen_worlds", "macro", "render", "render_screens", "src/render/render_screens.4dm", 195, 289, "void", "B:p_box &A:p_menu &A:p_worlds R:p_w R:p_h R:p_now",
                              "void screen_worlds(Draw_Box p_box, Attributes &p_menu, Attributes &p_worlds, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, hud_text, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_thumbnail, menu_draw_title, menu_draw_widgets, menu_field_text, menu_fit_text, menu_list_area, menu_pick, menu_scroll, menu_set_list, menu_set_value, menu_text_width, menu_world_entry, menu_world_rows_shown, menu_worlds_shown, player_game_mode_name, record_integer, record_integer_at, record_text_at, render_fill_rect, render_set_colour");
  if (p_id == 604) test_info_set(p_info, "screen_create", "macro", "render", "render_screens", "src/render/render_screens.4dm", 293, 322, "void", "B:p_box &A:p_menu I:p_mode R:p_w R:p_h R:p_now",
                              "void screen_create(Draw_Box p_box, Attributes &p_menu, Integer p_mode, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_title, menu_draw_widgets, player_game_mode_name");
  if (p_id == 605) test_info_set(p_info, "screen_delete", "macro", "render", "render_screens", "src/render/render_screens.4dm", 324, 340, "void", "B:p_box &A:p_menu T:p_name R:p_w R:p_h R:p_now",
                              "void screen_delete(Draw_Box p_box, Attributes &p_menu, Text p_name, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_title, menu_draw_widgets");
  if (p_id == 606) test_info_set(p_info, "screen_player", "macro", "render", "render_screens", "src/render/render_screens.4dm", 344, 370, "void", "B:p_box &A:p_menu I:p_join R:p_w R:p_h R:p_now",
                              "void screen_player(Draw_Box p_box, Attributes &p_menu, Integer p_join, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_title, menu_draw_widgets");
  if (p_id == 607) test_info_set(p_info, "screen_options", "macro", "render", "render_screens", "src/render/render_screens.4dm", 374, 428, "void", "B:p_box &A:p_menu &A:p_settings R:p_w R:p_h R:p_now",
                              "void screen_options(Draw_Box p_box, Attributes &p_menu, Attributes &p_settings, Real p_w, Real p_h, Real p_now)", 0, "", "menu_add, menu_begin, menu_draw_title, menu_draw_widgets, menu_on_off, menu_set_value, record_integer, settings_detail, settings_flag, settings_fov_degrees, settings_render_distance");
  if (p_id == 608) test_info_set(p_info, "screen_packs", "macro", "render", "render_screens", "src/render/render_screens.4dm", 432, 506, "void", "B:p_box &A:p_menu &A:p_files T:p_selected R:p_w R:p_h R:p_now",
                              "void screen_packs(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_selected, Real p_w, Real p_h, Real p_now)", 0, "", "floor_integer, hud_shadow_text, hud_text, max_integer, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_title, menu_draw_widgets, menu_fit_text, menu_id_at, menu_scroll, menu_set_list, menu_set_value, menu_widget_id, menu_widget_kind, menu_widgets, record_integer, record_real, record_real_at, record_text_at, render_fill_rect, render_set_colour, save_file_name");
  if (p_id == 609) test_info_set(p_info, "screen_skins", "macro", "render", "render_screens", "src/render/render_screens.4dm", 508, 582, "void", "B:p_box &A:p_menu &A:p_files T:p_selected R:p_w R:p_h R:p_now",
                              "void screen_skins(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_selected, Real p_w, Real p_h, Real p_now)", 0, "", "floor_integer, hud_draw_figure, hud_shadow_text, hud_text, max_integer, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_title, menu_draw_widgets, menu_fit_text, menu_id_at, menu_scroll, menu_set_list, menu_set_value, menu_widget_id, menu_widget_kind, menu_widgets, min_real, record_integer, record_real, record_real_at, record_text_at, render_fill_rect, render_set_colour");
  if (p_id == 610) test_info_set(p_info, "screen_fonts", "macro", "render", "render_screens", "src/render/render_screens.4dm", 584, 670, "void", "B:p_box &A:p_menu &A:p_files T:p_font T:p_font_file R:p_w R:p_h R:p_now",
                              "void screen_fonts(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_font, Text p_font_file, Real p_w, Real p_h, Real p_now)", 0, "", "floor_integer, font_apply, font_choice, hud_shadow_text, hud_text, max_integer, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_title, menu_draw_widgets, menu_fit_text, menu_id_at, menu_scroll, menu_set_list, menu_set_value, menu_widget_id, menu_widget_kind, menu_widgets, record_integer, record_real, record_real_at, record_text_at, render_fill_rect, render_set_colour");
  if (p_id == 611) test_info_set(p_info, "ui_clear", "macro", "render", "render_ui", "src/render/render_ui.4dm", 20, 35, "void", "&A:p_ui",
                              "void ui_clear(Attributes &p_ui)", 0, "", "record_clear, record_set_integer, ui_set_mouse, ui_set_search");
  if (p_id == 612) test_info_set(p_info, "ui_screen", "macro", "render", "render_ui", "src/render/render_ui.4dm", 37, 43, "Integer", "&A:p_ui",
                              "Integer ui_screen(Attributes &p_ui)", 0, "", "record_integer");
  if (p_id == 613) test_info_set(p_info, "ui_furnace", "macro", "render", "render_ui", "src/render/render_ui.4dm", 45, 51, "Integer", "&A:p_ui",
                              "Integer ui_furnace(Attributes &p_ui)", 0, "", "record_integer");
  if (p_id == 614) test_info_set(p_info, "ui_mouse", "macro", "render", "render_ui", "src/render/render_ui.4dm", 53, 60, "void", "&A:p_ui &R:p_x &R:p_y",
                              "void ui_mouse(Attributes &p_ui, Real &p_x, Real &p_y)", 0, "", "record_real");
  if (p_id == 615) test_info_set(p_info, "ui_set_mouse", "macro", "render", "render_ui", "src/render/render_ui.4dm", 62, 70, "void", "&A:p_ui R:p_x R:p_y",
                              "void ui_set_mouse(Attributes &p_ui, Real p_x, Real p_y)", 0, "", "record_set_real");
  if (p_id == 616) test_info_set(p_info, "ui_set_tabs", "macro", "render", "render_ui", "src/render/render_ui.4dm", 74, 81, "void", "&A:p_ui I:p_creative",
                              "void ui_set_tabs(Attributes &p_ui, Integer p_creative)", 0, "", "record_set_integer");
  if (p_id == 617) test_info_set(p_info, "ui_search", "macro", "render", "render_ui", "src/render/render_ui.4dm", 83, 89, "Text", "&A:p_ui",
                              "Text ui_search(Attributes &p_ui)", 0, "", "record_text");
  if (p_id == 618) test_info_set(p_info, "ui_set_search", "macro", "render", "render_ui", "src/render/render_ui.4dm", 91, 114, "void", "&A:p_ui T:p_search",
                              "void ui_set_search(Attributes &p_ui, Text p_search)", 0, "", "item_name, record_set_integer, record_set_integer_at, record_set_text");
  if (p_id == 619) test_info_set(p_info, "ui_type_search", "macro", "render", "render_ui", "src/render/render_ui.4dm", 116, 127, "void", "&A:p_ui T:p_key",
                              "void ui_type_search(Attributes &p_ui, Text p_key)", 0, "", "text_after_key, ui_search, ui_set_search");
  if (p_id == 620) test_info_set(p_info, "ui_creative_count", "macro", "render", "render_ui", "src/render/render_ui.4dm", 129, 135, "Integer", "&A:p_ui",
                              "Integer ui_creative_count(Attributes &p_ui)", 0, "", "record_integer");
  if (p_id == 621) test_info_set(p_info, "ui_creative_rows", "macro", "render", "render_ui", "src/render/render_ui.4dm", 137, 143, "Integer", "&A:p_ui",
                              "Integer ui_creative_rows(Attributes &p_ui)", 0, "", "floor_divide, ui_creative_count");
  if (p_id == 622) test_info_set(p_info, "ui_creative_item", "macro", "render", "render_ui", "src/render/render_ui.4dm", 145, 156, "Integer", "&A:p_ui I:p_slot",
                              "Integer ui_creative_item(Attributes &p_ui, Integer p_slot)", 0, "", "record_integer, record_integer_at, ui_creative_count");
  if (p_id == 623) test_info_set(p_info, "ui_creative_click", "macro", "render", "render_ui", "src/render/render_ui.4dm", 158, 181, "void", "&A:p_ui &A:p_inventory I:p_slot I:p_right_button",
                              "void ui_creative_click(Attributes &p_ui, Attributes &p_inventory, Integer p_slot, Integer p_right_button)", 0, "", "item_max_stack, slot_clear, slot_count, slot_item, slot_set, ui_creative_item");
  if (p_id == 624) test_info_set(p_info, "ui_open", "macro", "render", "render_ui", "src/render/render_ui.4dm", 185, 222, "void", "&A:p_ui &A:p_grid &A:p_furnaces &A:p_events I:p_screen I:p_x I:p_y I:p_z",
                              "void ui_open(Attributes &p_ui, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_events, Integer p_screen, Integer p_x, Integer p_y, Integer p_z)", 0, "", "chest_get_or_create, emit_toast, furnace_get_or_create, grid_clear, record_set_integer, ui_set_search");
  if (p_id == 625) test_info_set(p_info, "ui_close", "macro", "render", "render_ui", "src/render/render_ui.4dm", 224, 236, "void", "&A:p_ui &A:p_inventory &A:p_grid &A:p_events R:p_drop_x R:p_drop_y R:p_drop_z",
                              "void ui_close(Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_events, Real p_drop_x, Real p_drop_y, Real p_drop_z)", 0, "", "grid_return_items, inventory_return_cursor, record_set_integer");
  if (p_id == 626) test_info_set(p_info, "ui_on_event", "macro", "render", "render_ui", "src/render/render_ui.4dm", 238, 259, "void", "&A:p_event &A:p_ui &A:p_inventory &A:p_grid &A:p_furnaces &A:p_events R:p_drop_x R:p_drop_y R:p_drop_z",
                              "void ui_on_event(Attributes &p_event, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_events, Real p_drop_x, Real p_drop_y, Real p_drop_z)", 0, "", "event_integer, event_type, record_integer, ui_close, ui_open, ui_screen");
  if (p_id == 627) test_info_set(p_info, "ui_layout", "macro", "render", "render_ui", "src/render/render_ui.4dm", 263, 291, "void", "I:p_screen R:p_w R:p_h &R:p_slot_size &R:p_x0 &R:p_y0 &R:p_x1 &R:p_y1 &R:p_inv_x &R:p_inv_y &R:p_top_y",
                              "void ui_layout(Integer p_screen, Real p_w, Real p_h, Real &p_slot_size, Real &p_x0, Real &p_y0, Real &p_x1, Real &p_y1, Real &p_inv_x, Real &p_inv_y, Real &p_top_y)", 0, "", "clamp_real, max_real, min_real");
  if (p_id == 628) test_info_set(p_info, "ui_slot_rect", "macro", "render", "render_ui", "src/render/render_ui.4dm", 293, 433, "Integer", "I:p_screen I:p_grid_width I:p_slot R:p_w R:p_h &R:p_x &R:p_y &R:p_size",
                              "Integer ui_slot_rect(Integer p_screen, Integer p_grid_width, Integer p_slot, Real p_w, Real p_h, Real &p_x, Real &p_y, Real &p_size)", 0, "", "floor_divide, positive_mod, ui_layout");
  if (p_id == 629) test_info_set(p_info, "ui_inventory_slot", "macro", "render", "render_ui", "src/render/render_ui.4dm", 435, 445, "Integer", "I:p_slot",
                              "Integer ui_inventory_slot(Integer p_slot)", 0, "", "inventory_armour_slot");
  if (p_id == 630) test_info_set(p_info, "ui_slot_at", "macro", "render", "render_ui", "src/render/render_ui.4dm", 447, 462, "Integer", "I:p_screen I:p_grid_width R:p_px R:p_py R:p_w R:p_h",
                              "Integer ui_slot_at(Integer p_screen, Integer p_grid_width, Real p_px, Real p_py, Real p_w, Real p_h)", 0, "", "ui_slot_rect");
  if (p_id == 631) test_info_set(p_info, "ui_click", "macro", "render", "render_ui", "src/render/render_ui.4dm", 466, 561, "void", "&A:p_ui &A:p_inventory &A:p_grid &A:p_furnaces &A:p_book &A:p_events R:p_x R:p_y I:p_right_button R:p_w R:p_h",
                              "void ui_click(Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_book, Attributes &p_events, Real p_x, Real p_y, Integer p_right_button, Real p_w, Real p_h)", 0, "", "chest_slot, crafting_take_output, emit_event, emit_simple_event, emit_toast, furnace_slot, grid_width, inventory_fits_slot, item_fuel_seconds, max_integer, min_integer, record_integer, record_set_integer, slot_click_left, slot_click_right, slot_item, ui_creative_click, ui_creative_rows, ui_furnace, ui_inventory_slot, ui_screen, ui_slot_at");
  if (p_id == 632) test_info_set(p_info, "ui_draw_arrow", "macro", "render", "render_ui", "src/render/render_ui.4dm", 565, 581, "void", "B:p_box R:p_x R:p_y R:p_length R:p_size R:p_progress",
                              "void ui_draw_arrow(Draw_Box p_box, Real p_x, Real p_y, Real p_length, Real p_size, Real p_progress)", 0, "", "min_real, render_fill_rect, render_set_colour");
  if (p_id == 633) test_info_set(p_info, "ui_draw_furnace", "macro", "render", "render_ui", "src/render/render_ui.4dm", 583, 624, "void", "B:p_box &A:p_furnaces I:p_furnace R:p_w R:p_h",
                              "void ui_draw_furnace(Draw_Box p_box, Attributes &p_furnaces, Integer p_furnace, Real p_w, Real p_h)", 0, "", "clamp_real, furnace_burn_left, furnace_burn_total, furnace_progress, render_fill_rect, render_set_colour, ui_draw_arrow, ui_layout");
  if (p_id == 634) test_info_set(p_info, "ui_draw_tab", "macro", "render", "render_ui", "src/render/render_ui.4dm", 626, 647, "void", "B:p_box R:p_x R:p_y R:p_size I:p_slot I:p_screen I:p_hovered",
                              "void ui_draw_tab(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_slot, Integer p_screen, Integer p_hovered)", 0, "", "hud_draw_item_icon, hud_frame, render_fill_rect, render_set_colour");
  if (p_id == 635) test_info_set(p_info, "ui_draw_scroll", "macro", "render", "render_ui", "src/render/render_ui.4dm", 649, 670, "void", "B:p_box R:p_x R:p_y R:p_size I:p_up I:p_hovered",
                              "void ui_draw_scroll(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_up, Integer p_hovered)", 0, "", "hud_draw_slot_style, render_set_colour");
  if (p_id == 636) test_info_set(p_info, "ui_draw_search", "macro", "render", "render_ui", "src/render/render_ui.4dm", 672, 693, "void", "B:p_box &A:p_ui R:p_x R:p_y R:p_width R:p_size",
                              "void ui_draw_search(Draw_Box p_box, Attributes &p_ui, Real p_x, Real p_y, Real p_width, Real p_size)", 0, "", "hud_text, render_fill_rect, render_line, render_set_colour, ui_search");
  if (p_id == 637) test_info_set(p_info, "ui_draw", "macro", "render", "render_ui", "src/render/render_ui.4dm", 695, 821, "void", "B:p_box R:p_w R:p_h &A:p_ui &A:p_inventory &A:p_grid &A:p_furnaces &A:p_book",
                              "void ui_draw(Draw_Box p_box, Real p_w, Real p_h, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_book)", 0, "", "chest_slot, crafting_match, crafting_recipe_output, furnace_slot, grid_width, hud_draw_figure, hud_draw_item_icon, hud_draw_slot_style, hud_frame, hud_shadow_text, inventory_armour_slot, item_name, record_integer, record_integer_at, render_fill_rect, render_set_colour, slot_count, slot_damage, slot_item, ui_creative_item, ui_creative_rows, ui_draw_arrow, ui_draw_furnace, ui_draw_scroll, ui_draw_search, ui_draw_tab, ui_furnace, ui_inventory_slot, ui_layout, ui_mouse, ui_screen, ui_slot_at, ui_slot_rect");
  if (p_id == 638) test_info_set(p_info, "render_init", "macro", "render", "render_world", "src/render/render_world.4dm", 24, 46, "void", "",
                              "void render_init()", 0, "", "hash_real, render_set_detail");
  if (p_id == 639) test_info_set(p_info, "render_set_detail", "macro", "render", "render_world", "src/render/render_world.4dm", 48, 68, "void", "I:p_level",
                              "void render_set_detail(Integer p_level)", 0, "", "");
  if (p_id == 640) test_info_set(p_info, "render_view_from", "macro", "render", "render_world", "src/render/render_world.4dm", 70, 93, "void", "&A:p_player &A:p_settings R:p_time_of_day R:p_now",
                              "void render_view_from(Attributes &p_player, Attributes &p_settings, Real p_time_of_day, Real p_now)", 0, "", "player_break_stage, player_eye_in_water, player_target_cell, player_target_kind, record_integer, render_set_detail, settings_detail, settings_flag, settings_render_distance, world_daylight");
}

void test_registry_call_16(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 601 to 640 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 601) {   // menu_worlds_shown
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = menu_worlds_shown(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 602) {   // menu_world_entry
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_world_entry(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 603) {   // screen_worlds
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_worlds(g_test_box, g_test_record, g_test_record_2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 604) {   // screen_create
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_create(g_test_box, g_test_record, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 605) {   // screen_delete
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_delete(g_test_box, g_test_record, l_t1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 606) {   // screen_player
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_player(g_test_box, g_test_record, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 607) {   // screen_options
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_options(g_test_box, g_test_record, g_settings, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 608) {   // screen_packs
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_packs(g_test_box, g_test_record, g_test_record_2, l_t1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 609) {   // screen_skins
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_skins(g_test_box, g_test_record, g_test_record_2, l_t1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 610) {   // screen_fonts
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_fonts(g_test_box, g_test_record, g_test_record_2, l_t1, l_t2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 611) {   // ui_clear
    Get_time(l_start);
    ui_clear(g_ui);
    Get_time(l_end);
  } else if (p_id == 612) {   // ui_screen
    Get_time(l_start);
    l_ret_i = ui_screen(g_ui);
    Get_time(l_end);
  } else if (p_id == 613) {   // ui_furnace
    Get_time(l_start);
    l_ret_i = ui_furnace(g_ui);
    Get_time(l_end);
  } else if (p_id == 614) {   // ui_mouse
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    ui_mouse(g_ui, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 615) {   // ui_set_mouse
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    ui_set_mouse(g_ui, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 616) {   // ui_set_tabs
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    ui_set_tabs(g_ui, l_i1);
    Get_time(l_end);
  } else if (p_id == 617) {   // ui_search
    Get_time(l_start);
    l_ret_t = ui_search(g_ui);
    Get_time(l_end);
  } else if (p_id == 618) {   // ui_set_search
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    ui_set_search(g_ui, l_t1);
    Get_time(l_end);
  } else if (p_id == 619) {   // ui_type_search
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    ui_type_search(g_ui, l_t1);
    Get_time(l_end);
  } else if (p_id == 620) {   // ui_creative_count
    Get_time(l_start);
    l_ret_i = ui_creative_count(g_ui);
    Get_time(l_end);
  } else if (p_id == 621) {   // ui_creative_rows
    Get_time(l_start);
    l_ret_i = ui_creative_rows(g_ui);
    Get_time(l_end);
  } else if (p_id == 622) {   // ui_creative_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = ui_creative_item(g_ui, l_i1);
    Get_time(l_end);
  } else if (p_id == 623) {   // ui_creative_click
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    ui_creative_click(g_ui, g_inventory, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 624) {   // ui_open
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    ui_open(g_ui, g_grid, g_furnaces, g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 625) {   // ui_close
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    ui_close(g_ui, g_inventory, g_grid, g_events, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 626) {   // ui_on_event
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    ui_on_event(g_event, g_ui, g_inventory, g_grid, g_furnaces, g_events, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 627) {   // ui_layout
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    l_r9 = record_real(p_in, ATTR_TEST_R9);
    l_r10 = record_real(p_in, ATTR_TEST_R10);
    Get_time(l_start);
    ui_layout(l_i1, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8, l_r9, l_r10);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
    record_set_real(p_out, ATTR_TEST_R4, l_r4);
    record_set_real(p_out, ATTR_TEST_R5, l_r5);
    record_set_real(p_out, ATTR_TEST_R6, l_r6);
    record_set_real(p_out, ATTR_TEST_R7, l_r7);
    record_set_real(p_out, ATTR_TEST_R8, l_r8);
    record_set_real(p_out, ATTR_TEST_R9, l_r9);
    record_set_real(p_out, ATTR_TEST_R10, l_r10);
  } else if (p_id == 628) {   // ui_slot_rect
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    l_ret_i = ui_slot_rect(l_i1, l_i2, l_i3, l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
    record_set_real(p_out, ATTR_TEST_R4, l_r4);
    record_set_real(p_out, ATTR_TEST_R5, l_r5);
  } else if (p_id == 629) {   // ui_inventory_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = ui_inventory_slot(l_i1);
    Get_time(l_end);
  } else if (p_id == 630) {   // ui_slot_at
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = ui_slot_at(l_i1, l_i2, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 631) {   // ui_click
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    ui_click(g_ui, g_inventory, g_grid, g_furnaces, g_book, g_events, l_r1, l_r2, l_i1, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 632) {   // ui_draw_arrow
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    ui_draw_arrow(g_test_box, l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 633) {   // ui_draw_furnace
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    ui_draw_furnace(g_test_box, g_furnaces, l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 634) {   // ui_draw_tab
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    ui_draw_tab(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 635) {   // ui_draw_scroll
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    ui_draw_scroll(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 636) {   // ui_draw_search
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    ui_draw_search(g_test_box, g_ui, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 637) {   // ui_draw
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    ui_draw(g_test_box, l_r1, l_r2, g_ui, g_inventory, g_grid, g_furnaces, g_book);
    Get_time(l_end);
  } else if (p_id == 638) {   // render_init
    Get_time(l_start);
    render_init();
    Get_time(l_end);
  } else if (p_id == 639) {   // render_set_detail
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_set_detail(l_i1);
    Get_time(l_end);
  } else if (p_id == 640) {   // render_view_from
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    render_view_from(g_player, g_settings, l_r1, l_r2);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_17(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 641 to 680 are
// ----------------------------------------------------------------
{
  if (p_id == 641) test_info_set(p_info, "render_stats_text", "macro", "render", "render_world", "src/render/render_world.4dm", 95, 101, "Text", "",
                              "Text render_stats_text()", 0, "", "");
  if (p_id == 642) test_info_set(p_info, "render_set_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 105, 122, "void", "B:p_box R:p_red R:p_green R:p_blue",
                              "void render_set_colour(Draw_Box p_box, Real p_red, Real p_green, Real p_blue)", 0, "", "to_byte");
  if (p_id == 643) test_info_set(p_info, "render_forget_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 124, 131, "void", "",
                              "void render_forget_colour()", 0, "", "");
  if (p_id == 644) test_info_set(p_info, "render_set_shade", "macro", "render", "render_world", "src/render/render_world.4dm", 133, 140, "void", "R:p_shade",
                              "void render_set_shade(Real p_shade)", 0, "", "clamp_real");
  if (p_id == 645) test_info_set(p_info, "render_set_face_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 142, 158, "void", "B:p_box R:p_red R:p_green R:p_blue",
                              "void render_set_face_colour(Draw_Box p_box, Real p_red, Real p_green, Real p_blue)", 0, "", "");
  if (p_id == 646) test_info_set(p_info, "render_fill_rect", "macro", "render", "render_world", "src/render/render_world.4dm", 160, 174, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1",
                              "void render_fill_rect(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)", 0, "", "");
  if (p_id == 647) test_info_set(p_info, "render_line", "macro", "render", "render_world", "src/render/render_world.4dm", 176, 183, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1",
                              "void render_line(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)", 0, "", "");
  if (p_id == 648) test_info_set(p_info, "render_setup_camera", "macro", "render", "render_world", "src/render/render_world.4dm", 187, 242, "void", "R:p_w R:p_h R:p_view_bottom R:p_eye_x R:p_eye_y R:p_eye_z R:p_yaw R:p_pitch R:p_field_of_view",
                              "void render_setup_camera(Real p_w, Real p_h, Real p_view_bottom, Real p_eye_x, Real p_eye_y, Real p_eye_z, Real p_yaw, Real p_pitch, Real p_field_of_view)", 0, "", "min_real, render_sky_colours");
  if (p_id == 649) test_info_set(p_info, "render_to_camera", "macro", "render", "render_world", "src/render/render_world.4dm", 244, 253, "void", "R:p_rel_x R:p_rel_y R:p_rel_z",
                              "void render_to_camera(Real p_rel_x, Real p_rel_y, Real p_rel_z)", 0, "", "");
  if (p_id == 650) test_info_set(p_info, "render_sphere_visible", "macro", "render", "render_world", "src/render/render_world.4dm", 255, 269, "Integer", "R:p_rel_x R:p_rel_y R:p_rel_z R:p_radius",
                              "Integer render_sphere_visible(Real p_rel_x, Real p_rel_y, Real p_rel_z, Real p_radius)", 0, "", "render_to_camera");
  if (p_id == 651) test_info_set(p_info, "render_add_face", "macro", "render", "render_world", "src/render/render_world.4dm", 273, 334, "void", "R:p_c0x R:p_c0y R:p_c0z R:p_e1x R:p_e1y R:p_e1z R:p_e2x R:p_e2y R:p_e2z I:p_tex R:p_shade R:p_distance_squared R:p_size R:p_tint I:p_crack",
                              "void render_add_face(Real p_c0x, Real p_c0y, Real p_c0z, Real p_e1x, Real p_e1y, Real p_e1z, Real p_e2x, Real p_e2y, Real p_e2z, Integer p_tex, Real p_shade, Real p_distance_squared, Real p_size, Real p_tint, Integer p_crack)", 0, "", "clamp_real, max_real");
  if (p_id == 652) test_info_set(p_info, "render_add_block_face", "macro", "render", "render_world", "src/render/render_world.4dm", 336, 417, "void", "I:p_x I:p_y I:p_z I:p_direction I:p_block R:p_distance_squared I:p_crack R:p_light R:p_wet",
                              "void render_add_block_face(Integer p_x, Integer p_y, Integer p_z, Integer p_direction, Integer p_block, Real p_distance_squared, Integer p_crack, Real p_light, Real p_wet)", 0, "", "block_face_shade, block_face_texture, block_hides_faces, render_add_face");
  if (p_id == 653) test_info_set(p_info, "render_add_sprite", "macro", "render", "render_world", "src/render/render_world.4dm", 419, 434, "void", "R:p_rel_x R:p_rel_y R:p_rel_z R:p_half_width R:p_height I:p_tex R:p_shade R:p_distance_squared",
                              "void render_add_sprite(Real p_rel_x, Real p_rel_y, Real p_rel_z, Real p_half_width, Real p_height, Integer p_tex, Real p_shade, Real p_distance_squared)", 0, "", "render_add_face, render_to_camera");
  if (p_id == 654) test_info_set(p_info, "render_add_shaped", "macro", "render", "render_world", "src/render/render_world.4dm", 436, 492, "void", "I:p_x I:p_y I:p_z I:p_block R:p_light",
                              "void render_add_shaped(Integer p_x, Integer p_y, Integer p_z, Integer p_block, Real p_light)", 0, "", "block_bed_facing, block_bed_head, block_box, block_door_top, block_is_door, render_add_box");
  if (p_id == 655) test_info_set(p_info, "render_add_plant", "macro", "render", "render_world", "src/render/render_world.4dm", 494, 589, "void", "I:p_x I:p_y I:p_z I:p_tex R:p_light",
                              "void render_add_plant(Integer p_x, Integer p_y, Integer p_z, Integer p_tex, Real p_light)", 0, "", "render_add_face, render_to_camera");
  if (p_id == 656) test_info_set(p_info, "render_layer_count", "macro", "render", "render_world", "src/render/render_world.4dm", 591, 602, "Integer", "R:p_limit",
                              "Integer render_layer_count(Real p_limit)", 0, "", "floor_integer");
  if (p_id == 657) test_info_set(p_info, "render_collect_blocks", "macro", "render", "render_world", "src/render/render_world.4dm", 604, 809, "void", "",
                              "void render_collect_blocks()", 0, "", "block_is_shaped, block_plant_texture, clamp_integer, floor_integer, max_real, mesh_ensure_section, min_integer, render_add_block_face, render_add_plant, render_add_shaped, render_layer_count, render_sphere_visible");
  if (p_id == 658) test_info_set(p_info, "render_side_shade", "macro", "render", "render_world", "src/render/render_world.4dm", 811, 818, "Real", "R:p_normal_x R:p_normal_z",
                              "Real render_side_shade(Real p_normal_x, Real p_normal_z)", 0, "", "");
  if (p_id == 659) test_info_set(p_info, "render_add_box", "macro", "render", "render_world", "src/render/render_world.4dm", 820, 921, "void", "R:p_centre_x R:p_centre_y R:p_centre_z R:p_yaw R:p_pitch R:p_half_f R:p_half_y R:p_half_s I:p_tex_side I:p_tex_top I:p_tex_front I:p_tex_back R:p_tint R:p_sort_dist_sq",
                              "void render_add_box(Real p_centre_x, Real p_centre_y, Real p_centre_z, Real p_yaw, Real p_pitch, Real p_half_f, Real p_half_y, Real p_half_s, Integer p_tex_side, Integer p_tex_top, Integer p_tex_front, Integer p_tex_back, Real p_tint, Real p_sort_dist_sq)", 0, "", "max_real, render_add_face, render_side_shade, render_sphere_visible, render_to_camera");
  if (p_id == 660) test_info_set(p_info, "render_light_at", "macro", "render", "render_world", "src/render/render_world.4dm", 923, 932, "Real", "R:p_x R:p_y R:p_z",
                              "Real render_light_at(Real p_x, Real p_y, Real p_z)", 0, "", "floor_integer, max_real, world_get_light");
  if (p_id == 661) test_info_set(p_info, "render_mob_begin", "macro", "render", "render_world", "src/render/render_world.4dm", 934, 946, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_tint",
                              "void render_mob_begin(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_tint)", 0, "", "");
  if (p_id == 662) test_info_set(p_info, "render_mob_part", "macro", "render", "render_world", "src/render/render_world.4dm", 948, 983, "void", "R:p_along R:p_up R:p_across R:p_half_f R:p_half_y R:p_half_s R:p_turn R:p_pitch I:p_hip I:p_tex_side I:p_tex_top I:p_tex_front I:p_tex_back",
                              "void render_mob_part(Real p_along, Real p_up, Real p_across, Real p_half_f, Real p_half_y, Real p_half_s, Real p_turn, Real p_pitch, Integer p_hip, Integer p_tex_side, Integer p_tex_top, Integer p_tex_front, Integer p_tex_back)", 0, "", "");
  if (p_id == 663) test_info_set(p_info, "render_mob_part_nearer", "macro", "render", "render_world", "src/render/render_world.4dm", 985, 1008, "Integer", "I:p_a I:p_b R:p_eye_along R:p_eye_up R:p_eye_across",
                              "Integer render_mob_part_nearer(Integer p_a, Integer p_b, Real p_eye_along, Real p_eye_up, Real p_eye_across)", 0, "", "");
  if (p_id == 664) test_info_set(p_info, "render_mob_end", "macro", "render", "render_world", "src/render/render_world.4dm", 1010, 1053, "void", "",
                              "void render_mob_end()", 0, "", "render_add_box, render_mob_part_nearer");
  if (p_id == 665) test_info_set(p_info, "render_mob_head_look", "macro", "render", "render_world", "src/render/render_world.4dm", 1055, 1076, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_head_up R:p_idle &R:p_turn &R:p_pitch",
                              "void render_mob_head_look(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_head_up, Real p_idle, Real &p_turn, Real &p_pitch)", 0, "", "angle_of, clamp_real, wrap_angle");
  if (p_id == 666) test_info_set(p_info, "render_zombie", "macro", "render", "render_world", "src/render/render_world.4dm", 1078, 1097, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_swing R:p_tint R:p_idle",
                              "void render_zombie(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)", 0, "", "render_mob_begin, render_mob_end, render_mob_head_look, render_mob_part");
  if (p_id == 667) test_info_set(p_info, "render_cow", "macro", "render", "render_world", "src/render/render_world.4dm", 1099, 1126, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_swing R:p_tint R:p_idle",
                              "void render_cow(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)", 0, "", "render_mob_begin, render_mob_end, render_mob_head_look, render_mob_part");
  if (p_id == 668) test_info_set(p_info, "render_pig", "macro", "render", "render_world", "src/render/render_world.4dm", 1128, 1151, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_swing R:p_tint R:p_idle",
                              "void render_pig(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)", 0, "", "render_mob_begin, render_mob_end, render_mob_head_look, render_mob_part");
  if (p_id == 669) test_info_set(p_info, "render_person", "macro", "render", "render_world", "src/render/render_world.4dm", 1153, 1208, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_head_turn R:p_pitch R:p_swing I:p_crouch I:p_helmet I:p_chestplate I:p_leggings I:p_boots",
                              "void render_person(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_head_turn, Real p_pitch, Real p_swing, Integer p_crouch, Integer p_helmet, Integer p_chestplate, Integer p_leggings, Integer p_boots)", 0, "", "render_mob_begin, render_mob_end, render_mob_part");
  if (p_id == 670) test_info_set(p_info, "render_camera_place", "macro", "render", "render_world", "src/render/render_world.4dm", 1210, 1261, "void", "&A:p_player &R:p_x &R:p_y &R:p_z &R:p_yaw &R:p_pitch",
                              "void render_camera_place(Attributes &p_player, Real &p_x, Real &p_y, Real &p_z, Real &p_yaw, Real &p_pitch)", 0, "", "block_is_solid, floor_integer, max_real, min_real, player_camera, player_eye_y, player_look, player_position, world_get_block, wrap_angle");
  if (p_id == 671) test_info_set(p_info, "render_collect_self", "macro", "render", "render_world", "src/render/render_world.4dm", 1263, 1284, "void", "&A:p_player &A:p_inventory",
                              "void render_collect_self(Attributes &p_player, Attributes &p_inventory)", 0, "", "inventory_armour_slot, player_bob, player_body_yaw, player_camera, player_crouching, player_look, player_position, player_spectator, player_stride, render_light_at, render_person, slot_is_empty, wrap_angle");
  if (p_id == 672) test_info_set(p_info, "render_collect_peers", "macro", "render", "render_world", "src/render/render_world.4dm", 1286, 1304, "void", "&A:p_peers",
                              "void render_collect_peers(Attributes &p_peers)", 0, "", "peer_here, peer_pitch, peer_position, peer_step, peer_yaw, peers_count, render_light_at, render_person");
  if (p_id == 673) test_info_set(p_info, "render_peer_names", "macro", "render", "render_world", "src/render/render_world.4dm", 1306, 1335, "void", "B:p_box &A:p_peers",
                              "void render_peer_names(Draw_Box p_box, Attributes &p_peers)", 0, "", "hud_text, peer_here, peer_name, peer_position, peers_count, render_fill_rect, render_set_colour, render_to_camera");
  if (p_id == 674) test_info_set(p_info, "render_collect_cows", "macro", "render", "render_world", "src/render/render_world.4dm", 1337, 1374, "void", "&A:p_cows",
                              "void render_collect_cows(Attributes &p_cows)", 0, "", "cow_flash, cow_position, cow_step, cow_yaw, mob_kind, render_cow, render_light_at, render_pig, render_zombie, slots_at, slots_count");
  if (p_id == 675) test_info_set(p_info, "render_collect_drops", "macro", "render", "render_world", "src/render/render_world.4dm", 1376, 1410, "void", "&A:p_drops",
                              "void render_collect_drops(Attributes &p_drops)", 0, "", "drop_age, drop_item, drop_position, item_is_block, item_side_texture, item_sprite_texture, item_top_texture, render_add_box, render_add_sprite, render_light_at, render_sphere_visible, slots_at, slots_count");
  if (p_id == 676) test_info_set(p_info, "render_clip_screen_edge", "macro", "render", "render_world", "src/render/render_world.4dm", 1414, 1465, "void", "I:p_axis R:p_limit I:p_keep_above",
                              "void render_clip_screen_edge(Integer p_axis, Real p_limit, Integer p_keep_above)", 0, "", "");
  if (p_id == 677) test_info_set(p_info, "render_clip_and_draw", "macro", "render", "render_world", "src/render/render_world.4dm", 1467, 1532, "Integer", "B:p_box",
                              "Integer render_clip_and_draw(Draw_Box p_box)", 0, "", "render_clip_screen_edge");
  if (p_id == 678) test_info_set(p_info, "render_quad", "macro", "render", "render_world", "src/render/render_world.4dm", 1534, 1593, "void", "B:p_box R:p_u0 R:p_v0 R:p_u1 R:p_v1",
                              "void render_quad(Draw_Box p_box, Real p_u0, Real p_v0, Real p_u1, Real p_v1)", 0, "", "render_clip_and_draw");
  if (p_id == 679) test_info_set(p_info, "render_face_line", "macro", "render", "render_world", "src/render/render_world.4dm", 1595, 1624, "void", "B:p_box R:p_u0 R:p_v0 R:p_u1 R:p_v1",
                              "void render_face_line(Draw_Box p_box, Real p_u0, Real p_v0, Real p_u1, Real p_v1)", 0, "", "render_line");
  if (p_id == 680) test_info_set(p_info, "render_palette_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 1626, 1637, "void", "B:p_box I:p_tex I:p_index",
                              "void render_palette_colour(Draw_Box p_box, Integer p_tex, Integer p_index)", 0, "", "render_set_face_colour, texture_palette_index");
}

void test_registry_call_17(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 641 to 680 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 641) {   // render_stats_text
    Get_time(l_start);
    l_ret_t = render_stats_text();
    Get_time(l_end);
  } else if (p_id == 642) {   // render_set_colour
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    render_set_colour(g_test_box, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 643) {   // render_forget_colour
    Get_time(l_start);
    render_forget_colour();
    Get_time(l_end);
  } else if (p_id == 644) {   // render_set_shade
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_set_shade(l_r1);
    Get_time(l_end);
  } else if (p_id == 645) {   // render_set_face_colour
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    render_set_face_colour(g_test_box, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 646) {   // render_fill_rect
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_fill_rect(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 647) {   // render_line
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_line(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 648) {   // render_setup_camera
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    l_r9 = record_real(p_in, ATTR_TEST_R9);
    Get_time(l_start);
    render_setup_camera(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8, l_r9);
    Get_time(l_end);
  } else if (p_id == 649) {   // render_to_camera
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    render_to_camera(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 650) {   // render_sphere_visible
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = render_sphere_visible(l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 651) {   // render_add_face
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    l_r9 = record_real(p_in, ATTR_TEST_R9);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r10 = record_real(p_in, ATTR_TEST_R10);
    l_r11 = record_real(p_in, ATTR_TEST_R11);
    l_r12 = record_real(p_in, ATTR_TEST_R12);
    l_r13 = record_real(p_in, ATTR_TEST_R13);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    render_add_face(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8, l_r9, l_i1, l_r10, l_r11, l_r12, l_r13, l_i2);
    Get_time(l_end);
  } else if (p_id == 652) {   // render_add_block_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    render_add_block_face(l_i1, l_i2, l_i3, l_i4, l_i5, l_r1, l_i6, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 653) {   // render_add_sprite
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    Get_time(l_start);
    render_add_sprite(l_r1, l_r2, l_r3, l_r4, l_r5, l_i1, l_r6, l_r7);
    Get_time(l_end);
  } else if (p_id == 654) {   // render_add_shaped
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_add_shaped(l_i1, l_i2, l_i3, l_i4, l_r1);
    Get_time(l_end);
  } else if (p_id == 655) {   // render_add_plant
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_add_plant(l_i1, l_i2, l_i3, l_i4, l_r1);
    Get_time(l_end);
  } else if (p_id == 656) {   // render_layer_count
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = render_layer_count(l_r1);
    Get_time(l_end);
  } else if (p_id == 657) {   // render_collect_blocks
    Get_time(l_start);
    render_collect_blocks();
    Get_time(l_end);
  } else if (p_id == 658) {   // render_side_shade
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = render_side_shade(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 659) {   // render_add_box
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_r9 = record_real(p_in, ATTR_TEST_R9);
    l_r10 = record_real(p_in, ATTR_TEST_R10);
    Get_time(l_start);
    render_add_box(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8, l_i1, l_i2, l_i3, l_i4, l_r9, l_r10);
    Get_time(l_end);
  } else if (p_id == 660) {   // render_light_at
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = render_light_at(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 661) {   // render_mob_begin
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    render_mob_begin(l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 662) {   // render_mob_part
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    render_mob_part(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8, l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 663) {   // render_mob_part_nearer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_i = render_mob_part_nearer(l_i1, l_i2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 664) {   // render_mob_end
    Get_time(l_start);
    render_mob_end();
    Get_time(l_end);
  } else if (p_id == 665) {   // render_mob_head_look
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    Get_time(l_start);
    render_mob_head_look(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R7, l_r7);
    record_set_real(p_out, ATTR_TEST_R8, l_r8);
  } else if (p_id == 666) {   // render_zombie
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    Get_time(l_start);
    render_zombie(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7);
    Get_time(l_end);
  } else if (p_id == 667) {   // render_cow
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    Get_time(l_start);
    render_cow(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7);
    Get_time(l_end);
  } else if (p_id == 668) {   // render_pig
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    Get_time(l_start);
    render_pig(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7);
    Get_time(l_end);
  } else if (p_id == 669) {   // render_person
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    render_person(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 670) {   // render_camera_place
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    render_camera_place(g_player, l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
    record_set_real(p_out, ATTR_TEST_R4, l_r4);
    record_set_real(p_out, ATTR_TEST_R5, l_r5);
  } else if (p_id == 671) {   // render_collect_self
    Get_time(l_start);
    render_collect_self(g_player, g_inventory);
    Get_time(l_end);
  } else if (p_id == 672) {   // render_collect_peers
    Get_time(l_start);
    render_collect_peers(g_peers);
    Get_time(l_end);
  } else if (p_id == 673) {   // render_peer_names
    Get_time(l_start);
    render_peer_names(g_test_box, g_peers);
    Get_time(l_end);
  } else if (p_id == 674) {   // render_collect_cows
    Get_time(l_start);
    render_collect_cows(g_cows);
    Get_time(l_end);
  } else if (p_id == 675) {   // render_collect_drops
    Get_time(l_start);
    render_collect_drops(g_drops);
    Get_time(l_end);
  } else if (p_id == 676) {   // render_clip_screen_edge
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    render_clip_screen_edge(l_i1, l_r1, l_i2);
    Get_time(l_end);
  } else if (p_id == 677) {   // render_clip_and_draw
    Get_time(l_start);
    l_ret_i = render_clip_and_draw(g_test_box);
    Get_time(l_end);
  } else if (p_id == 678) {   // render_quad
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_quad(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 679) {   // render_face_line
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_face_line(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 680) {   // render_palette_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    render_palette_colour(g_test_box, l_i1, l_i2);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_18(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 681 to 720 are
// ----------------------------------------------------------------
{
  if (p_id == 681) test_info_set(p_info, "render_draw_crack", "macro", "render", "render_world", "src/render/render_world.4dm", 1639, 1668, "void", "B:p_box I:p_tex",
                              "void render_draw_crack(Draw_Box p_box, Integer p_tex)", 0, "", "render_quad, render_set_face_colour, texture_palette_index");
  if (p_id == 682) test_info_set(p_info, "render_draw_face", "macro", "render", "render_world", "src/render/render_world.4dm", 1670, 1805, "void", "B:p_box I:p_face",
                              "void render_draw_face(Draw_Box p_box, Integer p_face)", 0, "", "render_draw_crack, render_palette_colour, render_quad, render_set_colour, render_set_face_colour");
  if (p_id == 683) test_info_set(p_info, "render_cover_reset", "macro", "render", "render_world", "src/render/render_world.4dm", 1807, 1826, "void", "",
                              "void render_cover_reset()", 0, "", "");
  if (p_id == 684) test_info_set(p_info, "render_cover_add", "macro", "render", "render_world", "src/render/render_world.4dm", 1828, 1879, "void", "I:p_line R:p_low R:p_high",
                              "void render_cover_add(Integer p_line, Real p_low, Real p_high)", 0, "", "");
  if (p_id == 685) test_info_set(p_info, "render_cover_corners", "macro", "render", "render_world", "src/render/render_world.4dm", 1881, 1909, "void", "I:p_face",
                              "void render_cover_corners(Integer p_face)", 0, "", "");
  if (p_id == 686) test_info_set(p_info, "render_cover_face", "macro", "render", "render_world", "src/render/render_world.4dm", 1911, 2010, "void", "I:p_face",
                              "void render_cover_face(Integer p_face)", 0, "", "clamp_integer, render_cover_add, render_cover_corners");
  if (p_id == 687) test_info_set(p_info, "render_hide_covered", "macro", "render", "render_world", "src/render/render_world.4dm", 2012, 2035, "void", "",
                              "void render_hide_covered()", 0, "", "render_cover_face, render_cover_reset");
  if (p_id == 688) test_info_set(p_info, "render_draw_faces", "macro", "render", "render_world", "src/render/render_world.4dm", 2037, 2056, "void", "B:p_box",
                              "void render_draw_faces(Draw_Box p_box)", 0, "", "render_draw_face");
  if (p_id == 689) test_info_set(p_info, "render_sky_colours", "macro", "render", "render_world", "src/render/render_world.4dm", 2060, 2081, "void", "R:p_time_of_day",
                              "void render_sky_colours(Real p_time_of_day)", 0, "", "clamp_real, lerp_real, world_sun_height");
  if (p_id == 690) test_info_set(p_info, "render_sky_disc", "macro", "render", "render_world", "src/render/render_world.4dm", 2083, 2109, "void", "B:p_box R:p_dir_x R:p_dir_y R:p_dir_z R:p_size I:p_moon",
                              "void render_sky_disc(Draw_Box p_box, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_size, Integer p_moon)", 0, "", "render_fill_rect, render_set_colour, render_to_camera");
  if (p_id == 691) test_info_set(p_info, "render_stars", "macro", "render", "render_world", "src/render/render_world.4dm", 2111, 2131, "void", "B:p_box R:p_brightness",
                              "void render_stars(Draw_Box p_box, Real p_brightness)", 0, "", "lerp_real, render_fill_rect, render_set_colour, render_to_camera");
  if (p_id == 692) test_info_set(p_info, "render_sky", "macro", "render", "render_world", "src/render/render_world.4dm", 2133, 2179, "void", "B:p_box",
                              "void render_sky(Draw_Box p_box)", 0, "", "clamp_real, lerp_real, render_fill_rect, render_set_colour, render_sky_disc, render_stars");
  if (p_id == 693) test_info_set(p_info, "render_point_visible", "macro", "render", "render_world", "src/render/render_world.4dm", 2181, 2251, "Integer", "R:p_x R:p_y R:p_z I:p_skip_x I:p_skip_y I:p_skip_z",
                              "Integer render_point_visible(Real p_x, Real p_y, Real p_z, Integer p_skip_x, Integer p_skip_y, Integer p_skip_z)", 0, "", "block_hides_faces, world_get_block");
  if (p_id == 694) test_info_set(p_info, "render_world_line", "macro", "render", "render_world", "src/render/render_world.4dm", 2253, 2291, "void", "B:p_box R:p_x0 R:p_y0 R:p_z0 R:p_x1 R:p_y1 R:p_z1",
                              "void render_world_line(Draw_Box p_box, Real p_x0, Real p_y0, Real p_z0, Real p_x1, Real p_y1, Real p_z1)", 0, "", "render_line, render_to_camera");
  if (p_id == 695) test_info_set(p_info, "render_target_outline", "macro", "render", "render_world", "src/render/render_world.4dm", 2293, 2422, "void", "B:p_box",
                              "void render_target_outline(Draw_Box p_box)", 0, "", "block_box, render_point_visible, render_set_colour, render_world_line, world_get_block");
  if (p_id == 696) test_info_set(p_info, "render_ray_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 2424, 2541, "Integer", "R:p_x R:p_y R:p_z R:p_dir_x R:p_dir_y R:p_dir_z R:p_distance",
                              "Integer render_ray_colour(Real p_x, Real p_y, Real p_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_distance)", 0, "", "block_face_shade, block_face_texture, block_is_plant, block_is_solid, block_light_emission, clamp_real, floor_integer, lerp_real, max_real, to_byte, world_get_block, world_in_bounds");
  if (p_id == 697) test_info_set(p_info, "render_world", "macro", "render", "render_world", "src/render/render_world.4dm", 2543, 2582, "void", "B:p_box R:p_w R:p_h R:p_view_bottom &A:p_player &A:p_inventory &A:p_cows &A:p_drops &A:p_peers &A:p_settings R:p_time_of_day R:p_now",
                              "void render_world(Draw_Box p_box, Real p_w, Real p_h, Real p_view_bottom, Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_drops, Attributes &p_peers, Attributes &p_settings, Real p_time_of_day, Real p_now)", 0, "", "mesh_build_nearby, min_integer, render_camera_place, render_collect_blocks, render_collect_cows, render_collect_drops, render_collect_peers, render_collect_self, render_draw_faces, render_hide_covered, render_peer_names, render_setup_camera, render_sky, render_target_outline, render_view_from, settings_fov_radians");
  if (p_id == 698) test_info_set(p_info, "font_choice", "macro", "ui", "font", "src/ui/font.4dm", 8, 25, "Text", "I:p_index",
                              "Text font_choice(Integer p_index)", 0, "", "");
  if (p_id == 699) test_info_set(p_info, "font_choice_index", "macro", "ui", "font", "src/ui/font.4dm", 27, 38, "Integer", "T:p_font",
                              "Integer font_choice_index(Text p_font)", 0, "", "font_choice");
  if (p_id == 700) test_info_set(p_info, "font_next_choice", "macro", "ui", "font", "src/ui/font.4dm", 40, 50, "Text", "T:p_font",
                              "Text font_next_choice(Text p_font)", 0, "", "font_choice, font_choice_index");
  if (p_id == 701) test_info_set(p_info, "font_read_u16", "macro", "ui", "font", "src/ui/font.4dm", 52, 66, "Integer", "&?:p_file I:p_position",
                              "Integer font_read_u16(File &p_file, Integer p_position)", 0, "takes an open File", "");
  if (p_id == 702) test_info_set(p_info, "font_read_u32_high", "macro", "ui", "font", "src/ui/font.4dm", 68, 75, "Integer", "&?:p_file I:p_position",
                              "Integer font_read_u32_high(File &p_file, Integer p_position)", 0, "takes an open File", "font_read_u16");
  if (p_id == 703) test_info_set(p_info, "font_family_from_file", "macro", "ui", "font", "src/ui/font.4dm", 77, 203, "Integer", "T:p_path &T:p_family &T:p_report",
                              "Integer font_family_from_file(Text p_path, Text &p_family, Text &p_report)", 0, "", "font_read_u16, font_read_u32_high");
  if (p_id == 704) test_info_set(p_info, "font_apply", "macro", "ui", "font", "src/ui/font.4dm", 205, 212, "void", "B:p_box T:p_font",
                              "void font_apply(Draw_Box p_box, Text p_font)", 0, "", "");
  if (p_id == 705) test_info_set(p_info, "game_panel_split_xy", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 49, 61, "Integer", "T:p_msg &R:p_x &R:p_y",
                              "Integer game_panel_split_xy(Text p_msg, Real &p_x, Real &p_y)", 0, "", "");
  if (p_id == 706) test_info_set(p_info, "game_panel_calibrate", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 63, 92, "Integer", "B:p_box R:p_box_x R:p_box_y I:p_width I:p_height &I:p_origin_x &I:p_origin_y",
                              "Integer game_panel_calibrate(Draw_Box p_box, Real p_box_x, Real p_box_y, Integer p_width, Integer p_height, Integer &p_origin_x, Integer &p_origin_y)", 0, "", "");
  if (p_id == 707) test_info_set(p_info, "game_panel_notice", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 94, 117, "void", "B:p_box T:p_title T:p_line",
                              "void game_panel_notice(Draw_Box p_box, Text p_title, Text p_line)", 0, "", "font_apply, hud_shadow_text, menu_background, render_forget_colour, settings_font");
  if (p_id == 708) test_info_set(p_info, "game_panel_dispatch", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 119, 125, "void", "R:p_now",
                              "void game_panel_dispatch(Real p_now)", 0, "", "game_dispatch_events");
  if (p_id == 709) test_info_set(p_info, "game_panel_save", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 127, 140, "Integer", "",
                              "Integer game_panel_save()", 1, "", "game_save_world, save_note_played");
  if (p_id == 710) test_info_set(p_info, "game_panel_close_screen", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 142, 153, "void", "",
                              "void game_panel_close_screen()", 0, "", "player_position, ui_close, ui_screen");
  if (p_id == 711) test_info_set(p_info, "game_panel_backdrop", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 155, 163, "void", "B:p_box R:p_w R:p_h R:p_now",
                              "void game_panel_backdrop(Draw_Box p_box, Real p_w, Real p_h, Real p_now)", 0, "", "render_set_shade, render_world, world_time_of_day");
  if (p_id == 712) test_info_set(p_info, "game_panel_render", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 165, 209, "void", "B:p_box I:p_captured R:p_frame_ms R:p_now",
                              "void game_panel_render(Draw_Box p_box, Integer p_captured, Real p_frame_ms, Real p_now)", 0, "", "font_apply, hud_draw, hud_text, net_mode, net_players_text, render_forget_colour, render_set_shade, render_stats_text, render_world, settings_font, ui_draw, ui_screen, world_info_seed, world_time_of_day");
  if (p_id == 713) test_info_set(p_info, "game_panel_run", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 211, 817, "Integer", "B:p_box ?:p_keys T:p_world_name I:p_mode I:p_seed I:p_game_mode",
                              "Integer game_panel_run(Draw_Box p_box, Input_Box p_keys, Text p_world_name, Integer p_mode, Integer p_seed, Integer p_game_mode)", 1, "opens a panel and waits for events", "command_run, emit_event, game_build_nearby, game_host, game_join, game_load_world, game_new_world, game_panel_calibrate, game_panel_close_screen, game_panel_dispatch, game_panel_notice, game_panel_render, game_panel_save, game_panel_split_xy, game_respawn, game_select_slot, game_update, game_world_name, hud_chat, hud_help_shown, hud_menu_help, hud_note_frame, hud_pause_button_at, hud_set_chat_input, hud_set_help, hud_set_menu_help, hud_set_mouse, hud_show_name, hud_toast, inventory_swap_hands, key_name, menu_begin, net_clean_name, net_clear, net_flush, net_leave, net_mode, net_poll, net_say, player_auto_walk, player_creative, player_flying, player_game_mode_name, player_is_dead, player_key_pressed, player_next_camera, player_pick_block, player_primary_action, player_secondary_action, player_selected, player_set_auto_walk, player_set_game_mode, player_shift_pressed, player_spectator, player_survival, player_turn, random_range, save_note_played, save_settings_path, save_take_thumbnail, settings_change, settings_describe, settings_mouse_scale, settings_mp_folder, settings_panel_run, settings_player_name, settings_render_distance, settings_save, settings_toggle, text_after_key, ui_click, ui_screen, ui_set_mouse, ui_set_tabs, ui_type_search");
  if (p_id == 714) test_info_set(p_info, "app_run", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 23, 62, "Integer", "",
                              "Integer app_run()", 1, "opens a panel and waits for events", "game_panel_run, menu_panel_run, record_integer, record_text");
  if (p_id == 715) test_info_set(p_info, "menu_open_worlds", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 64, 75, "void", "&A:p_menu &A:p_worlds",
                              "void menu_open_worlds(Attributes &p_menu, Attributes &p_worlds)", 1, "", "menu_set_field_text, menu_set_focus, menu_set_pick, record_set_integer, save_list_worlds_about");
  if (p_id == 716) test_info_set(p_info, "menu_free_world_name", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 77, 87, "Text", "T:p_base",
                              "Text menu_free_world_name(Text p_base)", 0, "", "save_world_exists");
  if (p_id == 717) test_info_set(p_info, "menu_turned", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 89, 95, "Integer", "R:p_last_frame R:p_now",
                              "Integer menu_turned(Real p_last_frame, Real p_now)", 0, "", "");
  if (p_id == 718) test_info_set(p_info, "menu_splash", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 97, 109, "Text", "I:p_pick",
                              "Text menu_splash(Integer p_pick)", 0, "", "");
  if (p_id == 719) test_info_set(p_info, "menu_background", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 111, 124, "void", "B:p_box R:p_w R:p_h I:p_title R:p_now",
                              "void menu_background(Draw_Box p_box, Real p_w, Real p_h, Integer p_title, Real p_now)", 0, "", "menu_draw_panorama");
  if (p_id == 720) test_info_set(p_info, "menu_panel_run", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 126, 388, "Integer", "B:p_box ?:p_keys &A:p_game &A:p_random &A:p_settings",
                              "Integer menu_panel_run(Draw_Box p_box, Input_Box p_keys, Attributes &p_game, Attributes &p_random, Attributes &p_settings)", 1, "opens a panel and waits for events", "font_apply, game_panel_split_xy, key_name, menu_at, menu_background, menu_clear, menu_field_text, menu_focus, menu_free_world_name, menu_note, menu_open_worlds, menu_pick, menu_scroll_to, menu_set_field_text, menu_set_focus, menu_set_mouse, menu_set_pick, menu_slider_value_at, menu_splash, menu_turned, menu_type_key, menu_widget_id, menu_widget_kind, menu_widget_of, random_range, record_integer, record_set_integer, record_set_text, record_text, record_text_at, render_forget_colour, save_delete_world, save_ensure_folder, save_settings_path, save_world_exists, screen_create, screen_delete, screen_player, screen_title, screen_worlds, settings_font, settings_mp_folder, settings_panel_run, settings_player_name, settings_save, settings_set_text, text_is_safe_name, text_to_seed");
}

void test_registry_call_18(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 681 to 720 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 681) {   // render_draw_crack
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_draw_crack(g_test_box, l_i1);
    Get_time(l_end);
  } else if (p_id == 682) {   // render_draw_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_draw_face(g_test_box, l_i1);
    Get_time(l_end);
  } else if (p_id == 683) {   // render_cover_reset
    Get_time(l_start);
    render_cover_reset();
    Get_time(l_end);
  } else if (p_id == 684) {   // render_cover_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    render_cover_add(l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 685) {   // render_cover_corners
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_cover_corners(l_i1);
    Get_time(l_end);
  } else if (p_id == 686) {   // render_cover_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_cover_face(l_i1);
    Get_time(l_end);
  } else if (p_id == 687) {   // render_hide_covered
    Get_time(l_start);
    render_hide_covered();
    Get_time(l_end);
  } else if (p_id == 688) {   // render_draw_faces
    Get_time(l_start);
    render_draw_faces(g_test_box);
    Get_time(l_end);
  } else if (p_id == 689) {   // render_sky_colours
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_sky_colours(l_r1);
    Get_time(l_end);
  } else if (p_id == 690) {   // render_sky_disc
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_sky_disc(g_test_box, l_r1, l_r2, l_r3, l_r4, l_i1);
    Get_time(l_end);
  } else if (p_id == 691) {   // render_stars
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_stars(g_test_box, l_r1);
    Get_time(l_end);
  } else if (p_id == 692) {   // render_sky
    Get_time(l_start);
    render_sky(g_test_box);
    Get_time(l_end);
  } else if (p_id == 693) {   // render_point_visible
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = render_point_visible(l_r1, l_r2, l_r3, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 694) {   // render_world_line
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    render_world_line(g_test_box, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
  } else if (p_id == 695) {   // render_target_outline
    Get_time(l_start);
    render_target_outline(g_test_box);
    Get_time(l_end);
  } else if (p_id == 696) {   // render_ray_colour
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    Get_time(l_start);
    l_ret_i = render_ray_colour(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7);
    Get_time(l_end);
  } else if (p_id == 697) {   // render_world
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    render_world(g_test_box, l_r1, l_r2, l_r3, g_player, g_inventory, g_cows, g_drops, g_peers, g_settings, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 698) {   // font_choice
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = font_choice(l_i1);
    Get_time(l_end);
  } else if (p_id == 699) {   // font_choice_index
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = font_choice_index(l_t1);
    Get_time(l_end);
  } else if (p_id == 700) {   // font_next_choice
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = font_next_choice(l_t1);
    Get_time(l_end);
  } else if (p_id == 703) {   // font_family_from_file
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = font_family_from_file(l_t1, l_t2, l_t3);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
  } else if (p_id == 704) {   // font_apply
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    font_apply(g_test_box, l_t1);
    Get_time(l_end);
  } else if (p_id == 705) {   // game_panel_split_xy
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = game_panel_split_xy(l_t1, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 706) {   // game_panel_calibrate
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = game_panel_calibrate(g_test_box, l_r1, l_r2, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
  } else if (p_id == 707) {   // game_panel_notice
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    game_panel_notice(g_test_box, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 708) {   // game_panel_dispatch
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    game_panel_dispatch(l_r1);
    Get_time(l_end);
  } else if (p_id == 709) {   // game_panel_save
    Get_time(l_start);
    l_ret_i = game_panel_save();
    Get_time(l_end);
  } else if (p_id == 710) {   // game_panel_close_screen
    Get_time(l_start);
    game_panel_close_screen();
    Get_time(l_end);
  } else if (p_id == 711) {   // game_panel_backdrop
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    game_panel_backdrop(g_test_box, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 712) {   // game_panel_render
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    game_panel_render(g_test_box, l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 715) {   // menu_open_worlds
    Get_time(l_start);
    menu_open_worlds(g_test_record, g_test_record_2);
    Get_time(l_end);
  } else if (p_id == 716) {   // menu_free_world_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = menu_free_world_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 717) {   // menu_turned
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = menu_turned(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 718) {   // menu_splash
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = menu_splash(l_i1);
    Get_time(l_end);
  } else if (p_id == 719) {   // menu_background
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    menu_background(g_test_box, l_r1, l_r2, l_i1, l_r3);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_19(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 721 to 760 are
// ----------------------------------------------------------------
{
  if (p_id == 721) test_info_set(p_info, "settings_slider", "macro", "ui", "settings_panel", "src/ui/settings_panel.4dm", 22, 40, "void", "&A:p_settings I:p_id R:p_value",
                              "void settings_slider(Attributes &p_settings, Integer p_id, Real p_value)", 0, "", "clamp_integer, floor_integer, record_set_integer");
  if (p_id == 722) test_info_set(p_info, "settings_panel_run", "macro", "ui", "settings_panel", "src/ui/settings_panel.4dm", 42, 323, "Integer", "B:p_box ?:p_keys &A:p_settings I:p_in_game",
                              "Integer settings_panel_run(Draw_Box p_box, Input_Box p_keys, Attributes &p_settings, Integer p_in_game)", 1, "opens a panel and waits for events", "font_apply, font_choice, font_family_from_file, game_load_textures, game_panel_backdrop, game_panel_notice, game_panel_split_xy, key_name, menu_at, menu_background, menu_begin, menu_clear, menu_field_text, menu_focus, menu_note, menu_scroll_to, menu_set_field_text, menu_set_focus, menu_set_mouse, menu_slider_value_at, menu_turned, menu_type_key, menu_widget_id, menu_widget_kind, menu_widget_of, record_integer, record_set_integer, record_text_at, render_forget_colour, save_ensure_folder, save_file_name, save_list_files, save_settings_path, screen_fonts, screen_options, screen_packs, screen_player, screen_skins, settings_defaults, settings_detail, settings_font, settings_font_file, settings_mp_folder, settings_player_name, settings_resource_pack, settings_save, settings_set_font, settings_set_font_file, settings_set_resource_pack, settings_set_text, settings_skin, settings_slider, settings_toggle");
  if (p_id == 723) test_info_set(p_info, "mesh_section_index", "macro", "world", "mesh", "src/world/mesh.4dm", 13, 19, "Integer", "I:p_sx I:p_sy I:p_sz",
                              "Integer mesh_section_index(Integer p_sx, Integer p_sy, Integer p_sz)", 0, "", "");
  if (p_id == 724) test_info_set(p_info, "mesh_reset", "macro", "world", "mesh", "src/world/mesh.4dm", 21, 35, "void", "",
                              "void mesh_reset()", 0, "", "mesh_fill_cell_tables");
  if (p_id == 725) test_info_set(p_info, "mesh_fill_cell_tables", "macro", "world", "mesh", "src/world/mesh.4dm", 37, 67, "void", "",
                              "void mesh_fill_cell_tables()", 0, "", "block_is_plant, block_is_see_through, block_is_shaped, block_is_solid, world_cell_block, world_cell_light");
  if (p_id == 726) test_info_set(p_info, "mesh_section_buried", "macro", "world", "mesh", "src/world/mesh.4dm", 69, 92, "Integer", "I:p_sx I:p_sy I:p_sz",
                              "Integer mesh_section_buried(Integer p_sx, Integer p_sy, Integer p_sz)", 0, "", "world_solid_below");
  if (p_id == 727) test_info_set(p_info, "mesh_add_face", "macro", "world", "mesh", "src/world/mesh.4dm", 94, 110, "Integer", "I:p_entry I:p_x I:p_y I:p_z I:p_direction I:p_flag I:p_block",
                              "Integer mesh_add_face(Integer p_entry, Integer p_x, Integer p_y, Integer p_z, Integer p_direction, Integer p_flag, Integer p_block)", 0, "", "mesh_face_light");
  if (p_id == 728) test_info_set(p_info, "mesh_build_section", "macro", "world", "mesh", "src/world/mesh.4dm", 112, 217, "void", "I:p_sx I:p_sy I:p_sz",
                              "void mesh_build_section(Integer p_sx, Integer p_sy, Integer p_sz)", 0, "", "mesh_add_face, mesh_group_faces, mesh_section_buried, mesh_section_index, world_index");
  if (p_id == 729) test_info_set(p_info, "mesh_face_light", "macro", "world", "mesh", "src/world/mesh.4dm", 219, 314, "Integer", "I:p_x I:p_y I:p_z I:p_direction",
                              "Integer mesh_face_light(Integer p_x, Integer p_y, Integer p_z, Integer p_direction)", 0, "", "floor_divide, world_get_light, world_is_solid, world_sky_top");
  if (p_id == 730) test_info_set(p_info, "mesh_layer_key", "macro", "world", "mesh", "src/world/mesh.4dm", 316, 332, "Integer", "I:p_direction I:p_local_x I:p_local_y I:p_local_z",
                              "Integer mesh_layer_key(Integer p_direction, Integer p_local_x, Integer p_local_y, Integer p_local_z)", 0, "", "");
  if (p_id == 731) test_info_set(p_info, "mesh_group_faces", "macro", "world", "mesh", "src/world/mesh.4dm", 334, 388, "void", "I:p_section I:p_x0 I:p_y0 I:p_z0",
                              "void mesh_group_faces(Integer p_section, Integer p_x0, Integer p_y0, Integer p_z0)", 0, "", "mesh_layer_key");
  if (p_id == 732) test_info_set(p_info, "mesh_build_nearby", "macro", "world", "mesh", "src/world/mesh.4dm", 390, 445, "void", "R:p_eye_x R:p_eye_y R:p_eye_z I:p_range I:p_budget",
                              "void mesh_build_nearby(Real p_eye_x, Real p_eye_y, Real p_eye_z, Integer p_range, Integer p_budget)", 0, "", "clamp_integer, floor_integer, mesh_build_section, mesh_section_index");
  if (p_id == 733) test_info_set(p_info, "mesh_ensure_section", "macro", "world", "mesh", "src/world/mesh.4dm", 447, 457, "Integer", "I:p_sx I:p_sy I:p_sz",
                              "Integer mesh_ensure_section(Integer p_sx, Integer p_sy, Integer p_sz)", 0, "", "mesh_build_section, mesh_section_index");
  if (p_id == 734) test_info_set(p_info, "mesh_mark_dirty", "macro", "world", "mesh", "src/world/mesh.4dm", 459, 494, "void", "I:p_x I:p_y I:p_z",
                              "void mesh_mark_dirty(Integer p_x, Integer p_y, Integer p_z)", 0, "", "floor_divide, mesh_section_index, world_in_bounds");
  if (p_id == 735) test_info_set(p_info, "mesh_mark_box_dirty", "macro", "world", "mesh", "src/world/mesh.4dm", 496, 521, "void", "I:p_x I:p_y I:p_z I:p_radius",
                              "void mesh_mark_box_dirty(Integer p_x, Integer p_y, Integer p_z, Integer p_radius)", 0, "", "clamp_integer, floor_divide, mesh_section_index");
  if (p_id == 736) test_info_set(p_info, "mesh_on_event", "macro", "world", "mesh", "src/world/mesh.4dm", 523, 536, "void", "&A:p_event",
                              "void mesh_on_event(Attributes &p_event)", 0, "", "event_integer, event_type, mesh_mark_box_dirty, mesh_mark_dirty");
  if (p_id == 737) test_info_set(p_info, "physics_cell_box", "macro", "world", "physics", "src/world/physics.4dm", 11, 46, "Integer", "I:p_x I:p_y I:p_z &R:p_min_x &R:p_min_y &R:p_min_z &R:p_max_x &R:p_max_y &R:p_max_z",
                              "Integer physics_cell_box(Integer p_x, Integer p_y, Integer p_z, Real &p_min_x, Real &p_min_y, Real &p_min_z, Real &p_max_x, Real &p_max_y, Real &p_max_z)", 0, "", "block_box, world_get_block, world_in_bounds, world_is_solid");
  if (p_id == 738) test_info_set(p_info, "physics_box_limit", "macro", "world", "physics", "src/world/physics.4dm", 48, 102, "Real", "R:p_min_x R:p_min_y R:p_min_z R:p_max_x R:p_max_y R:p_max_z I:p_axis I:p_direction",
                              "Real physics_box_limit(Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z, Integer p_axis, Integer p_direction)", 0, "", "physics_cell_box");
  if (p_id == 739) test_info_set(p_info, "physics_box_collides", "macro", "world", "physics", "src/world/physics.4dm", 104, 111, "Integer", "R:p_min_x R:p_min_y R:p_min_z R:p_max_x R:p_max_y R:p_max_z",
                              "Integer physics_box_collides(Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)", 0, "", "physics_box_limit");
  if (p_id == 740) test_info_set(p_info, "physics_move_box", "macro", "world", "physics", "src/world/physics.4dm", 113, 181, "void", "&R:p_x &R:p_y &R:p_z R:p_half_width R:p_height R:p_dx R:p_dy R:p_dz &I:p_hit_x &I:p_hit_z &I:p_hit_down &I:p_hit_up",
                              "void physics_move_box(Real &p_x, Real &p_y, Real &p_z, Real p_half_width, Real p_height, Real p_dx, Real p_dy, Real p_dz, Integer &p_hit_x, Integer &p_hit_z, Integer &p_hit_down, Integer &p_hit_up)", 0, "", "physics_box_collides, physics_box_limit");
  if (p_id == 741) test_info_set(p_info, "physics_box_in_water", "macro", "world", "physics", "src/world/physics.4dm", 183, 194, "Integer", "R:p_x R:p_y R:p_z R:p_half_width R:p_height",
                              "Integer physics_box_in_water(Real p_x, Real p_y, Real p_z, Real p_half_width, Real p_height)", 0, "", "world_get_block");
  if (p_id == 742) test_info_set(p_info, "physics_raycast_blocks", "macro", "world", "physics", "src/world/physics.4dm", 196, 303, "Integer", "R:p_origin_x R:p_origin_y R:p_origin_z R:p_dir_x R:p_dir_y R:p_dir_z R:p_max_distance &I:p_hit_x &I:p_hit_y &I:p_hit_z &I:p_normal_x &I:p_normal_y &I:p_normal_z &R:p_distance",
                              "Integer physics_raycast_blocks(Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_max_distance, Integer &p_hit_x, Integer &p_hit_y, Integer &p_hit_z, Integer &p_normal_x, Integer &p_normal_y, Integer &p_normal_z, Real &p_distance)", 0, "", "block_box, physics_ray_box, world_get_block, world_in_bounds");
  if (p_id == 743) test_info_set(p_info, "physics_ray_box", "macro", "world", "physics", "src/world/physics.4dm", 305, 363, "Real", "R:p_origin_x R:p_origin_y R:p_origin_z R:p_dir_x R:p_dir_y R:p_dir_z R:p_min_x R:p_min_y R:p_min_z R:p_max_x R:p_max_y R:p_max_z",
                              "Real physics_ray_box(Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)", 0, "", "max_real, min_real");
  if (p_id == 744) test_info_set(p_info, "world_index", "macro", "world", "world", "src/world/world.4dm", 15, 21, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_index(Integer p_x, Integer p_y, Integer p_z)", 0, "", "");
  if (p_id == 745) test_info_set(p_info, "world_cell_of_index", "macro", "world", "world", "src/world/world.4dm", 23, 35, "void", "I:p_index &I:p_x &I:p_y &I:p_z",
                              "void world_cell_of_index(Integer p_index, Integer &p_x, Integer &p_y, Integer &p_z)", 0, "", "floor_divide, positive_mod");
  if (p_id == 746) test_info_set(p_info, "world_column", "macro", "world", "world", "src/world/world.4dm", 37, 43, "Integer", "I:p_x I:p_z",
                              "Integer world_column(Integer p_x, Integer p_z)", 0, "", "");
  if (p_id == 747) test_info_set(p_info, "world_in_bounds", "macro", "world", "world", "src/world/world.4dm", 45, 53, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_in_bounds(Integer p_x, Integer p_y, Integer p_z)", 0, "", "");
  if (p_id == 748) test_info_set(p_info, "world_get_block", "macro", "world", "world", "src/world/world.4dm", 55, 67, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_get_block(Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_cell_block, world_in_bounds, world_index");
  if (p_id == 749) test_info_set(p_info, "world_cell_block", "macro", "world", "world", "src/world/world.4dm", 69, 78, "Integer", "I:p_cell",
                              "Integer world_cell_block(Integer p_cell)", 0, "", "");
  if (p_id == 750) test_info_set(p_info, "world_cell_light", "macro", "world", "world", "src/world/world.4dm", 80, 89, "Integer", "I:p_cell",
                              "Integer world_cell_light(Integer p_cell)", 0, "", "");
  if (p_id == 751) test_info_set(p_info, "world_get_light", "macro", "world", "world", "src/world/world.4dm", 91, 98, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_get_light(Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_cell_light, world_in_bounds, world_index");
  if (p_id == 752) test_info_set(p_info, "world_set_block", "macro", "world", "world", "src/world/world.4dm", 100, 112, "void", "I:p_x I:p_y I:p_z I:p_block",
                              "void world_set_block(Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "world_cell_light, world_in_bounds, world_index");
  if (p_id == 753) test_info_set(p_info, "world_is_solid", "macro", "world", "world", "src/world/world.4dm", 114, 124, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_is_solid(Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_is_solid, world_cell_block, world_index");
  if (p_id == 754) test_info_set(p_info, "world_top_solid_y", "macro", "world", "world", "src/world/world.4dm", 126, 142, "Integer", "I:p_x I:p_z",
                              "Integer world_top_solid_y(Integer p_x, Integer p_z)", 0, "", "block_is_solid, world_cell_block, world_in_bounds, world_index");
  if (p_id == 755) test_info_set(p_info, "world_top_opaque_y", "macro", "world", "world", "src/world/world.4dm", 144, 161, "Integer", "I:p_x I:p_z",
                              "Integer world_top_opaque_y(Integer p_x, Integer p_z)", 0, "", "block_hides_faces, world_cell_block, world_in_bounds, world_index");
  if (p_id == 756) test_info_set(p_info, "world_sky_top", "macro", "world", "world", "src/world/world.4dm", 163, 171, "Integer", "I:p_x I:p_z",
                              "Integer world_sky_top(Integer p_x, Integer p_z)", 0, "", "world_column, world_in_bounds");
  if (p_id == 757) test_info_set(p_info, "world_solid_below", "macro", "world", "world", "src/world/world.4dm", 173, 181, "Integer", "I:p_x I:p_z",
                              "Integer world_solid_below(Integer p_x, Integer p_z)", 0, "", "world_column, world_in_bounds");
  if (p_id == 758) test_info_set(p_info, "world_biome", "macro", "world", "world", "src/world/world.4dm", 183, 190, "Integer", "I:p_x I:p_z",
                              "Integer world_biome(Integer p_x, Integer p_z)", 0, "", "world_column, world_in_bounds");
  if (p_id == 759) test_info_set(p_info, "world_update_column_top", "macro", "world", "world", "src/world/world.4dm", 192, 199, "void", "I:p_x I:p_z",
                              "void world_update_column_top(Integer p_x, Integer p_z)", 0, "", "world_column, world_in_bounds, world_top_opaque_y");
  if (p_id == 760) test_info_set(p_info, "world_break_block", "macro", "world", "world", "src/world/world.4dm", 201, 242, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_tool_item",
                              "void world_break_block(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_tool_item)", 0, "", "block_door_top, block_is_door, block_is_plant, block_is_shaped, block_partner, emit_cell_event, emit_event, world_get_block, world_in_bounds, world_light_update, world_set_block, world_update_column_top");
}

void test_registry_call_19(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 721 to 760 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 721) {   // settings_slider
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    settings_slider(g_settings, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 723) {   // mesh_section_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = mesh_section_index(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 724) {   // mesh_reset
    Get_time(l_start);
    mesh_reset();
    Get_time(l_end);
  } else if (p_id == 725) {   // mesh_fill_cell_tables
    Get_time(l_start);
    mesh_fill_cell_tables();
    Get_time(l_end);
  } else if (p_id == 726) {   // mesh_section_buried
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = mesh_section_buried(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 727) {   // mesh_add_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    Get_time(l_start);
    l_ret_i = mesh_add_face(l_i1, l_i2, l_i3, l_i4, l_i5, l_i6, l_i7);
    Get_time(l_end);
  } else if (p_id == 728) {   // mesh_build_section
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    mesh_build_section(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 729) {   // mesh_face_light
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = mesh_face_light(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 730) {   // mesh_layer_key
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = mesh_layer_key(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 731) {   // mesh_group_faces
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    mesh_group_faces(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 732) {   // mesh_build_nearby
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    mesh_build_nearby(l_r1, l_r2, l_r3, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 733) {   // mesh_ensure_section
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = mesh_ensure_section(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 734) {   // mesh_mark_dirty
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    mesh_mark_dirty(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 735) {   // mesh_mark_box_dirty
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    mesh_mark_box_dirty(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 736) {   // mesh_on_event
    Get_time(l_start);
    mesh_on_event(g_event);
    Get_time(l_end);
  } else if (p_id == 737) {   // physics_cell_box
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    l_ret_i = physics_cell_box(l_i1, l_i2, l_i3, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
    record_set_real(p_out, ATTR_TEST_R4, l_r4);
    record_set_real(p_out, ATTR_TEST_R5, l_r5);
    record_set_real(p_out, ATTR_TEST_R6, l_r6);
  } else if (p_id == 738) {   // physics_box_limit
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_r = physics_box_limit(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 739) {   // physics_box_collides
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    l_ret_i = physics_box_collides(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
  } else if (p_id == 740) {   // physics_move_box
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    physics_move_box(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
  } else if (p_id == 741) {   // physics_box_in_water
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    l_ret_i = physics_box_in_water(l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 742) {   // physics_raycast_blocks
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    Get_time(l_start);
    l_ret_i = physics_raycast_blocks(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_i1, l_i2, l_i3, l_i4, l_i5, l_i6, l_r8);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
    record_set_real(p_out, ATTR_TEST_R8, l_r8);
  } else if (p_id == 743) {   // physics_ray_box
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_r8 = record_real(p_in, ATTR_TEST_R8);
    l_r9 = record_real(p_in, ATTR_TEST_R9);
    l_r10 = record_real(p_in, ATTR_TEST_R10);
    l_r11 = record_real(p_in, ATTR_TEST_R11);
    l_r12 = record_real(p_in, ATTR_TEST_R12);
    Get_time(l_start);
    l_ret_r = physics_ray_box(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_r8, l_r9, l_r10, l_r11, l_r12);
    Get_time(l_end);
  } else if (p_id == 744) {   // world_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_index(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 745) {   // world_cell_of_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_cell_of_index(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
  } else if (p_id == 746) {   // world_column
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_column(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 747) {   // world_in_bounds
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_in_bounds(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 748) {   // world_get_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_get_block(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 749) {   // world_cell_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = world_cell_block(l_i1);
    Get_time(l_end);
  } else if (p_id == 750) {   // world_cell_light
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = world_cell_light(l_i1);
    Get_time(l_end);
  } else if (p_id == 751) {   // world_get_light
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_get_light(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 752) {   // world_set_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_set_block(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 753) {   // world_is_solid
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_is_solid(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 754) {   // world_top_solid_y
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_top_solid_y(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 755) {   // world_top_opaque_y
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_top_opaque_y(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 756) {   // world_sky_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_sky_top(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 757) {   // world_solid_below
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_solid_below(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 758) {   // world_biome
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_biome(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 759) {   // world_update_column_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    world_update_column_top(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 760) {   // world_break_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_break_block(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_20(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 761 to 800 are
// ----------------------------------------------------------------
{
  if (p_id == 761) test_info_set(p_info, "world_place_block", "macro", "world", "world", "src/world/world.4dm", 244, 256, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_block",
                              "void world_place_block(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "emit_cell_event, world_in_bounds, world_light_update, world_set_block, world_update_column_top");
  if (p_id == 762) test_info_set(p_info, "world_apply_remote_block", "macro", "world", "world", "src/world/world.4dm", 258, 277, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_block",
                              "void world_apply_remote_block(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "emit_cell_event, emit_event, world_get_block, world_in_bounds, world_light_update, world_set_block, world_update_column_top");
  if (p_id == 763) test_info_set(p_info, "world_time_of_day", "macro", "world", "world", "src/world/world.4dm", 281, 287, "Real", "&A:p_info",
                              "Real world_time_of_day(Attributes &p_info)", 0, "", "record_real");
  if (p_id == 764) test_info_set(p_info, "world_set_time_of_day", "macro", "world", "world", "src/world/world.4dm", 289, 295, "void", "&A:p_info R:p_time",
                              "void world_set_time_of_day(Attributes &p_info, Real p_time)", 0, "", "record_set_real");
  if (p_id == 765) test_info_set(p_info, "world_daylight_cycle", "macro", "world", "world", "src/world/world.4dm", 297, 304, "Integer", "&A:p_info",
                              "Integer world_daylight_cycle(Attributes &p_info)", 0, "", "record_integer");
  if (p_id == 766) test_info_set(p_info, "world_set_daylight_cycle", "macro", "world", "world", "src/world/world.4dm", 306, 312, "void", "&A:p_info I:p_on",
                              "void world_set_daylight_cycle(Attributes &p_info, Integer p_on)", 0, "", "record_set_integer");
  if (p_id == 767) test_info_set(p_info, "world_advance_time", "macro", "world", "world", "src/world/world.4dm", 314, 323, "void", "&A:p_info R:p_dt",
                              "void world_advance_time(Attributes &p_info, Real p_dt)", 0, "", "record_integer, record_set_integer, world_set_time_of_day, world_time_of_day");
  if (p_id == 768) test_info_set(p_info, "world_sun_height", "macro", "world", "world", "src/world/world.4dm", 325, 331, "Real", "R:p_time_of_day",
                              "Real world_sun_height(Real p_time_of_day)", 0, "", "");
  if (p_id == 769) test_info_set(p_info, "world_daylight", "macro", "world", "world", "src/world/world.4dm", 333, 342, "Real", "R:p_time_of_day",
                              "Real world_daylight(Real p_time_of_day)", 0, "", "clamp_real, smooth_curve, world_sun_height");
  if (p_id == 770) test_info_set(p_info, "world_is_night", "macro", "world", "world", "src/world/world.4dm", 344, 351, "Integer", "R:p_time_of_day",
                              "Integer world_is_night(Real p_time_of_day)", 0, "", "world_daylight");
  if (p_id == 771) test_info_set(p_info, "world_clock_text", "macro", "world", "world", "src/world/world.4dm", 353, 365, "Text", "R:p_time_of_day",
                              "Text world_clock_text(Real p_time_of_day)", 0, "", "two_digits");
  if (p_id == 772) test_info_set(p_info, "world_on_event", "macro", "world", "world", "src/world/world.4dm", 367, 398, "void", "&A:p_event &A:p_info &A:p_events",
                              "void world_on_event(Attributes &p_event, Attributes &p_info, Attributes &p_events)", 0, "", "block_furnace_lit_as, block_is_furnace, emit_cell_event, emit_toast, event_integer, event_type, record_integer, record_set_integer, world_get_block, world_info_set_spawn, world_is_night, world_light_update, world_set_block, world_set_time_of_day, world_time_of_day");
  if (p_id == 773) test_info_set(p_info, "world_set_light_index", "macro", "world", "world", "src/world/world.4dm", 402, 408, "void", "I:p_index I:p_light",
                              "void world_set_light_index(Integer p_index, Integer p_light)", 0, "", "world_cell_block");
  if (p_id == 774) test_info_set(p_info, "world_light_push", "macro", "world", "world", "src/world/world.4dm", 410, 420, "Integer", "I:p_tail I:p_x I:p_y I:p_z",
                              "Integer world_light_push(Integer p_tail, Integer p_x, Integer p_y, Integer p_z)", 0, "", "");
  if (p_id == 775) test_info_set(p_info, "world_light_seed_outside", "macro", "world", "world", "src/world/world.4dm", 422, 431, "Integer", "I:p_tail I:p_x I:p_y I:p_z",
                              "Integer world_light_seed_outside(Integer p_tail, Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_get_light, world_in_bounds, world_light_push");
  if (p_id == 776) test_info_set(p_info, "world_light_update", "macro", "world", "world", "src/world/world.4dm", 433, 537, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_light_update(Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_hides_faces, block_light_emission, max_integer, min_integer, world_cell_block, world_cell_light, world_get_block, world_get_light, world_in_bounds, world_index, world_light_push, world_light_seed_outside, world_set_light_index");
  if (p_id == 777) test_info_set(p_info, "world_info_clear", "macro", "world", "world", "src/world/world.4dm", 541, 558, "void", "&A:p_info I:p_seed",
                              "void world_info_clear(Attributes &p_info, Integer p_seed)", 0, "", "record_clear, record_set_integer, record_set_real, world_info_set_spawn, world_seed_shifts");
  if (p_id == 778) test_info_set(p_info, "world_info_seed", "macro", "world", "world", "src/world/world.4dm", 560, 566, "Integer", "&A:p_info",
                              "Integer world_info_seed(Attributes &p_info)", 0, "", "record_integer");
  if (p_id == 779) test_info_set(p_info, "world_info_spawn", "macro", "world", "world", "src/world/world.4dm", 568, 576, "void", "&A:p_info &R:p_x &R:p_y &R:p_z",
                              "void world_info_spawn(Attributes &p_info, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real");
  if (p_id == 780) test_info_set(p_info, "world_info_set_spawn", "macro", "world", "world", "src/world/world.4dm", 578, 586, "void", "&A:p_info R:p_x R:p_y R:p_z",
                              "void world_info_set_spawn(Attributes &p_info, Real p_x, Real p_y, Real p_z)", 0, "", "record_set_real");
  if (p_id == 781) test_info_set(p_info, "world_seed_shifts", "macro", "world", "world", "src/world/world.4dm", 590, 601, "void", "I:p_seed &R:p_shift_a &R:p_shift_b",
                              "void world_seed_shifts(Integer p_seed, Real &p_shift_a, Real &p_shift_b)", 0, "", "floor_divide, positive_mod");
  if (p_id == 782) test_info_set(p_info, "world_value_noise", "macro", "world", "world", "src/world/world.4dm", 603, 620, "Real", "R:p_x R:p_z I:p_layer R:p_shift_a R:p_shift_b",
                              "Real world_value_noise(Real p_x, Real p_z, Integer p_layer, Real p_shift_a, Real p_shift_b)", 0, "", "hash_real, lerp_real, smooth_curve");
  if (p_id == 783) test_info_set(p_info, "world_desert_weight", "macro", "world", "world", "src/world/world.4dm", 622, 631, "Real", "I:p_x I:p_z R:p_shift_a R:p_shift_b",
                              "Real world_desert_weight(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)", 0, "", "clamp_real, smooth_curve, world_value_noise");
  if (p_id == 784) test_info_set(p_info, "world_column_biome", "macro", "world", "world", "src/world/world.4dm", 633, 642, "Integer", "I:p_x I:p_z R:p_shift_a R:p_shift_b",
                              "Integer world_column_biome(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)", 0, "", "world_desert_weight, world_value_noise");
  if (p_id == 785) test_info_set(p_info, "world_terrain_height", "macro", "world", "world", "src/world/world.4dm", 644, 676, "Integer", "I:p_x I:p_z R:p_shift_a R:p_shift_b",
                              "Integer world_terrain_height(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)", 0, "", "clamp_integer, world_desert_weight, world_value_noise");
  if (p_id == 786) test_info_set(p_info, "world_fill_columns", "macro", "world", "world", "src/world/world.4dm", 680, 755, "void", "R:p_shift_a R:p_shift_b",
                              "void world_fill_columns(Real p_shift_a, Real p_shift_b)", 0, "", "hash_real, world_column, world_column_biome, world_index, world_terrain_height");
  if (p_id == 787) test_info_set(p_info, "world_mark_carved", "macro", "world", "world", "src/world/world.4dm", 757, 768, "void", "I:p_x I:p_y I:p_z",
                              "void world_mark_carved(Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_column, world_in_bounds");
  if (p_id == 788) test_info_set(p_info, "world_carve_sphere", "macro", "world", "world", "src/world/world.4dm", 770, 818, "void", "R:p_centre_x R:p_centre_y R:p_centre_z R:p_radius",
                              "void world_carve_sphere(Real p_centre_x, Real p_centre_y, Real p_centre_z, Real p_radius)", 0, "", "world_get_block, world_in_bounds, world_mark_carved, world_set_block");
  if (p_id == 789) test_info_set(p_info, "world_carve_caves", "macro", "world", "world", "src/world/world.4dm", 820, 862, "void", "&A:p_random",
                              "void world_carve_caves(Attributes &p_random)", 0, "", "clamp_real, floor_integer, max_real, random_between, random_range, world_carve_sphere, world_column");
  if (p_id == 790) test_info_set(p_info, "world_place_veins", "macro", "world", "world", "src/world/world.4dm", 864, 893, "void", "&A:p_random I:p_block I:p_count I:p_length I:p_max_y",
                              "void world_place_veins(Attributes &p_random, Integer p_block, Integer p_count, Integer p_length, Integer p_max_y)", 0, "", "random_range, world_get_block, world_set_block");
  if (p_id == 791) test_info_set(p_info, "world_plant_tree", "macro", "world", "world", "src/world/world.4dm", 895, 928, "void", "I:p_x I:p_ground_y I:p_z R:p_shift_a R:p_shift_b",
                              "void world_plant_tree(Integer p_x, Integer p_ground_y, Integer p_z, Real p_shift_a, Real p_shift_b)", 0, "", "block_is_plant, hash_real, world_get_block, world_set_block");
  if (p_id == 792) test_info_set(p_info, "world_plant_trees", "macro", "world", "world", "src/world/world.4dm", 930, 966, "void", "R:p_shift_a R:p_shift_b",
                              "void world_plant_trees(Real p_shift_a, Real p_shift_b)", 0, "", "floor_divide, hash_real, world_biome, world_column, world_get_block, world_plant_tree, world_value_noise");
  if (p_id == 793) test_info_set(p_info, "world_plant_cactus", "macro", "world", "world", "src/world/world.4dm", 968, 981, "void", "I:p_x I:p_ground_y I:p_z I:p_tall",
                              "void world_plant_cactus(Integer p_x, Integer p_ground_y, Integer p_z, Integer p_tall)", 0, "", "world_get_block, world_set_block");
  if (p_id == 794) test_info_set(p_info, "world_add_plants", "macro", "world", "world", "src/world/world.4dm", 983, 1025, "void", "&A:p_random R:p_shift_a R:p_shift_b",
                              "void world_add_plants(Attributes &p_random, Real p_shift_a, Real p_shift_b)", 0, "", "random_next, random_range, world_biome, world_column, world_get_block, world_plant_cactus, world_set_block, world_value_noise");
  if (p_id == 795) test_info_set(p_info, "world_area_is_flat", "macro", "world", "world", "src/world/world.4dm", 1027, 1055, "Integer", "I:p_x0 I:p_z0 I:p_x1 I:p_z1 &I:p_ground_y",
                              "Integer world_area_is_flat(Integer p_x0, Integer p_z0, Integer p_x1, Integer p_z1, Integer &p_ground_y)", 0, "", "world_column, world_get_block, world_in_bounds");
  if (p_id == 796) test_info_set(p_info, "world_dig_pond", "macro", "world", "world", "src/world/world.4dm", 1057, 1085, "void", "I:p_centre_x I:p_centre_z",
                              "void world_dig_pond(Integer p_centre_x, Integer p_centre_z)", 0, "", "world_area_is_flat, world_mark_carved, world_set_block");
  if (p_id == 797) test_info_set(p_info, "world_add_ponds", "macro", "world", "world", "src/world/world.4dm", 1087, 1105, "void", "&A:p_random",
                              "void world_add_ponds(Attributes &p_random)", 0, "", "random_next, random_range, world_biome, world_dig_pond");
  if (p_id == 798) test_info_set(p_info, "world_build_house", "macro", "world", "world", "src/world/world.4dm", 1107, 1186, "void", "&A:p_info I:p_origin_x I:p_ground_y I:p_origin_z",
                              "void world_build_house(Attributes &p_info, Integer p_origin_x, Integer p_ground_y, Integer p_origin_z)", 0, "", "block_bed, block_door, block_is_solid, record_set_integer, world_get_block, world_info_set_spawn, world_set_block");
  if (p_id == 799) test_info_set(p_info, "world_place_house_near", "macro", "world", "world", "src/world/world.4dm", 1188, 1220, "void", "&A:p_info R:p_spawn_x R:p_spawn_z",
                              "void world_place_house_near(Attributes &p_info, Real p_spawn_x, Real p_spawn_z)", 0, "", "clamp_integer, floor_integer, world_area_is_flat, world_build_house, world_column");
  if (p_id == 800) test_info_set(p_info, "world_find_spawn", "macro", "world", "world", "src/world/world.4dm", 1222, 1256, "void", "&R:p_spawn_x &R:p_spawn_y &R:p_spawn_z",
                              "void world_find_spawn(Real &p_spawn_x, Real &p_spawn_y, Real &p_spawn_z)", 0, "", "floor_divide, world_get_block, world_top_solid_y");
}

void test_registry_call_20(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 761 to 800 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 761) {   // world_place_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_place_block(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 762) {   // world_apply_remote_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_apply_remote_block(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 763) {   // world_time_of_day
    Get_time(l_start);
    l_ret_r = world_time_of_day(g_info);
    Get_time(l_end);
  } else if (p_id == 764) {   // world_set_time_of_day
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    world_set_time_of_day(g_info, l_r1);
    Get_time(l_end);
  } else if (p_id == 765) {   // world_daylight_cycle
    Get_time(l_start);
    l_ret_i = world_daylight_cycle(g_info);
    Get_time(l_end);
  } else if (p_id == 766) {   // world_set_daylight_cycle
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    world_set_daylight_cycle(g_info, l_i1);
    Get_time(l_end);
  } else if (p_id == 767) {   // world_advance_time
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    world_advance_time(g_info, l_r1);
    Get_time(l_end);
  } else if (p_id == 768) {   // world_sun_height
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = world_sun_height(l_r1);
    Get_time(l_end);
  } else if (p_id == 769) {   // world_daylight
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = world_daylight(l_r1);
    Get_time(l_end);
  } else if (p_id == 770) {   // world_is_night
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = world_is_night(l_r1);
    Get_time(l_end);
  } else if (p_id == 771) {   // world_clock_text
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_t = world_clock_text(l_r1);
    Get_time(l_end);
  } else if (p_id == 772) {   // world_on_event
    Get_time(l_start);
    world_on_event(g_event, g_info, g_events);
    Get_time(l_end);
  } else if (p_id == 773) {   // world_set_light_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    world_set_light_index(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 774) {   // world_light_push
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = world_light_push(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 775) {   // world_light_seed_outside
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = world_light_seed_outside(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 776) {   // world_light_update
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_light_update(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 777) {   // world_info_clear
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    world_info_clear(g_info, l_i1);
    Get_time(l_end);
  } else if (p_id == 778) {   // world_info_seed
    Get_time(l_start);
    l_ret_i = world_info_seed(g_info);
    Get_time(l_end);
  } else if (p_id == 779) {   // world_info_spawn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    world_info_spawn(g_info, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 780) {   // world_info_set_spawn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    world_info_set_spawn(g_info, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 781) {   // world_seed_shifts
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_seed_shifts(l_i1, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 782) {   // world_value_noise
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_r = world_value_noise(l_r1, l_r2, l_i1, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 783) {   // world_desert_weight
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = world_desert_weight(l_i1, l_i2, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 784) {   // world_column_biome
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = world_column_biome(l_i1, l_i2, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 785) {   // world_terrain_height
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = world_terrain_height(l_i1, l_i2, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 786) {   // world_fill_columns
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_fill_columns(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 787) {   // world_mark_carved
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    world_mark_carved(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 788) {   // world_carve_sphere
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    world_carve_sphere(l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 789) {   // world_carve_caves
    Get_time(l_start);
    world_carve_caves(g_random);
    Get_time(l_end);
  } else if (p_id == 790) {   // world_place_veins
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_place_veins(g_random, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 791) {   // world_plant_tree
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_plant_tree(l_i1, l_i2, l_i3, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 792) {   // world_plant_trees
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_plant_trees(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 793) {   // world_plant_cactus
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_plant_cactus(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 794) {   // world_add_plants
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_add_plants(g_random, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 795) {   // world_area_is_flat
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = world_area_is_flat(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
  } else if (p_id == 796) {   // world_dig_pond
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    world_dig_pond(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 797) {   // world_add_ponds
    Get_time(l_start);
    world_add_ponds(g_random);
    Get_time(l_end);
  } else if (p_id == 798) {   // world_build_house
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    world_build_house(g_info, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 799) {   // world_place_house_near
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_place_house_near(g_info, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 800) {   // world_find_spawn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    world_find_spawn(l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_21(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 801 to 834 are
// ----------------------------------------------------------------
{
  if (p_id == 801) test_info_set(p_info, "world_finish_maps", "macro", "world", "world", "src/world/world.4dm", 1258, 1272, "void", "",
                              "void world_finish_maps()", 0, "", "world_column, world_top_opaque_y");
  if (p_id == 802) test_info_set(p_info, "world_generate", "macro", "world", "world", "src/world/world.4dm", 1274, 1310, "void", "&A:p_info I:p_seed",
                              "void world_generate(Attributes &p_info, Integer p_seed)", 0, "", "random_seed, record_integer, world_add_plants, world_add_ponds, world_carve_caves, world_fill_columns, world_find_spawn, world_finish_maps, world_info_clear, world_info_set_spawn, world_light_update, world_place_house_near, world_place_veins, world_plant_trees, world_seed_shifts");
  if (p_id == 803) test_info_set(p_info, "Absolute", "library", "library", "library", "", 0, 0, "Real", "R:p_value",
                              "Real Absolute(Real p_value)", 0, "", "");
  if (p_id == 804) test_info_set(p_info, "Absolute", "library", "library", "library", "", 0, 0, "Integer", "I:p_value",
                              "Integer Absolute(Integer p_value)", 0, "", "");
  if (p_id == 805) test_info_set(p_info, "Floor", "library", "library", "library", "", 0, 0, "Real", "R:p_value",
                              "Real Floor(Real p_value)", 0, "", "");
  if (p_id == 806) test_info_set(p_info, "Sqrt", "library", "library", "library", "", 0, 0, "Real", "R:p_positive",
                              "Real Sqrt(Real p_positive)", 0, "", "");
  if (p_id == 807) test_info_set(p_info, "Sin", "library", "library", "library", "", 0, 0, "Real", "R:p_angle",
                              "Real Sin(Real p_angle)", 0, "", "");
  if (p_id == 808) test_info_set(p_info, "Cos", "library", "library", "library", "", 0, 0, "Real", "R:p_angle",
                              "Real Cos(Real p_angle)", 0, "", "");
  if (p_id == 809) test_info_set(p_info, "To_text", "library", "library", "library", "", 0, 0, "Text", "I:p_value",
                              "Text To_text(Integer p_value)", 0, "", "");
  if (p_id == 810) test_info_set(p_info, "To_text", "library", "library", "library", "", 0, 0, "Text", "R:p_value I:p_decimals",
                              "Text To_text(Real p_value, Integer p_decimals)", 0, "", "");
  if (p_id == 811) test_info_set(p_info, "Text_length", "library", "library", "library", "", 0, 0, "Integer", "T:p_text",
                              "Integer Text_length(Text p_text)", 0, "", "");
  if (p_id == 812) test_info_set(p_info, "Get_subtext", "library", "library", "library", "", 0, 0, "Text", "T:p_text I:p_start I:p_end",
                              "Text Get_subtext(Text p_text, Integer p_start, Integer p_end)", 0, "", "");
  if (p_id == 813) test_info_set(p_info, "Find_text", "library", "library", "library", "", 0, 0, "Integer", "T:p_text T:p_find",
                              "Integer Find_text(Text p_text, Text p_find)", 0, "", "");
  if (p_id == 814) test_info_set(p_info, "Text_lower", "library", "library", "library", "", 0, 0, "Text", "T:p_text",
                              "Text Text_lower(Text p_text)", 0, "", "");
  if (p_id == 815) test_info_set(p_info, "Text_justify", "library", "library", "library", "", 0, 0, "Text", "T:p_text",
                              "Text Text_justify(Text p_text)", 0, "", "");
  if (p_id == 816) test_info_set(p_info, "From_text", "library", "library", "library", "", 0, 0, "Integer", "T:p_number &I:p_value",
                              "Integer From_text(Text p_number, Integer &p_value)", 0, "", "");
  if (p_id == 817) test_info_set(p_info, "From_text", "library", "library", "library", "", 0, 0, "Integer", "T:p_number &R:p_value",
                              "Integer From_text(Text p_number, Real &p_value)", 0, "", "");
  if (p_id == 818) test_info_set(p_info, "From_text", "library", "library", "library", "", 0, 0, "Integer", "T:p_text &D:p_words",
                              "Integer From_text(Text p_text, Dynamic_Text &p_words)", 0, "", "");
  if (p_id == 819) test_info_set(p_info, "Set_char", "library", "library", "library", "", 0, 0, "Integer", "&T:p_text I:p_position I:p_char",
                              "Integer Set_char(Text &p_text, Integer p_position, Integer p_char)", 0, "", "");
  if (p_id == 820) test_info_set(p_info, "Get_time", "library", "library", "library", "", 0, 0, "Integer", "&R:p_time",
                              "Integer Get_time(Real &p_time)", 0, "", "");
  if (p_id == 821) test_info_set(p_info, "Get_time", "library", "library", "library", "", 0, 0, "Integer", "&I:p_time",
                              "Integer Get_time(Integer &p_time)", 0, "", "");
  if (p_id == 822) test_info_set(p_info, "Get_user_name", "library", "library", "library", "", 0, 0, "Integer", "&T:p_name",
                              "Integer Get_user_name(Text &p_name)", 0, "", "");
  if (p_id == 823) test_info_set(p_info, "Get_random_number_closed", "library", "library", "library", "", 0, 0, "Real", "",
                              "Real Get_random_number_closed()", 0, "", "");
  if (p_id == 824) test_info_set(p_info, "File_exists", "library", "library", "library", "", 0, 0, "Integer", "T:p_path",
                              "Integer File_exists(Text p_path)", 0, "", "");
  if (p_id == 825) test_info_set(p_info, "Directory_exists", "library", "library", "library", "", 0, 0, "Integer", "T:p_folder",
                              "Integer Directory_exists(Text p_folder)", 0, "", "");
  if (p_id == 826) test_info_set(p_info, "Set_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field I:p_value",
                              "Integer Set_attribute(Attributes &p_record, Text p_field, Integer p_value)", 0, "", "");
  if (p_id == 827) test_info_set(p_info, "Set_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field R:p_value",
                              "Integer Set_attribute(Attributes &p_record, Text p_field, Real p_value)", 0, "", "");
  if (p_id == 828) test_info_set(p_info, "Set_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field T:p_value",
                              "Integer Set_attribute(Attributes &p_record, Text p_field, Text p_value)", 0, "", "");
  if (p_id == 829) test_info_set(p_info, "Get_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field &I:p_value",
                              "Integer Get_attribute(Attributes &p_record, Text p_field, Integer &p_value)", 0, "", "");
  if (p_id == 830) test_info_set(p_info, "Get_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field &R:p_value",
                              "Integer Get_attribute(Attributes &p_record, Text p_field, Real &p_value)", 0, "", "");
  if (p_id == 831) test_info_set(p_info, "Get_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field &T:p_value",
                              "Integer Get_attribute(Attributes &p_record, Text p_field, Text &p_value)", 0, "", "");
  if (p_id == 832) test_info_set(p_info, "Attribute_exists", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field",
                              "Integer Attribute_exists(Attributes &p_record, Text p_field)", 0, "", "");
  if (p_id == 833) test_info_set(p_info, "Get_number_of_attributes", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record &I:p_count",
                              "Integer Get_number_of_attributes(Attributes &p_record, Integer &p_count)", 0, "", "");
  if (p_id == 834) test_info_set(p_info, "Attribute_delete_all", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record",
                              "Integer Attribute_delete_all(Attributes &p_record)", 0, "", "");
}

void test_registry_call_21(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 801 to 834 (see the header)
// ----------------------------------------------------------------
{
  Integer l_i1 = 0;
  Integer l_i2 = 0;
  Integer l_i3 = 0;
  Integer l_i4 = 0;
  Integer l_i5 = 0;
  Integer l_i6 = 0;
  Integer l_i7 = 0;
  Integer l_i8 = 0;
  Integer l_i9 = 0;
  Integer l_i10 = 0;
  Integer l_i11 = 0;
  Integer l_i12 = 0;
  Real    l_r1 = 0.0;
  Real    l_r2 = 0.0;
  Real    l_r3 = 0.0;
  Real    l_r4 = 0.0;
  Real    l_r5 = 0.0;
  Real    l_r6 = 0.0;
  Real    l_r7 = 0.0;
  Real    l_r8 = 0.0;
  Real    l_r9 = 0.0;
  Real    l_r10 = 0.0;
  Real    l_r11 = 0.0;
  Real    l_r12 = 0.0;
  Real    l_r13 = 0.0;
  Text    l_t1 = "";
  Text    l_t2 = "";
  Text    l_t3 = "";
  Text    l_t4 = "";
  Text    l_t5 = "";
  Text    l_t6 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 801) {   // world_finish_maps
    Get_time(l_start);
    world_finish_maps();
    Get_time(l_end);
  } else if (p_id == 802) {   // world_generate
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    world_generate(g_info, l_i1);
    Get_time(l_end);
  } else if (p_id == 803) {   // Absolute
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Absolute(l_r1);
    Get_time(l_end);
  } else if (p_id == 804) {   // Absolute
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Absolute(l_i1);
    Get_time(l_end);
  } else if (p_id == 805) {   // Floor
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Floor(l_r1);
    Get_time(l_end);
  } else if (p_id == 806) {   // Sqrt
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Sqrt(l_r1);
    Get_time(l_end);
  } else if (p_id == 807) {   // Sin
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Sin(l_r1);
    Get_time(l_end);
  } else if (p_id == 808) {   // Cos
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Cos(l_r1);
    Get_time(l_end);
  } else if (p_id == 809) {   // To_text
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = To_text(l_i1);
    Get_time(l_end);
  } else if (p_id == 810) {   // To_text
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = To_text(l_r1, l_i1);
    Get_time(l_end);
  } else if (p_id == 811) {   // Text_length
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = Text_length(l_t1);
    Get_time(l_end);
  } else if (p_id == 812) {   // Get_subtext
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_t = Get_subtext(l_t1, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 813) {   // Find_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = Find_text(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 814) {   // Text_lower
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = Text_lower(l_t1);
    Get_time(l_end);
  } else if (p_id == 815) {   // Text_justify
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = Text_justify(l_t1);
    Get_time(l_end);
  } else if (p_id == 816) {   // From_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = From_text(l_t1, l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 817) {   // From_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = From_text(l_t1, l_r1);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
  } else if (p_id == 818) {   // From_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    Get_time(l_start);
    l_ret_i = From_text(l_t1, g_test_words);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 819) {   // Set_char
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = Set_char(l_t1, l_i1, l_i2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 820) {   // Get_time
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = Get_time(l_r1);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
  } else if (p_id == 821) {   // Get_time
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Get_time(l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 822) {   // Get_user_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = Get_user_name(l_t1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 823) {   // Get_random_number_closed
    Get_time(l_start);
    l_ret_r = Get_random_number_closed();
    Get_time(l_end);
  } else if (p_id == 824) {   // File_exists
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = File_exists(l_t1);
    Get_time(l_end);
  } else if (p_id == 825) {   // Directory_exists
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = Directory_exists(l_t1);
    Get_time(l_end);
  } else if (p_id == 826) {   // Set_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Set_attribute(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 827) {   // Set_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = Set_attribute(g_test_record, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 828) {   // Set_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = Set_attribute(g_test_record, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 829) {   // Get_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Get_attribute(g_test_record, l_t1, l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 830) {   // Get_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = Get_attribute(g_test_record, l_t1, l_r1);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
  } else if (p_id == 831) {   // Get_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = Get_attribute(g_test_record, l_t1, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 832) {   // Attribute_exists
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = Attribute_exists(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 833) {   // Get_number_of_attributes
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Get_number_of_attributes(g_test_record, l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 834) {   // Attribute_delete_all
    Get_time(l_start);
    l_ret_i = Attribute_delete_all(g_test_record);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// Fill p_info with what function p_id (1..TEST_FUNCTION_COUNT) is
// ----------------------------------------------------------------
{
  if (p_id >= 1 && p_id <= 40) test_registry_info_1(p_id, p_info);
  if (p_id >= 41 && p_id <= 80) test_registry_info_2(p_id, p_info);
  if (p_id >= 81 && p_id <= 120) test_registry_info_3(p_id, p_info);
  if (p_id >= 121 && p_id <= 160) test_registry_info_4(p_id, p_info);
  if (p_id >= 161 && p_id <= 200) test_registry_info_5(p_id, p_info);
  if (p_id >= 201 && p_id <= 240) test_registry_info_6(p_id, p_info);
  if (p_id >= 241 && p_id <= 280) test_registry_info_7(p_id, p_info);
  if (p_id >= 281 && p_id <= 320) test_registry_info_8(p_id, p_info);
  if (p_id >= 321 && p_id <= 360) test_registry_info_9(p_id, p_info);
  if (p_id >= 361 && p_id <= 400) test_registry_info_10(p_id, p_info);
  if (p_id >= 401 && p_id <= 440) test_registry_info_11(p_id, p_info);
  if (p_id >= 441 && p_id <= 480) test_registry_info_12(p_id, p_info);
  if (p_id >= 481 && p_id <= 520) test_registry_info_13(p_id, p_info);
  if (p_id >= 521 && p_id <= 560) test_registry_info_14(p_id, p_info);
  if (p_id >= 561 && p_id <= 600) test_registry_info_15(p_id, p_info);
  if (p_id >= 601 && p_id <= 640) test_registry_info_16(p_id, p_info);
  if (p_id >= 641 && p_id <= 680) test_registry_info_17(p_id, p_info);
  if (p_id >= 681 && p_id <= 720) test_registry_info_18(p_id, p_info);
  if (p_id >= 721 && p_id <= 760) test_registry_info_19(p_id, p_info);
  if (p_id >= 761 && p_id <= 800) test_registry_info_20(p_id, p_info);
  if (p_id >= 801 && p_id <= 834) test_registry_info_21(p_id, p_info);
}

void test_registry_call(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run function p_id with the inputs in p_in; outputs go in p_out
// ----------------------------------------------------------------
{
  record_clear(p_out, DATATYPE_TEST_INFO);
  if (p_id >= 1 && p_id <= 40) test_registry_call_1(p_id, p_in, p_out);
  if (p_id >= 41 && p_id <= 80) test_registry_call_2(p_id, p_in, p_out);
  if (p_id >= 81 && p_id <= 120) test_registry_call_3(p_id, p_in, p_out);
  if (p_id >= 121 && p_id <= 160) test_registry_call_4(p_id, p_in, p_out);
  if (p_id >= 161 && p_id <= 200) test_registry_call_5(p_id, p_in, p_out);
  if (p_id >= 201 && p_id <= 240) test_registry_call_6(p_id, p_in, p_out);
  if (p_id >= 241 && p_id <= 280) test_registry_call_7(p_id, p_in, p_out);
  if (p_id >= 281 && p_id <= 320) test_registry_call_8(p_id, p_in, p_out);
  if (p_id >= 321 && p_id <= 360) test_registry_call_9(p_id, p_in, p_out);
  if (p_id >= 361 && p_id <= 400) test_registry_call_10(p_id, p_in, p_out);
  if (p_id >= 401 && p_id <= 440) test_registry_call_11(p_id, p_in, p_out);
  if (p_id >= 441 && p_id <= 480) test_registry_call_12(p_id, p_in, p_out);
  if (p_id >= 481 && p_id <= 520) test_registry_call_13(p_id, p_in, p_out);
  if (p_id >= 521 && p_id <= 560) test_registry_call_14(p_id, p_in, p_out);
  if (p_id >= 561 && p_id <= 600) test_registry_call_15(p_id, p_in, p_out);
  if (p_id >= 601 && p_id <= 640) test_registry_call_16(p_id, p_in, p_out);
  if (p_id >= 641 && p_id <= 680) test_registry_call_17(p_id, p_in, p_out);
  if (p_id >= 681 && p_id <= 720) test_registry_call_18(p_id, p_in, p_out);
  if (p_id >= 721 && p_id <= 760) test_registry_call_19(p_id, p_in, p_out);
  if (p_id >= 761 && p_id <= 800) test_registry_call_20(p_id, p_in, p_out);
  if (p_id >= 801 && p_id <= 834) test_registry_call_21(p_id, p_in, p_out);
}

#endif
