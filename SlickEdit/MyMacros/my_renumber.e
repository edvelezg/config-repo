#include "slick.sh"

/* Demo for StackOverflow question 14205293 */
_command my_renumber() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   int not_found = 0; /* boolean to terminate loop */
   int iLoop = 0;     /* Counter to renumber items */

   /* Use search initially; if that call doen't find an item, we're done. */
   _str text = hs2_cur_word_sel()
   if (search(text :+ ':i', 'R') != 0) {
      not_found = 1;
   }

   while (!not_found) {
      if (search_replace(text :+ iLoop/2, 'R') == STRING_NOT_FOUND_RC) {
         not_found = 1;
      }
      iLoop++;
   }
}

_command int clip_bufname() name_info(','VSARG2_REQUIRES_EDITORCTL){
   push_clipboard_itype ('CHAR','',1,true);
   append_clipboard_text (p_buf_name);
   return(0);
}


_command delete_nodes() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   int not_found = 0; /* boolean to terminate loop */

   /* Use search initially; if that call doen't find an item, we're done. */
   _str text = "TopsData.npts" 
   if (search(text, 'R') != 0) {
      not_found = 1;
   }

      while (find_next() != STRING_NOT_FOUND_RC) {

         select_line();
         cursor_down(2);
         if (_select_type()=="LINE") {
            p_col=1;
         }
         delete_selection();
         not_found = 1;
      }
}
