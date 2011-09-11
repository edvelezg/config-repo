// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-24
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
 * Move cursor under next non-whitespace character on line above.
 * If there is no line above, or it all whitespace after this column,
 * call ctab instead.
 */
_command void wrox_tab_matchtabs() name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY) {
  if (p_line < 2) { // no line above
    ctab();
    return;
  }
  cursor_up();
  _str line_above;
  get_line(line_above);
  cursor_down();
  _str remainder_above = strip(substr(line_above, p_col), 'T');
  if (length(remainder_above) <= 1) { // no more non-whitespace above
    ctab();
    return;
  }
  int first_space = pos('[ \t]', remainder_above, 1, 'U'); // Unix regexp
  if (first_space == 0) {               // no more spaces; skip to end
    first_space = length(remainder_above);
  }
  int first_nonspace = pos('[^ \t]', remainder_above, first_space, 'U');
  p_col += first_nonspace - 1;
}

/**
 * Move the cursor under the character before the previous non-whitespace
 * character on line above.
 * If there is no line above, or it is whitespace from the
 * beginning to this column, call cbacktab instead.
 */
_command void wrox_backtab_matchtabs() name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY) {
  if (p_line < 2) { // no line above
    cbacktab();
    return;
  }
  cursor_up();
  _str line_above;
  get_line(line_above);
  cursor_down();
  _str remainder_above = substr(line_above, 1, p_col - 1);
  if (length(strip(remainder_above)) <= 1) { // no more non-whitespace above
    cbacktab();
    return;
  }
  int last_nonspace = lastpos('[^ \t]', remainder_above, p_col, 'U'); // Unix regexp
  if (last_nonspace == 0) { // all spaces; normal backtab
    cbacktab();
    return;
  }
  int last_space = lastpos('[ \t]', remainder_above, last_nonspace, 'U');
  p_col = last_space + 1;
}

// key bindings for tab/backtab key
defeventtab default_keys;
def "TAB"= wrox_tab_matchtabs;
def "S-TAB"= wrox_backtab_matchtabs;



