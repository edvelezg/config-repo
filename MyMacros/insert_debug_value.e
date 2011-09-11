#include "slick.sh"

_command void insert_debug_value()
{
   // get the current word under the cursor
   int temp = 0;
   _str curWord = cur_word(temp);

   // report it
// say('curWord =' curWord);

// get the indentation of the current line
   first_non_blank();
   int indentCol = p_col -1;
   _str lineText = indent_string(indentCol);
   say(p_LangId);

   switch (p_LangId)
   {
   case 'e':
      //    Slick-c
      lineText :+= "say('"curWord" = '"curWord");";
      break;
   case 'c':
      //    C++
      lineText :+= "printf(\""curWord" = %s\", "curWord");";
      break;
   case 'ruby':
      //    Ruby
      lineText :+= "puts \""curWord:" #{"curWord"}\"";
      break;
   }

   insert_line(lineText);
}
