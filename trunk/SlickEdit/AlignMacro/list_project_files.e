#include "slick.sh"

/*******************************************************************************
//
// Function    :  list_project_files
// Parameters  :  Options: P=Path, D=Drive, E=Extension, N=Name.
// Returns     :  none
//
// Description :  This macro displays a list of all files in the current project
//                in a new temp buffer.  Specifying the Options string allows 
//                the way the filenames are displayed to be modified.  These 
//                options are passed directly to the strip_filename() function.
//
//                For example:
//                list_project_files "PD" - strips the directory and path from 
//                 the file names.
//                list_project_files - displays the all of the files with the
//                 full paths.
// ____________________________________________________________________________
// Author      :  Rick Suel
// History     :  03/24/2009 - Function Created (RDS)
//
*******************************************************************************/
_command void list_project_files(_str Options="")  name_info(',' VSARG2_MACRO | VSARG2_REQUIRES_EDITORCTL | VSARG2_READ_ONLY)
{
   _str FileNameArray[];  
   _str line;
   int orig_window_id = p_window_id;   
   int temp_window_id;

   // Ensure there is a project loaded.
   if (_project_name != '')
   {
      // There is currently an open project, proceed.

      // Convert options to upper case.
      Options = upcase(Options);

      //-----------------------------------------------
      // Save the list of filenames in the project.
      //-----------------------------------------------
      // GetProjectFiles will get all files in the given project and will add them 
      // to a temporary buffer (temp_view_id), one filename per line
      status = GetProjectFiles(_project_name, temp_window_id);

      // If the project file retrieval was successful (status = 0), continue...
      if (!status)
      {
         // Make the temp buffer with the file names the active buffer.
         p_window_id = temp_window_id;
         // Move to the top of the buffer.
         top();up();
         // Loop through the lines of the buffer and create an array of file names.
         for (i = 0; !down(); i++)
         {
            // Retrieve the current line from the buffer into the line variable.
            get_line(line);                                                 
            // Strip the filename from the string using the options that were passed in.
            FileNameArray[i] = strip_filename(line, Options);
         }

         // Create a new buffer for displaying the file names.
         e( "FileListResults.txt" );
         // Loop through the file name array and add each name to the buffer.
         for (i=0; i<FileNameArray._length(); i++)
         {
            insert_line(FileNameArray[i]);
         }

         // Restore the original Window ID.
         p_window_id = orig_window_id;
         // Delete the temp buffer.
         _delete_temp_view(temp_window_id);
      }

   } 
   else
   {
      _message_box('This macro requires a project to be open.');
   }
}
