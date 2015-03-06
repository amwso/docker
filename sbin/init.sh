#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LOG_FILE_PATH=/data/log
MYSQL_DATA_PATH=/data/mysql
WWW_DATA_PATH=/data/www
CONF_PATH=/data/conf
TEMP_PATH=/data/tmp

mysql_init () {
	MYSQL_PASSWORD=`pwgen -c -n -1 12`
	mkdir $MYSQL_DATA_PATH
	chown user_mysql:user_mysql $MYSQL_DATA_PATH
	mysql_install_db --defaults-file=/dev/null --datadir=$MYSQL_DATA_PATH --user=user_mysql
	mysqld --defaults-file=/dev/null --basedir=/usr --datadir=$MYSQL_DATA_PATH --log-error=/dev/null --user=user_mysql --pid-file=$MYSQL_DATA_PATH/mysqld.pid --socket=$MYSQL_DATA_PATH/mysqld.sock --skip-networking --plugin-dir=/usr/lib/mysql/plugin &
	sleep 3;
	mysqladmin -S $MYSQL_DATA_PATH/mysqld.sock -u root password $MYSQL_PASSWORD
	mysql -S $MYSQL_DATA_PATH/mysqld.sock -u root -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
	echo $MYSQL_PASSWORD > $LOG_FILE_PATH/mysql-root-pw.txt
	chmod 0400 $LOG_FILE_PATH/mysql-root-pw.txt
	killall mysqld
}

check_dir () {
	[[ ! -d $LOG_FILE_PATH/supervisor ]] && mkdir -p $LOG_FILE_PATH/supervisor
	[[ ! -d $LOG_FILE_PATH/nginx ]] && mkdir -p $LOG_FILE_PATH/nginx
	[[ ! -d $LOG_FILE_PATH/php-fpm ]] && mkdir -p $LOG_FILE_PATH/php-fpm
	[[ ! -d $LOG_FILE_PATH/mysql ]] && mkdir -p $LOG_FILE_PATH/mysql
	[[ ! -d $CONF_PATH ]] && cp -rf /root/template/conf $CONF_PATH
	[[ ! -f $CONF_PATH/supervisor_service.conf ]] && cp -f /root/template/conf/supervisor_service.conf $CONF_PATH/supervisor_service.conf
	[[ ! -d $MYSQL_DATA_PATH ]] && mysql_init
	[[ ! -d /var/run/mysqld ]] && mkdir /var/run/mysqld
	chown user_mysql /var/run/mysqld
	[[ ! -d $TEMP_PATH ]] && mkdir -p $TEMP_PATH && chmod 1777 $TEMP_PATH
	[[ ! -d $WWW_DATA_PATH ]] && mkdir $WWW_DATA_PATH && chown user_app:user_app $WWW_DATA_PATH
}

check_sys_user () {
	USER_ID=5000
	for USER in user_web user_app user_mysql ; do
		if  id -u $USER >/dev/null 2>&1  ; then
			# TODO: notice user exists
			true
		else
			groupadd -g $USER_ID -r $USER
			useradd -l -M -r  -s /usr/sbin/nologin -u $USER_ID -g $USER_ID $USER
		fi
		USER_ID=$(($USER_ID +1))
	done
}

check_sys_user
check_dir

# Forward SIGTERM to supervisord process
_term() {
	while kill -0 $child >/dev/null 2>&1
	do
		kill -TERM $child 2>/dev/null
	done
}
trap _term 15
exec /usr/bin/supervisord -n &
child=$!
wait $child
