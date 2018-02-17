//This macro has been posted for other SlickEdit users to use and explore.
//Depending on the version of SlickEdit that you are running, this macro may or may not load.
//Please note that these macros are NOT supported by SlickEdit and is not responsible for user submitted macros.

/**************************************************************************
Filename = Fillstr.e

------------------------------------------------------------------------
Description:

This macro fills a column block with a mult-character string. This
is somewhat similar to fill_selection() except that you are not
limited to filling the block with a single character and can fill
it with multiple characters.

Please send email notice of bugs or otherwise to Ken Curtis at the
following address

    wdlndengrg@earthlink.net

------------------------------------------------------------------------
Revision History:

10-Apr-2003
  Fixed bug when last line in vertical block is last line in file.
18-Jul-2001
  Original release written by Ken Curtis.

**************************************************************************/

#include "slick.sh"

/**************************************************************************
Globals used in this module
**************************************************************************/

static _str inputStr; // String input by the user

/**************************************************************************
This function fills (overwrites) a column block with a string.
**************************************************************************/
_command void fill_column_w_string() name_info(','MARK_ARG2)
{
int idx; // Index
int startCol; // Left column of selection
int endCol; // Right column of selection
int noCols; // Number of columns
int inputLen; // Length of input string
_str line; // Current line that we're working on
_str leftStr; // Portion of current line to the left of block
_str rightStr; // Portion of current line to right of block
_str replaceStr; // Replacement string

// Make sure we have a column block selected
if (!select_active() || _select_type() != "BLOCK")
  {
  _message_box("Column block not selected","Error",MB_OK | MB_ICONEXCLAMATION);
  return;
  }

// Ask for user input (temporarily use replaceStr to get results).
replaceStr = show('-xy -modal fill_col_text_form');
if (replaceStr == '')
  return;

// Save location in buffer
_save_pos2(p);

// Find start and end columns
_get_selinfo(startCol,endCol,dummy);
noCols = endCol - startCol + 1;

// Setup the replacement string
inputLen = length(inputStr);
if (inputLen < noCols)
  {
  replaceStr = "";
  do
    {
    if (noCols > inputLen)
      idx = inputLen;
    else
      idx = noCols;
    replaceStr = replaceStr :+ substr(inputStr,1,idx);
    noCols -= idx;
    }
  while (noCols > 0);
  }
else // inputStr is longer than or equal to noCols
  replaceStr = substr(inputStr,1,noCols);

// Replace all the text in the column block with numbers
_begin_select();
do
  {

  // Get the current line
  get_line(line);

  // Create a new line using pieces from current line plus the number string
  leftStr = substr(line,1,startCol - 1);
  rightStr = substr(line,endCol + 1);
  line = leftStr :+ replaceStr :+ rightStr;

  // Replace the line in buffer with the new line
  replace_line(line);

  // Move position in buffer down one line in the while test below

  }
while (down() == 0 && _end_select_compare() <= 0);

// Restore position in buffer
_restore_pos2(p);

} /* end fill_column_w_string() */


/**************************************************************************
This function inserts a column block with a string. The width of the
inserted column is the same as the selected column block.
**************************************************************************/
_command void insert_column_of_string() name_info(','MARK_ARG2)
{
int idx; // Index
int startCol; // Left column of selection
int endCol; // Right column of selection
int noCols; // Number of columns
int inputLen; // Length of input string
_str line; // Current line that we're working on
_str leftStr; // Portion of current line to the left of block
_str rightStr; // Portion of current line to right of block
_str insertStr; // Insert string

// Make sure we have a column block selected
if (!select_active() || _select_type() != "BLOCK")
  {
  _message_box("Column block not selected","Error",MB_OK | MB_ICONEXCLAMATION);
  return;
  }

// Ask for user input (temporarily use insertStr to get results).
insertStr = show('-xy -modal fill_col_text_form');
if (insertStr == '')
  return;

// Save location in buffer
_save_pos2(p);

// Find start and end columns
_get_selinfo(startCol,endCol,dummy);
noCols = endCol - startCol + 1;

// Setup the replacement string
inputLen = length(inputStr);
if (inputLen < noCols)
  {
  insertStr = "";
  do
    {
    if (noCols > inputLen)
      idx = inputLen;
    else
      idx = noCols;
    insertStr = insertStr :+ substr(inputStr,1,idx);
    noCols -= idx;
    }
  while (noCols > 0);
  }
else // inputStr is longer than or equal to noCols
  insertStr = substr(inputStr,1,noCols);

// Replace all the text in the column block with numbers
_begin_select();
do
  {

  // Get the current line
  get_line(line);

  // Create a new line using pieces from current line plus the number string
  leftStr = substr(line,1,startCol - 1);
  rightStr = substr(line,startCol);
  line = leftStr :+ insertStr :+ rightStr;

  // Replace the line in buffer with the new line
  replace_line(line);

  // Move position in buffer down one line in the while test below

  }
while (down() == 0 && _end_select_compare() <= 0);

// Restore position in buffer
_restore_pos2(p);

} /* end insert_column_of_string() */


