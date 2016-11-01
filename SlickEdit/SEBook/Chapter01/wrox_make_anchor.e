// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-06-21
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

// _command last_recorded_macro() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
// {
//   _macro('R',1);
//   cut();
//   keyin("<a");
//   last_event(name2event(' '));maybe_complete();
//   keyin("href=\"");
//   paste();
//   keyin("\">");
//   paste();
//   keyin("</a>");
// }

/**
 * Creates an HTML anchor (<a>) tag around the selected text.
 * So if the selected text is "www.slickedit.com", this is
 * replaced with
 *   <a href="http://www.slickedit.com">www.slickedit.com</a>
 */
_command void wrox_make_anchor() name_info(','VSARG2_REQUIRES_MDI_EDITORCTL|VSARG2_REQUIRES_AB_SELECTION) {
  if (_select_type() != "CHAR") {
    message("Character selection required");
    return;
  }
  begin_select();
  long begin_pos = _QROffset();
  end_select();
  long end_pos = _QROffset();
  int len = (int) (end_pos - begin_pos);
  _str text = get_text(len, (int) begin_pos);
  _str url = text;
  if (pos("://", url) == 0) {
    url = "http://" :+ url;
  }
  delete_selection();
  seek(begin_pos);
  _insert_text('<a href="'url'">'text'</a>');
}

defeventtab html_keys;
def 'A-S-A'=wrox_make_anchor;

