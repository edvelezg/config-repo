#include "slick.sh"
static _str MST_Get_Selected_Text(boolean OneLine=false)
{
   _str text='',Result='';
   int i=0,Start=0,Stopp=0;
   i = _get_selinfo(Start,Stopp,0);
   say('Stopp='Stopp);
   say('Start='Start);
   say('i='i);
   if (i != TEXT_NOT_SELECTED_RC) {
      filter_init();
      while (filter_get_string(text) == 0) {
         say('text='text);
         if (OneLine) {
            say('OneLine='OneLine);
            return(text);
         }
         if (Result != "") {
            say('Result='Result);
            Result=Result :+ "\n";
         }
         Result=Result :+ text;
      }
      filter_restore_pos();
   }
   return(Result);
}

_command copy_unit_test_diff_file() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   _str text = '.xml''';
// top_of_buffer();
   if (search(text, 'E>')) stop();
   cursor_left();
   select_char();
   if (search('''C','-E')) stop();
   cursor_right();
   _str filePath = MST_Get_Selected_Text();
   say('filePath='filePath);
   _str pathParts[] = split2array(filePath, '\');
   int _print_array_index;
   for(_print_array_index=0; _print_array_index < pathParts._length(); _print_array_index++) {
      say('pathParts['_print_array_index']='pathParts[_print_array_index]);
   }
// copy();

   // Only used to remove quotes from the string.
// say(filePath);
// say(stranslate(filePath, '', ''''));
// say(filePath);
}

def  'A-C' 'u' = copy_unit_test_diff_file;
