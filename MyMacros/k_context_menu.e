////////////////////////////////////////////////////////////////////////////////////////////////
// © by HS2 - 2014
////////////////////////////////////////////////////////////////////////////////////////////////

#pragma option(strict,on)
#region Imports
#include "slick.sh"
#import  "mouse.e"
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
 * @param force_rbutton needed for tagwin/tagefs edit control (see below)
 */
_command void k_context_menu(boolean force_rbutton = false) name_info(','VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_ICON|VSARG2_NOEXIT_SCROLL|VSARG2_TEXT_BOX|VSARG2_CMDLINE)
{
   // Put the menu right on the current mouse pointer location:
   int x = MAXINT, y = MAXINT;

   if ( _isEditorCtl() )
   {
      x = p_cursor_x + p_font_width;
      y = p_cursor_y + p_font_height;
   }
   else if ( (p_object == OI_TREE_VIEW) || (p_object == OI_TEXT_BOX) || (p_object == OI_COMBO_BOX) )
   {
      x = p_client_width;
      y = (p_object == OI_TREE_VIEW) ? (_TreeCurLineNumber() - _TreeScroll()) * p_line_height : p_client_height;
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
#define K_CONTEXT_MENU_KEY  'A-S-A' // Alt-Shift-<A>

defeventtab default_keys;
def  K_CONTEXT_MENU_KEY  = k_context_menu;

// install add. event handlers
// @see projutil.e
defeventtab _toolbar_etab2;
void _toolbar_etab2.K_CONTEXT_MENU_KEY()
{
   k_context_menu();
}

// @see tbtagrefs.e
defeventtab _tbtagrefs_form;
void ctlrefedit.K_CONTEXT_MENU_KEY ()
{
   k_context_menu(true);
}
// @see tagwin.e
defeventtab _tbtagwin_form;
void edit1.K_CONTEXT_MENU_KEY ()
{
   k_context_menu(true);
}

