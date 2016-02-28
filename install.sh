#!/bin/bash

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

service apache2 stop && \
service mysql stop && \

chmod 740 /etc/zm/zm.conf && \
chown root:www-data /etc/zm/zm.conf && \
sed -i "s|^start() {$|start() {\n        sleep 15|" /etc/init.d/zoneminder && \
adduser www-data video && \
a2enmod cgi && \
a2enconf zoneminder && \
a2enmod rewrite && \
echo "Setting php date.timezone = $TZ" && \
sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php5/apache2/php.ini && \
service mysql restart && \
service apache2 restart && \
service zoneminder restart && \
apt-get clean


chmod +x /etc/my_init.d/firstrun.sh && \

cp -p /etc/zm/zm.conf /root/zm.conf && \

update-rc.d -f apache2 remove && \
update-rc.d -f mysql remove && \
update-rc.d -f zoneminder remove

