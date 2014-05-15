////////////////////////////////////////////////////////////////////////////////////
// $Revision: 50589 $
////////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 SlickEdit Inc.
// You may modify, copy, and distribute the Slick-C Code (modified or unmodified)
// only if all of the following conditions are met:
//   (1) You do not include the Slick-C Code in any product or application
//       designed to run independently of SlickEdit software programs;
//   (2) You do not use the SlickEdit name, logos or other SlickEdit
//       trademarks to market Your application;
//   (3) You provide a copy of this license with the Slick-C Code; and
//   (4) You agree to indemnify, hold harmless and defend SlickEdit from and
//       against any loss, damage, claims or lawsuits, including attorney's fees,
//       that arise or result from the use or distribution of Your application.
////////////////////////////////////////////////////////////////////////////////////
#pragma option(pedantic,on)
#region Imports
#include "slick.sh"
#include "tagsdb.sh"
#include "color.sh"
#require "se/lang/api/LanguageSettings.e"
#import "se/tags/TaggingGuard.e"
#import "adaptiveformatting.e"
#import "alias.e"
#import "autobracket.e"
#import "autocomplete.e"
#import "beautifier.e"
#import "box.e"
#import "caddmem.e"
#import "clipbd.e"
#import "codehelp.e"
#import "codehelputil.e"
#import "commentformat.e"
#import "context.e"
#import "csymbols.e"
#import "cutil.e"
#import "hotspots.e"
#import "listproc.e"
#import "main.e"
#import "markfilt.e"
#import "notifications.e"
#import "pmatch.e"
#import "objc.e"
#import "seek.e"
#import "setupext.e"
#import "slickc.e"
#import "smartp.e"
#import "stdcmds.e"
#import "stdprocs.e"
#import "surround.e"
#import "tags.e"
#import "util.e"
#import "xmldoc.e"
#endregion

using se.lang.api.LanguageSettings;

/*
  Don't modify this code unless defining extension specific
  aliases does not suite your needs.   For example, if you
  want your brace style to be:

       if () {
          }

  Use the Extension Options dialog box ("Other", "Configuration...",
  "File Extension Setup...") and press the the "Alias" button to
  display the Alias Editor dialog box.  Press the New button, type
  "if" for the name of the alias and press Enter.  Enter the
  following text into the upper right editor control:

       if (%\c) {
       %\i}

  The  %\c indicates where the cursor will be placed after the
  "if" alias expanded.  The %\i specifies to indent by the
  Extension Specific "Syntax Indent" amount define in the
  Extension Options dialog box.  Check the "Indent With Tabs"
  check box on the Extension Options dialog box if you want
  the %\i option to indent using tab characters.

*/
/*
  Options for C syntax expansion/indenting may be accessed from the
  Extension Options dialog ("Other", "Configuration...",
  "File Extension Setup...").

  The extension specific options is a string of five numbers separated
  with spaces with the following meaning:

    Position       Option
       1             Syntax indent amount
       2             expansion on/off.
       3             Minimum abbreviation.  Defaults to 1.  Specify large
                     value to avoid abbreviation expansion.
       4             Indent after open parenthesis.  Effects argument
                     lists and if/while/switch.
       5             begin/end style.  Begin/end style may be 0,1, or 2
                     as show below.  Add 4 to the begin end style if you
                     want braces inserted when syntax expansion occurs
                     (main and do insert braces anyway).  Typing a begin
                     brace, '{', inserts an end brace when appropriate
                     (unless you unbind the key).  If you want a blank
                     line inserted in between, add 8 to the begin end
                     style.  Default is 4.

                      Style 0
                          if () {
                             ++i;
                          }

                      Style 1
                          if ()
                          {
                             ++i;
                          }

                      Style 2
                          if ()
                            {
                            ++i;
                            }


       6             Indent first level of code.  Default is 1.
                     Specify 0 if you want first level statements to
                     start in column 1.
       7             Main style.  Main style may be 0,1, or 2 which
                     correspond to old C style, ansi C, or no expansion.
                     Default is 0.
       8             Indent CASE from SWITCH.  Default is 0.  Specify
                     1 if you want CASE statements indented from the
                     SWITCH statement. Begin/end style 2 not supported.
       9             Not always present.
                     UseContOnParameters
*/


// style3 refers to out C extension options dialog
int def_style3_indent_all_braces;

// always prompt for else or else if,
// even if "else" is completely typed out
boolean def_always_prompt_for_else_if=false;

// indent public:|private:|protected: specifiers inside class/struct
boolean def_indent_member_access_specifier=false;

// leave single line statements hanging
//
// if (condition)
//    doSomething();
//
// instead of:
//
// if (condition) doSomething();
//
int def_hanging_statements_after_col=40;

/**
 * By default, when you type a space after a #include, we will not
 * do anything special.  Set this value to
 * AC_POUND_INCLUDE_QUOTED_ON_SPACE to list quoted include files
 * after typing "#include<space>".  To list include files (no
 * quotes) after typing "#include "" or "#include <", set this
 * value to AC_POUND_INCLUDE_ON_QUOTELT.
 *
 * This variable only applies to C/C++.  It is best to access
 * this by calling the LanguageSettings API for the language you
 * are interested in
 * (LanguageSettings.getAutoCompletePoundIncludeOption(p_LangId)).
 *
 * @default 0
 * @categories Configuration_Variables
 */
int def_c_expand_include=AC_POUND_INCLUDE_NONE;

/**
 * Activates C/C++ file editing mode.
 *
 * @appliesTo  Edit_Window, Editor_Control
 *
 * @categories Edit_Window_Methods, Editor_Control_Methods
 */
_command void c_mode() name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY|VSARG2_ICON)
{
   _SetEditorLanguage('c');
}

/**
 * (C mode only) ENTER
 * <pre>
 * New binding of ENTER key when in C mode.  Handles syntax expansion and indenting for files
 * with C or H extension.
 *
 * @appliesTo  Edit_Window, Editor_Control
 *
 * @categories Edit_Window_Methods, Editor_Control_Methods
 */
_command void c_enter() name_info(','VSARG2_CMDLINE|VSARG2_ICON|VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   if (ispf_common_enter()) return;
   if (command_state()) {
      call_root_key(ENTER);
      return;
   }

   // Handle Assembler embedded in C
   typeless orig_values;
   int embedded_status=_EmbeddedStart(orig_values);
   if (embedded_status==1) {
      call_key(ENTER, "\1", "L");
      _EmbeddedEnd(orig_values);
      return; // Processing done for this key
   }
   if (p_window_state:=='I' ||
      p_SyntaxIndent<0 || p_indent_style!=INDENT_SMART) {
      call_root_key(ENTER);
   } else {
      if (_in_comment(true)) {
         // start of a Java doc comment?
         get_line(auto first_line);
         if (_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_AUTO_DOC_COMMENT) &&
             (first_line=='/***/' || first_line=='/*!*/') && get_text(2)=='*/' && _is_line_before_decl()) {
            //_document_comment(DocCommentTrigger1);commentwrap_SetNewJavadocState();return;
            //get_line_raw(auto recoverLine);
            p_line += 1;
            first_non_blank();
            int pc = p_col - 1;
            p_line -= 1;
            p_col = 1;
            _delete_end_line();
            _insert_text_raw(indent_string(pc));
            if (!expand_alias(substr(strip(first_line), 1, 3), '', getCWaliasFile(p_LangId), true)) {
               CW_doccomment_nag();
            }
            commentwrap_SetNewJavadocState();
            return;
         }
         //Try to handle with comment wrap.  If comment wrap
         //handled the keystroke then return.
         if (commentwrap_Enter()) {
            return;
         }
         // multi-line comment
         if (_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_AUTO_JAVADOC_ASTERISK) && commentwrap_Enter(true)) {
            //do nothing
         } else {
            call_root_key(ENTER);
         }
         return;
      }
      if (_in_comment(false)) {
         // single line comment

         //Check for case of '//!'
         _str line; get_line(line);
         boolean double_slash_bang = (substr(strip(line), 1, 3) == '//!');
         _str commentChars='';
         int line_col = _inExtendableLineComment(commentChars, double_slash_bang);
         if (((_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_SPLIT_LINE_COMMENTS) && _will_split_insert_line()) || (_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_EXTEND_LINE_COMMENTS) && at_end_of_line())) &&
             line_col && /*get_text()!='/'*/ p_col - line_col > 2) {
            // check for xmldoc comment
            int orig_col=p_col;
            p_col = line_col;
            boolean triple_slash = (get_text(3)=='///' && get_text(4)!='////');
            boolean double_slash = (get_text(2)=='//' && get_text(3)!='///' && !double_slash_bang);
            //messageNwait('Checking double slash bang');
            double_slash_bang = (get_text(3)=='//!');
            p_col = orig_col;
            if (_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_AUTO_XMLDOC_COMMENT) &&
                (triple_slash || double_slash_bang) && _is_xmldoc_supported() &&
               (_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_AUTO_DOC_COMMENT) && c_maybe_create_xmldoc_comment(double_slash_bang ? '//!' : '///', true)) ) {
               CW_doccomment_nag();
               return;
            }
            //Try to handle with comment wrap.  If comment wrap
            //handled the keystroke then return.
            if (commentwrap_Enter()) {
               return;
            }

            indent_on_enter(0,line_col);
            if (get_text(2)!='//') {
               _str delimToInsert = '';
               if (double_slash_bang) {
                  delimToInsert = '//!';
               }
               else if (double_slash) {
                  delimToInsert = '//';
               }
               else if (triple_slash) {
                  delimToInsert = '///';
               } else {
                  //Get possible line comment delimiters
                  _str lineCommentDelims[];
                  if (_getLineCommentChars(lineCommentDelims)) {
                     keyin('// ');
                  } else {
                     delimToInsert = lineCommentDelims[0];
                  }
               }
               if (substr(strip(line, 'L'), delimToInsert._length() + 1, 1) == '') {
                  keyin(delimToInsert' ');
               } else {
                  keyin(delimToInsert);
               }
            }
            return;
         }
      }

      //Try to handle with comment wrap.  If comment wrap
      //handled the keystroke then return.
      if (commentwrap_Enter()) {
         return;
      }

      if (_in_string()) {
         if (_LanguageInheritsFrom('c') || _LanguageInheritsFrom('cs') || _LanguageInheritsFrom('java')) {
            _str delim='';
            int string_col = _inString(delim);
            if (_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_SPLIT_STRINGS) &&
                string_col && p_col > string_col && _will_split_insert_line()) {
               _insert_text(delim);
               if (_LanguageInheritsFrom('java')) _insert_text('+');
               if (_LanguageInheritsFrom('cs')) _insert_text('+');
               indent_on_enter(0,string_col);
               keyin(delim);
               return;
            }
         }
      }

      if (_c_expand_enter()) {
          call_root_key(ENTER);
      } else if (_argument=='') {
         _undo('S');
      }
   }
}
static int find_class_col(boolean in_c = false)
{
   _str search_text = in_c ? 'class|struct|[{}]' : 'class|[{}]';
   save_pos(auto p);
   int status=search(search_text,'@-rh');
   int nest_level=0;
   for (;;) {
      if (status) {
         restore_pos(p);
         return(0);
      }
      int cfg=_clex_find(0,'g');
      if (nest_level>=0 || cfg!=CFG_KEYWORD) {
         _str ch=get_text();
         if (ch=='{') {
            --nest_level;
         } else if (ch=='}') {
            ++nest_level;
         }
         status=repeat_search();
         continue;
      }
      first_non_blank();
      int col=p_col;
      restore_pos(p);
      return(col);
   }
}
boolean _c_do_colon()
{
   if (p_col<=2) return(true);
   int orig_col=p_col;
   left();left();
   _str word, line;
   int junk=0;
   int cfg=_clex_find(0,'g');
   get_line(line);
   _str maybe_slots,rest;
   parse line with word maybe_slots rest;
   if (cfg==CFG_KEYWORD || (line=='signals:' && _LanguageInheritsFrom('c')) ||
       ( maybe_slots=='slots:' && _LanguageInheritsFrom('c') &&
         (word=='public' || word=='private' || word=='protected') && rest==''
        )
      ) {
      word=cur_word(junk);
      if (word=='public' || word=='private' || word=='protected' ||
          word=='slots' || word=='signals'
          ) {
         if (word!='slots') {
            first_non_blank();
            if (p_col!=orig_col-length(word)-1) {
               p_col=orig_col;
               return(true);
            }
         }
         int class_col=find_class_col(true);
         if (!class_col) {
            p_col=orig_col;
            return(true);
         }
         get_line(line);line=strip(line);
         updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT);
         ma_indent := beaut_member_access_indent(p_LangId);
         if (ma_indent > 0) {
            class_col+=ma_indent;
         }
         if (beaut_style_for_keyword(p_LangId, 'class', auto jfound) == BES_BEGIN_END_STYLE_3) {
            class_col += p_SyntaxIndent;
         }
         replace_line(indent_string(class_col-1):+strip(line,'L'));
         if (word=='slots') {
            _end_line();
         } else {
            p_col=class_col+length(word)+1;
         }

         return(false);
      }
   }

   int orig_linenum=p_line;
   save_pos(auto p);
   int begin_col=c_begin_stat_col(false /* No RestorePos */,
                                  false /* Don't skip first begin statement marker */,
                                  false /* Don't return first non-blank */);
   // IF we found the beginning of this statement and it starts on
   //    the same line as the colon
   if (begin_col && p_line==orig_linenum) {
      word=cur_word(junk);
      if (word=='case' || word=='default') {
         updateAdaptiveFormattingSettings(AFF_INDENT_CASE);
         first_non_blank();
         // IF the 'case' word is the first non-blank on this line
         if (p_col==begin_col) {
            _str cur_line;
            get_line_raw(cur_line);
            int col=_c_last_switch_col();
            if ( col) {
               updateAdaptiveFormattingSettings(AFF_BEGIN_END_STYLE | AFF_INDENT_CASE);
               col = col + beaut_case_indent(p_LangId);
               if (beaut_style_for_keyword(p_LangId, 'switch', auto jfound) == BES_BEGIN_END_STYLE_3) {
                  col = col + p_SyntaxIndent;
               }
               _str new_cur_line=indent_string(col-1):+strip(cur_line,'L');
               replace_line_raw(new_cur_line);
               // adjust cursor column based on new length of line
               p_col=orig_col+length(expand_tabs(new_cur_line))-length(expand_tabs(cur_line));
            } else {
               p_col=orig_col;
            }
            return(false);
         }
      }
   }
   restore_pos(p);

   p_col=orig_col;
   return(true);
}
_command void c_colon() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL)
{
   keyin(':');
   int cfg=0;
   if (!command_state()) {
      left();
      cfg=_clex_find(0,'g');
      right();
   }
   if ( command_state() || cfg == CFG_STRING) {
      return;
   } 
   if (_in_comment()) {
      tag := "";
      if (!_inDocComment() || !_inJavadocSeeTag(tag)) {
         return;
      }
   }

   if (p_SyntaxIndent >= 0) {
      if (_LanguageInheritsFrom('m') && !_objectivec_do_colon()) {
         return;
      }
      if (!_c_do_colon()) {
         return;
      }
   }
   if (_GetCodehelpFlags() & VSCODEHELPFLAG_AUTO_LIST_MEMBERS) {
      _do_list_members(true,false);
   }
}

_command void c_pound() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL|VSARG2_LASTKEY)
{
   if (command_state()) {
      call_root_key(last_event());
      return;
   }
   if ( !(_GetCodehelpFlags() & VSCODEHELPFLAG_AUTO_LIST_MEMBERS)) {
      keyin('#');
      return;
   }
   if (_in_comment() && _inJavadocSeeTag()) {
      auto_codehelp_key();
      return;
   }
   keyin('#');
   get_line(auto line);
   if (strip(line) == '#' && (_GetCodehelpFlags() & VSCODEHELPFLAG_AUTO_LIST_MEMBERS)) {
      _do_list_members(true,false);
   }
#if 0
   if (_in_comment()) {
      return;
   }
   c_expand_space();
#endif
}
/**
 * If the user just typed <code>/*</code> to open a multiple line comment,
 * complete the comment with <code>*/</code>.  Do not complete the comment
 * if there is text after the cursor, since they are probably trying to
 * surround something.
 *
 * @appliesTo  Edit_Window, Editor_Control
 *
 * @categories Edit_Window_Methods, Editor_Control_Methods
 */
_command void c_asterisk() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL)
{
   if (command_state()) {
      call_root_key(last_event());
      return;
   }
   if (_in_comment() || _in_string()) {
      boolean doInsert = false;
      if (p_col>2) {
         p_col-=2;_str temp = get_text(4);p_col+=2;
         if (temp == '/**/') {
            doInsert = true;
         }
      }
      if (doInsert) {
         _insert_text('*');
      } else {
         keyin('*');
      }
      return;
   }

   _str orig_line='';
   get_line(orig_line);
   _str line=strip(orig_line,'T');
   if ( p_col != text_col(_rawText(line))+1 ) {
      keyin('*');
      return;
   }

   if (def_auto_complete_block_comment) {
      save_pos(auto p);
      left();
      if (get_text() == '/' && search('*/','@hXcs') < 0) {
         restore_pos(p);
         _insert_text_raw('*');
         //Insert an undo step here, so user can undo just the auto insertion of '*/'
         _undo('S');
         _insert_text_raw('*/');
         p_col -= 2;
         message("Type '*/' on a subsequent line to finish this block comment.");
         return;
      }

      restore_pos(p);
   }
   keyin('*');
}

/**
 * Is the location under the cursor a reasonable place for an
 * xmlDoc style comment? 
 *  
 * @param last_slash_keyed_in Should be set to true if the last 
 *                            character of the comment delimiter
 *                            has already been keyed into the
 *                            buffer.
 */
boolean c_maybe_create_xmldoc_comment(_str slcomment_start = '///', boolean last_char_keyed_in = false)
{
   // save our current position
   save_pos(auto p);

   // break look for default handling
   do {

      // option is disabled
      if (!_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_AUTO_XMLDOC_COMMENT)) break;

      // multiple-line comment or string?
      if (_in_comment(true) || _in_string()) break;

      // not in a single line comment?
      if (!_in_comment()) break;

      // not C#?
      if ( !_is_xmldoc_supported() ) break;

      // the line must start with //
      _str line='';
      get_line(line);
      if ( substr(strip(line),1,2)!='//') break;

      // cursor must be at the end of line
      if ( p_col != text_col(_rawText(line))+1 ) break;

      // Don't expand over any comment text the user has typed in.
      line = strip(line, 'B');
      if ((last_char_keyed_in && line != slcomment_start)
          ||( !last_char_keyed_in && line"/" != slcomment_start))
         break;

      // the previous line can not have a comment
      up(); _end_line();
      if (_in_comment()) break;

      // the next line can not have a comment
      restore_pos(p);
      down(); _end_line();
      if (_in_comment()) break;

      // update the current context
      restore_pos(p);
      if (!_is_line_before_decl()) break;

      // finally, we are ready to lay down a really cool comment
      //_document_comment(slcomment_start);
      p_line += 1;
      first_non_blank();
      int pc = p_col - 1;
      p_line -= 1;
      p_col = 1;
      _delete_end_line();
      _insert_text_raw(indent_string(pc));
      expand_alias(slcomment_start, '', getCWaliasFile(p_LangId), true);

      return true;

   } while ( false );

   // handle like normal slash
   restore_pos(p);
   return false;
}

/**
 * If they just typed <code>///</code> to open a xmlDoc comment,
 * and we are not already inside a xmlDoc comment, and the current
 * scope is outside of a function, create a skeleton xmlDoc comment.
 * <p>
 * This feature is enabled for C# only
 *
 * @see xmldoc_comment
 *
 * @appliesTo  Edit_Window, Editor_Control
 *
 * @categories Edit_Window_Methods, Editor_Control_Methods
 */
_command void c_slash() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL)
{
   // cursor is on command line?
   if (command_state()) {
      call_root_key(last_event());
      return;
   }

   // if the previous character is '*' and we are not in
   // a string or comment, then the slash should look for
   // a /**/ that needs to be fixed to create a block comment.
   int cfg = _clex_find(0,'g');
   if (p_col > 1 && get_text(1,(int)_QROffset()-1)=='*' &&
       cfg!=CFG_STRING && cfg!=CFG_COMMENT && cfg!=CFG_IMAGINARY_LINE) {

      int start_line=0;
      int orig_line=p_line;
      save_search(auto s1,auto s2,auto s3,auto s4,auto s5);
      long orig_offset = _QROffset();

      int status = search('\/\*\*\/[ \t]*$','@-rhCc');
      if (!status) {
         start_line=p_line;
         p_col+=2;
         _delete_text(2);
      }

      restore_search(s1,s2,s3,s4,s5);
      if (start_line > 0) {
         _GoToROffset(orig_offset-2);
         message("Finished comment starting on line ":+start_line);
      } else {
         _GoToROffset(orig_offset);
      }

      keyin('/');
      return;
   }

   // the line must only contain the leading // of the comment
   _str line='';
   get_line(line);
   if (strip(line)!='//' || !_LanguageInheritsFrom('cs')) {
      // handle like normal slash
      keyin('/');
      // start list members if we are on a line containing a #include
      if (first_char(line)=='#') {
         line = strip(substr(line, 2));
         if (pos("include|import|require", line, 1, "r") == 1) {
            if (LanguageSettings.getAutoCompletePoundIncludeOption(p_LangId) == AC_POUND_INCLUDE_ON_QUOTELT) {
               _macro_delete_line();
               _do_list_members(false,true);
            }
         }
      }
      return;
   }

   // see if we can create an xmlDoc comment
   if (_GetCommentEditingFlags(VS_COMMENT_EDITING_FLAG_AUTO_DOC_COMMENT) && c_maybe_create_xmldoc_comment('///', false)) {
      CW_doccomment_nag();
      return;
   } else {
      keyin('/');
      return;
   }
}

/**
 * (C mode only) SPACE BAR
 * <p>
 * New binding of SPACE key when in C mode.  Handles syntax expansion and indenting
 * for files with C or H extension..
 *
 * @appliesTo  Edit_Window, Editor_Control
 *
 * @categories Edit_Window_Methods, Editor_Control_Methods
 *
 */
_command void c_space() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL|VSARG2_LASTKEY)
{
   // Handle Assembler embedded in C
   if (command_state()) {
      call_root_key(' ');
      return;
   }
   typeless orig_values;
   int embedded_status=_EmbeddedStart(orig_values);
   if (embedded_status==1) {
      call_key(last_event(), "\1", "L");
      _EmbeddedEnd(orig_values);
      return; // Processing done for this key
   }
   if (_inJavadoc()) {
      auto_codehelp_key();
      if (!AutoCompleteActive()) {
         c_maybe_list_javadoc();
      }
      return;
   }
   boolean do_space = false;
   if ( command_state() || !doExpandSpace(p_LangId) || p_SyntaxIndent<0 ||
      _in_comment() ||
         c_expand_space() ) {
      if ( command_state() ) {
         call_root_key(' ');
      } else {
         keyin(' '); do_space = true;
      }
   } else if (_argument=='') {
      _undo('S');
   }

   // display auto-list-paramters for completing
   // assignment statements, return statements,
   // and goto statements
   if (!command_state() && do_space) {
      if (c_maybe_list_args(true)) {
         return;
      }
      if (c_maybe_list_javadoc()) {
         return;
      }
      // we don't do comments or strings
      if (_in_comment() || _in_string()) {
         return;
      }
      if (objectivec_space_codehelp()) {
         return;
      }
   }
}

