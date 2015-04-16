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
$ [ -e /usr/lib/apt/methods/https ] || {
  sudo apt-get update
  sudo apt-get install apt-transport-https
}
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
$ sudo sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
$ sudo apt-get update
$ sudo apt-get install lxc-docker git
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

Run instance

```bash
$ mkdir /data
$ sudo docker run -h localhost -p=80:80 --name myapp -v /data/myapp:/data -d -t -i amwso/docker /bin/bash /root/sbin/init.sh
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
