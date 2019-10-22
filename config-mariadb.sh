#!/bin/bash

## This script configures the environment, 
## singularity and mariadb
##
##
##
## Simo Goshev
## Oct 5, 2019
 

## Select images and directories depending on instance type
if [[ -z "$MDB_INSTANCE_TYPE" ]]; then
	### Pick the correct container to run
	export MDB_IMAGE=$MDB_IMAGE_FE
	### Set the DB home directory
	export MDB_ROOT_DIR=$MDB_ROOT_DIR/frontend
else 
	export MDB_IMAGE=$MDB_IMAGE_BE
	export MDB_ROOT_DIR=$MDB_ROOT_DIR/backend${MDB_INSTANCE_NUM}
	echo "$MY_SINGULARITY_DB_INSTANCE_NAME" > /tmp/$USER-containerName
fi

## Define the environment variables required by the MariaDB containers
MDB_ROOT_PASS=`head -n 2 $MDB_CREDENTIALS_FILE | tail -n 1`
MDB_USER_NAME=`head -n 3 $MDB_CREDENTIALS_FILE | tail -n 1`
MDB_USER_PASS=`head -n 4 $MDB_CREDENTIALS_FILE | tail -n 1`

## Export the environment variables to singularity
export SINGULARITYENV_MARIADB_ROOT_PASSWORD=$MDB_ROOT_PASS
export SINGULARITYENV_MARIADB_DATABASE=$MDB_DATABASE_NAME
export SINGULARITYENV_MARIADB_USER=$MDB_USER_NAME
export SINGULARITYENV_MARIADB_PASSWORD=$MDB_USER_PASS
export SINGULARITY_BIND="$MDB_ROOT_DIR/lib:/var/lib/mysql,$MDB_ROOT_DIR/run:/run/mysqld,$MDB_ROOT_DIR/log:/var/log/mysql,$MDB_ROOT_DIR/tmp:/tmp,$MDB_ROOT_DIR/tmp:/var/tmp,$MDB_ROOT_DIR/log:/var/log,$MDB_CONF_DIR:/etc/mysql/conf.d"

## This is only relevant for frontend
if [[ -z "$MDB_INSTANCE_TYPE" ]]; then

	## Write out the front end db hostname
	echo "$HOSTNAME:$MDB_PORT" > $MDB_CONF_DIR/dbNode

	## Write out the DB nodes 
	nodes=($(cat $PBS_NODEFILE | uniq)) 
	rm -rf $MDB_CONF_DIR/dbNodes
	for node in ${nodes[@]}; do
	  echo "$node" >> $MDB_CONF_DIR/dbNodes
	done

        if [[ ! -z "$MDB_NODE_DIR_SHARED" ]]; then
	  echo "$dbNodeName:$MDB_PORT" > $MDB_NODE_DIR_SHARED/dbNode
        fi

	## Write out the pid
	echo "$PBS_JOBID" > $MDB_CONF_DIR/jobid

	## Create properties file for db-spark integration (ROOT)
	if [[ ! -z "$MDB_SPARK_ROOT_CREDENTIALS_FILE" ]]; then
        	echo "root" > $MDB_SPARK_ROOT_CREDENTIALS_FILE
        	echo "$MDB_ROOT_PASS" >> $MDB_SPARK_ROOT_CREDENTIALS_FILE
		
        	chmod 600 $MDB_SPARK_ROOT_CREDENTIALS_FILE
	fi

	## Create properties file for db-spark integration (USER)
	if [[ ! -z "$MDB_SPARK_USER_CREDENTIALS_FILE" ]]; then
        	echo "$MDB_USER_NAME" > $MDB_SPARK_USER_CREDENTIALS_FILE
        	echo "$MDB_USER_PASS" >> $MDB_SPARK_USER_CREDENTIALS_FILE
		
        	chmod 640 $MDB_SPARK_USER_CREDENTIALS_FILE
	fi

	## Write out the database name
	echo "$MDB_DATABASE_NAME" > $MDB_CONF_DIR/dbName
fi

