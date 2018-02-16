#include "slick.sh"
#import "ini.e"
#define RSYNC_INI "rsync.ini"
#pragma option(strict2, on)


_command void run_rsync() name_info(',' VSARG2_REQUIRES_EDITORCTL)
{
   display_loadini();
};

void display_loadini()
{
    _str machineName;
   if (Rsync_LoadIni("Primary", machineName) == 0 && machineName != "NA") 
   {
      say('Primary='machineName);
//    do_run_rsync(rsyncPath, p_buf_name);
   } else {
      say("ERROR: You're missing the file " RSYNC_INI " in your directory");
   }

   _str homDir;
   if (Rsync_GetHome(homDir) == 0 && homDir != "NA") 
   {
      say('PrimaryDir='homDir);
//    do_run_rsync(rsyncPath, p_buf_name);
   } else {
      say("ERROR: You're missing the file " RSYNC_INI " in your directory");
   }

   _str engineHome, engine;
   if (Rsync_GetEngineMachine(engineHome, engine) == 0) 
   {
      say('Engine='engine);
      say('EngineDir='engineHome);
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

int Rsync_GetHome(_str &homeDir)
{
    _str iniPath = _GetWorkspaceDir() :+ RSYNC_INI;
   int status = _ini_get_value(iniPath, "Settings", "PrimaryDir", homeDir, "NA");
   return status;
};

int Rsync_GetEngineMachine(_str &engineHome, _str &engine)
{
    _str iniPath = _GetWorkspaceDir() :+ RSYNC_INI;
   int status = _ini_get_value(iniPath, "Settings", "Engine", engine, "NA");
   status = _ini_get_value(iniPath, "Settings", "EngineDir", engineHome, "NA");
   return status;
};

/**
 * Loads the RSYNC_INI file in the workspace directory of the 
 * project 
 * 
 * @author egutarra (2/12/2018)
 */
int LoadRsyncIniFile(_str &primaryMachine, _str &primaryDir)
{
   int status = Rsync_LoadIni("Primary", primaryMachine);
   if (status == 0 && primaryMachine != "NA") {
      say('Primary='primaryMachine);
   } else {
      say("ERROR: You're missing the file " RSYNC_INI " in your directory");
   }

   if (Rsync_GetHome(primaryDir) == 0 && primaryDir != "NA") {
      say('PrimaryDir='primaryDir);
   } else {
      say("WARN: status=" :+ status :+ "A Home directory may not have been specified");
      primaryDir = '/opt/qa';
   }

   primaryMachine = strip(primaryMachine);
   primaryDir = strip(primaryDir);

   return status;
}

_command void copy_unix_path() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str primaryMachine, primaryDir;
   int status = LoadRsyncIniFile(primaryMachine, primaryDir);

   /* Get the mirror folder based on the unixHome that's being referenced*/
   _str mirrorFolder = _strip_filename(primaryDir, 'P');
   say('mirrorFolder='mirrorFolder);

	/* Get the directory name and file name */
   _str dirName = _strip_filename(p_buf_name,'N');
   _str filName = _strip_filename(p_buf_name,'P');


   _str windHome = 'C:\tibco\' :+ primaryMachine :+ '\' :+ mirrorFolder :+ '\';
   _str relaPath = substr(dirName, windHome._length());
   relaPath = stranslate(relaPath, '/',   '\');
   _str fullPath = primaryDir :+ relaPath;

   _copy_text_to_clipboard(fullPath :+ filName);
// _copy_text_to_clipboard(_strip_filename(p_buf_name,'PE'));
}

_command void copy_unix_dir_path() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str machineName, unixHome;
   int status = LoadRsyncIniFile(machineName, unixHome);

   /* Get the mirror folder based on the unixHome that's being referenced*/
   _str mirrorFolder = _strip_filename(unixHome, 'P');
   say('mirrorFolder='mirrorFolder);

	/* Get the directory name and file name */
   _str dirName = _strip_filename(p_buf_name,'N');
   _str filName = _strip_filename(p_buf_name,'P');
// say(dirName);
   _str windHome = 'C:\tibco\' :+ machineName :+ '\' :+ mirrorFolder :+ '\';
   say(windHome);
   say(dirName);
   _str relaPath = substr(dirName, windHome._length());
   say(relaPath);
   relaPath = stranslate(relaPath, '/',   '\');
   say(relaPath);
   _str fullPath = unixHome :+ relaPath;
   say (unixHome);
   say(fullPath);
// say(fullPath);
   _copy_text_to_clipboard(fullPath);
// _copy_text_to_clipboard(_strip_filename(p_buf_name,'PE'));
}

def  'A-C' 'u' 'd' = copy_unix_dir_path;
def  'A-C' 'u' 'f' = copy_unix_path;
