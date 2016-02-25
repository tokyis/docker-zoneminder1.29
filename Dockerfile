FROM phusion/baseimage:0.9.18

MAINTAINER kyis

ENV SHMEM="50%" TZ="Europe/Paris"

VOLUME ["/config"]

EXPOSE 80

RUN export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get upgrade -y && \
add-apt-repository -y ppa:iconnor/zoneminder && \
apt-get update && \
apt-get install -y zoneminder php5-gd && \
apt-get install -y libvlc-dev libvlccore-dev vlc && \
service mysql start && \
mysql -uroot < /usr/share/zoneminder/db/zm_create.sql && \
mysql -uroot -e "grant all on zm.* to 'zmuser'@localhost identified by 'zmpass';" && \
mysqladmin -uroot reload && \
chmod 740 /etc/zm/zm.conf && \
chown root:www-data /etc/zm/zm.conf && \
sed -i '25i\        sleep 15' /etc/init.d/zoneminder && \
adduser www-data video && \
a2enmod cgi && \
a2enconf zoneminder && \
a2enmod rewrite && \
echo "date.timezone = $TZ" && \
echo "date.timezone = $TZ" >> /etc/php5/apache2/php.ini && \
service mysql restart && \
service apache2 restart && \
service zoneminder start && \
apt-get clean

ADD firstrun.sh /etc/my_init.d/firstrun.sh

RUN chmod +x /etc/my_init.d/firstrun.sh && \
#mkdir /etc/apache2/conf.d && \
cp /etc/apache2/conf-enabled/zoneminder.conf /etc/zm/apache.conf && \
rm /etc/apache2/conf-enabled/zoneminder.conf && \
ln -s /etc/zm/apache.conf /etc/apache2/conf-enabled/zoneminder.conf && \
rm /usr/share/zoneminder/www/tools/mootools/mootools-core.js && \
rm /usr/share/zoneminder/www/tools/mootools/mootools-more.js && \
ln -s /usr/share/javascript/mootools/mootools.js  /usr/share/zoneminder/www/tools/mootools/mootools-core.js && \
ln -s /usr/share/javascript/mootools/mootools-more.js  /usr/share/zoneminder/www/tools/mootools/mootools-more.js && \
#adduser www-data video && \
service apache2 restart && \
#cd /usr/src && \
#wget http://www.charliemouse.com:8080/code/cambozola/cambozola-0.936.tar.gz && \
#tar -xzvf cambozola-0.936.tar.gz && \
#cp cambozola-0.936/dist/cambozola.jar /usr/share/zoneminder && \
cp /etc/zm/apache.conf /root/apache.conf && \
cp /etc/zm/zm.conf /root/zm.conf && \
update-rc.d -f apache2 remove && \
update-rc.d -f mysql remove && \
update-rc.d -f zoneminder remove
