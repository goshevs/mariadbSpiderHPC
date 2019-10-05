#!/bin/bash

## This script creates the directory structure 
## for a NEW instance of mariadb; use it only
## if you want to set up a completely new db
##
##
##
##
## Simo Goshev
## Aug 21, 2019


echo
echo "Creating directories for a *new* database server"
echo "Exit now if you want to keep your existing databases"
echo
read -p "Are you sure you want to delete the DB root $MDB_ROOT_DIR (y/n)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm -rf $MDB_ROOT_DIR
	echo "DB root and all subdirectories have been deleted."
	echo "Creating root $MDB_ROOT_DIR and all subdirectories..."
	mkdir -p $MDB_ROOT_DIR/log $MDB_ROOT_DIR/lib/ $MDB_ROOT_DIR/run $MDB_ROOT_DIR/tmp
	echo "Done"
fi
