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

Run instance with random mysql root password

```bash
$ sudo docker run -h localhost -p=80:80 --name myapp -v /data/myapp:/data -d amwso/docker
```

Run instance with specified mysql root password

```bash
$ sudo docker run -h localhost -p=80:80 --name myapp -e MYSQL_PASSWORD=mySecret -d amwso/docker
```

PHPMyAdmin login path `http://localhost/pma`

pass `-e DOCKER_DISABLE_PMA=yes` to disable PHPMyAdmin

```bash
$ sudo docker run -h localhost -p=80:80 --name myapp -e DOCKER_DISABLE_PMA=yes -d amwso/docker
```

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

directory & path, for example /data/myapp

```
/data/myapp/conf - all config files
/data/myapp/log - all log files
/data/myapp/mysql - mysql data
/data/myapp/tmp - temp and php session
/data/myapp/var - variables
/data/myapp/www - nginx web root
http://localhost/nginx_status - nginx status page
http://localhost/php_status - php status page
```
