=surround_with_while while (%\c) {
                     %\m sur_text -indent%
                     }
=surround_with_try try {
                   %\m sur_text -indent%
                   }
=surround_with_catch catch (%\c) {
                     %\m sur_text -indent%
                     }
=surround_with_do...while do {
                          %\m sur_text -indent%
                          } while (%\c);
=surround_with_if if (%\c) {
                  %\m sur_text -indent%
                  }
=surround_with_template template %\c( ) {
                           %\m sur_text -indent%
                           };
=surround_with_default default:
                       %\m sur_text -indent%
=surround_with_case case %\c:
                    %\m sur_text -indent%
                    break;
=surround_with_static_if...else static if (%\c) {
                      %\m sur_text%
                      } else {
                      %\m sur_text%
                      }
=surround_with_switch switch (%\c) {
                      %\m sur_text%
                      }
=surround_with_if...else if (%\c) {
                         %\m sur_text -indent%
                         } else {
                         %\m sur_text -indent%
                         }
=surround_with_version...else version (%\c) {
                         %\m sur_text -indent%
                         } else {
                         %\m sur_text -indent%
                         }
=surround_with_finally finally {
                       %\m sur_text -indent%
                       }
=surround_with_for for (%\c) {
                   %\m sur_text -indent%
                   }
=surround_with_foreach foreach (%\c) {
                       %\m sur_text -indent%
                       }
=surround_with_foreach_reverse foreach_reverse (%\c) {
                       %\m sur_text -indent%
                       }
=surround_with_with with (%\c in ) {
                       %\m sur_text -indent%
                       }
=surround_with_version version (%\c in ) {
                       %\m sur_text -indent%
                       }
=surround_with_try...catch try {
                           %\m sur_text -indent%
                           } catch (%\c) {
                           }
=surround_with_try...catch...finally try {
                                     %\m sur_text -indent%
                                     } catch (%\c) {
                                     } finally {
                                     }
=surround_with_try...finally try {
                             %\m sur_text -indent%
                             } finally {%\c
                             }
=surround_with_braces {
                  %\m sur_text -indent%
                  }
