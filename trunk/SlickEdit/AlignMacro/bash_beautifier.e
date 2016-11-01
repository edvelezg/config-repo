#include "slick.sh"

#define BeautifierScriptPath "C:\\Users\\Viper\\Documents\\Ruby\\beautify_bash.rb"
_command void beautify_bash() name_info(','VSARG2_REQUIRES_EDITORCTL)
{
   _str bashfile = p_buf_name;

   if (bashfile == "") {
      sticky_message("Current file required");
      return;
   }

   if (_QReadOnly()) {
      int status = _on_readonly_error(0, true, false);
      if (status == COMMAND_CANCELLED_RC) {
         sticky_message("Current file is read only");
         return;
      }
   }

   if (!file_exists(BeautifierScriptPath)) {
      sticky_message("Could not find beautifier script");
      return;
   }

   _str rubypath = slick_path_search("ruby.exe", "M");
   if (rubypath == "") {
      rubypath = path_search("ruby.exe", "", "P");
      if (rubypath == "") {
         sticky_message("Could not locate ruby.exe in the PATH");
         return;
      }
   }
   _str command = "C:\\Cygwin\\bin\\ruby.exe" :+ " " :+ BeautifierScriptPath :+ " " :+ bashfile;

   int i = concur_shell(command); 
   save();
   revert_or_refresh();
   _ReloadFiles(true);
}