/**
 * (C mode only) Semicolon
 * <p>
 * Handles syntax expansion for one-line if and while
 * statements.  Just type "if", then semicolon, and it
 * expands to "if (&lt;cursor here&gt;) &lt;next hotspot&gt;
 *
 * @appliesTo Edit_Window, Editor_Control
 * @categories Edit_Window_Methods, Editor_Control_Methods
 */
_command void c_semicolon() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL|VSARG2_LASTKEY)
{
   if (command_state()) {
      call_root_key(';');
      return;
   }

   int cfg = 0;
   if (p_col>1) {
      cfg=_clex_find(0,'g');
   }

   // Handle Assembler embedded in C
   typeless orig_values;
   int embedded_status=_EmbeddedStart(orig_values);
   if (embedded_status==1) {
      call_key(last_event(), "\1", "L");
      _EmbeddedEnd(orig_values);
      return; // Processing done for this key
   }
   insertBraceOn := LanguageSettings.getInsertBeginEndImmediately(p_LangId);
   if (insertBraceOn) {
      LanguageSettings.setInsertBeginEndImmediately(p_LangId, false);
   }

   in_comment := _in_comment();

   if ( command_state() || ! LanguageSettings.getSyntaxExpansion(p_LangId) || p_SyntaxIndent<0 ||
       in_comment ||
         c_expand_space() ) {
      keyin(';');
      if (beautify_on_edit(p_LangId)
          && embedded_status != 2
          && !_in_c_preprocessing()
          && !in_comment
          && cfg != CFG_STRING) {
         cp := _QROffset();
         save_pos(auto sp1);
         prev_char(); prev_char();
         if (get_text() == '}') {
            // semi right after a }, probably a class, namespace, etc...
            find_matching_paren(true);
            prev_char();
         }
         if (c_begin_stat_col(false, false, false, true) > 0) {
            bp := _QROffset();
            if (bp < cp) {
               long markers[];
               restore_pos(sp1);
               _GoToROffset(cp);
               if (!_macro('S')) {
                  _undo('S');
               }
               new_beautify_range(bp, cp, markers, true, false, false, BEAUT_FLAG_TYPING);

               // Even when space after semicolon is enabled, we don't want to leave
               // trailing spaces all over the place.
               if (_text_colc()+1 == p_col) {
                  save_pos(sp1);
                  prev_char();
                  if (get_text_safe() != ' ') {
                     restore_pos(sp1);
                  } else {
                     _delete_char();
                  }
               }

            } else {
               restore_pos(sp1);
               _GoToROffset(cp);
            }
         } else {
            restore_pos(sp1);
            _GoToROffset(cp);
         }
      }
   } else if (_argument=='') {
      _undo('S');
   }

   if (insertBraceOn) {
      LanguageSettings.setInsertBeginEndImmediately(p_LangId, true);
   }
}

// Returns true the cursor is at a terminator for a statement
// that can be pulled into a dynamic-surround.  Cursor should
// be at the end of the statement.
boolean _c_surroundable_statement_end() {
   save_pos(auto p1);
   prev_char();
   if (get_text() == '}') {
      restore_pos(p1);
      return false;
   }

   _first_non_blank_col();
   wrd := cur_word(auto junk);
   restore_pos(p1);

   if (wrd == 'break') {
      return true;
   }

   return false;
}

/**
 * (C mode only) Open Parenthesis
 * <p>
 * Handles syntax expansion or auto-function-help for C/C++ mode
 * and several other C-like languages.
 *
 * @appliesTo  Edit_Window, Editor_Control
 * @categories Edit_Window_Methods, Editor_Control_Methods
 */
_command void c_paren() name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_CMDLINE|VSARG2_LASTKEY)
{
   // Called from command line?
   if (command_state()) {
      call_root_key('(');
      return;
   }

   // Handle Assembler embedded in C
   typeless orig_values;
   int embedded_status=_EmbeddedStart(orig_values);
   if (embedded_status==1) {
      call_key(last_event(), "\1", "L");
      _EmbeddedEnd(orig_values);
      return;
   }

   // Check syntax expansion options
   if (LanguageSettings.getSyntaxExpansion(p_LangId) && p_SyntaxIndent>=0 && !_in_comment() &&
       !c_expand_space()) {
      return;
   }

   // not the syntax expansion case, so try function help
   auto_functionhelp_key();
}
/**
 * (C mode only) '{'
 * <p>
 * New binding of '{' key when in C mode.  When appropriate, inserts '{' at cursor,
 * inserts blank line, indents cursor on next line, and inserts another line with end brace.
 * Exact action depends on your C extension specific options.
 *
 * @appliesTo  Edit_Window, Editor_Control
 *
 * @categories Edit_Window_Methods, Editor_Control_Methods
 */
_command void c_begin() name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_CMDLINE)
{
   if ( command_state()) {
      call_root_key('{');
      return;
   }

   int embedded_status=_EmbeddedStart(auto orig_values);
   if (embedded_status==1) {
      call_key(last_event(), "\1", "L");
      _EmbeddedEnd(orig_values);
      return; // Processing done for this key
   }

   int cfg = 0;
   if (p_col>1) {
      left();cfg=_clex_find(0,'g');right();
   }

   if ( cfg==CFG_STRING || _in_comment() ||
        c_expand_begin()) {
      call_root_key('{');
   } else if (_argument=='') {
      _undo('S');
   }

   if (beautify_on_edit(p_LangId)
       && embedded_status != 2
       && !_in_c_preprocessing()
       && !_in_comment()
       && cfg != CFG_STRING) {
      endpoint := _QROffset();

      save_pos(auto orig_pos);
      // Ride with {
      typeless rp;
      prev_char();
      riding_brace := get_text() == '{';

      // We ride the brace unless insertBlankLineBetweenBeginAndEnd is enabled.
      if (riding_brace) {
         save_pos(rp);
         next_char();
      } else {
         restore_pos(orig_pos);
         rp = orig_pos;
      }

      _clex_skip_blanks();
      if (get_text_safe() == '}') {
         // If we're immediately followed by the closing brace, beautify it too.
         endpoint = _QROffset();
      }

      // scoot back to where the { was inserted.
      if ( 0 == search('\{', '-r@XCS') ) {
         insert_point := _QROffset();
         if (p_col > 1) {
            left();
         } else {
            up();
            _end_line();
         }
         _clex_skip_blanks('-');
         if (c_begin_stat_col(false, false, false, true) > 0) {
            bp := _QROffset();
            if (bp < insert_point) {
               long markers[];
               restore_pos(rp);
               if (!_macro('S')) {
                  _undo('S');
               }
               new_beautify_range(bp, endpoint, markers, true, riding_brace, false, BEAUT_FLAG_TYPING|BEAUT_FLAG_AUTOBRACKET);
            } else {
               restore_pos(orig_pos);
               do_surround_mode_keys();
            }
         } else {
            restore_pos(orig_pos);
            do_surround_mode_keys();
         }
      } else {
         restore_pos(orig_pos);
         do_surround_mode_keys();
      }
   }
}

static boolean handle_objc_block_end(_str line) {
   if (_LanguageInheritsFrom('m')) {
      cur_col := _text_colc(p_col, 'P');
      if (cur_col <= 1 
          || pos('^[ \t]*\}$', substr(line, 1, cur_col-1), 1, 'R') > 0) {
         // Nothing but whitespace behind us, so reindent.
         int col = c_endbrace_col();
         if (col > 0) {
            replace_line(indent_string(col-1):+strip(line));
            p_col = col + 1;
            return true;
         }
      }
   }
   return false;
}

static _c_maybe_reindent_rbrace() {
   get_line(auto line);
   if (false == handle_objc_block_end(line)
       && line=='}') {
      int col=c_endbrace_col();
      if (col) {
         replace_line(indent_string(col-1):+'}');
         p_col=col+1;
      }
   }
   _undo('S');
}


void _c_endbrace(boolean inhibit_beautify=false) {
   int cfg=0;
   if (!command_state() && p_col>1) {
      left();cfg=_clex_find(0,'g');right();
   }
   keyin('}');
   if ( command_state() || cfg==CFG_STRING || p_window_state:=='I' ||
      p_SyntaxIndent<0 || p_indent_style!=INDENT_SMART ||
      _in_comment() || _in_c_preprocessing() ) {
   } else if (!inhibit_beautify
              && beautify_on_edit(p_LangId)) {
      // Ride the } to the new position
      prev_char();
      save_pos(auto sp);
      endo := _QROffset();

      if (find_matching_paren(true) == 0) {
         long markers[];

         // Scan back further if it looks like control statement.
         prev_char();
         _clex_skip_blanks('-');
         if (get_text_safe() == ')') {
            find_matching_paren(true);
         }
         start := _QROffset();
         restore_pos(sp);
         if (!_macro('S')) {
            _undo('S');
         }
         new_beautify_range(start, endo, markers, true, true, false);
      } else {
         restore_pos(sp);
         next_char();
         _c_maybe_reindent_rbrace();
      }
   } else if (_argument=='') {
      _c_maybe_reindent_rbrace();
   }
}

/**
 * (C mode only) '}'
 * <pre>
 * New binding of '}' key when in C mode.  Inserts '}' at cursor and reindents the brace
 * according to your C extension specific options.  No reindenting occurs if the brace is
 * NOT being inserted into a blank line or if the brace is NOT part of an if, switch, while,
 * do, or else block.
 *
 *
 * @appliesTo  Edit_Window, Editor_Control
 *
 * @categories Edit_Window_Methods, Editor_Control_Methods
 */
_command void c_endbrace() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL)
{
   _c_endbrace(false);
}

/**
 * look for beginning of statement by searching for the following
 * <PRE>
 *      '{', '}', ';', ':', 'if', 'while','switch','for', 'with' (perl)
 * </PRE>
 * <P>
 * If a non-alpha symbol is found, we look ahead for the first a non-blank
 * character that is not in a comment.
 * <P>
 * NOTE:  Calling this function for code like the following will
 *        find the beginning of the code block and not the statement:
 * <PRE>
 *    &lt;Find Here&gt;for (...) ++i&lt;Cursor Here&gt;
 *    &lt;Find Here&gt;if/while (...) ++i&lt;Cursor Here&gt;
 * </PRE>
 *
 * @param RestorePos
 * @param SkipFirstHit
 * @param ReturnFirstNonBlank
 * @param FailIfNoPrecedingText
 * @param AlreadyRecursed
 * @param FailWithMinus1_IfNoTextAfterCursor
 *
 * @return int
*/
int c_begin_stat_col(boolean RestorePos,boolean SkipFirstHit,boolean ReturnFirstNonBlank,
                     boolean FailIfNoPrecedingText=false,
                     boolean AlreadyRecursed=false,
                     boolean FailWithMinus1_IfNoTextAfterCursor=false)
{
   int orig_linenum=p_line;
   int orig_col=p_col;
   //ReturnCurColIfCursorBetweenOpenBraceAndEOF=1;
   in_c := _LanguageInheritsFrom("c");
   in_csharp := _LanguageInheritsFrom("cs");
   in_objectivec := _LanguageInheritsFrom('m');
   in_go := _LanguageInheritsFrom('googlego');
   bracket_count := 0;
   check_label := false;
   if (AlreadyRecursed && get_text() == ':') {
      check_label = true;
   }
   save_pos(auto p);

   _str srch_str = '[{};:()\[\]]|with|elsif|elseif|if|while|lock|switch|for|foreach|foreach_reverse|using';

   if (in_objectivec) {
      srch_str = srch_str :+ '|\@(interface|implementation|protocol|end|property|package|private|protected|public|optional|required|dynamic|synthesize|property)';
   } else if (in_go) {
      srch_str = srch_str :+ '|'\n;
   }

   int status=search(srch_str,'-Rh@');
   int nesting=0;
   int brace_nesting = 0;                                 
   boolean hit_top=false;
   boolean first_match = true;

   // Association from brace nesting to the paren nesting that was in effect
   // at the time the brace nesting was entered.                            
   int paren_at_brace_nesting:[];         

   paren_at_brace_nesting:[0] = 0;

   int MaxSkipPreprocessing=VSCODEHELP_MAXSKIPPREPROCESSING;
   for (;;) {
      if (status) {
         top();
         hit_top=true;
      } else {
         int cfg=_clex_find(0,'g');
         if (cfg==CFG_COMMENT || cfg==CFG_STRING) {
            SkipFirstHit=false;
            status=repeat_search();
            first_match = false;
            continue;
         }
         switch (get_text()) {
         case '(':
            FailIfNoPrecedingText=false;
            if (nesting>0) {
               --nesting;
            }
            SkipFirstHit=false;
            status=repeat_search();
            first_match = false;
            continue;
         case ')':
            FailIfNoPrecedingText=false;
            ++nesting;
            SkipFirstHit=false;
            status=repeat_search();
            first_match = false;
            continue;
         case '[':
            if (in_objectivec) {
               --bracket_count;
            }
            status=repeat_search();
            first_match = false;
            continue;
         case ']':
            if (in_objectivec) {
               ++bracket_count;
            }
            status=repeat_search();
            first_match = false;
            continue;
         case '@':
            if (in_objectivec && cfg == CFG_KEYWORD) {
               if (first_match) {
                  _clex_find_start();
               } else {
                  next_word();
               }
            }
            break;

         case '}':
            brace_nesting++;
            paren_at_brace_nesting:[brace_nesting] = nesting;
            break;

         case '{':
            if (paren_at_brace_nesting:[brace_nesting] != nesting) {
               // We've exited a matched {} pair, and the paren nesting
               // changed somewhere inside of it.  Which probably 
               // means a mismatched paren.  Worst case, mismatched parens 
               // or braces can kick us all the way to the top of the file, so 
               // we respond here with an error.
               restore_pos(p);
               return 0;
            }
            if (brace_nesting > 0) {
               brace_nesting--;
            }
            break;

         }
         first_match = false;
         if (SkipFirstHit || nesting || (bracket_count > 0)) {
            FailIfNoPrecedingText=false;
            SkipFirstHit=false;
            status=repeat_search();
            continue;
         }
         if (_in_c_preprocessing()) {
            --MaxSkipPreprocessing;
            if (MaxSkipPreprocessing<=0) {
               status=STRING_NOT_FOUND_RC;
               continue;
            }
            SkipFirstHit=false;
            begin_line();
            status=repeat_search();
            continue;
         }

         _str ch=get_text();
         if (!AlreadyRecursed && ch:==':') {
            save_pos(auto p2);
            if (p_col!=1) {
               left();
               // IF we are seeing  classname::name
               if (get_text()==':') {
                  status=repeat_search();
                  continue;
               }
               right();
            }
            int col = c_begin_stat_col(false,true,false,false,1);
            _str word = cur_word(auto junk);
            ch = get_text();
            if (in_objectivec && (ch == '[' || ch == '-' || ch == '+')) {
               // valid for objective-c, early-out

            } else if ((!in_csharp && (word=='public' || word=='private' || word=='protected')) ||
                       (in_c && word=='signals') ||
                       (word=='case' || word=='default')) {
               restore_pos(p2);
               right();
            }
         } else {
            /*
                Handle where constraint case for csharp.  Need to go back to beginning of class definition.
                The only down side to doing this is that if the constraints are on multiple lines we will
                indent back to the "where" column.  This is not a likely case so we can forget about it.

                class myclass<a>
                    where a: constraint1,constraint2,constraint3
                    where b: constraint1,constraint2,constraint3
            */
            if (AlreadyRecursed && ch:==':') {
               if (in_csharp) {
                  _str line, word, more;
                  get_line(line);
                  parse line with word more':';
                  if (word=='where') {
                     status=repeat_search();
                     continue;
                  }
               } else {
                  if (p_col!=1) {
                     left();
                     // IF we are seeing  classname::name
                     if (get_text()==':') {
                        status=repeat_search();
                        continue;
                     }
                     right();
                  }
                  if (in_objectivec) {
                     if (check_label) {
                        // could be in label, access modifier, or objc method call
                        save_pos(auto p2);
                        right();
                        status = _clex_skip_blanksNpp();
                        if (!status) {
                           _str word = cur_word(auto junk);
                           cfg = _clex_find(0,'g');
                           if (cfg != CFG_COMMENT && cfg != CFG_STRING) {
                              if ((cfg == CFG_KEYWORD && (word=='public' || word=='private' || word=='protected' || word=='case' || word=='default')) ||
                                  (in_c && word=='signals')) {
                                 int col = p_col;
                                 if (RestorePos) {
                                    restore_pos(p);
                                 }
                                 return(col);
                              }
                           }
                        }
                        restore_pos(p2);
                     }
                     check_label = true; // repeat check??
                     status=repeat_search();
                     continue;
                  }
               }
            }
            if (isalpha(ch)) {
               if(cfg!=CFG_KEYWORD) {
                  if (cfg!=CFG_STRING && cfg!=CFG_COMMENT) {
                     FailIfNoPrecedingText=false;
                  }
                  status=repeat_search();
                  continue;
               }
            } else {
               right();
            }
         }
      }
      status=_clex_skip_blanksNpp();
      if (status) {
         restore_pos(p);
         /*
             Would could have an open brace followed by blanks and eof.
         */
         if (!hit_top) {
            if (!FailWithMinus1_IfNoTextAfterCursor) {
               return(p_col);
            }
            return(-1);
         }
         return(0);
      }
      /*
          We could have the following:

            class name:public name2 {

          recurse to look for "case" keyword

      */
      if (ReturnFirstNonBlank) {
         first_non_blank();
      }
      int col=p_col;
      if (hit_top && FailIfNoPrecedingText && (p_line>orig_linenum || (p_line==orig_linenum)&& p_col>orig_col)) {
         return(0);
      }
      if (RestorePos) {
         restore_pos(p);
      }
      return(col);
   }

}

/**
 * On entry, the cursor is sitting on a } (close brace)
 * <PRE>
 * static void
 *    main () /* this is a test */ {
 * }
 * static void main /* this is a test */
 *   ()
 * {
 * }
 * </PRE>
 *
 * @param be_style  begin-end brace style
 * <PRE>
 * for (;;) {     for (;;)        for (;;)
 *                {                  {
 *                }                  }
 * }
 * style 0        style 1         style 2
 * </PRE>
 *
 * @return
 * Returns column where end brace should go.
 * Returns 0 if this function does not know the column where the
 * end brace should go.
*/
int c_endbrace_col()
{
   updateAdaptiveFormattingSettings(AFF_BEGIN_END_STYLE);
   boolean style3_MustBackIndent=false;
   return(c_endbrace_col2(p_begin_end_style,style3_MustBackIndent));
}
int c_endbrace_col2(int be_style, boolean &style3_MustBackIndent)
{
   style3_MustBackIndent=false;
   if (p_lexer_name=='') {
      return(0);
   }
   save_pos(auto p);
   --p_col;
   // Find matching begin brace
   int status=_find_matching_paren(def_pmatch_max_diff);
   if (status) {
      restore_pos(p);
      return(0);
   }
   // Assume end brace is at level 0
   if (p_col==1) {
      restore_pos(p);
      return(1);
   }
   save_pos(auto p2);
   int begin_brace_col=p_col;
   // Check if the first char before open brace is close paren
   int col= find_block_col();
   if (!col) {
      restore_pos(p2);
      if (_isVarInitList(true)) {
         restore_pos(p2);
         first_non_blank();
         col=p_col;
         restore_pos(p);
         return(col);
      }
      restore_pos(p2);
#if 0
      if ((be_style == BES_BEGIN_END_STYLE_3) && def_style3_indent_all_braces) {
         // check if this parenthesis is on a line by itself;
         get_line(line);
         if (line=="{") {
            style3_MustBackIndent=true;
            first_non_blank();
            col=p_col;
            restore_pos(p);
            return(col);
         }
      }
#endif
      col=c_begin_stat_col(true,true,true);
      restore_pos(p);
      if ((be_style == BES_BEGIN_END_STYLE_3) && def_style3_indent_all_braces) {
         style3_MustBackIndent=true;
         col+=p_SyntaxIndent;
      }
      return(col);
   }
   style3_MustBackIndent=true;
   if (be_style == BES_BEGIN_END_STYLE_3) {
      restore_pos(p);
      //return(begin_brace_col);
      return(col+p_SyntaxIndent);
   }
   restore_pos(p);
   return(col);
}
/**
 * This function behaves much like _clex_skip_blanks(), but
 * it does not support embedded code sections.  It also does
 * not support the 'c' option.
 *
 * @param options
 * @param clex_options
 *
 * @return  Returns 0 if non-blank character is found, nonzero otherwise.
 * If this functions fails the cursor is moved but its final location may
 * not be the top or bottom of the buffer (we need to change this should
 * be more concrete).
 *
 * @deprecated Use {@link _clex_skip_blanks()} with the 'q' option
 */
int _clex_skip_blanks_quick(_str options='',_str clex_options='n')
{
   return _clex_skip_blanks(options:+clex_options:+"q");

   /*
   _str search_options='@rh':+options;
   for (;;) {
      // search for non-blank character
      int status=search('[~ \t\r\n]',search_options);
      if (status) return(1);
      if (p_lexer_name!='' && _clex_find(0,'g')==CFG_COMMENT) {
         status=_clex_find(COMMENT_CLEXFLAG,clex_options);
         if (status) {
            /* This changes was made for select_proc() */
            if (pos('-',options)) {
               top();
            } else {
               bottom();
            }
            return(1);
         }
         continue;
      }
      return(0);
   }
   */
}

/**
 * Translates the reults of a _clex_find(0,'g') into one of the
 * CFG_&lt;&gt; constants that can be used in a subsequent _clex_find() call.
 *
 * @param clexflags
 *
 * @return
 */
int _clex_translate(int clexflags)
{
   switch (clexflags) {
   case CFG_KEYWORD:
      return(KEYWORD_CLEXFLAG);
   case CFG_LINENUM:
      return(LINENUM_CLEXFLAG);
   case CFG_NUMBER:
      return(NUMBER_CLEXFLAG);
   case CFG_STRING:
      return(STRING_CLEXFLAG);
   case CFG_COMMENT:
      return(COMMENT_CLEXFLAG);
   case CFG_PPKEYWORD:
      return(PPKEYWORD_CLEXFLAG);
   case CFG_PUNCTUATION:
      return(SYMBOL1_CLEXFLAG);
   case CFG_LIBRARY_SYMBOL:
      return(SYMBOL2_CLEXFLAG);
   case CFG_OPERATOR:
      return(SYMBOL3_CLEXFLAG);
   case CFG_USER_DEFINED:
      return(SYMBOL4_CLEXFLAG);
   case CFG_FUNCTION:
      return(FUNCTION_CLEXFLAG);
   default :
      return(OTHER_CLEXFLAG);
   }
}

/**
 * Given the current color coding element, this function places
 * the cursor on the first character of that element.
 *
 * @return Returns 0 if successful.
 */
int _clex_find_start()
{
   typeless p; save_pos(p);
   int clexflags=_clex_find(0,'g');
   if (!clexflags) {
      return(1);
   }
   clexflags = _clex_translate(clexflags);
   int status=_clex_find(clexflags,'n-');
   if (status) {
      top();
   }
   status=_clex_find(clexflags);
   if (status) {
      // this should not happen, but just in case
      restore_pos(p);
      return(1);
   }
   return(0);
}

