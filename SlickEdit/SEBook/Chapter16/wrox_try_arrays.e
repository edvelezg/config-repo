// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-17
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
 * Test/demonstrate Slick-C arrays.
 *
 * @return int
 */
_command int wrox_try_array() name_info(',') {
  _str a[];
  a[a._length()] = "one";
  a[a._length()] = "two";
  a[a._length()] = "three";
  a[a._length()] = "four";
  wrox_assert_equals(4, a._length());
  wrox_assert_equals("one", a[0]);
  wrox_assert_equals("two", a[1]);
  wrox_assert_equals("three", a[2]);
  wrox_assert_equals("four", a[3]);

  a._sort();
  wrox_assert_equals("four", a[0]);
  wrox_assert_equals("one", a[1]);
  wrox_assert_equals("three", a[2]);
  wrox_assert_equals("two", a[3]);
  return 0;
}

/**
 * Test/demonstrate Slick-C join() function.
 *
 * @return int
 */
_command int wrox_try_join() name_info(',') {
  _str a[];
  a[a._length()] = "one";
  a[a._length()] = "two";
  a[a._length()] = "three";
  a[a._length()] = "four";
  wrox_assert_equals("one,two,three,four", join(a, ','));
  return 0;
}

/**
 * Test/demonstrate Slick-C split() function.
 *
 * @return int
 */
_command int wrox_try_split() name_info(',') {
  _str b[];
  split("five,six,seven,eight", ",", b);
  wrox_assert_equals("five", b[0]);
  wrox_assert_equals("six", b[1]);
  wrox_assert_equals("seven", b[2]);
  wrox_assert_equals("eight", b[3]);
  return 0;
}


// JH_TODO: mention cannot initialize arrays in function

