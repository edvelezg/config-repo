// $Id: wrox_emulation.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-01-21
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

defeventtab default_keys;

// Alt-keys are not defined by CUA emulation -- these are copied mostly from Slick emulation.
//def 'A-a'=adjust_block_selection;
def 'A-b'=select_block;
//def 'A-c'=copy_to_cursor;
//def 'A-d'=cut;      // well, this one is added to the slick emulation.
//def 'A-e'=end_select;
def 'A-f'=fill_selection;
def 'A-j'=join_line;
//def 'A-k'=cut;
//def 'A-l'=select_line;
//def 'A-m'=move_to_cursor;
def 'A-n'=keyin_buf_name;
//def 'A-o'=overlay_block_selection;
def 'A-p'=reflow_paragraph;
//def 'A-r'=root_keydef;
//def 'A-s'=split_line;
////def 'A-t'=find_matching_paren;   // Alt-t used for tool window activation below
//def 'A-u'=deselect;
//def 'A-v'=copy_to_clipboard;
//def 'A-w'=cut_word;
//def 'A-x'=safe_exit;
//def 'A-y'=begin_select;
//def 'A-z'=select_char;
def "A-'"=duplicate_line;
def 'C-S-/'=toggle_comment;

// CUA has
// def 'C-/'= push_ref;
// def 'C-.'= push_tag;
// def 'C-,'= pop_bookmark;
// we add
def 'C-;'=push_bookmark;

// Some keys for what-is, where-is
//def 'A-q'=what_is;
//def 'A-S-q'=where_is;

// these commands could be changed from CUA to slick:
// but ... doing so loses some nice line-splitting features.
// def 'DEL'=delete_char; // CUA: linewrap_delete_char
// def 'ENTER'=nosplit_insert_line; // CUA: split_insert_line

// this key is not used by CUA emulation, nor is quick_search bound.
// We'll bind the same as VStudio.
def 'C-F3'=quick_search;
def 'C-S-F3'=quick_reverse_search;

// These keys are not defined by CUA emulation -- these are copied exactly from slick emulation.
def 'S-F1'=scroll_up;
def 'S-F2'=scroll_down;
def 'S-F3'=scroll_left;
def 'S-F4'=scroll_right;

// CUA tabs always indent -- Slick tabs indent conditionally
def 'S-TAB'=cbacktab; // CUA: move_text_backtab
def 'TAB'=ctab; // CUA: move_text_tab

// Reverse bookmark keys so it's easier to goto a bookmark than define it
// (since presumably we goto bookmarks more often than we define them)
def 'C-S-0'-'C-S-9'= alt_bookmark;  // reversed from CUA
def 'C-0'-'C-9'= alt_gtbookmark;    // reversed from CUA

// Keys for repositioning window based on cursor
def 'A-HOME'=center_line;
def 'A-PGUP'=line_to_top;
def 'A-PGDN'=line_to_bottom;
def 'A-S-PGDN'=page_right;
def 'A-S-PGUP'=page_left;
def 'A-S-J' 'l'=join_lines;

// Shortcut keys for invoking Tool Windows: Alt-T is for "Tool Window"
def  'A-T' 'k'= activate_bookmarks;
def  'A-T' 'b'= activate_build;
def  'A-T' 'a'= activate_call_stack;
def  'A-T' 'c'= activate_tbclass;
def  'A-T' 'd'= activate_defs;
def  'A-T' 'e'= activate_annotations;
def  'A-T' 'h'= activate_deltasave;
def  'A-T' 'l'= activate_files_files;
def  'A-T' 'p'= activate_files_project;
def  'A-T' 'w'= activate_files_workspace;
def  'A-T' 'f'= activate_find_symbol;
def  'A-T' 't'= activate_ftp;
def  'A-T' 'o'= activate_open;
def  'A-T' 'u'= activate_output;
def  'A-T' 'v'= activate_preview;
def  'A-T' 'j'= activate_projects;
def  'A-T' 'r'= activate_references;
def  'A-T' 'x'= activate_regex_evaluator;
def  'A-T' 's'= activate_search;
def  'A-T' 'y'= activate_symbols_browser;
def  'A-=' 's'= align_chars;

def  'C-T' 'c'= string_copy;
def  'C-T' 'v'= string_paste;
def  'C-T' 'l'= transpose_lines;
def  'C-T' 'w'= transpose_words;
def  'C-T' 'a'= transpose_chars;

def  'C-W' = surround_with;

defeventtab ruby_keys;
def '#'= ruby_hash;

//def 'F5'= config; // CUA: project_debug

// Routine executed when macro file is compiled ("loaded" in SlickEdit terminology)
defload() {
  // Allow def Alt keys for commands
  // The following code is copied from SlickEdit's config.e.
  // It is called there when the user updates the Alt menu hotkeys option.
  // Thanks to Rodney Bloom of SlickEdit for this tip.
  _str macro = 'altsetup';
  _str filename = get_env('VSROOT')'macros' :+ FILESEP :+ (macro :+ _macro_ext 'x');
  if (!file_exists(filename)) {
    filename = get_env('VSROOT') 'macros' :+ FILESEP :+ (macro :+ _macro_ext);
  }
  if (!file_exists(filename)) {
    _message_box(nls("File '%s' not found", macro :+ _macro_ext 'x'));
  }
  else {
    _no_mdi_bind_all = 1;
    macro = maybe_quote_filename(macro);
    int status = shell(macro ' N');
    _no_mdi_bind_all = 0;
    if (status) {
      _message_box(nls("Unable to set alt menu hotkeys.\n\nError probably caused by missing macro compiler or incorrect macro compiler version."));
    }
  }
}