/**************************************************************************
These are functions attached to control actions.
**************************************************************************/

defeventtab fill_col_text_form

/**************************************************************************
This function initializes the text inside the input string edit box.
**************************************************************************/
void ctl_inputstr_eb.on_create()
{

ctl_inputstr_eb.p_text = inputStr;

} /* end ctl_inputstr_eb.on_create() */


/**************************************************************************
This function gets the input string from the user.
**************************************************************************/
void ctl_ok_pb.lbutton_up()
{


if (length(ctl_inputstr_eb.p_text) > 0)
  {
  inputStr = ctl_inputstr_eb.p_text;
  p_active_form._delete_window("1");
  }
else
  p_active_form._delete_window();

} /* end ctl_ok_pb.lbutton_up() */


/**************************************************************************
Below is the form (dialog box) that goes with macro.
**************************************************************************/

_form fill_col_text_form {
   p_backcolor=0x80000005
   p_border_style=BDS_DIALOG_BOX
   p_caption='Fill String'
   p_clip_controls=FALSE
   p_forecolor=0x80000008
   p_height=1635
   p_width=3480
   p_x=3810
   p_y=3900
   _label ctllabel1 {
      p_alignment=AL_CENTER
      p_auto_size=FALSE
      p_backcolor=0x80000005
      p_border_style=BDS_NONE
      p_caption='Enter column text'
      p_font_bold=FALSE
      p_font_italic=FALSE
      p_font_name='MS Sans Serif'
      p_font_size=8
      p_font_underline=FALSE
      p_forecolor=0x80000008
      p_height=240
      p_tab_index=0
      p_width=2520
      p_word_wrap=FALSE
      p_x=480
      p_y=180
   }
   _text_box ctl_inputstr_eb {
      p_auto_size=TRUE
      p_backcolor=0x80000005
      p_border_style=BDS_FIXED_SINGLE
      p_completion=NONE_ARG
      p_font_bold=FALSE
      p_font_italic=FALSE
      p_font_name='MS Sans Serif'
      p_font_size=8
      p_font_underline=FALSE
      p_forecolor=0x80000008
      p_height=285
      p_tab_index=1
      p_tab_stop=TRUE
      p_text='ctltext1'
      p_width=2640
      p_x=420
      p_y=540
      p_eventtab2=_ul2_textbox
   }
   _command_button ctl_ok_pb {
      p_cancel=FALSE
      p_caption='OK'
      p_default=TRUE
      p_font_bold=FALSE
      p_font_italic=FALSE
      p_font_name='MS Sans Serif'
      p_font_size=8
      p_font_underline=FALSE
      p_height=360
      p_tab_index=2
      p_tab_stop=TRUE
      p_width=1080
      p_x=420
      p_y=1080
   }
   _command_button ctl_cancel_pb {
      p_cancel=TRUE
      p_caption='Cancel'
      p_default=FALSE
      p_font_bold=FALSE
      p_font_italic=FALSE
      p_font_name='MS Sans Serif'
      p_font_size=8
      p_font_underline=FALSE
      p_height=360
      p_tab_index=3
      p_tab_stop=TRUE
      p_width=1080
      p_x=1980
      p_y=1080
   }
}



