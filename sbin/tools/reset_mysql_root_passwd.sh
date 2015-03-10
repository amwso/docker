#!/bin/bash

PASSWD_FILE_PATH=/data/log/mysql-root-pw.txt
MYSQL_CONF_PATH=/data/conf/my.cnf

MYSQL_PASSWORD=`pwgen -c -n -1 12`

sed -i '/\[mysqld\]/ a skip-grant-tables' $MYSQL_CONF_PATH
supervisorctl restart mysqld
mysql -u root -e "UPDATE mysql.user SET Password = PASSWORD('$MYSQL_PASSWORD') WHERE User = 'root'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES; "

echo $MYSQL_PASSWORD > $PASSWD_FILE_PATH
chmod 0400 $PASSWD_FILE_PATH

sed -i '/^skip-grant-tables$/d' $MYSQL_CONF_PATH
supervisorctl restart mysqld
