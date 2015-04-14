#include "slick.sh"

_command void edit_associated_etl()
{
   _str filename = strip_filename(p_buf_name, 'P');
   filename = "_" filename;

   // edit the file
   if (file_exists(filename)) {
      edit(maybe_quote_filename(filename),EDIT_DEFAULT_FLAGS);
      message("Found: " filename);
   } else {
      message("No match found");
   }
}
