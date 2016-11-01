// $Id: wrox_try_typeless.e 1466 2007-08-28 10:49:25Z jhurst $
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

/**
 * Test/demonstrate Slick-C typeless variables.
 */
_command void wrox_try_typeless() name_info(',') {
  _str a[];
  a[0] = "one";
  a[1] = "two";
  typeless e = null;
  _str h:[];
  h:["one"] = 1;
  h:["two"] = 2;
  int i = 1;
  _str s = "Hello";
  wrox_assert_equals("ARRAY",   wrox_typeless_type(a));
  wrox_assert_equals("EMPTY",   wrox_typeless_type(e));
  wrox_assert_equals("HASHTAB", wrox_typeless_type(h));
  wrox_assert_equals("INT",     wrox_typeless_type(i));
  wrox_assert_equals("LSTR",    wrox_typeless_type(s));
}

/**
 * Return a string for the type of the variable.
 * @param v A variable.
 *
 * @return _str A string for the type of the variable.
 */
_str wrox_typeless_type(typeless v) {
  switch (v._varformat()) {
    case VF_ARRAY:   return "ARRAY";
    case VF_EMPTY:   return "EMPTY";
    case VF_FREE:    return "FREE";  // shouldn't happen!
    case VF_FUNPTR:  return "FUNPTR";
    case VF_HASHTAB: return "HASHTAB";
    case VF_INT:     return "INT";
    case VF_LSTR:    return "LSTR";
    case VF_PTR:     return "PTR";
    default: return "UNKNOWN";
  }
}
