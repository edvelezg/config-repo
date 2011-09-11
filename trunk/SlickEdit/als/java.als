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
=surround_with_switch switch (%\c) {
                      %\m sur_text%
                      }
=surround_with_if...else if (%\c) {
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
=surround_with_new_j2me_midlet import javax.microedition.lcdui.*;
                               import javax.microedition.midlet.*;
                               %\l
                               public class %\m sur_text%
                                   extends MIDlet
                                   implements CommandListener {
                                 private Form mMainForm;
                               %\l
                                 public %\m sur_text%() {
                                   mMainForm = new Form("HelloMIDlet");
                                   mMainForm.append(new StringItem(null, "Hello, %\m sur_text%!"));
                                   mMainForm.addCommand(new Command("Exit", Command.EXIT, 0));
                                   mMainForm.setCommandListener(this);
                                 }
                               %\l
                                 public void startApp() {
                                   Display.getDisplay(this).setCurrent(mMainForm);
                                 }
                               %\l
                                 public void pauseApp() {}
                               %\l
                                 public void destroyApp(boolean unconditional) {}
                               %\l
                                 public void commandAction(Command c, Displayable s) {
                                   notifyDestroyed();
                                 }
                               }

=surround_with_braces {
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
