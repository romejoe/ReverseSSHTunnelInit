#!/bin/bash


function createTunnel() {
	remoteURL=$1
	remotePort=$2
	localPort=$3
	sshUser=$4
	cmd="ssh -N -R $remoteURL:$remotePort:localhost:$localPort "
	
	if [[ ! -z "$4" ]];
	then
		cmd="$cmd $sshUser@"
	fi
	cmd="$cmd$remoteURL" 
	echo $cmd
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

if [ "${1}" != "create" ]; then
	. config/config.sh
	createTunnel REMOTE_URL REMOTE_PORT LOCAL_PORT REMOTE_USER
fi