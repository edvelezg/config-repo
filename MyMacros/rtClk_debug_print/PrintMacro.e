#include "slick.sh"

_command void generate_debug_select() name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_PRO_EDITION)
{
   _str text = hs2_cur_word_sel();

   // put the cursor on the first line of the selection 
   _begin_select();
   // get the indentation of the current line
   first_non_blank();
   int indentCol = p_col - 1;
   // start building the new line of code
   _str indentText = indent_string(indentCol);

   line := indentText :+ 'printf("' :+ text :+ '\n"' :+ ');';
   insert_line(line);
}

static _str get_line_leading_whitespace2(_str text='', boolean including_newlines=false)
{
   if(text == '') {
      get_line(text);
   }
   // Grab leading whitespace
   _str leading_indention = ""; 
   int p;
   if(including_newlines) {
      p = pos("[^ \t\n\r]", text, 1, "U");
   } else {
      p = pos("[^ \t]", text, 1, "U");
   }
   if(p > 1) {
      leading_indention = substr(text, 1, p-1);
   }
   return leading_indention;
}
