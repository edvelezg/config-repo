// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-22
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
 * Counts and removes duplicates.
 * The counts of each line are appended to the ends of unique
 * lines left in the buffer.
 * The counts are right-justified at the ends of the lines for a
 * tidy appearance.
 */
_command void wrox_count_duplicates(_str ignore_case = "") name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_AB_SELECTION) {
  if (_select_type() :!= "LINE") {
    message( "Command needs a line mark" );
    return;
  }
  ignore_case = upcase(ignore_case) == "I";
  // initialize variables
  int entry = 0;
  _str key[];
  int data[];
  key[entry] = "";
  data[entry] = 0;
  int max_keylen = 0;
  int max_datalen = 0;

  // go through marked lines
  filter_init();
  for (;;) {
     _str line;
    int status = filter_get_string(line);
    if (status) {
      break;
    }

    boolean matched = ignore_case ?
      strieq(key[entry], line) :
      key[entry] :== line;

    if (matched) {
      // duplicate: increment count
      data[entry]++;
      if (length(data[entry]) > max_datalen) {
        max_datalen++;
      }
    }
    else {
      // new entry: add to table, start count at 1
      if (data[entry] > 0) {
        entry++;
      }
      key[entry] = line;
      if (length(line) > max_keylen) {
        max_keylen = length(line);
      }
      data[entry] = 1;
    }
  }
  filter_restore_pos();
  // delete the selection
  delete_selection();
  cursor_up();
  // insert the aggregate (formatted neatly)
  int i;
  for (i = 0; i < key._length(); i++) {
    insert_line(wrox_leftstr(key[i], max_keylen) :+ " " :+ wrox_rightstr(data[i], max_datalen));
  }
}

