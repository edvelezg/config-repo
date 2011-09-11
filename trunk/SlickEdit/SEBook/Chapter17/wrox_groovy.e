// $Id$
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

#define MODE_NAME 'Groovy'
#define EXTENSION 'groovy'

/**
 * Attempt to find the previous Groovy "proc".
 * The procedure searches for an identifier indented exactly two
 * characters from the start of the line.  This is the most
 * effective search I've found for my own Groovy source files.
 */
_command void wrox_groovy_prev_proc() name_info(','VSARG2_REQUIRES_EDITORCTL) {
  int cur_line = p_line;
  int cur_col = p_col;
  int status = search('^  \:w', "-<UH@CO");
  if (!status) {
    if (p_line == cur_line && p_col == cur_col - 2) {
      p_line--;
      status = search('^  \:w', "-<UH@CO");
    }
  }
  if (!status) {
    cursor_right(2);
  }
}

/**
 * Attempt to find the next Groovy "proc".
 * The procedure searches for an identifier indented exactly two
 * characters from the start of the line.  This is the most
 * effective search I've found for my own Groovy source files.
 */
_command void wrox_groovy_next_proc() name_info(','VSARG2_REQUIRES_EDITORCTL) {
  int status = search('^  \:w', "+<UH@CO");
  if (!status) {
    cursor_right(2);
  }
}

defeventtab groovy_keys;
def 'C-Up'=wrox_groovy_prev_proc;
def 'C-Down'=wrox_groovy_next_proc;

/**
 * Install Groovy support.
 * Slick-C batch macro.
 */
defload() {
  _str setup_info='MN=' :+ MODE_NAME :+
       ',TABS=+2,MA=1 74 1,KEYTAB=groovy-keys,WW=1,IWT=0,ST=0,';
  _str compile_info='';
  _str syntax_info='2 1 1 1 0 1 0';
  _str be_info='({)|(})';
  int kt_index=0;
  create_ext(kt_index,EXTENSION,'',MODE_NAME,setup_info,compile_info,
             syntax_info,be_info,'','A-Za-z0-9_$',MODE_NAME);
  // Add Groovy lexer data to user.vlx.
  edit(maybe_quote_filename(get_env("VSLICKCONFIG") :+ "user.vlx"));
  int status = search("[Groovy]");
  if (!status) {
    quit();
    return;         // quit if file already has [Groovy] section
  }
  bottom_of_buffer();
  insert_line("");
  insert_line("[Groovy]");
  insert_line("idchars=a-zA-Z 0-9_$");
  insert_line("case-sensitive=y");
  insert_line("styles=xhex dqbackslash dqmultiline sqmultiline idparenfunction");
  insert_line("keywords= as assert boolean break case catch char class continue");
  insert_line("keywords= def default do double else extends false finally float");
  insert_line("keywords= for if implements import in instanceof int interface");
  insert_line("keywords= long new null package private property return short");
  insert_line("keywords= static switch this throw throws true try void while");
  insert_line("linecomment=//");
  file();
}

