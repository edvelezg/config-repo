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
 * Wrapper for join-line.
 * This command ensures that a space is inserted before the
 * joined line if the cursor begins within the first line.  If
 * the cursor begins after the end of the first line, the
 * join-line behavior is not affected.
 */
_command void wrox_join_line_with_space() name_info(','VSARG2_REQUIRES_EDITORCTL) {
  push_bookmark();
  int orig_col = p_col;
  end_line();
  if (p_col > orig_col) {
    cursor_right();
  }
  else {
    p_col = orig_col;
  }
  join_line();
  pop_bookmark();
}

defeventtab default_keys;
def 'A-J'=wrox_join_line_with_space;

