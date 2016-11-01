#include "slick.sh"
//_command void open_project_file(_str str='', ...) name_info(',')
//{
//    // Invoke SE with 'vs.exe "-#open_project_file file_name line_number"'
//    // Call from SE cli with "open_project_file file_name line_number"
//
//   //if (_executed_from_key_or_cmdline(name_name(last_index('','C'))))
//   if (_executed_from_key_or_cmdline("open_project_file"))
//      // if executed from command line, key press, menu, or toolbar button
//      say("not macro");
//   else
//      say("from macro");
//
//   parse arg(1) with auto file_name auto line_number;
//
//   say(file_name :+ ' zzz ' :+ line_number :+ " " :+ arg());
//}

static boolean user_macro_debug_enabled = false;

_command void open_project_file(_str file_name='', _str line_number='', _str text='if (getConstraint() != null) {') name_info(PROJECT_FILE_ARG','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   // Invoke SE with 'vs.exe "-#open_project_file file_name line_number"'
   // Call from SE cli with 'open_project_file file_name line_number'

   if ( user_macro_debug_enabled ) {

      say("Passed parameters - file_name: "file_name" - line_number: "line_number);
   }

   if (arg() > 0) {

      parse arg(1) with file_name line_number;

      if ( user_macro_debug_enabled ) {

         say("Parsed " :+ arg() :+ " arguments - file_name: "file_name" - line_number: "line_number);
      }
   }

   if (project_file_match(file_name, true) != '') {

      // Make SE the focus program.
      mdisetfocus();

      // Push a bookmark to easily go back.
      push_bookmark();

      edit_file_in_project(file_name);
      _str message_string = "Navigated to "file_name;

      say('text='text);
      if (text != '') {
         search(text, 'I>');
      }

      // Validate a line number if supplied.
//    if ((line_number != '') && isinteger(line_number)) {
//
//       goto_line(line_number);
//       first_non_blank();
//       message_string :+= ":"line_number;
//    }


      message(message_string". Bookmark pushed.");

   } else {

      message("Invalid project file or no project loaded");
   }
}

_command void parse_current_line_for_event() name_info(',')
{
   // Get 2 tagged expression from current line using perl regex "(?i)^.*\|\s(\S*)\s*:(\d*).*$". First tagged is file_name second
   // taged is line number.

   /* Links to example code found so far... 
   _str trace_line_str = '';
   get_line(trace_line_str);
   _str search_regex = "(?i)^.*\|\s(\S*)\s*:(\d*).*$";
   regex_search();
   //trace_line_str.regex_search()
   */

   //int returned_value = trace_line_str.search(search_regex,"IL",);
   //message("Found name: "trace_line_str"  Returned Value: "returned_value);

   open_project_file("WellZoneTableIterator.java", 0);
   open_project_file("WellZoneParameterTableIterator.java", 0);
   open_project_file("WellTableIterator.java", 0);
   open_project_file("WellPickTableIterator.java", 0);
   open_project_file("WellLogTraceTableIterator.java", 0);
   open_project_file("WellBoreTableIterator.java", 0);
   open_project_file("WellBoreListTableIterator.java", 0);
   open_project_file("StratUnitTableIterator.java", 0);
   open_project_file("StratColumnTableIterator.java", 0);
   open_project_file("ProjectTableIterator.java", 0);
   open_project_file("Petra3TableIterator.java", 0);
   open_project_file("IntervalTableIterator.java", 0);
   open_project_file("HorizonTableIterator.java", 0);
}
