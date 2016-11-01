// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-23
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
 * Test/demonstrate Slick-C hash tables.
 *
 * @return int
 */
_command int wrox_try_hash() name_info(',') {
  _str h:[];
  h:["first"] = "one";
  h:["second"] = "two";
  h:["third"] = "three";

  wrox_assert_equals("one", h:["first"]);
  wrox_assert_equals("two", h:["second"]);
  wrox_assert_equals("three", h:["third"]);

  typeless k;
  _str a[];
  for (k._makeempty();;) {
    h._nextel(k);
    if (k._isempty()) {
      break;
    }
    a[a._length()] = k :+ ":" :+ h:[k];
  }

  a._sort();
  wrox_assert_equals("first:one", a[0]);
  wrox_assert_equals("second:two", a[1]);
  wrox_assert_equals("third:three", a[2]);

  _str b[] = wrox_hash_keys(h);
  wrox_assert_equals("first", b[0]);
  wrox_assert_equals("second", b[1]);
  wrox_assert_equals("third", b[2]);

  return 0;
}


