// $Id: wrox_url_mappings.e 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-05-11
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
 * Downloads the resource referenced by the URL.
 * Stores a local copy with a unique name in the config
 * directory.
 * Then adds a URL mapping for the resource, so that afterwards
 * SlickEdit will use the local copy rather than fetching via
 * network.
 */
_command void wrox_make_url_mapping(_str url="") name_info(',') {
  url = prompt(url, "URL");
  edit(url); // Note: SlickEdit knows how to fetch http:// addresses
  _str resourcename = wrox_make_local_resource_filename();
  save(resourcename);
  quit();

  typeless handle = _cfg_get_useroptions();
  int index = _xmlcfg_set_path(handle,"/Options/URLMappings");
  int new_index = _xmlcfg_add(handle, index, "MapURL", VSXMLCFG_NODE_ELEMENT_START, VSXMLCFG_ADD_AS_CHILD);
  _xmlcfg_set_attribute(handle, new_index, "From", url);
  _xmlcfg_set_attribute(handle, new_index, "To", resourcename);
  _cfg_save_useroptions();
}


/**
 * Returns a new unused local file name to store a resource in.
 *
 * @return _str An unused local file name for a resource.
 */
_str wrox_make_local_resource_filename() {
  int i = 0;
  _str basename = _config_path() :+ "resource";
  while (file_exists(basename :+ i)) {
    i++;
  }
  return basename :+ i;
}

