#include "slick.sh"
//#import "clipbd.e"

static _str MST_Get_Selected_Text(boolean OneLine=false)
{
  _str text='',Result='';
  int i=0,Start=0,Stopp=0;
  i = _get_selinfo(Start,Stopp,0);
  if (i != TEXT_NOT_SELECTED_RC) {
    filter_init();
    while( filter_get_string(text) == 0 ) {
      if (OneLine) { return(text); }
      if (Result != "") { Result=Result :+ "\n"; }
      Result=Result :+ text;
      say('Result='Result);
    }
    filter_restore_pos();
    }
  return(Result);
}

_command tb() name_info(','VSARG2_MACRO|VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_REQUIRES_MDI_EDITORCTL)
{
   _macro('R',1);
   next_word();
   deselect();
   _select_char('','E');
   next_word();
   cursor_right();
   select_it('CHAR','','E');
   MST_Get_Selected_Text(false);
}

