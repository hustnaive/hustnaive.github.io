#!/bin/bash

memcached -d -m 2048 -p 11211
sudo nginx -s stop
sudo nginx
sudo killall php-fpm
sudo php-fpm -y /usr/local/etc/php/5.6/php-fpm.conf -c /usr/local/etc/php/5.6/php.ini -D

mysql.server stop
sudo rm -rf /usr/local/var/mysql/192.168.*.err
mysql.server start