// This very simple example runs a command on the file externally, and then opens the file in slickedit
#include "slick.sh"

_command void run_ruby_file() name_info(','VSARG2_REQUIRES_EDITORCTL)
{
   ruby_file=p_buf_name;
   concur_command('ruby ' :+ ruby_file)
}
