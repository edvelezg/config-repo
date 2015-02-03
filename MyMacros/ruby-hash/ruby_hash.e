#include "slick.sh"

#pragma option(strictsemicolons,on)
#pragma option(strict,on)
#pragma option(autodecl,off)
#pragma option(strictparens,on)


_command void ruby_hash() name_info(','VSARG2_MULTI_CURSOR|VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL|VSARG2_LASTKEY)
{
   if (command_state()) {
      call_root_key('#');
      return;
   }
   
   if (!_LanguageInheritsFrom("ruby")) {
      call_root_key('#');
      return;
   }

   typeless pos1, pos2;
   if (select_active()) {
      save_pos(pos1);
      _begin_select();
      if (!_in_string()) {
         restore_pos(pos1);
         call_root_key('#');
         return;
      }
      _save_pos2(pos2);
      _end_select();
      deselect();
      _insert_text("}");
      _restore_pos2(pos2);
      _insert_text("#{");
      return;
   }

   if (!_in_string()) {
      call_root_key('#');
      return;
   }

   _insert_text("#{}");
   cursor_left();
}
