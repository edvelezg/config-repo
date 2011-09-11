//This macro has been posted for other SlickEdit users to use and explore.
//Depending on the version of SlickEdit that you are running, this macro may or may not load.
//Please note that these macros are NOT supported by SlickEdit and is not responsible for user submitted macros.

File:       aligneq.e
Author:     Joseph Van Valen
Date:       May 8, 2001
E-mail:     vanvalen@att.com		
VSlick ver. 6.0

Description:

Implements three commands borrowed from other editors.

The first command, align_equals, aligns the equal signs in a group of
selected lines with the right-most first equal sign within the group.

The second command, slide_in_prompt, indents a group of selected lines
(or blocks) by prefixing a user specified string to the first selected
character in each line of the selection. The user is prompted for the
slide_in string.

The third command, slide_out_prompt,outdents a group of selected lines (or
blocks) by removing the user specified string from each line of a
selection.  Lines not containing the specified string are unchanged. The
user is prompted for the slide_out string.

The common thread between each of the commands is that they operate on
selected text and use the selection filter techniques supplied by Visual
Slick.All of these functions expect either a line or block selection to
operate on.  Stream selections are not supported at this time.

To install just execute LoadModule from the Macro menu, specify aligneq.e
click OK.  Next, bind these functions to the keystrokes of your choice.
My preference is to assign align_equals to Alt =>, slide_in_prompt to <Alt
..>, and slide_out_prompt to <Alt ,>.  (I moved complete_prev and
complete_next to <alt [> and <alt ]> respectively).

I hope you find these functions useful.


