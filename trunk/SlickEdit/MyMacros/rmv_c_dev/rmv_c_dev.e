// 10/13/2016 7:44 AM I based this on beautify_bash.e which works alright.
#include "slick.sh"

static _str gUsrStr;

_command void rmv_c_dev() {

   if (_select_type() == "") {
      select_all()
   } else if (_select_type() != "LINE" && _select_type() != "BLOCK") {
      // Convert it into a LINE selection
      _select_type('', 'T', 'LINE');
   }

   _str prmpt = "";
   gUsrStr = prompt(prmpt, "Please enter an issue number: ");

   // This doesn't run correctly if I don't supply the full path, I want to detect the path of this script.
   _str cmd = 'ruby C:\Users\egutarra\config-repo2\trunk\SlickEdit\MyMacros\rmv_c_dev\rmv_c_dev.rb 'gUsrStr
   _str out = filter_command(cmd);
   cursor_down();
   end_line();
// expand_alias('checkin');
// say('cmd='cmd);
}

def 'A-V' 'f' = rmv_c_dev
