// This very simple example runs a command on the file externally, and then opens the file in slickedit
#include "slick.sh"

_command void run_ruby_file() name_info(','VSARG2_REQUIRES_EDITORCTL)
{
   ruby_file=p_buf_name;
   concur_command('ruby ' :+ ruby_file)
}

// Defines a hotkey of # only under ruby-mode so that it doesn't do it with other languages
defeventtab ruby_keys;
def 'A-R' '1'= run_ruby_file;
