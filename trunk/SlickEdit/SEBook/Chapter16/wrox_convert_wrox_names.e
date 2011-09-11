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

#define WROX_FUNCTION_NAME 'wrox_(\:v)\('
#define WROX_DEF 'def (.*)= *wrox_(\:v);'
#define WROX_TYPES (PROC_TYPE | VAR_TYPE | COMMAND_TYPE)

/**
 * Converts WROX macro definitions by removing "wrox_" prefix,
 * to make them friendlier-looking and easier to type, although
 * more at risk of clashing with SlickEdit product macros.
 * TODO: more explanation.
 * @param path Path the WROX source files.
 */
_command void wrox_convert_wrox_names(_str path = "") name_info(DIR_ARG','VSARG2_REQUIRES_EDITORCTL) {
  path = prompt(path, "Path to WROX source files");
  push_bookmark();
  insert_line('#include "slick.sh"');
  _str macro_filespec = path"/*.e";
  _str files[] = wrox_list_files("+P +T -D "macro_filespec);
  int i;
  int file_count = 0;
  for (i = 0; i < files._length(); i++) {
    _str filename = files[i];
    if (pos("wrox_try", filename) > 0) {
      continue; // skip wrox_try files: they're for testing/demo purposes only
    }
    int temp_view_id;
    int orig_view_id = _create_temp_view(temp_view_id);
    get(filename); // loads file contents into temp buffer
    top();
    if (!search("defmain")) {          // skip Slick-C batch macro files
      pop_bookmark();
      _delete_temp_view(temp_view_id);
      continue;
    }
    file_count++;
    int status = search(WROX_FUNCTION_NAME, "U@>");
    while (!status) {
      _str short_name = get_text(match_length("1"), match_length("S1"));
      if (find_index(short_name, WROX_TYPES)) { // check whether short name already in use
        message(short_name " ("filename") already exists!");
        pop_bookmark();
        return;
      }
      status = search(WROX_FUNCTION_NAME, "U@>");
    }
    // if we get here all names in the file are OK
    top();
    deselect();
    search('#include ');       // skip down to first #include line
    search('$[ \t]*^', 'U>');  // skip down to following blank line
    select_line();             // start mark here
    bottom();
    select_line();             // mark to rest of file
    activate_window(orig_view_id);
    bottom();
    push_bookmark();
    copy_to_cursor();          // copy/append data into this file
    deselect();
    replace(WROX_FUNCTION_NAME, '\1(', "U*>"); // remove wrox_ from function names
    pop_bookmark();
    replace(WROX_DEF, 'def \1=\2;', "U*>");    // remove wrox_ from keyboard defs
    insert_line("");
    _delete_temp_view(temp_view_id);
  }
  pop_bookmark();
  message("Files processed: " file_count);
}


