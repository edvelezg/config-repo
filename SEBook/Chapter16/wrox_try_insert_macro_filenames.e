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
 * Test/demonstrate insert_file_list().
 */
_command void wrox_insert_macro_files() name_info(',') {
  _str macro_filespec = maybe_quote_filename(get_env("VSLICKMACROS") :+ '*.e');
  insert_file_list(' +P -V -D ' macro_filespec);
}

/**
 * Test/demonstrate insert_file_list().
 */
_command void wrox_insert_current_dir_files() name_info(',') {
  insert_file_list(' -T -H *');
}


