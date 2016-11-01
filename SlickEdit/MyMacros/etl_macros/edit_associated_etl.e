#include "slick.sh"

_command void edit_associated_etl()
{
   _str path = strip_filename(p_buf_name, 'N');
   chdir(path,1);
   
   _str filename = strip_filename(p_buf_name, 'P');
   if (substr(filename,1,1)=='_') {
      filename=substr(filename,2);
   } else {
      filename = "_" filename;
   }
   // edit the file
   if (file_exists(filename)) {
      edit(maybe_quote_filename(filename),EDIT_DEFAULT_FLAGS);
      message("Found: " filename);
   } else {
      message("No match found");
   }
}

//defeventtab etl_keys;
//def 'C-`' = edit_associated_etl;
