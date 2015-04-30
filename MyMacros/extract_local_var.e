#include "slick.sh"
_command extract_local_var() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   // Cut the selected text.
   cut();

   // Replace the cutted text with the  variable name.
   _str varName;
   get_string(varName, "Name of the variable: ");
   _insert_text(varName);

   // Add the variable assignment to the expression.
   insert_blankline_above();
   _insert_text(varName :+ " = ");
   paste();
}
