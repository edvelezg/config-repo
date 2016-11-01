# Applications should export here:
export EDITOR='/cygdrive/c/Program\ Files/SlickEditV15.0.1/win/vs.exe'
export WHOME='/cygdrive/c/Users/Viper'

# This changes the some behaviors of ls
alias lr='ls -lrt'
alias ls='ls -skFGh'
alias e='/cygdrive/c/Program\ Files/e/e.exe $*'
alias vs='/cygdrive/c/Program\ Files/SlickEditV15.0.1/win/vs.exe $*'
alias open='explorer $*'
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

# http://www.webweavertech.com/ovidiu/weblog/archives/000326.html
# this doesn't seem to work
