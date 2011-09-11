#include "slick.sh"

_command void build_qt(_str dir='')
{
   if(dir :!= '') {
      cd(dir);
   }
   concur_command("qmake -project");
   concur_command("qmake");
   concur_command("mingw32-make");
}

