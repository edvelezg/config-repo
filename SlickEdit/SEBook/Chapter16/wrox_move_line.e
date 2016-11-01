// $Id: wrox_move_line.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-07-17

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
 * Converts the current character selection into an appropriate
 * line selection.
 *
 */
_command void wrox_to_line_selection() {
  push_bookmark();
  begin_select();
  push_bookmark();
  end_select();
  if (p_col == 1) {
    cursor_up();
  }
  select_line();
  pop_bookmark();
  select_line();
  pop_bookmark();
}

// TODO: what if selection in a different buffer?

/**
 * Moves the current line or selection up by the given number of
 * lines.
 *
 * @param commandline The number of lines by which to move.
 *                    Default is 1.
 */
_command void wrox_move_line_up(_str commandline="1") {
  int n = (int) commandline;
  int i;
  int orig_col = p_col;
  if (_select_type() == 'CHAR') {
    message("selection changed");
    wrox_to_line_selection();
  }
  if (_select_type() == "LINE") {
    begin_select();
    cursor_up(n + 1);
    move_to_cursor();
  }
  else {
    _str line;
    get_line(line);
    _delete_line();
    cursor_up(n + 1);
    insert_line(line);
  }
  p_col = orig_col;  // restore column position
}

/**
 * Moves the current line or selection down by the given number
 * of lines.
 *
 * @param commandline The number of lines by which to move.
 *                    Default is 1.
 */
_command void wrox_move_line_down(_str commandline="1") {
  int n = (int) commandline;
  int i;
  int orig_col = p_col;
  if (_select_type() == 'CHAR') {
    message("selection changed");
    wrox_to_line_selection();
  }
  if (_select_type() == "LINE") {
    end_select();
    cursor_down(n);
    move_to_cursor();
  }
  else {
    _str line;
    get_line(line);
    _delete_line();
    cursor_down(n - 1);
    insert_line(line);
  }
  p_col = orig_col;  // restore column position
}

defeventtab default_keys;
def 'A-Up'=wrox_move_line_up;
def 'A-Down'=wrox_move_line_down;

