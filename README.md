# local-mysql-docker

setup mysql using docker.

Create users by logging into the database, and running

```mysql -u root -h 127.0.0.1 -p
create user '<user>'@'%' identifed by '<password>';
grant all privileges on *.* to '<user>'@'%' with grant option;
```

After installing and creating users, don't forget to run 
```
/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -u <user> -h 127.0.0.1 --database mysql -p
``` 
within the container in order to set the timezone.
