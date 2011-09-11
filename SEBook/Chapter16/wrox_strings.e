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
 * Returns left portion of string.
 * @param string The input string.
 * @param len Number of characters to include.
 * @param pad Character to use to pad to length.
 *
 * @return _str
 */
_str wrox_leftstr(_str string, int len, _str pad=' ') {
  _str result = '';
  if (length(string) > len) {
    result = substr(string, 1, len);
  }
  else {
    result = string :+
             translate(indent_string(len - length(string)), pad, ' ');
  }
  return result;
}

/**
 * Returns right portion of string.
 * @param string The input string.
 * @param len Number of characters to include.
 * @param pad Character to use to pad to length.
 *
 * @return _str
 */
_str wrox_rightstr( _str string, int len, _str pad=' ') {
  _str result = '';
  if (length(string) > len) {
    result = substr(string, length(string) - len + 1, len);
  }
  else {
    result = translate(indent_string(len - length(string)), pad, ' ') :+
             string;
  }
  return result;
}


