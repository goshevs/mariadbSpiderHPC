# Scripts for running containerized distributed MariaDB on HPC infrastructure


## Introduction

This repo offers a set of barebones scripts that simplify running 
containerized instances of distributed MariaDB on HPC infrastructure 
with a PBS job scheduler. 


## How to use

Download/clone the repo to a directory and edit the
`userConfiguration.template.sh` and `submit.template.pbs` files. Follow
the instructions in each file carefully. Save
`userConfiguration.template.sh` as `userConfiguration.sh` and (if
desired save `submit.template.pbs` as `submit.pbs`). Then submit the
PBS script to the job scheduler on the cluster.

Please note that in the case of working with sensitive data, users **must** ensure 
that all writes to disk by the database instance are directed to a directory 
permissible under the DUA/DMP. If users are unsure what directories they can 
write to, they should contact the signee of the DUA/DMP.


## Script specification

The scripts in this repo and their descriptions follow below.

### `userConfiguration.template.sh`

`userConfiguration.template.sh` defines a set of environment variables needed for configuring
the distributed database. This files **must** be customized and saved by the users as 
`userConfiguration.sh`. If working with sensitive data, users **must** ensure that all 
files written out by the database instance are stored in a permissible directory. 

### `submit.template.pbs`

This is the PBS submission script template. Users **must** customize it following
the instructions provided in it. Users **must** pay specific attention to the 
instructions for working with sensitive data, if this applies to them.

### All other files

All remaning files configure, start and stop the database instance. 

**Unless users know what they are doing, they should not edit them.**


## MariaDB credentials files

Users must provide a frontend credentials file, `$MDB_CREDENTIALS_FILE`, in 
`userConfiguration.sh`. This file must include the root username (i.e. `root`) and password, 
and a db user username and password. All four pieces of information have to be
provided in this order, on seperate consecutive lines starting from the first line, 
and flush against the left margin.


## Configuration directory

`$MDB_CONF_DIR` is mapped to `/etc/mysql/conf.d` in every mariadb container. This 
enables users to configure the database servers by placing a `mariadb.cnf` 
file in the configuration directory.


## Integration with Apache Spark

Users have the option to integrate Apache Spark with a containerized
distiributed MariaDB instance using:

1. The frontned db instance username and password written out to 
`$MDB_SPARK_ROOT_CREDENTIALS_FILE` and/or `$MDB_SPARK_USER_CREDENTIALS_FILE`.

2. The name of the node and port on which the frontend database instance is 
running, written out to file `dbNode` in `$MDB_CONF_DIR`.

3. The names of all db nodes, written out to file `dbNodes` in `$MDB_CONF_DIR`. 

4. The name of the database `$MDB_DATABASE_NAME`, wirtten out to file `dbName` in 
 `$MDB_CONF_DIR`.
 
In addition, users must create a backend credentials file (if it does not exist 
already) in `$MDB_CONF_DIR` which must contain a username and password for
accessing the backend db instances. The two pieces of information have
to be provided in this order, on seperate consecutive lines starting
from the first line, and flush against the left margin.

## Python and R utilities

Repo [sparkDBUtilities](https://github.com/goshevs/sparkDBUtilities)
contains Python and R utilities for pushing Spark RDD's to MariaDB
distributed tables. The need for such utilities arises from the fact that
table schemas do not propagate automatically from the frontend db instance 
to the backend db instances. 


