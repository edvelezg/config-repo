#include "slick.sh"
#include "tagsdb.sh"

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


static void getProtypeData()
{
   int  tagDatabaseIndex;
   _str tagDataTypeName;
   _str returns;
   _str functionName;
   _str argumentList;

   _UpdateContext(true);
   tagDatabaseIndex = tag_current_context();
   tag_get_detail2(VS_TAGDETAIL_context_return, tagDatabaseIndex, returns);    // what's returned by the function
   tag_get_detail2(VS_TAGDETAIL_context_name, tagDatabaseIndex, functionName); // returns the function name
   tag_get_detail2(VS_TAGDETAIL_context_args, tagDatabaseIndex, argumentList); // returns the argument list of a function

   say(returns);
   say(functionName);
   say(argumentList);
}
