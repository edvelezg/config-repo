#include "slick.sh"
#include "tagsdb.sh"

#pragma option(strictsemicolons,on)
#pragma option(strict,on)
#pragma option(autodecl,off)
#pragma option(strictparens,on)



static int diff_region1_start_line;
static int diff_region1_end_line;
static boolean diff_region1_set;
static _str diff_region1_filename;
static boolean diff_region1_auto_length;
   
_command void xset_diff_region() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   if (_isno_name(p_DocumentName) || p_buf_name == '') {
      _message_box("Save the file before using this command");
      diff_region1_set = false;
      return;
   }

   if (select_active2()) {
      typeless p1;
      save_pos(p1);
      _begin_select();
      diff_region1_start_line = p_line;
      _end_select();
      diff_region1_end_line = p_line;
      restore_pos(p1);
      diff_region1_auto_length = false;
   }
   else
   {
      diff_region1_start_line = p_line;
      diff_region1_end_line = p_line + 50;
      diff_region1_auto_length = true;
   }
   diff_region1_filename = p_buf_name;
   diff_region1_set = true;
}
   
   
_command void xcompare_diff_region() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   if (_isno_name(p_DocumentName) || p_buf_name == '') {
      _message_box("Save the file before using this command");
      return;
   }

   if (diff_region1_set) {
      int diff_region2_start_line;
      int diff_region2_end_line;
      if (select_active2()) {
         typeless p1;
         save_pos(p1);
         _begin_select();
         diff_region2_start_line = p_line;
         if (diff_region1_auto_length && (diff_region1_filename == p_buf_name) 
                                                  && (diff_region1_start_line < p_line)) {
            if (diff_region1_end_line >= p_line) {
               diff_region1_end_line = p_line - 1;
            }
         }
         _end_select();
         diff_region2_end_line = p_line;
         restore_pos(p1);
      }
      else
      {
         diff_region2_start_line = p_line;
         if (diff_region1_auto_length && (diff_region1_filename == p_buf_name)
                                                  && (diff_region1_start_line < p_line)) {
            if (diff_region1_end_line >= p_line) {
               diff_region1_end_line = p_line - 1;
            }
         }
         diff_region2_end_line = p_line + (diff_region1_end_line - diff_region1_start_line) + 20;
      }

      _DiffModal('-range1:' :+ diff_region1_start_line ',' :+ diff_region1_end_line :+ 
           ' -range2:' :+ diff_region2_start_line ',' :+ diff_region2_end_line :+ ' ' :+ 
           maybe_quote_filename(diff_region1_filename) ' '  maybe_quote_filename(p_buf_name));
   }
}
   
   

/*
 * Function: xbeautify_project
 * Beautifies all files in the active project
 */
_command void xbeautify_project(boolean ask = true, boolean no_preview = false, boolean autosave = true) name_info(',')
{
   _str files_to_beautify [];

   //_GetWorkspaceFiles(_workspace_filename, files_to_beautify);
   _getProjectFiles( _workspace_filename, _project_get_filename(), files_to_beautify, 1);

   if (ask && !no_preview) {
      activate_preview();
   }

   int k;
   for (k = 0; k < files_to_beautify._length(); ++k) {
      if (ask) {

         if (!no_preview) {
            struct VS_TAG_BROWSE_INFO cm;
            tag_browse_info_init(cm);
            cm.member_name = files_to_beautify[k];
            cm.file_name = files_to_beautify[k];
            cm.line_no = 1;
            cb_refresh_output_tab(cm, true, false, false);
            _UpdateTagWindowDelayed(cm, 0);
         }

         _str res = _message_box("Beautify " :+ files_to_beautify[k], "Beautify project", MB_YESNOCANCEL|IDYESTOALL);
         if (res == IDCANCEL) return;
         if (res == IDNO) continue;
         if (res == IDYESTOALL) ask = false;
      }

      if (edit("+B " :+ files_to_beautify[k]) == 0) {
         beautify();
         if (autosave) save();
      }
      else
      {
         edit(files_to_beautify[k]);
         beautify();
         if (autosave) save();
         quit();
      }
   }
}




static _str get_search_cur_word()
{
   int start_col = 0;
   word := "";
   if (select_active2()) {
      if (!_begin_select_compare()&&!_end_select_compare()) {
         /* get text out of selection */
         last_col := 0;
         buf_id   := 0;
         _get_selinfo(start_col,last_col,buf_id);
         if (_select_type('','I')) ++last_col;
         if (_select_type()=='LINE') {
            get_line(auto line);
            word=line;
            start_col=0;
         } else {
            word=_expand_tabsc(start_col,last_col-start_col);
         }
         _deselect();
      }else{
         deselect();
         word=cur_word(start_col,'',1);
      }
   }else{
      word=cur_word(start_col,'',1);
   }
   return word;
}




_command int xsearch_workspace_cur_word_now() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   _str sw = get_search_cur_word();
   if (sw != '') {
      _str ss = _get_active_grep_view();
      _str grep_id = '0';
      if (ss != '') {
         parse ss with "_search" grep_id; 
      }
      return _mffind2(sw,'I','<Workspace>','*.*','','32',grep_id);
      //return _mffind2(sw,'I','<Workspace>','*.*','','32',auto_increment_grep_buffer());
   }
   return 0;
}


_command int xsearch_cur_word() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   _str sw = get_search_cur_word();
   if (sw == '') 
      return 0;

   int formid;
   if (isEclipsePlugin()) {
      show('-xy _tbfind_form');
      formid = _find_object('_tbfind_form._findstring');
      if (formid) {
         formid._set_focus();
      }
   } else {
      formid = activate_tool_window('_tbfind_form', true, '_findstring');
   }

   if (!formid) {
      return 0;
   }
   _control _findstring;
   formid._findstring.p_text = sw;
   formid._findstring._set_sel(1,length(sw)+1);
   return 1;
}


