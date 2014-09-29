FROM ubuntu:12.04
MAINTAINER HJay <trixism@qq.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl ; \
 ln -sf /bin/true /sbin/initctl ; \
 cp /root/.bashrc /root/.profile / ; \
 echo 'HISTFILE=/dev/null' >> /.bashrc ; \
 HISTSIZE=0 ; \
 sed -i "s/archive.ubuntu.com/mirrors.sudu.cn/g" /etc/apt/sources.list ; \
 sed -i "s/archive.ubuntu.com/mirrors.sudu.cn/g" /etc/apt/sources.list.d/proposed.list ; \
 apt-get update ; \
 apt-get -y upgrade

RUN apt-get -y install nginx-extras php5-cli php5-curl php5-fpm php5-json php5-mcrypt php5-mysql php5-sqlite php5-xmlrpc php5-xsl php-apc curl git unzip pwgen supervisor mysql-server mysql-client ; \
 apt-get clean

RUN mv /etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf.default
ADD ./supervisord.conf /etc/supervisor/supervisord.conf
