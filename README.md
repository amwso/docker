docker
======



## Installation

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

