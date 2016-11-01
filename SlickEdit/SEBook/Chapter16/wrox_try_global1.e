// $Id: wrox_try_global1.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-05-20
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
#include "wrox_try_global.sh"

static _str sWroxStaticString = "Static String";

/**
 * Test/demonstrate globals vs statics.
 *
 * @return int
 */
_command int wrox_try_global1() name_info(',') {
  wrox_assert_equals("Global String", gWroxGlobalString); // global var is across all modules.
  wrox_assert_equals("Static String", sWroxStaticString); // static var is for this module only.
  return 0;
}

/**
 * Test/demonstrate updating static.
 *
 * @return int
 */
_command int wrox_try_update_static() name_info(',') {
  sWroxStaticString = "Other value";
  wrox_assert_equals("Other value", sWroxStaticString);
  return 0;
}


