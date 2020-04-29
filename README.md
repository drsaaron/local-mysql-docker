# local-mysql-docker

setup mysql using docker.

After installing and creating users, don't forget to run `/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -u aar1069 -h 127.0.0.1 --database mysql -p` in order to set the timezone.