/*
 * HighlightParens.e
 *
 * This provides a command HighlightParens() which highlights pairs of
 * parentheses on or spanning the current line.  Use the command repeatedly to
 * extend the color coding to more easily see the scope of individual pairs of
 * parentheses.
 *
 * The duration the highlights remain visible is configurable below, as is the
 * maximum distance to scan for matching parentheses.
 *
 * The colors are defined in the s_rgParenRGB array.  Add or remove colors as
 * you like; the macro automatically adjusts itself based on how many colors
 * are listed in the array.
 */

#include "slick.sh"
#pragma option( strict, on )

/**
 * Duration in milliseconds before the matching parenthesis highlights are
 * cleared.
 */
#define PAREN_HIGHLIGHT_TIMER_DURATION       1250

/**
 * Maximum distance (in bytes) to scan for a matching parenthesis.<br>
 * Note:  The effective distance in characters is less in multibyte encodings
 * or Unicode.  Adjust it higher if needed.
 */
#define PAREN_HIGHLIGHT_MAX_DISTANCE         1500

static int s_nLevels = 0;
static int s_lineParenCheck = -1;
static int s_colParenCheck = -1;
static int s_timer = -1;
static int s_markerType = -1;
static int s_mismatchColor = -1;
static int s_rgParenColors[] = null;
static int s_rgParenRGB[] =
{
#if 0
   // Reverse rainbow.
   0xff6666,
   0xdddd33,
   0x66ff66,
   0x00ccff,
   0x3333ff,
   0xff66ff,
#else
   // Alternating constrast.
   0xff6666,
   0xdddd33,
   0xff66ff,
   0x66ff66,
   0x3333ff,
   0x00ccff,
#endif
};

definit()
{
   s_nLevels = 0;
   s_lineParenCheck = -1;
   s_colParenCheck = -1;
   s_timer = -1;
   s_markerType = _MarkerTypeAlloc();

   s_mismatchColor = _AllocColor();
   _default_color( s_mismatchColor, 0xffffff, 0x0000ff, F_BOLD );

   int ii;
   for ( ii = 0; ii < s_rgParenRGB._length(); ii++ )
   {
      s_rgParenColors[ii] = _AllocColor();
      _default_color( s_rgParenColors[ii], 0x000000, s_rgParenRGB[ii] );
   }
};

/**
 * Timer callback that clears the matching paren highlights and also resets
 * the line/col so the next <b>HighlightParens</b> call will not extend the
 * color coding for any levels.
 */
static void ParenTimerCallback()
{
   ClearParenHighlights();
   s_lineParenCheck = -1;
   s_colParenCheck = -1;
}

/**
 * Clears the matching paren highlights.
 */
static void ClearParenHighlights()
{
   if ( s_timer >= 0 )
      _kill_timer( s_timer );
   s_timer = -1;

   _StreamMarkerRemoveAllType( s_markerType );
   refresh();
}

/**
 * Starts the timer for clearing the matching paren highlights.
 */
static void SetParenHighlightTimer()
{
   if ( s_timer < 0 )
      s_timer = _set_timer( PAREN_HIGHLIGHT_TIMER_DURATION, ParenTimerCallback );
}

/**
 * Right justifies a long variable <i>x</i> into a string field of width
 * <i>width</i>.  Couldn't figure out how string formatting is done in
 * Slick-C, so I wrote this helper.
 *
 * @param x       Value to format as a right-justified string.
 * @param width   Width for the right-justified string.
 *
 * @return _str   Right justified string field, padded with spaces to the
 *                left.
 */
static _str RightJustify( long x, int width )
{
   _str s = field( x, width );
   return substr( s, length( strip( s, 'T' ) ) + 1 ) :+ strip( s, 'T' );
}

/**
 * Extends the range to include the current offset.
 *
 * @param beginRange    [in/out] The offset of the beginning of the range.
 * @param endRange      [in/out] The offset of the end of the range.
 *
 * @return int          Returns 1 if the range was extended, or 0 if not.
 */
