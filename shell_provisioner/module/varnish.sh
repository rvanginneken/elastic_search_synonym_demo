#!/bin/bash

# Varnish

apt-get install -y varnish varnish-modules

# Reconfigure Apache

if [[ ! "$(grep 'Listen 8080' /etc/apache2/ports.conf)" ]]; then
    sed -i '/Listen 80/a Listen 8080' /etc/apache2/ports.conf
fi

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

cat ${CONFIG_PATH}/apache/app_varnish.vhost.conf > /etc/apache2/sites-available/${APP_DOMAIN}.conf
sed -i "s#/vagrant/htdocs#/vagrant${DocumentRoot}#g" /etc/apache2/sites-available/${APP_DOMAIN}.conf

systemctl restart apache2

