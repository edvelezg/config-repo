#include "slick.sh"

_command void PrintMacro()
{
   _str text = hs2_cur_word_sel();
   insert_blankline_below();
   _insert_text('_debug.printf("' :+ text :+ ' = %s\n", ' :+ text :+ ');');
}

_command void PrintMacro2()
{
   _str text = hs2_cur_word_sel();
   insert_blankline_below();
   _insert_text('_debug.printf("' :+ text :+ '\n");');
}
