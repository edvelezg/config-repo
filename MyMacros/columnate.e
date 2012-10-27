#include "slick.sh"

_command void columnate() {

   if (_select_type() == "") {
      select_all()
   } else if (_select_type() != "LINE" && _select_type() != "BLOCK") {
      // Convert it into a LINE selection
      _select_type('', 'T', 'LINE');
   }
   _str out = filter_command("column -t ");

}

//_command Tick() name_info(','VSARG2_MACRO|VSARG2_MARK|VSARG2_REQUIRES_MDI_EDITORCTL)
//{
//   _macro('R',1);
//   keyin('''');
//   cursor_down();
//   cursor_left();
//}

//_command void columnate()
//{
//   _str filename = p_buf_name
//   _str out = ""
//// _str delim = prompt ("delimiter", "enter the delimiter: ")
//// if (delim == '') {
//      out = filter_command("column -t " :+ "\\"" :+ p_buf_name :+ "\\"");
//// }
//// else {
////    out = filter_command("column -s'" :+ delim :+ "' -t " :+ "\\"" :+ p_buf_name :+ "\\"");
//// }
//}

