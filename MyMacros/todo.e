/**
 * todo.e 
 *  
 * This is a complete implementation of a ToDo toolbar for use 
 * in SlickEdit. This toolbar is implemented to compliment your 
 * development environment. All of the relevent commands are 
 * available in a right-click menu in the toolbar itself, as 
 * well as via the SlickEdit command line or a key binding. 
 *  
 * The functionality of this feature centers around SlickEdit's 
 * search feature. This means that the performance of searching 
 * for TODO: statements ought to match the performance of 
 * executing a "Find in Files" within your Workspace. The added 
 * benefit here is to have the statements listed in an orderly 
 * fashion. 
 *  
 * Author: Marty Lewis (marty.lewis@katserv.net) 
 * Message List Contributions: vivitron 
 *  
 * Version: 0.7
 *  
 * Changelog: 
 * 	0.7	Fix for error when executing ToDo_GenerateList
 *  
 *      0.6     Updated to support SlickEdit 16
 *  
 *      0.5	Merged vivitron's Message List fork
 *  
 * 	0.4	SlickEdit 14 compatibility 
 *  
 * 	0.3	Added alternate TDML search behavior 
 *  
 *      0.2	Visual Studio project support
 *      	Fixed reliance on Windows path separator
 *  
 *      0.1	Initial release
 *  
 * This module has been designed to work with SlickEdit 15.0.0.
 * There is always some risk that your configuration may 
 * conflict with with something in this module. I highly 
 * recommend that you backup your SlickEdit configuration 
 * directory prior to loading this module. 
 *  
 * This module is provided as-is without any warranty, explicit 
 * or implied. By using this module you, the user, assume all 
 * risk and liability that may come with using the module. 
 */

#pragma option(pedantic,on)
#region Imports
#include "slick.sh"
#import "files.e"
#import "makefile.e"
#import "projconv.e"
#import "stdcmds.e"
#import "stdprocs.e"
#import "toolbar.e"
#import "treeview.e"
#import "wkspace.e"
#import "se/messages/Message.e"
#import "se/messages/MessageCollection.e"
#endregion

/*
    TODO: Make a toolbar with a tree view that displays a project
          name, file name and line number.
    TODO: Clicking on an entry in the tree activates SlickEdit's
          preview window.
    TODO: Write a function that scans a file for TODO: statements
          and stores the file name and line number in an array
    TODO: Write a function that gets a list of files in a project
          and runs the scan_file function on each one. Mark any
          TODO: entries with the project name.
    TODO: Write a function that gets a list of projects in the work-
          space and runs the scan_project function for each one.
 
    Comments and TODO statements may come in many different flavors.
    Unfortunately, it would be difficult to make assumptions about
    a particular user's formatting needs. Perhaps this is an oppor-
    tunity to generate some kind of TODO: standardization. In fact,
    let's do that.

    To Do Markup Language
 
    Maybe this is a little ridiculous, but it seems likely that this
    feature will serve someone's purpose! All markups will be optional.
 
    TODO<importance><title>:
 
    <importance> values:
        !	- high
        ^	- above average
        <none>	- normal
 
    <title> values:
        Anything else that occurs before the colon.

    Alternate TDML:

    TODO<importance><title>:<comment>

    If title is not present, the parser will use the <comment> in its place.
*/

// Form name, obj name, how the editor identifies the toolbar
#define _TBTODO 		"_tbToDo"
// Menu name
#define _TBTODO_MENU 		"_tbToDoMenu"
// Form caption, title if needed elsewhere
#define _TBTODO_TITLE		"Todo"
// Icon in the bitmaps directory that shows in a tabbed group
#define _TBTODO_ICON		"tbannotations.bmp"
// Name of this source file
#define _TBTODO_FILE		"todo.e"

// Message list defines
#define _MLTODO_CREATOR_TYPE	"ToDo"
#define _MLTODO_MESSAGE_TYPE	"ToDo"
// Message list icon
#define _MLTODO_ICON		"_edannotation.bmp"

// Defines for SlickEdit 14 compatibility
#ifndef TREE_NODE_EXPANDED
#define TREE_NODE_EXPANDED 1
#define TREE_NODE_COLLAPSED 0
#define TREE_NODE_LEAF -1
#endif

enum SORTBY {
    SB_PROJECT = 0,
    SB_FILE,
    SB_IMPORTANCE,
    SB_TITLE
};

struct TODO_INFO {
    _str project;
    _str filename;
    int line;
    int column;

    _str importance;
    _str title;
};

