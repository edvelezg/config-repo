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
   if (Rsync_GetHome(homDir) == 0 && homDir != "NA") 
   {
      say('HomeDir='homDir);
//    do_run_rsync(rsyncPath, p_buf_name);
   } else {
      say("ERROR: You're missing the file " RSYNC_INI " in your directory");
   }


};


int Rsync_LoadIni(_str SectionName, _str &name)
{
   _str iniPath = _GetWorkspaceDir() :+ RSYNC_INI;
   int status = _ini_get_value(iniPath, "Settings", SectionName, name, "NA");
   return status;
};

_str Rsync_GetHome(_str &homeDir)
{
    _str iniPath = _GetWorkspaceDir() :+ RSYNC_INI;
   _ini_get_value(iniPath, "Settings", "HomeDir", homeDir, "NA");
   return homeDir;
};


/**
 * Loads the RSYNC_INI file in the workspace directory of the 
 * project 
 * 
 * @author egutarra (2/12/2018)
 */
int LoadRsyncIniFile(_str &machineName, _str &unixHome)
{
   int status = Rsync_LoadIni("MachineName", machineName);
   if (status == 0 && machineName != "NA") {
      say('MachineName='machineName);
   } else {
      say("ERROR: You're missing the file " RSYNC_INI " in your directory");
   }

      if (Rsync_GetHome(unixHome) == 0 && unixHome != "NA") {
      say('HomeDir='unixHome);
   } else {
      say("WARN: A Home directory was not specified");
      unixHome = '/opt/qa';
   }
   return status;
}

_command void copy_unix_path() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str machineName, unixHome;
   int status = LoadRsyncIniFile(machineName, unixHome);

	/* Get the directory name and file name */
   _str dirName = _strip_filename(p_buf_name,'N');
   _str filName = _strip_filename(p_buf_name,'P');

   _str windHome = 'C:\tibco\' :+ machineName :+ '\qa';
   _str relaPath = substr(dirName, windHome._length());
   relaPath = stranslate(relaPath, '/',   '\');
   _str fullPath = unixHome :+ relaPath;

   _copy_text_to_clipboard(fullPath :+ filName);
// _copy_text_to_clipboard(_strip_filename(p_buf_name,'PE'));
}

_command void copy_unix_dir_path() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str machineName, unixHome;
   int status = LoadRsyncIniFile(machineName, unixHome);

	/* Get the directory name and file name */
   _str dirName = _strip_filename(p_buf_name,'N');
   _str filName = _strip_filename(p_buf_name,'P');
// say(dirName);
   _str windHome = 'C:\tibco\' :+ machineName :+ '\qa';
   _str relaPath = substr(dirName, windHome._length());
   relaPath = stranslate(relaPath, '/',   '\');
   _str fullPath = unixHome :+ relaPath;
// say(fullPath);
   _copy_text_to_clipboard(fullPath);
// _copy_text_to_clipboard(_strip_filename(p_buf_name,'PE'));
}

def  'A-C' 'u' 'd' = copy_unix_dir_path;
def  'A-C' 'u' 'f' = copy_unix_path;
