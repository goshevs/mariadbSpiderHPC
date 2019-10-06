#!/bin/bash

## This script stops the mariadb instance
##
##
##
##
## Simo Goshev
## Aug 21, 2019

myfile="/tmp/$USER-containerName"

if [[ -f "$myfile" ]]; then
	MY_SINGULARITY_DB_INSTANCE_NAME=$(cat $myfile)
	rm -rf $myfile
fi

singularity instance stop $MY_SINGULARITY_DB_INSTANCE_NAME



## To stop all instances:
## singularity instance stop -a -F


