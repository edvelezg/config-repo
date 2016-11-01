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
 * Test/demonstrate wrox_leftstr(), wrox_rightstr().
 *
 * @return int
 */
_command int wrox_try_left_right_str() {
  wrox_assert_equals("http",
                     wrox_leftstr("http://www.skepticalhumorist.co.nz", 4));
  wrox_assert_equals("000123",
                     wrox_rightstr("123", 6, "0"));
  return 0;
}

/**
 * Test/demonstrate length().
 *
 * @return int
 */
_command int wrox_try_length() name_info(',') {
  wrox_assert_equals(13, length("Hello, World."));
  return 0;
}

/**
 * Test/demonstrate string/numeric conversions.
 *
 * @return int
 */
_command int wrox_try_string_conversions() name_info(',') {
  _str answer_s = "42";
  _str pi_s = "3.14159";
  int answer_i = (int) answer_s;  // cast to convert from string to integer
  double pi_d = (double) pi_s;    // and to double
  wrox_assert_equals(42, answer_i);
  wrox_assert_equals(3.14159, pi_d);
  wrox_assert_equals(42, answer_s);  // casts are automatic for comparisons
  wrox_assert_equals(3.14159, pi_s);

  return 0;
}

/**
 * Test/demonstrate string quoting and escapes.
 *
 * @return int
 */
