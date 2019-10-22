#!/bin/bash

## This script generates environment variables for 
## singularity and mariadb
##
##
##
## Simo Goshev
## Oct 22, 2019
 

#########################################################
## Load singularity module

module load singularity/3.1.0



########################################################
## Configuration variables


####### ==> Project directory
export PROJECT_ROOT_DIR=


####### ==> Database scripts directory
export MDB_SCRIPTS_DIR=


####### ==> Database configuration

## DB root directory
## !!! IF WORKING WITH SENSITIVE DATA, POINT TO A DESIGNATED DIRECTORY !!!
## !!! CONSULT WITH THE SIGNEE OF THE DUA/DMP !!!
export MDB_ROOT_DIR=

## DB configuration directory
export MDB_CONF_DIR=

## DB port (keep as is; available to root only)
export MDB_PORT=3306

## Time (in seconds) to wait for backend db instances to initialize 
export MDB_INIT_WAITTIME=120

## OPTIONAL: Directory to post db node information (for multiple db users)
export MDB_NODE_DIR_SHARED=

## Database name
export MDB_DATABASE_NAME=

## DB credentials file (MUST EXIST ALREADY)
export MDB_CREDENTIALS_FILE=

## DB backend credentials file (MUST EXIST IF CONFIGURING CONNECTIONS)
export MDB_BE_CREDENTIALS_FILE=


####### ==>  Singularity configuration

## Frontend singularity image location
export MDB_IMAGE_FE=

## Backend singularity image location
export MDB_IMAGE_BE=

## Singularity instance name 
export MY_SINGULARITY_DB_INSTANCE_NAME=


####### ==> Spark integration (OPTIONAL)

## Root credentials file for spark jdbc
export MDB_SPARK_ROOT_CREDENTIALS_FILE=

## User credentials file for spark jdbc (if db users)
export MDB_SPARK_USER_CREDENTIALS_FILE=
