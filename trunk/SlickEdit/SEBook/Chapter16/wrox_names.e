// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-20
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

typedef int INTARRAY[];

/**
 * Return an array of indexes of items in the Slick-C name table
 * matching the given name prefix and flags.
 * @param prefix The name prefix to match.
 * @param name_type_flags Flags filter the search.
 *
 * @return int[] Array of indexes into name table.
 */
INTARRAY wrox_find_matching_name_indexes(_str prefix, int name_type_flags) {
  int result[];
  int index = name_match(prefix, 1, name_type_flags);
  while (index) {
    result[result._length()] = index;
    index = name_match(prefix, 0, name_type_flags);
  }
  return result;
}

