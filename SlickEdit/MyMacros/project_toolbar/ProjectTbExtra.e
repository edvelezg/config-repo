
/******************************************************************************
*  $Revision: 1.3 $                                                            
******************************************************************************/


#include "slick.sh"
#pragma option(strictsemicolons,on)
#pragma option(strict,on)
#pragma option(autodecl,off)
#pragma option(strictparens,on)



/****************************************************************************** 
 * This module contains :
 * 
 * 1 : commands that are called from the right click menu in the projects
 *     toolbar.  The macro file ProjectTBExtraMenus.e contains modified right
 *     click menus for the project toolbar that call these functions.
 * 
 * 2 : An MRU (most recently used) folder facility called show_mru_folder_list.
 * 
 * 
 * This module contains an on_load event handler for _workspace_new_form. In
 * slick V13.0.0, the on_load event handler is unused in slick source.
 *
 * It is recommended to unload this module before installing any upgrade and
 * reload it only after determining that the on_load event handler is still
 * unused in slick sources.  Same goes for installing a hotfix - check the
 * on_load event handler is unused before reloading this macro.
 *
 * Also check that _projecttb_file_menu, _projecttb_project_menu and
 * _projecttb_folder_menu are unchanged before reloading the
 * ProjectTBExtraMenus.e file.
******************************************************************************/ 




/**
 * Determine the path of the current item in the projects toolbar.  This can 
 * be used when auto-folder is set to directory view or custom view. 
 * Package view is untested.  The types of tree node that this can be called 
 * for are project node, folder node or project file node. 
 * 
 * @return _str - path to current item in the projects toolbar
 */
_str projecttb_get_current_absolute_path()
{
   /*************************************************************************** 
   // don't need to find the window id, but this is how
   int treeWid;                                          
   _str name, fullPath;                                             
   treeWid= _find_object("_tbprojects_form._proj_tooltab_tree",'N');
   if (treeWid) {                                                   
      treeWid.TreeWithSelection(projecttbMaybeEditFile);            
   }                                                                
   ***************************************************************************/

   int index = _TreeCurIndex();
   int orig_index = index;
   _str path1 = '';

   if (_projecttbIsProjectNode(index)) {
      _str name = _TreeGetCaption(index);
      _str relpath="";
      parse name with name "\t" relpath;

      // might need this some day?
      //    if (_IsEclipseWorkspaceFilename(_workspace_filename)) {
      //       // For eclipse we only put the name of the file and the directory, but
      //       // not the whole file.  It looks a little more like the way Eclipse
      //       // actually does things that way.
      //       ProjectName=VSEProjectFilename(_AbsoluteToWorkspace(relpath:+name:+PRJ_FILE_EXT));
      //    }else{
      //       ProjectName=VSEProjectFilename(_AbsoluteToWorkspace(relpath));
      //    }

      return strip_filename(relpath, 'N');
   }


   if (_projecttbIsProjectFileNode(index)) {
      _str name, fullpath;
      parse _TreeGetCaption(index) with name "\t" fullpath;
      return (strip_filename(fullpath,'N'));
   }

   if (_projecttbIsFolderNode(index)) {
      path1 = '';
      // first go down the tree and try to find a file node because file nodes
      // have full path info
      while (index > 0) {                                                 
         index = _TreeGetFirstChildIndex(index);                          
         if (index > 0) {                                                 
            if (_projecttbIsProjectFileNode(index)) {                     
               break;                                                     
            }                                                             
            path1 = path1 :+ _TreeGetCaption(index) :+ FILESEP;           
         }                                                                
      }                     
      // if we found a file node, remove the sub-path from the end
      if (index > 0 && _projecttbIsProjectFileNode(index)) {              
         _str name, fullpath;                                             
         parse _TreeGetCaption(index) with name "\t" fullpath;            
         fullpath = strip_filename(fullpath, 'N');                        
         int len1 = length(fullpath);                                     
         int len2 = length(path1);                                        
         if (len2 == 0) {                                                 
            return (fullpath);                                 
         }                                                                
         if ((len1 - len2) > 2) {                                         
            int pos1 = pos(path1, fullpath, len1 - len2 - 2);             
            if (pos1 > 1) {                                               
               return (substr(fullpath, 1, pos1-1));
            }                                                             
         }                                                                
      }                                                                   

      // this is a folder node, try going back up the tree to the project node
      index = orig_index;
      path1 = _TreeGetCaption(index) :+ FILESEP;
      while (_TreeGetDepth(index) > 1) {
         index = _TreeGetParentIndex(index);
         if (!_projecttbIsProjectNode(index)) {
            path1 = _TreeGetCaption(index) :+ FILESEP :+ path1;
         }
         else {
            _str name = _TreeGetCaption(index);
            _str relpath="";
            parse name with name "\t" relpath;

               // might need this some day?
               //    if (_IsEclipseWorkspaceFilename(_workspace_filename)) {
               //       // For eclipse we only put the name of the file and the directory, but
               //       // not the whole file.  It looks a little more like the way Eclipse
               //       // actually does things that way.
               //       ProjectName=VSEProjectFilename(_AbsoluteToWorkspace(relpath:+name:+PRJ_FILE_EXT));
               //    }else{
               //       ProjectName=VSEProjectFilename(_AbsoluteToWorkspace(relpath));
               //    }

            return (absolute(path1, strip_filename(relpath,'N')));
         }
      }
   }
   _message_box("Unable to determine pathname." :+ "\n" :+ path1, "Project toolbar add item");
   return '';
}


