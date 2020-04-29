# local-mysql-docker

setup mysql using docker.

Create users by logging into the container, and running

```mysql -u root -h 127.0.0.1 -p
create user 'aar1069'@'%' identifed by '<password>';
grant all privileges on *.* to 'aar1069'@'%' with grant option;
```

After installing and creating users, don't forget to run 
```
/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -u aar1069 -h 127.0.0.1 --database mysql -p
``` 
within the container in order to set the timezone.
