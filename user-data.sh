#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update -y

apt-get install -y \
  apache2 \
  mysql-server \
  php \
  php-mysql \
  php-curl \
  php-gd \
  php-mbstring \
  php-xml \
  php-xmlrpc \
  php-soap \
  php-intl \
  php-zip \
  unzip \
  curl

systemctl enable apache2
systemctl enable mysql

systemctl start apache2
systemctl start mysql

mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY '${wordpress_db_password}';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

cd /tmp

curl -O https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

rm -rf /var/www/html/*
cp -a wordpress/. /var/www/html/

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sed -i "s/username_here/wordpressuser/" /var/www/html/wp-config.php
sed -i "s/password_here/${wordpress_db_password}/" /var/www/html/wp-config.php

chown -R www-data:www-data /var/www/html

find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

systemctl restart apache2