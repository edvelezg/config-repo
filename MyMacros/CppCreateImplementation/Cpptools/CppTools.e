/*****************************************************************************************
 * Project - (no project)         Filename - CppTools.e
 *
 *       Copyright © 2003  By Ash Associates Inc, All rights reserved
 *
 * This file contains the source a bunch of small C++ programming utilities
 *
 *****************************************************************************************
 * Gary Ash                           Phone:    (586) 731-1744
 * 12946 Beresford                    Fax:      (586) 731-7016
 * Sterling Heights MI 48313          E-mail:   gary_ash@wideopenwest.com
 *****************************************************************************************
 * $Revision$
 ****************************************************************************************/

/*****************************************************************************************
 * Include files
 ****************************************************************************************/

#include "slick.sh"
#include "tagsdb.sh"

/*****************************************************************************************
 * Constants
 ****************************************************************************************/

#define ESCAPE_KEY      0
#define SPACEBAR        1

/*****************************************************************************************
 * Function prototpyes
 ****************************************************************************************/

static _str     createFunctionName(_str variableName);
static int      generateFunctionProtypes(_str variableType, _str functionName);
static int      generateFunctions(_str variableType, _str variableName, _str className, _str functionName);
static int      waitForSpacebarOrEscape(_str promptText);
static boolean  findTopOfClass();
static boolean  findNextPrototype();
static boolean  foundPrototype();
static void     getProtypeData(_str& returns, _str& functionName, _str& argumentList);
static boolean  findToggleFile(_str baseFilename, _str mostLikely, _str (&otherExtensions)[]);
static boolean  switchToFileIfExists(_str baseFilename, _str extension);

/*****************************************************************************************
 * Global variables
 ****************************************************************************************/

static _str includeExtensions[] = { ".h", ".hh", ".hpp", ".hxx"};
static _str sourceExtensions[]  = { ".c", ".cc", ".cpp", ".cxx"};

/*****************************************************************************************
 * Package forms
 ****************************************************************************************/

_form ToggleImplementationForm {
	p_backcolor=0x80000005;
	p_border_style=BDS_DIALOG_BOX;
	p_caption='Toggle Include <--> Source file';
	p_clip_controls=FALSE;
	p_forecolor=0x80000008;
	p_height=4875;
	p_width=5355;
	p_x=10410;
	p_y=6000;
	_list_box namesListCtrl {
		p_auto_size=TRUE;
		p_backcolor=0x80000005;
		p_border_style=BDS_FIXED_SINGLE;
		p_font_bold=FALSE;
		p_font_italic=FALSE;
		p_font_name='MS Sans Serif';
		p_font_size=8;
		p_font_underline=FALSE;
		p_forecolor=0x80000008;
		p_height=4350;
		p_multi_select=MS_NONE;
		p_scroll_bars=SB_VERTICAL;
		p_tab_index=1;
		p_tab_stop=TRUE;
		p_width=3960;
		p_x=180;
		p_y=480;
		p_eventtab2=_ul2_listbox;
	}
	_label ctllabel1 {
		p_alignment=AL_LEFT;
		p_auto_size=FALSE;
		p_backcolor=0x80000005;
		p_border_style=BDS_NONE;
		p_caption='Couldn''t find a suitable match you want to create one?';
		p_font_bold=FALSE;
		p_font_italic=FALSE;
		p_font_name='MS Sans Serif';
		p_font_size=8;
		p_font_underline=FALSE;
		p_forecolor=0x80000008;
		p_height=300;
		p_tab_index=2;
		p_width=3840;
		p_word_wrap=FALSE;
		p_x=180;
		p_y=120;
	}
	_command_button create {
		p_cancel=FALSE;
		p_caption='Create';
		p_default=TRUE;
		p_font_bold=FALSE;
		p_font_italic=FALSE;
		p_font_name='MS Sans Serif';
		p_font_size=8;
		p_font_underline=FALSE;
		p_height=360;
		p_tab_index=3;
		p_tab_stop=TRUE;
		p_width=900;
		p_x=4395;
		p_y=120;
	}
	_command_button ctlcommand2 {
		p_cancel=TRUE;
		p_caption='Cancel';
		p_default=FALSE;
		p_font_bold=FALSE;
		p_font_italic=FALSE;
		p_font_name='MS Sans Serif';
		p_font_size=8;
		p_font_underline=FALSE;
		p_height=360;
		p_tab_index=4;
		p_tab_stop=TRUE;
		p_width=900;
		p_x=4395;
		p_y=540;
	}
}


