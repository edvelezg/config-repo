// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-30
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
 * Reads file and returns lines as an array.
 */
_str wrox_get_file_lines(_str filename)[] {
  int temp_view_id;
  int orig_view_id = _create_temp_view(temp_view_id);
  get(maybe_quote_filename(filename));
  _str result[];
  while (p_line < p_Noflines) {
    p_line++;
    _str line;
    get_line(line);
    result[result._length()] = line;
  }
  _delete_temp_view(temp_view_id);
  activate_window(orig_view_id);
  return result;
}

/**
 * Returns new array containing all elements of arr1 and arr2.
 */
_str wrox_array_concat(_str arr1[], _str arr2[])[] {
  int i;
  _str result[];
  for (i = 0; i < arr1._length(); i++) {
    result[result._length()] = arr1[i];
  }
  for (i = 0; i < arr2._length(); i++) {
    result[result._length()] = arr2[i];
  }
  return result;
}

/**
 * Returns new array containing unique elements of arr.
 */
_str wrox_array_uniq(_str arr[])[] {
  arr._sort();
  int i;
  _str prev = null;
  _str result[];
  for (i = 0; i < arr._length(); i++) {
    if (prev == null || arr[i] != prev) {
      result[result._length()] = arr[i];
    }
    prev = arr[i];
  }
  return result;
}

/**
*  Returns a new array formed by sorting the given array by
*  ordering values given in the hash table.
*  The items in arr are prefixed by their ordering strings
*  looked up in the hash table, then sorted.  Then the prefixes
*  are removed and the result returned.
*  Specify the delimiter to separate the prefixes from the
*  values if ':/:' might not be unique.
*  Specify a different notfound value if items without ordering
*  info are to go elsewhere other than at the front of the
*  result.
 */
_str wrox_array_sort_by(_str arr[], _str orderby:[], _str delim = ":/:", _str notfound="0000")[] {
  _str arr2[];
  int i;
  for (i = 0; i < arr._length(); i++) {
    _str value = arr[i];
    _str order = orderby._indexin(value) ? orderby:[value] : notfound;
    arr2[arr2._length()] = order :+ delim :+ value;
  }
  arr2._sort();
  _str result[];
  for (i = 0; i < arr2._length(); i++) {
    _str value = arr2[i];
    _str order;
    parse value with order (delim) value;
    result[result._length()] = value;
  }
  return result;
}

/**
 * Return output string of items separated by ", ".
 * @param keys Items to output.
 *
 * @return _str Output string of items.
 */
_str wrox_emulation_list_keys(_str keys) {
  if (keys == null) {
    return "";
  }
  _str arr[];
  split(keys, " ", arr);
  arr._sort();
  return join(arr, ", ");
}

/**
 * Convert key names from SlickEdit keydefs style to printable
 * style.
 * Key names in SlickEdit are expressed as 'A-T' for Alt+T.
 * This function converts them to 'A+T', which is the way we
 * want them printed in the book.
 * @param keys The keys to be converted.
 *
 * @return _str Printable key names.
 */
_str wrox_emulation_translate_key(_str keys) {
  if (keys == null) {
    return "";
  }
  _str result = stranslate(keys, "A+", "A-");
  result = stranslate(result, "C+", "C-");
  result = stranslate(result, "M+", "M-");
  result = stranslate(result, "S+", "S-");
  return result;
}

/**
 * Output list of lines as text into the buffer.
 * @param lines Lines to output.
 */
void wrox_emulation_output_text(_str lines[]) {
  int i;
  for (i = 0; i < lines._length(); i++) {
    _str line = lines[i];
    insert_line(line);
  }
}

/**
 * Output list of lines as HTML into the buffer.
 * Each line contains fields separated by tabs ("\t").
 * @param lines Lines to output.
 */
