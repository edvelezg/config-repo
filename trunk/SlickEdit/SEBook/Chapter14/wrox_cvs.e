// $Id: wrox_cvs.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-04-09
//
// Copyright 2007 Wiley Publishing Inc, Indianapolis, Indiana, USA.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma option(strict, on)
#include "slick.sh"

/**
 * Cal CVS update with the project root directory.
 */
_command void wrox_cvs_update_project() name_info(',') {
  cvs_gui_mfupdate("-r " wrox_project_dir());
}

// Set up some key bindings for using Subversion.
defeventtab default_keys;
def 'A-V' 'a'=cvs_add;
def 'A-V' 'm'=cvs_checkout_module;
def 'A-V' 'c'=cvs_commit;
def 'A-V' 'd'=cvs_diff_with_tip;
def 'A-V' 'l'=cvs_history;
def 'A-V' 'q'=cvs_query;
def 'A-V' 'r'=cvs_remove;
def 'A-V' 'v'=cvs_review_and_commit;
def 'A-V' 'u'=wrox_cvs_update_project;