static int ExtendRange( long& beginRange, long& endRange )
{
   long here = _QROffset();
   if ( _QROffset() < beginRange )
   {
      begin_line();
      beginRange = _QROffset();
   }
   else if ( _QROffset() >= endRange )
   {
      end_line();
      endRange = _QROffset() + 1;
   }
   else
      return 0;
   _GoToROffset( here );
   return 1;
}

/**
 * Selects a range of lines in which to match parentheses.  Iteratively
 * extends the range to include the matching parentheses for the parentheses
 * on the first/last lines of the range.
 */
static void SelectParenLines()
{
   typeless p;
   long beginRange = _QROffset();
   long endRange = _QROffset();
   long beginOld = beginRange + 1;
   long endOld = endRange - 1;

   // Loop to extend the range to include the outermost parentheses spanning
   // the current line, and the transitive closure of additional parentheses.

//int cPasses = 0;
   while ( true )
   {
      int ii;
      int cExtended = 0;

      for ( ii = 0; ii < 2; ii++ )
      {
         // Go to the beginning or end of the range.  But if the beginning or
         // end hasn't extended since last time then skip it.

         switch ( ii )
         {
         case 0:
            if ( beginRange >= beginOld )
               continue;
            _GoToROffset( beginRange );
            beginOld = beginRange;
            break;
         case 1:
            if ( endRange <= endOld )
               continue;
            _GoToROffset( endRange );
            endOld = endRange;
            break;
         }

         // Find closing matches for opening parens on the first line of the
         // range.

//cPasses++;
         _deselect();
         _select_line();
         _select_line();
         begin_line();
         loop
         {
            if ( 0 != search( '(', '@M,XCS' ) )
               break;

            save_pos( p );

            cExtended += ExtendRange( beginRange, endRange );
            if ( 0 == _find_matching_paren( PAREN_HIGHLIGHT_MAX_DISTANCE, true ) )
               cExtended += ExtendRange( beginRange, endRange );

            restore_pos( p );
            right();
         }

         // Find opening matches for closing parens on the last line of the
         // range.

         _deselect();
         _select_line();
         _select_line();
         end_line();
         loop
         {
            if ( 0 != search( ')', '@M-,XCS' ) )
               break;

            save_pos( p );

            cExtended += ExtendRange( beginRange, endRange );
            if ( 0 == _find_matching_paren( PAREN_HIGHLIGHT_MAX_DISTANCE, true ) )
               cExtended += ExtendRange( beginRange, endRange );

            restore_pos( p );
            if ( p_col <= 1 )
               break;
            left();
         }
      }

      if ( !cExtended )
         break;
   }
//say('cPasses='cPasses);

   _deselect();
   _GoToROffset( endRange );
   _select_char();
   _GoToROffset( beginRange );
   _select_char();
//messageNwait('range');
}

/**
 * Highlight parentheses on the current line and their matches.  Repeatedly
 * using this extends the color coding to more easily see the scope of
 * individual pairs of parentheses.
 */
