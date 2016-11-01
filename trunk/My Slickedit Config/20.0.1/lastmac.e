#include "slick.sh"
_command last_recorded_macro() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   _macro('R',1);
   activate_defs();
   cursor_down();
   cursor_up();
   cursor_down(3);
   cut();
   cursor_down();
   cursor_up();
   paste();
   prev_paragraph();
   cursor_down(2);
   select_line();
   find_matching_paren();
   execute('beautify');
}