_command void xupcase_char()name_info(',' VSARG2_REQUIRES_EDITORCTL)
{
   _select_char();
   cursor_right();
   _select_char();
   upcase_selection();
}


_command void xlowcase_char()name_info(',' VSARG2_REQUIRES_EDITORCTL)
{
   _select_char();
   cursor_right();
   _select_char();
   lowcase_selection();
}


// copy path plus filename of the current buffer to the clipboard
_command xcurbuf_path_to_clip() name_info(','VSARG2_MACRO|VSARG2_READ_ONLY)
{
   _str str;
   if (_no_child_windows()) {
      return 0;
   }
   else { 
      str = _mdi.p_child.p_buf_name;
   }
   push_clipboard_itype('CHAR','',1,true);
   append_clipboard_text(str);
}

// copy name (excluding path) of the current buffer to the clipboard
_command xcurbuf_name_to_clip() name_info(','VSARG2_MACRO|VSARG2_READ_ONLY)
{
   if (_no_child_windows()) {
      return 0;
   }
   push_clipboard_itype('CHAR','',1,true);
   append_clipboard_text(strip_filename(_mdi.p_child.p_buf_name,'P'));
}

_command void xproject_name_to_clip() name_info(',')
{
   push_clipboard_itype('CHAR','',1,true);
   append_clipboard_text(_project_name);
}


// explore configuration folder
_command void explore_config() name_info(',')
{
   explore(_config_path());
}


static _str get_vsroot_dir()
{
   _str root_dir = get_env('VSROOT');
   _maybe_append_filesep(root_dir);
   return root_dir;
}

// explore slickedit installation folder
_command void explore_vslick() name_info(',')
{
   explore(get_vsroot_dir());
}


// explore slickedit installation docs folder
_command void explore_docs() name_info(',')
{
   explore(get_vsroot_dir() :+ 'docs');
}

// explore active project vpj folder
_command void explore_vpj() name_info(',')
{
   explore(_project_name);
}


// explore current buffer or pathname (if supplied as first parameter)
_command void explore_cur_buffer() name_info(',')
{
   if (arg()) {
      if (file_exists(arg(1))) {
         explore(arg(1));
         return;
      } 
   }
   if (_no_child_windows()) {
      return;
   }

   if (file_exists(_mdi.p_child.p_buf_name)) {
      explore( _mdi.p_child.p_buf_name );
   }
}


static _str get_open_path(...)
{
   if (arg()) {
      if (file_exists(arg(1))) {
         return arg(1);
      } 
   }
   if (_no_child_windows()) {
      return strip_filename(_project_get_filename(),'N');
   }
   else if (file_exists(_mdi.p_child.p_buf_name)) {
      return strip_filename(_mdi.p_child.p_buf_name,'N');
   } else {
      return strip_filename(_project_get_filename(),'N');
   }
}

// open from path of current buffer or from specified path (if supplied as
// the first parameter
_command void xopen_from_here() name_info(',')
{
   chdir(get_open_path(arg(1)),1);
   gui_open();
}

// open from configuration folder
_command void xopen_from_config() name_info(',')
{
   chdir(_config_path(),1);
   gui_open();
}


// open vsstack error file
_command void xopvss() name_info(',')
{
   edit(strip_filename(GetErrorFilename(),'N') :+ 'vsstack');
}


_menu xmenu1 {
   "|&Set diff region", "xset_diff_region", "","","";
   "Compare |&Diff region", "xcompare_diff_region", "","","";
   "|&Beautify project", "xbeautify_project", "","","";
   "--","","","","";
   "Copy Buffer |&Name","xcurbuf-name-to-clip","","",""; 
   "Copy Buffer |&Path","xcurbuf-path-to-clip","","",""; 
   "Copy Active Pro|&Ject Name","xproject_name_to_clip","","",""; 
   "--","","","","";

   submenu "&|Complete","","","" {
      "complete-prev-no-dup","complete_prev_no_dup","","","";
      "complete-next-no-dup","complete_next_no_dup","","","";
      "complete-prev","complete_prev","","","";
      "complete-next","complete_next","","","";
      "complete-|&List","complete_list","","","";
      "complete-more","complete_more","","","";
   }

   submenu "Select / |&Hide","","","" {
      "select code block","select_code_block","","","";
      "select paren","select_paren_block","","","";
      "select procedure", "select_proc", "","","";
      "hide code block","hide_code_block","","","";
      "hide selection","hide_selection","","","";
      "hide comments","hide_all_comments","","","";
      "show all","show-all","","","";
   }

   submenu "Open / E|&Xplore","","open-file or explore folder","" {
      "Open from here","xopen_from_here","","","open from current buffer path";
      "Open from config","xopen_from_config","","","open file from configuration folder";
      "Open vsstack error file","xopvss","","","Open Slick C error file";
      "-","","","","";
      "Explore current buffer","explore_cur_buffer","","","explore folder of current buffer";
      "Explore config folder","explore_config","","",""; 
      "Explore installation folder", "explore_vslick","","",""; 
      "Explore docs","explore_docs","","",""; 
      "Explore project","explore_vpj","","","";
   }

   submenu "&Case conversion","","","" {
      "&Lowcase selection","lowcase-selection","","","";
      "&Upcase selection","upcase-selection","","","";
      "Lowcase word","lowcase-word","","","";
      "Upcase word","upcase-word","","","";
      "Upcase &char","xupcase-char","","","";
      "Lowcase &char","xlowcase-char","","","";
      "Cap &selection","cap-selection", "","","";
   }

}



_command show_xmenu1() name_info(',')
{
   mou_show_menu('xmenu1');
}


