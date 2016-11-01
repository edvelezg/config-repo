#include "slick.sh"

static _str remove_chars(_str text)
{
   text = substr(text, 4, length(text)-6);
   say(text);
   return(text);
}


/* Demo for StackOverflow question 14205293 */
_command void copy_buf_name_noext() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
{
	/* Remove the first 5 chars of the filename */
   _copy_text_to_clipboard(substr(_strip_filename(p_buf_name,'PE'), 5));
}
def  'A-C' 'e' = copy_buf_name_noext;
def  'A-C' 'd' = copy_buf_name_dir;
def  'A-C' 'f' = copy_buf_name;
def  'A-C' 'n' = copy_buf_name_only;
def  'A-D' 'b' = cd_to_buffer;

/* This is already done by copy_buf_name */
//_command void copy_buf_name_dir() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL)
//{
//   _copy_text_to_clipboard(_strip_filename(p_buf_name,'N'));
//}

