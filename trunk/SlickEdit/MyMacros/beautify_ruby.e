#include "slick.sh"

_command void beautify_bash() {

   if (_select_type() == "") {
      select_all()
   } else if (_select_type() != "LINE" && _select_type() != "BLOCK") {
      // Convert it into a LINE selection
      _select_type('', 'T', 'LINE');
   }
   _str out = filter_command("ruby beautify_bash.rb -");

}

