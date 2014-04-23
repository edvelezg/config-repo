/**
 * Copyright 2012 - Jeff Andrews 
 *  
 * Use this macro at your own risk.  Modify it, do whatever. 
 * I am not liable for any problems that arise out of its use. 
 * Emptor Caveat. 
 */

#pragma option(pedantic,on)
#region Imports
#include "slick.sh"
#include "project.sh"
#include "xml.sh"
#include "listbox.sh"
#include "tagsdb.sh"
#import "applet.e"
#import "cformat.e"
#import "cjava.e"
#import "codehelp.e"
#import "compile.e"
#import "context.e"
#import "env.e"
#import "files.e"
#import "guicd.e"
#import "javaopts.e"
#import "listproc.e"
#import "main.e"
#import "picture.e"
#import "projconv.e"
#import "project.e"
#import "projmake.e"
#import "projutil.e"
#import "saveload.e"
#import "seek.e"
#import "stdcmds.e"
#import "stdprocs.e"
#import "treeview.e"
#import "wizard.e"
#import "wkspace.e"
#import "sstab.e"
#endregion

_control ctltree1;
_control ctlsetters;
_control ctlgetters;

int end_pos;

enum Scope
{
	PUBLIC=1,
	PROTECTED,
	PRIVATE,
	PACKAGE
};


class MemberVariable 
{
	private _str m_name;
	private _str m_type;
	private int m_scope;

	private boolean m_writeSetter;
	private boolean m_writeGetter;

	MemberVariable(_str name="", _str type="", int scope=PUBLIC)
	{
		m_name = name;
		m_type = type;
		m_scope = scope;
		m_writeSetter = false;
		m_writeGetter = false;
	}

	public _str getName()
	{
		return m_name;
	}

	public _str getType()
	{
		return m_type;
	}

	public int getScope()
	{
		return m_scope;
	}

	public _str getSetterName()
	{
		_str fName = "set";
		strappend(fName,upcase(substr(m_name, 1, 1)));
		strappend(fName, substr(m_name, 2));
		return fName;
	}


	public _str getGetterName()
	{
		_str fName = "get";
		strappend(fName, upcase(substr(m_name, 1, 1)));
		strappend(fName, substr(m_name, 2));
		return fName;
	}


	public boolean shouldWriteGetter()
	{
		return m_writeGetter;
	}

	public boolean shouldWriteSetter()
	{
		return m_writeSetter;
	}

	public void setWriteGetter(boolean value)
	{
		m_writeGetter = value;
	}

	public void setWriteSetter(boolean value)
	{
		m_writeSetter = value;
	}
};


MemberVariable variables[];

defeventtab accform;
void ctlgetters.lbutton_up()
{
	// check the value

	// go through the tree and set the
	// check boxes for the setters to match
	int index = ctltree1._TreeGetFirstChildIndex(0);

	while (index != -1)
	{
		int child = ctltree1._TreeGetNextSiblingIndex(ctltree1._TreeGetFirstChildIndex(index));
		ctltree1._TreeSetCheckState(child, ctlgetters.p_value ? TCB_CHECKED : TCB_UNCHECKED);
		accessorsTreeCheckToggle(child);
		// Send Notification for the tree to update

		index = ctltree1._TreeGetNextSiblingIndex(index);
	}

}



void ctlsetters.lbutton_up()
{
	// check the value

	// go through the tree and set the
	// check boxes for the setters to match
	int index = ctltree1._TreeGetFirstChildIndex(0);

	while (index != -1)
	{
		int child = ctltree1._TreeGetFirstChildIndex(index);
		ctltree1._TreeSetCheckState(child, ctlsetters.p_value ? TCB_CHECKED : TCB_UNCHECKED);
		accessorsTreeCheckToggle(child);
		index = ctltree1._TreeGetNextSiblingIndex(index);
	}
}

void accessorsTreeCheckToggle(int index)
{
	if (index < 1)
	{
		return;
	}

	// get the value of the node
	int state = ctltree1._TreeGetCheckState(index);

	// if this is a parent, then automatically change the
	// state of its children
	if (ctltree1._TreeDoesItemHaveChildren(index))
	{
		if (state == TCB_CHECKED || state == TCB_UNCHECKED)
		{
			int childIndex = ctltree1._TreeGetFirstChildIndex(index); 
			while (childIndex != -1)
			{
				ctltree1._TreeSetCheckState(childIndex, state);
				childIndex = ctltree1._TreeGetNextSiblingIndex(childIndex);
			}

			if (state == TCB_UNCHECKED)
			{
				ctlsetters.p_value = 0;
				ctlgetters.p_value = 0;
			}
		}
	}
	else
	{
		// if it is a node, then check the state of the parent,
		// and if it's children are all toggled, then set it 
		// to the right state
		int parentIndex = ctltree1._TreeGetParentIndex(index);
		int numChildren = ctltree1._TreeGetNumChildren(parentIndex);
		int enabled = 0;

		int childIndex = ctltree1._TreeGetFirstChildIndex(parentIndex); 
		while (childIndex != -1)
		{
			if (ctltree1._TreeGetCheckState(childIndex) == TCB_CHECKED)
				enabled++;

			childIndex = ctltree1._TreeGetNextSiblingIndex(childIndex);
		}

		if (enabled == 0)
		{
			state = TCB_UNCHECKED;
			ctlsetters.p_value = 0;
			ctlgetters.p_value = 0;
		}
		else if (enabled == numChildren)
		{
			state = TCB_CHECKED;
		}
		else
			state = TCB_PARTIALLYCHECKED;

		ctltree1._TreeSetCheckState(parentIndex, state);
	}
}


