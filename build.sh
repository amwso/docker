#!/bin/bash

TOP_DIR=$(cd $(dirname "$0") && pwd)
LB_NGINX_CONF_DIR=/etc/lb_nginx

docker build -t='amwso/docker' $TOP_DIR

if [ ! -d /etc/confd ] ; then 
  mkdir -p /etc/confd
  \cp -r $TOP_DIR/confd/* /etc/confd
fi

status confd | grep -q running || start confd

if [ ! -d $LB_NGINX_CONF_DIR ] ; then 
  mkdir $LB_NGINX_CONF_DIR
  \cp $TOP_DIR/lb_nginx/nginx.conf $LB_NGINX_CONF_DIR/nginx.conf
fi

touch $LB_NGINX_CONF_DIR/nginx_site.conf

[[ -z $(docker ps --filter name=lb_nginx -q) ]] && docker run -d \
 --name lb_nginx \
 --hostname lb_nginx \
 -p 80:80 \
 -v /tmp/lb_nginx:/var/cache/nginx -v $LB_NGINX_CONF_DIR:/etc/nginx \
 nginx:latest
