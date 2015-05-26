#include "slick.sh"

/* Demo for StackOverflow question 14205293 */
_command my_renumber() name_info(','VSARG2_MARK|VSARG2_REQUIRES_EDITORCTL)
{
   int not_found = 0; /* boolean to terminate loop */
   int iLoop = 0;     /* Counter to renumber items */

   /* Use search initially; if that call doen't find an item, we're done. */
   _str text = hs2_cur_word_sel()
   if (search(text :+ ':i', 'R') != 0) {
      not_found = 1;
   }

   while (!not_found) {
      if (search_replace(text :+ iLoop, 'R') == STRING_NOT_FOUND_RC) {
         not_found = 1;
      }
      iLoop++;
   }
}