/*****************************************************************************************
 * CppGetterSetter
 *****************************************************************************************
 *
 * Description:
 *            This command utility will generate Getter and Setter functions for the class
 *            member variable the cursor is on when it is invoked
 *
 ****************************************************************************************/

_command void CppGetterSetter() name_info(','VSARG2_REQUIRES_MDI_EDITORCTL|VSARG2_REQUIRES_TAGGING)
	{
	int  tagDatabaseIndex;
	_str tagDataTypeName;
	_str variableDataType;
	_str variableName;
	_str className;
	_str functionName;

	if (p_lexer_name :== "cpp")
		{
		_UpdateContext(true);
		tagDatabaseIndex = tag_current_context();

		tag_get_detail2(VS_TAGDETAIL_context_type, tagDatabaseIndex, tagDataTypeName);
		if (tagDataTypeName :== "var")
			{
			tag_get_detail2(VS_TAGDETAIL_context_return, tagDatabaseIndex, variableDataType);
			tag_get_detail2(VS_TAGDETAIL_context_name,   tagDatabaseIndex, variableName);
			tag_get_detail2(VS_TAGDETAIL_context_class,  tagDatabaseIndex, className);

			functionName = createFunctionName(variableName);
			if (generateFunctionProtypes(variableDataType, functionName) == SPACEBAR)
				{
				generateFunctions(variableDataType, variableName, className, functionName);
				}
			}
		else
			{
			messageNwait("The cursor isn't on a member variable");
			}
		}
	else
		{
		messageNwait("This command only works with C++ files");
		}
	}

/*****************************************************************************************
 * CppCreateImplementation
 *****************************************************************************************
 *
 * Description:
 *            This command function will create a stub implementation for the class the
 *            cursor is within
 *
 ****************************************************************************************/

_command void CppCreateImplementation()  name_info(','VSARG2_REQUIRES_MDI_EDITORCTL|VSARG2_REQUIRES_TAGGING)
	{
	int      ret;
	_str     returns;
	_str     className;
	_str     argumentList;
	_str     functionName;
	_str     classDeclationBufferID;
	_str     classImplementationBufferID;
	typeless classDeclationPosition;
	typeless classImplementationPosition;

	if (p_lexer_name :== "cpp")
		{
		save_pos(classDeclationPosition);
		if (findTopOfClass() == true)
			{
			if (findNextPrototype() == true)
				{
				className = current_class(false);
				classDeclationBufferID = p_buf_name;
				ret = waitForSpacebarOrEscape("Move the cursor to the place you want the function stubs and press the Spacebar or Escape to abort.");
				if (ret == SPACEBAR)
					{
					save_pos(classImplementationPosition);
					classImplementationBufferID = p_buf_name;
					find_buffer(classDeclationBufferID);
					do
						{
						getProtypeData(returns, functionName, argumentList);
						find_buffer(classImplementationBufferID);
						createFunction(returns, className, functionName, argumentList);
						find_buffer(classDeclationBufferID);
						} while (findNextPrototype() == true);

					restore_pos(classDeclationPosition);
					find_buffer(classImplementationBufferID);
					restore_pos(classImplementationPosition);
					}
				else
					{
					restore_pos(classDeclationPosition);
					}
				}
			}
		else
			{
			messageNwait("Couldn't find a complete class declaration");
			}
		}
	else
		{
		messageNwait("This command only works with C++ files");
		}
	}

/*****************************************************************************************
 * ToggleHeaderImplementation
 *****************************************************************************************
 *
 * Description:
 *            This command will toggle Visual SlickEdit's current buffer back and forth
 *            between and include file and an implementation file
 *
 ****************************************************************************************/

