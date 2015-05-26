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