/**
 * Given the current color coding element, this function places the cursor on the
 * last character of that element.
 *
 * @return Returns 0 if successful.
 */
int _clex_find_end()
{
   save_pos(auto p);
   int clexflags=_clex_find(0,'g');
   if (!clexflags) {
      return(1);
   }
   clexflags = _clex_translate(clexflags);
   int status=_clex_find(clexflags,'n');
   if (status) {
      bottom();
   }
   status=_clex_find(clexflags,'o-');
   if (status) {
      // this should not happen, but just in case
      restore_pos(p);
      return(1);
   }
   return(0);
}

/**
 * @return Returns a SlickEdit regular expression for
 * matching an identifier, as specified by the color
 * coding engine.
 *
 * @see p_identifier_chars
 * @see _clex_identifier_chars()
 * @see _clex_is_identifier_char()
 *
 * @appliesTo Editor_Control, Edit_Window
 * @categories Editor_Control_Methods, Edit_Window_Methods
 */
_str _clex_identifier_re()
{
   _str identifierChars = p_identifier_chars;
   if (p_EmbeddedLexerName != '') {
      identifierChars = p_EmbeddedIdentifierChars;
   }

   // p_identifier_chars contains start chars, then end chars
   // example:  a-zA-z 0-9
   parse identifierChars with auto startch auto endch;
   startch = strip(startch);

   // no end chars?
   if (endch=='') {
      // match one or more start characters
      return "["startch"]#";
   }

   // match the start character followed
   // by zero or more ends
   endch = strip(endch);
   return "["startch"]["startch:+endch"]@";
}
/**
 * @return Returns a SlickEdit regular expression for
 * matching a character which is not part of an
 * identifier, as specified by the color coding engine.
 *
 * @see p_identifier_chars
 * @see _clex_identifier_chars()
 * @see _clex_identifier_re()
 * @see _clex_is_identifier_char()
 *
 * @appliesTo Editor_Control, Edit_Window
 * @categories Editor_Control_Methods, Edit_Window_Methods
 */
_str _clex_identifier_notre()
{
   _str identifierChars = p_identifier_chars;
   if (p_EmbeddedLexerName != '') {
      identifierChars = p_EmbeddedIdentifierChars;
   }

   // p_identifier_chars contains start chars, then end chars
   // example:  a-zA-z 0-9
   parse identifierChars with auto startch auto endch;
   startch = strip(startch);
   endch = strip(endch);
   return "[^"startch:+endch"]";
}
/**
 * @return Returns an expression containing all the
 *         identifier chars as specified by the color
 *         coding engine.  The results of this function
 *         are intended to be a drop-in replacement
 *         for p_word_chars.
 *
 * @see _clex_identifier_re()
 * @see _clex_identifier_notre()
 * @see _clex_is_identifier_char()
 * @see p_identifier_chars
 *
 * @appliesTo Editor_Control, Edit_Window
 * @categories Editor_Control_Methods, Edit_Window_Methods
 */
_str _clex_identifier_chars()
{
   _str identifierChars = p_identifier_chars;
   if (p_EmbeddedLexerName != '') {
      identifierChars = p_EmbeddedIdentifierChars;
   }
   return stranslate(identifierChars,'',' ');
}
/**
 * @return Returns true if the given character is an identifier char
 *         as specified by the color coding engine.
 *
 * @param ch   character to test
 *
 * @appliesTo Editor_Control, Edit_Window
 * @categories Editor_Control_Methods, Edit_Window_Methods
 */
boolean _clex_is_identifier_char(_str ch)
{
   _str identifierChars = p_identifier_chars;
   if (p_EmbeddedLexerName != '') {
      identifierChars = p_EmbeddedIdentifierChars;
   }

   // p_identifier_chars contains start chars, then end chars
   // example:  a-zA-z 0-9
   parse identifierChars with auto startch auto endch;
   startch = strip(startch);
   endch = strip(endch);
   return (length(ch)==1 && pos("["startch:+endch"]", ch, 1, 'r') == 1);
}

static int find_block_col()
{
   _str word;
   int col=0;
   --p_col;
   if (_clex_skip_blanks('-')) return(0);
   if (get_text()!=')') {
      if (_clex_find(0,'g')!=CFG_KEYWORD) {
         return(0);
      }
      word=cur_word(col);
      if (word=='do' || word=='else') {
         first_non_blank();
         return(p_col);
         //return(p_col-length(word)+1);
      }
      return(0);
   }
   // Here we match round parens. ()
   int status=_find_matching_paren(def_pmatch_max_diff);
   if (status) return(0);
   if (p_col==1) return(1);
   --p_col;

   if (_clex_skip_blanks('-')) return(0);
   /*if (_clex_find(0,'g')!=CFG_KEYWORD) {
      return(0);
   }
   */
   word=cur_word(col);
   if (pos(' 'word' ',' with for foreach foreach_reverse if elsif elseif switch while lock using ')) {
      first_non_blank();
      return(p_col);
      //return(p_col-length(word)+1);
   } else if (_LanguageInheritsFrom('java')) {
      // Check if we have a new construct
      p_col=_text_colc(col,'I');
      if (p_col>1) {
         left();
         if (_clex_skip_blanks('-')) return(0);
         word=cur_word(col);
         if (word=='new') {
            p_col=_text_colc(col,'I');
            col=p_col;
            first_non_blank();
            if (col!=p_col) {
               p_col+=p_SyntaxIndent;
            }
            return(p_col);
         }
      }
   }
   return(0);
}
#define EXPAND_WORDS (' #define #elif #else #endif #error #if #ifdef #ifndef':+\
                ' #include #pragma #undef else enum typedef static struct class' :+\
                ' union public private protected ')

#define JAVA_ONLY_EXPAND_WORDS ' final import int interface package synchronized '
#define CS_ONLY_EXPAND_WORDS ' #region #endregion '
#define IDL_ONLY_EXPAND_WORDS ' attribute in inout '
#define PHP_ONLY_EXPAND_WORDS ' import '

static SYNTAX_EXPANSION_INFO cpp_space_words:[] = {
   '#define'          => { "#define" },
   '#elif'            => { "#elif" },
   '#else'            => { "#else" },
   '#endif'           => { "#endif" },
   '#error'           => { "#error" },
   '#if'              => { "#if" },
   '#ifdef'           => { "#ifdef" },
   '#ifndef'          => { "#ifndef" },
   '#include'         => { "#include" },
   '#pragma'          => { "#pragma" },
   '#undef'           => { "#undef" },
   'break'            => { "break;" },
   'case'             => { "case" },
   'catch'            => { "catch ( ... ) { ... }" },
   'class'            => { "class" },
   'const_cast'       => { "const_cast < ... > ( ... )" },
   'continue'         => { "continue;" },
   'default'          => { "default:" },
   'do'               => { "do { ... } while ( ... );" },
   'dynamic_cast'     => { "dynamic_cast < ... > ( ... )" },
   'else if'          => { "else if ( ... ) { ... }" },
   'else'             => { "else { ... }" },
   'enum'             => { "enum" },
   'for'              => { "for ( ... ) { ... }" },
   'if'               => { "if ( ... ) { ... }" },
   'main'             => { "main(int argc, char *argv[]) { ... }" },
   'printf'           => { "printf(\"" },
   'private'          => { "private:" },
   'protected'        => { "protected:" },
   'public'           => { "public:" },
   'reinterpret_cast' => { "reinterpret_cast < ... > ( ... )" },
   'return'           => { "return" },
   'static_cast'      => { "static_cast < ... > ( ... )" },
   'struct'           => { "struct" },
   'switch'           => { "switch ( ... ) { ... }" },
   'template'         => { "template < ... >" },
   'try'              => { "try { ... } catch ( ... ) { ... }" },
   'typedef'          => { "typedef" },
   'union'            => { "union" },
   'while'            => { "while ( ... ) { ... }" },

   '@catch'           => { "@catch" },
   '@class'           => { "@class" },
   '@defs'            => { "@defs" },
   '@dynamic'         => { "@dynamic" },
   '@encode'          => { "@encode" },
   '@end'             => { "@end" },
   '@finally'         => { "@finally" },
   '@implementation'  => { "@implementation ... @end" },
   '@interface'       => { "@interface ... @end" },
   '@package'         => { "@package" },
   '@private'         => { "@private" },
   '@property'        => { "@property" },
   '@protected'       => { "@protected" },
   '@protocol'        => { "@protocol ... @end" },
   '@public'          => { "@public" },
   '@selector'        => { "@selector" },
   '@synchronized'    => { "@synchronized" },
   '@synthesize'      => { "@synthesize" },
   '@throw'           => { "@throw" },
   '@try'             => { "@try" },
};

static _str else_space_words[] = { 'else', 'else if' };

static SYNTAX_EXPANSION_INFO cs_space_words:[] = {
   '#define'      => { "#define" },
   '#elif'        => { "#elif" },
   '#else'        => { "#else" },
   '#endif'       => { "#endif" },
   '#endregion'   => { "#endregion" },
   '#error'       => { "#error" },
   '#if'          => { "#if" },
   '#ifdef'       => { "#ifdef" },
   '#ifndef'      => { "#ifndef" },
   '#include'     => { "#include" },
   '#pragma'      => { "#pragma" },
   '#region'      => { "#region" },
   '#undef'       => { "#undef" },
   'break'        => { "break;" },
   'case'         => { "case" },
   'catch'        => { "catch ( ... ) { ... }" },
   'class'        => { "class" },
   'continue'     => { "continue;" },
   'default'      => { "default:" },
   'do'           => { "do { ... } while ( ... );" },
   'else'         => { "else { ... }" },
   'enum'         => { "enum" },
   'else if'      => { "else if ( ... ) { ... }" },
   'finally'      => { "finally { ... }" },
   'fixed'        => { "fixed" },
   'for'          => { "for ( ... ) { ... }" },
   'foreach'      => { "foreach ( ... ) { ... }" },
   'if'           => { "if ( ... ) { ... }" },
   'int'          => { "int" },
   'interface'    => { "interface" },
   'lock'         => { "lock ( ... ) { ... }" },
   'main'         => { "public static void Main (string []args) { ... }" },
   'private'      => { "private" },
   'protected'    => { "protected" },
   'public'       => { "public" },
   'return'       => { "return" },
   'struct'       => { "struct" },
   'switch'       => { "switch ( ... ) { ... }" },
   'try'          => { "try { ... } catch ( ... ) { ... }" },
   'union'        => { "union" },
   'using'        => { "using" },
   'while'        => { "while ( ... ) { ... }" },
};

static SYNTAX_EXPANSION_INFO java_space_words:[] = {
   '#define'      => { "#define" },
   '#elif'        => { "#elif" },
   '#else'        => { "#else" },
   '#endif'       => { "#endif" },
   '#error'       => { "#error" },
   '#if'          => { "#if" },
   '#ifdef'       => { "#ifdef" },
   '#ifndef'      => { "#ifndef" },
   '#include'     => { "#include" },
   '#pragma'      => { "#pragma" },
   '#undef'       => { "#undef" },
   'break'        => { "break;" },
   'case'         => { "case" },
   'catch'        => { "catch ( ... ) { ... }" },
   'class'        => { "class" },
   'continue'     => { "continue;" },
   'default'      => { "default:" },
   'do'           => { "do { ... } while ( ... );" },
   'else'         => { "else { ... }" },
   'enum'         => { "enum" },
   'for'          => { "for ( ... ) { ... }" },
   'if'           => { "if ( ... ) { ... }" },
   'int'          => { "int" },
   'interface'    => { "interface" },
   'main'         => { "public static void main (String args[]) { ... }" },
   'package'      => { "package" },
   'private'      => { "private" },
   'protected'    => { "protected" },
   'public'       => { "public" },
   'return'       => { "return" },
   'switch'       => { "switch ( ... ) { ... )" },
   'try'          => { "try { ... } catch ( ... ) { ... }" },
   'while'        => { "while ( ... ) { ... }" },
   'else if'      => { "else if ( ... ) { ... }" },
   'static'       => { "static" },
   '@interface'   => { "@interface" },
   'final'        => { "final" },
   'finally'      => { "finally" },
   'import'       => { "import" },
};

static SYNTAX_EXPANSION_INFO javascript_space_words:[] = {
   'break'        => { "break;" },
   'case'         => { "case" },
   'catch'        => { "catch ( ... ) { ... }" },
   'continue'     => { "continue;" },
   'default'      => { "default:" },
   'do'           => { "do { ... } while ( ... );" },
   'else'         => { "else { ... }" },
   'else if'      => { "else if ( ... ) { ... }" },
   'finally'      => { "finally { ... }" },
   'for'          => { "for ( ... ) { ... }" },
   'if'           => { "if ( ... ) { ... }" },
   'return'       => { "return" },
   'switch'       => { "switch ( ... ) { ... }" },
   'while'        => { "while ( ... ) { ... }" },
   'export'       => { "export" },
   'function'     => { "function" },
   'import'       => { "import" },
   'try'          => { "try { ... } catch ( ... ) { ... }" },
   'var'          => { "var" },
   'with'         => { "with ( ... ) { ... }" },
};

static SYNTAX_EXPANSION_INFO php_space_words:[] = {
   'break'        => { "break;" },
   'case'         => { "case" },
   'class'        => { "class" },
   'continue'     => { "continue;" },
   'default'      => { "default:" },
   'do'           => { "do { ... } while ( ... );" },
   'else'         => { "else { ... }" },
   'for'          => { "for ( ... ) { ... )" },
   'if'           => { "if ( ... ) { ... }" },
   'return'       => { "return" },
   'switch'       => { "switch ( ... ) { ... }" },
   'while'        => { "while ( ... ) { ... }" },
   'function'     => { "function" },
   'import'       => { "import" },
   'var'          => { "var" },
   'elseif'       => { "elseif ( ... ) { ... }" },
};

static SYNTAX_EXPANSION_INFO idl_space_words:[] = {
   'attribute'    => { "attribute" },
   'case'         => { "case" },
   'default'      => { "default:" },
   'exception'    => { "exception ... { ... }" },
   'in'           => { "in" },
   'inout'        => { "inout" },
   'interface'    => { "interface ... { ... }" },
   'module'       => { "module ... { ... }" },
   'sequence'     => { "sequence < ... >" },
   'struct'       => { "struct ... { ... }" },
   'switch'       => { "switch ( ... ) { ... }" },
   'typedef'      => { "typedef" },
   'union'        => { "union ... { ... }" },
};

static SYNTAX_EXPANSION_INFO d_space_words:[] = {
   'abstract'     => { "abstract" },
   'alias'        => { "alias" },
   'assert'       => { "assert" },
   'auto'         => { "auto" },
   'body'         => { "body { ... }" },
   'bool'         => { "bool" },
   'byte'         => { "byte" },
   'break'        => { "break;" },
   'case'         => { "case" },
   'catch'        => { "catch ( ... ) { ... }" },
   'class'        => { "class" },
   'const'        => { "const" },
   'continue'     => { "continue;" },
   'debug'        => { "debug ( ... ) { ... }" },
   'default'      => { "default:" },
   'deprecated'   => { "deprecated" },
   'delegate'     => { "delegate" },
   'do'           => { "do { ... } while ( ... );" },
   'else'         => { "else { ... }" },
   'enum'         => { "enum { ... }" },
   'else if'      => { "else if ( ... ) { ... }" },
   'final'        => { "final" },
   'finally'      => { "finally { ... }" },
   'fixed'        => { "fixed" },
   'for'          => { "for ( ... ) { ... }" },
   'foreach'      => { "foreach ( ... ) { ... }" },
   'foreach_reverse' => { "foreach_reverse ( ... ) { ... }" },
   'function'     => { "function" },
   'if'           => { "if ( ... ) { ... }" },
   'import'       => { "import" },
   'in'           => { "in { ... }" },
   'int'          => { "int" },
   'interface'    => { "interface" },
   'invariant'    => { "invariant { ... }" },
   'main'         => { "void main (char[][] args) { ... }" },
   'mixin'        => { "mixin" },
   'module'       => { "module" },
   'out'          => { "out { ... }" },
   'override'     => { "override" },
   'package'      => { "package" },
   'private'      => { "private" },
   'protected'    => { "protected" },
   'public'       => { "public" },
   'return'       => { "return" },
   'struct'       => { "struct" },
   'switch'       => { "switch ( ... ) { ... }" },
   'synchronized' => { "synchronized" },
   'super'        => { "super" },
   'template'     => { "template  ( ... ) { ... }" },
   'try'          => { "try { ... } catch ( ... ) { ... }" },
   'typeid'       => { "typeid" },
   'typeof'       => { "typeof" },
   'typedef'      => { "typedef" },
   'union'        => { "union  { ... }" },
   'unittest'     => { "unittest { ... }" },
   'version'      => { "version ( ... ) { ... }" },
   'volatile'     => { "volatile" },
   'while'        => { "while ( ... ) { ... }" },
   'with'         => { "with ( ... ) { ... }" },
};

static SYNTAX_EXPANSION_INFO ansic_space_words:[] = {
   '#define'          => { "#define" },
   '#elif'            => { "#elif" },
   '#else'            => { "#else" },
   '#endif'           => { "#endif" },
   '#error'           => { "#error" },
   '#if'              => { "#if" },
   '#ifdef'           => { "#ifdef" },
   '#ifndef'          => { "#ifndef" },
   '#include'         => { "#include" },
   '#pragma'          => { "#pragma" },
   '#undef'           => { "#undef" },
   'break'            => { "break;" },
   'case'             => { "case" },
   'catch'            => { "catch ( ... ) { ... }" },
   'continue'         => { "continue;" },
   'default'          => { "default:" },
   'do'               => { "do { ... } while ( ... );" },
   'else if'          => { "else if ( ... ) { ... }" },
   'else'             => { "else { ... }" },
   'enum'             => { "enum" },
   'for'              => { "for ( ... ) { ... }" },
   'if'               => { "if ( ... ) { ... }" },
   'main'             => { "main(int argc, char *argv[]) { ... }" },
   'printf'           => { "printf(\"" },
   'return'           => { "return" },
   'struct'           => { "struct" },
   'switch'           => { "switch ( ... ) { ... }" },
   'typedef'          => { "typedef" },
   'union'            => { "union" },
   'while'            => { "while ( ... ) { ... }" },
};

static SYNTAX_EXPANSION_INFO objc_space_words:[] = {
   '#define'          => { "#define" },
   '#elif'            => { "#elif" },
   '#else'            => { "#else" },
   '#endif'           => { "#endif" },
   '#error'           => { "#error" },
   '#if'              => { "#if" },
   '#ifdef'           => { "#ifdef" },
   '#ifndef'          => { "#ifndef" },
   '#include'         => { "#include" },
   '#import'          => { "#import" },
   '#pragma'          => { "#pragma" },
   '#undef'           => { "#undef" },

   '@catch'           => { "@catch" },
   '@class'           => { "@class" },
   '@defs'            => { "@defs" },
   '@dynamic'         => { "@dynamic" },
   '@encode'          => { "@encode" },
   '@end'             => { "@end" },
   '@finally'         => { "@finally" },
   '@implementation'  => { "@implementation ... @end" },
   '@interface'       => { "@interface ... @end" },
   '@package'         => { "@package" },
   '@private'         => { "@private" },
   '@property'        => { "@property" },
   '@protected'       => { "@protected" },
   '@protocol'        => { "@protocol ... @end" },
   '@public'          => { "@public" },
   '@selector'        => { "@selector" },
   '@synchronized'    => { "@synchronized" },
   '@synthesize'      => { "@synthesize" },
   '@throw'           => { "@throw" },
   '@try'             => { "@try" },

   'break'            => { "break;" },
   'case'             => { "case" },
   'catch'            => { "catch ( ... ) { ... }" },
   'continue'         => { "continue;" },
   'default'          => { "default:" },
   'do'               => { "do { ... } while ( ... );" },
   'else if'          => { "else if ( ... ) { ... }" },
   'else'             => { "else { ... }" },
   'enum'             => { "enum" },
   'for'              => { "for ( ... ) { ... }" },
   'if'               => { "if ( ... ) { ... }" },
   'main'             => { "main(int argc, char *argv[]) { ... }" },
   'printf'           => { "printf(\"" },
   'return'           => { "return" },
   'self'             => { "self" },
   'struct'           => { "struct" },
   'super'            => { "super" },
   'switch'           => { "switch ( ... ) { ... }" },
   'typedef'          => { "typedef" },
   'union'            => { "union" },
   'while'            => { "while ( ... ) { ... }" },
};

static SYNTAX_EXPANSION_INFO googlego_space_words:[] = {
   'default'      => { "default:" },
   'else'         => { "else { ... }" },
   'for'          => { "for ... { ... )" },
   'func'         => { "func ... (...) ... { ... }" },
   'if'           => { "if ... { ... }" },
   'map'          => { "map[ ... ]..." },
   'select'       => { "select { ... }" },
   'switch'       => { "switch { ... }" },
};

_str _skip_pp;

int c_get_info(var Noflines,var cur_line,var first_word,var last_word,
               var rest,var non_blank_col,var semi,var prev_semi,
               boolean in_smart_paste=false)
{
   typeless old_pos;
   save_pos(old_pos);
   first_word='';last_word='';non_blank_col=p_col;
   int orig_col=p_col;
   int i,j;
   for (j=0;  ; ++j) {
      get_line_raw(cur_line);
      boolean bool = false;
      if (in_smart_paste) {
         _begin_line();
         i=verify(cur_line,' '\t);
         if ( i ) p_col=text_col(cur_line,i,'I');
         bool=cur_line!='' && (substr(strip(cur_line),1,1)!='#' || _skip_pp=='') && _clex_find(0,'g')!=CFG_COMMENT;
      } else {
         bool=cur_line!='' && (substr(strip(cur_line),1,1)!='#' || _skip_pp=='');
      }
      if ( bool){
         _str line;
         _str before_brace;
         parse cur_line with line '/*',p_rawpos; /* Strip comment on current line. */
         parse line with line '//',p_rawpos; /* Strip comment on current line. */
         parse line with before_brace '{',p_rawpos +0 last_word;
         parse strip(line,'L') with first_word '[({:; \t]',(p_rawpos'r') +0 rest;
         last_word=strip(last_word);

         updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT | AFF_BEGIN_END_STYLE);
         int syntax_indent=p_SyntaxIndent;
         if (last_word=='{' && (p_begin_end_style != VS_C_OPTIONS_STYLE2_FLAG)) {
            save_pos(auto p2);
            p_col=text_col(before_brace);
            _clex_skip_blanks('-');
            int status=1;
            if (get_text()==')') {
               status=_find_matching_paren(def_pmatch_max_diff);
            }
            if (!status) {
               status=1;
               if (p_col==1) {
                  up();_end_line();
               } else {
                  left();
               }
               _clex_skip_blanks('-');
               if (_clex_find(0,'g')==CFG_KEYWORD) {
                  int junk;
                  _str kwd=cur_word(junk);
                  status=(int) !pos(' 'kwd' ',' with if elsif elseif while switch for foreach lock using ');
               }
            }
            if (status) {
               non_blank_col=text_col(line,pos('[~ \t]|$',line,1,p_rawpos'r'),'I');
               restore_pos(p2);
            } else {
               get_line_raw(line);
               non_blank_col=text_col(line,pos('[~ \t]|$',line,1,p_rawpos'r'),'I');
               /* Use non blank of start of if, do, while, which, or for. */
            }
         } else {
            non_blank_col=text_col(line,pos('[~ \t]|$',line,1,p_rawpos'r'),'I');
         }
         Noflines=j;
         break;
      }
      if ( up() ) {
         restore_pos(old_pos);
         return(1);
      }
      if (j>=100) {
         restore_pos(old_pos);
         return(1);
      }
   }
   if (in_smart_paste) {
      if (!j) p_col=orig_col;
   }
   typeless p='';
   if ( j ) {
      p=1;
   }
   semi=stat_has_semi(p);
   prev_semi=prev_stat_has_semi();
   restore_pos(old_pos);
   return(0);
}


