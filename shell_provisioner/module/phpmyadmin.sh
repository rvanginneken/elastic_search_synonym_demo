#!/bin/bash

# PhpMyAdmin

# Download and extract
PMA_VERSION=5.1.1
cd /var/www
wget -q https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz
tar xzf phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz
mv phpMyAdmin-${PMA_VERSION}-all-languages phpmyadmin
rm phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz
chown -R vagrant:vagrant phpmyadmin
chmod -R ug+rwX phpmyadmin

# Configure
cd phpmyadmin

cp config.sample.inc.php config.inc.php
sed -e '/controluser/ s/^\/\/ *//' -i config.inc.php
sed -e '/controlpass/ s/^\/\/ *//' -i config.inc.php
sed -i "s/'pmapass'/'vagrant'/" config.inc.php
randomBlowfishSecret=$(openssl rand -base64 32)
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" -i config.inc.php

mysql -uroot -pvagrant -e "CREATE DATABASE phpmyadmin DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -uroot -pvagrant -e "CREATE USER pma@localhost IDENTIFIED WITH mysql_native_password BY 'vagrant';"
mysql -uroot -pvagrant -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO pma@localhost;"
mysql -uroot -pvagrant < sql/create_tables.sql

# Add Apache vhost
cat ${CONFIG_PATH}/apache/phpmyadmin.vhost.conf \
    > /etc/apache2/sites-available/phpmyadmin.${APP_DOMAIN}.conf
a2ensite phpmyadmin.${APP_DOMAIN}
systemctl restart apache2

