#! /bin/bash

###########################################################
### Configure connections to backend servers
##
##
##
##
## Simo Goshev
## Oct 22, 2019


## Waiting to load
sleep $MDB_INIT_WAITTIME

## Check backend credentials
if [[ ! -f "$MDB_BE_CREDENTIALS_FILE" ]]; then
	echo "Backend credentials file not provided"
	exit 1
fi

## Collect credentials information
myCred=($(cat "$MDB_CREDENTIALS_FILE"))
beCred=($(cat "$MDB_BE_CREDENTIALS_FILE"))

## Compose execute call to frontend
for b in $( seq 1 $last); do
        mySQLExec="$mySQLExec DROP SERVER IF EXISTS backend${b};"
        mySQLExec="$mySQLExec CREATE SERVER backend${b} FOREIGN DATA WRAPPER mysql"
        mySQLExec="$mySQLExec OPTIONS(HOST '${nodes[$b]}', DATABASE '$MDB_DATABASE_NAME',"
        mySQLExec="$mySQLExec USER '${beCred[0]}', PASSWORD '${beCred[1]}', PORT $MDB_PORT);"
done

## Execute the call to the frontend
mysql -u ${myCred[0]} -p${myCred[1]} -h ${nodes[0]} -D $MDB_DATABASE_NAME -e "$mySQLExec"

echo "Server connections set up successfully"

## Compose and execute calls to backend
for b in $( seq 1 $last); do
	mySQLExec="CREATE OR REPLACE USER ${beCred[0]};"
	mySQLExec="$mySQLExec SET PASSWORD FOR ${beCred[0]} = PASSWORD('${beCred[1]}');"
	mySQLExec="$mySQLExec GRANT ALL ON $MDB_DATABASE_NAME.* TO ${beCred[0]};"

	mysql -u ${myCred[0]} -p${myCred[1]} -h ${nodes[$b]} -e "$mySQLExec"
done

echo "Backend user accounts set up successfully"






