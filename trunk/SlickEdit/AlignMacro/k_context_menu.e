////////////////////////////////////////////////////////////////////////////////////////////////
// © by HS2 - 2010
////////////////////////////////////////////////////////////////////////////////////////////////

#pragma option(pedantic,on)
#region Imports
#include "slick.sh"
#import  "mouse.e"
#endregion

////////////////////////////////////////////////////////////////////////////////
// Note: Only selected (most often used) p_object-s curr. supported.
/**
 * shows context menu @ text cursor position or curr, selected item 
 * key binding is hardwired for now - see below
 *  
 * @param force_rbutton needed for tagwin/tagrefs edit control (see below)
 */
_command void k_context_menu (boolean force_rbutton = false) name_info (','VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_ICON|VSARG2_NOEXIT_SCROLL)
{
   // Put the menu right on the current mouse pointer location:
   int x=0, y=0;

   // message( "p_object = " p_object);

   if ( p_object == OI_TREE_VIEW )
   {
      int h = 0, w = 0;
      int i = _TreeCurIndex();

      if ( i >= 0 ) _TreeGetCurCoord(i, x, y, w, h);
      {
         // Just to be safe. Round twips to nearest pixel.
         _lxy2dxy(SM_TWIP,x,y);
         x = p_client_width;
         _map_xy (p_window_id,0,x,y);
      }
   }
   else if ( (p_object == OI_FORM) || (p_object == OI_EDITOR) )
   {
       // message( "p_object = OI_FORM/EDITOR" );

      _map_xy (p_window_id,0,x,y);
      x+=p_cursor_x + p_font_width;
      y+=p_cursor_y + p_font_height;
   }
   else if ( (p_object == OI_TEXT_BOX) || (p_object == OI_COMBO_BOX) )
   {
      // Just to be safe. Round twips to nearest pixel.
      _lxy2dxy(SM_TWIP,x,y);
      int fw = (p_object == OI_COMBO_BOX) ? p_cb_text_box.p_font_width  : p_font_width;
      int fh = (p_object == OI_COMBO_BOX) ? p_cb_text_box.p_font_height : p_font_height;
      x  += (p_sel_start + p_sel_length + 1) * fw;
      y  += fh;
      // x = p_client_width;
      _map_xy (p_window_id,0,x,y);
   }
   else return;

   // we need to capture and flush MOUSE_MOVEs ...
   mou_mode(1);
   mou_capture();
   mou_set_xy ( x, y );
   while ( test_event ('R') != '' ) get_event ( 'R' );
   mou_release();

   if ( force_rbutton || (p_object == OI_TREE_VIEW) )
   {
      call_event(p_window_id,RBUTTON_UP);
   }
   else
   {
      // ... and we need to force MM_TRACK_MOUSE instead of MM_MARK_FIRST - otherwise a mark created and extended
      typeless sav_mouse_menu_style=def_mouse_menu_style;
      def_mouse_menu_style = 1; // MM_TRACK_MOUSE see mouse.e
      mou_click_menu_block ();
      def_mouse_menu_style = sav_mouse_menu_style;
   }
}

// key binding defintion
#define K_CONTEXT_MENU_KEY  'A-S-A' // Alt-Shift-<+>

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

