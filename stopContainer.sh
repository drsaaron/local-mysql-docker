#! /bin/sh

# we can't do a simple docker stop because it seems if we're running under
# a not-root user docker stop can't kill those processes.  So explicitly kill
# the mysqld process

#mysqldPID=$(ps -ef | grep [m]ysqld | awk '{ print $2 }')
#echo $mysqldPID
#[ "$mysqldPID" = "" ] || kill $mysqldPID

# apparently now we can just doa simple stop.
docker stop mysql1
