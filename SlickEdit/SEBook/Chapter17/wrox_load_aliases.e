// $Id: wrox_load_aliases.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-05-25
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
 * Define aliases programmatically.
 * Slick-C batch macro.
 */
defmain() {
  int temp_window_id;
  int orig_window_id = _create_temp_view(temp_window_id); // fundamental mode
  alias('hosts "C:\Windows\system32\drivers\etc\hosts');
  alias('cpr Copyright %\m wrox_year% John Hurst');
  alias('local "C:\cygwin\usr\local\');
  alias('pdir %\m wrox_project_dir%');
  alias('bdir %\m wrox_buffer_dir%');
  select_mode("Slick-C");
  alias('_command _command void %\c(%\c) name_info(%\c'',''%\c) {%\m nosplit_insert_line%}');
/*
JH_TODO: insert into e.als? Currently I don't have a better way to do aliases with params.
forarr(ARRAY "Array" arr
       VAR "Variable" var
       INDEX "Index" i
       )
 for (%(INDEX) = 0; %(INDEX) < %(ARRAY)._length(); %(INDEX)++) {
   _str %(VAR) = %(ARRAY)[%(INDEX)];
 }
*/
  _delete_temp_view(temp_window_id);
  if (orig_window_id) {
    activate_window(orig_window_id);
  }
  return 0;
}


