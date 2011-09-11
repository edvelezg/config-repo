// $Id: wrox_comments.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-03-10
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
 * Returns whether the cursor is currently within a comment.
 * The function first moves the cursor to the first non-blank
 * character on the line, then tests whether a search for
 * anything in a comment moves the cursor.  If it does not move
 * the cursor, we're in a comment.
 *
 * @return true if the cursor is in a comment.
 */
boolean wrox_in_comment() {
  push_bookmark();
  p_col = 1;
  begin_line_text_toggle();
  int orig_col = p_col;
  int orig_line = p_line;
  int status = search(".", "U,CC");
  boolean result = (!status && orig_col == p_col && orig_line == p_line);
  pop_bookmark();
  return result;
}

/**
 * Toggles the comment.
 * If there is a selection, the comment is toggled for the
 * selection.
 * If there is no selection, the comment is toggled for the
 * line, and the cursor is moved down.  This allows you to
 * repeat the command easily for several lines without making a
 * selection.
 */
_command void wrox_toggle_comment() name_info(','VSARG2_REQUIRES_EDITORCTL) {
  boolean selection = _select_type() != "";
  if (wrox_in_comment()) {
    comment_erase();
  }
  else {
    comment();
  }
  if (!selection) {
    cursor_down();
  }
}

defeventtab default_keys;
def 'C-S-/' = wrox_toggle_comment;

