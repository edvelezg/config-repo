// $Id: wrox_repeat.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-02-20
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

#pragma option(strict,on)
#include "slick.sh"

// for testing:
//_command void tryme() name_info(',') {
//  _insert_text("Try me.  ");
//  begin_line();
//}

/**
 * Repeats a command a given number of times.
 * @param args "n command", where n is how many times, and
 *             command is the command to run.
 */
_command void repeat_n(_str args = null) name_info(','VSARG2_EDITORCTL) {
  if (args == null) {
    message("Specify number of times and command to run.");
    return;
  }
  _str n;
  _str command;
  parse args with n command;
  if (n <= 0 || command == null) {
    message("Specify number of times and command to run.");
    return;
  }
  int i;
  for (i = 0; i < n; i++) {
    execute(command);
  }
}

/**
 * Repeats last_macro a given number of times.
 * @param args "n" - how many times.
 */
_command void repeat_n_last_macro(_str args = null) name_info(','VSARG2_EDITORCTL) {
  repeat_n(args :+ " last_macro");
}

/**
 * Repeats a command for each line in the selection.
 * @param command The command to run.
 */
_command void wrox_repeat_selection(_str command = null) name_info(COMMAND_ARG','VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_AB_SELECTION) {
  if (command == null) {
    message("I need a command.");
    return;
  }
  if (_select_type() :== 'LINE') {
    filter_init();
    for (;;) {
      _str line;
      int status = filter_get_string(line);
      if (status) {
        break;
      }
      execute(command);
    }
    filter_restore_pos();
  }
  // JH_REVIEW: else do whole buffer?
}

/**
 * Repeats last_macro for each line in the selection.
 */
_command void wrox_repeat_selection_last_macro() name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_AB_SELECTION) {
  wrox_repeat_selection("last_macro");
}

