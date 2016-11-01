#include "slick.sh"

static _str last_buffer = '';
static _str second_last_buffer = '';

/**
 * @author Ryan Anderson
 * @version 0.2 - 2005/02/24
 * @description Sets the following global static varibles to the correct values:
 *       last_buffer
 *       second_last_buffer
 */
void _switchbuf_last_two_buffers(_str oldbuffname, _str flags)
{
   // Use _mdi.p_child.p_buf_name instead of just p_buf_name
   // to prevent picking up unwanted hidden buffers
   _str possible_last_buffer = _mdi.p_child.p_buf_name;
   // Extra checks to prevent getting incorrect buffers
   if (p_buf_flags & HIDE_BUFFER)                            { return; }
   if (possible_last_buffer == last_buffer)                  { return; }
   if (possible_last_buffer == '')                           { return; }
   if (possible_last_buffer == '.command')                   { return; }
   if (possible_last_buffer == '.process')                   { return; }
   if (possible_last_buffer == '.slickc_stack')              { return; }
   if (possible_last_buffer == '.References Window Buffer')  { return; }
   if (possible_last_buffer == '.Tag Window Buffer')         { return; }
   second_last_buffer = last_buffer;
   last_buffer        = possible_last_buffer;
}

/**
 * @author Ryan Anderson
 * @version 0.2 - 2005/02/24
 * @returns The return value from 'diff'
 *       0 if successful, Otherwise a nonzero error code
 * @description Runs a diff on the last 2 buffers that were selected
 *       If 2 buffers were not yet selected, it just brings up the regular diff window
 */
_command int diff_last_two_buffers() name_info(',' VSARG2_REQUIRES_EDITORCTL | VSARG2_MARK | VSARG2_READ_ONLY)
{
   int result = -99;
   if (last_buffer == '') { 
      _message_box("You must open 2 files to run this command.", "Message - diff_last_two_buffers");
      result = diff();
      return(result);
   }
   if (second_last_buffer == '') { 
      _message_box("You must switch to a second buffer to diff this buffer with.", "Message - diff_last_two_buffers");
      result = diff();
      return(result);
   }
   result = diff(maybe_quote_filename(last_buffer)" "maybe_quote_filename(second_last_buffer));
   return(result);
}
