# .bash_profile

if [ -f ~/.bashrc ]; then
	# this tells bashrc not to update enviroment-scripts
	# because it takes a few seconds and annoys humans
	. ~/.bashrc skipUpdate
fi

# these functions are set in machineEnv.sh and need to be unset in interactive
# shell mode because they cause the fabric engine to print errors when
# starting enablers
unset getWinEnvVar convert2winPaths getGCCVersion checkSusePlatform addPath addLibPath setJavaHome

# source the interactive stuff for this shell (the login shell) as well
source ${HOME}/.aliases
source ${HOME}/.functions