/**
 * Checks to see if the first thing on the current line is an
 * open brace.  Used by comment_erase (for reindentation).
 *
 * @return Whether the current line begins with an open brace.
 */
boolean c_is_start_block()
{
   save_pos(auto p);
   first_non_blank();
   _str word = get_text();
   restore_pos(p);

   return strieq(word, "{");
}

boolean _in_c_preprocessing()
{
   save_pos(auto p);
   //get_line(line);line=strip(line,'L');
   for (;;) {
      get_line(auto line);line=strip(line,'L');
      if (substr(line,1,1)=="#") {
         restore_pos(p);
         return(true);
      }
      up();
      if (_on_line0()) {
         restore_pos(p);
         return(false);
      }
      //get_line(line);line=strip(line,'L');
      _end_line();left();
      if (get_text()=='\') {
      //if (last_char(line)=='\') {
         _end_line();left();
         int cfg=_clex_find(0,'g');
         if (cfg==CFG_COMMENT && cfg==CFG_STRING) {
            restore_pos(p);
            return(false);
         }
      } else {
         restore_pos(p);
         return(false);
      }
   }

}

static boolean c_expand_enter_block(int syntax_indent, int be_style)
{
   if (p_col > _text_colc(0,'E')) {
      return(false);
   }
   save_pos(auto p);
   search('[~ \t]|$','@rh');
   cfg := _clex_find(0,'g');
   if (cfg != CFG_COMMENT && cfg != CFG_STRING) {
      ch := get_text();
      if (ch == '}') {
         right();
         col := c_endbrace_col();
         restore_pos(p);
         if (col) {
            indent_on_enter(0, col);
            get_line(auto line);
            replace_line(indent_string(col-1):+strip(line));
            return(true);
         }
      } else if (ch == '{') {
         save_pos(auto p2);
         col := find_block_col();
         if (!col) {
            restore_pos(p2);
            col = c_begin_stat_col(true,true,true);
         }
         restore_pos(p);
         if (col) {
            if (be_style == BES_BEGIN_END_STYLE_3) {
               col += syntax_indent;
            }
            indent_on_enter(0, col);
            get_line(auto line);
            replace_line(indent_string(col-1):+strip(line));
            return(true);
         }
      }
   }
   restore_pos(p);
   return(false);
}

/**
 * @return non-zero number if pass through to enter key required
 */
boolean _c_expand_enter()
{
   // special handling for objective-c
   boolean is_objc = _LanguageInheritsFrom('m');

   updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT | AFF_BEGIN_END_STYLE);
   syntax_indent := p_SyntaxIndent;
   be_style := p_begin_end_style;
   expand := LanguageSettings.getSyntaxExpansion(p_LangId);

   int indent_case = -1;

   save_pos(auto p);
   int orig_linenum=p_line;
   int orig_col=p_col;
   _str enter_cmd=name_on_key(ENTER);
   boolean line_splits=_will_split_insert_line();
   if (enter_cmd=='nosplit-insert-line') {
      _end_line();
   }
   if (_in_c_preprocessing()) {
      restore_pos(p);
      return(true);
   }

   if (line_splits
       && enter_cmd != 'nosplit-insert-line'
       && should_expand_cuddling_braces(p_LangId)) {
      startline := p_line;
      _clex_skip_blanks();
      if (get_text_safe() == '}' && startline == p_line) {
         save_pos(auto rb_pos);
         restore_pos(p);
         prev_char();
         _clex_skip_blanks('-');
         if (get_text_safe() == '{' && startline == p_line) {
            restore_pos(rb_pos);
            c_expand_enter_block(syntax_indent, be_style);
         }
      }
      restore_pos(p);
   }

   if (line_splits && c_expand_enter_block(syntax_indent, be_style)) {
      return(0);
   }

   int begin_col=c_begin_stat_col(false /* No RestorePos */,
                                  false /* Don't skip first begin statement marker */,
                                  false /* Don't return first non-blank */,
                                  1  /* Return 0 if no code before cursor. */,
                                  false,
                                  1
                                  );
// say('_c_expand_enter begin_col='begin_col', orig_col='orig_col);
   if (!begin_col /*|| (p_line>orig_linenum)*/) {
      restore_pos(p);
      return(true);
   }
   int status=0;
   boolean LineEndsWithBrace=false;
   int java=0;
   if (_LanguageInheritsFrom('java') || _LanguageInheritsFrom('cs')) {
      java=1;
   } else if (_LanguageInheritsFrom('js') || _LanguageInheritsFrom('cfscript')) {
      java=2;
   }
   if (p_line>orig_linenum) {
      if (p_col==1) {
         up();_end_line();
      } else {
         left();
      }
      _clex_skip_blanksNpp("-");
      LineEndsWithBrace= (orig_linenum==p_line && get_text()=='{');
      first_non_blank();
   } else if (p_line==orig_linenum && begin_col<0) {
      LineEndsWithBrace= (orig_linenum==p_line && get_text()=='{');
      first_non_blank();
   }
   int col=0,first_word_col=p_col;
   int junk=0;
   _str first_word=cur_word(junk);
   int first_word_color=_clex_find(0,'g');
   _str cur_line, line, orig_line;
   get_line_raw(cur_line);
   boolean BeginningOfStatementOnSameLine=(orig_linenum==p_line);
   restore_pos(p);
   enter_cmd=name_on_key(ENTER);

// say("first_word="first_word", splits="line_splits", orig_line="cur_line);

   if (is_objc || p_LangId == 'java') {
      // Check for special case of initial block indent.
      // This may be embedded inside of function or method calls,
      // so we can't just check for brace at the end of the line.
      br_pos := pos('\{[\] \t\)]*$', cur_line, 1, 'R');

      if (br_pos
          && orig_col > br_pos) {
         indent_on_enter(p_SyntaxIndent, c_indent_col2(begin_col, false));
         return 0;
      }
   }

   // Re-indent member-access keywords for objective-c.
   if (first_word_color == CFG_KEYWORD
       && is_objc
       && _c_is_member_access_kw('@'first_word)
       && (orig_col <= (first_word_col-1)
           || orig_col >= (first_word_col + length(first_word)))) {
      save_pos(p);
      tcol := c_smartpaste(true, first_word_col, 1);
      restore_pos(p);
      get_line_raw(auto newl);
      replace_line_raw(indent_string(tcol-1) :+ strip(newl));

      if (orig_col <= first_word_col) {
         begin_line();
      } else {
         end_line();
      }
   }

   if ( BeginningOfStatementOnSameLine &&
        !(_expand_tabsc(orig_col)!="" && line_splits) &&
        first_word_color==CFG_KEYWORD
        ) {
      if ( expand && cur_line=='main' && !java) {
         status=c_insert_main();
      } else if ( first_word=='for' && name_on_key(ENTER):=='nosplit-insert-line' ) {
         if ( name_on_key(ENTER):=='nosplit-insert-line' ) {
            /* tab to fields of C for statement */
            p_col=orig_col;
            line=expand_tabs(cur_line);
            int semi1_col=pos(';',line,p_col,p_rawpos);
            if ( semi1_col>0 && semi1_col>=p_col ) {
               p_col=semi1_col+1;
            } else {
               int semi2_col=pos(';',line,semi1_col+1,p_rawpos);
               if ( (semi2_col>0) && (semi2_col>=p_col) ) {
                  p_col=semi2_col+1;
               } else {
                  status=1;
               }
            }
         } else {
            status=1;
         }
      } else if ( (first_word=='case' || first_word=='default') &&
                 (orig_col>first_word_col ||
                  enter_cmd=='nosplit-insert-line') ) {
         _str eol='';
         if (indent_case<0) {
            updateAdaptiveFormattingSettings(AFF_INDENT_CASE);
            indent_case=beaut_case_indent(p_LangId);
         }
         if (line_splits){
            get_line_raw(orig_line);
            eol=expand_tabs(orig_line,p_col,-1,'s');
            replace_line_raw(expand_tabs(orig_line,1,p_col-1,'s'));
         }
         /* Indent case based on indent of switch. */
         col=_c_last_switch_col();
         if ( col && eol:=='') {
            if (indent_case && indent_case != '') {
               col = col + indent_case;
            } 
            if (beaut_style_for_keyword(p_LangId, 'switch', auto jfound) == BES_BEGIN_END_STYLE_3) {
               col=col+syntax_indent;
            }
            replace_line_raw(indent_string(col-1):+""strip(cur_line,'L'));
            _end_line();
         }
         indent_on_enter(syntax_indent);
         if (eol:!='') {
            replace_line_raw(indent_string(p_col-1):+eol);
         }
      } else if ( first_word=='switch' && LineEndsWithBrace) {
         if (indent_case<0) {
            updateAdaptiveFormattingSettings(AFF_INDENT_CASE);
            indent_case=beaut_case_indent(p_LangId);
         }
         down();
         get_line_raw(line);
         up();
         int extra_case_indent=0;
         if ((indent_case && indent_case!='') || (be_style&VS_C_OPTIONS_STYLE2_FLAG)) {
            extra_case_indent=indent_case;
         }
         indent_on_enter(syntax_indent);
         get_line_raw(line);
         if ( expand && line=='' ) {
            col=p_col-syntax_indent;
            replace_line_raw(indent_string(col-1+extra_case_indent)'case ');
            _end_line();
            c_maybe_list_args(true);
         }
     } else {
       status=1;
     }
   } else {
     status=1;
   }

   if (!status) {
      // notify user that we did something unexpected
      notifyUserOfFeatureUse(NF_SYNTAX_EXPANSION);
   }

   if (status && line_splits && is_objc) {
      col = m_indent_col(syntax_indent);
      if (col > 0) {
         indent_on_enter(0,col);
         return(0);

      } else if (!col) {
         return(0);
      }
   }

   if ( status ) {  /* try some more? Indenting only. */
      status=0;
      col=c_indent_col2(0,0);
      indent_on_enter(0,col);
   }

   return(status != 0);
}

/**
 * Searches backwards for the column position 
 * of the block declaration/statement that is introduced by the 
 * 'intro_keywords' regex.
 * 
 * @param intro_keywords Keywords that introduce the statement. 
 *                       ex: 'class|struct'.  Used in slickedit
 *                       regex, so be sure to escape any '@' in
 *                       objective-c keywords.
 * 
 * @return int Column position for the beginning of the 
 *         statement.
 */
int _c_last_enclosing_control_stmt(_str intro_keywords, _str& kw_found, long* found_offset = null) {
   if (p_lexer_name=='') {
      return(0);
   }
   save_pos(auto p);
   // Find switch at same brace level
   // search for begin brace,end brace, and switch not in comment or string
   int status=search('\{|\}|' :+ intro_keywords,'@rh-');
   int level=0;
   for (;;) {
      if (status) {
         restore_pos(p);
         return(0);
      }
      _str word=get_match_text();
      int color=_clex_find(0,'g');
      //messageNwait('word='word);
      if (color!=CFG_STRING && color!=CFG_COMMENT) {
         switch (word) {
         case '}':
            --level;
            break;
         case '{':
            ++level;
            break;
         default:
            if (color==CFG_KEYWORD && level== 1) {
               int result=p_col;
               kw_found = cur_word(auto junk);
               if (found_offset) {
                  *found_offset = _QROffset();
               }
               restore_pos(p);
               return(result);
            }
         }
      }
      status=repeat_search();
   }
}

boolean _c_is_member_access_kw(_str w) {
   return (w == 'public:' ||
           w == 'private:' ||
           w == 'protected:' ||
           w == 'signals:' ||
           w == 'slots:' ||
           (p_LangId == 'm' &&
               (w == '@public' ||
                   w == '@private' ||
                   w == '@protected' ||
                   w == '@package')));
}

/**
 * Returns the entire word from the cursor, 
 * including any punctuation that might be attached 
 * to the word if it were a keyword.  (':' for access 
 * modifiers, '@' for objective-c).  Does not guarantee 
 * the word is actually a keyword for the language. Can be used 
 * with _c_is_member_access_kw.  Returns empty string on 
 * failure. 
 * 
 * @return _str 
 */
_str _c_get_wordplus( ) {
   _str rv = '';
   save_search(auto s1, auto s2, auto s3, auto s4, auto s5);
   save_pos(auto p1);
   idre := '[a-zA-z:]#';
   if (p_LangId == 'm') {
      idre = '\@?'idre;
   }

   start := _QROffset();
   if (search('{'idre'}', 'r@<') == 0) {
      if (start == _QROffset()) {
         // If we moved, we've jumped ahead to another token most likely.
         rv = get_text(match_length('0'), match_length('S0'));
      }
   }

   restore_pos(p1);
   restore_search(s1, s2, s3, s4, s5);
   return rv;
}


/**
 * @return int Column position of last enclosing 
 *         class/struct/union/@interface
 */
int _c_last_struct_col(_str& kw_found) {
   return _c_last_enclosing_control_stmt('class|struct|union|\@interface', kw_found);
}


/**
 * @return Return column position on switch or 0 if not found
 */
int _c_last_switch_col() {
   _str junk;
   return _c_last_enclosing_control_stmt('switch', junk);
}

static int NoSyntaxIndentCase(int non_blank_col,int orig_linenum,int orig_col,typeless p,int syntax_indent)
{
   //_message_box("This case not handled yet");
   // SmartPaste(R) should set the non_blank_col
   if (non_blank_col) {
      //messageNwait("fall through case 1");
      restore_pos(p);
      return(non_blank_col);
   }
   restore_pos(p);
   int begin_stat_col=c_begin_stat_col(false /* No RestorePos */,
                                       false /* Don't skip first begin statement marker */,
                                       true  /* Don't return first non-blank */
                                       );

   if (begin_stat_col && (p_line<orig_linenum ||
                          (p_line==orig_linenum && p_col<=orig_col)
                         )
      ) {
#if 0
      /*
          We could have code at the top of a file like the following:

             int myproc(int i)<ENTER>

             int myvar=<ENTER>
             class foo :<ENTER>
                public name2

      */
      //messageNwait("fall through case 2");
      restore_pos(p);
      return(begin_stat_col);
#endif
      /*
         Check if partial statement ends with close paren.  This
         could be a function declaration.

         Another to handle this is to to indent any way and then
         move the open brace to the correct colmun position when
         the users types it.
      */
      save_pos(auto p2);
      p_line=orig_linenum;p_col=orig_col;
      if (p_col==1) {
         up();_end_line();
      } else {
         left();
      }
      int status=_clex_skip_blanksNpp("-");
      if (status) {
         restore_pos(p);
         return(orig_col);
      }
      _str ch=get_text();
      if (ch:==")") {
         restore_pos(p);
         return(begin_stat_col);
      }
      restore_pos(p2);
      /*
         Here we have something like
         int i;
            int k,<ENTER>
               <Cursor goes here>
               OR
         VOID<ENTER>
         <Cursor goes here>myproc()
      */
      int col=p_col;
      // Here we assume that functions start in column 1 and
      // variable declarations or statement continuations do not.
      // This seems to be a common solution.
      if (p_col==1 && ch!=',') {
         restore_pos(p);
         return(col);
      }
      int nextline_indent=syntax_indent;
      restore_pos(p);
      return(col+nextline_indent);
   }
   restore_pos(p);
   get_line(auto line);
   line=expand_tabs(line);
   if (line=="") {
      restore_pos(p);
      return(p_col);
   }
   //messageNwait("fall through case 3");
   first_non_blank();
   int col=p_col;
   restore_pos(p);
   return(col);
}
/**
 * Skip blanks and preprocessing
 *
 * @param options    search options for {@link _clex_find} and {@link search()}
 *
 * @return 0 on success, nonzero otherwise
 */
int _clex_skip_blanksNpp(_str options='')
{
   int MaxSkipPreprocessing=VSCODEHELP_MAXSKIPPREPROCESSING;
   int backwards=pos('-',options);
   for (;;) {
      int status=_clex_skip_blanks(options);
      if (status) {
         return(status);
      }
      /*if (p_line>FailIfPastLinenum) {
         messageNwait("p_line="p_line" FailIfPastLinenum="FailIfPastLinenum);
         return(STRING_NOT_FOUND_RC);
      }*/
      if (!_in_c_preprocessing()) {
         return(status);
      }
      --MaxSkipPreprocessing;
      if (MaxSkipPreprocessing<=0) {
         return(STRING_NOT_FOUND_RC);
      }
      if (backwards) {
         up();_end_line();
      } else {
         _end_line();
      }
   }
}
static int HandlePartialStatement(int statdelim_linenum,
                                  int sameline_indent,
                                  int nextline_indent,
                                  int orig_linenum,int orig_col)
{
   _str orig_ch=get_text();
   typeless orig_pos;
   save_pos(orig_pos);
   //linenum=p_line;col=p_col;

   /*
       Note that here we don't return first non-blank to handle the
       following case:

       for (;
            ;<ENTER>) {

       However, this does effect the following unusual case
           if (i<j) {abc;<ENTER>def;
           <end up here which is not correct>

       We won't worry about this case because it is unusual.
   */
   int begin_stat_col=c_begin_stat_col(false /* No RestorePos */,
                                       false /* Don't skip first begin statement marker. */,
                                       false /* Don't return first non-blank */,
                                       false,
                                       false,
                                       1   // Fail if no text after cursor
                                       );
   if (begin_stat_col>0 && (p_line<orig_linenum || (p_line==orig_linenum && p_col<orig_col))
        /* && (linenum!=p_line || col!=p_col) */
      ) {
      // Now get the first non-blank column.
      begin_stat_col=c_begin_stat_col(false /* No RestorePos */,
                                      false /* Don't skip first begin statement marker. */,
                                      true /* Return first non-blank */
                                      );
      /*
         Check if partial statement ends with close paren.  This
         could be a function declaration.

         Another to handle this is to to indent any way and then
         move the open brace to the correct colmun position when
         the users types it.
      */
      save_pos(auto p);
      p_line=orig_linenum;p_col=orig_col;
      if (p_col==1) {
         up();_end_line();
      } else {
         left();
      }
      _clex_skip_blanksNpp("-");
      _str ch=get_text();
      if (ch:==")") {
         return(begin_stat_col);
      }
      if (orig_ch:=='}' && ch:==',' && statdelim_linenum==p_line) {
         /*
             Also check if this line ends with a comma and handle the
             case where the user is in a declaration list like
             the following.

             MYSTRUCT array[]={
                {a,b,c},<ENTER>
                a,
                {a,b,c},<ENTER>
                {a,b,c},a,b,<ENTER>
                {a,{a,b,c}},<ENTER>
                d,
                {a,
                 {a,b,c}},
                 x,<ENTER>
                },
                b,
         */
         restore_pos(orig_pos);
         int status=_find_matching_paren(def_pmatch_max_diff);
         if (!status) {
            first_non_blank();
            return(p_col);
         }
      }
      restore_pos(p);
      /*
         IF semicolon is on same line as extra characters

         Example
            {b=<ENTER>
      */
      if (p_line==statdelim_linenum) {
         return(begin_stat_col+sameline_indent);
      }
      /*
         Here we have something like
         int i;
            int k,<ENTER>
               <Cursor goes here>
               OR
         VOID<ENTER>
         <Cursor goes here>myproc()
      */
      int col=p_col;
      // Here we assume that functions start in column 1 and
      // variable declarations or statement continuations do not.
      // This seems to be a common solution.
      if (p_col==1 && ch!=','
          && LanguageSettings.getIndentFirstLevel(p_LangId)) {
         return(col);
      }
      return(col+nextline_indent);
   }
   return(0);
}

/**
 * NOTE:  The caller should check if the user is calling this
 * function when inside a comment (use _in_comment(1) function).
 *
 * @param non_blank_col        All parameters are ignored except
 *                             non_blank_col.  Specify non_blank_col==0
 *                             if you want it ignored too.
 * @param pasting_open_block  ignored
 *
 * @return indent column
*/
int c_indent_col(int non_blank_col,boolean pasting_open_block)
{
   return(c_indent_col2(non_blank_col, pasting_open_block));
}

int cs_indent_col(int non_blank_col,boolean pasting_open_block)
{
   return(c_indent_col(non_blank_col, pasting_open_block));
}

static boolean _isQmarkExpression()
{
   // cursor is sitting colon
   /*
      could have
                (c)?s:t,
                MYCLASS():a(1),b(2) {
             class name1:public<ENTER>

            default :
            case 'a':
            case ('a'+'b')-1:
            public:
            private:
            protected:
      Give up on } for now.
   */
   in_objectivec := _LanguageInheritsFrom('m');
   int status=search('[?;})\[]|class|default|case|public|private|protected','-@rhxcs');
   for (;;) {
      if (status) {
         return(false);
      }
      switch(get_match_text()) {
      case '?':
         return(true);
      case '[':
         if (!in_objectivec) {
            status=repeat_search();
            continue;
         }
         return(false);
      case ';':
      case '}':
         return(false);
      case ')':
         status=find_matching_paren(true);
         if (status) {
            return(false);
         }
         status=repeat_search();
         continue;
      default:
         if (_clex_find(0,'g')==CFG_KEYWORD) {
            status=repeat_search();
            continue;
         }
         return(false);
      }
   }
}
static boolean _isVarInitList(boolean checkEnum=false)
{
   /*
      Check for the array/struct initialization case by
      check for equal sign before open brace.  This won't
      work if preprocessing is present.

        int array[]={
           a,
           b,<ENTER>
           int a,
           b,
           c,


      object array[]={
         "a","b",
         "c",{"a",
            "b","c"
         }
      };

      also check for enum declaration like

      enum [class|struct] [id] [: type] {enum-list} [id];
      enum_flags [id] {enum-list} [id]
   */
   if (p_col==1) {
      up();_end_line();
   } else {
      left();
   }
   _clex_skip_blanksNpp('-');
   boolean in_init=(get_text()=='=' || get_text()==']' ||
                    get_text()==',' || get_text()=='{');
   if (!in_init && checkEnum) {
      save_search(auto s1,auto s2,auto s3,auto s4,auto s5);
      save_pos(auto p);
      status := search('[,;})]|(enum_flags|enum)', "-rh@XSC");
      if (!status) {
         switch(get_match_text()) {
         case 'enum_flags':
         case 'enum':
            if (_clex_find(0,'g') == CFG_KEYWORD) {
               in_init = true;
            }
            break;
         default:
            restore_pos(p);
            break;
         }
      }
      restore_search(s1,s2,s3,s4,s5);
   }
   return(in_init);
}
static void parse_template_args()
{
   int nesting=0;
   for (;;) {
      if (c_sym_gtk()=='>') {
         ++nesting;
      } else if (c_sym_gtk()=='<') {
         --nesting;
         if (nesting<=0) {
            c_prev_sym();
            return;
         }
      } else if (c_sym_gtk()=='') {
         return;
      }
      c_prev_sym();
   }
}
static int c_indent_col2(int non_blank_col,boolean pasting_open_block)
{
   int orig_col=p_col;
   int orig_linenum=p_line;
   int orig_embedded=p_embedded;
   int col=orig_col;

   save_pos(auto p);
   updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT | AFF_BEGIN_END_STYLE);
   int syntax_indent=p_SyntaxIndent;
   if ( syntax_indent<=0) {
      // Find non-blank-col
      return(NoSyntaxIndentCase(non_blank_col,orig_linenum,orig_col,p,0));
   }
   be_style := p_begin_end_style;
   ParameterAlignment := beaut_funcall_param_alignment(p_LangId);
   indent_fl := LanguageSettings.getIndentFirstLevel(p_LangId);
   boolean style3=be_style == BES_BEGIN_END_STYLE_3;

   if (pasting_open_block) {
      // Look for for,while,switch
      save_pos(auto p2);
      col= find_block_col();
      restore_pos(p2);
      if (col) {
         restore_pos(p);
         if (style3) {
            return(col+syntax_indent);
         }
         return(col);
      }
      /*
          Note:
             pasting open brace does not yet work well
             for style2 when pasting brace out side class/while/for/switch blocks.
             Braces are not indented.

             pasting open brace does not yet work well
             for style2!=2 when pasting braces for a class.  Braces
             end up indented when they are not supposed to be.
      */
   }

   // locals
   int cfg=0;
   int begin_stat_col=0;
   _str ch='';
   _str word='';
   int junk=0;
   _str line='';
   _str kwd='';
   typeless p2,p3;

