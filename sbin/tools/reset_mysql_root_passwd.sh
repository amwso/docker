#!/bin/bash

PASSWD_FILE_PATH=/data/log/mysql-root-pw.txt
MYSQL_DATA_PATH=/data/mysql

MYSQL_PASSWORD=`pwgen -c -n -1 12`


sed -i '/\[mysqld\]/ a skip-grant-tables' /data/myapp/conf/my.cnf
supervisorctl restart mysqld
mysql -S $MYSQL_DATA_PATH/mysqld.sock -u root -e "UPDATE mysql.user SET Password = PASSWORD('$MYSQL_PASSWORD') WHERE User = 'root'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES; "

echo $MYSQL_PASSWORD > $PASSWD_FILE_PATH
chmod 0400 $PASSWD_FILE_PATH
