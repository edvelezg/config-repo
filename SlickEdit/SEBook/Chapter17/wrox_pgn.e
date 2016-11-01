// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-06-15
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

#define MODE_NAME 'PGN'
#define EXTENSION 'pgn'

/**
 * Install Portable Game Notation support.
 * Slick-C batch macro.
 */
defload() {
  _str setup_info='MN=' :+ MODE_NAME :+
       ',TABS=+2,MA=1 74 1,KEYTAB=pgn-keys,WW=1,IWT=0,ST=0,';
  _str compile_info='';
  _str syntax_info='2 1 1 1 0 1 0';
  _str be_info='({)|(})';
  int kt_index=0;
  create_ext(kt_index,EXTENSION,'',MODE_NAME,setup_info,compile_info,
             syntax_info,be_info,'','A-Za-z0-9_$',MODE_NAME);
  // Add PGN lexer data to user.vlx.
  edit(maybe_quote_filename(get_env("VSLICKCONFIG") :+ "user.vlx"));
  int status = search("[PGN]");
  if (!status) {
    quit();
    return;         // quit if file already has [PGN] section
  }
  bottom_of_buffer();
  insert_line("");
  insert_line("[PGN]");
  insert_line("idchars=a-zA-Z 0-9_$");
  insert_line("case-sensitive=y");
  insert_line("styles=xhex dqbackslash dqmultiline sqmultiline idparenfunction");
  insert_line("keywords= Event Site Date Round White Black");
  insert_line("keywords= WhiteRating BlackRating Result GameId");
  insert_line("keywords= TimeControl ECO");
  insert_line("mlcomment={ }");
  file();
}

