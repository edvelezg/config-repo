// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-22
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

static int wrox_optional_hmtl_tags:[] = {
  "base"     => 1,
  "basefont" => 1,
  "bgsound"  => 1,
  "br"       => 1,
  "frame"    => 1,
  "hr"       => 1,
  "img"      => 1,
  "input"    => 1,
  "isindex"  => 1,
  "link"     => 1,
  "meta"     => 1,
  "nextid"   => 1,
  "param"    => 1,
  "plaintext"=> 1,
  "spacer"   => 1,
  "wbr"      => 1
};

/**
 * Inserts matching HTML/XML ending tag.
 */
_command void wrox_insert_html_ending_tag() name_info(','VSARG2_REQUIRES_MDI_EDITORCTL) {
  _str tagexp = '<(/?(\:c|[0-9]|-|_|:)+)([^>]*)>';
  int nesting = 0;
  int status = 0;
  int start_line = p_line;
  int start_col = p_col;
  push_bookmark();
  status = search(tagexp, "U<-"); // search backwards for HTML/XML tag
  if (!status && p_line == start_line && p_col == start_col) { // search didn't move us
    status = repeat_search(); // doesn't count, search again
  }
  _str nesting_stack[];
  _str tag;
  while (!status) {
    tag = get_text(match_length("1"), match_length("S1"));
    _str endchar = get_text(match_length("3"), match_length("S3"));
    if (wrox_leftstr(tag, 1) == "/") { // end tag
      nesting_stack[nesting++] = wrox_rightstr(tag, length(tag) - 1); // add it to nesting stack
    }
    else if (wrox_rightstr(endchar, 1) == "/") { // self-contained tag like <tag/>
      // ignore
    }
    else { // start tag
      if (wrox_optional_hmtl_tags:[lowcase(tag)] == 1) { // end-tag is optional
        if (nesting > 0 && tag == nesting_stack[nesting - 1]) { // matched start: pop it
          nesting--;
        }
      }
      else { // otherwise end-tag not optional
        if (nesting == 0) { // a start tag with zero nesting; we're done
          break;
        }
        else {
          if (tag == nesting_stack[nesting - 1]) { // matched nested end-tag
            nesting--;
          }
          else { // unmatched
            message("Found unmatched tag <" :+ tag :+ ">");
            return;
          }
        }
      }
    }
    status = repeat_search();
  } // end while
  if (status) {
    message("Couldn't find a tag.");
    return;
  }
  int tag_line = p_line;
  int tag_col = p_col;
  pop_bookmark();
  _str line;
  get_line(line);
  line = strip(line);
  if (p_line != tag_line) { // match is on different line from cursor:
    insert_line("");  // add a new line for end tag
    p_col = tag_col;
  }
  _insert_text("</" :+ tag :+ ">"); // insert the end tag
}

// key bindings for wrox_insert_html_ending_tag

defeventtab html_keys;
def   'A-/'= wrox_insert_html_ending_tag;

defeventtab xml_keys;
def   'A-/'= wrox_insert_html_ending_tag;

