// $Id: wrox_try_control_structures.e 1466 2007-08-28 10:49:25Z jhurst $
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

#define STRICT true

#if STRICT
#pragma option(strict, on)
#endif
#include "slick.sh"

/**
 * Test/demonstrate Slick-C block scopes.
 *
 * @return int
 */
_command int wrox_try_block() name_info(',') {
#if !STRICT      // this code doesn't compile in strict mode
  int x = 1;
  {
    int x;
    x = 3;
  }
  wrox_assert_equals(1, x);
#endif
  return 0;
}

/**
 * Test/demonstrate Slick-C if() statement.
 *
 * @return int
 */
_command int wrox_try_if_statement() name_info(',') {
  int i = random(0, 10);
  if (i < 5) {
    _assert(i < 5);
  }
  else {
    _assert(i >= 5);
  }
  return 0;
}

/**
 * Test/demonstrate Slick-C for() statement.
 *
 * @return int
 */
_command int wrox_try_for_statement() name_info(',') {
  int sum = 0;
  int i;
  for (i = 0; i < 10; i++) {
    sum += i;
  }
  wrox_assert_equals(45, sum);

  for (;;) { // loop "forever"
    if (random(0, 10) < 1) {
      break;
    }
  }

  return 0;
}

/**
 * Test/demonstrate Slick-C while() statement.
 *
 * @return int
 */
_command int wrox_try_while_statement() name_info(',') {
  _str head, rest = "1,2,3";
  int i = 0;
  parse rest with head','rest;
  while (head != "") {
    wrox_assert_equals(++i, head);
    parse rest with head','rest;
  }
  wrox_assert_equals(3, i);
  return 0;
}

/**
 * Test/demonstrate Slick-C do() statement.
 *
 * @return int
 */
_command int wrox_try_do_statement() name_info(',') {
  _str head, rest = "1,2,3";
  int i = 0;
  do {
    parse rest with head','rest;
    if (head != "") {
      wrox_assert_equals(++i, head);
    }
  } while (head != "");
  wrox_assert_equals(3, i);
  return 0;
}

/**
 * Test/demonstrate Slick-C switch() statement.
 *
 * @return int
 */
_command int wrox_try_switch_statement() name_info(',') {
  _str month = "May";
  int mm;
  switch (upcase(month)) {
    case "JANUARY": mm = 1; break;
    case "FEBRUARY": mm = 2; break;
    case "MARCH": mm = 3; break;
    case "APRIL": mm = 4; break;
    case "MAY": mm = 5; break;
    case "JUNE": mm = 6; break;
    case "JULY": mm = 7; break;
    case "AUGUST": mm = 8; break;
    case "SEPTEMBER": mm = 9; break;
    case "OCTOBER": mm = 10; break;
    case "NOVEMBER": mm = 11; break;
    case "DECEMBER": mm = 12; break;
    default: message("Unknown month: "month); _StackDump();
  }
  wrox_assert_equals(5, mm);
  return 0;
}