_command void HighlightParens() name_info(','VSARG2_REQUIRES_MDI_EDITORCTL|VSARG2_READ_ONLY)
{
   ClearParenHighlights();

   // Preparation.

   typeless orig_p, m, ss, sf, sw, sr, sf2;
   save_pos( orig_p );
   save_selection( m );
   save_search( ss, sf, sw, sr, sf2 );

   // Repeated calls should extend the color coding, so detect when the cursor
   // has moved since the last call and reset.

   boolean fIterate = ( p_line == s_lineParenCheck && p_col == s_colParenCheck );
   if ( !fIterate )
   {
      s_nLevels = 0;
      s_lineParenCheck = p_line;
      s_colParenCheck = p_col;
   }

   // Select the lines to scan.  If there aren't any parentheses on the
   // current line, try looking for the next closing paren in the next few
   // lines.  If one exists and its match is before the current line, try
   // again to select lines to scan.

   SelectParenLines();
   if ( _isnull_selection() )
   {
      int old_line = p_line;
      _deselect();
      _select_line();
      down( 5 );
      _select_line();
      begin_select();
      begin_line();
      if ( 0 == search( ')', '@M,XCS' ) )
      {
         int close_line = p_line;
         if ( 0 == _find_matching_paren( PAREN_HIGHLIGHT_MAX_DISTANCE, true ) && p_line < old_line )
         {
            p_line = close_line;
            SelectParenLines();
         }
         else
         {
            _deselect();
         }
      }
      else
      {
         _deselect();
      }
      if ( _isnull_selection() )
      {
         restore_search( ss, sf, sw, sr, sf2 );
         restore_selection( m );
         restore_pos( orig_p );
         message( 'No parentheses.' );
         return;
      }
   }

   // Make a temp buffer to store the list of matches.

   int temp_view_id;
   int orig_view_id = _create_temp_view( temp_view_id );
   p_window_id = orig_view_id;

   // Build the list of matches.

   int iMax = 0;
   int iLevel = 0;
   boolean fAnyMismatch = false;
   while ( search( '[()]', '@MU,XCS' ) == 0 )
   {
      typeless p;
      save_pos( p );

      _str ch = get_text( -1 );
      if ( _find_matching_paren( PAREN_HIGHLIGHT_MAX_DISTANCE, true ) != 0 )
      {
         temp_view_id.insert_line( RightJustify( iLevel, 20 ) :+ RightJustify( _QROffset(), 20 ) );
         fAnyMismatch = true;
      }
      else
      {
         if ( ch == '(' )
         {
            iLevel++;
            temp_view_id.insert_line( RightJustify( iLevel, 20 ) :+ RightJustify( _QROffset(), 20 ) );
            restore_pos( p );
            temp_view_id.insert_line( RightJustify( iLevel, 20 ) :+ RightJustify( _QROffset(), 20 ) );
         }
         else if ( ch == ')' && iLevel > 0 )
         {
            iLevel--;
         }

         iMax = max( iMax, iLevel );
      }

      restore_pos( p );
      right();
   }

   // Render the matches.

   if ( temp_view_id.p_Noflines )
   {
      if ( fIterate )
      {
         if ( !s_nLevels )
            s_nLevels = iMax;
         else
            s_nLevels--;
      }

      temp_view_id.sort_buffer( 'A' );
      temp_view_id.top();

      _str line;
      int pos_marker;
      loop
      {
         temp_view_id.get_line( line );

         typeless level, offset;
         parse line with level offset .;

         if ( !level )
         {
            pos_marker = _StreamMarkerAdd( p_window_id, offset, 1, true, 0, s_markerType, '' );
            _StreamMarkerSetTextColor( pos_marker, s_mismatchColor );
         }
         else
         {
            int color = s_rgParenColors[( level - 1 ) % s_rgParenColors._length()];
            if ( s_nLevels && level > s_nLevels )
            {
               // This would overlap an extended highlights, so don't render.
            }
            else if ( s_nLevels && level >= s_nLevels )
            {
               temp_view_id.down();
               temp_view_id.get_line( line );
               typeless offset2;
               parse line with . offset2 .;

               pos_marker = _StreamMarkerAdd( p_window_id, offset, offset2 - offset + 1, true, 0, s_markerType, '' );
               _StreamMarkerSetTextColor( pos_marker, color );
            }
            else
            {
               pos_marker = _StreamMarkerAdd( p_window_id, offset, 1, true, 0, s_markerType, '' );
               _StreamMarkerSetTextColor( pos_marker, color );
            }
         }

         if ( temp_view_id.down() )
            break;
      }

      SetParenHighlightTimer();
   }

   // Clean up.

   _delete_temp_view( temp_view_id );

   restore_search( ss, sf, sw, sr, sf2 );
   restore_selection( m );
   restore_pos( orig_p );

   // Message about what happened.

   if ( fAnyMismatch )
      message( 'Mismatched parenthesis.' );
   else
      message( '' );
}


