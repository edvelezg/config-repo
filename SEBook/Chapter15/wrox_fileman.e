// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-11
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
 * Unlist all items in the fileman list except those having
 * given extensions.
 */
_command void wrox_fileman_retain_exts(_str exts="") name_info(','VSARG2_REQUIRES_FILEMAN_MODE) {
  exts = prompt(exts, "Extensions to retain");
  deselect_all();
  select_ext(exts);
  select_reverse();
  unlist_select();
}
