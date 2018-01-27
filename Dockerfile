FROM centos:latest

MAINTAINER "patricktsang" <patrick@patricktsang.net>

ENV container docker

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# normal updates, tools, nginx, cleanup
RUN yum -y update \
 && yum -y install epel-release iproute crontabs \
 && yum -y install php71w php71w-devel php71w-mcrypt php71w-opcache php71w-fpm \
 && yum -y install nginx \
 && yum -y install net-tools \
 && yum -y install sudo \
 && yum clean all

RUN curl --silent --location https://rpm.nodesource.com/setup_9.x | bash -
RUN yum -y install nodejs
RUN yum -y install gcc-c++ make
RUN npm install pm2 -g

RUN mkdir -p /srv/patricktsang/webroot/laravel.patricktsang.net/public

EXPOSE 80

COPY config/nginx.conf /etc/nginx/
COPY config/web.conf   /etc/nginx/conf.d
COPY config/index.html /srv/patricktsang/webroot/laravel.patricktsang.net/public

RUN systemctl enable nginx \
 && systemctl enable crond

# CMD ["/usr/sbin/init"]
CMD nginx -g 'daemon off;' && php-fpm --nodaemonize

