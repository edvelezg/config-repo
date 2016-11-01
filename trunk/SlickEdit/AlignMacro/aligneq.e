#include "slick.sh"

// File:       aligneq.e
// Author:     Joseph Van Valen
//
// Description:
// Implements three commands borrowed from other editors. The common thread                  
// between each of the commands is that they operate on selected text and use                
// the selection filter techniques supplied by Visual SlickEdit.                             
//                                                                                           
// The first command, align_equals, aligns the equal signs in a group of                     
// selected lines with the right-most first equal sign within the group.                     
//                                                                                           
// The second and third commands, slide_in_prompt and slide_out_prompt, indents              
// a group of lines by prefixing and removing the prefixing, respectively, of                
// a specific string supplied by the user.                                                   
//                                                                                           
// All of these functions expect either a line or block selection to operate on.             
// Stream selections are not supported at this time.                                         
//                                                                                           
// To install just load this macro file and bind these functions to the keystrokes           
// of your choice. For me, I have the align_equals assigned to <Alt =>,                      
// slide_in_prompt assigned to <Alt .>, and slide_out_prompt assigned to <Alt ,>             
// since these are the keys of habit for these functions. (I moved complete_prev             
// and complete_next to <alt [> and <alt ]> respectively)                                    
//                                                                                           
// I hope you find these useful

static int gMaxEqCol;                                                                        

/**                                                                                          
 * A selection filter that determines the column of the right most equal sign.               
 *                                                                                           
 * The filter finds the column of the first equal sign of the line if available.             
 * If there is an equal sign, and the column is greater than the current maximum,            
 * then the column will become the next maximum.                                             
 *                                                                                           
 * This is a helper function for the align_equals command.
 *
 * @return
 */
static _str find_max_eq_filter(s)
{
   _str inputStr = expand_tabs(s);
   int equalsPos = pos("=", inputStr, 1, "");
   if ( equalsPos > gMaxEqCol  ) {
      gMaxEqCol = equalsPos;
   }

   return s;
}


static _str find_max_ba_filter(s)
{
   _str inputStr = expand_tabs(s);
   int equalsPos = pos("\\", inputStr, 1, "");
   if ( equalsPos > gMaxEqCol  ) {
      gMaxEqCol = equalsPos;
   }

   return s;
}
/**
 * This selection filter injects spaces in front of the first equal sign of
 * the line until the equal sign is in the same column as the right most first
 * equal sign of the selection. If the line does not contain an equal sign, then
 * no action is taken.
 *
 * @return The resulting string with the first equal sign shifted, if applicable
 */
static _str align_eq_filter(s)
{
   if (gMaxEqCol <= 0 || length(s) == 0) {
      return s;
   }

   _str expandedStr = expand_tabs(s);

   int equalsPos  = pos("=", expandedStr, 1, "");
   if (equalsPos == 0) {
      return s;
   }

   _str prefix    = substr(expandedStr, 1, equalsPos - 1);
   _str postfix   = substr(expandedStr,equalsPos);

   while (equalsPos < gMaxEqCol ) {
      prefix = prefix :+ ' ';
      ++equalsPos;
   }

   return prefix :+ postfix;
}


static _str align_ba_filter(s)
{
   if (gMaxEqCol <= 0 || length(s) == 0) {
      return s;
   }

   _str expandedStr = expand_tabs(s);

   int equalsPos  = pos("\\", expandedStr, 1, "");
   if (equalsPos == 0) {
      return s;
   }

   _str prefix    = substr(expandedStr, 1, equalsPos - 1);
   _str postfix   = substr(expandedStr,equalsPos);

   while (equalsPos < gMaxEqCol ) {
      prefix = prefix :+ ' ';
      ++equalsPos;
   }

   return prefix :+ postfix;
}

/**
 * Aligns the first equal sign of each line of a selection to the right-most
 * equal sign. Lines without equal signs are not affected.
 *
 * Requires a Line or Block selection to identify the lines to align
 */
