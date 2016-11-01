/*
   IMPORTANT NOTE 12/24/2015 11:56 PM 
   Found this in the file:///C:/Program%20Files/SlickEdit%20Pro%2020.0.1/docs/SlickCMacroBestPractices.pdf Page 4

   If you are writing batch macros, then it would be a good idea to add an 
   entry to the VSLICKPATH environment variable in a file called vslick.ini 
   in your Configuration Directory.  Doing so will allow you to execute batch 
   macros without having to specify the full path.  Example vslick.ini with 
   modified VSLICKPATH: [Environment] ; IMPORTANT: Append to existing value 
   of VSLICKPATH or else you will have BIG problems!  
   VSLICKPATH=%VSLICKPATH%;<my-custom-macro-directory> Finding 
*/

#pragma option(strict, on)
#include "slick.sh"

/**
 * Load emulations and commands.
 * Slick-C batch macro.
 */
defmain() {
  load("align_chars\\alignchars.e");
  load("escape_string\\string_paste.e");
  load("my_emulation\\my_emulation.e");
  return 0;
}

