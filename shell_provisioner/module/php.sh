#!/bin/bash

# PHP

# Add deb.sury.org repository
wget -qO - https://packages.sury.org/php/apt.gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -

cat << EOF >/etc/apt/sources.list.d/sury.list
deb https://packages.sury.org/php/ $(lsb_release -sc) main
EOF

# Sync package index files
apt-get update

apt-get install -y php8.1-cli php8.1-fpm php8.1-dev php8.1-curl php8.1-intl php8.1-zip \
    php8.1-mysql php8.1-sqlite3 php8.1-gd php8.1-mbstring php8.1-xml php8.1-apcu php8.1-xdebug

update-alternatives --set php /usr/bin/php8.0

# PHP config
sed -i 's/;date.timezone.*/date.timezone = Europe\/Brussels/' /etc/php/8.1/{fpm,cli}/php.ini

sed -i 's/upload_max_filesize = .*/upload_max_filesize = 20M/' /etc/php/8.1/fpm/php.ini
sed -i 's/post_max_size = .*/post_max_size = 24M/' /etc/php/8.1/fpm/php.ini
sed -i 's/expose_php = .*/expose_php = Off/' /etc/php/8.1/fpm/php.ini

sed -i 's/^user = www-data/user = vagrant/' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/^group = www-data/group = vagrant/' /etc/php/8.1/fpm/pool.d/www.conf

# Do not disable for CLI because composer depends on it
sed -i 's/allow_url_fopen = .*/allow_url_fopen = Off/' /etc/php/8.1/fpm/php.ini

# Recommendations by Blackfire
cat << EOF >>/etc/php/8.1/fpm/php.ini

realpath_cache_ttl = 3600
zend.detect_unicode = 0

EOF
cat << EOF >>/etc/php/8.1/cli/php.ini

realpath_cache_ttl = 3600
zend.detect_unicode = 0

EOF

sed -i 's/;assert.active.*/assert.active = Off/' /etc/php/8.1/{fpm,cli}/php.ini
sed -i 's/session.use_strict_mode = .*/session.use_strict_mode = 1/' /etc/php/8.1/fpm/php.ini

# Configure xdebug
cat << EOF >/etc/php/8.1/mods-available/xdebug.ini
zend_extension=xdebug

xdebug.mode=debug
xdebug.start_with_request=1
xdebug.client_host=192.168.33.1
xdebug.max_nesting_level=256
xdebug.log=/tmp/xdebug.log
; Don't use xdebug.profiler_*, use Blackfire instead
EOF
touch /tmp/xdebug.log
chown vagrant:vagrant /tmp/xdebug.log

# Phar in FPM is a security risk
rm /etc/php/8.1/fpm/conf.d/20-phar.ini

# Reload FPM
systemctl restart php8.1-fpm

# composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin
ln -s /usr/bin/composer.phar /usr/bin/composer

su - vagrant -c 'composer global require --dev phpmd/phpmd'
echo "export PATH=\"/home/vagrant/.composer/vendor/bin:/vagrant/htdocs/vendor/bin:$PATH\"" >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

