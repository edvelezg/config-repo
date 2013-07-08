_str get_cliptext ()
{
   int temp_wid;
   orig_wid := _create_temp_view(temp_wid);
   paste ();
   top();

   // this assumes that the clipboard text comprises 1 line - adopt to your needs
   get_line (auto cliptext);
   p_window_id=orig_wid;
   _delete_temp_view(temp_wid);

   message ( "cliptext: " cliptext );
   return cliptext;
}
