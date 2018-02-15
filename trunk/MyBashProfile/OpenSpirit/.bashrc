# Bash aliases/functions
#
# For non-login shells
if [ -r ~/.trace_login ]; then echo "   in ~/.bashrc"; fi

# Where the application defaults are
#   %T -> "app-defaults"
#   %N -> <application class name>
#   %S -> ""
XUSERFILESEARCHPATH=./%N:$HOME/bin/app-defaults/%N:${MY_LOCAL}/app-defaults/%N
export XUSERFILESEARCHPATH

# On diamond I have to use a specialized xterm
if [ "${HOST_NAME}" = "diamond" ]; then
#   alias xterm='/users/rgh/local/bin/xterm -class XTerm-color'
   PATH=$HOME/local/bin:$PATH
   XUSERFILESEARCHPATH=$HOME/local/lib/X11/app-defaults/%N:$XUSERFILESEARCHPATH
fi

# If you have access to GNU 'ls' then set up to use it
GNU_LS=
if [ -x $MY_LOCAL/bin/gls ]; then
   GNU_LS=$MY_LOCAL/bin/gls
elif [ -x $MY_LOCAL/bin/ls ]; then
   GNU_LS=$MY_LOCAL/bin/ls
elif [ "`uname -s`" = "Linux" ]; then
   GNU_LS=/bin/ls
fi

gls_opts=
if [ -n "$GNU_LS" ]; then
   alias gls='$GNU_LS'

   # color file listing aliases. GNU ls appears to automatically pick up LS_COLORS
   # Note: this only works in color xterms, or 'ansi' which is what I get when
   # I use HyperAccess from home.
   if [ "$TERM" = "xterm" -o "$TERM" = "ansi" ]; then
     gls_opts='--color=auto'
   fi
else
   # No GNU ls, just use what's there
   alias gls='/bin/ls'
fi
source ~/.aliases
alias ls='gls $gls_opts'
alias lsf='gls -Fl $gls_opts'
alias lsa='gls -A $gls_opts'
alias lsfa='gls -FAl $gls_opts'

alias open='chmod go+rx'
alias shut='chmod go-rwx'

alias ascii='cat /usr/pub/ascii'

alias h='history | tail -50'
alias log=logout

# Check our spam/junk mail
alias mc='date;ls -Fl ~/mail/{reject-list,spam}'

# quick ways to get to certain stuff...
alias  _osp='pushd $OSP_HOME'
alias  _lib='pushd $OSP_HOME/lib'
alias  _src='pushd $OSP_HOME/src'
alias _java='pushd $OSP_HOME/java'
alias _incl='pushd $OSP_HOME/include'
alias  _idl='pushd $OSP_HOME/idl'
alias _logs='pushd $OSP_HOME/logs'

function _build() {
   latest_build=`perl $HOME/scripts/latest_build $@`
   if [ -d "${latest_build}" ]; then
      pushd $latest_build
   else
      echo "Cannot find latest build under /build"
   fi
}

# -----------------------------------------------------------------------
# use our own version of which(1)
# Note: This is largely obsolesced by the bash 'type' builtin function
if [ -z "$DT" -a "$HOSTTYPE" = "sparc" ]; then
function which ()
{
   eval last=\"\$$#\"

   # This picks up both functions and aliases
   ((set | sed -n "/^$last=()/,/^}$/p"); alias $last 2> /dev/null) | 
       ~rgh/bin/$HOSTTYPE/which -i ${1+"$@"}
}
fi

# -----------------------------------------------------------------------
# Set the prompt now, use boldfont if you can find tput...
# NOTE: if you drop into /bin/sh or /bin/ksh you will want to reset PS1
#       since they do NOT understand fancy PS1 values.
set_prompt ()
{
   # Note: tput is stupid about terminal type of 'emacs' 
   if [ "$TERM" = "xterm" -a -x /usr/bin/tput ]; then
      SB="`/usr/bin/tput bold`"
      EB="`/usr/bin/tput sgr0`"
      #  Exceed Xstart v6.0.0 chokes on the control chars used for bold
      #  prompt. Leave the trailing '>' char in normal font so that Exceed
      #  can detect the shell prompt.
      PS1="\[${SB}\]"'(\!)'$HOST_NAME:'${PWD#${PWD%/*/*/*}/}'"\[${EB}\]"'> '
   else
      PS1='(\!)'$HOST_NAME:'${PWD#${PWD%/*/*/*}/}> '
   fi
   export PS1
   PS2='> ' ; export PS2
}

