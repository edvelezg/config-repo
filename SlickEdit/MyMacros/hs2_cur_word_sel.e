
#include "slick.sh"

// get currently marked string or current word if nothing selected ...
// delete selection after retrieving the text with del_sel != ''
_command _str hs2_cur_word_sel ( _str del_sel = '' ) name_info (','VSARG2_READ_ONLY|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   _str  cur_sel_word = '';
   int   first_col, last_col, buf_id, junk;

   // HS2: snipped from quick_search ()
   /* if there is no mark searches for the word at the cursor.
      if there is a mark, searches for the selected text if it is on a single line.
      Otherwise, searches for the word at the cursor within the mark
   */
   if ( select_active2 () )
   {
      if ( !_begin_select_compare () && !_end_select_compare () )
      {
         /* get text out of selection */
         _get_selinfo (first_col, last_col, buf_id );

         // say ( "mark: first_col=" first_col " last_col=" last_col );
         // handle def_select_style == 'CN' resp. 'CI' better
         if ( pos('I',def_select_style,1,'i') ) ++last_col;

         if ( _select_type ()=='LINE' )
         {
            get_line (line);
            cur_sel_word=line;
         }
         else
         {
            cur_sel_word=_expand_tabsc (first_col,last_col-first_col);
         }
      }
      else cur_sel_word=cur_word (junk,'',1);

      if (del_sel != '')
         delete_selection();
      else
         _deselect ();
   }
   else
   {
      if (del_sel != '')
      {
         // init_command_op may not be nested !
         init_command_op();

         _str ch=get_text(-1);
         do_word=pos('[\od'_extra_word_chars:+p_word_chars']',ch,1,'r') || ((p_UTF8 == 0) && _IsLeadByteBuf(get_text_raw()));
         // messageNwait ("do_word=" do_word);
         if (do_word) select_whole_word();
         else select_word();

         retrieve_command_results();

         delete_selection();
      }
      else cur_sel_word=cur_word (junk,'',1);
   }

   if ( (del_sel == '') && (cur_sel_word == '') )
   {
      _beep ();
      message (nls ('No word at cursor'));
   }

   // say ( "returning cur_sel_word='" cur_sel_word "'" );
   return( cur_sel_word );
}
