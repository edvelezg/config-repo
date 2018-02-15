#! /bin/bash
# bash login shell setup

# ---------------------------------------------------------------
if [ -r ~/.trace_login ]; then echo "in ~/.bash_profile"; fi

# You don't seem to be able to ignore TSTP, TTIN or TTOU
trap "" 1 2 3     # ignore HUP, INT, and QUIT now.
### umask 027         # rwxr-----
umask 022         # rwxr-xr-x

# Bash is kind enough to provide you with $HOSTTYPE, which is the machine
# architecture you are running on.

# Where the group 'local' directory is located...
MY_LOCAL=/usr/local; export MY_LOCAL

# set your printers
PRINTER=printer1_1   ; export PRINTER
PS_PRINTER=$PRINTER  ; export PS_PRINTER
LPDEST=$PRINTER      ; export LPDEST

# Prevent flexlm from creating $HOME/.flexlmrc
FLEXLM_NO_CKOUT_INSTALL_LIC=1; export FLEXLM_NO_CKOUT_INSTALL_LIC

# ----------------------------------------------------------------------
# Hostid of the machine I use (for X-display)
MY_MACHINE=egutarra-2

# common environment variables (strip off any domain component)
HOST_NAME=`/bin/uname -n | sed -e 's/\..*$//'`
export HOST_NAME

# For Xmessage/Xquestion
HOST_TABLE=$HOME/.host_table; export HOST_TABLE

VISUAL=vi ; export VISUAL
EDITOR=vi ; export EDITOR

# for pgrind
PG_TABSTOP=3 ; export PG_TABSTOP

MORE=-s                 ; export MORE
MANPATH="$HOME/bin/man:${MY_LOCAL}/man:/usr/share/man" ; export MANPATH

XAPPLRESDIR=${HOME}/bin/app-defaults/ ; export XAPPLRESDIR

# ----------------------------------------------------------------------
SHELL=${MY_LOCAL}/bin/bash      ; export SHELL
EDITOR=vi                       ; export EDITOR
BASH_ENV=$HOME/.bash_profile    ; export BASH_ENV
HISTSIZE=500                    ; export HISTSIZE
IGNOREEOF=2                     ; export IGNOREEOF # this many ^D's will kill the shell
LESS=-MEirsX                    ; export LESS

# I want all my commands to make it the history list
unset HISTCONTROL

# ----------------------------------------------------------------------
# source the host specific login, if it exists
if [ -r ~/.bash_profile.${HOSTTYPE} ]; then
   . ~/.bash_profile.${HOSTTYPE}
else
   echo "Didn't find ~/.bash_profile.$HOSTTYPE to source..."
fi
# ----------------------------------------------------------------------

# This sets LS_COLORS for GNU ls
if [ -r ~/.dir_colors ]; then
   eval `dircolors -b ~/.dir_colors`
else
   eval `dircolors -b`
fi

# If you aren't using the Solaris Desktop login
if [ ! "$DT" ]; then

   # Figure out your DISPLAY value
   if [ "`tty`" == "/dev/console" ]; then
      # I'm at a console
      DISPLAY=${HOST_NAME}:0
   else
      # This is the rlogin case
      DISPLAY=${MY_MACHINE}:0
   fi
   export DISPLAY

   # if you've got an interactive login and an xterm
   if [ ! -z "$PS1" ]; then
      case "$TERM" in
         xterm|ansi)
                /bin/stty kill "^U" erase "^?" intr "^C" eof "^D" susp "^Z"
                /bin/stty -hupcl ixon -ixoff -tostop
                ;;
             *)
                /bin/stty kill "^U" erase "^?" intr "^C" eof "^D" susp "^Z"
                ;;
      esac
   fi

   # source the interactive stuff for this shell (the login shell) as well
   if [ -r ~/.bashrc ]; then
      . ~/.bashrc
   fi

fi

# reset interrupts
trap 1 2 3

if [ -r ~/.trace_login ]; then echo "leaving ~/.bash_profile"; fi

if [ -r ~/.bash_profile.ed ]; then
  . ~/.bash_profile.ed
fi
