// Misc (maybe helpful) macros - © by HS2 - 2006
// Major parts snipped from Slick sources - 'Use the source, Luke !'

// formatting: TAB=3 (SPACEs only)

#include 'slick.sh'

static _str c_hier[] =
{
   "Arity       Operator                                   Assoc  ",
   "--------------------------------------------------------------",
   "binary   ()  []  ->  .                                 l -> r ",
   "unary    !   ~   ++  --  -  (type)  *  &  sizeof       r -> l ",
   "binary   *   /   %                                     l -> r ",
   "binary   +   -                                         l -> r ",
   "binary   <<  >>                                        l -> r ",
   "binary   <   <=  >   >=                                l -> r ",
   "binary   ==  !=                                        l -> r ",
   "binary   &                                             l -> r ",
   "binary   ^                                             l -> r ",
   "binary   |                                             l -> r ",
   "binary   &&                                            l -> r ",
   "binary   ||                                            l -> r ",
   "ternary  ?:                                            r -> l ",
   "binary   = += -= *= /= %= >>= <<= &= ^= |=             r -> l ",
   "binary   ,                                             l -> r ",
   "==============================================================",
   "                                                From K&R, p 49",
};

static _str cpp_hier[] =
{
   "Operator   Description                Assoc    Example of Use",
   "----------------------------------------------------------------------------",
   "::         scope resolution           l -> r   class_name::member",
   "::         scope resolution                    namespace::member",
   "::         global                              ::name",
   "::         global                              ::qualified name",
   "----------------------------------------------------------------------------",
   ".          member selection           l -> r   object.member",
   "->         member selection                    pointer->member",
   "[]         subscripting                        pointer [expr]",
   "()         function call                       expr (expr_list)",
   "()         value construction                  type (expr_list)",
   "++         post increment                      lvalue ++",
   "--         post decrement                      lvalue --",
   "()         type identification                 typeid (type)",
   "()         run-time type identification        typeid (expr)",
   "*_cast<>() run-time type conversion (cast)     dynamic_cast     <type>(expr)",
   "<>()       compile-time cast                   static_cast      <type>(expr)",
   "<>()       unchecked cast                      reinterpret_cast <type>(expr)",
   "<>()       const-cast                          const_cast       <type>(expr)",
   "----------------------------------------------------------------------------",
   "sizeof     size of object             r -> l   sizeof object",
   "sizeof     size of type                        sizeof (type)",
   "++         pre increment                       ++ lvalue",
   "--         pre decrement                       -- lvalue",
   "~          complement                          ~ expr",
   "!          not                                 ! expr",
   "-          unary minus                         - expr",
   "+          unary plus                          + expr",
   "&          address of                          & lvalue",
   "*          dereference                         * expr",
   "new        create (allocate)                   new type",
   "new        create (allocate & initialize)      new type (expr_list)",
   "new()      create (placement)                  new (expr_list) type",
   "new()      create (placement & initialize)     new (expr_list) type (expr_list)",
   "delete     destroy (de-allocate)               delete pointer",
   "delete[]   destroy (de-allocate)               delete[] pointer",
   "()         cast (type conversion)              (type) expr",
   "----------------------------------------------------------------------------",
   ".*         member section             l -> r   object.*pointer-to-member",
   "->*        member section                      pointer->*pointer-to-member",
   "----------------------------------------------------------------------------",
   "*          multiply                   l -> r   expr * expr",
   "/          divide                              expr / expr",
   "%          modulo (remainder)                  expr % expr",
   "----------------------------------------------------------------------------",
   "+          add (plus)                 l -> r   expr + expr",
   "-          subtract (minus)                    expr - expr",
   "----------------------------------------------------------------------------",
   "<<         shift left                 l -> r   expr << expr",
   ">>         shift right                         expr >> expr",
   "----------------------------------------------------------------------------",
   "<          less than                  l -> r   expr > expr",
   "<=         less than or equal                  expr <= expr",
   ">          greater than                        expr > expr",
   ">=         greater than or equal               expr >= expr",
   "----------------------------------------------------------------------------",
   "==         equal                      l -> r   expr == expr",
   "!=         not equal                           expr != expr",
   "----------------------------------------------------------------------------",
   "&          bitwise AND                l -> r   expr & expr",
   "----------------------------------------------------------------------------",
   "^          bitwise exclusive OR       l -> r   expr ^ expr",
   "----------------------------------------------------------------------------",
   "|          bitwise inclusive OR       l -> r   expr | expr",
   "----------------------------------------------------------------------------",
   "&&         logical AND                l -> r   expr && expr",
   "----------------------------------------------------------------------------",
   "||         logical OR                 l -> r   expr || expr",
   "----------------------------------------------------------------------------",
   "? :        conditional expression     r -> l   expr ? expr : expr",
   "----------------------------------------------------------------------------",
   "=          simple assignment          r -> l   lvalue = expr",
   "*=         multiply and assign                 lvalue *= expr",
   "/=         divide and assign                   lvalue /= expr",
   "%=         modulo and assign                   lvalue %= expr",
   "+=         add and assign                      lvalue += expr",
   "-=         subtract and assign                 lvalue -= expr",
   "<<=        shift left and assign               lvalue <<= expr",
   ">>=        shift right and assign              lvalue >>= expr",
   "&=         AND and assign                      lvalue &= expr",
   "|=         inclusive OR and assign             lvalue |= expr",
   "^=         exclusive OR and assign             lvalue ^= expr",
   "----------------------------------------------------------------------------",
   "throw      throw exception            l -> r   throw expr",
   "----------------------------------------------------------------------------",
   ",          comma (sequencing)         l -> r   expr, expr",
   "============================================================================",
   "© Stroustrup: C++ Progamming Language, Special Edition - ISBN 0-201-70073-5",
};

