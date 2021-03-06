#! /bin/bash

###########################################################
### Configure and run the distributed mariadb db instance
##
##
##
##
## Simo Goshev
## Oct 22, 2019


## Collect arguments
while getopts ":dc" opt; do
	case ${opt} in
		d ) initFlag=1
		;;
		c ) conFlag=1
		;;
		\? ) echo
		     echo "Runs a distributed containerized instance of MariaDB on HPC infrastructure"
		     echo "USAGE: $(basename $0) [-d] [-c]"
		     echo "    -d  initializes a brand new db (i.e. recreates an empty $MDB_ROOT_DIR)"
		     echo "    -c  configures backend connections and backend user credentials"
		     echo
		     exit 1
		;;
		: ) echo "Invalid option $OPTARG"
		    exit 1	
		;;
	esac
done
shift $((OPTIND - 1))


echo "Setting up environment and defaults"

## Get the nodes list
nodes=($(cat $PBS_NODEFILE | uniq))
nnodes=${#nodes[@]}
last=$(($nnodes -1))

## Load the user configuration 
source ./userConfiguration.sh

## Check credentials
if [[ ! -f "$MDB_CREDENTIALS_FILE" ]]; then
	echo "ERROR: Credentials file not provided."
	exit 1
fi

echo "Starting backend db instances"
## Start the backend db instances
for b in $( seq 1 $last ); do
        
	## Write out the backend command
	bendCom="export MDB_INSTANCE_TYPE=backend"
	bendCom="$bendCom ; export MDB_INSTANCE_NUM=$b"
	bendCom="$bendCom ; source $MDB_SCRIPTS_DIR/userConfiguration.sh"
	bendCom="$bendCom ; source \$MDB_SCRIPTS_DIR/config-mariadb.sh"
	
	if [[ ! -z  "$initFlag" ]]; then
		bendCom="$bendCom; yes 2>/dev/null | $MDB_SCRIPTS_DIR/init-mariadb.sh"
	fi

	bendCom="$bendCom ; \$MDB_SCRIPTS_DIR/start-mariadb.sh ; sleep $MDB_INIT_WAITTIME"
	
	## Execute the command on the respective node
	ssh ${nodes[$b]} "$bendCom" &
done


## Configure the frontend DB node
source $MDB_SCRIPTS_DIR/config-mariadb.sh 

## Initialize the db if needed
if [[ ! -z "$initFlag" ]]; then
	yes 2>/dev/null | $MDB_SCRIPTS_DIR/init-mariadb.sh
fi

## Start the frontend
source $MDB_SCRIPTS_DIR/start-mariadb.sh &

echo "MariaDB cluster fired up. Frontend node is ${nodes[0]}"


## Configure backend connections
if [[ ! -z "$conFlag" ]]; then
	source $MDB_SCRIPTS_DIR/config-connection.sh
fi


## Retrieve the walltime of the job
jobNumber=$(echo $PBS_JOBID | grep -Eo '[0-9]+')
jobTimeRemaining=$(qstat -f $jobNumber | grep Walltime.Remaining | grep -Eo '[0-9]+')
runTime=$(expr $jobTimeRemaining - 300)

## Keep the job running for runTime seconds
sleep $runTime

echo "Shutting down backend db instances"
for b in $( seq 1 $last ); do
        ## Execute the commands	on the respective node
        ssh ${nodes[$b]} "source $MDB_SCRIPTS_DIR/userConfiguration.sh; $MDB_SCRIPTS_DIR/stop-mariadb.sh" &
done

echo "Shutting down frontend"
source $MDB_SCRIPTS_DIR/stop-mariadb.sh

echo "Distributed database torn down."