_command int wrox_try_string_escapes() name_info(',') {
  wrox_assert_equals("\"", '"'); // double quote in string
  wrox_assert_equals("'", ''''); // single quote in string
  wrox_assert_equals("\\", '\'); // backslash in string
  return 0;
}

/**
 * Test/demonstrate different ways to concatenate strings.
 *
 * @return int
 */
_command int wrox_try_concat() name_info(',') {
  wrox_assert_equals("Hello, World.", "Hello, ""World.");
  wrox_assert_equals("Hello, World.", "Hello, "'World.');
  _str a = "Hello,";
  _str b = " World.";
  wrox_assert_equals("Hello, World.", a :+ b);
  wrox_assert_equals("Hello, World.", a b);
  _str result = "";
  strappend(result, "Hello, ");
  strappend(result, "World."); // faster than result = result :+ ...
  wrox_assert_equals("Hello, World.", result);
  return 0;
}

/**
 * Test/demonstrate substr().
 *
 * @return int
 */
_command int wrox_try_substr() name_info(',') {
  _str a = "0123456789ABCDEF";
  wrox_assert_equals("0", substr(a, 1, 1));
  wrox_assert_equals("1", substr(a, 2, 1));
  return 0;
}

/**
 * Test/demonstrate strip().
 *
 * @return int
 */
_command int wrox_try_strip() name_info(',') {
  _str s = "   space string ";
  _str q = '"quoted string"';
  wrox_assert_equals("space string", strip(s));
  wrox_assert_equals("space string ", strip(s, "L"));      // leading
  wrox_assert_equals("   space string", strip(s, "T"));    // trailing
  wrox_assert_equals("quoted string", strip(q, "B", '"')); // both, strip quotes
  return 0;
}

/**
 * Test/demonstrate filename functions.
 *
 * @return int
 */
_command int wrox_try_filenames() name_info(',') {
  _str filename = 'C:\Documents and Settings\jhurst\trythis.c';
  wrox_assert_equals('C:\Documents and Settings\jhurst\trythis.c', filename);
  wrox_assert_equals('"C:\Documents and Settings\jhurst\trythis.c"',
                     maybe_quote_filename(filename));
  wrox_assert_equals("trythis.c", strip_filename(filename, "P"));
  wrox_assert_equals('\Documents and Settings\jhurst\trythis.c',
                     strip_filename(filename, "D"));
  wrox_assert_equals('C:\Documents and Settings\jhurst\trythis',
                     strip_filename(filename, "E"));
  wrox_assert_equals('C:\Documents and Settings\jhurst\',
                     strip_filename(filename, "N"));
  wrox_assert_equals("c", get_extension(filename));
  return 0;
}

/**
 * Test/demonstrate miscellaneous string functions.
 *
 * @return int
 */
_command int wrox_try_string_operations() name_info(',') {
  wrox_assert_equals(65, _asc("A"));
  wrox_assert_equals("A", _chr(65));
  wrox_assert_equals("TOM THUMB", upcase("tom thumb"));
  wrox_assert_equals("the giant", lowcase("THE GIANT"));
  _assert(strieq("ABC", "abc"));

  wrox_assert_equals("wrox-execute-current-command",
                     translate("wrox_execute_current_command", "-", "_"));
  wrox_assert_equals("www.skepticalhumorist.co.nz",
                     stranslate("http://www.skepticalhumorist.co.nz",
                                "", "(http|ftp)://", "U"));
  return 0;
}

/**
 * Test/demonstrate basic "parse with".
 *
 * @return int
 */
_command int wrox_try_parse_with() name_info(',') {
  _str s = "2007-05-19";
  _str yyyy, mm, dd;
  parse s with yyyy'-'mm'-'dd;
  wrox_assert_equals("2007", yyyy);
  wrox_assert_equals("05", mm);
  wrox_assert_equals("19", dd);
  return 0;
}

/**
 * Test/demonstrate parsing command line options
 * @param s
 *
 * @return int
 */
_command int wrox_try_parse_command(_str s="") name_info(',') {
  _str a, b;
  parse s with a b;
//   wrox_assert_equals("a", a);
//   wrox_assert_equals("b", b);
  messageNwait("a=["a"]");
  messageNwait("b=["b"]");
  return 0;
}

/**
 * Test/demonstrate "parse with" repeated for multiple items.
 *
 * @return int
 */
_command int wrox_try_parse_with_repeated() name_info(',') {
  _str s = "1,2,3";
  _str head, rest;
  int i = 0;
  parse s with head','rest;
  while (head != "") {
    wrox_assert_equals(++i, head);
    parse rest with head','rest;
  }
  wrox_assert_equals(3, i);
  return 0;
}

/**
 * Test/demonstrate "parse with" using expression in pattern.
 *
 * @return int
 */
_command int wrox_try_parse_with_expression() name_info(',') {
  _str date1 = "2007/5/19";
  _str yyyy, mm, dd, delim;
  parse date1 with yyyy +4 delim +1 mm (delim) dd;
  wrox_assert_equals(2007, yyyy);
  wrox_assert_equals(5, mm);
  wrox_assert_equals(19, dd);
  _str date2 = "2008-12-01";
  parse date2 with yyyy +4 delim +1 mm (delim) dd;
  wrox_assert_equals(2008, yyyy);
  wrox_assert_equals(12, mm);
  wrox_assert_equals(1, dd);

  _str url = "http://www.skepticalhumorist.co.nz/index.html";
  _str host;
  _str file;
  parse url with "(http|ftp)","U" "://" host "/" file;
  wrox_assert_equals("www.skepticalhumorist.co.nz", host);
  wrox_assert_equals("index.html", file);

  return 0;
}

/**
 * Test/demonstrate pos().
 *
 * @return int
 */
_command int wrox_try_pos() name_info(',') {
  wrox_assert_equals(6, pos("th", "The other ones"));
  wrox_assert_equals(1, pos("th", "The other ones", 1, "I")); // case-insensitive
  wrox_assert_equals(6, pos("th", "The other ones", 3, "I")); // with start pos
  wrox_assert_equals(6, lastpos("th", "The other ones", "", "I")); // from end

  _str date = "2007-05-20";
  wrox_assert_equals(1, pos('(\:d{4})([-/])(\:d{1,2})\2(\:d{1,2})', date, 1, "U"));
  wrox_assert_equals(2007, substr(date, pos("S1"), pos("1")));
  wrox_assert_equals(5, substr(date, pos("S3"), pos("3")));
  wrox_assert_equals(20, substr(date, pos("S4"), pos("4")));

  return 0;
}