/*
   beginning of statement
     {,},;,:

   cases
     -  in-comment or in-string
     - for (;;) <ENTER>


     - myproc(myproc() <ENTER>
     - myproc(a,<ENTER>
     - myproc(a);
     - if/while/for/switch (...) <ENTER>
     - (col1)myproc(a)<ENTER>
     - (col>1)myproc(a)<ENTER>
     - (col>1)myproc(a)<ENTER>
     - case a: <ENTER>
     - default: <ENTER>
     -  if (...) {<ENTER>
     -  if (...) <ENTER>
     -  if (...) ++i; else <ENTER>
     -  if (...) ++i; else <ENTER>
     -  myproc (...) {<ENTER>
     -  statement;
         {<ENTER>
     -  if (a && b
     -  if (a && b,b
     -  <ENTER>  no code above
     -  int a,
     -  if {
           }<ENTER>
     -  {
        }<ENTER>
     - for (;<ENTER>;<ENTER>)
     - for (<ENTER>;;<ENTER>)
     - for (i=1;i<j;<ENTER>
     - if (a<b) {
          x=1;
       } else if( sfsdfd) {<ENTER>}

     {sdfsdf;
      ddd


*/

   _str enter_cmd=name_on_key(ENTER);
   if (enter_cmd=='nosplit-insert-line') {
      _end_line();
   }
   /*
       Handle a few special cases where line begins with
         close brace, "case", "default","public", "private",
         and "protected".
   */
   {
      save_pos(p2);
      //first_non_blank();
      begin_word();
      if (orig_col<=p_col) {
         cfg=_clex_find(0,'g');
         if (cfg!=CFG_COMMENT && cfg!=CFG_STRING) {
            word=cur_word(junk);
            ch=get_text();
            if (ch=="}") {
               right();
               col=c_endbrace_col();
               if (col) {
                  restore_pos(p);
                  return(col);
               }
            } else if (cfg==CFG_KEYWORD || (word=='signals' && _LanguageInheritsFrom('c'))) {
               if (_LanguageInheritsFrom('c') && (word=='public' || word=='private' || word=='protected' || word=='signals')) {
                  int class_col=find_class_col(true);
                  if (class_col) {
                     ma_indent := beaut_member_access_indent(p_LangId);
                     class_col+=ma_indent;
                     if (beaut_style_for_keyword(p_LangId, 'class', auto jfound) == BES_BEGIN_END_STYLE_3) {
                        class_col += p_SyntaxIndent;
                     }
                     restore_pos(p);
                     return(class_col);
                  }
               } else if (word=='case' || word=='default') {
                  updateAdaptiveFormattingSettings(AFF_INDENT_CASE);
                  col=_c_last_switch_col();
                  if ( col) {
                     col = col + beaut_case_indent(p_LangId);
                     if (beaut_style_for_keyword(p_LangId, 'switch', auto jfound) == BES_BEGIN_END_STYLE_3) {
                        col = col + syntax_indent;
                     }
                     restore_pos(p);
                     return(col);
                  }
               }

            }
         }
      }
      restore_pos(p2);
   }

   // Are we in an embedded context?
   // Then find the beginning of the embedded code
   long embedded_start_pos=0;
   if (p_EmbeddedLexerName!='') {
      save_pos(p2);
      if (!_clex_find(0,'-S')) {
         embedded_start_pos=_QROffset();
      }
      restore_pos(p2);
   }

   in_csharp := _LanguageInheritsFrom('cs');
   in_javascript := _LanguageInheritsFrom('js');
   in_objectivec := _LanguageInheritsFrom('m');
   in_java := _LanguageInheritsFrom('java');
   in_go := _LanguageInheritsFrom('googlego');
   in_json := false;

   bracket_count := 0;
   int nesting=0;
   int OpenParenCol=0;
   int maybeInAttribute=0;
   if (p_col==1) {
      up();_end_line();
   } else if (!in_go || get_text() != \n) {
      left();
   }

   _str search_text = '[{;}:()\[\]]|with|if|elsif|elseif|while|lock|for|foreach|switch|using';
   if (in_objectivec) {
      // indent rules for objective-c directive
      search_text = search_text :+ '|'OBJECTIVEC_CLASS_KEYWORDS_RE;
   } else if (in_java) {
      search_text = search_text :+ '|\@';
   } else if (in_go) {
      search_text = search_text :+ '|{'\n'}';
   }

   int status=search(search_text,"@rh-");
   for (;;) {
      if (status) {
         if (nesting<0) {
            restore_pos(p);
            return(OpenParenCol+1/*+def_c_space_after_paren*/);
         }
         return(NoSyntaxIndentCase(non_blank_col,orig_linenum,orig_col,p,syntax_indent));
      }

      if (_QROffset() < embedded_start_pos && p_embedded) {
         // we are embedded in HTML and hit script start tag
         //return(NoSyntaxIndentCase(non_blank_col,orig_linenum,orig_col,p,syntax_indent));
         restore_pos(p);
         if (nesting<0) {
            return(OpenParenCol+1/*+def_c_space_after_paren*/);
         }
         /* Cases:
              <%
                  <ENTER>
              %>
              <? <ENTER>
              ?>
              <script ...> <ENTER>
              </script>

             <cfif
                 IsDate(...) and<ENTER>
             </cfif>
         */
         _str orig_EmbeddedLexerName=p_EmbeddedLexerName;
         // Look for first non blank that is in this embedded language
         first_non_blank();
         int ilen=_text_colc();
         //_message_box('xgot here');
         for(;;) {
            if (p_col>ilen) {
               //_message_box('got here');
               return(orig_col);
            } else if (orig_EmbeddedLexerName==p_EmbeddedLexerName && get_text():!=' ') {
               //refresh();_message_box('break col='p_col' l='p_line);
               break;
            }
            ++p_col;
         }
         col=p_col;
         restore_pos(p);
         return(col);
      }

      cfg=_clex_find(0,'g');
      if (cfg==CFG_COMMENT || cfg==CFG_STRING) {
         status=repeat_search();
         continue;
      }

      ch=get_text();
      //messageNwait('ch='ch);
      switch (ch) {
      case ']':  // maybe C# attribute
         if (in_csharp && !_in_function_scope()) {
            ++maybeInAttribute;
         }
         if (in_objectivec && _in_function_scope()) {
            --bracket_count;
         }
         status=repeat_search();
         continue;
      case '[':
         // maybe C# attribute
         if (in_csharp && !_in_function_scope()) {
            --maybeInAttribute;
            if (maybeInAttribute == 0 && p_col == _first_non_blank_col()) {
               col = p_col;
               restore_pos(p);
               return(col);
            }
         }

         // maybe objective-c message expression [object method]
         if (in_objectivec && _in_function_scope()) {
            ++bracket_count;
            if (bracket_count > 0) {
               if (!_objectivec_index_operator()) {
                  if (ParameterAlignment == COMBO_AL_CONT) {
                     first_non_blank();
                     col = p_col + beaut_continuation_indent(p_LangId);
                     restore_pos(p);
                     return(col);
                  }
                  col = p_col + 1;
                  restore_pos(p);
                  return(col);
               }
            }
         }
         status=repeat_search();
         continue;
      case '(':
         if (!nesting && !OpenParenCol) {
            save_pos(p3);
#if 1
            save_search(auto ss1,auto ss2,auto ss3,auto ss4,auto ss5);
            col=p_col;
            ++p_col;
            status=_clex_skip_blanksNpp();

            if (ParameterAlignment == COMBO_AL_AUTO) {
               if (!status 
                   && (p_line<orig_linenum 
                       || (p_line==orig_linenum && p_col<orig_col))) {
                  ParameterAlignment = COMBO_AL_PARENS;
               } else {
                  ParameterAlignment = COMBO_AL_CONT;
               }
            }
            switch (ParameterAlignment) {
            case COMBO_AL_PARENS:
               col=p_col-1;
               break;

            case COMBO_AL_CONT:
            default:
               /*
                  case: Use continuation indent instead of lining up on
                  open paren.

                  aButton.addActionListener(<Enter here. No args follow>
                      a,
                      b,
               */
               restore_pos(p3);
               goto_point(_nrseek()-1);
               //if (_clex_skip_blanks('-')) return(0);
               //word=cur_word(junk);
               c_prev_sym2();
               if (c_sym_gtk()=='>') {
                  parse_template_args();
               }
               if (c_sym_gtk()==TK_ID && !pos(' 'c_sym_gtkinfo()' ',' with for foreach if elsif elseif switch while lock using ')) {
                  restore_pos(p3);
                  first_non_blank();
                  col=p_col+beaut_continuation_indent(p_LangId)-1;
               }
               break;
            }
            restore_search(ss1,ss2,ss3,ss4,ss5);
#else
            save_search(auto ss1,auto ss2,auto ss3,auto ss4,auto ss5);
            col=p_col;
            ++p_col;
            status=_clex_skip_blanksNpp();
            if (!status && (p_line<orig_linenum ||
                            (p_line==orig_linenum && p_col<=orig_col)
                           )) {
               col=p_col-1;
            }
            restore_search(ss1,ss2,ss3,ss4,ss5);
#endif
            OpenParenCol=col;
            restore_pos(p3);
         }
         --nesting;
         status=repeat_search();
         continue;
      case ')':
         ++nesting;
         status=repeat_search();
         continue;

      case '@':
         if (in_objectivec && cfg == CFG_KEYWORD) {
            switch (get_match_text()) {
            case '@interface':
            case '@implementation':
            case '@protocol':
               // align to declaration column
               col = p_col;
               restore_pos(p);
               return(col);

            case '@package':
            case '@private':
            case '@protected':
            case '@public':
               if (beaut_indent_members_from_access_spec(p_LangId)) {
                  col = p_col;
                  restore_pos(p);
                  return syntax_indent + col;
               } else {
                  col = p_col;
                  restore_pos(p);
                  return col + syntax_indent - beaut_member_access_indent(p_LangId);
               }
               break;
               
            default:
               first_non_blank();
               col = p_col;
               restore_pos(p);
               return(col);
            }
         } else if (in_java) {
            // Don't treat it like a continuation indent.
            first_non_blank();
            col = p_col;
            restore_pos(p);
            return(col);
         }
         break;

      default:
         if (nesting<0) {
            //messageNwait("nesting case");
            restore_pos(p);
            return(OpenParenCol+1/*+def_c_space_after_paren*/);
         }
      }
      if (nesting ) {
         status=repeat_search();
         continue;
      }
      if (_in_c_preprocessing()) {
         begin_line();
         status=repeat_search();
         continue;
      }
      //messageNwait("c_indent_col2: ch="ch);
      switch (ch) {
      case '{':
         //messageNwait("case {");
         int openbrace_col=p_col;
         int statdelim_linenum=p_line;

         /*
            Could have
              for (;
                    ;) {<ENTER>

              myproc ( xxxx ) {<ENTER>

              myproc (xxx ) {
                 int i,<ENTER>

              {<ENTER>

              else {<ENTER>

              else
                 {<ENTER>

              class name : public name2 {<ENTER>

              if ( xxx ) {<ENTER>

              if ( xxx )
                 {<ENTER>

              if ( xxx )
              {<ENTER>

              int array[]={
                 a,
                 b,<ENTER>

         */
         save_pos(p2);

         if (in_objectivec) {
            // Handle "^{" or "^(typedecls) {"
            boolean is_block = false;

            left();
            _clex_skip_blanks('-');
            tok := get_text();
            if (tok == '^') {
               is_block = true;
            } else if (tok == ')') {
               find_matching_paren();
               left();
               _clex_skip_blanks('-');
               if (get_text() == '^') {
                  is_block = true;
               }
            }
            if (is_block) {
               col = c_begin_stat_col(false /* No RestorePos */,
                                     false /* Don't skip first begin statement marker */,
                                     false /* Don't return first non-blank */,
                                     1  /* Return 0 if no code before cursor. */,
                                     false,
                                     1);

               restore_pos(p);
               return col + beaut_initial_anonfn_indent(p_LangId);
            }
            restore_pos(p2);
         }

         prev_char();
         _clex_skip_blanks('-');
         first_non_blank();
         block_word := cur_word(auto junk1);
         if (block_word == 'namespace') {
            nscol := p_col;
            restore_pos(p);
            if (beaut_should_indent_namespace(p_LangId)) {
               return nscol+p_SyntaxIndent;
            } else {
               return nscol;
            }
         } else if (block_word == 'extern') {
            nscol := p_col;
            restore_pos(p);
            if (beaut_should_indent_extern(p_LangId)) {
               return nscol+p_SyntaxIndent;
            } else {
               return nscol;
            }
         }
         restore_pos(p2);

         if (_isVarInitList(true) || in_json) {
            restore_pos(p2);
            first_non_blank();
            col=p_col;
            restore_pos(p);
            return(col+p_SyntaxIndent);
#if 0
            restore_pos(p2);
            begin_stat_col=c_begin_stat_col(false /* No RestorePos */,
                                            true /* skip first begin statement marker */,
                                            true /* return first non-blank */
                                            );
            restore_pos(p2);
            // Now check if there are any characters between the
            // beginning of the previous statement and the original
            // cursor position
            col=HandlePartialStatement(statdelim_linenum,
                                       syntax_indent,0,
                                       orig_linenum,orig_col);
            if (col) {
               restore_pos(p);
               return(col);
            }
#endif
         }

         restore_pos(p2);

         if (p_col==1) {
            up();_end_line();
         } else {
            left();
         }
         _clex_skip_blanksNpp('-');
         status=1;
         if (get_text()==')') {
            status=_find_matching_paren(def_pmatch_max_diff);
            save_pos(p3);
         }
         if (!status) {
            status=1;
            if (p_col==1) {
               up();_end_line();
            } else {
               left();
            }
            _clex_skip_blanksNpp('-');
            if (_clex_find(0,'g')==CFG_KEYWORD) {
               kwd=cur_word(junk);
               status=(int) !pos(' 'kwd' ',' with if elsif elseif while lock switch for foreach catch using function ');
               // IF this is the beginning of a "if/while/switch/for" block
               if (!status) {
                  first_non_blank();
                  int block_col=p_col;
                  // Now check if there are any characters between the
                  // beginning of the previous statement and the original
                  // cursor position
                  restore_pos(p2);


                  col=HandlePartialStatement(statdelim_linenum,
                                             syntax_indent,syntax_indent,
                                             orig_linenum,orig_col);
                  if (col) {
                     restore_pos(p);
                     return(col);
                  }

                  restore_pos(p);
                  return(block_col+syntax_indent);
               }
            } else if (_LanguageInheritsFrom('java')) {
               /*

                   // case 1:  just blanks after open paren.  Use continuation indent.
                   aButton.addActionListener(
                       a,
                       b,
                       new ActionListener() {
                           public void actionPerformed(ActionEvent e) {
                               createdButtonFired(buttonIndex);
                           }
                       },
                       b,
                       );
                  // case 2:  First argument is new constructor
                  aButton.addActionListener(new ActionListener() {
                          public void actionPerformed(ActionEvent e) {
                              createdButtonFired(buttonIndex);
                          }
                      },
                      b,
                      );

               */
               // Check if we have a new construct
               kwd=cur_word(col);
               p_col=_text_colc(col,'I');
               if (p_col>1) {
                  left();
                  if (_clex_skip_blanks('-')) return(0);
                  word=cur_word(col);
                  if (word=='new') {
                     p_col=_text_colc(col,'I');
                     col=p_col;
                     first_non_blank();
                     if (col!=p_col) {
                        p_col+=p_SyntaxIndent;
                     }
                     col=p_col+p_SyntaxIndent;
                     restore_pos(p);
                     return(col);
                  }
               }
            }

            // Now check if there are any characters between the
            // beginning of the previous statement and the original
            // cursor position
            restore_pos(p2);
            col=HandlePartialStatement(statdelim_linenum,
                                       syntax_indent,syntax_indent,
                                       orig_linenum,orig_col);

            if (col) {
               restore_pos(p);
               return(col);
            }

            //  This open brace is to a function or method or some
            //  very strange preprocessing.
            restore_pos(p2); // Restore cursor to open brace
            first_non_blank();
            if (p_col==openbrace_col) {
               begin_stat_col=openbrace_col;
            } else {
               restore_pos(p3); // Restore cursor to open paren
               begin_stat_col=c_begin_stat_col(false /* No RestorePos */,
                                               false /* Don't skip first begin statement marker */,
                                               false /* Don't return first non-blank */
                                               );
               if ((be_style == BES_BEGIN_END_STYLE_3) && def_style3_indent_all_braces) {
                  begin_stat_col+=syntax_indent;
               }
            }

            if (begin_stat_col==1 && !indent_fl) {
               restore_pos(p);
               return(1);
            }
            restore_pos(p);
            if ((be_style == BES_BEGIN_END_STYLE_3) && def_style3_indent_all_braces) {
               return(begin_stat_col);
            }
            return(begin_stat_col+syntax_indent);
         }
         restore_pos(p2);
         // Now check if there are any characters between the
         // beginning of the previous statement and the original
         // cursor position


         // Now check if there are any characters between the
         // beginning of the previous statement and the original
         // cursor position
         restore_pos(p2);
         col=HandlePartialStatement(statdelim_linenum,
                                    syntax_indent,syntax_indent,
                                    orig_linenum,orig_col);
         if (col) {
            restore_pos(p);
            return(col);
         }

         /*
             Probably have one of these case here

              {<ENTER>

              else {<ENTER>

              else
                 {<ENTER>

              class name : public name2 {<ENTER>

              if (a<b) x=1; else {<ENTER>}

              if (a<b) {
                 x=1;
              } else {<ENTER>}

         */
         restore_pos(p2);
         if (style3) {
            first_non_blank();
            // IF the open brace is the first character in the line
            if (openbrace_col==p_col) {

               begin_stat_col=c_begin_stat_col(false /* No RestorePos */,
                                               true /* skip first begin statement marker */,
                                               true /* return first non-blank */
                                               );
               // IF there is stuff between the previous statement and
               //    this statement, we must be in a class/struct
               //    definition.  IF/While/FOR Etc. cases have been
               //    handled above.
               if (openbrace_col!=p_col || statdelim_linenum!=p_line) {
                  restore_pos(p);
                  return(begin_stat_col+syntax_indent);
               }
               // We could check here for extra stuff after the
               // open brace
               restore_pos(p);
               return(openbrace_col);
            }
            restore_pos(p2);
         }
         begin_stat_col=c_begin_stat_col(false /* No RestorePos */,
                                         true /* skip first begin statement marker */,
                                         true /* return first non-blank */
                                         );
         restore_pos(p);
         return(begin_stat_col+syntax_indent);

      case \n :
         left();
         _clex_skip_blanksNpp('-');
         cfg=_clex_find(0,'g');

         statdelim_linenum=p_line;
         begin_stat_col=c_begin_stat_col(false /* RestorePos */,
                                         true /* skip first begin statement marker */,
                                         true /* return first non-blank */
                                         );
         if (cfg == CFG_PUNCTUATION || cfg == CFG_OPERATOR) {

            // Now check if there are any characters between the
            // beginning of the previous statement and the original
            // cursor position
            col=HandlePartialStatement(statdelim_linenum,
                                       syntax_indent,syntax_indent,
                                       orig_linenum,orig_col);
            if (col) {
               restore_pos(p);
               return(col);
            }
         } 

         restore_pos(p);
         return(begin_stat_col);
      case ';':
         //messageNwait("case ;");
         save_pos(p2);

         // check for initializer or declaration
         // int a[] = { 1, 2, 3
         //     4, 5, 6 };
         status = -1;
         left();
         _clex_skip_blanksNpp('-');
         if (get_text() == '}') {
            brace_line := p_line;
            status = find_matching_paren(true);
            if (!status && (p_line == brace_line)) {
               status = -1;
            }
         }
         if (status) {
            restore_pos(p2);
         }
         offset := (int)point('s');
         statdelim_linenum=p_line;
         begin_stat_col=c_begin_stat_col(false /* RestorePos */,
                                    true /* skip first begin statement marker */,
                                    true /* return first non-blank */
                                    );
//       say("begin_stat_col="begin_stat_col);
         /* IF there is extra stuff before the beginning of this
               statement
            Example
                x=1;y=2;<ENTER>
                       OR
                for (x=1;<ENTER>
            NOTE:  The following code fragment does not work
                   properly.
                for (i=1;i<j;++i) ++i;<ENTER>
                for (i=1;
                     i<j;<ENTER>
         */
         word=cur_word(junk);
         if (in_objectivec) {
            // Indent for objective-c directive
            cfg = _clex_find(0,'g');
            if (cfg == CFG_KEYWORD && get_text() == '@') {
               switch ('@'word) {
               case '@optional':
               case '@required':
                  p_col += length(word) + 1; // fall-through to check for method decl

               case '@interface':
               case '@implementation':
               case '@protocol':
                  if (!_objectivec_find_next_class_decl(offset)) {
                     ch = get_text();
                     if (ch == '+'|| ch == '-') {  // start of method decl
                        begin_stat_col = p_col;
                     }
                  }
                  restore_pos(p);
                  return(begin_stat_col);

               case '@package':
               case '@private':
               case '@protected':
               case '@public':
                  if (beaut_indent_members_from_access_spec(p_LangId)) {
                     restore_pos(p);
                     return begin_stat_col + syntax_indent;
                  } else {
                     restore_pos(p);
                     return begin_stat_col + syntax_indent - beaut_member_access_indent(p_LangId);
                  }
                  break;

               case '@dynamic':
               case '@synthesize':
               case '@property':  
               case '@end':
               default:
                  restore_pos(p);
                  return(begin_stat_col);
               }
            }
         }
         if (word=='for') {
            // Here we try to indent after open brace for
            // loop unless the cursor is after the close paren.
            get_line_raw(line);line=expand_tabs(line);
            col=pos('(',line,1,p_rawpos);
            if (!col) {
               col=p_col;
               restore_pos(p);
               return(col+syntax_indent);
            }
            int result_col=col;
            p_col=col+1;
            search('[~ \t]','@rh');
            cfg=_clex_find(0,'g');
            if (get_text()!='' && cfg!=CFG_COMMENT && cfg!=CFG_STRING) {
               ++result_col;
            }
            p_col=col;
            status=find_matching_paren(true);
            // IF cursor is after close paren of for loop
            if (!status && (orig_linenum>p_line ||
                            (p_line==orig_linenum && orig_col>p_col)
                           )
               ) {
               // Cursor is after close paren of for loop.
               //messageNwait('f1');
               restore_pos(p);
               return(begin_stat_col);
            }
            // Align cursor after open brace of for loop
            restore_pos(p);
            return(result_col+1);
         }
         restore_pos(p2);

         // Now check if there are any characters between the
         // beginning of the previous statement and the original
         // cursor position
         col=HandlePartialStatement(statdelim_linenum,
                                    syntax_indent,syntax_indent,
                                    orig_linenum,orig_col);
         if (col) {
            restore_pos(p);
            return(col);
         }
         restore_pos(p);
         return(begin_stat_col);
      case '}':
         //messageNwait("case }");
         /*
            Don't forget to test

            if (i<j)
               {
               }<ENTER>

            if (i<j)
               {
               }
            else
               {
               }<ENTER>


         */
         statdelim_linenum=p_line;
         save_pos(p2);
         /*
            Check if we are in a variable initialization list.
            We don't want to handle this with the HandlePartialStatement statement.
             MYRECORD array[]={
                {a,b,c}
                ,{a,b,c},
                b,<ENTER>
                <End UP HERE, ALIGNED WITH b>

         */
         right();
         _clex_skip_blanks();
         if (get_text()==',') {
            restore_pos(p2);
         } else {
            restore_pos(p2);
            /* Now check if there are any characters between the
               beginning of the previous statement and the original
               cursor position

               Could have
                 struct name {
                 } name1, <ENTER>

                 myproc() {
                 }
                    int i,<ENTER>
            */
            col=HandlePartialStatement(statdelim_linenum,
                                       syntax_indent,syntax_indent,
                                       orig_linenum,orig_col);
            if (col) {
               restore_pos(p);
               return(col);
            }
         }



         /*
             Handle the following cases
             for (;;)
                 {
                 }<ENTER>

                 {
                 }<ENTER>

             MYRECORD array[]={
                {a,b,c}<ENTER>

             MYRECORD array[]={
                {a,b,c}
                ,{a,b,c}<ENTER>

         */
         restore_pos(p2);
         ++p_col;
         boolean style3_MustBackIndent=false;
         col=c_endbrace_col2(be_style, style3_MustBackIndent);
         if (col) {
            if (!style3 || !style3_MustBackIndent) {
               restore_pos(p);
               return(col);
            }
            col-=syntax_indent;
            if (col<1) col=1;
            restore_pos(p);
            return(col);
         }
         restore_pos(p2);
         if (!style3 || !style3_MustBackIndent) {
            col=p_col;
            restore_pos(p);
            return(col);
         }
         col=p_col-syntax_indent;
         if (col<1) col=1;
         restore_pos(p);
         return(col);
      case ':':
         //messageNwait("case :");
         if (_LanguageInheritsFrom('e')){
            // Watch out for :==,:!=, :+, :<=, :>=
            ch=get_text(1,(int)point('s')+1);
            if(ch=='=' || ch=='!' || ch=='<' || ch=='>' || ch=='+' ||  ch=='[' /* :[ ]  Slick-C operator*/) {
               status=repeat_search();
               continue;
            }
         }
         if (p_col!=1) {
            left();
            if (get_text()==":") {
               // skip ::
               //messageNwait('skip ::');
               status=repeat_search();
               continue;
            }
            right();
         }

         if (in_objectivec) {
            // This could be the colon in "@interface ClassName : Superclass
            save_pos(auto ip2);
            left();
            _clex_skip_blanks('-');
            begin_word();
            left();
            _clex_skip_blanks('-');
            begin_word();
            ty := _clex_find(0, 'G');
            if (ty == CFG_KEYWORD
                && cur_word(junk) == 'interface') {
               first_non_blank();
               col = p_col;
               restore_pos(p);
               return col;
            }
            restore_pos(ip2);

            // need to differentiate label, access modifer, or objc method argument
            _objectivec_message_statement(bracket_count, auto indent_col, auto bracket_col, auto arg_col, auto arg_count);
            if (indent_col > 0) {
               restore_pos(p);
               return(indent_col);
            }
            if (objectivec_inside_dict_literal()) {
               first_non_blank();
               col = p_col;
               restore_pos(p);
               return col;
            }
         }

         if (_LanguageInheritsFrom('as') || in_javascript) {
            // this could be part of an ActionScript declaration
            // var n:Number
            // function a(n:Number, b:Array
            //
            // this could be in Javascript object literal notation
            // var n = { a : 1, b : 1,
            in_json = in_javascript;
            status=repeat_search();
            continue;
         }

         save_pos(p2);
         typeless t1,t2,t3,t4;
         save_search(t1,t2,t3,t4);
         boolean bool=_isQmarkExpression();
         //messageNwait('isQmark='bool);
         restore_pos(p2);
         restore_search(t1,t2,t3,t4);
         if (bool) {
            //skip this question mark expression colon
            /*
               NOTE: We could handle the following case better here:
               myproc(b,
                     (c)?s:<ENTER>
                     )
               which is different from
               myproc(b,
                     (c)?s:t,<ENTER>
                     )
            */
            status=repeat_search();
            continue;
         }

         /* Now check if there are any characters between the
            beginning of the previous statement and the original
            cursor position

            Could have
             case 'a':
                 int i,<ENTER>

            MyConstructor(): a(1),<ENTER>b(2)
         */
         col=HandlePartialStatement(statdelim_linenum,
                                    syntax_indent,syntax_indent,
                                    orig_linenum,orig_col);
         if (col) {
            //messageNwait('c1');
            restore_pos(p);
            return(col);
         }
         //messageNwait('c2');

         restore_pos(p2);


         /*

             default:<ENTER>
             case ???:<ENTER>
             (abc)? a: b;<ENTER>
             class name1:public<ENTER>
         */
         begin_stat_col=c_begin_stat_col(false /* RestorePos */,
                                    true /* skip first begin statement marker */,
                                    true /* return first non-blank */,
                                    1
                                    );

//       say("colon begin_stat_col:"begin_stat_col);
         if (p_line==orig_linenum) {
            word=cur_word(junk);
            if (word=='case' || word=='default') {
               first_non_blank();
               // IF the 'case' word is the first non-blank on this line
               if (p_col==begin_stat_col) {
                  col=p_col;
                  restore_pos(p);
                  //messageNwait('c3');
                  return(col);
               }
            } else if (_c_is_member_access_kw(word)) {
               if (beaut_indent_members_from_access_spec(p_LangId)) {
                  restore_pos(p);
                  return begin_stat_col + syntax_indent;
               } else {
                  restore_pos(p);
                  return begin_stat_col + syntax_indent - beaut_member_access_indent(p_LangId);
               }
            }
         }
         //messageNwait('c4');
         restore_pos(p);
         return(begin_stat_col+syntax_indent);
      default:
         if (cfg==CFG_KEYWORD) {
            /*
               Cases
                 if ()
                    if () <ENTER>
                 for <ENTER>

            */
            first_non_blank();
            col=p_col+syntax_indent;
            restore_pos(p);
            return(col);
         }
      }

      status=repeat_search();
   }

}

