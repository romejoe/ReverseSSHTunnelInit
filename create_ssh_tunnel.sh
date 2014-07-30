#!/bin/bash

function isCMDRunning(){
	ps aux | grep "$1" | grep -v "grep" | wc -l
}

function createTunnel() {
	remoteURL=$1
	remotePort=$2
	localPort=$3
	sshUser=$4
	cmd="ssh -N -f -R $remoteURL:$remotePort:localhost:$localPort "
	
	if [[ ! -z "$4" ]];
	then
		cmd="$cmd $sshUser@"
	fi
	cmd="$cmd$remoteURL" 
	if [[ $( isCMDRunning "$cmd" ) -ne "0" ]]; then
		exit 2
	fi

	eval "$cmd"
	if [[ $? -eq 0 ]]; then
		echo Tunnel to jumpbox created successfully
	else
		echo An error occurred creating a tunnel. RC was $?
	fi
}

#if [[ $(ps aux | grep "$cmd" | grep -v "grep" | wc -l) -eq "0" ]]; then
#  echo Creating new tunnel connection
#  createTunnel
#fi

if [ "${1}" == "create" ]; then
	if [[ ! -e  "config/config.sh" ]]; then
		mkdir config
		cp config_example.sh config/config.sh
		echo Please configure 'config/config.sh'
		exit 1
	fi
	. config/config.sh
	createTunnel $REMOTE_URL $REMOTE_PORT $LOCAL_PORT $REMOTE_USER
fi
