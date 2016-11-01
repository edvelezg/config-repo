// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-18
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
 * Returns an array containing the keys for the given hash
 * table.
 * @param h The hash table.
 * @param sorted Whether to sort the result array, default is
 *               true.
 *
 * @return typeless
 */
typeless wrox_hash_keys(typeless h:[], boolean sorted = true) {
  typeless k;
  typeless result[];
  for (k._makeempty();;) {
    h._nextel(k);
    if (k._isempty()) {
      break;
    }
    result[result._length()] = k;
  }
  if (sorted) {
    result._sort();
  }
  return result;
}