/**
 * Structure containing settings for the TODO module.
 * <br>
 * This is in a structure format to make Toolbar state saving
 * and restoring a far easier process
 */
struct TODO_SETTINGS {
    // Indicates whether or not we should use the TODO Markup Language
    // Only set to false if you're concerned that TDML processing is causing
    // a detriment to performance
    boolean use_tdml;

    boolean use_alt_tdml;

    // Variable for saving the state of the TODO tree view.
    typeless node_state;

    // Complete list of gathered todo information
    TODO_INFO todo_list[];

    // Currently selected sort type
    int sort;

    // Indicates if we populate the message list as well
    boolean use_mlist;

    // Message list ToDo picture
    int pic_mlist_marker;
};

static TODO_SETTINGS settings;
const TODO_REGEX = '{#0TODO[~\:]@\:}{#1?*}$';
/* 
 * TDML_REGEX:
 *   {#0TODO}		- Match todo and tag it item 0
 *   :b*		- Maximal match of 0 or more spaces and tabs
 *   {#1[\!\^]:*0,1}	- Importance
 *       		  Find a "!", "^" or nothing and tag it as 1
 *   :b@		- Minimal match of 0 or more spaces and tabs
 *   {#2:a[~\:]@}*	- Title
 *       	          Find a chunk of text, starting with an alphanumeric,
 *       		  that may contain anything but a ":". Or find nothing.
 *       		  Tag it as 2
 *   \:			- Find the terminating ":"
 */
const TODO_TDML_REGEX = '{#0TODO}:b*{#1[\!\^]:*0,1}:b@{#2:a[~\:]@}*\:';
/*
 * TDML_ALT_REGEX: 
 *   :b* 		- Maximal match of 0 or more spaces and tabs
 *   {#3:a?@}*		- Comment
 *			  Find a chunk of text, starting with an alphanumeric,
 *			  that may contain anything. Or find nothing.
 *			  Tag it as 3
 *   $			- End of line character
 */
const TODO_TDML_ALT_REGEX = ':b*{#3:a?@}*$';

definit()
{
    init_toolbar();
    init_message_list();
}

defload()
{
    if (_tbIsVisible(_TBTODO))
    {
	tbHide(_TBTODO);
    }

    init_toolbar();
    _tbShow(_TBTODO, 200, 200, 3000, 6000);
    if (settings.pic_mlist_marker == 0)
    {
	settings.use_tdml = true;
	settings.use_alt_tdml = false;
	settings.sort = SB_PROJECT;
	settings.todo_list = null;
	settings.use_mlist = false;
    }
}

struct FILE_SORT {
    _str filename;
    _str friendly_name;

    TODO_INFO todo[];
};

struct PROJECT_SORT {
    _str project_name;
    _str friendly_name;

    FILE_SORT files:[];
};

/**
 * Attempt to open the file relevent to the tree item under the
 * cursor. If the item is a todo entry then open to the line and
 * column specified in the todo information.
 */
static void GoToToDo()
{
    int index = _TreeCurIndex();
    if (index <= 0)
    {
	return;
    }

    TODO_INFO info = _TreeGetUserInfo(index);

    if (info.filename == null || info.filename == "")
    {
	return;
    }

    // Open the file
    int sts = edit(maybe_quote_filename(info.filename), "+d +w ");

    if (sts < 0)
    {
	return;
    }

    // The user may have just double-clicked on a file
    // entry. Ignore line and column in this case
    if (info.project == null || info.project == "")
    {
	return;
    }

    p_line = info.line;
    p_col = info.column;
}

static void RenderTodo()
{
    mou_hour_glass(true);
    int tree = _tbGetWid(_TBTODO).p_child;
    if (tree > 0)
    {
	tree.RenderTree();
    }
    if (settings.use_mlist)
    {
	FillMessageList();
    }
    mou_hour_glass(false);
}

static void FillMessageList()
{
    // Remove existing markers
    se.messages.MessageCollection* mCollection = get_messageCollection();
    mCollection->removeMessages(_MLTODO_CREATOR_TYPE);

    foreach (auto todo in settings.todo_list)
    {
	se.messages.Message todo_message;
	todo_message.m_creator = _MLTODO_CREATOR_TYPE;
	todo_message.m_type = _MLTODO_MESSAGE_TYPE;
	todo_message.m_description = todo.title;
	todo_message.m_sourceFile = todo.filename;
	todo_message.m_lineNumber = todo.line;
	todo_message.m_colNumber = todo.column;
	todo_message.m_date = '';
	todo_message.m_markerPic = settings.pic_mlist_marker;
    
	mCollection->newMessage(todo_message);
    }
}