# -------------------------------------------------------------------
ruler ()
{
   echo "         1         2         3        4          5         6         7         8"
   echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
}
# -------------------------------------------------------------------
# Get an oracle error code explained
oraerr ()
{
   if [ $# -ne 1 ]; then
      printf "Error: oraerr() needs the numeric oracle error code\n"
   else
     oerr=/prod/oracle/9.2.0.4/bin/oerr
     if [ -x "$oerr" ]; then
         # Do this in a sub-shell so you don't mess up your environment
        (ORACLE_HOME=/prod/oracle/9.2.0.4; export ORACLE_HOME; $oerr ora "$@")
     else
        printf "Error: cannot find \"%s\" to execute.\n" "$oerr"
     fi
   fi
}

# -------------------------------------------------------------------
# rename a bunch of files to have a given extension for Windows/DOS
todos()
{
   if [ $# -lt 2 ]; then
      printf "Error: todos() needs 2 or more args, the first is newExt and the rest are source files.\n"
   else
      newExt=$1; shift

      # Guard against someone invoking it like this: todos *.cc (forgetting the extension)
      # If there is a '.' in the extension, it's probably not right.
      if [ `expr "$newExt" : '.*\..*'` -gt 0 ]; then
          printf "Error: todos()'s first argument is the new extension.\n"
      else
         for f in "$@"; do
             oldBase=`echo $f | sed -e 's/\.[A-Za-z]*$//'`
             cp $f ${oldBase}.${newExt}
             chmod u+w ${oldBase}.${newExt}
             unix2dos -ascii ${oldBase}.${newExt} ${oldBase}.${newExt} > /dev/null 2>&1
         done
         unset oldBase
      fi
      unset newExt
   fi
}

# -------------------------------------------------------------------
# 'Wide' ps
wps ()
{
   # Find the UCB style 'ps' to use
   if [ -x /usr/ucb/ps ]; then
      PS=/usr/ucb/ps
      PSOPTS="-auxww"
   elif [ -x /bin/ps ]; then
      PS=/bin/ps
      if [ "$HOSTTYPE" = "i386" -o "$HOSTTYPE" = "i686" -o "$HOSTTYPE" = "x86_64" ]; then
         # Linux has a BSD-style options if no leading dash
         PSOPTS="auxww"
      else
         PSOPTS="-ef"
      fi
   else
      printf "Error: wps() - could not find a UCB-style 'ps' to use.\n"
      return
   fi

   # Will take an optional argument for a regexp to look for
   str=""
   if [ $# -eq 1 ]; then
      str=$1
   fi

   if [ -z "$str" ]; then
      $PS $PSOPTS
   else
      $PS $PSOPTS | egrep -i $str
   fi

   unset PS PSOPTS
}

# -------------------------------------------------------------------
# tar/untar tar-balls using gzip/gunzip -> .gz files
targz ()
{
   echo "Trying to targz $1"
   # Tab completion leaves a trailing '/', remove it if necessary
   _d=`expr $1 : '\(.*\)/$' \| $1`
   rm -f ${_d}.tar
   tar cf - ${_d} > ${_d}.tar && gzip ${_d}.tar && rm -rf ${_d}
}
untargz ()
{
   echo "Trying to untargz $1"
   # Tab completion will give you the entire file name, with the '.tar.gz' suffix
   # This also handles 'foo_tar.gz' as well as 'foo.tar.gz'
   _d=`expr $1 : '\(.*\)tar\.gz$' \| $1`
   gunzip ${_d}tar.gz && tar xvf ./${_d}tar
}

# tar/untar .tar.Z-balls using compress-> .Z files
tarz ()
{
   echo "Trying to tarz $1"
   # Tab completion leaves a trailing '/', remove it if necessary
   _d=`expr $1 : '\(.*\)/$' \| $1`
   rm -f ${_d}.tar
   tar cf - ${_d} > ${_d}.tar && compress ${_d}.tar && rm -rf ${_d}
}
untarz ()
{
   echo "Trying to untarz $1"
   # Tab completion will give you the entire file name, with the '.tar.Z' suffix
   # This also handles 'foo_tar.Z' as well as 'foo.tar.Z'
   _d=`expr $1 : '\(.*\)tar\.Z$' \| $1`
   uncompress ${_d}tar.Z && tar xvf ./${_d}tar
}

# -----------------------------------------------------------------------
# This is kinda ugly, but whatever.
# If you drop into /bin/sh your PS1 prompt is all ugly, since sh is stupid.
# This function won't help if you invoke 'sh' as '/bin/sh' ...
sh ()
{
   (unset PS1; /bin/sh "$@" )
}
ksh ()
{
   (unset PS1; /bin/ksh "$@" )
}

# -----------------------------------------------------------------------
# TESTING
### function xemacs { ~rgh/sysadm/bin/xemacs "$@"; }

# -----------------------------------------------------------------------
# Make mgdiff ignore whitespace
function mgdiff {
   if [ -x /usr/local/bin/mgdiff ]; then
      /usr/local/bin/mgdiff -args -w "$@"
   else
      command mgdiff -args -w "$@"
   fi
}

# gmake aliases for OSP development
function gmakenm {
    gmake -f ${OSP_MAKE_DIR}/GNUmakefile.NoMakefile "$@"
}

# -----------------------------------------------------------------------
# helpful in finding files

function fn {
   if [ -x /usr/local/bin/realpath ]; then
      /usr/local/bin/realpath "$@"
   else
      echo "Cannot find realpath to use"
   fi
}

# Find files whose name match the pattern
function ffn {
  X=`find . -name "$*" -print;`
  echo $X | tr ' ' '\n'
}

# Find files (long listing) whose name match the pattern
function ffnl {
  find . -name "$*" -ls | cut -d ' ' -f 2-
}

# Find files containing the given pattern
function ffs {
  X=`find . -type f -exec egrep -i -l "$*" {} /dev/null \;`
   if [ ! -z "$X" ]; then
      echo $X | tr ' ' '\n'
   else
      echo "No files found containing the given expression."
   fi
}

# Find *.java files containing the given pattern
function ffjs {
   X=`find . -name "*.java" -exec egrep -i -l "$*" {} /dev/null \;`
   if [ ! -z "$X" ]; then
      echo $X | tr ' ' '\n'
   else
      echo "No Java files found containing the given expression."
   fi
}

# Find *.xml files containing the given pattern
function ffxml {
   arg=""
   if [ $# -gt 1 ]; then
      arg=$1
      shift
   fi

   X=`find . -name "*.xml" -exec egrep $arg -l "$*" {} /dev/null \;`
   if [ ! -z "$X" ]; then
      echo $X | tr ' ' '\n'
   else
      echo "No xml files found containing the given expression."
   fi
}

# Find any 'source code' files containing the given pattern
function ffsrc {
   X=`find . \( -name "*.java" -o \
     -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.hh" -o -name "*.h" -o -name "*.include" \) \
     -exec egrep -i -l "$*" {} /dev/null \;`
   if [ ! -z "$X" ]; then
      echo $X | tr ' ' '\n'
   else
      echo "No source *.{c,cc,cpp,hh,h,include} files found containing the given expression."
   fi
}

# Find any file in the current directory which file(1) considers a script...
function fscript {
    find . -name "*~" -prune -o -exec file {} \; | egrep "script|text" | awk -F: '{print $1}'
}

# Find any 'script' file (see 'fscript' function above) containing the given pattern
# Note: the 'mgrep' command is actually more useful, but doesn't take regexps (??)
function ffsh {
   egrep -i -l "$*" `fscript` /dev/null;
#      `find . -name "*~" -prune -o -exec file {} \; | egrep "script|text" | awk -F: '{print $1}'`;
}

# Convert all *.java files under '.' from DOS to Unix line terminators...
function mdjs {
   find . -name "*.java" | \
      while read file; do
         chmod u+w $file
         /bin/dos2unix -ascii $file $file 2> /dev/null
      done
}

# -----------------------------------------------------------------------
# Xmessage/Xquestion
function xq { xquestion "$@"; }
function xm { xmessage "$@"; }

# -----------------------------------------------------------------------
# Case insensitive grep using the faster GNU greps
if [ -x $MY_LOCAL/bin/egrep ]; then
   function egrep { $MY_LOCAL/bin/egrep -i "$@"; }
   function fgrep { $MY_LOCAL/bin/grep -i "$@"; }
   function grep  { $MY_LOCAL/bin/grep -i "$@"; }
elif [ -x /usr/bin/grep ]; then
   function grep { /usr/bin/grep -i "$@"; }
elif [ -x /bin/grep ]; then
   function grep { /bin/grep -i "$@"; }
fi

# -----------------------------------------------------------------------
# Getting around town
function pd  { pushd "$@"; ~rgh/bin/$HOSTTYPE/xterm_title -w; }
function pdl { pushd "$@"; ls -Fl; ~rgh/bin/$HOSTTYPE/xterm_title -w; }
function pop { popd "$@"; ~rgh/bin/$HOSTTYPE/xterm_title -w; }
function cd  { builtin cd "$@"; ~rgh/bin/$HOSTTYPE/xterm_title -w; }

# If you switch user to someone else, this function will make the
# new userid show in the xterm title as a reminder of who you are
function su() {
   u=$1
   # You have to set it before you 'su', because you don't come back from su
   # until the su'ed user exits his shell...
   ~rgh/bin/$HOSTTYPE/xterm_title -w $u
   /bin/su "$@"
   rc=$?
   # su done, restore xterm title
   ~rgh/bin/$HOSTTYPE/xterm_title -w
   return $rc
}

## This function will allow you to cd (accidentally) to a file and still
## do 'the right thing'...
#function cd() {
#   builtin cd "$@" && return 0
#   if [ -f "$1" ]; then
#      dir=${1%/*}
#      # could possibly inform the user we're changing to $dir
#      builtin cd "$dir"
#   else
#      return 1
#   fi
#}
#
## -----------------------------------------------------------------------
#fi92() {
#  if [ "${HOST_NAME}" = "mickey" ]; then
#      ( export ORACLE_HOME=/prod/oracle/8.1.6/sun/8.1.6/server;
#        export ORACLE_SID=fi9dv;
#        export TWO_TASK=fi9dv;
#        export TNS_ADMIN=/prod/oracle/8.1.6/network/admin;
#        export ORACLE_LIB=${ORACLE_HOME}/lib;
#        export PATH=${PATH}:${ORACLE_HOME}/bin;
#        export LD_LIBRARY_PATH=$ORACLE_HOME/lib:${LD_LIBRARY_PATH};
#        cd ~/dev/sql_macros;
#        xterm -title 'Finder 9.2' -geometry 135x30 -sb -sl 500 -e sqlplus ARCH/ARCH & );
#   else
#        echo "Don't know how to start sqlplus on this host '${HOST_NAME}'";
#   fi;
#}
# -----------------------------------------------------------------------

## Get me into OpenSpirit 'classic' ADS easily
function ads() {
   printf "You probably need to be on mickey or diamond...\n"
   if [ $# -lt 1 ]; then
      printf "ads() needs top-level OSP installation directory (e.g., '/prod/spirit/v252_56')\n"
      return
   fi

   # Ok, the argument is the short name of an OSP installation (e.g,. /prod/spirit/XYZ)
   install=$1
   if [ ! -d ${install} ]; then
      printf "ads() - can't find %s - pick a valid installation name.\n" "$install"
      return
   fi

   # The instance name is fixed (??) to 'ospd'
   # Grub out the ADS userid/password...
   userid=`/bin/grep 'openspirit.ads.config.Userid=' \
        $install/classes/OpenSpirit.properties | awk -F= '{print $2}'`

   if [ -z "$userid" ]; then
      printf "ads() - couldn't grok ADS userid from $install/classes/OpenSpirit.properties file\n"
      return
   fi

   if [ "${HOST_NAME}" = "mickey" ]; then
      (export ORACLE_HOME=/prod/oracle/8.1.7/sun/8.1.7/server; \
         export ORACLE_SID=ospd; \
         export TNS_ADMIN=/prod/oracle/8.1.7/network/admin; \
         export PATH=${PATH}:$ORACLE_HOME/bin; \
         export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/dt/lib:${LD_LIBRARY_PATH}; \
         cd ~/dev/sql_macros; \
         xterm -title ADS -geometry 135x30 -sb -sl 500 -e sqlplus $userid/$userid &)
   elif [ "${HOST_NAME}" = "diamond" ]; then
      (export ORACLE_HOME=/oracle/8.1.7/sun/8.1.7/server; \
         export ORACLE_SID=gf; \
         export TNS_ADMIN=/oracle/8.1.7/network/admin; \
         export PATH=${PATH}:$ORACLE_HOME/bin; \
         export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/dt/lib:${LD_LIBRARY_PATH}; \
         cd ~/dev/sql_macros; \
         xterm -title ADS -geometry 135x30 -sb -sl 500 -e sqlplus $userid/$userid &)
   else
      echo "Don't know how to start sqlplus on this host '${HOST_NAME}'"
   fi
   unset userid
}

# -----------------------------------------------------------------------
# Misc
function ypp { ypmatch "$@" passwd; }
# I like the BSD 'df' better
function df { /bin/df -k "$@"; }

# Use vim if we have it
function vi {
   vim=`type -p vim`
   if [ $? -eq 0 -a -n "${vim}" -a -x "${vim}" ]; then
      ${vim} "$@"
   else
      command vi "$@"
   fi
}

# Crank up the given number of xterms
function xt {
   let num=${1}+0
   if [ $? -eq 0 ]; then
      while `test $num -gt 0`; do
         xterm -sb -sl 5000 &
         let num=${num}-1
      done
   fi
}

function xts {
   # Get our xterms arranged the way we like them
   xterm -sb -geom "130x37+3-7" &              # bottom left
   xterm -sb -geom "130x37+865+1"  &           # top right
   xterm -sb -geom "135x37+822-5" &            # bottom right
   xterm -sb -iconic -geom "145x38+1713+140" & # left center
   xterm -sb -iconic -geom "140x40-9+228"  &   # right center
}

# Throw 'top' into it's own xterm if we're on Linux
function top {
   if [ "$HOSTTYPE" = "i386" -o "$HOSTTYPE" = "i686" -o "$HOSTTYPE" = "x86_64" ]; then
      xterm -sb -geom "240x40" -e top &
   else
      command top "$@"
   fi
}

# add the julian date to the output of 'date'
function date() {
   if [ -x /usr/bin/date ]; then
      DATE=/usr/bin/date
   elif [ -x /bin/date ]; then
      DATE=/bin/date
   else
      printf "Can't find a date executable.\n"
      return
   fi

   if [ $# -eq 0 ]; then
      $DATE +"%a %b %e %T %Z %Y (day %j/365, week %V/52)"
   else
      $DATE "$@"
   fi
}

# -----------------------------------------------------------------------
# # Thread count for builds OpenORB Notification Service
# function nscheck {
#    # Optional commerical install arg
#    if [ $# -eq 1 ]; then
#       if [ ! -d "/prod/spirit/$1" ]; then 
#          echo "Cannot find installation /prod/spirit/$1"
#          return
#       fi
#       pidFile="/prod/spirit/$1/logs/SharedServers/Notification.pid"
#    else
#       if [ -z "$OSP_HOME" ]; then
#          OSP_HOME=~ospbld/build/env/current_v2_7_build_dir
#       fi
#       echo "Using default OSP_HOME=$OSP_HOME"
#       pidFile="$OSP_HOME/logs/SharedServers/Notification.pid"
#    fi
# 
#    if [ ! -r $pidFile ]; then
#       echo "Cannot read pid file: $pidFile"
#       return
#    fi
# 
#    ps -ef -o 'pid nlwp user vsz rss args' | grep `cat $pidFile` | grep -v grep
#    unset pidFile
# }
#
# -----------------------------------------------------------------------
# popt="-P $PS_PRINTER"
# 
# # print landscape page, normal, on PS_PRINTER
# function land8 { nenscript -r -fCourier8 -FCourier-Bold9 $popt "$@"; }
# function land7 { nenscript -r -fCourier7 -FCourier-Bold8 $popt "$@"; }
# function land6 { nenscript -r -fCourier6 -FCourier-Bold7 $popt "$@"; }
# function land5 { nenscript -r -fCourier5 -FCourier-Bold6 $popt "$@"; }
# 
# # print small landscape, 80 col file, 2 per page, on PS_PRINTER
# function land27 { nenscript -2r -fCourier7 -FCourier-Bold8 $popt "$@"; }
# function land26 { nenscript -2r -fCourier6 -FCourier-Bold7 $popt "$@"; }
# function land25 { nenscript -2r -fCourier5 -FCourier-Bold6 $popt "$@"; }
# 
# # print normal pages, different fonts
# function l10 { nenscript -fCourier10 -FCourier-Bold11 $popt "$@"; }
# function l9 { nenscript -fCourier9 -FCourier-Bold10 $popt "$@"; }
# function l8 { nenscript -fCourier8 -FCourier-Bold9 $popt "$@"; }
# function l7 { nenscript -fCourier7 -FCourier-Bold8 $popt "$@"; }
# function l6 { nenscript -fCourier6 -FCourier-Bold7 $popt "$@"; }
# function l5 { nenscript -fCourier5 -FCourier-Bold6 $popt "$@"; }
# 
# -----------------------------------------------------------------------
# Aliases for use under bash
# -----------------------------------------------------------------------
# let's see our pushd/popd stack
alias stack='dirs | tr " " "\n"'

# -------------------------------------------------------------------
# always get decimals with bc(1)
if [ "`uname -s`" = "Linux" ]; then
   alias bc='bc -q -l'
else
   alias bc='bc -l'
fi

### -----------------------------------------------------------------------
### You need this here (as well as in your .bash_profile) if you run
### XSession under Exceed (single window manager).
###if [ ! -z "$PS1" ]; then
###   case "$TERM" in
###      xterm|ansi)
###             /bin/stty kill "^U" erase "^?" intr "^C" eof "^D" susp "^Z"
###             /bin/stty -hupcl ixon -ixoff -tostop
###             ;;
###          *)
###             /bin/stty kill "^U" erase "^?" intr "^C" eof "^D" susp "^Z"
###             ;;
###   esac
###fi
### -----------------------------------------------------------------------

# Set my command line editing mode to Emacs
set -o emacs

# fix minor typos in 'cd' command arguments
shopt -s cdspell

# up your limit of file descriptors
ulimit -n 1024
# Limit corefile size to zero (e.g, no core files)
ulimit -c 0

# This is like setting IGNOREEOF=10
# set -o ignoreeof

# The default undo is '\C-x\C-u'
bind '"\C-xu": undo'
# This re-maps ^W to the emacs kill-region
bind '"\C-w": kill-region'
bind '"\e[3~": backward-delete-char'

# I'm really lazy, so sue me...
bind '"\C-xc\.": "com.openspirit.osp."'
bind '"\C-xc/": "com/openspirit/osp/"'

# set the prompt
set_prompt

if [ -r ~/.trace_login ]; then echo "   leaving ~/.bashrc"; fi
