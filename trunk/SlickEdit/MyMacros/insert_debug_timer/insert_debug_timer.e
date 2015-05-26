#include "slick.sh"

// this macro file is reviewed in the SlickEdit blog entry 
// http://blog.slickedit.com/2010/05/let%E2%80%99s-make-a-macro-part-2-adding-debug-timing/

// this is a global static counter to make our variables unique
static int g_debugVarCounter = 0;

/**
 * Inserts code to capture begin and end timestamps around the 
 * currently selected block of code.  The difference in seconds 
 * between these timestamps is then reported.  This is useful 
 * when you need to determine the amount of time a block of code 
 * takes. 
 */
_command void insert_debug_timer() name_info(','VSARG2_MACRO|VSARG2_MARK|VSARG2_REQUIRES_MDI_EDITORCTL)
{
   // put the cursor on the first line of the selection 
   _begin_select();
   // get the indentation of the current line
   first_non_blank();
   int indentCol = p_col - 1;
   // start building the new line of code
   _str indentText = indent_string(indentCol);
   // we need to go up one line because insert_text inserts _after_ the current line
   up();
   insertText1(indentText);
   // put the cursor on the last line of the selection 
   int status = _end_select();
   if (status == TEXT_NOT_SELECTED_RC) {
      // we have to move down a line
      down();
   }
   // insert the text to calculate the time difference
   insertText2(indentText);
   // increment the global counter for variable names
   g_debugVarCounter++;

   // Check if the function get_wall_time is defined
   _str fct = "get_wall_time";
   typeless p; _save_pos2( p );
   if ( !find( fct, 'PEHNWCF' ) )
   {
      message("Could not find function in buffer");
      top();
      insertText0("");
   }
   _restore_pos2( p );
}

/**
 * Adds the code to capture the first timestamp.
 */
static void insertText1(_str indentText)
{
   _str lineText = "";
   // create the variable names
   _str var1Name = "beginWallTime"g_debugVarCounter;
   
   // figure out what language we're in (Slick-C, C++ or Java for now)
   switch (p_LangId) {
   case 'e':
      lineText :+= indentText"double "var1Name" = (double)_time('b');";
      break;
   case 'c':
      lineText :+= indentText"double "var1Name" = get_wall_time();";
      break;
   case 'java':
      lineText :+= indentText"long "var1Name" = System.currentTimeMillis();";
      break;
   }
   insert_line(lineText);
}

/**
 * Adds the code that defines how to capture a timestamp
 */
static void insertText0(_str indentText)
{
   _str c_code = \
   "#ifdef _WIN32\n"\
   "#include <Windows.h>\n"\
   "double get_wall_time(){\n"\
   "    LARGE_INTEGER time,freq;\n"\
   "    if (!QueryPerformanceFrequency(&freq)){\n"\
   "        //  Handle error\n"\
   "        return 0;\n"\
   "    }\n"\
   "    if (!QueryPerformanceCounter(&time)){\n"\
   "        //  Handle error\n"\
   "        return 0;\n"\
   "    }\n"\
   "    return (double)time.QuadPart / freq.QuadPart;\n"\
   "}\n"\
   "double get_cpu_time(){\n"\
   "    FILETIME a,b,c,d;\n"\
   "    if (GetProcessTimes(GetCurrentProcess(),&a,&b,&c,&d) != 0){\n"\
   "        //  Returns total user time.\n"\
   "        //  Can be tweaked to include kernel times as well.\n"\
   "        return\n"\
   "            (double)(d.dwLowDateTime |\n"\
   "            ((unsigned long long)d.dwHighDateTime << 32)) * 0.0000001;\n"\
   "    }else{\n"\
   "        //  Handle error\n"\
   "        return 0;\n"\
   "    }\n"\
   "}\n"\
   "\n"\
   "//  Posix/Linux\n"\
   "#else\n"\
   "#include <sys/time.h>\n"\
   "double get_wall_time(){\n"\
   "    struct timeval time;\n"\
   "    if (gettimeofday(&time,NULL)){\n"\
   "        //  Handle error\n"\
   "        return 0;\n"\
   "    }\n"\
   "    return (double)time.tv_sec + (double)time.tv_usec * .000001;\n"\
   "}\n"\
   "double get_cpu_time(){\n"\
   "    return (double)clock() / CLOCKS_PER_SEC;\n"\
   "}\n"\
   "#endif\n";
   _insert_text(c_code);
}

/**
 * Adds the code to capture the second timestamp, diff the two 
 * and report the number of seconds that elapsed. 
 */
static void insertText2(_str indentText)
{
   _str lineText = "";

   // create the variable names
   _str var1Name = "beginWallTime"g_debugVarCounter;
   _str var2Name = "endWallTime"g_debugVarCounter;
   _str var3Name = "wallTimeDiff"g_debugVarCounter;

   // figure out what language we're in (Slick-C, C++ or Java for now)
   switch (p_LangId) {
   case 'e':
      // insert the text to get the current timestamp
      lineText = indentText"double "var2Name" = (double)_time('b');";
      insert_line(lineText);
      // do the math and output the time difference
      lineText = indentText"double "var3Name" = ("var2Name" - "var1Name") / 1000.0;";
      insert_line(lineText);
      lineText = indentText"say('Elapsed time ["g_debugVarCounter"] = '"var3Name"' seconds.');";
      insert_line(lineText);
      break;
   case 'c':
      // insert the text to get the current timestamp
      lineText = indentText"double "var2Name" = get_wall_time();";
      insert_line(lineText);
      // do the math and output the time difference
      lineText = indentText"double "var3Name" = "var2Name" - "var1Name";";
      insert_line(lineText);
      lineText = indentText"printf(\"Elapsed time ["g_debugVarCounter"] = %lf seconds.\\n\", "var3Name");";
      insert_line(lineText);
      break;
   case 'java':
      // insert the text to get the current timestamp
      lineText = indentText"long "var2Name" = System.currentTimeMillis();";
      insert_line(lineText);
      // do the math and output the time difference
      lineText = indentText"double "var3Name" = (double)("var2Name" - "var1Name") / 1000.0;";
      insert_line(lineText);
      lineText = indentText"System.out.println(\"Elapsed time ["g_debugVarCounter"] = \" + "var3Name" + \" seconds.\");";
      insert_line(lineText);
      break;
   }
}


