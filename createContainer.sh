#! /bin/sh

while getopts :d: OPTION
do
    case $OPTION in
	d)
	    runDate=$OPTARG
	    ;;
	*)
	    echo "invalid option $OPTION" 1>&2
	    exit 1
    esac
done

LOCAL_DIR=$(dirname $0)
[ "$LOCAL_DIR" = "." ] && LOCAL_DIR=`pwd`

CONF_DIR=$LOCAL_DIR/conf
DATA_DIR=$LOCAL_DIR/data
KEYRING_DIR=$LOCAL_DIR/keyring
LOG_DIR=$LOCAL_DIR/log

# ensure the folders exist
for dir in $DATA_DIR $KEYRING_DIR $LOG_DIR
do
    [ -d $dir ] || mkdir $dir
done

[ -d $CONF_DIR -a -f $CONF_DIR/my.cnf ] || echo "warning: no configuration file!" 1>&2

# root password. 
rootPassword=$(pass Database/MySQL/local/root)

# have to kill any mysqld processes running
stopContainer.sh

# stop and remove existing container
containerName=mysql1
docker stop $containerName
docker rm $containerName

# tag image with today's date
if [ "$runDate" = "" ]
then
    today=$(date '+%Y%m%d')
    docker tag mysql:latest mysql:$today
else
    if [ "$(docker images mysql | grep $runDate)" = "" ]
    then
	echo "image mysql:$runDate not found" 1>&2
	exit 1
    fi
    today=$runDate
fi

# run the beast
docker run -p 3306:3306 --name=$containerName \
        --mount type=bind,src=$CONF_DIR/my.cnf,dst=/etc/my.cnf \
        --mount type=bind,src=$DATA_DIR,dst=/var/lib/mysql \
        --mount type=bind,src=$KEYRING_DIR,dst=/usr/local/mysql/mysql-keyring \
	--mount type=bind,src=$LOG_DIR,dst=/var/log \
	-e MYSQL_ROOT_PASSWORD=$rootPasssword \
	--health-cmd="mysqladmin --user=root --password=$rootPassword ping 2>/dev/null || exit 1" \
	--user $(id -u):$(id -g) \
        -d mysql:$today
