#include "slick.sh"

_command void edit_associated_ruby()
{
   _str filename = strip_filename(p_buf_name, 'N');
   // extract the extension
   _str extension = _get_extension(filename);
   filename = _strip_filename(filename, 'E');

   if (!associated_file_exists(filename, "xml", returnAll)) {
      filename = "";
   }

   // edit the file
   if (file_exists(filename)) {
      edit(maybe_quote_filename(filename),EDIT_DEFAULT_FLAGS);
      message("Found: " filename);
   } else {
      message("No match found");
   }
}
