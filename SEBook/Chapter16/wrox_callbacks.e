// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-17
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
 * Lists all callback event names into the current buffer.
 */
_command void wrox_insert_callbacks() name_info(',VSARG2_REQUIRES_EDITORCTL') {
  _str callbacks[] = wrox_list_callbacks();
  int i;
  for (i = 0; i < callbacks._length(); i++) {
    _insert_text(callbacks[i]);
    nosplit_insert_line();
  }
}

/**
 * Outputs a trace function for the given callback event.
 * @param callback The callback event name.
 */
_command void wrox_make_callback_trace(_str callback="") name_info(','VSARG2_REQUIRES_EDITORCTL) {
  insert_line("void "callback"_trace() {");
  insert_line("  say(\""callback" called\");");
  insert_line("}");
  insert_line("");
}

/**
 * Runs the given command for each callback event defined.
 * Use like this:
 *   wrox_foreach_callback wrox_make_callback_trace
 * To output callback trace functions for all callbacks.
 * @param command Command to run.
 */
_command void wrox_foreach_callback(_str command="") name_info(COMMAND_ARG','VSARG2_REQUIRES_EDITORCTL) {
  command = prompt(command, "Command");
  _str callbacks[] = wrox_list_callbacks();
  int i;
  for (i = 0; i < callbacks._length(); i++) {
    execute(command" "callbacks[i]);
  }
}

#define CALL_LIST_PATTERN 'call_list\(([''"])(\:v)\1'

/**
 * Returns an array containing list of all callback events in
 * Slick-C macro source.
 */
STRARRAY wrox_list_callbacks() {
  _str macro_filespec = maybe_quote_filename(get_env("VSLICKMACROS")"*.e");
  // NOTE: on Mac OS X VSLICKMACROS may not include a trailing slash ... (!)
  _str files[] = wrox_list_files("+P -D "macro_filespec);
  int i;
  _str callbacks:[];
  for (i = 0; i < files._length(); i++) {
    _str filename = files[i];
    int temp_view_id;
    int orig_view_id = _create_temp_view(temp_view_id);
    get(filename); // loads file contents into temp buffer
    top();
    int status = search(CALL_LIST_PATTERN, "U@>");
    while (!status) {
      _str callback = get_text(match_length("2"), match_length("S2"));
      callbacks:[callback] = 1;
      status = search(CALL_LIST_PATTERN, "U@>");
    }
    _delete_temp_view(temp_view_id);
    activate_window(orig_view_id);
  }
  return wrox_hash_keys(callbacks);
}

