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

_command void PrintMacro2()
{
   _str text = hs2_cur_word_sel();

   _begin_select();
   // Find end of statement. This handles multiple-line statements.
   search(";","@hXcs");

   insert_blankline_below();
   _insert_text('printf("' :+ text :+ '\n");');
}