static void RenderTree()
{
    PROJECT_SORT projects:[];
    PROJECT_SORT psort;
    FILE_SORT fsort;
    TODO_INFO todo;

    int i;
    int last_slash;
    for (i = 0; i < settings.todo_list._length(); i++)
    {
	todo = settings.todo_list[i];
	psort = projects:[todo.project];
	if (psort == null)
	{
	    psort.project_name = todo.project;
	    last_slash = lastpos(FILESEP, psort.project_name);
	    if (last_slash)
	    {
		psort.friendly_name = substr(psort.project_name, last_slash + 1);
	    }
	}
	fsort = psort.files:[todo.filename];
	if (fsort == null)
	{
	    fsort.filename = todo.filename;
	    last_slash = lastpos(FILESEP, fsort.filename);
	    if (last_slash)
	    {
		fsort.friendly_name = substr(fsort.filename, last_slash + 1);
	    }
	}
	fsort.todo[fsort.todo._length()] = todo;
	psort.files:[todo.filename] = fsort;
	projects:[todo.project] = psort;
    }

    int root = TREE_ROOT_INDEX;
    int proj;
    int file;
    int pic;
    _str title;

    // Clear the tree
    _TreeDelete(root, "C");

    foreach (auto ps_project in projects)
    {
	if (settings.sort == SB_PROJECT)
	{
	    proj = _TreeAddItem(root, ps_project.friendly_name, TREE_ADD_AS_CHILD,
				_pic_project, _pic_project, TREE_NODE_EXPANDED);
	}
	else
	{
	    proj = root;
	}
	foreach (auto fs_file in ps_project.files)
	{
	    // Insert file entry in the tree
	    file = _TreeAddItem(proj, fs_file.friendly_name, TREE_ADD_AS_CHILD, 
				_pic_file, _pic_file, TREE_NODE_COLLAPSED);
	    // Create a fake TODO_INFO with just the filename
	    // This will open the file but not go to a line or column
	    TODO_INFO temp;
	    temp.filename = fs_file.filename;
	    // Set the fake info as the user info for this file
	    _TreeSetUserInfo(file, temp);
	    for (i = 0; i < fs_file.todo._length(); i++)
	    {
		title = "";
		if (fs_file.todo[i].importance == "!")
		{
		    pic = _pic_ut_package_failure;
		}
		else if (fs_file.todo[i].importance == "^")
		{
		    pic = _pic_ut_package_notrun;
		}
		else
		{
		    pic = _pic_ut_package;
		}

		if (fs_file.todo[i].title != "")
		{
		    title = fs_file.todo[i].title :+ ", ";
		}

		// Add the todo to the tree with a caption of:
        	//	[title, ]line #, col #
		int td = _TreeAddItem(file, title :+\
			     "line " :+ fs_file.todo[i].line :+ ", " :+\
			     "col " :+ fs_file.todo[i].column :+ "",
			     TREE_ADD_AS_CHILD, pic, pic, TREE_NODE_LEAF);
		// Set the user info for the todo
		_TreeSetUserInfo(td, fs_file.todo[i]);
	    }
	}
	if (settings.sort == SB_PROJECT)
	{
	    // Sort the project children (filenames)
	    _TreeSortCaption(proj);
	}
    }
    if (settings.sort == SB_FILE)
    {
	// Sort the files
	_TreeSortCaption(root);
    }
    mou_hour_glass(false);
}

_command void ToDo_SortByFile() name_info(',')
{
    int tree = _tbGetWid(_TBTODO).p_child;
    if (tree > 0)
    {
	settings.sort = SB_FILE;
	tree.RenderTree();
    }
}

_command void ToDo_SortByProject() name_info(',')
{
    int tree = _tbGetWid(_TBTODO).p_child;
    if (tree > 0)
    {
	settings.sort = SB_PROJECT;
	tree.RenderTree();
    }
}

_command void ToDo_GenerateList() name_info(',')
{
    mou_hour_glass(true);
    ParseTodoFromWorkspace();
    mou_hour_glass(false);
    RenderTodo();
}

/**
 * Command for toggling the ToDo Markup Language. When on, the
 * todo parser will try to parse importance and name information
 * while searching for TODO: statements.
 */
_command void ToDo_ToggleTDML() name_info(',')
{
    if (settings.use_tdml == true)
    {
	settings.use_tdml = false;
    }
    else
    {
	settings.use_tdml = true;
    }
}


_command void ToDo_ToggleAltTDML() name_info(',')
{
    if (settings.use_alt_tdml == true)
    {
	settings.use_alt_tdml = false;
    }
    else
    {
	settings.use_alt_tdml = true;
    }
}

