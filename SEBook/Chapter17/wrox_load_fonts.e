// $Id: wrox_load_fonts.e 1466 2007-08-28 10:49:25Z jhurst $
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
 * Sets Bitstream Vera Sans Mono for several UI elements.
 * Slick-C batch macro.
 */
defmain() {
  set_var('def_sellist_font Bitstream Vera Sans Mono,10,0,1,');
  _default_font(CFG_DIFF_EDITOR_WINDOW,      'Bitstream Vera Sans Mono,10,0,1,');
  _default_font(CFG_FILE_MANAGER_WINDOW,     'Bitstream Vera Sans Mono,10,0,1,');
  _default_font(CFG_HEX_SOURCE_WINDOW,       'Bitstream Vera Sans Mono,10,0,1,');
  _default_font(CFG_SBCS_DBCS_SOURCE_WINDOW, 'Bitstream Vera Sans Mono,10,0,1,');
  _default_font(CFG_UNICODE_SOURCE_WINDOW,   'Bitstream Vera Sans Mono,10,0,1,');
  setall_wfonts('Bitstream Vera Sans Mono','10','0','1', CFG_DIFF_EDITOR_WINDOW);
  setall_wfonts('Bitstream Vera Sans Mono','10','0','1', CFG_FILE_MANAGER_WINDOW);
  setall_wfonts('Bitstream Vera Sans Mono','10','0','1', CFG_HEX_SOURCE_WINDOW);
  setall_wfonts('Bitstream Vera Sans Mono','10','0','1', CFG_SBCS_DBCS_SOURCE_WINDOW);
  setall_wfonts('Bitstream Vera Sans Mono','10','0','1', CFG_UNICODE_SOURCE_WINDOW);
}

