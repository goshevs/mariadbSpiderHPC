#!/bin/bash

## This script stops the mariadb instance
##
##
##
##
## Simo Goshev
## Aug 21, 2019


singularity instance stop $MY_SINGULARITY_DB_INSTANCE_NAME

## To stop all instances:
## singularity instance stop -a -F

