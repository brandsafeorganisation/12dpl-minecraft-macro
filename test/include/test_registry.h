#ifndef TEST_REGISTRY_H_INCLUDED
#define TEST_REGISTRY_H_INCLUDED

// ----------------------------------------------------------------
// Written by tools/make_test_registry.py: do not edit; run it again
// after adding, removing or changing a function.
//
// Every function of the macro (and some library calls) by number:
// test_registry_info fills a record with what function n is, and
// test_registry_call runs it with the inputs in p_in (fields i1..,
// r1.., t1.. for its Integer, Real and Text parameters in order,
// "words" for a Dynamic_Text), putting the return value, the
// reference parameters afterwards and the seconds it took in p_out.
// ----------------------------------------------------------------

#define TEST_FUNCTION_COUNT     712
#define TEST_MACRO_COUNT        680
#define TEST_INTEGER_SLOTS      12
#define TEST_REAL_SLOTS         13
#define TEST_TEXT_SLOTS         6

#define TEST_FLAG_WRITES_FILES  1

#define DATATYPE_TEST_INFO      ("test_info")
#define ATTR_TEST_NAME            ("name")
#define ATTR_TEST_KIND            ("kind")
#define ATTR_TEST_PART            ("part")
#define ATTR_TEST_MODULE          ("module")
#define ATTR_TEST_FILE            ("file")
#define ATTR_TEST_FIRST           ("first")
#define ATTR_TEST_LAST            ("last")
#define ATTR_TEST_RETURNS         ("returns")
#define ATTR_TEST_PARAMS          ("params")
#define ATTR_TEST_SIGNATURE       ("signature")
#define ATTR_TEST_FLAGS           ("flags")
#define ATTR_TEST_WHY             ("why")
#define ATTR_TEST_CALLS           ("calls")
#define ATTR_TEST_I1              ("i1")
#define ATTR_TEST_I2              ("i2")
#define ATTR_TEST_I3              ("i3")
#define ATTR_TEST_I4              ("i4")
#define ATTR_TEST_I5              ("i5")
#define ATTR_TEST_I6              ("i6")
#define ATTR_TEST_I7              ("i7")
#define ATTR_TEST_I8              ("i8")
#define ATTR_TEST_I9              ("i9")
#define ATTR_TEST_I10             ("i10")
#define ATTR_TEST_I11             ("i11")
#define ATTR_TEST_I12             ("i12")
#define ATTR_TEST_R1              ("r1")
#define ATTR_TEST_R2              ("r2")
#define ATTR_TEST_R3              ("r3")
#define ATTR_TEST_R4              ("r4")
#define ATTR_TEST_R5              ("r5")
#define ATTR_TEST_R6              ("r6")
#define ATTR_TEST_R7              ("r7")
#define ATTR_TEST_R8              ("r8")
#define ATTR_TEST_R9              ("r9")
#define ATTR_TEST_R10             ("r10")
#define ATTR_TEST_R11             ("r11")
#define ATTR_TEST_R12             ("r12")
#define ATTR_TEST_R13             ("r13")
#define ATTR_TEST_T1              ("t1")
#define ATTR_TEST_T2              ("t2")
#define ATTR_TEST_T3              ("t3")
#define ATTR_TEST_T4              ("t4")
#define ATTR_TEST_T5              ("t5")
#define ATTR_TEST_T6              ("t6")
#define ATTR_TEST_WORDS         ("words")
#define ATTR_TEST_RET_I         ("ret_i")
#define ATTR_TEST_RET_R         ("ret_r")
#define ATTR_TEST_RET_T         ("ret_t")
#define ATTR_TEST_SECONDS       ("seconds")

void    test_info_set      (Attributes &p_info, Text p_name, Text p_kind, Text p_part, Text p_module, Text p_file,
                            Integer p_first, Integer p_last, Text p_returns, Text p_params, Text p_signature,
                            Integer p_flags, Text p_why, Text p_calls);
void    test_registry_info_1 (Integer p_id, Attributes &p_info);
void    test_registry_call_1 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_2 (Integer p_id, Attributes &p_info);
void    test_registry_call_2 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_3 (Integer p_id, Attributes &p_info);
void    test_registry_call_3 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_4 (Integer p_id, Attributes &p_info);
void    test_registry_call_4 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_5 (Integer p_id, Attributes &p_info);
void    test_registry_call_5 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_6 (Integer p_id, Attributes &p_info);
void    test_registry_call_6 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_7 (Integer p_id, Attributes &p_info);
void    test_registry_call_7 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_8 (Integer p_id, Attributes &p_info);
void    test_registry_call_8 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_9 (Integer p_id, Attributes &p_info);
void    test_registry_call_9 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_10 (Integer p_id, Attributes &p_info);
void    test_registry_call_10 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_11 (Integer p_id, Attributes &p_info);
void    test_registry_call_11 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_12 (Integer p_id, Attributes &p_info);
void    test_registry_call_12 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_13 (Integer p_id, Attributes &p_info);
void    test_registry_call_13 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_14 (Integer p_id, Attributes &p_info);
void    test_registry_call_14 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_15 (Integer p_id, Attributes &p_info);
void    test_registry_call_15 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_16 (Integer p_id, Attributes &p_info);
void    test_registry_call_16 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_17 (Integer p_id, Attributes &p_info);
void    test_registry_call_17 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info_18 (Integer p_id, Attributes &p_info);
void    test_registry_call_18 (Integer p_id, Attributes &p_in, Attributes &p_out);
void    test_registry_info (Integer p_id, Attributes &p_info);
void    test_registry_call (Integer p_id, Attributes &p_in, Attributes &p_out);

#endif
