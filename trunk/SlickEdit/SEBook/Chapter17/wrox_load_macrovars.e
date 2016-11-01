// $Id: wrox_load_macrovars.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-05-25
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
 * Configuration settings controlled by macro variables.
 * Slick-C macro variables.
 */
defmain() {

  // Two character def_select_style corresponds to two settings in the config:
  // Extend selection as cursor moves (C = yes, E = no)
  // Inclusive character selection (I = yes, N = no)
  // We change to EI because:
  // 'E' gives more flexible selection locking, and
  // 'I' is makes character selections easier to use
  set_var('def_select_style EI');  // CUA default is CN

  // Leave selection after a copy, but not after a paste
  set_var('def_deselect_copy 0');  // CUA default is 1
  //set_var('def_deselect_paste 1'); // CUA default is 1

  // CUA style: typing replaces basic (not locked) selection
  //set_var('def_persistent_select D'); // CUA is D

  // ************************
  // Cursor movement/wrapping
  // ************************

  // undo undoes cursor movement as well as changes
  set_var('def_undo_with_cursor 1'); // CUA default is 0

  // allow cursor to move freely beyond the ends of lines
  // Tools | Options | General, General Tab
  set_var('def_click_past_end 1'); // CUA default is 0


  // Tools | Options | File Options, Save tab
  set_var('def_save_options -O -Z -ZR -E +S +DD +L'); // Strip tabs, reset line modification markers

  // do not wrap cursor at start/end of line
  // Tools | Options | Redefine Common Keys (?)
  set_var('def_cursorwrap 0'); // CUA default is 1

  // Tools | Options | Redefine Common Keys
  set_var('def_linewrap 0');
  set_var('def_restore_cursor 0'); // JH_REVIEW?
  set_var('def_updown_col 0');

  // *************
  // Miscellaneous
  // *************
  set_var('def_fast_open 1');        // Use Windows 3.1 / fast-open dialog
  set_var('def_alt_menu 0');         // allow def Alt keys for commands
  set_var('def_top_bottom_style 1'); // preserve column on top/bottom
  set_var('def_toolbar_animate 0');  // turn off toolbar autohide animation
}

