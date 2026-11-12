#ifndef INCLUDE_SAFETY_H
#define INCLUDE_SAFETY_H

//------------------------------------------------------------
// Safety
//
// Blocks every 12dPL library call that could harm the computer, the
// 12d project or the user's files. Each blocked call is replaced by
// "illegal_call", which isn't defined anywhere, so a macro that uses
// one doesn't compile. That proves what the macro can't do without
// anyone reading the rest of the source:
//
//   - start programs, run shell commands or other macros and chains
//   - delete, copy, rename or overwrite files outside the worlds
//     folder, or delete folders
//   - delete or change models, tins, elements, views, functions or
//     project settings, or save the project
//   - use the clipboard, databases or network services (Synergy,
//     ODBC, web links)
//
// Files: File_open is blocked too. The only way to open a file is
// safe_file_open() below, which opens any file for reading but only
// opens files inside SAFE_WRITE_FOLDER for writing.
//
// build.4dm includes this file before anything else, so the blocks
// cover every source file. Don't include anything before it, and
// never #undef one of these names. It depends on no other header.
//------------------------------------------------------------

#define SAFE_WRITE_FOLDER  "cubeland_worlds"
#define SAFE_OPEN_REFUSED  (-1)
#define SAFE_YES           (1)
#define SAFE_NO            (0)


// ---------------------------------------------------------------- the one way to open a file

Integer safe_path_is_writable(Text p_path)
// ----------------------------------------------------------------
// SAFE_YES if p_path is a file inside SAFE_WRITE_FOLDER (relative to the
// 12d working folder), with no ".." or drive letter that could
// climb out of it
// ----------------------------------------------------------------
{
  Text    l_folder = SAFE_WRITE_FOLDER;
  Text    l_prefix = "";
  Integer l_length = 0;

  l_prefix = l_folder + "\\";
  l_length = Text_length(l_prefix);

  if (Text_length(p_path) <= l_length)                   return SAFE_NO;
  if (Get_subtext(p_path, 1, l_length) != l_prefix)      return SAFE_NO;
  if (Find_text(p_path, "..") > 0)                       return SAFE_NO;
  if (Find_text(p_path, ":")  > 0)                       return SAFE_NO;
  if (Find_text(p_path, "/")  > 0)                       return SAFE_NO;
  return SAFE_YES;
}

Integer safe_file_open(Text p_path, Text p_mode, File &p_file)
// ----------------------------------------------------------------
// File_open (as an ANSI file) that only reads, unless the file is in
// SAFE_WRITE_FOLDER. Modes "r" and "rb" open anything; any other mode
// ("w", "wb", "a", "r+", ...) needs safe_path_is_writable().
// Returns 0 when the file was opened, like File_open.
// ----------------------------------------------------------------
{
  Integer l_reading = SAFE_NO;

  if (p_mode == "r")  l_reading = SAFE_YES;
  if (p_mode == "rb") l_reading = SAFE_YES;

  if (!l_reading) {
    if (!safe_path_is_writable(p_path)) return SAFE_OPEN_REFUSED;
  }
  return File_open(p_path, p_mode, "", p_file);
}


// ---------------------------------------------------------------- blocked calls
// (defined after safe_file_open, which is the only code that may
// call File_open)

// Files
#define File_open                             illegal_call
#define File_copy                             illegal_call
#define Delete_files                          illegal_call
#define Set_file_read_only                    illegal_call
#define Directory_delete                      illegal_call
#define Directory_delete_recursive            illegal_call
#define Write_to_file                         illegal_call
#define Write_4d_ascii                        illegal_call
#define Write_12d                             illegal_call
#define Write_12d_data                        illegal_call
#define Write_SLX                             illegal_call
#define Write_DAE_file                        illegal_call
#define Write_XML                             illegal_call
#define Write_XML_Document                    illegal_call
#define Write_XML_document                    illegal_call
#define Write_parameter_file                  illegal_call
#define Write_favorite                        illegal_call
#define View_write_favourite_file             illegal_call
#define View_write_position_file              illegal_call
#define Save_output_window_to_XML             illegal_call
#define Dump_slx_image                        illegal_call
#define File_redirect                         illegal_call

// Programs, shell commands, other macros
#define Create_process                        illegal_call
#define Shell_execute                         illegal_call
#define System                                illegal_call
#define Process_exists                        illegal_call
#define Create_macro                          illegal_call
#define Create_macro_function                 illegal_call
#define Run_chain                             illegal_call
#define Recalc_chain_running                  illegal_call
#define Run_slf_data                          illegal_call
#define Run_slf_file                          illegal_call
#define Read_4d_ascii                         illegal_call
#define Read_project_settings_file            illegal_call

// Project data
#define Project_save                          illegal_call
#define Model_delete                          illegal_call
#define Model_rename                          illegal_call
#define Remove_model                          illegal_call
#define Tin_delete                            illegal_call
#define Tin_rename                            illegal_call
#define Element_delete                        illegal_call
#define Delete_element                        illegal_call
#define Delete_all_models                     illegal_call
#define Delete_all_empty_models               illegal_call
#define Delete_all_tins                       illegal_call
#define Delete_all_functions                  illegal_call
#define Delete_function_strings_and_models    illegal_call
#define Delete_all_dependancies               illegal_call
#define Delete_dependancy                     illegal_call
#define Delete_hip                            illegal_call
#define Function_delete                       illegal_call
#define Function_rename                       illegal_call
#define Template_rename                       illegal_call
#define View_delete                           illegal_call
#define View_remove_model                     illegal_call
#define Menu_delete                           illegal_call
#define Set_project_attribute                 illegal_call
#define Set_project_attributes                illegal_call
#define Project_attribute_delete              illegal_call
#define Project_attribute_delete_all          illegal_call
#define Model_attribute_delete                illegal_call
#define Model_attribute_delete_all            illegal_call
#define Set_project_setting_colour            illegal_call
#define Set_project_setting_integer           illegal_call
#define Set_project_setting_real              illegal_call
#define Remove_project_setting                illegal_call
#define Set_active_project_settings_profile   illegal_call
#define Remove_shared_in_model                illegal_call
#define Remove_shared_in_tin                  illegal_call
#define Remove_drainage_pit                   illegal_call
#define Run_drainage_2d                       illegal_call
#define Run_drainage_analysis                 illegal_call
#define Run_drainage_analysis_dynamic         illegal_call
#define Run_dws_network                       illegal_call

// Clipboard, databases, network
#define Get_clipboard_text                    illegal_call
#define Set_clipboard_text                    illegal_call
#define Console_to_clipboard                  illegal_call
#define Create_ODBC_connection                illegal_call
#define Connect                               illegal_call
#define Execute                               illegal_call
#define Synergy_connect                       illegal_call
#define Synergy_check_out                     illegal_call
#define Synergy_get                           illegal_call

#endif
