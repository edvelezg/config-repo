// $Id: wrox_try_properties.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-05-18
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
 * Test/demonstrate updating SlickEdit properties.
 * @param command line and column.
 */
_command void wrox_goto_line_col(_str command = "") name_info(',') {
  _str line, col;
  parse command with line col;
  line = prompt(line, "Line");
  col = prompt(col, "Column");
  p_line = (int) line;
  p_col = (int) col;
}

