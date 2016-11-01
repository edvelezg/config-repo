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
 * A popup menu of some commands presented in WROX book.
 */
_menu wrox_popup_menu {
  "WROX commands","","","","";
  "", "", "", "", "";              // blank item to be replaced with divider
  submenu "&Selections", "", "Selections...", "ncw";
    "&Save line selection",    "wrox-save-line-sel",    "", "", "Save line selection to bookmarks";
    "&Restore line selection", "wrox-restore-line-sel", "", "", "Restore line selection from bookmarks";
  endsubmenu
  submenu "&Alignment", "", "Align...", "ncw";
    "&Left with above", "wrox-align-left-with-field-above", "", "", "Left-align next field with next field above";
    "&Right with above", "wrox-align-right-with-field-above", "", "", "Right-align next field with next field above";
  endsubmenu
  submenu "&Repeat", "", "Repeat...", "ncw";
    "&Last macro n times", "wrox-repeat-n-last-macro", "", "", "Repeat last_macro n times";
  endsubmenu
  submenu "&Other", "", "Other...", "ncw";
    "Toggle &comment", "wrox-toggle-comment", "", "", "Toggle comment for line selection or current line";
    "&Execute current command", "wrox-execute-current-command", "", "", "Execute current command";
    "Count &duplicates", "wrox-count-duplicates", "", "", "Count duplicates";
  endsubmenu
}

/**
 * Shows the WROX popup menu.
 * This command is suitable for binding to a key.
 */
_command void wrox_show_wrox_popup_menu() {
  int index = find_index("wrox_popup_menu", oi2type(OI_MENU));
  if (!index) {
    message("Can't find wrox_popup_menu");
    return;
  }

  int x = _screen_width()/2;                        // middle across
  int y = _screen_height()/3;                       // one-third down screen
  int flags = VPM_CENTERALIGN|VPM_LEFTBUTTON;
  int child = index.p_child;
  child++;
  child.p_caption = "-";                        // put in separator line
  int menu_handle = _menu_load(index, "P");
  _menu_show(menu_handle, flags, x, y);
  _menu_destroy(menu_handle);
}

defeventtab default_keys;
def 'C-W'=wrox_show_wrox_popup_menu;

