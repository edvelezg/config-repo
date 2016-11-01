// I created this this macro based on: Joseph Van Valen (aligneq.e)
// File:       alignchars.e
// Author:     EdgeVel
//
// Description:
// Implements three commands borrowed from other editors. The common thread                  
// between each of the commands is that they operate on selected text and use                
// the selection filter techniques supplied by Visual SlickEdit.                             

#include "slick.sh"

static int gMaxCharCol;
static _str gUsrStr;

static _str find_max_char_filter(s)
{
   _str inputStr = expand_tabs(s);
   int equalsPos = pos(gUsrStr, inputStr, 1, "");
   if ( equalsPos > gMaxCharCol  ) {
      gMaxCharCol = equalsPos;
   }

   return s;
}

static _str align_char_filter(s)
{
   if (gMaxCharCol <= 0 || length(s) == 0) {
      return s;
   }

   _str expandedStr = expand_tabs(s);

   int equalsPos  = pos(gUsrStr, expandedStr, 1, "");
   if (equalsPos == 0) {
      return s;
   }

   _str prefix    = substr(expandedStr, 1, equalsPos - 1);
   _str postfix   = substr(expandedStr,equalsPos);

   while (equalsPos < gMaxCharCol ) {
      prefix = prefix :+ ' ';
      ++equalsPos;
   }

   return prefix :+ postfix;
}

_command void align_chars() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{

   if (_select_type() == "") {
      select_paragraph()
   } else if (_select_type() != "LINE" && _select_type() != "BLOCK") {
      // Convert it into a LINE selection
      _select_type('', 'T', 'LINE');
   }

   gMaxCharCol = 0;
   _str prmpt = "";
   gUsrStr   = prompt(prmpt, "Please enter a string: ");
   filter_selection(find_max_char_filter);

   if (gMaxCharCol == 0) {
      // no equal signs
      return;
   }

   filter_selection(align_char_filter);
   _free_selection("");
}
