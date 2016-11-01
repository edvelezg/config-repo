# base-files version 3.9-3

# To pick up the latest recommended .bashrc content,
# look in /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# Environment Variables
# #####################

export REMOTEHOST=`whoami | sed 's/(\|)/ /g' | awk '{ print $6 }'`
export WHOME='/cygdrive/c/Users/Viper'

# TMP and TEMP are defined in the Windows environment.  Leaving
# them set to the default Windows temporary directory can have
# unexpected consequences.
unset TMP
unset TEMP

# Alternatively, set them to the Cygwin temporary directory
# or to any other tmp directory of your choice
# export TMP=/tmp
# export TEMP=/tmp

# Or use TMPDIR instead
# export TMPDIR=/tmp

# Shell Options
# #############

# See man bash for more options...

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
# shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
  shopt -s cdspell


# Completion options
# ##################

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# If this shell is interactive, turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# case $- in
#   *i*) [[ -f /etc/bash_completion ]] && . /etc/bash_completion ;;
# esac


# History Options
# ###############

# Don't put duplicate lines in the history.
# export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
# #######

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias lr='ls -lrt'
alias ls='ls -skFGh'
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #

alias lr='ls -lrt'
alias ls='ls -skFGh'
alias e='mate'
alias open.='open .'
alias h='history'

# A cleaner display of the paths.
alias path='echo $PATH | tr ":" "\n"'
alias ldpath='echo $DYLD_LIBRARY_PATH | tr ":" "\n"'
alias clpath='echo $CLASSPATH | tr ":" "\n"'
alias ll='ls -l'
alias sup='svn up'
alias sci='svn ci -m ""'

# Put most used directories here for quick access
alias cdjav='cd $WHOME/www.daniel-lemire.com/JavaRowReordering'
alias cdbit='cd $WHOME/www.daniel-lemire.com/BitmapIndexCpp'
alias cdtmp='cd $WHOME/Tmp'
alias cdeds='cd $WHOME/www.daniel-lemire.com/EdStuff'
alias cdrub='cd $WHOME/Documents/Ruby'
alias cdcol='cd $WHOME/www.daniel-lemire.com/ColumnMerging'
alias cdpro='cd $WHOME/www.daniel-lemire.com/'

# Testing this for quick access
alias mkfixed='$WHOME/Documents/Ruby/mkfixed.rb'
alias svnexec='$WHOME/Documents/Bash/svnexec.sh'
alias svnignore='$WHOME/Documents/Bash/svnignore.sh'
alias nofont='$WHOME/Documents/Bash/nofont.sh'

# Aliases for connecting to GXT
alias ssh2mail2='/usr/bin/ssh -l poppop -i $HOME/.ssh/id_rsa mail2.gxt.com'
alias ssh2aitne='/usr/bin/ssh -l poppop -i $HOME/.ssh/id_rsa -L 5901:aitne:5901 mail2.gxt.com'
alias ssh2svn='/usr/bin/ssh -l poppop -i $HOME/.ssh/id_rsa -L 8080:cvs01.gxt.com:8080 -L 3690:cvs01.gxt.com:3690 mail2.gxt.com'
# alias sshmaster="ssh -l edvelez licef"
alias sshmaster='ssh -l edvelez licef'
alias sshc1='ssh -l edvelez -t licef "ssh compute-00-01"'
alias sshc2='ssh -l edvelez -t licef "ssh compute-00-02"'
alias sshc3='ssh -l edvelez -t licef "ssh compute-00-03"'
alias sshc4='ssh -l edvelez -t licef "ssh compute-00-04"'
alias sshc5='ssh -l edvelez -t licef "ssh compute-00-05"'
alias sshc6='ssh -l edvelez -t licef "ssh compute-00-06"'
alias sshc7='ssh -l edvelez -t licef "ssh compute-00-07"'
alias sshc8='ssh -l edvelez -t licef "ssh compute-00-08"'
alias sshc9='ssh -l edvelez -t licef "ssh compute-00-09"'
alias sshc10='ssh -l edvelez -t licef "ssh compute-00-10"'
alias sshc11='ssh -l edvelez -t licef "ssh compute-00-11"'
alias sshc12='ssh -l edvelez -t licef "ssh compute-00-12"'
alias sshc13='ssh -l edvelez -t licef "ssh compute-00-13"'
alias sshc14='ssh -l edvelez -t licef "ssh compute-00-14"'
alias sshc15='ssh -l edvelez -t licef "ssh compute-00-15"'


# Functions
# #########

# Some example functions
function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }
function bu () { cp $1 ${1}-`date +%m%d%H%M` ; }
function cdp() { cd `cygpath.exe -u "$1"`; }
function vs() { vs `cygpath.exe -w "$1"`; }
#function e() { e `cygpath.exe -u "$1"`; } # This is really defective.

#http://blog.kowalczyk.info/article/ssh-tips.html
## Enable ssh agent
export SSH_AUTH_SOCK=/tmp/.ssh-socket

ssh-add -l >/dev/null 2>&1

if [ $? = 2 ]; then
  # Exit status 2 means couldn't connect to ssh-agent; start one now
  rm -rf /tmp/.ssh-*
  ssh-agent -a $SSH_AUTH_SOCK >/tmp/.ssh-script
  . /tmp/.ssh-script
  echo $SSH_AGENT_PID >/tmp/.ssh-agent-pid
fi

function kill-agent {
  pid=`cat /tmp/.ssh-agent-pid`
  kill $pid
}

function addkeys {
  ssh-add ~/.ssh/id_dsa*
}