int _c_get_syntax_completions(var words)
{
   typeless space_words;
   if (_LanguageInheritsFrom('phpscript')) {
      space_words = php_space_words;
   } else if (_LanguageInheritsFrom('idl')) {
      space_words = idl_space_words;
   } else if (_LanguageInheritsFrom('cs')) {
      space_words = cs_space_words;
   } else if (_LanguageInheritsFrom('js') || _LanguageInheritsFrom('cfscript')) {
      space_words = javascript_space_words;
   } else if (_LanguageInheritsFrom('java')) {
      space_words = java_space_words;
   } else if (_LanguageInheritsFrom('d')) {
      space_words = d_space_words;
   } else if (_LanguageInheritsFrom('ansic')) {
      space_words = ansic_space_words;
   } else if (_LanguageInheritsFrom('m')) {
      space_words = objc_space_words;
   } else {
      space_words = cpp_space_words;
   }

   return AutoCompleteGetSyntaxSpaceWords(words,space_words,0);
}
boolean c_else_followed_by_brace_else(_str word)
{
   // this must be an else if
   if (!pos('else',word) || !pos('if',word)) {
      return false;
   }

   int status=0;
   boolean found_brace_else=false;
   typeless p;
   typeless s1,s2,s3,s4;
   save_pos(p);
   save_search(s1,s2,s3,s4);

   first_non_blank();

   status=search('[^ \t\n\r]','@-rhXc');
   if (status || get_text() != '}') {
      restore_search(s1,s2,s3,s4);
      restore_pos(p);
      return false;
   }

   int close_brace_col = p_col;

   restore_pos(p);
   _end_line();
   status=search('[^ \t\n\r]','@rhXc');
   if (status==0 && get_text()=='}' && p_col == close_brace_col) {
      right();
      c_next_sym();
      if (c_sym_gtkinfo()=='else') {
         found_brace_else=true;
      }
   }

   restore_search(s1,s2,s3,s4);
   restore_pos(p);
   return found_brace_else;
}
// is the code above the current line (which contains 'while')
// a partial do {  } while loop?
boolean c_while_is_part_of_do_loop()
{
   // save search options and cursor position
   boolean found_do_loop = false;
   save_pos(auto p);
   save_search(auto s1,auto s2,auto s3,auto s4,auto s5);

   do {
      // back up from identifier
      up(); _end_line();
      status := _clex_skip_blanks('h-');
      if (status) {
         break;
      }

      // should find a brace block
      if (get_text() != '}') {
         break;
      }
      status = find_matching_paren(true);
      if (status) {
         break;
      }
      if (get_text() != '{') {
         break;
      }

      // skip backwards to keyword before brace block
      if (_QROffset() <= 0) {
         break;
      }
      _GoToROffset(_QROffset()-1);
      status = _clex_skip_blanks('h-');
      if (status) {
         break;
      }
      if (cur_identifier(auto start_col) == 'do') {
         found_do_loop = true;
      }

   } while (false);

   // restore search options and cursor position
   restore_search(s1,s2,s3,s4,s5);
   restore_pos(p);
   return found_do_loop;
}

