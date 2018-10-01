#include "slick.sh"
#import "ini.e"
#define RSYNC_INI "rsync.ini"
#pragma option(strict2, on)

_command void display_rsyncini() name_info(',' VSARG2_REQUIRES_EDITORCTL)
{
    _str machineName;
   if (Rsync_GetPrimary(machineName) == 0 && machineName != "NA") 
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

   _str iniPath = _GetWorkspaceDir() :+ RSYNC_INI;
   _str table:[];
   _ini_get_hashtable_values(iniPath, "Settings", table);

   _str k;
   foreach (k => auto v in table) {
      say(k" = "v);
   }
   
};


int Rsync_GetPrimary(_str &name)
{
   _str iniPath = _GetWorkspaceDir() :+ RSYNC_INI;
   int status = _ini_get_value(iniPath, "Settings", "Primary", name, "NA");
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
   int status = Rsync_GetPrimary(primaryMachine);
   if (status == 0 && primaryMachine != "NA") {
//    say('Primary='primaryMachine);
   } else {
      say("ERROR: You're missing the file " RSYNC_INI " in your directory");
      primaryMachine = "localhost";
   }

   if (Rsync_GetHome(primaryDir) == 0 && primaryDir != "NA") {
//    say('PrimaryDir='primaryDir);
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

   _str windHome = _GetWorkspaceDir() :+ mirrorFolder :+ '\';
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

   _str windHome = _GetWorkspaceDir() :+ mirrorFolder :+ '\';
   say(windHome);
   say(dirName);
   _str relaPath = substr(dirName, windHome._length());
   say(relaPath);
   relaPath = stranslate(relaPath, '/',   '\');
   say(relaPath);
   _str fullPath = unixHome :+ relaPath;
   say (unixHome);
   say(fullPath);

   _copy_text_to_clipboard(fullPath);
}

_command void copy_unix_dir_path2() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str cmdline = "ruby C:\\Users\\egutarra\\config-repo2\\trunk\\dev_scripts\\ruby\\GenerateUnixRemoteDir.rb " :+ _GetWorkspaceDir() :+ " " :+ p_buf_name;
   int status = 0;
   _str res = _PipeShellResult(cmdline, status, 'A');
}

_command void getInfoFromRsync() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str cmdline = "ruby C:\\Users\\egutarra\\config-repo2\\trunk\\dev_scripts\\ruby\\GetGSInfo.rb " :+ _GetWorkspaceDir();
   say(cmdline);
   int status = 0;
   _str res = _PipeShellResult(cmdline, status, 'C');
   e(_GetWorkspaceDir() :+ 'rsync2.ini');
// _insert_text(res);
// _str text = "Workflow was run successfully on GS " :+ version :+ " using " :+ machineName;
// insert_line(text);
}

_command void start_primary() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str machineName, unixHome;
   int status = LoadRsyncIniFile(machineName, unixHome);
   goto_url("http://"machineName":8080/livecluster/admin/control/dashboard/dashboardGrid.jsp");
}

_command void start_mobaxterm() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str machineName, unixHome;
   int status = LoadRsyncIniFile(machineName, unixHome);
   _str cmd = "\"C:\\Program Files (x86)\\Mobatek\\MobaXterm\\MobaXterm.exe\" -bookmark \""machineName" (qa)\"";
   concur_command(cmd);
}

_command void copy_local_to_remote() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
   _str cmdline = "ruby C:\\Users\\egutarra\\config-repo2\\trunk\\dev_scripts\\ruby\\GenerateCopyRemoteCommand.rb " :+ _GetWorkspaceDir() :+ " " :+ p_buf_name;
   int status = 0;
// e(_GetWorkspaceDir() :+ 'Result');
// concur_shell()
   _str res = _PipeShellResult(cmdline, status, 'A');
// _insert_text(res);
// concur_command(cmdline, true, false);
// concur_shell(cmdline);
}

_command void find_log_warnings_and_errors() name_info(','VSARG2_READ_ONLY)
{
   _str cmdline = 'ruby C:\Users\egutarra\config-repo2\trunk\dev_scripts\ruby\FindInFiles.rb ' :+ _GetWorkspaceDir();
   int status = 0;
// concur_shell(cmdline);
   concur_command(cmdline, true, false);
// _str res = _PipeShellResult(cmdline, status, 'A');
// _insert_text(res);
// concur_shell(cmdline);
}

_command cdate2() name_info(','VSARG2_REQUIRES_EDITORCTL)
{
   _str cmdline = 'bash -c "date +''%Y-%m-%d %H:%M:%S:%3N''"';
   int status = 0;
   _str res = _PipeShellResult(cmdline, status, 'C');
   _insert_text(strip(res,"B"," \t\n\R"));
   goto_url('https://community.slickedit.com/index.php/topic,15953.0.html');

}

def  'A-C' 'u' 'd' = copy_unix_dir_path2;
def  'A-C' 'i' = getInfoFromRsync;
def  'A-C' 'u' 'f' = copy_unix_path;
def  'A-C' 'r' 'c' = copy_local_to_remote;
def  'A-R' 'c' = copy_local_to_remote;
def  'A-R' 'p' = start_primary;
def  'A-R' 'm' = start_mobaxterm;