void wrox_emulation_output_html(_str lines[]) {
  insert_line("<table>");
  int i, j;
  _str fields[];
  split(lines[0], "\t", fields);
  _str output = "<tr>";
  for (i = 0; i < fields._length(); i++) {
    _str field = fields[i];
    strappend(output, "<th>"field"</th>");
  }
  strappend(output, "</tr>");
  insert_line(output);
  for (i = 1; i < lines._length(); i++) {
    _str line = lines[i];
    split(line, "\t", fields);
    output = "<tr>";
    for (j = 0; j < fields._length(); j++) {
      _str field = fields[j];
      strappend(output, "<td>"field"</td>");
    }
    strappend(output, "</tr>");
    insert_line(output);
  }
  insert_line("</table>");
}

/**
 * Output emulation tables to the buffer.
 * By default all 13 of SlickEdit's emulations are processed.
 * You can process a specific list of emulations by specifying
 * their file names as command arguments. TODO: more doc.
 * @param commandline
 */
_command void wrox_make_emulations(_str commandline="") name_info(',') {
  int i, j, k;
  _str macro_categories:[];     // category -> macro list
  _str category_macros:[];      // macro -> category
  _str key_order:[];            // key -> sort order
  _str emulations:[];           // def -> emulation name
  typeless def_macro_keys:[];   // def, macro -> key list
  typeless def_key_macros:[];   // def, key -> macro
  typeless def_var_values:[];   // def, variable -> value
  _str definition_list[];       // list of definitions
  _str emulation_list[];        // list of emulations
  _str key_list[];              // list of keys
  _str macro_list[];            // list of macros
  _str variable_list[];         // list of variables
  _str macros_seen:[];          // macros seen

  _str files = "bbeditdef.e briefdef.e codewarriordef.e " :+
    "codewrightdef.e emacsdef.e gnudef.e ispfdef.e slickdef.e " :+
    "vcppdef.e videf.e vsnetdef.e windefs.e xcodedef.e";
  _str path = get_env("VSLICKMACROS");
  _str common_file = "commondefs.e";
  _str output = "text";
  _str macro_file = "macros.txt";
  _str key_file = "keys.txt";
  _str definition_file = "definitions.txt";
  while (substr(commandline, 1, 1) == "-") {
    _str option;
    _str value;
    parse commandline with option commandline;
    parse option with "-" option "=" value;
    switch (option) {
      case "path": path = value; break;
      case "common": common_file = value; break;
      case "output": output = value; break;
      case "macros": macro_file = value; break;
      case "keys": key_file = value; break;
      case "definitions": definition_file = value; break;
      default:
        message("Unrecognised option ["option"]");
        _StackDump();
    }
  }
  if (strip(commandline) != "") {
    files = commandline;
  }
  _str macrolines[] = wrox_get_file_lines(macro_file);
  for (i = 0; i < macrolines._length(); i++) {
    _str line = macrolines[i];
    if (substr(line, 1, 1) == "#" || strip(line) == "") {
      continue; // skip comments and blank lines
    }
    _str macro, category;
    parse line with macro category;
    macro_categories:[macro] = category;
    if (category_macros._indexin(category)) {
      category_macros:[category] = category_macros:[category] :+ " " :+ macro;
    }
    else {
      category_macros:[category] = macro;
    }
  }
  _str keylines[] = wrox_get_file_lines(key_file);
  for (i = 0; i < keylines._length(); i++) {
    _str line = keylines[i];
    if (substr(line, 1, 1) == "#" || strip(line) == "") {
      continue; // skip comments and blank lines
    }
    _str key, order;
    parse line with key order;
    key_order:[key] = order;
  }
  _str definitionlines[] = wrox_get_file_lines(definition_file);
  for (i = 0; i < definitionlines._length(); i++) {
    _str line = definitionlines[i];
    if (substr(line, 1, 1) == "#" || strip(line) == "") {
      continue; // skip comments and blank lines
    }
    _str definition, emulation;
    parse line with definition emulation;
    emulations:[definition] = emulation;
  }

  _str commonlines[] = wrox_get_file_lines(path :+ common_file);
  while (strip(files) != "") {
    _str file;
    parse files with file files;
    _str definition;
    if (pos('(\:a+)def', file, 1, "U")) {
      definition = substr(file, pos("S1"), pos("1"));
    }
    else {
      definition = "?";
    }
    definition_list[definition_list._length()] = definition;
    emulation_list[emulation_list._length()] = emulations:[definition];
    _str macro_keys:[]; // macro -> key list
    _str key_macros:[]; // key -> macro
    _str var_values:[]; // variable -> value

    _str filelines[] = wrox_array_concat(commonlines, wrox_get_file_lines(path :+ file));
    _str eventtab = "";
    for (i = 0; i < filelines._length(); i++) {
      _str line = filelines[i];
      if (pos('^defeventtab\:b+(\:v);$', line, 1, "U") > 0) {
        eventtab = substr(line, pos("S1"), pos("1"));
      }
      if (eventtab == "default_keys" && pos('^\:b*def\:b+''([^'']+)''\:b*=\:b*(\:v);$', line, 1, "U") > 0) {
        _str key = upcase(substr(line, pos("S1"), pos("1")));
        _str macro = substr(line, pos("S2"), pos("2"));
        macros_seen:[macro] = 1;
        // JH_TODO: warn if not in macro_categories
        key_list[key_list._length()] = key;
        macro_list[macro_list._length()] = macro;
        if (macro_keys._indexin(macro)) {
          macro_keys:[macro] = macro_keys:[macro] :+ " " :+ key;
        }
        else {
          macro_keys:[macro] = key;
        }
        key_macros:[key] = macro;
      }
      if (pos('^\:b*(def_\:v)\:b*=\:b*(.*);$', line, 1, "U") > 0) {
        _str variable = substr(line, pos("S1"), pos("1"));
        _str value = substr(line, pos("S2"), pos("2"));
        variable_list[variable_list._length()] = variable;
        var_values:[variable] = value;
      }
    }
    def_macro_keys:[definition] = macro_keys;
    def_key_macros:[definition] = key_macros;
    def_var_values:[definition] = var_values;
  }
  macro_list = wrox_array_uniq(macro_list);
  key_list = wrox_array_sort_by(wrox_array_uniq(key_list), key_order);
  variable_list = wrox_array_uniq(variable_list);

  _str category_macro_key_lines[];
  _str macro_key_lines[];
  _str key_macro_lines[];
  _str variable_value_lines[];

  // output macro --> keys -- by category
  category_macro_key_lines[category_macro_key_lines._length()] =
    "Command\t" :+ join(emulation_list, "\t");
  _str categories[] = wrox_hash_keys(category_macros);
  for (i = 0; i < categories._length(); i++) {
    _str category = categories[i];
    category_macro_key_lines[category_macro_key_lines._length()] = category;
    _str macros[];
    split(category_macros:[category], " ", macros);
    macros._sort();
    for (j = 0; j < macros._length(); j++) {
      _str macro = macros[j];
      if (!macros_seen._indexin(macro)) {
        continue; // skip macro if we didn't actually see it
      }
      _str line = macro;
      for (k = 0; k < definition_list._length(); k++) {
        _str definition = definition_list[k];
        strappend(line, "\t" wrox_emulation_list_keys(wrox_emulation_translate_key(def_macro_keys:[definition]:[macro])));
      }
      category_macro_key_lines[category_macro_key_lines._length()] = line;
    }
  }

  // output macro --> keys -- alphabetically
  macro_key_lines[macro_key_lines._length()] =
    "Command\t" :+ join(emulation_list, "\t");
  for (i = 0; i < macro_list._length(); i++) {
    _str macro = macro_list[i];
    _str line = macro;
    for (j = 0; j < definition_list._length(); j++) {
      _str definition = definition_list[j];
      strappend(line, "\t" wrox_emulation_list_keys(wrox_emulation_translate_key(def_macro_keys:[definition]:[macro])));
    }
    macro_key_lines[macro_key_lines._length()] = line;
  }

  // output key --> macro
  key_macro_lines[key_macro_lines._length()] =
    "Key\t" :+ join(emulation_list, "\t");
  for (i = 0; i < key_list._length(); i++) {
    _str key = key_list[i];
    _str line = wrox_emulation_translate_key(key);
    for (j = 0; j < definition_list._length(); j++) {
      _str definition = definition_list[j];
      strappend(line, "\t" wrox_emulation_list_keys(def_key_macros:[definition]:[key]));
    }
    key_macro_lines[key_macro_lines._length()] = line;
  }

  // output macro variable --> value
  variable_value_lines[variable_value_lines._length()] =
    "Variable\t" :+ join(emulation_list, "\t");
  for (i = 0; i < variable_list._length(); i++) {
    _str variable = variable_list[i];
    _str line = variable;
    for (j = 0; j < definition_list._length(); j++) {
      _str definition = definition_list[j];
      strappend(line, "\t" wrox_emulation_list_keys(def_var_values:[definition]:[variable]));
    }
    variable_value_lines[variable_value_lines._length()] = line;
  }

  if (output == "text") {
    wrox_emulation_output_text(category_macro_key_lines);
    wrox_emulation_output_text(macro_key_lines);
    wrox_emulation_output_text(key_macro_lines);
    wrox_emulation_output_text(variable_value_lines);
  }
  else if (output == "html") {
    wrox_emulation_output_html(category_macro_key_lines);
    wrox_emulation_output_html(macro_key_lines);
    wrox_emulation_output_html(key_macro_lines);
    wrox_emulation_output_html(variable_value_lines);
  }
  else {
    message("Unrecognised output format ["output"]");
  }

}




