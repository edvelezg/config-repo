// $Id: wrox_wkspace_close_popallbkms.e 1466 2007-08-28 10:49:25Z jhurst $
// Hartmut Schaefer ("hs2")
// 2007-03-20
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

/**
 * Callback to pop all bookmarks whenever a workspace is closed.
 */
void _wkspace_close_popallbkms() {
  pop_all_bookmarks();
}

