// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-07-14

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
 * Displays a set of messages in a message box, each on its own
 * line.
 * @param message One or more messages.
 */
void wrox_multimessage(_str m, ...) {
  _str messages = m;
  int i;
  for (i = 2; i < arg(); i++) {
    messages = messages "\n" arg(i);
  }
  _message_box(messages);
}

