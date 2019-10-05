#!/bin/bash

## This script generates environment variables for 
## singularity and mariadb
##
##
##
## Simo Goshev
## Oct 05, 2019
 

#########################################################
## Load singularity module

module load singularity/3.1.0



########################################################
## Configuration variables


####### ==> Database scripts directory
export MDB_SCRIPTS_DIR=


####### ==> Database configuration

## DB root directory
## !!! IF WORKING WITH SENSITIVE DATA, POINT TO A DESIGNATED DIRECTORY !!!
## !!! CONSULT WITH THE SIGNEE OF THE DUA/DMP !!!
export MDB_ROOT_DIR=

## DB configuration directory
export MDB_CONF_DIR=

## DB port (option available to root only!)
export MDB_PORT=3306

## File to post db node information (for multiple db users)
export MDB_NODE_DIR_SHARED=

## Database name
export MDB_DATABASE_NAME=

## DB credentials file
export MDB_CREDENTIALS_FILE=


####### ==>  Singularity configuration

## Frontend singularity image location
export MDB_IMAGE_FE=

## Backend singularity image location
export MDB_IMAGE_BE=

## Singularity instance name 
export MY_SINGULARITY_DB_INSTANCE_NAME=


####### ==> Spark integration 

## Credentials file for spark jdbc
export MDB_SPARK_CREDENTIALS_FILE=
