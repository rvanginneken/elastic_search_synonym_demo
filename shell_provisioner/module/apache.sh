#!/bin/bash

# Apache

apt-get install -y apache2

a2enmod rewrite expires headers proxy proxy_http proxy_fcgi actions alias ssl http2 brotli

# No support for old protocols
sed -i 's/SSLProtocol .*/SSLProtocol +TLSv1.2 +TLSv1.3/' /etc/apache2/mods-enabled/ssl.conf
sed -i 's/#SSLHonorCipherOrder .*/SSLHonorCipherOrder On/' /etc/apache2/mods-enabled/ssl.conf

# Activate vhost
a2dissite 000-default

chmod -R a+rX /var/log/apache2
sed -i 's/640/666/' /etc/logrotate.d/apache2

# Documentroot detection
if [[ -d /vagrant/web ]]; then
  DocumentRoot="/web"
elif [[ -d /vagrant/htdocs/web ]]; then
  DocumentRoot="/htdocs/web"
elif [[ -d /vagrant/htdocs/public ]]; then
  DocumentRoot="/htdocs/public"
elif [[ -d /vagrant/htdocs ]]; then
  DocumentRoot="/htdocs"
else
  DocumentRoot=""
fi

cat ${CONFIG_PATH}/apache/app.vhost.conf > /etc/apache2/sites-available/${APP_DOMAIN}.conf
sed -i "s#/vagrant/htdocs#/vagrant${DocumentRoot}#g" /etc/apache2/sites-available/${APP_DOMAIN}.conf

a2ensite ${APP_DOMAIN}.conf
systemctl restart apache2