static _str perl_hier [] =
{
   "Arity       Operator",
   "---------   -----------------------------------",
   "left        terms and list operators (leftward)",
   "left        ->",
   "nonassoc    ++ --",
   "right       **",
   "right       ! ~ \\ and unary + and -",
   "left        =~ !~",
   "left        * / % x",
   "left        + - .",
   "left        << >>",
   "nonassoc    named unary operators",
   "nonassoc    < > <= >= lt gt le ge",
   "nonassoc    == != <=> eq ne cmp",
   "left        &",
   "left        | ^",
   "left        &&",
   "left        ||",
   "nonassoc    ..  ...",
   "right       ?:",
   "right       = += -= *= etc.",
   "left        , =>",
   "nonassoc    list operators (rightward)",
   "right       not",
   "left        and",
   "left        or xor",
};

static void show_table (_str table[], _str title)
{
   if (table._isempty()) return;

   int temp_window_id;
   int orig_window_id=_create_temp_view (temp_window_id);
   if ( orig_window_id != '' )
   {
      // The buffer and view allocated by _create_temp_view are active
      int i;
      for ( i = 0; i < table._length (); i++ )
      {
         _lbadd_item (table [i]);
      }
      // The original view must be activated before showing the _sellist_form
      activate_window (orig_window_id);
      _str result = show ('_sellist_form -mdi -modal',
                          title,
                          SL_VIEWID,   // Indicate the next argument is a view_id
                          temp_window_id,
                          "OK",
                          "",          // Help item
                          '',          // Use default font
                          ""           // Call back function
                          );
      // just show selected line afterwards
      if ( result != '' ) message (result);
   }
}

// maybe add these macros to 'Tools' menu (along with 'ASCII Table')
// Macro -> Menus -> Open '_mdi_menu' -> ...
// or use cmdline or ...
_command void c_operators () name_info (','VSARG2_EDITORCTL)
{
   show_table (c_hier, "C Operator Hierarchy" );
}

