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
=surround_with_default default:
                       %\m sur_text -indent%
=surround_with_case case %\c:
                    %\m sur_text -indent%
                    break;
=surround_with_if...else if (%\c) {
                         %\m sur_text -indent%
                         } else {
                         }
=surround_with_finally finally {
                       %\m sur_text -indent%
                       }
=surround_with_for for (%\c) {
                   %\m sur_text -indent%
                   }

=surround_with_try...catch try {
                           %\m sur_text -indent%
                           } catch (%\c) { %\S
                           }
=surround_with_try...catch...finally try {
                                     %\m sur_text -indent%
                                     } catch (%\c) { %\S
                                     } finally {
                                     }
=surround_with_try...finally try {
                             %\m sur_text -indent%
                             } finally {
                             %\i%\c
                             }
=surround_with_switch switch (%\c) {
                      %\m sur_text%
                      }
