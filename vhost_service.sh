#!/bin/bash

#PUB_ADDR="0.0.0.0::80"
IMG_NAME="amwso/docker"
HOST_DIR="/data/user_data"
USER_DIR="/data"

MAINIF=$( route -n | grep '^0\.0\.0\.0' | head -n 1 | awk '{print $NF}' )
IP=$( ifconfig $MAINIF | { IFS=' :';read r;read r r a r;echo $a; } )
PUB_ADDR=${PUB_ADDR:-$IP::80}

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

validate_vhost_name () {
    if [[ ! "$1" =~ ^vh[0-9]+$ ]] ; then
        echo "invalidate vhost name."
        exit 1
    fi
}

do_create () {
    validate_vhost_name $1
    
    docker run -d --name $1 --hostname $1 -p ${PUB_ADDR} -v ${HOST_DIR}/$1:${USER_DIR} ${IMG_NAME}
    backend_addr=$(docker inspect -f '{{ json (index (index .NetworkSettings.Ports "80/tcp") 0) }}' $1)
    [ -n "$backend_addr" ] && etcdctl set /vhost/$1/backend/$(hostname -s) $backend_addr
    echo "create done."
}

do_stop () {
    validate_vhost_name $1
    docker stop $1
    etcdctl rm /vhost/$1/backend/$(hostname -s) >/dev/null
    echo "stop success."
}


do_start () {
    validate_vhost_name $1
    docker start $1
    backend_addr=$(docker inspect -f '{{ json (index (index .NetworkSettings.Ports "80/tcp") 0) }}' $1)
    [ -n "$backend_addr" ] && etcdctl set /vhost/$1/backend/$(hostname -s) $backend_addr
    echo "start success."
}

do_destroy () {
    validate_vhost_name $1
    docker rm -f $1
    etcdctl rm /vhost/$1/backend/$(hostname -s) >/dev/null
    echo "destroy done."
}

case "$1" in
    create)
        do_create $2
        ;;
    stop)
        do_stop $2
        ;;
    start)
        do_start $2
        ;;
    restart)
        do_stop $2
        do_start $2
        ;;
    destroy)
        do_destroy $2
        ;;
    *)
        echo "Usage: $0 {create|stop|start|restart|destroy} [vhostname]"
        exit 1
        ;;
esac
