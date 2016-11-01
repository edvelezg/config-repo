/**
 * I Think this macro copies the diff file from a failed test. 
 * That is I copy it from eclipse's toolbar and paste it to an 
 * empty buffer. 
 */
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
