// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-23
//
// Copyright 2007 Wiley Publishing Inc, Indianapolis, Indiana, USA.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma option(strict, on)
#include "slick.sh"

/**
 * Test/demonstrate find_index().
 * @param command
 */
_command void wrox_try_command_exists(_str command="") name_info(',') {
  if (find_index(command, COMMAND_TYPE)) {
    message("Command "command" exists.");
  }
  else {
    message("Command "command" does not exist.");
  }
}

/**
 * Test/demonstrate name_match().
 *
 * @return int
 */
_command int wrox_try_names() name_info(',') {
  int indexes[];
  indexes = wrox_find_matching_name_indexes("cursor_", COMMAND_TYPE|PROC_TYPE);
  wrox_assert_equals(7, indexes._length());
  wrox_assert_equals("cursor-down", name_name(indexes[0]));
  wrox_assert_equals("cursor-up", name_name(indexes[1]));
  wrox_assert_equals("cursor-left", name_name(indexes[2]));
  wrox_assert_equals("cursor-right", name_name(indexes[3]));
  wrox_assert_equals("cursor-error2", name_name(indexes[4]));
  wrox_assert_equals("cursor-error", name_name(indexes[5]));
  wrox_assert_equals("cursor-shape", name_name(indexes[6]));
  return 0;
}

/**
 * Test/demonstrate find_index().
 * @param varname
 */
_command void wrox_try_get_var(_str varname="") name_info(VAR_ARG',') {
  varname = prompt(varname, "Variable");
  int index = find_index(varname, VAR_TYPE);
  if (!index) {
    message("Variable "varname" not found.");
    return;
  }
  if (index) {
    typeless value = _get_var(index);
    message(varname"=["value"]");
  }
}

/**
 * Test/demonstrate name_match().
 */
_command void wrox_try_list_modules() name_info(',') {
  int index = name_match("", 1, MODULE_TYPE);
  while (index) {
    insert_line(name_name(index));
    index = name_match("", 0, MODULE_TYPE);
  }
}

/**
 * Test/demonstrate name_match().
 * @param type
 */
_command void wrox_try_list_names(int type = 0) name_info(',') {
  if (type == 0) {
    message("Specify a type.");
    return;
  }
  int index = name_match("", 1, type);
  while (index) {
    insert_line(name_name(index));
    index = name_match("", 0, type);
  }
}

/**
 * Use name_match() to list buffers.
 */
_command void wrox_try_list_buffers() name_info(',') {
  wrox_try_list_names(BUFFER_TYPE);
}

/**
 * Use name_match() to list "misc" items in Slick-C name table.
 */
_command void wrox_try_list_miscs() name_info(',') {
  wrox_try_list_names(MISC_TYPE);
}

/**
 * Use name_match() to list "ignorecases" in Slick-C name table.
 */
_command void wrox_try_list_ignorecases() name_info(',') {
  wrox_try_list_names(IGNORECASE_TYPE);
}

/**
 * Use name_match() to list commands.
 */
_command void wrox_try_list_commands() name_info(',') {
  wrox_try_list_names(COMMAND_TYPE);
}

/**
 * Use name_match() to list procs.
 */
_command void wrox_try_list_procs() name_info(',') {
  wrox_try_list_names(PROC_TYPE);
}

