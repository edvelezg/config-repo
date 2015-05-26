#include "slick.sh"
#import "ini.e"
#define SLICK_LINT_INI       "slicklint.ini"
#pragma option(strict2, on)

_command void run_lint() name_info(',' VSARG2_REQUIRES_EDITORCTL)
{
   rlint();
};

void rlint()
{
    _str lintPath;

   if (Lint_LoadIni(p_LangId, lintPath) == 0 && lintPath != "NA") 
   {
      do_run_lint(lintPath, p_buf_name);
   }
};

void do_run_lint(_str lintPrg, _str filename)
{
   reset_next_error();
   clear_all_error_markers();
   clear_pbuffer();
 
   activate_build();
   _str finalCmd = _parse_env_vars(lintPrg);
   finalCmd = stranslate(finalCmd, file_path(p_buf_name), "%fp");
   finalCmd = stranslate(finalCmd, p_buf_name, "%f");
   finalCmd = stranslate(finalCmd, _GetWorkspaceDir(), "%w");
   finalCmd = stranslate(finalCmd, p_LangId, "%l");

   _str doSetMarkers;
   _str lintCmd;

   Lint_DoSetErrorMarkers(doSetMarkers);
   lintCmd = nls("%s",  finalCmd);
      
   if (doSetMarkers == "1") 
   {
      _str vsbin = Lint_GetVSCommand();
      _str seps = Lint_GetCommandSeperator();
      _str sleeper = Lint_GetSleeper();
   
      if (length(sleeper) > 0) 
      {
         lintCmd = nls("%s %s %s %s %s \"-#set_error_markers\"",  lintCmd, seps, sleeper, seps, vsbin);
      }
      else
      {
         lintCmd = nls("%s %s %s \"-#set_error_markers\"", lintCmd, seps, vsbin);
      }
   }

   concur_command(lintCmd, false, true, false, true);
   cursor_data();
};

int _cbsave_lint() 
{
   _str autoRun;
   Lint_DoAutoRunOnSave(autoRun);

   if (autoRun == "1") 
   {
      rlint();
   }

   return(0);
};

_str Lint_GetSleeper()
{
    _str sleeper;
    _str iniPath = _GetWorkspaceDir() :+ SLICK_LINT_INI;
   _ini_get_value(iniPath, "Settings", "Sleeper", sleeper, "NA");
   return sleeper;
};


_str Lint_GetVSCommand()
{
    _str vsbin;
    _str iniPath = _GetWorkspaceDir() :+ SLICK_LINT_INI;
   _ini_get_value(iniPath, "Settings", "VSCommand", vsbin, "vs");
   return vsbin;
};

_str Lint_GetCommandSeperator()
{
    _str sep;
    _str iniPath = _GetWorkspaceDir() :+ SLICK_LINT_INI;
   _ini_get_value(iniPath, "Settings", "CommandSeperator", sep, ";");
   return sep;
};


void Lint_DoSetErrorMarkers(_str &doSetMarkers)
{
   _str iniPath = _GetWorkspaceDir() :+ SLICK_LINT_INI;
   _ini_get_value(iniPath, "Settings", "SetErrorMarks", doSetMarkers, "0");
};

void Lint_DoAutoRunOnSave(_str &doAutoRunOnSave)
{
   _str iniPath = _GetWorkspaceDir() :+ SLICK_LINT_INI;
   _ini_get_value(iniPath, "Settings", "AutoLintOnSave", doAutoRunOnSave, "1");
};

int Lint_LoadIni(_str langType, _str &lintExe)
{
   _str iniPath = _GetWorkspaceDir() :+ SLICK_LINT_INI;
   int status = _ini_get_value(iniPath, "Languages", langType, lintExe, "NA");

   return status;
};

_str file_path(_str s)
{
   return strip_filename(s,'ne');
};
