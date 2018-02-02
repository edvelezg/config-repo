#include "slick.sh"

static _str MST_Get_Selected_Text(boolean OneLine=false)
{
   _str text='',Result='';
   int i=0,Start=0,Stopp=0;
   i = _get_selinfo(Start,Stopp,0);
   if (i != TEXT_NOT_SELECTED_RC) {
      filter_init();
      while (filter_get_string(text) == 0) {
         if (OneLine) {
            return(text);
         }
         if (Result != "") {
            Result=Result :+ "\n";
         }
         Result=Result :+ text;
      }
      filter_restore_pos();
   }
   return(Result);
}

_command copy_unit_test_diff_file() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   _str text = '.xml''';
// top_of_buffer();
   if (search(text, 'E>')) stop();
   cursor_left();
   select_char();
   if (search('''C','-E')) stop();
   cursor_right();
   _str filePath = MST_Get_Selected_Text();

   _copy_text_to_clipboard(filePath);
}


static _str remove_chars(_str text)
{
   text = substr(text, 4, length(text)-6);
   say(text);
   return(text);
}

static _str get_clipboard()
{
   _str cbtype = _getClipboardMarkType();
   if ((cbtype != "BLOCK") && (cbtype != "")) {
      boolean utf8 = p_UTF8;
      get_window_id(auto window_id);
      _create_temp_view(auto temp_wid);
      p_UTF8 = utf8;
      _str result = null;
      if (paste() == 0) {
         bottom();
         int delta = _line_length(true) - _line_length(false);
         top();
         result = get_text(p_buf_size - delta);
      }
      _delete_temp_view(temp_wid);
      p_window_id = window_id;
      return(result);
   }
   return(null);
}

static void set_clipboard(_str text)
{
    _str orig_markid = _duplicate_selection('');
    _str temp_markid = _alloc_selection();
    if (temp_markid < 0) {
        return;
    }
    _show_selection(temp_markid);

    int temp_view_id;
    int orig_view_id = _create_temp_view(temp_view_id);
    _insert_text(text);

    _deselect();
    top(); _select_char();
    bottom(); _select_char();
    copy_to_clipboard();

    if (orig_markid >= 0) {
        _show_selection(orig_markid);
    }
    _free_selection(temp_markid);
    _delete_temp_view(temp_view_id);
    activate_window(orig_view_id);
}

/* Demo for StackOverflow question 14205293 */
_command void copy_unit_test_diff() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   /* Use search initially; if that call doen't find an item, we're done. */
   _str text = '.txt';
   if (search(text, 'E') != 0) {
      return;
   }

   if (copy_full_word() != 0) {
      return;
   }
   _str clipd = get_clipboard();
   if (clipd != null) {
      free_clipboard(1);
      set_clipboard(remove_chars(clipd));
   }
}

/* Demo for StackOverflow question 14205293 */
_command void copy_buf_name_noext() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
	/* Remove the first 5 chars of the filename */
   _copy_text_to_clipboard(substr(_strip_filename(p_buf_name,'PE'), 5));
// _copy_text_to_clipboard(_strip_filename(p_buf_name,'PE'));
}

_command void copy_unix_path() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
	/* Remove the first 5 chars of the filename */
   _str dirName = _strip_filename(p_buf_name,'N');
   _str filName = _strip_filename(p_buf_name,'P');
   say(dirName :+ filName);
   _str unixHome = '/home/qa';
   _str windHome = 'C:\tibco\lin64vm465.qa.datasynapse.com\TIB_GridServer_5.2.0\'
   _str relaPath = substr(dirName, windHome._length());
   relaPath = stranslate(relaPath, '/',   '\');
   _str fullPath = unixHome :+ relaPath
   say(fullPath :+ filName);
   _copy_text_to_clipboard(fullPath :+ filName);
// _copy_text_to_clipboard(_strip_filename(p_buf_name,'PE'));
}

_command void copy_unix_dir_path() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
	/* Remove the first 5 chars of the filename */
   _str dirName = _strip_filename(p_buf_name,'N');
   _str filName = _strip_filename(p_buf_name,'P');
   say(dirName);
   _str unixHome = '/home/qa';
   _str windHome = 'C:\tibco\lin64vm465.qa.datasynapse.com\TIB_GridServer_5.2.0\'
   _str relaPath = substr(dirName, windHome._length());
   relaPath = stranslate(relaPath, '/',   '\');
   _str fullPath = unixHome :+ relaPath
   say(fullPath);
   _copy_text_to_clipboard(fullPath);
// _copy_text_to_clipboard(_strip_filename(p_buf_name,'PE'));
}

_command void copy_buf_name_dir() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _copy_text_to_clipboard(_strip_filename(p_buf_name,'N'));
}

def  'A-C' 'd' = copy_buf_name_dir;
def  'A-C' 'f' = copy_buf_name;
def  'A-C' 'n' = copy_buf_name_only;
def  'A-C' 'e' = copy_buf_name_noext;
def  'A-C' 'u' 'd' = copy_unix_dir_path;
def  'A-C' 'u' 'f' = copy_unix_path;
