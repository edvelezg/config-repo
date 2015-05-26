//https://community.slickedit.com/index.php/topic,11387.0.html
#include "slick.sh"
#include "..\\hs2_cur_word_sel.e"

// The 'VSARG2_MARK' is added to get hs2_cur_word_sel to work correctly.
_command void PrintMacro2()  name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_PRO_EDITION|VSARG2_MARK)
{
   _begin_select();
   _str text = hs2_cur_word_sel();

   // Find end of statement. This handles multiple-line statements.
   search(";","@hXcs");

   insert_blankline_below();
   if (p_LangId == 'java') {
      _insert_text('System.out.println("' :+ escape_string(text, true) :+ '");');
   } else if (p_LangId == 'c') {
      _insert_text('printf("' :+ escape_string(text, true) :+ '\n");');
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
