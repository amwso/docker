docker
======

## Install Docker

https://docs.docker.com/installation/

### CentOS 6 quick install

```
$ rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
$ yum install docker-io device-mapper-event-libs git
$ /etc/init.d/docker start
```

## Install image 

```
$ git clone https://github.com/amwso/docker.git
$ cd docker
$ sudo docker build --no-cache -t="myapp/lnmp" .
```

## Usage 

```bash
$ mkdir /data
$ sudo docker run -h localhost -p=80:80 --name myapp -v /data/myapp:/data -d -t -i myapp/lnmp /bin/bash /root/sbin/init.sh
```

