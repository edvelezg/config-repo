#include "slick.sh"

static int g_debugVarCounter = 0;

_command void insert_debug_timer()
{
   _begin_select();
   first_non_blank();

   int indentCol = p_col - 1;
   _str indentText = indent_string(indentCol);

   up();
   insertText1(indentText);
   int status = _end_select();
   if (status == TEXT_NOT_SELECTED_RC)
   {
      down();
   }

   insertText2(indentText);
   insertText3(indentText);
   insertText4(indentText);
   g_debugVarCounter++;
}

static void insertText1(_str indentText)
{
   _str lineText = "";
   _str var1Name = "beginTime"g_debugVarCounter;

   // figure out what lang we're in
   switch (p_LangId)
   {
   case 'e':
      lineText :+= indentText"double "var1Name" = (double)_time('b');";
      break;
   case 'c':
      lineText :+= indentText"clock_t "var1Name" = clock();";
      break;
   case 'java':
      lineText :+= indentText"long "var1Name" = System.currentTimeMillis();";
      break;
   }
   insert_line(lineText);
}


static void insertText2(_str indentText)
{
   _str lineText = "";
   _str var1Name = "endTime"g_debugVarCounter;

   // figure out what lang we're in
   switch (p_LangId)
   {
   case 'e':
      lineText :+= indentText"double "var1Name" = (double)_time('b');";
      break;
   case 'c':
      lineText :+= indentText"clock_t "var1Name" = clock();";
      break;
   case 'java':
      lineText :+= indentText"long "var1Name" = System.currentTimeMillis();";
      break;
   }
   insert_line(lineText);
}


static void insertText3(_str indentText)
{
   _str lineText = "";
   _str var1Name = "timeDiff"g_debugVarCounter;

   // figure out what lang we're in
   switch (p_LangId)
   {
   case 'e':
      lineText :+= indentText"double "var1Name" = (endTime"g_debugVarCounter " - beginTime"g_debugVarCounter ") / 1000.0;";
      //    lineText :+= indentText"double "timeDiff" = (endTime - beginTime) / 1000.0;";
      break;
   case 'c':
      lineText :+= indentText"clock_t "var1Name" = clock();";
      break;
   case 'java':
      lineText :+= indentText"long "var1Name" = System.currentTimeMillis();";
      break;
   }
   insert_line(lineText);
}


static void insertText4(_str indentText)
{
   _str lineText = "";
   _str var1Name = "timeDiff"g_debugVarCounter;

   // figure out what lang we're in
   switch (p_LangId)
   {
   case 'e':
      lineText :+= indentText"say('Elapsed time = '"var1Name" seconds. ');";
      //    lineText :+= indentText"double "timeDiff" = (endTime - beginTime) / 1000.0;";
      break;
   case 'c':
      lineText :+= indentText"clock_t "var1Name" = clock();";
      break;
   case 'java':
      lineText :+= indentText"long "var1Name" = System.currentTimeMillis();";
      break;
   }
   insert_line(lineText);
}

//_command void TestTiming()
//{
//   double beginTime = (double)_time('b');
//   delay(300);
//   double endTime = (double)_time('b');
//   double timeDiff = (endTime - beginTime)/1000.0;
//   say('Elapsed time = ' timeDiff ' seconds.');
//}
