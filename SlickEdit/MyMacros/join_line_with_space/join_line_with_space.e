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
