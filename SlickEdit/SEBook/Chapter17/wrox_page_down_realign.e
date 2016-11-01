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
 * Page-down wrapper command.
 * If we are not at the bottom of the buffer, invoke the
 * ordinary <code>page_down</code> command.
 * Otherwise, invoke <code>line_to_bottom</code> to align the
 * bottom line of the buffer with the bottom of the window.
 */
_command void wrox_page_down_realign() name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY) {
  if (p_line != p_Noflines) {
    page_down();
  }
  else {
    line_to_bottom();
  }
}

defeventtab default_keys;
def 'PGDN'=wrox_page_down_realign;


