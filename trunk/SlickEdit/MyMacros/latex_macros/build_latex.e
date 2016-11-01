#include "slick.sh"

_command void build_latex() name_info(','VSARG2_REQUIRES_EDITORCTL)
{
   _str filename = strip_filename(p_buf_name,'E');

   if (filename == "") {
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

   _str pdflatexpath = slick_path_search("pdflatex.exe", "M");
   if (pdflatexpath == "") {
      pdflatexpath = path_search("pdflatex.exe", "", "P");
      sticky_message(pdflatexpath);
      if (pdflatexpath == "") {
         sticky_message("Could not locate pdflatex.exe in PATH");
         return;
      }
   }

   save();
   concur_command("pdflatex.exe " :+ " " :+ filename);
   concur_command("bibtex.exe " :+ " " :+ filename);
   concur_command("pdflatex.exe " :+ " " :+ filename);
}
