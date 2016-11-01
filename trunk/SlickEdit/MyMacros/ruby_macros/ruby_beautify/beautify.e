// 1. Go to "C:\Program Files\SlickEdit Pro 19.0.2\macros\cformat.e"
// 2. Search for: #define DEFAULT_BEAUTIFIER_EXT  "
// 3. Add ruby=ruby to the string.
#include "slick.sh"

_command void ruby_beautify() {

   if (_select_type() == "") {
      select_all()
   } else if (_select_type() != "LINE" && _select_type() != "BLOCK") {
      // Convert it into a LINE selection
      _select_type('', 'T', 'LINE');
   }
   _str out = filter_command("rbeautify");

}

