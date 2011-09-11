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
 * Test/demonstrate prompt() with FILE_ARG argument.
 * @param filename Argument.
 */
_command void wrox_try_prompt_filename(_str filename="") name_info(FILE_ARG',') {
  filename = prompt(filename, "Filename");
  message("Filename=["filename"]");
}

/**
 * Test/demonstrate prompt() with COMMAND_ARG argument.
 * @param command Argument.
 */
_command void wrox_try_prompt_command(_str command="") name_info(COMMAND_ARG',') {
  command = prompt(command, "Command");
  message("Command=["command"]");
}

