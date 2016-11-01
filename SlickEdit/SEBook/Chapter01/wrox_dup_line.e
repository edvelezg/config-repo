// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-27
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
 * Duplicate the current line.
 * SlickEdit now includes a command "duplicate-line".
 * I'm not sure when it got added, but I've been using this one
 * for years, and like it a little better than duplicate-line.
 * With this version, the cursor stays on the original line.
 * With SlickEdit's, the cursor ends up on the new line.
 */
_command void wrox_dup_line() name_info(','VSARG2_REQUIRES_MDI_EDITORCTL) {
  push_bookmark();
  _str the_line;
  get_line(the_line);
  insert_line(the_line);
  pop_bookmark();
}
