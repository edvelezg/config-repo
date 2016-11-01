// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-04-14
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
 * Returns the path of the current project.
 * This can be useful in an alias with %\m wrox_project_dir%.
 *
 * @return _str The path of the current project.
 */
_str wrox_project_dir() {
  return maybe_quote_filename(strip_filename(_project_name, "N"));
}

/**
 * Inserts the path of the current project.
 */
_command void wrox_insert_project_dir() name_info(',') {
  _insert_text(wrox_project_dir());
}

/**
 * Returns the path of the current buffer.
 * This can be useful in an alias with %\m wrox_buffer_dir%.
 *
 * @return _str The path of the current buffer.
 */
_str wrox_buffer_dir() {
  // switch windows to _mdi child to get buffer name, so that this macro works in other windows
  int new_wid = _mdi.p_child;
  int orig_wid = p_window_id;
  p_window_id = new_wid;
  _str buf_name = p_buf_name;
  p_window_id = orig_wid;
  return maybe_quote_filename(strip_filename(buf_name, "N"));
}

/**
 * Inserts the path of the current buffer.
 */
_command void wrox_insert_buffer_dir() name_info(',') {
  _insert_text(wrox_buffer_dir());
}