void ctltree1.on_change(int reason,int index)
{
	switch ( reason )
	{
		case CHANGE_CHECK_TOGGLED:
			accessorsTreeCheckToggle(index);
			break;
	}
}



void accform.on_create()
{

	MemberVariable mv;
	foreach (mv in variables)
	{
		int pindex = ctltree1._TreeAddItem(0, mv.getName(), TREE_ADD_AS_CHILD, 0, 0);
		ctltree1._TreeSetCheckState(pindex, TCB_CHECKED);
		int index = ctltree1._TreeAddItem(pindex, mv.getSetterName(), TREE_ADD_AS_CHILD, 0, 0);
		ctltree1._TreeSetCheckState(index, TCB_CHECKED);
		index = ctltree1._TreeAddItem(pindex, mv.getGetterName(), TREE_ADD_AS_CHILD, 0, 0);
		ctltree1._TreeSetCheckState(index, TCB_CHECKED);
	}

}


void ctlcancel.lbutton_up()
{
	p_active_form._delete_window("");
}




void writeSetter(MemberVariable variable)
{
	if(variable.shouldWriteSetter() == false)
	{
		return;
	}
	// insert a line
	_insert_text("\r\n\r\n");
	_insert_text("public void ");
	_insert_text(variable.getSetterName());
	_insert_text("(");
	_insert_text(variable.getType());
	_insert_text(" value)\r\n{\r\n\t");
	_insert_text(variable.getName());
	_insert_text(" = value;\r\n}\r\n");

	int currentLine = p_line;
	cursor_up(4);
	javadoc_comment();
	cursor_down((currentLine - p_line) + 4);
	begin_line();
}

void writeGetter(MemberVariable variable)
{
	if(variable.shouldWriteGetter() == false)
	{
		return;
	}
	// insert a line
	_insert_text("\r\n\r\n");
	_insert_text("public ");
	_insert_text(variable.getType());
	_insert_text(" ");
	_insert_text(variable.getGetterName());
	_insert_text("()\r\n{\r\n\treturn ");
	_insert_text(variable.getName());
	_insert_text(";\r\n}\r\n");

	int currentLine = p_line;
	cursor_up(4);
	javadoc_comment();
	cursor_down((currentLine - p_line) + 5);
	begin_line();
}


void setMemberVariables()
{
	int index = ctltree1._TreeGetFirstChildIndex(0);

	while (index != -1)
	{
		int cell = (index / 3);
		int child = ctltree1._TreeGetFirstChildIndex(index);

		variables[cell].setWriteSetter(ctltree1._TreeGetCheckState(child) == TCB_CHECKED);
		child = ctltree1._TreeGetNextSiblingIndex(child);
		variables[cell].setWriteGetter(ctltree1._TreeGetCheckState(child) == TCB_CHECKED);
//		_message_box(nls("ARRAY LENGTH: %s  CELL: %s  CHILD: %s", variables._length(), cell, child));
		index = ctltree1._TreeGetNextSiblingIndex(index);
	}
}


void writeAccessors()
{
	_nrseek(end_pos - 1);

	MemberVariable mv;
	foreach (mv in variables)
	{
		writeSetter(mv);
		writeGetter(mv);
	}

	beautify();
}


void ctlok.lbutton_up()
{
	setMemberVariables();
	p_active_form._delete_window("done");
}





