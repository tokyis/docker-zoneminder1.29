FROM library/centos:7

MAINTAINER kyis


VOLUME ["/config"]
VOLUME ["/var/cache/zoneminder"]

EXPOSE 80

RUN yum -y install wget && \
mkdir /home/root && \
cd /home/root && \
wget http://zmrepo.zoneminder.com/el/7/x86_64/zmrepo-7-6.el7.centos.noarch.rpm && \
yum -y install --nogpgcheck zmrepo-7-6.el7.centos.noarch.rpm && \
yum -y install zoneminder && \
yum clean


CMD ["/sbin/my_init"]