_command int wrox_try_get_file_lines() {
  _str lines[] = wrox_get_file_lines("wrox_make_emulations.e");
  wrox_assert_equals("#pragma option(strict, on)", lines[18]);
  wrox_assert_equals("}", lines[lines._length()-1]);
  return 0;
}

_command int wrox_try_array_concat() {
  _str a[];
  _str b[];
  a[a._length()] = "one";
  a[a._length()] = "two";
  a[a._length()] = "three";
  b[b._length()] = "three";
  b[b._length()] = "two";
  b[b._length()] = "one";
  _str c[] = wrox_array_concat(a, b);
  wrox_assert_equals("one", c[0]);
  wrox_assert_equals("two", c[1]);
  wrox_assert_equals("three", c[2]);
  wrox_assert_equals("three", c[3]);
  wrox_assert_equals("two", c[4]);
  wrox_assert_equals("one", c[5]);
  return 0;
}

_command int wrox_try_array_uniq() {
  _str a[];
  a[a._length()] = "one";
  a[a._length()] = "two";
  a[a._length()] = "three";
  a[a._length()] = "three";
  a[a._length()] = "two";
  a[a._length()] = "one";
  a = wrox_array_uniq(a);
  wrox_assert_equals("one", a[0]);
  wrox_assert_equals("three", a[1]);
  wrox_assert_equals("two", a[2]);
  wrox_assert_equals(3, a._length());
  return 0;
}

_command int wrox_try_array_sort_by() name_info(',') {
  _str a[];
  a[a._length()] = "four";
  a[a._length()] = "one";
  a[a._length()] = "six";
  a[a._length()] = "three";
  a[a._length()] = "zero";
  a[a._length()] = "two";
  a[a._length()] = "five";
  _str order:[];
  order:["one"] = "0001";
  order:["two"] = "0002";
  order:["three"] = "0003";
  order:["four"] = "0004";
  order:["five"] = "0005";
  order:["six"] = "0006";
  _str b[] = wrox_array_sort_by(a, order);
  wrox_assert_equals(7, b._length());
  wrox_assert_equals("zero", b[0]);
  wrox_assert_equals("one", b[1]);
  wrox_assert_equals("two", b[2]);
  wrox_assert_equals("three", b[3]);
  wrox_assert_equals("four", b[4]);
  wrox_assert_equals("five", b[5]);
  wrox_assert_equals("six", b[6]);
  return 0;
}
