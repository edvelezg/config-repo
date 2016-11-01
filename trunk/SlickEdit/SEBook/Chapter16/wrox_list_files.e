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
 * Returns an array of file names obtained from running
 * insert_file_list() with the given command argument.
 */
STRARRAY wrox_list_files(_str command) {
  int filelist_view_id;
  int orig_view_id = _create_temp_view(filelist_view_id);
  _str result[];
  insert_file_list("-V "command);
  top();
  up();
  while (!down()) {
    _str filename;
    get_line(filename);
    filename = strip(filename);
    if (filename == "") {
      break;
    }
    result[result._length()] = maybe_quote_filename(filename);
  }
  _delete_temp_view(filelist_view_id);
  activate_window(orig_view_id);
  return result;
}


