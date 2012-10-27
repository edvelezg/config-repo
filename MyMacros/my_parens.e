//This macro has been posted for other SlickEdit users to use and explore.
//Depending on the version of SlickEdit that you are running, this macro may or may not load.
//Please note that these macros are NOT supported by SlickEdit and is not responsible for user submitted macros.

#include "slick.sh"

// toggles parentheses around the current selection

_command toggle_parens() name_info(','VSARG2_REQUIRES_EDITORCTL | VSARG2_REQUIRES_AB_SELECTION)
{
	typeless P;
	int extra = 0;
	int keep_going = 1;

	if (!_isnull_selection() && ((_select_type('') == "BLOCK") || (_select_type('') == "CHAR")))
	{
		if (_select_type('') == "BLOCK" )
			extra = 1;

		_save_pos2(P);

		// okay, figure out if we need to remove or add

		int ccol = p_col;


		_begin_select();

		int scol = p_col;

		_end_select();

		int ecol = p_col;

		if (!extra)																
			left()

		int remove_it = 1;
		int got_one = 0;
		int count = 0;

		int i = (p_col - scol)+1;

		while(i-- && (!got_one || (count != 0)))
		{
			if (get_text(1) :== ")")
				count++;
			else
				if (get_text(1) :== "(")
					count--;

			if (count)
				got_one = 1;

			if(got_one && !count && (p_col > scol))
			{
				remove_it = 0
				break;
			}

			left();
		}


		if (!got_one || ((i > 0) && count))
			remove_it = 0;


		_begin_select();

		if (remove_it)
		{
			if (get_text(1) :== "(")
			{
				_end_select();
				if (!extra)
					left;
				if (get_text(1) :== ")")
				{
					_delete_char();
					_begin_select;
					_delete_char();
					_restore_pos2(P);
					_deselect();
					keep_going = 0;
				}
			}
		}

		if (keep_going )
		{
			remove_it = 0;
			_end_select();
			if (extra)
				right();
			_insert_text("\"");
			_begin_select();
			_insert_text("\"");
			_restore_pos2(P);
			right();
			_deselect();
		}

		if(scol != ccol)
		{
			p_col= scol;
			if (extra)
				_select_block("","CE");
			else
				_select_char("","CE");
	
			p_col = ecol;
			if (remove_it)
			{
				left();
				left();
			}
			else
			{
				right();
				right();
			}
	
		}
		else
		{

			p_col = ecol;
			if (remove_it)
			{
				left();
				left();
			}
			else
			{
				right();
				right();
			}

			if (extra)
				_select_block("","CE");
			else
				_select_char("","CE");

			p_col= scol;
	
		}

		if (extra)
			_select_block("","PC");

	}
}
