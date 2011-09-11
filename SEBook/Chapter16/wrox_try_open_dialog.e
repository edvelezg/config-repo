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
 * Test/demonstrate _OpenDialog().
 */
_command void wrox_try_open_dialog() name_info(',') {
  _str files = _OpenDialog(
    "-modal _open_form",      // form and mode
    "Choose files to list",   // title
    "*.e;*.sh",               // initial exts
    "All Files (*.*),C/C++ Files (*.c;*.cpp;*.h),Slick-C Files (*.e;*.sh)",
    OFN_ALLOWMULTISELECT|OFN_FILEMUSTEXIST,  // flags
    "",                                      // default ext
    "",                                      // initial filename
    ""                                       // initial directory
  );
  while (files != "") {
    _str file;
    parse files with file files;
    insert_line(file);
  }
}

