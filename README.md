# Scripts for running containerized distributed MariaDB on HPC infrastructure


## Introduction

This repo offers a set of barebones scripts that simplify running 
containerized instances of distributed MariaDB on HPC infrastructure 
with a PBS job scheduler. 


## How to use

Download/clone the repo to a directory and edit the `userInput.template.sh` and
`submit.template.pbs` files. Follow the instructions in each file carefully.
Save `userInput.template.sh` as `userInput.sh` and (if desired save `submit.template.pbs` as 
`submit.pbs`). Then submit the PBS script to the job scheduler on the cluster.

Please note that in the case of working with sensitive data, users **MUST** ensure 
that all writes to disk by the database instance are directed to a directory 
permissible under the DUA/DMP. If users are unsure what directories they can 
write to, they should contact the signee of the DUA/DMP.


## Script specification

The scripts in this repo and their descriptions follow below.

### `userInput.template.sh`

`userInput.template.sh` defines a set of environment variables needed for configuring
the distributed database. This files **MUST** be customized and saved by the users as 
`userInput.sh`. If working with sensitive data, users **MUST** ensure that all 
files written out by the database instance are stored in a permissible directory. 

### `submit.template.pbs`

This is the PBS submission script template. Users **MUST** customize it following
the instructions provided in it. Users **MUST** pay specific attention to the 
instructions for working with sensitive data, if this applies to them.

### All other files

All remaning files configure, start and stop the database instance. 

**Unless users know what they are doing, they should not edit them.**


## Mariadb credentials file

Users must provide a database credentials file, `$MDB_CREDENTIALS_FILE`, in 
`userInput.sh`. This file must include the root username(i.e. `root`) and password, 
and a db user username and password. All four pieces of information have to be
provided in this order, on seperate consecutive lines starting from the first line, 
and flush against the left margin.


## Configuration directory

`$MDB_CONF_DIR` is mapped to `/etc/mysql/conf.d` in every mariadb container. This 
enables users to configure the database servers by placing a `mariadb.cnf` 
in the configuration directory.


## Integration with Apache Spark

Users can integrate Apache Spark with a containerized distiributed MariaDB instance 
using:

1. The db instance root username and password located in 
`$MDB_SPARK_CREDENTIALS_FILE`. 

2. The name of the node and port on which the frontend database instance is 
running which are located in file `dbNode` in `$MDB_CONF_DIR`.


## Utility functions/modules

TODO: These scripts will enable users to create distributed tables
directly from `SparkR` and `pyspark`.