_command void ToDo_ToggleMessageList() name_info(',')
{
    if (settings.use_mlist == true)
    {
	settings.use_mlist = false;
    }
    else
    {
	settings.use_mlist = true;
    }
}

/**
 * Command wrapper for viewing the ToDo that is currently
 * selected.
 */
_command void ToDo_ViewSource() name_info(',')
{
    GoToToDo();
}

/**
 * Run ParseTodoFromProject for each project in the workspace
 */
static void ParseTodoFromWorkspace()
{
    if (gWorkspaceHandle <= 0)
    {
	return;
    }
    
    _str projects[] = null;
    settings.todo_list = null;
    _GetWorkspaceFilesH(gWorkspaceHandle, projects);

    int i;
    for (i = 0; i < projects._length(); i++)
    {
	ParseTodoFromProject(_AbsoluteToWorkspace(projects[i]));
    }
}

/**
 * Get a list of files for the project. Run ParseTodoFromFile 
 * for each file found. 
 * 
 * 
 * @param project 
 */
static void ParseTodoFromProject(_str project)
{
    _str files[] = null;

#if __VERSION__ < 16
    if (GetProjectFilesArray(project, files) < 0)
    {
	return;
    }
#else 
    if (_getProjectFiles(_workspace_filename, project, files, 1))
    {
	return;
    }
#endif

    int i;

    for (i = 0; i < files._length(); i++)
    {
	if (file_exists(files[i]))
	{
	    ParseTodoFromFile(project, files[i]);
	}
    }

}

/**
 * Open the file into a temporary view. Run a search for the 
 * TODO regular expression against the file contents. If one is 
 * found, save off the information and search again; repeating 
 * as necessary. 
 * 
 * @param project 
 * @param file 
 */
static void ParseTodoFromFile(_str project, _str file)
{
    typeless file_wid;
    typeless orig_wid;
    boolean already_open;
    int status = _open_temp_view(file, file_wid, orig_wid, "+e", already_open, false, true);
    if (status)
    {
	message(get_message(status));
	return;
    }
    p_window_id = file_wid;

    _str regex = TODO_REGEX;
    _str tdml_regex;

    if (settings.use_tdml)
    {
	tdml_regex = TODO_TDML_REGEX;
	if (settings.use_alt_tdml)
	{
	    tdml_regex :+= TODO_TDML_ALT_REGEX;
	}
    }

    top();

    status = search(regex, "R@CC");
    while (!status)
    {
	TODO_INFO info;

	info.line = p_line;
	info.column = p_col;
	info.filename = file;
	info.project = project;
	info.importance = "";
	info.title = "";

	if (settings.use_tdml)
	{
	    _str match = get_text(match_length('0') + match_length('1'), match_length('S0'));
	    status = pos(tdml_regex, match, 1, "RI");
	    if (status > 0)
	    {
		info.importance = substr(match, pos('S1'), pos('1'));
		info.title = substr(match, pos('S2'), pos('2'));
		if (strip(info.title) == "" || info.title == null)
		{
		    info.title = substr(match, pos('S3'), pos('3'));
		}
	    }
	}

	settings.todo_list[settings.todo_list._length()] = info;

	status = repeat_search("R@CC");
    }

    p_window_id = orig_wid;
    _delete_temp_view(file_wid);
}

/**
 * Call this function to make sure that the ToDo toolbar has
 * been correctly added to the editor's toolbar list.
 */
static void init_toolbar()
{
    _TOOLBAR* todo = _tbFind(_TBTODO);
    if (todo == null)
    {
	_tbAddForm(_TBTODO, TBFLAG_ALWAYS_ON_TOP|TBFLAG_ALLOW_DOCKING|TBFLAG_SIZEBARS, true);
    }
}

static void init_message_list()
{
    settings.pic_mlist_marker = find_index(_MLTODO_ICON, PICTURE_TYPE);
}

/**
 * Editor callback (event) when a source module is unloaded. If 
 * we hook this callback and check for the toolbar's file name 
 * then its trivial to gracefully unload the toolbar. 
 * 
 * @param filename File name without path of the source module 
 *      	   that is being unloaded. Extension is .ex
 */
void _on_unload_module__tbToDo(_str filename)
{
    if (filename == _TBTODO_FILE :+ "x")
    {
	if (_tbIsVisible(_TBTODO))
	{
	    tbHide(_TBTODO);
	}

	int i;
	for (i = 0; i < def_toolbartab._length(); i++)
	{
	    if (def_toolbartab[i].FormName == _TBTODO)
	    {
		def_toolbartab[i] = null;
		break;
	    }
	}

	settings = null;
    }
}

