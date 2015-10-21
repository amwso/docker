Nginx + PHP + MySQL All-In-One Docker
======

## Install Docker

https://docs.docker.com/installation/

### CentOS 6 quick install

```bash
$ sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
$ sudo yum install docker-io device-mapper-event-libs git
$ sudo /etc/init.d/docker start
```

### CentOS 7 quick install

```bash
$ sudo yum install docker device-mapper-event-libs git
$ sudo systemctl start docker
```

### Ubuntu 14.04 quick install

```bash
# curl -sSL https://get.docker.com | sh
```

## get image 

### build manually

```bash
$ git clone https://github.com/amwso/docker.git
$ cd docker
$ sudo docker build --no-cache -t="amwso/docker" .
```

### pull directly

```bash
$ sudo docker pull amwso/docker
```

## Usage 

Run instance with random mysql root password, you can find the password in `/data/var/log/mysql-root-pw.txt`.

```bash
$ sudo docker run -h localhost -p=80:80 --name myapp -v /data/myapp:/data -d amwso/docker
```

### Environmen Variables

`MYSQL_PASSWORD=mySecret` -  set mysql root password manually

`DOCKER_DISABLE_PMA=yes` - disable PHPMyAdmin, PHPMyAdmin login path `http://localhost/pma`

`DOCKER_INSTALL_WEBSHELL=mySecret` - enable webshell (disabled by default), `mySecret` is your shell login password, webshell login path is `http://localhost/shell.php`

`DOCKER_INSTALL_WP=yes` - install Wordpress automatically

`DOCKER_WP_ADMIN` - set wordpress admin user name, if not set, defaults to `admin`

`DOCKER_WP_PASSWORD` - set wordpress password, if not set, defaults to `password`


### Service & Operating
enter an existing instance

```bash
$ sudo docker exec -ti myapp /bin/bash
```

reload a service

```bash
$ sudo docker exec myapp /bin/bash -c "supervisorctl kill HUP nginx"
```

reset mysql root password, write new password in log/mysql-root-pw.txt

```bash
$ sudo docker exec myapp /root/sbin/tools/reset_mysql_root_passwd.sh
```



## directory & path

```
/data/conf - all config files
/data/var/log - all log files
/data//mysql - mysql data
/data/tmp - temp and php session
/data/var - variables
/data/www - nginx web root
http://localhost/nginx_status - nginx status page
http://localhost/php_status - php status page
http://0.0.0.0/pma/ - PHPMyAdmin
http://0.0.0.0/shell.php - web shell (disabled by default)
```
