// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-02-21
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

#pragma option(strict,on)
#include "slick.sh"

/**
 * Returns the current date in ISO format: YYYY-MM-DD.
 *
 * @return current date as YYYY-MM-DD.
 */
_str wrox_iso_date() {
  _str mm;
  _str dd;
  _str yyyy;
  parse _date() with mm'/'dd'/'yyyy;
  if (yyyy > 90 && yyyy < 100) {
    yyyy = "19" :+ yyyy;
  }
  if (yyyy >= 0 && yyyy <= 90) {
    yyyy = "20" :+ yyyy;
  }
  return strip(yyyy) :+ '-' :+
         wrox_rightstr(strip(mm), 2, '0') :+ '-' :+
         wrox_rightstr(strip(dd), 2, '0');
}

/**
 * Inserts the current date in ISO format, followed by a space.
 * Useful for %\m expansion in aliases, also nice bound to a
 * key.
 */
_command void wrox_insert_iso_date() name_info(','VSARG2_REQUIRES_MDI_EDITORCTL) {
  _insert_text(wrox_iso_date() :+ " ");
}

/**
 * Returns the current year as 'YYYY'
 *
 * @return current year as 'YYYY'
 */
_str wrox_year() {
  _str mm;
  _str dd;
  _str yyyy;
  parse _date() with mm'/'dd'/'yyyy;
  return yyyy;
}

/**
 * Inserts the current year as YYYY.
 * Useful for %\m expansion in aliases.
 */
_command void wrox_insert_year() name_info(','VSARG2_REQUIRES_MDI_EDITORCTL) {
  _insert_text(wrox_year());
}