_command void cpp_operators () name_info (','VSARG2_EDITORCTL)
{
   show_table (cpp_hier, "C++ Operator Hierarchy" );
}

_command void perl_operators () name_info (','VSARG2_EDITORCTL)
{
   show_table (perl_hier, "Perl Operator Hierarchy" );
}

////////////////////////////////////////////////////////////////////////////////
// get current marked string or current word if nothing selected ...
_command _str cur_word_sel () name_info (','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   _str  cur_sel_word = '', line = '';
   int   first_col, last_col, buf_id, junk;

   // snipped from quick_search ()
   /* if there is no mark searches for the word at the cursor.
      if there is a mark, searches for the selected text if it is on a single line.
      Otherwise, searches for the word at the cursor within the mark
   */
   if ( select_active2 () )
   {
      if ( !_begin_select_compare () && !_end_select_compare () )
      {
         /* get text out of selection */
         _get_selinfo (first_col, last_col, buf_id );

         // say ( "mark: first_col=" first_col " last_col=" last_col );
         // if (_select_type ('','I')) ++last_col;

         ++last_col;
         if ( _select_type ()=='LINE' )
         {
            get_line (line);
            cur_sel_word=line;
         }
         else
         {
            cur_sel_word=_expand_tabsc (first_col,last_col-first_col);
         }
         _deselect ();
      }
      else
      {
         _deselect ();
         cur_sel_word=cur_word (junk,'',1);
      }
   }
   else
   {
      cur_sel_word=cur_word (junk,'',1);
   }

   if ( cur_sel_word=='' )
   {
      _beep ();
      message (nls ('No word at cursor'));
   }

   // say ( "returning cur_sel_word='" cur_sel_word "'" );
   return( cur_sel_word );
}

////////////////////////////////////////////////////////////////////////////////
// misc find functions to be used w/o the dialog
// opt: c == current buffer, b == all buffers, p == project files, w == workspace files
_command int fw,find_word_sel (_str opt = 'c') name_info (','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   int status = 0;

   _str search_options = make_search_options ((_default_option ('s') |
                                               VSSEARCHFLAG_HIDDEN_TEXT |
                                               VSSEARCHFLAG_NOSAVE_TEXT |
                                               VSSEARCHFLAG_MARK |
                                               VSSEARCHFLAG_FINDHILIGHT |
                                               VSSEARCHFLAG_GO), 1);

   // HS2: NO reg.exp.s (append to override _default_option())
   search_options = search_options :+ 'N';

   _str cur_word = cur_word_sel ();

   clear_highlights ();

   // adopt these flags to your needs
   int mfff = MFFIND_THREADED | MFFIND_GLOBAL;
   int grep_id = 1;   // -> Search<1>

   if ( cur_word != '' )
   {
      switch ( opt )
      {
         case 'b':
            status=_mffind (cur_word , search_options, MFFIND_BUFFERS, "", mfff , false, false, '', '', true, grep_id);
            break;
         case 'p':
            status=_mffind (cur_word , search_options, MFFIND_PROJECT_FILES, "", mfff, true, false, '', '', true, grep_id);
            break;
         case 'w':
            status=_mffind (cur_word , search_options, MFFIND_WORKSPACE_FILES, "", mfff, false, true, '', '', true, grep_id);
            break;
         case 'c':
         default:
            status=_mffind (cur_word , search_options, MFFIND_BUFFER, "", mfff, false, false, '', '', true, grep_id);
      }

      // return focus to edit win
      cursor_data ();
   }
   return( status );
}

// (aliased) wrappers to be bound to keys
_command int fwb,find_word_sel_buffers () name_info (','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   return(find_word_sel ('b'));
}
_command int fwp,find_word_sel_project () name_info (','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   return(find_word_sel ('p'));
}
_command int fww,find_word_sel_wkspace () name_info (','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_MARK)
{
   return(find_word_sel ('w'));
}

