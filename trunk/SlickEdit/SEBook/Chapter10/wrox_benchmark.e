// $Id: wrox_benchmark.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-02-23
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


// for testing
//_command void wrox_wait() name_info(','VSARG2_EDITORCTL) {
//  delay(200);
//}

/**
 * Runs a command, and reports how many seconds it took.
 * @param command Command to run.
 */
_command void wrox_benchmark(_str command = null) name_info(COMMAND_ARG','VSARG2_EDITORCTL) {
  if (command == null) {
    message("I need a command.");
    return;
  }
  long start = (long) _time('G');
  execute(command);
  long finish = (long) _time('G');
  long elapsed = finish - start;
  message("Command [" :+ command :+ "] took " :+ elapsed :+ " seconds.");
}

