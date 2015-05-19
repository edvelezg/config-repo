//https://community.slickedit.com/index.php/topic,11387.0.html
#include "slick.sh"

_command void PrintMacro()
{
   _str text = hs2_cur_word_sel();

   _begin_select();
   // Find end of statement. This handles multiple-line statements.
   search(";","@hXcs");

   insert_blankline_below();
   _insert_text('printf("' :+ text :+ ' = %s\n", ' :+ text :+ ');');
}

// The 'VSARG2_MARK' is added to get hs2_cur_word_sel to work correctly.
_command void PrintMacro2()  name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_PRO_EDITION|VSARG2_MARK)
{
   _str text = hs2_cur_word_sel();

   _begin_select();
   // Find end of statement. This handles multiple-line statements.
   search(";","@hXcs");

   insert_blankline_below();
   _insert_text('printf("' :+ text :+ '\n");');
}
