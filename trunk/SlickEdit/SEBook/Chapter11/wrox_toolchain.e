#include "slick.sh"
_command buildme(_str dir='') name_info(',')
{
   if(dir :!= '') {
      cd(dir);
   }
   concur_command("qmake -project");
   concur_command("qmake");
   concur_command("make");
}