_command void ToggleHeaderImplementation()  name_info(','VSARG2_REQUIRES_MDI_EDITORCTL|VSARG2_REQUIRES_TAGGING)
	{
	int  index;
	boolean found;
	_str baseFilename;
	_str baseExtension;
	_str newExtension;
	_str filenameToToggleTo;

	if (p_lexer_name :== "cpp")
		{
		found = false;
		baseFilename  = strip_filename(p_buf_name, "E");
		baseExtension = get_extension(p_buf_name, true);
		if (pos("c", baseExtension) > 0)
			{
			newExtension = stranslate(baseExtension, "h", "c");
			findToggleFile(baseFilename, newExtension, includeExtensions);
			}
		else
			{
			newExtension = stranslate(baseExtension, "c", "h");
			findToggleFile(baseFilename, newExtension, sourceExtensions);
			}
		}
	else
		{
		messageNwait("This command only works with C and C++ files");
		}
	}


/*****************************************************************************************
 * createFunctionName
 *****************************************************************************************
 *
 * Description:
 *            This function will attempt to create the base of a function name from given
 *            variable name. It attempts to strain out characters that are commonly added
 *            to a variable name to mark it as a class data member.
 *
 *            _memberVariable  - memberVariable
 *            memberVariable_  - memberVariable
 *            m_memberVariable - memberVariable
 *            mMemberVariable  - MemberVariable
 *
 * Parameters:
 *            variableName - variable name to work on
 *
 * Returns:
 *            _str - base name of the function
 *
 ****************************************************************************************/

static _str createFunctionName(_str variableName)
	{
	_str ch;
	int  position;
	_str functionName;

	functionName = strip(variableName, "B", "_");
	position = pos("m_|sm_", functionName, 1, "U");
	if (position > 0)
		{
		position     = pos("_", functionName);
		functionName = substr(functionName, position + 1);
		}
	else
		{
		position     = pos("m[A-Z0-9]", functionName, 1, "U");
		functionName = substr(functionName, position + 1);
		}

	/* the variable that is to wrapped by the Getter and Setter begins with a lowercase
	 * letter generate functions named like so get_isFileOpen
	 */
	ch = substr(functionName, 1, 1);
	if (ch >= "a" && ch <= "z")
		{
		functionName = "_" :+ functionName;
		}
	return functionName;
	}

/*****************************************************************************************
 * generateFunctionProtypes
 *****************************************************************************************
 *
 * Description:
 *            This function insert the prototypes for the Getter and Setter functions.
 *
 * Parameters:
 *            variableType - the variable type name (int, bool, char, etc)
 *            functionName - the base name of the function prototypes to created
 *
 * Returns:
 *            int - SPACEBAR   = the space bar was pressed
 *                  ESCAPE_KEY = the Escape key was procesed
 *
 ****************************************************************************************/

static int generateFunctionProtypes(_str variableType, _str functionName)
	{
	int ret;
	int column;

	ret = waitForSpacebarOrEscape("Move the cursor to the place you want the prototypes and press the Spacebar or Escape to abort.");
	if (ret == SPACEBAR)
		{
		/* the Getter function */
		column = p_col;
		_insert_text(variableType" get"functionName"();");
		c_enter();

		/* the Setter function */
		p_col = column;
		_insert_text("void set"functionName"("variableType" new"functionName");");
		c_enter();
		}
	return ret;
	}

/*****************************************************************************************
 * generateFunctions
 *****************************************************************************************
 *
 * Description:
 *            This function inserts stubs for the Getter and Setter functions
 *
 * Parameters:
 *            variableType - the variable type name (int, bool, char, etc)
 *            variableName - the name of the variable (with member indicators stripped)
 *            className    - the name of the class the member variable belongs to
 *            functionName - the base name of the function prototypes to created
 *
 * Returns:
 *            int - SPACEBAR   = the space bar was pressed
 *                  ESCAPE_KEY = the Escape key was procesed
 *
 ****************************************************************************************/

static int generateFunctions(_str variableType, _str variableName, _str className, _str functionName)
	{
	int ret;
	int column;

	ret = waitForSpacebarOrEscape("Move the cursor to the place you want the function stubs and press the Spacebar or Escape to abort.");
	if (ret == SPACEBAR)
		{
		/* the Getter function */
		column = p_col;
		_insert_text(variableType" ");
		if (className :!= "")
			{
			_insert_text(className"::");
			}

		_insert_text("get"functionName"()");
		c_enter();
		_insert_text("\t{");
		c_enter();
		_insert_text("return "variableName";");
		c_enter();
		_insert_text("}");
		c_enter();
		c_enter();

		/* the Setter function */
		p_col = column;
		_insert_text("void ");
		if (className :!= "")
			{
			_insert_text(className"::");
			}
		_insert_text("set"functionName"("variableType" new"functionName")");
		c_enter();
		_insert_text("\t{");
		c_enter();
		_insert_text(variableName" = new"functionName";");
		c_enter();
		_insert_text("}");
		c_enter();
		}
	return ret;
	}

