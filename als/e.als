=surround_with_while while (%\c) {
                     %\m sur_text -indent%
                     }
=surround_with_union union {
                     %\m sur_text -indent%
                     } %\c;
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
=surround_with_switch switch (%\c) {
                      %\m sur_text%
                      }
=surround_with_if...else if (%\c) {
                         %\m sur_text -indent%
                         } else {
                         %\m sur_text -indent%
                         }
=surround_with_struct struct {
                      %\m sur_text -indent%
                      } %\c;
=surround_with_for for (%\c) {
                   %\m sur_text -indent%
                   }

=surround_with_say say('%\m sur_text -stripend ;% "'%\m sur_text -stripend ;%'"');
=surround_with_if_condition if (%\m sur_text -stripend ;%) {
                            %\i%\c
                            }

=surround_with_braces {
                  %\m sur_text -indent%
                  }
