// $Id: wrox_align.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-02-21
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

/**
 * Left-aligns next field with field above.
 * Align data in a tabular format.
 * It moves the following text on the current line to the right,
 * to align it with the next field of the line above  (left-justified).
 * JH_TODO: keyboard binding?
 *
 * @return typeless
 */
_command wrox_align_left_with_field_above() name_info(','MACRO_ARG2|MARK_ARG2) {
  if (p_line < 2) {
    message("This function does not work on line zero or one.");
    return 0;
  }

  // save current position etc
  push_bookmark();
  int cur_line = p_line;
  _str cur_char = get_text();

  // move forward to non-whitespace on current line
  if (cur_char == " " || cur_char == "\t" || cur_char == "\n") {
    wrox_next_whitespace_word();
  }

  // remember column of stuff to move
  int cur_col  = p_col;

  // go to next field on line above
  cursor_up();
  wrox_next_whitespace_word();

  // if we stayed on the same line when moving forward by a field ...
  if (p_line == cur_line-1) {
    // shift the text, returning to the original position afterwards
    int diff = p_col - cur_col;
    pop_bookmark();
    push_bookmark();
    _insert_text(substr('', 1, diff, ' '));
    pop_bookmark();
  }
  else {
    // return to the original position
    pop_bookmark();
  }
}

/**
 * Right-aligns next field with field above.
 * Align data in a tabular format.
 * It moves the following text on the current line to the right,
 * to align it with the next field of the line above (right-justified).
 * JH_TODO: keyboard binding?
 *
 * @return typeless
 */
_command wrox_align_right_with_field_above() name_info(','MACRO_ARG2|MARK_ARG2) {
  if (p_line < 2) {
    message("This function does not work on line zero or one.");
    return 0;
  }

  // save current position etc
  push_bookmark();
  int cur_line = p_line;

  // move forward to end of next field on current line
  next_word();

  // remember column of stuff to move
  int cur_col  = p_col;

  // go to end of next field on line above
  cursor_up();
  next_word();
  int diff = p_col - cur_col;

  // if we stayed on the same line when moving forward by a field ...
  if (diff > 0 && p_line == cur_line-1) {
    // shift the text, returning to the original position afterwards
    pop_bookmark();
    push_bookmark();
    _insert_text(substr( '', 1, diff, ' '));
    pop_bookmark();
  }
  else if (diff < 0 && p_line == cur_line-1) {
    pop_bookmark();
    int i;
    for (i=0; i<(-diff); i++) {
      _delete_char();
    }
  }
  else {
    // return to the original position
    pop_bookmark();
  }
}

// default key bindings to alignment commands
defeventtab default_keys;
def   "A-S-L"= wrox_align_left_with_field_above;
def   "A-S-R"= wrox_align_right_with_field_above;