_command void align_equals() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{

   if (_select_type() == "") {
      select_paragraph()
//    message("A selection is required for this function");
//    return;
   } else if (_select_type() != "LINE" && _select_type() != "BLOCK") {
      // Convert it into a LINE selection
      _select_type('', 'T', 'LINE');
   }

// if ( _select_type() != "LINE" && _select_type() != "BLOCK" ) {
//    message("A LINE or BLOCK selection is required for this function");
//    return;
// }

   gMaxEqCol = 0;
   filter_selection(find_max_eq_filter);

   if (gMaxEqCol == 0) {
      // no equal signs
      return;
   }

   filter_selection(align_eq_filter);
   _free_selection("");
}


/**
 * Aligns the first equal sign of each line of a selection to the right-most
 * equal sign. Lines without equal signs are not affected.
 *
 * Requires a Line or Block selection to identify the lines to align
 */
_command void align_backslash() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{

   if ( _select_type() != "LINE" && _select_type() != "BLOCK" ) {
      message("A LINE or BLOCK selection is required for this function");
      return;
   }

   gMaxEqCol = 0;
   filter_selection(find_max_ba_filter);

   if (gMaxEqCol == 0) {
      // no equal signs
      return;
   }

   filter_selection(align_ba_filter);
   _free_selection("");
}

_str gSlideStr;

/**
 * Selection filter that prepends a predetermined prefix to the line.
 *
 * Helper function for the slide_in_prompt command.
 *
 * @param s      A copy of the current line of the selection
 * @return The modified line with prefix attached
 */
static _str slide_in_filter(_str s)
{

   _str inputStr = expand_tabs(s);

   if (length(gSlideStr) > 0) {
      inputStr = gSlideStr :+ inputStr;
   }

   return inputStr;
}


/**
 * Selection filter that removes a predetermined prefix from the line. Lines
 * that do not start with the specified prefix are unaffected.
 *
 * Helper function for the slide_out_prompt command.
 *
 * @param s      A copy of the current line of the selection
 * @return The modified line with prefix removed, if applicable
 */
static _str slide_out_filter(_str s)
{
   _str inputStr = expand_tabs(s);
   int slidePos  = pos(gSlideStr, inputStr);

   if (slidePos != 1) {
      return s;
   }

   inputStr = substr(inputStr, length(gSlideStr) + 1);
   return inputStr;
}


/**
 * A command that indents a Line or Block selection by prompting the user for
 * a string and prefixing each line of the selection with the supplied string.
 */
_command void slide_in_prompt() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   // indents the current selection in by a specified string. The user is
   // prompted for the string.

   _str slidestr;

   if ( get_string(slidestr, "Enter Slide-In String:")) {
      return;
   }

   if (length(slidestr) == 0) {
      message("Empty slide-in string.");
      return;
   }

   if (_select_type() != "LINE" && _select_type() != "BLOCK") {
      message("LINE or BLOCK selection required for this function");
      return;
   }

   gSlideStr = slidestr;

   filter_selection(slide_in_filter);
   _free_selection("");
}


/**
 * A command that outdents a Line or Block selection by prompting the user for
 * a string and removing the specified string from the beginning of each line
 * of a selection that starts with that string. Lines that do not start with
 * the specified string are not affected.
 */
_command void slide_out_prompt() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   // unindents the current selection in by a specified string. The user is
   // prompted for the string.

   _str slidestr;

   if ( get_string(slidestr, "Enter Slide-Out String:")) {
      return;
   }

   if (length(slidestr) == 0) {
      message("Empty slide-out string.");
      return;
   }

   if (_select_type() != "LINE" && _select_type() != "BLOCK") {
      message("LINE or BLOCK selection required for this function");
      return;
   }

   gSlideStr = slidestr;

   filter_selection(slide_out_filter);
   _free_selection("");
}
