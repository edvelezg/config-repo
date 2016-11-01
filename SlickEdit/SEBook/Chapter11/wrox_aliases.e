// $Id: wrox_aliases.e 1205 2007-05-31 20:42:24Z jhurst $
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
 * Expands an alias, returns nothing.
 * This version is better in your own alias definitions, because
 * the standard expand_alias returns a number (usually 0), which
 * is inserted into your expansion.
 * You might want to rename this macro to something shorter, to
 * make it more convenient to use in alias definitions.
 */
_command void wrox_expand_alias_inline() name_info(',') {
  expand_alias();
}