static int c_expand_space()
{
   long expansion_start = _QROffset();
   long expansion_end   = 0;
   updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT | AFF_BEGIN_END_STYLE);
   syntax_indent := p_SyntaxIndent;
   indent_fl := LanguageSettings.getIndentFirstLevel(p_LangId);
   doSyntaxExpansion := LanguageSettings.getSyntaxExpansion(p_LangId);

   int status=0;
   _str orig_line='';
   get_line(orig_line);
   _str line=strip(orig_line,'T');
   _str orig_word=strip(line);
   if ( p_col!=text_col(_rawText(line))+1 ) {
      return(1);
   }
   set_surround_mode_start_line();
   boolean open_paren_case=(last_event()=='(');
   boolean semicolon_case=(last_event()==';');
   boolean if_special_case=false;
   boolean else_special_case=false;
   boolean pick_else_or_else_if=false;
   _str brace_before='';
   _str aliasfilename='';
   boolean is_java=false;
   boolean is_javascript=false;
   boolean is_idl=false;
   boolean is_php=false;
   boolean is_csharp=false;
   boolean is_dlang=false;
   boolean is_go=false;
   if (_LanguageInheritsFrom('java') || _LanguageInheritsFrom('cs') || _LanguageInheritsFrom('d')) {
      is_java=true;
   } else if (_LanguageInheritsFrom('js') || _LanguageInheritsFrom('cfscript') || _LanguageInheritsFrom('as')) {
      is_javascript=true;
      is_java=true;
   }
   _str word='';
   if (_LanguageInheritsFrom('phpscript')) {
      word=min_abbrev2(orig_word,php_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
      is_php=true;
   } else if (_LanguageInheritsFrom('idl')) {
      is_idl=true;
      word=min_abbrev2(orig_word,idl_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
   } else if (_LanguageInheritsFrom('cs')) {
      word=min_abbrev2(orig_word,cs_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
      is_csharp=true;
   } else if (_LanguageInheritsFrom('d')) {
      word=min_abbrev2(orig_word,d_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
      is_dlang=true;
   } else if (_LanguageInheritsFrom('ansic')) {
      word=min_abbrev2(orig_word,ansic_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
   } else if (_LanguageInheritsFrom('m')) {
      word=min_abbrev2(orig_word,objc_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
   } else if (_LanguageInheritsFrom('googlego')) {
      word=min_abbrev2(orig_word,googlego_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
      is_go = true;
   } else if (is_javascript) {
      word=min_abbrev2(orig_word,javascript_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
   } else if (is_java) {
      word=min_abbrev2(orig_word,java_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
   } else {
      word=min_abbrev2(orig_word,cpp_space_words,name_info(p_index),
                       aliasfilename,!open_paren_case,open_paren_case);
   }

   // can we expand an alias?
   if (!maybe_auto_expand_alias(orig_word, word, aliasfilename, auto expandResult)) {
      // if the function returned 0, that means it handled the space bar
      // however, we need to return whether the expansion was successful
      return expandResult;
   }

   if ( word=='' && doSyntaxExpansion) {
      // Check for } else
      _str first_word, second_word, rest;
      parse orig_line with first_word second_word rest;
      if (!def_always_prompt_for_else_if && first_word=='}' && second_word!='' && rest=='' && second_word=='else') {
         //Can't force user to use modal dialog insead of just typing "} else {"
         //We need a modeless dialog so user can keep typing.
         return(1);
      } else if (!def_always_prompt_for_else_if && second_word=='' && length(first_word)>1 && first_word:=='}else') {
         //Can't force user to use modal dialog insead of just typing "}else {"
         //We need a modeless dialog so user can keep typing.
         return(1);
      } else if (first_word=='}' && second_word!='' && rest=='' && second_word:==substr('else',1,length(second_word))) {
         brace_before='} ';
         first_word=second_word;
         pick_else_or_else_if=true;
      } else if (second_word=='' && length(first_word)>1 && first_word:==substr('}else',1,length(first_word))) {
         brace_before='}';
         first_word=substr(first_word,2);
         pick_else_or_else_if=true;
      } else if (is_php && first_word=='}' && second_word!='' && rest=='' && second_word:==substr('elseif',1,length(second_word))) {
         word='} elseif';
         if_special_case=true;
      } else if (is_php && second_word=='' && length(first_word)>1 && first_word:==substr('}elseif',1,length(first_word))) {
         word='}elseif';
         if_special_case=true;
      } else if (!is_php && !is_idl && first_word=='}' && second_word!='' && rest=='' && second_word:==substr('catch',1,length(second_word))) {
         word='} catch';
         if_special_case=true;
      } else if (!is_php && !is_idl && second_word=='' && length(first_word)>1 && first_word:==substr('}catch',1,length(first_word))) {
         word='}catch';
         if_special_case=true;
      } else if (!is_php && !is_idl && first_word=='}' && second_word!='' && rest=='' && second_word:==substr('finally',1,length(second_word))) {
         word='} finally';
         else_special_case=true;
      } else if (!is_php && !is_idl && second_word=='' && length(first_word)>1 && first_word:==substr('}finally',1,length(first_word))) {
         word='}finally';
         else_special_case=true;
      // Check for else if or } else if
      } else if (first_word=='else' && orig_word==substr('else if',1,length(orig_word))) {
         word='else if';
         if_special_case=true;
      } else if (second_word=='else' && rest!='' && orig_word==substr('} else if',1,length(orig_word))) {
         word='} else if';
         if_special_case=true;
      } else if (first_word=='}else' && second_word!='' && orig_word==substr('}else if',1,length(orig_word))) {
         word='}else if';
         if_special_case=true;
      } else if (is_go && first_word == 'type') {
         parse rest with auto third_word rest;
         if (rest == '' && (third_word == 'struct' || third_word == 'interface')) {
            word = 'type';
         }
      } else {
         return(1);
      }
   } else if (!def_always_prompt_for_else_if && orig_word=='else' && word=='else') {
      //Can't force user to use modal dialog insead of just typing "}else {"
      //We need a modeless dialog so user can keep typing.
      return(1);
   } else if (orig_word=='else' && word=='else') {
      pick_else_or_else_if=true;
   }
   if (pick_else_or_else_if) {
      if (is_php || _LanguageInheritsFrom('rul')) {
         word=min_abbrev2('els',php_space_words,name_info(p_index),'');
      } else {
         word=min_abbrev2('els',else_space_words,name_info(p_index),'');
      }
      switch (word) {
      case 'else':
         word=brace_before:+word;
         else_special_case=true;
         break;
      case 'elseif':
      case 'else if':
         word=brace_before:+word;
         if_special_case=true;
         break;
      default:
         return(1);
      }
   }

   // special case for open parenthesis (see c_paren)
   updateAdaptiveFormattingSettings(AFF_NO_SPACE_BEFORE_PAREN | AFF_PAD_PARENS);
   noSpaceBeforeParen := p_no_space_before_paren;
   if ( open_paren_case ) {
      noSpaceBeforeParen = true;
      if ( length(word) != length(orig_word) ) {
         return 1;
      }
      switch ( word ) {
      case 'if':
      case 'elseif':
      case 'while':
      case 'for':
      case 'else if':
      case 'catch':
      case 'using':
      case 'with':
      case 'foreach':
      case 'lock':
      case 'fixed':
      case 'switch':
      case 'return':
         break;
      default:
         return 1;
      }
   }

   // special case for semicolon
   insertBraceImmediately := LanguageSettings.getInsertBeginEndImmediately(p_LangId);
   if ( semicolon_case ) {
      insertBraceImmediately = false;
      if ( length(word) != length(orig_word) ) {
         return 1;
      }
      switch ( word ) {
      case 'if':
      case 'while':
      case 'for':
      case 'foreach':
      case 'else if':
         break;
      default:
         return 1;
      }
   }

   // if they type the whole keyword and then space, ignore
   // the "no space before paren" option, always insert the space
   // 11/30/2006 - rb
   // Commented out because the user (me) could have trained themself to
   // type 'if<SPACE>' in order to get an expanded if-statement. This would
   // have always put the SPACE in regardless of the "no space before paren"
   // option.
   //if ( word == orig_word && last_event() :== ' ') {
   //   be_style &= ~VS_C_OPTIONS_NO_SPACE_BEFORE_PAREN;
   //}

   clear_hotspots();
   _str maybespace=(noSpaceBeforeParen)?'':' ';
   _str parenspace=(p_pad_parens)? ' ':'';

   // google go doesn't really use parens here
   // maybe make this optional someday
   _str openparen=is_go ? '' : '(';
   _str closeparen=is_go ? '' : ')';

   _str bracespace=' ';
   line=substr(line,1,length(line)-length(orig_word)):+word;
   int width=text_col(_rawText(line),_rawLength(line)-_rawLength(word)+1,'i')-1;
   bes_style := beaut_style_for_keyword(p_LangId, word, auto gotaval);

   style2 := bes_style == BES_BEGIN_END_STYLE_2;
   style3 := bes_style == BES_BEGIN_END_STYLE_3;
   _str e1=' {';
   if (! ((word=='do' || word=='try' || word=='finally') && !style2 && !style3) ) {
      if ( style2 || style3 || !insertBraceImmediately ) {
         e1='';
      } else if (word=='}else' || word=='}finally') {
         e1='{';
      }
   } else if (last_event()=='{') {
      e1='{';
      bracespace='';
   }
   if (semicolon_case) e1=' ;';

   // sometimes we just add some spacing, which is not
   // worth notifying the user over
   doNotify := true;
   if ( word=='main' ) {
      if (_LanguageInheritsFrom('java')) {
         save_pos(auto p);
         int col=find_class_col();
         restore_pos(p);
         // If there is no class in this file
         if (!col) {
            replace_line("public class "_strip_filename(p_buf_name,"pe")" {");
            width=syntax_indent;
            insert_line(indent_string(width)'public static void main (String args[]) {');
         } else {
            replace_line(indent_string(width)'public static void main (String args[]) {');
         }
         insert_line('');
         insert_line(indent_string(width)'}');
         if (!col) {
            insert_line("}");
            expansion_end = _QROffset();
            up();
         }
         up();p_col=width+((indent_fl)?syntax_indent:0)+1;

         // let the user know we did something
         notifyUserOfFeatureUse(NF_SYNTAX_EXPANSION);

         return(0);
      } else if (_LanguageInheritsFrom('cs')) {
         save_pos(auto p);
         int col=find_class_col();
         restore_pos(p);
         // If there is no class in this file
         if (!col) {
            replace_line("using System;");
            insert_line("class "_strip_filename(p_buf_name,"pe")" {");
            width=syntax_indent;
            insert_line(indent_string(width)'public static void Main (string []args) {');
         } else {
            replace_line(indent_string(width)'public static void Main (string []args) {');
         }
         insert_line('');
         insert_line(indent_string(width)'}');
         if (!col) {
            insert_line("}");
            up();
         }
         up();p_col=width+((indent_fl)?syntax_indent:0)+1;

         // let the user know we did something
         notifyUserOfFeatureUse(NF_SYNTAX_EXPANSION);
         return(0);
      } else if (_LanguageInheritsFrom('d')) {
         // If there is no class in this file
         replace_line(indent_string(width)'void main (char[][] args)');
         insert_line(indent_string(width)'{');
         insert_line("");
         insert_line(indent_string(width)'}');
         up();p_col=width+((indent_fl)?syntax_indent:0)+1;

         // let the user know we did something
         notifyUserOfFeatureUse(NF_SYNTAX_EXPANSION);

         return(0);
      } else {
         status=c_insert_main();
      }
   } else if ( word=='if' || word=='elseif' || word=='else if' || word=='catch' || if_special_case) {
      replace_line(line:+maybespace:+openparen:+parenspace:+parenspace:+closeparen:+e1);
      //replace_line(line:+maybespace:+'('parenspace:+parenspace')'e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word,c_else_followed_by_brace_else(word),!is_go);
      add_hotspot();
   } else if ( word=='else') {
      typeless p;
      typeless s1,s2,s3,s4;
      save_pos(p);
      save_search(s1,s2,s3,s4);
      up();_end_line();
      search('[^ \t\n\r]','@-rhXc');
      if (get_text()=='}') {
         insertBraceImmediately = true;
      } else {
         e1=' ';
         insertBraceImmediately = false;
      }
      restore_search(s1,s2,s3,s4);
      restore_pos(p);
      replace_line(line:+e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      _end_line();

      doNotify = (insertBraceImmediately || e1 != '');
   } else if ( word=='finally' || else_special_case) {
      replace_line(line:+e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, true, width,word);
      _end_line();
   } else if ( is_dlang && (word=='body' || word=='in' || word=='out' || word=='invariant' || word=='unittest')) {
      replace_line(line:+e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, true, width,word);
      _end_line();
   } else if ( is_dlang && word=='template') {
      replace_line(line:+maybespace' ('parenspace:+parenspace')'e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      p_col += 1+length(parenspace);
      add_hotspot();
      p_col -= 1+length(parenspace);
      left();
      add_hotspot();
   } else if ( word=='for' || (word=='with' && is_javascript) || (word=='with' && is_dlang) ) {
      //replace_line(line:+maybespace'('parenspace:+parenspace')'e1);
      replace_line(line:+maybespace:+openparen:+parenspace:+parenspace:+closeparen:+e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately, width, word, false, !is_go);
      add_hotspot();
   } else if ( word=='while' ) {
      if (c_while_is_part_of_do_loop()) {
         replace_line(line:+maybespace'('parenspace:+parenspace');');
         _end_line();
         p_col -= 2;
         if (p_pad_parens) --p_col;
      } else {
         //replace_line(line:+maybespace'('parenspace:+parenspace')'e1);
         replace_line(line:+maybespace:+openparen:+parenspace:+parenspace:+closeparen:+e1);
         expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
         add_hotspot();
      }
   } else if ( word=='using' ) {
      if (_in_function_scope()) {
         replace_line(line:+maybespace'('parenspace:+parenspace')'e1);
         expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
         add_hotspot();
      } else {
         replace_line(line' ');
         _end_line();
         expansion_end = _QROffset();
         // only notify if something changed
         doNotify = (line != orig_line);
      }
   } else if ( word=='foreach' || word=='foreach_reverse' ) {
      if (_LanguageInheritsFrom('d')) {
         replace_line(line:+maybespace'( , )'e1);
         expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
         add_hotspot();
         p_col+=3;
         add_hotspot();
         p_col-=3;
      } else {
         replace_line(line:+maybespace'( in )'e1);
         expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
         add_hotspot();
         p_col+=4;
         add_hotspot();
         p_col-=4;
      }
   } else if ( word=='lock' || word=='fixed' ) {
      replace_line(line:+maybespace'('parenspace:+parenspace')'e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      add_hotspot();
   } else if ( is_dlang && ( word=='debug' || word=='version') ) {
      replace_line(line:+maybespace'('parenspace:+parenspace')'e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      add_hotspot();
   } else if ((is_idl || is_php || is_dlang) && pos(' 'word' ',' exception interface struct class module union ' )) {
      replace_line(line' 'e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      if (maybespace:==' ') {
         left();
      }

      doNotify = (insertBraceImmediately || line != orig_line);
   } else if ((is_idl || is_dlang) && word=='union') {
      replace_line(line'  switch'maybespace'('parenspace:+parenspace')'e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      left();
   } else if (word=='enum' && (is_java || is_dlang)) {
      replace_line(line:+maybespace:+e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      left();
      add_hotspot();
      doNotify = (e1 != '' || insertBraceImmediately || line != orig_line);
   } else if (is_java && word=='@interface') {
      replace_line(line:+maybespace:+e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      left();
      add_hotspot();
      doNotify = (e1 != '' || insertBraceImmediately || line != orig_line);
   } else if (word=='@interface' || word=='@implementation' || word=='@protocol') {
      replace_line(line:+' ');
      insert_line(indent_string(width)'@end');
      add_hotspot();
      up(1); _end_line();
   } else if (is_java && (word=='interface' || word=="class")) {
      int command_line = p_line;
      className := _strip_filename(p_buf_name,'PE');
      replace_line(indent_string(width):+word" "className" {");
      p_col = width+length(word)+2;
      add_hotspot();
      _end_line();
      p_col = p_col-1;
      add_hotspot();
      insert_line("");
      insert_line(indent_string(width):+'}');
      up();
      p_col=width+syntax_indent+1;
      add_hotspot();
      p_line = command_line;
      p_col = width+length(word)+2;
   } else if (is_idl && word=='sequence') {
      replace_line(line:+maybespace:+'<>');
      _end_line();left();
   } else if ( (word=='public' || word=='private' || word=='protected') &&
               !is_java && p_LangId!='tagdoc' && _in_class_scope()) {
      replace_line(line':');_end_line();
      _c_do_colon();
   } else if ( word=='switch' || (is_go && word == 'select') ) {
      //replace_line(line:+maybespace'('parenspace:+parenspace')'e1);
      replace_line(line:+maybespace:+openparen:+parenspace:+parenspace:+closeparen:+e1);
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word, false, !is_go);
      add_hotspot();
   } else if ( word=='do' ) {
      insertBraceImmediately=true;  // do doesn't work well when not inserting braces immediately
      // Always insert braces for do loop unless braces are on separate
      // line from do and while statements
      int num_end_lines=1;
      replace_line(line:+e1);
      if ( ! style3 ) {
         if (style2 ) {
            insert_line(indent_string(width)'{');
         }
         insert_line(indent_string(width)'}'bracespace'while':+maybespace'('parenspace:+parenspace');');
         _end_line();
         expansion_end = _QROffset();
         p_col -= 2;

         updateAdaptiveFormattingSettings(AFF_PAD_PARENS);
         if (p_pad_parens) p_col--;
         add_hotspot();
         up();
      } else if ( style3 ) {
         if (insertBraceImmediately) {
            num_end_lines=2;
            insert_line(indent_string(width+syntax_indent)'{');
            insert_line(indent_string(width+syntax_indent)'}');
            insert_line(indent_string(width)'while':+maybespace'('parenspace:+parenspace');');
            _end_line();
            expansion_end = _QROffset();
            p_col -= 2;
            updateAdaptiveFormattingSettings(AFF_PAD_PARENS);
            if (p_pad_parens) p_col--;
            add_hotspot();
            up(2);
            //syntax_indent=0;
         } else {
            insert_line(indent_string(width)'while'maybespace:+'('parenspace:+parenspace');');
            _end_line();
            expansion_end = _QROffset();
            p_col -= 2;
            updateAdaptiveFormattingSettings(AFF_PAD_PARENS);
            if (p_pad_parens) p_col--;
            add_hotspot();
            up(1);
            //syntax_indent=0
         }
      }
      nosplit_insert_line();
      set_surround_mode_end_line(p_line+1, num_end_lines);
      p_col=width+syntax_indent+1;
      add_hotspot();
   } else if ( word=='try' ) {
      int surround_end_line=0;
      int num_end_lines = 2;
      if (LanguageSettings.getInsertBlankLineBetweenBeginEnd(p_LangId)) ++num_end_lines;
      if (style2 || style3) ++num_end_lines;
      replace_line(line:+e1);
      if (!style3) {
         if (style2) {
            insert_line(indent_string(width)'{');
         }
         cuddleElse := LanguageSettings.getCuddleElse(p_LangId);
         if (!cuddleElse) {
            insert_line(indent_string(width)'}');
            surround_end_line=p_line+1;
            insert_line(indent_string(width)'catch':+maybespace'('parenspace:+parenspace')'e1);
            ++num_end_lines;
         } else {
            insert_line(indent_string(width)'}'bracespace'catch':+maybespace'('parenspace:+parenspace')'e1);
            surround_end_line=p_line+1;
         }
         _end_line();
         p_col -= (length(e1)+1);
         add_hotspot();
         expansion_end = maybe_insert_braces(noSpaceBeforeParen, true, width,word);
         up(1);
         if (!cuddleElse){
            up(1);
         }
      } else if (style3) {
         insert_line(indent_string(width+syntax_indent)'{');
         insert_line(indent_string(width+syntax_indent)'}');
         surround_end_line=p_line+1;
         insert_line(indent_string(width)'catch':+maybespace'('parenspace:+parenspace')'e1);
         _end_line();
         p_col -= (length(e1)+1+length(parenspace));
         add_hotspot();
         expansion_end = maybe_insert_braces(noSpaceBeforeParen, true, width,word);
         up(2);
         ++num_end_lines;
      }
      nosplit_insert_line();
      p_col=width+syntax_indent+1;
      add_hotspot();
      set_surround_mode_end_line(surround_end_line, num_end_lines);
   } else if ( word=='printf' ) {
      replace_line(indent_string(width)'printf("');
      _end_line();
   } else if ( is_javascript && (word=='export' || word=='function' || word=='import' || word=='var')) {
      newLine := indent_string(width)word' ';
      replace_line(newLine);
      _end_line();
      doNotify = (newLine != orig_line);
   } else if ( word=='return' ) {
      if (orig_word=='return') {
         return(1);
      }
      boolean IsVoid=false;
      tag_lock_context(true);
      _UpdateContext(true);
      int context_id=tag_current_context();
      if (context_id>0) {
         _str tag_type='';
         tag_get_detail2(VS_TAGDETAIL_context_type,context_id,tag_type);
         if (tag_tree_type_is_func(tag_type)) {
            _str return_type='';
            tag_get_detail2(VS_TAGDETAIL_context_return,context_id,return_type);
            if (return_type=='void') {
               IsVoid=true;
            }
         }
      }
      tag_unlock_context();
      newLine := indent_string(width)'return';
      replace_line(newLine);
      _end_line();
      if (IsVoid) {
         keyin(';');
      } else {
         keyin(' ');
         doNotify = (newLine != orig_line);
      }
   } else if ( word=='continue' || word=='break' ) {
      // Java allows labels to follow continue or break
      if (orig_word==word) {
         replace_line(indent_string(width)word' ');
         doNotify = false;
      } else {
         if (is_java) {
            newLine := indent_string(width)word;
            replace_line(newLine);
            doNotify = (newLine != orig_line);
         } else {
            replace_line(indent_string(width)word';');
         }
      }
      _end_line();
   } else if ( word=='case' ) {
      if ( name_on_key(ENTER):=='nosplit-insert-line' ) {
         replace_line(indent_string(width)word' :');
         _end_line();_c_do_colon();p_col=p_col-1;
         if ( ! _insert_state() ) _insert_toggle();
      } else {
#if 1
         // Code which inserts case
         replace_line(indent_string(width)word' :');
         _end_line();_c_do_colon();_rubout();
#else
         // Code which inserts case and colon and
         // puts user in insert mode.
         replace_line(indent_string(width)word' :');
         _end_line();_c_do_colon();p_col=p_col-1;
         if ( ! _insert_state() ) _insert_toggle();
#endif
      }
   } else if ( word=='default' ) {
      replace_line(indent_string(width)word':');_end_line();
      _c_do_colon();
   } else if ( word=='template') {
      // auto-insert angle brackets for template
      replace_line(indent_string(width)word:+maybespace'<>');
      _end_line();left();
   } else if (((word=='static_cast' || word=='const_cast') && pos('_', orig_word)) || word == 'reinterpret_cast' || word=='dynamic_cast') {
      // expand static_cast and const_cast only if _ is in orig_word
      // auto-insert angle brackets and parens for cast operators
      // static_cast<>()
      _str cast_op = "";
      int h1, h2;
      cast_op = indent_string(width)word:+maybespace'<'parenspace;
      h1 = length(cast_op) + 1;
      cast_op = cast_op:+parenspace'>':+maybespace'('parenspace;
      h2 = length(cast_op) + 1;
      cast_op = cast_op:+parenspace')';
      replace_line(cast_op);
      p_col = h2; add_hotspot();
      p_col = h1; add_hotspot();
      _end_line();
      expansion_end = _QROffset();
      p_col = h1;
   } else if ( word=="#include" && LanguageSettings.getAutoCompletePoundIncludeOption(p_LangId) == AC_POUND_INCLUDE_QUOTED_ON_SPACE ) {
      replace_line(indent_string(width)word' ');
      _end_line();
      AutoBracketKeyin('"');
      _do_list_members(false, true);
      if (get_text() == '"') {
         message("Press '<' to convert #include "" to #include <>");
      }
   } else if (is_go && word == 'func') {
      replace_line(line'  () {');
      expansion_end = maybe_insert_braces(noSpaceBeforeParen, insertBraceImmediately,width,word);
      p_col = length(line) + 6;
      add_hotspot();
      p_col -= 2;
      add_hotspot();
      p_col -= 2;
      add_hotspot();
   } else if (is_go && word == 'map') {
      replace_line(line:+'[]');
      p_col = length(line) + 3;
      add_hotspot();
      p_col -= 1;
      add_hotspot();
   } else if ( pos(' 'word' ',EXPAND_WORDS) ) {
      newLine := indent_string(width)word' ';
      replace_line(newLine);
      _end_line();
      doNotify = (newLine != orig_line);
   } else if (is_java && !is_javascript && pos(' 'word' ',JAVA_ONLY_EXPAND_WORDS) ) {
      newLine := indent_string(width)word' ';
      replace_line(newLine);
      _end_line();
      doNotify = (newLine != orig_line);
   } else if (is_csharp==1 && pos(' 'word' ',CS_ONLY_EXPAND_WORDS) ) {
      newLine := indent_string(width)word' ';
      replace_line(newLine);
      _end_line();
      doNotify = (newLine != orig_line);
   } else if (is_dlang==1 && d_space_words._indexin(word) && d_space_words:[word].statement==word) {
      newLine := indent_string(width)word' ';
      replace_line(newLine);
      _end_line();
      doNotify = (newLine != orig_line);
   } else if (is_idl==1 && pos(' 'word' ',IDL_ONLY_EXPAND_WORDS) ) {
      newLine := indent_string(width)word' ';
      replace_line(newLine);
      _end_line();
      doNotify = (newLine != orig_line);
   } else if (is_php==1 && pos(' 'word' ',PHP_ONLY_EXPAND_WORDS) ) {
      newLine := indent_string(width)word' ';
      replace_line(newLine);
      _end_line();
      doNotify = (newLine != orig_line);
   } else {
     status=1;
     doNotify = false;
   }
   if (semicolon_case) {
      orig_col := p_col;
      _end_line();
      left();
      add_hotspot();
      p_col = orig_col;
   }
   show_hotspots();

   if (expansion_end >= expansion_start
       && beautify_syntax_expansion(p_LangId)) {
      long markers[];

      new_beautify_range(expansion_start, expansion_end, markers, true, false, false);
   } else if (!do_surround_mode_keys(false, NF_SYNTAX_EXPANSION) && doNotify) {
      // notify user that we did something unexpected
      notifyUserOfFeatureUse(NF_SYNTAX_EXPANSION);
   }

   if (open_paren_case) {
      AutoBracketCancel();
   }

   return(status);
}


int _java_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _java_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _cs_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _cs_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _e_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _e_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _js_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _js_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _as_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _as_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _awk_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _awk_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _pl_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _pl_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _phpscript_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _phpscript_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _cfscript_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _cfscript_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _ansic_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _ansic_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}
int _m_delete_char(_str force_wrap='')
{
   return _c_delete_char(force_wrap);
}
int _m_rubout_char(_str force_wrap='')
{
   return _c_rubout_char(force_wrap);
}

// Starting with the cursor on an open brace, find the start
// column for the keyword of the current statement.
static int get_statement_kw_column()
{
   status := 0;
   save_pos(auto p);

   loop {
      // skip backwards from open brace
      left();
      status = _clex_skip_blanks('-h');
      if (status < 0) break;

      // if we find a paren block, the skip to open paren
      if (get_text() == ')') {
         status = find_matching_paren(true);
         if (status) return status;
         left();
         status = _clex_skip_blanks('-h');
         if (status < 0) break;
      }

      // we expect to be on a keyword now
      if (_clex_find(0, 'g') != CFG_KEYWORD) {
         break;
      }

      // get the keyword and start column
      save_pos(auto kw_pos);
      kw := cur_identifier(status);
      if (kw == '') {
         status = STRING_NOT_FOUND_RC;
      }

      // check for extended "else if" statement
      if (kw=='if') {
         // skip 'if' keyword and spaces
         p_col -= 2;
         status = _clex_skip_blanks('-h');
         if (status < 0) break;

         // check for an 'else' keyword, drop back if no else
         if (_clex_find(0, 'g') == CFG_KEYWORD) {
            kw = cur_identifier(status);
         }
         if (kw != 'else') {
            restore_pos(kw_pos);
            kw = cur_identifier(status);
         }
      }

      // check for else block.
      if (kw == 'else') {
         // skip 'else' keyword and spaces
         p_col -= 4;
         status = _clex_skip_blanks('-h');
         if (status < 0) break;

         // check for close brace (ending block)
         if (get_text() == '}') {
            status = find_matching_paren(true);
            if (status) return status;
            continue;
         } else {
            origOffset := _QROffset();
            status = begin_statement();
            if (status) return status;
            if (_QROffset() == origOffset) return STRING_NOT_FOUND_RC;
            continue;
         }

         // restore to the position where we found the keyword
         restore_pos(kw_pos);
         kw = cur_identifier(status);
         break;
      }

      // break out for main loop
      break;
   }

   // that's all, status is either an error <0 or column >0
   restore_pos(p);
   return status;
}

int _c_delete_char(_str force_wrap='')
{
   if (get_text() == '{' && _clex_find(0, 'g')==CFG_PUNCTUATION) {

      // make sure the option is enabled for 'C'
      if (!LanguageSettings.getQuickBrace(p_LangId)) {
         return STRING_NOT_FOUND_RC;
      }

      // get the start column for this statement
      start_col := get_statement_kw_column();

      // check if this is an empty brace block
      save_pos(auto p);
      right();
      _clex_skip_blanks('h');
      empty_braces := (get_text()=='}');
      restore_pos(p);

      // check if this brace has a matching brace somewhere
      orig_line := p_line;
      status := find_matching_paren(true);
      if (status) return status;

      // examine the last line of the block, make sure we have a close }
      get_line(auto line);
      line=strip(line);
      if (first_char(line) != '}' && p_line > orig_line) {
         return STRING_NOT_FOUND_RC;
      }

      // check for 'else' or trailing line comment
      parse substr(line, 2) with auto kw .;
      if (substr(line,2,2)=='//') kw='//';
      if (substr(line,2,2)=='//') kw='/*';
      if (p_line>orig_line && kw!='' && kw!='else' && kw!='else{' && kw!='//' && kw!='/*') {
         return STRING_NOT_FOUND_RC;
      }
      end_col := p_col;
      sameLineCase := (orig_line==p_line);
      deleteBraceOnly := (kw != '');
      joinComment := (kw == '//' || kw == '/*');
      last_line := p_line;
      save_pos(auto close_p);

      // check that we did not match to a brace that doesn't really match
      if (end_col < start_col || end_col > start_col+p_SyntaxIndent) {
         return STRING_NOT_FOUND_RC;
      }

      // is the block too big?
      if (last_line > orig_line+8) {
         return STRING_NOT_FOUND_RC;
      }

      // back to where started, check for the
      // first statement in the block
      restore_pos(p);
      status = next_statement(true);
      if (status && p_line > last_line) {
         return STRING_NOT_FOUND_RC;
      }

      // check if there is another statement in the block
      // if so, then we can not un-brace the block
      status = next_sibling(true);
      if (!status && p_line <= last_line) {
         return STRING_NOT_FOUND_RC;
      }

      // delete the closing brace
      p_line = last_line;
      if (sameLineCase) {
         restore_pos(close_p);
         _delete_char();
         while (get_text():==" " || get_text():=="\t") {
            _delete_char();
         }
      } else if (deleteBraceOnly) {
         first_non_blank();
         _delete_char();
         while (get_text():==" " || get_text():=="\t") {
            _delete_char();
         }
      } else {
         _delete_line();
      }

      // back to the top, now join the one liner with the
      // current line, depending on brace style
      restore_pos(p);
      get_line(line);
      if (sameLineCase) {
         _delete_char();
         while (get_text():==" " || get_text():=="\t") {
            _delete_char();
         }
      } else if (line == '{') {
         _delete_line();
         first_non_blank();
      } else {
         // check if the line ends with a line comment
         save_pos(auto brace_pos);
         _end_line();
         hasLineComment := _in_comment();
         restore_pos(brace_pos);
         // join the single line statement to the condition line
         if (force_wrap==1 && !empty_braces && p_line+2 == last_line &&
             p_col <= def_hanging_statements_after_col && !hasLineComment) {
            join_line();
            // if the character to the left of the cursor is alphanumeric
            // add a space to separate it from the joining statement.
            if (isalnum(get_text_left())) {
               _insert_text(' ');
            }
         }
         if (joinComment) {
            orig_col := p_col;
            _end_line();
            _insert_text(' ');
            join_line();
            p_col = orig_col;
         }
         _delete_char();
      }

      // done, turn off dynamic surround
      clear_surround_mode_line();
      return 0;
   }

   return STRING_NOT_FOUND_RC;
}

int _c_rubout_char(_str force_wrap='')
{
   if (p_col <= 1) {
      return STRING_NOT_FOUND_RC;
   }
   save_pos(auto p);
   left();
   status := _c_delete_char(force_wrap);
   if (status) restore_pos(p);
   return status;
}

static void _maybe_skip_else_ladder()
{
   // We assume end-statement has been already been called at this point.
   // For if-else chains, end-statement will only skip over the if, so we 
   // do a little extra work to advance to the end of the chain.  
   // (end-statement-block doesn't help us, it skips over multiple statements,
   // which isn't what we want for quickbrace).
   for (;;) {
      save_pos(auto elsecheck);
      status := search('[^ \t]', '@RXC');
      if (status == 0) {
         xkw := cur_identifier(auto dnc);

         if (xkw == 'else') {
            status = end_statement(true);
            if (status != 0) {
               restore_pos(elsecheck);
               return;
            }
         } else {
            restore_pos(elsecheck);
            return;
         }
      } else {
         restore_pos(elsecheck);
         return;
      }
   }
}

static boolean maybe_surround_conditional_statement()
{
   // make sure the option is enabled
   if (!LanguageSettings.getQuickBrace(p_LangId)) {
      return false;
   }

   // now attempt to find a brace matching the brace we just put in
   // if it falls in a column that matches the expected indentation
   // then do not insert the closing brace.  If the cursor was past the
   // real end of the line, pretend there were real spaces there.
   save_pos(auto p);
   int orig_col = p_col;
   _end_line();
   int end_col = p_col;
   first_non_blank();
   int indent_col = p_col;
   if (indent_col == end_col && orig_col > indent_col) {
      indent_col = orig_col;
      p_col = indent_col;
   }

   restore_pos(p);
   _insert_text('{');
   if (!find_matching_paren(true)) {
      if (p_col >= indent_col && p_col <= indent_col+p_SyntaxIndent) {
         restore_pos(p);
         _delete_text(1);
         return false;
      }
   }
   restore_pos(p);
   _delete_text(1);
   restore_pos(p);

   // save the original cursor position and seach parameters
   status := 0;
   save_search(auto s1,auto s2, auto s3, auto s4, auto s5);

   // do - while - false
   do {
      orig_line := p_line;

      // skip backwards over whitespace
      left();
      status = search("[^ \t]", '-@r');
      if (status) {
         break;
      }

      // skip line comment if we encounter one
      if (_in_comment()) {
         _clex_skip_blanks('-');
      }

      // if we have a paren, skip backwards over it
      paren_line := p_line;
      haveParen := (get_text()==')');
      if (get_text()==')') {
         status = find_matching_paren(true);
         if (status) {
            break;
         }

         left();
         status = search("[^ \t]", '-@r');
         if (status) {
            break;
         }
      }

      // check keyword under cursor
      left();
      col := 0;
      kw := cur_identifier(col);
      kw_line := p_RLine;
      if (kw != 'if' && kw != 'for' && kw!='while' && kw!='foreach' && kw!='else') {
         status = STRING_NOT_FOUND_RC;
         break;
      }
      if (kw=='else' && haveParen) {
         status = STRING_NOT_FOUND_RC;
         break;
      }

      // check for type 2 or 3 braces
      boolean type23_braces=false;
      if (paren_line == orig_line) {
         type23_braces=false;
      } else if (paren_line < orig_line) {
         type23_braces=true;
      } else {
         status = STRING_NOT_FOUND_RC;
         break;
      }

      // check for "else if"
      if (kw == 'if') {
         left();
         status = search("[^ \t]", '-@r');
         if (status) {
            break;
         }

         save_pos(auto pif);
         left();
         if_col := 0;
         kw = cur_identifier(if_col);
         if (kw!='else') {
            restore_pos(pif);
         } else {
            col = if_col;
         }
      }

      // check for "} else"
      if (kw == 'else') {
         p_col = col;
         left();
         status = search("[^ \t]", '-@r');
         if (status) {
            break;
         }
         if (get_text() == '}') {
            col = p_col;
         }
      }

      // for type2 and type3 braces, have to be at start of line
      if (type23_braces) {
         restore_pos(p);
         orig_col = p_col;
         first_non_blank();
         if (p_col < orig_col && !at_end_of_line()) {
            status = STRING_NOT_FOUND_RC;
            break;
         }
      }

      // back where we started
      restore_pos(p);
      status = search('[^ \t]', '@rXC');
      if (status) {
         break;
      }

      // make sure we land where we expected
      if (p_col <= col) {
         status = STRING_NOT_FOUND_RC;
         break;
      }

      if (_are_statements_supported()) {
         // check that the current statement starts here
         _UpdateContext(true,false,VS_UPDATEFLAG_context|VS_UPDATEFLAG_statement);

         // make sure that the context doesn't get modified by a background thread.
         se.tags.TaggingGuard sentry;
         sentry.lockContext(false);

         int cur_statement_id = tag_current_statement();
         if (cur_statement_id <= 0) {
            status = STRING_NOT_FOUND_RC;
            break;
         }
         tag_get_detail2(VS_TAGDETAIL_context_start_linenum, cur_statement_id, auto cur_statement_line);
         if (cur_statement_line < kw_line || cur_statement_line > p_RLine) {
            status = STRING_NOT_FOUND_RC;
            break;
         }

         // jump to the end of the conditional statement
         status = end_statement(true);
         if (status) {
            break;
         }

         _maybe_skip_else_ladder();
      } else {
         // no statement tagging, so just be stupid and search
         // forward for a semicolon in the next five lines.
         if (search("[{};]", "@r") ||
             get_text() != ";"  ||
             _clex_find(0, "g") == CFG_STRING ||
             _clex_find(0, "g") == CFG_COMMENT ||
             p_RLine > orig_line+10) {
            status = STRING_NOT_FOUND_RC;
            break;
         }
      }

      // insert the closing brace
      updateAdaptiveFormattingSettings(AFF_BEGIN_END_STYLE | AFF_SYNTAX_INDENT);
      if (type23_braces && (p_begin_end_style == VS_C_OPTIONS_STYLE2_FLAG)) {
         insert_line(indent_string(col-1+p_SyntaxIndent):+"}");
      } else {
         insert_line(indent_string(col-1):+"}");
      }
      last_line := p_line;

      // check for trailing else and join to close brace
      save_pos(auto pend);
      down();
      first_non_blank();
      end_col = 0;
      kw = cur_identifier(end_col);
      restore_pos(pend);
      if (kw=='else' && !type23_braces) {
         if (LanguageSettings.getCuddleElse(p_LangId)) {
            join_line(1);
            _insert_text(' ');
         }
      }

      // check for incorrect brace style, I mean,
      // check for something other than style 1
      restore_pos(p);
      if (type23_braces) {
         if (p_begin_end_style == BES_BEGIN_END_STYLE_2) {
            p_col = col;
         } else if (p_begin_end_style == BES_BEGIN_END_STYLE_3) {
            p_col = col+p_SyntaxIndent;
         } else {
            p_col = col;
         }
         // re-indent the line using user's preferred tab style
         get_line(auto line);
         line = reindent_line(line, 0);
         replace_line(line);
      }

      // finally, insert the opening brace
      if (!_insert_state() && get_text()==' ') _delete_text(1);
      _insert_text('{');
      strip_trailing_spaces();
      save_pos(p);
      status = search('[^ \t]', '@r');
      if (!status && p_line == orig_line && !_in_comment()) {
         split_line();
         strip_trailing_spaces();
         last_line++;
      }

      // re-indent the statement, no matter how many lines
      down();
      while (p_line < last_line) {
         first_non_blank();
         while (p_col < col+p_SyntaxIndent) {
            _insert_text(' ');
         }
         get_line(auto line);
         line = reindent_line(line, 0);
         replace_line(line);
         down();
      }

      // drop into dynamic surround so they can move
      // single statement out of the loop if they want to
      //set_surround_mode_start_line(orig_line,1);
      //set_surround_mode_end_line(p_line);
      //restore_pos(p);
      //do_surround_mode_keys(false);

   } while (false);

   restore_pos(p);
   restore_search(s1,s2,s3,s4,s5);
   return status==0;
}

// Returns true for languagea that support same-line brace placement
// for Auto Close.
boolean supports_advanced_bracket_cfg(_str langId) 
{
   // Arbitrary - the only real initial limitation is what languages
   // use c_begin()
   return new_beautifier_supported_language(langId);
}


// Helper that deals with differences between the languages
// that support same-line bracket placement, and the languages that don't.
static int get_autobrace_placement(_str lang) {
   if (supports_advanced_bracket_cfg(lang)) {
      return LanguageSettings.getAutoBracePlacement(lang);
   } else if (LanguageSettings.getInsertBlankLineBetweenBeginEnd(lang)) {
      return AUTOBRACE_PLACE_AFTERBLANK;
   } else {
      return AUTOBRACE_PLACE_NEXTLINE;
   }
}

static boolean should_expand_cuddling_braces(_str lang) {
   // Assume they don't want any fancy newline behaviors if they've not got
   // Smart Indent on.  
   return (get_autobrace_placement(lang) == AUTOBRACE_PLACE_SAMELINE && 
           LanguageSettings.getAutoBracketEnabled(p_LangId, AUTO_BRACKET_BRACE));
}

static int c_expand_begin()
{
   if (maybe_surround_conditional_statement()) {
      return 0;
   }

   // check if they typed "do{" or "try{"
   get_line(auto line);
   if (line=='do' || (line=='try' && !_LanguageInheritsFrom('e'))) {
      if (!c_expand_space()) {
         return 0;
      }
   }

   // check that brace expansion is enabled
   expand := LanguageSettings.getAutoBracketEnabled(p_LangId, AUTO_BRACKET_BRACE);

   updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT | AFF_BEGIN_END_STYLE);
   syntax_indent := p_SyntaxIndent;
   insertBlankLine := LanguageSettings.getInsertBlankLineBetweenBeginEnd(p_LangId);
   if (first_char(strip(line)) == '}') {
      parse line with '}' line;
   }
   if (line=='if' || line=='while' || line=='for' ||
       line=='else if' || line=='switch' ||
       line=='with' || line=='lock' || line=='catch' ||
       line=='fixed' || line=='using') {

      insertBraceImmediately := LanguageSettings.getInsertBeginEndImmediately(p_LangId);
      if (!insertBraceImmediately) LanguageSettings.setInsertBeginEndImmediately(p_LangId, true);
      status := c_expand_space();
      if (!insertBraceImmediately) LanguageSettings.setInsertBeginEndImmediately(p_LangId, false);
      if (!status) return 0;
   }


   int brace_indent=0;
   lbo := _QROffset();
   keyin('{');
   get_line(line);
   int pcol=_text_colc(p_col,'P');
   _str last_word='';
   typeless AfterKeyinPos;
   save_pos(AfterKeyinPos);

   // first, back up and look for a parenthesized expression
   // which would be part of the if, while, or for statement
   left();
   left();
   _clex_skip_blanks('-');
   if (get_text() == ':'
       && strip(line) == '{') {
      // Might be for a case or default statement - if so, readjust the indent to 
      // match the formatting settings.
      first_non_blank();
      wd := _c_get_wordplus();
      if (wd == 'case' || wd == 'default:') {
         ccol := p_col;
         if (0 == beaut_brace_indents_with_case(p_LangId)) {
            ccol += p_SyntaxIndent;
         }
         restore_pos(AfterKeyinPos);
         replace_line(indent_string(ccol-1)'{');
         p_col = ccol+1;
         save_pos(AfterKeyinPos);
         lbo = _QROffset() - 1;
      }
   } else if (get_text()!=')' || find_matching_paren(true) != 0) {
      restore_pos(AfterKeyinPos);
   }

   // compute the simple indentation column for this line
   first_non_blank();
   int indent_col = p_col;

   // now attempt to find a brace matching the brace we just put in
   // if it falls in a column that matches the expected indentation
   // then do not insert the closing brace
   boolean orig_expand=expand;
   restore_pos(AfterKeyinPos);
   if (expand && !find_matching_paren(true)) {
      if (p_col >= indent_col && p_col <= indent_col+p_SyntaxIndent) {
         expand=0;
      }
   }
   restore_pos(AfterKeyinPos);

   /*
        Don't insert end brace for these cases in a variable initializer
        object array={
           {<DONT EXPAND THIS>
        }
        object array={
           a,{<DONT EXPAND THIS>
        }

   */
   left();
   if (p_col==1) {
      up();_end_line();
   } else {
      left();
   }
   _clex_skip_blanksNpp('-');
   if (get_text()==',') {
      restore_pos(AfterKeyinPos);
      return(0);
   }
   if (get_text()=='{') {
      // This won't work for C because of function variable declarations but should work pretty well for C++
      // Worst case, user has to type close brace
      if (p_col==1) {
         up();_end_line();
      } else {
         left();
      }
      _clex_skip_blanksNpp('-');
      if (get_text()!=')') {
         restore_pos(AfterKeyinPos);
         return(0);
      }
   }
   restore_pos(AfterKeyinPos);

   int old_linenum=p_line;
   int col=0, old_col=p_col;
   int begin_brace_col=0;
   int status=_clex_skip_blanks();
   boolean end_brace_is_last_char=status || p_line>old_linenum;
   restore_pos(AfterKeyinPos);

   if ( line!='{' ) {
      if (!end_brace_is_last_char) {
         return(0);
      }
   } else if ( p_begin_end_style != BES_BEGIN_END_STYLE_3 ) {
      /*
          Now that "class name<ENTER>" usually indents, we need
          the begin brace to be moved correctly to align under the
          "class" keyword.
      */
      save_pos(auto p);
      left();
      //begin_brace_col=p_col;
      col= find_block_col();
      if (!col) {
         restore_pos(p);left();
         col=c_begin_stat_col(true,true,true);
      } else {
         // Indenting for class/struct/interface/variable initialization
         /*style=(be_style & VS_C_OPTIONS_STYLE2_FLAG);
         if (style!=0) {
            col=begin_brace_col;
         }*/
      }
      restore_pos(p);
      if (col) {
         expand=orig_expand;
         replace_line(indent_string(col-1)'{');
         _end_line();save_pos(AfterKeyinPos);
      }

   } else if ( p_begin_end_style == BES_BEGIN_END_STYLE_3 ) {
      /*
         A few customers like the way 1.7 let them type braces
         for functions indented.

         Brief does not do this.

      */
      /*
          Now that "class name<ENTER>" usually indents, we need
          the begin brace to be moved correctly to align under the
          "class" keyword.
      */
      save_pos(auto p);
      left();
      begin_brace_col=p_col;
      col= find_block_col();
      if (!col) {
         restore_pos(p);left();
         col=c_begin_stat_col(true,true,true);
         if ((p_begin_end_style == BES_BEGIN_END_STYLE_3) && def_style3_indent_all_braces) {
            col+=syntax_indent;
         }
      } else {
         // Indenting for class/struct/interface/variable initialization
         if (p_begin_end_style == BES_BEGIN_END_STYLE_2 || p_begin_end_style == BES_BEGIN_END_STYLE_3) {
            col=begin_brace_col;
         }
      }
      restore_pos(p);
      if (col) {
         expand=orig_expand;
         replace_line(indent_string(col-1)'{');
         _end_line();save_pos(AfterKeyinPos);
      }

   }
   first_non_blank();
   int placement = get_autobrace_placement(p_LangId);
   if ( expand ) {
      col=p_col-1;

      indent_fl := LanguageSettings.getIndentFirstLevel(p_LangId);
      if ( (col && (p_begin_end_style == BES_BEGIN_END_STYLE_3)) || (! (indent_fl+col)) ) {
         syntax_indent=0;
      }

      if (placement == AUTOBRACE_PLACE_SAMELINE) {
         // Easy case.  Don't bother with all of the placement juggling in _c_endbrace.
         restore_pos(AfterKeyinPos);
         rbo := _QROffset();
         keyin('}');
         AutoBracketForBraces(p_LangId, lbo, rbo);
         restore_pos(AfterKeyinPos);
      } else {
         // Inhibit beautify_on_edit for _c_endbrace, otherwise the following restore_pos() 
         // will end up landing on pointy rocks.
         // It's expected the caller of c_expand_begin 
         // will do a post-call beautify, if necessary.
         insert_line(indent_string(col+brace_indent));
         brace_indent=p_col-1;
         set_surround_mode_start_line(old_linenum);
         _c_endbrace(true);      

         switch (placement) {
         case AUTOBRACE_PLACE_NEXTLINE:
            restore_pos(AfterKeyinPos);
            break;

         case AUTOBRACE_PLACE_AFTERBLANK:
            restore_pos(AfterKeyinPos);
            _end_line();
            c_enter();
            break;
         }
         set_surround_mode_end_line(p_line+1);
      }
   } else {
      restore_pos(AfterKeyinPos);//_end_line();
   }
   typeless done_pos;
   save_pos(done_pos);
   if (_LanguageInheritsFrom('c') || _LanguageInheritsFrom('java') || _LanguageInheritsFrom('cs') || _LanguageInheritsFrom('e')) {
      restore_pos(AfterKeyinPos);
      _str class_name='';
      _str implement_list='';
      _str class_type_name;
      int vsImplementFlags=0;
      indent_col=c_parse_class_definition(class_name,class_type_name,implement_list,vsImplementFlags,AfterKeyinPos);
      if (!indent_col) {
         restore_pos(done_pos);
         // do block surround only if we are already in a function scope
         if (_in_function_scope()) {
            if (!beautify_on_edit(p_LangId)) {
               // Only do this if we're not going to beautify it after the call to c_expand_begin().
               // Otherwise, you get a weird looking beautify update once surround mode exits.
               do_surround_mode_keys();
            }
         } else {
            clear_surround_mode_line();
         }
         return(0);
      }

      clear_surround_mode_line();
      restore_pos(AfterKeyinPos);
      /*
         For simplicity, remove blank line that was inserted
      */
      if (expand && placement == AUTOBRACE_PLACE_AFTERBLANK ) {
         down();
         _delete_line();
         restore_pos(AfterKeyinPos);
      }
      int count;
      //messageNwait('class_name='class_name' implement_list='implement_list);
      tag_lock_context();
      _UpdateContext(true);

      int context_id=tag_current_context();

      // The context in this area may be a little bit fidgety,
      // since we're in the process of editing it.  Search upwards
      // for an enclosing package/namespace.
      while (context_id > 0) {
         tag_get_detail2(VS_TAGDETAIL_context_type, context_id, auto tag_type);

         if (tag_type == 'package') {
            break;
         }
         tag_get_detail2(VS_TAGDETAIL_context_outer, context_id, context_id);
      }

      _str outer_class="";
      _str tag_name="";

      if (context_id>0) {
         tag_get_detail2(VS_TAGDETAIL_context_name, context_id, outer_class);
      }
      tag_unlock_context();

      if (class_name=='') {
         class_name=implement_list;
      }
      count=_do_default_get_implement_list(class_name, outer_class,vsImplementFlags,false);

      if (count > 0) {
         if (expand && placement == AUTOBRACE_PLACE_SAMELINE) {
            // Go ahead and expand the {} so we have a place to 
            // generate code to.
            c_enter();
         }
         generate_code_for_override(outer_class, class_name);
      }
      down();
      get_line(auto cur_line);
      if (_LanguageInheritsFrom('c') && !_LanguageInheritsFrom('d') && cur_line=='}') {
         replace_line(strip(cur_line,'T'):+';');
      }
      if (_LanguageInheritsFrom('e') && cur_line=='}') {
         replace_line(strip(cur_line,'T'):+';');
      }

      restore_pos(AfterKeyinPos);
      return(0);
   }

   // do block surround only if we are already in a function scope
   if (_in_function_scope()) {
      do_surround_mode_keys();
   } else {
      clear_surround_mode_line();
   }
   return(0);
}

static _str prev_stat_has_semi()
{
   int status=1;
   up();
   if ( ! rc ) {
      int col=p_col;
      _end_line();
      _str line;
      get_line_raw(line);
      parse line with line '\#|/\*|//',(p_rawpos'r');
      /* parse line with line '{' +0 last_word ; */
      /* parse line with first_word rest ; */
      /* status=stat_has_semi() or line='}' or line='' or last_word='{' or first_word='case' */
      line=strip(line,'T');
      if (raw_last_char(line)==')') {
         save_pos(auto p);
         p_col=text_col(line);
         status=_find_matching_paren(def_pmatch_max_diff);
         if (!status) {
            status=search('[~( \t]','@-rh');
            if (!status) {
               if (!_clex_find(0,'g')==CFG_KEYWORD) {
                  status=1;
               } else {
                  int junk=0;
                  _str kwd=cur_word(junk);
                  status=(int) !pos(' 'kwd' ',' if do while switch for ');
               }
            }
         }
         restore_pos(p);
      } else {
         status=(int) (raw_last_char(line)!=')' && (int) !pos('(\}|)else$',line,1,p_rawpos'r'));
      }
      down();
      p_col=col;
   }
   return(status);
}
static _str stat_has_semi(...)
{
   _str line;
   get_line_raw(line);
   parse line with line '/*',p_rawpos;
   parse line with line '/\*|//',(p_rawpos'r');
   line=strip(line,'T');
   _str name=name_on_key(ENTER);
   return((raw_last_char(line):==';' || raw_last_char(line):=='}') &&
            (
               ! ((_will_split_insert_line()
                    ) && (p_col<=text_col(line) && arg(1)=='')
                   )
            )
         );

}

// Returns offset of end of expansion.
static long maybe_insert_braces(boolean noSpaceBeforeParen, boolean insertBraceImmediately, int width,
                                _str word,boolean no_close_brace=false, boolean parens=true)
{
   long rv; 

   int col=width+length(word)+3;
   updateAdaptiveFormattingSettings(AFF_PAD_PARENS | AFF_NO_SPACE_BEFORE_PAREN);
   // do this extra check because we might have forced in the no space before paren setting in c_expand_space
   bes_style := beaut_style_for_keyword(p_LangId, word, auto foundp);
   if ( noSpaceBeforeParen ) --col;
   if ( p_pad_parens ) ++col;
   if ( !parens ) --col;
   if ( bes_style == BES_BEGIN_END_STYLE_3 ) {
      width=width+p_SyntaxIndent;
   }
   rv = _QROffset();
   if ( insertBraceImmediately ) {
      int up_count=1;
      if ( bes_style == BES_BEGIN_END_STYLE_2 || bes_style == BES_BEGIN_END_STYLE_3 ) {
         up_count=up_count+1;
         insert_line(indent_string(width)'{');
      }
      if ( LanguageSettings.getInsertBlankLineBetweenBeginEnd(p_LangId) ) {
         up_count=up_count+1;
         if ( bes_style == BES_BEGIN_END_STYLE_3) {
            insert_line(indent_string(width));
         } else {
            insert_line(indent_string(width+p_SyntaxIndent));
         }
      }
      _end_line();
      add_hotspot();
      if (no_close_brace) {
         up_count--;
      } else {
         insert_line(indent_string(width)'}');
         set_surround_mode_end_line();
      }
      rv = _QROffset();
      up(up_count);
   }
   p_col=col;
   if ( ! _insert_state() ) _insert_toggle();
   return rv;
}
/*
   It is no longer necessary to modify this function to
   create your own main style.  Just define an extension
   specific alias.  See comment at the top of this file.

   NOTE: This function is not called for java.
*/
static int c_insert_main()
{
 //  updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT);
   main_style := LanguageSettings.getMainStyle(p_LangId);
   _begin_line();
   start := _QROffset();

   if ( main_style == CMS_KR/* K&R */) {
      replace_line('main(argc, argv)');
      insert_line('int argc;');
      insert_line('argv[];');
   } else {          /* ANSI / C++ */
#if __UNIX__
      // GNU c++ wants int return type
      replace_line('int main(int argc, char *argv[])');
#else
      replace_line('void main(int argc, char* argv[])');
#endif
   }

   insert_line('{');
   insert_line('');
   cpt := _QROffset();
   insert_line('}');
   endoff := _QROffset();

   if (new_beautifier_supported_language(p_LangId)) {
      long markers[];

      markers[0] = cpt;
      rv := new_beautify_range(start, endoff, markers);
      if (rv == 0) {
         _GoToROffset(markers[0]);
      }
      return rv;
   } else {
      _GoToROffset(cpt);
      p_col = p_SyntaxIndent+1;
   }
   return 0;
}

_command void c_dquote() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL|VSARG2_LASTKEY)
{
   if (command_state()) {
      call_root_key('"');
      return;
   }
   // Handle Assembler embedded in C
   typeless orig_values;
   int embedded_status=_EmbeddedStart(orig_values);
   if (embedded_status==1) {
      call_key(last_event(), "\1", "L");
      _EmbeddedEnd(orig_values);
      return; // Processing done for this key
   }

   /*insertBraceOn := LanguageSettings.getInsertBeginEndImmediately(p_LangId);
   if (insertBraceOn) {
      LanguageSettings.setInsertBeginEndImmediately(p_LangId, false);
   } */

   keyin(last_event());
   if (LanguageSettings.getAutoCompletePoundIncludeOption(p_LangId) == AC_POUND_INCLUDE_ON_QUOTELT) {
      _macro_delete_line();
      _do_list_members(false,true);
   }
}
defeventtab c_keys;
def  ' '= c_space;
def  '#'= c_pound;
def  '('= c_paren;
def  '*'= c_asterisk;
def  '.'= auto_codehelp_key;
def  '/'= c_slash;
def  ':'= c_colon;
def  ';'= c_semicolon;
def  '<'= auto_functionhelp_key;
def  '='= auto_codehelp_key;
def  '"'= c_dquote;
def  '>'= auto_codehelp_key;
def  '@'= c_atsign;
def  '\'= c_backslash;
def  '{'= c_begin;
def  '}'= c_endbrace;
def  'ENTER'= c_enter;
def  'TAB'= smarttab;

