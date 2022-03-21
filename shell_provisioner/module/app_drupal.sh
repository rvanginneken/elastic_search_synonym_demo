#!/bin/bash

# Install
cd /vagrant/htdocs
composer install

# Drupal application
cp web/development.htaccess  web/.htaccess
cp web/sites/default/_snippets/services.development.yml web/sites/default/services.local.yml
cp web/sites/default/_snippets/settings.development.php web/sites/default/settings.local.php
cp web/sites/default/_snippets/settings.private.php web/sites/default/settings.private.php

# Configure database
sed -i 's/YOUR_DATABASE/'${APP_DBNAME}'/' web/sites/default/settings.private.php
sed -i 's/YOUR_USERNAME/'${APP_DBUSER}'/' web/sites/default/settings.private.php
sed -i 's/YOUR_PASSWORD/'${APP_DBPASSWORD}'/' web/sites/default/settings.private.php

# Build frontend
yarn install
yarn build

# Initialize Grumphp
cp ${CONFIG_PATH}/grumphp/drupal.yml /vagrant/grumphp.yml
sed -i 's/JIRACODE/'${JIRACODE}'/' /vagrant/grumphp.yml
echo "export PATH=\$PATH:/vagrant/htdocs/vendor/bin" >> /home/vagrant/.profile
su - vagrant -c 'cd /vagrant && /vagrant/htdocs/vendor/bin/grumphp git:init'
