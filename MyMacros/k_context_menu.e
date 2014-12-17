////////////////////////////////////////////////////////////////////////////////////////////////
// © by HS2 - 2014
////////////////////////////////////////////////////////////////////////////////////////////////

#pragma option(strict,on)
#region Imports
#include "slick.sh"
#import  "mouse.e"
#import  "tbfilelist.e"
#endregion

////////////////////////////////////////////////////////////////////////////////
// Note: Only selected (most often used) p_object-s curr. supported.

#if 0 // HS2-NOT: k_context_menu needs this patch in mouse.e
// HS2-CHG: override stock macro mouse.e::context_menu() with this enhanced, but compatible version: x,y opt. args
_command void context_menu(int x = MAXINT, int y = MAXINT) name_info(','VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_ICON|VSARG2_NOEXIT_SCROLL)
{
   if (x == MAXINT) x = p_client_width intdiv 2;
   if (y == MAXINT) y = p_client_height intdiv 2;
   _mou_mode_menu(x,y);
}
#endif

/**
 * shows context menu @ text cursor position or curr. selected item
 * key binding is hardwired for now - see below
 *
 * @param force_rbutton needed for tagwin/tagrefs edit control (see below)
 */
_command void k_context_menu(boolean force_rbutton = false) name_info(','VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_ICON|VSARG2_NOEXIT_SCROLL|VSARG2_TEXT_BOX|VSARG2_CMDLINE)
{
   // put the menu right on the current cursor or mouse pointer location
   int x = MAXINT, y = MAXINT;

   if ( _isEditorCtl() )
   {
      x = p_cursor_x + p_font_width;
      y = p_cursor_y + p_font_height;
   }
   else if ( (p_object == OI_TREE_VIEW) || (p_object == OI_TEXT_BOX) || (p_object == OI_COMBO_BOX) )
   {
      x = p_client_width;
      y = p_client_height;

      if (p_object == OI_TREE_VIEW)
      {
         int t_;
         _TreeGetCurCoord(_TreeCurIndex(), t_, y, t_, t_); // HS2-NOT: _TreeGetCurCoord returns y = -1 for recent SE versions ???
         if (y >= 0) y /= _dy2ly(SM_TWIP, 1);
      }
   }
   else
   {
      return;
   }

   force_rbutton = force_rbutton || !_isEditorCtl();
   if ( force_rbutton )
   {
      _map_xy(p_window_id,0,x,y);
      // we need to capture and flush MOUSE_MOVEs ...
      mou_mode(1);
      mou_capture();
      mou_set_xy( x, y );
      while ( test_event('R') != '' ) get_event('R');
      mou_release();

      call_event(p_window_id, RBUTTON_UP);
   }
   else
   {
      while ( test_event('R') != '' ) get_event('R');
      context_menu(x,y);
   }
}

// key binding defintion
#define K_CONTEXT_MENU_KEY  'A-S-+' // Alt-Shift-<+>

defeventtab default_keys;
def  K_CONTEXT_MENU_KEY  = k_context_menu;


#if __VERSION__ < 19
#define _TW_ETAB2   _toolbar_etab2
static boolean force_rbutton = true;   // tweak for tagrefs/tagwin
#else
#define _TW_ETAB2   _toolwindow_etab2
static boolean force_rbutton = false;
#endif

// install add. event handlers

// used by various forms
defeventtab _TW_ETAB2;
void _TW_ETAB2.K_CONTEXT_MENU_KEY()
{
   k_context_menu();
}

// @see proctree.e
defeventtab _tbproctree_form;
void _tbproctree_form.K_CONTEXT_MENU_KEY()
{
   k_context_menu();
}

// @see tagrefs.e
defeventtab _tbtagrefs_form;
void ctlrefedit.K_CONTEXT_MENU_KEY ()
{
   k_context_menu(force_rbutton);
}
// @see tagwin.e
defeventtab _tbtagwin_form;
void edit1.K_CONTEXT_MENU_KEY ()
{
   k_context_menu(force_rbutton);
}

// @see tbfilelist.e
defeventtab _tbfilelist_form;

// wid helpers
static int getCurFormWid_FilesTB()
{
   formwid := _find_formobj("_tbfilelist_form");
   if (formwid && formwid.p_child && formwid.p_child.p_object == OI_FORM) formwid = formwid.p_child;
   return formwid;
}
static int getCurTreeWid_FilesTB( int formwid = 0 )
{
   _nocheck _control ctl_file_list;
   _nocheck _control ctl_project_list;
   _nocheck _control ctl_workspace_list;

   if (!formwid ) formwid = getCurFormWid_FilesTB();
   int  treewid = 0;
   if ( formwid )
   {
      #if __VERSION__ >= 18   // oldest version I kept installed
      if      ( gfilelist_show == FILELIST_SHOW_OPEN_FILES )      treewid = formwid.ctl_file_list;
      else if ( gfilelist_show == FILELIST_SHOW_PROJECT_FILES )   treewid = formwid.ctl_project_list;
      else if ( gfilelist_show == FILELIST_SHOW_WORKSPACE_FILES ) treewid = formwid.ctl_workspace_list;
      #else
      if       ( formwid.ctl_file_list.p_visible )       treewid = formwid.ctl_file_list;
      else if  ( formwid.ctl_project_list.p_visible )    treewid = formwid.ctl_project_list;
      else if  ( formwid.ctl_workspace_list.p_visible )  treewid = formwid.ctl_workspace_list;
      #endif
   }
   return treewid;
}

void _tbfilelist_form.K_CONTEXT_MENU_KEY()
{
   // even with filter control having focus forward event to file list
   formwid := getCurFormWid_FilesTB();
   treewid := getCurTreeWid_FilesTB( formwid );
   if ( treewid ) treewid.call_event(treewid,last_event (),'2');
}

#if __VERSION__ >= 18
// patch for tbfilelist.e: (cycle) switching tabs with (SHIFT)-CTRL-TAB
void _tbfilelist_form.'C-TAB','S-C-TAB'()
{
   key := event2name(last_event(null, true));
   inc := pos('S-', key, 1, 'I') ? -1 : +1;
   tix := ctl_sstab.p_ActiveTab + inc;
   if (tix > FILELIST_SHOW_WORKSPACE_FILES) tix = FILELIST_SHOW_OPEN_FILES;
   ctl_sstab.p_ActiveTab = tix;
   call_event(ctl_sstab,CHANGE_TABACTIVATED,'W');
}
#endif
