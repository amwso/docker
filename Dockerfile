FROM ubuntu:14.04
MAINTAINER HJay <trixism@qq.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl ; \
 ln -sf /bin/true /sbin/initctl ; \
 cp /root/.bashrc /root/.profile / ; \
 echo 'HISTFILE=/dev/null' >> /.bashrc ; \
 HISTSIZE=0 ; \
 sed -i "s/archive.ubuntu.com/cn.archive.ubuntu.com/g" /etc/apt/sources.list ; \
 sed -i "s/archive.ubuntu.com/cn.archive.ubuntu.com/g" /etc/apt/sources.list.d/proposed.list ; \
 apt-get update ; \
 apt-get -y upgrade ; \
 cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ; \
 sed -i 's/UTC=yes/UTC=no/' /etc/default/rcS

RUN apt-get -y install nginx-extras \
 php5-cli php5-curl php5-fpm php5-json php5-mcrypt php5-mysql php5-sqlite php5-xmlrpc php5-xsl php5-gd php-apc \
 curl git unzip pwgen supervisor anacron \
 mysql-server mysql-client ; \
 apt-get clean

ADD sbin /root/sbin
ADD template /root/template
RUN mv /etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf.default ; \
 cp /root/template/conf/supervisord.conf /etc/supervisor/supervisord.conf