// execute from project toolbar menu
_command void projecttb_add_template_item_here() name_info(',' VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str s = projecttb_get_current_absolute_path();
   if (s != '') {
      add_item('', '', s, true);
   }
}

// execute from project toolbar menu
_command void projecttb_add_folder_here() name_info(',' VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str s = projecttb_get_current_absolute_path();
   if (s != '') {

      #if defined(SLICK_V11) || defined(SLICK_V12)
      //_str result=show('-modal '_stdform('_cd_form'),'Choose Directory',1,1,1,false,"",s,false);
      projecttb_add_to_folder_MRU();
      #else
      _ChooseDirDialog("",s,"",CDN_PATH_MUST_EXIST|CDN_ALLOW_CREATE_DIR);
      #endif
   }
}


static boolean hook_on_load;
static _str workspace_new_file_folder;

// execute from project toolbar menu
_command projecttb_add_new_file_here() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str folder = projecttb_get_current_absolute_path();
   if (folder != '') {
      workspace_new_file_folder = folder;
      int index = _TreeCurIndex();
      if (_projecttbIsProjectFileNode(index)) {
         if (_TreeGetDepth(index) > 1) {
            int index2 = _TreeGetParentIndex(index);
            _TreeSetCurIndex(index2);
            hook_on_load = true;
            projecttbAddNewFile();  
            _TreeSetCurIndex(index);   // restore
         }
      }
      else
      {
         hook_on_load = true;
         projecttbAddNewFile();  
      }
   }
}


/****************************************************************************** 
*  The on_load event is called after on_create.  In slick 13.0.0, the on_load
*  event for _workspace_new_form is unused so it can be defined here. If
*  on_load is unable to be used in future slick versions, the on_create2
*  event should work but probably won't be able to set the focus. (need an
*  on_load2!)
******************************************************************************/
defeventtab _workspace_new_form;

void _workspace_new_form.on_load()
{
   if (hook_on_load) {
      _control ctldirectory, ctladd_to_project, ctladd_to_project_name, ctlfilename;
      hook_on_load = false;
      // set up the path we previously generated
      ctldirectory.p_text = workspace_new_file_folder;
      // ensure the trailing end of the pathname is visible
      #if defined(SLICK_V11) || defined(SLICK_V12)
      ctldirectory._end_line();
      #else
      ctldirectory.end_line_text_toggle();
      #endif
      // allow control of "add to project" checkbox
      ctladd_to_project.p_enabled = 1;
      ctladd_to_project.p_value = 1;
      ctladd_to_project_name.p_enabled = 1;
      // put the focus somewhere sensible
      ctlfilename._set_focus();
   }
}

// execute from project toolbar menu
_command projecttb_explore_from_here() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str folder = projecttb_get_current_absolute_path();
   if (folder != '') {
      #ifdef SLICK_V11
      #if __PCDOS__
      // add your favourite file explorer
      shell(get_env('SystemRoot') :+ '\explorer.exe /n,/e,/select,' :+ folder, 'A');
      #else
      _message_box('Not supported on this platform');
      #endif
      #else
      explore(folder);
      #endif
   }
}

// execute from project toolbar menu
_command projecttb_copy_path() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str folder = projecttb_get_current_absolute_path();
   if (folder != '') {
      push_clipboard_itype('CHAR','',1,true);
      append_clipboard_text(folder);
   }
}

// execute from project toolbar menu
_command projecttb_copy_filename_full_path() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   int index = _TreeCurIndex();
   if (_projecttbIsProjectFileNode(index)) {
      _str name, fullpath;
      parse _TreeGetCaption(index) with name "\t" fullpath;
      if (fullpath != '') {
         push_clipboard_itype('CHAR','',1,true);
         append_clipboard_text(fullpath);
      }
   }
}

// execute from project toolbar menu
_command projecttb_open_from_here() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str folder = projecttb_get_current_absolute_path();
   if (folder != '') {
      chdir(folder,1);
      gui_open();
   }
}

// execute from project toolbar menu
_command projecttb_cd_to_here() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str folder = projecttb_get_current_absolute_path();
   if (folder != '') {
      chdir(folder,1);
   }
}

// execute from project toolbar menu
_command projecttb_show_path() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str folder = projecttb_get_current_absolute_path();
   if (folder != '') {
      message(folder);
   }
}

