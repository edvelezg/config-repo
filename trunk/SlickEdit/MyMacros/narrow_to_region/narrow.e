#include "slick.sh"

/*

Provides functionality inspired by the emacs narrow-to-region

VSE has selective display functionality but you would need to 
painfully select two regions to hide, so instead of hiding the selection
these function toggle display of the unselected lines.

Bind 'narrowTog' to a key (or tool button, bmp icon attached)

Tested on VSE6.0c/Linux

Nevo Hed,  nhed@alum.wpi.edu

*/

_command void narrow_to_region(...) name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_AB_SELECTION|VSARG2_REQUIRES_SELECTION|VSARG2_REQUIRES_MDI_EDITORCTL|VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   markid=arg(1);

   if (!select_active(markid)) {
      _message_box(get_message(TEXT_NOT_SELECTED_RC));
      return;
   }
   
   save_pos(p);

   _begin_select(markid);
   first_line=p_line;
   if(first_line>1)
      first_line--;

   _end_select(markid);
   last_line=p_line;

   if (_select_type(markid)=='CHAR' && !_select_type(markid,'i')) {
      _get_selinfo(start_col,end_col,buf_id,markid);
      if (end_col==1) {
         --last_line;
      }
   }

   top(); 
   first_buff_line=p_line;
   bottom();
   last_buff_line=p_line;
   
   if(last_buff_line>last_line)
      last_line++;


   _deselect(markid);
   
   // remove any prior hidden blocks
   show_all();

   // hide before selection
   _hide_lines(first_buff_line, first_line);
   // hide after selection
   _hide_lines(last_line, last_buff_line);
   
   restore_pos(p);
}


_command void narrowTog(...) name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_MDI_EDITORCTL|VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   markid=arg(1);

   if (select_active(markid)) {
      show_all(); // if there was a prior selection - deselect 
      narrow_to_region();
      return;
   }

   
   save_pos(p);

   top();
   reg_end=reg_start=1;
   while(!down()){

      if(!(_lineflags() & HIDDEN_LF)) {
         // remember first line in region
         reg_end=reg_start=p_line;
         break;
      }
   }

   while(!down()){
      //say('l2: ' p_line ' f:'_lineflags())
      if(_lineflags() & (PLUSBITMAP_LF|MINUSBITMAP_LF)) {
         // remember first line in region
         reg_end=p_line;
         break;
      }
   }


   show_all();

   _deselect();
   p_line=reg_start;
   _select_line();
   p_line=reg_end;
   _select_line();
}



