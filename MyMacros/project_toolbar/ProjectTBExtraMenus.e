
#include "slick.sh"
#pragma option(strictsemicolons,on)
#pragma option(strict,on)
#pragma option(autodecl,off)
#pragma option(strictparens,on)



// This file contains modified versions of project toolbar menus.  
// Functions defined in ProjectTBExtra.e have been added to these menus.




_menu _projecttb_file_menu {
   "&Open","projecttbEditFile","","","";
   submenu "&More","","","" {
      "Add &new file","projecttb-add-new-file-here","","","Add new file to project";
      "Add new item from &template","projecttb-add-template-item-here","","","Add item to project from template";
      "New &folder","projecttb-add-folder-here","","","Create new folder here";
      "&Explore","projecttb-explore-from-here","","","Shell explorer";
      "&Open file","projecttb-open-from-here","","","Open file to edit";
      "-","","","","";
      "She&ll from here","projecttb_shell_from_here","","","Open OS shell";
      "Folder &MRU","projecttb-show-folder-MRU","","","";
      "Add to folder MR&U","projecttb-add-to-folder-MRU","","","";
      "Change &directory to here","projecttb-cd-to-here","","","";
      "-","","","","";
      "Copy pathname","projecttb-copy-path","","","";
      "Copy file pathname","projecttb-copy-filename-full-path","","","";
      "-","","","","";
      "&Project properties","projecttb-project-properties","","","";
   }
   "-","","","","";
   "&Compile","projecttbCompile","","","";
   "-","","","","";
   "Cut\tCtrl+X","projecttbCut","","","";
   "Copy\tCtrl+C","projecttbCopy","","","";
   "Paste\tCtrl+V","projecttbPaste","","","";
   "&Remove\tDel","projecttbRemove","","","";
   submenu "&Version Control","help Version Control Menu","Displays project menu","version-control" {
   }
   "Re&tag File","projecttbRetagFile","","","";
}



_menu _projecttb_folder_menu {
   submenu "&More","","","" {
      "Add new item from &template","projecttb-add-template-item-here","","","Add item to project from template";
      "New &folder","projecttb-add-folder-here","","","Create new folder here";
      "&Explore","projecttb-explore-from-here","","","Shell explorer";
      "&Open file","projecttb-open-from-here","","","Open file to edit";
      "-","","","","";
      "She&ll from here","projecttb_shell_from_here","","","Open OS shell";
      "Folder &MRU","projecttb-show-folder-MRU","","","";
      "Add to folder MR&U","projecttb-add-to-folder-MRU","","","";
      "Change &directory to here","projecttb-cd-to-here","","","";
      "-","","","","";
      "Copy pathname","projecttb-copy-path","","","";
      "-","","","","";
      "&Project properties","projecttb-project-properties","","","";
   }
   submenu "&Add","","Displays Add To Folder menu","ncw" {
      "New File...","projecttbAddNewFile","","","Creates a new file and adds it to the project.";
      "Files...","projecttbAddFiles","","","Adds one or more existing files from a single directory to the project.";
      "Tree...","projecttbAddTreeOrWildcard","","","Adds files in a specified directory matching a given filter to the project.";
      "Folder...","projecttbAddFolder","","","";
   }
   "-","","","","";
   "Move &Up","projecttbMoveUp","","","";
   "Move &Down","projecttbMoveDown","","","";
   "Cut\tCtrl+X","projecttbCut","","","";
   "Copy\tCtrl+C","projecttbCopy","","","";
   "Paste\tCtrl+V","projecttbPaste","","","";
   "Remove\tDel","projecttbRemove","","","";
   "-","","","","";
   "Folder &Properties...","projecttbFolderProperties","","","";
}



_menu _projecttb_project_menu {
   "&Compile","projecttbCompile","","","";
   "Add New Build Tool...","projecttbAddNewBuildTool","ncw","help build menu","Launches the Project Tool Wizard";
   "Generate Makefile","projecttbGenerateMakefile","","","";
   "-","","","","";
   submenu "&More","","","" {
      "Add &new file","projecttb-add-new-file-here","","","Add new file to project";
      "Add new item from &template","projecttb-add-template-item-here","","","Add item to project from template";
      "New &folder","projecttb-add-folder-here","","","Create new folder here";
      "&Explore","projecttb-explore-from-here","","","Shell explorer";
      "&Open file","projecttb-open-from-here","","","Open file to edit";
      "-","","","","";
      "She&ll from here","projecttb_shell_from_here","","","Open OS shell";
      "Folder &MRU","projecttb-show-folder-MRU","","","";
      "Add to folder MR&U","projecttb-add-to-folder-MRU","","","";
      "Change &directory to here","projecttb-cd-to-here","","","";
      "-","","","","";
      "Copy pathname","projecttb-copy-path","","","";
      "-","","","","";
      "&Project properties","projecttb-project-properties","","","";
   }
   submenu "&Add","","Displays Add to Project menu","ncw" {
      "New File...","projecttbAddNewFile","","","Creates a new file and adds it to the project.";
      "Files...\tIns","projecttbAddToProject","","","Adds one or more existing files from a single directory to the project.";
      "Tree...","projecttbAddTreeOrWildcard","","","Adds files in a specified directory matching a given filter to the project.";
      "Folder...","projecttbAddFolder","","","";
   }
   "Open Files...","projecttbOpenFiles","","","";
   "-","","","","";
   submenu "&Version Control","help Version Control Menu","Displays project menu","version-control" {
   }
   "Refilter","projecttbRefilter","","","";
   "Refilter wildcards","projecttbRefilterWildcards","","","";
   submenu "Auto Folder","","Displays Auto Folder menu","ncw" {
      "Package View","projecttbAutoFolders PackageView","","","";
      "Directory View","projecttbAutoFolders DirectoryView","","","";
      "Custom View","projecttbAutoFolders","","","";
   }
   "Paste\tCtrl+V...","projecttbPaste","","","";
   "Remove\tDel","projecttbRemove","","","";
   "-","","","","";
   "Set Active Project","projecttbSetCurProject","","","";
   "Dependencies...","projecttbDependencies","","","";
   "Retag &Project...","projecttbRetagProject","","help Rebuilding Tag Files","Updates the tag file for the current project";
   "Refresh","projecttbRefresh","","","";
   "-","","","","";
   "Project &Properties...","project-edit","","","";
}