// execute from project toolbar menu
_command projecttb_show_this_project_name() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   message(_projecttbTreeGetCurProjectName());
}

// execute from project toolbar menu
_command projecttb_show_current_project_name() name_info("," VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   message(_project_name);
}


// execute from project toolbar menu
_command void projecttb_show_folder_MRU() name_info(',' VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   show_mru_folder_list();
}


// execute from project toolbar menu
_command void projecttb_shell_from_here() name_info(',' VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str folder = projecttb_get_current_absolute_path();
   if (folder != '') {
      chdir(folder,1);
   }
   #ifdef SLICK_V11
   dos();
   #else
   launch_os_shell();
   #endif
}


// execute from project toolbar menu
_command void projecttb_add_to_folder_MRU() name_info(',' VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   _str folder = projecttb_get_current_absolute_path();
   if (folder != '') {
      show_mru_folder_list('', folder);
   }
}

// execute from project toolbar menu
_command void projecttb_project_properties() name_info(',' VSARG2_EXECUTE_FROM_MENU_ONLY)
{
   // this macro is actually redundant. project_edit can be added directly
   // to the project toolbar menu
   project_edit();
}



/**
 * Shows a textBoxDialog allowing folder selection and operations applied to 
 * that folder.  This command can be called from a menu, hotkey, cmd line or 
 * macro.
 * New file - create a new file in selected folder and optionally add to project .
 * New item from template - create new items in specified folder. 
 * New folder - create a new folder in specified folder. 
 * Also, explore, open, shell, change dir, browse. 
 * 
 * @param options - 'c' initial value for CD checkbox is checked; 'm' force CD
 * @param path    - initial path to show
 * @param macro_to_run  - not implemented yet
 * @param retrieve_name - name to save dialog retrieve data as
 */
_command void show_mru_folder_list(_str options='', _str path='', _str macro_to_run='', _str retrieve_name='') name_info(',')
{
   static _str last_path;
   if (path == '') 
      path = last_path;

   if (retrieve_name == '') {
      retrieve_name = 'RecentFolderDialog1';
   }

   if (macro_to_run != '') {
      _message_box('Not supported yet');
      return;
   }

   _str change_dir = '0';
   if (pos('c',options)) {
      change_dir = '1';
   }
   boolean must_change_dir = false;
   if (pos('m',options)) {
      must_change_dir = true;
   }

   while (true) {
      _str info1 = 'Active project: ' :+ _project_name;
      _str info2 = 'Working dir:    ' :+ getcwd();
      _str info3 = '';
      if (macro_to_run != '') {
         info3 = 'Macro to run:   ' :+ macro_to_run;
      }

      int result = textBoxDialog(
         "Select folder", // Form caption
         TB_RETRIEVE,      // Flags
         11000,             // textbox width
         "",               // Help item
         "&New file,New from &template,New &folder," :+ 
         "&Explore,&Open file,Shel&l,&CD,&Browse," :+ 
         "OK:_ok,Cancel:_cancel\t" info1 "\n" info2" \n" info3 "\n",

         retrieve_name,
         "Path :" path, 
         "-CHECKBOX Change current directory to here:"change_dir);

      if (result == COMMAND_CANCELLED_RC) {
         return;
      }
      if (_param1 == '') {
         if (result == 9) {
            return;
         }
         continue;
      }
      last_path = _param1;

      if (_param2 || must_change_dir) {
         chdir(_param1,1);
      }
      switch (result) {
         case 1 :
            // add new file to active project
            workspace_new_file_folder = _param1;
            hook_on_load = true;
            show('-modal _workspace_new_form','F');
            return;
         case 2 :
            add_item('', '', _param1, true);
            return;
         case 8 :
            // browse is same as "create new folder"
         case 3 :
            #if defined(SLICK_V11) || defined(SLICK_V12)
            _str path2 = _param1;
            if (!isdirectory(path2)) {
               make_path(path2);
            }
            path=show('-modal '_stdform('_cd_form'),'Choose Directory',1,1,1,false,"",path2,false);
            #else
            path = _ChooseDirDialog("",_param1,"",CDN_PATH_MUST_EXIST|CDN_ALLOW_CREATE_DIR);
            #endif
            // show this dialog again
            break;
         case 4 :
            #ifdef SLICK_V11
            #if __PCDOS__
            shell(get_env('SystemRoot') :+ '\explorer.exe /n,/e,/select,' :+ _param1, 'A');
            #else
            _message_box('Not supported on this platform');
            #endif
            #else
            explore(_param1);
            #endif
            return;
         case 5 :
            chdir(_param1,1);
            gui_open();
            return;
         case 6 :
            chdir(_param1,1);
            #ifdef SLICK_V11
            dos();
            //shell();
            #else
            launch_os_shell();
            #endif
            return;
         case 7 :
            chdir(_param1,1);
            return;
         case 0 :
         default:
            return;
      }
   }
}




