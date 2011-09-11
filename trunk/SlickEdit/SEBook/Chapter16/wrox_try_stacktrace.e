// $Id: wrox_try_stacktrace.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-05-15
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
 * Demonstrate stack trace.
 */
_command void wrox_makestacktrace() name_info(',') {
  wrox_stacktrace1();
}

void wrox_stacktrace1() {
  wrox_stacktrace2();
}

void wrox_stacktrace2() {
  _str a = arg(1) + 1;
}


