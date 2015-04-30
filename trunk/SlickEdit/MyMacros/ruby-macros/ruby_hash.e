// Ruby enhancement.
// « on: January 25, 2015, 10:46:20 PM »
// http://community.slickedit.com/index.php?topic=11098.msg46789;boardseen#new
#include "slick.sh"

#pragma option(strictsemicolons,on)
#pragma option(strict,on)
#pragma option(autodecl,off)
#pragma option(strictparens,on)


//_command void ruby_hash() name_info(','VSARG2_MULTI_CURSOR|VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL|VSARG2_LASTKEY)
//Graeme: It seems to work if there are no name_info options
//_command void ruby_hash() name_info(',')
// SlickEdit support have told me that I need VSARG2_MARK in the list of name_info options otherwise the selection gets cleared before the command is executed.
_command void ruby_hash() name_info(','VSARG2_CMDLINE|VSARG2_REQUIRES_EDITORCTL|VSARG2_LASTKEY|VSARG2_MARK)
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

// Defines a hotkey of # only under ruby-mode so that it doesn't do it with other languages
defeventtab ruby_keys;
def '#'= ruby_hash;

