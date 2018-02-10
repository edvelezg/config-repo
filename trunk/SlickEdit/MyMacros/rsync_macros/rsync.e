#include "slick.sh"
#import "ini.e"
#define RSYNC_INI "rsync.ini"
#pragma option(strict2, on)


_command void run_rsync() name_info(',' VSARG2_REQUIRES_EDITORCTL)
{
   rsync();
};

void rsync()
{
    _str machineName;
   if (Rsync_LoadIni("MachineName", machineName) == 0 && machineName != "NA") 
   {
      say('MachineName='machineName);
//    do_run_rsync(rsyncPath, p_buf_name);
   } else {
      say("ERROR: You're missing the file " RSYNC_INI " in your directory");
   }

   _str homDir;
   if (Rsync_GetHome() == 0 && homDir != "NA") 
   {
      say('HomeDir='homDir);
//    do_run_rsync(rsyncPath, p_buf_name);
   } else {
      say("ERROR: You're missing the file " RSYNC_INI " in your directory");
   }


};


int Rsync_LoadIni(_str machine_name, _str &name)
{
   _str iniPath = _GetWorkspaceDir() :+ RSYNC_INI;
   int status = _ini_get_value(iniPath, "Settings", machine_name, name, "NA");
   say(name);
   say(status);
   return status;
};

_str Rsync_GetHome(_str &home)
{
    _str home;
    _str iniPath = _GetWorkspaceDir() :+ RSYNC_INI;
   _ini_get_value(iniPath, "Settings", "HomeDir", home, "NA");
   say(home);
   return home;
};