_form accform {
	p_backcolor=0x80000005;
	p_border_style=BDS_DIALOG_BOX;
	p_caption='Create Accessors';
	p_forecolor=0x80000008;
	p_height=6000;
	p_width=6000;
	p_x=18564;
	p_y=5184;
	p_eventtab=accform;
	_command_button ctlcancel {
		p_auto_size=false;
		p_cancel=true;
		p_caption='Cancel';
		p_default=false;
		p_height=348;
		p_tab_index=1;
		p_tab_stop=true;
		p_width=1200;
		p_x=1320;
		p_y=5400;
	}
	_command_button ctlok {
		p_auto_size=false;
		p_cancel=false;
		p_caption='OK';
		p_default=true;
		p_height=348;
		p_tab_index=2;
		p_tab_stop=true;
		p_width=1200;
		p_x=3660;
		p_y=5400;
	}
	_tree_view ctltree1 {
		p_after_pic_indent_x=50;
		p_backcolor=0x80000005;
		p_border_style=BDS_FIXED_SINGLE;
		p_CheckListBox=true;
		p_ColorEntireLine=false;
		p_EditInPlace=false;
		p_delay=0;
		p_forecolor=0x80000008;
		p_Gridlines=TREE_GRID_BOTH;
		p_height=4500;
		p_LevelIndent=250;
		p_LineStyle=TREE_SOLID_LINES;
		p_multi_select=MS_NONE;
		p_NeverColorCurrent=false;
		p_ShowRoot=false;
		p_AlwaysColorCurrent=false;
		p_SpaceY=50;
		p_scroll_bars=SB_VERTICAL;
		p_UseFileInfoOverlays=FILE_OVERLAYS_NONE;
		p_tab_index=3;
		p_tab_stop=true;
		p_width=3840;
		p_x=300;
		p_y=600;
		p_eventtab2=_ul2_tree;
	}
	_check_box ctlsetters {
		p_alignment=AL_LEFT;
		p_auto_size=false;
		p_backcolor=0x80000005;
		p_caption='Select All Setters';
		p_forecolor=0x80000008;
		p_height=240;
		p_style=PSCH_AUTO2STATE;
		p_tab_index=4;
		p_tab_stop=true;
		p_value=1;
		p_width=1500;
		p_x=4260;
		p_y=600;
	}
	_check_box ctlgetters {
		p_alignment=AL_LEFT;
		p_auto_size=false;
		p_backcolor=0x80000005;
		p_caption='Select All Getters';
		p_forecolor=0x80000008;
		p_height=240;
		p_style=PSCH_AUTO2STATE;
		p_tab_index=5;
		p_tab_stop=true;
		p_value=1;
		p_width=1500;
		p_x=4260;
		p_y=960;
	}
}


int flagsToScope(int flags)
{
	if ((flags & (VS_TAGFLAG_private | VS_TAGFLAG_protected)) == 
		(VS_TAGFLAG_private | VS_TAGFLAG_protected))
	{
		return PACKAGE;
	}
	else if ((flags & VS_TAGFLAG_private) == VS_TAGFLAG_private)
	{
		return PRIVATE;
	}
	else if ((flags & VS_TAGFLAG_protected) == VS_TAGFLAG_protected)
	{
		return PROTECTED;
	}

	return PUBLIC;
}


void buildVariableList()
{
	// query all of the member variables for the class
	_UpdateContext(true);

	tag_lock_context(false);

	int nearest = tag_nearest_context(p_line, VS_TAGFILTER_STRUCT, false);
	int current = tag_current_context();

	// Declarations
	_str tag_name, type_name, file_name, class_name, arguments, return_type;
	int start_line_no, start_pos, scope_line_no, scope_pos, end_line_no,
	tag_flags;

	tag_get_context(nearest, tag_name, type_name, file_name, start_line_no, start_pos,
					scope_line_no, scope_pos, end_line_no, end_pos, class_name, tag_flags,
					arguments, return_type);

	if (type_name == "class")
	{
		_str entire_class_name = class_name;
		// need to determine if this is an inner class, if so append ":" not "/"
		int outerId;
		_str type_name2;

		tag_get_detail2(VS_TAGDETAIL_context_outer, nearest, outerId);
		tag_get_detail2(VS_TAGDETAIL_context_type, outerId, type_name2);
		strappend(entire_class_name, type_name2 == "class" ? ":" : "/");
		strappend(entire_class_name, tag_name);

		int numberTags = tag_get_num_of_context();
		int index = nearest + 1;
		int mvIndex = 0;

		for (index; index <= numberTags; index++)
		{
			int tmp_scope_pos, tmp_end_pos;

			tag_get_context(index, tag_name, type_name, file_name, start_line_no, start_pos,
							scope_line_no, tmp_scope_pos, end_line_no, tmp_end_pos, class_name, tag_flags,
							arguments, return_type);

			if (type_name == "var" && class_name == entire_class_name)
			{
				MemberVariable member(tag_name, return_type, flagsToScope(tag_flags));
				variables[mvIndex] = member;
				mvIndex++;
			}
		}
	}

	tag_unlock_context();
}


_command void create_accessors() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_TAGGING)
{
	if ( ! _istagging_supported() )
	{
		_message_box(nls("No tagging support function for extension '%s'",p_LangId));
		return;
	}

	variables = null;
	buildVariableList();
	if (show("-modal accform") == "done")
	{
		writeAccessors();
	}

	variables = null;
}

