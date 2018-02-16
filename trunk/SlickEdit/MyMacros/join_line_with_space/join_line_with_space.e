#include "slick.sh"

_command void join_line_with_space() name_info(','VSARG2_REQUIRES_EDITORCTL)
{
   save_pos(p);
   end_line();
   last_event(name2event(' '));maybe_complete();
   linewrap_delete_char();
   restore_pos(p)
   // I need to check this out: join_lines()
}

_command void join_lines() name_info(','VSARG2_MULTI_CURSOR|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   if (select_active()) {
      int i;
      _str num_lines = count_lines_in_selection();
      if (!isinteger(num_lines)) {
         // ?
         message("Bad selection.");
         return;
      }
      int nl = (int)num_lines;
      begin_select();
      typeless p;
      _save_pos2(p);
      for (i = 0; i < nl - 1; i++) {
         join_line_with_space();
      }
      _restore_pos2(p);
   } else {
      join_line();
   }
}

def 'A-S-J' 'l'=join_lines;
