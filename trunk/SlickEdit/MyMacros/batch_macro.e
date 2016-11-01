#include "slick.sh"

#define MAXLINES 15
#define MAXLINESP1 (MAXLINES+1)
#define max(a,b) (((a) >= (b)) ? (a) : (b))
#define min(a,b) (((a) <= (b)) ? (a) : (b))

int gai[]={1, 7, 12};
int gaai[][]={{1},{1,2},{1,2,3}}; // Two dimensional array.
_str gastring1[]={"Value1", "Value2"};
typeless gat[]={"String", 1, 2.4};

void defmain()
{
   message("Hello World");
   say(p_file_date);
   say(p_active_form);
   say(p_buf_name);
   x=MAXLINES;
   y=MAXLINESP1;
   a=max(x,y);

//   t=gai; // Copy all the array elements into a local container
//   // variable.
//   t[t._length()]=45; // Add another array element.
//   t :+= 46; // Add another array element (shorthand).
//   for (i=0;i<t._length();++i) {
//      messageNwait("t["i"]="t[i]);
//   }
}