void _tbSaveState__tbToDo(TODO_SETTINGS& state, boolean closing)
{
    todo_tree._TreeSaveNodes(settings.node_state);
    state = settings;
}

void _tbRestoreState__tbToDo(TODO_SETTINGS& state, boolean opening)
{
    if (state == null) return;
    settings = state;
    todo_tree._TreeRestoreNodes(settings.node_state);
}

defeventtab _tbToDo;

_tbToDo.on_resize() {
    int avail_width = _dx2lx(p_active_form.p_xyscale_mode,p_active_form.p_client_width);
    int avail_height = _dy2ly(p_active_form.p_xyscale_mode,p_active_form.p_client_height);

    todo_tree.p_width = avail_width;
    todo_tree.p_height = avail_height;
}

todo_tree.lbutton_double_click() {
    todo_tree.GoToToDo();
}

todo_tree.rbutton_up() {
    int index = find_index(_TBTODO_MENU, oi2type(OI_MENU));
    if (!index)
    {
	return 0;
    }
    int menu_handle = _menu_load(index,'P');
    int x, y;
    mou_get_xy(x, y);

    int flags = 0;
    if (settings.use_tdml == true)
    {
	flags = MF_CHECKED;
    }
    else
    {
	flags = MF_UNCHECKED;
    }
    _menu_set_state(menu_handle, "ToDo_ToggleTDML", flags, 'M');

    flags = 0;
    if (settings.use_tdml == false)
	flags |= MF_GRAYED;
    if (settings.use_alt_tdml == true)
	flags |= MF_CHECKED;
    else
	flags |= MF_UNCHECKED;
    _menu_set_state(menu_handle, "ToDo_ToggleAltTDML", flags, 'M');

    flags = 0;
    if (settings.use_mlist == true)
    {
       flags |= MF_CHECKED;
    }
    else
    {
       flags |= MF_UNCHECKED;
    }
    _menu_set_state(menu_handle, "ToDo_ToggleMessageList", flags, 'M');

    _menu_show(menu_handle, VPM_LEFTBUTTON | VPM_LEFTALIGN, x, y);
}

_menu _tbToDoMenu {
    "Goto TODO", "ToDo_ViewSource", "", "", "";
    "Generate TODO List", "ToDo_GenerateList", "", "", "";
    "-", "", "", "", "";
    submenu "TDML", "", "", "" {
	"Use TDML", "ToDo_ToggleTDML", "", "", "";
	"Use Alternate TDML", "ToDo_ToggleAltTDML", "", "", "";
    }
    "Populate Message List", "ToDo_ToggleMessageList", "", "", "";
    "-", "", "", "", "";
    submenu "Sort By", "", "", "" {
	"File", "ToDo_SortByFile", "", "", "";
	"Project", "ToDo_SortByProject", "", "", "";
    }
}

_form _tbToDo {
    p_backcolor=0x80000005;
    p_border_style=BDS_SIZABLE;
    p_caption=_TBTODO_TITLE;
    p_CaptionClick=true;
    p_clip_controls=true;
    p_forecolor=0x80000008;
    p_height=6400;
    p_picture=_TBTODO_ICON;
    p_tool_window=true;
    p_width=5910;
    p_x=0;
    p_y=0;
    p_eventtab2=_toolbar_etab2;
    _tree_view todo_tree {
	p_after_pic_indent_x=50;
	p_backcolor=0x80000005;
	p_border_style=BDS_FIXED_SINGLE;
	p_clip_controls=false;
	p_CheckListBox=false;
	p_CollapsePicture='_lbminus.bmp';
	p_ColorEntireLine=false;
	p_EditInPlace=false;
	p_delay=0;
	p_ExpandPicture='_lbplus.bmp';
	p_forecolor=0x80000008;
	p_Gridlines=TREE_GRID_NONE;
	p_height=4260;
	p_LeafPicture='';
	p_LevelIndent=50;
	p_LineStyle=TREE_SOLID_LINES;
	p_multi_select=MS_NONE;
	p_NeverColorCurrent=false;
	p_ShowRoot=false;
	p_AlwaysColorCurrent=false;
	p_SpaceY=50;
	p_scroll_bars=SB_BOTH;
	p_tab_index=1;
	p_tab_stop=true;
	p_width=2940;
	p_x=0;
	p_y=0;
	p_eventtab2=_ul2_tree;
    }
}