/*****************************************************************************************
 * waitForSpacebarOrEscape
 *****************************************************************************************
 *
 * Description:
 *            This function will process editor event until the user press either the
 *            Spacebar or Escape key.
 *
 * Parameters:
 *            promptText - prompt text to be displayed
 *
 * Returns:
 *            int - SPACEBAR   = the space bar was pressed
 *                  ESCAPE_KEY = the Escape key was procesed
 *
 ****************************************************************************************/

static int waitForSpacebarOrEscape(_str promptText)
	{
	int     ret;
	_str    event;
	boolean cancelFlag = false;

	flush_keyboard();
	sticky_message(promptText);

	while (true)
		{
		event = test_event();
		if (event :== " ")
			{
			ret = SPACEBAR;
			break;
			}
		else if (event :== ESC)
			{
			ret = SPACEBAR;
			break;
			}
		process_events(cancelFlag);
		}
	clear_message();
	return ret;
	}

/*****************************************************************************************
 * findTopOfClass
 *****************************************************************************************
 *
 * Description:
 *            This function finds the top class declaration the cursor is within
 *
 * Returns:
 *            boolean - true  = success; the cursor is positioned at the top of the class
 *                      false = unable to find the top of a class declaration
 *
 ****************************************************************************************/

static boolean findTopOfClass()
	{
	boolean  ret = false;
	_str     theClassName;
	_str     currentClassName;

	theClassName = current_class(false);
	if (theClassName :!= "")
		{
		while (up() == 0)
			{
			currentClassName = current_class(false);
			if (currentClassName :!= theClassName)
				{
				down();
				break;
				}
			}
		ret = true;
		}
	return ret;
	}

/*****************************************************************************************
 * findNextPrototype
 *****************************************************************************************
 *
 * Description:
 *            This function will position the cursor on the next member function prototype
 *            in the class declaration (from the top)
 *
 * Returns:
 *            boolean - true  = member function prototype found
 *                      false = unable to find anymore member functions in this class
 *
 ****************************************************************************************/

static boolean findNextPrototype()
	{
	boolean  ret = false;
	_str     theClassName;
	_str     currentClassName;
	int      tagDatabaseIndex;
	_str     tagDataTypeName;

	theClassName = current_class(false);
	if (theClassName :!= "")
		{
		do
			{
			if (down() == BOTTOM_OF_FILE_RC)
				{
				break;
				}
			currentClassName = current_class(false);
			if (currentClassName :!= theClassName)
				{
				down();
				break;
				}
			_UpdateContext(true);
			tagDatabaseIndex = tag_current_context();
			tag_get_detail2(VS_TAGDETAIL_context_type, tagDatabaseIndex, tagDataTypeName);
			} while (tagDataTypeName :!= "proto");

		if (tagDataTypeName :== "proto")
			{
			ret = true;
			}
		}
	return ret;
	}

/*****************************************************************************************
 * getProtypeData
 *****************************************************************************************
 *
 * Description:
 *            This function will query the Slick Edit tagging database to get the
 *            information needed to build the function stub
 *
 * Parameters:
 *            returns      - reference to a string to hold the function's return type
 *            functionName - reference to a string to hold the function's name
 *            argumentList - reference to a string to hold the function's argument list
 *
 ****************************************************************************************/

static void getProtypeData(_str& returns, _str& functionName, _str& argumentList)
	{
	int  tagDatabaseIndex;
	_str tagDataTypeName;

	_UpdateContext(true);
	tagDatabaseIndex = tag_current_context();
	tag_get_detail2(VS_TAGDETAIL_context_return, tagDatabaseIndex, returns);
	tag_get_detail2(VS_TAGDETAIL_context_name, tagDatabaseIndex, functionName);
	tag_get_detail2(VS_TAGDETAIL_context_args, tagDatabaseIndex, argumentList);
	}

/*****************************************************************************************
 * createFunction
 *****************************************************************************************
 *
 * Description:
 *            This function will build a C++ class member function stub
 *
 * Parameters:
 *            returns      - string giving the function's return data type
 *            className    - string giving the current class name
 *            functionName - string gining the current function name
 *            argumentList - string giving the function's argument list
 *
 ****************************************************************************************/

