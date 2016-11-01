//https://community.slickedit.com/index.php/topic,11387.0.html
#include "slick.sh"
#include "tagsdb.sh" // needed by getProtypeData.
#include "..\\common\\hs2_cur_word_sel.e"

// TODO: I've added this unused fn to this macro that I want to have eventually print some useful information on a selected text
// other than just code itself.
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

// The 'VSARG2_MARK' is added to get hs2_cur_word_sel to work correctly.
_command void PrintMacro2()  name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_PRO_EDITION|VSARG2_MARK)
{
   _begin_select();
   _str text = hs2_cur_word_sel();

   // Find end of statement. This handles multiple-line statements.
// search(";","@hXcs");

   insert_blankline_below();
   if (p_LangId == 'java') {
      _insert_text('System.out.println("' :+ escape_string(text, true) :+ '");');
   } else if (p_LangId == 'c') {
      _insert_text('_debug.printf("' :+ escape_string(text, true) :+ '\n");');
   }
}

_str escape_string(_str text, boolean do_esc)
{
    if (do_esc) {
        text = stranslate(text, "\\\\", "\\");
        text = stranslate(text, "\\\"", "\"");
#if 0
        text = stranslate(text, "\\r",  "\r");
        text = stranslate(text, "\\n",  "\n");
        text = stranslate(text, "\\t",  "\t");
#endif
    } else {
        text = stranslate(text, "\xFF", "\\\\");
        text = stranslate(text, "\"",   "\\\"");
        text = stranslate(text, "\t",   "\\t");
        text = stranslate(text, "\n",   "\\n");
        text = stranslate(text, "\r",   "\\r");
        text = stranslate(text, "\\",   "\xFF");
    }
    return (text);
}
