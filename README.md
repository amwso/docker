docker
======



## Installation

```
$ git clone https://github.com/amwso/docker.git
$ cd docker
$ sudo docker build --no-cache -t="myapp/ubuntu1204" .
```

## Usage


```bash
$ mkdir /data
$ sudo docker run -h localhost -p=80:80 --name myapp -v /data/myapp:/data -d -t -i myapp/ubuntu1204 /bin/bash /root/sbin/init.sh
```

