// $Id: wrox_selections.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-05-14
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
 * Saves the current line selection as a pair of bookmarks.
 * Specify the bookmark prefix to the command, or it defaults to
 * "SELECTION".
 */
_command void wrox_save_line_sel(_str bookmark = "SELECTION") name_info(','VSARG2_REQUIRES_AB_SELECTION) {
  if (_select_type() != "LINE") {
    message("Line selection required.");
    return;
  }
  delete_bookmark(bookmark "_START");
  delete_bookmark(bookmark "_END");
  push_bookmark();
  begin_select();
  set_bookmark(bookmark "_START");
  end_select();
  set_bookmark(bookmark "_END");
  pop_bookmark();
}

/**
 * Restores a line selection from a pair of bookmarks.
 * Specify the bookmark prefix to the command, or it defaults to
 * "SELECTION".
 */
_command void wrox_restore_line_sel(_str bookmark = "SELECTION") name_info(BOOKMARK_ARG'*,'VSARG2_REQUIRES_EDITORCTL) {
  push_bookmark();
  goto_bookmark(bookmark "_START");
  _str filename = p_buf_name;
  goto_bookmark(bookmark "_END");
  if (p_buf_name != filename) {
    message("Bookmark _END must be in same file as bookmark _START.");
    pop_bookmark();
    return;
  }
  deselect();
  goto_bookmark(bookmark "_START");
  select_line();
  goto_bookmark(bookmark "_END");
  select_line();
  pop_bookmark();
}

