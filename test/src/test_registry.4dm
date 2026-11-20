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
  if (p_id == 1) test_info_set(p_info, "block_is_solid", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 12, 23, "Integer", "I:p_block",
                              "Integer block_is_solid(Integer p_block)", 0, "", "block_is_plant");
  if (p_id == 2) test_info_set(p_info, "block_is_liquid", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 25, 33, "Integer", "I:p_block",
                              "Integer block_is_liquid(Integer p_block)", 0, "", "");
  if (p_id == 3) test_info_set(p_info, "block_is_plant", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 35, 46, "Integer", "I:p_block",
                              "Integer block_is_plant(Integer p_block)", 0, "", "");
  if (p_id == 4) test_info_set(p_info, "block_is_flammable", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 48, 67, "Integer", "I:p_block",
                              "Integer block_is_flammable(Integer p_block)", 0, "", "block_is_bed, block_is_door");
  if (p_id == 5) test_info_set(p_info, "block_is_door", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 71, 77, "Integer", "I:p_block",
                              "Integer block_is_door(Integer p_block)", 0, "", "");
  if (p_id == 6) test_info_set(p_info, "block_is_bed", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 79, 86, "Integer", "I:p_block",
                              "Integer block_is_bed(Integer p_block)", 0, "", "");
  if (p_id == 7) test_info_set(p_info, "block_is_shaped", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 88, 95, "Integer", "I:p_block",
                              "Integer block_is_shaped(Integer p_block)", 0, "", "block_is_bed, block_is_chest, block_is_door");
  if (p_id == 8) test_info_set(p_info, "block_door", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 97, 108, "Integer", "I:p_facing I:p_open I:p_top",
                              "Integer block_door(Integer p_facing, Integer p_open, Integer p_top)", 0, "", "");
  if (p_id == 9) test_info_set(p_info, "block_door_facing", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 110, 116, "Integer", "I:p_block",
                              "Integer block_door_facing(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 10) test_info_set(p_info, "block_door_open", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 118, 124, "Integer", "I:p_block",
                              "Integer block_door_open(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 11) test_info_set(p_info, "block_door_top", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 126, 132, "Integer", "I:p_block",
                              "Integer block_door_top(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 12) test_info_set(p_info, "block_bed", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 134, 143, "Integer", "I:p_facing I:p_head",
                              "Integer block_bed(Integer p_facing, Integer p_head)", 0, "", "");
  if (p_id == 13) test_info_set(p_info, "block_bed_facing", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 145, 151, "Integer", "I:p_block",
                              "Integer block_bed_facing(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 14) test_info_set(p_info, "block_bed_head", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 153, 159, "Integer", "I:p_block",
                              "Integer block_bed_head(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 15) test_info_set(p_info, "block_facing_step", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 161, 172, "void", "I:p_facing &I:p_dx &I:p_dz",
                              "void block_facing_step(Integer p_facing, Integer &p_dx, Integer &p_dz)", 0, "", "");
  if (p_id == 16) test_info_set(p_info, "block_is_chest", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 174, 181, "Integer", "I:p_block",
                              "Integer block_is_chest(Integer p_block)", 0, "", "");
  if (p_id == 17) test_info_set(p_info, "block_chest", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 183, 190, "Integer", "I:p_facing I:p_type",
                              "Integer block_chest(Integer p_facing, Integer p_type)", 0, "", "");
  if (p_id == 18) test_info_set(p_info, "block_chest_facing", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 192, 199, "Integer", "I:p_block",
                              "Integer block_chest_facing(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 19) test_info_set(p_info, "block_chest_type", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 201, 209, "Integer", "I:p_block",
                              "Integer block_chest_type(Integer p_block)", 0, "", "floor_divide");
  if (p_id == 20) test_info_set(p_info, "block_facing_side", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 211, 224, "void", "I:p_facing &I:p_dx &I:p_dz",
                              "void block_facing_side(Integer p_facing, Integer &p_dx, Integer &p_dz)", 0, "", "");
  if (p_id == 21) test_info_set(p_info, "chest_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 226, 233, "Integer", "I:p_type",
                              "Integer chest_texture(Integer p_type)", 0, "", "");
  if (p_id == 22) test_info_set(p_info, "block_partner", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 235, 278, "Integer", "I:p_block I:p_x I:p_y I:p_z &I:p_px &I:p_py &I:p_pz",
                              "Integer block_partner(Integer p_block, Integer p_x, Integer p_y, Integer p_z, Integer &p_px, Integer &p_py, Integer &p_pz)", 0, "", "block_bed_facing, block_bed_head, block_chest_facing, block_chest_type, block_door_top, block_facing_side, block_facing_step, block_is_bed, block_is_chest, block_is_door");
  if (p_id == 23) test_info_set(p_info, "block_box", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 280, 364, "Integer", "I:p_block &R:p_min_x &R:p_min_y &R:p_min_z &R:p_max_x &R:p_max_y &R:p_max_z",
                              "Integer block_box(Integer p_block, Real &p_min_x, Real &p_min_y, Real &p_min_z, Real &p_max_x, Real &p_max_y, Real &p_max_z)", 0, "", "block_chest_facing, block_chest_type, block_door_facing, block_door_open, block_facing_side, block_is_bed, block_is_chest, block_is_door, block_is_plant");
  if (p_id == 24) test_info_set(p_info, "block_light_emission", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 366, 377, "Integer", "I:p_block",
                              "Integer block_light_emission(Integer p_block)", 0, "", "block_furnace_is_lit");
  if (p_id == 25) test_info_set(p_info, "block_is_see_through", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 379, 389, "Integer", "I:p_block",
                              "Integer block_is_see_through(Integer p_block)", 0, "", "");
  if (p_id == 26) test_info_set(p_info, "block_hides_faces", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 391, 403, "Integer", "I:p_block",
                              "Integer block_hides_faces(Integer p_block)", 0, "", "block_is_see_through, block_is_shaped, block_is_solid");
  if (p_id == 27) test_info_set(p_info, "block_plant_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 405, 417, "Integer", "I:p_block",
                              "Integer block_plant_texture(Integer p_block)", 0, "", "");
  if (p_id == 28) test_info_set(p_info, "block_is_furnace", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 419, 427, "Integer", "I:p_block",
                              "Integer block_is_furnace(Integer p_block)", 0, "", "");
  if (p_id == 29) test_info_set(p_info, "block_furnace_is_lit", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 429, 436, "Integer", "I:p_block",
                              "Integer block_furnace_is_lit(Integer p_block)", 0, "", "");
  if (p_id == 30) test_info_set(p_info, "block_furnace_lit_as", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 438, 449, "Integer", "I:p_block I:p_lit",
                              "Integer block_furnace_lit_as(Integer p_block, Integer p_lit)", 0, "", "block_furnace_is_lit");
  if (p_id == 31) test_info_set(p_info, "block_furnace_front", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 451, 463, "Integer", "I:p_block",
                              "Integer block_furnace_front(Integer p_block)", 0, "", "block_furnace_lit_as");
  if (p_id == 32) test_info_set(p_info, "block_falls", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 465, 473, "Integer", "I:p_block",
                              "Integer block_falls(Integer p_block)", 0, "", "");
  if (p_id == 33) test_info_set(p_info, "block_hand_hits", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 475, 512, "Integer", "I:p_block",
                              "Integer block_hand_hits(Integer p_block)", 0, "", "block_is_bed, block_is_chest, block_is_door, block_is_plant");
  if (p_id == 34) test_info_set(p_info, "block_tool_kind", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 514, 543, "Integer", "I:p_block",
                              "Integer block_tool_kind(Integer p_block)", 0, "", "block_is_bed, block_is_chest, block_is_door, block_is_furnace");
  if (p_id == 35) test_info_set(p_info, "block_needs_tool", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 545, 553, "Integer", "I:p_block",
                              "Integer block_needs_tool(Integer p_block)", 0, "", "block_tool_kind");
  if (p_id == 36) test_info_set(p_info, "block_tier_needed", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 555, 566, "Integer", "I:p_block",
                              "Integer block_tier_needed(Integer p_block)", 0, "", "");
  if (p_id == 37) test_info_set(p_info, "block_hits_with", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 568, 591, "Integer", "I:p_block I:p_tool_item",
                              "Integer block_hits_with(Integer p_block, Integer p_tool_item)", 0, "", "block_hand_hits, block_tool_kind, item_tool_kind, item_tool_tier");
  if (p_id == 38) test_info_set(p_info, "block_drop_item", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 593, 631, "Integer", "I:p_block I:p_tool_item",
                              "Integer block_drop_item(Integer p_block, Integer p_tool_item)", 0, "", "block_bed_head, block_door_top, block_is_bed, block_is_chest, block_is_door, block_is_furnace, block_needs_tool, block_tier_needed, block_tool_kind, item_tool_kind, item_tool_tier");
  if (p_id == 39) test_info_set(p_info, "block_pick_item", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 633, 645, "Integer", "I:p_block",
                              "Integer block_pick_item(Integer p_block)", 0, "", "block_is_bed, block_is_chest, block_is_door, block_is_furnace, item_places_block");
  if (p_id == 40) test_info_set(p_info, "block_face_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 647, 722, "Integer", "I:p_block I:p_direction",
                              "Integer block_face_texture(Integer p_block, Integer p_direction)", 0, "", "block_furnace_front, block_furnace_is_lit, block_is_chest, block_is_furnace, chest_texture");
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
  Text    l_t7 = "";
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
  } else if (p_id == 2) {   // block_is_liquid
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_liquid(l_i1);
    Get_time(l_end);
  } else if (p_id == 3) {   // block_is_plant
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_plant(l_i1);
    Get_time(l_end);
  } else if (p_id == 4) {   // block_is_flammable
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_flammable(l_i1);
    Get_time(l_end);
  } else if (p_id == 5) {   // block_is_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_door(l_i1);
    Get_time(l_end);
  } else if (p_id == 6) {   // block_is_bed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_bed(l_i1);
    Get_time(l_end);
  } else if (p_id == 7) {   // block_is_shaped
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_shaped(l_i1);
    Get_time(l_end);
  } else if (p_id == 8) {   // block_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = block_door(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 9) {   // block_door_facing
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_door_facing(l_i1);
    Get_time(l_end);
  } else if (p_id == 10) {   // block_door_open
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_door_open(l_i1);
    Get_time(l_end);
  } else if (p_id == 11) {   // block_door_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_door_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 12) {   // block_bed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_bed(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 13) {   // block_bed_facing
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_bed_facing(l_i1);
    Get_time(l_end);
  } else if (p_id == 14) {   // block_bed_head
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_bed_head(l_i1);
    Get_time(l_end);
  } else if (p_id == 15) {   // block_facing_step
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    block_facing_step(l_i1, l_i2, l_i3);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
  } else if (p_id == 16) {   // block_is_chest
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_chest(l_i1);
    Get_time(l_end);
  } else if (p_id == 17) {   // block_chest
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_chest(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 18) {   // block_chest_facing
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_chest_facing(l_i1);
    Get_time(l_end);
  } else if (p_id == 19) {   // block_chest_type
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_chest_type(l_i1);
    Get_time(l_end);
  } else if (p_id == 20) {   // block_facing_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    block_facing_side(l_i1, l_i2, l_i3);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
  } else if (p_id == 21) {   // chest_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = chest_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 22) {   // block_partner
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
  } else if (p_id == 23) {   // block_box
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
  } else if (p_id == 24) {   // block_light_emission
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_light_emission(l_i1);
    Get_time(l_end);
  } else if (p_id == 25) {   // block_is_see_through
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_see_through(l_i1);
    Get_time(l_end);
  } else if (p_id == 26) {   // block_hides_faces
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_hides_faces(l_i1);
    Get_time(l_end);
  } else if (p_id == 27) {   // block_plant_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_plant_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 28) {   // block_is_furnace
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_is_furnace(l_i1);
    Get_time(l_end);
  } else if (p_id == 29) {   // block_furnace_is_lit
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_furnace_is_lit(l_i1);
    Get_time(l_end);
  } else if (p_id == 30) {   // block_furnace_lit_as
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_furnace_lit_as(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 31) {   // block_furnace_front
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_furnace_front(l_i1);
    Get_time(l_end);
  } else if (p_id == 32) {   // block_falls
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_falls(l_i1);
    Get_time(l_end);
  } else if (p_id == 33) {   // block_hand_hits
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_hand_hits(l_i1);
    Get_time(l_end);
  } else if (p_id == 34) {   // block_tool_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_tool_kind(l_i1);
    Get_time(l_end);
  } else if (p_id == 35) {   // block_needs_tool
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_needs_tool(l_i1);
    Get_time(l_end);
  } else if (p_id == 36) {   // block_tier_needed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_tier_needed(l_i1);
    Get_time(l_end);
  } else if (p_id == 37) {   // block_hits_with
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_hits_with(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 38) {   // block_drop_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_drop_item(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 39) {   // block_pick_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = block_pick_item(l_i1);
    Get_time(l_end);
  } else if (p_id == 40) {   // block_face_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = block_face_texture(l_i1, l_i2);
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
  if (p_id == 41) test_info_set(p_info, "block_face_shade", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 724, 734, "Real", "I:p_direction",
                              "Real block_face_shade(Integer p_direction)", 0, "", "");
  if (p_id == 42) test_info_set(p_info, "item_name", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 738, 813, "Text", "I:p_item",
                              "Text item_name(Integer p_item)", 0, "", "");
  if (p_id == 43) test_info_set(p_info, "item_places_block", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 815, 830, "Integer", "I:p_item",
                              "Integer item_places_block(Integer p_item)", 0, "", "");
  if (p_id == 44) test_info_set(p_info, "item_is_block", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 832, 840, "Integer", "I:p_item",
                              "Integer item_is_block(Integer p_item)", 0, "", "block_is_plant, item_places_block");
  if (p_id == 45) test_info_set(p_info, "item_max_stack", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 842, 851, "Integer", "I:p_item",
                              "Integer item_max_stack(Integer p_item)", 0, "", "item_armour_place, item_tool_kind");
  if (p_id == 46) test_info_set(p_info, "item_tool_kind", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 853, 867, "Integer", "I:p_item",
                              "Integer item_tool_kind(Integer p_item)", 0, "", "");
  if (p_id == 47) test_info_set(p_info, "item_tool_tier", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 869, 884, "Integer", "I:p_item",
                              "Integer item_tool_tier(Integer p_item)", 0, "", "");
  if (p_id == 48) test_info_set(p_info, "item_max_uses", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 886, 906, "Integer", "I:p_item",
                              "Integer item_max_uses(Integer p_item)", 0, "", "item_tool_tier");
  if (p_id == 49) test_info_set(p_info, "item_attack_damage", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 908, 920, "Integer", "I:p_item",
                              "Integer item_attack_damage(Integer p_item)", 0, "", "item_tool_kind, item_tool_tier");
  if (p_id == 50) test_info_set(p_info, "item_food_value", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 922, 933, "Integer", "I:p_item",
                              "Integer item_food_value(Integer p_item)", 0, "", "");
  if (p_id == 51) test_info_set(p_info, "item_armour_place", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 935, 950, "Integer", "I:p_item",
                              "Integer item_armour_place(Integer p_item)", 0, "", "");
  if (p_id == 52) test_info_set(p_info, "item_armour_points", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 952, 967, "Integer", "I:p_item",
                              "Integer item_armour_points(Integer p_item)", 0, "", "");
  if (p_id == 53) test_info_set(p_info, "item_worn_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 969, 978, "Integer", "I:p_item I:p_part",
                              "Integer item_worn_texture(Integer p_item, Integer p_part)", 0, "", "");
  if (p_id == 54) test_info_set(p_info, "item_spawn_egg_mob", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 980, 989, "Integer", "I:p_item",
                              "Integer item_spawn_egg_mob(Integer p_item)", 0, "", "");
  if (p_id == 55) test_info_set(p_info, "item_fuel_seconds", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 991, 1005, "Integer", "I:p_item",
                              "Integer item_fuel_seconds(Integer p_item)", 0, "", "item_tool_tier");
  if (p_id == 56) test_info_set(p_info, "item_smelt_result", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 1007, 1019, "Integer", "I:p_item",
                              "Integer item_smelt_result(Integer p_item)", 0, "", "");
  if (p_id == 57) test_info_set(p_info, "item_top_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 1021, 1028, "Integer", "I:p_item",
                              "Integer item_top_texture(Integer p_item)", 0, "", "block_face_texture, item_places_block");
  if (p_id == 58) test_info_set(p_info, "item_side_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 1030, 1037, "Integer", "I:p_item",
                              "Integer item_side_texture(Integer p_item)", 0, "", "block_face_texture, item_places_block");
  if (p_id == 59) test_info_set(p_info, "item_sprite_texture", "macro", "blocks", "blocks", "src/blocks/blocks.4dm", 1039, 1086, "Integer", "I:p_item",
                              "Integer item_sprite_texture(Integer p_item)", 0, "", "block_plant_texture");
  if (p_id == 60) test_info_set(p_info, "pack_init_tables", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 14, 68, "void", "",
                              "void pack_init_tables()", 0, "", "floor_divide");
  if (p_id == 61) test_info_set(p_info, "pack_word_byte", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 72, 89, "Integer", "I:p_word I:p_byte",
                              "Integer pack_word_byte(Integer p_word, Integer p_byte)", 0, "", "floor_divide");
  if (p_id == 62) test_info_set(p_info, "pack_paeth", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 91, 104, "Integer", "I:p_left I:p_up I:p_up_left",
                              "Integer pack_paeth(Integer p_left, Integer p_up, Integer p_up_left)", 0, "", "");
  if (p_id == 63) test_info_set(p_info, "pack_is_zip", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 106, 117, "Integer", "T:p_path",
                              "Integer pack_is_zip(Text p_path)", 0, "", "");
  if (p_id == 64) test_info_set(p_info, "pack_key", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 119, 126, "Text", "T:p_kind T:p_name",
                              "Text pack_key(Text p_kind, Text p_name)", 0, "", "pack_replace");
  if (p_id == 65) test_info_set(p_info, "pack_replace", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 128, 143, "Text", "T:p_text T:p_find T:p_with",
                              "Text pack_replace(Text p_text, Text p_find, Text p_with)", 0, "", "");
  if (p_id == 66) test_info_set(p_info, "pack_part", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 145, 161, "Integer", "&I:p_tex &T:p_kind &T:p_name &I:p_x &I:p_y &I:p_w &I:p_h &I:p_turn I:p_set_tex T:p_set_kind T:p_set_name I:p_set_x I:p_set_y I:p_set_w I:p_set_h I:p_set_turn",
                              "Integer pack_part(Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h, Integer &p_turn, Integer p_set_tex, Text p_set_kind, Text p_set_name, Integer p_set_x, Integer p_set_y, Integer p_set_w, Integer p_set_h, Integer p_set_turn)", 0, "", "");
  if (p_id == 67) test_info_set(p_info, "pack_map_part", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 163, 302, "Integer", "I:p_entry &I:p_tex &T:p_kind &T:p_name &I:p_x &I:p_y &I:p_w &I:p_h &I:p_turn",
                              "Integer pack_map_part(Integer p_entry, Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h, Integer &p_turn)", 0, "", "chest_texture, pack_part");
  if (p_id == 68) test_info_set(p_info, "pack_entry", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 304, 316, "Integer", "&I:p_tex &T:p_kind &T:p_name &I:p_tint &T:p_overlay I:p_set_tex T:p_set_kind T:p_set_name I:p_set_tint T:p_set_overlay",
                              "Integer pack_entry(Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_tint, Text &p_overlay, Integer p_set_tex, Text p_set_kind, Text p_set_name, Integer p_set_tint, Text p_set_overlay)", 0, "", "");
  if (p_id == 69) test_info_set(p_info, "pack_map_entry", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 318, 415, "Integer", "I:p_entry &I:p_tex &T:p_kind &T:p_name &I:p_tint &T:p_overlay",
                              "Integer pack_map_entry(Integer p_entry, Integer &p_tex, Text &p_kind, Text &p_name, Integer &p_tint, Text &p_overlay)", 0, "", "pack_entry");
  if (p_id == 70) test_info_set(p_info, "pack_store_byte", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 419, 430, "void", "I:p_buffer I:p_position I:p_value",
                              "void pack_store_byte(Integer p_buffer, Integer p_position, Integer p_value)", 0, "", "");
  if (p_id == 71) test_info_set(p_info, "pack_read_bytes", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 432, 474, "Integer", "&?:p_file I:p_count I:p_buffer",
                              "Integer pack_read_bytes(File &p_file, Integer p_count, Integer p_buffer)", 0, "takes an open File", "pack_store_byte, pack_word_byte");
  if (p_id == 72) test_info_set(p_info, "pack_read_short_at", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 476, 486, "Integer", "&?:p_file",
                              "Integer pack_read_short_at(File &p_file)", 0, "takes an open File", "");
  if (p_id == 73) test_info_set(p_info, "pack_read_word_at", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 488, 498, "Integer", "&?:p_file",
                              "Integer pack_read_word_at(File &p_file)", 0, "takes an open File", "");
  if (p_id == 74) test_info_set(p_info, "pack_file_size", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 500, 525, "Integer", "&?:p_file",
                              "Integer pack_file_size(File &p_file)", 0, "takes an open File", "floor_divide");
  if (p_id == 75) test_info_set(p_info, "inflate_bit", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 529, 547, "Integer", "",
                              "Integer inflate_bit()", 0, "", "");
  if (p_id == 76) test_info_set(p_info, "inflate_bits", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 549, 561, "Integer", "I:p_count",
                              "Integer inflate_bits(Integer p_count)", 0, "", "inflate_bit");
  if (p_id == 77) test_info_set(p_info, "inflate_put", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 563, 571, "void", "I:p_byte",
                              "void inflate_put(Integer p_byte)", 0, "", "");
  if (p_id == 78) test_info_set(p_info, "inflate_build", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 573, 612, "Integer", "I:p_table I:p_first I:p_count",
                              "Integer inflate_build(Integer p_table, Integer p_first, Integer p_count)", 0, "", "");
  if (p_id == 79) test_info_set(p_info, "inflate_decode", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 614, 639, "Integer", "I:p_table",
                              "Integer inflate_decode(Integer p_table)", 0, "", "inflate_bit");
  if (p_id == 80) test_info_set(p_info, "inflate_codes", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 641, 680, "Integer", "",
                              "Integer inflate_codes()", 0, "", "inflate_bits, inflate_decode, inflate_put");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 41) {   // block_face_shade
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = block_face_shade(l_i1);
    Get_time(l_end);
  } else if (p_id == 42) {   // item_name
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = item_name(l_i1);
    Get_time(l_end);
  } else if (p_id == 43) {   // item_places_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_places_block(l_i1);
    Get_time(l_end);
  } else if (p_id == 44) {   // item_is_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_is_block(l_i1);
    Get_time(l_end);
  } else if (p_id == 45) {   // item_max_stack
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_max_stack(l_i1);
    Get_time(l_end);
  } else if (p_id == 46) {   // item_tool_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_tool_kind(l_i1);
    Get_time(l_end);
  } else if (p_id == 47) {   // item_tool_tier
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_tool_tier(l_i1);
    Get_time(l_end);
  } else if (p_id == 48) {   // item_max_uses
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_max_uses(l_i1);
    Get_time(l_end);
  } else if (p_id == 49) {   // item_attack_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_attack_damage(l_i1);
    Get_time(l_end);
  } else if (p_id == 50) {   // item_food_value
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_food_value(l_i1);
    Get_time(l_end);
  } else if (p_id == 51) {   // item_armour_place
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_armour_place(l_i1);
    Get_time(l_end);
  } else if (p_id == 52) {   // item_armour_points
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_armour_points(l_i1);
    Get_time(l_end);
  } else if (p_id == 53) {   // item_worn_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = item_worn_texture(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 54) {   // item_spawn_egg_mob
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_spawn_egg_mob(l_i1);
    Get_time(l_end);
  } else if (p_id == 55) {   // item_fuel_seconds
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_fuel_seconds(l_i1);
    Get_time(l_end);
  } else if (p_id == 56) {   // item_smelt_result
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_smelt_result(l_i1);
    Get_time(l_end);
  } else if (p_id == 57) {   // item_top_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_top_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 58) {   // item_side_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_side_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 59) {   // item_sprite_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = item_sprite_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 60) {   // pack_init_tables
    Get_time(l_start);
    pack_init_tables();
    Get_time(l_end);
  } else if (p_id == 61) {   // pack_word_byte
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = pack_word_byte(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 62) {   // pack_paeth
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = pack_paeth(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 63) {   // pack_is_zip
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = pack_is_zip(l_t1);
    Get_time(l_end);
  } else if (p_id == 64) {   // pack_key
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = pack_key(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 65) {   // pack_replace
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_t = pack_replace(l_t1, l_t2, l_t3);
    Get_time(l_end);
  } else if (p_id == 66) {   // pack_part
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_i8 = record_integer(p_in, ATTR_TEST_I8);
    l_i9 = record_integer(p_in, ATTR_TEST_I9);
    l_i10 = record_integer(p_in, ATTR_TEST_I10);
    l_i11 = record_integer(p_in, ATTR_TEST_I11);
    l_i12 = record_integer(p_in, ATTR_TEST_I12);
    Get_time(l_start);
    l_ret_i = pack_part(l_i1, l_t1, l_t2, l_i2, l_i3, l_i4, l_i5, l_i6, l_i7, l_t3, l_t4, l_i8, l_i9, l_i10, l_i11, l_i12);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
  } else if (p_id == 67) {   // pack_map_part
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    Get_time(l_start);
    l_ret_i = pack_map_part(l_i1, l_i2, l_t1, l_t2, l_i3, l_i4, l_i5, l_i6, l_i7);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
    record_set_integer(p_out, ATTR_TEST_I7, l_i7);
  } else if (p_id == 68) {   // pack_entry
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
  } else if (p_id == 69) {   // pack_map_entry
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
  } else if (p_id == 70) {   // pack_store_byte
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    pack_store_byte(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 75) {   // inflate_bit
    Get_time(l_start);
    l_ret_i = inflate_bit();
    Get_time(l_end);
  } else if (p_id == 76) {   // inflate_bits
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inflate_bits(l_i1);
    Get_time(l_end);
  } else if (p_id == 77) {   // inflate_put
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    inflate_put(l_i1);
    Get_time(l_end);
  } else if (p_id == 78) {   // inflate_build
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = inflate_build(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 79) {   // inflate_decode
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inflate_decode(l_i1);
    Get_time(l_end);
  } else if (p_id == 80) {   // inflate_codes
    Get_time(l_start);
    l_ret_i = inflate_codes();
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
  if (p_id == 81) test_info_set(p_info, "inflate_stored", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 682, 704, "Integer", "",
                              "Integer inflate_stored()", 0, "", "inflate_put");
  if (p_id == 82) test_info_set(p_info, "inflate_fixed", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 706, 723, "Integer", "",
                              "Integer inflate_fixed()", 0, "", "inflate_build, inflate_codes");
  if (p_id == 83) test_info_set(p_info, "inflate_dynamic", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 725, 785, "Integer", "",
                              "Integer inflate_dynamic()", 0, "", "inflate_bits, inflate_build, inflate_codes, inflate_decode");
  if (p_id == 84) test_info_set(p_info, "pack_inflate", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 787, 823, "Integer", "I:p_first I:p_last I:p_limit",
                              "Integer pack_inflate(Integer p_first, Integer p_last, Integer p_limit)", 0, "", "inflate_bit, inflate_bits, inflate_dynamic, inflate_fixed, inflate_stored, pack_init_tables");
  if (p_id == 85) test_info_set(p_info, "pack_zip_index", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 827, 915, "Integer", "T:p_path &A:p_wanted &A:p_index &T:p_problem",
                              "Integer pack_zip_index(Text p_path, Attributes &p_wanted, Attributes &p_index, Text &p_problem)", 0, "", "pack_file_size, pack_key, pack_read_short_at, pack_read_word_at, record_clear, record_integer, record_set_integer");
  if (p_id == 86) test_info_set(p_info, "pack_load_png_from_zip", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 917, 964, "Integer", "T:p_path &A:p_index T:p_key",
                              "Integer pack_load_png_from_zip(Text p_path, Attributes &p_index, Text p_key)", 0, "", "pack_inflate, pack_read_bytes, pack_read_short_at, pack_read_word_at, record_integer");
  if (p_id == 87) test_info_set(p_info, "pack_load_png_from_folder", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 966, 982, "Integer", "T:p_folder T:p_kind T:p_name",
                              "Integer pack_load_png_from_folder(Text p_folder, Text p_kind, Text p_name)", 0, "", "pack_read_bytes, pack_replace");
  if (p_id == 88) test_info_set(p_info, "png_number", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 986, 992, "Integer", "I:p_at",
                              "Integer png_number(Integer p_at)", 0, "", "");
  if (p_id == 89) test_info_set(p_info, "png_is_chunk", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 994, 1004, "Integer", "I:p_at I:p_a I:p_b I:p_c I:p_d",
                              "Integer png_is_chunk(Integer p_at, Integer p_a, Integer p_b, Integer p_c, Integer p_d)", 0, "", "");
  if (p_id == 90) test_info_set(p_info, "png_sample", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1006, 1030, "Integer", "I:p_row_start I:p_x I:p_bit_depth I:p_channels I:p_channel",
                              "Integer png_sample(Integer p_row_start, Integer p_x, Integer p_bit_depth, Integer p_channels, Integer p_channel)", 0, "", "floor_divide");
  if (p_id == 91) test_info_set(p_info, "png_decode", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1032, 1247, "Integer", "I:p_map_x I:p_map_y",
                              "Integer png_decode(Integer p_map_x, Integer p_map_y)", 0, "", "floor_divide, max_integer, pack_inflate, pack_paeth, png_is_chunk, png_number, png_sample");
  if (p_id == 92) test_info_set(p_info, "pack_tint", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1251, 1263, "void", "I:p_red I:p_green I:p_blue",
                              "void pack_tint(Integer p_red, Integer p_green, Integer p_blue)", 0, "", "floor_divide");
  if (p_id == 93) test_info_set(p_info, "pack_keep_overlay", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1265, 1278, "void", "",
                              "void pack_keep_overlay()", 0, "", "");
  if (p_id == 94) test_info_set(p_info, "pack_draw_overlay", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1280, 1295, "void", "",
                              "void pack_draw_overlay()", 0, "", "");
  if (p_id == 95) test_info_set(p_info, "pack_distance", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1297, 1307, "Real", "I:p_colour I:p_cluster",
                              "Real pack_distance(Integer p_colour, Integer p_cluster)", 0, "", "");
  if (p_id == 96) test_info_set(p_info, "pack_count_colours", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1309, 1348, "Integer", "",
                              "Integer pack_count_colours()", 0, "", "");
  if (p_id == 97) test_info_set(p_info, "pack_choose_palette", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1350, 1440, "Integer", "I:p_colours",
                              "Integer pack_choose_palette(Integer p_colours)", 0, "", "pack_distance");
  if (p_id == 98) test_info_set(p_info, "pack_to_texture", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1442, 1478, "void", "I:p_tex I:p_sprite",
                              "void pack_to_texture(Integer p_tex, Integer p_sprite)", 0, "", "floor_divide, pack_choose_palette, pack_count_colours, texture_set, texture_set_palette, to_byte");
  if (p_id == 99) test_info_set(p_info, "pack_load_image", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1482, 1493, "Integer", "T:p_path I:p_zip &A:p_index T:p_kind T:p_name I:p_map_x I:p_map_y",
                              "Integer pack_load_image(Text p_path, Integer p_zip, Attributes &p_index, Text p_kind, Text p_name, Integer p_map_x, Integer p_map_y)", 0, "", "pack_key, pack_load_png_from_folder, pack_load_png_from_zip, png_decode");
  if (p_id == 100) test_info_set(p_info, "pack_apply", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1495, 1639, "Integer", "T:p_path &T:p_report",
                              "Integer pack_apply(Text p_path, Text &p_report)", 0, "", "pack_draw_overlay, pack_init_tables, pack_is_zip, pack_keep_overlay, pack_key, pack_load_image, pack_map_entry, pack_map_part, pack_tint, pack_to_texture, pack_zip_index, record_clear, record_field_at, record_integer, record_set_integer, texture_is_sprite");
  if (p_id == 101) test_info_set(p_info, "pack_map_skin_part", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1643, 1669, "Integer", "I:p_entry &I:p_tex &I:p_x &I:p_y &I:p_w &I:p_h &I:p_over_x &I:p_over_y",
                              "Integer pack_map_skin_part(Integer p_entry, Integer &p_tex, Integer &p_x, Integer &p_y, Integer &p_w, Integer &p_h, Integer &p_over_x, Integer &p_over_y)", 0, "", "");
  if (p_id == 102) test_info_set(p_info, "pack_load_png_file", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1671, 1685, "Integer", "T:p_path",
                              "Integer pack_load_png_file(Text p_path)", 0, "", "pack_read_bytes, png_is_chunk");
  if (p_id == 103) test_info_set(p_info, "pack_skin_region", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1687, 1703, "Integer", "I:p_x I:p_y I:p_w I:p_h",
                              "Integer pack_skin_region(Integer p_x, Integer p_y, Integer p_w, Integer p_h)", 0, "", "png_decode");
  if (p_id == 104) test_info_set(p_info, "pack_skin_is_slim", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1705, 1717, "Integer", "I:p_width I:p_height",
                              "Integer pack_skin_is_slim(Integer p_width, Integer p_height)", 0, "", "png_decode");
  if (p_id == 105) test_info_set(p_info, "pack_apply_skin", "macro", "blocks", "resource_pack", "src/blocks/resource_pack.4dm", 1719, 1775, "Integer", "T:p_path &T:p_report &I:p_slim",
                              "Integer pack_apply_skin(Text p_path, Text &p_report, Integer &p_slim)", 0, "", "pack_draw_overlay, pack_init_tables, pack_keep_overlay, pack_load_png_file, pack_map_skin_part, pack_skin_is_slim, pack_skin_region, pack_to_texture, png_number");
  if (p_id == 106) test_info_set(p_info, "texture_palette_index", "macro", "blocks", "textures", "src/blocks/textures.4dm", 11, 18, "Integer", "I:p_tex I:p_index",
                              "Integer texture_palette_index(Integer p_tex, Integer p_index)", 0, "", "");
  if (p_id == 107) test_info_set(p_info, "texture_set_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 20, 30, "void", "I:p_tex I:p_index I:p_red I:p_green I:p_blue",
                              "void texture_set_palette(Integer p_tex, Integer p_index, Integer p_red, Integer p_green, Integer p_blue)", 0, "", "texture_palette_index");
  if (p_id == 108) test_info_set(p_info, "texture_set", "macro", "blocks", "textures", "src/blocks/textures.4dm", 32, 41, "void", "I:p_tex I:p_u I:p_v I:p_index",
                              "void texture_set(Integer p_tex, Integer p_u, Integer p_v, Integer p_index)", 0, "", "");
  if (p_id == 109) test_info_set(p_info, "texture_get", "macro", "blocks", "textures", "src/blocks/textures.4dm", 43, 51, "Integer", "I:p_tex I:p_u I:p_v",
                              "Integer texture_get(Integer p_tex, Integer p_u, Integer p_v)", 0, "", "");
  if (p_id == 110) test_info_set(p_info, "texture_fill", "macro", "blocks", "textures", "src/blocks/textures.4dm", 53, 59, "void", "I:p_tex I:p_index",
                              "void texture_fill(Integer p_tex, Integer p_index)", 0, "", "texture_fill_rect");
  if (p_id == 111) test_info_set(p_info, "texture_fill_rect", "macro", "blocks", "textures", "src/blocks/textures.4dm", 61, 74, "void", "I:p_tex I:p_u0 I:p_v0 I:p_u1 I:p_v1 I:p_index",
                              "void texture_fill_rect(Integer p_tex, Integer p_u0, Integer p_v0, Integer p_u1, Integer p_v1, Integer p_index)", 0, "", "texture_set");
  if (p_id == 112) test_info_set(p_info, "texture_copy", "macro", "blocks", "textures", "src/blocks/textures.4dm", 76, 92, "void", "I:p_from_tex I:p_to_tex",
                              "void texture_copy(Integer p_from_tex, Integer p_to_tex)", 0, "", "texture_palette_index");
  if (p_id == 113) test_info_set(p_info, "texture_row", "macro", "blocks", "textures", "src/blocks/textures.4dm", 94, 108, "void", "I:p_tex I:p_v T:p_pixels",
                              "void texture_row(Integer p_tex, Integer p_v, Text p_pixels)", 0, "", "texture_set");
  if (p_id == 114) test_info_set(p_info, "texture_random", "macro", "blocks", "textures", "src/blocks/textures.4dm", 110, 116, "Real", "I:p_tex I:p_u I:p_v I:p_salt",
                              "Real texture_random(Integer p_tex, Integer p_u, Integer p_v, Integer p_salt)", 0, "", "hash_real");
  if (p_id == 115) test_info_set(p_info, "texture_noise", "macro", "blocks", "textures", "src/blocks/textures.4dm", 118, 146, "Real", "I:p_tex I:p_u I:p_v I:p_cell I:p_salt",
                              "Real texture_noise(Integer p_tex, Integer p_u, Integer p_v, Integer p_cell, Integer p_salt)", 0, "", "floor_divide, hash_real, lerp_real, positive_mod, smooth_curve");
  if (p_id == 116) test_info_set(p_info, "texture_finish", "macro", "blocks", "textures", "src/blocks/textures.4dm", 150, 297, "void", "I:p_tex",
                              "void texture_finish(Integer p_tex)", 0, "", "texture_get, texture_palette_index");
  if (p_id == 117) test_info_set(p_info, "texture_speckle", "macro", "blocks", "textures", "src/blocks/textures.4dm", 301, 314, "void", "I:p_tex I:p_index R:p_chance I:p_salt",
                              "void texture_speckle(Integer p_tex, Integer p_index, Real p_chance, Integer p_salt)", 0, "", "texture_random, texture_set");
  if (p_id == 118) test_info_set(p_info, "texture_blotch", "macro", "blocks", "textures", "src/blocks/textures.4dm", 316, 331, "void", "I:p_tex I:p_index I:p_cell R:p_below R:p_above I:p_salt",
                              "void texture_blotch(Integer p_tex, Integer p_index, Integer p_cell, Real p_below, Real p_above, Integer p_salt)", 0, "", "texture_noise, texture_set");
  if (p_id == 119) test_info_set(p_info, "make_texture_stone", "macro", "blocks", "textures", "src/blocks/textures.4dm", 333, 344, "void", "I:p_tex",
                              "void make_texture_stone(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette");
  if (p_id == 120) test_info_set(p_info, "make_texture_bedrock", "macro", "blocks", "textures", "src/blocks/textures.4dm", 346, 357, "void", "I:p_tex",
                              "void make_texture_bedrock(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 81) {   // inflate_stored
    Get_time(l_start);
    l_ret_i = inflate_stored();
    Get_time(l_end);
  } else if (p_id == 82) {   // inflate_fixed
    Get_time(l_start);
    l_ret_i = inflate_fixed();
    Get_time(l_end);
  } else if (p_id == 83) {   // inflate_dynamic
    Get_time(l_start);
    l_ret_i = inflate_dynamic();
    Get_time(l_end);
  } else if (p_id == 84) {   // pack_inflate
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = pack_inflate(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 85) {   // pack_zip_index
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = pack_zip_index(l_t1, g_test_record, g_test_record_2, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 86) {   // pack_load_png_from_zip
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = pack_load_png_from_zip(l_t1, g_test_record, l_t2);
    Get_time(l_end);
  } else if (p_id == 87) {   // pack_load_png_from_folder
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = pack_load_png_from_folder(l_t1, l_t2, l_t3);
    Get_time(l_end);
  } else if (p_id == 88) {   // png_number
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = png_number(l_i1);
    Get_time(l_end);
  } else if (p_id == 89) {   // png_is_chunk
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = png_is_chunk(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 90) {   // png_sample
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = png_sample(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 91) {   // png_decode
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = png_decode(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 92) {   // pack_tint
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    pack_tint(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 93) {   // pack_keep_overlay
    Get_time(l_start);
    pack_keep_overlay();
    Get_time(l_end);
  } else if (p_id == 94) {   // pack_draw_overlay
    Get_time(l_start);
    pack_draw_overlay();
    Get_time(l_end);
  } else if (p_id == 95) {   // pack_distance
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_r = pack_distance(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 96) {   // pack_count_colours
    Get_time(l_start);
    l_ret_i = pack_count_colours();
    Get_time(l_end);
  } else if (p_id == 97) {   // pack_choose_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = pack_choose_palette(l_i1);
    Get_time(l_end);
  } else if (p_id == 98) {   // pack_to_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    pack_to_texture(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 99) {   // pack_load_image
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = pack_load_image(l_t1, l_i1, g_test_record, l_t2, l_t3, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 100) {   // pack_apply
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = pack_apply(l_t1, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 101) {   // pack_map_skin_part
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
  } else if (p_id == 102) {   // pack_load_png_file
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = pack_load_png_file(l_t1);
    Get_time(l_end);
  } else if (p_id == 103) {   // pack_skin_region
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = pack_skin_region(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 104) {   // pack_skin_is_slim
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = pack_skin_is_slim(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 105) {   // pack_apply_skin
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = pack_apply_skin(l_t1, l_t2, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 106) {   // texture_palette_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = texture_palette_index(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 107) {   // texture_set_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    texture_set_palette(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 108) {   // texture_set
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    texture_set(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 109) {   // texture_get
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = texture_get(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 110) {   // texture_fill
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    texture_fill(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 111) {   // texture_fill_rect
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    Get_time(l_start);
    texture_fill_rect(l_i1, l_i2, l_i3, l_i4, l_i5, l_i6);
    Get_time(l_end);
  } else if (p_id == 112) {   // texture_copy
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    texture_copy(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 113) {   // texture_row
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    texture_row(l_i1, l_i2, l_t1);
    Get_time(l_end);
  } else if (p_id == 114) {   // texture_random
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_r = texture_random(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 115) {   // texture_noise
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_r = texture_noise(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 116) {   // texture_finish
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    texture_finish(l_i1);
    Get_time(l_end);
  } else if (p_id == 117) {   // texture_speckle
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    texture_speckle(l_i1, l_i2, l_r1, l_i3);
    Get_time(l_end);
  } else if (p_id == 118) {   // texture_blotch
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    texture_blotch(l_i1, l_i2, l_i3, l_r1, l_r2, l_i4);
    Get_time(l_end);
  } else if (p_id == 119) {   // make_texture_stone
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_stone(l_i1);
    Get_time(l_end);
  } else if (p_id == 120) {   // make_texture_bedrock
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_bedrock(l_i1);
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
  if (p_id == 121) test_info_set(p_info, "make_texture_cobblestone", "macro", "blocks", "textures", "src/blocks/textures.4dm", 359, 412, "void", "I:p_tex",
                              "void make_texture_cobblestone(Integer p_tex)", 0, "", "positive_mod, texture_random, texture_set, texture_set_palette");
  if (p_id == 122) test_info_set(p_info, "make_texture_dirt", "macro", "blocks", "textures", "src/blocks/textures.4dm", 414, 426, "void", "I:p_tex",
                              "void make_texture_dirt(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 123) test_info_set(p_info, "make_texture_grass_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 428, 440, "void", "I:p_tex",
                              "void make_texture_grass_top(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 124) test_info_set(p_info, "make_texture_grass_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 442, 459, "void", "I:p_tex",
                              "void make_texture_grass_side(Integer p_tex)", 0, "", "texture_copy, texture_fill_rect, texture_random, texture_set, texture_set_palette");
  if (p_id == 125) test_info_set(p_info, "make_texture_log_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 461, 485, "void", "I:p_tex",
                              "void make_texture_log_side(Integer p_tex)", 0, "", "texture_fill, texture_random, texture_set, texture_set_palette");
  if (p_id == 126) test_info_set(p_info, "make_texture_log_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 487, 514, "void", "I:p_tex",
                              "void make_texture_log_top(Integer p_tex)", 0, "", "positive_mod, texture_set, texture_set_palette");
  if (p_id == 127) test_info_set(p_info, "make_texture_leaves", "macro", "blocks", "textures", "src/blocks/textures.4dm", 516, 529, "void", "I:p_tex",
                              "void make_texture_leaves(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 128) test_info_set(p_info, "make_texture_water", "macro", "blocks", "textures", "src/blocks/textures.4dm", 531, 550, "void", "I:p_tex",
                              "void make_texture_water(Integer p_tex)", 0, "", "positive_mod, texture_fill, texture_set, texture_set_palette");
  if (p_id == 129) test_info_set(p_info, "make_texture_planks", "macro", "blocks", "textures", "src/blocks/textures.4dm", 552, 577, "void", "I:p_tex",
                              "void make_texture_planks(Integer p_tex)", 0, "", "positive_mod, texture_fill, texture_fill_rect, texture_random, texture_set, texture_set_palette");
  if (p_id == 130) test_info_set(p_info, "make_texture_table_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 579, 594, "void", "I:p_tex",
                              "void make_texture_table_top(Integer p_tex)", 0, "", "texture_copy, texture_fill_rect, texture_set_palette");
  if (p_id == 131) test_info_set(p_info, "make_texture_table_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 596, 614, "void", "I:p_tex",
                              "void make_texture_table_side(Integer p_tex)", 0, "", "texture_copy, texture_fill_rect, texture_set_palette");
  if (p_id == 132) test_info_set(p_info, "make_texture_furnace_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 616, 638, "void", "I:p_tex",
                              "void make_texture_furnace_side(Integer p_tex)", 0, "", "positive_mod, texture_fill, texture_fill_rect, texture_set_palette, texture_speckle");
  if (p_id == 133) test_info_set(p_info, "make_texture_furnace_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 640, 655, "void", "I:p_tex",
                              "void make_texture_furnace_top(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette, texture_speckle");
  if (p_id == 134) test_info_set(p_info, "make_texture_furnace_front", "macro", "blocks", "textures", "src/blocks/textures.4dm", 657, 687, "void", "I:p_tex I:p_lit",
                              "void make_texture_furnace_front(Integer p_tex, Integer p_lit)", 0, "", "texture_copy, texture_fill_rect, texture_random, texture_set, texture_set_palette");
  if (p_id == 135) test_info_set(p_info, "make_texture_sand", "macro", "blocks", "textures", "src/blocks/textures.4dm", 689, 700, "void", "I:p_tex",
                              "void make_texture_sand(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 136) test_info_set(p_info, "make_texture_cow_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 702, 715, "void", "I:p_tex",
                              "void make_texture_cow_palette(Integer p_tex)", 0, "", "texture_set_palette");
  if (p_id == 137) test_info_set(p_info, "make_texture_cow_hide", "macro", "blocks", "textures", "src/blocks/textures.4dm", 717, 726, "void", "I:p_tex",
                              "void make_texture_cow_hide(Integer p_tex)", 0, "", "make_texture_cow_palette, texture_blotch, texture_fill");
  if (p_id == 138) test_info_set(p_info, "make_texture_cow_face", "macro", "blocks", "textures", "src/blocks/textures.4dm", 728, 751, "void", "I:p_tex",
                              "void make_texture_cow_face(Integer p_tex)", 0, "", "make_texture_cow_palette, texture_row");
  if (p_id == 139) test_info_set(p_info, "make_texture_cow", "macro", "blocks", "textures", "src/blocks/textures.4dm", 753, 782, "void", "I:p_tex I:p_part",
                              "void make_texture_cow(Integer p_tex, Integer p_part)", 0, "", "make_texture_cow_palette, texture_blotch, texture_fill, texture_fill_rect");
  if (p_id == 140) test_info_set(p_info, "make_texture_sandstone_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 784, 797, "void", "I:p_tex",
                              "void make_texture_sandstone_side(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 141) test_info_set(p_info, "make_texture_sandstone_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 799, 808, "void", "I:p_tex",
                              "void make_texture_sandstone_top(Integer p_tex)", 0, "", "texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 142) test_info_set(p_info, "make_texture_cactus_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 810, 823, "void", "I:p_tex",
                              "void make_texture_cactus_side(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette, texture_speckle");
  if (p_id == 143) test_info_set(p_info, "make_texture_cactus_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 825, 836, "void", "I:p_tex",
                              "void make_texture_cactus_top(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 144) test_info_set(p_info, "make_texture_coal_ore", "macro", "blocks", "textures", "src/blocks/textures.4dm", 838, 852, "void", "I:p_tex",
                              "void make_texture_coal_ore(Integer p_tex)", 0, "", "make_texture_stone, texture_fill_rect, texture_set_palette");
  if (p_id == 145) test_info_set(p_info, "make_texture_gravel", "macro", "blocks", "textures", "src/blocks/textures.4dm", 854, 867, "void", "I:p_tex",
                              "void make_texture_gravel(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 146) test_info_set(p_info, "make_texture_plant_grass", "macro", "blocks", "textures", "src/blocks/textures.4dm", 869, 892, "void", "I:p_tex",
                              "void make_texture_plant_grass(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 147) test_info_set(p_info, "make_texture_plant_flower", "macro", "blocks", "textures", "src/blocks/textures.4dm", 894, 927, "void", "I:p_tex I:p_red I:p_green I:p_blue",
                              "void make_texture_plant_flower(Integer p_tex, Integer p_red, Integer p_green, Integer p_blue)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 148) test_info_set(p_info, "make_texture_plant_dead_bush", "macro", "blocks", "textures", "src/blocks/textures.4dm", 929, 951, "void", "I:p_tex",
                              "void make_texture_plant_dead_bush(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 149) test_info_set(p_info, "make_texture_item_stick", "macro", "blocks", "textures", "src/blocks/textures.4dm", 953, 977, "void", "I:p_tex",
                              "void make_texture_item_stick(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 150) test_info_set(p_info, "make_texture_pig", "macro", "blocks", "textures", "src/blocks/textures.4dm", 979, 1025, "void", "I:p_tex I:p_part",
                              "void make_texture_pig(Integer p_tex, Integer p_part)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 151) test_info_set(p_info, "make_texture_item_porkchop", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1027, 1059, "void", "I:p_tex I:p_cooked",
                              "void make_texture_item_porkchop(Integer p_tex, Integer p_cooked)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 152) test_info_set(p_info, "make_texture_item_beef", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1061, 1092, "void", "I:p_tex I:p_cooked",
                              "void make_texture_item_beef(Integer p_tex, Integer p_cooked)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 153) test_info_set(p_info, "make_texture_iron_ore", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1094, 1110, "void", "I:p_tex",
                              "void make_texture_iron_ore(Integer p_tex)", 0, "", "make_texture_stone, texture_fill_rect, texture_set_palette");
  if (p_id == 154) test_info_set(p_info, "make_texture_item_ingot", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1112, 1137, "void", "I:p_tex",
                              "void make_texture_item_ingot(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 155) test_info_set(p_info, "make_texture_bed_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1139, 1158, "void", "I:p_tex",
                              "void make_texture_bed_top(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 156) test_info_set(p_info, "make_texture_bed_side", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1160, 1178, "void", "I:p_tex I:p_head",
                              "void make_texture_bed_side(Integer p_tex, Integer p_head)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 157) test_info_set(p_info, "make_texture_bed_end", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1180, 1197, "void", "I:p_tex I:p_head",
                              "void make_texture_bed_end(Integer p_tex, Integer p_head)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 158) test_info_set(p_info, "make_texture_bed_leg", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1199, 1208, "void", "I:p_tex",
                              "void make_texture_bed_leg(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette");
  if (p_id == 159) test_info_set(p_info, "make_texture_chest_part", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1210, 1260, "void", "I:p_tex I:p_part I:p_type",
                              "void make_texture_chest_part(Integer p_tex, Integer p_part, Integer p_type)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 160) test_info_set(p_info, "make_texture_zombie", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1262, 1316, "void", "I:p_tex I:p_part",
                              "void make_texture_zombie(Integer p_tex, Integer p_part)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 121) {   // make_texture_cobblestone
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cobblestone(l_i1);
    Get_time(l_end);
  } else if (p_id == 122) {   // make_texture_dirt
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_dirt(l_i1);
    Get_time(l_end);
  } else if (p_id == 123) {   // make_texture_grass_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_grass_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 124) {   // make_texture_grass_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_grass_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 125) {   // make_texture_log_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_log_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 126) {   // make_texture_log_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_log_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 127) {   // make_texture_leaves
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_leaves(l_i1);
    Get_time(l_end);
  } else if (p_id == 128) {   // make_texture_water
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_water(l_i1);
    Get_time(l_end);
  } else if (p_id == 129) {   // make_texture_planks
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_planks(l_i1);
    Get_time(l_end);
  } else if (p_id == 130) {   // make_texture_table_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_table_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 131) {   // make_texture_table_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_table_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 132) {   // make_texture_furnace_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_furnace_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 133) {   // make_texture_furnace_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_furnace_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 134) {   // make_texture_furnace_front
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_furnace_front(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 135) {   // make_texture_sand
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_sand(l_i1);
    Get_time(l_end);
  } else if (p_id == 136) {   // make_texture_cow_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cow_palette(l_i1);
    Get_time(l_end);
  } else if (p_id == 137) {   // make_texture_cow_hide
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cow_hide(l_i1);
    Get_time(l_end);
  } else if (p_id == 138) {   // make_texture_cow_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cow_face(l_i1);
    Get_time(l_end);
  } else if (p_id == 139) {   // make_texture_cow
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_cow(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 140) {   // make_texture_sandstone_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_sandstone_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 141) {   // make_texture_sandstone_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_sandstone_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 142) {   // make_texture_cactus_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cactus_side(l_i1);
    Get_time(l_end);
  } else if (p_id == 143) {   // make_texture_cactus_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_cactus_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 144) {   // make_texture_coal_ore
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_coal_ore(l_i1);
    Get_time(l_end);
  } else if (p_id == 145) {   // make_texture_gravel
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_gravel(l_i1);
    Get_time(l_end);
  } else if (p_id == 146) {   // make_texture_plant_grass
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_plant_grass(l_i1);
    Get_time(l_end);
  } else if (p_id == 147) {   // make_texture_plant_flower
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    make_texture_plant_flower(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 148) {   // make_texture_plant_dead_bush
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_plant_dead_bush(l_i1);
    Get_time(l_end);
  } else if (p_id == 149) {   // make_texture_item_stick
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_stick(l_i1);
    Get_time(l_end);
  } else if (p_id == 150) {   // make_texture_pig
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_pig(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 151) {   // make_texture_item_porkchop
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_porkchop(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 152) {   // make_texture_item_beef
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_beef(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 153) {   // make_texture_iron_ore
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_iron_ore(l_i1);
    Get_time(l_end);
  } else if (p_id == 154) {   // make_texture_item_ingot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_ingot(l_i1);
    Get_time(l_end);
  } else if (p_id == 155) {   // make_texture_bed_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_bed_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 156) {   // make_texture_bed_side
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_bed_side(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 157) {   // make_texture_bed_end
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_bed_end(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 158) {   // make_texture_bed_leg
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_bed_leg(l_i1);
    Get_time(l_end);
  } else if (p_id == 159) {   // make_texture_chest_part
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    make_texture_chest_part(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 160) {   // make_texture_zombie
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_zombie(l_i1, l_i2);
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
  if (p_id == 161) test_info_set(p_info, "make_texture_chest", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1318, 1341, "void", "I:p_tex I:p_side",
                              "void make_texture_chest(Integer p_tex, Integer p_side)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 162) test_info_set(p_info, "make_texture_torch", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1343, 1369, "void", "I:p_tex",
                              "void make_texture_torch(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 163) test_info_set(p_info, "make_texture_glass", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1371, 1395, "void", "I:p_tex",
                              "void make_texture_glass(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 164) test_info_set(p_info, "make_texture_item_rotten_flesh", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1397, 1422, "void", "I:p_tex",
                              "void make_texture_item_rotten_flesh(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 165) test_info_set(p_info, "make_texture_item_coal", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1424, 1449, "void", "I:p_tex",
                              "void make_texture_item_coal(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 166) test_info_set(p_info, "make_tool_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1451, 1473, "void", "I:p_tex I:p_tier",
                              "void make_tool_palette(Integer p_tex, Integer p_tier)", 0, "", "texture_set_palette");
  if (p_id == 167) test_info_set(p_info, "make_texture_item_pickaxe", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1475, 1497, "void", "I:p_tex I:p_tier",
                              "void make_texture_item_pickaxe(Integer p_tex, Integer p_tier)", 0, "", "make_tool_palette, texture_row");
  if (p_id == 168) test_info_set(p_info, "make_texture_item_axe", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1499, 1521, "void", "I:p_tex I:p_tier",
                              "void make_texture_item_axe(Integer p_tex, Integer p_tier)", 0, "", "make_tool_palette, texture_row");
  if (p_id == 169) test_info_set(p_info, "make_texture_item_shovel", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1523, 1545, "void", "I:p_tex I:p_tier",
                              "void make_texture_item_shovel(Integer p_tex, Integer p_tier)", 0, "", "make_tool_palette, texture_row");
  if (p_id == 170) test_info_set(p_info, "make_texture_item_sword", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1547, 1569, "void", "I:p_tex I:p_tier",
                              "void make_texture_item_sword(Integer p_tex, Integer p_tier)", 0, "", "make_tool_palette, texture_row");
  if (p_id == 171) test_info_set(p_info, "make_texture_destroy", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1571, 1626, "void", "I:p_tex I:p_stage",
                              "void make_texture_destroy(Integer p_tex, Integer p_stage)", 0, "", "floor_divide, floor_integer, hash_real, texture_fill, texture_get, texture_set, texture_set_palette");
  if (p_id == 172) test_info_set(p_info, "make_texture_heart", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1628, 1679, "void", "I:p_tex I:p_fill",
                              "void make_texture_heart(Integer p_tex, Integer p_fill)", 0, "", "texture_fill_rect, texture_row, texture_set, texture_set_palette");
  if (p_id == 173) test_info_set(p_info, "make_texture_door", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1681, 1708, "void", "I:p_tex I:p_top",
                              "void make_texture_door(Integer p_tex, Integer p_top)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 174) test_info_set(p_info, "make_texture_item_door", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1710, 1734, "void", "I:p_tex",
                              "void make_texture_item_door(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 175) test_info_set(p_info, "make_texture_bed_foot_top", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1736, 1751, "void", "I:p_tex",
                              "void make_texture_bed_foot_top(Integer p_tex)", 0, "", "texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 176) test_info_set(p_info, "make_texture_person", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1753, 1808, "void", "I:p_tex I:p_part",
                              "void make_texture_person(Integer p_tex, Integer p_part)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 177) test_info_set(p_info, "make_texture_door_edge", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1810, 1833, "void", "I:p_tex I:p_door_tex",
                              "void make_texture_door_edge(Integer p_tex, Integer p_door_tex)", 0, "", "texture_get, texture_palette_index, texture_set");
  if (p_id == 178) test_info_set(p_info, "make_armour_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1835, 1844, "void", "I:p_tex",
                              "void make_armour_palette(Integer p_tex)", 0, "", "texture_set_palette");
  if (p_id == 179) test_info_set(p_info, "make_texture_item_armour", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1846, 1926, "void", "I:p_tex I:p_place",
                              "void make_texture_item_armour(Integer p_tex, Integer p_place)", 0, "", "make_armour_palette, texture_row");
  if (p_id == 180) test_info_set(p_info, "make_texture_spawn_egg", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1928, 1954, "void", "I:p_tex I:p_red I:p_green I:p_blue I:p_spot_red I:p_spot_green I:p_spot_blue",
                              "void make_texture_spawn_egg(Integer p_tex, Integer p_red, Integer p_green, Integer p_blue, Integer p_spot_red, Integer p_spot_green, Integer p_spot_blue)", 0, "", "floor_integer, min_integer, texture_row, texture_set_palette");
  if (p_id == 181) test_info_set(p_info, "make_texture_armour_icon", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1956, 1997, "void", "I:p_tex I:p_fill",
                              "void make_texture_armour_icon(Integer p_tex, Integer p_fill)", 0, "", "texture_fill_rect, texture_row, texture_set, texture_set_palette");
  if (p_id == 182) test_info_set(p_info, "make_texture_armour_worn", "macro", "blocks", "textures", "src/blocks/textures.4dm", 1999, 2014, "void", "I:p_tex I:p_helmet_front",
                              "void make_texture_armour_worn(Integer p_tex, Integer p_helmet_front)", 0, "", "make_armour_palette, texture_blotch, texture_fill, texture_fill_rect, texture_speckle");
  if (p_id == 183) test_info_set(p_info, "make_texture_obsidian", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2016, 2027, "void", "I:p_tex",
                              "void make_texture_obsidian(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 184) test_info_set(p_info, "make_texture_netherrack", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2029, 2041, "void", "I:p_tex",
                              "void make_texture_netherrack(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette");
  if (p_id == 185) test_info_set(p_info, "make_texture_soul_sand", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2043, 2059, "void", "I:p_tex",
                              "void make_texture_soul_sand(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 186) test_info_set(p_info, "make_texture_glowstone", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2061, 2072, "void", "I:p_tex",
                              "void make_texture_glowstone(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette, texture_speckle");
  if (p_id == 187) test_info_set(p_info, "make_texture_quartz_ore", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2074, 2089, "void", "I:p_tex",
                              "void make_texture_quartz_ore(Integer p_tex)", 0, "", "make_texture_netherrack, texture_fill_rect, texture_set_palette");
  if (p_id == 188) test_info_set(p_info, "make_texture_lava", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2091, 2102, "void", "I:p_tex",
                              "void make_texture_lava(Integer p_tex)", 0, "", "texture_blotch, texture_fill, texture_set_palette");
  if (p_id == 189) test_info_set(p_info, "make_texture_portal", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2104, 2141, "void", "I:p_tex I:p_frame",
                              "void make_texture_portal(Integer p_tex, Integer p_frame)", 0, "", "angle_of, texture_set, texture_set_palette");
  if (p_id == 190) test_info_set(p_info, "make_texture_fire", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2143, 2188, "void", "I:p_tex I:p_frame",
                              "void make_texture_fire(Integer p_tex, Integer p_frame)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 191) test_info_set(p_info, "make_texture_diamond_ore", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2190, 2211, "void", "I:p_tex",
                              "void make_texture_diamond_ore(Integer p_tex)", 0, "", "make_texture_stone, texture_fill_rect, texture_set_palette");
  if (p_id == 192) test_info_set(p_info, "make_texture_jukebox", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2213, 2236, "void", "I:p_tex I:p_top",
                              "void make_texture_jukebox(Integer p_tex, Integer p_top)", 0, "", "texture_blotch, texture_fill, texture_fill_rect, texture_set_palette");
  if (p_id == 193) test_info_set(p_info, "make_texture_item_diamond", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2238, 2263, "void", "I:p_tex",
                              "void make_texture_item_diamond(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 194) test_info_set(p_info, "make_diamond_armour_palette", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2265, 2275, "void", "I:p_tex",
                              "void make_diamond_armour_palette(Integer p_tex)", 0, "", "texture_set_palette");
  if (p_id == 195) test_info_set(p_info, "make_texture_item_flint", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2277, 2301, "void", "I:p_tex",
                              "void make_texture_item_flint(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 196) test_info_set(p_info, "make_texture_item_flint_and_steel", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2303, 2328, "void", "I:p_tex",
                              "void make_texture_item_flint_and_steel(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 197) test_info_set(p_info, "make_texture_item_nether_quartz", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2330, 2354, "void", "I:p_tex",
                              "void make_texture_item_nether_quartz(Integer p_tex)", 0, "", "texture_row, texture_set_palette");
  if (p_id == 198) test_info_set(p_info, "texture_is_sprite", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2356, 2371, "Integer", "I:p_tex",
                              "Integer texture_is_sprite(Integer p_tex)", 0, "", "");
  if (p_id == 199) test_info_set(p_info, "textures_init", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2373, 2380, "void", "",
                              "void textures_init()", 0, "", "textures_finish_all, textures_generate");
  if (p_id == 200) test_info_set(p_info, "textures_finish_all", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2382, 2396, "void", "",
                              "void textures_finish_all()", 0, "", "make_texture_door_edge, texture_finish");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 161) {   // make_texture_chest
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_chest(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 162) {   // make_texture_torch
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_torch(l_i1);
    Get_time(l_end);
  } else if (p_id == 163) {   // make_texture_glass
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_glass(l_i1);
    Get_time(l_end);
  } else if (p_id == 164) {   // make_texture_item_rotten_flesh
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_rotten_flesh(l_i1);
    Get_time(l_end);
  } else if (p_id == 165) {   // make_texture_item_coal
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_coal(l_i1);
    Get_time(l_end);
  } else if (p_id == 166) {   // make_tool_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_tool_palette(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 167) {   // make_texture_item_pickaxe
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_pickaxe(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 168) {   // make_texture_item_axe
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_axe(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 169) {   // make_texture_item_shovel
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_shovel(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 170) {   // make_texture_item_sword
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_sword(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 171) {   // make_texture_destroy
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_destroy(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 172) {   // make_texture_heart
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_heart(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 173) {   // make_texture_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_door(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 174) {   // make_texture_item_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_door(l_i1);
    Get_time(l_end);
  } else if (p_id == 175) {   // make_texture_bed_foot_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_bed_foot_top(l_i1);
    Get_time(l_end);
  } else if (p_id == 176) {   // make_texture_person
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_person(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 177) {   // make_texture_door_edge
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_door_edge(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 178) {   // make_armour_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_armour_palette(l_i1);
    Get_time(l_end);
  } else if (p_id == 179) {   // make_texture_item_armour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_item_armour(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 180) {   // make_texture_spawn_egg
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
  } else if (p_id == 181) {   // make_texture_armour_icon
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_armour_icon(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 182) {   // make_texture_armour_worn
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_armour_worn(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 183) {   // make_texture_obsidian
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_obsidian(l_i1);
    Get_time(l_end);
  } else if (p_id == 184) {   // make_texture_netherrack
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_netherrack(l_i1);
    Get_time(l_end);
  } else if (p_id == 185) {   // make_texture_soul_sand
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_soul_sand(l_i1);
    Get_time(l_end);
  } else if (p_id == 186) {   // make_texture_glowstone
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_glowstone(l_i1);
    Get_time(l_end);
  } else if (p_id == 187) {   // make_texture_quartz_ore
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_quartz_ore(l_i1);
    Get_time(l_end);
  } else if (p_id == 188) {   // make_texture_lava
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_lava(l_i1);
    Get_time(l_end);
  } else if (p_id == 189) {   // make_texture_portal
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_portal(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 190) {   // make_texture_fire
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_fire(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 191) {   // make_texture_diamond_ore
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_diamond_ore(l_i1);
    Get_time(l_end);
  } else if (p_id == 192) {   // make_texture_jukebox
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    make_texture_jukebox(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 193) {   // make_texture_item_diamond
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_diamond(l_i1);
    Get_time(l_end);
  } else if (p_id == 194) {   // make_diamond_armour_palette
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_diamond_armour_palette(l_i1);
    Get_time(l_end);
  } else if (p_id == 195) {   // make_texture_item_flint
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_flint(l_i1);
    Get_time(l_end);
  } else if (p_id == 196) {   // make_texture_item_flint_and_steel
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_flint_and_steel(l_i1);
    Get_time(l_end);
  } else if (p_id == 197) {   // make_texture_item_nether_quartz
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    make_texture_item_nether_quartz(l_i1);
    Get_time(l_end);
  } else if (p_id == 198) {   // texture_is_sprite
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = texture_is_sprite(l_i1);
    Get_time(l_end);
  } else if (p_id == 199) {   // textures_init
    Get_time(l_start);
    textures_init();
    Get_time(l_end);
  } else if (p_id == 200) {   // textures_finish_all
    Get_time(l_start);
    textures_finish_all();
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
  if (p_id == 201) test_info_set(p_info, "textures_generate", "macro", "blocks", "textures", "src/blocks/textures.4dm", 2398, 2555, "void", "",
                              "void textures_generate()", 0, "", "floor_divide, make_diamond_armour_palette, make_texture_armour_icon, make_texture_armour_worn, make_texture_bed_end, make_texture_bed_foot_top, make_texture_bed_leg, make_texture_bed_side, make_texture_bed_top, make_texture_bedrock, make_texture_cactus_side, make_texture_cactus_top, make_texture_chest, make_texture_chest_part, make_texture_coal_ore, make_texture_cobblestone, make_texture_cow, make_texture_cow_face, make_texture_cow_hide, make_texture_destroy, make_texture_diamond_ore, make_texture_dirt, make_texture_door, make_texture_fire, make_texture_furnace_front, make_texture_furnace_side, make_texture_furnace_top, make_texture_glass, make_texture_glowstone, make_texture_grass_side, make_texture_grass_top, make_texture_gravel, make_texture_heart, make_texture_iron_ore, make_texture_item_armour, make_texture_item_axe, make_texture_item_beef, make_texture_item_coal, make_texture_item_diamond, make_texture_item_door, make_texture_item_flint, make_texture_item_flint_and_steel, make_texture_item_ingot, make_texture_item_nether_quartz, make_texture_item_pickaxe, make_texture_item_porkchop, make_texture_item_rotten_flesh, make_texture_item_shovel, make_texture_item_stick, make_texture_item_sword, make_texture_jukebox, make_texture_lava, make_texture_leaves, make_texture_log_side, make_texture_log_top, make_texture_netherrack, make_texture_obsidian, make_texture_person, make_texture_pig, make_texture_planks, make_texture_plant_dead_bush, make_texture_plant_flower, make_texture_plant_grass, make_texture_portal, make_texture_quartz_ore, make_texture_sand, make_texture_sandstone_side, make_texture_sandstone_top, make_texture_soul_sand, make_texture_spawn_egg, make_texture_stone, make_texture_table_side, make_texture_table_top, make_texture_torch, make_texture_water, make_texture_zombie, positive_mod");
  if (p_id == 202) test_info_set(p_info, "events_clear", "macro", "core", "events", "src/core/events.4dm", 9, 18, "void", "&A:p_events",
                              "void events_clear(Attributes &p_events)", 0, "", "record_clear, record_set_integer");
  if (p_id == 203) test_info_set(p_info, "emit_event", "macro", "core", "events", "src/core/events.4dm", 20, 52, "void", "&A:p_events I:p_type I:p_i1 I:p_i2 I:p_i3 I:p_i4 R:p_r1 R:p_r2 R:p_r3 T:p_text",
                              "void emit_event(Attributes &p_events, Integer p_type, Integer p_i1, Integer p_i2, Integer p_i3, Integer p_i4, Real p_r1, Real p_r2, Real p_r3, Text p_text)", 0, "", "record_integer, record_set_integer, record_set_integer_at, record_set_real_at, record_set_text_at");
  if (p_id == 204) test_info_set(p_info, "emit_simple_event", "macro", "core", "events", "src/core/events.4dm", 54, 60, "void", "&A:p_events I:p_type",
                              "void emit_simple_event(Attributes &p_events, Integer p_type)", 0, "", "emit_event");
  if (p_id == 205) test_info_set(p_info, "emit_cell_event", "macro", "core", "events", "src/core/events.4dm", 62, 68, "void", "&A:p_events I:p_type I:p_x I:p_y I:p_z I:p_block",
                              "void emit_cell_event(Attributes &p_events, Integer p_type, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "emit_event");
  if (p_id == 206) test_info_set(p_info, "emit_item_event", "macro", "core", "events", "src/core/events.4dm", 70, 76, "void", "&A:p_events I:p_type I:p_item I:p_count",
                              "void emit_item_event(Attributes &p_events, Integer p_type, Integer p_item, Integer p_count)", 0, "", "emit_event");
  if (p_id == 207) test_info_set(p_info, "emit_drop_event", "macro", "core", "events", "src/core/events.4dm", 78, 85, "void", "&A:p_events I:p_item I:p_count I:p_damage R:p_x R:p_y R:p_z",
                              "void emit_drop_event(Attributes &p_events, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z)", 0, "", "emit_event");
  if (p_id == 208) test_info_set(p_info, "emit_throw_event", "macro", "core", "events", "src/core/events.4dm", 87, 100, "void", "&A:p_events I:p_item I:p_count I:p_damage R:p_x R:p_y R:p_z R:p_yaw R:p_pitch",
                              "void emit_throw_event(Attributes &p_events, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_pitch)", 0, "", "clamp_real, emit_event");
  if (p_id == 209) test_info_set(p_info, "event_throw_direction", "macro", "core", "events", "src/core/events.4dm", 102, 112, "void", "&A:p_event &R:p_yaw &R:p_pitch",
                              "void event_throw_direction(Attributes &p_event, Real &p_yaw, Real &p_pitch)", 0, "", "event_integer");
  if (p_id == 210) test_info_set(p_info, "emit_toast", "macro", "core", "events", "src/core/events.4dm", 114, 120, "void", "&A:p_events T:p_text",
                              "void emit_toast(Attributes &p_events, Text p_text)", 0, "", "emit_event");
  if (p_id == 211) test_info_set(p_info, "events_pending", "macro", "core", "events", "src/core/events.4dm", 122, 128, "Integer", "&A:p_events",
                              "Integer events_pending(Attributes &p_events)", 0, "", "record_integer");
  if (p_id == 212) test_info_set(p_info, "next_event", "macro", "core", "events", "src/core/events.4dm", 130, 161, "Integer", "&A:p_events &A:p_event",
                              "Integer next_event(Attributes &p_events, Attributes &p_event)", 0, "", "record_clear, record_integer, record_integer_at, record_real_at, record_set_integer, record_set_real, record_set_text, record_text_at");
  if (p_id == 213) test_info_set(p_info, "event_type", "macro", "core", "events", "src/core/events.4dm", 163, 169, "Integer", "&A:p_event",
                              "Integer event_type(Attributes &p_event)", 0, "", "record_integer");
  if (p_id == 214) test_info_set(p_info, "event_integer", "macro", "core", "events", "src/core/events.4dm", 171, 180, "Integer", "&A:p_event I:p_which",
                              "Integer event_integer(Attributes &p_event, Integer p_which)", 0, "", "record_integer");
  if (p_id == 215) test_info_set(p_info, "event_real", "macro", "core", "events", "src/core/events.4dm", 182, 190, "Real", "&A:p_event I:p_which",
                              "Real event_real(Attributes &p_event, Integer p_which)", 0, "", "record_real");
  if (p_id == 216) test_info_set(p_info, "event_text", "macro", "core", "events", "src/core/events.4dm", 192, 198, "Text", "&A:p_event",
                              "Text event_text(Attributes &p_event)", 0, "", "record_text");
  if (p_id == 217) test_info_set(p_info, "event_is_remote", "macro", "core", "events", "src/core/events.4dm", 200, 208, "Integer", "&A:p_event",
                              "Integer event_is_remote(Attributes &p_event)", 0, "", "event_real");
  if (p_id == 218) test_info_set(p_info, "record_integer", "macro", "core", "records", "src/core/records.4dm", 9, 19, "Integer", "&A:p_record T:p_field",
                              "Integer record_integer(Attributes &p_record, Text p_field)", 0, "", "");
  if (p_id == 219) test_info_set(p_info, "record_real", "macro", "core", "records", "src/core/records.4dm", 21, 31, "Real", "&A:p_record T:p_field",
                              "Real record_real(Attributes &p_record, Text p_field)", 0, "", "");
  if (p_id == 220) test_info_set(p_info, "record_text", "macro", "core", "records", "src/core/records.4dm", 33, 43, "Text", "&A:p_record T:p_field",
                              "Text record_text(Attributes &p_record, Text p_field)", 0, "", "");
  if (p_id == 221) test_info_set(p_info, "record_set_integer", "macro", "core", "records", "src/core/records.4dm", 45, 53, "void", "&A:p_record T:p_field I:p_value",
                              "void record_set_integer(Attributes &p_record, Text p_field, Integer p_value)", 0, "", "");
  if (p_id == 222) test_info_set(p_info, "record_set_real", "macro", "core", "records", "src/core/records.4dm", 55, 61, "void", "&A:p_record T:p_field R:p_value",
                              "void record_set_real(Attributes &p_record, Text p_field, Real p_value)", 0, "", "");
  if (p_id == 223) test_info_set(p_info, "record_set_text", "macro", "core", "records", "src/core/records.4dm", 63, 69, "void", "&A:p_record T:p_field T:p_value",
                              "void record_set_text(Attributes &p_record, Text p_field, Text p_value)", 0, "", "");
  if (p_id == 224) test_info_set(p_info, "record_clear", "macro", "core", "records", "src/core/records.4dm", 71, 79, "void", "&A:p_record T:p_datatype",
                              "void record_clear(Attributes &p_record, Text p_datatype)", 0, "", "");
  if (p_id == 225) test_info_set(p_info, "record_datatype", "macro", "core", "records", "src/core/records.4dm", 81, 87, "Text", "&A:p_record",
                              "Text record_datatype(Attributes &p_record)", 0, "", "record_text");
  if (p_id == 226) test_info_set(p_info, "record_copy_field", "macro", "core", "records", "src/core/records.4dm", 91, 115, "Integer", "&A:p_source I:p_number &A:p_target T:p_name",
                              "Integer record_copy_field(Attributes &p_source, Integer p_number, Attributes &p_target, Text p_name)", 0, "", "");
  if (p_id == 227) test_info_set(p_info, "record_copy_prefixed", "macro", "core", "records", "src/core/records.4dm", 117, 133, "void", "&A:p_source &A:p_target T:p_prefix",
                              "void record_copy_prefixed(Attributes &p_source, Attributes &p_target, Text p_prefix)", 0, "", "record_copy_field");
  if (p_id == 228) test_info_set(p_info, "record_copy_unprefixed", "macro", "core", "records", "src/core/records.4dm", 135, 154, "void", "&A:p_source &A:p_target T:p_prefix",
                              "void record_copy_unprefixed(Attributes &p_source, Attributes &p_target, Text p_prefix)", 0, "", "record_copy_field");
  if (p_id == 229) test_info_set(p_info, "record_copy", "macro", "core", "records", "src/core/records.4dm", 156, 164, "void", "&A:p_source &A:p_target",
                              "void record_copy(Attributes &p_source, Attributes &p_target)", 0, "", "record_copy_prefixed");
  if (p_id == 230) test_info_set(p_info, "record_copy_entity", "macro", "core", "records", "src/core/records.4dm", 166, 188, "Integer", "&A:p_source &A:p_target I:p_index",
                              "Integer record_copy_entity(Attributes &p_source, Attributes &p_target, Integer p_index)", 0, "", "record_copy_field");
  if (p_id == 231) test_info_set(p_info, "record_field_at", "macro", "core", "records", "src/core/records.4dm", 192, 198, "Text", "T:p_field I:p_index",
                              "Text record_field_at(Text p_field, Integer p_index)", 0, "", "");
  if (p_id == 232) test_info_set(p_info, "record_integer_at", "macro", "core", "records", "src/core/records.4dm", 200, 206, "Integer", "&A:p_record T:p_field I:p_index",
                              "Integer record_integer_at(Attributes &p_record, Text p_field, Integer p_index)", 0, "", "record_field_at, record_integer");
  if (p_id == 233) test_info_set(p_info, "record_real_at", "macro", "core", "records", "src/core/records.4dm", 208, 214, "Real", "&A:p_record T:p_field I:p_index",
                              "Real record_real_at(Attributes &p_record, Text p_field, Integer p_index)", 0, "", "record_field_at, record_real");
  if (p_id == 234) test_info_set(p_info, "record_text_at", "macro", "core", "records", "src/core/records.4dm", 216, 222, "Text", "&A:p_record T:p_field I:p_index",
                              "Text record_text_at(Attributes &p_record, Text p_field, Integer p_index)", 0, "", "record_field_at, record_text");
  if (p_id == 235) test_info_set(p_info, "record_set_integer_at", "macro", "core", "records", "src/core/records.4dm", 224, 230, "void", "&A:p_record T:p_field I:p_index I:p_value",
                              "void record_set_integer_at(Attributes &p_record, Text p_field, Integer p_index, Integer p_value)", 0, "", "record_field_at, record_set_integer");
  if (p_id == 236) test_info_set(p_info, "record_set_real_at", "macro", "core", "records", "src/core/records.4dm", 232, 238, "void", "&A:p_record T:p_field I:p_index R:p_value",
                              "void record_set_real_at(Attributes &p_record, Text p_field, Integer p_index, Real p_value)", 0, "", "record_field_at, record_set_real");
  if (p_id == 237) test_info_set(p_info, "record_set_text_at", "macro", "core", "records", "src/core/records.4dm", 240, 246, "void", "&A:p_record T:p_field I:p_index T:p_value",
                              "void record_set_text_at(Attributes &p_record, Text p_field, Integer p_index, Text p_value)", 0, "", "record_field_at, record_set_text");
  if (p_id == 238) test_info_set(p_info, "random_seed", "macro", "core", "records", "src/core/records.4dm", 250, 261, "void", "&A:p_random I:p_seed",
                              "void random_seed(Attributes &p_random, Integer p_seed)", 0, "", "record_clear, record_set_real");
  if (p_id == 239) test_info_set(p_info, "random_next", "macro", "core", "records", "src/core/records.4dm", 263, 277, "Real", "&A:p_random",
                              "Real random_next(Attributes &p_random)", 0, "", "record_real, record_set_real");
  if (p_id == 240) test_info_set(p_info, "random_range", "macro", "core", "records", "src/core/records.4dm", 279, 289, "Integer", "&A:p_random I:p_low I:p_high",
                              "Integer random_range(Attributes &p_random, Integer p_low, Integer p_high)", 0, "", "random_next");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 201) {   // textures_generate
    Get_time(l_start);
    textures_generate();
    Get_time(l_end);
  } else if (p_id == 202) {   // events_clear
    Get_time(l_start);
    events_clear(g_events);
    Get_time(l_end);
  } else if (p_id == 203) {   // emit_event
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
  } else if (p_id == 204) {   // emit_simple_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    emit_simple_event(g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 205) {   // emit_cell_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    emit_cell_event(g_events, l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 206) {   // emit_item_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    emit_item_event(g_events, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 207) {   // emit_drop_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    emit_drop_event(g_events, l_i1, l_i2, l_i3, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 208) {   // emit_throw_event
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    emit_throw_event(g_events, l_i1, l_i2, l_i3, l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 209) {   // event_throw_direction
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    event_throw_direction(g_event, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 210) {   // emit_toast
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    emit_toast(g_events, l_t1);
    Get_time(l_end);
  } else if (p_id == 211) {   // events_pending
    Get_time(l_start);
    l_ret_i = events_pending(g_events);
    Get_time(l_end);
  } else if (p_id == 212) {   // next_event
    Get_time(l_start);
    l_ret_i = next_event(g_events, g_event);
    Get_time(l_end);
  } else if (p_id == 213) {   // event_type
    Get_time(l_start);
    l_ret_i = event_type(g_event);
    Get_time(l_end);
  } else if (p_id == 214) {   // event_integer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = event_integer(g_event, l_i1);
    Get_time(l_end);
  } else if (p_id == 215) {   // event_real
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = event_real(g_event, l_i1);
    Get_time(l_end);
  } else if (p_id == 216) {   // event_text
    Get_time(l_start);
    l_ret_t = event_text(g_event);
    Get_time(l_end);
  } else if (p_id == 217) {   // event_is_remote
    Get_time(l_start);
    l_ret_i = event_is_remote(g_event);
    Get_time(l_end);
  } else if (p_id == 218) {   // record_integer
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = record_integer(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 219) {   // record_real
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_r = record_real(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 220) {   // record_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = record_text(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 221) {   // record_set_integer
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    record_set_integer(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 222) {   // record_set_real
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    record_set_real(g_test_record, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 223) {   // record_set_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    record_set_text(g_test_record, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 224) {   // record_clear
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    record_clear(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 225) {   // record_datatype
    Get_time(l_start);
    l_ret_t = record_datatype(g_test_record);
    Get_time(l_end);
  } else if (p_id == 226) {   // record_copy_field
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = record_copy_field(g_test_record, l_i1, g_test_record_2, l_t1);
    Get_time(l_end);
  } else if (p_id == 227) {   // record_copy_prefixed
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    record_copy_prefixed(g_test_record, g_test_record_2, l_t1);
    Get_time(l_end);
  } else if (p_id == 228) {   // record_copy_unprefixed
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    record_copy_unprefixed(g_test_record, g_test_record_2, l_t1);
    Get_time(l_end);
  } else if (p_id == 229) {   // record_copy
    Get_time(l_start);
    record_copy(g_test_record, g_test_record_2);
    Get_time(l_end);
  } else if (p_id == 230) {   // record_copy_entity
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = record_copy_entity(g_test_record, g_test_record_2, l_i1);
    Get_time(l_end);
  } else if (p_id == 231) {   // record_field_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = record_field_at(l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 232) {   // record_integer_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = record_integer_at(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 233) {   // record_real_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = record_real_at(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 234) {   // record_text_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = record_text_at(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 235) {   // record_set_integer_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    record_set_integer_at(g_test_record, l_t1, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 236) {   // record_set_real_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    record_set_real_at(g_test_record, l_t1, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 237) {   // record_set_text_at
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    record_set_text_at(g_test_record, l_t1, l_i1, l_t2);
    Get_time(l_end);
  } else if (p_id == 238) {   // random_seed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    random_seed(g_random, l_i1);
    Get_time(l_end);
  } else if (p_id == 239) {   // random_next
    Get_time(l_start);
    l_ret_r = random_next(g_random);
    Get_time(l_end);
  } else if (p_id == 240) {   // random_range
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = random_range(g_random, l_i1, l_i2);
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
  if (p_id == 241) test_info_set(p_info, "random_between", "macro", "core", "records", "src/core/records.4dm", 291, 297, "Real", "&A:p_random R:p_low R:p_high",
                              "Real random_between(Attributes &p_random, Real p_low, Real p_high)", 0, "", "random_next");
  if (p_id == 242) test_info_set(p_info, "slots_reset", "macro", "core", "slots", "src/core/slots.4dm", 8, 18, "void", "I:p_pool",
                              "void slots_reset(Integer p_pool)", 0, "", "");
  if (p_id == 243) test_info_set(p_info, "slots_set", "macro", "core", "slots", "src/core/slots.4dm", 20, 58, "void", "I:p_pool I:p_slot I:p_used",
                              "void slots_set(Integer p_pool, Integer p_slot, Integer p_used)", 0, "", "");
  if (p_id == 244) test_info_set(p_info, "slots_used", "macro", "core", "slots", "src/core/slots.4dm", 60, 67, "Integer", "I:p_pool I:p_slot",
                              "Integer slots_used(Integer p_pool, Integer p_slot)", 0, "", "");
  if (p_id == 245) test_info_set(p_info, "slots_count", "macro", "core", "slots", "src/core/slots.4dm", 69, 75, "Integer", "I:p_pool",
                              "Integer slots_count(Integer p_pool)", 0, "", "");
  if (p_id == 246) test_info_set(p_info, "slots_at", "macro", "core", "slots", "src/core/slots.4dm", 77, 84, "Integer", "I:p_pool I:p_position",
                              "Integer slots_at(Integer p_pool, Integer p_position)", 0, "", "");
  if (p_id == 247) test_info_set(p_info, "slots_rebuild", "macro", "core", "slots", "src/core/slots.4dm", 86, 98, "void", "I:p_pool &A:p_record I:p_capacity",
                              "void slots_rebuild(Integer p_pool, Attributes &p_record, Integer p_capacity)", 0, "", "record_integer_at, slots_reset, slots_set");
  if (p_id == 248) test_info_set(p_info, "clamp_real", "macro", "core", "util", "src/core/util.4dm", 7, 18, "Real", "R:p_value R:p_low R:p_high",
                              "Real clamp_real(Real p_value, Real p_low, Real p_high)", 0, "", "");
  if (p_id == 249) test_info_set(p_info, "angle_of", "macro", "core", "util", "src/core/util.4dm", 20, 43, "Real", "R:p_y R:p_x",
                              "Real angle_of(Real p_y, Real p_x)", 0, "", "");
  if (p_id == 250) test_info_set(p_info, "two_digits", "macro", "core", "util", "src/core/util.4dm", 45, 52, "Text", "I:p_value",
                              "Text two_digits(Integer p_value)", 0, "", "");
  if (p_id == 251) test_info_set(p_info, "max_integer", "macro", "core", "util", "src/core/util.4dm", 54, 61, "Integer", "I:p_a I:p_b",
                              "Integer max_integer(Integer p_a, Integer p_b)", 0, "", "");
  if (p_id == 252) test_info_set(p_info, "min_integer", "macro", "core", "util", "src/core/util.4dm", 63, 70, "Integer", "I:p_a I:p_b",
                              "Integer min_integer(Integer p_a, Integer p_b)", 0, "", "");
  if (p_id == 253) test_info_set(p_info, "clamp_integer", "macro", "core", "util", "src/core/util.4dm", 72, 83, "Integer", "I:p_value I:p_low I:p_high",
                              "Integer clamp_integer(Integer p_value, Integer p_low, Integer p_high)", 0, "", "");
  if (p_id == 254) test_info_set(p_info, "min_real", "macro", "core", "util", "src/core/util.4dm", 85, 92, "Real", "R:p_first R:p_second",
                              "Real min_real(Real p_first, Real p_second)", 0, "", "");
  if (p_id == 255) test_info_set(p_info, "max_real", "macro", "core", "util", "src/core/util.4dm", 94, 101, "Real", "R:p_first R:p_second",
                              "Real max_real(Real p_first, Real p_second)", 0, "", "");
  if (p_id == 256) test_info_set(p_info, "floor_integer", "macro", "core", "util", "src/core/util.4dm", 103, 110, "Integer", "R:p_value",
                              "Integer floor_integer(Real p_value)", 0, "", "");
  if (p_id == 257) test_info_set(p_info, "floor_divide", "macro", "core", "util", "src/core/util.4dm", 112, 121, "Integer", "I:p_numerator I:p_denominator",
                              "Integer floor_divide(Integer p_numerator, Integer p_denominator)", 0, "", "");
  if (p_id == 258) test_info_set(p_info, "positive_mod", "macro", "core", "util", "src/core/util.4dm", 123, 130, "Integer", "I:p_value I:p_modulus",
                              "Integer positive_mod(Integer p_value, Integer p_modulus)", 0, "", "floor_divide");
  if (p_id == 259) test_info_set(p_info, "to_byte", "macro", "core", "util", "src/core/util.4dm", 132, 139, "Integer", "R:p_value",
                              "Integer to_byte(Real p_value)", 0, "", "clamp_real");
  if (p_id == 260) test_info_set(p_info, "lerp_real", "macro", "core", "util", "src/core/util.4dm", 141, 147, "Real", "R:p_from R:p_to R:p_amount",
                              "Real lerp_real(Real p_from, Real p_to, Real p_amount)", 0, "", "");
  if (p_id == 261) test_info_set(p_info, "smooth_curve", "macro", "core", "util", "src/core/util.4dm", 149, 155, "Real", "R:p_amount",
                              "Real smooth_curve(Real p_amount)", 0, "", "");
  if (p_id == 262) test_info_set(p_info, "hash_real", "macro", "core", "util", "src/core/util.4dm", 157, 166, "Real", "R:p_first R:p_second R:p_third",
                              "Real hash_real(Real p_first, Real p_second, Real p_third)", 0, "", "");
  if (p_id == 263) test_info_set(p_info, "wrap_angle", "macro", "core", "util", "src/core/util.4dm", 168, 174, "Real", "R:p_angle",
                              "Real wrap_angle(Real p_angle)", 0, "", "");
  if (p_id == 264) test_info_set(p_info, "angle_difference", "macro", "core", "util", "src/core/util.4dm", 176, 183, "Real", "R:p_from R:p_to",
                              "Real angle_difference(Real p_from, Real p_to)", 0, "", "wrap_angle");
  if (p_id == 265) test_info_set(p_info, "text_to_seed", "macro", "core", "util", "src/core/util.4dm", 185, 237, "Integer", "T:p_text",
                              "Integer text_to_seed(Text p_text)", 0, "", "");
  if (p_id == 266) test_info_set(p_info, "file_title_from_path", "macro", "core", "util", "src/core/util.4dm", 239, 266, "Text", "T:p_path",
                              "Text file_title_from_path(Text p_path)", 0, "", "");
  if (p_id == 267) test_info_set(p_info, "text_is_safe_name", "macro", "core", "util", "src/core/util.4dm", 268, 287, "Integer", "T:p_name",
                              "Integer text_is_safe_name(Text p_name)", 0, "", "");
  if (p_id == 268) test_info_set(p_info, "key_name", "macro", "core", "util", "src/core/util.4dm", 291, 311, "Text", "T:p_msg",
                              "Text key_name(Text p_msg)", 0, "", "");
  if (p_id == 269) test_info_set(p_info, "key_is_control_letter", "macro", "core", "util", "src/core/util.4dm", 313, 322, "Integer", "I:p_code",
                              "Integer key_is_control_letter(Integer p_code)", 0, "", "");
  if (p_id == 270) test_info_set(p_info, "key_base", "macro", "core", "util", "src/core/util.4dm", 324, 341, "Text", "T:p_msg",
                              "Text key_base(Text p_msg)", 0, "", "key_is_control_letter, key_name");
  if (p_id == 271) test_info_set(p_info, "key_modifier", "macro", "core", "util", "src/core/util.4dm", 343, 356, "Text", "T:p_msg",
                              "Text key_modifier(Text p_msg)", 0, "", "key_is_control_letter");
  if (p_id == 272) test_info_set(p_info, "key_label", "macro", "core", "util", "src/core/util.4dm", 358, 371, "Text", "T:p_key",
                              "Text key_label(Text p_key)", 0, "", "text_upper");
  if (p_id == 273) test_info_set(p_info, "text_upper", "macro", "core", "util", "src/core/util.4dm", 373, 387, "Text", "T:p_text",
                              "Text text_upper(Text p_text)", 0, "", "");
  if (p_id == 274) test_info_set(p_info, "key_is_text", "macro", "core", "util", "src/core/util.4dm", 389, 401, "Integer", "T:p_msg",
                              "Integer key_is_text(Text p_msg)", 0, "", "");
  if (p_id == 275) test_info_set(p_info, "text_without_last_word", "macro", "core", "util", "src/core/util.4dm", 403, 421, "Text", "T:p_text",
                              "Text text_without_last_word(Text p_text)", 0, "", "");
  if (p_id == 276) test_info_set(p_info, "text_after_key", "macro", "core", "util", "src/core/util.4dm", 423, 441, "Text", "T:p_text T:p_msg I:p_longest",
                              "Text text_after_key(Text p_text, Text p_msg, Integer p_longest)", 0, "", "key_is_text, key_name, text_without_last_word");
  if (p_id == 277) test_info_set(p_info, "chest_slot", "macro", "items", "chest", "src/items/chest.4dm", 13, 19, "Integer", "I:p_chest I:p_which",
                              "Integer chest_slot(Integer p_chest, Integer p_which)", 0, "", "");
  if (p_id == 278) test_info_set(p_info, "chest_used", "macro", "items", "chest", "src/items/chest.4dm", 21, 28, "Integer", "&A:p_store I:p_chest",
                              "Integer chest_used(Attributes &p_store, Integer p_chest)", 0, "", "record_integer_at");
  if (p_id == 279) test_info_set(p_info, "chest_find", "macro", "items", "chest", "src/items/chest.4dm", 30, 45, "Integer", "&A:p_store I:p_x I:p_y I:p_z",
                              "Integer chest_find(Attributes &p_store, Integer p_x, Integer p_y, Integer p_z)", 0, "", "chest_used, record_integer_at");
  if (p_id == 280) test_info_set(p_info, "chest_get_or_create", "macro", "items", "chest", "src/items/chest.4dm", 47, 68, "Integer", "&A:p_store I:p_x I:p_y I:p_z",
                              "Integer chest_get_or_create(Attributes &p_store, Integer p_x, Integer p_y, Integer p_z)", 0, "", "chest_find, chest_slot, chest_used, record_set_integer_at, slot_clear");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 241) {   // random_between
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = random_between(g_random, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 242) {   // slots_reset
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    slots_reset(l_i1);
    Get_time(l_end);
  } else if (p_id == 243) {   // slots_set
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    slots_set(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 244) {   // slots_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = slots_used(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 245) {   // slots_count
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slots_count(l_i1);
    Get_time(l_end);
  } else if (p_id == 246) {   // slots_at
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = slots_at(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 247) {   // slots_rebuild
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    slots_rebuild(l_i1, g_test_record, l_i2);
    Get_time(l_end);
  } else if (p_id == 248) {   // clamp_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = clamp_real(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 249) {   // angle_of
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = angle_of(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 250) {   // two_digits
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = two_digits(l_i1);
    Get_time(l_end);
  } else if (p_id == 251) {   // max_integer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = max_integer(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 252) {   // min_integer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = min_integer(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 253) {   // clamp_integer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = clamp_integer(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 254) {   // min_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = min_real(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 255) {   // max_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = max_real(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 256) {   // floor_integer
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = floor_integer(l_r1);
    Get_time(l_end);
  } else if (p_id == 257) {   // floor_divide
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = floor_divide(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 258) {   // positive_mod
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = positive_mod(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 259) {   // to_byte
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = to_byte(l_r1);
    Get_time(l_end);
  } else if (p_id == 260) {   // lerp_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = lerp_real(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 261) {   // smooth_curve
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = smooth_curve(l_r1);
    Get_time(l_end);
  } else if (p_id == 262) {   // hash_real
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = hash_real(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 263) {   // wrap_angle
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = wrap_angle(l_r1);
    Get_time(l_end);
  } else if (p_id == 264) {   // angle_difference
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = angle_difference(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 265) {   // text_to_seed
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = text_to_seed(l_t1);
    Get_time(l_end);
  } else if (p_id == 266) {   // file_title_from_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = file_title_from_path(l_t1);
    Get_time(l_end);
  } else if (p_id == 267) {   // text_is_safe_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = text_is_safe_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 268) {   // key_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = key_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 269) {   // key_is_control_letter
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = key_is_control_letter(l_i1);
    Get_time(l_end);
  } else if (p_id == 270) {   // key_base
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = key_base(l_t1);
    Get_time(l_end);
  } else if (p_id == 271) {   // key_modifier
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = key_modifier(l_t1);
    Get_time(l_end);
  } else if (p_id == 272) {   // key_label
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = key_label(l_t1);
    Get_time(l_end);
  } else if (p_id == 273) {   // text_upper
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = text_upper(l_t1);
    Get_time(l_end);
  } else if (p_id == 274) {   // key_is_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = key_is_text(l_t1);
    Get_time(l_end);
  } else if (p_id == 275) {   // text_without_last_word
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = text_without_last_word(l_t1);
    Get_time(l_end);
  } else if (p_id == 276) {   // text_after_key
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = text_after_key(l_t1, l_t2, l_i1);
    Get_time(l_end);
  } else if (p_id == 277) {   // chest_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = chest_slot(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 278) {   // chest_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = chest_used(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 279) {   // chest_find
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = chest_find(g_test_record, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 280) {   // chest_get_or_create
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = chest_get_or_create(g_test_record, l_i1, l_i2, l_i3);
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
  if (p_id == 281) test_info_set(p_info, "chests_split_legacy", "macro", "items", "chest", "src/items/chest.4dm", 70, 96, "void", "&A:p_store &A:p_away_store I:p_dimension",
                              "void chests_split_legacy(Attributes &p_store, Attributes &p_away_store, Integer p_dimension)", 0, "", "chest_slot, chest_used, record_integer_at, record_set_integer_at, slot_clear, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 282) test_info_set(p_info, "chest_item_count", "macro", "items", "chest", "src/items/chest.4dm", 98, 109, "Integer", "&A:p_store I:p_chest",
                              "Integer chest_item_count(Attributes &p_store, Integer p_chest)", 0, "", "chest_slot, chest_used, slot_count");
  if (p_id == 283) test_info_set(p_info, "chest_remove", "macro", "items", "chest", "src/items/chest.4dm", 111, 135, "void", "&A:p_store &A:p_events I:p_chest",
                              "void chest_remove(Attributes &p_store, Attributes &p_events, Integer p_chest)", 0, "", "chest_slot, chest_used, emit_drop_event, record_integer_at, record_set_integer_at, slot_clear, slot_count, slot_damage, slot_is_empty, slot_item");
  if (p_id == 284) test_info_set(p_info, "chest_join", "macro", "items", "chest", "src/items/chest.4dm", 137, 158, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_block",
                              "void chest_join(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "block_chest, block_chest_facing, block_facing_side, world_get_block, world_place_block");
  if (p_id == 285) test_info_set(p_info, "chest_split", "macro", "items", "chest", "src/items/chest.4dm", 160, 174, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_block",
                              "void chest_split(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "block_chest, block_chest_facing, block_chest_type, block_is_chest, block_partner, world_get_block, world_place_block");
  if (p_id == 286) test_info_set(p_info, "chest_on_event", "macro", "items", "chest", "src/items/chest.4dm", 176, 200, "void", "&A:p_event &A:p_store &A:p_events",
                              "void chest_on_event(Attributes &p_event, Attributes &p_store, Attributes &p_events)", 0, "", "block_chest_type, block_is_chest, chest_find, chest_get_or_create, chest_join, chest_remove, chest_split, event_integer, event_is_remote, event_type");
  if (p_id == 287) test_info_set(p_info, "crafting_add_recipe", "macro", "items", "crafting", "src/items/crafting.4dm", 13, 41, "void", "&A:p_book I:p_output I:p_output_count I:p_width I:p_height T:p_pattern I:p_item_a I:p_item_b",
                              "void crafting_add_recipe(Attributes &p_book, Integer p_output, Integer p_output_count, Integer p_width, Integer p_height, Text p_pattern, Integer p_item_a, Integer p_item_b)", 0, "", "crafting_recipe_count, record_field_at, record_set_integer, record_set_integer_at");
  if (p_id == 288) test_info_set(p_info, "crafting_init_book", "macro", "items", "crafting", "src/items/crafting.4dm", 43, 87, "void", "&A:p_book",
                              "void crafting_init_book(Attributes &p_book)", 0, "", "crafting_add_recipe, record_clear, record_set_integer");
  if (p_id == 289) test_info_set(p_info, "crafting_recipe_count", "macro", "items", "crafting", "src/items/crafting.4dm", 89, 95, "Integer", "&A:p_book",
                              "Integer crafting_recipe_count(Attributes &p_book)", 0, "", "record_integer");
  if (p_id == 290) test_info_set(p_info, "crafting_recipe_output", "macro", "items", "crafting", "src/items/crafting.4dm", 97, 103, "Integer", "&A:p_book I:p_recipe",
                              "Integer crafting_recipe_output(Attributes &p_book, Integer p_recipe)", 0, "", "record_integer_at");
  if (p_id == 291) test_info_set(p_info, "crafting_recipe_cell", "macro", "items", "crafting", "src/items/crafting.4dm", 105, 118, "Integer", "&A:p_book I:p_recipe I:p_column I:p_row",
                              "Integer crafting_recipe_cell(Attributes &p_book, Integer p_recipe, Integer p_column, Integer p_row)", 0, "", "record_field_at, record_integer, record_integer_at");
  if (p_id == 292) test_info_set(p_info, "grid_clear", "macro", "items", "crafting", "src/items/crafting.4dm", 122, 129, "void", "&A:p_grid I:p_width",
                              "void grid_clear(Attributes &p_grid, Integer p_width)", 0, "", "container_clear, record_set_integer");
  if (p_id == 293) test_info_set(p_info, "grid_width", "macro", "items", "crafting", "src/items/crafting.4dm", 131, 137, "Integer", "&A:p_grid",
                              "Integer grid_width(Attributes &p_grid)", 0, "", "record_integer");
  if (p_id == 294) test_info_set(p_info, "grid_slot", "macro", "items", "crafting", "src/items/crafting.4dm", 139, 145, "Integer", "I:p_column I:p_row",
                              "Integer grid_slot(Integer p_column, Integer p_row)", 0, "", "");
  if (p_id == 295) test_info_set(p_info, "grid_slot_used", "macro", "items", "crafting", "src/items/crafting.4dm", 147, 159, "Integer", "&A:p_grid I:p_slot",
                              "Integer grid_slot_used(Attributes &p_grid, Integer p_slot)", 0, "", "grid_width");
  if (p_id == 296) test_info_set(p_info, "crafting_match_at", "macro", "items", "crafting", "src/items/crafting.4dm", 161, 185, "Integer", "&A:p_book I:p_recipe &A:p_grid I:p_left I:p_top I:p_mirrored",
                              "Integer crafting_match_at(Attributes &p_book, Integer p_recipe, Attributes &p_grid, Integer p_left, Integer p_top, Integer p_mirrored)", 0, "", "crafting_recipe_cell, grid_slot, grid_width, record_integer_at, slot_item");
  if (p_id == 297) test_info_set(p_info, "crafting_match", "macro", "items", "crafting", "src/items/crafting.4dm", 187, 218, "Integer", "&A:p_book &A:p_grid",
                              "Integer crafting_match(Attributes &p_book, Attributes &p_grid)", 0, "", "crafting_match_at, crafting_recipe_count, grid_width, record_integer_at, slot_is_empty");
  if (p_id == 298) test_info_set(p_info, "crafting_take_output", "macro", "items", "crafting", "src/items/crafting.4dm", 220, 252, "Integer", "&A:p_book &A:p_grid &A:p_holder &A:p_events",
                              "Integer crafting_take_output(Attributes &p_book, Attributes &p_grid, Attributes &p_holder, Attributes &p_events)", 0, "", "crafting_match, crafting_recipe_output, emit_item_event, item_max_stack, record_integer_at, slot_count, slot_is_empty, slot_item, slot_set, slot_take_one");
  if (p_id == 299) test_info_set(p_info, "grid_return_items", "macro", "items", "crafting", "src/items/crafting.4dm", 254, 269, "void", "&A:p_grid &A:p_inventory &A:p_events R:p_x R:p_y R:p_z",
                              "void grid_return_items(Attributes &p_grid, Attributes &p_inventory, Attributes &p_events, Real p_x, Real p_y, Real p_z)", 0, "", "emit_drop_event, inventory_add_worn, slot_clear, slot_count, slot_damage, slot_is_empty, slot_item");
  if (p_id == 300) test_info_set(p_info, "drops_clear", "macro", "items", "drops", "src/items/drops.4dm", 19, 29, "void", "&A:p_drops",
                              "void drops_clear(Attributes &p_drops)", 0, "", "record_clear, record_set_integer_at, slots_reset");
  if (p_id == 301) test_info_set(p_info, "drops_rebuild_index", "macro", "items", "drops", "src/items/drops.4dm", 31, 38, "void", "&A:p_drops",
                              "void drops_rebuild_index(Attributes &p_drops)", 0, "", "slots_rebuild");
  if (p_id == 302) test_info_set(p_info, "drops_split_legacy", "macro", "items", "drops", "src/items/drops.4dm", 40, 55, "void", "&A:p_drops &A:p_away_drops I:p_dimension",
                              "void drops_split_legacy(Attributes &p_drops, Attributes &p_away_drops, Integer p_dimension)", 0, "", "record_copy_entity, record_integer_at, record_set_integer_at");
  if (p_id == 303) test_info_set(p_info, "drop_set_used", "macro", "items", "drops", "src/items/drops.4dm", 57, 65, "void", "&A:p_drops I:p_drop I:p_used",
                              "void drop_set_used(Attributes &p_drops, Integer p_drop, Integer p_used)", 0, "", "record_set_integer_at, slots_set");
  if (p_id == 304) test_info_set(p_info, "drop_used", "macro", "items", "drops", "src/items/drops.4dm", 67, 74, "Integer", "&A:p_drops I:p_drop",
                              "Integer drop_used(Attributes &p_drops, Integer p_drop)", 0, "", "slots_used");
  if (p_id == 305) test_info_set(p_info, "drop_item", "macro", "items", "drops", "src/items/drops.4dm", 76, 82, "Integer", "&A:p_drops I:p_drop",
                              "Integer drop_item(Attributes &p_drops, Integer p_drop)", 0, "", "record_integer_at");
  if (p_id == 306) test_info_set(p_info, "drop_count", "macro", "items", "drops", "src/items/drops.4dm", 84, 90, "Integer", "&A:p_drops I:p_drop",
                              "Integer drop_count(Attributes &p_drops, Integer p_drop)", 0, "", "record_integer_at");
  if (p_id == 307) test_info_set(p_info, "drop_damage", "macro", "items", "drops", "src/items/drops.4dm", 92, 98, "Integer", "&A:p_drops I:p_drop",
                              "Integer drop_damage(Attributes &p_drops, Integer p_drop)", 0, "", "record_integer_at");
  if (p_id == 308) test_info_set(p_info, "drop_age", "macro", "items", "drops", "src/items/drops.4dm", 100, 106, "Real", "&A:p_drops I:p_drop",
                              "Real drop_age(Attributes &p_drops, Integer p_drop)", 0, "", "record_real_at");
  if (p_id == 309) test_info_set(p_info, "drop_position", "macro", "items", "drops", "src/items/drops.4dm", 108, 116, "void", "&A:p_drops I:p_drop &R:p_x &R:p_y &R:p_z",
                              "void drop_position(Attributes &p_drops, Integer p_drop, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real_at");
  if (p_id == 310) test_info_set(p_info, "drops_restore", "macro", "items", "drops", "src/items/drops.4dm", 120, 157, "Integer", "&A:p_drops I:p_item I:p_count I:p_damage R:p_x R:p_y R:p_z R:p_age",
                              "Integer drops_restore(Attributes &p_drops, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z, Real p_age)", 0, "", "drop_age, drop_set_used, drop_used, record_set_integer_at, record_set_real_at");
  if (p_id == 311) test_info_set(p_info, "drops_spawn", "macro", "items", "drops", "src/items/drops.4dm", 159, 174, "Integer", "&A:p_drops &A:p_random I:p_item I:p_count I:p_damage R:p_x R:p_y R:p_z",
                              "Integer drops_spawn(Attributes &p_drops, Attributes &p_random, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z)", 0, "", "drops_restore, random_between, record_set_real_at");
  if (p_id == 312) test_info_set(p_info, "drops_throw", "macro", "items", "drops", "src/items/drops.4dm", 176, 192, "Integer", "&A:p_drops I:p_item I:p_count I:p_damage R:p_x R:p_y R:p_z R:p_yaw R:p_pitch",
                              "Integer drops_throw(Attributes &p_drops, Integer p_item, Integer p_count, Integer p_damage, Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_pitch)", 0, "", "drops_restore, record_set_real_at");
  if (p_id == 313) test_info_set(p_info, "drops_update", "macro", "items", "drops", "src/items/drops.4dm", 194, 300, "void", "&A:p_drops &A:p_inventory &A:p_events R:p_player_x R:p_player_y R:p_player_z I:p_player_dead R:p_dt",
                              "void drops_update(Attributes &p_drops, Attributes &p_inventory, Attributes &p_events, Real p_player_x, Real p_player_y, Real p_player_z, Integer p_player_dead, Real p_dt)", 0, "", "drop_age, drop_count, drop_damage, drop_item, drop_position, drop_set_used, emit_item_event, inventory_add_worn, max_real, min_real, physics_box_in_water, physics_move_box, record_real_at, record_set_integer_at, record_set_real_at, slots_at, slots_count");
  if (p_id == 314) test_info_set(p_info, "drops_on_event", "macro", "items", "drops", "src/items/drops.4dm", 302, 343, "void", "&A:p_event &A:p_drops &A:p_random",
                              "void drops_on_event(Attributes &p_event, Attributes &p_drops, Attributes &p_random)", 0, "", "block_drop_item, drops_spawn, drops_throw, event_integer, event_is_remote, event_real, event_throw_direction, event_type, floor_integer, random_between, random_range");
  if (p_id == 315) test_info_set(p_info, "furnaces_clear", "macro", "items", "furnace", "src/items/furnace.4dm", 16, 26, "void", "&A:p_furnaces",
                              "void furnaces_clear(Attributes &p_furnaces)", 0, "", "record_clear, record_set_integer_at, slots_reset");
  if (p_id == 316) test_info_set(p_info, "furnaces_rebuild_index", "macro", "items", "furnace", "src/items/furnace.4dm", 28, 35, "void", "&A:p_furnaces",
                              "void furnaces_rebuild_index(Attributes &p_furnaces)", 0, "", "slots_rebuild");
  if (p_id == 317) test_info_set(p_info, "furnaces_split_legacy", "macro", "items", "furnace", "src/items/furnace.4dm", 37, 65, "void", "&A:p_furnaces &A:p_away_furnaces I:p_dimension",
                              "void furnaces_split_legacy(Attributes &p_furnaces, Attributes &p_away_furnaces, Integer p_dimension)", 0, "", "furnace_burn_left, furnace_burn_total, furnace_progress, furnace_set_state, furnace_slot, record_integer_at, record_set_integer_at, slot_clear, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 318) test_info_set(p_info, "furnace_set_used", "macro", "items", "furnace", "src/items/furnace.4dm", 67, 75, "void", "&A:p_furnaces I:p_furnace I:p_used",
                              "void furnace_set_used(Attributes &p_furnaces, Integer p_furnace, Integer p_used)", 0, "", "record_set_integer_at, slots_set");
  if (p_id == 319) test_info_set(p_info, "furnace_slot", "macro", "items", "furnace", "src/items/furnace.4dm", 77, 83, "Integer", "I:p_furnace I:p_which",
                              "Integer furnace_slot(Integer p_furnace, Integer p_which)", 0, "", "");
  if (p_id == 320) test_info_set(p_info, "furnace_used", "macro", "items", "furnace", "src/items/furnace.4dm", 85, 92, "Integer", "&A:p_furnaces I:p_furnace",
                              "Integer furnace_used(Attributes &p_furnaces, Integer p_furnace)", 0, "", "slots_used");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 281) {   // chests_split_legacy
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    chests_split_legacy(g_test_record, g_test_record_2, l_i1);
    Get_time(l_end);
  } else if (p_id == 282) {   // chest_item_count
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = chest_item_count(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 283) {   // chest_remove
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    chest_remove(g_test_record, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 284) {   // chest_join
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    chest_join(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 285) {   // chest_split
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    chest_split(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 286) {   // chest_on_event
    Get_time(l_start);
    chest_on_event(g_event, g_test_record, g_events);
    Get_time(l_end);
  } else if (p_id == 287) {   // crafting_add_recipe
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
  } else if (p_id == 288) {   // crafting_init_book
    Get_time(l_start);
    crafting_init_book(g_book);
    Get_time(l_end);
  } else if (p_id == 289) {   // crafting_recipe_count
    Get_time(l_start);
    l_ret_i = crafting_recipe_count(g_book);
    Get_time(l_end);
  } else if (p_id == 290) {   // crafting_recipe_output
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = crafting_recipe_output(g_book, l_i1);
    Get_time(l_end);
  } else if (p_id == 291) {   // crafting_recipe_cell
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = crafting_recipe_cell(g_book, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 292) {   // grid_clear
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    grid_clear(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 293) {   // grid_width
    Get_time(l_start);
    l_ret_i = grid_width(g_grid);
    Get_time(l_end);
  } else if (p_id == 294) {   // grid_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = grid_slot(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 295) {   // grid_slot_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = grid_slot_used(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 296) {   // crafting_match_at
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = crafting_match_at(g_book, l_i1, g_grid, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 297) {   // crafting_match
    Get_time(l_start);
    l_ret_i = crafting_match(g_book, g_grid);
    Get_time(l_end);
  } else if (p_id == 298) {   // crafting_take_output
    Get_time(l_start);
    l_ret_i = crafting_take_output(g_book, g_grid, g_inventory, g_events);
    Get_time(l_end);
  } else if (p_id == 299) {   // grid_return_items
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    grid_return_items(g_grid, g_inventory, g_events, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 300) {   // drops_clear
    Get_time(l_start);
    drops_clear(g_drops);
    Get_time(l_end);
  } else if (p_id == 301) {   // drops_rebuild_index
    Get_time(l_start);
    drops_rebuild_index(g_drops);
    Get_time(l_end);
  } else if (p_id == 302) {   // drops_split_legacy
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    drops_split_legacy(g_drops, g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 303) {   // drop_set_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    drop_set_used(g_drops, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 304) {   // drop_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = drop_used(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 305) {   // drop_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = drop_item(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 306) {   // drop_count
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = drop_count(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 307) {   // drop_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = drop_damage(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 308) {   // drop_age
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = drop_age(g_drops, l_i1);
    Get_time(l_end);
  } else if (p_id == 309) {   // drop_position
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
  } else if (p_id == 310) {   // drops_restore
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
  } else if (p_id == 311) {   // drops_spawn
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_i = drops_spawn(g_drops, g_random, l_i1, l_i2, l_i3, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 312) {   // drops_throw
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    l_ret_i = drops_throw(g_drops, l_i1, l_i2, l_i3, l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 313) {   // drops_update
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    drops_update(g_drops, g_inventory, g_events, l_r1, l_r2, l_r3, l_i1, l_r4);
    Get_time(l_end);
  } else if (p_id == 314) {   // drops_on_event
    Get_time(l_start);
    drops_on_event(g_event, g_drops, g_random);
    Get_time(l_end);
  } else if (p_id == 315) {   // furnaces_clear
    Get_time(l_start);
    furnaces_clear(g_furnaces);
    Get_time(l_end);
  } else if (p_id == 316) {   // furnaces_rebuild_index
    Get_time(l_start);
    furnaces_rebuild_index(g_furnaces);
    Get_time(l_end);
  } else if (p_id == 317) {   // furnaces_split_legacy
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    furnaces_split_legacy(g_furnaces, g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 318) {   // furnace_set_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    furnace_set_used(g_furnaces, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 319) {   // furnace_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = furnace_slot(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 320) {   // furnace_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = furnace_used(g_furnaces, l_i1);
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
  if (p_id == 321) test_info_set(p_info, "furnace_cell", "macro", "items", "furnace", "src/items/furnace.4dm", 94, 102, "void", "&A:p_furnaces I:p_furnace &I:p_x &I:p_y &I:p_z",
                              "void furnace_cell(Attributes &p_furnaces, Integer p_furnace, Integer &p_x, Integer &p_y, Integer &p_z)", 0, "", "record_integer_at");
  if (p_id == 322) test_info_set(p_info, "furnace_burn_left", "macro", "items", "furnace", "src/items/furnace.4dm", 104, 110, "Real", "&A:p_furnaces I:p_furnace",
                              "Real furnace_burn_left(Attributes &p_furnaces, Integer p_furnace)", 0, "", "record_real_at");
  if (p_id == 323) test_info_set(p_info, "furnace_burn_total", "macro", "items", "furnace", "src/items/furnace.4dm", 112, 118, "Real", "&A:p_furnaces I:p_furnace",
                              "Real furnace_burn_total(Attributes &p_furnaces, Integer p_furnace)", 0, "", "record_real_at");
  if (p_id == 324) test_info_set(p_info, "furnace_progress", "macro", "items", "furnace", "src/items/furnace.4dm", 120, 126, "Real", "&A:p_furnaces I:p_furnace",
                              "Real furnace_progress(Attributes &p_furnaces, Integer p_furnace)", 0, "", "record_real_at");
  if (p_id == 325) test_info_set(p_info, "furnace_set_state", "macro", "items", "furnace", "src/items/furnace.4dm", 128, 136, "void", "&A:p_furnaces I:p_furnace R:p_burn_left R:p_burn_total R:p_progress",
                              "void furnace_set_state(Attributes &p_furnaces, Integer p_furnace, Real p_burn_left, Real p_burn_total, Real p_progress)", 0, "", "record_set_real_at");
  if (p_id == 326) test_info_set(p_info, "furnace_here", "macro", "items", "furnace", "src/items/furnace.4dm", 140, 147, "Integer", "&A:p_furnaces I:p_furnace",
                              "Integer furnace_here(Attributes &p_furnaces, Integer p_furnace)", 0, "", "furnace_used");
  if (p_id == 327) test_info_set(p_info, "furnace_find", "macro", "items", "furnace", "src/items/furnace.4dm", 149, 165, "Integer", "&A:p_furnaces I:p_x I:p_y I:p_z",
                              "Integer furnace_find(Attributes &p_furnaces, Integer p_x, Integer p_y, Integer p_z)", 0, "", "furnace_cell, furnace_here");
  if (p_id == 328) test_info_set(p_info, "furnace_get_or_create", "macro", "items", "furnace", "src/items/furnace.4dm", 167, 189, "Integer", "&A:p_furnaces I:p_x I:p_y I:p_z",
                              "Integer furnace_get_or_create(Attributes &p_furnaces, Integer p_x, Integer p_y, Integer p_z)", 0, "", "furnace_find, furnace_set_state, furnace_set_used, furnace_slot, furnace_used, record_set_integer_at, slot_clear");
  if (p_id == 329) test_info_set(p_info, "furnace_remove", "macro", "items", "furnace", "src/items/furnace.4dm", 191, 214, "void", "&A:p_furnaces &A:p_events I:p_furnace",
                              "void furnace_remove(Attributes &p_furnaces, Attributes &p_events, Integer p_furnace)", 0, "", "emit_drop_event, furnace_cell, furnace_set_used, furnace_slot, furnace_used, slot_clear, slot_count, slot_damage, slot_is_empty, slot_item");
  if (p_id == 330) test_info_set(p_info, "furnace_can_cook", "macro", "items", "furnace", "src/items/furnace.4dm", 216, 233, "Integer", "&A:p_furnaces I:p_furnace",
                              "Integer furnace_can_cook(Attributes &p_furnaces, Integer p_furnace)", 0, "", "furnace_slot, item_max_stack, item_smelt_result, slot_count, slot_is_empty, slot_item");
  if (p_id == 331) test_info_set(p_info, "furnace_step", "macro", "items", "furnace", "src/items/furnace.4dm", 235, 282, "void", "&A:p_furnaces I:p_furnace R:p_dt",
                              "void furnace_step(Attributes &p_furnaces, Integer p_furnace, Real p_dt)", 0, "", "furnace_burn_left, furnace_burn_total, furnace_can_cook, furnace_progress, furnace_set_state, furnace_slot, item_fuel_seconds, item_smelt_result, slot_count, slot_is_empty, slot_item, slot_set, slot_take_one");
  if (p_id == 332) test_info_set(p_info, "furnaces_update", "macro", "items", "furnace", "src/items/furnace.4dm", 284, 322, "void", "&A:p_furnaces &A:p_events R:p_dt",
                              "void furnaces_update(Attributes &p_furnaces, Attributes &p_events, Real p_dt)", 0, "", "block_furnace_is_lit, block_is_furnace, emit_event, furnace_burn_left, furnace_cell, furnace_step, slots_at, slots_count, world_get_block");
  if (p_id == 333) test_info_set(p_info, "furnace_on_event", "macro", "items", "furnace", "src/items/furnace.4dm", 324, 342, "void", "&A:p_event &A:p_furnaces &A:p_events",
                              "void furnace_on_event(Attributes &p_event, Attributes &p_furnaces, Attributes &p_events)", 0, "", "block_is_furnace, event_integer, event_type, furnace_find, furnace_get_or_create, furnace_remove");
  if (p_id == 334) test_info_set(p_info, "slot_item", "macro", "items", "inventory", "src/items/inventory.4dm", 14, 20, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_item(Attributes &p_container, Integer p_slot)", 0, "", "record_integer_at");
  if (p_id == 335) test_info_set(p_info, "slot_count", "macro", "items", "inventory", "src/items/inventory.4dm", 22, 28, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_count(Attributes &p_container, Integer p_slot)", 0, "", "record_integer_at");
  if (p_id == 336) test_info_set(p_info, "slot_damage", "macro", "items", "inventory", "src/items/inventory.4dm", 30, 36, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_damage(Attributes &p_container, Integer p_slot)", 0, "", "record_integer_at");
  if (p_id == 337) test_info_set(p_info, "slot_is_empty", "macro", "items", "inventory", "src/items/inventory.4dm", 38, 46, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_is_empty(Attributes &p_container, Integer p_slot)", 0, "", "slot_count, slot_item");
  if (p_id == 338) test_info_set(p_info, "slot_set", "macro", "items", "inventory", "src/items/inventory.4dm", 48, 65, "void", "&A:p_container I:p_slot I:p_item I:p_count I:p_damage",
                              "void slot_set(Attributes &p_container, Integer p_slot, Integer p_item, Integer p_count, Integer p_damage)", 0, "", "record_set_integer_at");
  if (p_id == 339) test_info_set(p_info, "slot_clear", "macro", "items", "inventory", "src/items/inventory.4dm", 67, 73, "void", "&A:p_container I:p_slot",
                              "void slot_clear(Attributes &p_container, Integer p_slot)", 0, "", "slot_set");
  if (p_id == 340) test_info_set(p_info, "slot_swap", "macro", "items", "inventory", "src/items/inventory.4dm", 75, 86, "void", "&A:p_container I:p_slot_a I:p_slot_b",
                              "void slot_swap(Attributes &p_container, Integer p_slot_a, Integer p_slot_b)", 0, "", "slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 341) test_info_set(p_info, "slot_take_one", "macro", "items", "inventory", "src/items/inventory.4dm", 88, 94, "void", "&A:p_container I:p_slot",
                              "void slot_take_one(Attributes &p_container, Integer p_slot)", 0, "", "slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 342) test_info_set(p_info, "slot_wear", "macro", "items", "inventory", "src/items/inventory.4dm", 96, 115, "Integer", "&A:p_container I:p_slot",
                              "Integer slot_wear(Attributes &p_container, Integer p_slot)", 0, "", "item_max_uses, record_set_integer_at, slot_clear, slot_damage, slot_item");
  if (p_id == 343) test_info_set(p_info, "slot_click_left", "macro", "items", "inventory", "src/items/inventory.4dm", 117, 162, "void", "&A:p_holder &A:p_container I:p_slot I:p_take_only",
                              "void slot_click_left(Attributes &p_holder, Attributes &p_container, Integer p_slot, Integer p_take_only)", 0, "", "item_max_stack, slot_clear, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 344) test_info_set(p_info, "slot_click_right", "macro", "items", "inventory", "src/items/inventory.4dm", 164, 193, "void", "&A:p_holder &A:p_container I:p_slot I:p_take_only",
                              "void slot_click_right(Attributes &p_holder, Attributes &p_container, Integer p_slot, Integer p_take_only)", 0, "", "floor_divide, item_max_stack, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 345) test_info_set(p_info, "slot_move_all", "macro", "items", "inventory", "src/items/inventory.4dm", 195, 204, "void", "&A:p_from I:p_from_slot &A:p_to I:p_first I:p_last",
                              "void slot_move_all(Attributes &p_from, Integer p_from_slot, Attributes &p_to, Integer p_first, Integer p_last)", 0, "", "container_add, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 346) test_info_set(p_info, "container_clear", "macro", "items", "inventory", "src/items/inventory.4dm", 208, 218, "void", "&A:p_container T:p_datatype I:p_first I:p_last",
                              "void container_clear(Attributes &p_container, Text p_datatype, Integer p_first, Integer p_last)", 0, "", "record_clear, slot_clear");
  if (p_id == 347) test_info_set(p_info, "container_add", "macro", "items", "inventory", "src/items/inventory.4dm", 220, 258, "Integer", "&A:p_container I:p_first I:p_last I:p_item I:p_count I:p_damage",
                              "Integer container_add(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item, Integer p_count, Integer p_damage)", 0, "", "item_max_stack, slot_count, slot_is_empty, slot_item, slot_set");
  if (p_id == 348) test_info_set(p_info, "container_count_item", "macro", "items", "inventory", "src/items/inventory.4dm", 260, 272, "Integer", "&A:p_container I:p_first I:p_last I:p_item",
                              "Integer container_count_item(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item)", 0, "", "slot_count, slot_item");
  if (p_id == 349) test_info_set(p_info, "container_remove_item", "macro", "items", "inventory", "src/items/inventory.4dm", 274, 298, "Integer", "&A:p_container I:p_first I:p_last I:p_item I:p_count",
                              "Integer container_remove_item(Attributes &p_container, Integer p_first, Integer p_last, Integer p_item, Integer p_count)", 0, "", "container_count_item, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 350) test_info_set(p_info, "inventory_clear", "macro", "items", "inventory", "src/items/inventory.4dm", 302, 308, "void", "&A:p_inventory",
                              "void inventory_clear(Attributes &p_inventory)", 0, "", "container_clear");
  if (p_id == 351) test_info_set(p_info, "inventory_add", "macro", "items", "inventory", "src/items/inventory.4dm", 310, 316, "Integer", "&A:p_inventory I:p_item I:p_count",
                              "Integer inventory_add(Attributes &p_inventory, Integer p_item, Integer p_count)", 0, "", "container_add");
  if (p_id == 352) test_info_set(p_info, "inventory_add_worn", "macro", "items", "inventory", "src/items/inventory.4dm", 318, 325, "Integer", "&A:p_inventory I:p_item I:p_count I:p_damage",
                              "Integer inventory_add_worn(Attributes &p_inventory, Integer p_item, Integer p_count, Integer p_damage)", 0, "", "container_add");
  if (p_id == 353) test_info_set(p_info, "inventory_count_item", "macro", "items", "inventory", "src/items/inventory.4dm", 327, 333, "Integer", "&A:p_inventory I:p_item",
                              "Integer inventory_count_item(Attributes &p_inventory, Integer p_item)", 0, "", "container_count_item");
  if (p_id == 354) test_info_set(p_info, "inventory_remove_item", "macro", "items", "inventory", "src/items/inventory.4dm", 335, 342, "Integer", "&A:p_inventory I:p_item I:p_count",
                              "Integer inventory_remove_item(Attributes &p_inventory, Integer p_item, Integer p_count)", 0, "", "container_remove_item");
  if (p_id == 355) test_info_set(p_info, "inventory_return_cursor", "macro", "items", "inventory", "src/items/inventory.4dm", 344, 359, "void", "&A:p_inventory &A:p_events R:p_x R:p_y R:p_z",
                              "void inventory_return_cursor(Attributes &p_inventory, Attributes &p_events, Real p_x, Real p_y, Real p_z)", 0, "", "emit_drop_event, inventory_add_worn, slot_clear, slot_count, slot_damage, slot_item");
  if (p_id == 356) test_info_set(p_info, "inventory_armour_slot", "macro", "items", "inventory", "src/items/inventory.4dm", 363, 370, "Integer", "I:p_place",
                              "Integer inventory_armour_slot(Integer p_place)", 0, "", "");
  if (p_id == 357) test_info_set(p_info, "inventory_fits_slot", "macro", "items", "inventory", "src/items/inventory.4dm", 372, 381, "Integer", "I:p_item I:p_slot",
                              "Integer inventory_fits_slot(Integer p_item, Integer p_slot)", 0, "", "inventory_armour_slot, item_armour_place");
  if (p_id == 358) test_info_set(p_info, "inventory_armour_points", "macro", "items", "inventory", "src/items/inventory.4dm", 383, 395, "Integer", "&A:p_inventory",
                              "Integer inventory_armour_points(Attributes &p_inventory)", 0, "", "item_armour_points, min_integer, slot_item");
  if (p_id == 359) test_info_set(p_info, "inventory_armour_damage", "macro", "items", "inventory", "src/items/inventory.4dm", 397, 407, "Integer", "&A:p_inventory I:p_amount",
                              "Integer inventory_armour_damage(Attributes &p_inventory, Integer p_amount)", 0, "", "floor_integer, inventory_armour_points");
  if (p_id == 360) test_info_set(p_info, "inventory_wear_armour", "macro", "items", "inventory", "src/items/inventory.4dm", 409, 428, "Integer", "&A:p_inventory &A:p_events",
                              "Integer inventory_wear_armour(Attributes &p_inventory, Attributes &p_events)", 0, "", "emit_toast, item_name, slot_item, slot_wear");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 321) {   // furnace_cell
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
  } else if (p_id == 322) {   // furnace_burn_left
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = furnace_burn_left(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 323) {   // furnace_burn_total
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = furnace_burn_total(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 324) {   // furnace_progress
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = furnace_progress(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 325) {   // furnace_set_state
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    furnace_set_state(g_furnaces, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 326) {   // furnace_here
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = furnace_here(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 327) {   // furnace_find
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = furnace_find(g_furnaces, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 328) {   // furnace_get_or_create
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = furnace_get_or_create(g_furnaces, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 329) {   // furnace_remove
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    furnace_remove(g_furnaces, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 330) {   // furnace_can_cook
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = furnace_can_cook(g_furnaces, l_i1);
    Get_time(l_end);
  } else if (p_id == 331) {   // furnace_step
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    furnace_step(g_furnaces, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 332) {   // furnaces_update
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    furnaces_update(g_furnaces, g_events, l_r1);
    Get_time(l_end);
  } else if (p_id == 333) {   // furnace_on_event
    Get_time(l_start);
    furnace_on_event(g_event, g_furnaces, g_events);
    Get_time(l_end);
  } else if (p_id == 334) {   // slot_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_item(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 335) {   // slot_count
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_count(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 336) {   // slot_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_damage(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 337) {   // slot_is_empty
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_is_empty(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 338) {   // slot_set
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    slot_set(g_grid, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 339) {   // slot_clear
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    slot_clear(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 340) {   // slot_swap
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    slot_swap(g_grid, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 341) {   // slot_take_one
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    slot_take_one(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 342) {   // slot_wear
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = slot_wear(g_grid, l_i1);
    Get_time(l_end);
  } else if (p_id == 343) {   // slot_click_left
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    slot_click_left(g_inventory, g_grid, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 344) {   // slot_click_right
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    slot_click_right(g_inventory, g_grid, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 345) {   // slot_move_all
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    slot_move_all(g_inventory, l_i1, g_grid, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 346) {   // container_clear
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    container_clear(g_grid, l_t1, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 347) {   // container_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = container_add(g_grid, l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  } else if (p_id == 348) {   // container_count_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = container_count_item(g_grid, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 349) {   // container_remove_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = container_remove_item(g_grid, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 350) {   // inventory_clear
    Get_time(l_start);
    inventory_clear(g_inventory);
    Get_time(l_end);
  } else if (p_id == 351) {   // inventory_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = inventory_add(g_inventory, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 352) {   // inventory_add_worn
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = inventory_add_worn(g_inventory, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 353) {   // inventory_count_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inventory_count_item(g_inventory, l_i1);
    Get_time(l_end);
  } else if (p_id == 354) {   // inventory_remove_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = inventory_remove_item(g_inventory, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 355) {   // inventory_return_cursor
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    inventory_return_cursor(g_inventory, g_events, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 356) {   // inventory_armour_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inventory_armour_slot(l_i1);
    Get_time(l_end);
  } else if (p_id == 357) {   // inventory_fits_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = inventory_fits_slot(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 358) {   // inventory_armour_points
    Get_time(l_start);
    l_ret_i = inventory_armour_points(g_inventory);
    Get_time(l_end);
  } else if (p_id == 359) {   // inventory_armour_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inventory_armour_damage(g_inventory, l_i1);
    Get_time(l_end);
  } else if (p_id == 360) {   // inventory_wear_armour
    Get_time(l_start);
    l_ret_i = inventory_wear_armour(g_inventory, g_events);
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
  if (p_id == 361) test_info_set(p_info, "inventory_equip", "macro", "items", "inventory", "src/items/inventory.4dm", 430, 441, "Integer", "&A:p_inventory I:p_slot",
                              "Integer inventory_equip(Attributes &p_inventory, Integer p_slot)", 0, "", "inventory_armour_slot, item_armour_place, slot_item, slot_swap");
  if (p_id == 362) test_info_set(p_info, "inventory_swap_hands", "macro", "items", "inventory", "src/items/inventory.4dm", 443, 449, "void", "&A:p_inventory I:p_selected",
                              "void inventory_swap_hands(Attributes &p_inventory, Integer p_selected)", 0, "", "slot_swap");
  if (p_id == 363) test_info_set(p_info, "cows_clear", "macro", "mobs", "cows", "src/mobs/cows.4dm", 17, 28, "void", "&A:p_cows",
                              "void cows_clear(Attributes &p_cows)", 0, "", "record_clear, record_set_integer_at, record_set_real, slots_reset");
  if (p_id == 364) test_info_set(p_info, "mobs_rebuild_index", "macro", "mobs", "cows", "src/mobs/cows.4dm", 30, 37, "void", "&A:p_cows",
                              "void mobs_rebuild_index(Attributes &p_cows)", 0, "", "slots_rebuild");
  if (p_id == 365) test_info_set(p_info, "mobs_split_legacy", "macro", "mobs", "cows", "src/mobs/cows.4dm", 39, 54, "void", "&A:p_cows &A:p_away_cows I:p_dimension",
                              "void mobs_split_legacy(Attributes &p_cows, Attributes &p_away_cows, Integer p_dimension)", 0, "", "record_copy_entity, record_integer_at, record_set_integer_at");
  if (p_id == 366) test_info_set(p_info, "mob_set_used", "macro", "mobs", "cows", "src/mobs/cows.4dm", 56, 64, "void", "&A:p_cows I:p_cow I:p_used",
                              "void mob_set_used(Attributes &p_cows, Integer p_cow, Integer p_used)", 0, "", "record_set_integer_at, slots_set");
  if (p_id == 367) test_info_set(p_info, "cow_alive", "macro", "mobs", "cows", "src/mobs/cows.4dm", 66, 74, "Integer", "&A:p_cows I:p_cow",
                              "Integer cow_alive(Attributes &p_cows, Integer p_cow)", 0, "", "slots_used");
  if (p_id == 368) test_info_set(p_info, "cow_position", "macro", "mobs", "cows", "src/mobs/cows.4dm", 76, 84, "void", "&A:p_cows I:p_cow &R:p_x &R:p_y &R:p_z",
                              "void cow_position(Attributes &p_cows, Integer p_cow, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real_at");
  if (p_id == 369) test_info_set(p_info, "cow_set_position", "macro", "mobs", "cows", "src/mobs/cows.4dm", 86, 94, "void", "&A:p_cows I:p_cow R:p_x R:p_y R:p_z",
                              "void cow_set_position(Attributes &p_cows, Integer p_cow, Real p_x, Real p_y, Real p_z)", 0, "", "record_set_real_at");
  if (p_id == 370) test_info_set(p_info, "cow_yaw", "macro", "mobs", "cows", "src/mobs/cows.4dm", 96, 102, "Real", "&A:p_cows I:p_cow",
                              "Real cow_yaw(Attributes &p_cows, Integer p_cow)", 0, "", "record_real_at");
  if (p_id == 371) test_info_set(p_info, "cow_flash", "macro", "mobs", "cows", "src/mobs/cows.4dm", 104, 110, "Real", "&A:p_cows I:p_cow",
                              "Real cow_flash(Attributes &p_cows, Integer p_cow)", 0, "", "record_real_at");
  if (p_id == 372) test_info_set(p_info, "cow_step", "macro", "mobs", "cows", "src/mobs/cows.4dm", 112, 118, "Real", "&A:p_cows I:p_cow",
                              "Real cow_step(Attributes &p_cows, Integer p_cow)", 0, "", "record_real_at");
  if (p_id == 373) test_info_set(p_info, "cows_alive_count", "macro", "mobs", "cows", "src/mobs/cows.4dm", 120, 126, "Integer", "&A:p_cows",
                              "Integer cows_alive_count(Attributes &p_cows)", 0, "", "mobs_count_kind");
  if (p_id == 374) test_info_set(p_info, "mob_kind", "macro", "mobs", "cows", "src/mobs/cows.4dm", 128, 134, "Integer", "&A:p_cows I:p_cow",
                              "Integer mob_kind(Attributes &p_cows, Integer p_cow)", 0, "", "record_integer_at");
  if (p_id == 375) test_info_set(p_info, "mob_half_width", "macro", "mobs", "cows", "src/mobs/cows.4dm", 136, 144, "Real", "I:p_kind",
                              "Real mob_half_width(Integer p_kind)", 0, "", "");
  if (p_id == 376) test_info_set(p_info, "mob_height", "macro", "mobs", "cows", "src/mobs/cows.4dm", 146, 154, "Real", "I:p_kind",
                              "Real mob_height(Integer p_kind)", 0, "", "");
  if (p_id == 377) test_info_set(p_info, "mobs_count_kind", "macro", "mobs", "cows", "src/mobs/cows.4dm", 156, 170, "Integer", "&A:p_cows I:p_kind",
                              "Integer mobs_count_kind(Attributes &p_cows, Integer p_kind)", 0, "", "mob_kind, slots_at, slots_count");
  if (p_id == 378) test_info_set(p_info, "cows_spawn", "macro", "mobs", "cows", "src/mobs/cows.4dm", 174, 180, "Integer", "&A:p_cows &A:p_random R:p_x R:p_y R:p_z R:p_yaw",
                              "Integer cows_spawn(Attributes &p_cows, Attributes &p_random, Real p_x, Real p_y, Real p_z, Real p_yaw)", 0, "", "mobs_spawn");
  if (p_id == 379) test_info_set(p_info, "mobs_spawn", "macro", "mobs", "cows", "src/mobs/cows.4dm", 182, 213, "Integer", "&A:p_cows &A:p_random I:p_kind R:p_x R:p_y R:p_z R:p_yaw",
                              "Integer mobs_spawn(Attributes &p_cows, Attributes &p_random, Integer p_kind, Real p_x, Real p_y, Real p_z, Real p_yaw)", 0, "", "cow_alive, cow_set_position, mob_set_used, random_between, record_set_integer_at, record_set_real_at");
  if (p_id == 380) test_info_set(p_info, "cows_spawn_random", "macro", "mobs", "cows", "src/mobs/cows.4dm", 215, 221, "Integer", "&A:p_cows &A:p_random I:p_count R:p_away_x R:p_away_z R:p_keep_away",
                              "Integer cows_spawn_random(Attributes &p_cows, Attributes &p_random, Integer p_count, Real p_away_x, Real p_away_z, Real p_keep_away)", 0, "", "mobs_spawn_random");
  if (p_id == 381) test_info_set(p_info, "mobs_spawn_random", "macro", "mobs", "cows", "src/mobs/cows.4dm", 223, 251, "Integer", "&A:p_cows &A:p_random I:p_kind I:p_count R:p_away_x R:p_away_z R:p_keep_away",
                              "Integer mobs_spawn_random(Attributes &p_cows, Attributes &p_random, Integer p_kind, Integer p_count, Real p_away_x, Real p_away_z, Real p_keep_away)", 0, "", "mobs_spawn, random_between, random_range, world_get_block, world_top_solid_y");
  if (p_id == 382) test_info_set(p_info, "zombies_spawn_near", "macro", "mobs", "cows", "src/mobs/cows.4dm", 253, 282, "Integer", "&A:p_cows &A:p_random R:p_player_x R:p_player_z",
                              "Integer zombies_spawn_near(Attributes &p_cows, Attributes &p_random, Real p_player_x, Real p_player_z)", 0, "", "floor_integer, mobs_spawn, random_between, world_get_block, world_get_light, world_top_solid_y");
  if (p_id == 383) test_info_set(p_info, "zombie_sunlight", "macro", "mobs", "cows", "src/mobs/cows.4dm", 284, 312, "void", "&A:p_cows &A:p_events I:p_cow R:p_dt",
                              "void zombie_sunlight(Attributes &p_cows, Attributes &p_events, Integer p_cow, Real p_dt)", 0, "", "cow_position, emit_event, floor_integer, mob_set_used, record_integer_at, record_real_at, record_set_integer_at, record_set_real_at, world_sky_top");
  if (p_id == 384) test_info_set(p_info, "cow_update", "macro", "mobs", "cows", "src/mobs/cows.4dm", 314, 479, "void", "&A:p_cows &A:p_random &A:p_events I:p_cow R:p_player_x R:p_player_y R:p_player_z R:p_dt",
                              "void cow_update(Attributes &p_cows, Attributes &p_random, Attributes &p_events, Integer p_cow, Real p_player_x, Real p_player_y, Real p_player_z, Real p_dt)", 0, "", "angle_of, cow_set_position, emit_event, floor_integer, max_real, min_real, mob_half_width, mob_height, mob_kind, physics_box_in_water, physics_move_box, random_between, random_next, record_integer_at, record_real_at, record_set_integer_at, record_set_real_at, world_get_block, world_is_solid, wrap_angle");
  if (p_id == 385) test_info_set(p_info, "cows_update", "macro", "mobs", "cows", "src/mobs/cows.4dm", 481, 538, "void", "&A:p_cows &A:p_random &A:p_events R:p_player_x R:p_player_y R:p_player_z I:p_night I:p_leave_player R:p_dt",
                              "void cows_update(Attributes &p_cows, Attributes &p_random, Attributes &p_events, Real p_player_x, Real p_player_y, Real p_player_z, Integer p_night, Integer p_leave_player, Real p_dt)", 0, "", "cow_alive, cow_position, cow_update, cows_alive_count, cows_spawn_random, mob_kind, mobs_count_kind, mobs_spawn_random, record_real, record_set_real, slots_at, slots_count, world_dimension, zombie_sunlight, zombies_spawn_near");
  if (p_id == 386) test_info_set(p_info, "cows_ray_hit", "macro", "mobs", "cows", "src/mobs/cows.4dm", 540, 573, "Integer", "&A:p_cows R:p_origin_x R:p_origin_y R:p_origin_z R:p_dir_x R:p_dir_y R:p_dir_z R:p_max_distance &R:p_distance",
                              "Integer cows_ray_hit(Attributes &p_cows, Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_max_distance, Real &p_distance)", 0, "", "cow_position, mob_half_width, mob_height, mob_kind, physics_ray_box, slots_at, slots_count");
  if (p_id == 387) test_info_set(p_info, "cow_damage", "macro", "mobs", "cows", "src/mobs/cows.4dm", 575, 611, "void", "&A:p_cows &A:p_events &A:p_random I:p_cow I:p_amount R:p_push_x R:p_push_z",
                              "void cow_damage(Attributes &p_cows, Attributes &p_events, Attributes &p_random, Integer p_cow, Integer p_amount, Real p_push_x, Real p_push_z)", 0, "", "cow_alive, cow_position, emit_event, mob_kind, mob_set_used, random_between, record_integer_at, record_set_integer_at, record_set_real_at");
  if (p_id == 388) test_info_set(p_info, "cows_box_overlaps", "macro", "mobs", "cows", "src/mobs/cows.4dm", 613, 637, "Integer", "&A:p_cows R:p_min_x R:p_min_y R:p_min_z R:p_max_x R:p_max_y R:p_max_z",
                              "Integer cows_box_overlaps(Attributes &p_cows, Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)", 0, "", "cow_position, mob_half_width, mob_height, mob_kind, slots_at, slots_count");
  if (p_id == 389) test_info_set(p_info, "cows_on_event", "macro", "mobs", "cows", "src/mobs/cows.4dm", 639, 650, "void", "&A:p_event &A:p_cows &A:p_random &A:p_events",
                              "void cows_on_event(Attributes &p_event, Attributes &p_cows, Attributes &p_random, Attributes &p_events)", 0, "", "emit_toast, event_integer, event_real, event_type, mobs_spawn");
  if (p_id == 390) test_info_set(p_info, "lan_run_name", "macro", "net", "lan", "src/net/lan.4dm", 12, 22, "Text", "R:p_now",
                              "Text lan_run_name(Real p_now)", 0, "", "");
  if (p_id == 391) test_info_set(p_info, "lan_word", "macro", "net", "lan", "src/net/lan.4dm", 24, 48, "Text", "T:p_text",
                              "Text lan_word(Text p_text)", 0, "", "");
  if (p_id == 392) test_info_set(p_info, "lan_folder", "macro", "net", "lan", "src/net/lan.4dm", 50, 58, "Text", "T:p_dir",
                              "Text lan_folder(Text p_dir)", 0, "", "");
  if (p_id == 393) test_info_set(p_info, "lan_scan_dir", "macro", "net", "lan", "src/net/lan.4dm", 60, 66, "Text", "T:p_run",
                              "Text lan_scan_dir(Text p_run)", 0, "", "");
  if (p_id == 394) test_info_set(p_info, "lan_host_dir", "macro", "net", "lan", "src/net/lan.4dm", 68, 74, "Text", "T:p_session",
                              "Text lan_host_dir(Text p_session)", 0, "", "");
  if (p_id == 395) test_info_set(p_info, "lan_join_dir", "macro", "net", "lan", "src/net/lan.4dm", 76, 82, "Text", "T:p_run",
                              "Text lan_join_dir(Text p_run)", 0, "", "");
  if (p_id == 396) test_info_set(p_info, "lan_write_control", "macro", "net", "lan", "src/net/lan.4dm", 84, 96, "Integer", "T:p_folder T:p_run T:p_word",
                              "Integer lan_write_control(Text p_folder, Text p_run, Text p_word)", 1, "", "");
  if (p_id == 397) test_info_set(p_info, "lan_read_status", "macro", "net", "lan", "src/net/lan.4dm", 98, 128, "Integer", "T:p_folder T:p_run &T:p_state &T:p_detail",
                              "Integer lan_read_status(Text p_folder, Text p_run, Text &p_state, Text &p_detail)", 0, "", "net_rest_of_line");
  if (p_id == 398) test_info_set(p_info, "lan_status_problem", "macro", "net", "lan", "src/net/lan.4dm", 130, 144, "Text", "T:p_state T:p_detail",
                              "Text lan_status_problem(Text p_state, Text p_detail)", 0, "", "");
  if (p_id == 399) test_info_set(p_info, "lan_run_clear", "macro", "net", "lan", "src/net/lan.4dm", 148, 163, "void", "&A:p_run",
                              "void lan_run_clear(Attributes &p_run)", 0, "", "record_clear, record_set_integer, record_set_real, record_set_text");
  if (p_id == 400) test_info_set(p_info, "lan_run_start", "macro", "net", "lan", "src/net/lan.4dm", 165, 189, "Integer", "&A:p_run T:p_system_root T:p_mode T:p_dir T:p_run_name T:p_session T:p_id T:p_address I:p_port R:p_now",
                              "Integer lan_run_start(Attributes &p_run, Text p_system_root, Text p_mode, Text p_dir, Text p_run_name, Text p_session, Text p_id, Text p_address, Integer p_port, Real p_now)", 1, "", "lan_folder, lan_run_clear, lan_run_stop, lan_write_control, record_set_integer, record_set_real, record_set_text");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 361) {   // inventory_equip
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = inventory_equip(g_inventory, l_i1);
    Get_time(l_end);
  } else if (p_id == 362) {   // inventory_swap_hands
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    inventory_swap_hands(g_inventory, l_i1);
    Get_time(l_end);
  } else if (p_id == 363) {   // cows_clear
    Get_time(l_start);
    cows_clear(g_cows);
    Get_time(l_end);
  } else if (p_id == 364) {   // mobs_rebuild_index
    Get_time(l_start);
    mobs_rebuild_index(g_cows);
    Get_time(l_end);
  } else if (p_id == 365) {   // mobs_split_legacy
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    mobs_split_legacy(g_cows, g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 366) {   // mob_set_used
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    mob_set_used(g_cows, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 367) {   // cow_alive
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = cow_alive(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 368) {   // cow_position
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
  } else if (p_id == 369) {   // cow_set_position
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    cow_set_position(g_cows, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 370) {   // cow_yaw
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = cow_yaw(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 371) {   // cow_flash
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = cow_flash(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 372) {   // cow_step
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = cow_step(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 373) {   // cows_alive_count
    Get_time(l_start);
    l_ret_i = cows_alive_count(g_cows);
    Get_time(l_end);
  } else if (p_id == 374) {   // mob_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = mob_kind(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 375) {   // mob_half_width
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = mob_half_width(l_i1);
    Get_time(l_end);
  } else if (p_id == 376) {   // mob_height
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = mob_height(l_i1);
    Get_time(l_end);
  } else if (p_id == 377) {   // mobs_count_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = mobs_count_kind(g_cows, l_i1);
    Get_time(l_end);
  } else if (p_id == 378) {   // cows_spawn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = cows_spawn(g_cows, g_random, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 379) {   // mobs_spawn
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = mobs_spawn(g_cows, g_random, l_i1, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 380) {   // cows_spawn_random
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_i = cows_spawn_random(g_cows, g_random, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 381) {   // mobs_spawn_random
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_i = mobs_spawn_random(g_cows, g_random, l_i1, l_i2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 382) {   // zombies_spawn_near
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = zombies_spawn_near(g_cows, g_random, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 383) {   // zombie_sunlight
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    zombie_sunlight(g_cows, g_events, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 384) {   // cow_update
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    cow_update(g_cows, g_random, g_events, l_i1, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 385) {   // cows_update
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    cows_update(g_cows, g_random, g_events, l_r1, l_r2, l_r3, l_i1, l_i2, l_r4);
    Get_time(l_end);
  } else if (p_id == 386) {   // cows_ray_hit
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
  } else if (p_id == 387) {   // cow_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    cow_damage(g_cows, g_events, g_random, l_i1, l_i2, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 388) {   // cows_box_overlaps
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    l_ret_i = cows_box_overlaps(g_cows, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
  } else if (p_id == 389) {   // cows_on_event
    Get_time(l_start);
    cows_on_event(g_event, g_cows, g_random, g_events);
    Get_time(l_end);
  } else if (p_id == 390) {   // lan_run_name
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_t = lan_run_name(l_r1);
    Get_time(l_end);
  } else if (p_id == 391) {   // lan_word
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = lan_word(l_t1);
    Get_time(l_end);
  } else if (p_id == 392) {   // lan_folder
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = lan_folder(l_t1);
    Get_time(l_end);
  } else if (p_id == 393) {   // lan_scan_dir
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = lan_scan_dir(l_t1);
    Get_time(l_end);
  } else if (p_id == 394) {   // lan_host_dir
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = lan_host_dir(l_t1);
    Get_time(l_end);
  } else if (p_id == 395) {   // lan_join_dir
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = lan_join_dir(l_t1);
    Get_time(l_end);
  } else if (p_id == 396) {   // lan_write_control
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = lan_write_control(l_t1, l_t2, l_t3);
    Get_time(l_end);
  } else if (p_id == 397) {   // lan_read_status
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    Get_time(l_start);
    l_ret_i = lan_read_status(l_t1, l_t2, l_t3, l_t4);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
    record_set_text(p_out, ATTR_TEST_T4, l_t4);
  } else if (p_id == 398) {   // lan_status_problem
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = lan_status_problem(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 399) {   // lan_run_clear
    Get_time(l_start);
    lan_run_clear(g_test_record);
    Get_time(l_end);
  } else if (p_id == 400) {   // lan_run_start
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    l_t6 = record_text(p_in, ATTR_TEST_T6);
    l_t7 = record_text(p_in, ATTR_TEST_T7);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = lan_run_start(g_test_record, l_t1, l_t2, l_t3, l_t4, l_t5, l_t6, l_t7, l_i1, l_r1);
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
  if (p_id == 401) test_info_set(p_info, "lan_run_stop", "macro", "net", "lan", "src/net/lan.4dm", 191, 199, "void", "&A:p_run",
                              "void lan_run_stop(Attributes &p_run)", 1, "", "lan_run_active, lan_write_control, record_set_integer, record_text");
  if (p_id == 402) test_info_set(p_info, "lan_run_active", "macro", "net", "lan", "src/net/lan.4dm", 201, 208, "Integer", "&A:p_run",
                              "Integer lan_run_active(Attributes &p_run)", 0, "", "record_integer");
  if (p_id == 403) test_info_set(p_info, "lan_run_folder", "macro", "net", "lan", "src/net/lan.4dm", 210, 216, "Text", "&A:p_run",
                              "Text lan_run_folder(Attributes &p_run)", 0, "", "record_text");
  if (p_id == 404) test_info_set(p_info, "lan_run_state", "macro", "net", "lan", "src/net/lan.4dm", 218, 224, "Text", "&A:p_run",
                              "Text lan_run_state(Attributes &p_run)", 0, "", "record_text");
  if (p_id == 405) test_info_set(p_info, "lan_run_check", "macro", "net", "lan", "src/net/lan.4dm", 226, 251, "Text", "&A:p_run R:p_now",
                              "Text lan_run_check(Attributes &p_run, Real p_now)", 0, "", "lan_read_status, lan_run_active, lan_run_folder, lan_status_problem, record_integer, record_real, record_set_integer, record_set_real, record_set_text, record_text");
  if (p_id == 406) test_info_set(p_info, "net_clear", "macro", "net", "net", "src/net/net.4dm", 15, 28, "void", "&A:p_net &A:p_peers &A:p_inbox",
                              "void net_clear(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox)", 0, "", "record_clear, record_set_integer, record_set_text");
  if (p_id == 407) test_info_set(p_info, "net_mode", "macro", "net", "net", "src/net/net.4dm", 30, 36, "Integer", "&A:p_net",
                              "Integer net_mode(Attributes &p_net)", 0, "", "record_integer");
  if (p_id == 408) test_info_set(p_info, "net_clean_name", "macro", "net", "net", "src/net/net.4dm", 38, 58, "Text", "T:p_name",
                              "Text net_clean_name(Text p_name)", 0, "", "");
  if (p_id == 409) test_info_set(p_info, "net_session_path", "macro", "net", "net", "src/net/net.4dm", 60, 66, "Text", "T:p_folder T:p_session",
                              "Text net_session_path(Text p_folder, Text p_session)", 0, "", "");
  if (p_id == 410) test_info_set(p_info, "net_snapshot_path", "macro", "net", "net", "src/net/net.4dm", 68, 74, "Text", "T:p_folder T:p_session",
                              "Text net_snapshot_path(Text p_folder, Text p_session)", 0, "", "");
  if (p_id == 411) test_info_set(p_info, "net_log_name", "macro", "net", "net", "src/net/net.4dm", 76, 82, "Text", "T:p_session T:p_id",
                              "Text net_log_name(Text p_session, Text p_id)", 0, "", "");
  if (p_id == 412) test_info_set(p_info, "net_ensure_folder", "macro", "net", "net", "src/net/net.4dm", 84, 96, "Integer", "T:p_folder",
                              "Integer net_ensure_folder(Text p_folder)", 1, "", "");
  if (p_id == 413) test_info_set(p_info, "net_write_session", "macro", "net", "net", "src/net/net.4dm", 98, 121, "Integer", "T:p_folder T:p_session T:p_host_id T:p_host_name I:p_seed T:p_world_name I:p_mode I:p_cheats I:p_open",
                              "Integer net_write_session(Text p_folder, Text p_session, Text p_host_id, Text p_host_name, Integer p_seed, Text p_world_name, Integer p_mode, Integer p_cheats, Integer p_open)", 1, "", "net_session_path");
  if (p_id == 414) test_info_set(p_info, "net_read_session", "macro", "net", "net", "src/net/net.4dm", 123, 179, "Integer", "T:p_path &T:p_session &T:p_host_id &T:p_host_name &I:p_seed &T:p_world_name &I:p_mode &I:p_cheats &I:p_open &T:p_problem",
                              "Integer net_read_session(Text p_path, Text &p_session, Text &p_host_id, Text &p_host_name, Integer &p_seed, Text &p_world_name, Integer &p_mode, Integer &p_cheats, Integer &p_open, Text &p_problem)", 0, "", "net_rest_of_line, net_word_integer");
  if (p_id == 415) test_info_set(p_info, "net_read_session_address", "macro", "net", "net", "src/net/net.4dm", 181, 208, "Integer", "T:p_path &T:p_address &I:p_port",
                              "Integer net_read_session_address(Text p_path, Text &p_address, Integer &p_port)", 0, "", "net_word_integer");
  if (p_id == 416) test_info_set(p_info, "net_list_lan", "macro", "net", "net", "src/net/net.4dm", 210, 250, "Integer", "T:p_folder &A:p_list",
                              "Integer net_list_lan(Text p_folder, Attributes &p_list)", 0, "", "file_title_from_path, net_read_session, record_clear, record_set_integer, record_set_integer_at, record_set_text_at");
  if (p_id == 417) test_info_set(p_info, "net_set_session", "macro", "net", "net", "src/net/net.4dm", 252, 262, "void", "&A:p_net I:p_seed T:p_world I:p_mode I:p_cheats",
                              "void net_set_session(Attributes &p_net, Integer p_seed, Text p_world, Integer p_mode, Integer p_cheats)", 0, "", "record_set_integer, record_set_text");
  if (p_id == 418) test_info_set(p_info, "net_cheats", "macro", "net", "net", "src/net/net.4dm", 264, 272, "Integer", "&A:p_net",
                              "Integer net_cheats(Attributes &p_net)", 0, "", "net_mode, record_integer");
  if (p_id == 419) test_info_set(p_info, "net_start", "macro", "net", "net", "src/net/net.4dm", 274, 296, "void", "&A:p_net &A:p_peers &A:p_inbox I:p_mode T:p_folder T:p_session T:p_host_id T:p_id T:p_name R:p_now",
                              "void net_start(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Integer p_mode, Text p_folder, Text p_session, Text p_host_id, Text p_id, Text p_name, Real p_now)", 1, "", "net_clear, net_flush, net_log_name, net_queue, record_set_integer, record_set_real, record_set_text");
  if (p_id == 420) test_info_set(p_info, "net_queue", "macro", "net", "net", "src/net/net.4dm", 300, 311, "void", "&A:p_net T:p_line",
                              "void net_queue(Attributes &p_net, Text p_line)", 0, "", "net_mode, record_integer, record_set_integer, record_set_text_at");
  if (p_id == 421) test_info_set(p_info, "net_flush", "macro", "net", "net", "src/net/net.4dm", 313, 338, "Integer", "&A:p_net",
                              "Integer net_flush(Attributes &p_net)", 1, "", "net_log_name, net_mode, record_integer, record_set_integer, record_set_text, record_text, record_text_at");
  if (p_id == 422) test_info_set(p_info, "net_leave", "macro", "net", "net", "src/net/net.4dm", 340, 354, "void", "&A:p_net",
                              "void net_leave(Attributes &p_net)", 1, "", "net_flush, net_mode, net_queue, net_write_session, record_integer, record_set_integer, record_text");
  if (p_id == 423) test_info_set(p_info, "net_whisper", "macro", "net", "net", "src/net/net.4dm", 356, 373, "Text", "&A:p_net &A:p_peers T:p_to T:p_text",
                              "Text net_whisper(Attributes &p_net, Attributes &p_peers, Text p_to, Text p_text)", 0, "", "net_clean_name, net_mode, net_queue, peer_here, peer_name, peers_count");
  if (p_id == 424) test_info_set(p_info, "net_say", "macro", "net", "net", "src/net/net.4dm", 375, 381, "void", "&A:p_net T:p_text",
                              "void net_say(Attributes &p_net, Text p_text)", 0, "", "net_queue");
  if (p_id == 425) test_info_set(p_info, "net_send_state", "macro", "net", "net", "src/net/net.4dm", 383, 425, "void", "&A:p_net &A:p_player &A:p_info R:p_now",
                              "void net_send_state(Attributes &p_net, Attributes &p_player, Attributes &p_info, Real p_now)", 0, "", "net_mode, net_queue, player_look, player_position, record_real, record_set_real, world_dimension, world_time_of_day");
  if (p_id == 426) test_info_set(p_info, "net_on_event", "macro", "net", "net", "src/net/net.4dm", 427, 443, "void", "&A:p_event &A:p_net",
                              "void net_on_event(Attributes &p_event, Attributes &p_net)", 0, "", "event_integer, event_is_remote, event_type, net_mode, net_queue, world_dimension, world_get_block");
  if (p_id == 427) test_info_set(p_info, "net_find_peer", "macro", "net", "net", "src/net/net.4dm", 447, 458, "Integer", "&A:p_peers T:p_file",
                              "Integer net_find_peer(Attributes &p_peers, Text p_file)", 0, "", "peers_count, record_text_at");
  if (p_id == 428) test_info_set(p_info, "net_add_peer", "macro", "net", "net", "src/net/net.4dm", 460, 486, "Integer", "&A:p_peers T:p_file R:p_now",
                              "Integer net_add_peer(Attributes &p_peers, Text p_file, Real p_now)", 0, "", "peers_count, record_set_integer, record_set_integer_at, record_set_real_at, record_set_text_at");
  if (p_id == 429) test_info_set(p_info, "net_scan", "macro", "net", "net", "src/net/net.4dm", 488, 512, "void", "&A:p_net &A:p_peers R:p_now",
                              "void net_scan(Attributes &p_net, Attributes &p_peers, Real p_now)", 0, "", "file_title_from_path, net_add_peer, net_find_peer, net_log_name, record_text");
  if (p_id == 430) test_info_set(p_info, "net_inbox_add", "macro", "net", "net", "src/net/net.4dm", 514, 524, "void", "&A:p_inbox I:p_peer T:p_line",
                              "void net_inbox_add(Attributes &p_inbox, Integer p_peer, Text p_line)", 0, "", "record_integer, record_set_integer, record_set_integer_at, record_set_text_at");
  if (p_id == 431) test_info_set(p_info, "net_read_peer", "macro", "net", "net", "src/net/net.4dm", 526, 557, "Integer", "&A:p_net &A:p_peers &A:p_inbox I:p_peer",
                              "Integer net_read_peer(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Integer p_peer)", 0, "", "net_inbox_add, record_integer_at, record_set_integer_at, record_text, record_text_at");
  if (p_id == 432) test_info_set(p_info, "net_poll", "macro", "net", "net", "src/net/net.4dm", 559, 576, "void", "&A:p_net &A:p_peers &A:p_inbox R:p_now",
                              "void net_poll(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Real p_now)", 0, "", "net_mode, net_read_peer, net_scan, peers_count, record_real, record_set_real");
  if (p_id == 433) test_info_set(p_info, "net_word_real", "macro", "net", "net", "src/net/net.4dm", 580, 595, "Real", "&D:p_words I:p_position",
                              "Real net_word_real(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 434) test_info_set(p_info, "net_word_integer", "macro", "net", "net", "src/net/net.4dm", 597, 612, "Integer", "&D:p_words I:p_position",
                              "Integer net_word_integer(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 435) test_info_set(p_info, "net_rest_of_line", "macro", "net", "net", "src/net/net.4dm", 614, 624, "Text", "T:p_line",
                              "Text net_rest_of_line(Text p_line)", 0, "", "");
  if (p_id == 436) test_info_set(p_info, "net_apply_line", "macro", "net", "net", "src/net/net.4dm", 626, 693, "void", "&A:p_net &A:p_peers I:p_peer T:p_line &A:p_info &A:p_hud &A:p_events R:p_now",
                              "void net_apply_line(Attributes &p_net, Attributes &p_peers, Integer p_peer, Text p_line, Attributes &p_info, Attributes &p_hud, Attributes &p_events, Real p_now)", 0, "", "hud_chat, hud_toast, net_clean_name, net_rest_of_line, net_word_integer, net_word_real, peer_here, peer_name, record_real_at, record_set_integer_at, record_set_real_at, record_set_text_at, record_text, record_text_at, world_apply_remote_block, world_dimension, world_set_time_of_day");
  if (p_id == 437) test_info_set(p_info, "net_apply", "macro", "net", "net", "src/net/net.4dm", 695, 735, "void", "&A:p_net &A:p_peers &A:p_inbox &A:p_info &A:p_hud &A:p_events R:p_dt R:p_now",
                              "void net_apply(Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Attributes &p_info, Attributes &p_hud, Attributes &p_events, Real p_dt, Real p_now)", 0, "", "hud_chat, min_real, net_apply_line, peer_here, peer_name, peer_position, peer_step, peers_count, record_clear, record_integer, record_integer_at, record_real_at, record_set_integer, record_set_integer_at, record_set_real_at, record_text_at");
  if (p_id == 438) test_info_set(p_info, "peers_count", "macro", "net", "net", "src/net/net.4dm", 739, 745, "Integer", "&A:p_peers",
                              "Integer peers_count(Attributes &p_peers)", 0, "", "record_integer");
  if (p_id == 439) test_info_set(p_info, "peer_here", "macro", "net", "net", "src/net/net.4dm", 747, 753, "Integer", "&A:p_peers I:p_peer",
                              "Integer peer_here(Attributes &p_peers, Integer p_peer)", 0, "", "record_integer_at");
  if (p_id == 440) test_info_set(p_info, "peer_dimension", "macro", "net", "net", "src/net/net.4dm", 755, 761, "Integer", "&A:p_peers I:p_peer",
                              "Integer peer_dimension(Attributes &p_peers, Integer p_peer)", 0, "", "record_integer_at");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 401) {   // lan_run_stop
    Get_time(l_start);
    lan_run_stop(g_test_record);
    Get_time(l_end);
  } else if (p_id == 402) {   // lan_run_active
    Get_time(l_start);
    l_ret_i = lan_run_active(g_test_record);
    Get_time(l_end);
  } else if (p_id == 403) {   // lan_run_folder
    Get_time(l_start);
    l_ret_t = lan_run_folder(g_test_record);
    Get_time(l_end);
  } else if (p_id == 404) {   // lan_run_state
    Get_time(l_start);
    l_ret_t = lan_run_state(g_test_record);
    Get_time(l_end);
  } else if (p_id == 405) {   // lan_run_check
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_t = lan_run_check(g_test_record, l_r1);
    Get_time(l_end);
  } else if (p_id == 406) {   // net_clear
    Get_time(l_start);
    net_clear(g_net, g_peers, g_net_inbox);
    Get_time(l_end);
  } else if (p_id == 407) {   // net_mode
    Get_time(l_start);
    l_ret_i = net_mode(g_net);
    Get_time(l_end);
  } else if (p_id == 408) {   // net_clean_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = net_clean_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 409) {   // net_session_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = net_session_path(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 410) {   // net_snapshot_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = net_snapshot_path(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 411) {   // net_log_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = net_log_name(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 412) {   // net_ensure_folder
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = net_ensure_folder(l_t1);
    Get_time(l_end);
  } else if (p_id == 413) {   // net_write_session
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = net_write_session(l_t1, l_t2, l_t3, l_t4, l_i1, l_t5, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 414) {   // net_read_session
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_t6 = record_text(p_in, ATTR_TEST_T6);
    Get_time(l_start);
    l_ret_i = net_read_session(l_t1, l_t2, l_t3, l_t4, l_i1, l_t5, l_i2, l_i3, l_i4, l_t6);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
    record_set_text(p_out, ATTR_TEST_T4, l_t4);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_text(p_out, ATTR_TEST_T5, l_t5);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
    record_set_text(p_out, ATTR_TEST_T6, l_t6);
  } else if (p_id == 415) {   // net_read_session_address
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = net_read_session_address(l_t1, l_t2, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 416) {   // net_list_lan
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = net_list_lan(l_t1, g_test_record);
    Get_time(l_end);
  } else if (p_id == 417) {   // net_set_session
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    net_set_session(g_net, l_i1, l_t1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 418) {   // net_cheats
    Get_time(l_start);
    l_ret_i = net_cheats(g_net);
    Get_time(l_end);
  } else if (p_id == 419) {   // net_start
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
  } else if (p_id == 420) {   // net_queue
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    net_queue(g_net, l_t1);
    Get_time(l_end);
  } else if (p_id == 421) {   // net_flush
    Get_time(l_start);
    l_ret_i = net_flush(g_net);
    Get_time(l_end);
  } else if (p_id == 422) {   // net_leave
    Get_time(l_start);
    net_leave(g_net);
    Get_time(l_end);
  } else if (p_id == 423) {   // net_whisper
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_t = net_whisper(g_net, g_peers, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 424) {   // net_say
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    net_say(g_net, l_t1);
    Get_time(l_end);
  } else if (p_id == 425) {   // net_send_state
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_send_state(g_net, g_player, g_info, l_r1);
    Get_time(l_end);
  } else if (p_id == 426) {   // net_on_event
    Get_time(l_start);
    net_on_event(g_event, g_net);
    Get_time(l_end);
  } else if (p_id == 427) {   // net_find_peer
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = net_find_peer(g_peers, l_t1);
    Get_time(l_end);
  } else if (p_id == 428) {   // net_add_peer
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = net_add_peer(g_peers, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 429) {   // net_scan
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_scan(g_net, g_peers, l_r1);
    Get_time(l_end);
  } else if (p_id == 430) {   // net_inbox_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    net_inbox_add(g_net_inbox, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 431) {   // net_read_peer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = net_read_peer(g_net, g_peers, g_net_inbox, l_i1);
    Get_time(l_end);
  } else if (p_id == 432) {   // net_poll
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_poll(g_net, g_peers, g_net_inbox, l_r1);
    Get_time(l_end);
  } else if (p_id == 433) {   // net_word_real
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = net_word_real(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 434) {   // net_word_integer
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = net_word_integer(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 435) {   // net_rest_of_line
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = net_rest_of_line(l_t1);
    Get_time(l_end);
  } else if (p_id == 436) {   // net_apply_line
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    net_apply_line(g_net, g_peers, l_i1, l_t1, g_info, g_hud, g_events, l_r1);
    Get_time(l_end);
  } else if (p_id == 437) {   // net_apply
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    net_apply(g_net, g_peers, g_net_inbox, g_info, g_hud, g_events, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 438) {   // peers_count
    Get_time(l_start);
    l_ret_i = peers_count(g_peers);
    Get_time(l_end);
  } else if (p_id == 439) {   // peer_here
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = peer_here(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 440) {   // peer_dimension
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = peer_dimension(g_peers, l_i1);
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
  if (p_id == 441) test_info_set(p_info, "peer_name", "macro", "net", "net", "src/net/net.4dm", 763, 769, "Text", "&A:p_peers I:p_peer",
                              "Text peer_name(Attributes &p_peers, Integer p_peer)", 0, "", "record_text_at");
  if (p_id == 442) test_info_set(p_info, "peer_position", "macro", "net", "net", "src/net/net.4dm", 771, 779, "void", "&A:p_peers I:p_peer &R:p_x &R:p_y &R:p_z",
                              "void peer_position(Attributes &p_peers, Integer p_peer, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real_at");
  if (p_id == 443) test_info_set(p_info, "peer_yaw", "macro", "net", "net", "src/net/net.4dm", 781, 787, "Real", "&A:p_peers I:p_peer",
                              "Real peer_yaw(Attributes &p_peers, Integer p_peer)", 0, "", "record_real_at");
  if (p_id == 444) test_info_set(p_info, "peer_pitch", "macro", "net", "net", "src/net/net.4dm", 789, 795, "Real", "&A:p_peers I:p_peer",
                              "Real peer_pitch(Attributes &p_peers, Integer p_peer)", 0, "", "record_real_at");
  if (p_id == 445) test_info_set(p_info, "peer_step", "macro", "net", "net", "src/net/net.4dm", 797, 803, "Real", "&A:p_peers I:p_peer",
                              "Real peer_step(Attributes &p_peers, Integer p_peer)", 0, "", "record_real_at");
  if (p_id == 446) test_info_set(p_info, "net_players_text", "macro", "net", "net", "src/net/net.4dm", 805, 827, "Text", "&A:p_net &A:p_peers R:p_now",
                              "Text net_players_text(Attributes &p_net, Attributes &p_peers, Real p_now)", 0, "", "net_mode, peer_here, peer_name, peers_count, record_real_at, record_text");
  if (p_id == 447) test_info_set(p_info, "player_reset", "macro", "player", "player", "src/player/player.4dm", 18, 75, "void", "&A:p_player R:p_x R:p_y R:p_z",
                              "void player_reset(Attributes &p_player, Real p_x, Real p_y, Real p_z)", 0, "", "player_set_auto_walk, player_set_fall_peak, player_set_health, player_set_look, player_set_position, player_set_selected, player_set_velocity, record_clear, record_integer, record_real, record_set_integer, record_set_real, record_set_text");
  if (p_id == 448) test_info_set(p_info, "player_position", "macro", "player", "player", "src/player/player.4dm", 77, 85, "void", "&A:p_player &R:p_x &R:p_y &R:p_z",
                              "void player_position(Attributes &p_player, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real");
  if (p_id == 449) test_info_set(p_info, "player_set_position", "macro", "player", "player", "src/player/player.4dm", 87, 95, "void", "&A:p_player R:p_x R:p_y R:p_z",
                              "void player_set_position(Attributes &p_player, Real p_x, Real p_y, Real p_z)", 0, "", "record_set_real");
  if (p_id == 450) test_info_set(p_info, "player_velocity", "macro", "player", "player", "src/player/player.4dm", 97, 105, "void", "&A:p_player &R:p_vx &R:p_vy &R:p_vz",
                              "void player_velocity(Attributes &p_player, Real &p_vx, Real &p_vy, Real &p_vz)", 0, "", "record_real");
  if (p_id == 451) test_info_set(p_info, "player_set_velocity", "macro", "player", "player", "src/player/player.4dm", 107, 115, "void", "&A:p_player R:p_vx R:p_vy R:p_vz",
                              "void player_set_velocity(Attributes &p_player, Real p_vx, Real p_vy, Real p_vz)", 0, "", "record_set_real");
  if (p_id == 452) test_info_set(p_info, "player_look", "macro", "player", "player", "src/player/player.4dm", 117, 124, "void", "&A:p_player &R:p_yaw &R:p_pitch",
                              "void player_look(Attributes &p_player, Real &p_yaw, Real &p_pitch)", 0, "", "record_real");
  if (p_id == 453) test_info_set(p_info, "player_set_look", "macro", "player", "player", "src/player/player.4dm", 126, 133, "void", "&A:p_player R:p_yaw R:p_pitch",
                              "void player_set_look(Attributes &p_player, Real p_yaw, Real p_pitch)", 0, "", "record_set_real");
  if (p_id == 454) test_info_set(p_info, "player_eye_y", "macro", "player", "player", "src/player/player.4dm", 135, 142, "Real", "&A:p_player",
                              "Real player_eye_y(Attributes &p_player)", 0, "", "player_crouching, record_real");
  if (p_id == 455) test_info_set(p_info, "player_crouching", "macro", "player", "player", "src/player/player.4dm", 144, 151, "Integer", "&A:p_player",
                              "Integer player_crouching(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 456) test_info_set(p_info, "player_look_direction", "macro", "player", "player", "src/player/player.4dm", 153, 165, "void", "&A:p_player &R:p_dir_x &R:p_dir_y &R:p_dir_z",
                              "void player_look_direction(Attributes &p_player, Real &p_dir_x, Real &p_dir_y, Real &p_dir_z)", 0, "", "player_look");
  if (p_id == 457) test_info_set(p_info, "player_health", "macro", "player", "player", "src/player/player.4dm", 167, 173, "Integer", "&A:p_player",
                              "Integer player_health(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 458) test_info_set(p_info, "player_set_health", "macro", "player", "player", "src/player/player.4dm", 175, 181, "void", "&A:p_player I:p_health",
                              "void player_set_health(Attributes &p_player, Integer p_health)", 0, "", "clamp_integer, record_set_integer");
  if (p_id == 459) test_info_set(p_info, "player_is_dead", "macro", "player", "player", "src/player/player.4dm", 183, 189, "Integer", "&A:p_player",
                              "Integer player_is_dead(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 460) test_info_set(p_info, "player_on_ground", "macro", "player", "player", "src/player/player.4dm", 191, 197, "Integer", "&A:p_player",
                              "Integer player_on_ground(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 461) test_info_set(p_info, "player_in_water", "macro", "player", "player", "src/player/player.4dm", 199, 205, "Integer", "&A:p_player",
                              "Integer player_in_water(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 462) test_info_set(p_info, "player_eye_in_water", "macro", "player", "player", "src/player/player.4dm", 207, 213, "Integer", "&A:p_player",
                              "Integer player_eye_in_water(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 463) test_info_set(p_info, "player_hurt_time", "macro", "player", "player", "src/player/player.4dm", 215, 221, "Real", "&A:p_player",
                              "Real player_hurt_time(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 464) test_info_set(p_info, "player_swing_time", "macro", "player", "player", "src/player/player.4dm", 223, 229, "Real", "&A:p_player",
                              "Real player_swing_time(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 465) test_info_set(p_info, "player_bob", "macro", "player", "player", "src/player/player.4dm", 231, 237, "Real", "&A:p_player",
                              "Real player_bob(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 466) test_info_set(p_info, "player_body_yaw", "macro", "player", "player", "src/player/player.4dm", 239, 245, "Real", "&A:p_player",
                              "Real player_body_yaw(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 467) test_info_set(p_info, "player_stride", "macro", "player", "player", "src/player/player.4dm", 247, 253, "Real", "&A:p_player",
                              "Real player_stride(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 468) test_info_set(p_info, "player_step", "macro", "player", "player", "src/player/player.4dm", 255, 262, "Real", "&A:p_player",
                              "Real player_step(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 469) test_info_set(p_info, "player_update_body", "macro", "player", "player", "src/player/player.4dm", 264, 293, "void", "&A:p_player I:p_walking R:p_dt",
                              "void player_update_body(Attributes &p_player, Integer p_walking, Real p_dt)", 0, "", "angle_difference, min_real, player_look, record_real, record_set_real, wrap_angle");
  if (p_id == 470) test_info_set(p_info, "player_fall_peak", "macro", "player", "player", "src/player/player.4dm", 295, 301, "Real", "&A:p_player",
                              "Real player_fall_peak(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 471) test_info_set(p_info, "player_set_fall_peak", "macro", "player", "player", "src/player/player.4dm", 303, 309, "void", "&A:p_player R:p_peak",
                              "void player_set_fall_peak(Attributes &p_player, Real p_peak)", 0, "", "record_set_real");
  if (p_id == 472) test_info_set(p_info, "player_selected", "macro", "player", "player", "src/player/player.4dm", 311, 317, "Integer", "&A:p_player",
                              "Integer player_selected(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 473) test_info_set(p_info, "player_set_selected", "macro", "player", "player", "src/player/player.4dm", 319, 325, "void", "&A:p_player I:p_slot",
                              "void player_set_selected(Attributes &p_player, Integer p_slot)", 0, "", "clamp_integer, record_set_integer");
  if (p_id == 474) test_info_set(p_info, "player_auto_walk", "macro", "player", "player", "src/player/player.4dm", 327, 333, "Integer", "&A:p_player",
                              "Integer player_auto_walk(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 475) test_info_set(p_info, "player_set_auto_walk", "macro", "player", "player", "src/player/player.4dm", 335, 341, "void", "&A:p_player I:p_on",
                              "void player_set_auto_walk(Attributes &p_player, Integer p_on)", 0, "", "record_set_integer");
  if (p_id == 476) test_info_set(p_info, "player_held_item", "macro", "player", "player", "src/player/player.4dm", 343, 349, "Integer", "&A:p_player &A:p_inventory",
                              "Integer player_held_item(Attributes &p_player, Attributes &p_inventory)", 0, "", "player_selected, slot_item");
  if (p_id == 477) test_info_set(p_info, "player_target_kind", "macro", "player", "player", "src/player/player.4dm", 351, 357, "Integer", "&A:p_player",
                              "Integer player_target_kind(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 478) test_info_set(p_info, "player_target_cell", "macro", "player", "player", "src/player/player.4dm", 359, 367, "void", "&A:p_player &I:p_x &I:p_y &I:p_z",
                              "void player_target_cell(Attributes &p_player, Integer &p_x, Integer &p_y, Integer &p_z)", 0, "", "record_integer");
  if (p_id == 479) test_info_set(p_info, "player_target_normal", "macro", "player", "player", "src/player/player.4dm", 369, 377, "void", "&A:p_player &I:p_x &I:p_y &I:p_z",
                              "void player_target_normal(Attributes &p_player, Integer &p_x, Integer &p_y, Integer &p_z)", 0, "", "record_integer");
  if (p_id == 480) test_info_set(p_info, "player_target_cow", "macro", "player", "player", "src/player/player.4dm", 379, 385, "Integer", "&A:p_player",
                              "Integer player_target_cow(Attributes &p_player)", 0, "", "record_integer");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 441) {   // peer_name
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = peer_name(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 442) {   // peer_position
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
  } else if (p_id == 443) {   // peer_yaw
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = peer_yaw(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 444) {   // peer_pitch
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = peer_pitch(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 445) {   // peer_step
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = peer_step(g_peers, l_i1);
    Get_time(l_end);
  } else if (p_id == 446) {   // net_players_text
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_t = net_players_text(g_net, g_peers, l_r1);
    Get_time(l_end);
  } else if (p_id == 447) {   // player_reset
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_reset(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 448) {   // player_position
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_position(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 449) {   // player_set_position
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_set_position(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 450) {   // player_velocity
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_velocity(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 451) {   // player_set_velocity
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_set_velocity(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 452) {   // player_look
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    player_look(g_player, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 453) {   // player_set_look
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    player_set_look(g_player, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 454) {   // player_eye_y
    Get_time(l_start);
    l_ret_r = player_eye_y(g_player);
    Get_time(l_end);
  } else if (p_id == 455) {   // player_crouching
    Get_time(l_start);
    l_ret_i = player_crouching(g_player);
    Get_time(l_end);
  } else if (p_id == 456) {   // player_look_direction
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    player_look_direction(g_player, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 457) {   // player_health
    Get_time(l_start);
    l_ret_i = player_health(g_player);
    Get_time(l_end);
  } else if (p_id == 458) {   // player_set_health
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_health(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 459) {   // player_is_dead
    Get_time(l_start);
    l_ret_i = player_is_dead(g_player);
    Get_time(l_end);
  } else if (p_id == 460) {   // player_on_ground
    Get_time(l_start);
    l_ret_i = player_on_ground(g_player);
    Get_time(l_end);
  } else if (p_id == 461) {   // player_in_water
    Get_time(l_start);
    l_ret_i = player_in_water(g_player);
    Get_time(l_end);
  } else if (p_id == 462) {   // player_eye_in_water
    Get_time(l_start);
    l_ret_i = player_eye_in_water(g_player);
    Get_time(l_end);
  } else if (p_id == 463) {   // player_hurt_time
    Get_time(l_start);
    l_ret_r = player_hurt_time(g_player);
    Get_time(l_end);
  } else if (p_id == 464) {   // player_swing_time
    Get_time(l_start);
    l_ret_r = player_swing_time(g_player);
    Get_time(l_end);
  } else if (p_id == 465) {   // player_bob
    Get_time(l_start);
    l_ret_r = player_bob(g_player);
    Get_time(l_end);
  } else if (p_id == 466) {   // player_body_yaw
    Get_time(l_start);
    l_ret_r = player_body_yaw(g_player);
    Get_time(l_end);
  } else if (p_id == 467) {   // player_stride
    Get_time(l_start);
    l_ret_r = player_stride(g_player);
    Get_time(l_end);
  } else if (p_id == 468) {   // player_step
    Get_time(l_start);
    l_ret_r = player_step(g_player);
    Get_time(l_end);
  } else if (p_id == 469) {   // player_update_body
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_update_body(g_player, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 470) {   // player_fall_peak
    Get_time(l_start);
    l_ret_r = player_fall_peak(g_player);
    Get_time(l_end);
  } else if (p_id == 471) {   // player_set_fall_peak
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_set_fall_peak(g_player, l_r1);
    Get_time(l_end);
  } else if (p_id == 472) {   // player_selected
    Get_time(l_start);
    l_ret_i = player_selected(g_player);
    Get_time(l_end);
  } else if (p_id == 473) {   // player_set_selected
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_selected(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 474) {   // player_auto_walk
    Get_time(l_start);
    l_ret_i = player_auto_walk(g_player);
    Get_time(l_end);
  } else if (p_id == 475) {   // player_set_auto_walk
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_auto_walk(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 476) {   // player_held_item
    Get_time(l_start);
    l_ret_i = player_held_item(g_player, g_inventory);
    Get_time(l_end);
  } else if (p_id == 477) {   // player_target_kind
    Get_time(l_start);
    l_ret_i = player_target_kind(g_player);
    Get_time(l_end);
  } else if (p_id == 478) {   // player_target_cell
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    player_target_cell(g_player, l_i1, l_i2, l_i3);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
  } else if (p_id == 479) {   // player_target_normal
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    player_target_normal(g_player, l_i1, l_i2, l_i3);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
  } else if (p_id == 480) {   // player_target_cow
    Get_time(l_start);
    l_ret_i = player_target_cow(g_player);
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
  if (p_id == 481) test_info_set(p_info, "player_break_stage", "macro", "player", "player", "src/player/player.4dm", 387, 401, "Integer", "&A:p_player R:p_now",
                              "Integer player_break_stage(Attributes &p_player, Real p_now)", 0, "", "clamp_integer, floor_integer, record_integer, record_real");
  if (p_id == 482) test_info_set(p_info, "player_turn", "macro", "player", "player", "src/player/player.4dm", 405, 415, "void", "&A:p_player R:p_yaw_change R:p_pitch_change",
                              "void player_turn(Attributes &p_player, Real p_yaw_change, Real p_pitch_change)", 0, "", "clamp_real, player_look, player_set_look, wrap_angle");
  if (p_id == 483) test_info_set(p_info, "player_on_event", "macro", "player", "player", "src/player/player.4dm", 417, 437, "void", "&A:p_event &A:p_player &A:p_inventory &A:p_events",
                              "void player_on_event(Attributes &p_event, Attributes &p_player, Attributes &p_inventory, Attributes &p_events)", 0, "", "event_integer, event_real, event_type, inventory_armour_damage, inventory_wear_armour, player_damage, player_is_dead, player_set_velocity, player_survival, player_velocity");
  if (p_id == 484) test_info_set(p_info, "player_camera", "macro", "player", "player", "src/player/player.4dm", 439, 446, "Integer", "&A:p_player",
                              "Integer player_camera(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 485) test_info_set(p_info, "player_next_camera", "macro", "player", "player", "src/player/player.4dm", 448, 454, "void", "&A:p_player",
                              "void player_next_camera(Attributes &p_player)", 0, "", "player_camera, positive_mod, record_set_integer");
  if (p_id == 486) test_info_set(p_info, "player_flying", "macro", "player", "player", "src/player/player.4dm", 456, 464, "Integer", "&A:p_player",
                              "Integer player_flying(Attributes &p_player)", 0, "", "player_spectator, record_integer");
  if (p_id == 487) test_info_set(p_info, "player_set_flying", "macro", "player", "player", "src/player/player.4dm", 466, 478, "void", "&A:p_player I:p_flying",
                              "void player_set_flying(Attributes &p_player, Integer p_flying)", 0, "", "player_position, player_set_fall_peak, record_set_integer");
  if (p_id == 488) test_info_set(p_info, "player_game_mode", "macro", "player", "player", "src/player/player.4dm", 480, 489, "Integer", "&A:p_player",
                              "Integer player_game_mode(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 489) test_info_set(p_info, "player_set_game_mode", "macro", "player", "player", "src/player/player.4dm", 491, 512, "void", "&A:p_player I:p_mode",
                              "void player_set_game_mode(Attributes &p_player, Integer p_mode)", 0, "", "player_game_mode, player_set_flying, player_set_health, record_set_integer");
  if (p_id == 490) test_info_set(p_info, "player_creative", "macro", "player", "player", "src/player/player.4dm", 514, 521, "Integer", "&A:p_player",
                              "Integer player_creative(Attributes &p_player)", 0, "", "player_game_mode");
  if (p_id == 491) test_info_set(p_info, "player_spectator", "macro", "player", "player", "src/player/player.4dm", 523, 530, "Integer", "&A:p_player",
                              "Integer player_spectator(Attributes &p_player)", 0, "", "player_game_mode");
  if (p_id == 492) test_info_set(p_info, "player_survival", "macro", "player", "player", "src/player/player.4dm", 532, 538, "Integer", "&A:p_player",
                              "Integer player_survival(Attributes &p_player)", 0, "", "player_game_mode");
  if (p_id == 493) test_info_set(p_info, "player_game_mode_name", "macro", "player", "player", "src/player/player.4dm", 540, 548, "Text", "I:p_mode",
                              "Text player_game_mode_name(Integer p_mode)", 0, "", "");
  if (p_id == 494) test_info_set(p_info, "player_pick_block", "macro", "player", "player", "src/player/player.4dm", 550, 592, "Integer", "&A:p_player &A:p_inventory &T:p_report",
                              "Integer player_pick_block(Attributes &p_player, Attributes &p_inventory, Text &p_report)", 0, "", "block_pick_item, item_max_stack, item_name, player_creative, player_selected, player_set_selected, player_target_cell, player_target_kind, slot_item, slot_set, slot_swap, world_get_block");
  if (p_id == 495) test_info_set(p_info, "player_key_pressed", "macro", "player", "player", "src/player/player.4dm", 594, 641, "void", "&A:p_player T:p_key R:p_now",
                              "void player_key_pressed(Attributes &p_player, Text p_key, Real p_now)", 0, "", "max_real, player_creative, player_flying, player_set_auto_walk, player_set_flying, record_real, record_set_integer, record_set_real, record_set_text, record_text");
  if (p_id == 496) test_info_set(p_info, "player_sneak_pressed", "macro", "player", "player", "src/player/player.4dm", 643, 656, "void", "&A:p_player R:p_now",
                              "void player_sneak_pressed(Attributes &p_player, Real p_now)", 0, "", "player_flying, record_set_real");
  if (p_id == 497) test_info_set(p_info, "player_sprint_pressed", "macro", "player", "player", "src/player/player.4dm", 658, 665, "void", "&A:p_player",
                              "void player_sprint_pressed(Attributes &p_player)", 0, "", "record_set_integer");
  if (p_id == 498) test_info_set(p_info, "player_sprinting", "macro", "player", "player", "src/player/player.4dm", 667, 673, "Integer", "&A:p_player",
                              "Integer player_sprinting(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 499) test_info_set(p_info, "player_drop_selected", "macro", "player", "player", "src/player/player.4dm", 675, 703, "Integer", "&A:p_player &A:p_inventory &A:p_events I:p_whole_stack",
                              "Integer player_drop_selected(Attributes &p_player, Attributes &p_inventory, Attributes &p_events, Integer p_whole_stack)", 0, "", "emit_throw_event, player_eye_y, player_is_dead, player_look, player_position, player_selected, player_spectator, record_set_real, slot_clear, slot_count, slot_damage, slot_item, slot_set");
  if (p_id == 500) test_info_set(p_info, "player_key_active", "macro", "player", "player", "src/player/player.4dm", 705, 712, "Integer", "&A:p_player T:p_key R:p_now",
                              "Integer player_key_active(Attributes &p_player, Text p_key, Real p_now)", 0, "", "record_real, record_text");
  if (p_id == 501) test_info_set(p_info, "player_damage", "macro", "player", "player", "src/player/player.4dm", 714, 733, "void", "&A:p_player &A:p_events I:p_amount",
                              "void player_damage(Attributes &p_player, Attributes &p_events, Integer p_amount)", 0, "", "emit_item_event, emit_simple_event, player_health, player_is_dead, player_set_health, player_survival, record_set_integer, record_set_real");
  if (p_id == 502) test_info_set(p_info, "player_in_lava", "macro", "player", "player", "src/player/player.4dm", 735, 741, "Integer", "&A:p_player",
                              "Integer player_in_lava(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 503) test_info_set(p_info, "player_portal_time", "macro", "player", "player", "src/player/player.4dm", 743, 749, "Real", "&A:p_player",
                              "Real player_portal_time(Attributes &p_player)", 0, "", "record_real");
  if (p_id == 504) test_info_set(p_info, "player_wants_travel", "macro", "player", "player", "src/player/player.4dm", 751, 758, "Integer", "&A:p_player",
                              "Integer player_wants_travel(Attributes &p_player)", 0, "", "record_integer");
  if (p_id == 505) test_info_set(p_info, "player_arrived", "macro", "player", "player", "src/player/player.4dm", 760, 771, "void", "&A:p_player",
                              "void player_arrived(Attributes &p_player)", 0, "", "player_set_velocity, record_set_integer, record_set_real");
  if (p_id == 506) test_info_set(p_info, "player_lava_and_portal", "macro", "player", "player", "src/player/player.4dm", 773, 818, "void", "&A:p_player &A:p_events R:p_x R:p_y R:p_z R:p_dt",
                              "void player_lava_and_portal(Attributes &p_player, Attributes &p_events, Real p_x, Real p_y, Real p_z, Real p_dt)", 0, "", "floor_integer, player_damage, player_portal_time, player_spectator, player_survival, record_integer, record_real, record_set_integer, record_set_real, world_get_block");
  if (p_id == 507) test_info_set(p_info, "player_update", "macro", "player", "player", "src/player/player.4dm", 820, 1070, "void", "&A:p_player &A:p_cows &A:p_events I:p_auto_jump R:p_dt R:p_now",
                              "void player_update(Attributes &p_player, Attributes &p_cows, Attributes &p_events, Integer p_auto_jump, Real p_dt, Real p_now)", 0, "", "clamp_real, floor_integer, max_real, min_real, physics_box_collides, physics_box_in_water, physics_move_box, player_auto_walk, player_bob, player_damage, player_fall_peak, player_flying, player_health, player_hurt_time, player_in_water, player_is_dead, player_key_active, player_lava_and_portal, player_look, player_on_ground, player_position, player_set_fall_peak, player_set_flying, player_set_health, player_set_position, player_set_velocity, player_spectator, player_sprinting, player_swing_time, player_update_body, player_update_target, player_velocity, record_integer, record_real, record_set_integer, record_set_real, world_get_block");
  if (p_id == 508) test_info_set(p_info, "player_update_target", "macro", "player", "player", "src/player/player.4dm", 1072, 1122, "void", "&A:p_player &A:p_cows",
                              "void player_update_target(Attributes &p_player, Attributes &p_cows)", 0, "", "cows_ray_hit, physics_raycast_blocks, player_eye_y, player_look_direction, player_spectator, record_real, record_set_integer");
  if (p_id == 509) test_info_set(p_info, "player_overlaps_cell", "macro", "player", "player", "src/player/player.4dm", 1124, 1138, "Integer", "&A:p_player I:p_x I:p_y I:p_z",
                              "Integer player_overlaps_cell(Attributes &p_player, Integer p_x, Integer p_y, Integer p_z)", 0, "", "player_position");
  if (p_id == 510) test_info_set(p_info, "player_wear_tool", "macro", "player", "player", "src/player/player.4dm", 1140, 1151, "void", "&A:p_player &A:p_inventory &A:p_events",
                              "void player_wear_tool(Attributes &p_player, Attributes &p_inventory, Attributes &p_events)", 0, "", "emit_toast, item_name, player_selected, slot_item, slot_wear");
  if (p_id == 511) test_info_set(p_info, "player_primary_action", "macro", "player", "player", "src/player/player.4dm", 1153, 1217, "void", "&A:p_player &A:p_inventory &A:p_cows &A:p_events &A:p_random R:p_now",
                              "void player_primary_action(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Attributes &p_random, Real p_now)", 0, "", "block_hits_with, block_needs_tool, block_tool_kind, cow_damage, emit_toast, item_attack_damage, item_tool_kind, player_held_item, player_is_dead, player_look, player_spectator, player_target_cell, player_target_cow, player_target_kind, player_update_target, player_wear_tool, record_integer, record_real, record_set_integer, record_set_real, world_break_block, world_get_block");
  if (p_id == 512) test_info_set(p_info, "player_look_facing", "macro", "player", "player", "src/player/player.4dm", 1219, 1238, "Integer", "&A:p_player",
                              "Integer player_look_facing(Attributes &p_player)", 0, "", "player_look");
  if (p_id == 513) test_info_set(p_info, "player_cell_free", "macro", "player", "player", "src/player/player.4dm", 1240, 1254, "Integer", "&A:p_player &A:p_cows I:p_x I:p_y I:p_z",
                              "Integer player_cell_free(Attributes &p_player, Attributes &p_cows, Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_is_liquid, block_is_plant, cows_box_overlaps, player_overlaps_cell, world_get_block, world_in_bounds");
  if (p_id == 514) test_info_set(p_info, "player_place_double", "macro", "player", "player", "src/player/player.4dm", 1256, 1291, "Integer", "&A:p_player &A:p_cows &A:p_events I:p_item I:p_x I:p_y I:p_z",
                              "Integer player_place_double(Attributes &p_player, Attributes &p_cows, Attributes &p_events, Integer p_item, Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_bed, block_door, block_facing_step, emit_toast, player_cell_free, player_look_facing, world_is_solid, world_place_block");
  if (p_id == 515) test_info_set(p_info, "player_toggle_door", "macro", "player", "player", "src/player/player.4dm", 1293, 1310, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_block",
                              "void player_toggle_door(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "block_door, block_door_facing, block_door_open, block_door_top, block_is_door, block_partner, world_get_block, world_place_block");
  if (p_id == 516) test_info_set(p_info, "player_furnace_facing", "macro", "player", "player", "src/player/player.4dm", 1312, 1326, "Integer", "R:p_player_x R:p_player_z I:p_cell_x I:p_cell_z",
                              "Integer player_furnace_facing(Real p_player_x, Real p_player_z, Integer p_cell_x, Integer p_cell_z)", 0, "", "");
  if (p_id == 517) test_info_set(p_info, "player_facing_toward", "macro", "player", "player", "src/player/player.4dm", 1328, 1343, "Integer", "R:p_player_x R:p_player_z I:p_cell_x I:p_cell_z",
                              "Integer player_facing_toward(Real p_player_x, Real p_player_z, Integer p_cell_x, Integer p_cell_z)", 0, "", "");
  if (p_id == 518) test_info_set(p_info, "player_use_slot", "macro", "player", "player", "src/player/player.4dm", 1345, 1482, "Integer", "&A:p_player &A:p_inventory &A:p_cows &A:p_events I:p_slot",
                              "Integer player_use_slot(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Integer p_slot)", 0, "", "block_chest, block_is_liquid, block_is_plant, cows_box_overlaps, emit_event, emit_item_event, emit_toast, floor_integer, inventory_equip, item_armour_place, item_food_value, item_name, item_places_block, item_spawn_egg_mob, player_creative, player_facing_toward, player_furnace_facing, player_health, player_look, player_overlaps_cell, player_place_double, player_position, player_set_health, player_target_cell, player_target_kind, player_target_normal, player_update_target, record_set_real, slot_item, slot_take_one, slot_wear, world_get_block, world_in_bounds, world_is_solid, world_light_fire, world_light_portal, world_place_block, wrap_angle");
  if (p_id == 519) test_info_set(p_info, "player_secondary_action", "macro", "player", "player", "src/player/player.4dm", 1484, 1529, "void", "&A:p_player &A:p_inventory &A:p_cows &A:p_events R:p_now",
                              "void player_secondary_action(Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_events, Real p_now)", 0, "", "block_is_bed, block_is_chest, block_is_door, block_is_furnace, emit_event, player_is_dead, player_selected, player_spectator, player_target_cell, player_target_kind, player_toggle_door, player_update_target, player_use_slot, record_set_real, world_get_block");
  if (p_id == 520) test_info_set(p_info, "command_word", "macro", "program", "commands", "src/program/commands.4dm", 14, 23, "Text", "&D:p_words I:p_position",
                              "Text command_word(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 481) {   // player_break_stage
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = player_break_stage(g_player, l_r1);
    Get_time(l_end);
  } else if (p_id == 482) {   // player_turn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    player_turn(g_player, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 483) {   // player_on_event
    Get_time(l_start);
    player_on_event(g_event, g_player, g_inventory, g_events);
    Get_time(l_end);
  } else if (p_id == 484) {   // player_camera
    Get_time(l_start);
    l_ret_i = player_camera(g_player);
    Get_time(l_end);
  } else if (p_id == 485) {   // player_next_camera
    Get_time(l_start);
    player_next_camera(g_player);
    Get_time(l_end);
  } else if (p_id == 486) {   // player_flying
    Get_time(l_start);
    l_ret_i = player_flying(g_player);
    Get_time(l_end);
  } else if (p_id == 487) {   // player_set_flying
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_flying(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 488) {   // player_game_mode
    Get_time(l_start);
    l_ret_i = player_game_mode(g_player);
    Get_time(l_end);
  } else if (p_id == 489) {   // player_set_game_mode
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_set_game_mode(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 490) {   // player_creative
    Get_time(l_start);
    l_ret_i = player_creative(g_player);
    Get_time(l_end);
  } else if (p_id == 491) {   // player_spectator
    Get_time(l_start);
    l_ret_i = player_spectator(g_player);
    Get_time(l_end);
  } else if (p_id == 492) {   // player_survival
    Get_time(l_start);
    l_ret_i = player_survival(g_player);
    Get_time(l_end);
  } else if (p_id == 493) {   // player_game_mode_name
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = player_game_mode_name(l_i1);
    Get_time(l_end);
  } else if (p_id == 494) {   // player_pick_block
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = player_pick_block(g_player, g_inventory, l_t1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 495) {   // player_key_pressed
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_key_pressed(g_player, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 496) {   // player_sneak_pressed
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_sneak_pressed(g_player, l_r1);
    Get_time(l_end);
  } else if (p_id == 497) {   // player_sprint_pressed
    Get_time(l_start);
    player_sprint_pressed(g_player);
    Get_time(l_end);
  } else if (p_id == 498) {   // player_sprinting
    Get_time(l_start);
    l_ret_i = player_sprinting(g_player);
    Get_time(l_end);
  } else if (p_id == 499) {   // player_drop_selected
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = player_drop_selected(g_player, g_inventory, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 500) {   // player_key_active
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = player_key_active(g_player, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 501) {   // player_damage
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    player_damage(g_player, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 502) {   // player_in_lava
    Get_time(l_start);
    l_ret_i = player_in_lava(g_player);
    Get_time(l_end);
  } else if (p_id == 503) {   // player_portal_time
    Get_time(l_start);
    l_ret_r = player_portal_time(g_player);
    Get_time(l_end);
  } else if (p_id == 504) {   // player_wants_travel
    Get_time(l_start);
    l_ret_i = player_wants_travel(g_player);
    Get_time(l_end);
  } else if (p_id == 505) {   // player_arrived
    Get_time(l_start);
    player_arrived(g_player);
    Get_time(l_end);
  } else if (p_id == 506) {   // player_lava_and_portal
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    player_lava_and_portal(g_player, g_events, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 507) {   // player_update
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    player_update(g_player, g_cows, g_events, l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 508) {   // player_update_target
    Get_time(l_start);
    player_update_target(g_player, g_cows);
    Get_time(l_end);
  } else if (p_id == 509) {   // player_overlaps_cell
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = player_overlaps_cell(g_player, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 510) {   // player_wear_tool
    Get_time(l_start);
    player_wear_tool(g_player, g_inventory, g_events);
    Get_time(l_end);
  } else if (p_id == 511) {   // player_primary_action
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_primary_action(g_player, g_inventory, g_cows, g_events, g_random, l_r1);
    Get_time(l_end);
  } else if (p_id == 512) {   // player_look_facing
    Get_time(l_start);
    l_ret_i = player_look_facing(g_player);
    Get_time(l_end);
  } else if (p_id == 513) {   // player_cell_free
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = player_cell_free(g_player, g_cows, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 514) {   // player_place_double
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = player_place_double(g_player, g_cows, g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 515) {   // player_toggle_door
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    player_toggle_door(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 516) {   // player_furnace_facing
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = player_furnace_facing(l_r1, l_r2, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 517) {   // player_facing_toward
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = player_facing_toward(l_r1, l_r2, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 518) {   // player_use_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = player_use_slot(g_player, g_inventory, g_cows, g_events, l_i1);
    Get_time(l_end);
  } else if (p_id == 519) {   // player_secondary_action
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    player_secondary_action(g_player, g_inventory, g_cows, g_events, l_r1);
    Get_time(l_end);
  } else if (p_id == 520) {   // command_word
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_word(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
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
  if (p_id == 521) test_info_set(p_info, "command_item_key", "macro", "program", "commands", "src/program/commands.4dm", 25, 45, "Text", "T:p_name",
                              "Text command_item_key(Text p_name)", 0, "", "");
  if (p_id == 522) test_info_set(p_info, "command_find_item", "macro", "program", "commands", "src/program/commands.4dm", 47, 65, "Integer", "T:p_name",
                              "Integer command_find_item(Text p_name)", 0, "", "command_item_key, item_name");
  if (p_id == 523) test_info_set(p_info, "command_time_value", "macro", "program", "commands", "src/program/commands.4dm", 67, 87, "Integer", "T:p_word &I:p_ticks",
                              "Integer command_time_value(Text p_word, Integer &p_ticks)", 0, "", "");
  if (p_id == 524) test_info_set(p_info, "command_time", "macro", "program", "commands", "src/program/commands.4dm", 89, 114, "Text", "&D:p_words I:p_count &A:p_info",
                              "Text command_time(Dynamic_Text &p_words, Integer p_count, Attributes &p_info)", 0, "", "command_time_value, command_word, floor_integer, record_integer, world_clock_text, world_set_time_of_day, world_time_of_day");
  if (p_id == 525) test_info_set(p_info, "command_gamerule", "macro", "program", "commands", "src/program/commands.4dm", 116, 142, "Text", "&D:p_words I:p_count &A:p_info",
                              "Text command_gamerule(Dynamic_Text &p_words, Integer p_count, Attributes &p_info)", 0, "", "command_word, world_daylight_cycle, world_set_daylight_cycle");
  if (p_id == 526) test_info_set(p_info, "command_give", "macro", "program", "commands", "src/program/commands.4dm", 144, 168, "Text", "&D:p_words I:p_count &A:p_inventory",
                              "Text command_give(Dynamic_Text &p_words, Integer p_count, Attributes &p_inventory)", 0, "", "command_find_item, command_word, inventory_add, item_name");
  if (p_id == 527) test_info_set(p_info, "command_gamemode", "macro", "program", "commands", "src/program/commands.4dm", 170, 190, "Text", "&D:p_words &A:p_player",
                              "Text command_gamemode(Dynamic_Text &p_words, Attributes &p_player)", 0, "", "command_word, player_game_mode, player_game_mode_name, player_set_game_mode");
  if (p_id == 528) test_info_set(p_info, "command_whisper", "macro", "program", "commands", "src/program/commands.4dm", 192, 206, "Text", "T:p_line &D:p_words I:p_count &A:p_net &A:p_peers",
                              "Text command_whisper(Text p_line, Dynamic_Text &p_words, Integer p_count, Attributes &p_net, Attributes &p_peers)", 0, "", "command_word, net_whisper");
  if (p_id == 529) test_info_set(p_info, "command_is_cheat", "macro", "program", "commands", "src/program/commands.4dm", 208, 219, "Integer", "T:p_name",
                              "Integer command_is_cheat(Text p_name)", 0, "", "");
  if (p_id == 530) test_info_set(p_info, "command_run", "macro", "program", "commands", "src/program/commands.4dm", 221, 245, "Text", "T:p_line &A:p_info &A:p_player &A:p_inventory &A:p_net &A:p_peers",
                              "Text command_run(Text p_line, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_net, Attributes &p_peers)", 0, "", "command_gamemode, command_gamerule, command_give, command_is_cheat, command_time, command_whisper, command_word, net_cheats");
  if (p_id == 531) test_info_set(p_info, "game_init_once", "macro", "program", "game", "src/program/game.4dm", 31, 51, "void", "&A:p_game &A:p_book &A:p_settings &A:p_random I:p_time_seed",
                              "void game_init_once(Attributes &p_game, Attributes &p_book, Attributes &p_settings, Attributes &p_random, Integer p_time_seed)", 0, "", "crafting_init_book, game_load_textures, random_seed, record_clear, record_integer, record_set_integer, record_set_text, render_init, save_settings_path, settings_load");
  if (p_id == 532) test_info_set(p_info, "game_load_textures", "macro", "program", "game", "src/program/game.4dm", 53, 77, "Integer", "&A:p_settings &T:p_report",
                              "Integer game_load_textures(Attributes &p_settings, Text &p_report)", 0, "", "pack_apply, pack_apply_skin, record_set_integer, settings_resource_pack, settings_skin, textures_finish_all, textures_generate");
  if (p_id == 533) test_info_set(p_info, "game_reset_state", "macro", "program", "game", "src/program/game.4dm", 79, 100, "void", "&A:p_game &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events &A:p_hud &A:p_ui",
                              "void game_reset_state(Attributes &p_game, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events, Attributes &p_hud, Attributes &p_ui)", 0, "", "cows_clear, drops_clear, events_clear, furnaces_clear, grid_clear, hud_clear, inventory_clear, player_reset, player_set_game_mode, record_clear, record_set_real, save_clear_edits, save_clear_thumbnail, ui_clear");
  if (p_id == 534) test_info_set(p_info, "game_world_name", "macro", "program", "game", "src/program/game.4dm", 102, 108, "Text", "&A:p_game",
                              "Text game_world_name(Attributes &p_game)", 0, "", "record_text");
  if (p_id == 535) test_info_set(p_info, "game_new_world", "macro", "program", "game", "src/program/game.4dm", 110, 146, "Integer", "T:p_name I:p_seed I:p_mode &A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events &A:p_hud &A:p_ui",
                              "Integer game_new_world(Text p_name, Integer p_seed, Integer p_mode, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events, Attributes &p_hud, Attributes &p_ui)", 1, "", "cows_spawn_random, events_clear, game_reset_state, game_save_world, mesh_reset, mobs_spawn_random, player_reset, player_set_game_mode, player_set_look, random_seed, record_set_text, world_generate, world_info_spawn");
  if (p_id == 536) test_info_set(p_info, "game_load_world", "macro", "program", "game", "src/program/game.4dm", 148, 164, "Integer", "T:p_name &A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events &A:p_hud &A:p_ui &T:p_problem",
                              "Integer game_load_world(Text p_name, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events, Attributes &p_hud, Attributes &p_ui, Text &p_problem)", 0, "", "events_clear, game_reset_state, load_world, player_set_flying, player_survival, record_set_text");
  if (p_id == 537) test_info_set(p_info, "game_host", "macro", "program", "game", "src/program/game.4dm", 166, 196, "Integer", "&A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events &A:p_net &A:p_peers &A:p_inbox T:p_folder T:p_session T:p_id T:p_name I:p_mode I:p_cheats R:p_now &T:p_problem",
                              "Integer game_host(Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events, Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Text p_folder, Text p_session, Text p_id, Text p_name, Integer p_mode, Integer p_cheats, Real p_now, Text &p_problem)", 1, "", "events_clear, game_world_name, net_ensure_folder, net_set_session, net_snapshot_path, net_start, net_write_session, save_world_to, world_info_seed");
  if (p_id == 538) test_info_set(p_info, "game_join", "macro", "program", "game", "src/program/game.4dm", 198, 253, "Integer", "T:p_folder T:p_session_file &A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events &A:p_hud &A:p_ui &A:p_net &A:p_peers &A:p_inbox T:p_id T:p_name R:p_now &T:p_problem",
                              "Integer game_join(Text p_folder, Text p_session_file, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events, Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Attributes &p_peers, Attributes &p_inbox, Text p_id, Text p_name, Real p_now, Text &p_problem)", 1, "", "drops_clear, events_clear, furnaces_clear, game_clear_away, game_reset_state, inventory_clear, load_world_from, net_read_session, net_set_session, net_snapshot_path, net_start, player_reset, player_set_game_mode, record_set_text, world_info_spawn");
  if (p_id == 539) test_info_set(p_info, "game_save_world", "macro", "program", "game", "src/program/game.4dm", 255, 262, "Integer", "&A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events",
                              "Integer game_save_world(Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events)", 1, "", "game_world_name, save_world");
  if (p_id == 540) test_info_set(p_info, "game_build_nearby", "macro", "program", "game", "src/program/game.4dm", 264, 293, "void", "&A:p_player I:p_range",
                              "void game_build_nearby(Attributes &p_player, Integer p_range)", 0, "", "clamp_integer, floor_integer, mesh_ensure_section, player_position");
  if (p_id == 541) test_info_set(p_info, "game_clear_away", "macro", "program", "game", "src/program/game.4dm", 295, 306, "void", "&A:p_away",
                              "void game_clear_away(Attributes &p_away)", 0, "", "record_clear, record_copy_prefixed, record_copy_unprefixed");
  if (p_id == 542) test_info_set(p_info, "game_swap_away", "macro", "program", "game", "src/program/game.4dm", 308, 321, "void", "&A:p_record &A:p_away &A:p_keep T:p_prefix",
                              "void game_swap_away(Attributes &p_record, Attributes &p_away, Attributes &p_keep, Text p_prefix)", 0, "", "record_clear, record_copy_prefixed, record_copy_unprefixed, record_datatype");
  if (p_id == 543) test_info_set(p_info, "game_switch_dimension", "macro", "program", "game", "src/program/game.4dm", 323, 351, "void", "&A:p_info &A:p_cows &A:p_drops &A:p_furnaces &A:p_away I:p_to",
                              "void game_switch_dimension(Attributes &p_info, Attributes &p_cows, Attributes &p_drops, Attributes &p_furnaces, Attributes &p_away, Integer p_to)", 0, "", "drops_rebuild_index, furnaces_rebuild_index, game_swap_away, mesh_reset, mobs_rebuild_index, record_clear, record_copy, record_set_integer, save_apply_edits, save_swap_edits, world_dimension, world_generate_dimension, world_info_seed");
  if (p_id == 544) test_info_set(p_info, "game_travel", "macro", "program", "game", "src/program/game.4dm", 353, 410, "Integer", "&A:p_info &A:p_player &A:p_cows &A:p_drops &A:p_furnaces &A:p_away &A:p_events",
                              "Integer game_travel(Attributes &p_info, Attributes &p_player, Attributes &p_cows, Attributes &p_drops, Attributes &p_furnaces, Attributes &p_away, Attributes &p_events)", 0, "", "emit_toast, floor_integer, game_switch_dimension, player_arrived, player_position, player_set_look, player_set_position, record_integer_at, record_set_integer_at, world_build_portal, world_dimension, world_find_portal, world_get_block, world_portal_spot");
  if (p_id == 545) test_info_set(p_info, "game_respawn", "macro", "program", "game", "src/program/game.4dm", 412, 428, "void", "&A:p_info &A:p_player &A:p_cows &A:p_drops &A:p_furnaces &A:p_away &A:p_events",
                              "void game_respawn(Attributes &p_info, Attributes &p_player, Attributes &p_cows, Attributes &p_drops, Attributes &p_furnaces, Attributes &p_away, Attributes &p_events)", 0, "", "emit_simple_event, game_switch_dimension, player_reset, player_set_look, world_info_spawn");
  if (p_id == 546) test_info_set(p_info, "game_dispatch_events", "macro", "program", "game", "src/program/game.4dm", 430, 461, "void", "&A:p_events &A:p_event &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_random &A:p_hud &A:p_ui &A:p_net R:p_now",
                              "void game_dispatch_events(Attributes &p_events, Attributes &p_event, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_random, Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Real p_now)", 0, "", "chest_on_event, cows_on_event, drops_on_event, furnace_on_event, hud_on_event, mesh_on_event, net_on_event, next_event, player_on_event, player_position, save_on_event, ui_on_event, world_on_event");
  if (p_id == 547) test_info_set(p_info, "game_update", "macro", "program", "game", "src/program/game.4dm", 463, 505, "void", "R:p_dt R:p_real_dt R:p_now I:p_running &A:p_game &A:p_info &A:p_player &A:p_inventory &A:p_grid &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events &A:p_event &A:p_random &A:p_settings &A:p_hud &A:p_ui &A:p_net &A:p_peers &A:p_inbox",
                              "void game_update(Real p_dt, Real p_real_dt, Real p_now, Integer p_running, Attributes &p_game, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events, Attributes &p_event, Attributes &p_random, Attributes &p_settings, Attributes &p_hud, Attributes &p_ui, Attributes &p_net, Attributes &p_peers, Attributes &p_inbox)", 1, "", "cows_update, drops_update, furnaces_update, game_dispatch_events, game_save_world, net_apply, net_send_state, player_is_dead, player_position, player_spectator, player_survival, player_update, record_real, record_set_real, settings_flag, world_advance_time, world_daylight_cycle, world_fire_ticks, world_is_night, world_time_of_day");
  if (p_id == 548) test_info_set(p_info, "game_select_slot", "macro", "program", "game", "src/program/game.4dm", 507, 514, "void", "&A:p_player &A:p_hud I:p_slot R:p_now",
                              "void game_select_slot(Attributes &p_player, Attributes &p_hud, Integer p_slot, Real p_now)", 0, "", "hud_show_name, player_set_selected");
  if (p_id == 549) test_info_set(p_info, "save_clear_edits", "macro", "program", "save", "src/program/save.4dm", 25, 33, "void", "",
                              "void save_clear_edits()", 0, "", "");
  if (p_id == 550) test_info_set(p_info, "save_record_edit", "macro", "program", "save", "src/program/save.4dm", 35, 57, "void", "I:p_index I:p_block",
                              "void save_record_edit(Integer p_index, Integer p_block)", 0, "", "");
  if (p_id == 551) test_info_set(p_info, "save_record_other_edit", "macro", "program", "save", "src/program/save.4dm", 59, 68, "void", "I:p_index I:p_block",
                              "void save_record_other_edit(Integer p_index, Integer p_block)", 0, "", "");
  if (p_id == 552) test_info_set(p_info, "save_swap_edits", "macro", "program", "save", "src/program/save.4dm", 70, 92, "void", "",
                              "void save_swap_edits()", 0, "", "max_integer");
  if (p_id == 553) test_info_set(p_info, "save_apply_edits", "macro", "program", "save", "src/program/save.4dm", 94, 115, "void", "",
                              "void save_apply_edits()", 0, "", "block_light_emission, world_cell_of_index, world_finish_maps, world_light_update, world_set_block");
  if (p_id == 554) test_info_set(p_info, "save_on_event", "macro", "program", "save", "src/program/save.4dm", 117, 134, "void", "&A:p_event",
                              "void save_on_event(Attributes &p_event)", 0, "", "event_integer, event_type, save_record_edit, world_in_bounds, world_index");
  if (p_id == 555) test_info_set(p_info, "save_world_folder", "macro", "program", "save", "src/program/save.4dm", 136, 144, "Text", "T:p_name",
                              "Text save_world_folder(Text p_name)", 0, "", "");
  if (p_id == 556) test_info_set(p_info, "save_level_path", "macro", "program", "save", "src/program/save.4dm", 146, 155, "Text", "T:p_name",
                              "Text save_level_path(Text p_name)", 0, "", "save_world_folder");
  if (p_id == 557) test_info_set(p_info, "save_region_path", "macro", "program", "save", "src/program/save.4dm", 157, 169, "Text", "T:p_name I:p_dimension",
                              "Text save_region_path(Text p_name, Integer p_dimension)", 0, "", "save_world_folder");
  if (p_id == 558) test_info_set(p_info, "save_legacy_path", "macro", "program", "save", "src/program/save.4dm", 171, 180, "Text", "T:p_name",
                              "Text save_legacy_path(Text p_name)", 0, "", "");
  if (p_id == 559) test_info_set(p_info, "save_file_in_use", "macro", "program", "save", "src/program/save.4dm", 182, 189, "Integer", "T:p_path",
                              "Integer save_file_in_use(Text p_path)", 0, "", "save_file_is_deleted");
  if (p_id == 560) test_info_set(p_info, "save_world_path", "macro", "program", "save", "src/program/save.4dm", 191, 200, "Text", "T:p_name",
                              "Text save_world_path(Text p_name)", 0, "", "save_file_in_use, save_legacy_path, save_level_path");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 521) {   // command_item_key
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = command_item_key(l_t1);
    Get_time(l_end);
  } else if (p_id == 522) {   // command_find_item
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = command_find_item(l_t1);
    Get_time(l_end);
  } else if (p_id == 523) {   // command_time_value
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = command_time_value(l_t1, l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 524) {   // command_time
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_time(g_test_words, l_i1, g_info);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 525) {   // command_gamerule
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_gamerule(g_test_words, l_i1, g_info);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 526) {   // command_give
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_give(g_test_words, l_i1, g_inventory);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 527) {   // command_gamemode
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    Get_time(l_start);
    l_ret_t = command_gamemode(g_test_words, g_player);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 528) {   // command_whisper
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = command_whisper(l_t1, g_test_words, l_i1, g_net, g_peers);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 529) {   // command_is_cheat
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = command_is_cheat(l_t1);
    Get_time(l_end);
  } else if (p_id == 530) {   // command_run
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = command_run(l_t1, g_info, g_player, g_inventory, g_net, g_peers);
    Get_time(l_end);
  } else if (p_id == 531) {   // game_init_once
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    game_init_once(g_game, g_book, g_settings, g_random, l_i1);
    Get_time(l_end);
  } else if (p_id == 532) {   // game_load_textures
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = game_load_textures(g_settings, l_t1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 533) {   // game_reset_state
    Get_time(l_start);
    game_reset_state(g_game, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_away, g_events, g_hud, g_ui);
    Get_time(l_end);
  } else if (p_id == 534) {   // game_world_name
    Get_time(l_start);
    l_ret_t = game_world_name(g_game);
    Get_time(l_end);
  } else if (p_id == 535) {   // game_new_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = game_new_world(l_t1, l_i1, l_i2, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_away, g_events, g_hud, g_ui);
    Get_time(l_end);
  } else if (p_id == 536) {   // game_load_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = game_load_world(l_t1, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_away, g_events, g_hud, g_ui, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 537) {   // game_host
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    Get_time(l_start);
    l_ret_i = game_host(g_game, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_away, g_events, g_net, g_peers, g_net_inbox, l_t1, l_t2, l_t3, l_t4, l_i1, l_i2, l_r1, l_t5);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T5, l_t5);
  } else if (p_id == 538) {   // game_join
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_t5 = record_text(p_in, ATTR_TEST_T5);
    Get_time(l_start);
    l_ret_i = game_join(l_t1, l_t2, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_away, g_events, g_hud, g_ui, g_net, g_peers, g_net_inbox, l_t3, l_t4, l_r1, l_t5);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T5, l_t5);
  } else if (p_id == 539) {   // game_save_world
    Get_time(l_start);
    l_ret_i = game_save_world(g_game, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_away, g_events);
    Get_time(l_end);
  } else if (p_id == 540) {   // game_build_nearby
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    game_build_nearby(g_player, l_i1);
    Get_time(l_end);
  } else if (p_id == 541) {   // game_clear_away
    Get_time(l_start);
    game_clear_away(g_away);
    Get_time(l_end);
  } else if (p_id == 542) {   // game_swap_away
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    game_swap_away(g_test_record, g_away, g_test_record_2, l_t1);
    Get_time(l_end);
  } else if (p_id == 543) {   // game_switch_dimension
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    game_switch_dimension(g_info, g_cows, g_drops, g_furnaces, g_away, l_i1);
    Get_time(l_end);
  } else if (p_id == 544) {   // game_travel
    Get_time(l_start);
    l_ret_i = game_travel(g_info, g_player, g_cows, g_drops, g_furnaces, g_away, g_events);
    Get_time(l_end);
  } else if (p_id == 545) {   // game_respawn
    Get_time(l_start);
    game_respawn(g_info, g_player, g_cows, g_drops, g_furnaces, g_away, g_events);
    Get_time(l_end);
  } else if (p_id == 546) {   // game_dispatch_events
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    game_dispatch_events(g_events, g_event, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_random, g_hud, g_ui, g_net, l_r1);
    Get_time(l_end);
  } else if (p_id == 547) {   // game_update
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    game_update(l_r1, l_r2, l_r3, l_i1, g_game, g_info, g_player, g_inventory, g_grid, g_furnaces, g_cows, g_drops, g_away, g_events, g_event, g_random, g_settings, g_hud, g_ui, g_net, g_peers, g_net_inbox);
    Get_time(l_end);
  } else if (p_id == 548) {   // game_select_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    game_select_slot(g_player, g_hud, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 549) {   // save_clear_edits
    Get_time(l_start);
    save_clear_edits();
    Get_time(l_end);
  } else if (p_id == 550) {   // save_record_edit
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    save_record_edit(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 551) {   // save_record_other_edit
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    save_record_other_edit(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 552) {   // save_swap_edits
    Get_time(l_start);
    save_swap_edits();
    Get_time(l_end);
  } else if (p_id == 553) {   // save_apply_edits
    Get_time(l_start);
    save_apply_edits();
    Get_time(l_end);
  } else if (p_id == 554) {   // save_on_event
    Get_time(l_start);
    save_on_event(g_event);
    Get_time(l_end);
  } else if (p_id == 555) {   // save_world_folder
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_world_folder(l_t1);
    Get_time(l_end);
  } else if (p_id == 556) {   // save_level_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_level_path(l_t1);
    Get_time(l_end);
  } else if (p_id == 557) {   // save_region_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = save_region_path(l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 558) {   // save_legacy_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_legacy_path(l_t1);
    Get_time(l_end);
  } else if (p_id == 559) {   // save_file_in_use
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_file_in_use(l_t1);
    Get_time(l_end);
  } else if (p_id == 560) {   // save_world_path
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_world_path(l_t1);
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
  if (p_id == 561) test_info_set(p_info, "save_settings_path", "macro", "program", "save", "src/program/save.4dm", 202, 211, "Text", "",
                              "Text save_settings_path()", 0, "", "");
  if (p_id == 562) test_info_set(p_info, "save_ensure_folder", "macro", "program", "save", "src/program/save.4dm", 213, 219, "void", "",
                              "void save_ensure_folder()", 1, "", "");
  if (p_id == 563) test_info_set(p_info, "save_file_is_deleted", "macro", "program", "save", "src/program/save.4dm", 221, 238, "Integer", "T:p_path",
                              "Integer save_file_is_deleted(Text p_path)", 0, "", "");
  if (p_id == 564) test_info_set(p_info, "save_world_exists", "macro", "program", "save", "src/program/save.4dm", 240, 248, "Integer", "T:p_name",
                              "Integer save_world_exists(Text p_name)", 0, "", "save_file_in_use, save_legacy_path, save_level_path");
  if (p_id == 565) test_info_set(p_info, "save_list_worlds", "macro", "program", "save", "src/program/save.4dm", 250, 297, "Integer", "&D:p_names",
                              "Integer save_list_worlds(Dynamic_Text &p_names)", 1, "", "file_title_from_path, record_clear, record_integer, record_set_integer, save_ensure_folder, save_file_in_use, save_file_name, save_legacy_path, save_level_path");
  if (p_id == 566) test_info_set(p_info, "save_mark_deleted", "macro", "program", "save", "src/program/save.4dm", 299, 312, "Integer", "T:p_path",
                              "Integer save_mark_deleted(Text p_path)", 1, "", "");
  if (p_id == 567) test_info_set(p_info, "save_delete_world", "macro", "program", "save", "src/program/save.4dm", 314, 330, "Integer", "T:p_name",
                              "Integer save_delete_world(Text p_name)", 1, "", "save_legacy_path, save_level_path, save_mark_deleted, save_region_path, save_world_exists");
  if (p_id == 568) test_info_set(p_info, "save_clear_thumbnail", "macro", "program", "save", "src/program/save.4dm", 334, 340, "void", "",
                              "void save_clear_thumbnail()", 0, "", "");
  if (p_id == 569) test_info_set(p_info, "save_thumbnail_ready", "macro", "program", "save", "src/program/save.4dm", 342, 348, "Integer", "",
                              "Integer save_thumbnail_ready()", 0, "", "");
  if (p_id == 570) test_info_set(p_info, "save_take_thumbnail", "macro", "program", "save", "src/program/save.4dm", 350, 396, "void", "&A:p_player R:p_distance",
                              "void save_take_thumbnail(Attributes &p_player, Real p_distance)", 0, "", "player_eye_y, player_look, player_position, render_ray_colour");
  if (p_id == 571) test_info_set(p_info, "save_thumbnail_colour", "macro", "program", "save", "src/program/save.4dm", 398, 405, "Integer", "I:p_cell",
                              "Integer save_thumbnail_colour(Integer p_cell)", 0, "", "");
  if (p_id == 572) test_info_set(p_info, "save_hex_colour", "macro", "program", "save", "src/program/save.4dm", 407, 424, "Text", "I:p_colour",
                              "Text save_hex_colour(Integer p_colour)", 0, "", "clamp_integer, floor_divide");
  if (p_id == 573) test_info_set(p_info, "save_hex_value", "macro", "program", "save", "src/program/save.4dm", 426, 447, "Integer", "T:p_text I:p_position I:p_digits",
                              "Integer save_hex_value(Text p_text, Integer p_position, Integer p_digits)", 0, "", "");
  if (p_id == 574) test_info_set(p_info, "save_note_played", "macro", "program", "save", "src/program/save.4dm", 449, 457, "void", "&A:p_info I:p_seconds T:p_clock",
                              "void save_note_played(Attributes &p_info, Integer p_seconds, Text p_clock)", 0, "", "record_set_integer, record_set_text, save_date_text");
  if (p_id == 575) test_info_set(p_info, "save_date_text", "macro", "program", "save", "src/program/save.4dm", 459, 479, "Text", "T:p_clock",
                              "Text save_date_text(Text p_clock)", 0, "", "");
  if (p_id == 576) test_info_set(p_info, "save_read_about", "macro", "program", "save", "src/program/save.4dm", 481, 554, "Integer", "T:p_path &A:p_list I:p_entry",
                              "Integer save_read_about(Text p_path, Attributes &p_list, Integer p_entry)", 0, "", "record_set_integer_at, record_set_text_at, save_hex_value, save_word_integer");
  if (p_id == 577) test_info_set(p_info, "save_swap_listed", "macro", "program", "save", "src/program/save.4dm", 556, 592, "void", "&A:p_list I:p_a I:p_b",
                              "void save_swap_listed(Attributes &p_list, Integer p_a, Integer p_b)", 0, "", "record_integer_at, record_set_integer_at, record_set_text_at, record_text_at");
  if (p_id == 578) test_info_set(p_info, "save_list_worlds_about", "macro", "program", "save", "src/program/save.4dm", 594, 624, "Integer", "&A:p_list",
                              "Integer save_list_worlds_about(Attributes &p_list)", 1, "", "record_clear, record_integer_at, record_set_integer, record_set_text_at, save_list_worlds, save_read_about, save_swap_listed, save_world_path");
  if (p_id == 579) test_info_set(p_info, "save_listed_colour", "macro", "program", "save", "src/program/save.4dm", 626, 633, "Integer", "I:p_entry I:p_cell",
                              "Integer save_listed_colour(Integer p_entry, Integer p_cell)", 0, "", "");
  if (p_id == 580) test_info_set(p_info, "save_file_name", "macro", "program", "save", "src/program/save.4dm", 635, 648, "Text", "T:p_path",
                              "Text save_file_name(Text p_path)", 0, "", "");
  if (p_id == 581) test_info_set(p_info, "save_list_files", "macro", "program", "save", "src/program/save.4dm", 650, 692, "Integer", "&A:p_files T:p_folder T:p_pattern I:p_with_folders",
                              "Integer save_list_files(Attributes &p_files, Text p_folder, Text p_pattern, Integer p_with_folders)", 0, "", "record_clear, record_set_integer, record_set_text_at, save_file_name");
  if (p_id == 582) test_info_set(p_info, "text_escape", "macro", "program", "save", "src/program/save.4dm", 698, 722, "Text", "T:p_value",
                              "Text text_escape(Text p_value)", 0, "", "");
  if (p_id == 583) test_info_set(p_info, "text_unescape", "macro", "program", "save", "src/program/save.4dm", 724, 748, "Text", "T:p_value",
                              "Text text_unescape(Text p_value)", 0, "", "");
  if (p_id == 584) test_info_set(p_info, "save_write_record", "macro", "program", "save", "src/program/save.4dm", 750, 777, "void", "&?:p_file T:p_name &A:p_record",
                              "void save_write_record(File &p_file, Text p_name, Attributes &p_record)", 0, "takes an open File", "text_escape");
  if (p_id == 585) test_info_set(p_info, "save_read_field", "macro", "program", "save", "src/program/save.4dm", 779, 805, "Integer", "&D:p_words I:p_count &A:p_record",
                              "Integer save_read_field(Dynamic_Text &p_words, Integer p_count, Attributes &p_record)", 0, "", "record_set_integer, record_set_real, record_set_text, save_word_integer, save_word_real, text_unescape");
  if (p_id == 586) test_info_set(p_info, "save_write_level", "macro", "program", "save", "src/program/save.4dm", 809, 840, "void", "&?:p_file &A:p_info &A:p_player &A:p_inventory",
                              "void save_write_level(File &p_file, Attributes &p_info, Attributes &p_player, Attributes &p_inventory)", 0, "takes an open File", "player_game_mode, record_integer, record_text, save_hex_colour, save_write_record, world_dimension, world_info_seed");
  if (p_id == 587) test_info_set(p_info, "save_write_edits", "macro", "program", "save", "src/program/save.4dm", 842, 868, "void", "&?:p_file I:p_other",
                              "void save_write_edits(File &p_file, Integer p_other)", 0, "takes an open File", "");
  if (p_id == 588) test_info_set(p_info, "save_write_region", "macro", "program", "save", "src/program/save.4dm", 870, 898, "void", "&?:p_file I:p_dimension &A:p_furnaces &A:p_cows &A:p_drops &A:p_away",
                              "void save_write_region(File &p_file, Integer p_dimension, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away)", 0, "takes an open File", "record_copy_unprefixed, save_write_edits, save_write_record, world_dimension");
  if (p_id == 589) test_info_set(p_info, "save_region_file", "macro", "program", "save", "src/program/save.4dm", 900, 916, "Integer", "T:p_path I:p_dimension &A:p_furnaces &A:p_cows &A:p_drops &A:p_away",
                              "Integer save_region_file(Text p_path, Integer p_dimension, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away)", 1, "", "save_write_region");
  if (p_id == 590) test_info_set(p_info, "save_world", "macro", "program", "save", "src/program/save.4dm", 918, 945, "Integer", "T:p_name &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events",
                              "Integer save_world(Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events)", 1, "", "emit_event, save_ensure_folder, save_level_path, save_region_file, save_region_path, save_world_folder, save_write_level");
  if (p_id == 591) test_info_set(p_info, "save_world_to", "macro", "program", "save", "src/program/save.4dm", 947, 966, "Integer", "T:p_path T:p_name &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_events",
                              "Integer save_world_to(Text p_path, Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_events)", 1, "", "emit_event, save_write_level, save_write_region");
  if (p_id == 592) test_info_set(p_info, "save_word_integer", "macro", "program", "save", "src/program/save.4dm", 968, 983, "Integer", "&D:p_words I:p_position",
                              "Integer save_word_integer(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 593) test_info_set(p_info, "save_word_real", "macro", "program", "save", "src/program/save.4dm", 985, 996, "Real", "&D:p_words I:p_position",
                              "Real save_word_real(Dynamic_Text &p_words, Integer p_position)", 0, "", "");
  if (p_id == 594) test_info_set(p_info, "load_world_file", "macro", "program", "save", "src/program/save.4dm", 998, 1120, "Integer", "T:p_path &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_away_furnaces &A:p_away_cows &A:p_away_drops &I:p_dimension &I:p_seeded &I:p_version &T:p_problem",
                              "Integer load_world_file(Text p_path, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away_furnaces, Attributes &p_away_cows, Attributes &p_away_drops, Integer &p_dimension, Integer &p_seeded, Integer &p_version, Text &p_problem)", 0, "", "mesh_mark_dirty, mesh_reset, player_reset, save_hex_value, save_read_field, save_record_edit, save_record_other_edit, save_word_integer, world_cell_of_index, world_generate_dimension, world_set_block");
  if (p_id == 595) test_info_set(p_info, "load_world_finish", "macro", "program", "save", "src/program/save.4dm", 1122, 1178, "Integer", "&A:p_info &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &A:p_away_furnaces &A:p_away_cows &A:p_away_drops I:p_dimension I:p_seeded I:p_version &T:p_problem",
                              "Integer load_world_finish(Attributes &p_info, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Attributes &p_away_furnaces, Attributes &p_away_cows, Attributes &p_away_drops, Integer p_dimension, Integer p_seeded, Integer p_version, Text &p_problem)", 0, "", "block_is_furnace, block_light_emission, chests_split_legacy, drops_rebuild_index, drops_split_legacy, furnace_cell, furnace_here, furnace_set_used, furnaces_rebuild_index, furnaces_split_legacy, mobs_rebuild_index, mobs_split_legacy, record_clear, record_copy_prefixed, world_cell_of_index, world_finish_maps, world_get_block, world_light_update");
  if (p_id == 596) test_info_set(p_info, "load_world_start", "macro", "program", "save", "src/program/save.4dm", 1180, 1195, "void", "&A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_away_furnaces &A:p_away_cows &A:p_away_drops",
                              "void load_world_start(Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away_furnaces, Attributes &p_away_cows, Attributes &p_away_drops)", 0, "", "cows_clear, drops_clear, furnaces_clear, inventory_clear, save_clear_edits, save_clear_thumbnail");
  if (p_id == 597) test_info_set(p_info, "load_world", "macro", "program", "save", "src/program/save.4dm", 1197, 1233, "Integer", "T:p_name &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &T:p_problem",
                              "Integer load_world(Text p_name, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Text &p_problem)", 0, "", "load_world_file, load_world_finish, load_world_from, load_world_start, save_file_in_use, save_legacy_path, save_level_path, save_region_path, save_world_exists, save_world_path");
  if (p_id == 598) test_info_set(p_info, "load_world_from", "macro", "program", "save", "src/program/save.4dm", 1235, 1257, "Integer", "T:p_path &A:p_info &A:p_player &A:p_inventory &A:p_furnaces &A:p_cows &A:p_drops &A:p_away &T:p_problem",
                              "Integer load_world_from(Text p_path, Attributes &p_info, Attributes &p_player, Attributes &p_inventory, Attributes &p_furnaces, Attributes &p_cows, Attributes &p_drops, Attributes &p_away, Text &p_problem)", 0, "", "load_world_file, load_world_finish, load_world_start");
  if (p_id == 599) test_info_set(p_info, "settings_defaults", "macro", "program", "settings", "src/program/settings.4dm", 11, 38, "void", "&A:p_settings",
                              "void settings_defaults(Attributes &p_settings)", 0, "", "record_clear, record_set_integer, record_set_text, settings_reset_binds");
  if (p_id == 600) test_info_set(p_info, "settings_bind_default", "macro", "program", "settings", "src/program/settings.4dm", 42, 70, "Text", "I:p_action",
                              "Text settings_bind_default(Integer p_action)", 0, "", "");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 561) {   // save_settings_path
    Get_time(l_start);
    l_ret_t = save_settings_path();
    Get_time(l_end);
  } else if (p_id == 562) {   // save_ensure_folder
    Get_time(l_start);
    save_ensure_folder();
    Get_time(l_end);
  } else if (p_id == 563) {   // save_file_is_deleted
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_file_is_deleted(l_t1);
    Get_time(l_end);
  } else if (p_id == 564) {   // save_world_exists
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_world_exists(l_t1);
    Get_time(l_end);
  } else if (p_id == 565) {   // save_list_worlds
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    Get_time(l_start);
    l_ret_i = save_list_worlds(g_test_words);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 566) {   // save_mark_deleted
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_mark_deleted(l_t1);
    Get_time(l_end);
  } else if (p_id == 567) {   // save_delete_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_delete_world(l_t1);
    Get_time(l_end);
  } else if (p_id == 568) {   // save_clear_thumbnail
    Get_time(l_start);
    save_clear_thumbnail();
    Get_time(l_end);
  } else if (p_id == 569) {   // save_thumbnail_ready
    Get_time(l_start);
    l_ret_i = save_thumbnail_ready();
    Get_time(l_end);
  } else if (p_id == 570) {   // save_take_thumbnail
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    save_take_thumbnail(g_player, l_r1);
    Get_time(l_end);
  } else if (p_id == 571) {   // save_thumbnail_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_thumbnail_colour(l_i1);
    Get_time(l_end);
  } else if (p_id == 572) {   // save_hex_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = save_hex_colour(l_i1);
    Get_time(l_end);
  } else if (p_id == 573) {   // save_hex_value
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = save_hex_value(l_t1, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 574) {   // save_note_played
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    save_note_played(g_info, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 575) {   // save_date_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_date_text(l_t1);
    Get_time(l_end);
  } else if (p_id == 576) {   // save_read_about
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_read_about(l_t1, g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 577) {   // save_swap_listed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    save_swap_listed(g_test_record, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 578) {   // save_list_worlds_about
    Get_time(l_start);
    l_ret_i = save_list_worlds_about(g_test_record);
    Get_time(l_end);
  } else if (p_id == 579) {   // save_listed_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = save_listed_colour(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 580) {   // save_file_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = save_file_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 581) {   // save_list_files
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_list_files(g_test_record, l_t1, l_t2, l_i1);
    Get_time(l_end);
  } else if (p_id == 582) {   // text_escape
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = text_escape(l_t1);
    Get_time(l_end);
  } else if (p_id == 583) {   // text_unescape
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = text_unescape(l_t1);
    Get_time(l_end);
  } else if (p_id == 585) {   // save_read_field
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_read_field(g_test_words, l_i1, g_test_record);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 589) {   // save_region_file
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_region_file(l_t1, l_i1, g_furnaces, g_cows, g_drops, g_away);
    Get_time(l_end);
  } else if (p_id == 590) {   // save_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = save_world(l_t1, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_away, g_events);
    Get_time(l_end);
  } else if (p_id == 591) {   // save_world_to
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = save_world_to(l_t1, l_t2, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_away, g_events);
    Get_time(l_end);
  } else if (p_id == 592) {   // save_word_integer
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = save_word_integer(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 593) {   // save_word_real
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = save_word_real(g_test_words, l_i1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 594) {   // load_world_file
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = load_world_file(l_t1, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_test_record, g_test_record_2, g_test_record_3, l_i1, l_i2, l_i3, l_t2);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
    record_set_integer(p_out, ATTR_TEST_I2, l_i2);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 595) {   // load_world_finish
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = load_world_finish(g_info, g_furnaces, g_cows, g_drops, g_away, g_test_record, g_test_record_2, g_test_record_3, l_i1, l_i2, l_i3, l_t1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 596) {   // load_world_start
    Get_time(l_start);
    load_world_start(g_inventory, g_furnaces, g_cows, g_drops, g_test_record, g_test_record_2, g_test_record_3);
    Get_time(l_end);
  } else if (p_id == 597) {   // load_world
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = load_world(l_t1, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_away, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 598) {   // load_world_from
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = load_world_from(l_t1, g_info, g_player, g_inventory, g_furnaces, g_cows, g_drops, g_away, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 599) {   // settings_defaults
    Get_time(l_start);
    settings_defaults(g_settings);
    Get_time(l_end);
  } else if (p_id == 600) {   // settings_bind_default
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = settings_bind_default(l_i1);
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
  if (p_id == 601) test_info_set(p_info, "settings_bind_title", "macro", "program", "settings", "src/program/settings.4dm", 72, 100, "Text", "I:p_action",
                              "Text settings_bind_title(Integer p_action)", 0, "", "");
  if (p_id == 602) test_info_set(p_info, "settings_bind_group", "macro", "program", "settings", "src/program/settings.4dm", 102, 112, "Integer", "I:p_action",
                              "Integer settings_bind_group(Integer p_action)", 0, "", "");
  if (p_id == 603) test_info_set(p_info, "settings_bind_group_title", "macro", "program", "settings", "src/program/settings.4dm", 114, 124, "Text", "I:p_group",
                              "Text settings_bind_group_title(Integer p_group)", 0, "", "");
  if (p_id == 604) test_info_set(p_info, "settings_bind_field", "macro", "program", "settings", "src/program/settings.4dm", 126, 134, "Text", "I:p_action",
                              "Text settings_bind_field(Integer p_action)", 0, "", "");
  if (p_id == 605) test_info_set(p_info, "settings_bind", "macro", "program", "settings", "src/program/settings.4dm", 136, 142, "Text", "&A:p_settings I:p_action",
                              "Text settings_bind(Attributes &p_settings, Integer p_action)", 0, "", "record_text_at");
  if (p_id == 606) test_info_set(p_info, "settings_set_bind", "macro", "program", "settings", "src/program/settings.4dm", 144, 151, "void", "&A:p_settings I:p_action T:p_key",
                              "void settings_set_bind(Attributes &p_settings, Integer p_action, Text p_key)", 0, "", "record_set_text_at");
  if (p_id == 607) test_info_set(p_info, "settings_reset_binds", "macro", "program", "settings", "src/program/settings.4dm", 153, 161, "void", "&A:p_settings",
                              "void settings_reset_binds(Attributes &p_settings)", 0, "", "settings_bind_default, settings_set_bind");
  if (p_id == 608) test_info_set(p_info, "settings_binds_changed", "macro", "program", "settings", "src/program/settings.4dm", 163, 174, "Integer", "&A:p_settings",
                              "Integer settings_binds_changed(Attributes &p_settings)", 0, "", "settings_bind, settings_bind_default");
  if (p_id == 609) test_info_set(p_info, "settings_bind_clashes", "macro", "program", "settings", "src/program/settings.4dm", 176, 189, "Integer", "&A:p_settings I:p_action",
                              "Integer settings_bind_clashes(Attributes &p_settings, Integer p_action)", 0, "", "settings_bind");
  if (p_id == 610) test_info_set(p_info, "settings_bind_pressed", "macro", "program", "settings", "src/program/settings.4dm", 191, 203, "Integer", "&A:p_settings I:p_action T:p_key T:p_modifier",
                              "Integer settings_bind_pressed(Attributes &p_settings, Integer p_action, Text p_key, Text p_modifier)", 0, "", "settings_bind");
  if (p_id == 611) test_info_set(p_info, "settings_skin", "macro", "program", "settings", "src/program/settings.4dm", 205, 211, "Text", "&A:p_settings",
                              "Text settings_skin(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 612) test_info_set(p_info, "settings_slim_arms", "macro", "program", "settings", "src/program/settings.4dm", 213, 220, "Integer", "&A:p_settings",
                              "Integer settings_slim_arms(Attributes &p_settings)", 0, "", "record_integer");
  if (p_id == 613) test_info_set(p_info, "settings_mp_folder", "macro", "program", "settings", "src/program/settings.4dm", 222, 232, "Text", "&A:p_settings",
                              "Text settings_mp_folder(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 614) test_info_set(p_info, "settings_player_name", "macro", "program", "settings", "src/program/settings.4dm", 234, 240, "Text", "&A:p_settings",
                              "Text settings_player_name(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 615) test_info_set(p_info, "settings_set_text", "macro", "program", "settings", "src/program/settings.4dm", 242, 248, "void", "&A:p_settings T:p_field T:p_value",
                              "void settings_set_text(Attributes &p_settings, Text p_field, Text p_value)", 0, "", "record_set_text");
  if (p_id == 616) test_info_set(p_info, "settings_line_text", "macro", "program", "settings", "src/program/settings.4dm", 250, 263, "Integer", "T:p_line T:p_name &T:p_value",
                              "Integer settings_line_text(Text p_line, Text p_name, Text &p_value)", 0, "", "");
  if (p_id == 617) test_info_set(p_info, "settings_font_file", "macro", "program", "settings", "src/program/settings.4dm", 265, 272, "Text", "&A:p_settings",
                              "Text settings_font_file(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 618) test_info_set(p_info, "settings_set_font_file", "macro", "program", "settings", "src/program/settings.4dm", 274, 280, "void", "&A:p_settings T:p_path",
                              "void settings_set_font_file(Attributes &p_settings, Text p_path)", 0, "", "record_set_text");
  if (p_id == 619) test_info_set(p_info, "settings_font", "macro", "program", "settings", "src/program/settings.4dm", 282, 288, "Text", "&A:p_settings",
                              "Text settings_font(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 620) test_info_set(p_info, "settings_set_font", "macro", "program", "settings", "src/program/settings.4dm", 290, 296, "void", "&A:p_settings T:p_font",
                              "void settings_set_font(Attributes &p_settings, Text p_font)", 0, "", "record_set_text");
  if (p_id == 621) test_info_set(p_info, "settings_resource_pack", "macro", "program", "settings", "src/program/settings.4dm", 298, 304, "Text", "&A:p_settings",
                              "Text settings_resource_pack(Attributes &p_settings)", 0, "", "record_text");
  if (p_id == 622) test_info_set(p_info, "settings_set_resource_pack", "macro", "program", "settings", "src/program/settings.4dm", 306, 312, "void", "&A:p_settings T:p_path",
                              "void settings_set_resource_pack(Attributes &p_settings, Text p_path)", 0, "", "record_set_text");
  if (p_id == 623) test_info_set(p_info, "settings_render_distance", "macro", "program", "settings", "src/program/settings.4dm", 314, 320, "Integer", "&A:p_settings",
                              "Integer settings_render_distance(Attributes &p_settings)", 0, "", "clamp_integer, record_integer");
  if (p_id == 624) test_info_set(p_info, "settings_detail", "macro", "program", "settings", "src/program/settings.4dm", 322, 328, "Integer", "&A:p_settings",
                              "Integer settings_detail(Attributes &p_settings)", 0, "", "clamp_integer, record_integer");
  if (p_id == 625) test_info_set(p_info, "settings_flag", "macro", "program", "settings", "src/program/settings.4dm", 330, 336, "Integer", "&A:p_settings T:p_field",
                              "Integer settings_flag(Attributes &p_settings, Text p_field)", 0, "", "record_integer");
  if (p_id == 626) test_info_set(p_info, "settings_fov_degrees", "macro", "program", "settings", "src/program/settings.4dm", 338, 344, "Integer", "&A:p_settings",
                              "Integer settings_fov_degrees(Attributes &p_settings)", 0, "", "clamp_integer, record_integer");
  if (p_id == 627) test_info_set(p_info, "settings_fov_radians", "macro", "program", "settings", "src/program/settings.4dm", 346, 352, "Real", "&A:p_settings",
                              "Real settings_fov_radians(Attributes &p_settings)", 0, "", "settings_fov_degrees");
  if (p_id == 628) test_info_set(p_info, "settings_mouse_scale", "macro", "program", "settings", "src/program/settings.4dm", 354, 360, "Real", "&A:p_settings",
                              "Real settings_mouse_scale(Attributes &p_settings)", 0, "", "clamp_integer, record_integer");
  if (p_id == 629) test_info_set(p_info, "settings_change", "macro", "program", "settings", "src/program/settings.4dm", 362, 382, "void", "&A:p_settings T:p_field I:p_direction",
                              "void settings_change(Attributes &p_settings, Text p_field, Integer p_direction)", 0, "", "clamp_integer, record_integer, record_set_integer");
  if (p_id == 630) test_info_set(p_info, "settings_toggle", "macro", "program", "settings", "src/program/settings.4dm", 384, 390, "void", "&A:p_settings T:p_field",
                              "void settings_toggle(Attributes &p_settings, Text p_field)", 0, "", "record_integer, record_set_integer");
  if (p_id == 631) test_info_set(p_info, "settings_describe", "macro", "program", "settings", "src/program/settings.4dm", 392, 430, "Text", "&A:p_settings T:p_field",
                              "Text settings_describe(Attributes &p_settings, Text p_field)", 0, "", "record_integer, settings_font, settings_fov_degrees, settings_render_distance, settings_resource_pack, settings_skin");
  if (p_id == 632) test_info_set(p_info, "settings_line", "macro", "program", "settings", "src/program/settings.4dm", 432, 438, "Text", "T:p_name I:p_value",
                              "Text settings_line(Text p_name, Integer p_value)", 0, "", "");
  if (p_id == 633) test_info_set(p_info, "settings_save", "macro", "program", "settings", "src/program/settings.4dm", 440, 485, "Integer", "&A:p_settings T:p_path",
                              "Integer settings_save(Attributes &p_settings, Text p_path)", 1, "", "record_integer, settings_bind, settings_bind_field, settings_detail, settings_flag, settings_font, settings_font_file, settings_fov_degrees, settings_line, settings_mp_folder, settings_player_name, settings_render_distance, settings_resource_pack, settings_skin");
  if (p_id == 634) test_info_set(p_info, "settings_load", "macro", "program", "settings", "src/program/settings.4dm", 487, 577, "Integer", "&A:p_settings T:p_path",
                              "Integer settings_load(Attributes &p_settings, Text p_path)", 0, "", "record_set_integer, settings_bind_field, settings_defaults, settings_line_text, settings_set_bind, settings_set_font, settings_set_font_file, settings_set_resource_pack, settings_set_text");
  if (p_id == 635) test_info_set(p_info, "panorama_load", "macro", "render", "panorama_data", "src/render/panorama_data.4dm", 7, 174, "void", "",
                              "void panorama_load()", 0, "", "panorama_set_colour, panorama_set_row");
  if (p_id == 636) test_info_set(p_info, "hud_clear", "macro", "render", "render_hud", "src/render/render_hud.4dm", 20, 47, "void", "&A:p_hud",
                              "void hud_clear(Attributes &p_hud)", 0, "", "hud_set_chat_input, record_clear, record_set_integer, record_set_real, record_set_real_at, record_set_text, record_set_text_at");
  if (p_id == 637) test_info_set(p_info, "hud_note_frame", "macro", "render", "render_hud", "src/render/render_hud.4dm", 49, 82, "void", "&A:p_hud R:p_frame_ms R:p_now",
                              "void hud_note_frame(Attributes &p_hud, Real p_frame_ms, Real p_now)", 0, "", "record_integer, record_real, record_set_integer, record_set_real, record_set_text");
  if (p_id == 638) test_info_set(p_info, "hud_frame_stats", "macro", "render", "render_hud", "src/render/render_hud.4dm", 84, 90, "Text", "&A:p_hud",
                              "Text hud_frame_stats(Attributes &p_hud)", 0, "", "record_text");
  if (p_id == 639) test_info_set(p_info, "hud_toast", "macro", "render", "render_hud", "src/render/render_hud.4dm", 92, 105, "void", "&A:p_hud T:p_text R:p_now",
                              "void hud_toast(Attributes &p_hud, Text p_text, Real p_now)", 0, "", "record_real_at, record_set_real_at, record_set_text_at, record_text_at");
  if (p_id == 640) test_info_set(p_info, "hud_chat", "macro", "render", "render_hud", "src/render/render_hud.4dm", 107, 120, "void", "&A:p_hud T:p_text R:p_now",
                              "void hud_chat(Attributes &p_hud, Text p_text, Real p_now)", 0, "", "record_real_at, record_set_real_at, record_set_text_at, record_text_at");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 601) {   // settings_bind_title
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = settings_bind_title(l_i1);
    Get_time(l_end);
  } else if (p_id == 602) {   // settings_bind_group
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = settings_bind_group(l_i1);
    Get_time(l_end);
  } else if (p_id == 603) {   // settings_bind_group_title
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = settings_bind_group_title(l_i1);
    Get_time(l_end);
  } else if (p_id == 604) {   // settings_bind_field
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = settings_bind_field(l_i1);
    Get_time(l_end);
  } else if (p_id == 605) {   // settings_bind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = settings_bind(g_settings, l_i1);
    Get_time(l_end);
  } else if (p_id == 606) {   // settings_set_bind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_set_bind(g_settings, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 607) {   // settings_reset_binds
    Get_time(l_start);
    settings_reset_binds(g_settings);
    Get_time(l_end);
  } else if (p_id == 608) {   // settings_binds_changed
    Get_time(l_start);
    l_ret_i = settings_binds_changed(g_settings);
    Get_time(l_end);
  } else if (p_id == 609) {   // settings_bind_clashes
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = settings_bind_clashes(g_settings, l_i1);
    Get_time(l_end);
  } else if (p_id == 610) {   // settings_bind_pressed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = settings_bind_pressed(g_settings, l_i1, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 611) {   // settings_skin
    Get_time(l_start);
    l_ret_t = settings_skin(g_settings);
    Get_time(l_end);
  } else if (p_id == 612) {   // settings_slim_arms
    Get_time(l_start);
    l_ret_i = settings_slim_arms(g_settings);
    Get_time(l_end);
  } else if (p_id == 613) {   // settings_mp_folder
    Get_time(l_start);
    l_ret_t = settings_mp_folder(g_settings);
    Get_time(l_end);
  } else if (p_id == 614) {   // settings_player_name
    Get_time(l_start);
    l_ret_t = settings_player_name(g_settings);
    Get_time(l_end);
  } else if (p_id == 615) {   // settings_set_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    settings_set_text(g_settings, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 616) {   // settings_line_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = settings_line_text(l_t1, l_t2, l_t3);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
  } else if (p_id == 617) {   // settings_font_file
    Get_time(l_start);
    l_ret_t = settings_font_file(g_settings);
    Get_time(l_end);
  } else if (p_id == 618) {   // settings_set_font_file
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_set_font_file(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 619) {   // settings_font
    Get_time(l_start);
    l_ret_t = settings_font(g_settings);
    Get_time(l_end);
  } else if (p_id == 620) {   // settings_set_font
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_set_font(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 621) {   // settings_resource_pack
    Get_time(l_start);
    l_ret_t = settings_resource_pack(g_settings);
    Get_time(l_end);
  } else if (p_id == 622) {   // settings_set_resource_pack
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_set_resource_pack(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 623) {   // settings_render_distance
    Get_time(l_start);
    l_ret_i = settings_render_distance(g_settings);
    Get_time(l_end);
  } else if (p_id == 624) {   // settings_detail
    Get_time(l_start);
    l_ret_i = settings_detail(g_settings);
    Get_time(l_end);
  } else if (p_id == 625) {   // settings_flag
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = settings_flag(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 626) {   // settings_fov_degrees
    Get_time(l_start);
    l_ret_i = settings_fov_degrees(g_settings);
    Get_time(l_end);
  } else if (p_id == 627) {   // settings_fov_radians
    Get_time(l_start);
    l_ret_r = settings_fov_radians(g_settings);
    Get_time(l_end);
  } else if (p_id == 628) {   // settings_mouse_scale
    Get_time(l_start);
    l_ret_r = settings_mouse_scale(g_settings);
    Get_time(l_end);
  } else if (p_id == 629) {   // settings_change
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    settings_change(g_settings, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 630) {   // settings_toggle
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    settings_toggle(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 631) {   // settings_describe
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = settings_describe(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 632) {   // settings_line
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = settings_line(l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 633) {   // settings_save
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = settings_save(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 634) {   // settings_load
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = settings_load(g_settings, l_t1);
    Get_time(l_end);
  } else if (p_id == 635) {   // panorama_load
    Get_time(l_start);
    panorama_load();
    Get_time(l_end);
  } else if (p_id == 636) {   // hud_clear
    Get_time(l_start);
    hud_clear(g_hud);
    Get_time(l_end);
  } else if (p_id == 637) {   // hud_note_frame
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    hud_note_frame(g_hud, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 638) {   // hud_frame_stats
    Get_time(l_start);
    l_ret_t = hud_frame_stats(g_hud);
    Get_time(l_end);
  } else if (p_id == 639) {   // hud_toast
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    hud_toast(g_hud, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 640) {   // hud_chat
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    hud_chat(g_hud, l_t1, l_r1);
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
  if (p_id == 641) test_info_set(p_info, "hud_set_chat_input", "macro", "render", "render_hud", "src/render/render_hud.4dm", 122, 129, "void", "&A:p_hud I:p_open T:p_text",
                              "void hud_set_chat_input(Attributes &p_hud, Integer p_open, Text p_text)", 0, "", "record_set_integer, record_set_text");
  if (p_id == 642) test_info_set(p_info, "hud_chat_open", "macro", "render", "render_hud", "src/render/render_hud.4dm", 131, 137, "Integer", "&A:p_hud",
                              "Integer hud_chat_open(Attributes &p_hud)", 0, "", "record_integer");
  if (p_id == 643) test_info_set(p_info, "hud_show_name", "macro", "render", "render_hud", "src/render/render_hud.4dm", 139, 145, "void", "&A:p_hud R:p_now",
                              "void hud_show_name(Attributes &p_hud, Real p_now)", 0, "", "record_set_real");
  if (p_id == 644) test_info_set(p_info, "hud_waiting", "macro", "render", "render_hud", "src/render/render_hud.4dm", 147, 154, "Integer", "&A:p_hud",
                              "Integer hud_waiting(Attributes &p_hud)", 0, "", "record_integer");
  if (p_id == 645) test_info_set(p_info, "hud_set_waiting", "macro", "render", "render_hud", "src/render/render_hud.4dm", 156, 162, "void", "&A:p_hud I:p_waiting",
                              "void hud_set_waiting(Attributes &p_hud, Integer p_waiting)", 0, "", "record_set_integer");
  if (p_id == 646) test_info_set(p_info, "hud_set_mouse", "macro", "render", "render_hud", "src/render/render_hud.4dm", 164, 171, "void", "&A:p_hud R:p_x R:p_y",
                              "void hud_set_mouse(Attributes &p_hud, Real p_x, Real p_y)", 0, "", "record_set_real");
  if (p_id == 647) test_info_set(p_info, "hud_on_event", "macro", "render", "render_hud", "src/render/render_hud.4dm", 173, 193, "void", "&A:p_event &A:p_hud R:p_now",
                              "void hud_on_event(Attributes &p_event, Attributes &p_hud, Real p_now)", 0, "", "event_integer, event_text, event_type, hud_toast, item_name");
  if (p_id == 648) test_info_set(p_info, "hud_text", "macro", "render", "render_hud", "src/render/render_hud.4dm", 197, 206, "void", "B:p_box R:p_x R:p_y R:p_size I:p_align I:p_red I:p_green I:p_blue T:p_text",
                              "void hud_text(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_align, Integer p_red, Integer p_green, Integer p_blue, Text p_text)", 0, "", "");
  if (p_id == 649) test_info_set(p_info, "hud_shadow_text", "macro", "render", "render_hud", "src/render/render_hud.4dm", 208, 215, "void", "B:p_box R:p_x R:p_y R:p_size I:p_align I:p_red I:p_green I:p_blue T:p_text",
                              "void hud_shadow_text(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_align, Integer p_red, Integer p_green, Integer p_blue, Text p_text)", 0, "", "hud_text");
  if (p_id == 650) test_info_set(p_info, "hud_frame", "macro", "render", "render_hud", "src/render/render_hud.4dm", 217, 226, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1",
                              "void hud_frame(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)", 0, "", "render_line");
  if (p_id == 651) test_info_set(p_info, "hud_texture_face", "macro", "render", "render_hud", "src/render/render_hud.4dm", 228, 300, "void", "B:p_box I:p_tex R:p_shade I:p_quick R:p_origin_x R:p_origin_y R:p_u_x R:p_u_y R:p_v_x R:p_v_y",
                              "void hud_texture_face(Draw_Box p_box, Integer p_tex, Real p_shade, Integer p_quick, Real p_origin_x, Real p_origin_y, Real p_u_x, Real p_u_y, Real p_v_x, Real p_v_y)", 0, "", "render_set_colour, texture_palette_index");
  if (p_id == 652) test_info_set(p_info, "hud_draw_item_icon", "macro", "render", "render_hud", "src/render/render_hud.4dm", 302, 335, "void", "B:p_box I:p_item R:p_centre_x R:p_centre_y R:p_size I:p_detail",
                              "void hud_draw_item_icon(Draw_Box p_box, Integer p_item, Real p_centre_x, Real p_centre_y, Real p_size, Integer p_detail)", 0, "", "hud_draw_bed_icon, hud_texture_face, item_is_block, item_side_texture, item_sprite_texture, item_top_texture");
  if (p_id == 653) test_info_set(p_info, "hud_draw_bed_icon", "macro", "render", "render_hud", "src/render/render_hud.4dm", 337, 363, "void", "B:p_box R:p_centre_x R:p_centre_y R:p_size I:p_quick",
                              "void hud_draw_bed_icon(Draw_Box p_box, Real p_centre_x, Real p_centre_y, Real p_size, Integer p_quick)", 0, "", "hud_texture_face");
  if (p_id == 654) test_info_set(p_info, "hud_draw_slot", "macro", "render", "render_hud", "src/render/render_hud.4dm", 365, 371, "void", "B:p_box R:p_x0 R:p_y0 R:p_size I:p_item I:p_count I:p_damage I:p_highlight",
                              "void hud_draw_slot(Draw_Box p_box, Real p_x0, Real p_y0, Real p_size, Integer p_item, Integer p_count, Integer p_damage, Integer p_highlight)", 0, "", "hud_draw_slot_style");
  if (p_id == 655) test_info_set(p_info, "hud_draw_slot_style", "macro", "render", "render_hud", "src/render/render_hud.4dm", 373, 423, "void", "B:p_box R:p_x0 R:p_y0 R:p_size I:p_item I:p_count I:p_damage I:p_highlight I:p_style",
                              "void hud_draw_slot_style(Draw_Box p_box, Real p_x0, Real p_y0, Real p_size, Integer p_item, Integer p_count, Integer p_damage, Integer p_highlight, Integer p_style)", 0, "", "clamp_real, hud_draw_item_icon, hud_frame, hud_shadow_text, item_max_uses, render_fill_rect, render_set_colour");
  if (p_id == 656) test_info_set(p_info, "hud_banner", "macro", "render", "render_hud", "src/render/render_hud.4dm", 427, 440, "void", "B:p_box R:p_centre_x R:p_centre_y R:p_half_w R:p_half_h T:p_title T:p_line I:p_red I:p_green I:p_blue",
                              "void hud_banner(Draw_Box p_box, Real p_centre_x, Real p_centre_y, Real p_half_w, Real p_half_h, Text p_title, Text p_line, Integer p_red, Integer p_green, Integer p_blue)", 0, "", "hud_frame, hud_text, render_fill_rect, render_set_colour");
  if (p_id == 657) test_info_set(p_info, "hud_pause_button_rect", "macro", "render", "render_hud", "src/render/render_hud.4dm", 442, 466, "void", "R:p_w R:p_h I:p_button &R:p_x0 &R:p_y0 &R:p_x1 &R:p_y1",
                              "void hud_pause_button_rect(Real p_w, Real p_h, Integer p_button, Real &p_x0, Real &p_y0, Real &p_x1, Real &p_y1)", 0, "", "min_real");
  if (p_id == 658) test_info_set(p_info, "hud_pause_button_at", "macro", "render", "render_hud", "src/render/render_hud.4dm", 468, 484, "Integer", "R:p_w R:p_h R:p_x R:p_y",
                              "Integer hud_pause_button_at(Real p_w, Real p_h, Real p_x, Real p_y)", 0, "", "hud_pause_button_rect");
  if (p_id == 659) test_info_set(p_info, "hud_draw_button", "macro", "render", "render_hud", "src/render/render_hud.4dm", 486, 520, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_text I:p_hover",
                              "void hud_draw_button(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_hover)", 0, "", "hud_text, render_fill_rect, render_set_colour");
  if (p_id == 660) test_info_set(p_info, "hud_draw_pause_menu", "macro", "render", "render_hud", "src/render/render_hud.4dm", 522, 552, "void", "B:p_box R:p_w R:p_h R:p_mouse_x R:p_mouse_y I:p_lan",
                              "void hud_draw_pause_menu(Draw_Box p_box, Real p_w, Real p_h, Real p_mouse_x, Real p_mouse_y, Integer p_lan)", 0, "", "hud_draw_button, hud_pause_button_at, hud_pause_button_rect, hud_shadow_text");
  if (p_id == 661) test_info_set(p_info, "hud_facing_name", "macro", "render", "render_hud", "src/render/render_hud.4dm", 554, 565, "Text", "R:p_yaw",
                              "Text hud_facing_name(Real p_yaw)", 0, "", "floor_integer, positive_mod");
  if (p_id == 662) test_info_set(p_info, "hud_draw_hand", "macro", "render", "render_hud", "src/render/render_hud.4dm", 567, 609, "void", "B:p_box R:p_w R:p_view_bottom R:p_h I:p_item R:p_bob R:p_swing_time I:p_slim",
                              "void hud_draw_hand(Draw_Box p_box, Real p_w, Real p_view_bottom, Real p_h, Integer p_item, Real p_bob, Real p_swing_time, Integer p_slim)", 0, "", "hud_draw_held_tool, hud_draw_item_icon, hud_texture_face, item_tool_kind");
  if (p_id == 663) test_info_set(p_info, "hud_draw_held_tool", "macro", "render", "render_hud", "src/render/render_hud.4dm", 611, 628, "void", "B:p_box I:p_item R:p_grip_x R:p_grip_y R:p_size",
                              "void hud_draw_held_tool(Draw_Box p_box, Integer p_item, Real p_grip_x, Real p_grip_y, Real p_size)", 0, "", "hud_texture_face, item_sprite_texture");
  if (p_id == 664) test_info_set(p_info, "hud_draw_figure", "macro", "render", "render_hud", "src/render/render_hud.4dm", 630, 669, "void", "B:p_box R:p_centre_x R:p_base_y R:p_unit I:p_helmet I:p_chestplate I:p_leggings I:p_boots",
                              "void hud_draw_figure(Draw_Box p_box, Real p_centre_x, Real p_base_y, Real p_unit, Integer p_helmet, Integer p_chestplate, Integer p_leggings, Integer p_boots)", 0, "", "hud_texture_face, item_worn_texture");
  if (p_id == 665) test_info_set(p_info, "hud_draw_armour", "macro", "render", "render_hud", "src/render/render_hud.4dm", 671, 694, "void", "B:p_box R:p_x0 R:p_y0 R:p_width I:p_points",
                              "void hud_draw_armour(Draw_Box p_box, Real p_x0, Real p_y0, Real p_width, Integer p_points)", 0, "", "hud_texture_face");
  if (p_id == 666) test_info_set(p_info, "hud_draw_health", "macro", "render", "render_hud", "src/render/render_hud.4dm", 696, 721, "void", "B:p_box R:p_x0 R:p_y0 R:p_width I:p_health R:p_now",
                              "void hud_draw_health(Draw_Box p_box, Real p_x0, Real p_y0, Real p_width, Integer p_health, Real p_now)", 0, "", "hud_texture_face");
  if (p_id == 667) test_info_set(p_info, "hud_portal_band", "macro", "render", "render_hud", "src/render/render_hud.4dm", 723, 771, "void", "B:p_box R:p_w R:p_h R:p_strip R:p_depth R:p_phase",
                              "void hud_portal_band(Draw_Box p_box, Real p_w, Real p_h, Real p_strip, Real p_depth, Real p_phase)", 0, "", "");
  if (p_id == 668) test_info_set(p_info, "hud_portal_overlay", "macro", "render", "render_hud", "src/render/render_hud.4dm", 773, 794, "void", "B:p_box R:p_w R:p_h R:p_strip R:p_amount R:p_now",
                              "void hud_portal_overlay(Draw_Box p_box, Real p_w, Real p_h, Real p_strip, Real p_amount, Real p_now)", 0, "", "hud_portal_band, min_real, render_fill_rect, render_set_colour");
  if (p_id == 669) test_info_set(p_info, "hud_draw", "macro", "render", "render_hud", "src/render/render_hud.4dm", 796, 967, "void", "B:p_box R:p_w R:p_h I:p_captured I:p_screen_open &A:p_hud &A:p_player &A:p_inventory &A:p_settings I:p_seed R:p_time_of_day R:p_frame_ms T:p_render_stats R:p_now",
                              "void hud_draw(Draw_Box p_box, Real p_w, Real p_h, Integer p_captured, Integer p_screen_open, Attributes &p_hud, Attributes &p_player, Attributes &p_inventory, Attributes &p_settings, Integer p_seed, Real p_time_of_day, Real p_frame_ms, Text p_render_stats, Real p_now)", 0, "", "clamp_real, hud_banner, hud_chat_open, hud_draw_armour, hud_draw_hand, hud_draw_health, hud_draw_item_icon, hud_draw_pause_menu, hud_draw_slot, hud_facing_name, hud_frame_stats, hud_portal_overlay, hud_shadow_text, hud_text, hud_waiting, inventory_armour_points, item_name, player_auto_walk, player_bob, player_camera, player_creative, player_crouching, player_flying, player_health, player_held_item, player_hurt_time, player_in_lava, player_is_dead, player_look, player_portal_time, player_position, player_selected, player_spectator, player_sprinting, player_survival, player_swing_time, record_integer, record_real, record_real_at, record_text, record_text_at, render_fill_rect, render_line, render_set_colour, settings_flag, settings_render_distance, settings_slim_arms, slot_count, slot_damage, slot_item, world_clock_text, world_dimension, world_is_night");
  if (p_id == 670) test_info_set(p_info, "menu_clear", "macro", "render", "render_menu", "src/render/render_menu.4dm", 14, 30, "void", "&A:p_menu",
                              "void menu_clear(Attributes &p_menu)", 0, "", "record_clear, record_set_integer, record_set_real, record_set_text");
  if (p_id == 671) test_info_set(p_info, "menu_begin", "macro", "render", "render_menu", "src/render/render_menu.4dm", 32, 40, "void", "&A:p_menu",
                              "void menu_begin(Attributes &p_menu)", 0, "", "menu_set_list, record_set_integer");
  if (p_id == 672) test_info_set(p_info, "menu_add", "macro", "render", "render_menu", "src/render/render_menu.4dm", 42, 63, "Integer", "&A:p_menu I:p_kind I:p_id R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_label I:p_enabled",
                              "Integer menu_add(Attributes &p_menu, Integer p_kind, Integer p_id, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_label, Integer p_enabled)", 0, "", "record_integer, record_set_integer, record_set_integer_at, record_set_real_at, record_set_text_at");
  if (p_id == 673) test_info_set(p_info, "menu_set_value", "macro", "render", "render_menu", "src/render/render_menu.4dm", 65, 71, "void", "&A:p_menu I:p_widget R:p_value",
                              "void menu_set_value(Attributes &p_menu, Integer p_widget, Real p_value)", 0, "", "clamp_real, record_set_real_at");
  if (p_id == 674) test_info_set(p_info, "menu_widgets", "macro", "render", "render_menu", "src/render/render_menu.4dm", 73, 79, "Integer", "&A:p_menu",
                              "Integer menu_widgets(Attributes &p_menu)", 0, "", "record_integer");
  if (p_id == 675) test_info_set(p_info, "menu_widget_id", "macro", "render", "render_menu", "src/render/render_menu.4dm", 81, 88, "Integer", "&A:p_menu I:p_widget",
                              "Integer menu_widget_id(Attributes &p_menu, Integer p_widget)", 0, "", "menu_widgets, record_integer_at");
  if (p_id == 676) test_info_set(p_info, "menu_widget_kind", "macro", "render", "render_menu", "src/render/render_menu.4dm", 90, 97, "Integer", "&A:p_menu I:p_widget",
                              "Integer menu_widget_kind(Attributes &p_menu, Integer p_widget)", 0, "", "menu_widgets, record_integer_at");
  if (p_id == 677) test_info_set(p_info, "menu_widget_of", "macro", "render", "render_menu", "src/render/render_menu.4dm", 99, 110, "Integer", "&A:p_menu I:p_id",
                              "Integer menu_widget_of(Attributes &p_menu, Integer p_id)", 0, "", "menu_widgets, record_integer_at");
  if (p_id == 678) test_info_set(p_info, "menu_at", "macro", "render", "render_menu", "src/render/render_menu.4dm", 112, 126, "Integer", "&A:p_menu R:p_x R:p_y",
                              "Integer menu_at(Attributes &p_menu, Real p_x, Real p_y)", 0, "", "menu_widgets, record_integer_at, record_real_at");
  if (p_id == 679) test_info_set(p_info, "menu_id_at", "macro", "render", "render_menu", "src/render/render_menu.4dm", 128, 134, "Integer", "&A:p_menu R:p_x R:p_y",
                              "Integer menu_id_at(Attributes &p_menu, Real p_x, Real p_y)", 0, "", "menu_at, menu_widget_id");
  if (p_id == 680) test_info_set(p_info, "menu_slider_value_at", "macro", "render", "render_menu", "src/render/render_menu.4dm", 136, 153, "Real", "&A:p_menu I:p_widget R:p_x R:p_y",
                              "Real menu_slider_value_at(Attributes &p_menu, Integer p_widget, Real p_x, Real p_y)", 0, "", "clamp_real, menu_widget_kind, record_real_at");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 641) {   // hud_set_chat_input
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    hud_set_chat_input(g_hud, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 642) {   // hud_chat_open
    Get_time(l_start);
    l_ret_i = hud_chat_open(g_hud);
    Get_time(l_end);
  } else if (p_id == 643) {   // hud_show_name
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    hud_show_name(g_hud, l_r1);
    Get_time(l_end);
  } else if (p_id == 644) {   // hud_waiting
    Get_time(l_start);
    l_ret_i = hud_waiting(g_hud);
    Get_time(l_end);
  } else if (p_id == 645) {   // hud_set_waiting
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_set_waiting(g_hud, l_i1);
    Get_time(l_end);
  } else if (p_id == 646) {   // hud_set_mouse
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    hud_set_mouse(g_hud, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 647) {   // hud_on_event
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    hud_on_event(g_event, g_hud, l_r1);
    Get_time(l_end);
  } else if (p_id == 648) {   // hud_text
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
  } else if (p_id == 649) {   // hud_shadow_text
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
  } else if (p_id == 650) {   // hud_frame
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    hud_frame(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 651) {   // hud_texture_face
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
  } else if (p_id == 652) {   // hud_draw_item_icon
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    hud_draw_item_icon(g_test_box, l_i1, l_r1, l_r2, l_r3, l_i2);
    Get_time(l_end);
  } else if (p_id == 653) {   // hud_draw_bed_icon
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_draw_bed_icon(g_test_box, l_r1, l_r2, l_r3, l_i1);
    Get_time(l_end);
  } else if (p_id == 654) {   // hud_draw_slot
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
  } else if (p_id == 655) {   // hud_draw_slot_style
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
  } else if (p_id == 656) {   // hud_banner
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
  } else if (p_id == 657) {   // hud_pause_button_rect
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
  } else if (p_id == 658) {   // hud_pause_button_at
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = hud_pause_button_at(l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 659) {   // hud_draw_button
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_draw_button(g_test_box, l_r1, l_r2, l_r3, l_r4, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 660) {   // hud_draw_pause_menu
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_draw_pause_menu(g_test_box, l_r1, l_r2, l_r3, l_r4, l_i1);
    Get_time(l_end);
  } else if (p_id == 661) {   // hud_facing_name
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_t = hud_facing_name(l_r1);
    Get_time(l_end);
  } else if (p_id == 662) {   // hud_draw_hand
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    hud_draw_hand(g_test_box, l_r1, l_r2, l_r3, l_i1, l_r4, l_r5, l_i2);
    Get_time(l_end);
  } else if (p_id == 663) {   // hud_draw_held_tool
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    hud_draw_held_tool(g_test_box, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 664) {   // hud_draw_figure
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
  } else if (p_id == 665) {   // hud_draw_armour
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    hud_draw_armour(g_test_box, l_r1, l_r2, l_r3, l_i1);
    Get_time(l_end);
  } else if (p_id == 666) {   // hud_draw_health
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    hud_draw_health(g_test_box, l_r1, l_r2, l_r3, l_i1, l_r4);
    Get_time(l_end);
  } else if (p_id == 667) {   // hud_portal_band
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    hud_portal_band(g_test_box, l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 668) {   // hud_portal_overlay
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    hud_portal_overlay(g_test_box, l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 669) {   // hud_draw
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
  } else if (p_id == 670) {   // menu_clear
    Get_time(l_start);
    menu_clear(g_test_record);
    Get_time(l_end);
  } else if (p_id == 671) {   // menu_begin
    Get_time(l_start);
    menu_begin(g_test_record);
    Get_time(l_end);
  } else if (p_id == 672) {   // menu_add
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
  } else if (p_id == 673) {   // menu_set_value
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    menu_set_value(g_test_record, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 674) {   // menu_widgets
    Get_time(l_start);
    l_ret_i = menu_widgets(g_test_record);
    Get_time(l_end);
  } else if (p_id == 675) {   // menu_widget_id
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_widget_id(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 676) {   // menu_widget_kind
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_widget_kind(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 677) {   // menu_widget_of
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_widget_of(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 678) {   // menu_at
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = menu_at(g_test_record, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 679) {   // menu_id_at
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = menu_id_at(g_test_record, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 680) {   // menu_slider_value_at
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = menu_slider_value_at(g_test_record, l_i1, l_r1, l_r2);
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
  if (p_id == 681) test_info_set(p_info, "menu_field_text", "macro", "render", "render_menu", "src/render/render_menu.4dm", 155, 161, "Text", "&A:p_menu I:p_id",
                              "Text menu_field_text(Attributes &p_menu, Integer p_id)", 0, "", "record_field_at, record_text");
  if (p_id == 682) test_info_set(p_info, "menu_set_field_text", "macro", "render", "render_menu", "src/render/render_menu.4dm", 163, 169, "void", "&A:p_menu I:p_id T:p_text",
                              "void menu_set_field_text(Attributes &p_menu, Integer p_id, Text p_text)", 0, "", "record_field_at, record_set_text");
  if (p_id == 683) test_info_set(p_info, "menu_focus", "macro", "render", "render_menu", "src/render/render_menu.4dm", 171, 177, "Integer", "&A:p_menu",
                              "Integer menu_focus(Attributes &p_menu)", 0, "", "record_integer");
  if (p_id == 684) test_info_set(p_info, "menu_set_focus", "macro", "render", "render_menu", "src/render/render_menu.4dm", 179, 185, "void", "&A:p_menu I:p_id",
                              "void menu_set_focus(Attributes &p_menu, Integer p_id)", 0, "", "record_set_integer");
  if (p_id == 685) test_info_set(p_info, "menu_type_key", "macro", "render", "render_menu", "src/render/render_menu.4dm", 187, 201, "Integer", "&A:p_menu T:p_key T:p_raw",
                              "Integer menu_type_key(Attributes &p_menu, Text p_key, Text p_raw)", 0, "", "key_is_text, menu_field_text, menu_focus, menu_set_field_text, text_after_key");
  if (p_id == 686) test_info_set(p_info, "menu_set_mouse", "macro", "render", "render_menu", "src/render/render_menu.4dm", 203, 210, "void", "&A:p_menu R:p_x R:p_y",
                              "void menu_set_mouse(Attributes &p_menu, Real p_x, Real p_y)", 0, "", "record_set_real");
  if (p_id == 687) test_info_set(p_info, "menu_note", "macro", "render", "render_menu", "src/render/render_menu.4dm", 212, 221, "void", "&A:p_menu T:p_text I:p_red R:p_now",
                              "void menu_note(Attributes &p_menu, Text p_text, Integer p_red, Real p_now)", 0, "", "record_set_integer, record_set_real, record_set_text");
  if (p_id == 688) test_info_set(p_info, "menu_pick", "macro", "render", "render_menu", "src/render/render_menu.4dm", 223, 229, "Integer", "&A:p_menu",
                              "Integer menu_pick(Attributes &p_menu)", 0, "", "record_integer");
  if (p_id == 689) test_info_set(p_info, "menu_set_pick", "macro", "render", "render_menu", "src/render/render_menu.4dm", 231, 237, "void", "&A:p_menu I:p_pick",
                              "void menu_set_pick(Attributes &p_menu, Integer p_pick)", 0, "", "record_set_integer");
  if (p_id == 690) test_info_set(p_info, "menu_scroll", "macro", "render", "render_menu", "src/render/render_menu.4dm", 239, 245, "Integer", "&A:p_menu",
                              "Integer menu_scroll(Attributes &p_menu)", 0, "", "record_integer");
  if (p_id == 691) test_info_set(p_info, "menu_set_scroll", "macro", "render", "render_menu", "src/render/render_menu.4dm", 247, 254, "void", "&A:p_menu I:p_scroll I:p_rows I:p_shown",
                              "void menu_set_scroll(Attributes &p_menu, Integer p_scroll, Integer p_rows, Integer p_shown)", 0, "", "clamp_integer, max_integer, record_set_integer");
  if (p_id == 692) test_info_set(p_info, "menu_set_list", "macro", "render", "render_menu", "src/render/render_menu.4dm", 256, 264, "void", "&A:p_menu I:p_rows I:p_shown",
                              "void menu_set_list(Attributes &p_menu, Integer p_rows, Integer p_shown)", 0, "", "record_set_integer");
  if (p_id == 693) test_info_set(p_info, "menu_scroll_to", "macro", "render", "render_menu", "src/render/render_menu.4dm", 266, 275, "void", "&A:p_menu R:p_value",
                              "void menu_scroll_to(Attributes &p_menu, Real p_value)", 0, "", "clamp_real, floor_integer, max_integer, menu_set_scroll, record_integer");
  if (p_id == 694) test_info_set(p_info, "menu_text_width", "macro", "render", "render_menu", "src/render/render_menu.4dm", 277, 283, "Real", "T:p_text R:p_size",
                              "Real menu_text_width(Text p_text, Real p_size)", 0, "", "");
  if (p_id == 695) test_info_set(p_info, "menu_fit_text", "macro", "render", "render_menu", "src/render/render_menu.4dm", 285, 296, "Text", "T:p_text R:p_size R:p_width",
                              "Text menu_fit_text(Text p_text, Real p_size, Real p_width)", 0, "", "floor_integer, menu_text_width");
  if (p_id == 696) test_info_set(p_info, "menu_draw_button", "macro", "render", "render_menu", "src/render/render_menu.4dm", 300, 319, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_text I:p_hover I:p_enabled",
                              "void menu_draw_button(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_hover, Integer p_enabled)", 0, "", "hud_draw_button, hud_text, menu_fit_text, render_fill_rect, render_set_colour");
  if (p_id == 697) test_info_set(p_info, "menu_draw_field", "macro", "render", "render_menu", "src/render/render_menu.4dm", 321, 344, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_text I:p_focused",
                              "void menu_draw_field(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Integer p_focused)", 0, "", "hud_text, menu_text_width, render_fill_rect, render_set_colour");
  if (p_id == 698) test_info_set(p_info, "menu_draw_slider", "macro", "render", "render_menu", "src/render/render_menu.4dm", 346, 367, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 T:p_text R:p_value I:p_hover",
                              "void menu_draw_slider(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Text p_text, Real p_value, Integer p_hover)", 0, "", "clamp_real, hud_draw_button, hud_text, render_fill_rect, render_set_colour");
  if (p_id == 699) test_info_set(p_info, "menu_draw_scroll", "macro", "render", "render_menu", "src/render/render_menu.4dm", 369, 384, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1 R:p_value R:p_share",
                              "void menu_draw_scroll(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1, Real p_value, Real p_share)", 0, "", "clamp_real, max_real, render_fill_rect, render_set_colour");
  if (p_id == 700) test_info_set(p_info, "menu_draw_widgets", "macro", "render", "render_menu", "src/render/render_menu.4dm", 386, 420, "void", "B:p_box &A:p_menu R:p_now",
                              "void menu_draw_widgets(Draw_Box p_box, Attributes &p_menu, Real p_now)", 0, "", "hud_shadow_text, menu_at, menu_draw_button, menu_draw_field, menu_draw_note, menu_draw_slider, menu_field_text, menu_focus, menu_widgets, record_integer_at, record_real, record_real_at, record_text_at");
  if (p_id == 701) test_info_set(p_info, "menu_draw_title", "macro", "render", "render_menu", "src/render/render_menu.4dm", 422, 428, "void", "B:p_box R:p_w R:p_y T:p_text",
                              "void menu_draw_title(Draw_Box p_box, Real p_w, Real p_y, Text p_text)", 0, "", "hud_shadow_text");
  if (p_id == 702) test_info_set(p_info, "menu_draw_note", "macro", "render", "render_menu", "src/render/render_menu.4dm", 430, 442, "void", "B:p_box &A:p_menu R:p_w R:p_now",
                              "void menu_draw_note(Draw_Box p_box, Attributes &p_menu, Real p_w, Real p_now)", 0, "", "hud_shadow_text, record_integer, record_real, record_text");
  if (p_id == 703) test_info_set(p_info, "menu_dark_band", "macro", "render", "render_menu", "src/render/render_menu.4dm", 444, 455, "void", "B:p_box R:p_w R:p_y0 R:p_y1",
                              "void menu_dark_band(Draw_Box p_box, Real p_w, Real p_y0, Real p_y1)", 0, "", "render_fill_rect, render_set_colour");
  if (p_id == 704) test_info_set(p_info, "panorama_set_colour", "macro", "render", "render_menu", "src/render/render_menu.4dm", 459, 468, "void", "I:p_colour I:p_red I:p_green I:p_blue",
                              "void panorama_set_colour(Integer p_colour, Integer p_red, Integer p_green, Integer p_blue)", 0, "", "");
  if (p_id == 705) test_info_set(p_info, "panorama_set_row", "macro", "render", "render_menu", "src/render/render_menu.4dm", 470, 492, "void", "I:p_row T:p_cells",
                              "void panorama_set_row(Integer p_row, Text p_cells)", 0, "", "min_integer");
  if (p_id == 706) test_info_set(p_info, "menu_draw_panorama", "macro", "render", "render_menu", "src/render/render_menu.4dm", 494, 566, "void", "B:p_box R:p_w R:p_h R:p_turn R:p_shade",
                              "void menu_draw_panorama(Draw_Box p_box, Real p_w, Real p_h, Real p_turn, Real p_shade)", 0, "", "floor_integer, panorama_load, positive_mod, render_fill_rect, render_set_colour");
  if (p_id == 707) test_info_set(p_info, "menu_draw_logo", "macro", "render", "render_menu", "src/render/render_menu.4dm", 568, 586, "void", "B:p_box R:p_w R:p_h T:p_splash",
                              "void menu_draw_logo(Draw_Box p_box, Real p_w, Real p_h, Text p_splash)", 0, "", "hud_text");
  if (p_id == 708) test_info_set(p_info, "menu_on_off", "macro", "render", "render_screens", "src/render/render_screens.4dm", 26, 33, "Text", "I:p_on",
                              "Text menu_on_off(Integer p_on)", 0, "", "");
  if (p_id == 709) test_info_set(p_info, "menu_thumbnail_colour", "macro", "render", "render_screens", "src/render/render_screens.4dm", 35, 60, "Integer", "I:p_entry I:p_row I:p_column",
                              "Integer menu_thumbnail_colour(Integer p_entry, Integer p_row, Integer p_column)", 0, "", "floor_divide, positive_mod, save_listed_colour");
  if (p_id == 710) test_info_set(p_info, "menu_draw_thumbnail", "macro", "render", "render_screens", "src/render/render_screens.4dm", 62, 100, "void", "B:p_box I:p_entry I:p_has_picture R:p_x0 R:p_y0 R:p_size",
                              "void menu_draw_thumbnail(Draw_Box p_box, Integer p_entry, Integer p_has_picture, Real p_x0, Real p_y0, Real p_size)", 0, "", "floor_divide, hud_draw_item_icon, menu_thumbnail_colour, positive_mod, render_fill_rect, render_set_colour");
  if (p_id == 711) test_info_set(p_info, "screen_title", "macro", "render", "render_screens", "src/render/render_screens.4dm", 104, 130, "void", "B:p_box &A:p_menu R:p_w R:p_h T:p_splash R:p_now",
                              "void screen_title(Draw_Box p_box, Attributes &p_menu, Real p_w, Real p_h, Text p_splash, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_logo, menu_draw_widgets, menu_text_width");
  if (p_id == 712) test_info_set(p_info, "menu_list_area", "macro", "render", "render_screens", "src/render/render_screens.4dm", 134, 141, "void", "R:p_h &R:p_top &R:p_bottom",
                              "void menu_list_area(Real p_h, Real &p_top, Real &p_bottom)", 0, "", "");
  if (p_id == 713) test_info_set(p_info, "menu_world_rows_shown", "macro", "render", "render_screens", "src/render/render_screens.4dm", 143, 153, "Integer", "R:p_h",
                              "Integer menu_world_rows_shown(Real p_h)", 0, "", "floor_integer, max_integer, menu_list_area");
  if (p_id == 714) test_info_set(p_info, "menu_world_matches", "macro", "render", "render_screens", "src/render/render_screens.4dm", 155, 163, "Integer", "&A:p_worlds I:p_entry T:p_search",
                              "Integer menu_world_matches(Attributes &p_worlds, Integer p_entry, Text p_search)", 0, "", "record_text_at");
  if (p_id == 715) test_info_set(p_info, "menu_worlds_shown", "macro", "render", "render_screens", "src/render/render_screens.4dm", 165, 177, "Integer", "&A:p_worlds T:p_search",
                              "Integer menu_worlds_shown(Attributes &p_worlds, Text p_search)", 0, "", "menu_world_matches, record_integer");
  if (p_id == 716) test_info_set(p_info, "menu_world_entry", "macro", "render", "render_screens", "src/render/render_screens.4dm", 179, 194, "Integer", "&A:p_worlds T:p_search I:p_shown",
                              "Integer menu_world_entry(Attributes &p_worlds, Text p_search, Integer p_shown)", 0, "", "menu_world_matches, record_integer");
  if (p_id == 717) test_info_set(p_info, "screen_worlds", "macro", "render", "render_screens", "src/render/render_screens.4dm", 196, 289, "void", "B:p_box &A:p_menu &A:p_worlds R:p_w R:p_h R:p_now",
                              "void screen_worlds(Draw_Box p_box, Attributes &p_menu, Attributes &p_worlds, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, hud_text, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_thumbnail, menu_draw_title, menu_draw_widgets, menu_field_text, menu_fit_text, menu_list_area, menu_pick, menu_scroll, menu_set_list, menu_set_value, menu_text_width, menu_world_entry, menu_world_rows_shown, menu_worlds_shown, player_game_mode_name, record_integer, record_integer_at, record_text_at, render_fill_rect, render_set_colour, save_file_name, save_legacy_path, save_world_path");
  if (p_id == 718) test_info_set(p_info, "screen_create", "macro", "render", "render_screens", "src/render/render_screens.4dm", 293, 322, "void", "B:p_box &A:p_menu I:p_mode R:p_w R:p_h R:p_now",
                              "void screen_create(Draw_Box p_box, Attributes &p_menu, Integer p_mode, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_title, menu_draw_widgets, player_game_mode_name");
  if (p_id == 719) test_info_set(p_info, "screen_delete", "macro", "render", "render_screens", "src/render/render_screens.4dm", 324, 340, "void", "B:p_box &A:p_menu T:p_name R:p_w R:p_h R:p_now",
                              "void screen_delete(Draw_Box p_box, Attributes &p_menu, Text p_name, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_title, menu_draw_widgets");
  if (p_id == 720) test_info_set(p_info, "screen_player", "macro", "render", "render_screens", "src/render/render_screens.4dm", 344, 378, "void", "B:p_box &A:p_menu &A:p_settings R:p_w R:p_h R:p_now",
                              "void screen_player(Draw_Box p_box, Attributes &p_menu, Attributes &p_settings, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_title, menu_draw_widgets, net_clean_name, settings_flag");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 681) {   // menu_field_text
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = menu_field_text(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 682) {   // menu_set_field_text
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    menu_set_field_text(g_test_record, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 683) {   // menu_focus
    Get_time(l_start);
    l_ret_i = menu_focus(g_test_record);
    Get_time(l_end);
  } else if (p_id == 684) {   // menu_set_focus
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    menu_set_focus(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 685) {   // menu_type_key
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = menu_type_key(g_test_record, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 686) {   // menu_set_mouse
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    menu_set_mouse(g_test_record, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 687) {   // menu_note
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    menu_note(g_test_record, l_t1, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 688) {   // menu_pick
    Get_time(l_start);
    l_ret_i = menu_pick(g_test_record);
    Get_time(l_end);
  } else if (p_id == 689) {   // menu_set_pick
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    menu_set_pick(g_test_record, l_i1);
    Get_time(l_end);
  } else if (p_id == 690) {   // menu_scroll
    Get_time(l_start);
    l_ret_i = menu_scroll(g_test_record);
    Get_time(l_end);
  } else if (p_id == 691) {   // menu_set_scroll
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    menu_set_scroll(g_test_record, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 692) {   // menu_set_list
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    menu_set_list(g_test_record, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 693) {   // menu_scroll_to
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    menu_scroll_to(g_test_record, l_r1);
    Get_time(l_end);
  } else if (p_id == 694) {   // menu_text_width
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = menu_text_width(l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 695) {   // menu_fit_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_t = menu_fit_text(l_t1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 696) {   // menu_draw_button
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
  } else if (p_id == 697) {   // menu_draw_field
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    menu_draw_field(g_test_box, l_r1, l_r2, l_r3, l_r4, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 698) {   // menu_draw_slider
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
  } else if (p_id == 699) {   // menu_draw_scroll
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    menu_draw_scroll(g_test_box, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
  } else if (p_id == 700) {   // menu_draw_widgets
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    menu_draw_widgets(g_test_box, g_test_record, l_r1);
    Get_time(l_end);
  } else if (p_id == 701) {   // menu_draw_title
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    menu_draw_title(g_test_box, l_r1, l_r2, l_t1);
    Get_time(l_end);
  } else if (p_id == 702) {   // menu_draw_note
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    menu_draw_note(g_test_box, g_test_record, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 703) {   // menu_dark_band
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    menu_dark_band(g_test_box, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 704) {   // panorama_set_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    panorama_set_colour(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 705) {   // panorama_set_row
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    panorama_set_row(l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 706) {   // menu_draw_panorama
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    menu_draw_panorama(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 707) {   // menu_draw_logo
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    menu_draw_logo(g_test_box, l_r1, l_r2, l_t1);
    Get_time(l_end);
  } else if (p_id == 708) {   // menu_on_off
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = menu_on_off(l_i1);
    Get_time(l_end);
  } else if (p_id == 709) {   // menu_thumbnail_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = menu_thumbnail_colour(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 710) {   // menu_draw_thumbnail
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    menu_draw_thumbnail(g_test_box, l_i1, l_i2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 711) {   // screen_title
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_title(g_test_box, g_test_record, l_r1, l_r2, l_t1, l_r3);
    Get_time(l_end);
  } else if (p_id == 712) {   // menu_list_area
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    menu_list_area(l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 713) {   // menu_world_rows_shown
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = menu_world_rows_shown(l_r1);
    Get_time(l_end);
  } else if (p_id == 714) {   // menu_world_matches
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = menu_world_matches(g_test_record, l_i1, l_t1);
    Get_time(l_end);
  } else if (p_id == 715) {   // menu_worlds_shown
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = menu_worlds_shown(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 716) {   // menu_world_entry
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_world_entry(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 717) {   // screen_worlds
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_worlds(g_test_box, g_test_record, g_test_record_2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 718) {   // screen_create
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_create(g_test_box, g_test_record, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 719) {   // screen_delete
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_delete(g_test_box, g_test_record, l_t1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 720) {   // screen_player
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_player(g_test_box, g_test_record, g_settings, l_r1, l_r2, l_r3);
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
  if (p_id == 721) test_info_set(p_info, "screen_lan", "macro", "render", "render_screens", "src/render/render_screens.4dm", 380, 407, "void", "B:p_box &A:p_menu &A:p_settings R:p_w R:p_h R:p_now",
                              "void screen_lan(Draw_Box p_box, Attributes &p_menu, Attributes &p_settings, Real p_w, Real p_h, Real p_now)", 0, "", "hud_shadow_text, menu_add, menu_begin, menu_draw_title, menu_draw_widgets, player_game_mode_name, record_integer");
  if (p_id == 722) test_info_set(p_info, "screen_multiplayer", "macro", "render", "render_screens", "src/render/render_screens.4dm", 409, 476, "void", "B:p_box &A:p_menu &A:p_lan R:p_w R:p_h R:p_now",
                              "void screen_multiplayer(Draw_Box p_box, Attributes &p_menu, Attributes &p_lan, Real p_w, Real p_h, Real p_now)", 0, "", "floor_integer, hud_shadow_text, hud_text, menu_add, menu_begin, menu_dark_band, menu_draw_title, menu_draw_widgets, menu_fit_text, menu_list_area, menu_pick, menu_world_rows_shown, player_game_mode_name, record_integer, record_integer_at, record_text, record_text_at, render_fill_rect, render_set_colour");
  if (p_id == 723) test_info_set(p_info, "screen_options", "macro", "render", "render_screens", "src/render/render_screens.4dm", 480, 536, "void", "B:p_box &A:p_menu &A:p_settings R:p_w R:p_h R:p_now",
                              "void screen_options(Draw_Box p_box, Attributes &p_menu, Attributes &p_settings, Real p_w, Real p_h, Real p_now)", 0, "", "menu_add, menu_begin, menu_draw_title, menu_draw_widgets, menu_on_off, menu_set_value, record_integer, settings_detail, settings_flag, settings_fov_degrees, settings_render_distance");
  if (p_id == 724) test_info_set(p_info, "menu_key_rows", "macro", "render", "render_screens", "src/render/render_screens.4dm", 540, 547, "Integer", "",
                              "Integer menu_key_rows()", 0, "", "");
  if (p_id == 725) test_info_set(p_info, "menu_key_row_action", "macro", "render", "render_screens", "src/render/render_screens.4dm", 549, 570, "Integer", "I:p_row",
                              "Integer menu_key_row_action(Integer p_row)", 0, "", "settings_bind_group");
  if (p_id == 726) test_info_set(p_info, "screen_controls", "macro", "render", "render_screens", "src/render/render_screens.4dm", 572, 666, "void", "B:p_box &A:p_menu &A:p_settings I:p_listening R:p_w R:p_h R:p_now",
                              "void screen_controls(Draw_Box p_box, Attributes &p_menu, Attributes &p_settings, Integer p_listening, Real p_w, Real p_h, Real p_now)", 0, "", "clamp_integer, floor_integer, hud_draw_button, hud_shadow_text, hud_text, key_label, max_integer, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_title, menu_draw_widgets, menu_id_at, menu_key_row_action, menu_key_rows, menu_scroll, menu_set_list, menu_set_value, menu_widget_id, menu_widget_kind, menu_widgets, min_integer, record_real, record_real_at, settings_bind, settings_bind_clashes, settings_bind_default, settings_bind_group_title, settings_bind_title, settings_binds_changed");
  if (p_id == 727) test_info_set(p_info, "screen_packs", "macro", "render", "render_screens", "src/render/render_screens.4dm", 670, 744, "void", "B:p_box &A:p_menu &A:p_files T:p_selected R:p_w R:p_h R:p_now",
                              "void screen_packs(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_selected, Real p_w, Real p_h, Real p_now)", 0, "", "floor_integer, hud_shadow_text, hud_text, max_integer, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_title, menu_draw_widgets, menu_fit_text, menu_id_at, menu_scroll, menu_set_list, menu_set_value, menu_widget_id, menu_widget_kind, menu_widgets, record_integer, record_real, record_real_at, record_text_at, render_fill_rect, render_set_colour, save_file_name");
  if (p_id == 728) test_info_set(p_info, "screen_skins", "macro", "render", "render_screens", "src/render/render_screens.4dm", 746, 820, "void", "B:p_box &A:p_menu &A:p_files T:p_selected R:p_w R:p_h R:p_now",
                              "void screen_skins(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_selected, Real p_w, Real p_h, Real p_now)", 0, "", "floor_integer, hud_draw_figure, hud_shadow_text, hud_text, max_integer, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_title, menu_draw_widgets, menu_fit_text, menu_id_at, menu_scroll, menu_set_list, menu_set_value, menu_widget_id, menu_widget_kind, menu_widgets, min_real, record_integer, record_real, record_real_at, record_text_at, render_fill_rect, render_set_colour");
  if (p_id == 729) test_info_set(p_info, "screen_fonts", "macro", "render", "render_screens", "src/render/render_screens.4dm", 822, 908, "void", "B:p_box &A:p_menu &A:p_files T:p_font T:p_font_file R:p_w R:p_h R:p_now",
                              "void screen_fonts(Draw_Box p_box, Attributes &p_menu, Attributes &p_files, Text p_font, Text p_font_file, Real p_w, Real p_h, Real p_now)", 0, "", "floor_integer, font_apply, font_choice, hud_shadow_text, hud_text, max_integer, menu_add, menu_begin, menu_dark_band, menu_draw_scroll, menu_draw_title, menu_draw_widgets, menu_fit_text, menu_id_at, menu_scroll, menu_set_list, menu_set_value, menu_widget_id, menu_widget_kind, menu_widgets, record_integer, record_real, record_real_at, record_text_at, render_fill_rect, render_set_colour");
  if (p_id == 730) test_info_set(p_info, "ui_clear", "macro", "render", "render_ui", "src/render/render_ui.4dm", 20, 35, "void", "&A:p_ui",
                              "void ui_clear(Attributes &p_ui)", 0, "", "record_clear, record_set_integer, ui_set_mouse, ui_set_search");
  if (p_id == 731) test_info_set(p_info, "ui_screen", "macro", "render", "render_ui", "src/render/render_ui.4dm", 37, 43, "Integer", "&A:p_ui",
                              "Integer ui_screen(Attributes &p_ui)", 0, "", "record_integer");
  if (p_id == 732) test_info_set(p_info, "ui_furnace", "macro", "render", "render_ui", "src/render/render_ui.4dm", 45, 51, "Integer", "&A:p_ui",
                              "Integer ui_furnace(Attributes &p_ui)", 0, "", "record_integer");
  if (p_id == 733) test_info_set(p_info, "ui_mouse", "macro", "render", "render_ui", "src/render/render_ui.4dm", 53, 60, "void", "&A:p_ui &R:p_x &R:p_y",
                              "void ui_mouse(Attributes &p_ui, Real &p_x, Real &p_y)", 0, "", "record_real");
  if (p_id == 734) test_info_set(p_info, "ui_set_mouse", "macro", "render", "render_ui", "src/render/render_ui.4dm", 62, 70, "void", "&A:p_ui R:p_x R:p_y",
                              "void ui_set_mouse(Attributes &p_ui, Real p_x, Real p_y)", 0, "", "record_set_real");
  if (p_id == 735) test_info_set(p_info, "ui_set_tabs", "macro", "render", "render_ui", "src/render/render_ui.4dm", 74, 81, "void", "&A:p_ui I:p_creative",
                              "void ui_set_tabs(Attributes &p_ui, Integer p_creative)", 0, "", "record_set_integer");
  if (p_id == 736) test_info_set(p_info, "ui_search", "macro", "render", "render_ui", "src/render/render_ui.4dm", 83, 89, "Text", "&A:p_ui",
                              "Text ui_search(Attributes &p_ui)", 0, "", "record_text");
  if (p_id == 737) test_info_set(p_info, "ui_set_search", "macro", "render", "render_ui", "src/render/render_ui.4dm", 91, 114, "void", "&A:p_ui T:p_search",
                              "void ui_set_search(Attributes &p_ui, Text p_search)", 0, "", "item_name, record_set_integer, record_set_integer_at, record_set_text");
  if (p_id == 738) test_info_set(p_info, "ui_type_search", "macro", "render", "render_ui", "src/render/render_ui.4dm", 116, 127, "void", "&A:p_ui T:p_key",
                              "void ui_type_search(Attributes &p_ui, Text p_key)", 0, "", "text_after_key, ui_search, ui_set_search");
  if (p_id == 739) test_info_set(p_info, "ui_creative_count", "macro", "render", "render_ui", "src/render/render_ui.4dm", 129, 135, "Integer", "&A:p_ui",
                              "Integer ui_creative_count(Attributes &p_ui)", 0, "", "record_integer");
  if (p_id == 740) test_info_set(p_info, "ui_creative_rows", "macro", "render", "render_ui", "src/render/render_ui.4dm", 137, 143, "Integer", "&A:p_ui",
                              "Integer ui_creative_rows(Attributes &p_ui)", 0, "", "floor_divide, ui_creative_count");
  if (p_id == 741) test_info_set(p_info, "ui_creative_item", "macro", "render", "render_ui", "src/render/render_ui.4dm", 145, 156, "Integer", "&A:p_ui I:p_slot",
                              "Integer ui_creative_item(Attributes &p_ui, Integer p_slot)", 0, "", "record_integer, record_integer_at, ui_creative_count");
  if (p_id == 742) test_info_set(p_info, "ui_creative_click", "macro", "render", "render_ui", "src/render/render_ui.4dm", 158, 181, "void", "&A:p_ui &A:p_inventory I:p_slot I:p_right_button",
                              "void ui_creative_click(Attributes &p_ui, Attributes &p_inventory, Integer p_slot, Integer p_right_button)", 0, "", "item_max_stack, slot_clear, slot_count, slot_item, slot_set, ui_creative_item");
  if (p_id == 743) test_info_set(p_info, "ui_open", "macro", "render", "render_ui", "src/render/render_ui.4dm", 185, 249, "void", "&A:p_ui &A:p_grid &A:p_furnaces &A:p_events I:p_screen I:p_x I:p_y I:p_z",
                              "void ui_open(Attributes &p_ui, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_events, Integer p_screen, Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_chest_type, block_is_chest, block_partner, chest_get_or_create, emit_toast, furnace_get_or_create, grid_clear, record_set_integer, ui_set_search, world_get_block");
  if (p_id == 744) test_info_set(p_info, "ui_close", "macro", "render", "render_ui", "src/render/render_ui.4dm", 251, 265, "void", "&A:p_ui &A:p_inventory &A:p_grid &A:p_events R:p_drop_x R:p_drop_y R:p_drop_z",
                              "void ui_close(Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_events, Real p_drop_x, Real p_drop_y, Real p_drop_z)", 0, "", "grid_return_items, inventory_return_cursor, record_set_integer");
  if (p_id == 745) test_info_set(p_info, "ui_on_event", "macro", "render", "render_ui", "src/render/render_ui.4dm", 267, 291, "void", "&A:p_event &A:p_ui &A:p_inventory &A:p_grid &A:p_furnaces &A:p_events R:p_drop_x R:p_drop_y R:p_drop_z",
                              "void ui_on_event(Attributes &p_event, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_events, Real p_drop_x, Real p_drop_y, Real p_drop_z)", 0, "", "event_integer, event_type, record_integer, ui_close, ui_open, ui_screen");
  if (p_id == 746) test_info_set(p_info, "ui_layout", "macro", "render", "render_ui", "src/render/render_ui.4dm", 295, 328, "void", "I:p_screen R:p_w R:p_h &R:p_slot_size &R:p_x0 &R:p_y0 &R:p_x1 &R:p_y1 &R:p_inv_x &R:p_inv_y &R:p_top_y",
                              "void ui_layout(Integer p_screen, Real p_w, Real p_h, Real &p_slot_size, Real &p_x0, Real &p_y0, Real &p_x1, Real &p_y1, Real &p_inv_x, Real &p_inv_y, Real &p_top_y)", 0, "", "clamp_real, max_real, min_real");
  if (p_id == 747) test_info_set(p_info, "ui_slot_rect", "macro", "render", "render_ui", "src/render/render_ui.4dm", 330, 474, "Integer", "I:p_screen I:p_grid_width I:p_slot R:p_w R:p_h &R:p_x &R:p_y &R:p_size",
                              "Integer ui_slot_rect(Integer p_screen, Integer p_grid_width, Integer p_slot, Real p_w, Real p_h, Real &p_x, Real &p_y, Real &p_size)", 0, "", "floor_divide, positive_mod, ui_layout");
  if (p_id == 748) test_info_set(p_info, "ui_inventory_slot", "macro", "render", "render_ui", "src/render/render_ui.4dm", 476, 486, "Integer", "I:p_slot",
                              "Integer ui_inventory_slot(Integer p_slot)", 0, "", "inventory_armour_slot");
  if (p_id == 749) test_info_set(p_info, "ui_chest_target", "macro", "render", "render_ui", "src/render/render_ui.4dm", 488, 501, "Integer", "&A:p_ui I:p_slot",
                              "Integer ui_chest_target(Attributes &p_ui, Integer p_slot)", 0, "", "chest_slot, record_integer");
  if (p_id == 750) test_info_set(p_info, "ui_slot_at", "macro", "render", "render_ui", "src/render/render_ui.4dm", 503, 518, "Integer", "I:p_screen I:p_grid_width R:p_px R:p_py R:p_w R:p_h",
                              "Integer ui_slot_at(Integer p_screen, Integer p_grid_width, Real p_px, Real p_py, Real p_w, Real p_h)", 0, "", "ui_slot_rect");
  if (p_id == 751) test_info_set(p_info, "ui_click", "macro", "render", "render_ui", "src/render/render_ui.4dm", 522, 617, "void", "&A:p_ui &A:p_inventory &A:p_grid &A:p_furnaces &A:p_book &A:p_events R:p_x R:p_y I:p_right_button R:p_w R:p_h",
                              "void ui_click(Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_book, Attributes &p_events, Real p_x, Real p_y, Integer p_right_button, Real p_w, Real p_h)", 0, "", "crafting_take_output, emit_event, emit_simple_event, emit_toast, furnace_slot, grid_width, inventory_fits_slot, item_fuel_seconds, max_integer, min_integer, record_integer, record_set_integer, slot_click_left, slot_click_right, slot_item, ui_chest_target, ui_creative_click, ui_creative_rows, ui_furnace, ui_inventory_slot, ui_screen, ui_slot_at");
  if (p_id == 752) test_info_set(p_info, "ui_draw_arrow", "macro", "render", "render_ui", "src/render/render_ui.4dm", 621, 637, "void", "B:p_box R:p_x R:p_y R:p_length R:p_size R:p_progress",
                              "void ui_draw_arrow(Draw_Box p_box, Real p_x, Real p_y, Real p_length, Real p_size, Real p_progress)", 0, "", "min_real, render_fill_rect, render_set_colour");
  if (p_id == 753) test_info_set(p_info, "ui_draw_furnace", "macro", "render", "render_ui", "src/render/render_ui.4dm", 639, 680, "void", "B:p_box &A:p_furnaces I:p_furnace R:p_w R:p_h",
                              "void ui_draw_furnace(Draw_Box p_box, Attributes &p_furnaces, Integer p_furnace, Real p_w, Real p_h)", 0, "", "clamp_real, furnace_burn_left, furnace_burn_total, furnace_progress, render_fill_rect, render_set_colour, ui_draw_arrow, ui_layout");
  if (p_id == 754) test_info_set(p_info, "ui_draw_tab", "macro", "render", "render_ui", "src/render/render_ui.4dm", 682, 703, "void", "B:p_box R:p_x R:p_y R:p_size I:p_slot I:p_screen I:p_hovered",
                              "void ui_draw_tab(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_slot, Integer p_screen, Integer p_hovered)", 0, "", "hud_draw_item_icon, hud_frame, render_fill_rect, render_set_colour");
  if (p_id == 755) test_info_set(p_info, "ui_draw_scroll", "macro", "render", "render_ui", "src/render/render_ui.4dm", 705, 726, "void", "B:p_box R:p_x R:p_y R:p_size I:p_up I:p_hovered",
                              "void ui_draw_scroll(Draw_Box p_box, Real p_x, Real p_y, Real p_size, Integer p_up, Integer p_hovered)", 0, "", "hud_draw_slot_style, render_set_colour");
  if (p_id == 756) test_info_set(p_info, "ui_draw_search", "macro", "render", "render_ui", "src/render/render_ui.4dm", 728, 749, "void", "B:p_box &A:p_ui R:p_x R:p_y R:p_width R:p_size",
                              "void ui_draw_search(Draw_Box p_box, Attributes &p_ui, Real p_x, Real p_y, Real p_width, Real p_size)", 0, "", "hud_text, render_fill_rect, render_line, render_set_colour, ui_search");
  if (p_id == 757) test_info_set(p_info, "ui_draw_titles", "macro", "render", "render_ui", "src/render/render_ui.4dm", 751, 767, "void", "B:p_box I:p_screen R:p_inv_x R:p_inv_y R:p_top R:p_slot_size",
                              "void ui_draw_titles(Draw_Box p_box, Integer p_screen, Real p_inv_x, Real p_inv_y, Real p_top, Real p_slot_size)", 0, "", "hud_text");
  if (p_id == 758) test_info_set(p_info, "ui_draw", "macro", "render", "render_ui", "src/render/render_ui.4dm", 769, 896, "void", "B:p_box R:p_w R:p_h &A:p_ui &A:p_inventory &A:p_grid &A:p_furnaces &A:p_book",
                              "void ui_draw(Draw_Box p_box, Real p_w, Real p_h, Attributes &p_ui, Attributes &p_inventory, Attributes &p_grid, Attributes &p_furnaces, Attributes &p_book)", 0, "", "crafting_match, crafting_recipe_output, furnace_slot, grid_width, hud_draw_figure, hud_draw_item_icon, hud_draw_slot_style, hud_frame, hud_shadow_text, inventory_armour_slot, item_name, record_integer, record_integer_at, render_fill_rect, render_set_colour, slot_count, slot_damage, slot_item, ui_chest_target, ui_creative_item, ui_creative_rows, ui_draw_arrow, ui_draw_furnace, ui_draw_scroll, ui_draw_search, ui_draw_tab, ui_draw_titles, ui_furnace, ui_inventory_slot, ui_layout, ui_mouse, ui_screen, ui_slot_at, ui_slot_rect");
  if (p_id == 759) test_info_set(p_info, "render_init", "macro", "render", "render_world", "src/render/render_world.4dm", 24, 46, "void", "",
                              "void render_init()", 0, "", "hash_real, render_set_detail");
  if (p_id == 760) test_info_set(p_info, "render_set_detail", "macro", "render", "render_world", "src/render/render_world.4dm", 48, 68, "void", "I:p_level",
                              "void render_set_detail(Integer p_level)", 0, "", "");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 721) {   // screen_lan
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_lan(g_test_box, g_test_record, g_settings, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 722) {   // screen_multiplayer
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_multiplayer(g_test_box, g_test_record, g_test_record_2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 723) {   // screen_options
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_options(g_test_box, g_test_record, g_settings, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 724) {   // menu_key_rows
    Get_time(l_start);
    l_ret_i = menu_key_rows();
    Get_time(l_end);
  } else if (p_id == 725) {   // menu_key_row_action
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = menu_key_row_action(l_i1);
    Get_time(l_end);
  } else if (p_id == 726) {   // screen_controls
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_controls(g_test_box, g_test_record, g_settings, l_i1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 727) {   // screen_packs
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_packs(g_test_box, g_test_record, g_test_record_2, l_t1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 728) {   // screen_skins
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_skins(g_test_box, g_test_record, g_test_record_2, l_t1, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 729) {   // screen_fonts
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    screen_fonts(g_test_box, g_test_record, g_test_record_2, l_t1, l_t2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 730) {   // ui_clear
    Get_time(l_start);
    ui_clear(g_ui);
    Get_time(l_end);
  } else if (p_id == 731) {   // ui_screen
    Get_time(l_start);
    l_ret_i = ui_screen(g_ui);
    Get_time(l_end);
  } else if (p_id == 732) {   // ui_furnace
    Get_time(l_start);
    l_ret_i = ui_furnace(g_ui);
    Get_time(l_end);
  } else if (p_id == 733) {   // ui_mouse
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    ui_mouse(g_ui, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 734) {   // ui_set_mouse
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    ui_set_mouse(g_ui, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 735) {   // ui_set_tabs
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    ui_set_tabs(g_ui, l_i1);
    Get_time(l_end);
  } else if (p_id == 736) {   // ui_search
    Get_time(l_start);
    l_ret_t = ui_search(g_ui);
    Get_time(l_end);
  } else if (p_id == 737) {   // ui_set_search
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    ui_set_search(g_ui, l_t1);
    Get_time(l_end);
  } else if (p_id == 738) {   // ui_type_search
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    ui_type_search(g_ui, l_t1);
    Get_time(l_end);
  } else if (p_id == 739) {   // ui_creative_count
    Get_time(l_start);
    l_ret_i = ui_creative_count(g_ui);
    Get_time(l_end);
  } else if (p_id == 740) {   // ui_creative_rows
    Get_time(l_start);
    l_ret_i = ui_creative_rows(g_ui);
    Get_time(l_end);
  } else if (p_id == 741) {   // ui_creative_item
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = ui_creative_item(g_ui, l_i1);
    Get_time(l_end);
  } else if (p_id == 742) {   // ui_creative_click
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    ui_creative_click(g_ui, g_inventory, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 743) {   // ui_open
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    ui_open(g_ui, g_grid, g_furnaces, g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 744) {   // ui_close
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    ui_close(g_ui, g_inventory, g_grid, g_events, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 745) {   // ui_on_event
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    ui_on_event(g_event, g_ui, g_inventory, g_grid, g_furnaces, g_events, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 746) {   // ui_layout
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
  } else if (p_id == 747) {   // ui_slot_rect
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
  } else if (p_id == 748) {   // ui_inventory_slot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = ui_inventory_slot(l_i1);
    Get_time(l_end);
  } else if (p_id == 749) {   // ui_chest_target
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = ui_chest_target(g_ui, l_i1);
    Get_time(l_end);
  } else if (p_id == 750) {   // ui_slot_at
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = ui_slot_at(l_i1, l_i2, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 751) {   // ui_click
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    ui_click(g_ui, g_inventory, g_grid, g_furnaces, g_book, g_events, l_r1, l_r2, l_i1, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 752) {   // ui_draw_arrow
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    ui_draw_arrow(g_test_box, l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 753) {   // ui_draw_furnace
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    ui_draw_furnace(g_test_box, g_furnaces, l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 754) {   // ui_draw_tab
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    ui_draw_tab(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 755) {   // ui_draw_scroll
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    ui_draw_scroll(g_test_box, l_r1, l_r2, l_r3, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 756) {   // ui_draw_search
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    ui_draw_search(g_test_box, g_ui, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 757) {   // ui_draw_titles
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    ui_draw_titles(g_test_box, l_i1, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 758) {   // ui_draw
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    ui_draw(g_test_box, l_r1, l_r2, g_ui, g_inventory, g_grid, g_furnaces, g_book);
    Get_time(l_end);
  } else if (p_id == 759) {   // render_init
    Get_time(l_start);
    render_init();
    Get_time(l_end);
  } else if (p_id == 760) {   // render_set_detail
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_set_detail(l_i1);
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
  if (p_id == 761) test_info_set(p_info, "render_view_from", "macro", "render", "render_world", "src/render/render_world.4dm", 70, 95, "void", "&A:p_player &A:p_settings R:p_time_of_day R:p_now",
                              "void render_view_from(Attributes &p_player, Attributes &p_settings, Real p_time_of_day, Real p_now)", 0, "", "player_break_stage, player_eye_in_water, player_target_cell, player_target_kind, record_integer, render_set_detail, settings_detail, settings_flag, settings_render_distance, settings_slim_arms, world_daylight, world_dimension");
  if (p_id == 762) test_info_set(p_info, "render_stats_text", "macro", "render", "render_world", "src/render/render_world.4dm", 97, 103, "Text", "",
                              "Text render_stats_text()", 0, "", "");
  if (p_id == 763) test_info_set(p_info, "render_set_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 107, 124, "void", "B:p_box R:p_red R:p_green R:p_blue",
                              "void render_set_colour(Draw_Box p_box, Real p_red, Real p_green, Real p_blue)", 0, "", "to_byte");
  if (p_id == 764) test_info_set(p_info, "render_forget_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 126, 133, "void", "",
                              "void render_forget_colour()", 0, "", "");
  if (p_id == 765) test_info_set(p_info, "render_set_shade", "macro", "render", "render_world", "src/render/render_world.4dm", 135, 142, "void", "R:p_shade",
                              "void render_set_shade(Real p_shade)", 0, "", "clamp_real");
  if (p_id == 766) test_info_set(p_info, "render_set_face_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 144, 160, "void", "B:p_box R:p_red R:p_green R:p_blue",
                              "void render_set_face_colour(Draw_Box p_box, Real p_red, Real p_green, Real p_blue)", 0, "", "");
  if (p_id == 767) test_info_set(p_info, "render_fill_rect", "macro", "render", "render_world", "src/render/render_world.4dm", 162, 176, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1",
                              "void render_fill_rect(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)", 0, "", "");
  if (p_id == 768) test_info_set(p_info, "render_line", "macro", "render", "render_world", "src/render/render_world.4dm", 178, 185, "void", "B:p_box R:p_x0 R:p_y0 R:p_x1 R:p_y1",
                              "void render_line(Draw_Box p_box, Real p_x0, Real p_y0, Real p_x1, Real p_y1)", 0, "", "");
  if (p_id == 769) test_info_set(p_info, "render_setup_camera", "macro", "render", "render_world", "src/render/render_world.4dm", 189, 244, "void", "R:p_w R:p_h R:p_view_bottom R:p_eye_x R:p_eye_y R:p_eye_z R:p_yaw R:p_pitch R:p_field_of_view",
                              "void render_setup_camera(Real p_w, Real p_h, Real p_view_bottom, Real p_eye_x, Real p_eye_y, Real p_eye_z, Real p_yaw, Real p_pitch, Real p_field_of_view)", 0, "", "min_real, render_sky_colours");
  if (p_id == 770) test_info_set(p_info, "render_to_camera", "macro", "render", "render_world", "src/render/render_world.4dm", 246, 255, "void", "R:p_rel_x R:p_rel_y R:p_rel_z",
                              "void render_to_camera(Real p_rel_x, Real p_rel_y, Real p_rel_z)", 0, "", "");
  if (p_id == 771) test_info_set(p_info, "render_sphere_visible", "macro", "render", "render_world", "src/render/render_world.4dm", 257, 271, "Integer", "R:p_rel_x R:p_rel_y R:p_rel_z R:p_radius",
                              "Integer render_sphere_visible(Real p_rel_x, Real p_rel_y, Real p_rel_z, Real p_radius)", 0, "", "render_to_camera");
  if (p_id == 772) test_info_set(p_info, "render_add_face", "macro", "render", "render_world", "src/render/render_world.4dm", 275, 337, "void", "R:p_c0x R:p_c0y R:p_c0z R:p_e1x R:p_e1y R:p_e1z R:p_e2x R:p_e2y R:p_e2z I:p_tex R:p_shade R:p_distance_squared R:p_size R:p_tint I:p_crack",
                              "void render_add_face(Real p_c0x, Real p_c0y, Real p_c0z, Real p_e1x, Real p_e1y, Real p_e1z, Real p_e2x, Real p_e2y, Real p_e2z, Integer p_tex, Real p_shade, Real p_distance_squared, Real p_size, Real p_tint, Integer p_crack)", 0, "", "clamp_real, max_real");
  if (p_id == 773) test_info_set(p_info, "render_add_block_face", "macro", "render", "render_world", "src/render/render_world.4dm", 339, 420, "void", "I:p_x I:p_y I:p_z I:p_direction I:p_block R:p_distance_squared I:p_crack R:p_light R:p_wet",
                              "void render_add_block_face(Integer p_x, Integer p_y, Integer p_z, Integer p_direction, Integer p_block, Real p_distance_squared, Integer p_crack, Real p_light, Real p_wet)", 0, "", "block_face_shade, block_face_texture, block_hides_faces, render_add_face");
  if (p_id == 774) test_info_set(p_info, "render_add_sprite", "macro", "render", "render_world", "src/render/render_world.4dm", 422, 437, "void", "R:p_rel_x R:p_rel_y R:p_rel_z R:p_half_width R:p_height I:p_tex R:p_shade R:p_distance_squared",
                              "void render_add_sprite(Real p_rel_x, Real p_rel_y, Real p_rel_z, Real p_half_width, Real p_height, Integer p_tex, Real p_shade, Real p_distance_squared)", 0, "", "render_add_face, render_to_camera");
  if (p_id == 775) test_info_set(p_info, "render_add_shaped", "macro", "render", "render_world", "src/render/render_world.4dm", 439, 491, "void", "I:p_x I:p_y I:p_z I:p_block R:p_light",
                              "void render_add_shaped(Integer p_x, Integer p_y, Integer p_z, Integer p_block, Real p_light)", 0, "", "block_box, block_door_top, block_is_bed, block_is_chest, render_add_bed, render_add_box, render_add_chest");
  if (p_id == 776) test_info_set(p_info, "render_facing_yaw", "macro", "render", "render_world", "src/render/render_world.4dm", 493, 503, "Real", "I:p_facing",
                              "Real render_facing_yaw(Integer p_facing)", 0, "", "");
  if (p_id == 777) test_info_set(p_info, "render_add_chest", "macro", "render", "render_world", "src/render/render_world.4dm", 505, 558, "void", "I:p_x I:p_y I:p_z I:p_block R:p_min_x R:p_min_z R:p_max_x R:p_max_z",
                              "void render_add_chest(Integer p_x, Integer p_y, Integer p_z, Integer p_block, Real p_min_x, Real p_min_z, Real p_max_x, Real p_max_z)", 0, "", "block_chest_facing, block_chest_type, chest_texture, render_add_box, render_add_lid, render_facing_yaw");
  if (p_id == 778) test_info_set(p_info, "render_add_lid", "macro", "render", "render_world", "src/render/render_world.4dm", 560, 568, "void", "R:p_cx R:p_cy R:p_cz R:p_yaw R:p_half_f R:p_half_y R:p_half_s I:p_tex",
                              "void render_add_lid(Real p_cx, Real p_cy, Real p_cz, Real p_yaw, Real p_half_f, Real p_half_y, Real p_half_s, Integer p_tex)", 0, "", "render_add_box");
  if (p_id == 779) test_info_set(p_info, "render_add_bed", "macro", "render", "render_world", "src/render/render_world.4dm", 570, 612, "void", "I:p_x I:p_y I:p_z I:p_block",
                              "void render_add_bed(Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "block_bed_facing, block_bed_head, render_add_box, render_facing_yaw");
  if (p_id == 780) test_info_set(p_info, "render_add_plant", "macro", "render", "render_world", "src/render/render_world.4dm", 614, 709, "void", "I:p_x I:p_y I:p_z I:p_tex R:p_light",
                              "void render_add_plant(Integer p_x, Integer p_y, Integer p_z, Integer p_tex, Real p_light)", 0, "", "render_add_face, render_to_camera");
  if (p_id == 781) test_info_set(p_info, "render_layer_count", "macro", "render", "render_world", "src/render/render_world.4dm", 711, 722, "Integer", "R:p_limit",
                              "Integer render_layer_count(Real p_limit)", 0, "", "floor_integer");
  if (p_id == 782) test_info_set(p_info, "render_collect_blocks", "macro", "render", "render_world", "src/render/render_world.4dm", 724, 929, "void", "",
                              "void render_collect_blocks()", 0, "", "block_is_shaped, block_plant_texture, clamp_integer, floor_integer, max_real, mesh_ensure_section, min_integer, render_add_block_face, render_add_plant, render_add_shaped, render_layer_count, render_sphere_visible");
  if (p_id == 783) test_info_set(p_info, "render_face_shade", "macro", "render", "render_world", "src/render/render_world.4dm", 931, 943, "Real", "R:p_normal_x R:p_normal_y R:p_normal_z",
                              "Real render_face_shade(Real p_normal_x, Real p_normal_y, Real p_normal_z)", 0, "", "");
  if (p_id == 784) test_info_set(p_info, "render_add_box", "macro", "render", "render_world", "src/render/render_world.4dm", 945, 1048, "void", "R:p_centre_x R:p_centre_y R:p_centre_z R:p_yaw R:p_pitch R:p_half_f R:p_half_y R:p_half_s I:p_tex_side I:p_tex_top I:p_tex_front I:p_tex_back R:p_tint R:p_sort_dist_sq",
                              "void render_add_box(Real p_centre_x, Real p_centre_y, Real p_centre_z, Real p_yaw, Real p_pitch, Real p_half_f, Real p_half_y, Real p_half_s, Integer p_tex_side, Integer p_tex_top, Integer p_tex_front, Integer p_tex_back, Real p_tint, Real p_sort_dist_sq)", 0, "", "max_real, render_add_face, render_face_shade, render_sphere_visible, render_to_camera");
  if (p_id == 785) test_info_set(p_info, "render_light_at", "macro", "render", "render_world", "src/render/render_world.4dm", 1050, 1059, "Real", "R:p_x R:p_y R:p_z",
                              "Real render_light_at(Real p_x, Real p_y, Real p_z)", 0, "", "floor_integer, max_real, world_get_light");
  if (p_id == 786) test_info_set(p_info, "render_mob_begin", "macro", "render", "render_world", "src/render/render_world.4dm", 1061, 1073, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_tint",
                              "void render_mob_begin(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_tint)", 0, "", "");
  if (p_id == 787) test_info_set(p_info, "render_mob_part", "macro", "render", "render_world", "src/render/render_world.4dm", 1075, 1110, "void", "R:p_along R:p_up R:p_across R:p_half_f R:p_half_y R:p_half_s R:p_turn R:p_pitch I:p_hip I:p_tex_side I:p_tex_top I:p_tex_front I:p_tex_back",
                              "void render_mob_part(Real p_along, Real p_up, Real p_across, Real p_half_f, Real p_half_y, Real p_half_s, Real p_turn, Real p_pitch, Integer p_hip, Integer p_tex_side, Integer p_tex_top, Integer p_tex_front, Integer p_tex_back)", 0, "", "");
  if (p_id == 788) test_info_set(p_info, "render_mob_part_nearer", "macro", "render", "render_world", "src/render/render_world.4dm", 1112, 1135, "Integer", "I:p_a I:p_b R:p_eye_along R:p_eye_up R:p_eye_across",
                              "Integer render_mob_part_nearer(Integer p_a, Integer p_b, Real p_eye_along, Real p_eye_up, Real p_eye_across)", 0, "", "");
  if (p_id == 789) test_info_set(p_info, "render_mob_end", "macro", "render", "render_world", "src/render/render_world.4dm", 1137, 1180, "void", "",
                              "void render_mob_end()", 0, "", "render_add_box, render_mob_part_nearer");
  if (p_id == 790) test_info_set(p_info, "render_mob_head_look", "macro", "render", "render_world", "src/render/render_world.4dm", 1182, 1203, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_head_up R:p_idle &R:p_turn &R:p_pitch",
                              "void render_mob_head_look(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_head_up, Real p_idle, Real &p_turn, Real &p_pitch)", 0, "", "angle_of, clamp_real, wrap_angle");
  if (p_id == 791) test_info_set(p_info, "render_zombie", "macro", "render", "render_world", "src/render/render_world.4dm", 1205, 1224, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_swing R:p_tint R:p_idle",
                              "void render_zombie(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)", 0, "", "render_mob_begin, render_mob_end, render_mob_head_look, render_mob_part");
  if (p_id == 792) test_info_set(p_info, "render_cow", "macro", "render", "render_world", "src/render/render_world.4dm", 1226, 1253, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_swing R:p_tint R:p_idle",
                              "void render_cow(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)", 0, "", "render_mob_begin, render_mob_end, render_mob_head_look, render_mob_part");
  if (p_id == 793) test_info_set(p_info, "render_pig", "macro", "render", "render_world", "src/render/render_world.4dm", 1255, 1278, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_swing R:p_tint R:p_idle",
                              "void render_pig(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_swing, Real p_tint, Real p_idle)", 0, "", "render_mob_begin, render_mob_end, render_mob_head_look, render_mob_part");
  if (p_id == 794) test_info_set(p_info, "render_person", "macro", "render", "render_world", "src/render/render_world.4dm", 1280, 1350, "void", "R:p_x R:p_y R:p_z R:p_yaw R:p_head_turn R:p_pitch R:p_swing I:p_crouch I:p_helmet I:p_chestplate I:p_leggings I:p_boots",
                              "void render_person(Real p_x, Real p_y, Real p_z, Real p_yaw, Real p_head_turn, Real p_pitch, Real p_swing, Integer p_crouch, Integer p_helmet, Integer p_chestplate, Integer p_leggings, Integer p_boots)", 0, "", "item_worn_texture, render_mob_begin, render_mob_end, render_mob_part");
  if (p_id == 795) test_info_set(p_info, "render_camera_place", "macro", "render", "render_world", "src/render/render_world.4dm", 1352, 1403, "void", "&A:p_player &R:p_x &R:p_y &R:p_z &R:p_yaw &R:p_pitch",
                              "void render_camera_place(Attributes &p_player, Real &p_x, Real &p_y, Real &p_z, Real &p_yaw, Real &p_pitch)", 0, "", "block_is_solid, floor_integer, max_real, min_real, player_camera, player_eye_y, player_look, player_position, world_get_block, wrap_angle");
  if (p_id == 796) test_info_set(p_info, "render_collect_self", "macro", "render", "render_world", "src/render/render_world.4dm", 1405, 1426, "void", "&A:p_player &A:p_inventory",
                              "void render_collect_self(Attributes &p_player, Attributes &p_inventory)", 0, "", "angle_difference, inventory_armour_slot, player_body_yaw, player_camera, player_crouching, player_look, player_position, player_spectator, player_step, player_stride, render_light_at, render_person, slot_item");
  if (p_id == 797) test_info_set(p_info, "render_collect_peers", "macro", "render", "render_world", "src/render/render_world.4dm", 1428, 1447, "void", "&A:p_peers",
                              "void render_collect_peers(Attributes &p_peers)", 0, "", "peer_dimension, peer_here, peer_pitch, peer_position, peer_step, peer_yaw, peers_count, render_light_at, render_person, world_dimension");
  if (p_id == 798) test_info_set(p_info, "render_peer_names", "macro", "render", "render_world", "src/render/render_world.4dm", 1449, 1479, "void", "B:p_box &A:p_peers",
                              "void render_peer_names(Draw_Box p_box, Attributes &p_peers)", 0, "", "hud_text, peer_dimension, peer_here, peer_name, peer_position, peers_count, render_fill_rect, render_set_colour, render_to_camera, world_dimension");
  if (p_id == 799) test_info_set(p_info, "render_collect_cows", "macro", "render", "render_world", "src/render/render_world.4dm", 1481, 1518, "void", "&A:p_cows",
                              "void render_collect_cows(Attributes &p_cows)", 0, "", "cow_flash, cow_position, cow_step, cow_yaw, mob_kind, render_cow, render_light_at, render_pig, render_zombie, slots_at, slots_count");
  if (p_id == 800) test_info_set(p_info, "render_collect_drops", "macro", "render", "render_world", "src/render/render_world.4dm", 1520, 1554, "void", "&A:p_drops",
                              "void render_collect_drops(Attributes &p_drops)", 0, "", "drop_age, drop_item, drop_position, item_is_block, item_side_texture, item_sprite_texture, item_top_texture, render_add_box, render_add_sprite, render_light_at, render_sphere_visible, slots_at, slots_count");
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 761) {   // render_view_from
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    render_view_from(g_player, g_settings, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 762) {   // render_stats_text
    Get_time(l_start);
    l_ret_t = render_stats_text();
    Get_time(l_end);
  } else if (p_id == 763) {   // render_set_colour
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    render_set_colour(g_test_box, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 764) {   // render_forget_colour
    Get_time(l_start);
    render_forget_colour();
    Get_time(l_end);
  } else if (p_id == 765) {   // render_set_shade
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_set_shade(l_r1);
    Get_time(l_end);
  } else if (p_id == 766) {   // render_set_face_colour
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    render_set_face_colour(g_test_box, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 767) {   // render_fill_rect
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_fill_rect(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 768) {   // render_line
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_line(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 769) {   // render_setup_camera
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
  } else if (p_id == 770) {   // render_to_camera
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    render_to_camera(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 771) {   // render_sphere_visible
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_i = render_sphere_visible(l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 772) {   // render_add_face
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
  } else if (p_id == 773) {   // render_add_block_face
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
  } else if (p_id == 774) {   // render_add_sprite
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
  } else if (p_id == 775) {   // render_add_shaped
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_add_shaped(l_i1, l_i2, l_i3, l_i4, l_r1);
    Get_time(l_end);
  } else if (p_id == 776) {   // render_facing_yaw
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_r = render_facing_yaw(l_i1);
    Get_time(l_end);
  } else if (p_id == 777) {   // render_add_chest
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_add_chest(l_i1, l_i2, l_i3, l_i4, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 778) {   // render_add_lid
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    l_r7 = record_real(p_in, ATTR_TEST_R7);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_add_lid(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6, l_r7, l_i1);
    Get_time(l_end);
  } else if (p_id == 779) {   // render_add_bed
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    render_add_bed(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 780) {   // render_add_plant
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_add_plant(l_i1, l_i2, l_i3, l_i4, l_r1);
    Get_time(l_end);
  } else if (p_id == 781) {   // render_layer_count
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = render_layer_count(l_r1);
    Get_time(l_end);
  } else if (p_id == 782) {   // render_collect_blocks
    Get_time(l_start);
    render_collect_blocks();
    Get_time(l_end);
  } else if (p_id == 783) {   // render_face_shade
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = render_face_shade(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 784) {   // render_add_box
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
  } else if (p_id == 785) {   // render_light_at
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_r = render_light_at(l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 786) {   // render_mob_begin
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    render_mob_begin(l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 787) {   // render_mob_part
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
  } else if (p_id == 788) {   // render_mob_part_nearer
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    l_ret_i = render_mob_part_nearer(l_i1, l_i2, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 789) {   // render_mob_end
    Get_time(l_start);
    render_mob_end();
    Get_time(l_end);
  } else if (p_id == 790) {   // render_mob_head_look
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
  } else if (p_id == 791) {   // render_zombie
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
  } else if (p_id == 792) {   // render_cow
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
  } else if (p_id == 793) {   // render_pig
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
  } else if (p_id == 794) {   // render_person
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
  } else if (p_id == 795) {   // render_camera_place
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
  } else if (p_id == 796) {   // render_collect_self
    Get_time(l_start);
    render_collect_self(g_player, g_inventory);
    Get_time(l_end);
  } else if (p_id == 797) {   // render_collect_peers
    Get_time(l_start);
    render_collect_peers(g_peers);
    Get_time(l_end);
  } else if (p_id == 798) {   // render_peer_names
    Get_time(l_start);
    render_peer_names(g_test_box, g_peers);
    Get_time(l_end);
  } else if (p_id == 799) {   // render_collect_cows
    Get_time(l_start);
    render_collect_cows(g_cows);
    Get_time(l_end);
  } else if (p_id == 800) {   // render_collect_drops
    Get_time(l_start);
    render_collect_drops(g_drops);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_21(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 801 to 840 are
// ----------------------------------------------------------------
{
  if (p_id == 801) test_info_set(p_info, "render_clip_screen_edge", "macro", "render", "render_world", "src/render/render_world.4dm", 1558, 1609, "void", "I:p_axis R:p_limit I:p_keep_above",
                              "void render_clip_screen_edge(Integer p_axis, Real p_limit, Integer p_keep_above)", 0, "", "");
  if (p_id == 802) test_info_set(p_info, "render_clip_and_draw", "macro", "render", "render_world", "src/render/render_world.4dm", 1611, 1676, "Integer", "B:p_box",
                              "Integer render_clip_and_draw(Draw_Box p_box)", 0, "", "render_clip_screen_edge");
  if (p_id == 803) test_info_set(p_info, "render_quad", "macro", "render", "render_world", "src/render/render_world.4dm", 1678, 1737, "void", "B:p_box R:p_u0 R:p_v0 R:p_u1 R:p_v1",
                              "void render_quad(Draw_Box p_box, Real p_u0, Real p_v0, Real p_u1, Real p_v1)", 0, "", "render_clip_and_draw");
  if (p_id == 804) test_info_set(p_info, "render_face_line", "macro", "render", "render_world", "src/render/render_world.4dm", 1739, 1768, "void", "B:p_box R:p_u0 R:p_v0 R:p_u1 R:p_v1",
                              "void render_face_line(Draw_Box p_box, Real p_u0, Real p_v0, Real p_u1, Real p_v1)", 0, "", "render_line");
  if (p_id == 805) test_info_set(p_info, "render_palette_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 1770, 1781, "void", "B:p_box I:p_tex I:p_index",
                              "void render_palette_colour(Draw_Box p_box, Integer p_tex, Integer p_index)", 0, "", "render_set_face_colour, texture_palette_index");
  if (p_id == 806) test_info_set(p_info, "render_draw_crack", "macro", "render", "render_world", "src/render/render_world.4dm", 1783, 1812, "void", "B:p_box I:p_tex",
                              "void render_draw_crack(Draw_Box p_box, Integer p_tex)", 0, "", "render_quad, render_set_face_colour, texture_palette_index");
  if (p_id == 807) test_info_set(p_info, "render_animated_texture", "macro", "render", "render_world", "src/render/render_world.4dm", 1814, 1830, "Integer", "I:p_tex",
                              "Integer render_animated_texture(Integer p_tex)", 0, "", "floor_integer, positive_mod");
  if (p_id == 808) test_info_set(p_info, "render_draw_face", "macro", "render", "render_world", "src/render/render_world.4dm", 1832, 1967, "void", "B:p_box I:p_face",
                              "void render_draw_face(Draw_Box p_box, Integer p_face)", 0, "", "render_animated_texture, render_draw_crack, render_palette_colour, render_quad, render_set_colour, render_set_face_colour");
  if (p_id == 809) test_info_set(p_info, "render_cover_reset", "macro", "render", "render_world", "src/render/render_world.4dm", 1969, 1988, "void", "",
                              "void render_cover_reset()", 0, "", "");
  if (p_id == 810) test_info_set(p_info, "render_cover_add", "macro", "render", "render_world", "src/render/render_world.4dm", 1990, 2041, "void", "I:p_line R:p_low R:p_high",
                              "void render_cover_add(Integer p_line, Real p_low, Real p_high)", 0, "", "");
  if (p_id == 811) test_info_set(p_info, "render_cover_corners", "macro", "render", "render_world", "src/render/render_world.4dm", 2043, 2071, "void", "I:p_face",
                              "void render_cover_corners(Integer p_face)", 0, "", "");
  if (p_id == 812) test_info_set(p_info, "render_cover_face", "macro", "render", "render_world", "src/render/render_world.4dm", 2073, 2172, "void", "I:p_face",
                              "void render_cover_face(Integer p_face)", 0, "", "clamp_integer, render_cover_add, render_cover_corners");
  if (p_id == 813) test_info_set(p_info, "render_hide_covered", "macro", "render", "render_world", "src/render/render_world.4dm", 2174, 2197, "void", "",
                              "void render_hide_covered()", 0, "", "render_cover_face, render_cover_reset");
  if (p_id == 814) test_info_set(p_info, "render_draw_faces", "macro", "render", "render_world", "src/render/render_world.4dm", 2199, 2218, "void", "B:p_box",
                              "void render_draw_faces(Draw_Box p_box)", 0, "", "render_draw_face");
  if (p_id == 815) test_info_set(p_info, "render_sky_colours", "macro", "render", "render_world", "src/render/render_world.4dm", 2222, 2253, "void", "R:p_time_of_day",
                              "void render_sky_colours(Real p_time_of_day)", 0, "", "clamp_real, lerp_real, world_dimension, world_sun_height");
  if (p_id == 816) test_info_set(p_info, "render_sky_disc", "macro", "render", "render_world", "src/render/render_world.4dm", 2255, 2281, "void", "B:p_box R:p_dir_x R:p_dir_y R:p_dir_z R:p_size I:p_moon",
                              "void render_sky_disc(Draw_Box p_box, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_size, Integer p_moon)", 0, "", "render_fill_rect, render_set_colour, render_to_camera");
  if (p_id == 817) test_info_set(p_info, "render_stars", "macro", "render", "render_world", "src/render/render_world.4dm", 2283, 2303, "void", "B:p_box R:p_brightness",
                              "void render_stars(Draw_Box p_box, Real p_brightness)", 0, "", "lerp_real, render_fill_rect, render_set_colour, render_to_camera");
  if (p_id == 818) test_info_set(p_info, "render_sky", "macro", "render", "render_world", "src/render/render_world.4dm", 2305, 2352, "void", "B:p_box",
                              "void render_sky(Draw_Box p_box)", 0, "", "clamp_real, lerp_real, render_fill_rect, render_set_colour, render_sky_disc, render_stars, world_dimension");
  if (p_id == 819) test_info_set(p_info, "render_point_visible", "macro", "render", "render_world", "src/render/render_world.4dm", 2354, 2424, "Integer", "R:p_x R:p_y R:p_z I:p_skip_x I:p_skip_y I:p_skip_z",
                              "Integer render_point_visible(Real p_x, Real p_y, Real p_z, Integer p_skip_x, Integer p_skip_y, Integer p_skip_z)", 0, "", "block_hides_faces, world_get_block");
  if (p_id == 820) test_info_set(p_info, "render_world_line", "macro", "render", "render_world", "src/render/render_world.4dm", 2426, 2464, "void", "B:p_box R:p_x0 R:p_y0 R:p_z0 R:p_x1 R:p_y1 R:p_z1",
                              "void render_world_line(Draw_Box p_box, Real p_x0, Real p_y0, Real p_z0, Real p_x1, Real p_y1, Real p_z1)", 0, "", "render_line, render_to_camera");
  if (p_id == 821) test_info_set(p_info, "render_target_outline", "macro", "render", "render_world", "src/render/render_world.4dm", 2466, 2595, "void", "B:p_box",
                              "void render_target_outline(Draw_Box p_box)", 0, "", "block_box, render_point_visible, render_set_colour, render_world_line, world_get_block");
  if (p_id == 822) test_info_set(p_info, "render_ray_colour", "macro", "render", "render_world", "src/render/render_world.4dm", 2597, 2714, "Integer", "R:p_x R:p_y R:p_z R:p_dir_x R:p_dir_y R:p_dir_z R:p_distance",
                              "Integer render_ray_colour(Real p_x, Real p_y, Real p_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_distance)", 0, "", "block_face_shade, block_face_texture, block_is_plant, block_is_solid, block_light_emission, clamp_real, floor_integer, lerp_real, max_real, to_byte, world_get_block, world_in_bounds");
  if (p_id == 823) test_info_set(p_info, "render_world", "macro", "render", "render_world", "src/render/render_world.4dm", 2716, 2759, "void", "B:p_box R:p_w R:p_h R:p_view_bottom &A:p_player &A:p_inventory &A:p_cows &A:p_drops &A:p_peers &A:p_settings R:p_time_of_day R:p_now",
                              "void render_world(Draw_Box p_box, Real p_w, Real p_h, Real p_view_bottom, Attributes &p_player, Attributes &p_inventory, Attributes &p_cows, Attributes &p_drops, Attributes &p_peers, Attributes &p_settings, Real p_time_of_day, Real p_now)", 0, "", "clamp_real, mesh_build_nearby, min_integer, player_portal_time, render_camera_place, render_collect_blocks, render_collect_cows, render_collect_drops, render_collect_peers, render_collect_self, render_draw_faces, render_hide_covered, render_peer_names, render_setup_camera, render_sky, render_target_outline, render_view_from, settings_fov_radians");
  if (p_id == 824) test_info_set(p_info, "font_choice", "macro", "ui", "font", "src/ui/font.4dm", 8, 25, "Text", "I:p_index",
                              "Text font_choice(Integer p_index)", 0, "", "");
  if (p_id == 825) test_info_set(p_info, "font_choice_index", "macro", "ui", "font", "src/ui/font.4dm", 27, 38, "Integer", "T:p_font",
                              "Integer font_choice_index(Text p_font)", 0, "", "font_choice");
  if (p_id == 826) test_info_set(p_info, "font_next_choice", "macro", "ui", "font", "src/ui/font.4dm", 40, 50, "Text", "T:p_font",
                              "Text font_next_choice(Text p_font)", 0, "", "font_choice, font_choice_index");
  if (p_id == 827) test_info_set(p_info, "font_read_u16", "macro", "ui", "font", "src/ui/font.4dm", 52, 66, "Integer", "&?:p_file I:p_position",
                              "Integer font_read_u16(File &p_file, Integer p_position)", 0, "takes an open File", "");
  if (p_id == 828) test_info_set(p_info, "font_read_u32_high", "macro", "ui", "font", "src/ui/font.4dm", 68, 75, "Integer", "&?:p_file I:p_position",
                              "Integer font_read_u32_high(File &p_file, Integer p_position)", 0, "takes an open File", "font_read_u16");
  if (p_id == 829) test_info_set(p_info, "font_family_from_file", "macro", "ui", "font", "src/ui/font.4dm", 77, 203, "Integer", "T:p_path &T:p_family &T:p_report",
                              "Integer font_family_from_file(Text p_path, Text &p_family, Text &p_report)", 0, "", "font_read_u16, font_read_u32_high");
  if (p_id == 830) test_info_set(p_info, "font_apply", "macro", "ui", "font", "src/ui/font.4dm", 205, 212, "void", "B:p_box T:p_font",
                              "void font_apply(Draw_Box p_box, Text p_font)", 0, "", "");
  if (p_id == 831) test_info_set(p_info, "game_panel_split_xy", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 51, 63, "Integer", "T:p_msg &R:p_x &R:p_y",
                              "Integer game_panel_split_xy(Text p_msg, Real &p_x, Real &p_y)", 0, "", "");
  if (p_id == 832) test_info_set(p_info, "game_panel_calibrate", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 65, 94, "Integer", "B:p_box R:p_box_x R:p_box_y I:p_width I:p_height &I:p_origin_x &I:p_origin_y",
                              "Integer game_panel_calibrate(Draw_Box p_box, Real p_box_x, Real p_box_y, Integer p_width, Integer p_height, Integer &p_origin_x, Integer &p_origin_y)", 0, "", "");
  if (p_id == 833) test_info_set(p_info, "game_panel_notice", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 96, 119, "void", "B:p_box T:p_title T:p_line",
                              "void game_panel_notice(Draw_Box p_box, Text p_title, Text p_line)", 0, "", "font_apply, hud_shadow_text, menu_background, render_forget_colour, settings_font");
  if (p_id == 834) test_info_set(p_info, "game_panel_lan_join", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 121, 181, "Integer", "B:p_box T:p_found T:p_player_id &T:p_folder &T:p_problem",
                              "Integer game_panel_lan_join(Draw_Box p_box, Text p_found, Text p_player_id, Text &p_folder, Text &p_problem)", 1, "", "game_panel_notice, lan_folder, lan_join_dir, lan_run_check, lan_run_name, lan_run_start, lan_run_state, lan_run_stop, net_read_session, net_read_session_address");
  if (p_id == 835) test_info_set(p_info, "game_panel_lan_host", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 183, 217, "Integer", "B:p_box T:p_session T:p_player_id &T:p_problem",
                              "Integer game_panel_lan_host(Draw_Box p_box, Text p_session, Text p_player_id, Text &p_problem)", 1, "", "lan_host_dir, lan_run_check, lan_run_start, lan_run_state, lan_run_stop");
  if (p_id == 836) test_info_set(p_info, "game_panel_lan_stop", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 219, 225, "void", "",
                              "void game_panel_lan_stop()", 1, "", "lan_run_stop");
  if (p_id == 837) test_info_set(p_info, "game_panel_dispatch", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 227, 233, "void", "R:p_now",
                              "void game_panel_dispatch(Real p_now)", 0, "", "game_dispatch_events");
  if (p_id == 838) test_info_set(p_info, "game_panel_save", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 235, 248, "Integer", "",
                              "Integer game_panel_save()", 1, "", "game_save_world, save_note_played");
  if (p_id == 839) test_info_set(p_info, "game_panel_close_screen", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 250, 261, "void", "",
                              "void game_panel_close_screen()", 0, "", "player_position, ui_close, ui_screen");
  if (p_id == 840) test_info_set(p_info, "game_panel_backdrop", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 263, 271, "void", "B:p_box R:p_w R:p_h R:p_now",
                              "void game_panel_backdrop(Draw_Box p_box, Real p_w, Real p_h, Real p_now)", 0, "", "render_set_shade, render_world, world_time_of_day");
}

void test_registry_call_21(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 801 to 840 (see the header)
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 801) {   // render_clip_screen_edge
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    render_clip_screen_edge(l_i1, l_r1, l_i2);
    Get_time(l_end);
  } else if (p_id == 802) {   // render_clip_and_draw
    Get_time(l_start);
    l_ret_i = render_clip_and_draw(g_test_box);
    Get_time(l_end);
  } else if (p_id == 803) {   // render_quad
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_quad(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 804) {   // render_face_line
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    render_face_line(g_test_box, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 805) {   // render_palette_colour
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    render_palette_colour(g_test_box, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 806) {   // render_draw_crack
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_draw_crack(g_test_box, l_i1);
    Get_time(l_end);
  } else if (p_id == 807) {   // render_animated_texture
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = render_animated_texture(l_i1);
    Get_time(l_end);
  } else if (p_id == 808) {   // render_draw_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_draw_face(g_test_box, l_i1);
    Get_time(l_end);
  } else if (p_id == 809) {   // render_cover_reset
    Get_time(l_start);
    render_cover_reset();
    Get_time(l_end);
  } else if (p_id == 810) {   // render_cover_add
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    render_cover_add(l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 811) {   // render_cover_corners
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_cover_corners(l_i1);
    Get_time(l_end);
  } else if (p_id == 812) {   // render_cover_face
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_cover_face(l_i1);
    Get_time(l_end);
  } else if (p_id == 813) {   // render_hide_covered
    Get_time(l_start);
    render_hide_covered();
    Get_time(l_end);
  } else if (p_id == 814) {   // render_draw_faces
    Get_time(l_start);
    render_draw_faces(g_test_box);
    Get_time(l_end);
  } else if (p_id == 815) {   // render_sky_colours
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_sky_colours(l_r1);
    Get_time(l_end);
  } else if (p_id == 816) {   // render_sky_disc
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    render_sky_disc(g_test_box, l_r1, l_r2, l_r3, l_r4, l_i1);
    Get_time(l_end);
  } else if (p_id == 817) {   // render_stars
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    render_stars(g_test_box, l_r1);
    Get_time(l_end);
  } else if (p_id == 818) {   // render_sky
    Get_time(l_start);
    render_sky(g_test_box);
    Get_time(l_end);
  } else if (p_id == 819) {   // render_point_visible
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = render_point_visible(l_r1, l_r2, l_r3, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 820) {   // render_world_line
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    render_world_line(g_test_box, l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
  } else if (p_id == 821) {   // render_target_outline
    Get_time(l_start);
    render_target_outline(g_test_box);
    Get_time(l_end);
  } else if (p_id == 822) {   // render_ray_colour
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
  } else if (p_id == 823) {   // render_world
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    render_world(g_test_box, l_r1, l_r2, l_r3, g_player, g_inventory, g_cows, g_drops, g_peers, g_settings, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 824) {   // font_choice
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = font_choice(l_i1);
    Get_time(l_end);
  } else if (p_id == 825) {   // font_choice_index
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = font_choice_index(l_t1);
    Get_time(l_end);
  } else if (p_id == 826) {   // font_next_choice
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = font_next_choice(l_t1);
    Get_time(l_end);
  } else if (p_id == 829) {   // font_family_from_file
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = font_family_from_file(l_t1, l_t2, l_t3);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
  } else if (p_id == 830) {   // font_apply
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    font_apply(g_test_box, l_t1);
    Get_time(l_end);
  } else if (p_id == 831) {   // game_panel_split_xy
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = game_panel_split_xy(l_t1, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 832) {   // game_panel_calibrate
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
  } else if (p_id == 833) {   // game_panel_notice
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    game_panel_notice(g_test_box, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 834) {   // game_panel_lan_join
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    l_t4 = record_text(p_in, ATTR_TEST_T4);
    Get_time(l_start);
    l_ret_i = game_panel_lan_join(g_test_box, l_t1, l_t2, l_t3, l_t4);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
    record_set_text(p_out, ATTR_TEST_T4, l_t4);
  } else if (p_id == 835) {   // game_panel_lan_host
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    l_t3 = record_text(p_in, ATTR_TEST_T3);
    Get_time(l_start);
    l_ret_i = game_panel_lan_host(g_test_box, l_t1, l_t2, l_t3);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T3, l_t3);
  } else if (p_id == 836) {   // game_panel_lan_stop
    Get_time(l_start);
    game_panel_lan_stop();
    Get_time(l_end);
  } else if (p_id == 837) {   // game_panel_dispatch
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    game_panel_dispatch(l_r1);
    Get_time(l_end);
  } else if (p_id == 838) {   // game_panel_save
    Get_time(l_start);
    l_ret_i = game_panel_save();
    Get_time(l_end);
  } else if (p_id == 839) {   // game_panel_close_screen
    Get_time(l_start);
    game_panel_close_screen();
    Get_time(l_end);
  } else if (p_id == 840) {   // game_panel_backdrop
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    game_panel_backdrop(g_test_box, l_r1, l_r2, l_r3);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_22(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 841 to 880 are
// ----------------------------------------------------------------
{
  if (p_id == 841) test_info_set(p_info, "game_panel_render", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 273, 317, "void", "B:p_box I:p_captured R:p_frame_ms R:p_now",
                              "void game_panel_render(Draw_Box p_box, Integer p_captured, Real p_frame_ms, Real p_now)", 0, "", "font_apply, hud_draw, hud_text, net_mode, net_players_text, render_forget_colour, render_set_shade, render_stats_text, render_world, settings_font, ui_draw, ui_screen, world_info_seed, world_time_of_day");
  if (p_id == 842) test_info_set(p_info, "game_panel_run", "macro", "ui", "game_panel", "src/ui/game_panel.4dm", 319, 1012, "Integer", "B:p_box ?:p_keys T:p_world_name I:p_mode I:p_seed I:p_game_mode",
                              "Integer game_panel_run(Draw_Box p_box, Input_Box p_keys, Text p_world_name, Integer p_mode, Integer p_seed, Integer p_game_mode)", 1, "opens a panel and waits for events", "command_run, emit_event, game_build_nearby, game_host, game_join, game_load_world, game_new_world, game_panel_calibrate, game_panel_close_screen, game_panel_dispatch, game_panel_lan_host, game_panel_lan_join, game_panel_lan_stop, game_panel_notice, game_panel_render, game_panel_save, game_panel_split_xy, game_respawn, game_select_slot, game_travel, game_update, game_world_name, hud_chat, hud_note_frame, hud_pause_button_at, hud_set_chat_input, hud_set_mouse, hud_set_waiting, hud_show_name, hud_toast, hud_waiting, inventory_swap_hands, key_base, key_label, key_modifier, key_name, lan_folder, lan_host_dir, lan_run_check, lan_run_clear, lan_run_stop, lan_word, menu_begin, net_clean_name, net_clear, net_flush, net_leave, net_mode, net_poll, net_say, player_auto_walk, player_creative, player_drop_selected, player_flying, player_is_dead, player_key_pressed, player_next_camera, player_pick_block, player_primary_action, player_secondary_action, player_selected, player_set_auto_walk, player_sneak_pressed, player_spectator, player_sprint_pressed, player_turn, player_wants_travel, random_range, record_integer, record_set_integer, save_note_played, save_settings_path, save_take_thumbnail, settings_bind, settings_bind_pressed, settings_change, settings_describe, settings_flag, settings_mouse_scale, settings_mp_folder, settings_panel_run, settings_render_distance, settings_save, settings_toggle, text_after_key, ui_click, ui_screen, ui_set_mouse, ui_set_tabs, ui_type_search, world_dimension");
  if (p_id == 843) test_info_set(p_info, "app_run", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 25, 64, "Integer", "",
                              "Integer app_run()", 1, "opens a panel and waits for events", "game_panel_run, menu_panel_run, record_integer, record_text");
  if (p_id == 844) test_info_set(p_info, "menu_open_worlds", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 66, 77, "void", "&A:p_menu &A:p_worlds",
                              "void menu_open_worlds(Attributes &p_menu, Attributes &p_worlds)", 1, "", "menu_set_field_text, menu_set_focus, menu_set_pick, record_set_integer, save_list_worlds_about");
  if (p_id == 845) test_info_set(p_info, "menu_free_world_name", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 79, 89, "Text", "T:p_base",
                              "Text menu_free_world_name(Text p_base)", 0, "", "save_world_exists");
  if (p_id == 846) test_info_set(p_info, "menu_turned", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 91, 97, "Integer", "R:p_last_frame R:p_now",
                              "Integer menu_turned(Real p_last_frame, Real p_now)", 0, "", "");
  if (p_id == 847) test_info_set(p_info, "menu_splash", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 99, 111, "Text", "I:p_pick",
                              "Text menu_splash(Integer p_pick)", 0, "", "");
  if (p_id == 848) test_info_set(p_info, "menu_background", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 113, 126, "void", "B:p_box R:p_w R:p_h I:p_title R:p_now",
                              "void menu_background(Draw_Box p_box, Real p_w, Real p_h, Integer p_title, Real p_now)", 0, "", "menu_draw_panorama");
  if (p_id == 849) test_info_set(p_info, "menu_panel_lan_folder", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 128, 136, "Text", "&A:p_settings",
                              "Text menu_panel_lan_folder(Attributes &p_settings)", 0, "", "lan_run_folder, settings_flag, settings_mp_folder");
  if (p_id == 850) test_info_set(p_info, "menu_panel_run", "macro", "ui", "menu_panel", "src/ui/menu_panel.4dm", 138, 432, "Integer", "B:p_box ?:p_keys &A:p_game &A:p_random &A:p_settings",
                              "Integer menu_panel_run(Draw_Box p_box, Input_Box p_keys, Attributes &p_game, Attributes &p_random, Attributes &p_settings)", 1, "opens a panel and waits for events", "font_apply, game_panel_split_xy, key_name, lan_run_check, lan_run_clear, lan_run_name, lan_run_start, lan_run_stop, lan_scan_dir, menu_at, menu_background, menu_clear, menu_field_text, menu_focus, menu_free_world_name, menu_note, menu_open_worlds, menu_panel_lan_folder, menu_pick, menu_scroll_to, menu_set_field_text, menu_set_focus, menu_set_mouse, menu_set_pick, menu_slider_value_at, menu_splash, menu_turned, menu_type_key, menu_widget_id, menu_widget_kind, menu_widget_of, net_list_lan, random_range, record_integer, record_set_integer, record_set_text, record_text, record_text_at, render_forget_colour, save_delete_world, save_world_exists, screen_create, screen_delete, screen_multiplayer, screen_title, screen_worlds, settings_flag, settings_font, settings_panel_run, text_is_safe_name, text_to_seed");
  if (p_id == 851) test_info_set(p_info, "settings_slider", "macro", "ui", "settings_panel", "src/ui/settings_panel.4dm", 22, 40, "void", "&A:p_settings I:p_id R:p_value",
                              "void settings_slider(Attributes &p_settings, Integer p_id, Real p_value)", 0, "", "clamp_integer, floor_integer, record_set_integer");
  if (p_id == 852) test_info_set(p_info, "settings_panel_run", "macro", "ui", "settings_panel", "src/ui/settings_panel.4dm", 42, 381, "Integer", "B:p_box ?:p_keys &A:p_settings I:p_in_game I:p_screen",
                              "Integer settings_panel_run(Draw_Box p_box, Input_Box p_keys, Attributes &p_settings, Integer p_in_game, Integer p_screen)", 1, "opens a panel and waits for events", "font_apply, font_choice, font_family_from_file, game_load_textures, game_panel_backdrop, game_panel_notice, game_panel_split_xy, key_base, key_modifier, key_name, menu_at, menu_background, menu_begin, menu_clear, menu_field_text, menu_focus, menu_note, menu_scroll_to, menu_set_field_text, menu_set_focus, menu_set_mouse, menu_slider_value_at, menu_turned, menu_type_key, menu_widget_id, menu_widget_kind, menu_widget_of, positive_mod, record_integer, record_set_integer, record_text_at, render_forget_colour, save_ensure_folder, save_file_name, save_list_files, save_settings_path, screen_controls, screen_fonts, screen_lan, screen_options, screen_packs, screen_player, screen_skins, settings_bind, settings_bind_default, settings_defaults, settings_detail, settings_flag, settings_font, settings_font_file, settings_mp_folder, settings_reset_binds, settings_resource_pack, settings_save, settings_set_bind, settings_set_font, settings_set_font_file, settings_set_resource_pack, settings_set_text, settings_skin, settings_slider, settings_toggle");
  if (p_id == 853) test_info_set(p_info, "mesh_section_index", "macro", "world", "mesh", "src/world/mesh.4dm", 13, 19, "Integer", "I:p_sx I:p_sy I:p_sz",
                              "Integer mesh_section_index(Integer p_sx, Integer p_sy, Integer p_sz)", 0, "", "");
  if (p_id == 854) test_info_set(p_info, "mesh_reset", "macro", "world", "mesh", "src/world/mesh.4dm", 21, 35, "void", "",
                              "void mesh_reset()", 0, "", "mesh_fill_cell_tables");
  if (p_id == 855) test_info_set(p_info, "mesh_fill_cell_tables", "macro", "world", "mesh", "src/world/mesh.4dm", 37, 67, "void", "",
                              "void mesh_fill_cell_tables()", 0, "", "block_is_plant, block_is_see_through, block_is_shaped, block_is_solid, world_cell_block, world_cell_light");
  if (p_id == 856) test_info_set(p_info, "mesh_section_buried", "macro", "world", "mesh", "src/world/mesh.4dm", 69, 92, "Integer", "I:p_sx I:p_sy I:p_sz",
                              "Integer mesh_section_buried(Integer p_sx, Integer p_sy, Integer p_sz)", 0, "", "world_solid_below");
  if (p_id == 857) test_info_set(p_info, "mesh_add_face", "macro", "world", "mesh", "src/world/mesh.4dm", 94, 110, "Integer", "I:p_entry I:p_x I:p_y I:p_z I:p_direction I:p_flag I:p_block",
                              "Integer mesh_add_face(Integer p_entry, Integer p_x, Integer p_y, Integer p_z, Integer p_direction, Integer p_flag, Integer p_block)", 0, "", "mesh_face_light");
  if (p_id == 858) test_info_set(p_info, "mesh_build_section", "macro", "world", "mesh", "src/world/mesh.4dm", 112, 217, "void", "I:p_sx I:p_sy I:p_sz",
                              "void mesh_build_section(Integer p_sx, Integer p_sy, Integer p_sz)", 0, "", "mesh_add_face, mesh_group_faces, mesh_section_buried, mesh_section_index, world_index");
  if (p_id == 859) test_info_set(p_info, "mesh_face_light", "macro", "world", "mesh", "src/world/mesh.4dm", 219, 314, "Integer", "I:p_x I:p_y I:p_z I:p_direction",
                              "Integer mesh_face_light(Integer p_x, Integer p_y, Integer p_z, Integer p_direction)", 0, "", "floor_divide, world_get_light, world_is_solid, world_sky_top");
  if (p_id == 860) test_info_set(p_info, "mesh_layer_key", "macro", "world", "mesh", "src/world/mesh.4dm", 316, 332, "Integer", "I:p_direction I:p_local_x I:p_local_y I:p_local_z",
                              "Integer mesh_layer_key(Integer p_direction, Integer p_local_x, Integer p_local_y, Integer p_local_z)", 0, "", "");
  if (p_id == 861) test_info_set(p_info, "mesh_group_faces", "macro", "world", "mesh", "src/world/mesh.4dm", 334, 388, "void", "I:p_section I:p_x0 I:p_y0 I:p_z0",
                              "void mesh_group_faces(Integer p_section, Integer p_x0, Integer p_y0, Integer p_z0)", 0, "", "mesh_layer_key");
  if (p_id == 862) test_info_set(p_info, "mesh_build_nearby", "macro", "world", "mesh", "src/world/mesh.4dm", 390, 445, "void", "R:p_eye_x R:p_eye_y R:p_eye_z I:p_range I:p_budget",
                              "void mesh_build_nearby(Real p_eye_x, Real p_eye_y, Real p_eye_z, Integer p_range, Integer p_budget)", 0, "", "clamp_integer, floor_integer, mesh_build_section, mesh_section_index");
  if (p_id == 863) test_info_set(p_info, "mesh_ensure_section", "macro", "world", "mesh", "src/world/mesh.4dm", 447, 457, "Integer", "I:p_sx I:p_sy I:p_sz",
                              "Integer mesh_ensure_section(Integer p_sx, Integer p_sy, Integer p_sz)", 0, "", "mesh_build_section, mesh_section_index");
  if (p_id == 864) test_info_set(p_info, "mesh_mark_dirty", "macro", "world", "mesh", "src/world/mesh.4dm", 459, 494, "void", "I:p_x I:p_y I:p_z",
                              "void mesh_mark_dirty(Integer p_x, Integer p_y, Integer p_z)", 0, "", "floor_divide, mesh_section_index, world_in_bounds");
  if (p_id == 865) test_info_set(p_info, "mesh_mark_box_dirty", "macro", "world", "mesh", "src/world/mesh.4dm", 496, 521, "void", "I:p_x I:p_y I:p_z I:p_radius",
                              "void mesh_mark_box_dirty(Integer p_x, Integer p_y, Integer p_z, Integer p_radius)", 0, "", "clamp_integer, floor_divide, mesh_section_index");
  if (p_id == 866) test_info_set(p_info, "mesh_on_event", "macro", "world", "mesh", "src/world/mesh.4dm", 523, 536, "void", "&A:p_event",
                              "void mesh_on_event(Attributes &p_event)", 0, "", "event_integer, event_type, mesh_mark_box_dirty, mesh_mark_dirty");
  if (p_id == 867) test_info_set(p_info, "physics_cell_box", "macro", "world", "physics", "src/world/physics.4dm", 11, 46, "Integer", "I:p_x I:p_y I:p_z &R:p_min_x &R:p_min_y &R:p_min_z &R:p_max_x &R:p_max_y &R:p_max_z",
                              "Integer physics_cell_box(Integer p_x, Integer p_y, Integer p_z, Real &p_min_x, Real &p_min_y, Real &p_min_z, Real &p_max_x, Real &p_max_y, Real &p_max_z)", 0, "", "block_box, world_get_block, world_in_bounds, world_is_solid");
  if (p_id == 868) test_info_set(p_info, "physics_box_limit", "macro", "world", "physics", "src/world/physics.4dm", 48, 102, "Real", "R:p_min_x R:p_min_y R:p_min_z R:p_max_x R:p_max_y R:p_max_z I:p_axis I:p_direction",
                              "Real physics_box_limit(Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z, Integer p_axis, Integer p_direction)", 0, "", "physics_cell_box");
  if (p_id == 869) test_info_set(p_info, "physics_box_collides", "macro", "world", "physics", "src/world/physics.4dm", 104, 111, "Integer", "R:p_min_x R:p_min_y R:p_min_z R:p_max_x R:p_max_y R:p_max_z",
                              "Integer physics_box_collides(Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)", 0, "", "physics_box_limit");
  if (p_id == 870) test_info_set(p_info, "physics_move_box", "macro", "world", "physics", "src/world/physics.4dm", 113, 181, "void", "&R:p_x &R:p_y &R:p_z R:p_half_width R:p_height R:p_dx R:p_dy R:p_dz &I:p_hit_x &I:p_hit_z &I:p_hit_down &I:p_hit_up",
                              "void physics_move_box(Real &p_x, Real &p_y, Real &p_z, Real p_half_width, Real p_height, Real p_dx, Real p_dy, Real p_dz, Integer &p_hit_x, Integer &p_hit_z, Integer &p_hit_down, Integer &p_hit_up)", 0, "", "physics_box_collides, physics_box_limit");
  if (p_id == 871) test_info_set(p_info, "physics_box_in_water", "macro", "world", "physics", "src/world/physics.4dm", 183, 195, "Integer", "R:p_x R:p_y R:p_z R:p_half_width R:p_height",
                              "Integer physics_box_in_water(Real p_x, Real p_y, Real p_z, Real p_half_width, Real p_height)", 0, "", "block_is_liquid, world_get_block");
  if (p_id == 872) test_info_set(p_info, "physics_raycast_blocks", "macro", "world", "physics", "src/world/physics.4dm", 197, 304, "Integer", "R:p_origin_x R:p_origin_y R:p_origin_z R:p_dir_x R:p_dir_y R:p_dir_z R:p_max_distance &I:p_hit_x &I:p_hit_y &I:p_hit_z &I:p_normal_x &I:p_normal_y &I:p_normal_z &R:p_distance",
                              "Integer physics_raycast_blocks(Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_max_distance, Integer &p_hit_x, Integer &p_hit_y, Integer &p_hit_z, Integer &p_normal_x, Integer &p_normal_y, Integer &p_normal_z, Real &p_distance)", 0, "", "block_box, block_is_liquid, physics_ray_box, world_get_block, world_in_bounds");
  if (p_id == 873) test_info_set(p_info, "physics_ray_box", "macro", "world", "physics", "src/world/physics.4dm", 306, 364, "Real", "R:p_origin_x R:p_origin_y R:p_origin_z R:p_dir_x R:p_dir_y R:p_dir_z R:p_min_x R:p_min_y R:p_min_z R:p_max_x R:p_max_y R:p_max_z",
                              "Real physics_ray_box(Real p_origin_x, Real p_origin_y, Real p_origin_z, Real p_dir_x, Real p_dir_y, Real p_dir_z, Real p_min_x, Real p_min_y, Real p_min_z, Real p_max_x, Real p_max_y, Real p_max_z)", 0, "", "max_real, min_real");
  if (p_id == 874) test_info_set(p_info, "world_index", "macro", "world", "world", "src/world/world.4dm", 15, 21, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_index(Integer p_x, Integer p_y, Integer p_z)", 0, "", "");
  if (p_id == 875) test_info_set(p_info, "world_cell_of_index", "macro", "world", "world", "src/world/world.4dm", 23, 35, "void", "I:p_index &I:p_x &I:p_y &I:p_z",
                              "void world_cell_of_index(Integer p_index, Integer &p_x, Integer &p_y, Integer &p_z)", 0, "", "floor_divide, positive_mod");
  if (p_id == 876) test_info_set(p_info, "world_column", "macro", "world", "world", "src/world/world.4dm", 37, 43, "Integer", "I:p_x I:p_z",
                              "Integer world_column(Integer p_x, Integer p_z)", 0, "", "");
  if (p_id == 877) test_info_set(p_info, "world_in_bounds", "macro", "world", "world", "src/world/world.4dm", 45, 53, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_in_bounds(Integer p_x, Integer p_y, Integer p_z)", 0, "", "");
  if (p_id == 878) test_info_set(p_info, "world_get_block", "macro", "world", "world", "src/world/world.4dm", 55, 67, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_get_block(Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_cell_block, world_in_bounds, world_index");
  if (p_id == 879) test_info_set(p_info, "world_cell_block", "macro", "world", "world", "src/world/world.4dm", 69, 78, "Integer", "I:p_cell",
                              "Integer world_cell_block(Integer p_cell)", 0, "", "");
  if (p_id == 880) test_info_set(p_info, "world_cell_light", "macro", "world", "world", "src/world/world.4dm", 80, 89, "Integer", "I:p_cell",
                              "Integer world_cell_light(Integer p_cell)", 0, "", "");
}

void test_registry_call_22(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 841 to 880 (see the header)
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 841) {   // game_panel_render
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    game_panel_render(g_test_box, l_i1, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 844) {   // menu_open_worlds
    Get_time(l_start);
    menu_open_worlds(g_test_record, g_test_record_2);
    Get_time(l_end);
  } else if (p_id == 845) {   // menu_free_world_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = menu_free_world_name(l_t1);
    Get_time(l_end);
  } else if (p_id == 846) {   // menu_turned
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = menu_turned(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 847) {   // menu_splash
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = menu_splash(l_i1);
    Get_time(l_end);
  } else if (p_id == 848) {   // menu_background
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    menu_background(g_test_box, l_r1, l_r2, l_i1, l_r3);
    Get_time(l_end);
  } else if (p_id == 849) {   // menu_panel_lan_folder
    Get_time(l_start);
    l_ret_t = menu_panel_lan_folder(g_settings);
    Get_time(l_end);
  } else if (p_id == 851) {   // settings_slider
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    settings_slider(g_settings, l_i1, l_r1);
    Get_time(l_end);
  } else if (p_id == 853) {   // mesh_section_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = mesh_section_index(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 854) {   // mesh_reset
    Get_time(l_start);
    mesh_reset();
    Get_time(l_end);
  } else if (p_id == 855) {   // mesh_fill_cell_tables
    Get_time(l_start);
    mesh_fill_cell_tables();
    Get_time(l_end);
  } else if (p_id == 856) {   // mesh_section_buried
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = mesh_section_buried(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 857) {   // mesh_add_face
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
  } else if (p_id == 858) {   // mesh_build_section
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    mesh_build_section(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 859) {   // mesh_face_light
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = mesh_face_light(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 860) {   // mesh_layer_key
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = mesh_layer_key(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 861) {   // mesh_group_faces
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    mesh_group_faces(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 862) {   // mesh_build_nearby
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    mesh_build_nearby(l_r1, l_r2, l_r3, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 863) {   // mesh_ensure_section
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = mesh_ensure_section(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 864) {   // mesh_mark_dirty
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    mesh_mark_dirty(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 865) {   // mesh_mark_box_dirty
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    mesh_mark_box_dirty(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 866) {   // mesh_on_event
    Get_time(l_start);
    mesh_on_event(g_event);
    Get_time(l_end);
  } else if (p_id == 867) {   // physics_cell_box
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
  } else if (p_id == 868) {   // physics_box_limit
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
  } else if (p_id == 869) {   // physics_box_collides
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    l_r6 = record_real(p_in, ATTR_TEST_R6);
    Get_time(l_start);
    l_ret_i = physics_box_collides(l_r1, l_r2, l_r3, l_r4, l_r5, l_r6);
    Get_time(l_end);
  } else if (p_id == 870) {   // physics_move_box
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
  } else if (p_id == 871) {   // physics_box_in_water
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    l_r5 = record_real(p_in, ATTR_TEST_R5);
    Get_time(l_start);
    l_ret_i = physics_box_in_water(l_r1, l_r2, l_r3, l_r4, l_r5);
    Get_time(l_end);
  } else if (p_id == 872) {   // physics_raycast_blocks
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
  } else if (p_id == 873) {   // physics_ray_box
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
  } else if (p_id == 874) {   // world_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_index(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 875) {   // world_cell_of_index
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
  } else if (p_id == 876) {   // world_column
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_column(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 877) {   // world_in_bounds
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_in_bounds(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 878) {   // world_get_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_get_block(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 879) {   // world_cell_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = world_cell_block(l_i1);
    Get_time(l_end);
  } else if (p_id == 880) {   // world_cell_light
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = world_cell_light(l_i1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_23(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 881 to 920 are
// ----------------------------------------------------------------
{
  if (p_id == 881) test_info_set(p_info, "world_get_light", "macro", "world", "world", "src/world/world.4dm", 91, 98, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_get_light(Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_cell_light, world_in_bounds, world_index");
  if (p_id == 882) test_info_set(p_info, "world_set_block", "macro", "world", "world", "src/world/world.4dm", 100, 112, "void", "I:p_x I:p_y I:p_z I:p_block",
                              "void world_set_block(Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "world_cell_light, world_in_bounds, world_index");
  if (p_id == 883) test_info_set(p_info, "world_is_solid", "macro", "world", "world", "src/world/world.4dm", 114, 124, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_is_solid(Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_is_solid, world_cell_block, world_index");
  if (p_id == 884) test_info_set(p_info, "world_top_solid_y", "macro", "world", "world", "src/world/world.4dm", 126, 142, "Integer", "I:p_x I:p_z",
                              "Integer world_top_solid_y(Integer p_x, Integer p_z)", 0, "", "block_is_solid, world_cell_block, world_in_bounds, world_index");
  if (p_id == 885) test_info_set(p_info, "world_top_opaque_y", "macro", "world", "world", "src/world/world.4dm", 144, 161, "Integer", "I:p_x I:p_z",
                              "Integer world_top_opaque_y(Integer p_x, Integer p_z)", 0, "", "block_hides_faces, world_cell_block, world_in_bounds, world_index");
  if (p_id == 886) test_info_set(p_info, "world_sky_top", "macro", "world", "world", "src/world/world.4dm", 163, 171, "Integer", "I:p_x I:p_z",
                              "Integer world_sky_top(Integer p_x, Integer p_z)", 0, "", "world_column, world_in_bounds");
  if (p_id == 887) test_info_set(p_info, "world_solid_below", "macro", "world", "world", "src/world/world.4dm", 173, 181, "Integer", "I:p_x I:p_z",
                              "Integer world_solid_below(Integer p_x, Integer p_z)", 0, "", "world_column, world_in_bounds");
  if (p_id == 888) test_info_set(p_info, "world_biome", "macro", "world", "world", "src/world/world.4dm", 183, 190, "Integer", "I:p_x I:p_z",
                              "Integer world_biome(Integer p_x, Integer p_z)", 0, "", "world_column, world_in_bounds");
  if (p_id == 889) test_info_set(p_info, "world_update_column_top", "macro", "world", "world", "src/world/world.4dm", 192, 201, "void", "I:p_x I:p_z",
                              "void world_update_column_top(Integer p_x, Integer p_z)", 0, "", "world_column, world_in_bounds, world_top_opaque_y");
  if (p_id == 890) test_info_set(p_info, "world_break_block", "macro", "world", "world", "src/world/world.4dm", 203, 245, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_tool_item",
                              "void world_break_block(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_tool_item)", 0, "", "block_door_top, block_is_chest, block_is_door, block_is_plant, block_is_shaped, block_partner, emit_cell_event, emit_event, world_get_block, world_in_bounds, world_light_update, world_set_block, world_update_column_top");
  if (p_id == 891) test_info_set(p_info, "world_place_block", "macro", "world", "world", "src/world/world.4dm", 247, 259, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_block",
                              "void world_place_block(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "emit_cell_event, world_in_bounds, world_light_update, world_set_block, world_update_column_top");
  if (p_id == 892) test_info_set(p_info, "world_apply_remote_block", "macro", "world", "world", "src/world/world.4dm", 261, 280, "void", "&A:p_events I:p_x I:p_y I:p_z I:p_block",
                              "void world_apply_remote_block(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z, Integer p_block)", 0, "", "emit_cell_event, emit_event, world_get_block, world_in_bounds, world_light_update, world_set_block, world_update_column_top");
  if (p_id == 893) test_info_set(p_info, "world_time_of_day", "macro", "world", "world", "src/world/world.4dm", 284, 290, "Real", "&A:p_info",
                              "Real world_time_of_day(Attributes &p_info)", 0, "", "record_real");
  if (p_id == 894) test_info_set(p_info, "world_set_time_of_day", "macro", "world", "world", "src/world/world.4dm", 292, 298, "void", "&A:p_info R:p_time",
                              "void world_set_time_of_day(Attributes &p_info, Real p_time)", 0, "", "record_set_real");
  if (p_id == 895) test_info_set(p_info, "world_daylight_cycle", "macro", "world", "world", "src/world/world.4dm", 300, 307, "Integer", "&A:p_info",
                              "Integer world_daylight_cycle(Attributes &p_info)", 0, "", "record_integer");
  if (p_id == 896) test_info_set(p_info, "world_set_daylight_cycle", "macro", "world", "world", "src/world/world.4dm", 309, 315, "void", "&A:p_info I:p_on",
                              "void world_set_daylight_cycle(Attributes &p_info, Integer p_on)", 0, "", "record_set_integer");
  if (p_id == 897) test_info_set(p_info, "world_advance_time", "macro", "world", "world", "src/world/world.4dm", 317, 326, "void", "&A:p_info R:p_dt",
                              "void world_advance_time(Attributes &p_info, Real p_dt)", 0, "", "record_integer, record_set_integer, world_set_time_of_day, world_time_of_day");
  if (p_id == 898) test_info_set(p_info, "world_sun_height", "macro", "world", "world", "src/world/world.4dm", 328, 334, "Real", "R:p_time_of_day",
                              "Real world_sun_height(Real p_time_of_day)", 0, "", "");
  if (p_id == 899) test_info_set(p_info, "world_daylight", "macro", "world", "world", "src/world/world.4dm", 336, 345, "Real", "R:p_time_of_day",
                              "Real world_daylight(Real p_time_of_day)", 0, "", "clamp_real, smooth_curve, world_sun_height");
  if (p_id == 900) test_info_set(p_info, "world_is_night", "macro", "world", "world", "src/world/world.4dm", 347, 354, "Integer", "R:p_time_of_day",
                              "Integer world_is_night(Real p_time_of_day)", 0, "", "world_daylight");
  if (p_id == 901) test_info_set(p_info, "world_clock_text", "macro", "world", "world", "src/world/world.4dm", 356, 368, "Text", "R:p_time_of_day",
                              "Text world_clock_text(Real p_time_of_day)", 0, "", "two_digits");
  if (p_id == 902) test_info_set(p_info, "world_on_event", "macro", "world", "world", "src/world/world.4dm", 370, 422, "void", "&A:p_event &A:p_info &A:p_events",
                              "void world_on_event(Attributes &p_event, Attributes &p_info, Attributes &p_events)", 0, "", "block_furnace_lit_as, block_is_furnace, emit_cell_event, emit_toast, event_integer, event_type, record_integer, record_set_integer, world_break_block, world_get_block, world_info_set_spawn, world_is_night, world_light_update, world_set_block, world_set_time_of_day, world_time_of_day");
  if (p_id == 903) test_info_set(p_info, "world_set_light_index", "macro", "world", "world", "src/world/world.4dm", 426, 432, "void", "I:p_index I:p_light",
                              "void world_set_light_index(Integer p_index, Integer p_light)", 0, "", "world_cell_block");
  if (p_id == 904) test_info_set(p_info, "world_light_push", "macro", "world", "world", "src/world/world.4dm", 434, 444, "Integer", "I:p_tail I:p_x I:p_y I:p_z",
                              "Integer world_light_push(Integer p_tail, Integer p_x, Integer p_y, Integer p_z)", 0, "", "");
  if (p_id == 905) test_info_set(p_info, "world_light_seed_outside", "macro", "world", "world", "src/world/world.4dm", 446, 455, "Integer", "I:p_tail I:p_x I:p_y I:p_z",
                              "Integer world_light_seed_outside(Integer p_tail, Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_get_light, world_in_bounds, world_light_push");
  if (p_id == 906) test_info_set(p_info, "world_light_update", "macro", "world", "world", "src/world/world.4dm", 457, 561, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_light_update(Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_hides_faces, block_light_emission, max_integer, min_integer, world_cell_block, world_cell_light, world_get_block, world_get_light, world_in_bounds, world_index, world_light_push, world_light_seed_outside, world_set_light_index");
  if (p_id == 907) test_info_set(p_info, "world_info_clear", "macro", "world", "world", "src/world/world.4dm", 565, 582, "void", "&A:p_info I:p_seed",
                              "void world_info_clear(Attributes &p_info, Integer p_seed)", 0, "", "record_clear, record_set_integer, record_set_real, world_info_set_spawn, world_seed_shifts");
  if (p_id == 908) test_info_set(p_info, "world_info_seed", "macro", "world", "world", "src/world/world.4dm", 584, 590, "Integer", "&A:p_info",
                              "Integer world_info_seed(Attributes &p_info)", 0, "", "record_integer");
  if (p_id == 909) test_info_set(p_info, "world_info_spawn", "macro", "world", "world", "src/world/world.4dm", 592, 600, "void", "&A:p_info &R:p_x &R:p_y &R:p_z",
                              "void world_info_spawn(Attributes &p_info, Real &p_x, Real &p_y, Real &p_z)", 0, "", "record_real");
  if (p_id == 910) test_info_set(p_info, "world_info_set_spawn", "macro", "world", "world", "src/world/world.4dm", 602, 610, "void", "&A:p_info R:p_x R:p_y R:p_z",
                              "void world_info_set_spawn(Attributes &p_info, Real p_x, Real p_y, Real p_z)", 0, "", "record_set_real");
  if (p_id == 911) test_info_set(p_info, "world_seed_shifts", "macro", "world", "world", "src/world/world.4dm", 614, 625, "void", "I:p_seed &R:p_shift_a &R:p_shift_b",
                              "void world_seed_shifts(Integer p_seed, Real &p_shift_a, Real &p_shift_b)", 0, "", "floor_divide, positive_mod");
  if (p_id == 912) test_info_set(p_info, "world_value_noise", "macro", "world", "world", "src/world/world.4dm", 627, 644, "Real", "R:p_x R:p_z I:p_layer R:p_shift_a R:p_shift_b",
                              "Real world_value_noise(Real p_x, Real p_z, Integer p_layer, Real p_shift_a, Real p_shift_b)", 0, "", "hash_real, lerp_real, smooth_curve");
  if (p_id == 913) test_info_set(p_info, "world_desert_weight", "macro", "world", "world", "src/world/world.4dm", 646, 655, "Real", "I:p_x I:p_z R:p_shift_a R:p_shift_b",
                              "Real world_desert_weight(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)", 0, "", "clamp_real, smooth_curve, world_value_noise");
  if (p_id == 914) test_info_set(p_info, "world_column_biome", "macro", "world", "world", "src/world/world.4dm", 657, 666, "Integer", "I:p_x I:p_z R:p_shift_a R:p_shift_b",
                              "Integer world_column_biome(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)", 0, "", "world_desert_weight, world_value_noise");
  if (p_id == 915) test_info_set(p_info, "world_terrain_height", "macro", "world", "world", "src/world/world.4dm", 668, 700, "Integer", "I:p_x I:p_z R:p_shift_a R:p_shift_b",
                              "Integer world_terrain_height(Integer p_x, Integer p_z, Real p_shift_a, Real p_shift_b)", 0, "", "clamp_integer, world_desert_weight, world_value_noise");
  if (p_id == 916) test_info_set(p_info, "world_fill_columns", "macro", "world", "world", "src/world/world.4dm", 704, 779, "void", "R:p_shift_a R:p_shift_b",
                              "void world_fill_columns(Real p_shift_a, Real p_shift_b)", 0, "", "hash_real, world_column, world_column_biome, world_index, world_terrain_height");
  if (p_id == 917) test_info_set(p_info, "world_mark_carved", "macro", "world", "world", "src/world/world.4dm", 781, 792, "void", "I:p_x I:p_y I:p_z",
                              "void world_mark_carved(Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_column, world_in_bounds");
  if (p_id == 918) test_info_set(p_info, "world_carve_sphere", "macro", "world", "world", "src/world/world.4dm", 794, 842, "void", "R:p_centre_x R:p_centre_y R:p_centre_z R:p_radius",
                              "void world_carve_sphere(Real p_centre_x, Real p_centre_y, Real p_centre_z, Real p_radius)", 0, "", "world_get_block, world_in_bounds, world_mark_carved, world_set_block");
  if (p_id == 919) test_info_set(p_info, "world_carve_caves", "macro", "world", "world", "src/world/world.4dm", 844, 886, "void", "&A:p_random",
                              "void world_carve_caves(Attributes &p_random)", 0, "", "clamp_real, floor_integer, max_real, random_between, random_range, world_carve_sphere, world_column");
  if (p_id == 920) test_info_set(p_info, "world_place_veins", "macro", "world", "world", "src/world/world.4dm", 888, 918, "void", "&A:p_random I:p_block I:p_inside I:p_count I:p_length I:p_max_y",
                              "void world_place_veins(Attributes &p_random, Integer p_block, Integer p_inside, Integer p_count, Integer p_length, Integer p_max_y)", 0, "", "random_range, world_get_block, world_set_block");
}

void test_registry_call_23(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 881 to 920 (see the header)
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 881) {   // world_get_light
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_get_light(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 882) {   // world_set_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_set_block(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 883) {   // world_is_solid
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_is_solid(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 884) {   // world_top_solid_y
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_top_solid_y(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 885) {   // world_top_opaque_y
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_top_opaque_y(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 886) {   // world_sky_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_sky_top(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 887) {   // world_solid_below
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_solid_below(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 888) {   // world_biome
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_biome(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 889) {   // world_update_column_top
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    world_update_column_top(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 890) {   // world_break_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_break_block(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 891) {   // world_place_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_place_block(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 892) {   // world_apply_remote_block
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_apply_remote_block(g_events, l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 893) {   // world_time_of_day
    Get_time(l_start);
    l_ret_r = world_time_of_day(g_info);
    Get_time(l_end);
  } else if (p_id == 894) {   // world_set_time_of_day
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    world_set_time_of_day(g_info, l_r1);
    Get_time(l_end);
  } else if (p_id == 895) {   // world_daylight_cycle
    Get_time(l_start);
    l_ret_i = world_daylight_cycle(g_info);
    Get_time(l_end);
  } else if (p_id == 896) {   // world_set_daylight_cycle
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    world_set_daylight_cycle(g_info, l_i1);
    Get_time(l_end);
  } else if (p_id == 897) {   // world_advance_time
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    world_advance_time(g_info, l_r1);
    Get_time(l_end);
  } else if (p_id == 898) {   // world_sun_height
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = world_sun_height(l_r1);
    Get_time(l_end);
  } else if (p_id == 899) {   // world_daylight
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = world_daylight(l_r1);
    Get_time(l_end);
  } else if (p_id == 900) {   // world_is_night
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = world_is_night(l_r1);
    Get_time(l_end);
  } else if (p_id == 901) {   // world_clock_text
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_t = world_clock_text(l_r1);
    Get_time(l_end);
  } else if (p_id == 902) {   // world_on_event
    Get_time(l_start);
    world_on_event(g_event, g_info, g_events);
    Get_time(l_end);
  } else if (p_id == 903) {   // world_set_light_index
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    world_set_light_index(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 904) {   // world_light_push
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = world_light_push(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 905) {   // world_light_seed_outside
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    l_ret_i = world_light_seed_outside(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 906) {   // world_light_update
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_light_update(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 907) {   // world_info_clear
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    world_info_clear(g_info, l_i1);
    Get_time(l_end);
  } else if (p_id == 908) {   // world_info_seed
    Get_time(l_start);
    l_ret_i = world_info_seed(g_info);
    Get_time(l_end);
  } else if (p_id == 909) {   // world_info_spawn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    world_info_spawn(g_info, l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 910) {   // world_info_set_spawn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    world_info_set_spawn(g_info, l_r1, l_r2, l_r3);
    Get_time(l_end);
  } else if (p_id == 911) {   // world_seed_shifts
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_seed_shifts(l_i1, l_r1, l_r2);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
  } else if (p_id == 912) {   // world_value_noise
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    l_ret_r = world_value_noise(l_r1, l_r2, l_i1, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 913) {   // world_desert_weight
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_r = world_desert_weight(l_i1, l_i2, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 914) {   // world_column_biome
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = world_column_biome(l_i1, l_i2, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 915) {   // world_terrain_height
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    l_ret_i = world_terrain_height(l_i1, l_i2, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 916) {   // world_fill_columns
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_fill_columns(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 917) {   // world_mark_carved
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    world_mark_carved(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 918) {   // world_carve_sphere
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    world_carve_sphere(l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 919) {   // world_carve_caves
    Get_time(l_start);
    world_carve_caves(g_random);
    Get_time(l_end);
  } else if (p_id == 920) {   // world_place_veins
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    world_place_veins(g_random, l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_24(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 921 to 960 are
// ----------------------------------------------------------------
{
  if (p_id == 921) test_info_set(p_info, "world_plant_tree", "macro", "world", "world", "src/world/world.4dm", 920, 953, "void", "I:p_x I:p_ground_y I:p_z R:p_shift_a R:p_shift_b",
                              "void world_plant_tree(Integer p_x, Integer p_ground_y, Integer p_z, Real p_shift_a, Real p_shift_b)", 0, "", "block_is_plant, hash_real, world_get_block, world_set_block");
  if (p_id == 922) test_info_set(p_info, "world_plant_trees", "macro", "world", "world", "src/world/world.4dm", 955, 991, "void", "R:p_shift_a R:p_shift_b",
                              "void world_plant_trees(Real p_shift_a, Real p_shift_b)", 0, "", "floor_divide, hash_real, world_biome, world_column, world_get_block, world_plant_tree, world_value_noise");
  if (p_id == 923) test_info_set(p_info, "world_plant_cactus", "macro", "world", "world", "src/world/world.4dm", 993, 1006, "void", "I:p_x I:p_ground_y I:p_z I:p_tall",
                              "void world_plant_cactus(Integer p_x, Integer p_ground_y, Integer p_z, Integer p_tall)", 0, "", "world_get_block, world_set_block");
  if (p_id == 924) test_info_set(p_info, "world_add_plants", "macro", "world", "world", "src/world/world.4dm", 1008, 1050, "void", "&A:p_random R:p_shift_a R:p_shift_b",
                              "void world_add_plants(Attributes &p_random, Real p_shift_a, Real p_shift_b)", 0, "", "random_next, random_range, world_biome, world_column, world_get_block, world_plant_cactus, world_set_block, world_value_noise");
  if (p_id == 925) test_info_set(p_info, "world_area_is_flat", "macro", "world", "world", "src/world/world.4dm", 1052, 1080, "Integer", "I:p_x0 I:p_z0 I:p_x1 I:p_z1 &I:p_ground_y",
                              "Integer world_area_is_flat(Integer p_x0, Integer p_z0, Integer p_x1, Integer p_z1, Integer &p_ground_y)", 0, "", "world_column, world_get_block, world_in_bounds");
  if (p_id == 926) test_info_set(p_info, "world_dig_pond", "macro", "world", "world", "src/world/world.4dm", 1082, 1110, "void", "I:p_centre_x I:p_centre_z",
                              "void world_dig_pond(Integer p_centre_x, Integer p_centre_z)", 0, "", "world_area_is_flat, world_mark_carved, world_set_block");
  if (p_id == 927) test_info_set(p_info, "world_add_ponds", "macro", "world", "world", "src/world/world.4dm", 1112, 1130, "void", "&A:p_random",
                              "void world_add_ponds(Attributes &p_random)", 0, "", "random_next, random_range, world_biome, world_dig_pond");
  if (p_id == 928) test_info_set(p_info, "world_build_house", "macro", "world", "world", "src/world/world.4dm", 1132, 1211, "void", "&A:p_info I:p_origin_x I:p_ground_y I:p_origin_z",
                              "void world_build_house(Attributes &p_info, Integer p_origin_x, Integer p_ground_y, Integer p_origin_z)", 0, "", "block_bed, block_chest, block_door, block_is_solid, record_set_integer, world_get_block, world_info_set_spawn, world_set_block");
  if (p_id == 929) test_info_set(p_info, "world_place_house_near", "macro", "world", "world", "src/world/world.4dm", 1213, 1245, "void", "&A:p_info R:p_spawn_x R:p_spawn_z",
                              "void world_place_house_near(Attributes &p_info, Real p_spawn_x, Real p_spawn_z)", 0, "", "clamp_integer, floor_integer, world_area_is_flat, world_build_house, world_column");
  if (p_id == 930) test_info_set(p_info, "world_find_spawn", "macro", "world", "world", "src/world/world.4dm", 1247, 1281, "void", "&R:p_spawn_x &R:p_spawn_y &R:p_spawn_z",
                              "void world_find_spawn(Real &p_spawn_x, Real &p_spawn_y, Real &p_spawn_z)", 0, "", "floor_divide, world_get_block, world_top_solid_y");
  if (p_id == 931) test_info_set(p_info, "world_finish_maps", "macro", "world", "world", "src/world/world.4dm", 1283, 1299, "void", "",
                              "void world_finish_maps()", 0, "", "world_column, world_top_opaque_y");
  if (p_id == 932) test_info_set(p_info, "world_generate", "macro", "world", "world", "src/world/world.4dm", 1301, 1345, "void", "&A:p_info I:p_seed",
                              "void world_generate(Attributes &p_info, Integer p_seed)", 0, "", "random_seed, record_integer, world_add_lava_pools, world_add_plants, world_add_ponds, world_carve_caves, world_fill_columns, world_find_spawn, world_finish_maps, world_info_clear, world_info_set_spawn, world_light_update, world_place_house_near, world_place_veins, world_plant_trees, world_seed_shifts");
  if (p_id == 933) test_info_set(p_info, "world_dimension", "macro", "world", "world", "src/world/world.4dm", 1349, 1355, "Integer", "",
                              "Integer world_dimension()", 0, "", "");
  if (p_id == 934) test_info_set(p_info, "world_generate_dimension", "macro", "world", "world", "src/world/world.4dm", 1357, 1370, "void", "&A:p_info I:p_seed I:p_dimension",
                              "void world_generate_dimension(Attributes &p_info, Integer p_seed, Integer p_dimension)", 0, "", "record_set_integer, world_generate, world_generate_nether");
  if (p_id == 935) test_info_set(p_info, "world_generate_nether", "macro", "world", "world", "src/world/world.4dm", 1372, 1466, "void", "&A:p_info I:p_seed",
                              "void world_generate_nether(Attributes &p_info, Integer p_seed)", 0, "", "floor_divide, floor_integer, hash_real, random_range, random_seed, world_column, world_finish_maps, world_get_block, world_index, world_info_clear, world_info_set_spawn, world_place_veins, world_portal_spot, world_seed_shifts, world_set_block, world_value_noise");
  if (p_id == 936) test_info_set(p_info, "world_nether_floor", "macro", "world", "world", "src/world/world.4dm", 1468, 1485, "Integer", "I:p_x I:p_z",
                              "Integer world_nether_floor(Integer p_x, Integer p_z)", 0, "", "world_get_block, world_is_solid");
  if (p_id == 937) test_info_set(p_info, "world_add_lava_pools", "macro", "world", "world", "src/world/world.4dm", 1487, 1530, "void", "&A:p_random",
                              "void world_add_lava_pools(Attributes &p_random)", 0, "", "random_between, random_range, world_get_block, world_is_solid, world_mark_carved, world_set_block");
  if (p_id == 938) test_info_set(p_info, "world_next_to_flammable", "macro", "world", "world", "src/world/world.4dm", 1534, 1544, "Integer", "I:p_x I:p_y I:p_z",
                              "Integer world_next_to_flammable(Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_is_flammable, world_get_block");
  if (p_id == 939) test_info_set(p_info, "world_light_fire", "macro", "world", "world", "src/world/world.4dm", 1546, 1567, "Integer", "&A:p_events I:p_x I:p_y I:p_z",
                              "Integer world_light_fire(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_is_liquid, block_is_plant, world_get_block, world_in_bounds, world_is_solid, world_next_to_flammable, world_place_block");
  if (p_id == 940) test_info_set(p_info, "world_fire_catches", "macro", "world", "world", "src/world/world.4dm", 1569, 1597, "Integer", "&A:p_events &A:p_random I:p_x I:p_y I:p_z",
                              "Integer world_fire_catches(Attributes &p_events, Attributes &p_random, Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_is_flammable, block_is_shaped, block_partner, random_next, world_get_block, world_light_fire, world_next_to_flammable, world_place_block");
  if (p_id == 941) test_info_set(p_info, "world_burn_cell", "macro", "world", "world", "src/world/world.4dm", 1599, 1629, "void", "&A:p_events &A:p_random I:p_x I:p_y I:p_z",
                              "void world_burn_cell(Attributes &p_events, Attributes &p_random, Integer p_x, Integer p_y, Integer p_z)", 0, "", "block_is_plant, block_is_solid, random_next, world_break_block, world_fire_catches, world_get_block, world_next_to_flammable");
  if (p_id == 942) test_info_set(p_info, "world_fire_ticks", "macro", "world", "world", "src/world/world.4dm", 1631, 1651, "void", "&A:p_events &A:p_random R:p_x R:p_y R:p_z R:p_dt",
                              "void world_fire_ticks(Attributes &p_events, Attributes &p_random, Real p_x, Real p_y, Real p_z, Real p_dt)", 0, "", "floor_integer, min_real, random_next, random_range, world_burn_cell, world_get_block");
  if (p_id == 943) test_info_set(p_info, "world_portal_frame", "macro", "world", "world", "src/world/world.4dm", 1655, 1713, "Integer", "I:p_x I:p_y I:p_z I:p_along_x &I:p_x0 &I:p_y0 &I:p_z0 &I:p_width &I:p_height",
                              "Integer world_portal_frame(Integer p_x, Integer p_y, Integer p_z, Integer p_along_x, Integer &p_x0, Integer &p_y0, Integer &p_z0, Integer &p_width, Integer &p_height)", 0, "", "world_get_block");
  if (p_id == 944) test_info_set(p_info, "world_light_portal", "macro", "world", "world", "src/world/world.4dm", 1715, 1740, "Integer", "&A:p_events I:p_x I:p_y I:p_z",
                              "Integer world_light_portal(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_place_block, world_portal_frame");
  if (p_id == 945) test_info_set(p_info, "world_find_portal", "macro", "world", "world", "src/world/world.4dm", 1742, 1769, "Integer", "I:p_x I:p_y I:p_z I:p_range &I:p_px &I:p_py &I:p_pz",
                              "Integer world_find_portal(Integer p_x, Integer p_y, Integer p_z, Integer p_range, Integer &p_px, Integer &p_py, Integer &p_pz)", 0, "", "max_integer, min_integer, world_get_block");
  if (p_id == 946) test_info_set(p_info, "world_portal_spot", "macro", "world", "world", "src/world/world.4dm", 1771, 1810, "Integer", "I:p_x I:p_z &I:p_sx &I:p_sy &I:p_sz",
                              "Integer world_portal_spot(Integer p_x, Integer p_z, Integer &p_sx, Integer &p_sy, Integer &p_sz)", 0, "", "block_is_liquid, clamp_integer, max_integer, world_get_block, world_nether_floor, world_top_solid_y");
  if (p_id == 947) test_info_set(p_info, "world_build_portal", "macro", "world", "world", "src/world/world.4dm", 1812, 1843, "void", "&A:p_events I:p_x I:p_y I:p_z",
                              "void world_build_portal(Attributes &p_events, Integer p_x, Integer p_y, Integer p_z)", 0, "", "world_get_block, world_is_solid, world_place_block");
  if (p_id == 948) test_info_set(p_info, "Absolute", "library", "library", "library", "", 0, 0, "Real", "R:p_value",
                              "Real Absolute(Real p_value)", 0, "", "");
  if (p_id == 949) test_info_set(p_info, "Absolute", "library", "library", "library", "", 0, 0, "Integer", "I:p_value",
                              "Integer Absolute(Integer p_value)", 0, "", "");
  if (p_id == 950) test_info_set(p_info, "Floor", "library", "library", "library", "", 0, 0, "Real", "R:p_value",
                              "Real Floor(Real p_value)", 0, "", "");
  if (p_id == 951) test_info_set(p_info, "Sqrt", "library", "library", "library", "", 0, 0, "Real", "R:p_positive",
                              "Real Sqrt(Real p_positive)", 0, "", "");
  if (p_id == 952) test_info_set(p_info, "Sin", "library", "library", "library", "", 0, 0, "Real", "R:p_angle",
                              "Real Sin(Real p_angle)", 0, "", "");
  if (p_id == 953) test_info_set(p_info, "Cos", "library", "library", "library", "", 0, 0, "Real", "R:p_angle",
                              "Real Cos(Real p_angle)", 0, "", "");
  if (p_id == 954) test_info_set(p_info, "To_text", "library", "library", "library", "", 0, 0, "Text", "I:p_value",
                              "Text To_text(Integer p_value)", 0, "", "");
  if (p_id == 955) test_info_set(p_info, "To_text", "library", "library", "library", "", 0, 0, "Text", "R:p_value I:p_decimals",
                              "Text To_text(Real p_value, Integer p_decimals)", 0, "", "");
  if (p_id == 956) test_info_set(p_info, "Text_length", "library", "library", "library", "", 0, 0, "Integer", "T:p_text",
                              "Integer Text_length(Text p_text)", 0, "", "");
  if (p_id == 957) test_info_set(p_info, "Get_subtext", "library", "library", "library", "", 0, 0, "Text", "T:p_text I:p_start I:p_end",
                              "Text Get_subtext(Text p_text, Integer p_start, Integer p_end)", 0, "", "");
  if (p_id == 958) test_info_set(p_info, "Find_text", "library", "library", "library", "", 0, 0, "Integer", "T:p_text T:p_find",
                              "Integer Find_text(Text p_text, Text p_find)", 0, "", "");
  if (p_id == 959) test_info_set(p_info, "Text_lower", "library", "library", "library", "", 0, 0, "Text", "T:p_text",
                              "Text Text_lower(Text p_text)", 0, "", "");
  if (p_id == 960) test_info_set(p_info, "Text_justify", "library", "library", "library", "", 0, 0, "Text", "T:p_text",
                              "Text Text_justify(Text p_text)", 0, "", "");
}

void test_registry_call_24(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 921 to 960 (see the header)
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 921) {   // world_plant_tree
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_plant_tree(l_i1, l_i2, l_i3, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 922) {   // world_plant_trees
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_plant_trees(l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 923) {   // world_plant_cactus
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    Get_time(l_start);
    world_plant_cactus(l_i1, l_i2, l_i3, l_i4);
    Get_time(l_end);
  } else if (p_id == 924) {   // world_add_plants
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_add_plants(g_random, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 925) {   // world_area_is_flat
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = world_area_is_flat(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
  } else if (p_id == 926) {   // world_dig_pond
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    world_dig_pond(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 927) {   // world_add_ponds
    Get_time(l_start);
    world_add_ponds(g_random);
    Get_time(l_end);
  } else if (p_id == 928) {   // world_build_house
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    world_build_house(g_info, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 929) {   // world_place_house_near
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    Get_time(l_start);
    world_place_house_near(g_info, l_r1, l_r2);
    Get_time(l_end);
  } else if (p_id == 930) {   // world_find_spawn
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    Get_time(l_start);
    world_find_spawn(l_r1, l_r2, l_r3);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
    record_set_real(p_out, ATTR_TEST_R2, l_r2);
    record_set_real(p_out, ATTR_TEST_R3, l_r3);
  } else if (p_id == 931) {   // world_finish_maps
    Get_time(l_start);
    world_finish_maps();
    Get_time(l_end);
  } else if (p_id == 932) {   // world_generate
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    world_generate(g_info, l_i1);
    Get_time(l_end);
  } else if (p_id == 933) {   // world_dimension
    Get_time(l_start);
    l_ret_i = world_dimension();
    Get_time(l_end);
  } else if (p_id == 934) {   // world_generate_dimension
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    world_generate_dimension(g_info, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 935) {   // world_generate_nether
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    world_generate_nether(g_info, l_i1);
    Get_time(l_end);
  } else if (p_id == 936) {   // world_nether_floor
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = world_nether_floor(l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 937) {   // world_add_lava_pools
    Get_time(l_start);
    world_add_lava_pools(g_random);
    Get_time(l_end);
  } else if (p_id == 938) {   // world_next_to_flammable
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_next_to_flammable(l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 939) {   // world_light_fire
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_light_fire(g_events, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 940) {   // world_fire_catches
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_fire_catches(g_events, g_random, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 941) {   // world_burn_cell
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    world_burn_cell(g_events, g_random, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 942) {   // world_fire_ticks
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_r2 = record_real(p_in, ATTR_TEST_R2);
    l_r3 = record_real(p_in, ATTR_TEST_R3);
    l_r4 = record_real(p_in, ATTR_TEST_R4);
    Get_time(l_start);
    world_fire_ticks(g_events, g_random, l_r1, l_r2, l_r3, l_r4);
    Get_time(l_end);
  } else if (p_id == 943) {   // world_portal_frame
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    l_i8 = record_integer(p_in, ATTR_TEST_I8);
    l_i9 = record_integer(p_in, ATTR_TEST_I9);
    Get_time(l_start);
    l_ret_i = world_portal_frame(l_i1, l_i2, l_i3, l_i4, l_i5, l_i6, l_i7, l_i8, l_i9);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
    record_set_integer(p_out, ATTR_TEST_I7, l_i7);
    record_set_integer(p_out, ATTR_TEST_I8, l_i8);
    record_set_integer(p_out, ATTR_TEST_I9, l_i9);
  } else if (p_id == 944) {   // world_light_portal
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    l_ret_i = world_light_portal(g_events, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 945) {   // world_find_portal
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    l_i6 = record_integer(p_in, ATTR_TEST_I6);
    l_i7 = record_integer(p_in, ATTR_TEST_I7);
    Get_time(l_start);
    l_ret_i = world_find_portal(l_i1, l_i2, l_i3, l_i4, l_i5, l_i6, l_i7);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
    record_set_integer(p_out, ATTR_TEST_I6, l_i6);
    record_set_integer(p_out, ATTR_TEST_I7, l_i7);
  } else if (p_id == 946) {   // world_portal_spot
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    l_i4 = record_integer(p_in, ATTR_TEST_I4);
    l_i5 = record_integer(p_in, ATTR_TEST_I5);
    Get_time(l_start);
    l_ret_i = world_portal_spot(l_i1, l_i2, l_i3, l_i4, l_i5);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I3, l_i3);
    record_set_integer(p_out, ATTR_TEST_I4, l_i4);
    record_set_integer(p_out, ATTR_TEST_I5, l_i5);
  } else if (p_id == 947) {   // world_build_portal
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    l_i3 = record_integer(p_in, ATTR_TEST_I3);
    Get_time(l_start);
    world_build_portal(g_events, l_i1, l_i2, l_i3);
    Get_time(l_end);
  } else if (p_id == 948) {   // Absolute
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Absolute(l_r1);
    Get_time(l_end);
  } else if (p_id == 949) {   // Absolute
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Absolute(l_i1);
    Get_time(l_end);
  } else if (p_id == 950) {   // Floor
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Floor(l_r1);
    Get_time(l_end);
  } else if (p_id == 951) {   // Sqrt
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Sqrt(l_r1);
    Get_time(l_end);
  } else if (p_id == 952) {   // Sin
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Sin(l_r1);
    Get_time(l_end);
  } else if (p_id == 953) {   // Cos
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_r = Cos(l_r1);
    Get_time(l_end);
  } else if (p_id == 954) {   // To_text
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = To_text(l_i1);
    Get_time(l_end);
  } else if (p_id == 955) {   // To_text
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_t = To_text(l_r1, l_i1);
    Get_time(l_end);
  } else if (p_id == 956) {   // Text_length
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = Text_length(l_t1);
    Get_time(l_end);
  } else if (p_id == 957) {   // Get_subtext
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_t = Get_subtext(l_t1, l_i1, l_i2);
    Get_time(l_end);
  } else if (p_id == 958) {   // Find_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = Find_text(l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 959) {   // Text_lower
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = Text_lower(l_t1);
    Get_time(l_end);
  } else if (p_id == 960) {   // Text_justify
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_t = Text_justify(l_t1);
    Get_time(l_end);
  }
  record_set_integer(p_out, ATTR_TEST_RET_I,   l_ret_i);
  record_set_real   (p_out, ATTR_TEST_RET_R,   l_ret_r);
  record_set_text   (p_out, ATTR_TEST_RET_T,   l_ret_t);
  record_set_real   (p_out, ATTR_TEST_SECONDS, l_end - l_start);
}

void test_registry_info_25(Integer p_id, Attributes &p_info)
// ----------------------------------------------------------------
// What functions 961 to 979 are
// ----------------------------------------------------------------
{
  if (p_id == 961) test_info_set(p_info, "From_text", "library", "library", "library", "", 0, 0, "Integer", "T:p_number &I:p_value",
                              "Integer From_text(Text p_number, Integer &p_value)", 0, "", "");
  if (p_id == 962) test_info_set(p_info, "From_text", "library", "library", "library", "", 0, 0, "Integer", "T:p_number &R:p_value",
                              "Integer From_text(Text p_number, Real &p_value)", 0, "", "");
  if (p_id == 963) test_info_set(p_info, "From_text", "library", "library", "library", "", 0, 0, "Integer", "T:p_text &D:p_words",
                              "Integer From_text(Text p_text, Dynamic_Text &p_words)", 0, "", "");
  if (p_id == 964) test_info_set(p_info, "Set_char", "library", "library", "library", "", 0, 0, "Integer", "&T:p_text I:p_position I:p_char",
                              "Integer Set_char(Text &p_text, Integer p_position, Integer p_char)", 0, "", "");
  if (p_id == 965) test_info_set(p_info, "Get_time", "library", "library", "library", "", 0, 0, "Integer", "&R:p_time",
                              "Integer Get_time(Real &p_time)", 0, "", "");
  if (p_id == 966) test_info_set(p_info, "Get_time", "library", "library", "library", "", 0, 0, "Integer", "&I:p_time",
                              "Integer Get_time(Integer &p_time)", 0, "", "");
  if (p_id == 967) test_info_set(p_info, "Get_user_name", "library", "library", "library", "", 0, 0, "Integer", "&T:p_name",
                              "Integer Get_user_name(Text &p_name)", 0, "", "");
  if (p_id == 968) test_info_set(p_info, "Get_random_number_closed", "library", "library", "library", "", 0, 0, "Real", "",
                              "Real Get_random_number_closed()", 0, "", "");
  if (p_id == 969) test_info_set(p_info, "File_exists", "library", "library", "library", "", 0, 0, "Integer", "T:p_path",
                              "Integer File_exists(Text p_path)", 0, "", "");
  if (p_id == 970) test_info_set(p_info, "Directory_exists", "library", "library", "library", "", 0, 0, "Integer", "T:p_folder",
                              "Integer Directory_exists(Text p_folder)", 0, "", "");
  if (p_id == 971) test_info_set(p_info, "Set_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field I:p_value",
                              "Integer Set_attribute(Attributes &p_record, Text p_field, Integer p_value)", 0, "", "");
  if (p_id == 972) test_info_set(p_info, "Set_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field R:p_value",
                              "Integer Set_attribute(Attributes &p_record, Text p_field, Real p_value)", 0, "", "");
  if (p_id == 973) test_info_set(p_info, "Set_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field T:p_value",
                              "Integer Set_attribute(Attributes &p_record, Text p_field, Text p_value)", 0, "", "");
  if (p_id == 974) test_info_set(p_info, "Get_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field &I:p_value",
                              "Integer Get_attribute(Attributes &p_record, Text p_field, Integer &p_value)", 0, "", "");
  if (p_id == 975) test_info_set(p_info, "Get_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field &R:p_value",
                              "Integer Get_attribute(Attributes &p_record, Text p_field, Real &p_value)", 0, "", "");
  if (p_id == 976) test_info_set(p_info, "Get_attribute", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field &T:p_value",
                              "Integer Get_attribute(Attributes &p_record, Text p_field, Text &p_value)", 0, "", "");
  if (p_id == 977) test_info_set(p_info, "Attribute_exists", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record T:p_field",
                              "Integer Attribute_exists(Attributes &p_record, Text p_field)", 0, "", "");
  if (p_id == 978) test_info_set(p_info, "Get_number_of_attributes", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record &I:p_count",
                              "Integer Get_number_of_attributes(Attributes &p_record, Integer &p_count)", 0, "", "");
  if (p_id == 979) test_info_set(p_info, "Attribute_delete_all", "library", "library", "library", "", 0, 0, "Integer", "&A:p_record",
                              "Integer Attribute_delete_all(Attributes &p_record)", 0, "", "");
}

void test_registry_call_25(Integer p_id, Attributes &p_in, Attributes &p_out)
// ----------------------------------------------------------------
// Run one of functions 961 to 979 (see the header)
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
  Text    l_t7 = "";
  Integer l_ret_i = 0;
  Real    l_ret_r = 0.0;
  Text    l_ret_t = "";
  Real    l_start = 0.0;
  Real    l_end   = 0.0;

  if (p_id == 961) {   // From_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = From_text(l_t1, l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 962) {   // From_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = From_text(l_t1, l_r1);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
  } else if (p_id == 963) {   // From_text
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    test_reset_words(g_test_words, record_text(p_in, ATTR_TEST_WORDS));
    Get_time(l_start);
    l_ret_i = From_text(l_t1, g_test_words);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_WORDS, test_words_text(g_test_words));
  } else if (p_id == 964) {   // Set_char
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    l_i2 = record_integer(p_in, ATTR_TEST_I2);
    Get_time(l_start);
    l_ret_i = Set_char(l_t1, l_i1, l_i2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 965) {   // Get_time
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = Get_time(l_r1);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
  } else if (p_id == 966) {   // Get_time
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Get_time(l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 967) {   // Get_user_name
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = Get_user_name(l_t1);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T1, l_t1);
  } else if (p_id == 968) {   // Get_random_number_closed
    Get_time(l_start);
    l_ret_r = Get_random_number_closed();
    Get_time(l_end);
  } else if (p_id == 969) {   // File_exists
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = File_exists(l_t1);
    Get_time(l_end);
  } else if (p_id == 970) {   // Directory_exists
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = Directory_exists(l_t1);
    Get_time(l_end);
  } else if (p_id == 971) {   // Set_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Set_attribute(g_test_record, l_t1, l_i1);
    Get_time(l_end);
  } else if (p_id == 972) {   // Set_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = Set_attribute(g_test_record, l_t1, l_r1);
    Get_time(l_end);
  } else if (p_id == 973) {   // Set_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = Set_attribute(g_test_record, l_t1, l_t2);
    Get_time(l_end);
  } else if (p_id == 974) {   // Get_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Get_attribute(g_test_record, l_t1, l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 975) {   // Get_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_r1 = record_real(p_in, ATTR_TEST_R1);
    Get_time(l_start);
    l_ret_i = Get_attribute(g_test_record, l_t1, l_r1);
    Get_time(l_end);
    record_set_real(p_out, ATTR_TEST_R1, l_r1);
  } else if (p_id == 976) {   // Get_attribute
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    l_t2 = record_text(p_in, ATTR_TEST_T2);
    Get_time(l_start);
    l_ret_i = Get_attribute(g_test_record, l_t1, l_t2);
    Get_time(l_end);
    record_set_text(p_out, ATTR_TEST_T2, l_t2);
  } else if (p_id == 977) {   // Attribute_exists
    l_t1 = record_text(p_in, ATTR_TEST_T1);
    Get_time(l_start);
    l_ret_i = Attribute_exists(g_test_record, l_t1);
    Get_time(l_end);
  } else if (p_id == 978) {   // Get_number_of_attributes
    l_i1 = record_integer(p_in, ATTR_TEST_I1);
    Get_time(l_start);
    l_ret_i = Get_number_of_attributes(g_test_record, l_i1);
    Get_time(l_end);
    record_set_integer(p_out, ATTR_TEST_I1, l_i1);
  } else if (p_id == 979) {   // Attribute_delete_all
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
  if (p_id >= 801 && p_id <= 840) test_registry_info_21(p_id, p_info);
  if (p_id >= 841 && p_id <= 880) test_registry_info_22(p_id, p_info);
  if (p_id >= 881 && p_id <= 920) test_registry_info_23(p_id, p_info);
  if (p_id >= 921 && p_id <= 960) test_registry_info_24(p_id, p_info);
  if (p_id >= 961 && p_id <= 979) test_registry_info_25(p_id, p_info);
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
  if (p_id >= 801 && p_id <= 840) test_registry_call_21(p_id, p_in, p_out);
  if (p_id >= 841 && p_id <= 880) test_registry_call_22(p_id, p_in, p_out);
  if (p_id >= 881 && p_id <= 920) test_registry_call_23(p_id, p_in, p_out);
  if (p_id >= 921 && p_id <= 960) test_registry_call_24(p_id, p_in, p_out);
  if (p_id >= 961 && p_id <= 979) test_registry_call_25(p_id, p_in, p_out);
}

#endif
