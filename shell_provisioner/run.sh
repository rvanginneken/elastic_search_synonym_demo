#!/bin/bash

# Shell provisioner

export DEBIAN_FRONTEND=noninteractive

# Set environment variables
source /vagrant/shell_provisioner/set_vars.sh

# Adding an entry here executes the corresponding .sh file in MODULE_PATH
DEPENDENCIES=(
    debian
    tools
    vim
#    mysql
    php
    cert
    apache
#    phpmyadmin
#    yarn
#    mailhog
#    blackfire
    elasticsearch
    # rabbitmq
    # varnish
    # docker
    # app_drupal
     app_symfony
    # app_laravel
    # app_wordpress
    # app_shopware
    # nuxt_ssr
)

for MODULE in ${DEPENDENCIES[@]}; do
    source ${MODULE_PATH}/${MODULE}.sh
done

echo "cd /vagrant/htdocs" >> /home/vagrant/.profile