////////////////////////////////////////////////////////////////////////////////
// bind these macros to some keyboard shortcuts and leave the mouse where it is...
// Note: Only selected (most often used) p_object-s curr. supported.
_command void k_context_menu () name_info (','VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_ICON|VSARG2_NOEXIT_SCROLL)
{
   // Put the menu right on the current cursor location:
   int x=0, y=0;

   // message ( "p_object = " p_object) ;

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
      _map_xy (p_window_id,0,x,y);
      x+=p_cursor_x + p_font_width;
      y+=p_cursor_y + p_font_height;
   }
   else if ( (p_object == OI_TEXT_BOX) || (p_object == OI_COMBO_BOX) )
   {
      // Just to be safe. Round twips to nearest pixel.
      _lxy2dxy(SM_TWIP,x,y);
      int fw = (p_object == OI_COMBO_BOX) ? p_cb_text_box.p_font_width     : p_font_width;
      int fh = (p_object == OI_COMBO_BOX) ? p_cb_text_box.p_font_height : p_font_height;
      x  += (p_sel_start + p_sel_length + 1) * fw;
      y  += fh;
      // x = p_client_width;
      _map_xy (p_window_id,0,x,y);
   }
   else return;

   // we need to capture and flush MOUSE_MOVEs ...
   mou_mode(1)
   mou_capture();
   mou_set_xy ( x, y );
   while ( test_event ('R') != '' ) get_event ( 'R' );
   mou_release()

   if ( p_object == OI_TREE_VIEW )
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

_command void k_config_menu ()
{
   if ( p_window_id==VSWID_HIDDEN ) p_window_id=_mdi;
   _macro_delete_line ();

   // Find the submenu with caption matching submenu_pos
   int menu_handle=find_index ("_mdi_menu",oi2type (OI_MENU));
   int tools_index=_menu_find_caption (menu_handle,"Tools");
   if ( tools_index )
   {
      int config_index=_menu_find_caption (tools_index,"Options");
      if ( config_index )
      {
         menu_handle=p_active_form._menu_load (config_index,'P');

         // Put the menu right on the current cursor location:
         int x=0, y=0;
         _map_xy (p_window_id,0,x,y);
         x+=p_cursor_x + p_font_width;
         y+=p_cursor_y + p_font_height;
         int flags=VPM_LEFTALIGN|VPM_LEFTBUTTON;

         if ( !(_default_option (VSOPTION_APIFLAGS) & VSAPIFLAG_CONFIGURABLE_VCPP_SETUP) )
         {
            int status=_menu_find (menu_handle, "show -modal -mdi _vchack_form", found_mh, found_mp,'M');
            if ( !status ) _menu_delete (found_mh,found_mp);
         }
#if __OS390__ || __TESTS390__
         s390addOptimization2 (menu_handle);
#endif
         if ( _DataSetSupport () ) s390addJobcard2 (menu_handle);

         _menu_show (menu_handle,flags,x,y);
         _menu_destroy (menu_handle);
      }
   }
}

_command void k_vc_menu () name_info (','VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_ICON|VSARG2_NOEXIT_SCROLL)
{
   if ( p_window_id==HIDDEN_WINDOW_ID ) p_window_id=_mdi;
   _macro_delete_line ();

   // Find the submenu with caption matching submenu_pos
   int menu_handle=find_index ("_ext_menu_default",oi2type (OI_MENU));
   int vc_index=_menu_find_caption (menu_handle,"Version Control");
   if ( vc_index )
   {
      menu_handle=p_active_form._menu_load (vc_index,'P');

      // Put the menu right on the current cursor location:
      int x=0, y=0;
      _map_xy (p_window_id,0,x,y);
      x+=p_cursor_x + p_font_width;
      y+=p_cursor_y + p_font_height;
      int flags=VPM_LEFTALIGN|VPM_LEFTBUTTON;

      _menu_show (menu_handle,flags,x,y);
      _menu_destroy (menu_handle);
   }
}

