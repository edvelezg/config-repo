////////////////////////////////////////////////////////////////////////////////////
// $Revision: 48910 $
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
#import "adaptiveformatting.e"
#import "alias.e"
#import "alllanguages.e"
#import "autocomplete.e"
#import "c.e"
#import "cutil.e"
#import "main.e"
#import "notifications.e"
#import "optionsxml.e"
#import "plsql.e"
#import "seek.e"
#import "setupext.e"
#import "slickc.e"
#import "stdcmds.e"
#import "stdprocs.e"
#import "surround.e"
#endregion

using se.lang.api.LanguageSettings;

/*
  To install this macro, perform use
  the Load module dialog box ("Macro", "Load Module...").


  IF  BEGIN
  END
  WHILE  BEGIN
  END

*/

#define SQLSERVER_LANGUAGE_ID 'sqlserver'
#define SQLSERVER_MODE_NAME   'SQL Server'
#define SQLSERVER_VLXLEXERNAME 'SQL Server'
// The funky symbols at the end are yen and pound symbols
// Try the courier font for them to display correctly.
#define SQLSERVER_IDENTIFIER_CHARS  'A-Za-z0-9_$#@\x{a5}\x{a3}'

/**
 * @deprecated Use {@link LanguageSettings_API}
 */
boolean def_sqlserver_autocase=0;

defload()
{
   _str setup_info='MN='SQLSERVER_MODE_NAME',TABS=+3,MA=1 74 1,':+
                   'KEYTAB='SQLSERVER_LANGUAGE_ID'-keys,WW=1,IWT=0,ST='DEFAULT_SPECIAL_CHARS',IN=2,WC='SQLSERVER_IDENTIFIER_CHARS',LN='SQLSERVER_VLXLEXERNAME',CF=1,';
   _str compile_info='';
   // The first two number are syntax_indent amount and expand on/off
   // the restore of
   _str syntax_info='3 1 ':+    // <Syntax indent amount>  <expansion on/off>
                    '1 -1 0';   // <min abbrev> <word_case> <begin/end style>
   _str be_info='';
   
   _CreateLanguage(SQLSERVER_LANGUAGE_ID, SQLSERVER_MODE_NAME,
                   setup_info, compile_info, syntax_info, be_info);
   _CreateExtension('sqlserver', SQLSERVER_LANGUAGE_ID);
   _CreateExtension('sybase', SQLSERVER_LANGUAGE_ID);

   kt_index := find_index('sqlserver-keys', EVENTTAB_TYPE);
   if (kt_index) {
      set_eventtab_index(kt_index,event2index(ENTER),find_index('sqlserver-enter',COMMAND_TYPE));
      set_eventtab_index(kt_index,event2index(' '),find_index('sqlserver-space',COMMAND_TYPE));
   }

   LanguageSettings.setReferencedInLanguageIDs(SQLSERVER_LANGUAGE_ID, "ansic c cob cob2000 cob74 db2 plsql");
   /*index=find_index('def-language-sql',MISC_TYPE);
   if (index && substr(name_info(index),1,1)!='@') {
      delete_name(index);
      insert_name('def-language-sql',MISC_TYPE,'@plsql');
   } */
}

defeventtab sqlserver_keys;
//def ' '=sql_space
//def ENTER=sql_enter*/

_command sqlserver_mode()  name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY|VSARG2_ICON)
{
   _SetEditorLanguage(SQLSERVER_LANGUAGE_ID);
}
_command void sqlserver_enter() name_info(','VSARG2_CMDLINE|VSARG2_ICON|VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   generic_enter_handler(_sqlserver_expand_enter);
}

_command sqlserver_space() name_info(','VSARG2_CMDLINE|VSARG2_LASTKEY|VSARG2_REQUIRES_EDITORCTL)
{
   if ( command_state() || ! doExpandSpace(p_LangId) || p_SyntaxIndent<0 ||
      _in_comment() ||
      sqlserver_expand_space(p_SyntaxIndent) ) {
      if ( command_state() ) {
         call_root_key(' ');
      } else {
         keyin(' ');
         typeless orig_pos=0;
         save_pos(orig_pos);
         left();left();
         int cfg=_clex_find(0,'g');
         if (cfg==CFG_KEYWORD && LanguageSettings.getAutoCaseKeywords(p_LangId)) {
            int word_pcol=0;
            _str cw=cur_word(word_pcol);
            p_col=_text_colc(word_pcol,'I');
            _delete_text(length(cw));
            _insert_text(_word_case(cw));
         }
         restore_pos(orig_pos);
      }
   } else if (_argument=='') {
      _undo('S');
   }
}

static SYNTAX_EXPANSION_INFO sqlserver_space_words:[] = {
   'if'           => { "if ... begin ... end" },
   'while'        => { "while ... begin ... end" },
   'return'       => { "return" },
   'exception'    => { "exception" },
   'else'         => { "else" },
};


