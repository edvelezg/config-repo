Replace the C:\Program Files\SlickEditV19.0.1 x64\macros\mouse.e with the 
one in this directory. Even best just do a diff against mouse.e and look 
for:

// HS2-ADD: x,y opt. args, k_context_menu needs this patch in mouse.e
// HS2-CHG: override stock macro mouse.e::context_menu() with this enhanced, but compatible version: x,y opt. args
_command void context_menu(int x = MAXINT, int y = MAXINT) name_info(','VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_ICON|VSARG2_NOEXIT_SCROLL)
{
   if (x == MAXINT) x = p_client_width intdiv 2;
   if (y == MAXINT) y = p_client_height intdiv 2;
   _mou_mode_menu(x,y);

}

_str lang=''; // HS2-ADD: robustness if not an editor control ie. p_LangId isn't available

