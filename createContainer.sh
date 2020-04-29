#! /bin/ksh

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

[[ -d $CONF_DIR && -f $CONF_DIR/my.cnf ]] || echo "warning: no configuration file!" 1>&2

# have to kill any mysqld processes running
mysqldPID=$(ps -ef | grep [m]ysqld | awk '{ print $2 }')
echo $mysqldPID
[ "$mysqldPID" = "" ] || kill $mysqldPID

# stop and remove existing container
containerName=mysql1
docker stop $containerName
docker rm $containerName

# run the beast
docker run -p 3306:3306 --name=$containerName \
        --mount type=bind,src=$CONF_DIR/my.cnf,dst=/etc/my.cnf \
        --mount type=bind,src=$DATA_DIR,dst=/var/lib/mysql \
        --mount type=bind,src=$KEYRING_DIR,dst=/usr/local/mysql/mysql-keyring \
	--mount type=bind,src=$LOG_DIR,dst=/var/log \
	-e MYSQL_ROOT_PASSWORD=my-root-pass \
	--user $(id -u):$(id -g) \
        -d mysql:5.7