/*
    Returns true if nothing is done
*/
boolean _sqlserver_expand_enter()
{
   updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT);
   int syntax_indent = p_SyntaxIndent;

   save_pos(auto p);
   int orig_linenum=p_line;
   int orig_col=p_col;
   _str enter_cmd=name_on_key(ENTER);
   if (enter_cmd=='nosplit-insert-line') {
      _end_line();
   }
   save_pos(auto p2);
   _clex_skip_blanks('-');
   int junk=0;
   _str word=lowcase(cur_word(junk));
   if (word=='begin') {
      first_non_blank();
      word=lowcase(cur_word(junk));
      if (word=='if' || word=='while') {
         restore_pos(p2);
         indent_on_enter(syntax_indent);
         return(false);
      }
   }
   restore_pos(p);
   return(true);
}
/*
    Returns true if nothing is done.
*/
static boolean sqlserver_expand_space(int syntax_indent)
{
   updateAdaptiveFormattingSettings(AFF_SYNTAX_INDENT);
   syntax_indent = p_SyntaxIndent;

   boolean status=false;
   _str orig_line='';
   get_line(orig_line);
   _str line=strip(orig_line,'T');
   _str orig_word=strip(line);
   if ( p_col!=text_col(_rawText(line))+1 ) {
      return(1);
   }
   int if_special_case=0;
   _str aliasfilename='';
   _str word=min_abbrev2(orig_word,sqlserver_space_words,name_info(p_index),aliasfilename);

   // can we expand an alias?
   if (!maybe_auto_expand_alias(orig_word, word, aliasfilename, auto expandResult)) {
      // if the function returned 0, that means it handled the space bar
      // however, we need to return whether the expansion was successful
      return (expandResult != 0);
   }

   if ( word=='') return(1);

   line=substr(line,1,length(line)-length(orig_word)):+word;
   int width=text_col(_rawText(line),_rawLength(line)-_rawLength(word)+1,'i')-1;
   orig_word=word;
   word=lowcase(word);
   doNotify := true;
   if ( word=='if' ) {
      set_surround_mode_start_line();
      replace_line(_word_case(line:+'  begin'));
      insert_line(indent_string(width)_word_case('end'));
      set_surround_mode_end_line();
      up();_end_line();p_col-=6;
   } else if (word=='while') {
      set_surround_mode_start_line();
      replace_line(_word_case(line:+'  begin'));
      insert_line(indent_string(width)_word_case('end'));
      set_surround_mode_end_line();
      up();_end_line();p_col-=6;
   } else {
     status=true;
     doNotify = false;
   }

   if (!do_surround_mode_keys(false, NF_SYNTAX_EXPANSION) && doNotify) {
      // notify user that we did something unexpected
      notifyUserOfFeatureUse(NF_SYNTAX_EXPANSION);
   }

   return status;
}

int _sqlserver_get_syntax_completions(var words, _str prefix="", int min_abbrev=0)
{
   return AutoCompleteGetSyntaxSpaceWords(words, sqlserver_space_words, prefix, min_abbrev);
}
/*
static boolean _isProtoType()
{
   save_pos(orig_pos);
   save_search(p1,p2,p3,p4);
   status=search('as','@hrixcs');
   for (;;) {
      if (status) {
         return(status);
      }
      if (match_length()==1) {
         cw=';';
         break;
      }
      cw=upcase(cur_word(junk));
      if(cw=='IS' || cw=='AS') {
         break;
      }
      status=repeat_search();
   }
   restore_search(p1,p2,p3,p4);
   restore_pos(orig_pos);
   return(cw==';');
}
*/
static _str gtkinfo;
static _str gtk;

