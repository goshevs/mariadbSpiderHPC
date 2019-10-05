\#! /bin/bash

###########################################################
### Configure and run the distributed mariadb db instance
##
##
##
##
## Simo Goshev
## Oct 05, 2019

initFlag=$1

echo "Setting up environment and defaults"

## Load the user specifications 
source ./userInput.sh

## Get the nodes list
nodes=($(cat $PBS_NODEFILE | uniq))
nnodes=${#nodes[@]}
last=$(($nnodes -1))

echo "Starting backend db instances"
## Start the backend db instances
for b in $( seq 1 $last ); do
        
	## Write out the backend command
	bendCom="export MDB_INSTANCE_TYPE=backend"
	bendCom="$bendCom ; export MDB_INSTANCE_NUM=$b"
	bendCom="$bendCom ; source $MDB_SCRIPTS_DIR/userInput.sh"
	bendCom="$bendCom ; source $MDB_SCRIPTS_DIR/config-mariadb.sh"
	
	if [[ "$initFlag" = "init" ]]; then
		bendCom="$bendCom; yes 2>/dev/null | $MDB_SCRIPTS_DIR/init-mariadb.sh"
	fi
	bendCom="$bendCom ; source $MDB_SCRIPTS_DIR/start-mariadb.sh; sleep 120"
	
	## Execute the command on the respective node
	ssh ${nodes[$b]} "$bendCom" &
done


## Configure the frontend DB node
source $MDB_SCRIPTS_DIR/config-mariadb.sh 

## Initialize the db if needed
if [[ "$initFlag" = "init" ]]; then
	yes 2>/dev/null | $MDB_SCRIPTS_DIR/init-mariadb.sh
fi

## Start the frontend
source $MDB_SCRIPTS_DIR/start-mariadb.sh

echo "MariaDB cluster fired up. Frontend node is ${nodes[0]}"

## Retrieve the walltime of the job
jobNumber =$(echo $PBS_JOBID | grep -Eo '[0-9]+')
jobTimeRemaining=$(qstat -f $jobNumber | grep Walltime.Remaining | grep -Eo '[0-9]+')
runTime=$(expr $jobTimeRemaining - 300)

## Keep the job running for runTime seconds
sleep $runTime

echo "Shutting down the backend db instances"
for b in $( seq 1 $last ); do
        ## Execute the commands	on the respective node
        ssh ${nodes[$b]} "$MDB_SCRIPTS_DIR/stop-mariadb.sh" &
done

echo "Shutting down the frontend"
source $MDB_SCRIPTS_DIR/stop-mariadb.sh

echo "Distributed database torn down."
