=surround_with_while while (%\c) {
                     %\m sur_text -indent%
                     }
=surround_with_try @try {
                   %\m sur_text -indent%
                   }
=surround_with_union union {
                     %\m sur_text -indent%
                     } %\c;
=surround_with_catch @catch (%\c) {
                     %\m sur_text -indent%
                     }
=surround_with_do...while do {
                          %\m sur_text -indent%
                          } while (%\c);
=surround_with_if if (%\c) {
                  %\m sur_text -indent%
                  }
=surround_with_type_struct typedef struct %\c {
                           %\m sur_text -indent%
                           };
=surround_with_default default:
                       %\m sur_text -indent%
=surround_with_case case %\c:
                    %\m sur_text -indent%
                    break;
=surround_with_#ifndef %\m begin_line%#ifndef %\c
                      %\m sur_text%
                      %\m begin_line%#endif
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
=surround_with_#ifdef %\m begin_line%#ifdef %\c
                     %\m sur_text%
                     %\m begin_line%#endif
=surround_with_finally @finally {
                       %\m sur_text -indent%
                       }
=surround_with_type_union typdef union %\c {
                          %\m sur_text -indent%
                          };
=surround_with_for for (%\c) {
                   %\m sur_text -indent%
                   }
=surround_with_include_once(macro "Symbol"
                            )
 #ifndef %(macro)
 #define %(macro)
 %\m sur_text%
 #endif // %(macro)
=surround_with_try...catch @try {
                           %\m sur_text -indent%
                           } @catch () {
                           }
=surround_with_try...catch...finally @try {
                                     %\m sur_text -indent%
                                     } @catch () {
                                     } @finally {
                                     }
=surround_with_dynamic_cast dynamic_cast<%\c>(%\m sur_text%)
=surround_with_#if %\m begin_line%#if %\c
                   %\m sur_text%
                   %\m begin_line%#endif
=surround_with_#if...else %\m begin_line%#if %\c
                          %\m sur_text%
                          %\m begin_line%#else
                          %\m sur_text%
                          %\m begin_line%#endif
=surround_with_const_cast const_cast<%\c>(%\m sur_text%)
=surround_with_reinterpret_cast reinterpret_cast<%\c>(%\m sur_text%)
=surround_with_try...finally @try {
                             %\m sur_text -indent%
                             } @finally {
                             }
=surround_with_static_cast static_cast<%\c>(%\m sur_text%)
 
=surround_with_braces {
                  %\m sur_text -indent%
                  }