static _str sqlserver_next_sym(boolean multiline=false)
{
   if (p_col>_text_colc()) {
      if (!multiline) {
         gtk=gtkinfo='';
         return(gtk);
      }
      if(down()) return('');
      _begin_line();
   }
   int status=0;
   _str ch=get_text();
   if (ch=='' || ((ch=='/' || ch=='-') && _clex_find(0,'g')==CFG_COMMENT)) {
      status=_clex_skip_blanks();
      if (status) {
         gtk=gtkinfo='';
         return(gtk);
      }
      return(sqlserver_next_sym(multiline));
   }
   int start_col=0;
   int start_line=0;
   if ((ch=='"' || ch=="'" ) && _clex_find(0,'g')==CFG_STRING) {
      start_col=p_col;
      start_line=p_line;
      status=_clex_find(STRING_CLEXFLAG,'n');
      if (status) {
         _end_line();
      } else if (p_col==1) {
         up();_end_line();
      }
      gtk=TK_STRING;
      gtkinfo=_expand_tabsc(start_col,p_col-start_col+1);
      return(gtk);
   }
   word_chars := _clex_identifier_chars();
   if (pos('['word_chars']',ch,1,'r')) {
      start_col=p_col;
      if(_clex_find(0,'g')==CFG_NUMBER) {
         for (;;) {
            if (p_col>_text_colc()) break;
            right();
            if(_clex_find(0,'g')!=CFG_NUMBER) {
               break;
            }
         }
         gtk=TK_NUMBER;
         gtkinfo=_expand_tabsc(start_col,p_col-start_col+1);
         return(gtk);
      }
      search('[~'word_chars']|$','h@r');
      gtk=TK_ID;
      gtkinfo=_expand_tabsc(start_col,p_col-start_col);
      return(gtk);
   }
   right();
   gtk=gtkinfo=ch;
   return(gtk);

}
static int get_next_decl(_str &name,_str &type,_str &return_type)
{
   save_search(auto s1,auto s2,auto s3,auto s4,auto s5);
   sqlserver_next_sym();
   if (gtk=='') {
      restore_search(s1,s2,s3,s4,s5);
      return(1);
   }
   if (gtkinfo==',') {
      sqlserver_next_sym(1);
      if (gtk=='') {
         restore_search(s1,s2,s3,s4,s5);
         return(1);
      }
   }
   // If we are NOT sitting on a variable
   if (gtk!=TK_ID) {
      restore_search(s1,s2,s3,s4,s5);
      return(1);
   }
   name=gtkinfo;
   type='var';
   // Skip over variable name
   word_chars := _clex_identifier_chars();
   search('[~'word_chars']|$','hri@');
   int start=_nrseek();
   for(;;) {
      sqlserver_next_sym();
      if (gtk=='' || gtk==',') {
         break;
      }
   }
   if (gtk==',') {
      return_type=strip(get_text(_nrseek()-start-1,start));
   } else {
      return_type=strip(get_text(_nrseek()-start,start));
   }
   if (lowcase(return_type)=='cursor') {
      type='cursor';
   }
   return(0);
}

_str sqlserver_proc_search(_str &proc_name,int find_first)
{
   static int state;
   int status=0;
   _str variable_re='', re='';
   if ( find_first ) {
      state=0;
      word_chars := _clex_identifier_chars();
      variable_re='(['word_chars']#)';
      re='{#1(proc|procedure|trigger|declare)}[ \t]+\c{#0'variable_re'}';
         //_mdi.p_child.insert_line(re);
      mark_option := (p_EmbeddedLexerName != '')? 'm':'';
      status=search(re,'w:phri'mark_option'@xcs');
   } else {
      if (state) {
         status=0;
      } else {
         status=repeat_search();
      }
   }

   _str name='';
   _str type='';
   _str return_type='';
   _str keyword='';
   typeless orig_pos;
   save_pos(orig_pos);
   for (;;) {
      if ( status ) {
         restore_pos(orig_pos);
         break;
      }
      if (state) {
         status=get_next_decl(name,type,return_type);
         //messageNwait('n='name' type='type);
         if (status) {
            state=0;
            word_chars := _clex_identifier_chars();
            variable_re='(['word_chars']#)';
            re='{#1(proc|procedure|trigger|declare)}[ \t]+\c{#0'variable_re'}';
               //_mdi.p_child.insert_line(re);
            status=search(re,'w:phri@xcs');
            continue;
         }
      } else {
         name=get_match_text(0);
         keyword=get_match_text(1);
         if (lowcase(name)=='for') {
            status=repeat_search();
            continue;
         }
         if (lowcase(keyword)=='declare') {
            state=1;
            status=get_next_decl(name,type,return_type);
            //messageNwait('s='status' n='name' t='type);
            if (status) {
               state=0;
               word_chars := _clex_identifier_chars();
               variable_re='(['word_chars']#)';
               re='{#1(proc|procedure|trigger|declare)}[ \t]+\c{#0'variable_re'}';
                  //_mdi.p_child.insert_line(re);
               status=search(re,'w:phri@xcs');
               continue;
            }
         } else {
            // make sure the first word on this line is NOT DROP
            _str line='';
            get_line(line);
            _str first_word='';
            parse line with first_word .;
            if (lowcase(first_word)=='drop') {
               status=repeat_search();
               continue;
            }
            type='func';
            return_type='';
         }
      }
      name=tag_tree_compose_tag(name,'',type,0,'',return_type);
      if (proc_name:=='') {
         //restore_pos(orig_pos);
         proc_name=name;
         return(0);
      }
      if (proc_name==name) {
         //restore_pos(orig_pos);
         return(0);
      }
      if (state) {
         status=0;
      } else {
         status=repeat_search();
      }
   }
   return(status);
}

