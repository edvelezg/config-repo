#include "slick.sh"

typeless _width;

//Some of this macro code was originally written with the help of a slickedit
//employee back in the days of visual slick edit for windows (i.e. versions 1-3
//or so). I don't recall who it was. This macro was written before slickedit
//reformatted comments as I typed them and I still use it when I re-indent code.

//The purpose of this macro is to reflow a comment at a new indentation level or
//to just reformat the comment per the document width of 80 using a tab indent
//setting of 4.

//To use this macro you select the comment using line mode making sure your
//cursor is at the new indentation location. Then execute the macro. The comment
//will be reformatted to the new width with the C/C++ "/*" " *" and "*/" to
//open/close the comment.

//Some improvements would be to obtain the document width and tab indent
//settings programatically. In addition, the comment style could be obtained and
//used (this is fixed for the old C style comment format).

_command reflow_c_comment() name_info(','EDITORCTL_ARG2|MARK_ARG2|MACRO_ARG2)
{
   if (!select_active()) {
      message('There needs to be an active selection');
      return (0);
   }

   if ( lowcase(_select_type('')) :!= 'line') {
      _select_type('','T','LINE');
   }

   lock_selection();
   _begin_select();
   _save_pos2(p);

   //Determine the column of the opening of the comment.  This will be
   //used to indent the new comment.
   replace('/\*','rjrj','PNIrm*');
   search('rjrj','PNIrm');
   new_left_ma=p_col;
   replace('rjrj','','PNIrm*');

   _end_select();
   insert_line("\27\27");

   //Need to replace / * and * / before we replace the * otherwise
   //replacing the * will get rid of the / * and * / and cause problems
   replace('/\*','','PNIrm*');     //Get rid of '/*' in the line
   replace('\*/','','PNIrm*');     //Get rid of '*/' in the line
   replace('\*','','PNIrm*');      //Get rid of '*' in the line
   old_p_margins=p_margins;
   parse old_p_margins with left_ma right_ma para;
//set the margins to reformat the comment with the text not going past column
//80 and leaving room for my tab indent of 4. We will reformat the text in
//columns 1..n and then will re-indent the text later.
   p_margins=1' '81-new_left_ma+1-4' 'para;
   reflow_selection();
   p_margins=old_p_margins;

   _deselect();
   _restore_pos2(p);
   select_line();
   search("\27\27",'PNr');
   _delete_line();
   line=p_line;
   _begin_select();
   filter_init();
   filter_get_string(text);

   //Create the spacesstring which will be used to indent the newly formatted
   //comment
   stringcounter = 1;
   spacesstring=''
   while (stringcounter < new_left_ma)
   {
   spacesstring = spacesstring' ';
   stringcounter++;
   }

   filter_put_string(spacesstring'/* 'text);
   while (p_line+1<line) {
      filter_get_string(text);
      filter_put_string(spacesstring' * 'text);
   }
   insert_line(spacesstring' */');
   filter_restore_pos();
   _deselect();
}


_command reflow_bash_comment() name_info(','EDITORCTL_ARG2|MARK_ARG2|MACRO_ARG2)
{
   if (!select_active()) {
      select_paragraph();
   }

   if ( lowcase(_select_type('')) :!= 'line') {
      _select_type('','T','LINE');
   }

   lock_selection();
   toggle_comment(false, false);
   reflow_selection();
   toggle_comment(false, true);
}


_command type_single_quote() name_info(','EDITORCTL_ARG2|MARK_ARG2|MACRO_ARG2)
{
   if (!select_active()) {
      keyin("'");
      return (0);
   }
   else {
      lock_selection();
      _begin_select();
      _insert_text("'");
      _end_select();
      cursor_right();
      _insert_text("'");
      deselect();
   }
}
