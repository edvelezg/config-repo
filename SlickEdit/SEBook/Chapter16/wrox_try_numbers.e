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
 * Test/demonstrate Slick-C integers.
 *
 * @return int
 */
_command int wrox_try_integer() name_info(',') {
  int i1 = 0x7fffffff; // 2^31 - 1
  int i2 = i1 + 2;     // - 2^31 + 1)
  int i3 = i1 + i2 - 1;    // - 1
  wrox_assert_equals("0x7FFFFFFF", dec2hex(i1));
  wrox_assert_equals(2147483647, i1);
  wrox_assert_equals("-0x7FFFFFFF", dec2hex(i2));
  wrox_assert_equals(-2147483647, i2);
  wrox_assert_equals(-1, i3);
  return 0;
}

/**
 * Test/demonstrate Slick-C longs.
 *
 * @return int
 */
_command int wrox_try_long() name_info(',') {
  long n1 = 99999999;
  n1 = n1 * 100000000 + 99999999;
  n1 = n1 * 100000000 + 99999999;
  n1 = n1 * 100000000 + 99999999; // 32 '9's
  long n2 = n1 + 1;  // 1 plus 32 0's'
  long n3 = n2;
  n3 = n3 + 1;
  n3 = n3 + 1;
  n3 = n3 + 1;
  n3 = n3 + 1;
  n3 = n3 + 1;
  n3 = n3 + 1;
  n3 = n3 + 1;
  n3 = n3 + 1;
  n3 = n3 + 1;
  n3 = n3 + 1;  // 1 plus 30 '0's plus "10"? Nope, lost precision.
  wrox_assert_equals(n3, n2);
  wrox_assert_equals("0x4EE2D6D415B85ACEF80FFFFFFFF", dec2hex(n1));
  wrox_assert_equals(99999999999999999999999999999999, n1);
  wrox_assert_equals("", dec2hex(n2));
  wrox_assert_equals(1.0000000000000000000000000000000E+32, n2);
  wrox_assert_equals("", dec2hex(n3));
  wrox_assert_equals(1.0000000000000000000000000000000E+32, n3);
  return 0;
}

/**
 * Test/demonstrate Slick-C doubles.
 *
 * @return int
 */
_command int wrox_try_double() name_info(',') {
  double d1 = 9.9999999999999999999999999999999e999999999;
  double d2 = 0.1e-999999997;
  wrox_assert_equals(9.9999999999999999999999999999999E+999999999, d1/1.0);
  wrox_assert_equals(1.1E-999999998, d2*1.1);
  return 0;
}