/*
    This functions make show_procs smarter by showing user
    all parameters and attributes of the function definition
    but not the code.
*/
void sqlserver_find_lastprocparam()
{
   save_pos(auto p);
   int startpos=_nrseek();
   int status=search("as","hwixcs");
   if (status) {
      restore_pos(p);
      return;
   }
   int orig_col=p_col;
   first_non_blank();
   if (p_col==orig_col) {
      up();_end_line();
   }
}



defeventtab sqlserver_keys;
def  'a'-'z','A'-'Z','0'-'9','$','_','#'= sqlserver_maybe_case_word;
def  'BACKSPACE'= sqlserver_maybe_case_backspace;
def  '%'-'/'=;
//def ' '=sql_space;
//def ENTER=sql_enter;*/

static int gWordEndOffset=-1;
static _str gWord;
//Returns 0 if the letter wasn't upcased, otherwise 1
_command void sqlserver_maybe_case_word() name_info(','VSARG2_CMDLINE|VSARG2_LASTKEY|VSARG2_REQUIRES_EDITORCTL)
{
   _maybe_case_word(LanguageSettings.getAutoCaseKeywords(SQLSERVER_LANGUAGE_ID),gWord,gWordEndOffset);
}

_command void sqlserver_maybe_case_backspace() name_info(','VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL)
{
   _maybe_case_backspace(LanguageSettings.getAutoCaseKeywords(SQLSERVER_LANGUAGE_ID),gWord,gWordEndOffset);
}

/* Desc: Find the matching begin/end.

   Supported combinations:
      begin -- end
      if -- begin end
      while -- begin end
      case -- end

   Example:
      procedure calc1 is
      begin                 <-------+
         if @varTest = 7    <---+-+ |
         begin              <---+ | |
            calc2(month);       | | |
         end                <---+-+ |
      end;                  <-------+


      while inrange(currentrow)    <------+-+
      begin                        <------+ |
         when nodatafound then            | |
            withinthreshold := 1;         | |
      end;                         <------+-+
*/
int _sqlserver_find_matching_word(boolean quiet)
{
   //say("_plsql_find_matching_word");
   typeless ori_position;
   save_pos(ori_position);

   // Get current word at cursor:
   int start_col=0;
   _str word = cur_identifier(start_col);
   if (word == "") {
      restore_pos(ori_position);
      if (!quiet) {
         message(nls('Not on begin/end or word pair'));
      }
      return 1;
   }
   word = lowcase(word);

   // Only some words have matching words. Find the actual word
   // to match and the expected word to match.
   _str direction="";
   if (word == "begin" || word=="if" || word=="while" || word=="case") {
      direction = "";
   } else if (word == "end" || word == "commit") {
      direction = "-";
   } else {
      restore_pos(ori_position);
      if (!quiet) {
         message(nls('Not on begin/end or word pair'));
      }
      return 1;
   }

   // Find the matching word:
   int status = matchWord(word, direction);
   if (!status) {
      restore_pos(ori_position);
      if (!quiet) {
         message(nls('Matching word not found'));
      }
      return 1;
   }

   return 0;
}

// Desc: Match the word
// Retn: 1 for word matched, 0 not
static int matchWord(_str word, _str direction='')
{
   // match in specified direction
   int level = 0;
   int status = 0;
   long begin_pos=-1;
   if (word=="begin" || word=="case" || word=="end" || word=="commit") {
      level++;
   }

   word_chars := _clex_identifier_chars();
   while (1) {
      // Skip over the current word:
      status = search(" |[~"word_chars"]|$", direction"rh@XCS");
      if (status) {
         if (begin_pos >= 0) {
            _GoToROffset(begin_pos);
            return 1;
         }
         return 0;
      }

      // Search for next block key word:
      status = search("begin|end|while|if|case|commit", direction"rhw@iCK");
      if (status) {
         if (begin_pos >= 0) {
            _GoToROffset(begin_pos);
            return 1;
         }
         return 0;
      }

      // Check new block keyword. If keyword indicates a new
      // block, increase the nesting level. Otherwise, decrease
      // the nesting level. If current nesting level is 0, we've
      // found the matching word.
      int start_col=0;
      _str current = cur_identifier(start_col);
      current = lowcase(current);

      // go back to position of 'begin'
      if (begin_pos >= 0) {
         if (current!="if" && current!="while") {
            _GoToROffset(begin_pos);
         }
         return 1;
      }

      // direction is '' for forward, '-' for backward
      if (current == "begin" || current == "case") {
         if (direction=='') {
            level++;
         } else {
            level--;
            if (!level) {     // set our begin position
               begin_pos=_QROffset();
            }
         }
      } else if (current == "end" || current == "commit") {
         if (direction=='') {
            level--;
            if (!level) {
               return 1;
            }
         } else {
            level++;
         }
      } else if (current == "if" || current=="while") {
         if (!level && direction=='-') {
            return 1;
         }
      } else {
         return 0;
      }
   }

   return 0;
}