static void createFunction(_str returns, _str className, _str functionName, _str argumentList)
	{
	_begin_line();
	if (returns :!= "")
		{
		_insert_text(returns" ");
		}

	_insert_text(className"::"functionName"("argumentList")");
	c_enter();
	_insert_text("\t{");
	c_enter();

	if (returns :!= "" && pos(returns, "void|VOID", 1, "U") == 0)
		{
		_insert_text("return ;");
		c_enter();
		}
	_insert_text("}");
	c_enter();
	c_enter();
	}

/*****************************************************************************************
 * findToggleFile
 *****************************************************************************************
 *
 * Description:
 *            This file will search for the file that is either the include or the source
 *            file. If the file is found it is made the current buffer. If the file
 *            doesn't exist the user is given a chance to create the file based on a list
 *            of common filenames
 *
 * Parameters:
 *            baseFilename    -  string containing the (path + name) of the file to create
 *            otherExtensions - reference to a array of strings containing extensions
 *
 * Returns:
 *            boolean - true  = file found
 *                      false = unable to find the file
 *
 ****************************************************************************************/

static boolean findToggleFile(_str baseFilename, _str mostLikely, _str (&otherExtensions)[])
	{
	_str nameOnly;
	_str selected;
	_str filename;

	boolean ret = switchToFileIfExists(baseFilename, mostLikely);
	if (ret == false)
		{
		for (index = 0;index < otherExtensions._length();index++)
			{
			ret = switchToFileIfExists(baseFilename, otherExtensions[index]);
			if (ret == true)
				{
				break;
				}
			}
		}

	if (ret == false)
		{
		nameOnly  = strip_filename(baseFilename, "DP");
		selected  = show("-modal ToggleImplementationForm", nameOnly, otherExtensions);
		if (selected :!= "")
			{
			filename = '"';
			strappend(filename, baseFilename);
			strappend(filename, selected);
			strappend(filename, '"');
			popup_message(filename);
			edit(filename);
			ret = true;
			}
		}
	return ret;
	}

/*****************************************************************************************
 * switchToFileIfExists
 *****************************************************************************************
 *
 * Description:
 *            This function will check to see if the file specified by the base (path +
 *            name) and possible extension exists. If it does it will load it into a
 *            Visual SlickEdit buffer
 *
 * Parameters:
 *            baseFilename - string containing the base name
 *            extension    - string containing the possible filename extension
 *
 * Returns:
 *            boolean - true  = the file does exist
 *                      false = the file doesn't exist
 *
 ****************************************************************************************/

static boolean switchToFileIfExists(_str baseFilename, _str extension)
	{
	boolean ret      = false;
	_str    filename = '"';
	strappend(filename, baseFilename);
	strappend(filename, extension);
	strappend(filename, '"');
	if (file_time(filename) :!= "")
		{
		ret = true;
		edit(filename);
		}
	return ret;
	}

defeventtab ToggleImplementationForm

/*****************************************************************************************
 * namesListCtrl.on_create
 *****************************************************************************************
 *
 * Description:
 *            This function to called to fill the list box with likely filnames the user
 *            may want to use
 *
 * Parameters:
 *            nameOnly        - string containing the base name of include/source combo
 *            otherExtensions - reference to an array of common file name extensions
 *
 ****************************************************************************************/

void namesListCtrl.on_create(_str nameOnly, _str (&otherExtensions)[])
	{
	int  index;
	_str listboxItem;
	for (index = 0;index < otherExtensions._length();index++)
		{
		listboxItem = nameOnly;
		strappend(listboxItem, otherExtensions[index]);
		namesListCtrl._lbadd_item(listboxItem);
		}
	namesListCtrl.p_line = 1;
	namesListCtrl.p_no_select_color = false;
	namesListCtrl._lbselect_line();
	}

/*****************************************************************************************
 * create.lbutton_up
 *****************************************************************************************
 *
 * Description:
 *            This function is called when the "Create" button is pressed
 *
 ****************************************************************************************/

void create.lbutton_up()
	{
	_str selected;
	selected = namesListCtrl._lbget_text();
	selected = get_extension(selected, true);
	p_active_form._delete_window(selected);
	}

