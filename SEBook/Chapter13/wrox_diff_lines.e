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
 * Compare two ranges of lines, determined by bookmarks.
 * The bookmarks are given as four arguments, or they default to
 * 1, 2, 3 and 4.
 */
_command void wrox_diff_lines(_str bookmarks = "1 2 3 4") name_info(BOOKMARK_ARG'*,'VSARG2_REQUIRES_EDITORCTL) {
  _str bookmark1;
  _str bookmark2;
  _str bookmark3;
  _str bookmark4;
  parse bookmarks with bookmark1 bookmark2 bookmark3 bookmark4;
  push_bookmark();
  goto_bookmark(bookmark1);
  _str filename1 = p_buf_name;
  int start_line1 = p_line;
  goto_bookmark(bookmark2);
  if (p_buf_name != filename1) {
    message("Bookmark 2 must be in same file as bookmark 1.");
    pop_bookmark();
    return;
  }
  int end_line1 = p_line;
  if (end_line1 <= start_line1) {
    message("Bookmark 2 must be after bookmark 1 in file.");
    pop_bookmark();
    return;
  }
  goto_bookmark(bookmark3);
  _str filename2 = p_buf_name;
  int start_line2 = p_line;
  goto_bookmark(bookmark4);
  if (p_buf_name != filename2) {
    message("Bookmark 4 must be in same file as bookmark 3.");
    pop_bookmark();
    return;
  }
  int end_line2 = p_line;
  if (end_line2 <= start_line2) {
    message("Bookmark 4 must be after bookmark 3 in file.");
    pop_bookmark();
    return;
  }
  _str commandline = "";
  commandline = commandline :+ "-range1:" :+ start_line1 :+ "," :+ end_line1 :+ " ";
  commandline = commandline :+ "-range2:" :+ start_line2 :+ "," :+ end_line2 :+ " ";
  commandline = commandline :+ maybe_quote_filename(filename1) :+ " ";
  commandline = commandline :+ maybe_quote_filename(filename2);
  diff(commandline);
  pop_bookmark();
}


