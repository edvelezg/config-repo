/**
 * Description: C/XML string copy/paste with escape
 * Copyright:   Megatops Software.
 * Author:      Ding Zhaojie, zhaojie.ding@gmail.com
 *
 * ========================[  Revision History  ]=============================
 * Name             Date            Description
 * ---------------------------------------------------------------------------
 * Ding Zhaojie     2010-12-9       Initial version.
 */

/************************* [   INCLUDE FILES    ] ****************************/

#include "slick.sh"
#import "clipbd.e"

/************************* [ LOCAL DEFINITIONS  ] ****************************/

/************************* [    DECLARATIONS    ] ****************************/

/************************* [    PUBLIC DATA     ] ****************************/

/************************* [    PRIVATE DATA    ] ****************************/

/************************* [ PRIVATE  FUNCTIONS ] ****************************/

static _str
get_clipboard()
{
    _str cbtype = _getClipboardMarkType();
    if ((cbtype != "BLOCK") && (cbtype != "")) {
        boolean utf8 = p_UTF8;
        get_window_id(auto window_id);
        _create_temp_view(auto temp_wid);
        p_UTF8 = utf8;
        _str result = null;
        if (paste() == 0) {
            bottom();
            int delta = _line_length(true) - _line_length(false);
            top();
            result = get_text(p_buf_size - delta);
        }
        _delete_temp_view(temp_wid);
        p_window_id = window_id;
        return (result);
    }
    return (null);
}


static void
set_clipboard(_str text)
{
    _str orig_markid = _duplicate_selection('');
    _str temp_markid = _alloc_selection();
    if (temp_markid < 0) {
        return;
    }
    _show_selection(temp_markid);

    int temp_view_id;
    int orig_view_id = _create_temp_view(temp_view_id);
    _insert_text(text);

    _deselect();
    top(); _select_char();
    bottom(); _select_char();
    copy_to_clipboard();

    if (orig_markid >= 0) {
        _show_selection(orig_markid);
    }
    _free_selection(temp_markid);
    _delete_temp_view(temp_view_id);
    activate_window(orig_view_id);
}


static _str
c_escape(_str text, boolean do_esc)
{
    if (do_esc) {
        text = stranslate(text, "\\\\", "\\");
        text = stranslate(text, "\\\"", "\"");
#if 0
        text = stranslate(text, "\\r",  "\r");
        text = stranslate(text, "\\n",  "\n");
        text = stranslate(text, "\\t",  "\t");
#endif
    } else {
        text = stranslate(text, "\xFF", "\\\\");
        text = stranslate(text, "\"",   "\\\"");
        text = stranslate(text, "\t",   "\\t");
        text = stranslate(text, "\n",   "\\n");
        text = stranslate(text, "\r",   "\\r");
        text = stranslate(text, "\\",   "\xFF");
    }
    return (text);
}


static _str
xml_escape(_str text, boolean do_esc)
{
    if (do_esc) {
        text = stranslate(text, "&amp;", "&");
        text = stranslate(text, "&gt;",  ">");
        text = stranslate(text, "&lt;",  "<");
        text = stranslate(text, "&quot;", "\"");
#if 0
        text = stranslate(text, "&apos;", "'");
#endif
    } else {
        text = stranslate(text, ">",  "&gt;");
        text = stranslate(text, "<",  "&lt;");
        text = stranslate(text, "'",  "&apos;");
        text = stranslate(text, "\"", "&quot;");
        text = stranslate(text, "&",  "&amp;");
    }
    return (text);
}


static _str escape_string(_str text, boolean do_esc)
{
    switch (p_LangId) {
    case 'c':
    case 'js':
    case 'java':
    case 'ruby':
    case 'e':
    case 'as':
        return (c_escape(text, do_esc));
    case 'html':
    case 'xml':
        return (xml_escape(text, do_esc));
    default:
        return (c_escape(text, do_esc));
    }
}

/************************* [  PUBLIC FUNCTIONS  ] ****************************/

/**
 * Paste string with escape
 *
 * @author Ding Zhaojie (2010-12-9)
 */
_command void
string_paste() name_info(','VSARG2_MARK|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_CLIPBOARD)
{
    _str clipd = get_clipboard();
    if (clipd != null) {
        if (select_active()) {
            _begin_select();
            _delete_selection();
        }
        _insert_text(escape_string(clipd, true));
    }
}


/**
 * Copy string without escape
 *
 * @author Ding Zhaojie (2010-12-9)
 */
_command void
string_copy() name_info(','VSARG2_MARK|VSARG2_READ_ONLY|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL)
{
    if (copy_to_clipboard() != 0) {
        return;
    }
    _str clipd = get_clipboard();
    if (clipd != null) {
        free_clipboard(1);
        set_clipboard(escape_string(clipd, false));
    }
}

/************************* [  DEBUG FUNCTIONS   ] ****************************/

