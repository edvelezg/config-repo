// $Id: wrox_create_java_project.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-04-07
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
#include "project.sh"

/**
 * Create directories for a new Java project, initialize files.
 * This is a sample command that shows how you can hook into
 * SlickEdit's new project functionality to do stuff when a
 * project is created.
 * This example is expanded from Chapter 4.
 */
_command void wrox_create_java_project() name_info(',') {
  // create src/java/com/wrox/
  _str java_path = _file_path(_project_name) :+ "src" :+ FILESEP :+
                   "java" :+ FILESEP :+ "com" :+ FILESEP :+ "wrox";
  make_path(java_path);
  // create src/test/com/wrox/
  _str test_path = _file_path(_project_name) :+ "src" :+ FILESEP :+
                   "test" :+ FILESEP :+ "com" :+ FILESEP :+ "wrox";
  make_path(test_path);

  // add wildcard for src/*, recursive, excluding SVN files
  _ProjectAdd_Wildcard(_ProjectHandle(), 'src\*', '*\.svn\*', true);

  // add Ant build file from user template
  // This line is added in Chapter 11.
  add_item('%VSLICKCONFIG%\templates\ItemTemplates\Java\Ant build file\Ant build file.setemplate', "build.xml", "", true, false);
}
