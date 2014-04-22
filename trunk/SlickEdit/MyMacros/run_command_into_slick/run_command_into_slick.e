// This very simple example runs a command on the file externally, and then opens the file in slickedit
#include "slick.sh"

_command void run_command_into_slick() name_info(','VSARG2_REQUIRES_EDITORCTL)
{
   html_fid=p_buf_name;
   shell('net time \\%computername% |find "Current time"  >> ' :+ html_fid)
   e(html_fid);
}

