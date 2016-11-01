// This very simple example runs a command on the file externally, and then opens the file in slickedit
#include "slick.sh"

_command void run_ruby_file(boolean useShell = false) name_info(','VSARG2_REQUIRES_EDITORCTL)
{
   ruby_file=p_buf_name;
   _str cmdline = 'ruby ' :+ maybe_quote_filename(ruby_file) :+ " 2>&1";
// concur_command(cmdline)
   useShell ? shell( cmdline, 'NAP' ) : concur_command( cmdline, true, true, false, false );
}

////! invoke cmd with current buffer name and line either in Build toolwindow or external shell
//_command void cmdbl( boolean useShell = false ) name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
//{
//   _str cmdline=get_env("COMSPEC") " /k echo " maybe_quote_filename( p_buf_name ) " [line " p_RLine "]";
//
//   useShell ? shell( cmdline, 'NAP' ) : concur_command( cmdline, false, true, false, false );
//}

// Defines a hotkey of # only under ruby-mode so that it doesn't do it with other languages
defeventtab ruby_keys;
def 'A-R' '1'= run_ruby_file;
