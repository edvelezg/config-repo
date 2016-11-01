// 10/14/2016 11:18 AM This macro finds and appends something in the clipboard
// https://community.slickedit.com/index.php/topic,14326.msg55691.html#msg55691

#include "slick.sh"
#include "tagsdb.sh"

_command find_and_append() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   int not_found = find('printf("',"I+"); /* boolean to terminate loop */

   while (!not_found) {
      _deselect();
      next_word();
      cursor_right(2);
      paste();
      not_found = find('printf("',"I+");
   }
}

_command gen_fun_dbgs() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   while (!next_proc()) {
      find('(',"+>NIp?")
      cursor_left();
      execute('generate-debug');
      say(current_class(false));
//    getProtypeData()
   }
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
