#include "slick.sh"

defeventtab _tbbookmarks_form;
void ctl_bookmarks_tree."n","N"()
{
   if (!_no_child_windows()) {
      _mdi.p_child.set_bookmark('-n');
   }
}

defeventtab _tbannotations_browser_form
void _annotation_tree."n","N"()
{
   if (!_no_child_windows()) {
      _mdi.p_child.new_annotation(_mdi.p_child.p_buf_name);
   }
}
