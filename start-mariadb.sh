#!/bin/bash

## This script initiates and starts a mariadb instance
##
##
##
##
## Simo Goshev
## Aug 21, 2019


## These arguments can only be used by root
## --net --network-args "portmap=$MDB_PORT:3306/tcp" \

singularity instance start $MDB_IMAGE $MY_SINGULARITY_DB_INSTANCE_NAME

singularity run instance://$MY_SINGULARITY_DB_INSTANCE_NAME &

