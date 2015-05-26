#include "slick.sh"

_command void edit_associated_ruby()
{
   _str filename = strip_filename(p_buf_name, 'N');
   // extract the extension
   _str extension = _get_extension(filename);
   filename = _strip_filename(filename, 'E');

   returnAll = false;
   if (!my_associated_file_exists(filename, "xml", returnAll)) {
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


/**
 * Check if an associated file exists in the current directory.
 *
 * @param filename      current buffer name
 * @param ext_list      list of alternate file extensions to try
 *
 * @return boolean
 */
static boolean my_associated_file_exists(_str &filename, _str ext_list, boolean returnAll=false)
{
   mou_hour_glass(true);
   filename_no_ext  := _strip_filename(filename, 'E');
   filename_no_path := _strip_filename(filename, 'EP');

   // try same directory
   foreach (auto ext in ext_list) {
      if (file_exists(filename_no_ext"."ext)) {
         filename = maybe_quote_filename(filename_no_ext"."ext);
         mou_hour_glass(false);
         return true;
      }
   }

   // try current project
   if (_project_name != '') {
      foreach (ext in ext_list) {
         message("Searching: "_project_name);
         filename_in_project := _projectFindFile(_workspace_filename, _project_name, filename_no_path"."ext, 0);
         if (filename_in_project != '') {
            filename = maybe_quote_filename(filename_in_project);
            mou_hour_glass(false);
            return true;
         }
      }
   }

   // try entire workspace
   if (_workspace_filename != '') {
      _str foundFileList[];
      _str projectList[] = null;
      _GetWorkspaceFiles(_workspace_filename, projectList);
      foreach (ext in ext_list) {

         // try all projects in the workspace
         foreach (auto project in projectList) {
            project = _AbsoluteToWorkspace(project, _workspace_filename);
            if (project != _project_name) {
               // search this project for the file
               message("Searching: "project);
               filename_in_project := _projectFindFile(_workspace_filename, project, filename_no_path"."ext, 0);
               if (filename_in_project != "") {
                  foundFileList[foundFileList._length()] = filename_in_project;
               }
            }

         }
      }

      // remove duplicates
      foundFileList._sort();
      _aremove_duplicates(foundFileList, file_eq("A",'a'));

      // exactly one match, super!
      if (foundFileList._length() == 1) {
         filename = maybe_quote_filename(foundFileList[0]);
         mou_hour_glass(false);
         return true;
      }

      // multiple matches, prompt
      if (foundFileList._length() > 1) {
         if (returnAll) {
            filename = "";
            foreach (auto fname in foundFileList) {
               _maybe_append(filename," ");
               filename :+= maybe_quote_filename(fname);
            }
            mou_hour_glass(false);
            return true;
         } else {
            answer := select_tree(foundFileList);
            if (answer != '' && answer != COMMAND_CANCELLED_RC) {
               filename = maybe_quote_filename(answer);
               mou_hour_glass(false);
               return true;
            }
         }
      }
   }

   // that's all folks
   mou_hour_glass(false);
   return false;
}
