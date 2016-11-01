#include 'slick.sh'
_menu _tbfilelist_menu {
   "&Open","tbfilelist-menu-command open","","","";
   "Open in C&urrent Window","tbfilelist-menu-command open-current","","","";
   "&Save","tbfilelist-menu-command save","","","";
   "&Close","tbfilelist-menu-command close","","","";
   "&Diff","tbfilelist-menu-command diff","","","";
   "Add to Pro&ject...","tbfilelist-menu-command addToProject","","","";
   "-","","","","";
   "Dismiss on select","tbfilelist-menu-command dismiss","","","Close dialog when a file is selected";
   "Prefix match","tbfilelist-menu-command prefixmatch","","","";
   "Auto-size columns","tbfilelist-menu-command autocolumnwidths","","","";
   "Refresh","tbfilelist-menu-command refresh","","","Refresh project or workspace files";
}
_menu _tbdelta_menu {
   "&Save Selected Backup as...","TBD_saveBackupAs","","","";
   "&Open Selected Backup","TBD_loadBackupVersion","","","";
   "Run &Diff on Selected Backup","TBD_diffWithCurrent","","","";
   "&Revert to Selected Backup","TBD_revertBackup","","","";
   "Add &Comments to Selected Backup","TBD_setBackupComment","","","";
   "&View CVS History","TBD_viewCVSHistory","","","";
}
_menu _ext_menu_default_sel {
   "Cut","cut","nrdonly","help Edit menu","Deletes the selected text and copies it to the clipboard";
   "Copy","copy-to-clipboard","","help Edit menu","Copies the selected text to the clipboard";
   "Paste","paste","clipboard|nrdonly","help Edit menu","Inserts the clipboard into the current file";
   "-","","","","";
   "Quick Search","quick-search","","help Quick Search","Searches for current word at cursor or selection";
   "Quick Replace","quick-replace","","help Quick Replace","Replace the current word at cursor or selection";
   "-","","","","";
   "Quick Rename...","refactor_quick_rename","quick_rename","","Rename symbol";
   "Extract Method...","refactor_extract_method","extract_method","","Extract the selected code block into a new function";
   "Quick Extract Method...","refactor_quick_extract_method","quick_extract_method","","Extract the selected code block into a new function";
   "&Generate Debug from Selected","PrintMacro2","","","First on PrintMacro2";
   "-","","refactorbar","","";
   "Shift Selection Left...","arg-shift-selection L","nrdonly","help shift_selection_left","Shifts the selection left any number of spaces";
   "Shift Selection Right...","arg-shift-selection R","nrdonly","help shift_selection_right","Shifts selection right any number of spaces";
   "Column Align Variables","align-variables","nrdolny","","Aligns variable declarations into a table, with columns for the type, name, and initial value.";
   "Surround Selection With...","surround-with","nrdonly","help Surround With dialog","Surrounds selection with some construct";
   "Unsurround...","unsurround","nrdonly","help Unsurround Block","Un-surrounds the block under the cursor";
   "Create Alias...","new-alias","nrdonly","help Aliases","Create a new alias containing the selected text";
   "Fill...","fill-selection","nrdonly","help Edit menu","Fills selected text with a character you choose";
   "Spell Check Selection","spell-check M","nrdonly","help Spell Check","Spell check the selected text";
   "-","","debuggerbar","","";
   "Add Watch","debug_add_watch","","help Debug","Add a watch on the selected variable";
   "Set Watchpoint","debug_add_watchpoint","","help Debug","Add a watchpoint on the selected variable";
   "-","","","","";
   "Edit This Menu","open-menu _ext_menu_default_sel","","popup-imessage Runs menu editor on this menu","Allows you to customize this menu";
}
_menu _ext_menu_default {
   "Quick Search","quick-search","","help Quick Search","Searches for word at cursor";
   "Quick Replace","quick-replace","","help Quick Replace","Replace the word at cursor";
   "-","","","","";
   "Go to &Definition","push-tag","","help Go to Definition","Goes to definition or declaration for word at cursor";
   "Go to Declaration","push-alttag","ncw","help Go to Declaration","Goes to definition or declaration for word at cursor";
   "Go to &Reference","push-ref","","help Go to Reference","Search for references to the symbol under the cursor";
   "Edit Associated File","edit-associated-file","ncw","help Document Menu","Switch to header or source file associated with the current file";
   "-","","","","";
   "List &Symbols","list-symbols","","help Context Tagging","Lists valid symbols for current context";
   "Parameter &Info","function-argument-help","","help Context Tagging","Display prototype(s) and highlights current argument";
   "Show in Symbol Browser","cf","cf","help Symbols tool window","Finds current word in symbol browser";
   "-","","","","";
   submenu "C++ &Refactoring","","Displays C++ refactoring menu","cpp_refactoring" {
   }
   submenu "&Quick Refactoring","help Quick Refactoring","Displays Quick refactoring menu","quick_refactoring" {
      "&Override Method...","override_method 0","override_method","help Symbols tool window","Lists virtual methods from a parent class that may be overridden";
   }
   submenu "Im&ports","help Organize Imports Options","Displays Imports refactoring menu","imports" {
      "Organize Imports","jrefactor_organize_imports","organize_imports","help Java Organize Imports","Organize import statements in a java file";
      "Add Import","jrefactor_add_import","add_import","help Add import","Add import statement for symbol under cursor";
      "-","","bar","","";
      "Options...","jrefactor_organize_imports_options","organize_imports_options","help Java Organize imports options","View options for Organize Imports operations";
   }
   "Generate Debug","generate_debug","generate_debug","help Generate debug","Generates debug code for symbol under the cursor";
   "Update Doc Comment","update_doc_comment","update_doc_comment","help update_doc_comment","Create or update the documentation comment for the current function or method";
   "-","","","","";
   "Set Breakpoint","debug_toggle_breakpoint","set_breakpoint","help Debug","Toggle a breakpoint on this line";
   "Enable Breakpoint","debug_toggle_breakpoint_enabled","","help Debug","Toggle whether the current breakpoint is enabled or not";
   "Breakpoint properties...","debug_edit_breakpoint","","help Debug","Toggle whether the current breakpoint is enabled or not";
   "Add Watch","debug_add_watch","","help Debug","Add a watch on the current variable";
   "-","","","","";
   "Copy Word","copy-word","","help Edit menu","Copies the current word to the clipboard";
   "&Paste","paste","","help Edit menu","Inserts the clipboard into the current file";
   "List Clipboards...","list-clipboards","nrdonly","help List Clipboards","Inserts a clipboard select from a list of your recently created clipboards";
   "-","","","","";
   "&Toggle Bookmark\tCtrl+Shift+J","toggle-bookmark","toggle_bookmark","help bookmarks","Toggles setting a bookmark on the current line";
   "Create Code Annotation...","new-annotation","new_annotation","help Code Annotations","Creates a code annotation on the current line";
   "Show File in Projects Tool Window","show_file_in_projects_tb","show_file_in_projects_tb","help Projects Tool Window","Expands all projects containing the current file in the Projects tool window.";
   "&Add File to Project...","project_add_files_prompt_project","","","";
   "-","","version-control-sep","","";
   submenu "&Version Control","help Version Control Menu","Displays project menu","version-control" {
      "Check &In","vccheckin","update","help Version Control Menu","Checks in current file";
      "&Get","vcget","get","help Version Control Menu","Checks out current file read only";
      "Check &Out","vccheckout","checkout","help Version Control Menu","Checks out current file";
      "Lock","vclock","lock","help Version Control Menu","Locks the current file without checking out the file";
      "U&nlock","vcunlock","uncheckout","help Version Control Menu","Unlocks the current file without checking in the file";
      "-","","","","";
      "&Add","vcadd","add","help Version Control Menu","Adds current file to version control";
      "&Remove","vcremove","remove","help Version Control Menu","Removes current file from version control";
      "-","","","","";
      "&History...","vchistory","history","help Version Control Menu","Views history for current file";
      "&Difference...","vcdiff","diff","help Version Control Menu","Views differences of current file";
      "&Properties...","vcproperties","properties","help Version Control Menu","Views properties of current file";
      "&Manager...","vcmanager","manager","help Version Control Menu","Executes Version Control Manager";
      "-","","","","";
      "&Setup...","vcsetup","","help Version Control Setup dialog box","Allows you to choose and configure a Version Control System interface";
   }
   "-","","","","";
   "Edit This Menu","open-menu _ext_menu_default","","popup-imessage Runs menu editor on this menu","Allows you to customize this menu";
}
_menu _mdi_menu {
   submenu "&File","help file menu","Displays file menu","ncw" {
      "&New...","new","ncw","help file menu","Creates an empty file to edit";
      "New Item from &Template...","add-item","ncw","help Add New Item Dialog Box (Code Templates)","Create files from template";
      "&Open...\tF7","gui-open\tedit\te","ncw","help open dialog box","Opens a file for editing";
      "Open &URL...","open-url","","help Open URL dialog box","Opens an HTTP file";
      "&Close","quit\temacs-quit","","help file menu","Closes the current file";
      "Close All","close-all","","help file menu","Closes all files";
      "-","","","","";
      "&Save","save","","help file menu","Saves the current file";
      "Save &As...","gui-save-as","","help save as dialog box","Saves the current file under a different name";
      "Sav&e All","save-all","","help file menu","Saves all modified files";
      "&Revert","revert-or-refresh","","help file menu","Revert current file to version on disk";
      "Reload with Encoding...","reload_with_encoding","","help file menu","Reload the current document using a different encoding";
      "Change &Directory...","gui-cd\tprompt-cd","ncw","help change directory dialog box","Changes the current working directory";
      "-","","","","";
      "&Backup history for ...","history_diff_machine_file","","","List backup information for ";
      "Backup history browser ...","backup_history_browser","","","List all backup history information";
      "-","","","","";
      submenu "&FTP","help FTP Menu","Displays menu of FTP commands","ncw" {
         "&Start New Connection...","ftpOpen 1","","help FTP Menu","Activates FTP tool window and starts a new connection";
         "&Activate FTP","activate_ftp","","help FTP Menu","Activates FTP tool window";
         "&Upload","ftpUpload","","help FTP Menu","Uploads the current FTP file";
         "&Client","ftpClient","","help FTP Menu","Activates FTP Client toolbar";
         "&Profile Manager","ftpProfileManager","","help FTP Menu","Displays FTP Profile Manager dialog box";
         "Default Options...","ftp_default_options","","help FTP Menu","Displays FTP Options dialog box";
      }
      "-","","","","";
      "&Print...","gui-print","ncw","help Print Dialog Box","Prints current file or selection";
      "&Insert a File...","gui-insert-file\tget","nrdonly","help insert file dialog box","Inserts a file you choose at the cursor";
      "&Write Selection...","gui-write-selection\tput","sel","help write selection dialog box","Writes selected text to a file you choose";
      "Template Manager...","template-manager","ncw","help Template Manager Dialog Box (Code Templates)","Create, edit, and delete your templates";
      "Export to HTML...","export-html","ncw","help","Write file to HTML format";
      submenu "File &Manager","help file manager menu","Displays menu of file manager commands","ncw" {
         "&New File List...","fileman","ncw","help list files dialog box","Displays a directory of files you choose";
         "&Append File List...","fileman append","fileman","help list files dialog box","Appends files to current list";
         "S&ort...","fsort","fileman","help file sort dialog box","Sorts file list";
         "&Backup...","fileman-backup","fileman","help backup dialog box","Copies selected files and preserve directory structure";
         "&Copy...","fileman-copy","fileman","help copy dialog box","Copies selected files to a directory you choose";
         "&Move...","fileman-move","fileman","help move dialog box","Moves selected files to a directory you choose";
         "&Delete","fileman-delete","fileman","help file manager menu","Delete selected files";
         "&Edit","fileman-edit","fileman","help file manager menu","Edits selected files";
         submenu "&Select","help fileman select menu","Displays menu of file manager select commands","ncw" {
            "&All","fileman_select_all","fileman","help fileman select menu","Selects all files";
            "&Deselect All","deselect-all","fileman","help fileman select menu","Deselects all files";
            "&InvertSelect","select-reverse","fileman","help fileman select menu","Selects files which are not selected and deselects files which are selected";
            "A&ttribute...","select-attr","fileman","help fileman select menu","Selects files based on file attribute";
            "&Extension...","gui-select-ext","fileman","help fileman select menu","Selects files based on file extension";
            "&Highlight","select-mark","fileman","help fileman select menu","Selects files which are highlighted";
            "Dese&lect Highlight","deselect-mark","fileman","help fileman select menu","Deselects files which are highlighted";
         }
         submenu "&Files","help files menu","Displays menu of file manager listing commands","ncw" {
            "&Unlist All","unlist-all","fileman","help files menu","Removes all files from the list.  Files are not deleted.";
            "Unlist &Selected","unlist-select","fileman","help files menu","Removes selected files from the list.  Files are not deleted.";
            "Unlist &Extension...","gui-unlist-ext","fileman","help files menu","Removes files with a specific extension from the list";
            "Unlist &Attribute...","unlist-attr","fileman","help files menu","Removes files with a specific attribute from the list";
            "Unlist Sear&ch...","unlist-search","fileman","help unlist search dialog box","Removes lines which contain a particular search string";
            "&Read List...","read-list","fileman","help read list dialog box","Appends a list of files contained in a file";
            "&Write List...","write-list","fileman","help write list dialog box","Writes a file containing the currently selected files";
         }
         "A&ttribute...","fileman-attr","fileman","help file manager menu","Changes files attributes";
         "&Repeat Command...","for-select","fileman","help Repeat Command on Selected Dialog Box","Runs internal or external command on selected files";
         "&Global Replace...","fileman-replace","fileman","help global replace dialog box","Performs search and replace on selected files";
         "Global Find...","fileman-find","","help Global Find dialog","Performs search on selected files";
      }
      "-","","","","";
      "E&xit","safe-exit","ncw","help file menu","Prompts you to save files if necessary and exits the editor";
   }
   submenu "&Edit","help edit menu","Displays edit menu","ncw" {
      "&Undo","undo","undo|nicon|nrdonly","help edit menu","Undoes the last edit operation";
      "&Redo","redo","nicon|nrdonly","help edit menu","Undoes an undo operation";
      "Multi-File Undo","mfundo","","help edit menu","Undoes the last multi file operation";
      "Multi-File Redo","mfredo","","help edit menu","Undoes a multi file undo operation";
      "-","","","","";
      "Cu&t","cut","sel|nrdonly","help edit menu","Deletes the selected text and copies it to the clipboard";
      "&Copy","copy-to-clipboard","ab-sel|nicon","help edit menu","Copies the selected text to the clipboard";
      "&Paste","paste\tbrief-paste\temacs-paste","clipboard|nicon|nrdonly","help edit menu","Inserts the clipboard into the current file";
      "&List Clipboards...\tCtrl+X Ctrl+Y","list-clipboards","nicon|nrdonly","help list clipboards dialog box","Inserts a clipboard selected from a list of your recently created clipboards";
      "Copy &Word","copy-word","nicon","help edit menu","Copies the current word to the clipboard";
      "&Append to Clipboard","append-to-clipboard","ab-sel|nicon","help edit menu","Appends the selected text to the clipboard";
      "App&end Cut","append-cut","ab-sel|nicon|nrdonly","help edit menu","Deletes the selected text and appends it to the clipboard";
      "Insert Literal...","insert-literal","nicon|nrdonly","help insert literal dialog box","Inserts a character code you specify";
      "-","","","","";
      submenu "&Select","help edit select menu","Displays menu for selecting and deselecting text","ncw" {
         "C&har","select-char","nicon","help edit select menu","Starts or ends a character/stream selection";
         "&Block","select-block","nicon","help edit select menu","Starts or ends a block/column selection";
         "&Line","select-line","nicon","help edit select menu","Starts or ends a line selection";
         "&Word","select-whole-word","","help edit select menu","Selects the word under cursor";
         "&Code Block","select-code-block","","help edit select menu","Selects current code block";
         "&Procedure","select-proc","nicon","help edit select menu","Selects procedure/function";
         "&Deselect","deselect","sel","help edit select menu","Unhighlights selected text";
         "&All","select-all","","help edit select menu","Select all text in current buffer";
      }
      submenu "&Delete","help delete menu","Displays menu for deleting text","ncw" {
         "&Word","cut-full-word","nicon|nrdonly","help delete menu","Deletes text from the cursor to the end of the current word and copies it to the clipboard";
         "&Line","cut-line","nicon|nrdonly","help delete menu","Deletes the current line and copies it to the clipboard";
         "&To End of Line","cut-end-line","nicon|nrdonly","help delete menu","Deletes text from the cursor to the end of the line and copies it to the clipboard";
         "&Selection","delete-selection","sel|nicon|nrdonly","help delete menu","Deletes the selected text";
         "&All","delete-all","","help delete menu","Delete all text in current buffer";
      }
      "Complete Previous Word","complete-prev","nrdonly","help Edit Menu","Retrieves previous word or variable matching word prefix at cursor";
      "Complete Next Word","complete-next","nrdonly","help Edit Menu","Retrieves next word or variable matching word prefix at cursor";
      "&Fill...","gui-fill-selection\tfill-selection","sel|nicon|nrdonly","help edit menu","Fills the selected text with a character you choose";
      "&Indent","indent-selection","sel|nicon|nrdonly","help edit menu","Indents the selected text based on the tabs or indent for each level";
      "U&nindent","unindent-selection","sel|nicon|nrdonly","help edit menu","Unindents the selected text based on the tabs or indent for each level";
      submenu "&Other","help edit other menu","Displays menu containing more edit related commands","ncw" {
         "&Lowcase","lowcase-selection","sel|nicon|nrdonly","help edit other menu","Translates the characters in the selection or current word to lower case";
         "&Upcase","upcase-selection","sel|nicon|nrdonly","help edit other menu","Translates the characters in the selection or current word to upper case";
         "Cap&italize","cap-selection","sel|nicon|nrdonly","help edit other menu","Capitalizes the first character of each word in the current selection";
         "-","","","","";
         "&Shift Left","shift-selection-left","sel|nicon|nrdonly","help edit other menu","Deletes the first column of text in each line of the selected text";
         "Shift &Right","shift-selection-right","sel|nicon|nrdonly","help edit other menu","Inserts a space at the first column of each line of the selected text";
         "&Overlay Block","overlay-block-selection","block|nicon|nrdonly","help edit other menu","Overwrites selected block/column of text at the cursor";
         "&Adjust Block","adjust-block-selection","block|nicon|nrdonly","help edit other menu","Overlays the selected text at the cursor and fills the original selected text with spaces";
         "&Copy to Cursor","copy-to-cursor","sel|nicon|nrdonly","help edit other menu","Copies the selection to the cursor without using the clipboard";
         "&Enumerate...","gui-enumerate","ab-sel","help Edit Other Menu","Adds incrementing numbers to a selection";
         "&Filter Selection...","filter_command","","","Filter the selected text through an external command";
         "-","","","","";
         "Copy UC&N As Unicode","copy_ucn_as_unicode","","help edit other menu",'Copies various UCN forms (like \uHHHH, \xHHHH, &#xHHHH etc.) as Unicode';
         submenu "&Copy Unicode As","help edit other copy unicode as ucn menu","Displays menu containing copy as Unicode commands","ncw" {
            '&C++ (UTF-16 \xHHHH)',"copy-unicode-as-c","","help Copy Unicode As menu",'Copies unicode characters in selection as C++ UTF-16 \xHHHH notation';
            '&Regex (UTF-32 \x{HHHH})',"copy-unicode-as-regex","","help Copy Unicode As menu",'Copies unicode characters in selection as Regex UTF-32 \x{HHHH} notation';
            '&Java/C# (UTF-16 \uHHHH)',"copy-unicode-as-java","","help Copy Unicode As menu",'Copies unicode characters in selection as Java/C# UTF-16 \uHHHH notation';
            '&UCN (UTF-32 \uHHHH and \UHHHHHHHH)',"copy-unicode-as-ucn","","help Copy Unicode As menu",'Copies unicode characters in selection as UCN \uHHHH and \UHHHHHHHH UTF-32 notation';
            "SGML/XML &hexadecimal (UTF-32 &&#xHHHH;)","copy-unicode-as-xml","","help Copy Unicode As menu","Copies unicode characters in selection as SGML/XML &#xHHHH; UTF-32 notation";
            "SGML/XML &decimal (UTF-32 &&#DDDD;)","copy-unicode-as-xmldec","","help Copy Unicode As menu","Copies unicode characters in selection as SGML/XML &#DDDD; UTF-32 notation";
         }
         "-","","","","";
         "&Tabs to Spaces","convert_tabs2spaces","nicon|nrdonly","help edit other menu","Converts tabs to spaces for selection or current buffer";
         "S&paces to Tabs","convert_spaces2tabs","","help edit other menu","Converts indentation spaces to tabs for selection or current buffer";
         "Remove Trailing &Whitespace","remove_trailing_spaces","","help edit other menu","Removes whitespace spaces at end of line";
         "&Block Insert Mode","block_insert_mode","","help Edit Other menu","Allows you to insert/delete characters for an entire block/column selection";
      }
   }
   submenu "&Search","help search menu","Displays menu of search commands","ncw" {
      "&Find...","gui-find\t/\tl\tsearch-forward","ncw","help Find and Replace tool window","Searches for a string you specify";
      "F&ind in Files...","find-in-files","ncw","help Find and Replace tool window","Searches for a string in files";
      "&Next Occurrence","find-next\tsearch-again","ncw","help search menu","Searches for the next occurrence of the last string you searched for";
      "&Previous Occurrence","find-prev\tsearch-again","ncw","help search menu","Searches for the previous occurrence of the last string you searched for";
      "&Replace...","gui-replace\tc\ttranslate-forward\tquery-replace","ncw","help Find and Replace tool window","Searches for a string and replaces it with another string";
      "R&eplace in Files...","replace-in-files","ncw","help Find and Replace tool window","Searches for a string and replaces it with another string in files";
      "Incremental Search","i-search","","help Incremental Searching","Searches for match incrementally";
      "Find File...","find-file","","help find file dialog box","Searches for files on disk";
      "Find S&ymbol...","activate-find-symbol\tgui-push-tag","ncw","help Find Symbol tool window","Searches tag databases for a symbol you specify";
      "-","","","","";
      "&Go to Line...","gui-goto-line\tgoto-line","nicon","help search menu","Places the cursor on a line you specify";
      "Go to Col&umn...","gui-goto-col","","help search menu","Places the cursor on a column you specify";
      "Go to &Offset...","gui-seek","nicon","help Seek dialog","Places the cursor on a byte/character offset in the current file";
      "Go to &Matching Parenthesis\tCtrl+]","find-matching-paren","nicon","help Begin End Structure Matching","Finds the matching parenthesis or begin/end structure pair";
      "Go to &Definition","push-tag","ncw","help Go to Definition","Goes to definition or declaration for word at cursor";
      "Go to Declaration","push-alttag","ncw","help Go to Declaration","Goes to definition or declaration for word at cursor";
      "Go to Referen&ce","push-ref","ncw","help Go to reference","Search for references to the symbol under the cursor";
      "-","","","","";
      submenu "&Bookmarks","help bookmarks menu","Displays Bookmark-related menu items","ncw" {
         "P&ush Bookmark","push-bookmark","nicon","help bookmarks","Pushes a bookmark at the cursor";
         "P&op Bookmark","pop-bookmark","","help bookmarks","Pops the last bookmark";
         "Bookmark Stac&k...","bookmark-stack","","help Bookmark Stack dialog","Displays all pushed bookmarks";
         "&Set Bookmark...","set-bookmark","ncw","help bookmarks","Set a persistent bookmark on the current line";
         "Go to Bookmark...","goto-bookmark","ncw","help Go to Bookmark dialog box","Displays Go to Bookmark dialog box";
         "&Toggle Bookmark","toggle-bookmark","toggle_bookmark","help bookmarks","Toggles setting a bookmark on the current line";
         "&Bookmarks Tool Window...","activate-bookmarks","ncw","help Bookmarks Tool Window","List bookmarks and allows you to add and delete bookmarks";
         "Ne&xt Bookmark","next-bookmark","ncs","help bookmarks","Go to next bookmark";
         "Pre&vious Bookmark","prev-bookmark","ncs","help bookmarks","Go to previous bookmark";
      }
      "-","","","","";
      "&Last Find/Grep List","grep_last","ncw","help search menu","Displays list of Files/Buffers generated by Find command";
   }
   submenu "&View","help view menu","Displays view menu","ncw" {
      "&Hex","hex","","help view menu","Toggles hex/ASCII display";
      "Line Hex","linehex","","help view menu","Toggles line hex/ASCII display";
      "S&pecial Chars","view-specialchars-toggle","","help view menu","Toggles viewing of tabs,spaces, and new line character(s) on/off";
      "&New Line Chars","view-nlchars-toggle","","help view menu","Toggles viewing of new line character(s) on/off";
      "Ta&b Chars","view-tabs-toggle","","help View Menu","Toggles viewing of tab character(s) on/off";
      "Spac&es","view-spaces-toggle","","help View Menu","Toggles viewing of space character(s) on/off";
      "Other Ctrl Characters","view-other-ctrl-chars-toggle","","help View Menu","Toggles viewing of other control character(s) on/off";
      "&Line Numbers","view-line-numbers-toggle","","help view menu","Toggles viewing of line numbers on/off";
      "-","","","","";
      "Soft &Wrap","softwrap-toggle","","help view menu","Toggles wrapping of long lines to window width";
      "Language &View Options... ","setupext -view","","help View Options (Language-Specific)","Configure default view options for current language";
      "-","","","","";
      submenu "&Toolbars","","Show, hide, or customize a toolbar","ncw" {
         "Customize...","toolbars","","help Toolbar Customization dialog","";
      }
      submenu "&Tool Windows","","Show, hide, or customize a tool window","ncw" {
         "Customize...","customize_tool_windows","","help Toolbar Customization dialog","";
      }
      "F&ull Screen","fullscreen","","help Full Screen Mode","Toggles full screen editing mode";
      "-","","","","";
      "&Selective Display...","selective-display","","help Selective Display dialog box","Allows you to hide lines and create an outline";
      "Hide All Co&mments","hide-all-comments","","help View menu","Hides all lines that only contain a comment";
      "Hide &Code Block","hide-code-block","","help View menu","Hides lines inside current code block";
      "Hi&de Selection","hide-selection","sel","help View menu","Hides selected lines";
      "Hide #&region Blocks","hide-dotnet-regions","","help View menu","Hides .NET #region blocks";
      "&Function Headings","show-procs","","help View menu","Collapses all function code blocks in the current file";
      "E&xpand/Collapse Block","plusminus","","help View menu","Toggles between hiding and showing the code block under the cursor";
      "Copy &Visible","copy-selective-display","","help View menu","Copies text not hidden by selective display";
      "Show &All","show-all","","help view menu","Ends selective display.  All lines are displayed and outline bitmaps are removed";
   }
   submenu "&Project","help project menu","Displays project menu","ncw" {
      "&New...","project_new_maybe_wizard","ncw","help New Project Tab","Allows you to create a workspace and/or project";
      "&Open Workspace...","workspace-open","ncw","help Project Menu","Opens a workspace";
      submenu "Open O&ther Workspace","","Opens a workspace","ncw" {
         "Visual Studio .NET &Solution...","workspace_open_visualstudio","","help Open Other Workspace Menu","Open a Visual Studio Solution";
         "Visual &C++ Workspace...","workspace_open_visualcpp","","help Open Other Workspace Menu","Open a Visual C++ Workspace";
         "Visual C++ E&mbedded Workspace...","workspace_open_visualcppembedded","","help Open Other Workspace Menu","Open a Visual C++ Embedded Workspace";
         "&Tornado Workspace...","workspace_open_tornado","","help Open Other Workspace Menu","Open a Tornado Workspace";
         "&Ant XML Build File...","workspace_open_ant","","help Open Other Workspace Menu","Open an Ant XML Build File";
         "&Maven Project File...","workspace_open_maven","","help Open Other Workspace Menu","Open a Maven Project File";
         "&Makefile...","workspace_open_makefile","","help Open Other Workspace Menu","Open a Makefile";
         "&QT Makefile...","workspace_open_qtmakefile","","help Open Other Workspace Menu","Open a QT Makefile";
         "&NAnt .build File...","workspace_open_nant","","help Open Other Workspace Menu","Open a NAnt .build file";
         "&JBuilder Project...","workspace_open_jbuilder","","help Open Other Workspace Menu","Open a JBuilder Project";
         "&Xcode Project...","workspace_open_xcode","","help Open Other Workspace Menu","Open a Xcode Project";
         "&Flash Project...","workspace_open_flash","","help Open Other Workspace Menu","Open a Flash Project";
         "An&droid Project...","workspace_open_android","","help Open Other Workspace Menu","Open an Android Project";
         "-","","","","";
         "Workspace from C&VS...","cvs-open-workspace","","help Open Other Workspace Menu","Checkout and open a workspace from CVS";
         "Convert Co&deWright Workspace","cwprojconv.e","","help Open Other Workspace Menu","Convert a Codewright workspace and projects to SlickEdit workspace and projects";
      }
      "&Close Workspace","workspace-close","ncw","help project menu","Closes the current workspace";
      "Or&ganize All Workspaces...","workspace-organize","","help Managing Workspaces","Manage workspaces";
      "&Workspace Properties...","workspace_properties","","help Workspace Properties dialog","Lists projects in the current workspace";
      "Re&tag Workspace...","workspace_retag","","help Rebuilding Tag Files","Updates the tag file for the current workspace";
      "Re&tag Project...","project_retag","","help Rebuilding Tag Files","Updates the tag file for the current project";
      "&Refresh","workspace_refresh","","help Managing Workspaces","Refreshes current workspace, projects, and tag files(Pro only)";
      "-","","","","";
      "Add New Item from Template...","project-add-item","ncw","help Add New Item Dialog Box (Code Templates)","Create files from template and add to project";
      "-","","","","";
      "Open &Files from Project...","project-load -p","ncw","help project menu","Open files from current project";
      "Open Files from Workspace...","project-load","ncw","help project menu","Open files from current workspace";
      "&Insert Project into Workspace...","workspace_insert","","help Project Menu","Adds an existing project to the current workspace";
      "&Dependencies...","workspace_dependencies","","help dependencies (defining for projects)","Sets the dependencies for the active project";
      "Project Prop&erties...","project-edit","ncw","help Project Properties dialog","Edit settings for the current project";
   }
   submenu "&Build","help project menu","Displays project menu","ncw" {
      "&Add New Build Tool...","project-tool-wizard","ncw","help build menu","Launches the Project Tool Wizard";
      "-","-","","","";
      "&Next Error","next-error","ncw","help build menu","Processes the next compiler error message";
      "&Previous Error","prev-error","ncw","help build menu","Processes the previous compiler error message";
      "&Go to Error or Include","cursor-error","nicon","help build menu","Parses the error message or filename at the cursor and places cursor in file";
      "&Clear All Error Markers","clear-all-error-markers","ncw","help build menu","Removes all error markers in all files";
      "Configure Error Parsing...","configure-error-regex","ncw","help Error Regular Expressions dialog box","Configures regular expressions used to search for compiler messages";
      "-","","","","";
      "&Stop Build","stop-process","ncw","help build menu","Sends break signal to the build tab";
      "Show Build","start-process","ncw","help build menu","Starts or activates the the build tab";
      "Build Automatically on Save","project-toggle-auto-build","ncw","help build menu","Toggles option to build projects automatically on file save";
   }
   submenu "&Debug","help debug menu","Displays debug menu","ncw" {
      submenu "Windows","help Debug Windows menu","Displays debug window toolbars","" {
         "&Call Stack","activate_call_stack","","help Debug Windows menu","Activates the Call Stack window";
         "&Locals","activate-locals","","help Debug Windows menu","Activates the Locals window";
         "&Members","activate-members","","help Debug Windows menu","Activates the window which displays member variables";
         "&Autos","activate-autos","","help Debug Windows menu","Activates the Autos window";
         "&Watch","activate-watch","","help Debug Windows menu","Activates the Watch window";
         "T&hreads","activate-threads","","help Debug Windows menu","Activates the Threads window";
         "&Breakpoints","activate-breakpoints","","help Debug Windows menu","Activates the Breakpoints window";
         "&Registers","activate-registers","","help Debug Windows menu","Activates the Registers window";
         "Memo&ry","activate-memory","","help Debug Windows menu","Activates the Memory window";
         "Loaded &Classes","activate-classes","","help Debug Windows menu","Activates the Loaded Classes window";
      }
      "&Start","project_debug","","help debug menu","Starts debugger";
      "Suspend","debug_suspend","","help debug menu","Suspends execution";
      "Stop &Debugging","debug_stop","","help debug menu","Stops debugging the program";
      "&Restart","debug_restart","","help debug menu","Restarts the program";
      "Start with arguments...","debug_run_with_arguments","","help debug menu","Starts debugger with user-specified command line arguments and working directory";
      "-","","","","";
      submenu "Unix &Attach Debugger","help Attach Debugger Menu","Attach debugger to a process, remote server or core file","" {
         "Attach to Running Process...","debug_attach gdb","","help Attach Debugger menu","Attach debugger to a running process using GDB";
         "Analyze Core File...","debug_corefile gdb","","help Attach Debugger menu","Attach debugger to a core file";
         "Attach to Remote Process...","debug_remote gdb","","help Attach Debugger menu","Attach debugger to a remote GDB server or executable with GDB stub";
         "&Attach to Java Virtual Machine...","debug_attach jdwp","","help Attach Debugger menu","Attach to a Java virtual machine executing remotely";
         "Attach to Android Application Process (GDB for NDK)...","debug_remote android","","help Attach Debugger menu","Attach debugger to an Android application running on a hardware device or emulator";
         "Attach to &Xdebug...","debug_remote xdebug","","help Attach Debugger menu","Listen for a remote connection from Xdebug";
         "Attach to &pydbgp...","debug_remote pydbgp","","help Attach Debugger menu","Listen for a remote connection from pydbgp (Python)";
         "Attach to &perl5db...","debug_remote perl5db","","help Attach Debugger menu","Listen for a remote connection from perl5db (Perl)";
         "Attach to &rdbgp...","debug_remote rdbgp","","help Attach Debugger menu","Listen for a remote connection from rdbgp (Ruby)";
         "Debug Other Executable...","debug_executable gdb","","help Attach Debugger menu","Step into a program using GDB";
      }
      submenu "Windows &Attach Debugger","help Attach Debugger menu","Attach debugger to a process or remote server","" {
         submenu "&GDB","","","" {
            "Attach to Process (GDB)...","debug_attach gdb","","help Attach Debugger menu","Attach debugger to a running process using GDB";
            "Attach to Remote Process (GDB)...","debug_remote gdb","","help Attach Debugger menu","Attach debugger to a remote GDB server or executable with GDB stub";
            "Attach to Android Application Process (GDB)...","debug_remote android","","help Attach Debugger menu","Attach debugger to an Android application running on a hardware device or emulator";
            "Debug Executable (GDB)...","debug_executable gdb","","help Attach Debugger menu","Step into a program using GDB";
         }
         submenu "&WinDBG","","","" {
            "Attach to Process (WinDbg)...","debug_attach windbg","","help Attach Debugger menu","Attach debugger to a running process using WinDbg";
            "Debug Executable (WinDbg)...","debug_executable windbg","","help Attach Debugger menu","Step into a program using WinDbg";
            "Open Dump File (WinDbg)...","debug_corefile windbg","","help Attach Debugger menu","Attach debugger to a dump file";
         }
         "&Attach to Java Virtual Machine...","debug_attach jdwp","","help Attach Debugger menu","Attach to a Java virtual machine executing remotely";
         "Attach to &Xdebug...","debug_remote xdebug","","help Attach Debugger menu","Listen for a remote connection from Xdebug";
         "Attach to &pydbgp...","debug_remote pydbgp","","help Attach Debugger menu","Listen for a remote connection from pydbgp (Python)";
         "Attach to &perl5db...","debug_remote perl5db","","help Attach Debugger menu","Listen for a remote connection from perl5db (Perl)";
         "Attach to &rdbgp...","debug_remote rdbgp","","help Attach Debugger menu","Listen for a remote connection from rdbgp (Ruby)";
      }
      "Detach","debug_detach","","help debug menu","Detach from target process and allow application to continue running";
      "Debugger Information...","debug_props","","help Debugger Options dialog","Displays the debugger options dialog";
      "-","","","","";
      "Step &Into","debug_step_into","","help debug menu","Steps into the next statement";
      "Step &Over","debug_step_over","","help debug menu","Steps over the next statement";
      "Step Ou&t","debug_step_out","","help debug menu","Steps out of the current function";
      "Step Instruction","debug_step_instr","","help debug menu","Steps by one instruction";
      "-","","","","";
      "&Run to Cursor","debug-run-to-cursor","","help debug menu","Runs the program to the line containing the cursor";
      "Show &Next Statement","debug_show_next_statement","","help debug menu","Displays the source line for the instruction pointer";
      "Set Instruction Pointer","debug_set_instruction_pointer","","help debug menu","Set the instruction pointer to the current line";
      "Show Disassembly","debug_toggle_disassembly","","help debug menu","Toggle display of disassembly";
      "-","","","","";
      "Toggle Breakpoint","debug_toggle_breakpoint","","","";
      "Delete All Breakpoints","debug_clear_all_breakpoints","","help debug menu","Deletes all debugger breakpoints";
      "Disable All Breakpoints","debug_disable_all_breakpoints","","help debug menu","Disables all debugger breakpoints";
      "Add Watch","debug_add_watch","","help debug menu","Add a watch on the variable under the cursor";
      "Set Watchpoint","debug_add_watchpoint","","help debug menu","Set a watchpoint on the variable under the cursor";
      "-","","","","";
      "Debugger &Options...","debug_options","","help Debugging Options","Displays the Debugger Options dialog";
   }
   submenu "Do&cument","help document menu","Displays document menu","ncw" {
      "&Next Buffer","next-buffer","mto-buffer","help Document Menu","Switches to the next buffer";
      "Pre&vious Buffer","prev-buffer","mto-buffer","help Document Menu","Switches to the previous buffer";
      "Close Buffer","close-buffer","","help Document Menu","Closes the current buffer";
      "&List Open Files...","list-buffers","ncw","help Files tool window","List all buffers and allows you to activate one";
      "Edit Associated File","edit-associated-file","ncw","help Document Menu","Switch to header or source file associated with the current file";
      "Select Mo&de...","select-mode","","help Select Mode dialog box","List all modes and lets you select one";
      "Language &Options...","setupext","","help Language Options","Control the behavior of SlickEdit when working with this language";
      "-","","","","";
      "&Tabs...","gui-tabs","nrdonly","help Tabs dialog box","Sets tab stops";
      "&Margins...","gui-margins","nrdonly","help document menu","Sets word wrap margins";
      "-","","","","";
      "Format &Paragraph","reflow-paragraph","nicon|nrdonly","help document menu","Reflows the text in the current paragraph according to the margins";
      "Format &Selection","reflow-selection","sel|nicon|nrdonly","help document menu","Reflows the selected text according to the margins";
      "Format Columns","format-columns","ab-sel|nicon|nrdonly","help document menu","Format columns according to words";
      "-","","","","";
      "Edit &Documentation Comment","edit-doc-comment","","help Javadoc Editor dialog box","Edits documentation comments for the current source file";
      "Update Doc Comment","update_doc_comment","update_doc_comment","help update_doc_comment","Create or update the documentation comment for the current function or method";
      "Comment &Block","box","ab-sel|nrdonly","help Comments","Converts selected text into block comment using box comment setup characters";
      "Comment Lines","comment","ab-sel|nrdonly","help Comments","Converts selected lines into line comments using the line comment setup";
      "Uncomment Lines","comment_erase","ab-sel|nrdonly","help Comments","Uncomment selected lines using comment setup";
      "Re&flow Comment...","gui-reflow-comment","nrdonly","help Reflowing Comments","Reflows and reformats the current block comment";
      "Comment Setup...","comment-setup","","help Comment Options (Language-Specific)","Displays settings for box and line comments";
      "&Comment Wrap","comment-wrap-toggle","nrdonly","help Comment Wrap Options (Language-Specific)","Toggles comment wrap on/off";
      "-","","","","";
      "&Indent with Tabs","indent-with-tabs-toggle","nrdonly","help document menu","Toggles indenting with tabs on/off";
      "&Word Wrap While Typing","word-wrap-toggle","nrdonly","help document menu","Toggles word wrap while typing on/off";
      "&Justify...","gui-justify","nrdonly","help justification dialog box","Sets/displays word wrap justification style";
      "&Read Only Mode","read-only-mode-toggle","","help document menu","Toggles Read only mode on/off";
      "&Adaptive Formatting","adaptive-format-toggle","","","Toggles adaptive formatting on/off";
   }
   submenu "&Macro","help macro menu","Displays menu of macro programming commands","ncw" {
      "Loa&d Module...","gui-load\tload\tprompt-load","ncw","help load module dialog box","Loads a macro source module";
      "&Unload Module...","gui-unload\tunload","ncw","help macro menu","Unloads a macro module";
      "List User-Loaded Modules...","gui-list-macfiles","ncw","help macro menu","List user-loaded Slick-C® modules";
      "-","","","","";
      "&Record Macro","record-macro-toggle","nicon","help macro menu","Starts recording Slick-C® language macro based on the editor features you use";
      "E&xecute last-macro","record-macro-end-execute\tlast-macro","nicon","help macro menu","Runs last recorded macro";
      "&Save last-macro...","gui-save-macro\tsave-macro","","help save macro dialog box","Saves the last recorded macro under a name you specify";
      "&List Macros...","list-macros","ncw","help Bind Key dialog","Lists saved recorded macros";
      "-","","","","";
      "Set Macro &Variable...","gui-set-var\tset-var","ncw","help set variable dialog box","Sets global macro variable";
      "Start Slick-C® Debugger...","slickc-debug-start","ncw","help Debug","Activates the Slick-C® debugger window";
      submenu "Slick-C Profiler","help macro menu","Displays menu of Slick-C profiling options","ncw" {
         "&Begin Profiling","profile","ncw","help macro menu","Starts the Slick-C profiler";
         "&Finish Profiling...","profile view","ncw","help macro menu","Stop the Slick-C profiler and view results in profiler dialog";
         "Profile &Keystroke...","profile key","ncw","help macro menu","Profile a single keystroke and view results in profiler dialog";
         "&Save...","profile save","ncw","help macro menu","Save last profiling results to a text file";
         "&Load...","profile load","ncw","help macro menu","Load profiling results from a text file and view them in profiler dialog";
      }
      "-","","","","";
      "&Go to Slick-C® Definition...","gui-find-proc\tfind-proc","ncw","help Macro Menu","Opens a macro source file and places your cursor on the definition of a macro symbol";
      "Find Slick-C &Error","find-error","ncw","help Macro Menu","Places your cursor on the macro source line which caused the last interpreter run-time error";
      "-","","","","";
      "&New Form...","new-form","ncw","help macro menu","Opens a new form for editing with dialog editor";
      "&Open Form...","open-form\topen-form","ncw","help macro menu","Opens an existing or new form for editing with dialog editor";
      "Sele&cted Form...","show-selected","ncw","help window menu","Displays edited form window currently selected";
      "Load and Run &Form\tShift+Space","run-selected","ncw","help macro menu","Loads form, loads Slick-C® code, and runs the currently selected/edited form.";
      "Grid...","gui-grid\tgrid","ncw","help macro menu","Sets form grid settings";
      "&Menus...","open-menu","ncw","help Open Menu dialog box","Opens an existing or new menu for editing";
      "&Insert Form or Menu Source...","insert-object","nrdonly","help macro menu","Insert source code into current file for a form you specify";
   }
   submenu "&Tools","help Tools menu","Displays Tools menu containing miscellaneous editor commands","ncw" {
      "&Options...","config","","","";
      "&Quick Start Configuration...","quick-start","","","";
      "-","","","","";
      "Regex Evaluator...","activate-regex-evaluator","","help Regex Evaluator","Shows the Regex Evaluator tool window";
      "OS She&ll","launch-os-shell","","help Tools menu","Runs operating system command shell";
      "OS &File Browser...","explore","","help Tools menu","Runs operating system file system browser";
      "Calculator","calculator","ncw","help calculator dialog box","Evaluates mathematical expressions you specify";
      "&Add Selected Expr","add","sel|nicon|nrdonly","help Tools menu","Adds the result of evaluating each line in a selected area of text";
      "ASCII &Table","ascii-table","ncw","help Tools menu","Opens ASCII table file";
      "Generate GUID...","gui-insert-guid","","help Tools menu","Shows the GUID generator dialog";
      "-","","","","";
      submenu "&Version Control","help Version Control Menu","Displays version control menu","version-control" {
         "Check &In...","vccheckin","update","help Version Control Menu","Checks in current file";
         "&Get...","vcget","get","help Version Control Menu","Checks out current file read only";
         "Check &Out...","vccheckout","checkout","help Version Control Menu","Checks out current file";
         "Lock","vclock","lock","help Version Control Menu","Locks the current file without checking out the file";
         "U&nlock...","vcunlock","uncheckout","help Version Control Menu","Unlocks the current file without checking in the file";
         "-","","","","";
         "&Add...","vcadd","add","help Version Control Menu","Adds current file to version control";
         "&Remove...","vcremove","remove","help Version Control Menu","Removes current file from version control";
         "-","","","","";
         "&History...","vchistory","history","help Version Control Menu","Views history for current file";
         "&Difference...","vcdiff","diff","help Version Control Menu","Views differences of current file";
         "&Properties...","vcproperties","properties","help Version Control Menu","Views properties of current file";
         "&Manager...","vcmanager","manager","help Version Control Menu","Executes Version Control Manager";
         "-","","","","";
         "&Setup...","vcsetup","","help Version Control Setup dialog box","Allows you to choose and configure a Version Control System interface";
      }
      "-","","","","";
      submenu "C++ &Refactoring","","Displays C++ refactoring menu","cpp_refactoring" {
         "-","","bar","","";
         "Test Parsing Configuration...","refactor_parse","parse","","View and test C++ Refactoring settings for the current file";
         "C/C++ C&ompiler Options...","refactor_options","options","","Allows you to configure C++ Refactoring options";
      }
      submenu "&Quick Refactoring","help Quick Refactoring","Displays Quick refactoring menu","quick_refactoring" {
         "&Rename...","refactor_quick_rename","quick_rename","help Quick Refactoring Menu","Rename symbol";
         "Extract Method...","refactor_quick_extract_method","quick_extract_method","Help Quick Refactoring Menu","Extract the selected code block into a new function";
         "Modify Parameter List...","refactor_quick_modify_params","quick_modify_params","help Quick Refactoring Menu","Modify the parameter list of a method";
         "Replace Literal with Constant...","refactor_quick_replace_literal","quick_replace_literal","help Quick Refactoring Menu","Replace literal value with a declared constant";
      }
      submenu "Im&ports","help Imports","Displays Imports refactoring menu","imports" {
         "Organize Imports","jrefactor_organize_imports","organize_imports","help Java Organize Imports","Organize import statements in a java file";
         "Add Import","jrefactor_add_import","add_import","help Imports Menu","Add import statement for symbol under cursor";
         "-","","bar","","";
         "Options...","jrefactor_organize_imports_options","organize_imports_options","help Organize Imports Options","View options for Organize Imports operations";
      }
      "Generate debug","generate_debug","nicon|nrdonly","help generate debug","Generates debug code for symbol under the cursor";
      "-","","","","";
      "Sort...","gui-sort","nicon|nrdonly","help sort dialog box","Sorts current buffer or selected text";
      submenu "&Beautify","","","" {
         "Edit Current Profile...","beautifier-edit-current-profile","","","Edits the current beautifier profile.";
         "Options...","beautifier-options","","","Set default formatter options.";
      }
      "File &Merge...","merge","ncw","help 3 Way Merge dialog","Merges two sets of changes made to a file";
      "File &Difference...","diff","ncw","help Diff Setup dialog box","Shows and edits differences between files";
      submenu "&Spell Check","help spell check menu","Displays menu of spell checking commands","ncw" {
         "&Check from Cursor","spell-check","nrdonly|nicon","help spell check menu","Spell check starting from cursor";
         "C&heck Comments and Strings","spell-check-source","nicon|nrdonly","help spell check menu","Spell check comments and strings";
         "Check &Selection","spell-check-selection","nrdonly|ab-sel|nicon","help spell check menu","Spell check words in selection";
         "Check &Word at Cursor","spell-check-word","nrdonly|nicon","help spell check menu","Spell check word at cursor";
         "Check &Files...","spell-check-files","ncw","help spell check menu","Spell check multiple source files (HTML,...)";
         "-","","","","";
         "Spell &Options...","spell-options","ncw","help Spell Check Options","Display/modify spell checker options";
      }
      "-","","","","";
      "Tag F&iles...","gui-make-tags\tmake-tags","ncw","help Context Tagging::Tag Files dialog","Builds tag files for use by the symbol browser and other tagging features";
   }
   submenu "&Window","help window menu","Displays menu of window commands","ncw" {
      "&Tile","tile-windows","","help window menu","Tiles edit windows";
      "Tile Ho&rizontal","tile-windows h","","help window menu","Tiles edit windows horizontally";
      "Tile Vertical","tile-windows v","","help window menu","Tiles edit windows vertically";
      "&Untile","untile-windows","","help window menu","Creates one document tab group with all windows";
      "-","","","","";
      "&Next","next-window","mto-window","help window menu","Switches to next window";
      "&Previous","prev-window","mto-window","help window menu","Switches to previous window";
      "Close","close-window","","help window menu","Closes the current window";
      "&Font...","wfont","","help window font dialog box","Sets/views font for current window or all windows";
      "&Minimize","iconize-mdi","","help window menu","Iconize window";
      "-","","","","";
      "&Zoom Toggle","zoom-window","","help window menu","Zooms or unzooms the current window";
      "&One Window","one-window","","help window menu","Zooms the current window and deletes all other windows";
      "&Duplicate","duplicate-window","","help window menu","Creates another window linked to the current buffer";
      "&Link Window...","link-window","","help link window dialog box","Selects buffer to display in current window";
      "-","","","","";
      "New Horizontal Tab Group Above","new-horizontal-tab-group-above","","help window menu","Move the current document to a new horizontal tab group above the current tab group";
      "New Horizontal Tab Group Below","new-horizontal-tab-group-below","","help window menu","Move the current document to a new horizontal tab group below the current tab group";
      "New Vertical Tab Group on Right","new-vertical-tab-group-on-right","","help window menu","Move the current document to a new vertical tab group on the right of the current tab group";
      "New Vertical Tab Group on Left","new-vertical-tab-group-on-left","","help window menu","Move the current document to a new vertical tab group on the left of the current tab group";
      "Split &Horizontally","hsplit-window","nicon","help window menu","Splits the current window horizontally in half";
      "Split &Vertically","vsplit-window","nicon","help window menu","Splits the current window vertically in half";
      "Move to Tab Group Above","move-to-tab-group-above","","help window menu","Move document to document tab group above";
      "Move to Tab Group Below","move-to-tab-group-below","","help window menu","Move document to document tab group below";
      "Move to Tab Group on Left","move-to-tab-group-on-left","","help window menu","Move document to document tab group on left";
      "Move to Tab Group on Right","move-to-tab-group-on-right","","help window menu","Move document to document tab group on right";
      "-","","","","";
      "&Reset Window Layout","prompt-reset-window-layout","","","Restore the default window layout";
      "-","","","","";
   }
   submenu "&Help","help help menu","Displays menu of help commands","ncw" {
      "&Contents","help -contents","ncw","help help menu","Displays help on table of contents";
      "Index...","help -index","ncw","help help menu","Displays help index and allows you to search the index";
      "&Search...","help -search","ncw","help help menu","Displays help index and allows you to enter a help item";
      "New Features","help new features","ncw","help help menu","Displays SlickEdit new features";
      "Cool Features","cool_features","ncw","help help menu","Displays SlickEdit feature tips";
      "Quick Start","help Quick Start","ncw","help help menu","Displays SlickEdit Quick Start documentation";
      "-","","","","";
      "&Keys Help","help summary of keys","ncw","help help menu","Displays summary of key bindings for the current emulation";
      "&What Is Key...","what-is","ncw","help help menu","Displays help on command invoked by a key you specify";
      "&Where Is Command...","where-is","ncw","help help menu","Displays which key(s) the specified command is bound to";
      "&Macro Functions by Category","help macro_functions_by_category","ncw","help help menu","Allows you to choose help on macro functions by category";
      "Frequently Asked &Questions","goto_faq","ncw","help help menu","Answers to common user questions";
      "-","","","","";
      submenu "Licensing","help help menu","Displays license menu","ncw" {
         "License Manager...","lmw 1","","help help menu","Manage license";
         "Borrow License...","lm-borrow","","help help menu","Manage license";
         "Return License...","lm-return","","help help menu","Manage license";
      }
      submenu "Product &Updates","","Displays Update Manager menus","ncw" {
         "New Updates...","upcheck_display","","","Check for new updates";
         "Options...","upcheck_options","","","Set Update Manager options";
         "-","","","","";
         "Load Hot Fix...","load_hotfix","","","Load a hot fix for the current release";
         "List Installed Fixes...","list_hotfixes","","","List hot fixes already installed";
         "Apply Available Hot Fix...","hotfix_auto_apply","","","Apply available hot fixes";
      }
      "&Register Product...","online_registration","","help help menu","Displays SlickEdit Inc. on-line registration dialog";
      "SlickEdit Support Web Site","goto-slickedit","","help help menu","Displays SlickEdit Inc. home page in your Web browser";
      "Contact Product Support","do-webmail-support","","help help menu","Use web-based form to contact product support";
      "Check Maintenance","check-maintenance","","help help menu","Check the status of your maintenance and support agreement";
      "-","","","","";
      "&About SlickEdit","version","ncw","help help menu","Displays version and serial number information";
   }
}

defmain()
{
}
