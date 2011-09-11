// $Id$
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
 * Assert the values are equal, fail with error message if not.
 * @param expected Expected value.
 * @param actual Actual value.
 * @param msg Error message for failure.
 */
void wrox_assert_equals_message(typeless expected, typeless actual, _str msg) {
  if (expected._varformat() == VF_LSTR && actual._varformat() == VF_LSTR) {
    _assert(expected :== actual, msg); // exact match for strings
  }
  else {
    _assert(expected == actual, msg);
  }
}

/**
 * Assert the values are equal.
 * @param expected Expected value.
 * @param actual Actual value.
 */
void wrox_assert_equals(typeless expected, typeless actual) {
  wrox_assert_equals_message(expected, actual, "expected=["expected"], actual=["actual"]");
}

/**
 * Assert the condition is false.
 * @param condition Condition to test.
 */
void wrox_assert_false(boolean condition, _str msg = null) {
  _assert(!condition, msg);
}


/**
 * Test assertions.
 *
 * @return int
 */
_command int wrox_test_assert() name_info(',') {
  int i1 = 0x80000000;
  int i2 = - i1;
  _assert(i1 < 0);
  _assert(i2 < 0); // anomaly of signed 32 bit integers!
  return 0;
}


